ARCHS = armv7 arm64

include theos/makefiles/common.mk

BUNDLE_NAME = ReadReceiptFS
ReadReceiptFS_FILES = Switch.x
ReadReceiptFS_FRAMEWORKS = UIKit
ReadReceiptFS_LIBRARIES = flipswitch
ReadReceiptFS_INSTALL_PATH = /Library/Switches

include $(THEOS_MAKE_PATH)/bundle.mk