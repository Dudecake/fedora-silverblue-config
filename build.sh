#!/bin/bash

if [[ $EUD -ne 0 ]]; then
    echo "This script must be run as root" >&2
    exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
KEY=${KEY:-920498D5E1E4D38C258A1AE623FE6D6C9114BC76}
DIST_NAME=ironblue
DIST_PATH=${DIST_PATH:-/srv/http/ckoomen.eu/ostree/${DIST_NAME}}
MACHINE="$(uname -m)"
FEDORA_VERSION=36

set -e
[[ ! -z ${DRYRUN} ]] && exit 0
if [[ ! -d "${DIST_PATH}/tmp" ]]; then
  mkdir -p "${DIST_PATH}"
  ostree init --repo="${DIST_PATH}" --mode=archive
fi
if [[ ! -f "${DIST_PATH}/refs/heads/fedora/${FEDORA_VERSION}/${MACHINE}/${DIST_NAME}" ]]; then
  NEW_REPO=1
fi
rpm-ostree compose tree --repo="${DIST_PATH}" "${DIR}/custom-desktop.yaml" --unified-core --cachedir="${DIST_PATH}/tmp/cache" "$@"
echo "Composed Fedora tree" >&2
if [[ -z "${NEW_REPO}" ]]; then
    ostree --repo="${DIST_PATH}" static-delta generate fedora/${FEDORA_VERSION}/${MACHINE}/${DIST_NAME}
fi
# ostree --repo="${DIST_PATH}" gpg-sign fedora/${FEDORA_VERSION}/${MACHINE}/${DIST_NAME} ${KEY}
ostree --repo="${DIST_PATH}" summary -u
# Deploy with
# ostree remote add fedora-${DIST_NAME} http://${URL}/ostree/${DIST_NAME}
# ostree pull fedora-${DIST_NAME}:fedora/${FEDORA_VERSION}/${MACHINE}/${DIST_NAME}
# ostree admin deploy fedora-${DIST_NAME}:fedora/${FEDORA_VERSION}/${MACHINE}/${DIST_NAME}
