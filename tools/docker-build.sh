#!/bin/sh
# Build the game DLLs with the release-CI toolchain (Ubuntu 24.04 mingw-w64)
# inside Docker, so the host compiler version doesn't matter.
#
# Usage:  tools/docker-build.sh [make targets...]     (default: all)
#   tools/docker-build.sh                  -> out/dinput8.dll, out/version.dll, out/client/version.dll
#   tools/docker-build.sh cleanserver all  -> clean rebuild
#
# Optional: GA_SERVER_BINARIES=<game Binaries dir> copies out/dinput8.dll there after a successful build.
set -e

REPO=$(cd "$(dirname "$0")/.." && pwd)
IMAGE=ga-build:ubuntu24.04

if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
    echo "Building toolchain image $IMAGE (one-time)..."
    docker build -t "$IMAGE" "$REPO/docker/build"
fi

[ $# -eq 0 ] && set -- all

docker run --rm \
    -u "$(id -u):$(id -g)" \
    -v "$REPO":/src -w /src \
    "$IMAGE" make -j"$(nproc)" "$@"

if [ -n "$GA_SERVER_BINARIES" ] && [ -f "$REPO/out/dinput8.dll" ]; then
    cp "$REPO/out/dinput8.dll" "$GA_SERVER_BINARIES/dinput8.dll"
    echo "Copied out/dinput8.dll -> $GA_SERVER_BINARIES/dinput8.dll"
fi
