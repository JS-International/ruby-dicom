ssh in
irb
require 'redis'
require 'json'
redis=Redis.new host: 'localhost'
redis.keys (look for a secure random)
guid = (key from above)
dicom_object = JSON.parse(redis.get(guid)).to_h
keys_to_keep = ['Transfer Syntax UID', "Patient's Name", "Modality"] * e.g. *
distilled_dicom = dicom_object.select {|key| keys_to_keep.include?(key)}

