NF != 3 { print $0, "number of fields not equal to 3" }
$2 < 7.5{ print $0, "rate below minimum or incorrect" }
$2 > 10 { print $0, "rate exceeds $10 per hour"}
$3 < 0  { print $0, "negative hours worked" }
$3 > 60 { print $0, "too many hours worked" }
