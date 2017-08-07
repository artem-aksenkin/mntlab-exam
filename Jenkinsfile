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
    deleteDir()
    git branch: 'aaksionkin', url: 'git@git.epam.com:siarhei_beliakou/mntlab-exam.git'
    sh "echo build artifact"
    sh "date >> src/main/resources/build-info.txt"
    sh "hostname >> src/main/resources/build-info.txt"
    sh "whoami >> src/main/resources/build-info.txt"
    sh ''' 
    echo ' BUILD DETAILS:
      Developer name: Artsiom Aksionkin
    - GIT URL: ${GIT_URL}
    - GIT Commit: ${GIT_COMMIT}
    - GIT Branch: ${GIT_BRANCH}' >> src/main/resources/build-info.txt '''
    sh "cat src/main/resources/build-info.txt"
    sh "cp src/main/resources/build-info.txt roles/deploy/templates/build-info.txt.j2d"
    sh "mvn clean package -DbuildNumber=$BUILD_NUMBER"
    
  }

  stage("Package"){
    /*
        use tar tool to package built war file into *.tar.gz package
    */
    sh "echo package artifact"
    sh  "tar -zvcf ${BUILD_NUMBER}.tar.gz target/mnt-exam.war"
    sh "ls -la"
  }

  stage("Roll out Dev VM"){
    /*
        use ansible to create VM (with developed vagrant module)
    */

    sh "echo ansible-playbook createvm.yml ..."
    withEnv(["ANSIBLE_FORCE_COLOR=true", "PYTHONUNBUFFERED=1"]){
        ansiColor('xterm') {
            sh "ansible-playbook stack.yml --tags 'create' -vv"
        }
    }

  }

  stage("Provision VM"){
    /*
        use ansible to provision VM
        Tomcat and nginx should be installed
    */

    withEnv(["ANSIBLE_FORCE_COLOR=true", "PYTHONUNBUFFERED=1"]){
        ansiColor('xterm') {
           sh "ansible-playbook stack.yml --tags 'create, provision' -vv'"
        }
    }

  }

  stage("Deploy Artefact"){
    /*
        use ansible to deploy artefact on VM (Tomcat)
        During the deployment you should create file: /var/lib/tomcat/webapps/deploy-info.txt
        Put following details into this file:
        - Deployment time
        - Deploy User
        - Deployment Job
        sh "echo ansible-playbook deploy.yml -e artifact=... ..."
    */

    withEnv(["ANSIBLE_FORCE_COLOR=true", "PYTHONUNBUFFERED=1"]){
        ansiColor('xterm') {
           sh "ansible-playbook stack.yml --tags 'create, provision, deployment' -vv'"
        }
    }

  }

  stage("Test Artefact is deployed successfully"){
    /*
        use ansible to artefact on VM (Tomcat)
        During the deployment you should create file: /var/lib/tomcat/webapps/deploy-info.txt
        Put following details into this file:
        - Deployment time
        - Deploy User
        - Deployment Job
        sh "echo ansible-playbook application_tests.yml -e artefact=... ..."
    */
     withEnv(["ANSIBLE_FORCE_COLOR=true", "PYTHONUNBUFFERED=1"]){
        ansiColor('xterm') {
           sh "ansible-playbook stack.yml --tags 'create, provision, deployment, testing' -vv'"
        }
    }
  }

}

