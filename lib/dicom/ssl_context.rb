module DICOM

  class SslContext

    def self.call(ssl_options = {})
      context = OpenSSL::SSL::SSLContext.new
      if ssl_options.any?
        if ssl_options[:path]
          path = ssl_options[:path].match(/\/$/) ? "#{ssl_options[:path]}/" : ssl_options[:path]
        else
          path = ''
        end
        cert_path = path + (ssl_options[:cert] || 'fullchain.pem')
        key_path = path + (ssl_options[:key] || 'privkey.pem')
        chain_path = path + (ssl_options[:chain] || 'chain.pem')

        context.cert = OpenSSL::X509::Certificate.new( File.read( cert_path ))
        context.key = OpenSSL::PKey::RSA.new( File.read( key_path ))
        context.extra_chain_cert = [OpenSSL::X509::Certificate.new( File.read( chain_path ))] 
      end
      return context
    end
  end
end
