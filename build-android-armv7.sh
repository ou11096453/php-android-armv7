#!/usr/bin/env bash
set -Eeuo pipefail
PHP_VERSION=7.3.22
NDK_VERSION=25.2.9519653
ROOT=$(pwd)
WORK=$ROOT/.build/android-armv7
PREFIX=$WORK/prefix
SYSROOT=$ANDROID_HOME/ndk/$NDK_VERSION/toolchains/llvm/prebuilt/linux-x86_64
HOST=armv7a-linux-androideabi21
export PATH=$SYSROOT/bin:$PATH CC=$SYSROOT/bin/$HOST-clang CXX=$SYSROOT/bin/$HOST-clang++ AR=$SYSROOT/bin/llvm-ar RANLIB=$SYSROOT/bin/llvm-ranlib STRIP=$SYSROOT/bin/llvm-strip
mkdir -p $WORK $PREFIX dist
fetch(){ curl --fail --location --retry 3 --output $2 $1; }
fetch https://zlib.net/fossils/zlib-1.2.13.tar.gz $WORK/zlib.tgz; tar -xf $WORK/zlib.tgz -C $WORK; cd $WORK/zlib-1.2.13; CHOST=$HOST ./configure --static --prefix=$PREFIX; make -j2; make install
fetch https://www.openssl.org/source/old/1.1.1/openssl-1.1.1w.tar.gz $WORK/openssl.tgz; tar -xf $WORK/openssl.tgz -C $WORK; cd $WORK/openssl-1.1.1w; ./Configure linux-generic32 -D__ANDROID_API__=21 no-shared no-tests --prefix=$PREFIX; make -j2; make install_sw
fetch https://curl.se/download/curl-7.79.1.tar.xz $WORK/curl.txz; tar -xf $WORK/curl.txz -C $WORK; cd $WORK/curl-7.79.1; ./configure --host=$HOST --prefix=$PREFIX --disable-shared --enable-static --with-ssl=$PREFIX --with-zlib=$PREFIX --disable-ldap --disable-rtsp --disable-dict --disable-telnet --disable-tftp --disable-pop3 --disable-imap --disable-smb --disable-gopher --disable-manual; make -j2; make install
fetch https://www.php.net/distributions/php-7.3.22.tar.gz $WORK/php.tgz; tar -xf $WORK/php.tgz -C $WORK; cd $WORK/php-7.3.22; ./buildconf --force
LDFLAGS="-static-libgcc -L$PREFIX/lib" CPPFLAGS="-I$PREFIX/include" PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig ./configure --host=$HOST --prefix=/php --disable-all --enable-cli --enable-cgi --enable-mbstring --enable-json --enable-filter --enable-pcre --enable-session --enable-libxml --enable-xml --with-curl=$PREFIX --with-openssl=$PREFIX --with-zlib=$PREFIX --without-sqlite3 --without-pdo --disable-phpdbg --disable-fpm --disable-maintainer-mode
make -j2; make INSTALL_ROOT=$WORK/stage install; mkdir -p $WORK/package/bin $WORK/package/runner; cp $WORK/stage/php/bin/php $WORK/package/bin/php; cp $ROOT/runner/runner.php $ROOT/runner/spider.php $WORK/package/runner/; chmod 0755 $WORK/package/bin/php; $WORK/package/bin/php -v; $WORK/package/bin/php -m; file $WORK/package/bin/php; (cd $WORK/package && zip -9 -r $ROOT/dist/php-7.3.22-android-armeabi-v7a.zip bin runner)
