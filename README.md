# Intune Secure Boot and OS Compliance Detection Script

> Detects Secure Boot status and OS build version on Windows 11 devices for use as an Intune Proactive Remediation detection script to assess fleet readiness ahead of the 2026 Secure Boot certificate expiry.

## Overview

This PowerShell script was extracted from an article on [MSEndpoint.com](https://msendpoint.com) and is part of the professional automation portfolio.

### Quick Start

```powershell
# Clone the repository
git clone https://github.com/Msendpoint/intune-secure-boot-compliance-detection.git
cd intune-secure-boot-compliance-detection

# One-click install & run (checks prerequisites, installs modules, launches script)
.\Install.ps1

# Or run the script directly
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\scripts\intune-secure-boot-compliance-detection.ps1
```

## Script Usage

```powershell
.\scripts\intune-secure-boot-compliance-detection.ps1
```

## Tech Stack

PowerShell, Microsoft Intune, Proactive Remediations

## Requirements

- PowerShell 7.0 or later
- Microsoft Graph CLI (if applicable)
- Exchange Online Management module (if applicable)
- Appropriate administrative permissions

## About the Author

**Souhaiel Morhag** — Microsoft 365 & Intune Automation Specialist

- 🌐 **Blog**: [https://msendpoint.com](https://msendpoint.com) — Enterprise endpoint management insights
- 📚 **Academy**: [MSEndpoint Academy](https://app.msendpoint.com/academy) — Professional training & certifications
- 💼 **LinkedIn**: [Souhaiel Morhag](https://linkedin.com/in/souhaiel-morhag) — Connect for collaboration
- 🐙 **GitHub**: [@Msendpoint](https://github.com/Msendpoint)

## Source Article

This script originated from:
**[Preparing Your Intune-Managed Fleet for the Windows 11 Secure Boot Certificate Expiry in 2026](https://msendpoint.com/article/preparing-your-intune-managed-fleet-for-the-windows-11-secure-boot-certificate-expiry-in-2026)**

Published on MSEndpoint.com — Enterprise endpoint management blog

## Contributing

1. Fork this repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Commit your changes (`git commit -m 'feat: add improvement'`)
4. Push to the branch (`git push origin feature/improvement`)
5. Open a Pull Request

## License

MIT License — see [LICENSE](LICENSE) for details.

## Support

- Report issues: [GitHub Issues](https://github.com/Msendpoint/intune-secure-boot-compliance-detection/issues)
- Questions: Comment on the original article or reach out on LinkedIn

---

*Developed with ❤️ by [MSEndpoint.com](https://msendpoint.com) — Your Microsoft 365 Endpoint Management Partner*