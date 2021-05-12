FROM amazonlinux:latest

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8
#ENV PYTHON_VERSION 3.7.10

RUN yum update -y && \
    yum install -y python3.7 tzdata python3-devel gcc yum-utils && \
	python3 --version && \
	# Upgrade pip and install poetry :>
    pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 --no-cache-dir install -U && \
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python - && \
    export PATH="/root/.local/bin:$PATH" && \
    pip3 install --no-cache-dir wheel && \
    pip3 cache purge && rm -rf ~/.cache/pypoetry/cache/* && \
    yum remove -y gcc perl make && \
    package-cleanup -q --leaves --all | xargs -l1 yum -y remove && \
    yum -y autoremove && \
    yum clean all && \
    rm -rf /var/cache/yum
