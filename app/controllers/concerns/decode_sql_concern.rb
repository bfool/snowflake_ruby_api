module DecodeSqlConcern
  extend ActiveSupport::Concern

  included do
    before_action :decode_sql
    attr_reader :sql
  end

  def decode_sql
    @sql = Base64.urlsafe_decode64(params[:SQL])
    @sql.gsub!(/"/, '')
  rescue ArgumentError => e
    render plain: "SQL: #{e.message}"
  end
end
