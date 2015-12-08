#!/bin/bash

set -e

ICONV_PATH='libiconv-1.13.1'
SQLITE_PATH='sqlite-autoconf-3090200'
PROJ4_PATH='proj.4-4.9.2'
GEOS_PATH='geos-3.5.0'
LZMA_PATH='xz-5.2.2'
XML2_PATH='libxml2-2.9.1'
SPATIALITE_PATH='libspatialite'


BASE=$(cd $(dirname $0) && pwd)
cd "${BASE}/jni"

PREFIX="${BASE}/darwin/amd64"

# SQLITE
cd "${SQLITE_PATH}"
env CFLAGS='-DSQLITE_ENABLE_LOAD_EXTENSION' ./configure --prefix="${PREFIX}" --enable-json1 --disable-static
make
make install
make distclean
cd ..

# PROJ
cd "${PROJ4_PATH}"
./configure --prefix="${PREFIX}" --disable-static --without-jni
make
make install
make distclean
cd ..

# GEOS
cd "${GEOS_PATH}"
./configure --prefix="${PREFIX}" --disable-static
make
make install
make distclean
cd ..

# XZ
cd "${LZMA_PATH}"
./configure --prefix="${PREFIX}" --disable-static
make
make install
make distclean
cd ..

# LIBXML2
cd "${XML2_PATH}"
./configure --prefix="${PREFIX}" --disable-static
make
make install
make distclean
cd ..

cd "${SPATIALITE_PATH}"
export CFLAGS="-I${PREFIX}/include"
export LDFLAGS="-L${PREFIX}/lib"
./configure --prefix="${PREFIX}" --enable-module-only --with-geosconfig="${PREFIX}/bin/geos-config" --disable-examples --disable-freexl
make
make install
make distclean
cd ..


cd "${BASE}"
