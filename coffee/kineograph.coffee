class Kineograph

  complete: true

  onLoadComplete: null

  onAnimationEnd: null
  
  currentFrame: -1

  currentAnimation: null

  paused: true

  spriteSheet: null
  
  offset: 0
  
  currentAnimationFrame: 0

  _advanceCount: 0

  _animations: null
  
  _animation: null

  _frames: null

  _images: null

  _data: null

  _loadCount: 0
  
  _frameHeight: 0
  
  _frameWidth: 0
  
  _numFrames: 0
  
  _regX: 0
  
  _regY: 0

  _fps: 24

  constructor: (data) ->
    return unless data

    # parse fps
    @_fps = data.fps if data.fps
    
    # parse images
    if data.images and data.images.length > 0
      @_images = []
      for image in data.images
        if typeof image is "string"
          src = image
          image = new Image()
          image.src = src
        @_images.push image
        unless image.getContext or image.complete
          @_loadCount++
          @complete = false
          image.onload = @_handleImageLoad

    # parse frames
    if data.frames instanceof Array
      @_frames = []
      for frame in data.frames
        @_frames.push {
          image: @_images[if frame[4] then frame[4] else 0],
          rect: {
            x: frame[0],
            y: frame[1],
            width: frame[2],
            height: frame[3]
          },
          regX: frame[5] || 0,
          regY: frame[6] || 0
        }
    else
      frame = data.frames
      @_frameWidth = frame.width
      @_frameHeight = frame.height
      @_regX = frame.regX || 0
      @_regY = frame.regY || 0
      @_numFrames = frame.count
      @_calculateFrames() if @_loadCount == 0

    # parse animations
    if data.animations
      @_animations = []
      @_data = {}
      for name, obj of data.animations
        anim = { name: name}

        if !isNaN(obj)
          anim.frames = [obj]
        else if obj instanceof Array
          anim.frequency = obj[3]
          anim.next = obj[2]
          anim.frames = []
          anim.frames.push(i) for i in [obj[0]..obj[1]]
        else
          anim.frequency = obj.frequency
          anim.next = obj.next
          frames = obj.frames
          anim.frames = if typeof frames is "number" then [frames] else frames.slice(0)

        anim.next = if (anim.frames.length < 2 || anim.next == false) then null else if (anim.next == null || anim.next == true) then name else anim.next
        anim.frequency = 1 if !anim.frequency
        @_animations.push(name)
        @_data[name] = anim

    # create kineograph container
    @kineograph = document.createElement("IMG")
    @kineograph.src = ""
    @kineograph.style.display = "inline-block"
    @kineograph.style.position = "relative"

    # parse container
    if data.container
      @container = data.container
    else
      @container = document.createElement("DIV")
      document.body.appendChild(@container)
    @container.innerHTML = ""
    @container.style.width = "#{@_frameWidth}px"
    @container.style.height = "#{@_frameHeight}px"
    @container.style.overflow = "hidden"
    @container.style.position = "relative"
    @container.appendChild(@kineograph)

    # launch ticker
    @tick = setInterval(@_tick, 1000/@_fps)

  draw: =>
    frame = @getFrame(@currentFrame)
    return unless frame
    rect = frame.rect
    @kineograph.src = "#{frame.image.src}" unless @kineograph.src is frame.image.src
    @kineograph.style.width = "#{frame.image.width}px" unless @kineograph.style.width is frame.image.width
    @kineograph.style.height = "#{frame.image.height}px" unless @kineograph.style.height is frame.image.height
    @kineograph.style.left = "-#{rect.x}px"
    @kineograph.style.top = "-#{rect.y}px"
    true

  play: =>
    @paused = false
  
  stop: =>
    @paused = true

  gotoAndPlay: (frameOrAnimation) =>
    @paused = false
    @_goto(frameOrAnimation)

  gotoAndStop: (frameOrAnimation) =>
    @paused = true;
    @_goto(frameOrAnimation)

  advance: =>
    if @_animation then @currentAnimationFrame++ else @currentFrame++
    @_normalizeFrame()

  getNumFrames: (animation) =>
    unless animation
      ret = if @_frames then @_frames.length else @_numFrames
    else
      data = @_data[animation]
      ret = unless data then 0 else data.frames.length
    ret

  getAnimations: =>
    @_animations.slice(0)

  getAnimation: (name) =>
    @_data[name]

  getFrame: (frameIndex) =>
    ret = null
    ret = frame if @complete and @_frames and ( frame = @_frames[frameIndex] )
    ret

  _tick: =>
    f = if @_animation then @_animation.frequency else 1
    @advance() if !@paused and ((++@_advanceCount)+@offset)%f == 0
    @draw()

  _handleImageLoad: =>
    if --@_loadCount == 0
      @_calculateFrames()
      @complete = true
      @onLoadComplete(@) if @onLoadComplete

  _calculateFrames: =>
    return if @_frames || @_frameWidth == 0
    @_frames = []
    ttlFrames = 0
    fw = @_frameWidth
    fh = @_frameHeight

    for image in @_images
      cols = (image.width+1)/fw|0
      rows = (image.height+1)/fh|0
      ttl = if @_numFrames > 0 then Math.min(@_numFrames - ttlFrames, cols * rows) else cols * rows
      for j in [0..ttl-1]
        @_frames.push {
          image: image,
          rect: {
            x: j%cols*fw,
            y: (j/cols|0)*fh,
            width: fw,
            height: fh
          },
          regX: @_regX,
          regY: @_regY
        }
      ttlFrames += ttl

    @_numFrames = ttlFrames

  _normalizeFrame: => 
    a = @_animation
    if a
      if @currentAnimationFrame >= a.frames.length
        if a.next
          @_goto(a.next)
        else
          @paused = true
          @currentAnimationFrame = a.frames.length - 1
          @currentFrame = a.frames[@currentAnimationFrame]
        @onAnimationEnd(@, a.name) if @onAnimationEnd
      else
        @currentFrame = a.frames[@currentAnimationFrame]
    else
      if @currentFrame >= @getNumFrames()
        @currentFrame = 0
        @onAnimationEnd(@, null) if @onAnimationEnd

  _goto: (frameOrAnimation) =>
    if isNaN(frameOrAnimation)
      data = @getAnimation(frameOrAnimation)
      if data
        @currentAnimationFrame = 0
        @_animation = data
        @currentAnimation = frameOrAnimation
        @_normalizeFrame()
    else
      @currentAnimation = @_animation = null
      @currentFrame = frameOrAnimation

window.Kineograph = Kineograph