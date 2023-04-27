create_cluster:
	eksctl create cluster -f cluster.yaml

delete_cluster:
	eksctl delete cluster -f cluster.yaml

describe_cluster:
	eksctl utils describe-stacks --region=us-east-1 --cluster=YOUR_KUBERNETES_CLUSTER_NAME

aws_identity:
	aws sts get-caller-identity

set_context:
	eksctl utils write-kubeconfig --cluster=YOUR_KUBERNETES_CLUSTER_NAME --set-kubeconfig-context=true

enable_iam_sa_provider:
	eksctl utils associate-iam-oidc-provider --cluster=YOUR_KUBERNETES_CLUSTER_NAME --approve

create_cluster_role:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/rbac-role.yaml

create_iam_policy:
	curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.2.0/docs/install/iam_policy.json
	aws iam create-policy \
		--policy-name AWSLoadBalancerControllerIAMPolicy \
		--policy-document file://iam_policy.json

create_service_account:
	eksctl create iamserviceaccount \
      --cluster=YOUR_KUBERNETES_CLUSTER_NAME \
      --namespace=kube-system \
      --name=aws-load-balancer-controller \
      --attach-policy-arn=arn:aws:iam::553001092438:policy/AWSLoadBalancerControllerIAMPolicy \
      --override-existing-serviceaccounts \
      --approve

create_cert_manager:
	helm repo add jetstack https://charts.jetstack.io
	helm repo update
	helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.9.0 --set startupapicheck.timeout=5m --set installCRDs=true --set webhook.hostNetwork=true --set webhook.securePort=10260

cert_install_alb_controller:
	helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
		-n kube-system \
		--set clusterName=YOUR_KUBERNETES_CLUSTER_NAME \
		--set serviceAccount.create=false \
		--set serviceAccount.name=aws-load-balancer-controller 
	helm repo add aws-load-balancer-controller https://aws.github.io/eks-charts
	helm repo update
	helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller \
		--set clusterName=YOUR_KUBERNETES_CLUSTER_NAME \
		--set serviceAccount.create=false \
		--set serviceAccount.name=aws-load-balancer-controller \
		--set region=us-east-1 \
		--set vpcId=vpc-01642d4fc1a9ec36f \
		-n kube-system

get_loadbalancer_pods:
	kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller

logs_loadbalancer_pods:
	kubectl logs -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller

reinstall_alb_controller:
	kubectl delete pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller
	helm uninstall aws-load-balancer-controller -n kube-system
	helm repo add aws-load-balancer-controller https://aws.github.io/eks-charts
	helm repo update
	helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller \
   --set clusterName=YOUR_KUBERNETES_CLUSTER_NAME \
   --set serviceAccount.create=false \
   --set serviceAccount.name=aws-load-balancer-controller \
   --set region=us-east-1 \
   --set vpcId=vpc-01642d4fc1a9ec36f \
   -n kube-syste

get_alb_endpoint:
	kubectl get ingress backend-api-ingress -n default -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'

deploy_application:
	kustomize build ./k8s | kubectl apply -f -

update_deployments:
	awk -v date="$$(date -u +%Y-%m-%dT%H:%M:%SZ)" '/kubectl.kubernetes.io\/restartedAt:/ {gsub(/"(.*)"/, "\"" date "\"")} {print}' k8s/deployment/portal-deployment.yaml > tmp.yaml && mv tmp.yaml k8s/deployment/portal-deployment.yaml
	awk -v date="$$(date -u +%Y-%m-%dT%H:%M:%SZ)" '/kubectl.kubernetes.io\/restartedAt:/ {gsub(/"(.*)"/, "\"" date "\"")} {print}' k8s/deployment/api-deployment.yaml > tmp.yaml && mv tmp.yaml k8s/deployment/api-deployment.yaml

delete_application:
	kustomize build ./k8s | kubectl delete -f -
