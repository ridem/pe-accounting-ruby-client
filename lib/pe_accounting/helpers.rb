module PeAccounting
  refine Object do
    def file(name, file)
      return {
        "filename": name,
        "data": file_to_hex(file)
      }
    end

    def date(datetime)
      datetime.strftime("%Y-%m-%d")
    end

    private

    # Converts a File to its hexadecimal representation
    #
    # @param f [File] A binary file.
    # @return [String] A string representing the file in hexadecimal form.
    def file_to_hex(f)
      f.unpack('H*').first
    end
  end
end
