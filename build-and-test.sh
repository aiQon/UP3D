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
DESTDIR="UP3D"
OS=

rename_artefact()
{
    if [ -f $1 ]; then
        FILENAME=$(basename $1)
        cp $1 "$DESTDIR/$FILENAME"
    else
        echo "$1 was not present, dying"
        exit -1
    fi
}

zip_artefacts()
{
    if [ -d $DESTDIR ]; then
        zip "UP3D_${OS}_${DATE}_${GIT_BRANCH}_${GIT}.zip" "$DESTDIR/*"
    fi
}

mkdir -p $DESTDIR

if [ "$OSTYPE" == "msys" ]; then
    OS="WIN"
    rename_artefact UP3DTOOLS/upinfo.exe
    rename_artefact UP3DTOOLS/upload.exe
    rename_artefact UP3DTOOLS/upshell.exe
    rename_artefact UP3DTRANSCODE/up3dtranscode.exe
    zip_artefacts
elif [ "$OSTYPE" == "darwin"* ]; then
    OS="MAC"
    rename_artefact UP3DTOOLS/upinfo
    rename_artefact UP3DTOOLS/upload
    rename_artefact UP3DTOOLS/upshell
    rename_artefact UP3DTRANSCODE/up3dtranscode
    zip_artefacts
elif [ "$OSTYPE" == "linux-gnu" ]; then
    OS="LIN"
    rename_artefact UP3DTOOLS/upinfo
    rename_artefact UP3DTOOLS/upload
    rename_artefact UP3DTOOLS/upshell
    rename_artefact UP3DTRANSCODE/up3dtranscode
    zip_artefacts
fi
