# Build odr-dabmod
FROM ubuntu:22.04 AS builder
ENV  DEBIAN_FRONTEND=noninteractive
## Update system
RUN  apt-get update \
     && apt-get upgrade --yes
## Install build packages
RUN  apt-get install --yes \
          autoconf \
          curl \
          make \
          pkg-config
## Install development libraries
RUN  apt-get install --yes \
          libbladerf-dev \
          libfftw3-dev \
          liblimesuite-dev \
          libsoapysdr-dev \
          libuhd-dev \
          libzmq3-dev  
ARG  URL=ODR-DabMod/archive/refs/tags/v2.6.0.tar.gz
RUN  cd /root \
     && curl -L https://github.com/Opendigitalradio/${URL} | tar -xz \
     && cd ODR* \
     && ./bootstrap.sh \
     && ./configure --enable-limesdr --enable-bladerf --enable-fast-math --disable-native \
     && make \
     && make install 

# Build the final image
FROM ubuntu:22.04
ENV  DEBIAN_FRONTEND=noninteractive
## Update system
RUN  apt-get update \
     && apt-get upgrade --yes
## Copy objects built in the builder phase
COPY --from=builder /usr/local/bin/* /usr/bin/
COPY start /usr/local/bin/
## Install production libraries
RUN  chmod 0755 /usr/local/bin/start \
     && apt-get install --yes \
          libbladerf2 \
          libcurl4 \
          libfftw3-3 \
          liblimesuite20.10-1 \
          libsoapysdr0.7 \
          libuhd3.15.0 \
          libzmq5 \
     && rm -rf /var/lib/apt/lists/*

EXPOSE 9400
ENTRYPOINT ["start"]
LABEL org.opencontainers.image.vendor="Open Digital Radio" 
LABEL org.opencontainers.image.description="DAB/DAB+ Modulator" 
LABEL org.opencontainers.image.authors="robin.alexander@netplus.ch" 