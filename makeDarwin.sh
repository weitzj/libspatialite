#!/bin/bash

set -e
BASE=$(cd $(dirname $0) && pwd)
JNIDIR="${BASE}/jni"
PREFIX="${BASE}/darwin/amd64"
INCLUDEDIR="${PREFIX}/include"
LIBDIR="${PREFIX}/lib"

ICONV_PATH="${JNIDIR}/libiconv-1.13.1"
SQLITE_PATH="${JNIDIR}/sqlite-autoconf-3090200"
PROJ4_PATH="${JNIDIR}/proj.4-4.9.2"
GEOS_PATH="${JNIDIR}/geos-3.5.0"
LZMA_PATH="${JNIDIR}/xz-5.2.2"
XML2_PATH="${JNIDIR}/libxml2-2.9.1"
SPATIALITE_PATH="${JNIDIR}/libspatialite"


# SQLITE
cd "${SQLITE_PATH}"
env CFLAGS='-DSQLITE_ENABLE_LOAD_EXTENSION' ./configure --prefix="${PREFIX}" --enable-json1 --disable-static
make
make install
make distclean

# PROJ
cd "${PROJ4_PATH}"
./configure --prefix="${PREFIX}" --disable-static --without-jni
make
make install
make distclean

# GEOS
cd "${GEOS_PATH}"
./configure --prefix="${PREFIX}" --disable-static
make
make install
make distclean

# XZ
cd "${LZMA_PATH}"
./configure --prefix="${PREFIX}" --disable-static
make
make install
make distclean

# LIBXML2
cd "${XML2_PATH}"
./configure --prefix="${PREFIX}" --disable-static
make
make install
make distclean

cd "${SPATIALITE_PATH}"
export CFLAGS="-I${PREFIX}/include"
export LDFLAGS="-L${PREFIX}/lib"
./configure --prefix="${PREFIX}" --enable-module-only --with-geosconfig="${PREFIX}/bin/geos-config" --disable-examples --disable-freexl
make
make install
make distclean
cp "${LIBDIR}/mod_spatialite.7.so" "${LIBDIR}/libspatialite.dylib"


# Fixing dynamic library search paths
for fullPath in $(find $LIBDIR -type f -maxdepth 1 -regex ".*[.dylib]\$")
do
    fileName=$(basename $fullPath)
    install_name_tool -id "${fileName}" "${fullPath}"
    if [ "${fileName}" == 'libgeos_c.1.dylib' ]
    then
        install_name_tool -change "${LIBDIR}/libgeos-3.5.0.dylib" "@loader_path/libgeos-3.5.0.dylib" "${fullPath}"
    fi
    if [ "${fileName}" == 'libspatialite.dylib' ]
    then
        echo "fixing libspatialite"
        install_name_tool -change "${LIBDIR}/libgeos_c.1.dylib" "@loader_path/libgeos_c.1.dylib" "${fullPath}"
        install_name_tool -change "${LIBDIR}/libgeos-3.5.0.dylib" "@loader_path/libgeos-3.5.0.dylib" "${fullPath}"
        install_name_tool -change "${LIBDIR}/libproj.9.dylib" "@loader_path/libproj.9.dylib" "${fullPath}"
        install_name_tool -change "${LIBDIR}/libsqlite3.0.dylib" "@loader_path/libsqlite3.0.dylib" "${fullPath}"
        install_name_tool -change "${LIBDIR}/libxml2.2.dylib" "@loader_path/libxml2.2.dylib" "${fullPath}"
    fi
done
