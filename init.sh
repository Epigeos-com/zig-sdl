App_name=

if [ x"${App_name}" == "x" ]; then
    echo "Please provide App name"
else
    git clone https://github.com/Epigeos-com/zig-sdl
    rm zig-sdl/LICENSE
    rm zig-sdl/README.md
    rm zig-sdl/init.sh

    cp -r zig-sdl/* . 
    sudo rm -r zig-sdl

    sed -i "s/{{{App_name}}}/$App_name/g" build.zig
    sed -i "s/{{{APP_NAME}}}/${App_name^^}/g" build.zig
fi