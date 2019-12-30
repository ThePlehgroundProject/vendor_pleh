# Inherit full common Pleh stuff
$(call inherit-product, vendor/pleh/config/common.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include Pleh LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/pleh/overlay/dictionaries
