Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52CF71098797
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 15:05:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67CCB6B00D3; Fri, 20 Mar 2026 11:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 606E36B00D4; Fri, 20 Mar 2026 11:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F5656B00D5; Fri, 20 Mar 2026 11:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 39DA76B00D3
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:05:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4C321B7115
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:05:41 +0000 (UTC)
X-FDA: 84566765682.19.6974CE5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3947C140010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:05:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jNZCnAqj;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774019140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCuXufbrmQdKpLLe5J7RyocoMqhBYcUtLOH+h/klFSI=;
	b=q8i7N+Wnr1g1W+9BZJeXhZe2j5LInn7x+3pwNNLSiMHTCW2Lejnm5BzAidtVukP5HT+7JU
	exCyK2SJ8KDBVD91wTIJtWbM04gzLFkMgrYdMzDRuT/B5IsMS1RF09rl+7UUxPP7TZjtHy
	T5RFF0VVzg91/AwA7953dLQVT4FrjN4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774019140; a=rsa-sha256;
	cv=none;
	b=B+5gXvhhGsRdZr6M4fvDVpuH9h3IUmq5tWfXHPCEAnbUp/xXS13s1LtH2SwWZCWRVFX+17
	QdoBmZ6OT7PCeJ/fU1tHoKRR1qKI3dv9WUymAqFRpMMjkuF6SBIsjQXdf/8gCg/UxG24I5
	m8OszNZAlEa0IJdERDdyII1IDjLT9ac=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jNZCnAqj;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A99616012A;
	Fri, 20 Mar 2026 15:05:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FECC4CEF7;
	Fri, 20 Mar 2026 15:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774019139;
	bh=0JzefbnFDDUAaPXmhGXPuuosVEsGt8ZsfIx+ICZ5XIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jNZCnAqjl1CLFi85I0hi+AXYLvnD+QnKeBuACo1Qy2c5EcFGBofio5O8jrMcYMj21
	 vYuJj4LOI5dWYK9UUPN7gY76gTAu3Ko4OCvk5uJ5X/7/1pKueJEDZI5cnTUKNYUjyc
	 DH2pSAOWbr004DEN+2seNW3xHkhv4P74DPN6B/Aog9S1ECpic85DD1/xmhYz7pILEZ
	 Ht8ANtsURPfdh6ge2D1yK45F/n6G84PSYXd4R2K9LSs779y5TRBoDU/ZghRMV/rDxr
	 zyD/Z2KurpgLVL4gZV43bbEzOU/eHxej+bFLMKONXo1pfYYWevns7ITnX7N/buvBMz
	 8Rb/aHQuLVkzA==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon/ops-common: optimize damon_hot_score()  using fls()
Date: Fri, 20 Mar 2026 08:05:36 -0700
Message-ID: <20260320150536.98893-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260320072431.248235-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3947C140010
X-Stat-Signature: hwnmz9g8snrdfghesdeesrw8kj1s8zyd
X-Rspam-User: 
X-HE-Tag: 1774019140-601004
X-HE-Meta: U2FsdGVkX1/4W7saix5CbMvfppflYI7p9ALv6hInhPJhUr0PAv09lEDyCF7Dy0oo/mko0g2In5kGfRf4S5g06aQyXs0nUlmqsqYlmb+/zPttVXKYhvLDhySt+Iu7ReBp2YxBX4UpqvTtIGVGPHUtDgyM8QHuPs6HOGAt5MVztjsIrYNy7iOSIQmaQ3rBEZ5zzHgESmxz2ilDaNiox50V+u2NCt1PPshZl/0paKS/g6k+LV90iRC9XeoHLJ9ZkfWOWUZ/nrkvZPbvFpEg3ZLIL0GC5hwAn2PMJ0xPATd3OvLiRpcRcrnnM1HaFKJ4N8tgeXTCV48TuYQcr5D4wOkYWVq+qnm93KPfZOudD8YBUqDkXna4owncA4xvA+DLpAgkdmTmOScV6RxhIds4T02JuyHA0U/fSS0QM7WdSbqcWt4YKJerAfW++nCULsQ+f1JFXvrRqyBgmoxfxN6Q7gHmPcPtjSGZX+DrUaDOxXUxCqAWeHEcHOD8PsX2nwU3ogeGF/2kVuK/N6jO3UioX+Xtq6Xwfm6cnNeKr1wn3ZDq4OvKlfw/iGKoa+R3JaKBTBgsa2Kc+1Y6bUpdqg0UgVKSgzLFH2dUANSRGutVEQf01F/1QBAV/ZGezRSTC/RG0fnJKmY8rvQEqecBHn/24J3UBlrW6e272DlGoHXFZinVGupqwmHnqUIRpg+TzoF4WjDbbBGUlR83VMtkLcOh+vVag5WOv8onraaBVXWzQxbZICbBG2FXU77YFAgnshyclZeoGt0ekYCujrJf7lqQtA7ZyR9t4+IkiFHOgwr/SsFwIVRfY0UQvf9sOBZTcDfCWJqh2bEBF6DWNLw1bqKPKAie1oi54Ck9tj6mTtQEOtjVOf/9RrFNWaO4Qwq8RUMLN/nBia5dewZm+7G3d/8x6e4davdPYW6JquLHs8DWzmCcJTqofgbP4MAuNB6iU4M4AlX6tSYU2g5oqfwGHgNdsVR
 T8F9l8/f
 1LY8ltq4CUIiAe75yHEbLfBi9fg0PjS5KoGiHqK9rFWC/XvRbDh8k9y/3Ziqat+PRqV2mjYtVbuHX9iIebBoeJaPQ+mgosWG18TVzOfaoLlxhIeBT5tJrdZP9I0b8/zlINRcWjD3S+kXKtv3njkqTFHROf9aueqA7scbY8RNRwohbYb3xpk3Wy2XMUO0c1AGuXQOQjRO3ONuX4ASuLZX+VABlHLnqSP5nLzIg39YxyB6fHLNs5tdP22KtMFA5xcmMBG1MTGQmTU0XopxyXRQ1Wor2xWE2BMeR5nCBBaGBKkFec93IrfZuyuSRUTBbBjxDmrWoBNo4S3ufnknKB9dgRZUMqzpWEyWLUJqMSbU9/yn65og=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Liew,

On Fri, 20 Mar 2026 15:24:31 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> The current implementation of damon_hot_score() uses a manual for-loop
> to calculate the value of 'age_in_log'. This can be efficiently replaced
> by the fls().

This makes sense.  But, it seems ilog2() looks more same to what the current
code is trying to do.  How about using ilog2() instead of fls()?

> 
> In a simulated performance test with 10,000,000 iterations, this
> optimization showed a significant reduction in latency:
> - Average Latency: Reduced from ~9ns to ~1ns.
> - P99 Latency: Reduced from ~60ns to ~41ns.
> - Throughput: The loop-based version mostly fell into the 40-50ns range,
>   while the fls-based version shifted significantly towards the 20-39ns
>   range in the test environment.
> 
> Although these results are based on a simulated kernel module test
> environment [1], they indicate a clear instruction-level optimization.
> 
> [1] https://github.com/aethernet65535/damon-hot-score-fls-optimize/blob/master/test-kernel-module/fls.c

Makes sense!

> 
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> ---
> Note on testing methodology:
> I attempted to measure the performance directly within the kernel using
> bpftrace, perf, and ktime inside damon_hot_score(). However, the results
> were highly unstable (ktime), and in some cases (perf/bpftrace) the
> function was difficult to trace reliably (likely due to my own tracing
> limitations).
> 
> Despite the instability of in-kernel ktime measurements, one thing
> remained consistent: the fls-based version significantly improves the
> "long tail" latency compared to the for-loop.
> 
> Test results from the simulated module:
> - fls-based:
>     DAMON Perf Test: Starting 10000000 iterations
>     =============================================
>      Total Iterations : 10000000
>      Average Latency  : 1 ns
>      P95 Latency      : 40 ns
>      P99 Latency      : 41 ns
>     ---------------------------------------------
>      Range (ns)      | Count    | Percent
>     ---------------------------------------------
>      20-39           | 3522000  |   35%
>      40-59           | 6478000  |   64%
>      60-79           | 0        |    0%
>     =============================================
> 
> - for-loop:
>     DAMON Perf Test: Starting 10000000 iterations
>     =============================================
>      Total Iterations : 10000000
>      Average Latency  : 9 ns
>      P95 Latency      : 51 ns
>      P99 Latency      : 60 ns
>     ---------------------------------------------
>      Range (ns)      | Count    | Percent
>     ---------------------------------------------
>      20-39           | 0        |    0%
>      40-59           | 9894000  |   98%
>      60-79           | 98000    |    0%
>     =============================================
> 
> Full raw benchmark results can be found at [2].
> 
> If anyone could suggest a more robust way to profile this specific
> function within live DAMON context, I would greatly appreciate the
> guidance.
> 
> [2] https://github.com/aethernet65535/damon-hot-score-fls-optimize/tree/master/result-raw

Nice test results!  I think this deserves to be in the git history.  Could you
please add this on the commit message area, rather than this commentary area in
the next version?

> 
>  mm/damon/ops-common.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> index 8c6d613425c1..0294de61a23a 100644
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -117,9 +117,7 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
>  		damon_max_nr_accesses(&c->attrs);
>  
>  	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
> -	for (age_in_log = 0; age_in_log < DAMON_MAX_AGE_IN_LOG && age_in_sec;
> -			age_in_log++, age_in_sec >>= 1)
> -		;
> +	age_in_log = min_t(int, fls(age_in_sec), DAMON_MAX_AGE_IN_LOG);
>  
>  	/* If frequency is 0, higher age means it's colder */
>  	if (freq_subscore == 0)
> -- 
> 2.53.0


Thanks,
SJ

