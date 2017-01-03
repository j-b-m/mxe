# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := frei0r-plugins
$(PKG)_VERSION  := 1.5.0
#$(PKG)_CHECKSUM := 3c06e72f1bb8e30af15c22c12066cfcea802293fcc3b2d95641b84d50c255601

#Using local git tree
$(PKG)_SOURCE_TREE := /media/home/data/downloads/git/frei0r-1
#$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
#$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_HOME     := https://files.dyne.org/frei0r/releases/
$(PKG)_URL      := $($(PKG)_HOME)/$($(PKG)_FILE)
$(PKG)_DEPS     := cairo

define $(PKG)_UPDATE
    $(WGET) -q -O-  https://files.dyne.org/frei0r/releases | \
    $(SED) -n 's,.*frei0r-plugins_\([0-9][^>]*\)\.tar.gz,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake '$($(PKG)_SOURCE_TREE)' \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DWITHOUT_OPENCV=1 -DWITHOUT_GAVL=1
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install
endef
