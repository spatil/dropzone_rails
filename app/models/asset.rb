class Asset
  include Mongoid::Document

  mount_uploader :image, AssetUploader

  field :file_name  
  field :file_size
  field :is_primary, type: Boolean, default: false

  scope :primary, where(is_primary: true)

  def name
    self.file_name
  end

  def size
    self.file_size
  end

  def remote_url 
    self.image.url
  end
  
  def type
    "image/png"
  end

  def as_json(options= {})
    options.merge!(only: [:_id, :is_primary], methods: [:name, :size, :remote_url, :type])
    super
  end

  private

  def update_asset_attributes
    if image.present? && image_changed?
      self.file_size = image.file.size
    end
  end
end
