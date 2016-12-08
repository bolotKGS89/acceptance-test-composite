open(SG, "aws ec2 describe-security-groups |");
$group_name = "";
$group_id = "";
while(<SG>) {
	#print;
	if (/GroupName.*\"(.+)\"/) {
		$group_name = $1;
		#print "group_name: $group_name\n";
	}
	if (/GroupId.*\"(.+)\"/) {
		$group_id = $1;
		#print "group_id: $group_id\n";
		if ($group_name =~ /\_ac\-cat/) {
			#print "group_id of $group_name is $group_id\n";
			print "$group_id\n";
			$group_id = "";
			$group_name = "";		
		}
	}
}