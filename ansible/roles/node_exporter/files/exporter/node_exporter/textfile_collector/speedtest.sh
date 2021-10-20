speedtest -f json --accept-license -p no | jq -r '
"# HELP node_speedtest_ping_jitter Internet speed ping jitter",
"# TYPE node_speedtest_ping_jitter gauge",
"node_speedtest_ping_jitter{} " + (.ping.jitter|tostring),
"# HELP node_speedtest_ping_latency Internet speed ping latency",
"# TYPE node_speedtest_ping_latency gauge",
"node_speedtest_ping_latency{} " + (.ping.latency|tostring),
"# HELP node_speedtest_download_speed_bytes Internet speed download",
"# TYPE node_speedtest_download_speed_bytes gauge",
"node_speedtest_download_speed_bytes{} " + (.download.bytes|tostring),
"# HELP node_speedtest_download_bandwidth_bytes Internet speed download bandwidth",
"# TYPE node_speedtest_download_bandwidth_bytes gauge",
"node_speedtest_download_bandwidth_bytes{} " + (.download.bandwidth|tostring),
"# HELP node_speedtest_upload_speed_bytes Internet speed upload",
"# TYPE node_speedtest_upload_speed_bytes gauge",
"node_speedtest_upload_speed_bytes{} " + (.upload.bytes|tostring),
"# HELP node_speedtest_upload_bandwidth_bytes Internet speed upload bandwidth",
"# TYPE node_speedtest_upload_bandwidth_bytes gauge",
"node_speedtest_upload_bandwidth_bytes{} " + (.upload.bandwidth|tostring)
'

