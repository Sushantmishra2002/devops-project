pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = 'docker-hub'
        EC2_SSH_CREDENTIALS = 'ec2-ssh'
        DOCKER_IMAGE = 'your-dockerhub-username/blog-app:latest'
        EC2_HOST = 'your-ec2-public-ip'
        EC2_USER = 'ec2-user'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/<YOUR-USERNAME>/blog-app.git'
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
