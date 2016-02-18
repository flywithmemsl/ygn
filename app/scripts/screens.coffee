module.exports = class Screens

  screens = null
  active = null

  arrow = null
  video = null
  playButton = null

  donateLink = null
  toggleMenu = null
  badge = null
  index: null

  length = 5

  states =
    '0': []
    '1': ['state-1','state-2']
    '2': []
    '3': ['state-1']
    '4': []
    '5': []

  currentState = null
  started = false

  @scrollDisabled: false


  constructor: ->
    @move = _.throttle @_move, 1200



  init: =>

    # $('.vide_wrapper').vide('videos/hero')

    container = document.querySelector('body')
    @createScrollListener(container, @onScroll)
    arrow = $('.next_arrow')
    window.video = video = $('.video_wrapper video')[0]
    playButton = $('.video_wrapper .controls .play')

    donateLink = $('.donate_link')
    toggleMenu = $('.toggle_menu')
    badge = $('.badge')


    screens = $('.screen')
    active = screens.first()
    @index = 0

    @setHandlers()

    # screens.each (i,e) =>
    #   if !!states[i]
    #     $(e).addClass(states[i][0])

  createScrollListener: (elem, handler) =>
    if elem.addEventListener
      if 'onScroll' of document
        elem.addEventListener "wheel", handler
      else if 'onmousewheel' of document
        elem.addEventListener "mousewheel", handler
      else
        elem.addEventListener "MozMousePixelScroll", handler
    else
      elem.attachEvent "onmousewheel", handler



  onScroll: (e) =>
    if $('body').hasClass('noscroll') then return
    e = e || window.event
    scrollInfo = lethargy.check(e)
    if scrollInfo != false
      unless @scrollDisabled
        @scrollDisabled = true
        @move(scrollInfo)
        runNext 1200, =>
          @scrollDisabled = false

    if e.preventDefault
      e.preventDefault()
    else
      (e.returnValue = false)
    return false


  _move: (direction) =>
    if direction is 'next' || direction is -1
      @moveNext()
    else if direction is 'prev' || direction is 1
      @movePrev()
    else
      return false


  moveNext: =>
    started = true
    next = active.next()

    if !next.hasClass('screen') then return

    @beforeScroll('next')
    if (currentState != null) && !!states[@index][currentState+1]
      active.removeClass states[@index][currentState]
      active.addClass states[@index][currentState+1]
      currentState+=1
      @afterScroll('next')
      return
    else
      currentState = null
      # active.removeClass(states[@index].join(' '))


    next.addClass 'shown'
    runNext 10, =>
      active.addClass 'scrolled'
      next.addClass 'visible'
      if !!states[@index+1].length
        currentState = 0
        next.addClass(states[@index+1][0])
      runNext 800, =>
        active.removeClass 'visible'
        active.removeClass 'shown'
        @index+=1
        active = next
        @afterScroll('next')




  movePrev: =>
    if not started then return
    next = active.prev()

    if !next.hasClass('screen') then return

    @beforeScroll('prev')
    if (currentState != null) && !!states[@index][currentState-1]
      active.removeClass states[@index][currentState]
      active.addClass states[@index][currentState-1]
      currentState-=1
      @afterScroll('prev')
      return
    else
      currentState = null
      active.removeClass(states[@index].join(' '))



    next.addClass 'shown'
    if !!states[@index-1].length
      currentState = states[@index-1].length-1


    runNext 10, =>
      active.removeClass 'visible'
      next.removeClass 'scrolled'
      next.addClass 'visible'


      runNext 800, =>
        active.removeClass 'shown'
        @index-=1
        active = next
        if !!states[@index].length
          active.addClass(states[@index].slice(-1)[0])

        @afterScroll('prev')

  afterScroll: (direction) =>

    # if direction is 'next' && @index != 0
    #   if !!$('.vide_wrapper').data('vide')
    #     $('.vide_wrapper').data('vide').destroy()

    @highlightMenu(@index, currentState)




  beforeScroll: (direction) =>

    $('.content').removeClass('expanded')

    # if !!$('.vide_wrapper video')[0]
    #   $('.vide_wrapper video')[0].pause()
    @stopVideo()

    # if direction is 'prev' && @index is 1 && currentState is 0
    #   $('.vide_wrapper').vide('videos/hero')

    if direction is 'next' && @index+1 == length-1
      arrow.addClass('hidden')
    else
      arrow.removeClass('hidden')


  hideVideoControls: =>
    $('.video_wrapper>div').addClass('hidden')

  showVideoControls: =>
    $('.video_wrapper>div').removeClass('hidden')


  playVideo: =>
    # video.play()
    # @hideVideoControls()

  stopVideo: =>
    # video.pause()
    # @showVideoControls()

  toggleVideo: =>
    # if video.paused
    #   @playVideo()
    # else
    #   @stopVideo()

  highlightMenu: (index, state) =>
    console.log [index, state].join(',')
    switch [index, state].join(',')
      when '1,0'
        toggleMenu.addClass('reversed')
        donateLink.addClass('reversed')
        badge.removeClass('reversed')

      when '1,1'
        toggleMenu.addClass('reversed')
        donateLink.addClass('reversed')
        badge.removeClass('reversed')
      when '3,0'
        donateLink.removeClass('reversed')
        toggleMenu.removeClass('reversed')
        badge.addClass('reversed')
      when '4,'
        donateLink.addClass('reversed')
        toggleMenu.addClass('reversed')
        badge.addClass('reversed')
      else
        donateLink.removeClass('reversed')
        toggleMenu.removeClass('reversed')
        badge.removeClass('reversed')






  setHandlers: =>
    arrow.click =>
      unless @scrollDisabled
        @scrollDisabled = true
        @move('next')
        runNext 1200, =>
          @scrollDisabled = false

    playButton.click (e) =>
      @toggleVideo()

    $(video).on 'ended', =>
      @showVideoControls()










    $('.content .button.more, .content .close').click ->
      $(this).parent().toggleClass('expanded')

