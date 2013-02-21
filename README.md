# Kineograph

Kineograph is a JavaScript plugin that displays frames or sequences of frames (ie. animations) from a sprite sheet image. A sprite sheet is a series of images (usually animation frames) combined into a single image.

### Contributing to Kineograph

Contributions and pull requests are very welcome. Please follow these guidelines when submitting new code.

1. Make all changes in Coffeescript files, **not** JavaScript files.
2. Use `npm install -d` to install the correct development dependencies.
3. Use `cake build` or `cake watch` to generate Chosen's JavaScript file and minified version.
4. Don't touch the `VERSION` file
5. Submit a Pull Request using GitHub.

### Using CoffeeScript & Cake

First, make sure you have the proper CoffeeScript / Cake set-up in place. We have added a package.json that makes this easy:

```
npm install -d
```

This will install `coffee-script` and `uglifyjs`.

Once you're configured, building the JavasScript from the command line is easy:

    cake build                # build Chosen from source
    cake watch                # watch coffee/ for changes and build Chosen
    
If you're interested, you can find the recipes in Cakefile.