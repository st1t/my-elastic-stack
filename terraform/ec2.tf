data "http" "checkip" {
  url = "https://checkip.amazonaws.com/"
}

resource "aws_security_group" "log_analyzer" {
  name        = "log-analyzer"
  description = "Security group for log analyzer instance"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.checkip.response_body)}/32"]
  }

  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.checkip.response_body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_log_analyzer"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0f36779931e4e31ce" # Canonical, Ubuntu, 24.04 LTS, arm64 noble image build on 2024-07-01
  instance_type = "c7g.xlarge"
  key_name      = local.ssh_key_name
  subnet_id     = local.subnet_id
  root_block_device {
    volume_size = 300
  }
  associate_public_ip_address = true
  security_groups             = [aws_security_group.log_analyzer.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_ssm_instance_profile.name

  tags = {
    Name = "log_analyzer"
  }
}
