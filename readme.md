OrderedAnimations is an easy way to make animations occur in an serial FIFO queue. You don't need to deal with completion blocks or calculate delays. 

Example:

The below will complete in a total of 6.5 seconds

```swift
let orderedAnimations = OrderedAnimation()
orderedAnimations.addAnimation(duration: 2.0) { 
    //animation
}
orderedAnimations.addAnimation(duration: 1.0, options: [.curveEaseInOut, .allowUserInteraction]) { 
    //animation
}
orderedAnimations.addWait(duration: 2.0) //wait 2 seconds until the next one starts
orderedAnimations.addSpringAnimation(duration: 1.5, options: .curveEaseInOut, damping: 0.9, springVelocity: 0.3) { 
    //animation
}
orderedAnimations.addCompletion {
    //the animations added before this completion are completed
    //can handle some completed state here.
}
```

Example

![](http://i.imgur.com/z7RgZjV.gif)

Other

```sw
clearRemainingAnimations() //will clear all animations that haven't started yet
pauseUnrunAnimations() //will prevent all unstarted animations from starting
resumeUnrunAnimations() //will resume previously unstarted & paused animations
```



# Carthage

`github brandonskane/OrderedAnimations`

## Use Cases

1. User input causes a chain of animations that should all complete
2. Setting up animations without wanting to worry about calculating delays or nesting animations within completion blocks