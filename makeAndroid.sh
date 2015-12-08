#!/bin/bash

set -e
BASE=$(cd $(dirname $0) && pwd)
source "${BASE}/pathSetup.sh"

cp -a "${CONFIGSDIR}/"* "${JNIDIR}"
cd "${JNIDIR}"
ndk-build

