pipeline{

    agent any

    tools {
        maven 'maven3'
    }

    environment {

        docker_registry = "shady25/vproapp-kube"
        docker_cred = "dockerhub"
        KUBECONFIG = '/opt/jenkins-slave/.kube/config'
    }

    stages{
        
        stage("Building The Artifact"){
            steps{
                sh 'mvn clean install -DskipTest'
            }
            post{
                
                success{
                    echo "Archiving"
                    archiveArtifacts artifacts: "**/target/*.war"
                    
                }
                
            }
        }
    
        stage('Unit Test With Maven'){
            steps {
                sh 'mvn test'
            }
        }

        stage('Integration Test'){
            steps {
                sh 'mvn verify -DskipUnitTests'
            }
        }

        stage ('Code Analysis Wth Checkstyle'){
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
            post {
                success {
                    echo 'Generated Analysis Result'
                }
            }
        }

        stage ('SonarQube Analysis') {

            environment {
             scannerHome = tool 'sonarscanner4'
            }

            steps {
                withSonarQubeEnv('MySonar') {
                    sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
                   -Dsonar.projectName=vprofile-repo \
                   -Dsonar.projectVersion=1.0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                   -Dsonar.junit.reportsPath=target/surefire-reports/ \
                   -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                   -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
                }

                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
        }
    }

    stage ('Building Docker App Image'){
        steps {

            script {

                dockerImg = docker.build docker_registry + ":V$BUILD_NUMBER"
            }
        }
    }

    stage ('Uploading Docker Image'){
        steps {

            script {

                docker.withRegistry('', docker_cred){
                    dockerImg.push ("V$BUILD_NUMBER")
                    dockerImg.push ("latest")
                }
            }
        }
    }

    stage ('Removing Unused Docker Image'){
        steps {

            sh "docker rmi $docker_registry:V$BUILD_NUMBER"
        }
    }


    stage ("K8s Deploy") {

        agent {label 'KOPS'}
        steps {
            echo "KUBECONFIG: $KUBECONFIG"
            
                sh "KUBECONFIG=$KUBECONFIG helm upgrade --install --force vpro-stack helm/vprofilecharts --set appimg=${docker_registry}:V${BUILD_NUMBER} --namespace prod"
            
        }
    }
  }
}