# Build fingerprint
ifneq ($(BUILD_FINGERPRINT),)
ADDITIONAL_BUILD_PROPERTIES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)
endif

# Plehground System Version
ADDITIONAL_BUILD_PROPERTIES += \
    ro.pleh.version=$(PLEH_VERSION)
