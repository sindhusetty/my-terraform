variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-east-1"
}

variable "key_name" {
  description = " SSH keys to connect to ec2 instance"
  default     =  "mykey"
}

variable "instance_type" {
  description = "instance type for ec2"
  default     =  "t2.micro"
}
resource "aws_instance" "myFirstInstance" {
  ami           = "ami-02e136e904f3da870"
  key_name = var.key_name
  instance_type = var.instance_type
  subnet_id = "subnet-034a9f6e420bc37e0"
  vpc_security_group_ids = ["sg-0bf3f3b2f96eeabd5"]
  user_data = "${file("nginx.sh")}"
  provisioner "file" {
    source      = "/home/sanjay/terraform/file"
    destination = "/home/ec2-user"
    connection {
       type     = "ssh"
       user     = "ec2-user"
       private_key = file("mykey.pem")
       host     = self.public_ip
     }
  }
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "ec2-user"
      private_key = file("mykey.pem")
      host     = self.public_ip
    }
    inline = [
      "sleep 60s;",
      "sudo cp /home/ec2-user/file/index.html /usr/share/nginx/html/index.html;",
      "sudo cp /home/ec2-user/file/pic_trulli.jpg /usr/share/nginx/html/;",
      "sudo service nginx stop;",
      "sudo service nginx start;",
    ]
  }
tags= {
    Name = "assignment-2"
  }
}
