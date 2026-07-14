Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC43CC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 10:07:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D031F6B0005; Tue, 14 Jul 2026 06:07:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3156B0088; Tue, 14 Jul 2026 06:07:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9666B008A; Tue, 14 Jul 2026 06:07:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 933D16B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:07:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E9F7F120339
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:07:37 +0000 (UTC)
X-FDA: 84986955354.27.A280119
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 107B0C0004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:07:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gJyD9QEX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784023656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/175y28NB+ZFC3yHKio3eZe/JFspmgrkZa1O3kEAj9E=;
	b=DiZ88O9+Z+h5EWT14FbXJvdKHyOKvnIZeMFYOLBIeWZNf53w93WYlZ2fqfvbM+t2lz1pCj
	8F9Qzk8um1IrIGmoiCof4kT7vJ4ucuhRZ6bNUz3SJpNIt2+YvH6elmnCiKE3CVh7qww0hV
	ftFbsGpnh54CWDQ42e5xjgq4lwjH64M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gJyD9QEX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784023656;
	b=SAXJninzf7E6KS/IxNa9/UQK0B5u3aQ8e9TMVpZtkGID8VAhhElfZO0H4i34T8wDY0ZMFp
	orUm7Z7HFg7nFde1Ff77+iElYg/NNhT+il9OxttQdLmfWcLRFM8/CRRM5Pw58dNJTN5Lq5
	Zlamhti+oKzf2Sv8f+qnJVhBG8dW5SU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 64C4D60120;
	Tue, 14 Jul 2026 10:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F6B1F00A3A;
	Tue, 14 Jul 2026 10:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784023655;
	bh=/175y28NB+ZFC3yHKio3eZe/JFspmgrkZa1O3kEAj9E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gJyD9QEXespHpA+2dReUkty/xaWk1Mf7m6uy1vuLe2wGx4K5bgW81Pj7zaGIuljgD
	 2RejCTkR9Evunw8dM4kLlDUXTVeEA7HkjN2GZqqURC0rLNiyFW2UdarzMyUlwtvfG/
	 r7yXxQdWlIvMk+pgiO8txJjuFf9FV4aAN8S7FTBHKfdz5xQDpUmMpEZbdEMfu4MSLe
	 v17e88C4bRLQoO4zPMJIgh+xb2ZWBU6Dm1+7nGGN181gf9rkIfyoQa597Uo+eSphpn
	 jVEr3A3ANQwx7/tmM2xN9oJ7GTaz5jjThOBeYxsgbX5VgqqCjyW2dqFqrlXlTL4Q6J
	 zhoEm847xH63g==
Date: Tue, 14 Jul 2026 11:07:21 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org, 
	david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, shuah@kernel.org, balbirs@nvidia.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	hongfu.li@linux.dev, SJ Park <sj@kernel.org>
Subject: Re: [PATCH v2] selftests/mm: Fix memleak in migration benchmark
Message-ID: <alYJzrQOXY1AoV6j@lucifer>
References: <20260709081843.1451202-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709081843.1451202-1-lihongfu@kylinos.cn>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 107B0C0004
X-Stat-Signature: d5zef9soxpwa4oiwc7ycq7x54mzgyzow
X-Rspam-User: 
X-HE-Tag: 1784023655-553433
X-HE-Meta: U2FsdGVkX18rug2ulLfZshIZULmWCGw58NabAgnA3UPyp3Kgj6zWubu9s7lo59a5HZQigu8Yso54/IZZm67WepQvgBlKyCQRnDg4Gz2rMtEHwUKgW1+90h7c9v3h1p92HIgHaAz8detcr2zskCqVYtFsUfNiOihy5EnT9Z4kfbvniaA+Q4+514qnlIoNogLKMt7U09k1Uwj2Ws7PUy0F28ocTp2S1hTxGJrjFSuWF6QGK13iyCeqXqPibdi1izqEWZroVBJJlGlXGZE1OOZ4wPnwhgMMw/ChrrlWHtpnsoU8G6ZXxQqS+Ecm2uLOGL4/J38MhC7WKVymWgiGi+toqpfxi9sMIconYtdeDoSI7Q+dLqtpWdwwRTCTct+tfqPAIIYfhQEH7brbs9/o0wygDlnMHQxsYdsJCA0Svuy7mMjK2qP0q98BIKsBqT4QARW08lwNsOgnxvt36WPUfa640fkE9D2uw3B17DYH/zuA+tbLOjDKobotfmnfMz4/2G6LjBY+Ky2a4+a8CiMR8AFPs7HxKmZf2Si54HHIln8Te8M5ozjLwiK6PX3kZr97UJXjrUzPOIfupqX19NT9x9SX2/s2w5DbDpegwnviMt4KYJqK3YvF9AvCK0zKVpgBnYws8dwM152N/+XaoiDXdD6PAjCLwMIcSaCI1ChhwwddlTUaJRzaX5TumQTT+Pn6HLPpIFcxFxTMOfRxMft0rwmkWtLMJVjXU8+jJ/04tlh63CDxqtKDlC6mvA9dWdRgbFXq58GwJnhH0biH0ihFY5IvSsWK+SiRDkQv6rfGEiCoKefYKL2EIcwvfrzJhdfrxZ/6X0oYpTeMFE/8vavjrQUWIRoIhzmAAU6wyeGZrMQ700dBm5V8qHu/3k4GJmAYacvYptTbC9IIg0xFTuLYm8dgvwroBF0COKxvpnuS7pldwLazo8VbioHOHnrGiW7/Ma8jtgJl6Lx/TPMXnTNRthl
 h8VQwTSU
 s3mADajhyeU15dztPonBcepl4ajInNyWI8x0g5yxQ00a6snG5UhQQpQS7KzGR31XF10h5A7ZMvprA53Dhyg027oRuzbrG7UoO7YxWAbZFYjtFxTt4OJRA/kRAZXVn6ovb1++QfCH415UQHy8DMxLC9ADI8Nf5dPX2I0+JTtV5vMFJauKskmzoeqS+znKuY9a5U2ZNV9F+BJuBfKgf2hfTzQ2269kHqk7Y0lq7GUQPQEfHfqym8/pjEU95Hrtnad8cKrd0WadkrFV5hGGbZQFl6zCNL/171HzN6IB65HD39ChoZ4m+KQusnJKXfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 04:18:43PM +0800, Hongfu Li wrote:
> Several early return paths in run_migration_benchmark() skip
> hmm_buffer_free(), leaking the buffer. Replace with a single cleanup
> label.
>
> Fixes: 271a7b2e3c13 ("selftests/mm/hmm-tests: new throughput tests including THP")
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: SJ Park <sj@kernel.org>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> v2:
>  - Set buffer->ptr to NULL on mmap failure to avoid passing MAP_FAILED
>    to munmap() in hmm_buffer_free()
>  - Drop the redundant "/* Cleanup */" comment
>  - Add Fixes tag for the commit that introduced the leak
>  - Collect Reviewed-by tags from David Hildenbrand and SJ Park
> ---
>  tools/testing/selftests/mm/hmm-tests.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
> index e4c49699f3f7..402c6f6f5f09 100644
> --- a/tools/testing/selftests/mm/hmm-tests.c
> +++ b/tools/testing/selftests/mm/hmm-tests.c
> @@ -2828,8 +2828,11 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
>  	buffer->ptr = mmap(NULL, buffer_size, PROT_READ | PROT_WRITE,
>  			  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>
> -	if (buffer->ptr == MAP_FAILED)
> -		return -1;
> +	if (buffer->ptr == MAP_FAILED) {
> +		buffer->ptr = NULL;
> +		ret = -1;
> +		goto cleanup;
> +	}
>
>  	/* Apply THP hint if requested */
>  	if (use_thp)
> @@ -2838,7 +2841,7 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
>  		ret = madvise(buffer->ptr, buffer_size, MADV_NOHUGEPAGE);
>
>  	if (ret)
> -		return ret;
> +		goto cleanup;
>
>  	/* Initialize memory to make sure pages are allocated */
>  	ptr = (int *)buffer->ptr;
> @@ -2848,11 +2851,11 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
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
> @@ -2861,7 +2864,7 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
>
>  		ret = hmm_migrate_sys_to_dev(fd, buffer, npages);
>  		if (ret)
> -			return ret;
> +			goto cleanup;
>
>  		end = get_time_ms();
>  		s2d_total += (end - start);
> @@ -2871,7 +2874,7 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
>
>  		ret = hmm_migrate_dev_to_sys(fd, buffer, npages);
>  		if (ret)
> -			return ret;
> +			goto cleanup;
>
>  		end = get_time_ms();
>  		d2s_total += (end - start);
> @@ -2885,9 +2888,9 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
>  	results->throughput_d2s = (buffer_size / (1024.0 * 1024.0 * 1024.0)) /
>  				 (results->dev_to_sys_time / 1000.0);
>
> -	/* Cleanup */
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

