FROM docker.io/debian:bookworm

ARG MATLAB_VERSION=R2023b

# Fix Matlab window rendering
ENV _JAVA_AWT_WM_NONREPARENTING=1

COPY debian.sources /etc/apt/sources.list.d/

RUN apt update && \
    apt install -y --no-install-recommends \
    	ca-certificates libasound2 libatk-bridge2.0-0 libatk1.0-0 libatspi2.0-0        \
	libc6 libcairo2 libcairo-gobject2 libcap2 libcrypt1 libcrypt-dev libcups2      \
        libdbus-1-3 libdrm2 libfontconfig1 libgbm1 libgdk-pixbuf2.0-0 libglib2.0-0     \
        libgomp1 libgstreamer1.0-0 libgstreamer-plugins-base1.0-0 libgtk-3-0 libnspr4  \
        libnss3 libodbc1 libpam0g libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 \
        libpython3.11 libsm6 libsndfile1 libssl3 libuuid1 libx11-6 libx11-xcb1         \
        libxcb-dri3-0 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6          \
        libxfixes3 libxft2 libxi6 libxinerama1 libxrandr2 libxrender1 libxt6 libxtst6  \
        libxxf86vm1 linux-libc-dev locales locales-all make net-tools procps sudo      \
        unzip wget zlib1g software-properties-common mesa-utils mesa-utils gnupg       \
	ttf-mscorefonts-installer \
	&& \
    apt clean

# Install JRE Hotspot 8
COPY temurin.sources /etc/apt/sources.list.d/
RUN wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public \
	| gpg --dearmor > /usr/share/keyrings/temurin-archive-keyring.gpg && \
    apt update && \
    apt install -y --no-install-recommends \
    	temurin-8-jre

RUN mkdir --mode 777 /usr/local/MATLAB

