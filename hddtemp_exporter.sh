#!/bin/bash

set -ueo pipefail

HDDTEMP_EXPORTER_OUTPUT=${HDDTEMP_EXPORTER_OUTPUT:-/var/lib/node_exporter/hddtemp.prom}

mkdir -p "$(dirname ${HDDTEMP_EXPORTER_OUTPUT})"

find /dev/ -name 'sd?' -print0 \
    | parallel -0 --tag sudo hddtemp --numeric \
    | sort \
    | awk '{ printf("hddtemp_temperature_celcius{device=\"%s\"} %s\n", $1, $2) }' \
    > "$HDDTEMP_EXPORTER_OUTPUT"
