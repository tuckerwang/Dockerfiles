# Fetch SVT-AV1
ARG SVT_AV1_VER=v0.8.5
ARG SVT_AV1_REPO=https://github.com/AOMediaCodec/SVT-AV1

ARG SVT_AV1_PATCHES_RELEASE_VER=0.4
ARG SVT_AV1_PATCHES_RELEASE_URL=https://github.com/VCDP/CDN/archive/v${SVT_AV1_PATCHES_RELEASE_VER}.tar.gz
ARG SVT_AV1_PATCHES_PATH=/home/CDN-${SVT_AV1_PATCHES_RELEASE_VER}
RUN wget -O - ${SVT_AV1_PATCHES_RELEASE_URL} | tar xz

# hadolint ignore=SC1091
RUN git clone ${SVT_AV1_REPO} && \
    cd SVT-AV1 && \
    git checkout ${SVT_AV1_VER} && \
    cd Build/linux && \
    mkdir -p ../../Bin/Release && \
ifelse(index(DOCKER_IMAGE,centos),-1,,`dnl
    ( source /opt/rh/devtoolset-7/enable && \
')dnl
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_LIBDIR=ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install ifelse(index(DOCKER_IMAGE,centos),-1,,`)')

#Remove build residue from SVT-AV1 build -- temp fix for bug
RUN if [ -d "build/home/" ]; then rm -rf build/home/; fi

define(`FFMPEG_SOURCE_SVT_AV1',dnl
# Patch FFmpeg source for SVT-AV1
ARG SVT_AV1_FFMPEG_PLUGIN_VER=0.8.4
ARG SVT_AV1_FFMPEG_PLUGIN_REPO=https://github.com/AOMediaCodec/SVT-AV1/archive/v${SVT_AV1_FFMPEG_PLUGIN_VER}.tar.gz
RUN cd /home/FFmpeg; \
    wget -O - ${SVT_AV1_FFMPEG_PLUGIN_REPO} | tar xz -C /home; \
    patch -p1 < ../SVT-AV1-${SVT_AV1_FFMPEG_PLUGIN_VER}/ffmpeg_plugin/0001-Add-ability-for-ffmpeg-to-run-svt-av1.patch;

)dnl
define(`FFMPEG_CONFIG_SVT_AV1',--enable-libsvtav1 )dnl
