#!/usr/bin/env bash

set -e

# Change fluent user in passwd
sed -r 's/(fluent):(x):[0-9]+:[0-9]+/\1:\2:'$(id -u):$(id -g)'/' /etc/passwd > /tmp/passwd
export LD_PRELOAD="${LD_PRELOAD}${LD_PRELOAD:+:}/usr/lib/libnss_wrapper.so"
export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/etc/group

umask 0000

exec "$@"
