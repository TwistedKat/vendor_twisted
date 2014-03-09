PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.google.clientidbase=android-google \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Disable excessive dalvik debug messages
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.debug.alloc=0

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/twisted/prebuilt/common/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/twisted/prebuilt/common/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/twisted/prebuilt/common/bin/50-twisted.sh:system/addon.d/50-twisted.sh \
    vendor/twisted/prebuilt/common/bin/99-backup.sh:system/addon.d/99-backup.sh \
    vendor/twisted/prebuilt/common/etc/backup.conf:system/etc/backup.conf

# Twisted-specific init file
PRODUCT_COPY_FILES += \
    vendor/twisted/prebuilt/common/etc/init.local.rc:root/init.twisted.rc

# Copy latinime for gesture typing
PRODUCT_COPY_FILES += \
    vendor/twisted/prebuilt/common/lib/libjni_latinime.so:system/lib/libjni_latinime.so

# SELinux filesystem labels
PRODUCT_COPY_FILES += \
    vendor/twisted/prebuilt/common/etc/init.d/50selinuxrelabel:system/etc/init.d/50selinuxrelabel

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/twisted/prebuilt/common/etc/mkshrc:system/etc/mkshrc \
    vendor/twisted/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf

PRODUCT_COPY_FILES += \
    vendor/twisted/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/twisted/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit \
    vendor/twisted/prebuilt/common/bin/sysinit:system/bin/sysinit

# Workaround for NovaLauncher zipalign fails
PRODUCT_COPY_FILES += \
    vendor/twisted/prebuilt/common/app/DashClock.apk:system/app/DashClock.apk \
    vendor/twisted/prebuilt/common/app/NovaLauncher.apk:system/app/NovaLauncher.apk \
    vendor/twisted/prebuilt/common/app/Roundr.apk:system/app/Roundr.apk

# Embed SuperUser
SUPERUSER_EMBEDDED := true

# Required packages
PRODUCT_PACKAGES += \
    Camera \
    CellBroadcastReceiver \
    Development \
    SpareParts \
    Superuser \
    su

# Optional packages
# PRODUCT_PACKAGES += \
#    Basic \
#    HoloSpiralWallpaper \
#    NoiseField \
#    Galaxy4 \
#    LiveWallpapersPicker \
#    PhaseBeam

# DSPManager
#PRODUCT_PACKAGES += \
#    DSPManager \
#    libcyanogen-dsp \
#    audio_effects.conf

# Extra Optional packages
PRODUCT_PACKAGES += \
    LatinIME \
    BluetoothExt
 
# Extra tools
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs

# easy way to extend adding more packages
-include vendor/extra/product.mk

PRODUCT_PACKAGE_OVERLAYS += vendor/twisted/overlay/common

# Boot animation include
ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))

# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/twisted/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

PRODUCT_COPY_FILES += \
    vendor/twisted/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip
endif

# Versioning System
# TwistedKat stable releases
PRODUCT_VERSION_MAJOR = 4.4.2
PRODUCT_VERSION_MINOR = build
PRODUCT_VERSION_MAINTENANCE = 2.3
ifdef TWISTED_BUILD_EXTRA
    TWISTED_POSTFIX := -$(TWISTED_BUILD_EXTRA)
endif
ifndef TWISTED_BUILD_TYPE
    TWISTED_BUILD_TYPE := UNOFFICIAL
    PLATFORM_VERSION_CODENAME := UNOFFICIAL
    TWISTED_POSTFIX := -$(shell date +"%Y%m%d-%H%M")
endif

# Set all versions
TWISTED_VERSION := TWISTED-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(TWISTED_BUILD_TYPE)$(TWISTED_POSTFIX)
TWISTED_MOD_VERSION := TWISTED-$(TWISTED_BUILD)-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(TWISTED_BUILD_TYPE)$(TWISTED_POSTFIX)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    twisted.ota.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE) \
    ro.twisted.version=$(TWISTED_VERSION) \
    ro.modversion=$(TWISTED_MOD_VERSION)

