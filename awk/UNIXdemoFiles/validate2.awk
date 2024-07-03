NF != 3 { print $0, "number of fields not equal to 3" }
0+$2 < 7.25 { print $0, "rate below minimum or incorrect" }
0+$2 > 10 { print $0, "rate exceeds $10 per hour"}
0+$3 < 0 { print $0, "negative hours worked" }
0+$3 > 60 { print $0, "too many hours worked" }
0+$3 != 0 && 0+$3==0{ print $0, "incorrect hours" }
0+$1!=0{ print $0, "incorrect name" }
