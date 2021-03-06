# frozen_string_literal: true

module Draftable
  extend ActiveSupport::Concern

  def update
    klass = params[:controller].split("/").last.classify
    resource_name = klass.downcase
    requested_resource = klass.constantize.find(params[:id])
    resource_params = params[resource_name]

    requested_resource.update(params[resource_name].to_unsafe_hash)
    apply_draft(requested_resource, resource_params, resource_name) if resource_params[:publish] == "1"
    if requested_resource.save
      render :show
    else
      render :edit
    end
  end

  def apply_draft(resource, resource_params, resource_name)
    params[resource_name].keys.each do |k|
      if k.starts_with?("draft_")
        draft_content = k
        content = k.delete_prefix('draft_')
        resource.update_attribute(content, resource_params[draft_content])
      end
    end
  end

end