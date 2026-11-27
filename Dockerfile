FROM python:3.12-slim

WORKDIR /app

# 패키지 설치 결과를 코드 변경 뒤에도 재사용한다.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app ./app

EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
