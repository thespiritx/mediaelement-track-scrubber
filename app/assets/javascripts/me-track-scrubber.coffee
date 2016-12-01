(($)->

  $.extend mejs.MepDefaults,
    trackScrubberEnabled: false

  $.extend MediaElementPlayer::,
    buildTrackScrubber: (player, controls, layers, media) ->
      return unless player.options.trackScrubberEnabled
      player.media.on 'timeupdate', => @updateTrackScrubber

    initializeTrackScrubber: (initialtime, stream_info) ->
      return unless stream_info.hasOwnProperty('t') and this.options.displayTrackScrubber
      duration = stream_info.duration
      trackstart = stream_info.t[0]
      trackend = stream_info.t[1] || duration
      trackduration = trackend - trackstart
      $currentTime = $('.track-mejs-currenttime')
      $currentTime.text(mejs.Utility.secondsToTimeCode(initialtime-trackstart, false))
      this.trackdata = {}
      this.trackdata['starttime'] = trackstart
      this.trackdata['endtime'] = trackend
      this.trackdata['duration'] = duration
      this.trackdata['trackduration'] = trackduration
      $duration = $('.track-mejs-duration')
      $duration.text(mejs.Utility.secondsToTimeCode(trackduration, false))
      $('#track_scrubber').css('visibility','visible')

    updateTrackScrubber: ->
      trackoffset = this.getCurrentTime() - this.trackdata['starttime']
      trackpercent = Math.min(100, Math.max(0,(100 * trackoffset / this.trackdata['trackduration'])))
      $('.track-mejs-time-current').width(Math.round(trackpercent)+'%')
      $('.track-mejs-currenttime').text(mejs.Utility.secondsToTimeCode(trackoffset, false))

)(mejs.$)
