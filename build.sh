#!/bin/bash

if [[ $EUD -ne 0 ]]; then
    echo "This script must be run as root" >&2
    exit 1
fi

DIST_NAME=ironblue

rpm-ostree compose tree -r /var/cache/ostree/${DIST_NAME} --workdir /var/cache/ostree/${DIST_NAME}/tmp custom-desktop.yaml
#ostree pull-local /ostree/${DIST_NAME} fedora/31/${DIST_NAME}
#ostree admin deploy fedora/31/${DIST_NAME}
