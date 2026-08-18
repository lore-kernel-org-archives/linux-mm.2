Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AE6BC5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 04:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45E016B0395; Tue, 18 Aug 2026 00:32:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 435416B0399; Tue, 18 Aug 2026 00:32:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 324076B039B; Tue, 18 Aug 2026 00:32:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 123006B0395
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:32:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8F784140AC4
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:32:51 +0000 (UTC)
X-FDA: 85113119742.27.B163C9A
Received: from mta1.migadu.com (out-109.mta1.migadu.com [95.215.58.109])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4956B20006
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:32:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HGopUP2/";
	spf=pass (imf03.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.109 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787027569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P+cg+mHVWxa2H5q2cXNZ8NujXu7ELUrJOrsxU2k1HZA=;
	b=sS7FbOcH4/3J3vf3ytHs+M8RcdFkzbyxWPLqcQJGrrdzvJbk79I//XoRzi0iEggq+8WROr
	BQ/YQQK3SHhNcmITuiQyRt48DneUURlcQx/oEJD5k5H3EfH4BNukgHB/89cMWJWn9bAYYO
	7WgOIP8iruQdoUr10bGUINAhRih6GZc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787027569;
	b=nlQR18jFTd4inLM6+wclBN+PvYOhXce0ntrLZe5QAd0uAzymsDx28B1n/NBjJpBnqGCvXS
	5vIkbHP3Pu7h2vzDE8rPFwcMD9XZgEw3OBXTb/osUbid52MdOCUx9t89T/GdGjvOSIqqcW
	zFB0UeT/u6pZGAe6tp7Y4+NJsjb6ENI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HGopUP2/";
	spf=pass (imf03.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.109 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0Aeu40CJPGg7YRxdQERUwajbl2h/m9U4sdY8I6B0VYI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787027568; v=1; x=1787632368;
 b=HGopUP2/F+uKWqEig+66rbj55FW/4Xtb8zqBR+V2aGujRikZ2ewOGYV9sx/X8N9KGevlIVUu
 MGdMSBdjJ+17Ywi8DG5DDHUrbJVU1faCC9+A8sb+dO1wZHDek4cpq9Ks0w9hLcTmkKPS9odE8gb
 q8GDUp8QhNWf2IJfZUVgleOo=
X-Envelope-To: linux-mm@kvack.org
Received: from [192.168.110.173] (223.70.160.239)
	by smtp.migadu.com with ESMTPS id 7e9ddfa9cc62e64c;
	Tue, 18 Aug 2026 04:32:48 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <ebffdd23-5291-47f8-88e7-0f10d5f7d3b2@linux.dev>
Date: Tue, 18 Aug 2026 12:32:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, tj@kernel.org, mkoutny@suse.com, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, akpm@linux-foundation.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/8] mm/memcontrol: add per-tier charge and uncharge
To: liuqiqi@kylinos.cn, linux-mm@kvack.org
References: <20260818023121.100613-1-liuqiqi@kylinos.cn>
 <20260818023121.100613-5-liuqiqi@kylinos.cn>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260818023121.100613-5-liuqiqi@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: k8y5at7o3upr3b3krjin4uroncmp9w64
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4956B20006
X-HE-Tag: 1787027569-60343
X-HE-Meta: U2FsdGVkX18PsB25mBgXfBJyJH6LamrkPjxJ/JN9yZ/l8JyxWuygn3oa6K5E9Z/ZSi7dbTSMebT1Yn99xACLvlONiysUnyt/iWlIA9nj7Tkml9zPuIxeB81gms+qu7U9lDWskkjvLAYv5FmlTrvgXu6gl/ITr+6uTUerpwFjThBa99LhGvrm/wkYU5wa5dS1ljIrHUm3sCV2lx1Wjm8+uWtR1PhMM+0bp7eJlpygXaH9Mhc+nX+yoUG7C9XyR4FfKeUXcL0skI5QFoy7JtRD4qMnCp94Xr5Q0ARhtKxfqJgi3v8jp0hx29Q4zJVDiiupNMDtm1o8SE599QecCuFPdHZ85tK4GQrgtoLENKwTbxqgXCjgKx7XNKUkpwSmYtc1Dvh3gWrXWbxVBd8yd+bSjjiYMVMqX5zIq6aXarX6tKeMWK/qZIkiWAqtGKwEmXZVGH3QEq4lJ+zQyGB/mE3dJH8doUxNplNQd0/J4CX98ctRjMsvVjLhC5nS4zMJ9y6owFM3YSjfFUJYhlbUb1Ck60NJ0Kn0EovTUgp66iIvlovRs6w+DD+byLFLdQOjZjqTWDmZaYCjD6E/wsbHFliIqRC3jNbct7zrxoinCOVf+Ef3GZRGJ3GdsGSAS9L4o45/8yknPfgDa/kEQkjFv7WY3k4fBeE6js5+Oh3wNvhBFmbfZg/woKhnV1Bmyf9Y0Jy5aYhME5hDNrPH+rFLfM3I+JdoVmpfjsWFFnJ9d4xEbI52vAvaGyn4X4EzyA572mWtsMr0+8HT6ROd5hrpJxJ0CM+qw1w3GOQkqqu7zEFd4JG8zc3Hyod60XTuLRc4VxJsu2KBYrbcnvL+S74XIlLfaKjG8ZVprCREV64EDR3vT50On+fjqgkONq1u4HRr9V+zygzzrERQi+k/LSgdFEFWRQ+yugPUDi4Ggtr9xXJlJxHkXVkqQJ6TMiyXfWTBPvH3N4WEDq4zj8zynpTmOyl
 3aTvYxVF
 CAyjnRU/7VdSpXWYRs+Z6CUwIhXMaU+RV0JYdXyD7io9Sy64m33wZF33MwAWftrV8nXXOSwXZlyvmlDG+FnqgC486fSdHNN3clTsHYr2IeVYxnSIUSSjzG5+AAucbqbgZkad9kwEU4FJDFHzsoeYNHUQxoz34sj4jekaQXZgCrriYelUVVvPggjcwaK08k9+ybvVIpACB7EVkCB1mLYAobti1y/hl/r4R62siXm/a4wvO3tHAv0CAKYD+pc7hYg5PI7Gchlt973NcPNXpXqu8NjN1EqqVp49tZhyrpeora8fBf/nrX0O3iEA1FA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,Qiqi

在 2026/8/18 10:31, liuqiqi@kylinos.cn 写道:
> From: Qiqi Liu <liuqiqi@kylinos.cn>
> 
> Extend the memcg charging infrastructure to support per-tier accounting.
> After a successful global charge (try_charge_memcg), charge_memcg()
> attempts per-tier charging. If the tier charge fails, the global charge
> is rolled back via refill_stock() to maintain a consistent state.
> 
> Per-tier limits are enforced via dedicated page_counter objects with
> both a hard limit (max) and a soft limit (high):
> 
>   - Hard limit: Charging beyond the tier's max triggers reclaim scoped
>     to that tier's NUMA nodes and retries the charge. If reclaim fails,
>     OOM is invoked, mirroring memory.max behavior. PF_MEMALLOC
>     allocations force-charge past the tier max without reclaim (recursion
>     guard); __GFP_NOFAIL/__GFP_HIGH allocations are force-charged past
>     the tier max only after reclaim and OOM both fail.
> 
>   - Soft limit: The charge always succeeds, but if a tier exceeds its
>     high watermark, the charge path schedules tier_high_work to perform
>     asynchronous reclaim.
> 
> The folio lifecycle is updated accordingly:
> 
>   - Charging: Attempt per-tier charging after global success; roll back
>     the global charge on tier failure.
>   - Uncharging: Directly uncharge the tier counter.
>   - Replacement: Force-charge the new folio to its tier; the old folio
>     is uncharged upon freeing.
>   - Migration: Keep the global usage unchanged; uncharge the old tier
>     and charge the new tier to reflect the folio's new location.
> 
> This patch implements per-tier accounting for LRU folios (anon and file).
> 
> Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
> ---
>  include/linux/memcontrol.h |   1 +
>  mm/memcontrol.c            | 198 ++++++++++++++++++++++++++++++++++++-
>  2 files changed, 197 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index c0f5929a87bf..fa944e4bc5ad 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -330,6 +330,7 @@ struct mem_cgroup {
>  
>  	spinlock_t tier_lock;
>  	struct list_head tier_counters;
> +	struct work_struct tier_high_work;
>  
>  	struct mem_cgroup_per_node *nodeinfo[];
>  };
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 70efe01bc36f..30f24604010c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2433,6 +2433,46 @@ static int memcg_tier_counter_create(struct mem_cgroup *memcg,
>  	return 0;
>  }
>  
> +static void memcg_charge_tier_id(struct mem_cgroup *memcg, int tier_id,
> +				 unsigned long nr_pages)
> +{
> +	struct memcg_tier_counter *tc;
> +
> +	if (tier_id < 0)
> +		return;
> +	rcu_read_lock();
> +	tc = memcg_tier_counter_find(memcg, tier_id);
> +	if (tc)
> +		page_counter_charge(&tc->counter, nr_pages);
> +	rcu_read_unlock();
> +}
> +
> +static void memcg_uncharge_tier_id(struct mem_cgroup *memcg, int tier_id,
> +				   unsigned long nr_pages)
> +{
> +	struct memcg_tier_counter *tc;
> +
> +	if (tier_id < 0)
> +		return;
> +	rcu_read_lock();
> +	tc = memcg_tier_counter_find(memcg, tier_id);
> +	if (tc)
> +		page_counter_uncharge(&tc->counter, nr_pages);
> +	rcu_read_unlock();
> +}
> +
> +static void memcg_charge_tier(struct mem_cgroup *memcg, struct folio *folio,
> +			     unsigned long nr_pages)
> +{
> +	memcg_charge_tier_id(memcg, node_to_tier_id(folio_nid(folio)), nr_pages);
> +}
> +
> +static void memcg_uncharge_tier(struct mem_cgroup *memcg, struct folio *folio,
> +			       unsigned long nr_pages)
> +{
> +	memcg_uncharge_tier_id(memcg, node_to_tier_id(folio_nid(folio)), nr_pages);
> +}
> +
>  static void memcg_free_tier_counters(struct mem_cgroup *memcg)
>  {
>  	struct memcg_tier_counter *tc, *tmp;
> @@ -2445,6 +2485,49 @@ static void memcg_free_tier_counters(struct mem_cgroup *memcg)
>  	spin_unlock(&memcg->tier_lock);
>  }
>  
> +static unsigned long
> +reclaim_tier(struct mem_cgroup *memcg, unsigned int nr_pages, gfp_t gfp_mask,
> +	     nodemask_t *nmp)
> +{
> +	unsigned long nr_reclaimed, pflags;
> +
> +	psi_memstall_enter(&pflags);
> +	nr_reclaimed = try_to_free_mem_cgroup_pages_nodemask(memcg, nr_pages, gfp_mask,
> +							    MEMCG_RECLAIM_MAY_SWAP, NULL, nmp);
> +	psi_memstall_leave(&pflags);
> +	return nr_reclaimed;
> +}
> +
> +static void tier_high_work_func(struct work_struct *work)
> +{
> +	struct mem_cgroup *memcg;
> +	struct memcg_tier_counter *tc;
> +	/* Few tiers in practice (2-4); cap is generous. */
> +	int over_ids[16];
> +	int nr_over = 0;
> +	int i;
> +
> +	memcg = container_of(work, struct mem_cgroup, tier_high_work);
> +
> +	spin_lock(&memcg->tier_lock);
> +	list_for_each_entry(tc, &memcg->tier_counters, list) {
> +		if (page_counter_read(&tc->counter) > READ_ONCE(tc->counter.high)) {
> +			if (nr_over < ARRAY_SIZE(over_ids))
> +				over_ids[nr_over++] = tc->tier_id;
> +		}
> +	}
> +	spin_unlock(&memcg->tier_lock);
> +
> +	for (i = 0; i < nr_over; i++) {
> +		nodemask_t nodes;
> +
> +		if (tier_id_to_nodemask(over_ids[i], &nodes) ||
> +		    nodes_empty(nodes))
> +			continue;
> +		reclaim_tier(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL, &nodes);
> +	}
> +}
> +
>  /*
>   * Clamp the maximum sleep time per allocation batch to 2 seconds. This is
>   * enough to still cause a significant slowdown in most cases, while still
> @@ -2873,6 +2956,90 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	return 0;
>  }
>  
> +static int try_charge_memcg_tier(struct mem_cgroup *memcg, gfp_t gfp_mask,
> +	unsigned int nr_pages, int tier_id)
> +{
> +	struct memcg_tier_counter *tc;
> +	struct page_counter *counter;
> +	int nr_retries = MAX_RECLAIM_RETRIES;
> +	unsigned long nr_reclaimed = 0;
> +	bool passed_oom = false;
> +	nodemask_t nodes, *nmp = NULL;
> +
> +	if (tier_id < 0)
> +		return 0;
> +
> +	rcu_read_lock();
> +	tc = memcg_tier_counter_find(memcg, tier_id);
> +	rcu_read_unlock();
> +	if (!tc)
> +		return 0;
> +
> +retry:
> +	if (page_counter_try_charge(&tc->counter, nr_pages, &counter))
> +		goto success;
> +
> +	/* Over max -> reclaim. */
> +	if (unlikely(current->flags & PF_MEMALLOC))
> +		goto force;
> +	if (unlikely(task_in_memcg_oom(current)))
> +		goto nomem;
> +	if (!gfpflags_allow_blocking(gfp_mask))
> +		goto nomem;
> +
> +	if (!tier_id_to_nodemask(tier_id, &nodes) && !nodes_empty(nodes))
> +		nmp = &nodes;
> +
> +	nr_reclaimed = reclaim_tier(memcg, nr_pages, gfp_mask, nmp);
> +

If the nodemask lookup fails, nmp stays NULL and reclaim scans all
nodes - enforcing tier4.max evicts from tier22, and the freed pages
are on the wrong tier so it doesn't even help. I'd goto nomem here.

Also two nits: struct page_counter *counter is never read; and the
function relies on the caller's css reference to keep tc valid across
reclaim_tier()/mem_cgroup_oom() (the RCU lock only covers the list
walk) - worth a comment before someone adds a new caller.

Thanks,
Tao

> +	if (page_counter_read(&tc->counter) + nr_pages <= READ_ONCE(tc->counter.max))
> +		goto retry;
> +	if (gfp_mask & __GFP_NORETRY)
> +		goto nomem;
> +	if (nr_reclaimed && nr_pages <= (1 << PAGE_ALLOC_COSTLY_ORDER))
> +		goto retry;
> +	if (nr_retries--)
> +		goto retry;
> +	if (gfp_mask & __GFP_RETRY_MAYFAIL)
> +		goto nomem;
> +	if (passed_oom && task_is_dying())
> +		goto nomem;
> +	if (mem_cgroup_oom(memcg, gfp_mask, get_order(nr_pages * PAGE_SIZE))) {
> +		passed_oom = true;	/* tier max is a hard limit: OOM, like memory.max */
> +		nr_retries = MAX_RECLAIM_RETRIES;
> +		goto retry;
> +	}
> +	goto nomem;
> +success:
> +	do {
> +		struct memcg_tier_counter *tc_this;
> +
> +		rcu_read_lock();
> +		tc_this = memcg_tier_counter_find(memcg, tier_id);
> +		if (tc_this &&
> +		    page_counter_read(&tc_this->counter) > READ_ONCE(tc_this->counter.high) &&
> +		    !work_pending(&memcg->tier_high_work)) {
> +			schedule_work(&memcg->tier_high_work);
> +			rcu_read_unlock();
> +			break;
> +		}
> +		rcu_read_unlock();
> +	} while ((memcg = parent_mem_cgroup(memcg)));
> +	return 0;
> +nomem:
> +	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
> +		return -ENOMEM;
> +
> +force:
> +	/*
> +	 * Force-charge past the tier max for reclaim/privileged allocations
> +	 * (PF_MEMALLOC, or __GFP_NOFAIL/__GFP_HIGH that fell through from
> +	 * nomem) -- not skip -- so the page is in tier.current too.
> +	 */
> +	page_counter_charge(&tc->counter, nr_pages);
> +	return 0;
> +}
> +
>  static inline int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  			     unsigned int nr_pages)
>  {
> @@ -4216,6 +4383,7 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
>  	INIT_WORK(&memcg->high_work, high_work_func);
>  	spin_lock_init(&memcg->tier_lock);
>  	INIT_LIST_HEAD(&memcg->tier_counters);
> +	INIT_WORK(&memcg->tier_high_work, tier_high_work_func);
>  	vmpressure_init(&memcg->vmpressure);
>  	INIT_LIST_HEAD(&memcg->memory_peaks);
>  	INIT_LIST_HEAD(&memcg->swap_peaks);
> @@ -4439,6 +4607,7 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
>  
>  	vmpressure_cleanup(&memcg->vmpressure);
>  	cancel_work_sync(&memcg->high_work);
> +	cancel_work_sync(&memcg->tier_high_work);
>  	memcg_free_tier_counters(memcg);
>  	memcg1_remove_from_trees(memcg);
>  	free_shrinker_info(memcg);
> @@ -5224,8 +5393,17 @@ static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
>  
>  	objcg = get_obj_cgroup_from_memcg(memcg);
>  	/* Do not account at the root objcg level. */
> -	if (!obj_cgroup_is_root(objcg))
> +	if (!obj_cgroup_is_root(objcg)) {
>  		ret = try_charge_memcg(memcg, gfp, folio_nr_pages(folio));
> +		if (!ret) {
> +			int tid = node_to_tier_id(folio_nid(folio));
> +
> +			ret = try_charge_memcg_tier(memcg, gfp, folio_nr_pages(folio), tid);
> +			/* tier over max / OOM: undo the memory charge */
> +			if (ret)
> +				refill_stock(memcg, folio_nr_pages(folio));
> +		}
> +	}
>  	if (ret) {
>  		obj_cgroup_put(objcg);
>  		return ret;
> @@ -5385,8 +5563,11 @@ static void uncharge_folio(struct folio *folio, struct uncharge_gather *ug)
>  		ug->nr_kmem += nr_pages;
>  	} else {
>  		/* LRU pages aren't accounted at the root level */
> -		if (!obj_cgroup_is_root(objcg))
> +		if (!obj_cgroup_is_root(objcg)) {
>  			ug->nr_memory += nr_pages;
> +			memcg_uncharge_tier(obj_cgroup_memcg(objcg), folio,
> +				nr_pages);
> +		}
>  		ug->pgpgout++;
>  
>  		WARN_ON_ONCE(folio_unqueue_deferred_split(folio));
> @@ -5461,6 +5642,7 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
>  		page_counter_charge(&memcg->memory, nr_pages);
>  		if (do_memsw_account())
>  			page_counter_charge(&memcg->memsw, nr_pages);
> +		memcg_charge_tier(memcg, new, nr_pages);
>  	}
>  
>  	obj_cgroup_get(objcg);
> @@ -5503,6 +5685,18 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
>  	if (!objcg)
>  		return;
>  
> +	/* Re-account the per-tier breakdown if the folio moved across tiers. */
> +	if (!obj_cgroup_is_root(objcg)) {
> +		struct mem_cgroup *memcg = obj_cgroup_memcg(objcg);
> +		int old_tier = node_to_tier_id(folio_nid(old));
> +		int new_tier = node_to_tier_id(folio_nid(new));
> +
> +		if (old_tier != new_tier) {
> +			memcg_uncharge_tier_id(memcg, old_tier, folio_nr_pages(old));
> +			memcg_charge_tier_id(memcg, new_tier, folio_nr_pages(new));
> +		}
> +	}
> +
>  	/* Transfer the charge and the objcg ref */
>  	commit_charge(new, objcg);
>  


