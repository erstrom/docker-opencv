FROM ubuntu:16.04

ENV OPENCV_VERSION 3.2.0

RUN apt-get -y upgrade
RUN apt-get -y update

# Build prerequisites
RUN apt-get -y install build-essential cmake pkg-config git libgtk-3-dev \
	libatlas-base-dev gfortran python-dev python-pip

# Image related packages
RUN apt-get -y install libjpeg8-dev libtiff5-dev libjasper-dev libpng12-dev

# Video related packages
RUN apt-get -y install libavcodec-dev libavformat-dev libswscale-dev \
	libv4l-dev libxvidcore-dev libx264-dev

# Other useful tools
RUN apt-get -y install tmux

RUN pip install numpy matplotlib configparser


RUN mkdir -p /opencv/build
WORKDIR /opencv/build
ADD build_opencv.sh /opencv/build/build_opencv.sh
RUN OPENCV_VERSION=$OPENCV_VERSION /opencv/build/build_opencv.sh
WORKDIR /opencv

CMD ["bash"]
