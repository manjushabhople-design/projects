pipeline{
    agent any

    environment {
        AWS_IAM_CREDS = 'aws-iam-creds' // Replace with your credential ID
        AWS_REGION = 'us-east-1'  // Replace with the appropriate AWS region
    }
     tools {
          jdk 'java'
          maven 'maven'
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
                    //docker build -t manjusha143/chatapp:${BUILD_NUMBER} .
                    docker build -t dev/images/chatapp:${BUILD_NUMBER} .
                '''
            }

        }
        stage("push docker image"){
            steps {
                withAWS(credentials: AWS_IAM_CREDS, region: AWS_REGION)
                script{
                sh '''
                    docker push 307946649652.dkr.ecr.us-east-1.amazonaws.com/dev/images/chatapp:${BUILD_NUMBER}
                '''
            }

        }

}

}
}
