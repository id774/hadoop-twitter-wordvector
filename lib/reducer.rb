#!/opt/ruby/current/bin/ruby
# -*- coding: utf-8 -*-

$:.unshift File.join(File.dirname(__FILE__))

class Reducer
  def reduce(stdin)
    stdin.each_line {|line|
      puts "#{line}"
    }
  end
end

if __FILE__ == $0
  reducer = Reducer.new
  reducer.reduce($stdin)
end
