#############################################
# ec2.tf - Jenkins Master EC2
#############################################

# Get the latest Ubuntu 22.04 LTS AMI in *this* region (us-east-2 via your provider)
data "aws_ami" "ubuntu_2204" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Instance for Jenkins Master
resource "aws_instance" "jenkins_master" {
  ami                    = data.aws_ami.ubuntu_2204.id
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.jenkins_master.id]
  key_name               = "1PU_key"

  associate_public_ip_address = true

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "jenkins-master"
  }
}