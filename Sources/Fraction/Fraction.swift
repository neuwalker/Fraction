//
//  Fraction.swift
//  
//
//  Created by Stefan Neumärker on 08.03.20.
//

import Foundation

//===----------------------------------------------------------------------===//
// Fraction
//===----------------------------------------------------------------------===//
/// Struct for fraction with numerator / denominator.
/// Use for symbolic calculation.
/// Reduce to smalles common denominator.
/// Gives double from faction.
/// Mathematical operations.
public struct Fraction {

    enum Error: Swift.Error {
        case devisionByZero
    }

    fileprivate var _numerator: Int
    fileprivate var _denominator: UInt

    /// Public getter
    public var numerator: Int {
        return _numerator
    }

    public var denominator: UInt {
        return _denominator
    }

    /// The nearest double value represented by this fraction.
    public var doubleValue: Double {
        return convertToDouble()
    }

    init(num: Int, den: UInt) {
        self._numerator = num
        self._denominator = den
    }

    /// Creates a new fraction object.
    /// - Parameters:
    ///  - numerator: The counting part of the fraction. Value above the diving line.
    ///  - denominator: The declaring part of the fraction. Value below the diving line.
    public init(numerator: Int, denominator: UInt) throws {
        guard denominator != 0 else {
            throw Error.devisionByZero
        }

        self.init(num: numerator, den: denominator)
    }
    
    /// Creates a new fraction object.
    /// - Parameters:
    ///   - numerator: The counting part of the fraction. Value above the diving line.
    ///   - denominator: The declaring part of the fraction .Value below the diving line. If this value is negative, the magnitude will be used and numerator witll be multiplied by -1.
    public init(numerator: Int, denominator: Int) throws {
        guard denominator != 0 else {
            throw Error.devisionByZero
        }

        var numerator = numerator
        if denominator < 0 {
            numerator *= -1
        }

        self.init(num: numerator, den: denominator.magnitude)
    }

    public init(double: Double) throws {
        let fractionalPart = modf(double).1
        let wholePart = Int(modf(double).0)

        let digitsAfterDecimal: Int = {
            let string = String(double)
            guard let dotIndex = string.firstIndex(of: ".") else { return 0 }
            return string.distance(from: dotIndex, to: string.endIndex) - 1
        }()

        let sign = double < 0.0 ? -1 : 1

        guard fractionalPart != 0 else {
            self.init(num: sign * wholePart, den: 1)
            return
        }

        let denominator = Int(pow(10.0, Double(digitsAfterDecimal)))
        let numerator = sign * (Int(fractionalPart) + abs(wholePart) * Int(denominator))
        self.init(num: numerator, den: UInt(denominator)) //.reduced()
    }
}

// MARK: - Operations
extension Fraction {
    
    /// approx to nearest floating point number (double precision).
    fileprivate func convertToDouble() -> Double {
        return Double(_numerator) / Double(_denominator)
    }
}

// MARK: - Calculations
//extension Fraction: AdditiveArithmetic, SignedNumeric {
//    
//    /// The result of calculating the absolut value of a fraction is itself a fraction.
//    public typealias Magnitude = Fraction
//    
//    /// Any integer can represented as a fraction by diving through 1.
//    public typealias IntegerLiteralType = Int
//
//    /// Representing a Fraction with numerator of 0. Neutral element of addition.
//    public static var zero: Fraction { Fraction(num: 0, den: 1) }
//    /// Representing a Fraction with numerator and denominator of 1. Neutral element of multiplication.
//    public static var one: Fraction { Fraction(num: 1, den: 1) }
//    
//    /// The absolut value of a fraction
//    public var magnitude: Magnitude { Fraction(num: Int(numerator.magnitude), den: denominator) }
//    
//    /// The reciprocal value of the given fraction
//    /// `signum(numerator/denominator) -> signum(denominator/numerator)`
//    public var reciprocal: Fraction {
//        var reciprocalNumerator = Int(self._denominator)
//        reciprocalNumerator *= self._numerator < 0 ? -1 : 1
//        
//        return Fraction(num: reciprocalNumerator, den: self._numerator.magnitude)
//    }
//    
//    /// Creates a new fraciton from an integer literal (by dividing through 1).
//    /// - Parameter value: An integer literal (like any whole number written).
//    public init(integerLiteral value: Self.IntegerLiteralType) {
//        self = Fraction(num: value, den: 1)
//    }
//    
//    /// Creates a new fraction from any `BinaryInteger` type, by dividing the value through 1.
//    /// - Parameter source: Any value of `BinaryInteger` type.
//    public init?<T>(exactly source: T) where T : BinaryInteger {
//        let numerator = Int(source)
//        self = Fraction(num: numerator, den: 1)
//    }
//    
//    /// Finds the lowest common denominator.
//    public mutating func reduce() {
//        // In the end upper will store the devisor to reduce to lowest common denominator
//        var upper = _numerator.magnitude    // devisor will be the same for positiv and negative fractions
//        var lower = _denominator
//        var temp: UInt = 0    // Temporay storage to flip values between upper and lower
//        
//        // Find the devisor
//        while lower != 0 {
//            temp = upper % lower
//            upper = lower
//            lower = temp
//        }
//        
//        // Upper now stores the devisor.
//        // Deviding by it reduces the fraction to its lowest common denominator
//        _numerator /= Int(upper)
//        _denominator /= upper
//    }
//    
//    /// Creates a fraction reduced by the lowest common denominator.
//    /// - Returns: A new fraction reduced by the lowest common denominator.
//    public func reduced() -> Fraction {
//        var reducing = self
//        reducing.reduce()
//        return reducing
//    }
//
//    /// The summation of two fractions.
//    /// To add two fractions:
//    /// `a/b + c/d = ((a*d) + (b*c)) / (b*d)`
//    /// - Parameters:
//    ///   - lhs: A fraction summand.
//    ///   - rhs: Another fraction summand.
//    /// - Returns: A fraction representing the sum.
//    public static func + (lhs: Fraction, rhs: Fraction) -> Fraction {
//
//        let result = Fraction(num: (lhs._numerator * Int(rhs._denominator)) + (Int(lhs._denominator) * rhs._numerator), den: lhs._denominator * rhs._denominator)
//        
//        return result.reduced()
//    }
//    
//    /// The difference of one fractions from another.
//    /// To substiute a fraction from another:
//    /// `a/b - c/d = ((a*d) - (b*c)) / (b*d)`
//    /// - Parameters:
//    ///   - lhs: Minuend fraction.
//    ///   - rhs: Subtrahend fraction.
//    /// - Returns: The fraction representing the difference.
//    public static func - (lhs: Fraction, rhs: Fraction) -> Fraction {
//
//        let result = Fraction(num: (lhs._numerator * Int(rhs._denominator)) - (Int(lhs._denominator) * rhs._numerator), den: lhs._denominator * rhs._denominator)
//        
//        return result.reduced()
//    }
//    
//    /// The product of two fractions.
//    /// To multiply two fraction:
//    /// `a/b * c/d = (a*c) / (b/d)`
//    /// - Parameters:
//    ///   - lhs: A fraction factor.
//    ///   - rhs: Another fraction factor.
//    /// - Returns: A fraction representing the product.
//    public static func * (lhs: Fraction, rhs: Fraction) -> Fraction {
//
//        let result = Fraction(num: lhs._numerator * rhs._numerator, den: lhs._denominator * rhs._denominator)
//        
//        return result.reduced()
//    }
//    
//    /// The quotient of one fraction to another.
//    /// To devide a Fraction by another:
//    /// `a/b / c/d = (a*d) / (b*c)`
//    /// - Parameters:
//    ///   - lhs: Dividend fraction.
//    ///   - rhs: Devisor fraction.
////    public static func / (lhs: Fraction, rhs: Fraction) -> Fraction {
////
////        let result = Fraction(num: lhs._numerator * Int(rhs._denominator), den: UInt(lhs._denominator * rhs._numerator))
////
////        return result.reduced()
////    }
//    
//    /// Adds two fractions and stores the result in the left-hand-side fraction.
//    /// - Parameters:
//    ///   - lhs: A fraction summand.
//    ///   - rhs: Another fraction summand.
//    public static func += (lhs: inout Fraction, rhs: Fraction) {
//        lhs = lhs + rhs
//    }
//    
//    /// Subtracts the second fraction from the first and stores the difference in the left-hand-side variable.
//    /// - Parameters:
//    ///   - lhs: Minuend fraction.
//    ///   - rhs: Subtrahend fraction.
//    public static func -= (lhs: inout Fraction, rhs: Fraction) {
//        lhs = lhs - rhs
//    }
//    
//    /// Multiplies two fractions and stores the product in the left-hand-side variable.
//    /// - Parameters:
//    ///   - lhs: A fraction factor.
//    ///   - rhs: Another fraction factor.
//    public static func *= (lhs: inout Fraction, rhs: Fraction) {
//        lhs = lhs * rhs
//    }
//    
//    /// Divieds one fraction through another and stores the quotient in the left-hand-side variable.
//    /// - Parameters:
//    ///   - lhs: Dividend fraction.
//    ///   - rhs: Devisor fraction.
////    public static func /= (lhs: inout Fraction, rhs: Fraction) {
////        lhs = lhs / rhs
////    }
//    
//    /// Replaces this value with its additive inverse.
//    public mutating func negate() {
//        self = .zero - self
//    }
//    
//    public func negated() -> Fraction {
//        var negating = self
//        negating.negate()
//        return negating
//    }
//
//    /// Multiply a fraction with a whole number.
//    /// - Parameter number: An integer to multiply the fraction with.
//    /// - Returns: A new fraction which is the `number` times of the given fraction.
//    public func multiply(with number: Int) -> Fraction {
//        var multipliedFraction = Fraction(num: self._numerator * number, den: self._denominator)
//        multipliedFraction.reduce()
//        return multipliedFraction
//    }
//    
//    /// Multiply a fraction with a floating point number.
//    /// - Parameter double: The floating point number to multiply the fraction with.
//    /// - Returns: A new fraction which is the producht of `double` with the givern fraction.
//    public func multiply(with double: Double) -> Fraction {
//        var potentionOf10: Double = 1
//        var potentialNumerator: Double = 1
//        var temp: Double = 0
//        
//        while potentialNumerator - temp > 0 {
//            potentionOf10 *= 10
//            
//            potentialNumerator = double * potentionOf10
//            temp = potentialNumerator.rounded(.down)
//        }
//        
//        return self * Fraction(num: Int(temp), den: UInt(potentionOf10))
//    }
//}

//extension Fraction: Equatable {
//    /// Returns a Boolean value indicating whether two fractions are equal.
//    /// Reduces both values to its lowest common devisor before comparing,
//    /// therefore fraction equality does not mean both values have the same numerator and denominator:
//    /// `3/4 == 6/8`
//    ///
//    /// Equality is the inverse of inequality. For any values `a` and `b`,
//    /// `a == b` implies that `a != b` is `false`.
//    ///
//    /// - Parameters:
//    ///   - lhs: A fraction to compare.
//    ///   - rhs: Another fraction to compare.
//    /// - Returns: Boolean indicating both fractions are equal.
//    public static func == (lhs: Fraction, rhs: Fraction) -> Bool {
//        var first = lhs
//        var second = rhs
//        return first.reduce() == second.reduce()
//    }
//
//    public static func != (lhs: Fraction, rhs: Fraction) -> Bool {
//        return !(lhs == rhs)
//    }
//
//    /// Two fractions are identically, if both their numerator and denominators are equal.
//    /// - Parameters:
//    ///   - lhs: A fraction to compare.
//    ///   - rhs: Another fraction to compare.
//    /// - Returns: Boolean indicating both fractions are identical.
//    public static func === (lhs: Fraction, rhs: Fraction) -> Bool {
//        return lhs._numerator == rhs._numerator && lhs._denominator == rhs._denominator
//    }
//    
//    /// Two fractions are not identically, if either their numerators or denominators are unequal.
//    /// - Parameters:
//    ///   - lhs: A fraction to compare.
//    ///   - rhs: Another fraction to compare.
//    /// - Returns: Boolean indicating both fractions are unidentical.
//    public static func !== (lhs: Fraction, rhs: Fraction) -> Bool {
//        return !(lhs === rhs)
//    }
//}

//extension Fraction: Comparable {
//    /// Returns a Boolean value indicating whether the value of the first
//    /// fraction is less than that of the second fraction.
//    ///
//    /// This function is the only requirement of the `Comparable` protocol. The
//    /// remainder of the relational operator functions are implemented by the
//    /// standard library for any type that conforms to `Comparable`.
//    ///
//    /// - Parameters:
//    ///   - lhs: A fraction to compare.
//    ///   - rhs: Another fraction to compare.
//    /// - Returns: Boolean indicating `lhs` fraction is less than `rhs` fraction.
//    public static func < (lhs: Fraction, rhs: Fraction) -> Bool {
//        
//        // to compare to fractions, bring both to same denominator
//        // multiply first fraction with second denominator
//        // multiply second fraciton with first denominator
//        // compare numerators
//        
//        let ownNumerator = lhs._numerator * rhs._denominator
//        let foreignNumerator = rhs._numerator * lhs._denominator
//        
//        return ownNumerator < foreignNumerator
//    }
//}

extension Fraction: Codable { }

// MARK: - Description
extension Fraction: CustomStringConvertible, CustomDebugStringConvertible {
    /// A textual representation of this instance.
    public var description: String {
        "Fraction \(_numerator)/\(_denominator) – approx: \(convertToDouble())"
    }
    
    /// A textual representation of this instance, suitable for debugging.
    public var debugDescription: String {
        "Fraction \(_numerator)/\(_denominator) – approx: \(convertToDouble())"
    }
}

extension String.StringInterpolation {
    /// Interpolates the given value's textual representation into the string literal being created.
    /// - Parameter value: A fraction which should be interpolated.
    mutating func appendInterpolation(_ value: Fraction) {
        appendInterpolation(value.description)
    }
}
