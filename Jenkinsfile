node("${env.SLAVE}") {

  stage("Build"){
    /*
        Update file src/main/resources/build-info.txt with following details:
        - Build time
        - Build Machine Name
        - Build User Name
        - GIT URL: ${GIT_URL}
        - GIT Commit: ${GIT_COMMIT}
        - GIT Branch: ${GIT_BRANCH}

        Simple command to perform build is as follows:
        $ mvn clean package -DbuildNumber=$BUILD_NUMBER
    */
    
    git branch: 'aaksionkin', url: 'git@git.epam.com:siarhei_beliakou/mntlab-exam.git'
    sh "echo build artifact"
    sh "echo ${(date +"%T")} ${(hostname)} ${(whoami)} ${GIT_URL} ${GIT_COMMIT} ${GIT_BRANCH} > src/main/resources/build-info.txt"
    sh "cat src/main/resources/build-info.txt"
    sh "mvn clean package -DbuildNumber=$BUILD_NUMBER"
    sh  "tar -zcf ${BUILD_NUMBER}.tar.gz target/mnt-exam.war "
  }

  stage("Package"){
    /*
        use tar tool to package built war file into *.tar.gz package
    */
    sh "echo package artefact"
    sh ""
  }

  stage("Roll out Dev VM"){
    /*
        use ansible to create VM (with developed vagrant module)
    */
    sh "echo ansible-playbook createvm.yml ..."
  }

  stage("Provision VM"){
    /*
        use ansible to provision VM
        Tomcat and nginx should be installed
    */
    sh "echo ansible-playbook provisionvm.yml ..."
  }

  stage("Deploy Artefact"){
    /*
        use ansible to deploy artefact on VM (Tomcat)
        During the deployment you should create file: /var/lib/tomcat/webapps/deploy-info.txt
        Put following details into this file:
        - Deployment time
        - Deploy User
        - Deployment Job
    */
    sh "echo ansible-playbook deploy.yml -e artefact=... ..."
  }

  stage("Test Artefact is deployed successfully"){
    /*
        use ansible to artefact on VM (Tomcat)
        During the deployment you should create file: /var/lib/tomcat/webapps/deploy-info.txt
        Put following details into this file:
        - Deployment time
        - Deploy User
        - Deployment Job
    */
    sh "echo ansible-playbook application_tests.yml -e artefact=... ..."
  }

}

