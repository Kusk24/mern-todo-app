pipeline {
  agent any

  options {
    skipDefaultCheckout(true)
  }

  environment {
    IMAGE_NAME = 'winyumaung/finead-todo-app:latest'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build') {
      steps {
        sh 'cd TODO/todo_backend && npm ci'
        sh 'cd TODO/todo_frontend && npm ci && npm run build'
        sh 'mkdir -p TODO/todo_backend/static && cp -r TODO/todo_frontend/build TODO/todo_backend/static/'
      }
    }

    stage('Containerise') {
      steps {
        sh 'docker build -t "$IMAGE_NAME" .'
      }
    }

    stage('Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
          sh '''
            echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin
            docker push "$IMAGE_NAME"
            docker logout
          '''
        }
      }
    }
  }
}
