Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79608FD7078
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 11:00:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4F896B0005; Tue, 17 Mar 2026 07:00:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D006F6B0088; Tue, 17 Mar 2026 07:00:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEF7E6B0089; Tue, 17 Mar 2026 07:00:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AF4D36B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:00:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 70DF71B8633
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:00:55 +0000 (UTC)
X-FDA: 84555262470.23.BF9715E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6C9F41C000F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:00:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CRBf+0v8;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773745253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OU9HeMbqI29tof6Rtl7nuJTqNNWh/njQGsMtuCZxsoE=;
	b=UJ4kv8qxC7JkhfH5thu6EnYuhXz/eAQtyPNc9sdFfOSMDqSDQ2FpCMHMxTMd6lv98MhXeK
	NGDSWDpbrkeTrQPKZ43rWfZQ/SAaCr2QZxyP0swfpQQYLwoukHdjLHRuY8Dy9ykXgMY7NB
	+WdW4vHxdCKzZ6nQXAtxD3T5gIbzNc0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773745253; a=rsa-sha256;
	cv=none;
	b=mbRmm4QkMWUEoo0bWb7DMngCjR5P7mVzZ8urpZ0c2wcAunV3zjDzgXnw73XMs8CijDjPq8
	oQ8KntVEWaPoo954giJrkzB83ZfWtoTNs5f18AGHA+ZmJy/s/Gs7k7wXllZGLU8EOq9skN
	k1TYkGi+m5Q9ZLyYif0ZbPbFghKmqGE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CRBf+0v8;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E9B741A7E;
	Tue, 17 Mar 2026 11:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228B9C2BC9E;
	Tue, 17 Mar 2026 11:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773745252;
	bh=oj7nohgoi4g+nFKcItDav0B2W2ZLJfi60fDH0eZKBxI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CRBf+0v8BAFxiJEwAGlzA4PCbbAq9cgkT4n7aoC4DF4BVfG/fEiESc+rMbX30IiHD
	 IsXd65rWUOWuNdxJVGu8HjGXvCTE1vRM7ZbbqWk5JqBDOHWOuzAgN7ahJb0P+jwVxj
	 pVDzAX6wW4gsnuVXPdcDUcXH9AdbZOHjC7dFW2CdziFC5ZELQMxaqmV646OTZvKgvq
	 /XNaoJp7Tsz6OnS7TGIA0n1lcWKBHsu+QRBjQM8TZrS65wjYq7k51XXtTT2+1hS5oV
	 3oG99B7y35oM9QTyIrOxNlbOh67ctwH/x6QTYQexb+h9pvczN/ZXSBHcSAaPe7S7QL
	 GTjFz7kVeBKQw==
Message-ID: <fe849bdc-485b-4cac-88e5-d8c5c49f36dd@kernel.org>
Date: Tue, 17 Mar 2026 12:00:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/5] selftests/mm: move write_file helper to vm_util
To: Chunyu Hu <chuhu@redhat.com>, akpm@linux-foundation.org,
 shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
References: <20260317094419.1429259-1-chuhu@redhat.com>
 <20260317094419.1429259-4-chuhu@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260317094419.1429259-4-chuhu@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oik9po6etsaruhgb6k6hcjpyhdz4u1oq
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C9F41C000F
X-Rspamd-Server: rspam12
X-HE-Tag: 1773745253-827705
X-HE-Meta: U2FsdGVkX1/B02oSPjRqd5hC8nvAJl0VPMbWGzG3OzlFM7Cyzh8PIGri5XpLgcjmWnKRGQIGm6pCB1L6PbnK6lew89OLJtZTF30BAqU2bA1UlrKnfZf1qfC9VO+14w5Aly2U2C2Bheb8HJsZUr2n1pwFmTo9qCan8WuXI3mJrFo4QHlF22RDx/K0ypacJ9VNrFGDOSfHFOwAHsFrzywRSWHMKwZ28KNTuasaDKUvjqwNsjp60i5hh806cayBoV48m05XuTZpOV86kIqRAUEQDVBSfT2JmYIsp1xinUhuMro5p8nLjn52lJRkf8jo1kUbD5NrJ6oZX1t5CDvzfufwai44N3TMCVLS/qzsfrej50IuIctBToFnnIMN+L80KcRti72c3dgxjpeNR31r534qqUIZzcNqwaeVDO/ROrdjVsS1/RHzaeDWeB/va6zQi3J2CcYEh+6IyVgGcnYiGuiSZqFx32qQS9M4WK6Rt+z2+UkHBJR+3QXgheS0af99v1etYV6NsPTqZ3ydpB7KVKD4JWZEpKMyAIEGMTsYGXR37ew3cOw0bI2wNuSUucoRQj7l75sW9Rz0gO6/o29LfVQItXfEFRT5Ee0d9iGhmL8TGzH8GYjBHXQpzOzeCUcT1Bx6X+LZwhdQ7pnlT+hwjX1jsmys6nDvOi2VSN9JDseThYst9DKH2AMFdTCjFVVyARBOpPbzG4A9EeX/SuBbZTN4NvzHkXAE89qdkoSVhXo4dfHacL+wO3qK8V2TJ5p+QV0oFCwbsLV55A5rbE+AuLCHZagGZ08M+6Z0ozmKkR75RqWzR3aELa0cnZ4DlT7Td6UDN7pCWP5xrCPzpiKLrvflT7p+Xhz4VHT/bp+UWZDR5NS43nyVccPy9kWi/NtXwM7nMZ7LouG/MtlbVMGK2ixm9U/FI+3Vx9R+US3gWsFgVE1l2Q7A3qjTYKmwDGDgpkFWxe7ciqnIdXqgRy1+kNM
 Bgg3Cpuo
 efopX5cx86fSaACt36fxK3bTQlH+3pBkBBzbYvSzrPw8Y8lpU+GXjpqsE8m72rPOoNJMLFyKJpu55LGnoDanPxCUI8Sm5k3Jb5gRFa5tByUu+fXpFS+MuUN905Esm0eOy3+U71QutLOYUut3x6ibrXHjiuqZN/pD/ldtvVdORebaKIn+1r6OBFX0WIvUmG4T7FKVuus5jze6sB/LrSJpGUazpsaglb02BcZQMEyjl4p/kM/t7q3EBUaMTcXZTXzNN8hmheG/f9klxh0rKMC6uzzk5MgwcyjO5w0byCfGgAnfPFqjhoN7PitKcNLsKBMb3MuuGuQopcu/MR7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>  
>  int thp_read_string(const char *name, const char * const strings[])
> @@ -165,11 +140,7 @@ void thp_write_string(const char *name, const char *val)
>  		printf("%s: Pathname is too long\n", __func__);
>  		exit(EXIT_FAILURE);
>  	}
> -
> -	if (!write_file(path, val, strlen(val) + 1)) {
> -		perror(path);
> -		exit(EXIT_FAILURE);
> -	}
> +	write_file(path, val, strlen(val) + 1);

Wondering what happens if a test like migration.c that uses
kselftest_harness.h ends up calling ksft_exit_fail_msg().

I assume the ksft_exit_fail* will simply set exit(KSFT_FAIL) and make
the __wait_for_test() helper happy.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

