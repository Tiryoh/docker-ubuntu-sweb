ARG BASE_TAG

FROM ubuntu:${BASE_TAG}

ENV DEBIAN_FRONTEND noninteractive

####################
# Upgrade
####################
RUN apt-get update -q \
    && apt-get upgrade -y \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

####################
# Add Ubuntu Mate
####################
RUN apt-get update -q \
    && apt-get upgrade -y \
    && apt-get install -y \
        ubuntu-mate-desktop \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

####################
# Add Package
####################
RUN apt-get update \
    && apt-get install -y \
        tigervnc-standalone-server tigervnc-common \
        supervisor wget curl gosu git sudo python3-pip tini \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

####################
# noVNC and Websockify
####################
RUN git clone https://github.com/AtsushiSaito/noVNC.git -b add_clipboard_support /usr/lib/novnc
RUN pip install git+https://github.com/novnc/websockify.git@v0.10.0
RUN ln -s /usr/lib/novnc/vnc.html /usr/lib/novnc/index.html

####################
# Disable Update and Crash Report
####################
RUN sed -i 's/Prompt=.*/Prompt=never/' /etc/update-manager/release-upgrades
RUN sed -i 's/enabled=1/enabled=0/g' /etc/default/apport

RUN rm /etc/apt/apt.conf.d/docker-clean

COPY ./rootfs/entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]

ENV USER ubuntu
