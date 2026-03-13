pipeline {
  agent any

  options {
    skipDefaultCheckout(true)
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
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
          sh '''
            IMAGE_NAME="${DOCKERHUB_USERNAME}/finead-todo-app:latest"
            echo "$IMAGE_NAME" > image_name.txt
            docker build -t "$IMAGE_NAME" .
          '''
        }
      }
    }

    stage('Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
          sh '''
            IMAGE_NAME="$(cat image_name.txt)"
            echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin
            docker push "$IMAGE_NAME"
            docker logout
          '''
        }
      }
    }
  }
}
