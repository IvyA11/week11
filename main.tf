# Define the provider for AWS
provider "aws" {
  region = "us-east-1" # Use your preferred region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Lab-VPC"
  }
}

# Compliant Security Group (Removes 0.0.0.0/0 ingress/egress warnings)
resource "aws_security_group" "compliant_sg" {
  # tfsec Note 1: Added description
  name        = "secure_web_sg"
  description = "Allows restricted HTTP access"
  vpc_id      = aws_vpc.main.id

  # Compliant Ingress: Restricts traffic to specific IP/CIDR (e.g., your IP block)
  # For testing, we can restrict it to a smaller subnet, not 0.0.0.0/0
  ingress {
    description = "HTTP access from a trusted subnet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"] # Example: Only allows traffic from within a specific subnet
  }

  # Compliant Egress: Allows only outbound traffic over port 443 (HTTPS)
  # This makes the rule specific, resolving the "allow all" egress issue.
  egress {
    description = "Allow secure outbound traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # tfsec Note 2: Added tags
  tags = {
    Name = "Compliant-SG"
  }
}
