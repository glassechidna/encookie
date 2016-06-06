module Encookie
  class Cryptor
    Encrypted = Struct.new(:ciphertext, :iv, :auth_tag)

    def self.encrypt(plaintext:, key:)
      cipher = OpenSSL::Cipher.new 'aes-128-gcm'
      cipher.encrypt
      cipher.key = key
      iv = cipher.random_iv
      cipher.auth_data = ''
      ciphertext = cipher.update(plaintext) + cipher.final
      auth_tag = cipher.auth_tag
      Encrypted.new(ciphertext, iv, auth_tag)
    end

    def self.decrypt(ciphertext:, key:, iv:, auth_tag:)
      cipher = OpenSSL::Cipher.new 'aes-128-gcm'
      cipher.decrypt
      cipher.key = key
      cipher.iv = iv
      cipher.auth_tag = auth_tag
      cipher.auth_data = ''
      cipher.update(ciphertext) + cipher.final
    end
  end
end
