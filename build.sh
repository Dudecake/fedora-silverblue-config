#!/bin/bash

if [[ $EUD -ne 0 ]]; then
    echo "This script must be run as root" >&2
    exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )" 
DIST_NAME=ironblue
REPO_PATH=${REPO_PATH:-/var/lib/ostree/ironblue}
DIST_PATH=${DIST_PATH:-/srv/http/ckoomen.eu/ostree/ironblue}

if [[ ! -d ${REPO_PATH}/tmp ]]; then
    ostree init --repo=${REPO_PATH}
    NEW_REPO=1
fi
rpm-ostree compose tree --repo=${REPO_PATH} --workdir ${REPO_PATH}/tmp ${DIR}/custom-desktop.yaml
if [[ ! -z "${NEW_REPO}" ]]; then
    ostree --repo=${REPO_PATH} static-delta generate fedora/31/x86_64/ironblue
fi
if [[ ! -d ${DIST_PATH}/tmp ]]; then
    ostree init --repo=${DIST_PATH} --mode=archive
fi
ostree --repo=${DIST_PATH} pull-local ${REPO_PATH}
ostree --repo=${DIST_PATH} summary -u
#ostree pull-local /ostree/${DIST_NAME} fedora/31/${DIST_NAME}
#ostree admin deploy fedora/31/x86_64/${DIST_NAME}
#ostree admin rebase fedora/31/x86_64/${DIST_NAME}
