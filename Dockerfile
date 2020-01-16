FROM ubuntu:18.04

# Install (for SANE Backend).
RUN apt-get update >/dev/null && \
	apt-get install -y libusb-1.0-0-dev build-essential libsane-dev && \
	apt-get install -y libavahi-client-dev libavahi-glib-dev && \
	apt-get install -y git-core && \
	apt-get install -y autoconf libtool && \
	rm -rf /var/lib/apt/lists/*

# Compile SANE Backend.
RUN cd root && \
	git clone https://gitlab.com/sane-project/backends.git sane-backends && \
	cd sane-backends && \
	./configure --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu --sysconfdir=/etc --localstatedir=/var  --enable-avahi BACKENDS="kodakaio test" && \
	make

# Create a symbolic link for backend develop.
RUN cd /root/sane-backends/backend && \
	mkdir project && \
	ln -s /root/sane-backends/backend/project /root/project

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root
