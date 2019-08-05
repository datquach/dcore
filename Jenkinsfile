pipeline {
    agent any
    stages {
        stage('Init') {
            steps {
                withAWS(region: 'us-east-1', credentials: 'dcore-api-prodkey') {
                sh '''
                    terraform init -input=false 
                '''
                }
            }
        }
        stage('Build') {
            steps {
                withAWS(region: 'us-east-1', credentials: 'dcore-api-prodkey'){
                sh '''
                   terraform plan -var dcore_environment=prod -var aws_profile=prod -var ecs_cluster=dcore-prod -var ecs_key_pair_name=dcore-prod-key -var max_instance_size=2 -var max_instance_size=4 -var desired_capacity=2 -out=tfplan -input=false
                   terraform apply -input=false tfplan
                '''
               }
            }
        }
    }
}