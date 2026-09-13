pipeline {

    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
                sh 'echo "===== TARGET DIRECTORY ====="'
                sh 'ls -lah target/'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:sonar'
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Archive WAR') {
            steps {
                archiveArtifacts artifacts: 'target/*.war',
                                 fingerprint: true
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                deploy adapters: [
                    tomcat9(
                        credentialsId: 'tomcat-credentials',
                        url: 'http://172.31.70.61:8080'
                    )
                ],
                contextPath: 'devops-demo-app',
                war: 'target/devops-demo-app.war'
            }
        }
    }

    post {

        success {
            echo 'CI Pipeline completed successfully!!!'
        }

        failure {
            echo 'CI Pipeline failed!'
        }

    }
}
