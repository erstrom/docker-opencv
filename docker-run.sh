#! /bin/sh
#

# Fix for running GUI programs from within the docker container:
#
# Make xorg disable access control, i.e. let any x client connect to our
# server.
xhost +

# In order to let the container connect to the pulseaudio server over TCP,
# the module-native-protocol-tcp module must be enabled:
#
# load-module module-native-protocol-tcp

# 172.17.0.1 is the default host ip address of the docker network interface
# (docker0). In case this is changed (e.g. docker container not using NAT
# address) the below env var must of course be updated.
PULSE_SERVER_TCP_ENV="-e PULSE_SERVER=tcp:172.17.0.1:4713"

docker run -it \
	--privileged \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-e DISPLAY=unix$DISPLAY \
	$PULSE_SERVER_TCP_ENV \
	--name opencv-dev \
	erstrom/opencv
