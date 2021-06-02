# Usage: docker run -tid --privileged -v /srv/scan:/scan -v /var/run/dbus:/var/run/dbus -p 7800:7800 --name=scanimage-webui --restart=always scanimage-webui
FROM debian:buster

LABEL maintainer="Rom Luengwattanapong"

ENV LIBRARY_PATH=/lib:/usr/lib

VOLUME [ "/scan" ]

EXPOSE 7800

RUN echo "deb http://deb.debian.org/debian buster-backports main" > /etc/apt/sources.list.d/backports.list \
    && apt-get update \
    && apt-get install -y \
    python3-pip \
    build-essential \
    tini \
    && apt-get -t buster-backports install -y \
    sane-airscan \
    hplip \
    && python3 -m pip install --upgrade pip wheel \
    && pip install scanimage-webui \
    && apt-get autoremove --purge -y \
    build-essential \
    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/usr/local/bin/scanimage-webui", "-p", "7800", "-d", "/scan" ]
