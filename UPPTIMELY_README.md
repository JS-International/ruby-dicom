ssh dicom-test
irb
require 'redis'
require 'json'
require 'pp'
redis=Redis.new host: 'localhost'
redis.keys (look for a secure random)
guid = (key from above)
dicom_object = JSON.parse(redis.get(guid)).to_h
pp dicom_object
keys_to_keep = ['Transfer Syntax UID', "Patient's Name", "Modality"] * e.g. *
distilled_dicom = dicom_object.select {|key| keys_to_keep.include?(key)}

g