# 3.0·4.0 AWS 실습 준비

교재: https://pre-skala-hackathon.pages.dev/courses/aws-basic/complete-guide.html

교재: https://pre-skala-hackathon.pages.dev/courses/eks-ecr/complete-guide.html

현재 파일은 교재의 배포 설정 초안이다. AWS 리소스는 아직 생성하지 않았다.
`<ACCOUNT_ID>`, `<TAG>`는 실제 계정과 이미지 값으로 교체해야 한다.
`cluster.yaml`의 Kubernetes 버전은 교재 예시이며 생성 전에 서울 리전의 지원 버전을 확인한다.

## 3.0: AWS 계정 연결

운영진에게 발급받은 IAM 사용자로 콘솔에 로그인한 뒤 실행한다.
비밀번호와 Access Key를 저장소에 적지 않는다.

macOS에서는 설치한 최신 도구를 먼저 찾도록 PATH를 지정한다.
기존 Docker Desktop의 `kubectl`보다 Homebrew 버전을 사용한다.

```sh
export PATH="/opt/homebrew/bin:$PATH"
aws login --profile hackathon
export AWS_PROFILE=hackathon
aws sts get-caller-identity
aws configure get region --profile hackathon
```

리전은 `ap-northeast-2`를 사용한다. 이후 교재의 EC2 컨테이너 실행과 S3
업로드·다운로드·동기화·presigned URL 실습을 진행한다.

## 4.0: 배포 순서

1. ECR `hackathon-app` 리포지토리를 만들고 amd64 이미지를 커밋 SHA 태그로 올린다.
2. `ecr-lifecycle.json` 정책을 적용한다.
3. `aws eks describe-cluster-versions --region ap-northeast-2`로 지원 버전을 확인한다.
4. `eksctl create cluster -f infra/cluster.yaml --dry-run`으로 설정을 확인하고 클러스터를 생성한다.
5. `k8s/deployment.yaml`의 이미지 주소를 실제 값으로 바꾸고 Deployment와 Service를 적용한다.
6. 외부 주소의 `/health`, scale, rolling update, rollback을 검증한다.
7. OIDC Provider와 `github-actions-hackathon` IAM Role을 만든다.
   신뢰 정책은 `github-trust-policy.json`, 권한 정책은 `github-permissions-policy.json`을 사용한다.
8. 해당 Role의 EKS Access Entry와 접근 정책을 구성한다.
9. GitHub Repository variable `AWS_ROLE_ARN`에 Role ARN을 등록한다.
10. 준비가 끝난 뒤 `deploy.yml`을 `main`에 반영하고 자동 배포를 검증한다.

현재 OIDC 신뢰 정책은 `dahyunhub/hackathon-app`의 `main`만 허용한다.
AWS 계정 ID는 로그인 후 확인한 값으로 넣는다.

## 실습 종료

계속 사용할 리소스인지 확인한 뒤 교재 순서에 따라 정리한다.
LoadBalancer가 남지 않도록 Service를 먼저 삭제하고 EKS 클러스터를 삭제한다.
3.0에서 만든 EC2·EBS·S3와 4.0의 ECR도 별도로 확인한다.
