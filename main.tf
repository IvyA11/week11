resource "aws_instance" "vulnerable_server" {
  # tfsec will flag this for using a default unencrypted volume (if not specified)
  ami           = "ami-068c0051b15cdb816" # Replace with a valid AMI ID
  instance_type = "t2.micro"

  # tfsec will flag this for overly permissive ingress rules (port 22 open to the world)
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  # Missing "root_block_device" or "ebs_block_device" arguments with encryption set to true
  # is a common tfsec alert.

  tags = {
    Name = "Vulnerable-Test-Server"
  }
}

resource "aws_security_group" "allow_all" {
  # tfsec will flag this because ingress allows "0.0.0.0/0" (all IPs)
  name        = "allow_all_ssh"
  description = "Allow inbound SSH traffic from anywhere"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allows all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}
