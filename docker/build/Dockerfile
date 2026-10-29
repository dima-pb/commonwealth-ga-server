# DLL build toolchain matching the release CI (.github/workflows/build.yml:
# ubuntu-latest + apt mingw-w64). Used by tools/docker-build.sh.
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        mingw-w64 \
        make \
    && rm -rf /var/lib/apt/lists/*
