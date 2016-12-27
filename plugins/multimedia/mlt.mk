# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mlt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.4.1
$(PKG)_CHECKSUM := d3a992f3e67463e68630cb0b455d408a2a12f4da7a19e46807fa08a79f09b2b6
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libxml2 sdl sdl_image ffmpeg qtbase qtsvg \
	ladspa-sdk fftw libsamplerate vorbis sox dlfcn-win32
# frei0r-plugins ladspa-sdk fftw libsamplerate vorbis sox	
# sox gtk2 movit exif xine

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/mltframework/mlt/tags' | \
    grep '<a href="/mltframework/mlt/archive/' | \
    $(SED) -n 's,.*href="/mltframework/mlt/archive/v\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && \
	CFLAGS="-I$(PREFIX)/$(TARGET)/include" \
	PKG_CONFIG_LIBDIR=$(PREFIX)/$(TARGET)/lib/pkgconfig \
	CC=$(TARGET)-gcc \
	./configure $(MXE_CONFIGURE_OPTS) \
		--target-os=MinGW --target-arch=x86_64 --rename-melt=melt.exe \
		--qt-includedir=$(PREFIX)/$(TARGET)/qt5/include \
		--qt-libdir=$(PREFIX)/$(TARGET)/qt5/lib \
		--enable-gpl --enable-gpl3 \
		--disable-gtk2 --disable-opengl --disable-xine --disable-rtaudio \
		--disable-decklink \
		--extra-cflags='-std=c++11'
	echo "CONFIG DONe\n"
	# --disable-sse --disable-sse2  -DMELT_NOSDL
	#PKG_CONFIG_LIBDIR=$(PREFIX)/$(TARGET)/lib/pkgconfig
	#
	$(MAKE) -C '$(1)/src/modules/lumas' CC=$(BUILD_CC) luma
	CXXFLAGS="$(CXXFLAGS) -std=c++11 -I.." \
	CFLAGS="$(CFLAGS) -I.. -I$(PREFIX)/$(TARGET)/include -DMELT_NOSDL" \
	LDFLAGS="$(LDFLAGS) -Wl,--no-as-needed -lz -ldl -liconv -lpsapi -L$(PREFIX)/$(TARGET)/lib" \
	PKG_CONFIG_LIBDIR=$(PREFIX)/$(TARGET)/lib/pkgconfig \
	$(MAKE) -C '$(1)' \
		CC=$(TARGET)-gcc \
		CXX=$(TARGET)-g++ \
		-j '$(JOBS)' all
    $(MAKE) -C '$(1)' -j 1 install
endef

