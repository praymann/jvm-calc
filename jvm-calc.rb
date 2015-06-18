#!/usr/bin/env ruby

require 'open3'
require 'filesize'

java = "java -XX:+PrintFlagsFinal " + ARGV.join(" ") + " -version"
# java = "java -Xmx6g -Xms6g -XX:MaxPermSize=128 -XX:SurvivorRatio=3 -version
grep = " | egrep -i 'maxheapsize| survivorratio| newsize | newratio' "

command = java + grep

captured_stdout = ''
captured_stderr = ''

exit_status = Open3.popen3(command) {|stdin, stdout, stderr, wait_thr|
  pid = wait_thr.pid # pid of the started process.
  stdin.close
  captured_stdout = stdout.read
  captured_stderr = stderr.read
  wait_thr.value # Process::Status object returned.
}

# puts "STDOUT: " + captured_stdout
# puts "EXIT STATUS: " + (exit_status.success? ? 'succeeded' : 'failed')

# Clean up the OUTPUT a little
#
# Split it into words into an array
output = captured_stdout.split(/\W+/)

# Reject null elements
output.reject! { |i| i.empty? }

# Remove crud
output.delete_if { |i| i.match(/product|pdproduct|intx|uintx|pd/) }

# I like Hash Browns
hashoutput = Hash[*output]

# Give NewRatio of X, OldSize will always be X times as large as NewSize ( Setting NewSize statically overrides )
if hashoutput.include? "NewSize" and hashoutput["NewSize"].to_i > 1572864 
  hashoutput["OldSize"] = hashoutput["MaxHeapSize"].to_i - hashoutput["NewSize"].to_i
else
  # NewSize = Heap - (( Heap / ( NewRatio + 2 )) * 2)
  hashoutput["NewSize"] = hashoutput["MaxHeapSize"].to_i  - ( ( hashoutput["MaxHeapSize"].to_i / ( hashoutput["NewRatio"].to_i + 2 ) ) * 2 )

  # We know New, Old is simple now
  hashoutput["OldSize"] = hashoutput["MaxHeapSize"].to_i  - hashoutput["NewSize"].to_i
end

# Eden = NewSize - ((NewSize / ( SurvivorRatio + 2)) * 2)
hashoutput["EdenSize"] = hashoutput["NewSize"].to_i  - ( ( hashoutput["NewSize"].to_i / ( hashoutput["SurvivorRatio"].to_i + 2 ) ) * 2 )

# We know Eden, Survivor is simple now
hashoutput["To/FromSurvivorSpace"] = ( hashoutput["NewSize"].to_i - hashoutput["EdenSize"].to_i ) / 2
hashoutput["TotalSurvivorSpace"] = ( hashoutput["NewSize"].to_i - hashoutput["EdenSize"].to_i )

# Print it back
hashoutput.sort.each do | key, value |
  if key.include? "Ratio"
    puts "#{key}   : #{value}"
  else
    puts "#{key}   : #{Filesize.from("#{value} B").pretty}"
  end
end
