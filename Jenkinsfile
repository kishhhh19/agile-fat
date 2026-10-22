pipeline {
    agent any
    environment { 
        IMG = 'disaster/portal' 
        KUBE_CRED = 'k8s-cluster-config'
    }
    stages {
        stage('Build Image') { steps { sh "docker build -t ${IMG}:${BUILD_NUMBER} ." } }
        stage('Deploy') { 
            steps {
                withCredentials([file(credentialsId: "${KUBE_CRED}", variable: 'KUBECONFIG')]) {
                    sh "sed -i 's|TAG_PLACEHOLDER|${BUILD_NUMBER}|g' deployment.yaml"
                    sh "kubectl apply -f deployment.yaml"
                    sh "kubectl rollout status deployment/disaster-portal --timeout=60s"
                }
            }
        }
    }
    post {
        failure {
            withCredentials([file(credentialsId: "${KUBE_CRED}", variable: 'KUBECONFIG')]) {
                echo 'Deployment faulty. Rolling back to stable...'
                sh "kubectl rollout undo deployment/disaster-portal"
            }
        }
    }
}
