git clone https://github.com/Epigeos-com/zig-sdl
rm zig-sdl/LICENSE
rm zig-sdl/README.md
rm zig-sdl/init.sh

cp -nr zig-sdl/* . 
rm -fr zig-sdl