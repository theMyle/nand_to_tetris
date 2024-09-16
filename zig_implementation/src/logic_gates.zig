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

pub fn Or(a: u2, b: u2) u2 {
    return Nand(Not(a), Not(b));
}

pub fn Xor(a: u2, b: u2) u2 {
    const notA = Not(a);
    const notB = Not(b);
    return Or(And(notA, b), And(a, notB));
}

// [TESTING]
test "NAND gate test" {
    try std.testing.expectEqual(1, Nand(0, 0));
    try std.testing.expectEqual(1, Nand(0, 1));
    try std.testing.expectEqual(1, Nand(1, 0));
    try std.testing.expectEqual(0, Nand(1, 1));
}

test "NOT gate test" {
    try std.testing.expectEqual(0, Not(1));
    try std.testing.expectEqual(1, Not(0));
}

test "AND gate test" {
    try std.testing.expectEqual(0, And(0, 0));
    try std.testing.expectEqual(0, And(0, 1));
    try std.testing.expectEqual(0, And(1, 0));
    try std.testing.expectEqual(1, And(1, 1));
}

test "OR gate test" {
    try std.testing.expectEqual(0, Or(0, 0));
    try std.testing.expectEqual(1, Or(0, 1));
    try std.testing.expectEqual(1, Or(1, 0));
    try std.testing.expectEqual(1, Or(1, 1));
}

test "XOR gate test" {
    try std.testing.expectEqual(0, Xor(0, 0));
    try std.testing.expectEqual(1, Xor(0, 1));
    try std.testing.expectEqual(1, Xor(1, 0));
    try std.testing.expectEqual(0, Xor(1, 1));
}
