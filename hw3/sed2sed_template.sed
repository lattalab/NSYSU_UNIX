#!/usr/bin/sed
# In another part of the asingment, a cshell script named mgrep will
# pretend to behave like grep. One of the jobs of the mgrep script is
# to take all of the flags passed into it, put them on separate lines,
# and pass them into this sed script that you are now reading. So, the
# inputs to this script are lines that each contain a grep flag. Which
# means that each line begins with a "-".
# Now, there are a few points to note:
#  1. The only flags we need to handle are -n, -o, -v, -i, -w, and -e.
#     Note that the only one of these flags that has more after it is -e.
#  2. The grep search patterns to look for will always be indicated with
#     a -e and with no space after the -e.
#      Eg: cat F | ./mgrep -epattern1 -epattern2
#          cat F | ./mgrep -i -epattern1 -n
#          (ie, not ./mgrep -i -e pattern1 -n or ./mgrep -i pattern1 -n)
#

# Now, on to the assignment:
# As lines enter the Pattern Space (PS), add them to the Hold Space (HS).
# But the /^-e.../ lines must all end up at bottom lines of the HS, with
# their "-e" part being replaced by a "\r".

# Your code here:
     ____________________________________________________________

_____# This command only allows the final input line to proceed

z;G; # Now the commands are all in the PS.

#Let's now handle flags that affect the patterns that match...

# Handle -w by adding a "\<" onto the front (and "\>" onto the back) of
# each regular expression (ie, each match to \r\([^\n]*\).):
/\n-w/ s/______________/g

# Handle -i flag by replacing each letter in the reg.expressions with a
# wildcard match for both cases (eg, the letters "a" and "A" both replace
# with "[Aa]"). But there is a caveat: Do not do this for letters that
# are inside of a "[...]" in the regular expression itself. (Technically,
# grep does know how to use -i with such letters, but I am simplifying
# this issue by just not applying -i to letters matched inside "[...]".)
/\n-i/{
      s/\r/&=/;# The character to the right of this marker will represent
               # the next character to process.
      
  :L; s/___________/\1=/;tL;# Pass the "=" over irelevant characters.
   
      s/___________/\1=/;   # If "=[" then pass "=" over [...].
                            # Note: Must work for all [...].
      # Now use 26 "s" commands to handle the 26 letter pairs:

      # Your code here:
      ____________________________________________________________
      
      tL;   # Loop
      s/=//;# Remove the marker
     }

# At this point, if a user typed: ./mgrep -win "ILuv[Sed]", then PS will
# hold: "\n-w\n-i\n-n\n\r[^\\n]*\<[Ii][Ll][uU][vV][Sed]\>[^\\n]*",
# or    "\n-n\n-i\n-w\n\r[^\\n]*\<[Ii][Ll][uU][vV][Sed]\>[^\\n]*",etc.


So the lines beginning with a "\r" hold the search patterns, and the lines
beginning with a "-" control how to process matches. Let's deal with them:

################
# Deal with -v #
################
#
# If the user used a -v flag, then each pattern is a reason not to print.
# So your job here is to output a set of "/.../d;" commands followed by a
# "p" command.

# Your code here:
/\n-v/{__________;q}


################
# Deal with -n #
################
#
# If the user used a -n flag, then the expected behavior is to print the
# line number as well as the match. Now, as we have seen in Lecture 10,
# slide #6, the "=" command writes to stdout, not the PS, so we will need
# to do something external to make it look right (ie, the pipe into a
# second sed in slide #6 of lecture 10). That "something external" is not
# our present concern; it is "something" that we will deal with later. For
# now, we just want to get the line number to print. The way that we will
# achieve this is that we will put into the hold space one of two things:
#  - "{p}" if no "-n" was requested by the user.
#  - "{i=\\n;=;p}" otherwise.
# So, it is your job to write code to do that here:

# Your code here:
     ____________________________________________________________


####################
# Deal with not -o #
####################
#
# If the user did not give a -o flag, then either the line prints or it
# does not, and any pattern can make it print. But the hold space tells
# us more exactly what to do, because the line # may also needs to print.
# This means that we can't just create code to do: /<pattern>/p, we must
# rather do /<pattern>/{...}, where ... comes from the HS.
# Moreover, it is even more complicated, because we only want to allow a
# line to print once, even if it matched multiple patterns. So we actually
# want /<pattern1>/bL;/pattern2>/bL;...;d;:L;<HS goes here>.

# Your code here:
     ____________________________________________________________


####################################
# Deal with -o, the only case left #
####################################
#
# Now we need to deal with the -o flag, and there are two solutions:
# One for full points, and a more complicated one for extra credit.
# - First, the full points solution:
#    This solution assumes that there can only be one match per line.
#    Its implementation is not so different from your above solution to
#    "/\n-o/!{...}" -- just remember to chopout the part of the line that
#    doesn't match before you print it.
# - Second, the extra credit solution:
#    This solution allows multiple matches per line. But it still has a
#    simplification compared to true grep: If multiple -e's are provided,
#    a match to the first -e will be chosen over a match to later -e's,
#    even if that match starts later on the line from the input stream.

# Your code here:
     ____________________________________________________________
