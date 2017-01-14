//: Playground - noun: a place where people can play

import UIKit

/*
 structs are value types(stored on stack, immutable, thread-save since anything can't change can be safely shared accross threads), classes are reference types(stored on heap, so optimize to use structs)
 code sharing: class use iheritance, structs use composition, generics, protocol extensions.
 entities that have a lifecycle - file handles, notification centers, networking interfaces, db connections and view controllers are implemented using objects(reference types).
 values such as URLs, binary data, dates, errors, strings, and numbers are defined by their properties, are implemented using structs.
 structs supports value semantics, passed by a copy of its value, and when received only the copy can be changed. 
 structs only have a single owner, it's not possible to create a reference cycle. but classes and functions need to be more careful.
 weak and unowned to break reference cycle for reference types: make sure the unowned object outlives its holder, otherwise there'll be a runtime crash. When you don't need weak, unowned is recommended.
 functions in Swift are referece types too, including closures.
 */

let handle = FileHandle(forWritingAtPath: "out.html")
let request = URLRequest(url: URL(string:"https://www.apple.com")!)
URLSession.shared.dataTask(with: request) {
    (data, _, _) in
    guard let theData = data else { return }
    handle?.write(theData)
}

//Using capture list
class View {
    var window: Window
    init(window: Window){
        self.window = window
    }
    deinit {
        print("Deinit window")
    }
}

class Window {
    var rootView: View?
    deinit {
        print("Deinit Window")
    }
    var onRotate:(()->())?
}

var window: Window? = Window()
var view: View? = View(window: window!)
window?.rootView = view!

window?.onRotate = { [weak view, weak myWindow = window, x = 5*5] in
    print("We now also need to update the view: \(view)")
    print("Because the window \(myWindow) changed")
}



