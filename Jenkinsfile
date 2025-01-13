pipeline{
    agent any
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
                    docker build -t manjusha143/chatapp:${BUILD_NUMBER} .
                '''
            }

        }
        

    }

}
