
pipeline {
    agent any

    stages {

        stage('Checkout Information') {
            steps {
                echo 'Jenkins Pipeline started'
                echo "Job Name: ${env.JOB_NAME}"
                echo "Build Number: ${env.BUILD_NUMBER}"
            }
        }

        stage('Build Application') {
            steps {
                sh '''
                    echo "Building application..."

                    mkdir -p build

                    echo "Build successful" > build/result.txt

                    cat build/result.txt
                '''
            }
        }

        stage('Test Application') {
            steps {
                sh '''
                    echo "Running tests..."

                    if [ -f build/result.txt ]; then
                        echo "PASS: Build file exists"
                    else
                        echo "FAIL: Build file missing"
                        exit 1
                    fi
                '''
            }
        }

        stage('Deployment') {
            steps {
                echo 'Application deployment stage'
                echo 'Deployment completed!'
            }
        }
    }
}
