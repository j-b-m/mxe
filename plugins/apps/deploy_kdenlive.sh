#!/bin/bash
# run from mxe root dir after "make kdenlive"
# > plugins/apps/deploy_kdenlive.sh
INSTALL_DIR=$PWD/../kdenlive-windows

echo Installing to $INSTALL_DIR
[ -d $INSTALL_DIR ] && echo "... already exists, delete?" && rm -rI $INSTALL_DIR
mkdir -p $INSTALL_DIR/{lib,share,etc}

cd usr/x86_64-w64-mingw32.shared.posix

echo Copying binaries
cp *.dll *.exe $INSTALL_DIR
cp bin/{*.dll,ff*.exe,k*.exe,dbus-*.exe,gdb*.exe} $INSTALL_DIR
cp lib/libdl.dll.a $INSTALL_DIR
cp qt5/bin/*.dll $INSTALL_DIR
cp -r qt5/{plugins,qml} $INSTALL_DIR
printf "[Paths]\nPlugins=plugins\nQml2Imports=qml\n" > $INSTALL_DIR/qt.conf
echo Copying data
cp -r bin/data $INSTALL_DIR
cp bin/data/icons/breeze/breeze-icons.rcc $INSTALL_DIR/data/icontheme.rcc
rm -r $INSTALL_DIR/data/icons/
# MLT looks for lib & share next to exe on windows
cp -r share/{mlt,ffmpeg,dbus-1} $INSTALL_DIR/share
cp -r etc/{dbus-1,xdg} $INSTALL_DIR/etc
cp -r lib/{mlt,frei0r-1,ladspa} $INSTALL_DIR/lib

cd $INSTALL_DIR/..
#[ -f drmingw-0.8.1-win64.7z ] || wget https://github.com/jrfonseca/drmingw/releases/download/0.8.1/drmingw-0.8.1-win64.7z
#[ -d drmingw-0.8.1-win64 ] || 7z x drmingw-0.8.1-win64.7z
#cp drmingw-0.8.1-win64/bin/*.{dll,yes} $INSTALL_DIR
[ -$1 == -z ] && echo "Compressing" && 7z a $INSTALL_DIR.7z $INSTALL_DIR

