node("${env.SLAVE}") {

  stage("Checkout scm")
    {
       git branch: 'aaksionkin', url: 'https://github.com/artem-aksenkin/mntlab-exam.git'

    }



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
    sh "echo build artifact"
    sh "echo Build time: ${BUILD_TIMESTAMP} > src/main/resources/build-info.txt"
    sh "echo Build Machine Name: ${env.SLAVE} >> src/main/resources/build-info.txt"
    wrap([$class: 'BuildUser']){
    sh "echo Build User Name: ${BUILD_USER} >> src/main/resources/build-info.txt"
    }
    sh '''
    echo "GIT URL: `git config --get remote.origin.url`" >> ${WORKSPACE}/src/main/resources/build-info.txt
    echo "GIT Commit: `git rev-parse HEAD`" >> ${WORKSPACE}/src/main/resources/build-info.txt
    echo "GIT Branch: `git rev-parse --abbrev-ref HEAD`" >> ${WORKSPACE}/src/main/resources/build-info.txt
    '''
    sh "cp ${WORKSPACE}/src/main/resources/build-info.txt ${WORKSPACE}/roles/deploy/templates/build-info.txt.j2d"
    sh "mvn clean package -DbuildNumber=${BUILD_NUMBER}"
    
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
    withEnv(["ANSIBLE_FORCE_COLOR=true", "PYTHONUNBUFFERED=1"]){
        ansiColor('xterm') {
            sh "ansible-playbook stack.yml -t create"
            sh "cat ${WORKSPACE}/stack.yml"

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
           sh "ansible-playbook stack.yml -t create,provision -v"
           sh "cat ${WORKSPACE}/roles/java/tasks/main.yml"
           sh "cat ${WORKSPACE}/roles/java/tasks/main.yml"
           sh "cat ${WORKSPACE}/roles/tomcat/tasks/main.yml"
           sh "cat ${WORKSPACE}/roles/nginx/tasks/main.yml"
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
           sh "ansible-playbook stack.yml -t create,provision,deployment -e war=${WORKSPACE}/target/mnt-exam.war -v"
           sh "cat ${WORKSPACE}/roles/deploy/tasks/main.yml"
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
           sh "ansible-playbook stack.yml -t create,testing -v"
           sh "ansible-playbook stack.yml -t create -e dest=/home/student/cm/ansible/day-4/ state=destroyed -v"
           sh "cat ${WORKSPACE}/roles/java_test/tasks/main.yml"
           sh "cat ${WORKSPACE}/roles/tomcat_test/tasks/main.yml"
           sh "cat ${WORKSPACE}/roles/nginx_test/tasks/main.yml"
        }
    }
  deleteDir()
  }


}

