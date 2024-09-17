const std = @import("std");
const expectEqual = std.testing.expectEqual;

/// ## Logic Gates Implementation
///
/// Decided to use zig's built in operators for faster operations:
///
///     OR = |
///     AND = &
///     NOT = ~
///
pub const Gates = struct {
    /// Base `NAND` gate
    ///
    pub fn Nand(a: u1, b: u1) u1 {
        return ~(a & b);
    }

    /// `NOT` gate
    ///
    /// Used to invert input
    ///
    ///     Not(1) -> 0
    ///     Not(0) -> 1
    pub fn Not(in: u1) u1 {
        // return Nand(in, in);
        // causes a bit of overhead so:
        return ~in;
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
        return (a & b);
    }

    /// `OR` gate
    ///
    /// Returns true if atleast one of the input is true
    ///
    ///     Or(1,0) -> 1
    ///     Or(0,1) -> 1
    ///     Or(1,1) -> 1
    pub fn Or(a: u1, b: u1) u1 {
        return (a | b);
    }

    /// `XOR` - Exclusive OR gate
    ///
    /// Returns true if and only if one of the ouput is true
    ///
    ///     Xor(1,0) -> 1
    ///     Xor(0,1) -> 1
    pub fn Xor(a: u1, b: u1) u1 {
        // const notA = Not(a);
        // const notB = Not(b);
        // return Or(And(notA, b), And(a, notB));
        return ((~a & b) | (a & ~b));
    }

    /// `MUX` - Multiplexor
    ///
    /// It returns a or b depending on the selection `sel` bit
    ///
    ///     sel = 0 // returns a
    ///     sel = 1 // returns b
    pub fn Mux(a: u1, b: u1, sel: u1) u1 {
        // formula from truth table:
        // (a'bs) + (ab's') + (abs') + (abs)

        // simplify:
        // bs(a' + a) + as'(b' + b)
        // bs(1) + as'(1)
        // bs + as'
        return ((b & sel) | (a & ~sel));
    }

    /// `DMUX` - Demultiplexor
    ///
    /// Splits a single input into two possible outputs depending
    /// on the selection bit `sel`
    ///
    ///     if (sel == 0) -> in -> outA
    ///     if (sel == 1) -> in -> outB
    pub fn DMux(in: u1, sel: u1, outA: *u1, outB: *u1) void {
        // outA.* = And(in, Not(sel));
        // outB.* = And(in, sel);
        outA.* = (in & ~sel);
        outB.* = (in & sel);
    }

    /// `NOT16` - 16 bit NOT gate
    ///
    /// Takes a 16 bit input and performs `not` to every single bit.
    ///
    /// It basically `inverts` all the bits of a 16 bit input.
    pub fn Not16(in: u16) u16 {
        return ~in;
    }
};

// [TESTING]
test "NAND gate test" {
    try std.testing.expectEqual(1, Gates.Nand(0, 0));
    try std.testing.expectEqual(1, Gates.Nand(0, 1));
    try std.testing.expectEqual(1, Gates.Nand(1, 0));
    try std.testing.expectEqual(0, Gates.Nand(1, 1));
}

test "NOT gate test" {
    try std.testing.expectEqual(0, Gates.Not(1));
    try std.testing.expectEqual(1, Gates.Not(0));
}

test "AND gate test" {
    try std.testing.expectEqual(0, Gates.And(0, 0));
    try std.testing.expectEqual(0, Gates.And(0, 1));
    try std.testing.expectEqual(0, Gates.And(1, 0));
    try std.testing.expectEqual(1, Gates.And(1, 1));
}

test "OR gate test" {
    try std.testing.expectEqual(0, Gates.Or(0, 0));
    try std.testing.expectEqual(1, Gates.Or(0, 1));
    try std.testing.expectEqual(1, Gates.Or(1, 0));
    try std.testing.expectEqual(1, Gates.Or(1, 1));
}

test "XOR gate test" {
    try std.testing.expectEqual(0, Gates.Xor(0, 0));
    try std.testing.expectEqual(1, Gates.Xor(0, 1));
    try std.testing.expectEqual(1, Gates.Xor(1, 0));
    try std.testing.expectEqual(0, Gates.Xor(1, 1));
}

test "MUX chip test" {
    try expectEqual(0, Gates.Mux(0, 0, 0));
    try expectEqual(0, Gates.Mux(0, 0, 1));
    try expectEqual(0, Gates.Mux(0, 1, 0));
    try expectEqual(1, Gates.Mux(0, 1, 1));
    try expectEqual(1, Gates.Mux(1, 0, 0));
    try expectEqual(0, Gates.Mux(1, 0, 1));
    try expectEqual(1, Gates.Mux(1, 1, 0));
    try expectEqual(1, Gates.Mux(1, 1, 1));
}

test "DMUX chip test" {
    var outA: u1 = 0;
    var outB: u1 = 0;

    Gates.DMux(0, 0, &outA, &outB);
    try expectEqual(0, outA);
    try expectEqual(0, outB);

    Gates.DMux(0, 1, &outA, &outB);
    try expectEqual(0, outA);
    try expectEqual(0, outB);

    Gates.DMux(1, 0, &outA, &outB);
    try expectEqual(1, outA);
    try expectEqual(0, outB);

    Gates.DMux(1, 1, &outA, &outB);
    try expectEqual(0, outA);
    try expectEqual(1, outB);
}

test "NOT16 chip test" {
    var expected: u16 = 0;
    var result: u16 = 0;

    expected = 0b1111_1111_1111_1111;
    result = Gates.Not16(0b0000_0000_0000_0000);
    try expectEqual(expected, result);

    expected = 0b0000_0000_0000_0000;
    result = Gates.Not16(0b1111_1111_1111_1111);
    try expectEqual(expected, result);

    expected = 0b0101010101010101;
    result = Gates.Not16(0b1010101010101010);
    try expectEqual(expected, result);

    expected = 0b1100001100111100;
    result = Gates.Not16(0b0011110011000011);
    try expectEqual(expected, result);

    expected = 0b1110110111001011;
    result = Gates.Not16(0b0001001000110100);
    try expectEqual(expected, result);
}
