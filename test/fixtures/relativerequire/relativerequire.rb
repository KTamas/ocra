require 'somedir/somefile.rb'
require 'SomeDir/otherfile.rb'
exit 160 if __FILE__ == $0 and defined?(SomeConst) and defined?(OtherConst)
