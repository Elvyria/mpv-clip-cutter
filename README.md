# mpv-clip-cutter

This is yet another script for `mpv` that helps me quickly cut clips from videos without resorting to advanced video processing tools.
No weird dependencies, no reencoding.

Because every other script that I found was overly complicated or just simply didn't work.

## Installation

Drop the **[cut.lua](/cut.lua)** script from the repository into scripts directory that resides near `mpv.conf` :
```sh
${XDG_CONFIG_HOME:-$HOME/.config}/mpv/scripts
```

## Dependencies
* [mpv 0.36.0](https://mpv.io)
* [ffmpeg 4.4.4](https://ffmpeg.org)

## Shortcuts
* `c` - mark the beggining of the cut
* `C` - mark the end of the cut
* `Ctrl+c` - make a cut

Script uses chapters as marks. In case you're not familiar with them:
* `!` - previous chapter
* `@` - next chapter
