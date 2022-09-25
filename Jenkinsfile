pipeline {
  agent any

  environment {
    NAME = "solar-system"
    VERSION = "${env.BUILD_ID}-${env.GIT_COMMIT}"
    IMAGE_REPO = "siddharth67"
    ARGOCD_TOKEN = credentials('argocd-token')
    GITEA_TOKEN = credentials('gitea-token')
  }
  
  stages {

        stage('Raise PR') {
      steps {
        sh "bash pr.sh"
      }
    } 

    
  }
}
