#!/bin/bash

set -e
BASE=$(cd $(dirname $0) && pwd)
JNIDIR="${BASE}/jni"

cd "${JNIDIR}"
ndk-build

