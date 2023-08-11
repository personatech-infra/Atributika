Pod::Spec.new do |s|
  s.name         = "AtributikaViews"
  s.version      = "5.0.2"
  s.summary      = "UILabel drop-in replacement."
  s.description  = <<-DESC
    `Atributika` comes with drop-in label replacement `AttributedLabel` which is able to make any detection clickable.
  DESC
  s.homepage     = "https://github.com/psharanda/Atributika"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Pavel Sharanda" => "psharanda@gmail.com" }
  s.social_media_url   = "https://twitter.com/psharanda"
  s.swift_version = '5.1'
  s.ios.deployment_target = "11.0"
  s.source       = { :git => "https://github.com/psharanda/Atributika.git", :tag => s.version.to_s }
  s.source_files = "Sources/Views/**/*.swift"
end

