#!groovy
properties([disableConcurrentBuilds()])

pipeline {
    environment { 
        registry = "avvppro/dtester" 
        registryCredential = 'dockerhub_id' 
        dockerImage = '' 
    }
    agent any
    stages {
        stage("Make Backend Files") {
            steps {
                sh "rm -rf ./!(*file)"
                sh 'git clone https://github.com/koseven/koseven'
                sh 'mkdir ./application/logs ./application/cache'
                sh 'chmod 766 ./application/logs'
                sh 'chmod 766 ./application/cache'
                sh 'mv ./koseven/public/index.php ./'
                sh 'mv ./koseven/modules/ ./'
                sh 'mv ./koseven/system/ ./'
            }
        }
        stage("Set variables") {
            steps {
                sh "sed -i 's|RewriteBase /|RewriteBase /dtapi/|g' ./.htaccess"
                sh "sed -i '107s|/|/dtapi/|g' ./application/bootstrap.php"
                sh "sed -i 's/PDO_MySQL/PDO/g' ./application/config/database.php"
            }
        }
        stage("Build Docker Image") {
            steps {
                script { 
                    dockerImage = docker.build registry + ":dtester_backend" 
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
        stage('Cleaning up') { 
            steps { 
                sh "docker rmi $registry:dtester_backend"
            }
        } 
    }
}