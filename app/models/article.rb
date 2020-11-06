class Article < ApplicationRecord
    has_rich_text :description
    has_rich_text :draft_description
    attr_accessor :publish
end
