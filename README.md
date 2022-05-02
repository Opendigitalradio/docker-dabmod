# opendigitalradio/docker-dabmod

## Introduction
This repository is part of a project aiming at containerizing the [mmbTools](https://www.opendigitalradio.org/mmbtools) software stack of [Open Digital Radio](https://www.opendigitalradio.org/).

This repository features the [dab modulator](https://github.com/opendigitalradio/ODR-DabMod) component. 

## Quick setup
1. Get this repository on your host
1. Declare your time zone:
    ```
    TZ=your_time_zone (ex: Europe/Zurich)
    ```
1. Declare your modulator configuration file
    ```
    # Example: this repository configuration file
    MOD_CONFIG=your_configuration_file (ex: $(pwd)/odr-data/odr-dabmod.ini)
    ```
1. If DAB channel 5A is unavailable in your location, then adapt the configuration file
    ```
    sed -e "s/channel=5A/channel=new_channel/" -i ${MOF_CONFIG}
    ```
1. Plug the USB SoapySDR-compatible transceiver before you run the container
1. Declare your transceiver device
    ```
    # Identify your USB-device
    lsusb

    # Find the line with your device. For instance
    Bus 001 Device 004: ID 1d50:6089 OpenMoko, Inc. Great Scott Gadgets HackRF One SDR

    # Declare your device
    TX_DEV=/dev/bus/usb/major/minor (in the above example: /dev/bus/usb/001/004)
    ```
1. Run the container. Please note that the image uses port:
    - 9400: modulator ZMQ RC port

    ```
    docker container run \
        --detach \
        --rm \
        --name odr-dabmod \
        --env "TZ=${TZ}" \
        --network odr \
        --publish 9400:9400 \
        --device=${TX_DEV} \
        --volume ${MOD_CONFIG}:/mnt/mod.ini \
        opendigitalradio/dabmod:latest \
        /mnt/mod.ini
    ```
