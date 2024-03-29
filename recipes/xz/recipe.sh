VERSION=5.2.3
TAR=https://codeload.github.com/xz-mirror/xz/tar.gz/v$VERSION

function recipe_version {
    echo "$VERSION"
    skip=1
}

function recipe_update {
    echo "skipping update"
    skip=1
}

function recipe_build {
    export CFLAGS="-static"

    ./autogen.sh
    chmod +w build-aux/config.sub
    wget -O build-aux/config.sub http://git.savannah.gnu.org/cgit/config.git/plain/config.sub
    ./configure \
        --build=${BUILD} \
        --host=${HOST} \
        --prefix=/ \
        --disable-lzmadec \
        --disable-lzmainfo \
        --disable-xz \
        --disable-xzdec \
        --enable-shared=no \
        --enable-static=yes \
        --enable-threads=no \
        --with-pic=no
    make -j"$(nproc)"
    skip=1
}

function recipe_test {
    echo "skipping test"
    skip=1
}

function recipe_clean {
    make clean
    skip=1
}

function recipe_stage {
    dest="$(realpath $1)"
    make DESTDIR="$dest" install
    rm -rf "$dest/share"
    skip=1
}
