#!/opt/ruby/current/bin/ruby
# -*- coding: utf-8 -*-

$:.unshift File.join(File.dirname(__FILE__))

require 'date'
require 'time'
require 'MeCab'
require 'json'

class Mapper
  def initialize
    @mecab = MeCab::Tagger.new("-Ochasen")
  end

  def map(stdin)
    stdin.each_line {|line|
      uid = screen_name = id_str = ""
      word_vector = Array.new
      tag = "twitter.statuses"
      # datetime, tag, json = line.force_encoding("utf-8").strip.split("\t")
      json = line.force_encoding("utf-8").scan(/\{.*\}/).join
      hash = JSON.parse(json)
      hash.each {|k,v|
        uid = v.to_s if k == "uid"
        screen_name = v if k == "screen_name"
        if k == "text"
          pickup_nouns(v).each {|word|
            if word =~ /[亜-腕]/
              word_vector.push word
            end
            if word =~ /^[A-Za-z].*/
              word_vector.push word if word.length > 2
            end
          }
        end
      }
      hash["word_vector"] = word_vector.join(",")
      id = screen_name + "," + uid 
      mapper_output(id,tag,hash)
    }
  end

  private

  def mapper_output(id,tag,hash)
    puts "#{id}\t#{tag}\t#{JSON.generate(hash)}"
  end

  def pickup_nouns(string)
    node = @mecab.parseToNode(string)
    nouns = []
    while node
      if /^名詞/ =~ node.feature.force_encoding("utf-8").split(/,/)[0] then
        nouns.push(node.surface.force_encoding("utf-8"))
      end
      node = node.next
    end
    nouns
  end
end

if __FILE__ == $0
  mapper = Mapper.new
  mapper.map($stdin)
end

