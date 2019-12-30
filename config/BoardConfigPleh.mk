include vendor/pleh/config/BoardConfigKernel.mk

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include vendor/pleh/config/BoardConfigQcom.mk
endif

include vendor/pleh/config/BoardConfigSoong.mk
