FROM ubuntu:bionic
MAINTAINER Thomas Perl <m@thp.io>

WORKDIR /build

COPY ld-script.patch /build/

ENV PATH $PATH:/usr/local/mipsel-unknown-elf/bin

RUN apt-get update && apt-get install -y make git-core cmake libtinyxml2-dev libmpfr-dev wget xz-utils build-essential pkg-config

# Install pre-built toolchain
RUN wget http://lameguy64.net/download/psn00bsdk/toolchain/gcc-7.4.0-mipsel-unknown-elf_linux-amd64.tar.xz
RUN tar xvf gcc-7.4.0-mipsel-unknown-elf_linux-amd64.tar.xz -C /
RUN rm -f gcc-7.4.0-mipsel-unknown-elf_linux-amd64.tar.xz
RUN cd /usr/local/mipsel-unknown-elf/mipsel-unknown-elf/lib/ldscripts/ && \
        patch --verbose -p0 < /build/ld-script.patch

# Fix updated library in newer Ubuntu version
RUN ln -s /usr/lib/x86_64-linux-gnu/libmpfr.so.6 /usr/lib/x86_64-linux-gnu/libmpfr.so.4

# Place things here
RUN mkdir -p /usr/src

# Install tools
RUN git clone https://github.com/Lameguy64/PSn00bSDK && \
    cd PSn00bSDK && \
    make -C tools && \
    make -C tools install && \
    cp -rpv tools/bin/* /usr/local/bin && \
    make -C libpsn00b && \
    cp -rpv . /opt/psn00bsdk && \
    cd .. && \
    mv PSn00bSDK /usr/src

# Install mkpsxiso
RUN git clone https://github.com/Lameguy64/mkpsxiso && \
    cd mkpsxiso && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    cp -rpv bin_nix/mkpsxiso /usr/local/bin/ && \
    cd ../.. && \
    mv mkpsxiso /usr/src

# Licenses
RUN mkdir /opt/licenses/
COPY licenses/licensea.dat /opt/licenses/
COPY licenses/licensee.dat /opt/licenses/
COPY licenses/licensej.dat /opt/licenses/

