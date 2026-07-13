# Pipeline Workflow

The pipeline combines multiple open-source reconnaissance tools into a single automated workflow. Each stage builds upon the results of the previous one to maximize subdomain coverage while keeping the process simple and reproducible.

## Workflow

```text
                Target Domain
                      │
        ┌─────────────┴─────────────┐
        ▼                           ▼
   Sublist3r                  Subfinder
        └─────────────┬─────────────┘
                      ▼
              Merge & Deduplicate
                 (passive.txt)
                      │
                      ▼
                  PureDNS
               (Bruteforce)
                 (puredns.txt)
                      │
                      ▼
        Top Passive + Bruteforce Results
                      │
                      ▼
                   AltDNS
         (Generate Hostname Variations)
                      │
                      ▼
                  MassDNS
          (Validate Generated Names)
                 (altdns.txt)
                      │
                      ▼
          Merge & Deduplicate Results
                      │
                      ▼
                  final.txt
```

## Stage 1 — Passive Enumeration

The pipeline begins by collecting publicly available subdomains using two independent tools:

* **Sublist3r**
* **Subfinder**

The outputs are merged and duplicate entries are removed to create a single list of passive discoveries.

**Output:** `passive.txt`

---

## Stage 2 — Active Bruteforce

PureDNS performs DNS bruteforcing using the supplied subdomain wordlist and trusted resolver list.

This step discovers subdomains that may not appear in passive data sources.

**Output:** `puredns.txt`

---

## Stage 3 — Alternate Hostname Enumeration

To limit runtime, only the first configurable number of discovered subdomains (`MAX_FOR_ALT`) are selected.

AltDNS generates common hostname permutations from these seed subdomains, such as environment prefixes, numbering patterns, and alternate naming conventions.

These generated hostnames are then validated using MassDNS.

**Output:** `altdns.txt`

---

## Stage 4 — Final Result Generation

The validated AltDNS results are merged with the passive and brute-force discoveries.

Duplicate entries are removed, producing a final consolidated list of unique subdomains.

**Output:** `final.txt`

---

## Intermediate Files

Several intermediate files are generated during execution to preserve the output of each stage. This makes it easier to inspect individual tool results or troubleshoot the pipeline if required.

A description of each generated file is available in `docs/output-files.md`.
