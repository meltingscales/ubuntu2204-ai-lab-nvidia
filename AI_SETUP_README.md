# AI Tools Setup for Ubuntu 22.04

This repository contains scripts to set up ComfyUI, Ollama, and OpenWebUI on Ubuntu 22.04 bare metal.

## Quick Start

1. **Install Dependencies First**:
   ```bash
   ./setup_dependencies.sh
   ```

2. **Install AI Tools**:
   ```bash
   ./setup_ai_tools.sh
   ```

3. **Reload your shell** (or restart terminal):
   ```bash
   source ~/.bashrc
   ```

## What Gets Installed

### Dependencies Script (`setup_dependencies.sh`)
- System packages and build tools
- Python 3.x development stack
- Node.js LTS and npm
- Multimedia libraries (FFmpeg, OpenCV, etc.)
- AI/ML system dependencies (BLAS, LAPACK, etc.)
- Development tools (git, curl, vim, etc.)

### AI Tools Script (`setup_ai_tools.sh`)
- **ComfyUI**: Node-based stable diffusion GUI
- **Ollama**: Local LLM runtime with pre-installed models
- **OpenWebUI**: Web interface for Ollama
- Desktop shortcuts
- Systemd services for auto-start

#### Pre-installed Models
The script automatically downloads these models:
- `llama3.2:3b` - Fast general-purpose model
- `yuiseki/devstral-small-2507:24b` - Development-focused model
- `hf.co/bartowski/Qwen2.5-Coder-14B-Instruct-abliterated-GGUF:Q4_K_S` - Code generation
- `hf.co/mlabonne/gemma-3-27b-it-abliterated-GGUF:Q4_K_M` - Large instruction model

## Usage

### ComfyUI
```bash
# Launch manually
~/ai-tools/launch_comfyui.sh

# Access in browser
http://localhost:8188
```

### Ollama
```bash
# Check status
sudo systemctl status ollama

# Download a model
ollama pull llama2

# List installed models
ollama list

# API endpoint
http://localhost:11434
```

### OpenWebUI
```bash
# Launch manually
~/ai-tools/launch_openwebui.sh

# Or use systemd service
systemctl --user start openwebui
systemctl --user enable openwebui  # auto-start

# Access in browser
http://localhost:8080
```

## Directory Structure

```
~/ai-tools/
├── ComfyUI/                 # ComfyUI installation
│   ├── venv/               # Python virtual environment
│   └── ...
├── openwebui-env/          # OpenWebUI Python environment
│   ├── bin/open-webui      # OpenWebUI executable
│   └── ...
├── launch_comfyui.sh       # ComfyUI launcher script
└── launch_openwebui.sh     # OpenWebUI launcher script
```

## Troubleshooting

### ComfyUI Issues
- Check Python virtual environment: `~/ai-tools/ComfyUI/venv/bin/python --version`
- Update ComfyUI: `cd ~/ai-tools/ComfyUI && git pull`
- Reinstall dependencies: `cd ~/ai-tools/ComfyUI && source venv/bin/activate && pip install -r requirements.txt`

### Ollama Issues
- Check service: `sudo systemctl status ollama`
- Restart service: `sudo systemctl restart ollama`
- View logs: `journalctl -u ollama -f`

### OpenWebUI Issues
- Check if Ollama is running: `curl http://localhost:11434/api/version`
- Check Python environment: `~/ai-tools/openwebui-env/bin/python --version`
- Test manual launch: `~/ai-tools/launch_openwebui.sh`
- View service logs: `journalctl --user -u openwebui -f`

## GPU Support

The current setup installs CPU-only versions. For GPU acceleration:

1. Install NVIDIA drivers and CUDA toolkit
2. Reinstall PyTorch with CUDA support:
   ```bash
   cd ~/ai-tools/ComfyUI
   source venv/bin/activate
   pip uninstall torch torchvision torchaudio
   pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
   ```

## Security Notes

- All services run on localhost by default
- OpenWebUI runs as user service (not system-wide)
- No external network access by default
- Review firewall settings if accessing remotely

## Requirements

- Ubuntu 22.04 LTS
- At least 8GB RAM (16GB recommended)
- 20GB free disk space
- Internet connection for downloads