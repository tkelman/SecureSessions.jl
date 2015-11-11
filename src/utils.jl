# Contents: Utility functions for SecureSessions.jl


"Cryptographically secure RNG"
function csrng(numbytes::Integer)
    entropy = MbedTLS.Entropy()
    rng     = MbedTLS.CtrDrbg()
    MbedTLS.seed!(rng, entropy)
    rand(rng, numbytes)
end


"""
Returns: Milliseconds since the epoch.

Takes 13 characters (valid until some time around the year 2287).
"""
function get_timestamp()
    1000 * convert(Int, Dates.datetime2unix(now()))
end


"""
Returns true if username adheres to the following formatting rules:
1) length(username) <= 20
2) username contains none of the following tags:
       "<script>", "<link>", "<img>", "<iframe>", "<object>"
"""
function username_is_permissible(username)
    result = length(username) <= 20
    if result
        bad_tags = ["<script>", "<link>", "<img>", "<iframe>", "<object>"]
        for tag in bad_tags
            if contains(username, tag)
                 result = false
                 break
            end
        end
    end
    result
end


"""
Returns true is password adheres to the following formatting rules:
  R1) Length at least 8 characters
  R2) At least 5 unique characters
  R3) At least 1 upper case letter
  R4) At least 1 lower case letter
  R5) At least 1 number
  R6) At least 1 special character
"""
function password_is_permissible(password)
    # Determine the truth values of rules 1 to 6.
    uniq = unique(password)
    n    = length(uniq)
    r1   = length(password) >= 8
    r2   = n >= 5
    r3   = false
    r4   = false
    r5   = false
    r6   = false
    for i = 1:n
	c     = uniq[i]
	c_int = Int(c)
	if c == uppercase(c)
	    r3 = true
	elseif c == lowercase(c)
	    r4 = true
	elseif c_int >= 48 && c_int <= 57
	    r5 = true
	else
	    r6 = true
	end
    end

    # Calculate result
    result = false
    if r1 && r2 && r3 && r4 && r5 && r6
	result = true
    end
    result
end
