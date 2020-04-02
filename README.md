# Cyclic Carousel.

Who doesn't like presenting cards on a screen and go around the world? <sub><small>(Flat earth believer? maybe?)</small></sub>

What if you need to do this in SwiftUI?

Well, wait no more. Here you will find a sample code to achieve this.

<sub>Sales pitch is over.</sub>

Basically, I was bored and saw an image of this on the internet and decided to implement it in SwiftUI.

## Requirements
- Written on xcode 11.4. 
- No extra requirements.

## Pending to do:

- [ ] Using `GeometryReader`, read the size already provided on each element to set it to the internal frame.
- [ ] Allow providing the footer and header, allowing the user customise if they want it top, center or bottom aligned.
- [ ] Make it a Swift Package if the code is good enough for anybody else to use it.
- [ ] Update the documentation to explain how to use it.
- [ ] Maybe defer `views` initialization when the entire view is loaded so the impact doesn't happen on initialization of the `CarouselView`