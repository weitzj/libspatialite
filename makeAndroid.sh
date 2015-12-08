#!/bin/bash

set -e
BASE=$(cd $(dirname $0) && pwd)
source "${BASE}/pathSetup.sh"

cp "${JNIDIR}/libspatialite_config.h" "${SPATIALITE_PATH}/config.h"

ndk-build

