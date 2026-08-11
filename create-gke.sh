echo "starting to create the gke cluster"

# I have chose the delhi region
# You should put as per your liking
# https://docs.cloud.google.com/compute/docs/regions-zones
gcloud container clusters create gitops-gcp \
  --zone=asia-south2-a \
  --machine-type e2-medium \
  --num-nodes 1 \
  --workload-pool="${PROJECT_ID}.svc.id.goog" \
  --project="$PROJECT_ID"
