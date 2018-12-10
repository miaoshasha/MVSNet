def cloud_local_file_exchange(start_location, destination_folder, file_name=""):
    # pull or push data between buckets and local directory
    # return the path of destination
    # will create local folder to save stuff
    # bucket has to exist for pushing stuff

    # start_location: string, e.g. gs://bucket_name/sub_folder, without file names
    # destination folder: string, e.g. /full/path/on/local/machine, without file names
    from subprocess import call
    if start_location[:5] == "gs://":
        # downloading data, make sure destination folder exists
        call(['mkdir', '-p', destination_folder])

    if file_name == "":
        # copying full folder
        start_location = start_location+'/*'
        call(['gsutil','-m','cp','-r', start_location, destination_folder])
        return destination_folder

    full_start_path = start_location + '/' + file_name
    full_des_path = destination_folder + '/' + file_name

    call(['gsutil', 'cp', '-r', full_start_path, full_des_path])
    return full_des_path
