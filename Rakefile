# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.spec 'ocra' do
  developer "Lars Christensen", "larsch@belunktum.dk"
end

task :build_stub do
  sh "mingw32-make -C src"
  cp 'src/stub.exe', 'share/ocra/stub.exe'
  cp 'src/stubw.exe', 'share/ocra/stubw.exe'
  cp 'src/edicon.exe', 'share/ocra/edicon.exe'
end

file 'share/ocra/stub.exe' => :build_stub

task :test => :build_stub

task :standalone => [ 'bin/ocrasa.rb' ]

standalone_zip = "bin/ocrasa-#{ENV['VERSION']}.zip"

file standalone_zip => 'bin/ocrasa.rb' do
  chdir 'bin' do
    system "zip ocrasa-#{ENV['VERSION']}.zip ocrasa.rb"
  end
end

task :release_standalone => standalone_zip do
  load 'bin/ocra'
  sh "rubyforge add_release ocra ocra-standalone #{Ocra::VERSION} #{standalone_zip}"
end

file 'bin/ocrasa.rb' => [ 'bin/ocra', 'share/ocra/stub.exe', 'share/ocra/stubw.exe', 'share/ocra/lzma.exe', 'share/ocra/edicon.exe' ] do
  cp 'bin/ocra', 'bin/ocrasa.rb'
  File.open("bin/ocrasa.rb", "a") do |f|
    f.puts "__END__"
    
    stub = File.open("share/ocra/stub.exe", "rb") {|g| g.read}
    stub64 = [stub].pack("m")
    f.puts stub64.size
    f.puts stub64

    stub = File.open("share/ocra/stubw.exe", "rb") {|g| g.read}
    stub64 = [stub].pack("m")
    f.puts stub64.size
    f.puts stub64
    
    lzma = File.open("share/ocra/lzma.exe", "rb") {|g| g.read}
    lzma64 = [lzma].pack("m")
    f.puts lzma64.size
    f.puts lzma64

    lzma = File.open("share/ocra/edicon.exe", "rb") {|g| g.read}
    lzma64 = [lzma].pack("m")
    f.puts lzma64.size
    f.puts lzma64
  end
end

task :clean do
  rm_rf Dir.glob("bin/*.exe")
  sh "mingw32-make -C src clean"
  rm_f 'share/ocra/stub.exe'
  rm_f 'share/ocra/stubw.exe'
  rm_f 'share/ocra/edicon.exe'
end

task :test_standalone => :standalone do
  ENV['TESTED_OCRA'] = 'ocrasa.rb'
  system("rake test")
  ENV['TESTED_OCRA'] = nil
end

def each_ruby_version
  raise "Set RUBIES to point to where you have various versions of Ruby installed" if ENV['RUBIES'].nil?
  root = ENV['RUBIES'].tr '\\', '/'
  Dir.glob(File.join(root, 'ruby*','bin')).each do |path|
    path.tr!('/','\\')
    pathenv = ENV['PATH']
    ENV['PATH'] = path
    begin
      yield
    ensure
      ENV['PATH'] = pathenv
    end
  end
end

task :setup_all_ruby do
  ENV['RUBYOPT'] = nil
  rubygemszip = "rubygems-1.3.4.zip"
  rubygemsdir = rubygemszip.gsub(/\.zip$/,'')
  sh "unzip rubygems-1.3.4.zip"
  begin
    cd "rubygems-1.3.4" do
      each_ruby_version do
        system("ruby -v")
        system("ruby setup.rb")
        system("gem install win32-api")
      end
    end
  ensure
    rm_rf "rubygems-1.3.4"
  end
end

desc 'Run test suite with all version of Ruby found in ENV["RUBIES"]'
task :test_all_rubies do
  each_ruby_version do
    system("ruby -v")
    system("ruby test/test_ocra.rb")
  end
end

desc 'List all version of Ruby found in ENV["RUBIES"]'
task :list_all_rubies do
  each_ruby_version do
    system "ruby -v"
  end
end

task :release_docs => :redocs do
  sh "pscp -r doc/* ocra.rubyforge.org:/var/www/gforge-projects/ocra"
end


# vim: syntax=Ruby
