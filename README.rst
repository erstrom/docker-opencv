=====================
OpenCV docker dev env
=====================

Installation
++++++++++++

See the official docker documentation for a general overview of docker
and how to install:

https://docs.docker.com/engine/installation/linux/

Build and launch docker image
+++++++++++++++++++++++++++++

Build the docker image, create a container and launch it:

.. code-block:: bash

	git clone https://github.com/erstrom/docker-opencv.git
	cd docker-opencv
	./docker-build.sh
	./docker-run.sh

``docker-build.h`` can be replaced with ``docker-build-eclipse-pydev.sh``
if eclipse + pydev support is wanted.

The eclipse and pydev bundles will be downloaded with the script
``eclipse_pydev_install.sh``.

The download paths can be overridden by setting **ECLIPSE_URL** and
**PYDEV_URL** environment variables from the Dockerfile.

``docker-build.h`` and ``docker-run.sh`` should only be run once unless several
containers are needed. In this case ``docker-run.sh`` must be modified with
different ``--name`` options for each container.

``docker-run.sh`` wraps ``docker run`` and adds a few options for convenience.

Since ``docker-run.sh`` adds the ``-i`` and ``-t`` options, the container will be
launched in interactive mode. In order to leave the interactive session and
stop the running container, type ``exit``

Launch an already created container
+++++++++++++++++++++++++++++++++++

``docker-start.sh`` is used to launch an already created container:

.. code-block:: bash

	cd docker-opencv
	./docker-start.sh

OpenCV
++++++

OpenCV is built from source using the build_opencv.sh script.
It will fetch the source code from the public OpenCV git repositories
and build the version specified by the **OPENCV_VERSION** environment
variable.

**OPENCV_VERSION** must be a valid git tag in both the opencv and
opencv_contrib repositories.
