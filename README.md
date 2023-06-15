# Background: What will we do? How will we do it? 
For this project, we will be setting up a minecraft server using an EC2 instance that we set up with Terraform. 

# Requirements:
# What will the user need to configure to run the pipeline?
The user will need to configure an EC2 instance using Terraform. Then, after they connect to the EC2 instance, they will need to configure the minecraft server itself, as well as a minecraft.service file that will automatically start and stop the server when the EC2 instance is booted up.

# What tools should be installed?
On the user's local machine, they will install terraform.
On the EC2 instance, they will install jdk and jre 17, and the latest minecraft.jar

# Are there any credentials or CLI required?
The user needs to have an academy account with AWS, and they will need to set up the following CLI's using the instructions at the given links.
[Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
[AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

# Should the user set environment variables or configure anything?
The user needs to create a file, `~/.aws/credentials`
Within this file, they need to copy-paste their AWS credentials. They can find this on their learner lab on canvas

# Diagram of the major steps in the pipeline.
1. Configure Terraform EC2 Instance
2. SSH into the EC2 instance
3. Configure all Minecraft Server files

# List of commands to run, with explanations.
`./configure`
This command will set up all terraform-related files

`terraform init`
`terraform apply`
These commands set up the EC2 instance using terraform

`ssh -i "../../../tf-key-pair" admin@ec2-<IP ADDRESS>.compute-1.amazonaws.com`
This command will ssh the user into their EC2 instance. This is an example of the command with the IP address filled in:
`ssh -i "../../../tf-key-pair" admin@ec2-3-226-247-127.compute-1.amazonaws.com`

`./configure.sh`
This command will set up the minecraft server and service and all related files

# How to connect to the Minecraft server once it's running?
To connect to the Minecraft server, the user can open their Minecraft app, go to Multiplayer->Direct Connection and then copy-paste their EC2 Instance's Public IP address. This address can be found by typing 'terraform output' on their local machine in the folder they set up terraform in
