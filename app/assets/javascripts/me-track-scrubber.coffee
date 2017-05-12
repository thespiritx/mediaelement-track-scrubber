(($)->

  $.extend mejs.MepDefaults,
    trackScrubberEnabled: false

  $.extend MediaElementPlayer::,
    buildtrackScrubber: (player, controls, layers, media) ->
      return unless player.options.trackScrubberEnabled
      button = $("<div class='mejs__button mejs__track-scrubber track-scrubber-show'>
                    <button type='button' aria-controls='mep_0' title='Toggle Track Scrubber' aria-label='Toggle Track Scrubber'/>
                  </div>")
      button.appendTo(controls)
      button.click (event) ->
        player.showTrackScrubber($('#track_scrubber').css('display')=='none')

    showTrackScrubber: (show = true) ->
      if show
        $('.mejs__controls .mejs__track-scrubber').addClass('track-scrubber-hide')
        $('.mejs__controls .mejs__track-scrubber').removeClass('track-scrubber-show')
        $('#track_scrubber').css('display','block')
        this.resizeTrackScrubber()
      else
        $('.mejs__controls .mejs__track-scrubber').addClass('track-scrubber-show')
        $('.mejs__controls .mejs__track-scrubber').removeClass('track-scrubber-hide')
        $('#track_scrubber').css('display','none')

    updateTrackScrubber: ->
      trackoffset = this.getCurrentTime() - this.trackdata['starttime']
      trackpercent = Math.min(100, Math.max(0,(100 * trackoffset / this.trackdata['trackduration'])))
      $('.track-mejs__time-current').width(Math.round(trackpercent)+'%')
      $('.track-mejs__currenttime').text(mejs.Utility.secondsToTimeCode(trackoffset, false))

    resizeTrackScrubber: ->
      timeWidth = $('.track-mejs__currenttime-container').outerWidth()
      durationWidth = $('.track-mejs__duration-container').outerWidth()
      railWidth = this.controls.width() - timeWidth - durationWidth - 5
      $('.track-mejs__time-rail').width(railWidth)
      total = $('.track-mejs__time-total')
      total.width(railWidth - (total.outerWidth(true) - total.width()))

    initializeTrackScrubber: (trackstart, trackend, stream_info) ->
      return unless stream_info.hasOwnProperty('t') and this.options.trackScrubberEnabled
      duration = stream_info.duration
      trackduration = trackend - trackstart
      $currentTime = $('.track-mejs__currenttime')
      $currentTime.text(mejs.Utility.secondsToTimeCode(Math.max(0,this.getCurrentTime()-trackstart), false))
      this.trackdata = {}
      this.trackdata['starttime'] = trackstart
      this.trackdata['endtime'] = trackend
      this.trackdata['duration'] = duration
      this.trackdata['trackduration'] = trackduration
      $duration = $('.track-mejs__duration')
      $duration.text(mejs.Utility.secondsToTimeCode(parseInt(trackduration), false))

      start_percent = Math.max(0,Math.min(100,Math.round(100*trackstart / duration)))
      end_percent = Math.max(0,Math.min(100,Math.round(100*trackend / duration)))
      clip_span = $('<span />').addClass('mejs__time-clip')
      trackbubble = $('<span class="mejs__time-clip">')
      trackbubble.css 'left', start_percent+'%'
      trackbubble.css 'width', end_percent-start_percent+'%'
      $('.mejs__time-clip').remove()
      unless start_percent==0 and end_percent==100
        $('.mejs__time-total').append trackbubble
      t = this
      total = $('.track-mejs__time-total')
      current = $('.track-mejs__time-current')
      handle = $('.track-mejs__time-handle')
      timefloat = $('.track-mejs__time-float')
      timefloatcurrent = $('.track-mejs__time-float-current')
      slider = $('.track-mejs__time-slider')
      media = t.media
      mouseIsDown = false
      mouseIsOver = false
      handleMouseMove = (e) ->
        offset = total.offset()
        width = total.width()
        percentage = 0
        newTime = 0
        pos = 0
        x = undefined
        # mouse or touch position relative to the object
        if e.originalEvent and e.originalEvent.changedTouches
          x = e.originalEvent.changedTouches[0].pageX
        else if e.changedTouches
          # for Zepto
          x = e.changedTouches[0].pageX
        else
          x = e.pageX
        if media.duration
          if x < offset.left
            x = offset.left
          else if x > width + offset.left
            x = width + offset.left
          pos = x - (offset.left)
          percentage = pos / width
          newTime = if percentage <= 0.02 then 0 else percentage * t.trackdata.trackduration
          # seek to where the mouse is
          if mouseIsDown and newTime != media.currentTime
            media.setCurrentTime(newTime + t.trackdata.starttime)
          # position floating time box
          if !mejs.MediaFeatures.hasTouch
            timefloat.css 'left', pos
            timefloatcurrent.html mejs.Utility.secondsToTimeCode(newTime, false)
            timefloat.show()

      total.bind('mousedown touchstart', (e) ->
        # only handle left clicks or touch
        if e.which == 1 or e.which == 0
          mouseIsDown = true
          handleMouseMove e
          t.globalBind 'mousemove.dur touchmove.dur', (e) ->
            handleMouseMove e
            return
          t.globalBind 'mouseup.dur touchend.dur', (e) ->
            mouseIsDown = false
            timefloat.hide()
            t.globalUnbind '.dur'
            return
        return
      ).bind('mouseenter', (e) ->
        mouseIsOver = true
        t.globalBind 'mousemove.dur', (e) ->
          handleMouseMove e
          return
        if !mejs.MediaFeatures.hasTouch
          timefloat.show()
        return
      ).bind 'mouseleave', (e) ->
        mouseIsOver = false
        if !mouseIsDown
          t.globalUnbind '.dur'
          timefloat.hide()
        return

)(mejs.$)
