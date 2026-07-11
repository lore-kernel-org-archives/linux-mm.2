Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CD9EC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 07:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29B9A6B008A; Sat, 11 Jul 2026 03:31:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2728F6B008C; Sat, 11 Jul 2026 03:31:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 189426B0092; Sat, 11 Jul 2026 03:31:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5C8F6B008A
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 03:31:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A06814067E
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 07:31:31 +0000 (UTC)
X-FDA: 84975675582.09.9A8A88F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id BBD0418000D
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 07:31:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KhO/XnPL";
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783755089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pXKkMbE8S50fgci7zV//UdWNphx5itNGzvWESRKObgE=;
	b=pumSyDh2i2QoM9Qc6qUSzyl3JaGuA5p1iPEn0ZTJ5izYErRxvQkTUNKajUBST2s9eokCVs
	GNB6hFVi79bwgiSgXwL7yYDz4w5elYNVuz2MtjNHDuzULW8heGUDVlY64kUnt+kQM6wkVP
	N1OZTTf6agWvjDVAmMGtj84n42xUOTk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KhO/XnPL";
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783755089;
	b=kzNzH8bOBc9n7VEpAyvok07m7MM/8Iy1floecCA6qpcVwa/c9x3VASS8oYjri8K85FINHO
	bUrxJiP+wMsBps+bXAEZfJQdNiutFYhU1RFD6FdxVqlXufWJ7p+CtMPvuogU6KSIhIahoC
	fwN+eoianR6sgt5ljjB2MLt7mdrWdCs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C838A4178A;
	Sat, 11 Jul 2026 07:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AA91F000E9;
	Sat, 11 Jul 2026 07:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783755088;
	bh=pXKkMbE8S50fgci7zV//UdWNphx5itNGzvWESRKObgE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KhO/XnPLypEcN+qXIRTWLzu8O2Y/F16+kdI29zDTSrvLklMfo7TQcpfnonmGvvJG7
	 pP52IH5+GRUjeVRbg5Yy4rSKY7/AewvEcTgb/jgyIOTouLqc4kxiFUTT56uKE2mmHQ
	 ItFhV1PI/gf3irZiMqfcv6mG//q1/aSvea078Todvek8GmXbnMs2iJktQkf5aNNVP+
	 ofJJDnK5Kv2qKXdMj5pPwq6dJeYEhrzbIpFKkwz2zxTb/8vKn1GpPEdiF7H3pOY324
	 klFrHq8C6cmF7Lh3uFdxDiHR9LbkvO+bcPmUL9IZkzit5qoQogkYEQp4PVfvtmwegY
	 7SCmG5BTmBNsQ==
Date: Sat, 11 Jul 2026 08:31:16 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org, 
	david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, hongfu.li@linux.dev
Subject: Re: [PATCH] selftests/mm: Fix memleak in migration benchmark
Message-ID: <alHxLNTQFJlb3cLV@lucifer>
References: <20260708103705.840679-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708103705.840679-1-lihongfu@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BBD0418000D
X-Stat-Signature: z1ri7n4bu89s91zi1o5hu69uujijwm6c
X-HE-Tag: 1783755089-366090
X-HE-Meta: U2FsdGVkX19w8ehBtrfCFHpUktj8pMA5VrQ67nLY+ES2nGt5yzRdslCKAfNl+iSH6sQNsCdU+qoD7lRo1ZxDDBfGwguUHEHtsOVgb89n2VQvApcRwztMvUFORUcRnnydIy9YhM7Lqt4jNQR4QV7DbwBGX++FSlVnN13CMDr76XBSgOAMrnlLa/3JsOVYpcDXja9HrNm3gvtUZPc1w9MTT27QUXDycP7rSOqPU7oSyDn9G9/N1XsoFam2Fw6wP6laYKRUKa/I+v7FUT2iQf5ehQsHYzWfvXixptyU6n5AH7emOuOvV3dKYXMA6u6EOIt+Ny6WjIE9lJdE2kO3hpOdFO5vIYzhcZbty6+3qL0FQSdMrxcVE77BZuFJpMF+ESGmjRgpolzrGYKlNDUQW1bknmNZmr0go/r24nVbxRmUtiZP/sWjT8zwAC5FUc62C8gGY5Ck+phuCX+HSnubL2pNIhRFwFYv0NiagsScTVYPEhohUUzhyi4gIIqLDTvdPdeGAQ2JcKZmB//4N8n1kPFWKDZCAowJ3ZVCdg/maEOYMQUq2e5MYWOP71auQxuizcpdS7i6sUFqEbW1f3SM/6MyekYz4MJI0u+7MENdhv8vBHYoO9MiTH/1sWaEAtFMSRB8juvcOfe7Y2tY3jomfVTZihJDMj6BPPjUCapxfpZXf5k4LdyhfVdjsXbyH2cv9wdUloq32oms5fd8eC6pHLyQInocf8JPr6AeiFCA393pqvCRyIjznXcR83rhsJedYJfQz7Xd49vIsS0hmaPWS/IzSeknO8ENWBC3tGDYqukJ7NKn5n0hHvk/DOeMQAGeDeNyv5eNPaL9xD0Rn3JP02jvogYbx2MyC/1lu+oQd7uI+PoGeIkJp7I1EKit4tcesUtiM3wTGcqJQ9JIXbvayqqKThcFPEjpx4W1lV79aVJUaRgMkZo9PhBr09y6YwZDleMiemqjLQS2/5QJsMUTXHH
 LpvmTnNn
 lbF7dFIcpIIis14vqlCPVO23aKbBZZdCp6celnLy+t+k4ZKC5Lr4qiGZmsvF4AHI/Jol8a8eqEVtfjZYdK2Xx2NMRcMGAqA+c2FWk3z99UPy/CXG3Xzhds4njIOMotvgBmD2U49cD6sZjm3OKHYrea2Omfh3sb+mr3xZR+LqnOTMCD1WWcTejFSfMgQlsZ8CXvg1xcUZx/tbuBpykNFoVe12/2VkUa/8VU7p1JqC+BM92DFFs0IY3HdGxBfJBPZQYXuqcQ7aRz4t0bBdzd9twr1fOkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 06:37:05PM +0800, Hongfu Li wrote:
> Several early return paths in run_migration_benchmark() skip
> hmm_buffer_free(), leaking the buffer. Replace with a single cleanup
> label.
>
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

LGTM. With the Fixes tag added as requested by David, feel free to add:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/hmm-tests.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
> index e4c49699f3f7..e8046675a0c3 100644
> --- a/tools/testing/selftests/mm/hmm-tests.c
> +++ b/tools/testing/selftests/mm/hmm-tests.c
> @@ -2828,8 +2828,10 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
>  	buffer->ptr = mmap(NULL, buffer_size, PROT_READ | PROT_WRITE,
>  			  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>
> -	if (buffer->ptr == MAP_FAILED)
> -		return -1;
> +	if (buffer->ptr == MAP_FAILED) {
> +		ret = -1;
> +		goto cleanup;
> +	}
>
>  	/* Apply THP hint if requested */
>  	if (use_thp)
> @@ -2838,7 +2840,7 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
>  		ret = madvise(buffer->ptr, buffer_size, MADV_NOHUGEPAGE);
>
>  	if (ret)
> -		return ret;
> +		goto cleanup;
>
>  	/* Initialize memory to make sure pages are allocated */
>  	ptr = (int *)buffer->ptr;
> @@ -2848,11 +2850,11 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
>  	/* Warmup iteration */
>  	ret = hmm_migrate_sys_to_dev(fd, buffer, npages);
>  	if (ret)
> -		return ret;
> +		goto cleanup;
>
>  	ret = hmm_migrate_dev_to_sys(fd, buffer, npages);
>  	if (ret)
> -		return ret;
> +		goto cleanup;
>
>  	/* Benchmark iterations */
>  	for (i = 0; i < iterations; i++) {
> @@ -2861,7 +2863,7 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
>
>  		ret = hmm_migrate_sys_to_dev(fd, buffer, npages);
>  		if (ret)
> -			return ret;
> +			goto cleanup;
>
>  		end = get_time_ms();
>  		s2d_total += (end - start);
> @@ -2871,7 +2873,7 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
>
>  		ret = hmm_migrate_dev_to_sys(fd, buffer, npages);
>  		if (ret)
> -			return ret;
> +			goto cleanup;
>
>  		end = get_time_ms();
>  		d2s_total += (end - start);
> @@ -2886,8 +2888,9 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
>  				 (results->dev_to_sys_time / 1000.0);
>
>  	/* Cleanup */
> +cleanup:
>  	hmm_buffer_free(buffer);
> -	return 0;
> +	return ret;
>  }
>
>  /*
> --
> 2.25.1
>

Cheers, Lorenzo

