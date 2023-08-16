class Comment < ApplicationRecord
  
  # Validation
  validates :content, presence: true, length: { maximum: 100 }

  # 追加された
  belongs_to :post
end
