class HomeController < ApplicationController
  skip_before_filter :protect_from_forgery, only: :upload

  def index
    @assets = Asset.all    
  end

  def upload
    asset = Asset.new(image: params[:image], file_name: params[:image].original_filename)
    asset.save!
    render json: {asset_id: asset.id} 
  end

  def remove_image
    Asset.find(params[:asset_id]).destroy
    render nothing: true
  end

  def set_primary
    Asset.primary.update_all(is_primary: false)

    asset = Asset.find(params[:asset_id])
    asset.update_attributes(is_primary: true)
  end
end
