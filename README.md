# About
Only works on x86_64 linux host (for now)  
It takes the output file name from build.zig.zon  
init.sh is an example script for integration of this repo into other projects  
android.sh moves files from zig-out into the proper android project spots, assuming the android project is in the dir ./android/

# Versions
SDL: 3.2.6
SDL_ttf: 3.2.2
Freetype: 2.14.1, 2.14.0 on Windows
Lib files built for android api level 21
