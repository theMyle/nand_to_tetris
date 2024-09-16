const std = @import("std");

/// Base `NAND` gate
///
/// Used to implement all other gates.
pub fn Nand(a: u1, b: u1) u1 {
    switch (a & b) {
        1 => return 0,
        else => return 1,
    }
}

/// `NOT` gate
///
/// Used to invert input
///
///     Not(1) -> 0
///     Not(0) -> 1
pub fn Not(in: u1) u1 {
    return Nand(in, in);
}

/// `AND` gate
///
/// Returns true only if both of the inputs are true
///
///     And(1,1) -> 1
///     else     -> 0
pub fn And(a: u1, b: u1) u1 {
    // Nand = Not (a and b)
    // We can cancel out the not by using another not:
    // Not ( Not (a and b)) = a and b
    const nand = Nand(a, b);
    return Not(nand);
}

/// `OR` gate
///
/// Returns true if atleast one of the input is true
///
///     Or(1,0) -> 1
///     Or(0,1) -> 1
///     Or(1,1) -> 1
pub fn Or(a: u1, b: u1) u1 {
    return Nand(Not(a), Not(b));
}

/// `XOR` - Exclusive OR gate
///
/// Returns true if and only if one of the ouput is true
///
///     Xor(1,0) -> 1
///     Xor(0,1) -> 1
pub fn Xor(a: u1, b: u1) u1 {
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
