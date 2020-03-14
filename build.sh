#!/bin/bash

if [[ $EUD -ne 0 ]]; then
    echo "This script must be run as root" >&2
    exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )" 
DIST_NAME=ironblue
REPO_PATH=${REPO_PATH:-/var/lib/ostree/ironblue}

if [[ ! -d ${REPO_PATH}/tmp ]]; then
    ostree init --repo=${REPO_PATH} --mode=archive
fi
rpm-ostree compose tree --repo=${REPO_PATH} --workdir ${REPO_PATH}/tmp ${DIR}/custom-desktop.yaml
ostree --repo=${REPO_PATH} static-delta generate fedora/31/x86_64/ironblue
ostree --repo=${REPO_PATH} summary -u
#ostree pull-local /ostree/${DIST_NAME} fedora/31/${DIST_NAME}
#ostree admin deploy fedora/31/x86_64/${DIST_NAME}
#ostree admin rebase fedora/31/x86_64/${DIST_NAME}
