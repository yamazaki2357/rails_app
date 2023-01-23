class ApplicationMailer < ActionMailer::Base
  # 送信元のメールアドレスを設定
  default from: "yamazaki.h.1005@gmail.com"
  layout "mailer"
end
