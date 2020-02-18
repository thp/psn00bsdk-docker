docker build -t psn00bsdk-docker .
docker run -it psn00bsdk-docker bash
docker save psn00bsdk-docker | bzip2 > psn00bsdk-docker.tar.bz2
docker load < bzip2 -dc psn00bsdk-docker.tar.bz2
