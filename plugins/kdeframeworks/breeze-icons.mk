# This file is part of MXE. See LICENSE.md for licensing information.
PKG             := breeze-icons
$(PKG)_VERSION  := 5.29.0
$(PKG)_CHECKSUM  := 0bad6cad78f948fd73fc89ae2566b59b6859a752e95eb348ce735408d4bffbae
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
	cd "$(1)" && $(BUILD_CXX) -std=c++11 qrcAlias.cpp -o $(PREFIX)/bin/qrcAlias -fPIC $(shell pkg-config --cflags Qt5Core --libs Qt5Core)
	#cd "$(1)" && $(BUILD_CXX) -std=c++11 qrcAlias.cpp -o $(PREFIX)/bin/qrcAlias -fPIC -I/media/video/packaging/mxe/usr/x86_64-w64-mingw32.shared.posix/qt5/include/ -I/media/video/packaging/mxe/usr/x86_64-w64-mingw32.shared.posix/qt5/include/QtCore -lQt5Core
	#$(shell pkg-config --cflags Qt5Core --libs Qt5Core)
    mkdir "$(1)/build"
    cd "$(1)/build" && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE="$(CMAKE_TOOLCHAIN_FILE)" \
        -DCMAKE_BUILD_TYPE=Release \
        -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
        -DBUILD_TESTING=OFF \
        -DBINARY_ICONS_RESOURCE=ON \
        -DQRCALIAS_EXECUTABLE=$(PREFIX)/bin/qrcAlias
    $(MAKE) -C "$(1)/build" -j $(JOBS) install
endef
