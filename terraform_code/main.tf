#provider
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

#data soruce for ami
data "aws_ami" "ami-amzn2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


data "aws_vpc" "default" {
  default = true
}

resource "aws_default_subnet" "default" {
  availability_zone = "us-east-1a"
  tags = {
    Name = "Default subnet"
  }
}
#ec2 instance 
resource "aws_instance" "linux_vm" {
  ami                    = data.aws_ami.ami-amzn2.id
  key_name               = aws_key_pair.web_key.key_name
  instance_type          = "t3.medium"
  vpc_security_group_ids = [aws_security_group.security_sg.id]
  user_data = "${file("docker_script.sh")}"
  tags = {
    Name = "amazon linux server"
    }
}

#security group
resource "aws_security_group" "security_sg" {
  name        = "allow_http_conn"
  description = "Allow http inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description      = "Http"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
   ingress {
    description      = "Http"
    from_port        = 8081
    to_port          = 8081
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_http"
  }
}


resource "aws_key_pair" "web_key" {
  key_name   = "anmol_key"
  public_key = file("anmol_key.pub")
}

resource "aws_ecr_repository" "catsimage-repo" {
  name                 = "catsimage-repo"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "dogsimage-repo" {
  name                 = "dogsimage-repo"
  image_tag_mutability = "MUTABLE"
}