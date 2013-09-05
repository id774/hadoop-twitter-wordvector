#!/opt/ruby/current/bin/ruby
# -*- coding: utf-8 -*-

$:.unshift File.join(File.dirname(__FILE__))

class Reducer
  def self.reduce(stdin)
    stdin.each_line {|line|
      puts "#{line}"
    }
  end
end

if __FILE__ == $0
  Reducer.reduce($stdin)
end
