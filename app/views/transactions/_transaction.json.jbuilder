json.extract! transaction, :id, :organization_id, :membership_id, :amount, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)