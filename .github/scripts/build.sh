#!/bin/bash
set -e 

tar -c --exclude .git . | docker run --name build-container -i ${IMAGE,,} /bin/bash -c "
set -e
mkdir -p /src
cd /src
tar -xf -
curl -fsL -O --output-dir addons/KiriPythonRPCWrapper/StandalonePythonBuilds/ https://github.com/indygreg/python-build-standalone/releases/download/20240814/cpython-3.12.5%2B20240814-x86_64-unknown-linux-gnu-install_only_stripped.tar.gz
mkdir -p SnekStudio
godot --headless --path . --export-release Linux/X11 SnekStudio/snekstudio
tar -zcvf SnekStudio-linux-x86_64.tar.gz SnekStudio
"
docker cp build-container:/src/SnekStudio-linux-x86_64.tar.gz .
docker rm build-container
