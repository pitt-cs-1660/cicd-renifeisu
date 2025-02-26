# Builder Stage

FROM python:3.11-buster AS builder

WORKDIR /app

RUN pip install --upgrade pip && pip install poetry

COPY pyproject.toml poetry.lock ./

RUN poetry config virtualenvs.create false && poetry install --no-root --no-interaction --no-ansi

# App Stage

FROM python:3.11-buster AS app

WORKDIR /app

COPY --from=builder /app /app

EXPOSE 8000

ENV PATH=$PATH:/app/.venv/bin
# ENTRYPOINT ["entrypoint.sh"]

CMD ["uvicorn", "cc_compose.server:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]