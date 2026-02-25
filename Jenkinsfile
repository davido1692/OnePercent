pipeline {
  agent any

  environment {
    AWS_REGION   = 'us-east-1'
    ECR_REGISTRY = '751545121618.dkr.ecr.us-east-1.amazonaws.com'
    ECR_REPO     = '751545121618.dkr.ecr.us-east-1.amazonaws.com/app-repository'
    IMAGE_TAG    = "${env.BUILD_ID}"
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/davido1692/OnePercent.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh '''
          set -e
          docker build -t ${ECR_REPO}:${IMAGE_TAG} ./app
        '''
      }
    }

    stage('Push to ECR') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
          sh '''
            set -e
            aws --version
            aws sts get-caller-identity
            aws ecr get-login-password --region ${AWS_REGION} \
              | docker login --username AWS --password-stdin ${ECR_REGISTRY}

            docker push ${ECR_REPO}:${IMAGE_TAG}
          '''
        }
      }
    }

    stage('Deploy with Helm') {
      steps {
        sh '''
          set -e
          helm version
          helm upgrade --install hello-app ./helm-chart \
            --namespace jenkins-deploy --create-namespace \
            --set image.repository=${ECR_REPO} \
            --set image.tag=${IMAGE_TAG}
        '''
      }
    }
  }
}