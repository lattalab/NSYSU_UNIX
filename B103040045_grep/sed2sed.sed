#!/usr/bin/sed -f
# In another part of the asingment, a cshell script named mgrep will
# pretend to behave like "grep". One of the jobs of the mgrep script is
# to take all of the flags passed into it, put them on separate lines,
# and pass them into this sed script that you are now reading. 
# 將所有傳遞給 "mgrep" 的flag們，放在每個不同的行，再傳遞這個Sed腳本
# So, the
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
# As lines enter the Pattern Space (PS), add them to the Hold Space (HS). -> H?
# But the /^-e.../ lines must all end up at bottom lines of the HS, with ->  /^-e.*$/ s/-e/\r/1
# their "-e" part being replaced by a "\r".

# Your code here:
# 遇到 -e 之前一直附加到HS
# 之後開始遇到 -e 就把所有行讀到PS，最後用替換的把-e都移到最後
# 又需要把-e換成-r，最後一起附加到HS
{
     /-[^e]/ {:x; H; 1h; N; s/.*\n//; /-[^e]/tx;};
     /^-e/ {:a; $!N; s/\(-e.*\)\n\(.*\)/\2\n\1/g; $!ba; s/-e/\r/g; H;};
}
# This command only allows the final input line to proceed

z;G; # Now the commands are all in the PS.
# z	→ “Zap” the pattern space (equivalent to: s/.//g).
# G	→ Append the hold space into the pattern space

#Let's now handle flags that affect the patterns that match...

# Handle -w by adding a "\<" onto the front (and "\>" onto the back) of
# each regular expression (ie, each match to \r\([^\n]*\).):
# -w: match the whole string
/\n-w/ s/\r\([^\n]*\)/\r\\<\1\\>/g;
s/\n-w/\n#-w/;    # 註解掉flag

# Handle -i flag by replacing each letter in the reg.expressions with a
# wildcard match for both cases (eg, the letters "a" and "A" both replace
# with "[Aa]"). But there is a caveat: Do not do this for letters that
# are inside of a "[...]" in the regular expression itself. (Technically,
# grep does know how to use -i with such letters, but I am simplifying
# this issue by just not applying -i to letters matched inside "[...]".)
/\n-i/{
      s/\r/&=/;     # The character to the right of this marker will represent
                                   # the next character to process.
      
      :L; s/=\([^[A-Za-z]\)/\1=/; tL; # Pass the "=" over irelevant characters.
   
      s/=\([.*]\)/\1=/;   # If "=[" then pass "=" over [...].
                            # Note: Must work for all [...].
      # Now use 26 "s" commands to handle the 26 letter pairs:

      # Your code here:

     s/=[Aa]/[Aa]=/;
     s/=[Bb]/[Bb]=/;
     s/=[Cc]/[Cc]=/;
     s/=[Dd]/[Dd]=/;
     s/=[Ee]/[Ee]=/;
     s/=[Ff]/[Ff]=/;
     s/=[Gg]/[Gg]=/;
     s/=[Hh]/[Hh]=/;
     s/=[Ii]/[Ii]=/;
     s/=[Jj]/[Jj]=/;
     s/=[Kk]/[Kk]=/;
     s/=[Ll]/[Ll]=/;
     s/=[Mm]/[Mm]=/;
     s/=[Nn]/[Nn]=/;
     s/=[Oo]/[Oo]=/;
     s/=[Pp]/[Pp]=/;
     s/=[Qq]/[Qq]=/;
     s/=[Rr]/[Rr]=/;
     s/=[Ss]/[Ss]=/;
     s/=[Tt]/[Tt]=/;
     s/=[Uu]/[Uu]=/;
     s/=[Vv]/[Vv]=/;
     s/=[Ww]/[Ww]=/;
     s/=[Xx]/[Xx]=/;
     s/=[Yy]/[Yy]=/;
     s/=[Zz]/[Zz]=/;
      
     tL;   # Loop
     s/=//;# Remove the marker
     s/\n-i/\n#-i/;    # 註解掉flag
}

# At this point, if a user typed: ./mgrep -win "ILuv[Sed]", then PS will
# hold: "\n-w\n-i\n-n\n\r[^\\n]*\<[Ii][Ll][uU][vV][Sed]\>[^\\n]*",
# or    "\n-n\n-i\n-w\n\r[^\\n]*\<[Ii][Ll][uU][vV][Sed]\>[^\\n]*",etc.

# So the lines beginning with a "\r" hold the search patterns, and the lines
# beginning with a "-" control how to process matches. Let's deal with them:

################
# Deal with -v #
################
#
# If the user used a -v flag, then each pattern "is a reason not to print".
# So your job here is to output a set of "/.../d;" commands followed by a
# "p" command.
# 把那些pattern刪掉的意思 寫出一個Sed subcommand能實現這功能
# Your code here:
/\n-v/{
     s_\r\([^\n]*\)_\r/\1/d;_g; 
     /\n-o/{s/.*/d;/; q;}    # 防止-v跟-o同時出現的情況
};
/\n-v/!{
     s_\r\([^\n]*\)_\r/\1/_g;
};
s/\n-v/\n#-v/;    # 註解掉flag

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
:A
     h;
     /\n-n/{
          /\r\([^\n]*\)/{s/.*/{i=\n=; \np}/;};
          x;
     };
     # 沒有 -n 的話
     /\n-n/ !{s/.*/{p}/; x;};
s/\n-n/\n#-n/;    # 註解掉flag

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
# 在檔案中寫入相關邏輯 (檔案中才有pattern)
/\n-o/ !{
     /\r\([^\n]*\)/ s//&bL/g;
     G;
     s/{\(.*\)}/d;\n:L \1\nd;/;
}

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
/\n-o/{
     /\r\([^\n]*\)/ s//&bL/g; 
     G;
     s/{\(.*\)\(p\)}/d;\n:L \1s__%\&%_; s_.*%\\(.*\\)%.*_\\1_; /;
}
s/\n-o/\n#-o/;    # 註解掉flag
