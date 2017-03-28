#! /bin/bash

SCRIPT_PATH=`readlink -f $0`
SCRIPT_DIR=`dirname $SCRIPT_PATH`

# Configuration env vars will be set to default values if not defined.
[ -z $OPENCV_TOP_DIR ] && OPENCV_TOP_DIR=$SCRIPT_DIR
[ -z $OPENCV_VERSION ] && OPENCV_VERSION="master"
[ -z $OPENCV_INSTALL_PREFIX ] && OPENCV_INSTALL_PREFIX="/usr/local"
[ -z $OPENCV_J_LEVEL ] && OPENCV_J_LEVEL=$((`nproc`+1))
[ -z $OPENCV_GIT_URL ] && OPENCV_GIT_URL="https://github.com/opencv/opencv.git"
[ -z $OPENCV_WORKING_DIR ] && OPENCV_WORKING_DIR="opencv"
[ -z $OPENCV_CONTRIB_GIT_URL ] && OPENCV_CONTRIB_GIT_URL="https://github.com/opencv/opencv_contrib.git"
[ -z $OPENCV_CONTRIB_WORKING_DIR ] && OPENCV_CONTRIB_WORKING_DIR="opencv_contrib"

OPENCV_CONTRIB_WORKING_DIR_FULL_PATH=`readlink -f $OPENCV_CONTRIB_WORKING_DIR`

OPENCV_CMAKE_VARS="
-DCMAKE_INSTALL_PREFIX=${OPENCV_INSTALL_PREFIX}
-DINSTALL_C_EXAMPLES=ON
-DINSTALL_PYTHON_EXAMPLES=ON
-DOPENCV_EXTRA_MODULES_PATH=${OPENCV_CONTRIB_WORKING_DIR_FULL_PATH}/modules
"

# Enter the top build dir
pushd $OPENCV_TOP_DIR

# Clone and prepare contrib repo
git clone $OPENCV_CONTRIB_GIT_URL $OPENCV_CONTRIB_WORKING_DIR
[ $? -ne 0 ] && >&2 echo "ERROR: Unable to clone git repo $OPENCV_CONTRIB_GIT_URL" && exit 1
pushd $OPENCV_CONTRIB_WORKING_DIR
# Make sure opencv_contrib version is the same as opencv version.
git checkout $OPENCV_VERSION
[ $? -ne 0 ] && >&2 echo "ERROR: Unable to checkout git revision $OPENCV_VERSION" && exit 1
popd

# Clone and build opencv
git clone $OPENCV_GIT_URL $OPENCV_WORKING_DIR
[ $? -ne 0 ] && >&2 echo "ERROR: Unable to clone git repo $OPENCV_GIT_URL" && exit 1
pushd $OPENCV_WORKING_DIR
git checkout $OPENCV_VERSION
[ $? -ne 0 ] && >&2 echo "ERROR: Unable to checkout git revision $OPENCV_VERSION" && exit 1
[ -e build ] && rm -rf build
mkdir -p build
cd build
cmake $OPENCV_CMAKE_VARS .. && make -j $OPENCV_J_LEVEL && make install
[ $? -ne 0 ] && >&2 echo "ERROR: opencv build fail!" && exit 1
popd

# Generate environment setup script.
# This script can be sourced by the user if the prefix is a local directory.
cat << EOF > $OPENCV_INSTALL_PREFIX/setup-opencv-env
export PATH=$OPENCV_INSTALL_PREFIX/bin:\$PATH
export LD_LIBRARY_PATH=$OPENCV_INSTALL_PREFIX/lib
EOF

popd #pushd $OPENCV_TOP_DIR
