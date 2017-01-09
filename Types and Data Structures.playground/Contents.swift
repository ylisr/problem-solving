import UIKit

//string, array, dictionary, linked lists, stacks, queues

//Iterator for fibonacci sequences
func fibsIterator() -> AnyIterator<Int> {
    var state = (0, 1)
    return AnyIterator {
        let upcomingNumber = state.0
        state = (state.1, state.0 + state.1)
        return upcomingNumber
    }
}
let fibsSequence = AnySequence(fibsIterator)
Array(fibsSequence.prefix(10))

let randomNumbers = sequence(first: 100) {
    (previous: UInt32) in
    let newValue = arc4random_uniform(previous)
    guard newValue > 0 else {
        return nil
    }
    return newValue
}
Array(randomNumbers)

/*Difference between sequences and iterators: sequences carry their own iterations state and are mutated as they're traversed.
 collection - a stable sequence can be traversed nondestructively and accessed via subscript. Built upon top of sequence.
 */
protocol Queue {
    associatedtype Element
    mutating func enqueue(_ newElement: Element)
    mutating func dequeue() -> Element?
}

struct RegularQueue<Element>: Queue {
    fileprivate var array:[Element] = []
    public var isEmpty: Bool {
        return array.isEmpty
    }
    public var count: Int {
        return array.count
    }
    public var front: Element? {
        return array.first
    }
    
    mutating func dequeue() -> Element? {
        if isEmpty {
            return nil
        } else {
            return array.removeFirst()
        }
    }
    mutating func enqueue(_ newElement: Element) {
        array.append(newElement)
    }
    
}

var iceCreamQueue = RegularQueue(array:["vanilla", "chocolate chip cookie", "strawberry", "pistachio"])
iceCreamQueue.enqueue("Mango")
iceCreamQueue.dequeue()
print(iceCreamQueue)


struct FIFOQueue<Element>:Queue {
    fileprivate var left:[Element] = []
    fileprivate var right:[Element] = []
    mutating func enqueue(_ newElement: Element) {
        right.append(newElement)
    }
    mutating func dequeue() -> Element? {
        if left.isEmpty {
            left = right.reversed()
            right.removeAll()
        }
        return left.popLast()
    }
}

extension FIFOQueue: Collection {
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return left.count + right.count}
    
    public func index(after i: Int) -> Int {
        precondition(i < endIndex)
        return i + 1
    }
    
    public subscript(position: Int) -> Element {
        precondition((0...endIndex).contains(position), "Index out of bounds")
        if position < left.endIndex {
            return left[left.count - position - 1]
        } else {
            return right[position - left.count]
        }
    }
}

var queue = FIFOQueue<String>()
for string in ["a", "foo","fizzbuzz", "123"] {
    queue.enqueue(string)
}
for item in queue {
    print(item, terminator: " ")
}
queue.map { $0.uppercased() }
queue.filter { $0.characters.count > 1}



