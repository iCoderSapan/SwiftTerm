// Wcwidth.swift
// Placeholder implementation to satisfy Xcode file reference.
// Provides a minimal wcwidth(_:) function used to determine column width of a Unicode scalar.
// Replace with full implementation if wide-character handling is required.

import Foundation

/// Returns the display width (number of columns) for a given Unicode scalar.
/// Very naive: treats combining marks as zero-width, East Asian wide characters as width 2
/// and everything else as width 1.
public func wcwidth(_ scalar: Unicode.Scalar) -> Int {
    // Control characters
    if scalar.value < 0x20 || (scalar.value >= 0x7F && scalar.value < 0xA0) {
        return 0
    }
    // Combining diacritical marks (basic block)
    if (0x0300...0x036F).contains(Int(scalar.value)) {
        return 0
    }
    // Common wide ranges (CJK Unified Ideographs, Hangul, etc.) – simplified subset
    let wideRanges: [ClosedRange<UInt32>] = [
        0x1100...0x115F, // Hangul Jamo init consonants
        0x2E80...0xA4CF, // CJK Radicals Supplement .. Yi
        0xAC00...0xD7A3, // Hangul Syllables
        0xF900...0xFAFF, // CJK Compatibility Ideographs
        0xFE10...0xFE19, // Vertical forms
        0xFE30...0xFE6F, // CJK Compatibility Forms + Small Form Variants
        0xFF01...0xFF60, // Fullwidth ASCII variants
        0xFFE0...0xFFE6  // Fullwidth symbol variants
    ]
    for range in wideRanges where range.contains(scalar.value) { return 2 }
    return 1
}

/// Convenience that maps first scalar of a Character.
public func wcwidth(_ character: Character) -> Int {
    guard let first = character.unicodeScalars.first else { return 1 }
    return wcwidth(first)
}
