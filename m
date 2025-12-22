Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5120D68BD5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 03:12:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F2AD6B0088; Sun, 21 Dec 2025 22:12:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A0B16B0089; Sun, 21 Dec 2025 22:12:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE1E26B008A; Sun, 21 Dec 2025 22:12:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DBFAB6B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 22:12:18 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A9C791409CA
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:12:18 +0000 (UTC)
X-FDA: 84245633556.07.492D2BC
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id D7BD7140012
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:12:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LLXTjyXj;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766373137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lhDz9De+0KQKYXwyi7fXsZXUS+UyFkHbIg9lL8okLng=;
	b=IsrhcDUEEpmLH8Rg2p8csUvQcSbieNuBerJJ2ez0DclAvkSa+zxzckqxztF5QHocepFutJ
	8GiRSX+xxjpsz+M+KmQfuJlyiZJy3qlzNiaM5EG4oYSvXsOBPAutxwYGDitgvDJxygUm1K
	m7xjLliSBz5G2dyN/a+TwHaBZ/P+4iM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LLXTjyXj;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766373137; a=rsa-sha256;
	cv=none;
	b=XWsPW98dDGSxkajurxwVriUlkU2HIlHHVC15B6UYSgkbJ8mtdtJmpP9y9fvf67UL5rHeWN
	AmcfY2gmv/RvpgH/VOj4S4cK/jTCxGyjfZS71OqtX5lSubEbyC/AX4xSajNUabwLwYswst
	myfiTa9Jgg7vaHzeSjgTpqXG0UQPzV4=
Date: Sun, 21 Dec 2025 19:12:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766373133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lhDz9De+0KQKYXwyi7fXsZXUS+UyFkHbIg9lL8okLng=;
	b=LLXTjyXj4sjKaSd7i+xSAkBw/Egc4X73CMw9V0L1nvh4msC2Wo73V2CTmMnyFZ6OV4btxo
	fGnwKNSKQDavxwzVJ0cZAwHrzN+Rppl+CgK3m8F3QniAgBfr2K3jzqizcuiYBDRUx9b9ql
	rMlMj7XO0cSjsvw3e70ahe02CtnyJxs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, hannes@cmpxchg.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, zhengqi.arch@bytedance.com, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	lujialin4@huawei.com, zhongjinji@honor.com
Subject: Re: [PATCH -next 1/5] mm/mglru: use mem_cgroup_iter for global
 reclaim
Message-ID: <gkudpvytcc3aa5yjaigwtkyyyglmvnnqngrexfuqiv2mzxj5cn@e7rezszexd7l>
References: <20251209012557.1949239-1-chenridong@huaweicloud.com>
 <20251209012557.1949239-2-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209012557.1949239-2-chenridong@huaweicloud.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D7BD7140012
X-Stat-Signature: qzkgupkg7mugnddwuspw5pcihxki1pti
X-HE-Tag: 1766373136-227440
X-HE-Meta: U2FsdGVkX19Ylu18c1pOxWMfKhwiZ2O6tB3ufBe+e9KuHp2cZ9ywXt2dZ+MMfRvOjHfA0s1YanLuaVjRtJUoprcZUpbkg5G4Ps+TCOzmEW0Ct2WOHJD829f9On7iqWzkE8Br3Jz6yN+pwP+ThCSSkcyK7DDg0CaMhfDxW63sExGZZayDU/uvf49FlGELaYhnsrdgEoWLZ8pl30dIJR9UZqboNtAD7bhjR86AOxk2MbJM8ujMKb1RRNDErQgdnzYIg1a22dyyhCMIMQMnp7j9pBZ/6j4VFtBTdO72BBT46nm1UHWWrYAZ/QZDEl5wQ1kYnJE1yaFfKWqBFe8b0bKZTfEtxHL6MDn5pVPXCoBVWau/3IvxG1NuvUVUDd4ZSNiVPvy7gXK7HcPheVCsaBz/jk5WflFElvGp9deycGWuSfSaQF2HD+wDhW+RAHMY3hAGkZKsjZDk+TYh+UQD6tywN3YsIiLS7O9dVp4RFm/WtkWDjrnXhyHn3jZRZfHvwKU4U8u/aHFWvdx12lX8LfEg4Pf14Y9HKWvdPJuoMSxbepYFUoPT5iGbCfmwTkn2ANi+qbcv/Gzza3EAluSBnLiiAloRv2TGFw7diBxOgPKzSBW6CJV2TbYexn/wg5HkQaRon3TYoeGe1ofJYwY9v0l6W1OJ4+NGF7yVZhQ2oKDR4yhLrE5/w3sQSHEa+tWUnlodZH/EohSrvmOoGH9PcRVkoGjRhAJ6M9AJ8ePxui8uPSsYezv1tofon4G4w/MkrjlldqwMp6pnok5twI0mYOo8fdn33pkg7DaUbehmVcuU56/WCKDjVm5uS6oXKhiJKudEgJ0hwM0GacpibUrsnDnPoe7rjHERLvjcG9mlqW5Em0DQM7Qp5lc7JXMBjD5RsZr3UAgFdNwKMsq/zHNhWJpwKEu2FycOkpfIPmTDVskazDc5RnuxlvhR/nhyd6E+IP9VlKZhSF6WrEYSqLAfY2y
 Neu1h/V3
 3LHfK4GnSVK6PAznl7WHdw4ekf+GR3V0Qo3ovn/UcH5nmd+zvr8t+/OWgRiT1lE7JKDJcttK/uENGOpAGGP29JtaiBdANgiNNBv2N6qFdzT9SoLOJXlbRs49nPCYPznXd61H345jU2FS3qVB1ZGTYeFXP+PXyfGfdjq9Soc9aND3li2NuuJEpm73n4N2IqOU+PV6L7gtx4EHgpMhz2lp/K14aN8V4IckyMFLz/y30Y5iKg3Yv0MzWK09dOY3PWiGAcS+g93IQJZkQmrnqHHF7LRHyaSYpQPqai/anjWkfqvuc3pJPRrVoOFglJU2f468W13xxe+EIR61yLl8Y4IQlaSMduiiO/kpLqewnrmslpiH20qUrZpzKjkFbhxiNqtekyouWMVNXcLF+o7/03AcggSavVoDzPb+2FLpn+0sy95UaJ/CNiugHEPYu2eJASMGAHbUS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 09, 2025 at 01:25:53AM +0000, Chen Ridong wrote:
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
> It performed a stress test based on Yu Zhao's methodology [2] on a
> 1 TB, 4-node NUMA system. The results are summarized below:
> 
> 	pgsteal:
> 						memcg LRU    memcg iter
> 	stddev(pgsteal) / mean(pgsteal)		106.03%		93.20%
> 	sum(pgsteal) / sum(requested)		98.10%		99.28%
> 
> 	workingset_refault_anon:
> 						memcg LRU    memcg iter
> 	stddev(refault) / mean(refault)		193.97%		134.67%
> 	sum(refault)				1963229		2027567
> 
> The new implementation shows a clear fairness improvement, reducing the
> standard deviation relative to the mean by 12.8 percentage points. The
> pgsteal ratio is also closer to 100%. Refault counts increased by 3.2%
> (from 1,963,229 to 2,027,567).
> 
> The primary benefits of this change are:
> 1. Simplified codebase by removing custom memcg LRU infrastructure
> 2. Improved fairness in memory reclaim across multiple cgroups
> 3. Better performance when creating many memory cgroups
> 
> [1] https://lore.kernel.org/r/20251126171513.GC135004@cmpxchg.org
> [2] https://lore.kernel.org/r/20221222041905.2431096-7-yuzhao@google.com
> Suggested-by: Johannes Weiner <hannes@cmxpchg.org>
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> Acked-by: Johannes Weiner <hannes@cmxpchg.org>
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
>  {
> -	int op;
> -	int gen;
> -	int bin;
> -	int first_bin;
> -	struct lruvec *lruvec;
> -	struct lru_gen_folio *lrugen;
> +	struct mem_cgroup *target = sc->target_mem_cgroup;
> +	struct mem_cgroup_reclaim_cookie reclaim = {
> +		.pgdat = pgdat,
> +	};
> +	struct mem_cgroup_reclaim_cookie *cookie = &reclaim;

Please keep the naming same as shrink_node_memcgs i.e. use 'partial'
here.

>  	struct mem_cgroup *memcg;
> -	struct hlist_nulls_node *pos;
>  
> -	gen = get_memcg_gen(READ_ONCE(pgdat->memcg_lru.seq));
> -	bin = first_bin = get_random_u32_below(MEMCG_NR_BINS);
> -restart:
> -	op = 0;
> -	memcg = NULL;
> -
> -	rcu_read_lock();
> +	if (current_is_kswapd() || sc->memcg_full_walk)
> +		cookie = NULL;
>  
> -	hlist_nulls_for_each_entry_rcu(lrugen, pos, &pgdat->memcg_lru.fifo[gen][bin], list) {
> -		if (op) {
> -			lru_gen_rotate_memcg(lruvec, op);
> -			op = 0;
> -		}
> +	memcg = mem_cgroup_iter(target, NULL, cookie);
> +	while (memcg) {

Please use the do-while loop same as shrink_node_memcgs and then change
the goto next below to continue similar to shrink_node_memcgs.

> +		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
>  
> -		mem_cgroup_put(memcg);
> -		memcg = NULL;
> +		cond_resched();
>  
> -		if (gen != READ_ONCE(lrugen->gen))
> -			continue;
> +		mem_cgroup_calculate_protection(target, memcg);
>  
> -		lruvec = container_of(lrugen, struct lruvec, lrugen);
> -		memcg = lruvec_memcg(lruvec);
> +		if (mem_cgroup_below_min(target, memcg))
> +			goto next;
>  
> -		if (!mem_cgroup_tryget(memcg)) {
> -			lru_gen_release_memcg(memcg);
> -			memcg = NULL;
> -			continue;
> +		if (mem_cgroup_below_low(target, memcg)) {
> +			if (!sc->memcg_low_reclaim) {
> +				sc->memcg_low_skipped = 1;
> +				goto next;
> +			}
> +			memcg_memory_event(memcg, MEMCG_LOW);
>  		}
>  
> -		rcu_read_unlock();
> +		shrink_one(lruvec, sc);
>  
> -		op = shrink_one(lruvec, sc);
> -
> -		rcu_read_lock();
> -
> -		if (should_abort_scan(lruvec, sc))
> +		if (should_abort_scan(lruvec, sc)) {
> +			if (cookie)
> +				mem_cgroup_iter_break(target, memcg);
>  			break;

This seems buggy as we may break the loop without calling
mem_cgroup_iter_break(). I think for kswapd the cookie will be NULL and
if should_abort_scan() returns true, we will break the loop without
calling mem_cgroup_iter_break() and will leak a reference to memcg.


