jniLibsDir="android/app/src/main/jniLibs"
mkdir $jniLibsDir/arm64-v8a
mkdir $jniLibsDir/armeabi-v7a
mkdir $jniLibsDir/x86_64
mkdir $jniLibsDir/x86
mkdir $jniLibsDir/riscv64
mv zig-out/aarch64-linux-android/* $jniLibsDir/arm64-v8a
mv zig-out/arm-linux-androideabi/* $jniLibsDir/armeabi-v7a
mv zig-out/x86_64-linux-android/* $jniLibsDir/x86_64
mv zig-out/x86-linux-android/* $jniLibsDir/x86
mv zig-out/riscv64-linux-android/* $jniLibsDir/riscv64
rmdir zig-out/aarch64-linux-android/
rmdir zig-out/arm-linux-androideabi/
rmdir zig-out/x86_64-linux-android/
rmdir zig-out/x86-linux-android/
rmdir zig-out/riscv64-linux-android/