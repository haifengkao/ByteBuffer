//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftNIO open source project
//
// Copyright (c) 2017-2021 Apple Inc. and the SwiftNIO project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftNIO project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import XCTest
import ByteBuffer

func assert(_ condition: @autoclosure () -> Bool, within time: TimeInterval, testInterval: TimeInterval? = nil, _ message: String = "condition not satisfied in time", file: StaticString = #filePath, line: UInt = #line) {
    let testInterval = testInterval ?? time / 5.0
    let endTime = DispatchTime.now() + time

    repeat {
        if condition() { return }
        usleep(UInt32(testInterval * 1_000_000))  // Convert to microseconds for usleep
    } while (DispatchTime.now() < endTime)

    if !condition() {
        XCTFail(message, file: file, line: line)
    }
}
func assertNoThrowWithValue<T>(_ body: @autoclosure () throws -> T, defaultValue: T? = nil, message: String? = nil, file: StaticString = #filePath, line: UInt = #line) throws -> T {
    do {
        return try body()
    } catch {
        XCTFail("\(message.map { $0 + ": " } ?? "")unexpected error \(error) thrown", file: (file), line: line)
        if let defaultValue = defaultValue {
            return defaultValue
        } else {
            throw error
        }
    }
}

