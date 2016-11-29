$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "media_element_track_scrubber/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "media_element_track_scrubber"
  s.version     = MediaElementTrackScrubber::VERSION
  s.authors     = ["Leah Lee"]
  s.email       = ["lmb@iu.edu"]
  s.homepage    = "https://github.com/avalonmediasystem/media-element-track-scrubber"
  s.summary     = "Add an additional scrubber for tracks."
  s.description = "Add an additional scrubber for tracks."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.13"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'guard-coffeescript'
end
