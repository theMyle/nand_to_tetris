const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // testing
    const logic_gates_test = b.addTest(.{
        .name = "LOGIC GATES TEST",
        .root_source_file = b.path("src/logic_gates.zig"),
        .target = target,
        .optimize = optimize,
    });
    const logic_gates_test_run = b.addRunArtifact(logic_gates_test);

    // test step
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&logic_gates_test_run.step);
}
