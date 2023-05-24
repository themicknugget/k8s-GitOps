# K8s backed by Flux

[Talos](https://talos.dev) cluster with [Terraform](https://www.terraform.io) backed by [Flux](https://toolkit.fluxcd.io/) and [SOPS](https://toolkit.fluxcd.io/guides/mozilla-sops/).

Powered by the [GitOps](https://www.weave.works/blog/what-is-gitops-really) tool [Flux](https://toolkit.fluxcd.io/). Utilizing [Terraform](https://github.com/carlpett/terraform-provider-sops) and [Flux](https://toolkit.fluxcd.io/guides/mozilla-sops/) SOPS integrations to utilize Age encrypted secrets within this public repository.

Effectively, this GitHub repository is the heart of my cluster.

## Overview

- [Repository structure](https://github.com/themicknugget/k8s-GitOps#-repository-structure)
- [Rebuild counter](https://github.com/themicknugget/k8s-GitOps#-rebuild-counter-5)
- [Thanks](https://github.com/themicknugget/k8s-GitOps#-thanks)

## 📂 Repository structure

The Git repository contains the following directories under `kubernetes`.

```
kubernetes/     # Kubernetes cluster defined as code
├── apps        # Regular applications, namespaced directory tree
├── bootstrap   # Flux Installation
└── flux        # Main flux configuration
```

## 💣 Rebuild counter: 0

How many times I've had to nuke and re-build my cluster, either due to hardware failure or hasty updating.

## 🤝 Thanks

I sincerely appreciate all the past, present, and future guidance and advice from those who helped make this possible.
I would also like to thank those that contributed to the projects being used within this repository.
