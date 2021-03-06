# This file is part of MXE. See LICENSE.md for licensing information.

# need to symlink host "parsetrigrams" to $(PREFIX)/bin !!!

PKG             := sonnet
$(PKG)_VERSION  := 5.29.0
$(PKG)_CHECKSUM  := 20358de0d45387f44260c3e6f8df012d661b4446293cbb3823c978e3a8766965
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_HOME     := http://download.kde.org/stable/frameworks
$(PKG)_URL      := $($(PKG)_HOME)/$(basename $($(PKG)_VERSION))/$($(PKG)_FILE)
$(PKG)_DEPS     := qtbase extra-cmake-modules

define $(PKG)_UPDATE
    $(WGET) -q -O- http://download.kde.org/stable/frameworks/ | \
    $(SED) -n 's,.*\([0-9]\+\.[0-9]\+\)/.*,\1.0,p' | \
	tail -1
endef

define $(PKG)_BUILD
	cd "$(1)/data" && $(BUILD_CXX) -std=c++11 parsetrigrams.cpp -o $(PREFIX)/bin/parsetrigrams -fPIC $(shell pkg-config --cflags Qt5Core --libs Qt5Core)
    mkdir "$(1)/build"
    cd "$(1)/build" && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE="$(CMAKE_TOOLCHAIN_FILE)" \
        -DCMAKE_BUILD_TYPE=Release \
        -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
        -DBUILD_TESTING=OFF \
        -DPARSETRIGRAMS_EXECUTABLE=$(PREFIX)/bin/parsetrigrams
    $(MAKE) -C "$(1)/build" -j $(JOBS) install
endef
