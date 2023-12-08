#!/usr/bin/bash

set -e

MATLAB_VERSION=R2023b

# Cleanup all
docker rm matlab{,_install} || true

# Build base image
docker build -f Dockerfile -t matlab-base:${MATLAB_VERSION} .

xhost +

if [[ -d ./matlab ]]; then
	read -p "matlab directory found. Uninstall? [Y/n]: " yn
	if [[ "$yn" == [Nn]* ]]; then 
		echo Aborted.
		exit 1
	fi
	rm -rf matlab
fi
mkdir matlab

if [[ -d ./matlab_install ]]; then
	read -p "matlab_install directory found. Recreate it? [y/N]: " yn
	if [[ "$yn" == [Yy]* ]]; then
		rm -rf matlab_install
		mkdir matlab_install
		unzip -qd matlab_install/ matlab_${MATLAB_VERSION}_glnxa64.zip
	fi
else
	mkdir matlab_install
	unzip -qd matlab_install/ matlab_${MATLAB_VERSION}_glnxa64.zip
fi

docker run --name matlab_install \
	   --ipc host \
	   --net host \
	   --env DISPLAY \
	   --mount type=bind,src=/dev/dri,dst=/dev/dri,ro=true \
	   --mount type=bind,src=/tmp/.X11-unix,dst=/tmp/.X11-unix,ro=true \
	   --mount type=bind,src=/home/$USER,dst=/home/$USER,rw=true \
	   --mount type=bind,src=matlab,dst=/usr/local/MATLAB,rw=true \
	   --mount type=bind,src=matlab_install,dst=/opt/matlab_install,ro=true \
	   -it \
	   matlab-base:${MATLAB_VERSION} bash -c "/opt/matlab_install/install && apt install -y matlab-support"

docker commit matlab_install matlab:${MATLAB_VERSION}

rm -rf matlab_install
docker rm matlab_install

