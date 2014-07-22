#!/usr/bin/env ruby

require 'date'
require 'time'

DATAFILE = "whatsapp-test.txt"

if __FILE__ == $0
  # regex for detecting the beginning of a message
  # each message should begin with a date time stamp
  msg_begin = /(\d{1,2}\/\d{1,2}\/\d{2} \d{1,2}:\d{2}:\d{2} [ap]m): (.+)/
  omitted = /<media omitted>$/
  attached = /(.+) <attached>$/

  data = File.open(DATAFILE, 'r')
  data.each do | line |
    if msg = msg_begin.match(line.chomp)
      # create a DateTime object from a string (timezone is set to SGT)
      #puts "stamp: #{msg[1]}"
      stamp = DateTime.strptime("#{msg[1]} SGT", "%d/%m/%y %l:%M:%S %P %Z")
      line = msg[2].chomp

      if line.index(':').nil?
        puts "status: #{stamp}: #{line}"
      else
        index = line.index(':')
        name = line.slice(0..index - 1)
        line = line.slice(index + 1..-1).strip

        action = "says"
        if o = omitted.match(line)
          action = "<media omitted>"
        elsif a = attached.match(line)
          action = "uploads"
          line = a[1] 
        end

        if action == "<media omitted>"
          puts "action: #{stamp}: #{name}: #{action}"
        else
          puts "action: #{stamp}: #{name} #{action}:"
          puts "#{line}"
        end
      end
    else
      puts "... #{line.chomp}"
    end
  end
end
