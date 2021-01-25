FROM elasticsearch:2

HEALTHCHECK  --interval=5s --timeout=2s --start-period=30s --retries=5 \
    CMD curl -f localhost:9200/_cluster/health || false
