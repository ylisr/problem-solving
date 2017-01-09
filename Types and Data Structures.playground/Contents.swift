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

//Implement a stack
public struct Stack<Element> {
    fileprivate var array: [Element] = []
    public var count: Int {
        return array.count
    }
    public var isEmpty: Bool {
        return array.isEmpty
    }
    public mutating func push(_ newElement: Element){
        array.append(newElement)
    }
    public mutating func pop() -> Element? {
        return array.popLast()
    }
    public var top: Element? {
        return array.last
    }
}

protocol ProtocolStack {
    associatedtype Element
    mutating func push(_: Element)
    mutating func pop() -> Element?
}

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
iceCreamQueue.array.removeLast()

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

//Indices: endIndex comes after the last element of the collection (someIndex ..< endIndex)
//Linked lists
public class LinkedListNode<Element> {
    var value: Element
    var next: LinkedListNode?
    weak var previous: LinkedListNode?
    
    public init(value: Element){
        self.value = value
    }
}

public class LinkedList<Element> {
    public typealias Node = LinkedListNode<Element>
    fileprivate var head: Node?
    
    public var isEmpty: Bool {
        return head == nil
    }
    
    public var first: Node? {
        return head
    }
    public var last: Node? {
        if var node = head {
            while case let next? = node.next {
                node = next
            }
            return node
        } else {
            return nil
        }
    }
    public func append(_ newElement: Element) {
        let newNode = Node(value: newElement)
        if let lastNode = last {
            newNode.previous = lastNode
            lastNode.next = newNode
        } else {
            head = newNode
        }
    }
}

//implementing using enum
enum List<Element> {
    case end
    //indirect tells the compiler node is represented as reference, since enums are value types
    indirect case node(Element, next: List<Element>)
}

extension List {
    func cons(_ x: Element) -> List {
        return .node(x, next: self)
    }
}

extension List: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        self = elements.reversed().reduce(.end) {
            partialList, element in
            partialList.cons(element)
        }
    }
}

let list = List<Int>.end.cons(1).cons(2).cons(3)
let secondList: List = [3, 2, 1]

extension List: ProtocolStack {
    mutating func push(_ element: Element) {
        self = self.cons(element)
    }
    mutating func pop() -> Element? {
        switch self {
        case .end:
            return nil
        case let .node(x, next: xs):
            self = xs
            return x
        }
    }
}












