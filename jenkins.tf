resource "aws_instance" "jenkins-instance"{
ami = " which used ina aws region"
instance_type ="t2.small" //t2.micro


# the vpc subnet

subnet_id = "{mention here created in aws vpc_subnet id}"

# the security group 

vpc_security_group_ids = ["mention here created in aws vpc_security_group_id"]

#public SSH key

key_name = "{aws key pair.key_name}"

#user data

user_data = "${data template}"

}

resources"aws_ebs_volume" "jenkins-data{
avalability_zone = "region what you use"
size = " "
type = "gp2"
tags{
Name = "jenkins-data"

}
}

resources"aws_ebs_volume" "jenkins_data_attachment" {
device_name  = "${ var.instance_device_name}"
volume_id = "${aes_ebs_volume id}"
instance_id = "${aws_instance.id} 
}

