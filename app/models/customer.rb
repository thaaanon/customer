require 'open-uri'

class Customer < ApplicationRecord
  # Attach an image
  has_one_attached :image

  # Virtual attribute for the image URL (not stored in the database)
  attr_accessor :image_url

  # Validations
  validates :full_name, presence: true, length: { minimum: 2 }
  validates :phone_number, presence: true, format: { with: /\A\d{3}-\d{4}\z/, message: "must be in the format 555-1234" }
  validates :email_address, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }
  validate :birthdate_must_be_in_the_past

  # Callback to download the image if an image URL is provided
  after_validation :download_image_from_url, if: -> { image_url.present? && !image.attached? }

  # Custom validation method for birthdate
  def birthdate_must_be_in_the_past
    if birthdate.present? && birthdate >= Date.today
      errors.add(:birthdate, "must be in the past")
    end
  end

  # Custom method to display customer information
  def full_info
    "#{full_name} - #{email_address} (#{phone_number})"
  end

  private

  # Method to download and attach an image from the provided URL
  def download_image_from_url
    begin
      downloaded_image = URI.open(image_url)
      self.image.attach(io: downloaded_image, filename: "profile-#{id}.png", content_type: downloaded_image.content_type)
    rescue => e
      errors.add(:image_url, "could not be downloaded. Please check the URL.")
    end
  end
end
