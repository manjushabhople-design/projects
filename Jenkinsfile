
pipeline{
    agent any
    parameters {
        choice(name: 'BRANCH', choices: ['dev', 'test', 'prod', 'feature/chatapp'], description: 'Select Environment')
    }   
    environment {
        AWS_IAM_CREDS = 'aws-iam-creds' // Replace with your credential ID
        AWS_REGION = 'us-east-1'  // Replace with the appropriate AWS region
    }
     tools {
          jdk 'java'
          maven 'maven' // maven version
        }

    stages{
        stage('clean workspace'){
            steps{
                cleanWs()
            }
        }
        
        stage('Checkout from Git'){
            steps{
                git branch: 'main', url: 'https://github.com/manjushabhople-design/projects.git'
            }
        }
        
        stage("Build "){
            steps {
                sh '''
                    mvn clean install
                '''
            }

        }
        stage("OWASP Dependency check"){
            steps {
                sh '''
                     mvn dependency-check:check
                '''
            }

        }
            
        stage("Build docker image"){
            steps {
                sh '''
                    echo $USER
                    docker build -t dev/chatapp:${BUILD_NUMBER} .
                '''
            }

        }
        stage("push docker image"){
            steps {
                withAWS(credentials: AWS_IAM_CREDS, region: AWS_REGION){
                script{
                sh '''
                    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 307946649652.dkr.ecr.us-east-1.amazonaws.com
                    docker tag dev/chatapp:${BUILD_NUMBER} 307946649652.dkr.ecr.us-east-1.amazonaws.com/dev/chatapp:${BUILD_NUMBER}
                    docker push 307946649652.dkr.ecr.us-east-1.amazonaws.com/dev/chatapp:${BUILD_NUMBER}
                '''
            }
                }

        }

}

       stage("deploy app on ec2"){
        when {
            branch 'feature/*'
            }
            steps {
                script{
                    sshagent(['ec2-creds']) {
                        sh '''
                            ssh -o StrictHostKeyChecking=no ubuntu@52.87.187.234
                                if sudo docker ps -a | grep -q "chat-app"; then
                                    echo "docker container found. Stopping..."
                                        sudo docker stop "chat-app" && sudo docker rm "chat-app"
                                    echo "docker container stopped"
                                fi

                                    sudo docker run --name chat-app \
                                    -p 8081:8080

                        '''
                    }
                }

            }
        }

}
}
