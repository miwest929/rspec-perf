Gem::Specification.new do |s|
  s.name = 'rspec-perf'
  s.version = '0.0.0'
  s.date = '2013-09-13'
  s.summary = 'Allows one to easily write performance tests in rspec'
  s.description = 'Allows one to easily write performance tests in rspec'
  s.authors = ['Michael West', 'Matt Szenher']
  s.files = ['lib/rspec_perf.rb']
  s.require_paths = ["lib"]

  s.add_dependency('statsample')
  s.add_dependency('rspec')
end
