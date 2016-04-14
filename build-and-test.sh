#!/bin/bash

set -e
set -x

if [ -z $TRAVIS_OS_NAME ]; then
	echo "This file is for automated builds only. Please use the respective make.sh files for local builds."
	exit -1
fi

if [ "_$TRAVIS_OS_NAME" = "_osx" ]; then
	#OSX DEPENDENCIES
	brew update
	brew upgrade pkg-config
    brew install $PACKAGES_INSTALL
else
	#DEBIAN DEPENDENCIES
    sudo apt-get update -qq
    sudo apt-get install -qq -y $PACKAGES_INSTALL
fi

if [ "_$OSTYPE" = "_msys" ]; then
	unset CC
	git clone https://github.com/libusb/libusb
	cd libusb
	sh autogen.sh --host=i686-w64-mingw32
	sh configure --target=i686-w64-mingw --host=i686-w64-mingw32 --prefix=/usr/i686-w64-mingw32 --disable-shared
	make
	sudo make install
	cd ..

	wget http://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz
	tar xzf ncurses-5.9.tar.gz
	cd ncurses-5.9
	sh configure --host=i686-w64-mingw32 --prefix=/usr/i686-w64-mingw32 --disable-shared --enable-term-driver --enable-sp-funcs --without-tests --without-cxx-binding
	make
	sudo make install
	cd ..

	export CC=i686-w64-mingw32-gcc
	export STRIP=i686-w64-mingw32-strip
fi

cd UP3DTOOLS
bash make.sh
cd ..

cd UP3DTRANSCODE
bash make.sh
cd ..


GIT=$(git rev-parse --short HEAD)
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
DATE=$(date +'%Y%m%d')
DESTDIR="build/UP3DTOOLS"
OS="LIN"

mkdir -p $DESTDIR

if [ "$OSTYPE" == "msys" ]; then
    OS="WIN"
    cp UP3DTOOLS/upinfo.exe $DESTDIR
    cp UP3DTOOLS/upload.exe $DESTDIR
    cp UP3DTOOLS/upshell.exe $DESTDIR
    cp UP3DTRANSCODE/up3dtranscode.exe $DESTDIR
else 
    if [ "$OSTYPE" == "darwin"* ]; then
        OS="MAC"
    fi
    cp UP3DTOOLS/upinfo $DESTDIR
    cp UP3DTOOLS/upload $DESTDIR
    cp UP3DTOOLS/upshell $DESTDIR
    cp UP3DTRANSCODE/up3dtranscode $DESTDIR
fi

ls -R

cd build
zip -9 "UP3DTOOLS_${OS}_${DATE}_${GIT_BRANCH}_${GIT}.zip" "UP3DTOOLS"
cd ..
