# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  
  org_success = Dropzone.prototype.defaultOptions.success
  org_removed = Dropzone.prototype.defaultOptions.removedfile
  
  Dropzone.options.assetsDropzone = {
    addRemoveLinks: true,
    paramName: 'image',
    previewTemplate: '<div class="dz-preview dz-file-preview">  <div class="dz-details">    <div class="dz-filename"><span data-dz-name></span></div>    <div class="dz-size" data-dz-size></div>    <img data-dz-thumbnail />  </div>  <div class="dz-progress"><span class="dz-upload" data-dz-uploadprogress></span></div>  <div class="dz-success-mark"><span>✔</span></div>  <div class="dz-error-mark"><span>✘</span></div>  <div class="dz-error-message"><span data-dz-errormessage></span></div><div class="dz-primary-mark"></div><a class="dz-set-primary">Set Primary</a></div>',
    removedfile: (file) ->
      $.ajax({
        url: "/#{file._id}/remove_image",
        method: 'post'
      })
      org_removed(file)
    ,
    success: (file, data) ->
      index = $('#assets-dropzone').get(0).dropzone.files.indexOf(file)
      $('#assets-dropzone').get(0).dropzone.files[index]["_id"] = data["asset_id"]
      $('#assets-dropzone').get(0).dropzone.files[index].previewElement.id = data["asset_id"]
      org_success(file)
  }
  Dropzone.autoDiscover = false

  $('#assets-dropzone').on 'click', '.dz-set-primary', ->
    $.ajax({
      url: "/#{$(this).parent().attr('id')}/set_primary",
      method: 'post'
    })
    
  if images?
    $('#assets-dropzone').dropzone()

    $.each images, (i, image) ->
      $('#assets-dropzone').get(0).dropzone.addExistingFile(image)
    
    primary_asset = images.filter((x) ->
      x if x.is_primary is true
    )[0]

    $('#'+primary_asset._id).addClass('dz-primary') if primary_asset?
