const std = @import("std");

pub fn main() void {
    var num1: u2 = 2;
    std.debug.print("num1: {d}\n", .{num1});

    num1 = num1 >> 1;
    std.debug.print("right shift 1: (num >> 1)\n", .{});
    std.debug.print("num1: {d}, type: {?}\n", .{ num1, @TypeOf(num1) });

    // now let's try casting types
    const num2: u1 = @intCast(num1);
    std.debug.print("num2: {?}\n", .{@TypeOf(num2)});
}
