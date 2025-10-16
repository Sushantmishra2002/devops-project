pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = 'docker-hub'
        EC2_SSH_CREDENTIALS = 'ec2-ssh'
        DOCKER_IMAGE = 'sushantmishra2002/blog-app:latest'
        EC2_HOST = '13.62.49.93'
        EC2_USER = 'ec2-user'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Sushantmishra2002/devops-project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t blog-app .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: env.DOCKER_HUB_CREDENTIALS,
                                                 passwordVariable: 'DOCKER_PASS',
                                                 usernameVariable: 'DOCKER_USER')]) {
                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker tag blog-app $DOCKER_USER/blog-app:latest
                        docker push $DOCKER_USER/blog-app:latest
                    '''
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent([env.EC2_SSH_CREDENTIALS]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST '
                        docker pull $DOCKER_IMAGE &&
                        docker stop blog-app || true &&
                        docker rm blog-app || true &&
                        docker run -d -p 80:80 --name blog-app $DOCKER_IMAGE'
                    """
                }
            }
        }
    }
}
