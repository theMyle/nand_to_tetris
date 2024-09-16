const std = @import("std");

// BASE NAND GATE
pub fn Nand(a: u2, b: u2) u2 {
    switch (a & b) {
        1 => return 0,
        else => return 1,
    }
}

pub fn Not(in: u2) u2 {
    return Nand(in, in);
}

pub fn And(a: u2, b: u2) u2 {
    // Nand = Not (a and b)
    // We can cancel out the not by using another not:
    // Not ( Not (a and b)) = a and b
    const nand = Nand(a, b);
    return Not(nand);
}

// [TESTING]
test "Nand Gate Test" {
    const testCases = [_][3]u2{
        .{ 0, 0, 1 },
        .{ 0, 1, 1 },
        .{ 1, 0, 1 },
        .{ 1, 1, 0 },
    };

    for (testCases) |v| {
        try std.testing.expectEqual(Nand(v[0], v[1]), v[2]);
    }
}

test "Not Gate Test" {
    const testCases = [_][2]u2{
        .{ 0, 1 },
        .{ 1, 0 },
    };

    for (testCases) |v| {
        try std.testing.expectEqual(Not(v[0]), v[1]);
    }
}

test "And Gate Test" {
    const testCases = [_][3]u2{
        .{ 0, 0, 0 },
        .{ 0, 1, 0 },
        .{ 1, 0, 0 },
        .{ 1, 1, 1 },
    };

    for (testCases) |v| {
        try std.testing.expectEqual(And(v[0], v[1]), v[2]);
    }
}
