# -------------------
# Android_4.3.0_so.mk
# [from 'jni/' directory]
# ndk-build clean
# ndk-build
# 20150623: used to create a 'libspatialite.so' with spatialite-4.3.0_so.mk
# -------------------
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARDS)
LOCAL_MODULE := spatial

ICONV_PATH := libiconv-1.13.1
SQLITE_PATH := sqlite-amalgamation-3090200
PROJ4_PATH := proj.4-4.9.2
GEOS_PATH := geos-3.4.2
LZMA_PATH := xz-5.2.2
XML2_PATH := libxml2-2.9.1
SPATIALITE_PATH := libspatialite

# SQLITE_PATH := sqlite-autoconf-3090200
# include $(LOCAL_PATH)/sqlite-autoconf-3090200.mk
#
# SQLITE_PATH := sqlite-amalgamation-3081002
# include $(LOCAL_PATH)/sqlite-3081002.mk
#
include $(LOCAL_PATH)/sqlite-amalgamation-3090200.mk
include $(LOCAL_PATH)/libiconv-1.13.1.mk
include $(LOCAL_PATH)/proj.4-4.9.2.mk
include $(LOCAL_PATH)/geos-3.4.2.mk
include $(LOCAL_PATH)/xz-5.2.2.mk
include $(LOCAL_PATH)/libxml2-2.9.1.mk
include $(LOCAL_PATH)/spatialite-4.3.0a_so.mk
$(call import-module,android/cpufeatures)
