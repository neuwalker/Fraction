//
//  UIntArithmetics.swift.swift
//
//
//  Created by Stefan Neumärker on 13.03.20.
//

import Foundation

extension UInt {

    public static func + (lhs: UInt, rhs: Int) -> Int {
        let signedLhs = Int(lhs)
        return signedLhs + rhs
    }

    public static func + (lhs: Int, rhs: UInt) -> Int {
        let signedRhs = Int(rhs)
        return lhs + signedRhs
    }

    public static func - (lhs: UInt, rhs: Int) -> Int {
        let signedLhs = Int(lhs)
        return signedLhs + rhs
    }

    public static func - (lhs: Int, rhs: UInt) -> Int {
        let signedRhs = Int(rhs)
        return lhs + signedRhs
    }

    public static func * (lhs: UInt, rhs: Int) -> Int {
        let signedLhs = Int(lhs)
        return signedLhs * rhs
    }

    public static func * (lhs: Int, rhs: UInt) -> Int {
        let signedRhs = Int(rhs)
        return lhs * signedRhs
    }

    public static func / (lhs: UInt, rhs: Int) -> Int {
        let signedLhs = Int(lhs)
        return signedLhs / rhs
    }

    public static func / (lhs: Int, rhs: UInt) -> Int {
        let signedRhs = Int(rhs)
        return lhs / signedRhs
    }

    public static func += (lhs: inout UInt, rhs: Int) {
        let signedLhs = Int(lhs)
        lhs = UInt(signedLhs + rhs)
    }

    public static func += (lhs: inout Int, rhs: UInt) {
        let signedRhs = Int(rhs)
        lhs = lhs + signedRhs
    }

    public static func -= (lhs: inout UInt, rhs: Int) {
        let signedLhs = Int(lhs)
        let difference = signedLhs - rhs
        lhs = difference > 0 ? UInt(difference) : 0
    }

    public static func -= (lhs: inout Int, rhs: UInt) {
        let signedRhs = Int(rhs)
        lhs = lhs - signedRhs
    }

    public static func *= (lhs: inout UInt, rhs: Int) {
        let signedLhs = Int(lhs)
        lhs = UInt(signedLhs * rhs)
    }

    public static func *= (lhs: inout Int, rhs: UInt) {
        let signedRhs = Int(rhs)
        lhs = lhs * signedRhs
    }

    public static func /= (lhs: inout UInt, rhs: Int) {
        let signedLhs = Int(lhs)
        let quotient = signedLhs / rhs
        lhs = quotient > 0 ? UInt(quotient) : 0
    }

    public static func /= (lhs: inout Int, rhs: UInt) {
        let signedRhs = Int(rhs)
        lhs = lhs / signedRhs
    }
}
