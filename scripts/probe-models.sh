#!/usr/bin/env bash
# Sends one tiny chat request to every model GMI lists and prints how many answered.
# A request that takes longer than 40 seconds counts as not answered (code 000).
# Needs: curl, jq, GMI_API_KEY in your environment. About 80 requests of 16 output tokens each.
set -u
: "${GMI_API_KEY:?export GMI_API_KEY first}"
API=https://api.gmi-serving.com/v1
ok=0; bad=0
for id in $(curl -s --max-time 40 "$API/models" -H "Authorization: Bearer $GMI_API_KEY" | jq -r '.data[].id'); do
  code=$(curl -s --max-time 40 -o /tmp/probe.json -w '%{http_code}' "$API/chat/completions" \
    -H "Authorization: Bearer $GMI_API_KEY" -H 'Content-Type: application/json' \
    -d "{\"model\":\"$id\",\"messages\":[{\"role\":\"user\",\"content\":\"Reply with the word ok.\"}],\"max_tokens\":16}" || true)
  if [ "$code" = 200 ]; then
    ok=$((ok+1))
  else
    bad=$((bad+1))
    echo "${code:-000} $id $(jq -r '.error.details // .error.message // empty' /tmp/probe.json 2>/dev/null | head -c 90)"
  fi
  rm -f /tmp/probe.json
  sleep 1
done
echo "answered: $ok   did not answer: $bad"
