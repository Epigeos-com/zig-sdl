const std = @import("std");

pub fn build(b: *std.Build) !void {
    const standard_target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    var targets = std.ArrayList(std.Build.ResolvedTarget).empty;
    defer targets.deinit(b.allocator);

    const io = b.graph.io;
    const build_dir = b.root.root_dir.handle;

    // Target options
    const TargetOptions = enum { all, pc, mobile, linux, windows, macos, android, ios };
    const CpuArchRangeOptions = enum { all, four, two };
    const target_set_option = b.option(TargetOptions, "tgts", "Build for multiple targets");
    const cpu_arch_range_option = b.option(CpuArchRangeOptions, "tgtscpu", "Specify how many of the most popular cpu archs to build for when using tgts (default: two)") orelse .two;
    const android_api_level_option = b.option(u32, "tgtsaapi", "Android API for multi-target build (default: 21)") orelse 21;
    const allow_debug_multitarget_build_option = b.option(bool, "tgtsallowdebug", "Allow tgts to run on debug optimisation mode");
    if (target_set_option) |target_set_option_| {
        if (optimize == .debug and !(allow_debug_multitarget_build_option orelse false)) std.debug.panic("Attempted multi-target build on Debug optimiser, use -Dtgtsallowdebug to allow this", .{});
        const cpu_range = @intFromEnum(cpu_arch_range_option);
        if (target_set_option_ == .linux or target_set_option_ == .pc or target_set_option_ == .all) {
            try targets.appendSlice(b.allocator, &.{
                b.resolveTargetQuery(.{ .os_tag = .linux, .abi = .gnu, .cpu_arch = .x86_64 }),
                b.resolveTargetQuery(.{ .os_tag = .linux, .abi = .gnu, .cpu_arch = .x86 }),
            });
            if (cpu_range < 2) try targets.appendSlice(b.allocator, &.{
                b.resolveTargetQuery(.{ .os_tag = .linux, .abi = .gnu, .cpu_arch = .aarch64 }), // No SDL files available
                b.resolveTargetQuery(.{ .os_tag = .linux, .abi = .gnu, .cpu_arch = .arm }), // No SDL files available
            });
            if (cpu_range < 1) try targets.appendSlice(b.allocator, &.{
                b.resolveTargetQuery(.{ .os_tag = .linux, .abi = .gnu, .cpu_arch = .mips64 }), // No SDL files available
                b.resolveTargetQuery(.{ .os_tag = .linux, .abi = .gnu, .cpu_arch = .mips64el }), // No SDL files available
                b.resolveTargetQuery(.{ .os_tag = .linux, .abi = .gnu, .cpu_arch = .mips }), // No SDL files available
                b.resolveTargetQuery(.{ .os_tag = .linux, .abi = .gnu, .cpu_arch = .mipsel }), // No SDL files available
                b.resolveTargetQuery(.{ .os_tag = .linux, .abi = .gnu, .cpu_arch = .powerpc64 }), // No SDL files available
                b.resolveTargetQuery(.{ .os_tag = .linux, .abi = .gnu, .cpu_arch = .powerpc64le }), // No SDL files available
                b.resolveTargetQuery(.{ .os_tag = .linux, .abi = .gnu, .cpu_arch = .powerpc }), // No SDL files available
                b.resolveTargetQuery(.{ .os_tag = .linux, .abi = .gnu, .cpu_arch = .powerpcle }), // No SDL files available
                b.resolveTargetQuery(.{ .os_tag = .linux, .abi = .gnu, .cpu_arch = .s390x }), // No SDL files available
                b.resolveTargetQuery(.{ .os_tag = .linux, .abi = .gnu, .cpu_arch = .riscv64 }), // No SDL files available
                b.resolveTargetQuery(.{ .os_tag = .linux, .abi = .gnu, .cpu_arch = .riscv32 }), // No SDL files available
            });
        }
        if (target_set_option_ == .windows or target_set_option_ == .pc or target_set_option_ == .all) {
            try targets.appendSlice(b.allocator, &.{
                b.resolveTargetQuery(.{ .os_tag = .windows, .cpu_arch = .x86_64 }),
                b.resolveTargetQuery(.{ .os_tag = .windows, .cpu_arch = .x86 }),
            });
            if (cpu_range < 2) try targets.appendSlice(b.allocator, &.{
                b.resolveTargetQuery(.{ .os_tag = .windows, .cpu_arch = .aarch64 }), // No SDL files available
                b.resolveTargetQuery(.{ .os_tag = .windows, .cpu_arch = .arm }), // No SDL files available
            });
        }
        if (target_set_option_ == .macos or target_set_option_ == .pc or target_set_option_ == .all) {
            try targets.appendSlice(b.allocator, &.{
                b.resolveTargetQuery(.{ .os_tag = .macos, .cpu_arch = .aarch64 }), // No SDL files available //.abi = .none
                b.resolveTargetQuery(.{ .os_tag = .macos, .cpu_arch = .x86_64 }), // No SDL files available
            });
            if (cpu_range < 2) try targets.appendSlice(b.allocator, &.{
                b.resolveTargetQuery(.{ .os_tag = .macos, .cpu_arch = .x86 }), // No SDL files available
                b.resolveTargetQuery(.{ .os_tag = .macos, .cpu_arch = .arm }), // No SDL files available
            });
            if (cpu_range < 1) try targets.appendSlice(b.allocator, &.{
                b.resolveTargetQuery(.{ .os_tag = .macos, .cpu_arch = .powerpc64 }), // No SDL files available
                b.resolveTargetQuery(.{ .os_tag = .macos, .cpu_arch = .powerpc }), // No SDL files available
            });
        }
        if (target_set_option_ == .android or target_set_option_ == .mobile or target_set_option_ == .all) {
            try targets.appendSlice(b.allocator, &.{
                b.resolveTargetQuery(.{ .os_tag = .linux, .abi = .android, .cpu_arch = .aarch64, .android_api_level = android_api_level_option }),
                b.resolveTargetQuery(.{ .os_tag = .linux, .abi = .androideabi, .cpu_arch = .arm, .android_api_level = android_api_level_option }),
            });
            if (cpu_range < 2) try targets.appendSlice(b.allocator, &.{
                b.resolveTargetQuery(.{ .os_tag = .linux, .abi = .android, .cpu_arch = .x86_64, .android_api_level = android_api_level_option }),
                b.resolveTargetQuery(.{ .os_tag = .linux, .abi = .android, .cpu_arch = .x86, .android_api_level = android_api_level_option }),
            });
            if (cpu_range < 1) try targets.appendSlice(b.allocator, &.{
                b.resolveTargetQuery(.{ .os_tag = .linux, .abi = .android, .cpu_arch = .riscv64, .android_api_level = 35 }),
            });
            if (cpu_range < 1 and android_api_level_option < 35) std.debug.print("Changed android api version for riscv64 to 35, as it does not support older versions\n", .{});
        }
        if (target_set_option_ == .ios or target_set_option_ == .mobile or target_set_option_ == .all) {
            try targets.appendSlice(b.allocator, &.{
                b.resolveTargetQuery(.{ .os_tag = .ios, .cpu_arch = .aarch64 }), // No SDL files available //.abi = .none
                b.resolveTargetQuery(.{ .os_tag = .ios, .cpu_arch = .arm }), // No SDL files available
            });
        }
    } else {
        try targets.append(b.allocator, standard_target);
    }
    var run_step_exe: ?*std.Build.Step.Compile = null;

    // App name
    const app_name = @tagName(@import("build.zig.zon").name);
    const app_name_upper = try std.ascii.allocUpperString(b.allocator, app_name);
    defer b.allocator.free(app_name_upper);

    for (targets.items) |target| {
        // Exe
        const exe_mod = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        });
        const exe: *std.Build.Step.Compile =
            if (target.result.abi.isAndroid())
                b.addLibrary(.{
                    .name = app_name_upper,
                    .root_module = exe_mod,
                    .linkage = .dynamic,
                })
            else
                b.addExecutable(.{
                    .name = app_name,
                    .root_module = exe_mod,
                });
        const write_files = b.addWriteFiles();
        exe.step.dependOn(&write_files.step);
        if (target.result.cpu.arch == standard_target.result.cpu.arch and target.result.os.tag == standard_target.result.os.tag and target.result.abi == standard_target.result.abi) run_step_exe = exe;

        // Target
        const os_string = try std.fmt.allocPrint(b.allocator, "{s}-{s}-{s}", .{ @tagName(target.result.cpu.arch), @tagName(target.result.os.tag), @tagName(target.result.abi) });
        // defer b.allocator.free(os_string); // The build uses this and freeing this causes a corrupted output
        const target_dir_path = try std.mem.join(b.allocator, "", &.{ "zig-out/", os_string });
        defer b.allocator.free(target_dir_path);
        const target_dir = try build_dir.createDirPathOpen(io, target_dir_path, .{});
        defer target_dir.close(io);

        // LibC
        const needs_separate_libs = target.result.os.tag == .windows or target.result.abi.isAndroid();
        const lib_prefix = if (target.result.os.tag == .windows) "" else "lib";
        const lib_extension = if (target.result.os.tag == .windows) "dll" else "so";

        const translate_c = b.addTranslateC(.{ .optimize = optimize, .target = target, .root_source_file = b.path("c_includes.h") });
        const c_includes_read = try build_dir.readFileAlloc(io, "c_includes.h", b.allocator, .unlimited);
        defer b.allocator.free(c_includes_read);
        var c_includes_lines = std.mem.splitScalar(u8, c_includes_read, '\n');
        while (c_includes_lines.next()) |line| {
            if (std.mem.startsWith(u8, line, "#include ")) {
                const brace_index = std.mem.findScalar(u8, line, '<') orelse 9;
                const slash_index = std.mem.findScalar(u8, line, '/') orelse 9;
                const lib_name = line[brace_index + 1 .. slash_index];

                // translate_c.linkSystemLibrary(lib_name, .{});

                const lib_src_file_path = try std.fmt.allocPrint(b.allocator, "lib/{s}/{s}.{s}", .{ lib_name, os_string, lib_extension });
                // defer b.allocator.free(lib_src_file_path); // The build uses this and freeing this causes a corrupted output
                const lib_dest_file_name = try std.fmt.allocPrint(b.allocator, "{s}{s}.{s}", .{ lib_prefix, lib_name, lib_extension });
                defer b.allocator.free(lib_dest_file_name);
                if (needs_separate_libs) build_dir.copyFile(lib_src_file_path, target_dir, lib_dest_file_name, io, .{}) catch |err| std.debug.panic("{}, lib_src_file_path: {s}\n", .{ err, lib_src_file_path });
                const lib_dest_path = try std.mem.join(b.allocator, "/", &.{ target_dir_path, lib_dest_file_name });
                defer b.allocator.free(lib_dest_path);

                exe.root_module.addObjectFile(if (needs_separate_libs) b.path(lib_dest_path) else b.path(lib_src_file_path));
            }
        }
        exe.root_module.addImport("c", translate_c.createModule());

        // Android // TODO: Linux-specific
        if (target.result.abi.isAndroid()) {
            const android_os_string = try std.mem.replaceOwned(u8, b.allocator, os_string, "x86-", "i686-");
            defer b.allocator.free(android_os_string);
            const libc_conf_content = try std.fmt.allocPrint(b.allocator,
                \\include_dir=/usr/include/
                \\sys_include_dir=/usr/include
            ++ "\ncrt_dir=/opt/android-ndk/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/{s}/{d}\n" ++
                \\msvc_lib_dir=
                \\kernel32_lib_dir=
                \\gcc_dir=
            , .{ android_os_string, target.result.os.version_range.linux.android });
            defer b.allocator.free(libc_conf_content);
            const libc_conf = write_files.add("libc.conf", libc_conf_content);
            exe.libc_file = libc_conf;

            const libcpp_shared_path = try std.fmt.allocPrint(b.allocator, "/opt/android-sdk/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/{s}/libc++_shared.so", .{android_os_string});
            try target_dir.symLink(io, libcpp_shared_path, "libc++_shared.so", .{});
        }

        // Links
        if (target.result.os.tag == .windows) exe.subsystem = .windows;
        const artifact = b.addInstallArtifact(exe, .{ .dest_dir = .{ .override = .{ .custom = os_string } } });
        b.getInstallStep().dependOn(&artifact.step);
    }

    if (run_step_exe) |run_step_exe_| {
        const run_cmd = b.addRunArtifact(run_step_exe_);
        run_cmd.step.dependOn(b.getInstallStep());
        const run_step = b.step("run", "Run the app, requires your current setup as one of the targets");
        run_step.dependOn(&run_cmd.step);
    }
}
