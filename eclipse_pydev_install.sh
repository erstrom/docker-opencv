#! /bin/bash

SCRIPT_PATH=`readlink -f $0`
SCRIPT_DIR=`dirname $SCRIPT_PATH`

# Configuration env vars will be set to default values if not defined.
[[ -z ${ECLIPSE_INSTALL_DIR+x} ]] && ECLIPSE_INSTALL_DIR=/opt
[[ -z ${ECLIPSE_URL+x} ]] && ECLIPSE_URL=http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/technology/epp/downloads/release/oxygen/R
[[ -z ${ECLIPSE_TAR_BALL+x} ]] && ECLIPSE_TAR_BALL=eclipse-java-oxygen-R-linux-gtk-x86_64.tar.gz
[[ -z ${PYDEV_URL+x} ]] && PYDEV_URL=https://downloads.sourceforge.net/project/pydev/pydev/PyDev%205.8.0
[[ -z ${PYDEV_ZIP+x} ]] && PYDEV_ZIP=PyDev%205.8.0.zip

mkdir -p $ECLIPSE_INSTALL_DIR
[[ $? -ne 0 ]] && echo "Unable to create directory: $ECLIPSE_INSTALL_DIR" && exit 1

pushd $ECLIPSE_INSTALL_DIR
wget $ECLIPSE_URL/$ECLIPSE_TAR_BALL
[[ $? -ne 0 ]] && echo "Unable to fetch eclipse tar ball. Check URL: $ECLIPSE_URL/$ECLIPSE_TAR_BALL" && exit 1
tar xf $ECLIPSE_TAR_BALL
[[ $? -ne 0 ]] && echo "Unable to extract eclipse tar ball." && exit 1
pushd eclipse/dropins
popd
wget $PYDEV_URL/$PYDEV_ZIP -O pydev.zip
[[ $? -ne 0 ]] && echo "Unable to fetch pydev zip. Check URL: $PYDEV_URL/$PYDEV_ZIP" && exit 1
unzip pydev.zip
[[ $? -ne 0 ]] && echo "Unable to extract pydev zip archive." && exit 1
popd
