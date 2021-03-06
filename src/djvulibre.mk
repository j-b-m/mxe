# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := djvulibre
$(PKG)_WEBSITE  := http://djvu.sourceforge.net/
$(PKG)_DESCR    := DjVuLibre
$(PKG)_VERSION  := 3.5.27
$(PKG)_CHECKSUM := e69668252565603875fb88500cde02bf93d12d48a3884e472696c896e81f505f
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/djvu/DjVuLibre/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc jpeg tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/djvu/files/DjVuLibre/' | \
    $(SED) -n 's,.*/\([0-9][^A-Za-z"]*\)/".*,\1,p' | \
    head -1
endef

# can't build a working static library for now
# https://sourceforge.net/p/djvu/bugs/274/
define $(PKG)_BUILD_SHARED
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-desktopfiles
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install-strip \
        $(MXE_DISABLE_CRUFT) dist_bin_SCRIPTS=

    '$(TARGET)-g++' \
        -W -Wall -Werror -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' ddjvuapi --cflags --libs`
endef
