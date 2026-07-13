# Installation

This project depends on several third-party reconnaissance tools. Install each dependency before running the pipeline.

## 1. Clone the Repository

```bash
git clone https://github.com/<your-username>/subdomain-enumeration-pipeline.git
cd subdomain-enumeration-pipeline
```

## 2. Install Sublist3r Dependencies

A copy of Sublist3r is included in this repository.

Install its Python dependencies using the bundled `requirements.txt`:

```bash
python3 -m venv ~/python3_venv
source ~/python3_venv/bin/activate

pip install -r Sublist3r/requirements.txt
```

By default, the script expects the virtual environment to be located at:

```text
~/python3_venv/
```

If your virtual environment is elsewhere, update the `PYTHON_PATH` variable in `main.sh`.

## 3. Install Required Tools

Install the following tools using their official installation instructions:

* Subfinder
* PureDNS
* AltDNS
* MassDNS

After installation, ensure the binaries are available in your system's `PATH`, or update the `GO_PACKAGES_PATH` variable in `main.sh` if required.

## 4. Resolver and Wordlists

The required resolver lists and wordlists are already included under the `wordlists/` directory. No additional setup is required.

## 5. Verify Installation

Confirm that the required tools are accessible:

```bash
subfinder -h
puredns -h
altdns -h
massdns -h
```

Also verify that Python can execute Sublist3r:

```bash
~/python3_venv/bin/python Sublist3r/sublist3r.py -h
```

## 6. Run the Pipeline

```bash
chmod +x main.sh
./main.sh example.com
```

Generated files will be written to:

```text
outputs/example.com/
```
