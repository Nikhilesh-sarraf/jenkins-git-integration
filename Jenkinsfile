pipeline {

    agent any

    environment {
        APP_NAME = 'jenkins-cicd-final-project'
        APP_VERSION = '1.0-SNAPSHOT'
    }

    stages {

        stage('Environment Information') {
            steps {
                echo '======================================'
                echo '        CI/CD PIPELINE STARTED'
                echo '======================================'

                echo "Application: ${env.APP_NAME}"
                echo "Version: ${env.APP_VERSION}"
                echo "Job Name: ${env.JOB_NAME}"
                echo "Build Number: ${env.BUILD_NUMBER}"
                echo "Workspace: ${env.WORKSPACE}"

                sh '''
                    echo "Java Version:"
                    java -version

                    echo "Maven Version:"
                    mvn -version

                    echo "Git Version:"
                    git --version
                '''
            }
        }

        stage('Checkout') {
            steps {
                echo 'Source code is checked out from GitHub.'
                sh 'ls -la'
            }
        }

        stage('Maven Validation') {
            steps {
                sh 'mvn validate'
            }
        }

        stage('Clean') {
            steps {
                sh 'mvn clean'
            }
        }

        stage('Compile') {
            steps {
                sh 'mvn compile'
            }
        }

        stage('Unit Testing') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Package') {
            steps {
                sh 'mvn package'
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts(
                    artifacts: 'target/*.jar',
                    fingerprint: true
                )

                echo 'JAR successfully archived in Jenkins.'
            }
        }

        stage('Publish to Nexus') {
            steps {

                withCredentials([
                    usernamePassword(
                        credentialsId: 'nexus-deployer',
                        usernameVariable: 'NEXUS_USER',
                        passwordVariable: 'NEXUS_PASSWORD'
                    )
                ]) {

                    sh '''
                        set +x
                        umask 077

                        cat > settings-nexus.xml <<EOF
                        <settings>
                            <servers>
                                <server>
                                    <id>nexus-snapshots</id>
                                    <username>${NEXUS_USER}</username>
                                    <password>${NEXUS_PASSWORD}</password>
                                </server>
                            </servers>
                        </settings>
                        EOF

                        mvn -s settings-nexus.xml deploy
                    '''
                }
            }
        }

        stage('Staging Deployment') {
            steps {

                echo '======================================'
                echo '      STAGING DEPLOYMENT DEMO'
                echo '======================================'

                sh '''
                    echo "Application: ${APP_NAME}"
                    echo "Version: ${APP_VERSION}"
                    echo "Deployment Environment: STAGING"
                    echo "Checking packaged JAR..."

                    ls -lh target/*.jar

                    echo "Deployment simulation completed."
                '''
            }
        }

        stage('Pipeline Summary') {
            steps {

                echo '======================================'
                echo '       CI/CD PIPELINE COMPLETED'
                echo '======================================'

                echo "Job: ${env.JOB_NAME}"
                echo "Build: ${env.BUILD_NUMBER}"
                echo "Application: ${env.APP_NAME}"
                echo "Version: ${env.APP_VERSION}"
            }
        }
    }

    post {

        always {
            junit allowEmptyResults: true,
                  testResults: 'target/surefire-reports/*.xml'

            sh 'rm -f settings-nexus.xml'
        }

        success {
            echo 'SUCCESS: CI/CD pipeline completed successfully!'
        }

        failure {
            echo 'FAILURE: CI/CD pipeline failed.'
            echo 'Check the Console Output to identify the error.'
        }

        unstable {
            echo 'WARNING: Pipeline completed with unstable status.'
        }

        cleanup {
            echo 'Pipeline cleanup completed.'
        }
    }
}
