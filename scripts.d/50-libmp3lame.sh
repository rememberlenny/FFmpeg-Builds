#!/bin/bash

LAME_SRC="https://fossies.org/linux/misc/lame-3.100.tar.gz"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    mkdir lame
    cd lame
    wget -O lame.tar.gz "$LAME_SRC"
    tar xaf lame.tar.gz
    rm lame.tar.gz
    cd lame*

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-static
        --enable-nasm
        --disable-gtktest
        --disable-cpml
        --disable-frontend
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install
}

ffbuild_configure() {
    echo --enable-libmp3lame
}

ffbuild_unconfigure() {
    echo --disable-libmp3lame
}
