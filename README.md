# Kineograph

Kineograph is a JavaScript plugin that displays frames or sequences of frames (ie. animations) from a sprite sheet image. A sprite sheet is a series of images (usually animation frames) combined into a single image.

### Starting with Kineograph

It’s really easy to implement. Simply create a new Kineograph object and pass the necessary parameters for your spritesheet to come alive.

```javascript
var kineograph = new Kineograph({
  container: document.getElementById("kineograph_container"),
  images: ["img/spritesheet.png"],
  frames: {width: 100, height: 100, count: 50},
  animations: {
    onset: [0, 5, "loop"],
    loop: [6, 49, "loop"]
  },
  fps: 60
});
```

`container`: the container element for the animation

`images`: url to a spritesheet or a JavaScript Image object

`frames`: information concerning the frames of the image

`width`: the width of a frame

`height`: the height of a frame

`count`: the number of frames included in your image

`animations`: definitions of the various sequences your animation is made up of. You can have as many as you want and link them together. Each sequence is defined by an identifier and an array of settings.
* *parameter 1*: index of the starting frame
* *parameter 2*: index of the end frame
* *parameter 3*: name of the following sequence

`fps`: number of frames displayed per second

### Events

Two types of event listener can be attached to an Kineograph object.

`onLoadComplete`: this event is triggered when the spritesheet is loaded and the animation is ready to be used.

```javascript
kineograph.onLoadComplete = function() {
  this.gotoAndPlay("onset");
}
```

`onAnimationEnd`: this event is triggered every time an animation is complete. The name of the animation, if there is one, is sent as a single parameter.

```javascript
kineograph.onAnimationEnd = function(name) {
  console.log(name);
}
```

### Methods

`play()`: loops the animation from the first frame regardless of defined sequences

`stop()`: stops the animation

`gotoAndPlay(frameOrAnimation)`: plays the animation from the frame index or the name of the animation sequence passed as a parameter.

`gotoAndStop(frameOrAnimation)`: stops the animation at the frame index or the name of the animation sequence passed as a parameter.

`getNumFrames(animation)`: returns the number of frames that contains the animation sequence whose name is passed as a parameter or the number of frames that contains the entire sequence if no name is given.

`getAnimations()`: returns the names of all the animation sequences.

`getAnimation(name)`: returns the data associated with the animation sequence whose name is passed as a parameter.

`getFrame(frameIndex)`: returns a frame object whose index corresponds to the value passed as parameter.

### Contributing to Kineograph

Contributions and pull requests are very welcome. Please follow these guidelines when submitting new code.

1. Make all changes in Coffeescript files, **not** JavaScript files.
2. Use `npm install -d` to install the correct development dependencies.
3. Use `cake build` or `cake watch` to generate Kineograph's JavaScript file and minified version.
4. Don't touch the `VERSION` file
5. Submit a Pull Request using GitHub.

### Using CoffeeScript & Cake

First, make sure you have the proper CoffeeScript / Cake set-up in place. We have added a package.json that makes this easy:

```
npm install -d
```

This will install `coffee-script` and `uglifyjs`.

Once you're configured, building the JavasScript from the command line is easy:

    cake build                # build Kineograph from source
    cake watch                # watch coffee/ for changes and build Kineograph
    
If you're interested, you can find the recipes in Cakefile.