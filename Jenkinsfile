node('master'){

    def mavenHome = tool(
        name: "ADOP Maven",
        type: "maven"
    )
    def sonarScanner = tool 'ADOP Sonar'

	stage('Checkout'){
		checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/migueltanada/sample-java-maven-app']]])
	}
    
	stage('maven'){
		env.PATH = "${env.PATH}:${mavenHome}/bin"
		sh "mvn package"	    
	}
	
	withCredentials([usernamePassword(credentialsId: 'ADMIN_CREDS', passwordVariable: 'ADMIN_PASSWORD', usernameVariable: 'ADMIN_USER')]) {
		stage('sonar'){
			env.PATH = "${env.PATH}:${mavenHome}/bin"

			sh """
			mvn --batch-mode sonar:sonar \
				-Dsonar.login=${ADMIN_USER} \
				-Dsonar.password=${ADMIN_PASSWORD} \
				-Dsonar.host.url=http://sonar:9000/sonar \
				-Dsonar.jdbc.url='jdbc:mysql://sonar-mysql:3306/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true' \
				-Dsonar.jdbc.username=sonar \
				-Dsonar.jdbc.password=sonar \
			"""
		}

		stage('nexus'){
			env.PATH = "${env.PATH}:${mavenHome}/bin"
			
			sh """
			mvn deploy:deploy-file \
				-DgeneratePom=false \
				-DrepositoryId=nexus \
				-Durl=http://${ADMIN_USER}:${ADMIN_PASSWORD}@nexus:8081/nexus/content/repositories/snapshots \
				-DpomFile=pom.xml \
				-Dfile=target/CurrencyConverter.war
			"""
		}
	}

} 
 
