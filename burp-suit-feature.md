# Burp Suite Community Edition — Essential Guide for Web Ethical Hackers

> **Version:** Community Edition (Free)  
> **Vendor:** PortSwigger  
> **Purpose:** Manual web application security testing  
> **Download:** [portswigger.net/burp/communitydownload](https://portswigger.net/burp/communitydownload)

---

## What Is Burp Suite Community Edition?

Burp Suite Community Edition is a **free**, industry-standard intercepting proxy platform built by PortSwigger. It sits between your browser and the target web application, capturing every HTTP/HTTPS request and response. This gives ethical hackers full visibility into application-layer traffic — something no browser developer tool can offer on its own.

It is the go-to entry point for anyone starting in web penetration testing or bug bounty hunting, and it remains indispensable even for seasoned professionals for manual testing workflows.

---

## Core Features Available in Community Edition

### 1. 🔀 Proxy (Intercepting HTTP/HTTPS & WebSockets)

The heart of Burp Suite. The proxy sits at `127.0.0.1:8080` and intercepts all traffic between your browser and the target.

| Capability | Details |
|---|---|
| HTTP/HTTPS interception | View, pause, modify, and forward requests/responses |
| WebSocket support | Intercept and inspect WebSocket messages |
| Proxy history | Full log of all traffic for later analysis |
| TLS/SSL decryption | Via per-installation CA certificate installed in your browser |
| Intercept toggle | Turn on/off — "on" pauses each request for manual review |

**Setup (quick start):**
```
1. Open Burp → Proxy tab → turn Intercept ON
2. Set browser proxy → 127.0.0.1 : 8080
3. Install Burp's CA certificate in your browser (for HTTPS)
4. Browse the target → traffic appears in Burp
```

**Use cases:** Inspect authentication flows, API calls, token handling, cookie transmission, and hidden parameters.

---

### 2. 🔁 Repeater

Repeater allows you to manually resend and modify captured HTTP requests as many times as needed, with instant response comparison.

**Workflow:**
```
Proxy History → Right-click request → Send to Repeater
→ Modify parameters/headers/body → Click Send → Analyse response
```

**What to test with Repeater:**
- SQL injection (`id=1'` → look for DB errors)
- XSS payloads (`<script>alert(1)</script>` in input fields)
- IDOR (change `user_id=12` to `user_id=13`)
- Authentication bypass (remove/alter auth tokens)
- Business logic flaws (negative prices, quantity manipulation)
- API endpoint fuzzing

**Key features:**
- Save tabs and name them per vulnerability type
- Compare request/response lengths for blind injection detection
- Send sequences of requests for multi-step process testing

---

### 3. 🎯 Intruder (Demo / Rate-Limited)

Intruder automates customised attacks by injecting different payloads into defined positions of an HTTP request.

> ⚠️ **Community Edition Limitation:** Intruder is heavily rate-throttled in the free version. Requests are intentionally slowed, making it impractical for large wordlists. Use small payload sets (10–20 entries) for concept learning and basic testing.

**Attack modes:**

| Mode | Description | Use Case |
|---|---|---|
| Sniper | One payload set, one position at a time | Single parameter fuzzing |
| Battering Ram | Same payload in all positions simultaneously | Credential stuffing |
| Pitchfork | Multiple payload sets, parallel positions | Username + password lists |
| Cluster Bomb | All combinations across all positions | Brute force login forms |

**Common payload types:**
- Wordlists (usernames, passwords, paths)
- Numbers (sequential IDs for IDOR)
- Dates and custom patterns
- Null payloads (for race condition testing)

**Practical use (Community Edition):**
- Use small payload lists (< 20 entries) for testing concepts
- For real brute force on authorised targets → upgrade to Professional or use `ffuf`/`wfuzz` externally

---

### 4. 🔍 Decoder

Decoder transforms data between different encoding formats — essential for understanding how the application processes input and whether it can be manipulated.

**Supported formats:**

| Encoding | Example |
|---|---|
| URL encoding | `%3C%73%63%72%69%70%74%3E` |
| Base64 | `YWRtaW46cGFzc3dvcmQ=` |
| HTML entities | `&lt;script&gt;` |
| Hex | `48 65 6c 6c 6f` |
| Gzip | Compressed data inspection |
| ASCII Hex | Mixed encoding layers |

**Workflow:**  
Paste encoded value → Select encoding type → Smart Decode (auto-detect) or manually chain decode steps.

**Use cases:**
- Decode JWT tokens (Base64 each part)
- Spot Base64-encoded credentials in cookies
- Detect double-encoding bypasses (URL → URL → HTML)
- Inspect serialised objects

---

### 5. 📊 Sequencer

Sequencer analyses the randomness and entropy of tokens, session IDs, and CSRF tokens to determine if they are cryptographically predictable.

**How it works:**
1. Capture a response containing a session token or CSRF token
2. Configure the token location in the response
3. Run the analysis (Burp requests the same endpoint hundreds of times)
4. Review the entropy report

**What it finds:**
- Weak session IDs (sequential, time-based, low entropy)
- Predictable CSRF tokens
- Insecure random number generation
- Token reuse patterns

**Output:** Entropy score with statistical analysis — higher entropy = stronger token.

---

### 6. ⚖️ Comparer

Comparer performs a visual diff between two HTTP requests or responses, highlighting differences at the word or byte level.

**Use cases:**
- Compare responses to valid vs. invalid login (spot subtle differences for user enumeration)
- Detect changes in response length (blind SQLi indicator)
- Compare authenticated vs. unauthenticated responses (access control testing)
- Spot differences between admin and normal user responses

**How to use:**
```
Right-click any request or response → Send to Comparer
Do the same for the second item → Comparer tab → Compare
```

---

### 7. 🌐 Target (Site Map)

The Target tool builds a visual map of the application's structure as you browse.

**Features:**
- Tree view of all discovered hosts, directories, and endpoints
- Scope definition (include/exclude hosts and URL paths)
- Annotate items with notes and severity
- Highlight interesting endpoints for follow-up testing

**Scope management:**  
Define scope to limit proxy history, intruder, and other tools to only the authorised target. Prevents accidental testing of out-of-scope assets.

---

### 8. 🧩 BApp Store (Extensions)

The BApp Store provides community-built extensions that extend Burp's capabilities. Many are free and work in Community Edition.

**Essential free extensions for Community Edition:**

| Extension | Purpose |
|---|---|
| **Hackvertor** | Advanced encoding/decoding with XML tag chaining |
| **Logger++** | Enhanced request/response logging |
| **Autorize** | Automated authorisation and access control testing |
| **JSON Web Tokens** | Decode, edit, and attack JWTs directly in Burp |
| **Param Miner** | Discover hidden parameters and headers |
| **HTTP Request Smuggler** | Detect HTTP request smuggling vulnerabilities |
| **Software Vulnerability Scanner** | Passive CVE detection based on software versions |
| **InQL** | GraphQL security testing |

**Install:** Extender tab → BApp Store → Search → Install

---

## Community vs. Professional — Feature Comparison

| Feature | Community (Free) | Professional ($449/yr) |
|---|---|---|
| HTTP/HTTPS Proxy | ✅ Full | ✅ Full |
| WebSocket Proxy | ✅ Full | ✅ Full |
| Proxy History | ✅ Full | ✅ Full |
| Repeater | ✅ Full | ✅ Full |
| Decoder | ✅ Full | ✅ Full |
| Sequencer | ✅ Full | ✅ Full |
| Comparer | ✅ Full | ✅ Full |
| Intruder | ⚠️ Rate-throttled | ✅ Full speed |
| Automated vulnerability scanner | ❌ | ✅ |
| Burp Collaborator (OAST/SSRF) | ❌ | ✅ |
| Automated crawler | ❌ | ✅ |
| Project files (save work) | ❌ | ✅ |
| Pro-exclusive BApp extensions | ❌ | ✅ |
| Search function | ❌ | ✅ |

---

## Initial Setup Checklist

```
[ ] Download Burp Suite Community Edition from portswigger.net
[ ] Launch Burp → accept default temporary project
[ ] Go to Proxy → Options → confirm listener on 127.0.0.1:8080
[ ] Configure browser proxy → 127.0.0.1 : 8080
[ ] Visit http://burpsuite/ in browser → download CA certificate
[ ] Install CA cert in browser trust store (Settings → Certificates)
[ ] Test: visit any HTTPS site → request appears in Proxy History
[ ] Define target scope (Target → Scope)
[ ] Install recommended BApp extensions (Extender → BApp Store)
```

---

## Ethical & Legal Requirements

> **Burp Suite is a powerful offensive tool. Misuse is illegal.**

- Only test systems you **own** or have **explicit written authorisation** to test
- Obtain written scope agreements before any engagement
- Authorised bug bounty programmes (HackerOne, Bugcrowd, Intigriti) define legal scope
- Practice on intentionally vulnerable targets: OWASP Juice Shop, DVWA, HackTheBox, TryHackMe, PortSwigger Web Security Academy
- Never test production systems without authorisation — even "just looking" constitutes unauthorised access in most jurisdictions

---

## Recommended Learning Resources

| Resource | URL |
|---|---|
| PortSwigger Web Security Academy (Free) | `https://portswigger.net/web-security` |
| Burp Suite Documentation | `https://portswigger.net/burp/documentation` |
| OWASP Juice Shop (Practice target) | `https://owasp.org/www-project-juice-shop` |
| TryHackMe — Burp Suite rooms | `https://tryhackme.com` |
| HackTheBox Academy | `https://academy.hackthebox.com` |

---

## Key Workflow: Manual Penetration Test with Community Edition

```
1. SCOPE DEFINITION
   └─ Add target to scope in Target tab

2. RECONNAISSANCE
   └─ Browse all app features manually
   └─ Let Proxy capture everything in History
   └─ Review Site Map for hidden endpoints

3. ANALYSIS
   └─ Identify interesting parameters, tokens, auth mechanisms
   └─ Decode suspicious values with Decoder
   └─ Test token strength with Sequencer

4. EXPLOITATION (MANUAL)
   └─ Send interesting requests to Repeater
   └─ Modify and resend → analyse responses
   └─ Use small Intruder payloads for fuzzing

5. VALIDATION
   └─ Use Comparer to confirm findings
   └─ Document in notes within Target tab

6. REPORTING
   └─ Export findings from Proxy History / Target
   └─ Write clear reproduction steps per vulnerability
```

---

*Last updated: June 2026 | Based on Burp Suite Community Edition by PortSwigger*
