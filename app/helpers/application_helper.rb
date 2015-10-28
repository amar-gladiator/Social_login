module ApplicationHelper
	
  def bootstrap_class_for flash_type
    case flash_type
      when :success
        "alert-success"
      when :error
        "alert-error"
      when :alert
        "alert-block"
      when :notice
        "alert-info"
      else
        flash_type.to_s
    end
  end

  def sign_in_url(provider)
    provider = 'google' if provider == 'google_oauth2'
    raw("<span class='btn btn-block btn-social btn-#{provider}'>
    <i class='fa fa-#{provider}'></i> Sign in with #{provider.titleize}
    </span>")
  end
end
