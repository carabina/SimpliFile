Pod::Spec.new do |s|
  s.name = 'SimpliFile'
  s.version = '1.0.0'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.summary = 'Two classes for Swift3 to read and write in files more easily (inspired of Java)'
  s.homepage = 'https://github.com/FlPe/SimpliFile'
  s.authors = { 'FlPe' => '<fp051888@gmail.com>' }
  s.source = { :git => 'https://github.com/FlPe/SimpliFile.git', :tag => s.version }

  s.osx.deployment_target = '10.10'
  s.source_files = 'SimpliFile/Classes/*.swift'
end
