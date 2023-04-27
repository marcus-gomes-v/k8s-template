# Kubernetes Cluster Repository

This repository contains the necessary configuration files and scripts to create, manage, and deploy applications to a Kubernetes cluster. The repository is organized as follows:

* `Makefile`: Contains commands to manage the cluster and deploy applications.
* `k8s`: Contains Kubernetes manifests organized by their types, such as ConfigMaps, Deployments, Ingresses, and Services.

## Getting Started

Before you begin, make sure you have the following tools installed:

* `eksctl`: The official CLI tool for Amazon EKS.
* `kubectl`: The Kubernetes command-line tool.
* `helm`: The Kubernetes package manager.
* `kustomize`: A Kubernetes-native configuration management tool.

## Usage

### Cluster Management

Use the following commands for cluster management:

* **Create a new cluster** : `make create_cluster`
* **Delete the cluster** : `make delete_cluster`
* **Describe the cluster** : `make describe_cluster`
* **Set the cluster context** : `make set_context`
* **Enable the IAM service account provider** : `make enable_iam_sa_provider`
* **Create a cluster role** : `make create_cluster_role`
* **Create an IAM policy** : `make create_iam_policy`
* **Create a service account** : `make create_service_account`
* **Install the AWS Load Balancer controller** : `make cert_install_alb_controller`

### Application Deployment

Use the following commands for application deployment:

* **Deploy the application** : `make deploy_application`
* **Update datetime to redeploy same image** : `make update_deployments`
* **Delete the application** : `make delete_application`

### Troubleshooting and Monitoring

Use the following commands for troubleshooting and monitoring:

* **Get ALB controller pods** : `make get_loadbalancer_pods`
* **View ALB controller logs** : `make logs_loadbalancer_pods`
* **Reinstall the ALB controller** : `make reinstall_alb_controller`
* **Get the ALB endpoint** : `make get_alb_endpoint`

## Repository Structure


The repository is organized as follows:

<pre><div class="bg-black rounded-md mb-4"><div class="flex items-center relative text-gray-200 bg-gray-800 px-4 py-2 text-xs font-sans justify-between rounded-t-md"><br class="Apple-interchange-newline"/></div></div></pre>


```shell
├── Makefile
├── cluster.yaml
└── k8s
    ├── kustomization.yaml
    ├── configmap
    │   ├── api-configmap.yaml
    │   └── portal-configmap.yaml
    ├── deployment
    │   ├── api-deployment.yaml
    │   └── portalo-deployment.yaml
    ├── service
    │   ├── api-service.yaml
    │   └── portal-service.yaml
    └── ingress
        └── ingress.yaml
```

Feel free to explore the repository and make any necessary changes to suit your needs. Don't forget to update the Makefile and Kubernetes manifests accordingly.

Feel free to explore the repository and make any necessary changes to suit your needs. Don't forget to update the Makefile and Kubernetes manifests accordingly.

## Contributing

1. Fork the repository.
2. Create a new branch with your changes.
3. Open a pull request with a detailed description of your changes.

Please ensure your changes follow best practices and are properly documented.

## License

This project is open-source and available under the [MIT License](https://chat.openai.com/LICENSE).
