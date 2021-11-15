class ShirtMailer < ApplicationMailer

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.shirt_mailer.new_count.subject
    #
    def new_shirt(shirt)
      @shirt = shirt
  
      mail to: 'yonyossef4@gmail.com', subject: "Test: New shirt by you", cc: "yonyossef3@gmail.com"
    end
  end