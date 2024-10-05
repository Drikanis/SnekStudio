FROM debian:12.7-slim

ARG RELEASE_URL="https://github.com/godotengine/godot/releases/download"
ARG GODOT_VERSION="4.3-stable"

ENV GODOT_TEMPLATES_DIR="/root/.local/share/godot/export_templates"

RUN apt-get update && apt-get install -y \
    libfontconfig1 \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/* && \
    curl -sfL -O ${RELEASE_URL}/${GODOT_VERSION}/Godot_v${GODOT_VERSION}_linux.x86_64.zip && \
    unzip Godot_v${GODOT_VERSION}_linux.x86_64.zip Godot_v${GODOT_VERSION}_linux.x86_64 -d /usr/bin && \
    mv /usr/bin/Godot_v${GODOT_VERSION}_linux.x86_64 /usr/bin/godot &&\
    mkdir -p ${GODOT_TEMPLATES_DIR}/$(echo $GODOT_VERSION | sed -e 's/-/./') && \
    curl -sfL -O ${RELEASE_URL}/${GODOT_VERSION}/Godot_v${GODOT_VERSION}_export_templates.tpz && \
    unzip -j Godot_v${GODOT_VERSION}_export_templates.tpz -d ${GODOT_TEMPLATES_DIR}/$(echo $GODOT_VERSION | sed -e 's/-/./') && \
    rm *.tpz *.zip

WORKDIR /src
