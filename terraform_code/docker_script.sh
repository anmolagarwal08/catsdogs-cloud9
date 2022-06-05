#!/bin/bash
sudo yum update -y
yum install docker -y
sudo systemctl start docker
sudo gpasswd -a $USER docker
sudo usermod -aG docker ec2-user
