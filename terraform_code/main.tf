provider "aws" {
    profile = "default"
    region = "us-east-1"
}

#data soruce for ami
data "aws_ami" "ami-amzn2" {
    most_recent = true
    owners = ["amazon"]
    
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

#availiability zones in us east
data "aws_availability_zones" "available" {
  state = "available"
}

#default vpc id
data "aws_vpc" "default" {
  default = true
}

resource "aws_default_subnet" "default" {
  availability_zone = "us-east-1a"
  tags = {
    Name = "Default subnet"
  }
}



#EC2 instance in default vpc 
resource "aws_instance" "linux_vm" {
  ami                    = data.aws_ami.ami-amzn2.id
  key_name               = key_pair.web_key.key_name
  instance_type          = "t2.micro"
  tags = {
    Name = "Ec2 amazon linux"
    }
}

#ssh key
resource "key_pair" "web_key" {
  key_name   = "anmol_key"
  public_key = file("anmol_key.pub")
}