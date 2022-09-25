echo "Opening a Pull Request"

curl -X 'POST' \
  'http://139.59.21.103:3000/api/v1/repos/siddharth/gitops-argocd/pulls' \
  -H 'accept: application/json' \
  -H "authorization: $ARGOCD_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{
  "assignee": "siddharth",
  "assignees": [
    "siddharth"
  ],
  "base": "main",
  "body": "body22",
  "head": "feature-gitea",
  "title": "title22"
}'

echo "Success"