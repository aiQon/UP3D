#!/bin/bash

GIT=$(git rev-parse --short HEAD)
DATE=$(date +'%Y%m%d')
SUFFIX=
DESTDIR=artefacts
OS=

function rename_artefact
{
    if [ -f $1 ]; then
        FILENAME=$(basename $1)
        cp $1 "$DESTDIR/${FILENAME%.*}_${DATE}_${GIT}_${OS}${SUFFIX}"
    else
        echo "$1 was not present, dying"
        exit -1
    fi
}

mkdir -p $DESTDIR

if [[ "$OSTYPE" == "msys" ]]; then
    SUFFIX=".exe"
    OS="win"
    rename_artefact UP3DTOOLS/upinfo.exe
    rename_artefact UP3DTOOLS/upload.exe
    rename_artefact UP3DTOOLS/upshell.exe
    rename_artefact UP3DTRANSCODE/up3dtranscode.exe
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="mac"
    rename_artefact UP3DTOOLS/upinfo
    rename_artefact UP3DTOOLS/upload
    rename_artefact UP3DTOOLS/upshell
    rename_artefact UP3DTRANSCODE/up3dtranscode
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    OS="lin"
    rename_artefact UP3DTOOLS/upinfo
    rename_artefact UP3DTOOLS/upload
    rename_artefact UP3DTOOLS/upshell
    rename_artefact UP3DTRANSCODE/up3dtranscode
fi
