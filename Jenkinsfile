pipeline {
  agent any

  environment {
    ECR_REPO = '751545121618.dkr.ecr.us-east-1.amazonaws.com/app-repository'
    IMAGE_TAG = "${env.BUILD_ID}"
    AWS_REGION = 'us-east-1'
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/davido1692/OnePercent.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $ECR_REPO:$IMAGE_TAG ./app'
      }
    }

    stage('Push to ECR') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
          sh '''
            aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
            docker push $ECR_REPO:$IMAGE_TAG
          '''
        }
      }
    }

    stage('Deploy with Helm') {
      steps {
        sh '''
          helm upgrade --install hello-app ./helm-chart \
            --namespace jenkins-deploy --create-namespace \
            --set image.repository=$ECR_REPO \
            --set image.tag=$IMAGE_TAG
        '''
      }
    }
  }
}