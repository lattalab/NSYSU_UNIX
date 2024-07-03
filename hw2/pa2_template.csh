#!/usr/bin/tcsh
# Fill in the blanks below.
# You cannot add any "\" or ";" or "|" symbols.
echo
echo ______
echo
echo | sed -n "i______
echo
echo $*:q | sed "s______
echo
echo $*:q | sed "i______\
                 a______\
		 | tr -d "\n"; echo
echo
# In the following, you can use ";" (but still no "\" or "|").
# Also, in this case, you cannot use any "^" or "$" or "(" or "&" symbols.
# (This restriction is to force you to meaningfully use the hold space.)
echo $*:q | sed "x;______"
echo

#The expected output is:
#  % ./pa2.csh Hello world!
#
#  Echo echoed, "You said, 'Hello world!'."
#
#  Sed's "i" said, "You said, 'Hello world!'."
#
#  Sed's "s" said, "You said, 'Hello world!'."
#
#  Sed's "i" and "a" said, "You said, ''Hello world!'."
#
#  Sed's hold space was used to say, "You said, 'Hello world!'."
#
#  % ./pa2.csh bye
#
#  Echo echoed, "You said, 'bye'."
#
#  Sed's "i" said, "You said, 'bye'."
#
#  Sed's "s" said, "You said, 'bye'."
#
#  Sed's "i" and "a" said, "You said, ''bye'."
#
#  Sed's hold space was used to say, "You said, 'bye'."
#
#  %
