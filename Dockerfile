FROM ubuntu:16.04

ENV OPENCV_VERSION 3.2.0

# If INSTALL_ECLIPSE is set, eclipse + pydev will be installed
ARG INSTALL_ECLIPSE=0

RUN apt-get -y upgrade
RUN apt-get -y update

# Build prerequisites
RUN apt-get -y install build-essential cmake pkg-config git libgtk-3-dev \
	libatlas-base-dev gfortran python3 python3.5-dev

# Image related packages
RUN apt-get -y install libjpeg8-dev libtiff5-dev libjasper-dev libpng12-dev

# Video related packages
RUN apt-get -y install libavcodec-dev libavformat-dev libswscale-dev \
	libv4l-dev libxvidcore-dev libx264-dev

# Other useful tools
RUN apt-get -y install tmux wget zip

# Eclipse prerequisites
RUN [ $INSTALL_ECLIPSE -ne 0 ] && apt-get -y install openjdk-9-jre || /bin/true

RUN mkdir -p /opencv/build

WORKDIR /opencv/build
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py
RUN pip3 install numpy matplotlib configparser imutils
# pudb debugger
RUN pip3 install pudb

ADD build_opencv.sh /opencv/build/build_opencv.sh
RUN OPENCV_VERSION=$OPENCV_VERSION /opencv/build/build_opencv.sh
ADD eclipse_pydev_install.sh /opencv/build/eclipse_pydev_install.sh
RUN [ $INSTALL_ECLIPSE -ne 0 ] && /opencv/build/eclipse_pydev_install.sh || /bin/true
WORKDIR /opencv

# Add tab completion for pdb
RUN echo 'import rlcompleter' > /root/.pdbrc
RUN echo 'pdb.Pdb.complete = rlcompleter.Completer(locals()).complete' >> /root/.pdbrc

CMD ["bash"]
