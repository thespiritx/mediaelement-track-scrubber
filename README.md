# MediaElementTrackScrubber

This project rocks and uses MIT-LICENSE.

## How to use (as a dev):
1. Add this gem to your gemfile (mediaelement-track-scrubber)
2. bundle install
3. add the styling assets to your manifest file: ```*= require me-track-scrubber```
4. add the javascript assets to your manifest file: ```//= require me-track-scrubber```
5. You'll need to make changes to a few files too.

* In app/assets/javascripts/avalon_player.js.coffee
   line 25: ```display_track_scrubber = if removeOpt('displayTrackScrubber') then 'trackScrubber' else null```

   line 30: ```features = ['playpause','current','progress','duration','volume','tracks','qualities',thumbnail_selector, add_to_playlist, add_marker,display_track_scrubber, 'fullscreen','responsive']```

   line 39: ```trackScrubberEnabled: true```

   line 108: ```$(@player.media).on 'timeupdate', =>
            @setActiveSection()
            @player.updateTrackScrubber()```

   Line 115: ```#Save because it might be necessary if showing mediafragment of object without structure...
          if _this.stream_info.hasOwnProperty('t')
            trackstart = _this.stream_info.t[0]
            trackend = _this.stream_info.t[1] || _this.stream_info.duration
          else
            trackstart = 0
            trackend = _this.stream_info.duration
          @player.initializeTrackScrubber(trackstart, trackend, _this.stream_info)
          @player.showTrackScrubber(true)```

   Line 166: ```trackstart = parseFloat($(active_node).data('fragmentbegin')||0)||0
          trackend = parseFloat($(active_node).data('fragmentend')||@stream_info.duration)||@stream_info.duration
          @player.initializeTrackScrubber(trackstart, trackend, @stream_info)
          @player.showTrackScrubber(true)```

* In app/views/media_objects/_item_view.html.erb ,
   Line 56: ```<%= render file: '_track_scrubber.html.erb' if current_user.present? %>```

   Line 93: ```displayTrackScrubber: true,```