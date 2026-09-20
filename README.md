# skifree

A source port of the classic [Microsoft Entertainment Pack](https://en.wikipedia.org/wiki/Microsoft_Entertainment_Pack) game "skifree" to SDL2 on Linux — plus live theming via a single `theme.toml` ([credits](#credits)).


## Quick Start

First install the following dependencies

- SDL2
- SDL2_image
- SDL2_ttf

Arch:

```sh
sudo pacman -S sdl2 sdl2_image sdl2_ttf
```

Debian / Ubuntu:

```sh
sudo apt-get install libsdl2-dev libsdl2-image-dev libsdl2-ttf-dev
```

Clone the repo, and run the install script:

```sh
git clone https://github.com/jasondoc3/skifree
cd skifree
./install.sh
skifree
```

`./install.sh` checks dependencies, fetches the sprite resources below,
configures, builds, and installs. Set `PREFIX=/usr/local` (or run as root)
to install system-wide instead.

## Theming

This version of the game has support for live color theming at
`~/.config/skifree/theme.toml`. The game defaults to the classic
skifree colors if no theme file is present.

Example neon theme:

```toml
snow = "#1a0f2e"
ink = "#f5f0ff"
red = "#ff5c8a"
green = "#7bf1a8"
blue = "#5cc8ff"
yellow = "#ffe74c"
magenta = "#c86bff"
cyan = "#5cf2e0"
```


## Manual Build

The install script takes care of the following steps.

### Resources
You will need to place the original gfx and icon resources into `resources/`.
You can download the original version
from the [official Skifree website](https://ski.ihoc.net/) and extract the resources with a a PE resources extractor (e.g. [ResourcesExtract](https://www.nirsoft.net/utils/resources_extract.html))

Alternatively, you can fetch pre-extracted resources: 
```sh
curl -Lo /tmp/ski32_resources.zip https://archive.org/download/ski32_resources/ski32_resources.zip
unzip -d resources /tmp/ski32_resources.zip
```

<details>
<summary>Manual steps (or for packagers)</summary>

```sh
# grab resources (original gfx, not shipped with the repo)
curl -Lo /tmp/ski32_resources.zip https://archive.org/download/ski32_resources/ski32_resources.zip
unzip -d resources /tmp/ski32_resources.zip

cmake -B build -DCMAKE_INSTALL_PREFIX=~/.local
cmake --build build
cmake --install build
./build/skifree   # or `skifree` once installed
```
</details>

## Credits

This project is for educational and preservation purposes only.

* **Original game:** *SkiFree* (1991) by Chris Pirih, later updated to 32-bit v1.04 —
  still available from the author's site at [ski.ihoc.net](https://ski.ihoc.net/).
* **Decompilation:** [yuv422/skifree_decomp](https://github.com/yuv422/skifree_decomp)
  by Eric Fry — a source reconstruction of v1.04 back to C.
* **SDL port:** [jeff-1amstudios/skifree_sdl](https://github.com/jeff-1amstudios/skifree_sdl) —
  the decompilation brought to SDL2. This repo started from that code with its
  history left behind.
* **Here:** a portable theme engine on top — the game reads
  `$XDG_CONFIG_HOME/skifree/theme.toml` (else `~/.config/skifree/theme.toml`)
  and remaps its palettized sprites, snow, and status bar at startup, reloading
  live when the file changes. No theme file means the classic look.
