(($)->

  $.extend mejs.MepDefaults,
    trackScrubberEnabled: false

  $.extend MediaElementPlayer::,
    buildTrackScrubber: (player, controls, layers, media) ->

      return unless player.options.trackScrubberEnabled

)(mejs.$)
