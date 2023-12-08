#!/usr/bin/bash

MATLAB_VERSION=R2023b

if [[ ! -d ./matlab ]]; then
	echo "matlab installation directory not found! Cannot start MATLAB"
	exit 1
fi

docker start matlab || \
	docker run --name matlab \
		   --ipc host \
		   --net host \
		   --env DISPLAY \
		   --mount type=bind,src=/dev/dri,dst=/dev/dri,ro=true \
		   --mount type=bind,src=/tmp/.X11-unix,dst=/tmp/.X11-unix,ro=true \
		   --mount type=bind,src=/home/$USER,dst=/home/$USER,rw=true \
		   --mount type=bind,src=matlab,dst=/usr/local/MATLAB,rw=true \
		   -it \
		   matlab:${MATLAB_VERSION} bash -c "matlab -nosoftwareopengl -useStartupFolderPref"

