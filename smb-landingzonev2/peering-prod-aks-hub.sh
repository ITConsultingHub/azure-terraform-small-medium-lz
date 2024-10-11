#!/opt/homebrew/opt/bash/bin/bash  # Use the Homebrew-installed Bash if needed

# Check for required commands
for cmd in az jq; do
  if ! command -v $cmd &> /dev/null; then
    echo "Error: $cmd could not be found. Please install $cmd."
    exit 1
  fi
done

# Exit script on any command failure
set -e

# Login to Azure CLI (if needed, remove this if you're already logged in)
az login -o tsv

# Define the subscription ID (you can replace this with your own)
SUBSCRIPTION_ID="83ba76c2-808d-4e06-9419-eed9cd489b9d"
az account set --subscription $SUBSCRIPTION_ID

# Define variables for the Production AKS VNet, Fractal-Bitcoin-Node VNet, and Hub VNet
aks_vnet_name="aks-network-prod"
aks_vnet_rg="terraform-aks-canadacentral-prod"
bitcoin_vnet_name="Fractal-Bitcoin-Node-vnet"
bitcoin_vnet_rg="Fractal-Bitcoin-Node_group"
hub_vnet_name="vnet-hub-oc"
hub_vnet_rg="rg-hub-oc"

# Define the peering names
aks_to_hub_peering="prod-aks-to-hub"
hub_to_aks_peering="hub-to-prod-aks"
bitcoin_to_hub_peering="fractal-bitcoin-to-hub"
hub_to_bitcoin_peering="hub-to-fractal-bitcoin"

# Get the full resource ID for the AKS, Bitcoin Node, and Hub VNets
aks_vnet_id=$(az network vnet show --name $aks_vnet_name --resource-group $aks_vnet_rg --query id --out tsv)
bitcoin_vnet_id=$(az network vnet show --name $bitcoin_vnet_name --resource-group $bitcoin_vnet_rg --query id --out tsv)
hub_vnet_id=$(az network vnet show --name $hub_vnet_name --resource-group $hub_vnet_rg --query id --out tsv)

# Create peering from Production AKS VNet to Hub VNet
az network vnet peering create \
    --name $aks_to_hub_peering \
    --resource-group $aks_vnet_rg \
    --vnet-name $aks_vnet_name \
    --remote-vnet $hub_vnet_id \
    --allow-vnet-access \
    --out tsv

# Create peering from Hub VNet to Production AKS VNet
az network vnet peering create \
    --name $hub_to_aks_peering \
    --resource-group $hub_vnet_rg \
    --vnet-name $hub_vnet_name \
    --remote-vnet $aks_vnet_id \
    --allow-vnet-access \
    --out tsv

# Create peering from Fractal Bitcoin Node VNet to Hub VNet
az network vnet peering create \
    --name $bitcoin_to_hub_peering \
    --resource-group $bitcoin_vnet_rg \
    --vnet-name $bitcoin_vnet_name \
    --remote-vnet $hub_vnet_id \
    --allow-vnet-access \
    --out tsv

# Create peering from Hub VNet to Fractal Bitcoin Node VNet
az network vnet peering create \
    --name $hub_to_bitcoin_peering \
    --resource-group $hub_vnet_rg \
    --vnet-name $hub_vnet_name \
    --remote-vnet $bitcoin_vnet_id \
    --allow-vnet-access \
    --out tsv

echo "Peering between Production AKS VNet, Fractal-Bitcoin-Node VNet, and Hub VNet completed successfully!"
