#!/usr/bin/env ruby

require 'date'
require 'time'

DATAFILE = "whatsapp-test.txt"

if __FILE__ == $0
  # regex for detecting the beginning of a message
  # each message should begin with a date time stamp
  msg_begin = /(\d{1,2}\/\d{1,2}\/\d{2} \d{1,2}:\d{2}:\d{2} [ap]m): (.+)/
  # detect person and the following action
  person = /(.+): (.+)/
  omitted = /<media omitted>$/
  attached = /<attached>$/

  data = File.open(DATAFILE, 'r')
  data.each do | line |
    if msg = msg_begin.match(line.chomp)
      # create a DateTime object from a string (timezone is set to SGT)
      #puts "stamp: #{msg[1]}"
      stamp = DateTime.strptime("#{msg[1]} SGT", "%d/%m/%y %l:%M:%S %P %Z")
      
      if p = person.match(msg[2].chomp)
        name = p[1]
        action = "says"

        if o = omitted.match(p[2].chomp)
          puts "<BADABING>"
          action = "<media omitted>"
        elsif a = attached.match(p[2].chomp)
          puts "<BADABOOM>"
          action = "uploads"
        end

        if action == "<media omitted>"
          puts "action: #{stamp}: #{name}: #{action}"
        else
          puts "action: #{stamp}: #{name} #{action}:"
          puts "#{p[2]}"
        end
      else
        puts "status: #{stamp}: #{msg[2]}"
      end
    else
      puts "... #{line.chomp}"
    end
  end
end
