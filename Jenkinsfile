node() {
   
    stage('MasterBuild - Clone_app') {
        git url: 'https://github.com/haithem-boukhari/projet-pile-complete.git',
             branch: 'master'
    }
    
    withCredentials([azureServicePrincipal(credentialsId: 'credentials_id',
                                    subscriptionIdVariable: 'SUBS_ID',
                                    clientIdVariable: 'CLIENT_ID',
                                    clientSecretVariable: 'CLIENT_SECRET',
                                    tenantIdVariable: 'TENANT_ID')]) {
    
    stage('Terraform Init') {
        sh "terraform init -input=false"
    }
    stage('Terraform Plan') {
        withCredentials([string(credentialsId: 'pubKey', variable: 'pubKey')]) {
        withCredentials([azureServicePrincipal(credentialsId: 'credentials_id',
                                    subscriptionIdVariable: 'SUBS_ID',
                                    clientIdVariable: 'CLIENT_ID',
                                    clientSecretVariable: 'CLIENT_SECRET',
                                    tenantIdVariable: 'TENANT_ID')]) {
                                    
        sh 'terraform plan -var client_id="$CLIENT_ID" -var client_secret="$CLIENT_SECRET" -var tenant_id="$TENANT_ID" -var pubKey="$pubKey" -var subscription_id="$SUBS_ID"'
    }
    
    stage('Terraform Apply') {
        sh 'terraform apply -auto-approve -var client_id="$CLIENT_ID" -var client_secret="$CLIENT_SECRET" -var tenant_id="$TENANT_ID" -var pubKey="$pubKey" -var subscription_id="$SUBS_ID"'
      }
    }
    stage('MasterBuild - Clone_app') {
          git url: 'https://gitlab.com/RaphaeldeGail/devopsapp.git',
               branch: 'master'
    }
    
    stage('MasterBuild - Maven package'){
            sh 'mvn clean package'
    }
    
    stage('MasterBuild - Clone_app') {
        git url: 'https://github.com/haithem-boukhari/projet-pile-complete.git',
             branch: 'master'
    }
    
    stage('MasterDeploy - End') {
     sshagent (credentials: ['pileUser']) {    
      ansiblePlaybook (
          colorized: true,
          become: true,
          credentialsId: 'pileUser',
          playbook: 'deploy.yml',
          becomeUser: 'pileUser',
          disableHostKeyChecking: true,
          inventory: 'inventory'
          
      )
     } 
    }

    }
    }
}
