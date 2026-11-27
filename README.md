# hackathon-app

Pre-SKALA 해커톤 연습용 FastAPI 앱.

## API
- `GET /` : 인사 메시지
- `GET /health` : 상태 확인

## 실행 방법
```sh
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements-dev.txt
uvicorn app.main:app --reload
```

Python 3.12 또는 3.13을 사용한다.

## 테스트
```sh
pytest -v
```

## Docker 실행
```sh
docker build --platform linux/amd64 -t hackathon-app:local .
docker run -d --rm -p 8000:8000 --name hk hackathon-app:local
curl http://localhost:8000/health
docker stop hk
```

## GitHub Actions
- `Hello`: `main` push 또는 Actions 탭에서 수동 실행하는 입문 실습.
- `CI`: PR과 `main`에서 Python 3.12·3.13 테스트 후 Docker 빌드 및 `/health` 확인.
- `main` push에서는 검증 후 GHCR에 `latest`, 커밋 SHA 태그 이미지를 게시한다.
- 테스트 결과는 실행 화면의 Artifacts에서 내려받을 수 있다.
- `main` 보호 규칙의 필수 체크: `test (Python 3.12)`, `test (Python 3.13)`, `build`.

3.0 AWS와 4.0 EKS 실습은 운영진이 발급한 계정으로 이어서 진행한다.

## 팀원
