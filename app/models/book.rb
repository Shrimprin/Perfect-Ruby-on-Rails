class Book < ApplicationRecord
  belongs_to :publisher
  has_many :book_authors
  has_many :authors, through: :book_authors

  # バリデーション
  validates :name, presence: true
  validates :name, length: { maximum: 25 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  # コールバック
  before_validation do
    self.name = self.name.gsub(/Cat/) do |matched|
      "lovely #{matched}"
    end
  end

  after_destroy do
    Rails.logger.info "Book is deleted: #{self.attributes}"
  end

  after_destroy :if => :high_price? do
    Rails.logger.warn "Book with high price is deleted: #{self.attributes}"
    Rails.logger.warn "Please check!"
  end

  def high_price?
    price >= 5000
  end

  # Enum(列挙型)
  enum sales_status: {
    reservation: 0, # 予約受付
    now_on_sale: 1, # 販売中
    end_of_print: 2, # 販売終了
  }
end
