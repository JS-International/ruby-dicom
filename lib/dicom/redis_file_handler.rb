module DICOM
  class RedisFileHandler < DICOM::FileHandler
    require 'securerandom'


    def self.save_file(path_prefix, dcm, transfer_syntax)
      # Save the DICOM object to Redis:
      $redis.set(SecureRandom.uuid, dcm.to_hash.to_json)
      message = [:info, "DICOM file processed "]
      return message
    end
  end
end