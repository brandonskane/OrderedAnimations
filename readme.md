OrderedOperations is an easy way to make animations occur in an FIFO serial manner. You don't need to deal with completion blocks or calculate delays. 

Example:

The follow will complete in a total of 8 seconds

```swift
let orderedAnimations = OrderedAnimation()
orderedAnimations.addAnimation(duration: 2.0) { 
    //animation
}
orderedAnimations.addAnimation(duration: 1.0, options: [.curveEaseInOut, .allowUserInteraction]) { 
    //animation
}
orderedAnimations.addWait(duration: 2.0) //wait 2 seconds until the next one starts
orderedAnimations.addAnimation(duration: 3.0) { 
    //animation
}
orderedAnimations.addCompletion {
    //the animations added before this completion are completed
    //can handle some completed state here.
}
```



## Use Cases

1. User input causes a chain of animations that should all complete
2. Setting up animations without wanting to worry about calculating delays or nesting animations within completion blocks