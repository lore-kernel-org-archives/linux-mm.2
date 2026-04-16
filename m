Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CFFEF433D4
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 01:02:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81E366B0005; Wed, 15 Apr 2026 21:02:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A7766B0088; Wed, 15 Apr 2026 21:02:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66ED66B008A; Wed, 15 Apr 2026 21:02:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 514146B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 21:02:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0C1A41B86C2
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:02:26 +0000 (UTC)
X-FDA: 84662618292.13.E11D26E
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf27.hostedemail.com (Postfix) with ESMTP id 17C3F40004
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:02:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=svbvtnVI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776301344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M/IxZ9Exo9xtMakzxD94fQQCxKkr37hohfsJWCyPGpU=;
	b=aO3b1/Aj/ztvzI2P2zroYlst2/4q9ib31JN0QprXkVMV1VARE1fWs9sAah7k/wIJeukV1D
	H/S1kElw4epGZreGNSjqdBSz2+XxrZVlwRKQLujcTK/91XuwPjtrai0unP1m6fu5JZXxe6
	sLi0A7iFwAmlPYQkmLyo2/par8/YquQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=svbvtnVI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776301344; a=rsa-sha256;
	cv=none;
	b=LkX6nvVEvr6ZpO76LFQCvffaTbFyC17FXplWmxdOGzgbCZbaytLXHCTTa66TkLgdjUowWr
	aGxTY9qEqlea7H7UoZjo8Iv44RLmJlAQraQYkXxAqg1SokNufaVlNNSsUPXXi4+av56KCJ
	w/Tb5cM+VDmJtUcROFG1mLwNu8km0QY=
Date: Wed, 15 Apr 2026 18:01:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776301341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M/IxZ9Exo9xtMakzxD94fQQCxKkr37hohfsJWCyPGpU=;
	b=svbvtnVIstOZ+4s1tT6Pc2S5sB5+MzNqsn2eqkXKDE6BKiuA3xhWll1qDnSC5yf7e2RZoW
	/NNXdhCYFXAewFWhBQSOZoL6gg/gLdjS1RBfAB101F6EMJfrWIbC1HML5F75nZBJM9yA+a
	J3B+viP3FcnEM1zeypuq0tjd4wD5+iM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Matt Fleming <matt@readmodwrite.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Minchan Kim <minchan@kernel.org>, kernel-team@cloudflare.com, 
	Matt Fleming <mfleming@cloudflare.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Require LRU reclaim progress before retrying direct
 reclaim
Message-ID: <aeAtOUIhFv5hXOyb@linux.dev>
References: <20260410101550.2930139-1-matt@readmodwrite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410101550.2930139-1-matt@readmodwrite.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 17C3F40004
X-Stat-Signature: kfmuqhwgryiupmw55ao3oz1psc1bf5sy
X-HE-Tag: 1776301343-108418
X-HE-Meta: U2FsdGVkX1+ZokBR9tajb3NBPgbVgwXJxqIOMyzywFER/lPiqFILUiBDunmplcwFFgVYJ7I2z8Q3RmNNnu0oE8Ya9ME6aCoBfvpQvWSIKqF9GiCD90KiCWUFT/z2t6IQ6c8IB+A/RHv1ZYwuaoMNF1IlHnOvnVk8L12L53HeL0jEbmd2R6ywdcb7aA/vgh2aLHJQP1QTgncz40twID/eNSuCUObCaGP+7B2GKWi0c1a6o5xNHs0bZsWL2KC8y/7QOQ68N+p59l4sqgoBPivzd2zLsThI9gVsV1lfu3lEzSQiy0SmA71yVkrXppP9kidP7PQsMRoPL816akmR8dThsYGd7izx3SlULjwQcdUmtsLuSfcNMe/lRVdTq0mskpQ+kxXjYEC7dF/bEJm4SJ2eMwHCcXt9y63z5+5xjZ60P+Me4nlf+ez9OtCgj14RcZ6HZzZD1bDE3GafEEnDDXOsZ6zTj+fmiqVlmKyWZzMDuLqs1v3THb5iX/0rjrkJn0L3hTxgVEYzgBlFbfOJkSk9I1xzs07GZeRpZfx9meWNqOxgsRWjJvDQqmUs0H7UXQxMoOadkd0BNLR3j4IvhcpQDsR46L6dDb1rHG5DkvEpq3sW1awXL3AgDGVoVZ5Ks117howbziXz+0U++u5EcqMClU4TgxxdpKCCT1WD0zyWxYb9a9QUztSrhvC+h8V0xAMefblraY10iVvho83xTbRLeBe+Dqo/0z2/pb38TgubVsk3h89FVM1k6qH26dC2ZW0D/xleVrZGDYCbYXWkQX0gQ+wGsSHiLo5oGg7zWeIogs+jAcWc6rManlLvFTNFF1Xvu0yDUh6lvXDDX2GT9sMXIGV7+jTW1l87sXY+wm/uyeWvQbjNGeqXuuQ0139ArL2TaDcSaaub6fsH4ldvl0SeEQ024zz6M9V//yyJZhYZGG3LLRwSZm3BZ8c16GOdAOGrXmDG8DkCwHA4ZFuJuHh
 CjlTcGT0
 fpcooV+9P1V9NlATVqjNQZyxkWK1rbcnXO7Wbv3srW15mrndqfmTndblzvQ8Kk/+HVwJzXmZ9ra4T12lvBZCymCgVHYAIBKUPzR/+HhrNJEG4WcyRecrdlJlLyBYR2ND8P+/9Q5eeEAjNgSXMz42lzmkT/Pu0VBFQcTqDbGQcSgh8TJ0w76ky/61gBi0tzXjiuFJdg5AQuD7lFVyxQpNc8PG3bC9jFUf4YgYpdbzEUdJjDAokRXCNK8bYtE75SUZoLrgmOMxWx75UgKt/djVRHXcuFj+jFlzRs/ZowKSGsqQPz+g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 11:15:49AM +0100, Matt Fleming wrote:
> From: Matt Fleming <mfleming@cloudflare.com>
> 
> should_reclaim_retry() uses zone_reclaimable_pages() to estimate whether
> retrying reclaim could eventually satisfy an allocation. It's possible
> for reclaim to make minimal or no progress on an LRU type despite having
> ample reclaimable pages, e.g. anonymous pages when the only swap is
> RAM-backed (zram). 

Or incompressible memory on zswap with writeback disabled or overcommitted
memory.min.

> This can cause the reclaim path to loop indefinitely.
> 
> Track LRU reclaim progress (anon vs file) through a new struct
> reclaim_progress passed out of try_to_free_pages(), and only count a
> type's reclaimable pages if at least reclaim_progress_pct% was actually
> reclaimed in the last cycle.
> 
> The threshold is exposed as /proc/sys/vm/reclaim_progress_pct (default
> 1, range 0-100). 

Let's not expose any sysctl or user visible API for this heuristic. It will
evolve and then this interface would be awkward and hard to remove.

> Setting 0 disables the gate and restores the previous
> behaviour. Environments with only RAM-backed swap (zram) and small
> memory may need a higher value to prevent futile anon LRU churn from
> keeping the allocator spinning.
> 
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
> ---

[...]

>  
> @@ -4637,7 +4672,24 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
>  			!__cpuset_zone_allowed(zone, gfp_mask))
>  				continue;
>  
> -		available = reclaimable = zone_reclaimable_pages(zone);
> +		/*
> +		 * Only count reclaimable pages from an LRU type if reclaim
> +		 * actually made headway on that type in the last cycle.
> +		 * This prevents the allocator from looping endlessly on
> +		 * account of a large pool of pages that reclaim cannot make
> +		 * progress on, e.g. anonymous pages when the only swap is
> +		 * RAM-backed (zram).
> +		 */
> +		reclaimable = 0;
> +		reclaimable_file = zone_reclaimable_file_pages(zone);
> +		reclaimable_anon = zone_reclaimable_anon_pages(zone);

Here we are getting the current reclaimable pages.

> +
> +		if (reclaim_progress_sufficient(progress->nr_file, reclaimable_file))
> +			reclaimable += reclaimable_file;
> +		if (reclaim_progress_sufficient(progress->nr_anon, reclaimable_anon))
> +			reclaimable += reclaimable_anon;

And here we are comparing the current reclaimable pages with last iteration. Is
this intentional to keep things simple?

> +
> +		available = reclaimable;
>  		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
>  

Another heuristic we can play with is to also pass through the vmscan scan
count. If for couple of consecutive iterations, we continue to see low reclaim
efficiency, go for OOM. Also maybe compare the scan count with the watermark as
I expect we don't see much difference scan count for consecutive reclaim
iteration, so, it is a good representative of reclaimable memory.

The reclaim efficiency heuristic should handle the swap-on-zram or
incomp-zswap-with-no-writeback. Treating scan count as proxy for reclaimable
memory should handle the overcommitted memory.min case.


