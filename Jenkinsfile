pipeline {
   agent any
    parameters{
        choice(choices: ['DEV', 'PROD'], description: 'Selecione o TIER', name: 'CRONAPP_TIER')
        choice(choices: ['false', 'true'], description: 'Selecione se quer usar conexões de banco e parâmetros dentro do conteiner', name: 'CRONAPP_USE_CONTEXT')
        string(defaultValue: 'antonionovaesjr/teste-app-cicd', description: 'Defini o nome de sua image (se for registry privado, informo o caminho completo)', name: 'CRONAPP_DOCKER_IMAGE_NAME', trim: false)
        string(defaultValue: 'https://index.docker.io/v1/', description: 'URL do Registry (por default é docker hub)', name: 'CRONAPP_DOCKER_REGISTRY', trim: false)
        string(defaultValue: 'dockerhub-app-cicd', description: 'informe o nome do secret usado para acesso ao registry', name: 'CRONAPP_DOCKERHUB_ACCESS', trim: false)
        string(defaultValue: 'https://github.com/antonionovaesjr/teste-app-cicd.git', description: 'Defini o nome de sua image', name: 'CRONAPP_GIT_URL', trim: false)
        string(defaultValue: 'github-app-cicd', description: 'Defini o nome de sua image', name: 'CRONAPP_GIT_USERPASS', trim: false)
    }
   stages {
      stage('Git Clone') {

         steps {
            checkout([$class: 'GitSCM', branches: [[name: '${CRONAPP_TAG_VERSION}']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'CloneOption', noTags: false, reference: '', shallow: false]], submoduleCfg: [], userRemoteConfigs: [[credentialsId: "${CRONAPP_GIT_USERPASS}", url: "${CRONAPP_GIT_URL}"]]])
         }
      }
     stage ('Maven and Docker Build') {
         steps {
            sh '''
            docker build -t ${CRONAPP_DOCKER_IMAGE_NAME}:${CRONAPP_TAG_VERSION}-${CRONAPP_TIER} --build-arg TIER=${CRONAPP_TIER} --build-arg CONTEXT_USE=${CRONAPP_USE_CONTEXT} .
            '''
      }
    }
     stage ('Docker Push') {
         steps {
        
            withDockerRegistry(credentialsId: "${CRONAPP_DOCKERHUB_ACCESS}", url: "${CRONAPP_DOCKER_REGISTRY}") {
                sh '''
                docker push ${CRONAPP_DOCKER_IMAGE_NAME}:${CRONAPP_TAG_VERSION}-${CRONAPP_TIER}
                '''
            }
         
        }
      }
    stage ('Docker Clean') {
         steps {
                sh '''
                docker rmi $(docker images -f "dangling=true" -q)
                '''
        }
      }
   }
}
