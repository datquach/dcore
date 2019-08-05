pipeline {
    agent any
    stages {
        stage('Init') {
            steps {
                withAWS(region: 'us-east-1', credentials: 'dcore-api-devkey') {
                sh '''
                    terraform init -input=false 
                '''
                }
            }
        }
        stage('Build') {
            steps {
                withAWS(region: 'us-east-1', credentials: 'dcore-api-devkey'){
                sh '''
                   terraform plan -var dcore_environment=dev -var aws_profile=dev -var ecs_cluster=dcore-dev -var ecs_key_pair_name=dcore-dev-key -var max_instance_size=1 -var max_instance_size=1 -var desired_capacity=1 -out=tfplan -input=false
                   terraform apply -input=false tfplan
                '''
               }
            }
        }
    }
}
