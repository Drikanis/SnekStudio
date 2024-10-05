#!/bin/bash
set -e 

case $TARGET_PLATFORM in
    linux)
        PYTHON_PLATFORM=Linux
        GODOT_EXPORT_PRESET=Linux/X11
        ;;
    windows)
        PYTHON_PLATFORM=Windows
        GODOT_EXPORT_PRESET="Windows Desktop"
        ;;
    #maxos)
    #    PYTHON_PLATFORM=macOS
    #    GODOT_EXPORT_PRESET=
esac

PYTHON_PLATFORM_STATUS=addons/KiriPythonRPCWrapper/platform_status.json

PYTHON_FILENAME=$(jq -r .platforms.$PYTHON_PLATFORM.complete_filename < $PYTHON_PLATFORM_STATUS)
PYTHON_URL=$(jq -r .platforms.$PYTHON_PLATFORM.download_url < $PYTHON_PLATFORM_STATUS)

# tar the working directory, send it to a new instance of the build container
# then run the godot build within that container and archive the results
#
# yes this is very weird and hacky but github actions has limitations in the template lanuage
# that prevented us from running the workflow steps directly inside a container
tar -c --exclude .git . | docker run --name build-container -i ${IMAGE,,} /bin/bash -c "
set -e
mkdir -p /src
cd /src
tar -xf -
curl -fsL -o \"addons/KiriPythonRPCWrapper/StandalonePythonBuilds/$PYTHON_FILENAME\" \"$PYTHON_URL\"
mkdir -p SnekStudio
godot --headless --path . --export-release \"$GODOT_EXPORT_PRESET\" SnekStudio/snekstudio
tar -zcvf SnekStudio-$TARGET_PLATFORM-x86_64.tar.gz SnekStudio
"
# copy build results out of completed container
docker cp build-container:/src/SnekStudio-$TARGET_PLATFORM-x86_64.tar.gz .
docker rm build-container
