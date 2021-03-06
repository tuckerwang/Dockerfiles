This docker image is part of Open Visual Cloud software stacks. This is development image aim towards enabling C++ application compilation, debugging (with the debugging, profiling tools) and optimization (with the optimization tools.) You can compile C++ applications with this image and then copy the applications to the corresponding deployment image. Included what are in FFmpeg or GStreamer media creation and delivery images . The docker image can be used in the FROM field of a downstream Dockerfile. 

## Supported tags and respective Dockerfile links
 - [xeon-ubuntu-1804-media-dev](https://github.com/OpenVisualCloud/Dockerfiles/blob/master/Xeon/ubuntu-18.04/media/dev/Dockerfile)

## Quick reference
- #### Supported platform and OS
  Intel&reg; Xeon&reg; platform, Ubuntu 18.04

- #### Usage instructions:
  [FFmpeg](https://github.com/OpenVisualCloud/Dockerfiles/blob/master/doc/ffmpeg.md)	[GStreamer](https://github.com/OpenVisualCloud/Dockerfiles/blob/master/doc/gst.md)	


- #### Getting started with Dockerfiles:
  [OpenVisualCloud Dockerfiles Wiki](https://github.com/OpenVisualCloud/Dockerfiles/wiki)

- #### File issues:
  [OpenVisualCloud Dockerfiles Issues](https://github.com/OpenVisualCloud/Dockerfiles/issues)


## License
This docker installs third party components licensed under various open source licenses.  The terms under which those components may be used and distributed can be found with the license document that is provided with those components.  Please familiarize yourself with those terms to ensure your distribution of those components complies with the terms of those licenses.


| Components | License |
| ----- | ----- |
|Ubuntu| [Various](https://hub.docker.com/_/ubuntu) |
|libogg|BSD 3-clause "New" or "Revised" License|
|libvorbis|BSD 3-clause "New" or "Revised" License|
|Opus Interactive Audio Codec|BSD 3-clause "New" or "Revised" License|
|libvpx|BSD 3-clause "New" or "Revised" License|
|Aomedia AV1 Codec Library|BSD 2-clause "Simplified" License|
|x264|GNU General Public License v2.0 or later|
|x265|GNU General Public License v2.0 or later|
|dav1d|BSD 2-clause "Simplified" License|
|Intel SVT-HEVC|BSD-2-Clause Plus Patent License|
|Intel SVT-AV1|BSD-2-Clause Plus Patent License|
|Intel SVT-VP9|BSD-2-Clause Plus Patent License|
|gstreamer|GNU Lesser General Public License v2.1 or later|
|gst plugin base|GNU Lesser General Public License v2.1 or later|
|gst plugin good|GNU Lesser General Public License v2.1 or later|
|gst plugin bad|GNU Lesser General Public License v2.1 or later|
|gst plugin ugly|GNU Lesser General Public License v2.1 or later|
|gst plugin libav|GNU Library General Public License Version 2|
|gst plugin svt|GNU Lesser General Public License v2.1 or later|
|FFmpeg|GNU Lesser General Public License v2.1 or later|


More license information can be found in [components source package](https://github.com/OpenVisualCloud/Dockerfiles-Resources).   
As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses and potential fees for all software contained within. We will have no indemnity or warranty coverage from suppliers.
