#!/bin/bash

if [[ $EUD -ne 0 ]]; then
    echo "This script must be run as root" >&2
    exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
KEY=${KEY:-920498D5E1E4D38C258A1AE623FE6D6C9114BC76}
DIST_NAME=ironblue
REPO_PATH=${REPO_PATH:-/var/lib/ostree/${DIST_NAME}}
DIST_PATH=${DIST_PATH:-/srv/http/ckoomen.eu/ostree/${DIST_NAME}}
MACHINE="$(uname -m)"
FEDORA_VERSION=32

for dir in ${REPO_PATH} ${DIST_PATH} /var/cache/ostree/${DIST_NAME}; do
  if [[ ! -d ${dir} ]]; then
    mkdir -p ${dir}
  fi
done
if [[ ! -d ${DIST_PATH}/tmp ]]; then
    ostree init --repo=${DIST_PATH} --mode=archive
    [[ "${REPO_PATH}" = "${DIST_PATH}" ]] && NEW_REPO=1
fi
if [[ ! -d ${REPO_PATH}/tmp ]]; then
    ostree init --repo=${REPO_PATH}
    NEW_REPO=1
fi
# rm -rf ${REPO_PATH}/tmp/*.tmp
rpm-ostree compose tree --repo=${REPO_PATH} --workdir ${REPO_PATH}/tmp ${DIR}/custom-desktop.yaml
if [[ ! -z "${NEW_REPO}" ]]; then
    ostree --repo=${REPO_PATH} static-delta generate fedora/${FEDORA_VERSION}/${MACHINE}/${DIST_NAME}
fi
# ostree --repo=${REPO_PATH} gpg-sign fedora/${FEDORA_VERSION}/${MACHINE}/${DIST_NAME} ${KEY}
if [[ "${REPO_PATH}" != "${DIST_PATH}" ]]; then
  ostree --repo="${DIST_PATH}" pull-local "${REPO_PATH}"
fi
ostree --repo=${DIST_PATH} summary -u
# Deploy with
# ostree remote add fedora-${DIST_NAME} http://${URL}/ostree/${DIST_NAME}
# ostree pull fedora-${DIST_NAME}:fedora/${FEDORA_VERSION}/${MACHINE}/${DIST_NAME}
# ostree admin deploy fedora-${DIST_NAME}:fedora/${FEDORA_VERSION}/${MACHINE}/${DIST_NAME}
