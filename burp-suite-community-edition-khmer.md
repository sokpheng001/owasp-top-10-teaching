# Burp Suite Community Edition — មគ្គុទ្ទេសក៍សំខាន់សម្រាប់អ្នក Ethical Hacker លើបណ្តាញ

> **កំណែ:** Community Edition (ឥតគិតថ្លៃ)  
> **អ្នកផលិត:** PortSwigger  
> **គោលបំណង:** ការធ្វើតេស្តសុវត្ថិភាព Web Application ដោយដៃ  
> **ទាញយក:** [portswigger.net/burp/communitydownload](https://portswigger.net/burp/communitydownload)

---

## តើ Burp Suite Community Edition គឺជាអ្វី?

Burp Suite Community Edition គឺជាវេទិកា intercepting proxy ស្តង់ដារឧស្សាហកម្ម **ឥតគិតថ្លៃ** ដែលបង្កើតដោយ PortSwigger។ វាស្ថិតនៅចន្លោះ browser របស់អ្នក និង web application គោលដៅ ដោយចាប់យករាល់ HTTP/HTTPS request និង response ទាំងអស់។ វាផ្តល់ឱ្យ ethical hacker នូវវិស័យទស្សនៈពេញលេញលើការចរាចរ application-layer — ដែលជាអ្វីដែល browser developer tool ធម្មតា មិនអាចផ្តល់បានឡើយ។

វាគឺជាចំណុចចូលដំបូងសម្រាប់អ្នកដែលចាប់ផ្តើមធ្វើ web penetration testing ឬ bug bounty hunting ហើយវានៅតែមានសារៈសំខាន់ដល់អ្នកជំនាញស្ទាត់ជំនាញសម្រាប់ workflow ការធ្វើតេស្តដោយដៃ។

---

## មុខងារស្នូលដែលមាននៅក្នុង Community Edition

### ១. 🔀 Proxy (ការស្ទាក់ HTTP/HTTPS និង WebSockets)

បេះដូងរបស់ Burp Suite។ Proxy ស្ថិតនៅ `127.0.0.1:8080` ហើយស្ទាក់ចរាចរទាំងអស់រវាង browser របស់អ្នក និងគោលដៅ។

| សមត្ថភាព | ព័ត៌មានលម្អិត |
|---|---|
| ការស្ទាក់ HTTP/HTTPS | មើល, ផ្អាក, កែប្រែ, និងបញ្ជូន request/response |
| ការគាំទ្រ WebSocket | ស្ទាក់ និងពិនិត្យ WebSocket messages |
| ប្រវត្តិ Proxy | កំណត់ហេតុពេញលេញនៃចរាចរទាំងអស់សម្រាប់ការវិភាគពីក្រោយ |
| ការឌិគ្រីប TLS/SSL | តាមរយៈ CA certificate ដែលដំឡើងក្នុង browser |
| ប៊ូតុងស្ទាក់ | បើក/បិទ — "បើក" ផ្អាករាល់ request សម្រាប់ការពិនិត្យដោយដៃ |

**ការដំឡើង (ចាប់ផ្តើមលឿន):**
```
១. បើក Burp → ផ្ទាំង Proxy → បើក Intercept ON
២. កំណត់ browser proxy → 127.0.0.1 : 8080
៣. ដំឡើង CA certificate របស់ Burp ក្នុង browser (សម្រាប់ HTTPS)
៤. រុករក​ទៅ​គោលដៅ → ចរាចរលេចឡើងក្នុង Burp
```

**ករណីប្រើប្រាស់:** ពិនិត្យ authentication flows, ការហៅ API, ការដោះស្រាយ token, ការបញ្ជូន cookie, និងប៉ារ៉ាម៉ែត្រដែលលាក់ស្ងាត់។

---

### ២. 🔁 Repeater

Repeater អនុញ្ញាតឱ្យអ្នកបញ្ជូនឡើងវិញ និងកែប្រែ HTTP requests ដែលបានចាប់ទុកដោយដៃ ច្រើនដងតាមដែលត្រូវការ ជាមួយការប្រៀបធៀប response ភ្លាមៗ។

**Workflow:**
```
Proxy History → ចុចប្ដូរស្ដាំ​លើ request → Send to Repeater
→ កែប្រែ parameters/headers/body → ចុច Send → វិភាគ response
```

**អ្វីដែលត្រូវធ្វើតេស្តជាមួយ Repeater:**
- SQL injection (`id=1'` → រកមើល DB errors)
- XSS payloads (`<script>alert(1)</script>` នៅក្នុងវាល input)
- IDOR (ផ្លាស់ `user_id=12` ទៅ `user_id=13`)
- ការឆ្លងកាត់ Authentication (លុប/កែប្រែ auth tokens)
- ចំណុចខ្វះខាតតក្កវិជ្ជាអាជីវកម្ម (តម្លៃអវិជ្ជមាន, ការគ្រប់គ្រងបរិមាណ)
- ការ fuzzing endpoint API

**មុខងារសំខាន់:**
- រក្សាទុកផ្ទាំង និងដាក់ឈ្មោះតាមប្រភេទភាពងាយរងគ្រោះ
- ប្រៀបធៀបប្រវែង request/response សម្រាប់ការរកឃើញ blind injection
- បញ្ជូន request ជាបន្តបន្ទាប់សម្រាប់ការធ្វើតេស្តដំណើរការច្រើនជំហាន

---

### ៣. 🎯 Intruder (Demo / កំណត់ល្បឿន)

Intruder ធ្វើស្វ័យប្រវត្តិកម្មការវាយប្រហារ​ដែលបានកំណត់ដោយការបញ្ចូល payloads ផ្សេងៗ ចូលទៅក្នុងទីតាំងដែលបានកំណត់នៃ HTTP request។

> ⚠️ **ការដាក់កម្រិតរបស់ Community Edition:** Intruder ត្រូវបានកំណត់ល្បឿនខ្លាំងនៅក្នុងកំណែឥតគិតថ្លៃ។ Requests ត្រូវបានធ្វើឱ្យយឺតដោយចេតនា ធ្វើឱ្យមិនអាចប្រើបានជាក់ស្តែងសម្រាប់ wordlists ធំ។ ប្រើ payload sets តូច (១០–២០ entries) សម្រាប់ការរៀន និងការធ្វើតេស្តជាមូលដ្ឋាន។

**របៀបវាយប្រហារ:**

| របៀប | ការពិពណ៌នា |ករណីប្រើប្រាស់ |
|---|---|---|
| Sniper | payload set មួយ, ទីតាំងមួយម្ដងៗ | Fuzzing ប៉ារ៉ាម៉ែត្រតែមួយ |
| Battering Ram | payload ដូចគ្នានៅគ្រប់ទីតាំងក្នុងពេលតែមួយ | Credential stuffing |
| Pitchfork | payload sets ច្រើន, ទីតាំងស្រួចស្រាវ | បញ្ជីឈ្មោះអ្នកប្រើ + ពាក្យសម្ងាត់ |
| Cluster Bomb | ការរួមបញ្ចូលទាំងអស់ក្នុងគ្រប់ទីតាំង | Brute force ទម្រង់ login |

**ប្រភេទ payload ទូទៅ:**
- Wordlists (ឈ្មោះអ្នកប្រើ, ពាក្យសម្ងាត់, paths)
- លេខ (IDs ជាលំដាប់សម្រាប់ IDOR)
- កាលបរិច្ឆេទ និងទម្រង់ផ្ទាល់ខ្លួន
- Null payloads (សម្រាប់ការធ្វើតេស្ត race condition)

**ការប្រើប្រាស់ជាក់ស្តែង (Community Edition):**
- ប្រើ payload lists តូច (< ២០ entries) ដើម្បីធ្វើតេស្តគំនិត
- សម្រាប់ brute force ពិតប្រាកដលើគោលដៅដែលមានការអនុញ្ញាត → ដំឡើងទៅ Professional ឬប្រើ `ffuf`/`wfuzz` ខាងក្រៅ

---

### ៤. 🔍 Decoder

Decoder បំប្លែងទិន្នន័យរវាងទម្រង់ encoding ផ្សេងៗ — ចាំបាច់សម្រាប់ការយល់ដឹងពីរបៀបដែល application ដំណើរការ input និងថាតើវាអាចត្រូវបានរៀបចំបានឬអត់។

**ទម្រង់ដែលគាំទ្រ:**

| Encoding | ឧទាហរណ៍ |
|---|---|
| URL encoding | `%3C%73%63%72%69%70%74%3E` |
| Base64 | `YWRtaW46cGFzc3dvcmQ=` |
| HTML entities | `&lt;script&gt;` |
| Hex | `48 65 6c 6c 6f` |
| Gzip | ការពិនិត្យទិន្នន័យបង្ហាប់ |
| ASCII Hex | ស្រទាប់ encoding ចម្រុះ |

**Workflow:**  
បិទភ្ជាប់តម្លៃដែល encoded → ជ្រើសប្រភេទ encoding → Smart Decode (រៀបចំដោយស្វ័យប្រវត្ត) ឬ chain ជំហាន decode ដោយដៃ។

**ករណីប្រើប្រាស់:**
- Decode JWT tokens (Base64 នីមួយៗ)
- រកឃើញ credentials ដែល Base64-encoded ក្នុង cookies
- រៀបចំការ double-encoding bypasses (URL → URL → HTML)
- ពិនិត្យ serialised objects

---

### ៥. 📊 Sequencer

Sequencer វិភាគភាពចៃដន្យ និង entropy នៃ tokens, session IDs, និង CSRF tokens ដើម្បីកំណត់ថាតើពួកវាអាចទស្សន៍ទាយបានតាម cryptographic ឬអត់។

**របៀបដំណើរការ:**
១. ចាប់ response ដែលមាន session token ឬ CSRF token
២. កំណត់ទីតាំង token ក្នុង response
៣. ដំណើរការការវិភាគ (Burp ស្នើ endpoint ដូចគ្នារាប់រយដង)
៤. ពិនិត្យ entropy report

**អ្វីដែលវារកឃើញ:**
- Session IDs ទន់ខ្សោយ (ជាលំដាប់, ផ្អែកលើពេលវេលា, entropy ទាប)
- CSRF tokens ដែលអាចទស្សន៍ទាយបាន
- ការបង្កើតលេខចៃដន្យមិនសុវត្ថិភាព
- ទម្រង់ការប្រើ token ឡើងវិញ

**លទ្ធផល:** ពិន្ទុ entropy ជាមួយការវិភាគស្ថិតិ — entropy ខ្ពស់ = token រឹងមាំជាង។

---

### ៦. ⚖️ Comparer

Comparer ធ្វើ visual diff រវាង HTTP requests ឬ responses ចំនួនពីរ ដោយបន្លិចភាពខុសគ្នានៅកម្រិត word ឬ byte។

**ករណីប្រើប្រាស់:**
- ប្រៀបធៀប responses ចំពោះ login ត្រឹមត្រូវ vs. មិនត្រឹមត្រូវ (រកភាពខុសគ្នាតូចតាចសម្រាប់ user enumeration)
- រៀបចំការផ្លាស់ប្ដូរប្រវែង response (សូចនករ blind SQLi)
- ប្រៀបធៀប responses ដែល authenticated vs. unauthenticated (ការធ្វើតេស្តការគ្រប់គ្រងការចូលប្រើ)
- រកភាពខុសគ្នារវាង responses របស់ admin និងអ្នកប្រើធម្មតា

**របៀបប្រើ:**
```
ចុចប្ដូរស្ដាំ​លើ request ឬ response ណាមួយ → Send to Comparer
ធ្វើដូចគ្នាសម្រាប់ item ទីពីរ → ផ្ទាំង Comparer → Compare
```

---

### ៧. 🌐 Target (Site Map)

ឧបករណ៍ Target បង្កើតផែនទីដែលអាចមើលឃើញនូវរចនាសម្ព័ន្ធ application ខណៈពេលអ្នករុករក។

**មុខងារ:**
- ទិដ្ឋភាព Tree view នៃ hosts, directories, និង endpoints ទាំងអស់ដែលបានរកឃើញ
- ការកំណត់ Scope (រួមបញ្ចូល/ដកចេញ hosts និង URL paths)
- ភ្ជាប់ annotations ជាមួយ notes និងភាពធ្ងន់ធ្ងរ
- បន្លិច endpoints ដែលគួរអោយចាប់អារម្មណ៍សម្រាប់ការធ្វើតេស្តបន្ត

**ការគ្រប់គ្រង Scope:**  
កំណត់ scope ដើម្បីកម្រិត proxy history, intruder, និងឧបករណ៍ផ្សេងទៀតដល់តែគោលដៅដែលបានអនុញ្ញាតប៉ុណ្ណោះ។ ការពារការធ្វើតេស្ត assets ដែលនៅខាងក្រៅ scope ដោយចៃដន្យ។

---

### ៨. 🧩 BApp Store (Extensions)

BApp Store ផ្តល់ extensions ដែលបង្កើតដោយសហគមន៍ ដែលពង្រីកសមត្ថភាពរបស់ Burp។ ជាច្រើនគឺឥតគិតថ្លៃ ហើយដំណើរការក្នុង Community Edition។

**Extensions ឥតគិតថ្លៃសំខាន់ៗសម្រាប់ Community Edition:**

| Extension | គោលបំណង |
|---|---|
| **Hackvertor** | ការ encoding/decoding កម្រិតខ្ពស់ជាមួយ XML tag chaining |
| **Logger++** | ការ logging request/response ដែលប្រសើរឡើង |
| **Autorize** | ការធ្វើតេស្ត authorisation និង access control ស្វ័យប្រវត្ត |
| **JSON Web Tokens** | Decode, កែ, និងវាយប្រហារ JWTs ដោយផ្ទាល់ក្នុង Burp |
| **Param Miner** | ស្វែងរក parameters និង headers លាក់ស្ងាត់ |
| **HTTP Request Smuggler** | រកឃើញភាពងាយរងគ្រោះ HTTP request smuggling |
| **Software Vulnerability Scanner** | ការរៀបចំ CVE ដោយ passive ផ្អែកលើកំណែកម្មវិធី |
| **InQL** | ការធ្វើតេស្តសុវត្ថិភាព GraphQL |

**ដំឡើង:** ផ្ទាំង Extender → BApp Store → ស្វែងរក → Install

---

## Community vs. Professional — ការប្រៀបធៀបមុខងារ

| មុខងារ | Community (ឥតគិតថ្លៃ) | Professional ($449/ឆ្នាំ) |
|---|---|---|
| HTTP/HTTPS Proxy | ✅ ពេញលេញ | ✅ ពេញលេញ |
| WebSocket Proxy | ✅ ពេញលេញ | ✅ ពេញលេញ |
| Proxy History | ✅ ពេញលេញ | ✅ ពេញលេញ |
| Repeater | ✅ ពេញលេញ | ✅ ពេញលេញ |
| Decoder | ✅ ពេញលេញ | ✅ ពេញលេញ |
| Sequencer | ✅ ពេញលេញ | ✅ ពេញលេញ |
| Comparer | ✅ ពេញលេញ | ✅ ពេញលេញ |
| Intruder | ⚠️ ល្បឿនត្រូវបានកម្រិត | ✅ ល្បឿនពេញ |
| ម៉ាស៊ីនស្កែនភាពងាយរងគ្រោះ ស្វ័យប្រវត្ត | ❌ | ✅ |
| Burp Collaborator (OAST/SSRF) | ❌ | ✅ |
| Crawler ស្វ័យប្រវត្ត | ❌ | ✅ |
| Project files (រក្សាទុកការងារ) | ❌ | ✅ |
| BApp extensions Pro-exclusive | ❌ | ✅ |
| មុខងារស្វែងរក | ❌ | ✅ |

---

## បញ្ជីត្រួតពិនិត្យការដំឡើងដំបូង

```
[ ] ទាញយក Burp Suite Community Edition ពី portswigger.net
[ ] បើក Burp → ទទួលយក project បណ្ដោះអាសន្នលំនាំដើម
[ ] ទៅ Proxy → Options → បញ្ជាក់ listener នៅ 127.0.0.1:8080
[ ] កំណត់ browser proxy → 127.0.0.1 : 8080
[ ] ចូលទៅ http://burpsuite/ ក្នុង browser → ទាញយក CA certificate
[ ] ដំឡើង CA cert ក្នុង browser trust store (Settings → Certificates)
[ ] ធ្វើតេស្ត: ចូលទៅ HTTPS site ណាមួយ → request លេចឡើងក្នុង Proxy History
[ ] កំណត់ target scope (Target → Scope)
[ ] ដំឡើង BApp extensions ដែលបានណែនាំ (Extender → BApp Store)
```

---

## តម្រូវការក្រមសីលធម៌ និងផ្នែកច្បាប់

> **Burp Suite គឺជាឧបករណ៍វាយប្រហារដ៏មានឥទ្ធិពល។ ការប្រើប្រាស់ខុស គឺខុសច្បាប់។**

- ធ្វើតេស្តប្រព័ន្ធដែលអ្នក **ជាម្ចាស់** ឬ **មានការអនុញ្ញាតជាលាយលក្ខណ៍អក្សរ** ប៉ុណ្ណោះ
- ទទួលបានកិច្ចព្រមព្រៀង scope ជាលាយលក្ខណ៍អក្សរ មុនពេលចាប់ប្រថ្នំណាមួយ
- កម្មវិធី bug bounty ដែលមានការអនុញ្ញាត (HackerOne, Bugcrowd, Intigriti) កំណត់ scope ស្របច្បាប់
- អនុវត្តលើគោលដៅដែលងាយរងគ្រោះដោយចេតនា: OWASP Juice Shop, DVWA, HackTheBox, TryHackMe, PortSwigger Web Security Academy
- កុំធ្វើតេស្ត production systems ដោយគ្មានការអនុញ្ញាត — សូម្បីតែ "មើលតែប៉ុណ្ណោះ" ក៏ถือ ជាការចូលប្រើដោយគ្មានការអនុញ្ញាតនៅក្នុងយុត្តាធិការភាគច្រើន

---

## ធនធានសម្រាប់ការរៀនសូត្រដែលបានណែនាំ

| ធនធាន | URL |
|---|---|
| PortSwigger Web Security Academy (ឥតគិតថ្លៃ) | `https://portswigger.net/web-security` |
| ឯកសារ Burp Suite | `https://portswigger.net/burp/documentation` |
| OWASP Juice Shop (គោលដៅអនុវត្ត) | `https://owasp.org/www-project-juice-shop` |
| TryHackMe — បន្ទប់ Burp Suite | `https://tryhackme.com` |
| HackTheBox Academy | `https://academy.hackthebox.com` |

---

## Workflow សំខាន់: ការធ្វើ Penetration Test ដោយដៃជាមួយ Community Edition

```
១. ការកំណត់ SCOPE
   └─ បញ្ចូល​គោលដៅ​ទៅ​ scope ក្នុងផ្ទាំង Target

២. ការ RECONNAISSANCE
   └─ រុករក​មុខងារ​ app ​ទាំងអស់​ដោយ​ដៃ
   └─ ឱ្យ Proxy ចាប់​ទាំង​អស់​ក្នុង History
   └─ ពិនិត្យ Site Map ដើម្បីរក endpoints លាក់ស្ងាត់

៣. ការ ANALYSIS
   └─ ស្គាល់ parameters, tokens, និង auth mechanisms ដែលគួរចាប់អារម្មណ៍
   └─ Decode តម្លៃ​គួរ​សង្ស័យ​ជាមួយ Decoder
   └─ ធ្វើ​តេស្ត​ភាព​រឹងមាំ​ token ​ជាមួយ Sequencer

៤. ការ EXPLOITATION (ដោយដៃ)
   └─ បញ្ជូន requests ​ដែល​គួរ​ចាប់​អារម្មណ៍ ​ទៅ Repeater
   └─ កែ​ប្រែ​ហើយ​បញ្ជូន​ម្ដង​ទៀត → វិភាគ responses
   └─ ប្រើ Intruder payloads តូច​សម្រាប់ fuzzing

៥. ការ VALIDATION
   └─ ប្រើ Comparer ដើម្បីបញ្ជាក់​ការ​រក​ឃើញ
   └─ ចងក្រង​ក្នុង notes ​ក្នុង​ផ្ទាំង Target

៦. ការ REPORTING
   └─ ​នាំ​ចេញ​ការ​រក​ឃើញ​ពី Proxy History / Target
   └─ ​សរសេរ​ជំហាន​ reproduction ​ច្បាស់​លាស់​ក្នុង​មួយ​ភាព​ងាយ​រងគ្រោះ
```

---

*ធ្វើ​បច្ចុប្បន្នភាព​ចុង​ក្រោយ: មិថុនា ២០២៦ | ផ្អែក​លើ Burp Suite Community Edition ដោយ PortSwigger*
