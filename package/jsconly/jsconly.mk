################################################################################
#
# jsconly
#
################################################################################

JSCONLY_VERSION = 9d6044421981653d5c5a021dc0fbd44918b907b3
JSCONLY_SITE = $(call github,WebKit,webkit,$(JSCONLY_VERSION))
JSCONLY_INSTALL_STAGING = YES
JSCONLY_DEPENDENCIES = host-bison host-cmake host-flex host-gperf host-ruby icu pcre

JSCONLY_BUILD_JSC_ARGS = --jsc-only
JSCONLY_BUILD_JSC_ARGS += \
	--cmakeargs=-DCMAKE_TOOLCHAIN_FILE=${BR2_HOST_DIR}/usr/share/buildroot/toolchainfile.cmake

ifeq ($(BR2_PACKAGE_JSC_DEBUG),y)
JSCONLY_BUILD_JSC_ARGS += --debug
JSCONLY_BUILD_DIR_NAME = Debug
else
JSCONLY_BUILD_JSC_ARGS += --release
JSCONLY_BUILD_DIR_NAME = Release
endif

define JSCONLY_BUILD_CMDS
	(pushd $(@D) && \
	PATH="${BR2_HOST_DIR}/ccache:${BR2_HOST_DIR}/usr/bin:${PATH}" ./Tools/Scripts/build-jsc ${JSCONLY_BUILD_JSC_ARGS} && \
    popd)
endef

define JSCONLY_INSTALL_STAGING_CMDS
	cp -d $(@D)/WebKitBuild/$(JSCONLY_BUILD_DIR_NAME)/lib/libJavaScriptCore.so* $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/WebKitBuild/$(JSCONLY_BUILD_DIR_NAME)/bin/jsc $(STAGING_DIR)/usr/bin/jsc
endef

define JSCONLY_INSTALL_TARGET_CMDS
	cp -d $(@D)/WebKitBuild/$(JSCONLY_BUILD_DIR_NAME)/lib/libJavaScriptCore.so* $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/WebKitBuild/$(JSCONLY_BUILD_DIR_NAME)/bin/jsc $(TARGET_DIR)/usr/bin/jsc
	$(STRIPCMD) $(TARGET_DIR)/usr/lib/libJavaScriptCore.so.1.0.*
	$(STRIPCMD) $(TARGET_DIR)/usr/bin/jsc
endef


$(eval $(generic-package))
