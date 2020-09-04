#!groovy
properties([disableConcurrentBuilds()])

pipeline {
    environment { 
        registry = "avvppro/dtester" 
        registryCredential = 'dockerhub_id' 
        dockerImage = '' 
        DB_HOST = "172.33.0.2"
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
        stage("Set variables") {
            steps {
                load "$JENKINS_HOME/dtvariables.groovy"
                sh "sed -i 's|RewriteBase /|RewriteBase /dtapi/|g' ./.htaccess"
                sh "sed -i '107s|'/'|'/dtapi/'|g' ./application/bootstrap.php"
                sh "sed -i 's/PDO_MySQL/PDO/g' ./application/config/database.php"
                sh "sed -i 's/mysql:host=localhost/mysql:host=$DB_HOST/g' ./application/config/database.php"
                sh "sed -i '43s/'dtapi'/'${env.DB_USER}'/g' ./application/config/database.php"
                sh "sed -i '44s/'dtapi'/'${env.DB_PASS}'/g' ./application/config/database.php"
                sh "rm -rf koseven/ dtapi.sql README.md .git .gitignore"
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
                sh 'rm -rf ./*'
            }
        } 
    }
}