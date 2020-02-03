FROM ubuntu:bionic
MAINTAINER Thomas Perl <m@thp.io>

WORKDIR /build

ENV PATH $PATH:/usr/local/mipsel-unknown-elf/bin

RUN apt-get update && apt-get install -y make git-core cmake libtinyxml2-dev libmpfr-dev wget xz-utils build-essential

# Install pre-built toolchain
RUN wget http://lameguy64.net/download/psn00bsdk/toolchain/gcc-7.4.0-mipsel-unknown-elf_linux-amd64.tar.xz
RUN tar xvf gcc-7.4.0-mipsel-unknown-elf_linux-amd64.tar.xz -C /
RUN rm -f gcc-7.4.0-mipsel-unknown-elf_linux-amd64.tar.xz

# Fix updated library in newer Ubuntu version
RUN ln -s /usr/lib/x86_64-linux-gnu/libmpfr.so.6 /usr/lib/x86_64-linux-gnu/libmpfr.so.4

# Install tools
RUN git clone https://github.com/Lameguy64/PSn00bSDK && \
    cd PSn00bSDK && \
    make -C tools && \
    make -C tools install && \
    cp -rpv tools/bin/* /usr/local/bin && \
    make -C libpsn00b && \
    cp -rpv . /opt/psn00bsdk && \
    cd .. && \
    rm -rf PSn00bSDK
