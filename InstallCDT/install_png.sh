#!/bin/sh
installResources=`pwd`/Resources
scriptResources=$installResources/scripts

productFolder=/Developer/Cocotron/1.0
downloadFolder=$productFolder/Downloads

if [ ""$1"" = "" ];then
  targetPlatform="Windows"
else
  targetPlatform=$1
fi

if [ ""$2"" = "" ];then
  targetArchitecture="i386"
else
  targetArchitecture=$2
fi

if [ ""$3"" = "" ];then
  gccVersion="4.3.1"
else
  gccVersion=$3
fi

BASEDIR=/Developer/Cocotron/1.0/$targetPlatform/$targetArchitecture

BUILD=/tmp/build_png
LIBPNGVERSION=libpng16
VERSION=1.6.17

$scriptResources/downloadFilesIfNeeded.sh $downloadFolder ftp://ftp.simplesystems.org/pub/libpng/png/src/${LIBPNGVERSION}/libpng-${VERSION}.tar.gz

mkdir -p $BUILD
cd $BUILD
tar -xvzf $downloadFolder/libpng-${VERSION}.tar.gz
cd libpng-${VERSION}

pwd 

GCC=$(echo $BASEDIR/gcc-$gccVersion/bin/*gcc)
AS=$(echo $BASEDIR/gcc-$gccVersion/bin/*as)
AR=$(echo $BASEDIR/gcc-$gccVersion/bin/*ar)
RANLIB=$(echo $BASEDIR/gcc-$gccVersion/bin/*ranlib)
TARGET=$($GCC -dumpmachine)



COCOTRON="/Developer/Cocotron/1.0//build/$targetPlatform/$targetArchitecture"
INSTALL_PREFIX="/Developer/Cocotron/1.0/Windows/i386/libpng"
BINARY_PATH="$INSTALL_PREFIX/bin"
INCLUDE_PATH="$INSTALL_PREFIX/include"
LIBRARY_PATH="$INSTALL_PREFIX/lib"

export LDFLAGS="-L$BASEDIR/zlib-1.2.5/lib"
export CFLAGS="-I$BASEDIR/zlib-1.2.5/include"

GCC="$GCC $CFLAGS"

make -p $BINARY_PATH
make -p $LIBRARY_PATH
make -p $INCLUDE_PATH

echo ./configure --prefix="$INSTALL_PREFIX" -host $TARGET AR=$AR CC=$GCC RANLIB=$RANLIB AS=$AS 
./configure --prefix=${INSTALL_PREFIX} --host $TARGET -with-zlib-prefix=$BASEDIR/zlib-1.2.5 AR="$AR" CC="$GCC" RANLIB="$RANLIB" AS="$AS"

echo `pwd`
make && make install

echo $INSTALL_PREFIX
