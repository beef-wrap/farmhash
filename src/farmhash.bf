// Copyright (c) 2014 Google, Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// FarmHash, by Geoff Pike

//
// http://code.google.com/p/farmhash/
//
// This file provides a few functions for hashing strings and other
// data.  All of them are high-quality functions in the sense that
// they do well on standard tests such as Austin Appleby's SMHasher.
// They're also fast.  FarmHash is the successor to CityHash.
//
// Functions in the FarmHash family are not suitable for cryptography.
//
// WARNING: This code has been only lightly tested on big-endian platforms!
// It is known to work well on little-endian platforms that have a small penalty
// for unaligned reads, such as current Intel and AMD moderate-to-high-end CPUs.
// It should work on all 32-bit and 64-bit platforms that allow unaligned reads;
// bug reports are welcome.
//
// By the way, for some hash functions, given strings a and b, the hash
// of a+b is easily derived from the hashes of a and b.  This property
// doesn't hold for any hash functions in this file.

using System;
using System.Interop;

namespace farmhash;

public static class farmhash
{
    typealias char = c_char;
    typealias size_t = uint;
    typealias uint32_t = uint32;
    typealias uint64_t = uint64;

    public struct uint128_t {
        public uint64_t a;
        public uint64_t b;
    }

    [Inline]
    public static uint64_t uint128_t_low64(uint128_t x) { 
        return x.a; 
    }

    [Inline]
    public static uint64_t uint128_t_high64(uint128_t x) { 
        return x.b; 
    }

    [Inline]
    public static uint128_t make_uint128_t(uint64_t lo, uint64_t hi) { 
        return .(){a = lo, b = hi};
    }

    // BASIC STRING HASHING

    // Hash function for a byte array.
    // May change from time to time, may differ on different platforms, may differ
    // depending on NDEBUG.
    [CLink] public static extern size_t farmhash(char* s, size_t len);

    // Hash function for a byte array.  Most useful in 32-bit binaries.
    // May change from time to time, may differ on different platforms, may differ
    // depending on NDEBUG.
    [CLink] public static extern uint32_t farmhash32(char* s, size_t len);

    // Hash function for a byte array.  For convenience, a 32-bit seed is also
    // hashed into the result.
    // May change from time to time, may differ on different platforms, may differ
    // depending on NDEBUG.
    [CLink] public static extern uint32_t farmhash32_with_seed(char* s, size_t len, uint32_t seed);

    // Hash 128 input bits down to 64 bits of output.
    // Hash function for a byte array.
    // May change from time to time, may differ on different platforms, may differ
    // depending on NDEBUG.
    [CLink] public static extern uint64_t farmhash64(char* s, size_t len);

    // Hash function for a byte array.  For convenience, a 64-bit seed is also
    // hashed into the result.
    // May change from time to time, may differ on different platforms, may differ
    // depending on NDEBUG.
    [CLink] public static extern uint64_t farmhash64_with_seed(char* s, size_t len, uint64_t seed);

    // Hash function for a byte array.  For convenience, two seeds are also
    // hashed into the result.
    // May change from time to time, may differ on different platforms, may differ
    // depending on NDEBUG.
    [CLink] public static extern uint64_t farmhash64_with_seeds(char* s, size_t len, uint64_t seed0, uint64_t seed1);

    // Hash function for a byte array.
    // May change from time to time, may differ on different platforms, may differ
    // depending on NDEBUG.
    [CLink] public static extern uint128_t farmhash128(char* s, size_t len);

    // Hash function for a byte array.  For convenience, a 128-bit seed is also
    // hashed into the result.
    // May change from time to time, may differ on different platforms, may differ
    // depending on NDEBUG.
    [CLink] public static extern uint128_t farmhash128_with_seed(char* s, size_t len, uint128_t seed);

    // BASIC NON-STRING HASHING

    // This is intended to be a reasonably good hash function.
    // May change from time to time, may differ on different platforms, may differ
    // depending on NDEBUG.
    [Inline]
    public static uint64_t farmhash128_to_64(uint128_t x) {
        // Murmur-inspired hashing.
        uint64_t k_mul = 0x9ddfea08eb382d69UL;
        uint64_t a = (uint128_t_low64(x) ^ uint128_t_high64(x)) * k_mul;
        a ^= (a >> 47);
        uint64_t b = (uint128_t_high64(x) ^ a) * k_mul;
        b ^= (b >> 47);
        b *= k_mul;
        return b;
    }

    // FINGERPRINTING (i.e., good, portable, forever-fixed hash functions)

    // Fingerprint function for a byte array.  Most useful in 32-bit binaries.
    [CLink] public static extern uint32_t farmhash_fingerprint32(char* s, size_t len);

    // Fingerprint function for a byte array.
    [CLink] public static extern uint64_t farmhash_fingerprint64(char* s, size_t len);

    // Fingerprint function for a byte array.
    [CLink] public static extern uint128_t farmhash_fingerprint128(char* s, size_t len);

    // This is intended to be a good fingerprinting primitive.
    // See below for more overloads.
    [CLink]
    public static uint64_t farmhash_fingerprint_uint128_t(uint128_t x) {
        // Murmur-inspired hashing.
        uint64_t k_mul = 0x9ddfea08eb382d69UL;
        uint64_t a = (uint128_t_low64(x) ^ uint128_t_high64(x)) * k_mul;
        a ^= (a >> 47);
        uint64_t b = (uint128_t_high64(x) ^ a) * k_mul;
        b ^= (b >> 44);
        b *= k_mul;
        b ^= (b >> 41);
        b *= k_mul;
        return b;
    }

    // This is intended to be a good fingerprinting primitive.
    [Inline]
    public static uint64_t farmhash_fingerprint_uint64_t(uint64_t x) {
        // Murmur-inspired hashing.
        uint64_t k_mul = 0x9ddfea08eb382d69UL;
        uint64_t b = x * k_mul;
        b ^= (b >> 44);
        b *= k_mul;
        b ^= (b >> 41);
        b *= k_mul;
        return b;
    }
}