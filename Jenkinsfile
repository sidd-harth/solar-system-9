pipeline {
  agent any

  environment {
    NAME = "planets"
    VERSION = "${env.BUILD_ID}-${env.GIT_COMMIT}"
    IMAGE_REPO = "siddharth67"
    GIT_TOKEN = credentials('github-token')
  }
  
  stages {
    stage('Unit Tests') {
      steps {
        echo 'Implement unit tests if applicable.'
        echo 'This stage is a sample placeholder'
      }
    }

    stage('Build Image') {
      steps {
            sh "docker build -t ${NAME} ."
            sh "docker tag ${NAME}:latest ${IMAGE_REPO}/${NAME}:${VERSION}"
        }
      }

    stage('Push Image') {
      steps {
        withDockerRegistry([credentialsId: "docker-hub", url: ""]) {
          sh 'docker push ${IMAGE_REPO}/${NAME}:${VERSION}'
        }
      }
    }

    stage('Clone/Pull Repo') {
      steps {
        script {
          if (fileExists('test-cd')) {

            echo 'Cloned repo already exists - Pulling latest changes'

            dir("test-cd") {
              sh 'git pull'
            }

          } else {
            echo 'Repo does not exists - Cloning the repo'
            sh 'git clone -b feature https://github.com/sidd-harth/test-cd.git'
          }
        }
      }
    }
    
    stage('Update Manifest') {

      steps {
        dir("test-cd/jenkins-demo") {
          sh "git config --global user.email 'ci@ci.com'"
          sh 'sed -i "s#siddharth67.*#${IMAGE_REPO}/${NAME}:${VERSION}#g" deployment.yaml'
          sh 'cat deployment.yaml'
        }
      }
    }

    stage('Commit & Push') {

      steps {
        dir("test-cd/jenkins-demo") {
          sh 'git remote set-url origin https://$GIT_TOKEN@github.com/sidd-harth/test-cd.git'
          sh 'git checkout feature'
          sh 'git add -A'
          sh 'git commit -am "Updated new image version for VERSION - $VERSION"'
          sh 'git push origin feature'
        }
      }
    }

    stage('Raise PR') {

      steps {
        dir("test-cd/jenkins-demo") {
          sh 'gh auth login -h github.com  -p https --with-token < /home/devsecops/token.txt'
          sh 'gh auth status'
          sh 'gh pr create -a @me --title "Updated Image Version - $VERSION" --body "Planets Updated in Solar System - $VERSION"  -B main'
        }
      }
    }
  }
}
