# Build odr-dabmod
FROM debian:bullseye-slim AS builder
ENV  DEBIAN_FRONTEND=noninteractive
RUN  apt-get update && \
     apt-get upgrade --yes && \
     apt-get install --yes \
          apt-utils
RUN  apt-get install --yes \
          automake \
          build-essential \
          curl \
          git \
          libtool \
          pkg-config
RUN  apt-get install --yes \
          libbladerf-dev \
          libcurl4-openssl-dev \
          libfftw3-dev \
          liblimesuite-dev \
          libsoapysdr-dev \
          libuhd-dev \
          libzmq3-dev  
ARG  URL=ODR-DabMod/archive/refs/tags/v2.6.0.tar.gz
RUN  cd /root && \
     curl -L https://github.com/Opendigitalradio/${URL} | tar -xz && \
     cd ODR* && \
     ./bootstrap.sh && \
     ./configure --enable-limesdr --enable-bladerf --enable-fast-math --disable-native && \
     make && make install 

# Build the final image
FROM debian:bullseye-slim
ARG  DEBIAN_FRONTEND=noninteractive
## Update system
RUN  apt-get update && \
     apt-get upgrade --yes && \
     apt-get install --yes \
          apt-utils
## Install specific packages
RUN  apt-get install --yes \
          libbladerf2 \
          libcurl4 \
          libfftw3-3 \
          liblimesuite20.10-1 \
          libsoapysdr0.7 \
          libuhd3.15.0 \
          libzmq5 && \
     rm -rf /var/lib/apt/lists/*
## Document image
LABEL org.opencontainers.image.vendor="Open Digital Radio" 
LABEL org.opencontainers.image.description="DAB/DAB+ Modulator" 
LABEL org.opencontainers.image.authors="robin.alexander@netplus.ch" 
## Copy objects built in the builder phase
COPY --from=builder /usr/local/bin/* /usr/bin/
COPY start /usr/local/bin/
## Customization
RUN  chmod 0755 /usr/local/bin/start
EXPOSE 9400
ENTRYPOINT ["start"]
