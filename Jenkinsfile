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
                    dockerImage = docker.build registry + ":${VERSION}" 
                    sh "docker tag ${registry}:${VERSION} ${registry}:latest"
                    dockerLatest = "${registry}:latest"
                }
            }
        }
        stage('Deploy our image') { 
            steps { 
                script { 
                    docker.withRegistry( '', registryCredential ) { 
                        dockerImage.push() 
                    }
                } 
            }
        } 
                stage('Deploy latest image') { 
            steps { 
                script { 
                    docker.withRegistry( '', registryCredential ) { 
                        dockerLatest.push() 
                    }
                } 
            }
        } 
        stage('Cleaning up') { 
            steps { 
                sh "echo docker rmi $registry:${env.BUILD_ID}"
            }
        } 
    }
}