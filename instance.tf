provider "aws" {
  region = "us-east-2"   
}
resource "aws_instance" "example" {
  ami           = "ami-024e6efaf93d85776" 
  instance_type = "t2.micro"
  key_name      = "pra-ohio" 
  vpc_security_group_ids = ["sg-0b982a00311d9789d"]
  associate_public_ip_address = true

  tags = {
    Name = "docker"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
              echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
              sudo apt update
              sudo apt install -y docker-ce docker-ce-cli containerd.io
              sudo usermod -aG docker $USER
              sudo systemctl enable docker
              docker version

              EOF
}

output "instance_public_ip" {
  value       = aws_instance.example.public_ip
  description = "Public IP address of the EC2 instance"
}
