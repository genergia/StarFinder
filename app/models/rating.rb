class Rating < ApplicationRecord
  belongs_to :post
  validates :sky_light, :sky_clear, :sky_extent, :accessiblity, :convenient, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }, presence: true
end
