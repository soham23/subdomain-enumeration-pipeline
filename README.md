# Subdomain Enumeration Pipeline

A lightweight Bash pipeline that automates passive and active subdomain enumeration by combining multiple open-source reconnaissance tools into a single workflow.

The pipeline performs passive discovery, DNS bruteforcing, alternate hostname generation, and result deduplication to produce a consolidated list of unique subdomains.

## Features

- Passive enumeration using Sublist3r and Subfinder
- Active DNS bruteforcing with PureDNS
- Alternate hostname generation with AltDNS
- Validation using MassDNS
- Deduplicated final output for each target
- Organized output directory per domain

## Workflow

```
          Target Domain
                │
     ┌──────────┴──────────┐
     ▼                     ▼
Sublist3r             Subfinder
     └──────────┬──────────┘
                ▼
            Passive Merge
                │
                ▼
             PureDNS
                │
                ▼
              AltDNS
                │
                ▼
             MassDNS
                │
                ▼
             final.txt
```

## Usage

```bash
chmod +x main.sh
./main.sh example.com
```

## Generated Output

After execution, the pipeline creates a dedicated output directory under `outputs/` for the target domain.

![Output Directory](screenshots/outputs-directory.png)

## Requirements

The following third-party tools must be installed and accessible:

- Sublist3r
- Subfinder
- PureDNS
- AltDNS
- MassDNS

See the documentation below for installation instructions.

## Documentation

- [Installation Guide](docs/installation.md)
- [Pipeline Workflow](docs/workflow.md)
- [Generated Output Files](docs/output-files.md)
- [Execution Examples](docs/examples.md)

## Acknowledgements

This project builds upon the excellent work of the maintainers of Sublist3r, Subfinder, PureDNS, AltDNS, MassDNS, SecLists, and the Trickest DNS resolver list.

## License

Released under the MIT License.