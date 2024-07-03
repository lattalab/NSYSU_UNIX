#!/usr/bin/tcsh
# Fill in the blanks below.
# You cannot add any "\" or ";" or "|" symbols.
echo
echo Echo echoed, '"You said, '"'$*:q'"'."'
echo
echo | sed -n 'i Sed'"'"'s "i" said, "You said, '"'$*:q'"'."'
echo
echo $*:q | sed 's_.*_Sed'"'"'s "s" said, "You said, '"'"'&'"'"'."_'
echo
echo $*:q | sed 'i Sed'"'"'s "i" and "a" said, "You said, '"'"'\
                  a '"'"'."'\
 		 | tr -d "\n"; echo
echo
# In the following, you can use ";" (but still no "\" or "|").
# Also, in this case, you cannot use any "^" or "$" or "(" or "&" symbols.
# (This restriction is to force you to meaningfully use the hold space.)
echo $*:q | sed 'x; s_.*_Sed'"'"'s hold space was used to say, "You said, _ ; G; y/\n/'"'"'/; x; s_.*_."_; H; x; y/\n/'"'"'/ '
echo

##### Explained Solution for my idea #####
# Note: use $*:q to indicate the input string.
# 1. x for exchanging the pattern space with the hold space.
# 2. modified pattern space and stored the string "Sed's hold space was used to say, "You said, "
# 3. G for appending the hold space to the pattern space.
# 4. y for replacing the newline character with a single quote.
# now we have the string "Sed's hold space was used to say, "You said, '$*:q" in the pattern space.
# 5. x for exchanging the pattern space with the hold space.
# 6. modified pattern space and stored the string ".""
# 7. H for appending the pattern space to the hold space.
# 8. x for exchanging the pattern space with the hold space.
# 9. y for replacing the newline character with a single quote.
# Therefore, the final output is "Sed's hold space was used to say, "You said, '$*:q'."

#The expected output is:
#  % ./pa2.csh Hello world!
#
#  Echo echoed, "You said, 'Hello world!'."
#
#  Sed's "i" said, "You said, 'Hello world!'."
#
#  Sed's "s" said, "You said, 'Hello world!'."
#
#  Sed's "i" and "a" said, "You said, 'Hello world!'."
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
#  Sed's "i" and "a" said, "You said, 'bye'."
#
#  Sed's hold space was used to say, "You said, 'bye'."
#
#  %
