pipeline {
agent any

    environment{
        DOCKERHUB_CREDENTIALS = credentials('e08d9a39-11d6-4211-b184-d7f62f6bf3e3')
    }

    triggers {
        pollSCM('* * * * *')
    }

    stages {

        stage('Clean up') {
            steps {
                echo "Cleaning..."
                sh '''
                
                docker stop r-build || true
                docker container rm r-build || true
                docker stop r-test || true
                docker container rm r-test || true
                docker stop r-deploy || true
                
                docker image rm -f react-app
                docker image rm -f react-app-test
                docker image rm -f react-app-deploy
                '''
            }
        }

        stage('Pull'){
            steps{
                echo "Pulling..."
                git branch: "master", credentialsId: 'e08d9a39-11d6-4211-b184-d7f62f6bf3e3', url: "https://github.com/weronikaabednarz/react-app"
                sh 'git config user.email "weronikaabednarz@gmail.com"'
                sh 'git config user.name "weronikaabednarz"'
            }
        }

        stage('Build') {
            steps {
                echo "Building..."
                sh '''
                docker build -t react-app -f ./Dockerfile .
                docker run --name r-build react-app
                docker cp r-build:/react-app/build ./artifacts
                docker logs r-build > build_logs.txt
                '''
            }
        }

        stage('Test') {
            steps {
                echo "Testing..."
                sh '''
                docker build -t react-app-test -f ./Dockerfile2 .
                docker run --name r-test react-app-test
                docker logs r-test > test_logs.txt
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying..."
                sh '''
                
                docker build -t react-app-deploy -f ./Dockerfile3 .
                docker run -p 3000:3000 -d --rm --name r-deploy react-app-deploy
                '''
            }
        }

        stage('Publish') {
            steps {
                echo "Publishing..."
                sh '''
                TIMESTAMP=$(date +%Y%m%d%H%M%S)
                tar -czf artifact_$TIMESTAMP.tar.gz build_logs.txt test_logs.txt artifacts
                
                echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                NUMBER='''+ env.BUILD_NUMBER +'''
                docker tag react-app-deploy weronikaabednarz/react-app:latest
                docker push weronikaabednarz/react-app:latest
                docker logout

                '''
            } 
        }
    }
}