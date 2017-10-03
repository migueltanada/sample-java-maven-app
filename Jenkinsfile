def mvnHome

node {
    mvnHome = tool 'ADOP Maven'
    
    stage 'Clone Git Repo'
        def workspace = pwd()
             sh """
                git config --global http.postBuffer 524288000
                git init ${workspace}
                git config remote.origin.url http://gitlab/gitlab/${env.gitlabSourceRepoName}
                git config --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
                git fetch --no-tags --progress http://gitlab/gitlab/root/jenkins-gitlab-sonarqube.git +refs/heads/*:refs/remotes/origin/*
                git checkout ${env.gitlabSourceBranch}
                """ 
    
    stage 'sonar preview'
        sh """
        ${mvnHome}/bin/mvn --batch-mode sonar:sonar \
        -Dsonar.gitlab.ref_name=${env.gitlabSourceBranch} \
        -Dsonar.gitlab.project_id=${env.gitlabSourceRepoHttpUrl} \
        -Dsonar.gitlab.commit_sha=${env.gitlabMergeRequestLastCommit} \
        -Dsonar.analysis.mode=preview \
        -Dsonar.gitlab.only_issue_from_commit_file=true \
        -Dsonar.login= \
		-Dsonar.password= \
		-Dsonar.host.url=http://sonar:9000/sonar \
		-Dsonar.jdbc.url='jdbc:mysql://sonar-mysql:3306/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true' \
		-Dsonar.jdbc.username=sonar \
		-Dsonar.jdbc.password=sonar \
		-Dsonar.scm.enabled=false \
		-Dsonar.scm-stats.enabled=false \
		-Dissueassignplugin.enabeld=false"""      
} 
