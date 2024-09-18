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

    /// `AND16` - 16 bit AND gate
    ///
    /// Takes two 16 bit input and `AND`' every single bit.
    pub fn And16(a: u16, b: u16) u16 {
        return (a & b);
    }

    /// `OR16` - 16 bit OR gate
    ///
    /// `OR`s two 16 bit input.
    pub fn Or16(a: u16, b: u16) u16 {
        return (a | b);
    }

    /// `MUX16` - 16 bit Mux
    ///
    /// Returns a or b depending on the selection bit `sel`
    ///
    ///     sel = 0 // returns a
    ///     sel = 1 // returns b
    pub fn Mux16(a: u16, b: u16, sel: u1) u16 {
        // I do this cuz i'm lazy doing bit shifting and stuff
        switch (sel) {
            0b0 => return a,
            0b1 => return b,
        }
    }

    /// `OR8WAY` - 8 inputs OR gate
    ///
    /// Performs `or` in all 8 bits,
    /// If any of them is 1, then output will be 1
    pub fn Or8Way(in: u8) u1 {
        // reasoning: if a single value inside `in` is 1, then output is 1
        // so a doing an if statement instead of doing multiple bit shifting
        // should in theory should work just fine.
        switch (in) {
            0 => return 0,
            else => return 1,
        }
    }

    /// `MUX4WAY16` - 4 inputs, 16 bit, MUX chip
    ///
    /// Returns an input depending on the `sel` bit.
    ///
    ///     sel(0) => a
    ///     sel(1) => b
    ///     sel(2) => c
    ///     sel(3) => d
    pub fn Mux4Way16(a: u16, b: u16, c: u16, d: u16, sel: u2) u16 {
        switch (sel) {
            0b00 => return a,
            0b01 => return b,
            0b10 => return c,
            0b11 => return d,
        }
    }

    /// `MUX8WAY16` - 8 inputs, 16 bit, MUX chip
    ///
    /// Returns an input depending on the `sel` bit.
    ///
    ///     sel(0) => a
    ///     sel(1) => b
    ///     sel(2) => c
    ///     sel(3) => d
    ///     sel(4) => e
    ///     sel(5) => f
    ///     sel(6) => g
    ///     sel(7) => h
    pub fn Mux8Way16(a: u16, b: u16, c: u16, d: u16, e: u16, f: u16, g: u16, h: u16, sel: u3) u16 {
        switch (sel) {
            0b000 => return a,
            0b001 => return b,
            0b010 => return c,
            0b011 => return d,
            0b100 => return e,
            0b101 => return f,
            0b110 => return g,
            0b111 => return h,
        }
    }

    /// DMux4Way - 4 way output demultiplexor
    ///
    /// Transfers the input (`in`) into 1 of the 4 output paths depending on the `sel` bit
    ///
    ///     sel(0) => in -> outA
    ///     sel(1) => in -> outB
    ///     sel(2) => in -> outC
    ///     sel(3) => in -> outD
    pub fn DMux4Way(in: u1, sel: u2, outA: *u1, outB: *u1, outC: *u1, outD: *u1) void {
        switch (sel) {
            0b00 => outA.* = in,
            0b01 => outB.* = in,
            0b10 => outC.* = in,
            0b11 => outD.* = in,
        }
    }

    /// DMux8Way - 8 way output demultiplexor
    ///
    /// Transfers the input (`in`) into 1 of the 8 output paths depending on the `sel` bit
    ///
    ///     sel(0) => in -> outA
    ///     sel(1) => in -> outB
    ///     sel(2) => in -> outC
    ///     sel(3) => in -> outD
    ///     sel(4) => in -> outE
    ///     sel(5) => in -> outF
    ///     sel(6) => in -> outG
    ///     sel(7) => in -> outH
    pub fn DMux8Way(in: u1, sel: u3, outA: *u1, outB: *u1, outC: *u1, outD: *u1, outE: *u1, outF: *u1, outG: *u1, outH: *u1) void {
        switch (sel) {
            0b000 => outA.* = in,
            0b001 => outB.* = in,
            0b010 => outC.* = in,
            0b011 => outD.* = in,
            0b100 => outE.* = in,
            0b101 => outF.* = in,
            0b110 => outG.* = in,
            0b111 => outH.* = in,
        }
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

test "AND16 chip test" {
    try expectEqual(0b0000_0000_0000_0000, Gates.And16(0, 0));
    try expectEqual(0b0000_0000_0000_0000, Gates.And16(0, 0b1111_1111_1111_1111));
    try expectEqual(0b1111_1111_1111_1111, Gates.And16(0b1111_1111_1111_1111, 0b1111_1111_1111_1111));
    try expectEqual(0b0000000000000000, Gates.And16(0b1010101010101010, 0b0101010101010101));
    try expectEqual(0b0000110011000000, Gates.And16(0b0011110011000011, 0b0000111111110000));
    try expectEqual(0b0001000000110100, Gates.And16(0b0001001000110100, 0b1001100001110110));
}

test "MUX16 chip test" {
    try expectEqual(0, Gates.Mux16(0, 0, 0));
    try expectEqual(0, Gates.Mux16(0, 0, 1));
    try expectEqual(0, Gates.Mux16(0, 20, 0));
    try expectEqual(20, Gates.Mux16(0, 20, 1));
    try expectEqual(33, Gates.Mux16(33, 0, 0));
    try expectEqual(11, Gates.Mux16(33, 11, 1));
}

test "OR8WAY chip test" {
    try expectEqual(0, Gates.Or8Way(0));
    try expectEqual(1, Gates.Or8Way(0b1111_1111));
    try expectEqual(1, Gates.Or8Way(0b0001_0000));
    try expectEqual(1, Gates.Or8Way(0b0000_0001));
}

test "MUX4WAY16 chip test" {
    try expectEqual(20, Gates.Mux4Way16(20, 0, 0, 0, 0));
    try expectEqual(30, Gates.Mux4Way16(20, 30, 0, 0, 1));
    try expectEqual(40, Gates.Mux4Way16(20, 30, 40, 0, 2));
    try expectEqual(50, Gates.Mux4Way16(20, 30, 40, 50, 3));
}

test "MUX8WAY16 chip test" {
    try expectEqual(1, Gates.Mux8Way16(1, 2, 3, 4, 5, 6, 7, 8, 0));
    try expectEqual(2, Gates.Mux8Way16(1, 2, 3, 4, 5, 6, 7, 8, 1));
    try expectEqual(3, Gates.Mux8Way16(1, 2, 3, 4, 5, 6, 7, 8, 2));
    try expectEqual(4, Gates.Mux8Way16(1, 2, 3, 4, 5, 6, 7, 8, 3));

    try expectEqual(5, Gates.Mux8Way16(1, 2, 3, 4, 5, 6, 7, 8, 4));
    try expectEqual(6, Gates.Mux8Way16(1, 2, 3, 4, 5, 6, 7, 8, 5));
    try expectEqual(7, Gates.Mux8Way16(1, 2, 3, 4, 5, 6, 7, 8, 6));
    try expectEqual(8, Gates.Mux8Way16(1, 2, 3, 4, 5, 6, 7, 8, 7));
}

test "DMUX4WAY chip test" {
    var outA: u1 = undefined;
    var outB: u1 = undefined;
    var outC: u1 = undefined;
    var outD: u1 = undefined;

    Gates.DMux4Way(1, 0, &outA, &outB, &outC, &outD);
    try expectEqual(1, outA);

    Gates.DMux4Way(1, 1, &outA, &outB, &outC, &outD);
    try expectEqual(1, outB);

    Gates.DMux4Way(1, 2, &outA, &outB, &outC, &outD);
    try expectEqual(1, outC);

    Gates.DMux4Way(1, 3, &outA, &outB, &outC, &outD);
    try expectEqual(1, outD);
}

test "DMUX8WAY chip test" {
    var outA: u1 = undefined;
    var outB: u1 = undefined;
    var outC: u1 = undefined;
    var outD: u1 = undefined;
    var outE: u1 = undefined;
    var outF: u1 = undefined;
    var outG: u1 = undefined;
    var outH: u1 = undefined;

    Gates.DMux8Way(1, 0, &outA, &outB, &outC, &outD, &outE, &outF, &outG, &outH);
    try expectEqual(1, outA);

    Gates.DMux8Way(1, 1, &outA, &outB, &outC, &outD, &outE, &outF, &outG, &outH);
    try expectEqual(1, outB);

    Gates.DMux8Way(1, 2, &outA, &outB, &outC, &outD, &outE, &outF, &outG, &outH);
    try expectEqual(1, outC);

    Gates.DMux8Way(1, 3, &outA, &outB, &outC, &outD, &outE, &outF, &outG, &outH);
    try expectEqual(1, outD);

    Gates.DMux8Way(1, 4, &outA, &outB, &outC, &outD, &outE, &outF, &outG, &outH);
    try expectEqual(1, outE);

    Gates.DMux8Way(1, 5, &outA, &outB, &outC, &outD, &outE, &outF, &outG, &outH);
    try expectEqual(1, outF);

    Gates.DMux8Way(1, 6, &outA, &outB, &outC, &outD, &outE, &outF, &outG, &outH);
    try expectEqual(1, outG);

    Gates.DMux8Way(1, 7, &outA, &outB, &outC, &outD, &outE, &outF, &outG, &outH);
    try expectEqual(1, outH);
}
