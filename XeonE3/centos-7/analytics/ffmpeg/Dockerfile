
FROM centos:centos7 AS build
WORKDIR /home

# COMMON BUILD TOOLS
RUN yum install -y -q bzip2 make autoconf libtool git wget ca-certificates pkg-config gcc gcc-c++ bison flex patch epel-release yum-devel libcurl-devel zlib-devel;

# Install cmake
ARG CMAKE_VER=3.13.1
ARG CMAKE_REPO=https://cmake.org/files
RUN wget -O - ${CMAKE_REPO}/v${CMAKE_VER%.*}/cmake-${CMAKE_VER}.tar.gz | tar xz && \
    cd cmake-${CMAKE_VER} && \
    ./bootstrap --prefix="/usr/local" --system-curl && \
    make -j8 && \
    make install

# Install automake, use version 1.14 on CentOS
ARG AUTOMAKE_VER=1.14
ARG AUTOMAKE_REPO=https://ftp.gnu.org/pub/gnu/automake/automake-${AUTOMAKE_VER}.tar.xz
RUN wget -O - ${AUTOMAKE_REPO} | tar xJ && \
    cd automake-${AUTOMAKE_VER} && \
    ./configure --prefix=/usr --libdir=/usr/local/lib64 --disable-doc && \ 
    make -j8 && \
    make install

# Build NASM
ARG NASM_VER=2.13.03
ARG NASM_REPO=https://www.nasm.us/pub/nasm/releasebuilds/${NASM_VER}/nasm-${NASM_VER}.tar.bz2
RUN  wget ${NASM_REPO} && \
     tar -xaf nasm* && \
     cd nasm-${NASM_VER} && \
     ./autogen.sh && \
     ./configure --prefix="/usr/local" --libdir=/usr/local/lib64 && \
     make -j8 && \
     make install

# Build YASM
ARG YASM_VER=1.3.0
ARG YASM_REPO=https://www.tortall.net/projects/yasm/releases/yasm-${YASM_VER}.tar.gz
RUN  wget -O - ${YASM_REPO} | tar xz && \
     cd yasm-${YASM_VER} && \
     sed -i "s/) ytasm.*/)/" Makefile.in && \
     ./configure --prefix="/usr/local" --libdir=/usr/local/lib64 && \
     make -j8 && \
     make install

# Build ogg
ARG OGG_VER=1.3.3
ARG OGG_REPO=https://downloads.xiph.org/releases/ogg/libogg-${OGG_VER}.tar.xz

RUN wget -O - ${OGG_REPO} | tar xJ && \
    cd libogg-${OGG_VER} && \
    ./configure --prefix="/usr/local" --libdir=/usr/local/lib64 --enable-shared && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

# Build vorbis
ARG VORBIS_VER=1.3.6
ARG VORBIS_REPO=https://downloads.xiph.org/releases/vorbis/libvorbis-${VORBIS_VER}.tar.xz

RUN wget -O - ${VORBIS_REPO} | tar xJ && \
    cd libvorbis-${VORBIS_VER} && \
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib64 && \
    ./configure --prefix="/usr/local" --libdir=/usr/local/lib64 --enable-shared && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

# Build mp3lame
ARG MP3LAME_VER=3.100
ARG MP3LAME_REPO=https://sourceforge.net/projects/lame/files/lame/${MP3LAME_VER}/lame-${MP3LAME_VER}.tar.gz

RUN wget -O - ${MP3LAME_REPO} | tar xz && \
    cd lame-${MP3LAME_VER} && \
    ./configure --prefix="/usr/local" --libdir=/usr/local/lib64 --enable-shared --enable-nasm && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

# Build fdk-aac
ARG FDK_AAC_VER=v0.1.6
ARG FDK_AAC_REPO=https://github.com/mstorsjo/fdk-aac/archive/${FDK_AAC_VER}.tar.gz

RUN wget -O - ${FDK_AAC_REPO} | tar xz && mv fdk-aac-${FDK_AAC_VER#v} fdk-aac && \
    cd fdk-aac && \
    autoreconf -fiv && \
    ./configure --prefix="/usr/local" --libdir=/usr/local/lib64 --enable-shared && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install


# Build opus
ARG OPUS_VER=1.2.1
ARG OPUS_REPO=https://archive.mozilla.org/pub/opus/opus-${OPUS_VER}.tar.gz

RUN wget -O - ${OPUS_REPO} | tar xz && \
    cd opus-${OPUS_VER} && \
    ./configure --prefix="/usr/local" --libdir=/usr/local/lib64 --enable-shared && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

# Build vpx
ARG VPX_VER=tags/v1.7.0
ARG VPX_REPO=https://chromium.googlesource.com/webm/libvpx.git

RUN git clone ${VPX_REPO} && \
    cd libvpx && \
    git checkout ${VPX_VER} && \
    ./configure --prefix="/usr/local" --libdir=/usr/local/lib64 --enable-shared --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=nasm && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install


# Build x264
ARG X264_VER=stable
ARG X264_REPO=https://github.com/mirror/x264

RUN  git clone ${X264_REPO} && \
     cd x264 && \
     git checkout ${X264_VER} && \
     ./configure --prefix="/usr/local" --libdir=/usr/local/lib64 --enable-shared && \
     make -j8 && \
     make install DESTDIR="/home/build" && \
     make install


# Build x265
ARG X265_VER=2.9
ARG X265_REPO=https://github.com/videolan/x265/archive/${X265_VER}.tar.gz

RUN  yum install -y -q numactl-devel libpciaccess-devel

RUN  wget -O - ${X265_REPO} | tar xz && mv x265-${X265_VER} x265 && \
     cd x265/build/linux && \
     cmake -DBUILD_SHARED_LIBS=ON -DENABLE_TESTS=OFF -DCMAKE_INSTALL_PREFIX=/usr/local -DLIB_INSTALL_DIR=/usr/local/lib64 ../../source && \
     make -j8 && \
     make install DESTDIR="/home/build" && \
     make install

# Install required packges
RUN yum install -y ninja-build python36-setuptools

# Build Meson
ARG MESON_VER=0.53.1
ARG MESON_REPO=https://github.com/mesonbuild/meson

RUN git clone ${MESON_REPO}; \
    cd meson; \
    git checkout ${MESON_VER}; \
    python3.6 setup.py install;

# Build dav1d
ARG LIBDAV1D_VER=0.5.2
ARG LIBDAV1D_REPO=https://code.videolan.org/videolan/dav1d.git

RUN  git clone ${LIBDAV1D_REPO}; \
     cd dav1d; \
     git checkout ${LIBDAV1D_VER}; \
     meson build --prefix /usr --libdir /usr/lib64 --buildtype release; \
     ninja-build -C build; \
     cd build; \
     DESTDIR="/home/build" ninja-build install; \
     ninja-build install;


# Fetch SVT-HEVC
ARG SVT_HEVC_VER=v1.5.0
ARG SVT_HEVC_REPO=https://github.com/intel/SVT-HEVC

RUN yum install -y -q patch centos-release-scl && \
    yum install -y -q devtoolset-7

# hadolint ignore=SC1091
RUN git clone ${SVT_HEVC_REPO} && \
    cd SVT-HEVC/Build/linux && \
    export PKG_CONFIG_PATH="/usr/local/lib64/pkgconfig" && \
    git checkout ${SVT_HEVC_VER} && \
    mkdir -p ../../Bin/Release && \
    ( source /opt/rh/devtoolset-7/enable && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_LIBDIR=lib64 -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install )


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
    ( source /opt/rh/devtoolset-7/enable && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_LIBDIR=lib64 -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install )

#Remove build residue from SVT-AV1 build -- temp fix for bug
RUN if [ -d "build/home/" ]; then rm -rf build/home/; fi


# Fetch SVT-VP9
ARG SVT_VP9_VER=v0.2.1
ARG SVT_VP9_REPO=https://github.com/OpenVisualCloud/SVT-VP9

# hadolint ignore=SC1091
RUN git clone ${SVT_VP9_REPO} && \
    cd SVT-VP9/Build/linux && \
    git checkout ${SVT_VP9_VER} && \
    mkdir -p ../../Bin/Release && \
  ( source /opt/rh/devtoolset-7/enable && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_LIBDIR=lib64 -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install )


# Fetch gmmlib
ARG GMMLIB_VER=intel-gmmlib-18.3.0
ARG GMMLIB_REPO=https://github.com/intel/gmmlib/archive/${GMMLIB_VER}.tar.gz

RUN wget -O - ${GMMLIB_REPO} | tar xz && mv gmmlib-${GMMLIB_VER} gmmlib;


# Build libdrm
ARG LIBDRM_VER=2.4.96
ARG LIBDRM_REPO=https://dri.freedesktop.org/libdrm/libdrm-${LIBDRM_VER}.tar.gz

RUN yum install -y -q libpciaccess-devel

RUN wget -O - ${LIBDRM_REPO} | tar xz && \
    cd libdrm-${LIBDRM_VER} && \
    ./configure --prefix=/usr/local --libdir=/usr/local/lib64 && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install ;


# Build libva
ARG LIBVA_VER=2.4.0
ARG LIBVA_REPO=https://github.com/intel/libva/archive/${LIBVA_VER}.tar.gz

RUN yum install -y -q libX11-devel mesa-libGL-devel which libdrm-devel

RUN wget -O - ${LIBVA_REPO} | tar xz && \
    cd libva-${LIBVA_VER} && \
    ./autogen.sh --prefix=/usr/local --libdir=/usr/local/lib64 && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install;


# Build libva-utils
ARG LIBVA_UTILS_VER=2.4.0
ARG LIBVA_UTILS_REPO=https://github.com/intel/libva-utils/archive/${LIBVA_UTILS_VER}.tar.gz

RUN wget -O - ${LIBVA_UTILS_REPO} | tar xz; \
    cd libva-utils-${LIBVA_UTILS_VER}; \
    export PKG_CONFIG_PATH="/usr/local/lib64/pkgconfig"; \
    ./autogen.sh --prefix=/usr/local --libdir=/usr/local/lib64; \
    make -j8; \
    make install DESTDIR=/home/build; \
    make install;


# Build media driver
ARG MEDIA_DRIVER_VER=intel-media-kbl-19.1.1
ARG MEDIA_DRIVER_REPO=https://github.com/VCDP/media-driver/archive/${MEDIA_DRIVER_VER}.tar.gz

RUN yum install -y -q libX11-devel mesa-libGL-devel libpciaccess-devel libXext-devel

RUN wget -O - ${MEDIA_DRIVER_REPO} | tar xz && mv media-driver-${MEDIA_DRIVER_VER} media-driver && \
    mkdir -p media-driver/build && \
    cd media-driver/build && \
    export PKG_CONFIG_PATH="/usr/local/lib64/pkgconfig" && \
    cmake -DBUILD_TYPE=release -DBUILD_ALONG_WITH_CMRTLIB=1 -DMEDIA_VERSION="2.0.0" -DBS_DIR_GMMLIB=/home/gmmlib/Source/GmmLib -DBS_DIR_COMMON=/home/gmmlib/Source/Common -DBS_DIR_INC=/home/gmmlib/Source/inc -DBS_DIR_MEDIA=/home/media-driver -Wno-dev -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install



# Build Intel(R) Media SDK
ARG MSDK_VER=MSS-KBL-2019-R1-HF1
ARG MSDK_REPO=https://github.com/Intel-Media-SDK/MediaSDK/archive/${MSDK_VER}.tar.gz

RUN wget -O - ${MSDK_REPO} | tar xz && mv MediaSDK-${MSDK_VER} MediaSDK && \
    mkdir -p MediaSDK/build && \
    cd MediaSDK/build && \
    export PKG_CONFIG_PATH="/usr/local/lib64/pkgconfig" && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_INCLUDEDIR=include -DBUILD_SAMPLES=OFF -DENABLE_OPENCL=OFF -Wno-dev .. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    rm -rf /home/build/usr/samples && \
    rm -rf /home/build/usr/plugins && \
    rm -rf /home/build/usr/local/samples && \
    rm -rf /home/build/usr/local/plugins && \
    make install;

#install OpenCL


RUN yum install -y -q dnf dnf-plugins-core
RUN yum install -y yum-plugin-copr
RUN yum copr enable -y jdanecki/intel-opencl
RUN yum install -y intel-opencl
RUN yum install -y ocl-icd libgomp

#clinfo needs to be installed after build directory is copied over

# Build libjson-c
ARG LIBJSONC_VER=0.13.1-20180305
ARG LIBJSONC_REPO=https://github.com/json-c/json-c/archive/json-c-${LIBJSONC_VER}.tar.gz

RUN wget -O - ${LIBJSONC_REPO} | tar xz && \
    cd json-c-json-c-${LIBJSONC_VER} && \
    sh autogen.sh && \
    ./configure --prefix=/usr/local --libdir=/usr/local/lib64 && \
    make -j8 && \
    make install DESTDIR="/home/build" && \
    make install;

# Build librdkafka
ARG LIBRDKAFKA_VER=1.0.0
ARG FILE_NAME=v${LIBRDKAFKA_VER}
ARG LIBRDKAFKA_REPO=https://github.com/edenhill/librdkafka/archive/${FILE_NAME}.tar.gz

RUN wget -O - ${LIBRDKAFKA_REPO} | tar xz && \
    cd librdkafka-${LIBRDKAFKA_VER} && \
    ./configure --prefix=/usr/local --libdir=/usr/local/lib64 && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install;

ARG OPENCV_VER=4.5.0
ARG OPENCV_REPO=https://github.com/opencv/opencv/archive/${OPENCV_VER}.tar.gz

RUN yum install -y -q eigen3-devel

RUN wget "${OPENCV_REPO}" && \
    tar -zxvf ${OPENCV_VER}.tar.gz && \
    cd opencv-${OPENCV_VER} && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DOPENCV_GENERATE_PKGCONFIG=ON -DBUILD_EXAMPLES=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_DOCS=OFF -DBUILD_TESTS=OFF .. && \
    make -j "$(nproc)" && \
    make install DESTDIR=/home/build && \
    make install


# Build DLDT-Inference Engine
ARG DLDT_VER=2021.1
ARG DLDT_REPO=https://github.com/openvinotoolkit/openvino.git

RUN yum install -y -q boost-devel glibc-static glibc-devel libstdc++-static libstdc++-devel libstdc++ libgcc libusbx-devel openblas-devel;

RUN git clone -b ${DLDT_VER} ${DLDT_REPO} && \
    cd openvino && \
    git submodule update --init --recursive && \
    mkdir build && \
    cd build && \
    cmake  -DCMAKE_INSTALL_PREFIX=/opt/intel/dldt -DLIB_INSTALL_PATH=/opt/intel/dldt -DENABLE_MKL_DNN=ON -DENABLE_CLDNN=ON -DENABLE_SAMPLES=OFF -DENABLE_OPENCV=OFF -DENABLE_TESTS=OFF -DENABLE_GNA=OFF -DENABLE_PROFILING_ITT=OFF -DENABLE_SAMPLES_CORE=OFF -DENABLE_SEGMENTATION_TESTS=OFF -DENABLE_OBJECT_DETECTION_TESTS=OFF -DBUILD_TESTS=OFF -DNGRAPH_UNIT_TEST_ENABLE=OFF -DNGRAPH_TEST_UTIL_ENABLE=OFF .. && \
    make -j "$(nproc)" && \
    rm -rf ../bin/intel64/Release/lib/libgtest* && \
    rm -rf ../bin/intel64/Release/lib/libgmock* && \
    rm -rf ../bin/intel64/Release/lib/libmock* && \
    rm -rf ../bin/intel64/Release/lib/libtest*

ARG libdir=/opt/intel/dldt/inference-engine/lib/intel64

RUN mkdir -p /opt/intel/dldt/inference-engine/include && \
    cp -r openvino/inference-engine/include/* /opt/intel/dldt/inference-engine/include && \
    cp -r openvino/inference-engine/ie_bridges/c/include/* /opt/intel/dldt/inference-engine/include && \
    mkdir -p ${libdir} && \
    cp -r openvino/bin/intel64/Release/lib/* ${libdir} && \
    mkdir -p /opt/intel/dldt/inference-engine/src && \
    cp -r openvino/inference-engine/src/* /opt/intel/dldt/inference-engine/src/ && \
    mkdir -p /opt/intel/dldt/inference-engine/share && \
    cp -r openvino/build/share/* /opt/intel/dldt/inference-engine/share/ && \
    mkdir -p /opt/intel/dldt/inference-engine/external/ && \
    cp -r openvino/inference-engine/temp/tbb /opt/intel/dldt/inference-engine/external/

RUN mkdir -p build${libdir} && \
    cp -r openvino/bin/intel64/Release/lib/* build${libdir} && \
    mkdir -p build/opt/intel/dldt/inference-engine/external/ && \
    cp -r openvino/inference-engine/temp/tbb build/opt/intel/dldt/inference-engine/external/

RUN for p in /usr /home/build/usr /opt/intel/dldt/inference-engine /home/build/opt/intel/dldt/inference-engine; do \
        pkgconfiglibdir="$p/lib64" && \
        mkdir -p "${pkgconfiglibdir}/pkgconfig" && \
        pc="${pkgconfiglibdir}/pkgconfig/dldt.pc" && \
        echo "prefix=/opt" > "$pc" && \
        echo "libdir=${libdir}" >> "$pc" && \
        echo "includedir=/opt/intel/dldt/inference-engine/include" >> "$pc" && \
        echo "" >> "$pc" && \
        echo "Name: DLDT" >> "$pc" && \
        echo "Description: Intel Deep Learning Deployment Toolkit" >> "$pc" && \
        echo "Version: 5.0" >> "$pc" && \
        echo "" >> "$pc" && \
        echo "Libs: -L\${libdir} -linference_engine" >> "$pc" && \
        echo "Cflags: -I\${includedir}" >> "$pc"; \
    done;

ARG local_lib_path="/usr/local/lib64"
ENV PKG_CONFIG_PATH=${local_lib_path}/pkgconfig:$PKG_CONFIG_PATH
ENV InferenceEngine_DIR=/opt/intel/dldt/inference-engine/share
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/dldt/inference-engine/lib:/opt/intel/dldt/inference-engine/external/tbb/lib:${libdir}


#install Model Optimizer in the DLDT for Dev

ENV PYTHONIOENCODING=UTF-8


# Fetch FFmpeg source
ARG FFMPEG_VER=n4.2.2
ARG FFMPEG_REPO=https://github.com/FFmpeg/FFmpeg/archive/${FFMPEG_VER}.tar.gz
ARG FFMPEG_1TN_PATCH_REPO=https://patchwork.ffmpeg.org/patch/11625/raw

ARG FFMPEG_PATCHES_RELEASE_VER=0.2
ARG FFMPEG_PATCHES_RELEASE_URL=https://github.com/VCDP/CDN/archive/v${FFMPEG_PATCHES_RELEASE_VER}.tar.gz
ARG FFMPEG_PATCHES_PATH=/home/CDN-${FFMPEG_PATCHES_RELEASE_VER}
RUN wget -O - ${FFMPEG_PATCHES_RELEASE_URL} | tar xz


ARG FFMPEG_MA_RELEASE_VER=0.5
ARG FFMPEG_MA_RELEASE_URL=https://github.com/VCDP/FFmpeg-patch/archive/v${FFMPEG_MA_RELEASE_VER}.tar.gz
ARG FFMPEG_MA_PATH=/home/FFmpeg-patch-${FFMPEG_MA_RELEASE_VER}
RUN wget -O - ${FFMPEG_MA_RELEASE_URL} | tar xz
RUN cp ${FFMPEG_MA_PATH}/docker/patch/opencv.pc /usr/lib/pkgconfig
ARG CVDEF_H=/usr/local/include/opencv4/opencv2/core/cvdef.h
RUN if [ -f "${CVDEF_H}" ]; then cp ${FFMPEG_MA_PATH}/docker/patch/cvdef.h ${CVDEF_H}; fi

RUN yum install -y -q libass-devel freetype-devel SDL2-devel libxcb-devel libvdpau-devel zlib-devel openssl-devel

RUN wget -O - ${FFMPEG_REPO} | tar xz && mv FFmpeg-${FFMPEG_VER} FFmpeg && \
    cd FFmpeg && \
    find ${FFMPEG_PATCHES_PATH}/FFmpeg_patches -type f -name '*.patch' -print0 | sort -z | xargs -t -0 -n 1 patch -p1 -i && \
    find ${FFMPEG_MA_PATH}/patches -type f -name '*.patch' -print0 | sort -z | xargs -t -0 -n 1 patch -p1 -i;

# Patch FFmpeg source for SVT-HEVC
RUN cd /home/FFmpeg && \
    patch -p1 < ../SVT-HEVC/ffmpeg_plugin/0001-lavc-svt_hevc-add-libsvt-hevc-encoder-wrapper.patch;

# Patch FFmpeg source for SVT-AV1
ARG SVT_AV1_FFMPEG_PLUGIN_VER=0.8.4
ARG SVT_AV1_FFMPEG_PLUGIN_REPO=https://github.com/AOMediaCodec/SVT-AV1/archive/v${SVT_AV1_FFMPEG_PLUGIN_VER}.tar.gz
RUN cd /home/FFmpeg; \
    wget -O - ${SVT_AV1_FFMPEG_PLUGIN_REPO} | tar xz -C /home; \
    patch -p1 < ../SVT-AV1-${SVT_AV1_FFMPEG_PLUGIN_VER}/ffmpeg_plugin/0001-Add-ability-for-ffmpeg-to-run-svt-av1.patch;

# Patch FFmpeg source for SVT-VP9
RUN cd /home/FFmpeg; \
    git apply ../SVT-VP9/ffmpeg_plugin/0001-Add-ability-for-ffmpeg-to-run-svt-vp9.patch;

# Compile FFmpeg
RUN cd /home/FFmpeg && \
    export PKG_CONFIG_PATH="/usr/local/lib64/pkgconfig" && \
    ./configure --prefix="/usr/local" --extra-cflags="-I/opt/intel/dldt/inference-engine/include -I/usr/local/include/opencv4 " --extra-ldflags="-L/opt/intel/dldt/inference-engine/lib/intel64 " --libdir=/usr/local/lib64 --extra-libs="-lpthread -lm" --enable-shared --enable-gpl --enable-libass --enable-libfreetype  --enable-openssl --enable-nonfree --enable-libdrm --enable-libmfx --disable-doc --disable-htmlpages --disable-manpages --disable-podpages --disable-txtpages --enable-libfdk-aac --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 --enable-libdav1d --enable-libsvthevc --enable-libsvtav1 --enable-libsvtvp9 --enable-libinference_engine_c_api --enable-librdkafka --enable-libjson_c --enable-libopencv  && \
    make -j8 && \
    make install && make install DESTDIR="/home/build"



# remake opencv videoio to incorporate ffmpeg/gst
RUN cd opencv-${OPENCV_VER}/build && \
    rm -rf ./* && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DOPENCV_GENERATE_PKGCONFIG=ON -DBUILD_EXAMPLES=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_DOCS=OFF -DBUILD_TESTS=OFF .. && \
    cd modules/videoio && \
    make -j "$(nproc)" && \
    cp -f ../../lib/libopencv_videoio.so.${OPENCV_VER} /home/build/usr/local/lib

# Clean up after build
RUN rm -rf /home/build/usr/include && \
    rm -rf /home/build/usr/share/doc && \
    rm -rf /home/build/usr/share/gtk-doc && \
    rm -rf /home/build/usr/share/man && \
    rm -rf /home/build/usr/local/include && \
    rm -rf /home/build/usr/local/share/doc && \
    rm -rf /home/build/usr/local/share/gtk-doc && \
    rm -rf /home/build/usr/local/share/man && \
    find /home/build -name "*.a" -exec rm -f {} \;

FROM centos:centos7
LABEL Description="This is the base image for FFMPEG & DLDT CentOS 7.6"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Prerequisites
RUN yum install -y epel-release;  \
    yum install -y -q   libxcb SDL2 libass numactl libvdpau  libpciaccess libpciaccess libX11 mesa-dri-drivers mesa-libGL libdrm  ; \
    yum remove -y -q epel-release; \
    rm -rf /var/cache/yum/*;

# Install
COPY --from=build /home/build /
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib:/usr/local/lib64
ENV LIBVA_DRIVERS_PATH=/usr/local/lib64/dri
ENV LIBVA_DRIVER_NAME=iHD
RUN yum install -y -q dnf dnf-plugins-core yum-plugin-copr
RUN yum copr enable -y jdanecki/intel-opencl
RUN yum install -y intel-opencl
RUN yum install -y ocl-icd libgomp
RUN ln -s /usr/lib64/libOpenCL.so.1 /usr/lib/libOpenCL.so
ARG local_lib_path="/usr/local/lib64"
ARG libdir=/opt/intel/dldt/inference-engine/lib/intel64
ENV PKG_CONFIG_PATH=${local_lib_path}/pkgconfig:$PKG_CONFIG_PATH
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/dldt/inference-engine/lib:/opt/intel/dldt/inference-engine/external/tbb/lib:${libdir}

ENV PYTHONIOENCODING=UTF-8

