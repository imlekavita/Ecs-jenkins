#app

data "template_file" "myapp-task-defination-template" {
 template  =  "${file("template/app.json.tpl")}"
  vars {
REPOSITORY_URL = "${replace("{$aws_ecr_repository.myapp.repository_url}", "https://", "")}"
APP_VERSION = "${var.MYAPP_VERSION}"
	}
}


resources "aws_ecs_task_defination" "myapp-task-defination" {
family  = "myapp"
container_definations = "${data.template_file.myapp-task-defination-template.rendered}"

}



resources "aws_ecs_service" "myapp-service" {
count = "${var.MYAPP_SERVICE_ENABLE}"
name = "myapp"
cluster = "${aws_ecs_cluser.example-cluster.id}"
task_defintion = "${aws_ecs_task_defination.myapp-task-defination.arn}"
desired_count = 1
iam_role = "${aws_iam_role.ecs-service-role.arn}"
depends_on  = ["aws_iam_policy_attachment.ecs-service-attach"]

load_balancer {

elb_name = "${aws_elb.myapp-elb.name}"
container_name = "myapp"
container_port = 3000
}
lifecycle { ignore_changes = ["task_defination"] }

}


#load balancer
resources "aws_elb"  "myapp-elb" {
 name = "myapp-elb"

Listner {

instance_port = 3000
instance_protocol = "http"
Lb_port = 80
Lb_protocol = "http"

}

heath_check {

healthy_threshold = 3
unhealthy_threshold = 3
timeout = 30
target = "HTTP:3000/"
interval = 60

}

cross_zone_load_balancig = true 
idle_timeout = 400
connection_draining = true
connection_draining_timeout = 400

subnets = ["${aws_subnet.main-public-1.id}", "${aws_subnet.main-public-2.id}"]
security_groups = ["${aws_security_group.myapp-elb-securitygroup.id}"]

tags{
Name = "myapp-elb"

	}
}

