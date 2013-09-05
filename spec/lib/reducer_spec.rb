#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'rubygems'
require 'rspec'
require 'json'

class Reducer
  def self.run
    `cat data/* | ruby lib/mapper.rb | ruby lib/reducer.rb`
  end
end

describe Reducer do
  it 'should created word_vector in json objects' do
    expected = []
    expected << '曲,好き,RT,人,名前,説明'
    expected << 'RT,mnishi,全体,人間,眼球,寿命,年,電機,業界,不可避,問題,医師,研究,者,国際,会議,開催,Tech,On,http,t,co,OjEgHkyRJg'
    expected << '水,勢,毎日'
    expected << 'http,t,co,Jyhjq,mxEt,東京,進撃,巨人,夏休み,月,日,月,月,夏,年,宿題,進撃,劣化,月'
    expected << '何'
    expected << '番,塩'
    expected << '以外,水族館'
    expected << '宙吊り'
    expected << '編集,付き合い'
    i = 0

    result = Reducer.run
    result.each_line {|line|
      json = line.scan(/\{.*\}/).join
      JSON.parse(json).each {|k,v|
        if k == "word_vector"
          if i < 9
            puts "Testing #{i} of lines"
            v.should eql expected[i]
          end
          i += 1
        end
      }
    }
  end
end
