# Copyright (c) 2011 David Aaron Fendley
#
# Import-to-DEVONthink is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------

# Import to DEVONthnk
def import_to_devonthink(filename, database, folder)
  puts "Importing to DEVONthink..."
  %x[ osascript <<-HDOC
    tell application id "com.devon-technologies.thinkpro2" to launch
    tell application id "com.devon-technologies.thinkpro2"
      set lstFound to databases where name = "#{database}"
      if length of lstFound > 0 then
        set oDb to item 1 of lstFound
        set theFolder to create location "#{folder}" in oDb
        set oWin to open window for record theFolder
        set theRecord to import #{filename} to theFolder
        close oWin
      end if
    end tell
  ]
end