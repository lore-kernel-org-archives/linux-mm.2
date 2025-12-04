Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CC76D2A551
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 22:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C16A66B0092; Thu,  4 Dec 2025 17:30:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB00D6B00BB; Thu,  4 Dec 2025 17:30:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9E2B6B00BC; Thu,  4 Dec 2025 17:30:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 943836B0092
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 17:30:03 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38C7A1403A5
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 22:30:03 +0000 (UTC)
X-FDA: 84183232686.24.D8DCA94
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id F21B74000B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 22:30:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vrXk+BB4;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764887401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ZYSwOESe8KGknL6RO9823p3TDyuaFDKtZ3tBskISlA=;
	b=gYVyxX5TgOm/xMrGS7HhKswooROZCvUUbahy07bW6JJjLsdolddd4o8q7wDgQeaEQczz9G
	7DpNQsJkxUWR939103WLUDxm4G7mR5UPn19tyFNZ5PoPNUxKjZuUqHvkrNisxhgug/9oxW
	idb5jt7tPlD6krVtsCjIqJ5h2YwDO08=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764887401; a=rsa-sha256;
	cv=none;
	b=E81SkXhXMpmAjsyuJV7jkCUAC+UQq4f84T0B+V4PsZsta6G7cYLUglrfCQTSGMx8cudIYL
	ohPum1PhCG82nzcuIun4pd7ZhmYkoqf3LDNuKGIfCYSzec+/tFhxuT0wFuNIuzXdBFTe+H
	gFsA95Ek25XyAwrQo+rVANJdHTMTCSU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vrXk+BB4;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 4 Dec 2025 14:29:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764887398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+ZYSwOESe8KGknL6RO9823p3TDyuaFDKtZ3tBskISlA=;
	b=vrXk+BB4vd8tsHzc/9rBCiqMkFvgVmd1PUjLJaTjRYJ/zNYdPX7+JdPxEE26gICqmMSoD+
	7kOtjrOFjQ3Uzetugdn5Do3Kf9UiQzv2iC1fGbIlOL8alf33vMmTaC5PWjLlisa9iRM6sl
	2TmB/4+U9eQ56pgpC01DRWlxc2XG1cw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, hannes@cmpxchg.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, yuzhao@google.com, zhengqi.arch@bytedance.com, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, lujialin4@huawei.com, chenridong@huawei.com
Subject: Re: [RFC PATCH -next 1/2] mm/mglru: use mem_cgroup_iter for global
 reclaim
Message-ID: <tvrspnhlo7x7gpjc4nn7f73b2qoyphkpaxlcnnn4fsxciv6bks@3dibvbs7u5do>
References: <20251204123124.1822965-1-chenridong@huaweicloud.com>
 <20251204123124.1822965-2-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204123124.1822965-2-chenridong@huaweicloud.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F21B74000B
X-Stat-Signature: hef4axmuefktidt5p3a7jwfogtz7bepo
X-Rspam-User: 
X-HE-Tag: 1764887400-594150
X-HE-Meta: U2FsdGVkX1+GpNycGVjGcQAr2+I36PPiJ26joLetQpMKbwOOnD93P/D4P20VnWshM5u5vWNHlqRksE15ulLYsp9FiiFMvzUXuwTE9SpTCSRNZGUZRlpVOY0Ofa5rAAwtXT5VvYUXppldLfR8PdCFV5Da60Umc/I8dP1HxWFGX+9O0iqS3ZDiyhq6c3BaH6jX8XdZGfNrYetC4kMYfI1zToHg6VR/SJo2cXyH2CHf6INf4b9FZmbCObnpvWgrPyg1usdU2ezuV9yVPBG/4iz/HB3WX2C6FxcIqXxkU+2oSHayL2dpw7mE3Jt/Vh8iLyLYislJWgN70CyRmZ3EH+WPkivgiVetFHyLmmUX2j4Q3jlLDrRwPb0s8iqwbAwwuwe0QLDzGdT6GEPy89eoj/PEUV8X+9pxwdxFziV6AkBWje65GMpeEe8rSSqMWd/Gl4KYCUNqgqbuFk0ARDgdxD+ftLOD8MCB+v8eDUGqeStbLlzbvKx8fK55u5lIZt1PB0qObwuFGYpiMJKy4kkLYla4bLgrmF2W+vVC4G+ZcAN7LVhAJs0Db6Hxe/l24HfLSQ26FleYdaN4Hl/EQJyR2mm0r5ivLPnFTElRNwOBczlj0yA3gUo/4c53j02PyuD10oYGYv3KtAOYsuyVCTGs8CPPxRTPEgwVS+0pB5zXBqd0fjUL2hE3eqw+FXNeVlY/jRXVUg1JThcvlwSCkQPGT1t9StW0HYvwDiYC8FjnCi75IIA3kZ/I1C2h2tD1uHROi11FUoCVj9RvTKRwYQ16KZcOS1oQ9nT38ogDBhEBzhRtqlZsfvmTk7rPYAbo6qWgqDQCPWCiuV3ECr0Q5GZf+5krdq8mNm0CBdc/InLYgyQVUYfhDcfMqp6rPl/3uAKL5HVkGkF2oQUev22XjVs4qcWiChx9xsewTyOSqznrQp4V+0eCy3Ar7qeQAevH7/kj0DDSm708Tdw56LeRvQXuC9b
 c2wzjFPs
 SR0xJUNejvfetyX1j4C1FqVdTKzVz/mjzeufR7DQQtKCiSHXI29VJpbCK3794Cx6+vYk2YRvJG/UbkDfBTL3TFBH9DracNT2vl7EpRKDsLMc1YqWecVu1eSKMRDHPRVixvetG9vRo26RBdHFWx9+C9q/IvYeCc3QVRJ/ZDRedBrboeg0JXTUxgXR9Cc2jMkP5payNBdvduaNZ78U1pTwRFronQp2GANCqIIkiIJNRnszzqFAxC6cMfvCIT6Lf2O88vIDTX2SnQGrUt5qbEaKqlP8sveXcwNJfDFbeWbXDjmTKkNgbkNWaSRkNITam3Ibz8LfRBauK3FfuJt2IIWSUpK1sSpQLQRf6DxwRpF8d3zfLiBY9C5ImOyfJk0x6jjn1kfzp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Chen,

On Thu, Dec 04, 2025 at 12:31:23PM +0000, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> The memcg LRU was originally introduced for global reclaim to enhance
> scalability. However, its implementation complexity has led to performance
> regressions when dealing with a large number of memory cgroups [1].
> 
> As suggested by Johannes [1], this patch adopts mem_cgroup_iter with
> cookie-based iteration for global reclaim, aligning with the approach
> already used in shrink_node_memcgs. This simplification removes the
> dedicated memcg LRU tracking while maintaining the core functionality.
> 
> It performed a stress test based on Zhao Yu's methodology [2] on a
> 1 TB, 4-node NUMA system. The results are summarized below:
> 
> 					memcg LRU    memcg iter
> stddev(pgsteal) / mean(pgsteal)            91.2%         75.7%
> sum(pgsteal) / sum(requested)             216.4%        230.5%
> 
> The new implementation demonstrates a significant improvement in
> fairness, reducing the standard deviation relative to the mean by
> 15.5 percentage points. While the reclaim accuracy shows a slight
> increase in overscan (from 85086871 to 90633890, 6.5%).
> 
> The primary benefits of this change are:
> 1. Simplified codebase by removing custom memcg LRU infrastructure
> 2. Improved fairness in memory reclaim across multiple cgroups
> 3. Better performance when creating many memory cgroups
> 
> [1] https://lore.kernel.org/r/20251126171513.GC135004@cmpxchg.org
> [2] https://lore.kernel.org/r/20221222041905.2431096-7-yuzhao@google.com
> Signed-off-by: Chen Ridong <chenridong@huawei.com>

Thanks a lot of this awesome work.

> ---
>  mm/vmscan.c | 117 ++++++++++++++++------------------------------------
>  1 file changed, 36 insertions(+), 81 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index fddd168a9737..70b0e7e5393c 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4895,27 +4895,14 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  	return nr_to_scan < 0;
>  }
>  
> -static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
> +static void shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>  {
> -	bool success;
>  	unsigned long scanned = sc->nr_scanned;
>  	unsigned long reclaimed = sc->nr_reclaimed;
> -	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>  	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> +	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>  
> -	/* lru_gen_age_node() called mem_cgroup_calculate_protection() */
> -	if (mem_cgroup_below_min(NULL, memcg))
> -		return MEMCG_LRU_YOUNG;
> -
> -	if (mem_cgroup_below_low(NULL, memcg)) {
> -		/* see the comment on MEMCG_NR_GENS */
> -		if (READ_ONCE(lruvec->lrugen.seg) != MEMCG_LRU_TAIL)
> -			return MEMCG_LRU_TAIL;
> -
> -		memcg_memory_event(memcg, MEMCG_LOW);
> -	}
> -
> -	success = try_to_shrink_lruvec(lruvec, sc);
> +	try_to_shrink_lruvec(lruvec, sc);
>  
>  	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
>  
> @@ -4924,86 +4911,55 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>  			   sc->nr_reclaimed - reclaimed);
>  
>  	flush_reclaim_state(sc);

Unrealted to your patch but why this flush_reclaim_state() is at
different place from the non-MGLRU code path?

> -
> -	if (success && mem_cgroup_online(memcg))
> -		return MEMCG_LRU_YOUNG;
> -
> -	if (!success && lruvec_is_sizable(lruvec, sc))
> -		return 0;
> -
> -	/* one retry if offlined or too small */
> -	return READ_ONCE(lruvec->lrugen.seg) != MEMCG_LRU_TAIL ?
> -	       MEMCG_LRU_TAIL : MEMCG_LRU_YOUNG;
>  }
>  
>  static void shrink_many(struct pglist_data *pgdat, struct scan_control *sc)

This function kind of become very similar to shrink_node_memcgs()
function other than shrink_one vs shrink_lruvec. Can you try to combine
them and see if it looks not-ugly? Otherwise the code looks good to me.


