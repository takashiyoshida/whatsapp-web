#!/usr/bin/env ruby

require 'date'
require 'time'

DATAFILE = "whatsapp-test.txt"

if __FILE__ == $0
  # regex for detecting date time string
  message = /(\d{1,2}\/\d{1,2}\/\d{2} \d{1,2}:\d{2}:\d{2} [ap]m): (.+)/
  
  data = File.open(DATAFILE, 'r')
  data.each do | line |
    if mat = message.match(line.chomp)
      # create a DateTime object from a string
      stamp = DateTime.parse("#{mat[1]} SGT", "%d/%m/%y %l:%M:%S %P %Z")
      
      
    end
  end
end
