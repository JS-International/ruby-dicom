module DICOM
  require 'securerandom'
  class RedisFileHandler < DICOM::FileHandler

    def self.save_file(path_prefix, dcm, transfer_syntax)
      guid = SecureRandom.uuid
      # Save the DICOM object to Redis:
      
      $redis.set(guid, dcm.to_hash.to_json)
      AWorker.perform_async(guid)
      message = [:info, "DICOM file processed with guid: #{guid}"]
      return message
    end
  end
end