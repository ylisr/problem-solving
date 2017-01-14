//: Playground - noun: a place where people can play

import UIKit

/* In objc, it's possible to safely send messages to nil.
 enum Optional<Wrapped> {
 case none
 case some(wrapped)
 }
 to retrive an associated value: if case let (or switch statement)
 Optional<Index> is equivalent to Index?.
 nil is equivalent to .none because it conforms to ExpressibleByNilLiteral
 */

var array = ["one", "two", "three"]
switch array.index(of: "four") {
case .some(let index):
    array.remove(at: index)
case .none:
    break
}

array = ["one", "two", "three", "four"]
if let idx = array.index(of: "four"){
    array.remove(at: idx)
}

if let idx = array.index(of: "four"), idx != array.startIndex {
    array.remove(at: idx)
}

