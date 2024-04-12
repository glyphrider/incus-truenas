#!/usr/bin/env bash

set +x

# TRUENAS=TrueNAS-13.0-U6.1 # Currently, I can't get the FreeBSD-based VM to actually work
TRUENAS=TrueNAS-SCALE-23.10.2

# incus storage volume import --type=iso default ~/Downloads/$TRUENAS.iso $TRUENAS

incus init truenas --empty --vm -c limits.cpu=2 -c limits.memory=8GiB -c security.secureboot=false -d root,size=20GiB

incus config device add truenas truenas-installer disk pool=default source=$TRUENAS boot.priority=10
# incus config device add truenas hba pci address="xx:xx.x"

incus start truenas
# install to serial console.... then shutdown
incus console truenas
incus stop truenas --timeout 30

# detach the install media.... then start
incus config device remove truenas truenas-installer
incus start truenas

# wait for the IP address, since incus doesn't see it
incus console truenas
