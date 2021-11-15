class ApplicationMailer < ActionMailer::Base
  # this address is a SendGrid's verified sender (https://app.sendgrid.com/settings/sender_auth/senders)
  default from: 'test@cashapp.co.il'
  layout 'mailer'
end
