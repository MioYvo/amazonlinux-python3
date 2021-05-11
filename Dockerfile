FROM amazonlinux:latest

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8
ENV PYTHON_VERSION 3.9.5

RUN yum update -y && \
    yum install -y yum-utils tzdata tar gcc \
    libffi libffi-devel expat-devel zlib-devel \
    gdbm-devel \
    xz xz-devel \
    bzip2-devel \
    tk-devel \
    libuuid-devel\
    libtirpc libtirpc-devel \
    readline-devel \
    sqlite-devel \
    openssl-devel \
    make \
    wget \
    findutils && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
#    wget -O python.tar.xz "https://npm.taobao.org/mirrors/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" && \
    wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" && \
    mkdir -p /usr/src/python && \
    tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz && \
    rm python.tar.xz && \
    \
    cd /usr/src/python && \
    ./configure \
#		--build="$gnuArch" \
		--build="x86_64-linux-gnu" \
		--enable-loadable-sqlite-extensions \
		--enable-optimizations \
		--enable-option-checking=fatal \
		--enable-shared \
		--with-system-expat \
		--with-system-ffi \
#		--without-ensurepip \
	&& make -j "$(nproc)" \
		LDFLAGS="-Wl,--strip-all,-rpath /usr/local/lib" \
	&& make install \
	&& rm -rf /usr/src/python \
	&& find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
			-o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' -o -name '*.a' \) \) \
		\) -exec rm -rf '{}' + \
	\
	&& ldconfig \
	&& python3 --version \
	\
    && cd /usr/local/bin \
	&& ln -s idle3 idle \
	&& ln -s pydoc3 pydoc \
	&& ln -s python3 python \
	&& ln -s python3-config python-config && \
	\
    pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 --no-cache-dir install -U && \
    pip3 install --no-cache-dir wheel && \
    yum remove -y gcc perl make && \
    package-cleanup -q --leaves --all | xargs -l1 yum -y remove && \
    yum -y autoremove && \
    yum clean all && \
    rm -rf /var/cache/yum
