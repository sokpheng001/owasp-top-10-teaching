# Ways to Find IDOR (Insecure Direct Object Reference) Vulnerabilities

Insecure Direct Object Reference (IDOR) vulnerabilities occur when an application exposes internal object references (such as IDs, filenames, or keys) without enforcing proper authorization checks. This guide details the core methodologies, environments, and techniques used to discover them.

---

## 1. Methodology & Testing Techniques

### 1.1 Manual Parameter Tampering
Direct manipulation of client-side inputs is the simplest way to uncover IDOR vulnerabilities.
* **URL Modification:** Alter numeric IDs embedded directly within the URL structure.
  * *Example:* `/user/123` → `/user/124`
* **Query Parameters:** Modify visible parameters appended to endpoints.
  * *Example:* `?invoice_id=100` → `?invoice_id=101`
* **POST Body Alteration:** Adjust payload fields inside JSON, XML, or form-encoded requests.
  * *Example:* `{"account_id": "456"}` → `{"account_id": "457"}`
* **Boundary Testing:** Attempt edge-case values such as negative numbers (`-1`), zero (`0`), or exceptionally large integers (`99999999`).

### 1.2 Intercept & Modify Requests (Proxy Testing)
Leveraging proxy tools like Burp Suite or OWASP ZAP allows deeper inspection and manipulation of traffic flow.
* **Traffic Capture:** Route application traffic through a proxy to log all state-changing or data-retrieval actions.
* **Manual Replay (Repeater):** Isolate specific requests containing identifiers and iteratively tweak them to observe response differences.
* **Automated Fuzzing (Intruder):** Configure payload positions over target ID parameters to systematically iterate across large numerical sequences or dictionary lists.

### 1.3 Horizontal Privilege Escalation Testing
Testing if a user can access resources belonging to a peer with the same privilege tier.
1. **Setup:** Provision two distinct accounts within the same access tier (e.g., Account A [Attacker] and Account B [Victim]).
2. **Identification:** Execute actions as Account B and record the specific resource IDs generated or accessed.
3. **Execution:** Switch to Account A's session context (cookies, headers, or bearer tokens). Attempt to query or modify Account B's resource IDs.
4. **Analysis:** Access granted implies a horizontal IDOR flaw.

### 1.4 Vertical Privilege Escalation Testing
Testing if a lower-privileged user can access resources reserved for higher-privileged roles.
* **Access Control Bypass:** Attempt to query administrative endpoints or administrative resource IDs using a low-privilege user token.
* **Direct Resource Querying:** Extract a known admin-only object reference and replay the request under a standard user session.

### 1.5 Encoded & Hashed ID Analysis
Applications often obfuscate identifiers to deter superficial tampering, but obfuscation does not mean authorization.
* **Encoding Schemes:** Identify and reverse common schemas like Base64.
  * *Example:* `dXNlcl8xMjM=` decodes to `user_123`. Tamper, re-encode, and replay.
* **Cryptographic Hashes:** Detect predictable patterns (e.g., MD5, SHA-1). Cross-reference hashes with common dictionaries or check if they are generated deterministically (such as hashing sequential numbers).
* **UUIDs/GUIDs:** While universally unique identifiers are hard to guess, determine if they are leaked elsewhere in the application, or if they follow a predictable version (e.g., UUIDv1 which includes timestamp data).

### 1.6 API Endpoint Enumeration
Modern microservices and single-page apps extensively leverage APIs that are highly susceptible to IDOR.
* **REST Ecosystems:** Map out routes systematically (`GET /api/v1/orders/{id}`).
* **GraphQL APIs:** Inspect schemas and query configurations for exposed object fields or vulnerable resolvers that allow pulling arbitrary nodes via IDs.
* **Client-Side Source Code:** Analyze compiled JavaScript bundle files (`main.js`, `chunk.js`) to uncover unadvertised API endpoints exposing object references.

### 1.7 HTTP Method Switching
Web servers occasionally apply broken access controls contextually based on the HTTP verb.
* **Verb Tampering:** If a resource blocks unauthorized access via a `GET` request, test verbs such as `POST`, `PUT`, `DELETE`, `PATCH`, or `OPTIONS` against that same object reference.
* *Example:* Changing `GET /api/v1/invoice/100` (Blocked) to `DELETE /api/v1/invoice/100` (Vulnerable).

### 1.8 Referrer & Response Analysis
Identifiers frequently leak through adjacent channels, simplifying exploitation.
* **Response Inspection:** Analyze HTTP headers (e.g., `Location: /uploads/file_99.pdf` on creation blocks), meta tags, or developer logs.
* **External Vectors:** Mine valid candidate IDs from secondary outputs such as automated emails, exported reporting files (PDF/CSV), or detailed stack traces/error messages.

### 1.9 Batch/Array Parameter Testing
Backend parameter parsing logic can sometimes be manipulated to process unintended scope blocks.
* **Array Pollution:** Pass parameters formatted as arrays to see if the authorization logic evaluates only the first index while the data layer executes all inputs.
  * *Example:* Modify `?id=1` to `?id[]=1&id[]=2&id[]=99`

### 1.10 Chained IDOR Discovery
IDOR vectors can be paired with separate, lower-severity vulnerabilities to maximize impact.
* **Information Leaks:** Use a minor leak (e.g., an unauthenticated directory listing or user search feature) to harvest valid object IDs, then feed those IDs into an IDOR-vulnerable endpoint.
* **High-Impact Workflows:** Target password reset token verification pipelines, private file compilation downloaders, or invoice fulfillment handlers.

---

## 2. Automated Tooling & Extensions

Leverage automation to dynamically intercept and audit access control layers during runtime:

* **Autorize (Burp Suite Extension):** Automatically repeats intercepted requests with an alternative session token, highlighting differences in response lengths and status codes to quickly flag candidate IDOR vectors.
* **Agartha (Burp Suite Extension):** Designed for mapping complex matrices of user roles, privileges, and references to identify matrix bypass paths.
* **ffuf / wfuzz:** Command-line fuzzing utilities used for sweeping parameter blocks or payload sequences rapidly through targeted URLs and API routes.

---

## 3. High-Value Targets Matrix

| Target Component | Resource Endpoint / Parameter Patterns | Vulnerability Context |
| :--- | :--- | :--- |
| **User Profiles** | `/profile?user_id=123` | Exposure of PII, session tokens, or private settings. |
| **File Downloads** | `/download?file=report_456.pdf` | Direct extraction of sensitive cloud storage or server assets. |
| **Order/Invoice Pages** | `/invoice/789` | Financial disclosure and regulatory compliance breaches. |
| **Password Resets** | `?token=abc123` | Account takeover via token substitution or state prediction. |
| **API Object Access** | `GET /api/messages/55` | Data exfiltration due to missing validation on internal micro-routes. |
| **Admin Functions** | `/admin/deleteUser?id=10` | Full administrative takeover or structural data deletion. |

---

## 💡 Core Philosophy & Defense Mindset
> **Key Tip:** Always evaluate access controls within **authenticated contexts**. The core of an IDOR vulnerability is not that an ID is visible or sequential, but that the application server implicitly **trusts client-supplied parameters** without validating whether the requesting entity possesses explicit ownership or authorization permissions for that specific object.
