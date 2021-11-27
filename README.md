# amazonlinux-python3 
Python3 docker image based on amazonlinux2.Python3.7 use al2's yum repo, 3.8 and 3.9 build from source code.

### Why amazonlinux not alpine?
1. Build fast, alpine often build package from source due to musl lib.
2. Security
   1. AWS provides ongoing security and maintenance updates to all instances running Amazon Linux.
   2. Alpine is secure as well known.

### Additional features
1. `poetry` installed
