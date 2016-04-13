#!/bin/bash

set -e
set -x

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

bash rename_artefacts.sh
