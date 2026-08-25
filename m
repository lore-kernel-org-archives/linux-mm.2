Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEB75C5DF9C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 01:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 846736B008C; Mon, 24 Aug 2026 21:48:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7696B0092; Mon, 24 Aug 2026 21:48:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70D8A6B0095; Mon, 24 Aug 2026 21:48:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4447F6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:48:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD387C02D1
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:48:26 +0000 (UTC)
X-FDA: 85138107012.02.98EBF08
Received: from mta1.migadu.com (out-9.mta1.migadu.com [95.215.58.9])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7182840009
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:48:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jOEuyHVq;
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.9 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787622504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tM95BHdRdet6LO8J9BWeZQNX6Tg8sEng0X6lWtyfTJ0=;
	b=WPuK2IXDmNyJj1vRjcQJgWtmOTH7PYhWBd6jATYv8UnMXHmx0ku/sCDGPWKtUeSbMGPcHB
	UFepqiPbDc250u+f/OrPSE7afSbkPDpkHzGV8WT/hV3jZKNhN5bqyMMpTtySuFLKaSHM7F
	0x53TL17fEJ+ZSP5SSoXEzPXFal1FjU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787622504;
	b=WDpukAFOUs7K5pBT56qezrj4VqQS6TAQo1h/bgwdz1Yh529dOt25MRPz6UcGKE2RoYb1me
	5yuccwAvIyu9ORdUJ3cKhXmUofjTd0VV5OODG58o7TNzBR47tMsyQlrxg1t5YGeS86mu0p
	qSI4W0QKxsclIL6x1rJ8fe3jaz8kaHc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jOEuyHVq;
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.9 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=prN5H8SaiZTV7pApteisCiLH+mKhQksL1qSnd7wzZjo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787622503; v=1; x=1788227303;
 b=jOEuyHVq7k3pykS/uKauSLbdnVgQU/BENKUapkq/zZmLrauZ4h5PmGfeuZxG/CuLLZ08YQIh
 AL1QZlCoGmht/9oR8nyisW6IwsXKFJvuDzW+kCYHZc/FUro2Cg5IaqJ+0TCKu0FSKtGoi15IdSq
 862PkzHbDVw97hdEQq8qS4As=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta10.migadu.com with ESMTPS id a2e5a6a88a84bda4;
	Tue, 25 Aug 2026 01:48:13 +0000
X-Mizu-Trace-ID: a2e5a6a88a84bda4
X-Migadu-Flow: FLOW_OUT
Date: Tue, 25 Aug 2026 09:48:07 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>,
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v2 1/6] mm/memcontrol: make lru_zone_size atomic and
 simplify sanity check
Message-ID: <aoz0Q-PARiEKF8_H@fedora>
References: <20260824-mglru-flags-cleanup-v2-0-0104132114ae@tencent.com>
 <20260824-mglru-flags-cleanup-v2-1-0104132114ae@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824-mglru-flags-cleanup-v2-1-0104132114ae@tencent.com>
X-Rspam-User: 
X-Stat-Signature: az3w1dmybefpc68usf9dx4fquizw33tc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7182840009
X-HE-Tag: 1787622504-237122
X-HE-Meta: U2FsdGVkX19BuhanfiitXLr2a+lvz098B6aKytQkVbzS7iTYcO52i8DP5YsNHxj7NbOgqT+Fz5qIgrPXnu+sCh6PcXxTFfQyAJWbNzVWGUb/8pQlYC5ttbSMskdYqixFv2A2oJ7Hs3o/VvcxWo0rGCwPGaOJBhOzkpNg9akZV0G6H9BCBfQ8Tqzx8K1wxxhbBdDrOPlnBrkN4KcmKb1EfXKpfpQb1A1W0GuC6yhpWVdO/wkamJch+Gkk5vPipiGN9+YlRRTzHk4QlmUnbuzfQAFIaWF5Jkt0VSWViFLGaViHYf0hDNE/l8s6R1hAvgmVgy6BMMXDAXHMyUnYcEfaU39A5jEAVfvkmoNhVLWEEl/bqZQH0KIpRpdKLTL7Rhi1lGEGPsd26tjSDGd6T+o1dVk/PSxojwNC99GjZ05F+IsLjz5GJO7pu+Zoy7Ezpj5uN2a5l6aGonfVus/T5Htdlxe45Im70bKKa9EMUgz8nMTFNrUw2FnGRhiyD+1ulzBVsYhUkO2gX6jDkP5Hf1cCRhbqaxWRDWGMkAE378B/GZBC0CYcI2bsJDM5fa+vxCmWLb7QVXxtM86R0PUSqGtC+mTVPRQFvvQZ4ifWWoVv4qxS1BOA6HgeGynKxd4jxzK9h7I/0XyyJKrMafhi+1IlcWIUZJVg/8665xP/Qu1298bSkuRKfv5C2P5DE1075zonqaau544KJBP2RlIu+Bxos29F9pUBauN30p/jhvHLruGq+ME9wlLfWRh73sv2/EUy5ySgmyxI6iE+Axuoct71HryFd5b5Opj9Wr/qO+Z8/Xh3/CerCOLhz/AGitgu5/45lxuxE/pQU7shNBsP9lY1ajwJxb+ECHLE+Z0pwTjbjIX6wUDU0ruC7bYdnbIAtC0lRAtoqdX3WqD2rbhgShwGQTVEHTAGY+/uiwEfTeqlEL9A/x5S4ApJX4rCw3+XBSokrRplyoZA3cJ5Lsyiqgd
 0k+4HE+Z
 6035CjpugEheUi01ia6Pw42Y4AdGLWYSE13qSWk+FhfH97qsrtkMlEwJklyAIKwwMLUN8ZPKAcMBYqUUSHMn69FMXtTcFYHLTR1xVHwoPjIIS2h4htujK+epjXtaxBbiWMwN9M1eSQ3+49vvjGQmseo6ECs0pv4W+in5AIALDwDGuD7q0ph5dnDymKZIyivJwWqf2GBA7IOZ7Hu9jaW1aRrbZX+9CoSCRZZOcS9t7eyi/MK6sZy87icu+L5JmnzVGiGjHEVJ4nf7zvv5tJKq7/JiPK7FQMXAh9m07VCAc3J4LLfNr3Q5VWzxEfQND6jhriYpDHP1nP6fBcK9mENI+gfO4Edq76hAR/KiLTCZepMzXB41LCE6a6AdSVYw2/YDR0w6v/9SiTqUZ9XtVcB0WaDmgxOx1a/2vJ09rZqgReNZDq92pXj4VdVcRE3mvCjHmf3YNDlIF7bf4ccdms7xoeljFBwEa0Q+mQFKM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/24/26 at 11:26pm, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size")
> introduced a sanity check to catch memcg counter underflow, which was
> more of a workaround for another bug: lru_zone_size is unsigned, so
> underflow wraps it around and returns an enormously large number, then
> the memcg shrinker loops almost forever as the calculated number of
> folios to shrink is huge. That commit also checked if a zero value
> matches the empty LRU list, so we have to hold the LRU lock, and
> handle the positive and negative deltas separately.
> 
> But later commit b4536f0c829c ("mm, memcg: fix the active list aging
> for lowmem requests when memcg is enabled") already removed the LRU
> emptiness check, so handling the deltas separately is no longer
> needed. And if we just turn it into an atomic long, underflow isn't a
> big issue either, and can be checked at the reader side, which is
> called much less frequently than the updater.
> 
> So let's turn the counter into an atomic long and check at the reader
> side instead, which has a smaller overhead. The underflow correction
> is removed: a massive leak of the LRU size counter would indicate
> that something else has gone very wrong, and one should fix that
> leaking site instead. Besides, the updater-side sanity check is
> unlikely to catch the leaking site anyway: if a folio was removed
> without updating the counter while other folios remain on the LRU,
> the WARN only triggers much later, from a likely innocent callsite.
> 
> Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/memcontrol.h |  9 +++++++--
>  mm/memcontrol.c            | 18 +-----------------
>  2 files changed, 8 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 215e2e87f42b..7b89d0cb5f6c 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -113,7 +113,7 @@ struct mem_cgroup_per_node {
>  	/* Fields which get updated often at the end. */
>  	struct lruvec		lruvec;
>  	CACHELINE_PADDING(_pad2_);
> -	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
> +	atomic_long_t		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
>  	struct mem_cgroup_reclaim_iter	iter;
>  
>  	/*
> @@ -902,10 +902,15 @@ static inline
>  unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
>  		enum lru_list lru, int zone_idx)
>  {
> +	long val;
>  	struct mem_cgroup_per_node *mz;
>  
>  	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> -	return READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
> +	val = atomic_long_read(&mz->lru_zone_size[zone_idx][lru]);
> +	if (WARN_ON_ONCE(val < 0))
> +		return 0;
> +
> +	return val;
>  }
>  
>  void __mem_cgroup_handle_over_high(gfp_t gfp_mask);
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 11b85f4b6828..a7572ded56c9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1529,28 +1529,12 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
>  				int zid, long nr_pages)
>  {
>  	struct mem_cgroup_per_node *mz;
> -	unsigned long *lru_size;
> -	long size;
>  
>  	if (mem_cgroup_disabled())
>  		return;
>  
>  	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> -	lru_size = &mz->lru_zone_size[zid][lru];
> -
> -	if (nr_pages < 0)
> -		*lru_size += nr_pages;
> -
> -	size = *lru_size;
> -	if (WARN_ONCE(size < 0,
> -		"%s(%p, %d, %ld): lru_size %ld\n",
> -		__func__, lruvec, lru, nr_pages, size)) {
> -		VM_BUG_ON(1);
> -		*lru_size = 0;

If it happened, the resetting to 0 is removed, will it cause anything
unexpected and different behaviour? mem_cgroup_get_zone_lru_size() just
read minus value and always WARN_ON_ONCE() if no new adding to this
counter.

> -	}
> -
> -	if (nr_pages > 0)
> -		*lru_size += nr_pages;
> +	atomic_long_add(nr_pages, &mz->lru_zone_size[zid][lru]);
>  }
>  
>  /**
> 
> -- 
> 2.55.0
> 
> 

