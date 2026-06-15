Phase 1 — Burp Suite Fundamentals
Module 1: What is Burp Suite & how it works
    - What a proxy is and why it matters
    - Burp architecture — how it sits between browser and server
    - Community vs Pro differences (be honest with students upfront)
    - Installing and launching for the first time

Module 2: Proxy
    - Setting up the built-in Burp browser
    - Intercept on/off — when to use each
    - Reading HTTP history — every request logged
    - Forwarding, dropping, and editing requests live
    
Module 3: Decoder
    - Base64 encode/decode
    - URL encoding/decoding
    - Reading JWT tokens — header, payload, signature
    - Hashing — MD5, SHA1, SHA256

Module 4: Repeater
    - Sending requests from history to Repeater
    - Editing and replaying requests manually
    - Comparing responses — status codes, length, body
    - Tab management — keeping multiple requests open

Module 5: Intruder
    - Understanding payload positions (§ markers)
    - Four attack types — when to use each
    - Payload types — numbers, wordlists, custom
    - Analyzing results — sorting by length/status
    - Installing Turbo Intruder to remove speed limit

Module 6: Extensions (BApp Store)
    - Installing Jython for Python-based extensions
    - Autorize — setup and reading results
    - JWT Editor — decoding and modifying tokens
    - Turbo Intruder — writing basic attack scripts