
# challenge_cicd

# Topology
![enter image description here](https://raw.githubusercontent.com/fauzanooor/challenge_cicd/main/topology-cicd.png)

# Step 1 - Prepare for the EC2 Instance
For the EC2 instance we can use Ubuntu 18.04, and install the docker + webhook package on there, below are for the commands:

    sudo apt-get update
    sudo apt-get remove docker docker-engine docker.io
    sudo apt install -y docker.io webhook

Start and enable autostart docker service:

    sudo systemctl start docker
    sudo systemctl enable docker

Create webhook file

    mkdir $HOME/dev
    cd $HOME/dev
    wget https://raw.githubusercontent.com/fauzanooor/challenge_cicd/main/webhook/hooks.json
    wget https://raw.githubusercontent.com/fauzanooor/challenge_cicd/main/webhook/deploy.sh

Start webhook

    webhook -hooks /home/ubuntu/dev/hooks.json -verbose &

And also, allow port 9000 from EC2 security group, which used by webhook service


# Step 2 - Create Pipeline for Build and Deploy Docker Image with Github

From github repository, go to **Settings** > **Secrets** and add 3 new repository secret for:

 1. DOCKERHUB_PASSWORD: the password of Dockerhub account
 2. DOCKERHUB_USERNAME: email or username of Dockerhub account
 3. WEBHOOK_URL: URL of webhook (url format will be like this `http://{EIP EC2}:9000/hooks/deploycontainer`)

After those 3 secrets are added, create a yaml file that named `docker_cicd.yaml` on this directory `.github/workflows/`. 

And on that file is contain some paramaters to run the CI/CD pipeline, and here's the explanation:

 - pipeline will be triggered, when the `Dockerfile` file is changing on `main` branch of this repository
 - When the pipeline is running, there will be 2 jobs. 
 
 -- **First**, to the build the docker image from Dockerfile and also push it to the Dockerhub. 
 
 -- **Second**, will be running a webhook action that targetting to EC2 instance on the previous step, so after the docker image is already stored into Dockerhub, the EC2 instance will be pull it and launch it again (refer to the topology)

# Result
Everytime if there's some updates on `Dockerfile` file, it will be triggering the pipeline and refreshing the docker container on the EC2 instance
