#!/usr/bin/env bash
# One-command installer: ./install.sh (to ~/.local) or PREFIX=/usr/local ./install.sh
set -euo pipefail
cd "$(dirname "$0")"
PREFIX="${PREFIX:-$HOME/.local}"

command -v cmake >/dev/null || { echo "missing dependency: cmake"; exit 1; }
command -v cc >/dev/null || { echo "missing dependency: a C compiler"; exit 1; }
pkg-config --exists sdl2 SDL2_image SDL2_ttf || {
  echo "missing dependencies: SDL2 dev libraries (sdl2, sdl2_image, sdl2_ttf)"
  exit 1
}

if [ ! -f resources/ski32_1.bmp ]; then
  curl -sfLo /tmp/ski32_resources.zip \
    https://archive.org/download/ski32_resources/ski32_resources.zip
  unzip -o -q -d resources /tmp/ski32_resources.zip
  rm -f /tmp/ski32_resources.zip
fi

cmake -B build -DCMAKE_INSTALL_PREFIX="$PREFIX" -DCMAKE_BUILD_TYPE=Release
cmake --build build
cmake --install build
echo "Done: $PREFIX/bin/skifree"
