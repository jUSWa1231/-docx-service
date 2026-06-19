# AI Document Updater — Microservice

FastAPI service that powers the n8n "AI Document Update Assistant".
Runs on Railway. Provides DOCX analysis, formatting-safe text update,
and DOCX→PDF conversion (LibreOffice headless).

## Endpoints

| Method | Path       | Body                                   | Returns        |
|--------|------------|----------------------------------------|----------------|
| GET    | /health    | —                                      | JSON status    |
| POST   | /analyze   | multipart: file=<docx>                 | JSON structure |
| POST   | /update    | multipart: file=<docx>, replacements_json=<json obj> | DOCX file |
| POST   | /to-pdf    | multipart: file=<docx>                 | PDF file       |

All endpoints except /health require header:  X-API-Key: <DOC_API_KEY>

## Environment variable (set in Railway)

    DOC_API_KEY = <YOUR_DOC_API_KEY>

## Deploy on Railway (Ubuntu terminal)

```bash
# 1. Put these three files in a folder:
#    main.py  requirements.txt  Dockerfile

# 2. Install Railway CLI (if not installed)
npm i -g @railway/cli      # or: bash <(curl -fsSL https://railway.app/install.sh)

# 3. Log in
railway login

# 4. From inside the docx-service folder:
railway init               # create/link a project (name it: docx-service)
railway up                 # build & deploy the Dockerfile

# 5. Set the API key secret
railway variables --set DOC_API_KEY=<YOUR_DOC_API_KEY>

# 6. Generate a PUBLIC domain
railway domain             # prints something like https://docx-service-production.up.railway.app
```

## Verify after deploy

```bash
curl https://YOUR-RAILWAY-URL/health
# -> {"status":"ok","libreoffice":true}
```

## Quick functional test

```bash
# analyze
curl -X POST https://YOUR-RAILWAY-URL/analyze \
  -H "X-API-Key: <YOUR_DOC_API_KEY>" \
  -F "file=@sample.docx"

# update (replace text, formatting preserved)
curl -X POST https://YOUR-RAILWAY-URL/update \
  -H "X-API-Key: <YOUR_DOC_API_KEY>" \
  -F "file=@sample.docx" \
  -F 'replacements_json={"May 2026":"June 2026"}' \
  --output updated.docx

# convert to pdf
curl -X POST https://YOUR-RAILWAY-URL/to-pdf \
  -H "X-API-Key: <YOUR_DOC_API_KEY>" \
  -F "file=@updated.docx" \
  --output output.pdf
```

Once /health returns ok, send Alpha the public URL and the n8n workflows
WF2–WF5 will be wired to call this service.
