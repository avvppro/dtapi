#!groovy
properties([disableConcurrentBuilds()])

pipeline {
    environment { 
        registry = "avvppro/dt-back" 
        registryCredential = 'dockerhub_id' 
        dockerImage = '' 
        VERSION = "${env.BUILD_ID}-${env.GIT_COMMIT}"
    }
    agent any
    stages {
        stage("Make Backend Files") {
            steps {
                sh 'git clone https://github.com/koseven/koseven'
                sh 'mkdir ./application/logs ./application/cache'
                sh 'chmod 766 ./application/logs'
                sh 'chmod 766 ./application/cache'
                sh 'mv ./koseven/public/index.php ./'
                sh 'mv ./koseven/modules/ ./'
                sh 'mv ./koseven/system/ ./'
            }
        }
        stage("Clean Useless Files") {
            steps {
                sh "rm -rf koseven/ dtapi.sql README.md .git .gitignore .dockerignore"
            }
        }
        stage("Build Docker Image") {
            steps {
                script { 
                    dockerImage = docker.build registry 
                }
            }
        }
        stage('Deploy our image') { 
            steps { 
                script { 
                    docker.withRegistry( '', registryCredential ) { 
                        dockerImage.push("${VERSION}") 
                        dockerImage.push("latest") 
                    }
                } 
            }
        } 
        stage('Cleaning up') { 
            steps { 
                sh "echo docker rmi $registry:${VERSION}"
                sh "echo docker rmi $registry:latest"
            }
        } 
    }
}