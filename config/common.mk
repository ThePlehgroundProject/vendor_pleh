PRODUCT_BRAND ?= Plehground

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# Default notification/alarm sounds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.config.ringtone=Ganymede.ogg \
    ro.config.notification_sound=Ariel.ogg \
    ro.config.alarm_alert=Argon.ogg

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/pleh/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/pleh/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/pleh/prebuilt/common/bin/50-base.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-base.sh \
    vendor/pleh/prebuilt/common/bin/blacklist:$(TARGET_COPY_OUT_SYSTEM)/addon.d/blacklist

ifneq ($(AB_OTA_PARTITIONS),)
PRODUCT_COPY_FILES += \
    vendor/pleh/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/pleh/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/pleh/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh
endif

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/pleh/config/permissions/backup.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/backup.xml

# Copy all Pleh-specific init rc files
$(foreach f,$(wildcard vendor/pleh/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/pleh/prebuilt/common/lib/content-types.properties:$(TARGET_COPY_OUT_SYSTEM)/lib/content-types.properties

# Enable Android Beam on all targets
PRODUCT_COPY_FILES += \
    vendor/pleh/config/permissions/android.software.nfc.beam.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.nfc.beam.xml

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/Vendor_045e_Product_0719.kl

# This is Pleh!
PRODUCT_COPY_FILES += \
    vendor/pleh/config/permissions/privapp-permissions-pleh-system.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-pleh.xml \
    vendor/pleh/config/permissions/privapp-permissions-pleh-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-pleh.xml \

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=enforce

# Power whitelist
PRODUCT_COPY_FILES += \
    vendor/pleh/config/permissions/pleh-power-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/pleh-power-whitelist.xml

# TWRP
ifeq ($(WITH_TWRP),true)
include vendor/pleh/config/twrp.mk
endif

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# AOSP packages
PRODUCT_PACKAGES += \
    ExactCalculator \
    Exchange2 \
    Terminal

# Themes
PRODUCT_PACKAGES += \
    ThemePicker

# Extra tools in Pleh
PRODUCT_PACKAGES += \
    7z \
    awk \
    bash \
    bzip2 \
    curl \
    getcap \
    htop \
    lib7z \
    libsepol \
    nano \
    pigz \
    powertop \
    setcap \
    unrar \
    unzip \
    vim \
    wget \
    zip

# Charger
PRODUCT_PACKAGES += \
    charger_res_images

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.exfat \
    fsck.ntfs \
    mke2fs \
    mkfs.exfat \
    mkfs.ntfs \
    mount.ntfs

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

# Conditionally build in su
ifeq ($(WITH_SU),true)
PRODUCT_PACKAGES += \
    su
endif

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/pleh/overlay
DEVICE_PACKAGE_OVERLAYS += vendor/pleh/overlay/common

PLEH_DATE_YEAR := $(shell date -u +%Y)
PLEH_DATE_MONTH := $(shell date -u +%m)
PLEH_DATE_DAY := $(shell date -u +%d)
PLEH_DATE_HOUR := $(shell date -u +%H)
PLEH_DATE_MINUTE := $(shell date -u +%M)
PLEH_BUILD_DATE := $(PLEH_DATE_YEAR)$(PLEH_DATE_MONTH)$(PLEH_DATE_DAY)-$(PLEH_DATE_HOUR)$(PLEH_DATE_MINUTE)

PLEH_PLATFORM_VERSION := 10

PLEH_VERSION := $(PLEH_PLATFORM_VERSION)-$(PLEH_BUILD)-$(PLEH_BUILD_DATE)

-include $(WORKSPACE)/build_env/image-auto-bits.mk
-include vendor/pleh/config/partner_gms.mk
