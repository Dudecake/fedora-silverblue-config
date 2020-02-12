#!/usr/bin/env bash

set -xeuo pipefail

./workstation-ostree-config/post.sh

sed -i 's/#AutomaticUpdatePolicy=.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostree.conf
ln -s /usr/lib/systemd/system/rpm-ostreed-automatic.timer /etc/systemd/system/timers.target.wants/rpm-ostreed-automatic.timer
