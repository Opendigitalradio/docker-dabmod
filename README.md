# opendigitalradio/docker-dabmod

## Introduction
This repository is part of a project aiming at containerizing the [mmbTools](https://www.opendigitalradio.org/mmbtools) software stack of [Open Digital Radio](https://www.opendigitalradio.org/).

This repository features the [dab modulator](https://github.com/opendigitalradio/ODR-DabMod) component. 

## Setup
In order to allow for data persistence and data sharing among the various mmbTools containers, please follow these instructions:
1. Create a temporary `odr-data` directory structure on your host:
    ```
    mkdir --parents \
        ${HOME}/odr-data/mot \
        ${HOME}/odr-data/supervisor
    ```
1. Declare your time zone:
    ```
    TZ=your_time_zone (ex: Europe/Zurich)
    ```
1. Declare your mux configuration file:
    ```
    # case-1: you have a config file
    DABMOD_CONFIG=full_path_to_your_dabmux_configuration_file

    # case-2: you dont't have a config file. Take the sample from this repository
    DABMOD_CONFIG=./odr-data/odr-dabmod.ini
    ```
1. If you are taking the sample modulator configuration file, then you should modify it to suit your needs (ex: hardware and output power) and local environments (ex: DAB channel)
1. Copy the mux configuration file into the temporary `odr-data` directory:
    ```
    cp ${DABMOD_CONFIG} ${HOME}/odr-data/
    ```
1. Create a docker network:
    ```
    docker network create odr
    ```

## Run
1. Plug the USB SoapySDR-compatible transceiver before you create the container
1. Create the container that will be started later. Please note that the image uses ports:
    - 9400: modulator ZMQ RC port

    ```
    docker container create \
        --name odr-dabmod \
        --env "TZ=${TZ}" \
        --volume odr-data:/odr-data \
        --network odr \
        --publish 9400:9400 \
        --device=/dev/bus/usb/001/004 \
        opendigitalradio/dabmod:latest \
        /odr-data/$(basename ${DABMOD_CONFIG})
    ```
1. Copy the temporary `odr-data` directory to the container:
    ```
    docker container cp ${HOME}/odr-data/$(basename ${DABMOD_CONFIG}) odr-dabmod:/odr-data/
    ```
1. Start the container 
    ```
    docker container start odr-dabmod
    ```
