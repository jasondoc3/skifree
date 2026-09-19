skifree
=============================

A source port of the classic [Microsoft Entertainment Pack](https://en.wikipedia.org/wiki/Microsoft_Entertainment_Pack) game "skifree" to cross platform SDL2.

![Untitled](https://github.com/jeff-1amstudios/skifree_sdl/assets/1063652/95b53385-4d16-4de5-8f9d-10a877fee6a9)


## Dependencies
### Resources
You will need to place the original gfx and icon resources into `resources/`.
You can download the original version
from the [official Skifree website](https://ski.ihoc.net/) and extract the resources with a a PE resources extractor (e.g. [ResourcesExtract](https://www.nirsoft.net/utils/resources_extract.html))

Alternatively, you can fetch pre-extracted resources: 
```sh
curl -Lo /tmp/ski32_resources.zip https://archive.org/download/ski32_resources/ski32_resources.zip
unzip -d resources /tmp/ski32_resources.zip
```

### Libraries
- SDL2
- SDL2_image
- SDL2_ttf

## Compiling

One command (installs to `~/.local`, no sudo needed):

```sh
git clone https://github.com/jasondoc3/skifree
cd skifree
./install.sh
skifree
```

`./install.sh` checks dependencies, fetches the sprite resources below,
configures, builds, and installs. Set `PREFIX=/usr/local` (or run as root)
to install system-wide instead.

<details>
<summary>Manual steps (or for packagers)</summary>

This is a cmake project. The installer above just runs these stages.

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

## MacOS
On MacOS we build an app bundle `skifree.app`. Use right-click > Open the first time to get around [unverified developer warnings](https://support.apple.com/en-nz/guide/mac-help/mh40616/mac).

![Screenshot 2023-11-06 at 2 07 45 pm](https://github.com/jeff-1amstudios/skifree_sdl/assets/1063652/4edce399-ddeb-499a-a554-aebb7a70dfad)

## Todo
- Mouse support
- Sound maybe(?) - https://foone.wordpress.com/2017/06/20/uncovering-the-sounds-of-skifree/

## Credits

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
