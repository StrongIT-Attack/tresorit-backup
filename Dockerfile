FROM debian:stable-slim

ENV DEBIAN_FRONTEND noninteractive
ENV PATH="/home/tresorit:${PATH}"

# install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    borgbackup

# add tresorit user and set workdir to it's home directory
RUN useradd --create-home --shell /bin/bash tresorit
WORKDIR /home/tresorit
USER tresorit

# install tresorit
RUN curl -o tresorit_installer.run https://installerstorage.blob.core.windows.net/public/install/tresorit_installer.run && \
    chmod +x ./tresorit_installer.run && \
    echo "N " | ./tresorit_installer.run --update-v2 . && \
    rm ./tresorit_installer.run && \
    mkdir Profiles external

VOLUME /home/tresorit/Profiles /home/tresorit/external
USER root

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
