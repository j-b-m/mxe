# This file is part of MXE. See LICENSE.md for licensing information.

$(info == Custom FFmpeg overrides: $(lastword $(MAKEFILE_LIST)))

# reduced ffmpeg
ffmpeg_DEPS := $(filter-out gnutls libass libbluray libbs2b libcaca opencore-amr vo-amrwbenc,$(ffmpeg_DEPS))

# use pthreads with MLT
#--disable-libmp3lame
define ffmpeg_BUILD
    cd '$(1)' && ./configure \
        --cross-prefix='$(TARGET)-' \
        --enable-cross-compile \
        --target-os=mingw32 \
        --disable-static \
        --enable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --yasmexe='$(TARGET)-yasm' \
        --disable-debug \
        --enable-memalign-hack \
        --enable-pthreads \
        --disable-ffserver \
        --arch=x86_64 \
        --disable-doc \
        --enable-avresample \
        --enable-gpl \
        --enable-version3 \
        --extra-libs='-mconsole' \
        --enable-runtime-cpudetect \
        --enable-avisynth \
        --disable-libass \
        --disable-libbluray \
        --disable-libbs2b \
        --disable-libcaca \
        --disable-libopencore-amrnb \
        --disable-libopencore-amrwb \
        --disable-libopus \
        --enable-libspeex \
        --enable-libtheora \
        --enable-libvidstab \
        --disable-libvo-amrwbenc \
        --enable-libvorbis \
        --enable-libvpx \
        --enable-libx264 \
        --enable-libxvid
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
#        --enable-libmp3lame \

