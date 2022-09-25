pipeline {
  agent any

  environment {
    NAME = "solar-system"
    VERSION = "${env.BUILD_ID}-${env.GIT_COMMIT}"
    IMAGE_REPO = "siddharth67"
    ARGOCD_TOKEN = credentials('argocd-token')
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
          if (fileExists('gitops-argocd')) {

            echo 'Cloned repo already exists - Pulling latest changes'

            dir("gitops-argocd") {
              sh 'git pull'
            }

          } else {
            echo 'Repo does not exists - Cloning the repo'
            sh 'git clone -b feature-gitea http://139.59.21.103:3000/siddharth/gitops-argocd'
          }
        }
      }
    }
    
    stage('Update Manifest') {

      steps {
        dir("gitops-argocd/jenkins-demo") {
          sh "git config --global user.email 'ci@ci.com'"
          sh 'sed -i "s#siddharth67.*#${IMAGE_REPO}/${NAME}:${VERSION}#g" deployment.yaml'
          sh 'cat deployment.yaml'
        }
      }
    }

    stage('Commit & Push') {

      steps {
        dir("gitops-argocd/jenkins-demo") {
          sh 'git remote set-url origin http://139.59.21.103:3000/siddharth/gitops-argocd'
          sh 'git checkout feature-gitea'
          sh 'git add -A'
          sh 'git commit -am "Updated image version for Build - $VERSION"'
          sh 'git push origin feature-gitea'
        }
      }
    }

    stage('Raise PR') {

      steps {
        dir("gitops-argocd/jenkins-demo") {
          sh "bash pr.sh"
        }
      }
    }
  }
}
