#--
#     This file is part of the X12Parser library that provides tools to
#     manipulate X12 messages using Ruby native syntax.
#
#     http://x12parser.rubyforge.org 
#     
#     Copyright (C) 2008 APP Design, Inc.
#
#     This library is free software; you can redistribute it and/or
#     modify it under the terms of the GNU Lesser General Public
#     License as published by the Free Software Foundation; either
#     version 2.1 of the License, or (at your option) any later version.
#
#     This library is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#     Lesser General Public License for more details.
#
#     You should have received a copy of the GNU Lesser General Public
#     License along with this library; if not, write to the Free Software
#     Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#++
#
module X12

  #
  # Implements nested loops of segments

  class Loop < Base

#     def regexp
#       @regexp ||= 
#         Regexp.new(inject(''){|s, i|
#                      puts i.class
#                      s += case i
#                           when X12::Segment: "(#{i.regexp.source}){#{i.repeats.begin},#{i.repeats.end}}"
#                           when X12::Loop:    "(.*?)"
#                           else
#                             ''
#                           end
#                    })
#     end

    # Parse a string and fill out internal structures with the pieces of it. Returns 
    # an unparsed portion of the string or the original string if nothing was parsed out.
    def parse_helper(str, yield_loop_name, block)
      # puts "#{$count}: parse for #{name}" if name == yield_loop_name
      $count ||=0
      # $count+=1 if name == yield_loop_name
      # return nil if name == yield_loop_name && (($count+=1) > 2)
      #puts "Parsing loop #{name}: "+str
      current_location = str
      nodes.each{|node|
        match_location = node.parse(current_location, yield_loop_name, block)
        current_location = match_location if match_location
      } 
      if str == current_location
        return nil
      else
        self.parsed_str = str[0..-current_location.length-1]
        block.call(self) if yield_loop_name && name == yield_loop_name
        return current_location
      end
    end # parse

    # Render all components of this loop as string suitable for EDI
    def render
      if self.has_content?
        self.to_a.inject(''){|loop_str, i|
          loop_str += i.nodes.inject(''){|nodes_str, j|
            nodes_str += j.render
          } 
        }
      else
        ''
      end
    end # render

  
    # Formats a printable string containing the loops element's content 
    # added to provide compatability with ruby > 2.0.0 
    def inspect
      "#{self.class.to_s.sub(/^.*::/, '')} (#{name}) #{repeats} =<#{parsed_str}, #{next_repeat.inspect}> ".gsub(/\\*\"/, '"')
    end 


    # Provides looping through repeats of a message    
    def each
      res = self.to_a
      0.upto(res.length - 1) do |x|
        yield res[x]
      end
    end

  end # Loop
end # X12
