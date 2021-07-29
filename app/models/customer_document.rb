class CustomerDocument < ApplicationRecord
  validates :name, :content, :public_level, presence: true
  belongs_to :user
  belongs_to :customer
  mount_uploader :document, DocumentUploader
end
