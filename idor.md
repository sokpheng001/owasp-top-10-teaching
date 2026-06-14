Ways to Find IDOR (Insecure Direct Object Reference) Vulnerabilities
IDOR vulnerabilities occur when an application exposes internal object references (IDs, filenames, keys) without proper authorization checks. Here are the main methods to discover them:

1. Manual Parameter Tampering

Change numeric IDs in URLs: /user/123 → /user/124
Modify query params: ?invoice_id=100 → ?invoice_id=101
Alter POST body fields: {"account_id": "456"} → {"account_id": "457"}
Try negative numbers, zero, or very large numbers

2. Intercept & Modify Requests (Burp Suite / OWASP ZAP)

Capture requests with a proxy
Replay requests with modified object references
Use Burp's Repeater to manually tweak IDs
Use Intruder to fuzz ID ranges automatically

3. Horizontal Privilege Escalation Testing

Create two accounts (attacker + victim)
Perform actions as victim, capture resource IDs
Switch to attacker session and access victim's resource IDs
Check if access is granted without authorization

4. Vertical Privilege Escalation Testing

Use a low-privilege account to access resources owned by admin/higher roles
Try accessing admin endpoints with regular user tokens

5. Encoded & Hashed ID Analysis

Decode Base64 IDs: dXNlcl8xMjM= → user_123
Identify hash patterns (MD5, SHA1) and try to crack or predict them
Look for GUIDs/UUIDs — sometimes they're guessable or leaked

6. API Endpoint Enumeration

Test REST APIs: GET /api/v1/orders/{id}
Check GraphQL queries for exposed object fields
Look at JavaScript files for hidden API endpoints with object references

7. HTTP Method Switching

Try GET, POST, PUT, DELETE, PATCH on the same object reference
Some endpoints restrict one method but not others

8. Referrer & Response Analysis

Object IDs often leak in HTTP responses, headers, or redirects
Check Location: headers after creating resources
Mine IDs from emails, export files (PDF/CSV), or error messages

9. Batch/Array Parameter Testing

Try sending arrays of IDs: ?id[]=1&id[]=2&id[]=99
Some APIs process multiple objects and may return unauthorized ones

10. Chained IDOR Discovery

Combine IDOR with other bugs (e.g., use an info-leak bug to get valid IDs, then exploit IDOR)
Password reset flows, file download links, and invoice endpoints are common chaining targets

11. Automated Scanning

Autorize (Burp extension) — automatically replaces session tokens and checks for IDOR
Agartha — Burp extension for privilege escalation/IDOR
ffuf / wfuzz — fuzz ID parameters in URLs


Common High-Value Targets
LocationExampleUser profiles/profile?user_id=123File downloads/download?file=report_456.pdfOrder/invoice pages/invoice/789Password reset tokens?token=abc123API object accessGET /api/messages/55Admin functions/admin/deleteUser?id=10

Key Tip
Always test IDOR in authenticated contexts — the vulnerability exists when the server trusts the client-supplied reference without verifying the requester owns or has permission to access that object.