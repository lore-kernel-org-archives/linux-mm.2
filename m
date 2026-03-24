Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30A0CF54ABA
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 13:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 725076B0088; Tue, 24 Mar 2026 09:48:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D5DA6B0089; Tue, 24 Mar 2026 09:48:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C5316B008A; Tue, 24 Mar 2026 09:48:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A0DD6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:48:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AEEABBF857
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:48:12 +0000 (UTC)
X-FDA: 84581085624.22.1CB4339
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id CDB6012000C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:48:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d6TRMebZ;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774360091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wuDPoLJUo258SLdN/4lGI5T4x8vsvh+7UpJzNYCOsWk=;
	b=Y75qGKiztrAYzSkhCqSkeusDewtLPHjL5hV41cOL3EsdodFPmzpQPzGv8a8daLgAaH2gas
	mr7Dntood7kaOjfHPxjy4zQVFkVmHAfWHZ6ubQUcCcj9V/juMod7UATFp99NJlU/39QRG4
	RHww6oYLqZK5SBAMSsc40xzGNS2PEdY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d6TRMebZ;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774360091; a=rsa-sha256;
	cv=none;
	b=cbNcH+zcU1RJT/Wk1bmJFU3bwHI4BGEYbh8nzuachOfidlamdMEYGB3ZjT522SLD2ImkBZ
	wqOCd83FFseb0xEaDk6uEtSgSygt4bkatxmNKFhWZ2ai8KqgM19yh1lIA+063lzSZjpDmI
	4OfeeXfxo7zB7NXzHYkC33FOm4UrPNY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BE4743655;
	Tue, 24 Mar 2026 13:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548A5C19424;
	Tue, 24 Mar 2026 13:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774360089;
	bh=2uFj+Eqcx7B/i9zlvQhHIieM8KgsJpunX/ancseN0no=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d6TRMebZUcdvonlMzTlgbgoUVI8qdoMsX1rNEuywUAUQpCTaKN7Q+dxBDMR7iPSqH
	 54uwtV+Nxy41VijlFn/HfG554BKwScr2wZBhrEgQ3323eGWc6JnL+YL72zjlNE8t/J
	 r4ieUhNfzdDjATqVlw8XYcHkBA0E124sKeQArfoJ6LwI3czi69KSHZm9S7Rao0BXMS
	 wtEMKz+iV0p8JcTe0eWTAa7mIzeXQx55DLiaPz+n8znILZADGE/d0s38T98mwv2kEz
	 R2atB/MUqjCJlW3bOUcM7K1+6DXscLqSsO3Fp63/4Ase8cEqrtsYALCLvvTQ61YO8j
	 svoLQeg8u+oqA==
Date: Tue, 24 Mar 2026 13:48:06 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/7] mm: switch deferred split shrinker to list_lru
Message-ID: <0cf8a859-b142-4e53-9113-94872dd68f40@lucifer.local>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-8-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318200352.1039011-8-hannes@cmpxchg.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CDB6012000C
X-Stat-Signature: ockoxnxiuhbn6j1azyoexu5ddkr6qqd6
X-Rspam-User: 
X-HE-Tag: 1774360090-969371
X-HE-Meta: U2FsdGVkX18dAw49+FQ3qXk6xa+1ackF0ryVJvMP1Q3fDk2yY7M1khRStYGtsBoSP+Bqp5efDZNbxs4IocX5X/f+YtHZwpOeya6uDykCe6XgpRV3gpnitTDOMZpEHFQiLOthSaaitl44i4a1EH7YpIvOWd5pXj9zYc4voEZotNMSIYwSozMCf+yKWPmD12NHhZezqYPNFg5/nrwsKK+RmFUZqdtCRiMy6yxnH0MK/+fCjqZv4lgQIQ7hKfV+HK9V3Ix5LNNisFo5/V8pwD4UPMbVkYhuhCnZwaLmw4bH+osRCcfxxvJG9qOM5gBgwSvij+bTHHMtPsj0j2XRZqgEtk83JcXJbRTDt4dinZTw5g0qGS1LiTG8ZLJX+RYj/HnoLso543r1Rthu9A/SuseXK9bqzmr754LEMsaFRoIbUyzoc4KACAZUPk7cbCMQATlNUvfIC8ER2B3UoxhhoOOaubDjqtS5GARReTUa6hxG0//2gHQGchrCmt45YvLBX6sZwsmTi8Pn/1FbPn5p5St7x1sHv8IG4ADznNp0I7qu1gH4ygj79KJdbLzspLlWVLPoUEqPlKAx8O3WncxgF9bk6P8rvMSzmSHs5m35xMF6rc2E9xaN0uPYwxrbY6Gu3tcfo/YtuDiGoM3B2WNf/oo4mzQ7UspwafC0zKlnditmU7/wEACCV4UTv+tWwLTve7hXQzHbQKw1QEJncA9sjhI4r368MEKQfyMpAmsGJzV5yCWdQcsg3uAk7IyhQtfJJ52QgxhfjhVBHxZUuQU8NRFiZjtCGbesDZQv2qDdQ/HxKP94Gkn/XvOMOhHngXU9ByBpl8go2IWRvTvJUCcbNRGgzXH7Fc8eZtFL10FIG5VeHRdR4HhHWSQ+/6wV7lReIukBOMemW/rU8IUpc84k1zymdzfScJAALuUo+LmwjSx7ikgcrTh6LEmQ1zeRI86D3ufuK2SlW+gyyp68kn/JqRn
 RIHZnK9W
 sii2OHMjVFC+WnaLia7o1mR/p2Cip3JQ7Wjfy4/a6kBgt++rdSvLzXjFO3g9/MaWP1ATUDgoeMxEjaUXVpvrgwqw7K7nmVdKkQvslSY1VroNTPJKXWopOUyLao73JzLzI4jYEWu64ogRiT8iYF8qo0fXILcwnGJCOMf6kxsFJLpuviTGT6ZNryNA9zvEZ9DhQWpuLyb4LuwDzdPQ7vTNi+0CEa6B6QqENGiAHAEgb7aofuSdv4AqCNIba2Z8k8UqD3Fj+cr/v4K5ZDEFNvOzcIevi5AWpIQKZo3g3ugPpk2trYxTmMRR9TmuEk0ZUtvsqBSs9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 03:53:25PM -0400, Johannes Weiner wrote:
> The deferred split queue handles cgroups in a suboptimal fashion. The
> queue is per-NUMA node or per-cgroup, not the intersection. That means
> on a cgrouped system, a node-restricted allocation entering reclaim
> can end up splitting large pages on other nodes:
>
> 	alloc/unmap
> 	  deferred_split_folio()
> 	    list_add_tail(memcg->split_queue)
> 	    set_shrinker_bit(memcg, node, deferred_shrinker_id)

So here it's:

__do_huge_pmd_anonymous_page() / do_huge_zero_wp_pmd()
-> map_anon_folio_pmd_pf()
-> map_anon_folio_pmd_nopf()
-> deferred_split_folio()
-> set_shrinker_bit()

Yeah it makes sense to make the first bit succinct anyway :)

>
> 	for_each_zone_zonelist_nodemask(restricted_nodes)
> 	  mem_cgroup_iter()
> 	    shrink_slab(node, memcg)
> 	      shrink_slab_memcg(node, memcg)
> 	        if test_shrinker_bit(memcg, node, deferred_shrinker_id)

Hmm there's no such function is this kind of pseudocode, essentially?

Wouldn't it be clearer to reference:

shrink_slab_memcg() -> do_shrink_slab() -> shrinker->scan_objects ->
deferred_split_scan()?

Though I get that it adds verbosity :)

Sorry not (just) being pedantic here, also so I can understand myself :)

> 	          deferred_split_scan()
> 	            walks memcg->split_queue

Ok so overall there's a per-memcg memcg->split_queue, but we set a bit in
memcg->nodeinfo[nid]->shrinker_info->unit[blah]->map for it, and when we
enter shrink_slab_memcg(), we figure out the shrink_control from the
for_each_set_bit() across memcg->...->unit->map?

> The shrinker bit adds an imperfect guard rail. As soon as the cgroup
> has a single large page on the node of interest, all large pages owned
> by that memcg, including those on other nodes, will be split.

So at this point, regardless of node, we are invoking deferred_split_scan()
and it's the same memcg->split_queue we are walking, regardless of node?

Do let me know if my understanding is correct here!

Hmm that does sound sub-optimal.

>
> list_lru properly sets up per-node, per-cgroup lists. As a bonus, it
> streamlines a lot of the list operations and reclaim walks. It's used
> widely by other major shrinkers already. Convert the deferred split
> queue as well.

It's odd that it wasn't used before?

>
> The list_lru per-memcg heads are instantiated on demand when the first
> object of interest is allocated for a cgroup, by calling
> folio_memcg_list_lru_alloc(). Add calls to where splittable pages are
> created: anon faults, swapin faults, khugepaged collapse.

OK that makes sense.

>
> These calls create all possible node heads for the cgroup at once, so
> the migration code (between nodes) doesn't need any special care.

Nice!

>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Hmm you saved the big one for last :)

> ---
>  include/linux/huge_mm.h    |   6 +-
>  include/linux/memcontrol.h |   4 -
>  include/linux/mmzone.h     |  12 --
>  mm/huge_memory.c           | 342 ++++++++++++-------------------------
>  mm/internal.h              |   2 +-
>  mm/khugepaged.c            |   7 +
>  mm/memcontrol.c            |  12 +-
>  mm/memory.c                |  52 +++---
>  mm/mm_init.c               |  15 --
>  9 files changed, 151 insertions(+), 301 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index bd7f0e1d8094..8d801ed378db 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -414,10 +414,9 @@ static inline int split_huge_page(struct page *page)
>  {
>  	return split_huge_page_to_list_to_order(page, NULL, 0);
>  }
> +
> +extern struct list_lru deferred_split_lru;

It might be nice for the sake of avoiding a global to instead expose this
as a getter?

Or actually better, since every caller outside of huge_memory.c that
references this uses folio_memcg_list_lru_alloc(), do something like:

int folio_memcg_alloc_deferred(struct folio *folio, gfp_t gfp);

in mm/huge_memory.c:

/**
 * blah blah blah put on error blah
 */
int folio_memcg_alloc_deferred(struct folio *folio, gfp_t gfp)
{
	int err;

	err = folio_memcg_list_lru_alloc(folio, &deferred_split_lru, gfP);
	if (err) {
		folio_put(folio);
		return err;
	}

	return 0;
}

And then the callers can just invoke this, and you can make
deferred_split_lru static in mm/huge_memory.c?


>  void deferred_split_folio(struct folio *folio, bool partially_mapped);
> -#ifdef CONFIG_MEMCG
> -void reparent_deferred_split_queue(struct mem_cgroup *memcg);
> -#endif
>
>  void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>  		unsigned long address, bool freeze);
> @@ -650,7 +649,6 @@ static inline int try_folio_split_to_order(struct folio *folio,
>  }
>
>  static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
> -static inline void reparent_deferred_split_queue(struct mem_cgroup *memcg) {}
>  #define split_huge_pmd(__vma, __pmd, __address)	\
>  	do { } while (0)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 086158969529..0782c72a1997 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -277,10 +277,6 @@ struct mem_cgroup {
>  	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
>  #endif
>
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	struct deferred_split deferred_split_queue;
> -#endif
> -
>  #ifdef CONFIG_LRU_GEN_WALKS_MMU
>  	/* per-memcg mm_struct list */
>  	struct lru_gen_mm_list mm_list;
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 7bd0134c241c..232b7a71fd69 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1429,14 +1429,6 @@ struct zonelist {
>   */
>  extern struct page *mem_map;
>
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -struct deferred_split {
> -	spinlock_t split_queue_lock;
> -	struct list_head split_queue;
> -	unsigned long split_queue_len;
> -};
> -#endif
> -
>  #ifdef CONFIG_MEMORY_FAILURE
>  /*
>   * Per NUMA node memory failure handling statistics.
> @@ -1562,10 +1554,6 @@ typedef struct pglist_data {
>  	unsigned long first_deferred_pfn;
>  #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
>
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	struct deferred_split deferred_split_queue;
> -#endif
> -
>  #ifdef CONFIG_NUMA_BALANCING
>  	/* start time in ms of current promote rate limit period */
>  	unsigned int nbp_rl_start;
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 3fc02913b63e..e90d08db219d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -14,6 +14,7 @@
>  #include <linux/mmu_notifier.h>
>  #include <linux/rmap.h>
>  #include <linux/swap.h>
> +#include <linux/list_lru.h>
>  #include <linux/shrinker.h>
>  #include <linux/mm_inline.h>
>  #include <linux/swapops.h>
> @@ -67,6 +68,8 @@ unsigned long transparent_hugepage_flags __read_mostly =
>  	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG)|
>  	(1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
>
> +static struct lock_class_key deferred_split_key;
> +struct list_lru deferred_split_lru;
>  static struct shrinker *deferred_split_shrinker;
>  static unsigned long deferred_split_count(struct shrinker *shrink,
>  					  struct shrink_control *sc);
> @@ -919,6 +922,13 @@ static int __init thp_shrinker_init(void)
>  	if (!deferred_split_shrinker)
>  		return -ENOMEM;
>
> +	if (list_lru_init_memcg_key(&deferred_split_lru,
> +				    deferred_split_shrinker,
> +				    &deferred_split_key)) {
> +		shrinker_free(deferred_split_shrinker);
> +		return -ENOMEM;
> +	}
> +

It's kind of out of scope for the series, but I hate that the huge zero
folio stuff has an early exit for persistent but if not, falls through to
trying to set that up - it'd be nice to split out the huge zero folio stuff
into another function.

But probably one for a follow up!

>  	deferred_split_shrinker->count_objects = deferred_split_count;
>  	deferred_split_shrinker->scan_objects = deferred_split_scan;
>  	shrinker_register(deferred_split_shrinker);
> @@ -939,6 +949,7 @@ static int __init thp_shrinker_init(void)
>
>  	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
>  	if (!huge_zero_folio_shrinker) {
> +		list_lru_destroy(&deferred_split_lru);
>  		shrinker_free(deferred_split_shrinker);

Presumably no probably-impossible-in-reality race on somebody entering the
shrinker and referencing the deferred_split_lru before the shrinker is freed?

>  		return -ENOMEM;
>  	}
> @@ -953,6 +964,7 @@ static int __init thp_shrinker_init(void)
>  static void __init thp_shrinker_exit(void)
>  {
>  	shrinker_free(huge_zero_folio_shrinker);
> +	list_lru_destroy(&deferred_split_lru);

Same question above as to race/ordering.

>  	shrinker_free(deferred_split_shrinker);
>  }



>
> @@ -1133,119 +1145,6 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
>  	return pmd;
>  }
>
> -static struct deferred_split *split_queue_node(int nid)
> -{
> -	struct pglist_data *pgdata = NODE_DATA(nid);
> -
> -	return &pgdata->deferred_split_queue;
> -}
> -
> -#ifdef CONFIG_MEMCG
> -static inline
> -struct mem_cgroup *folio_split_queue_memcg(struct folio *folio,
> -					   struct deferred_split *queue)
> -{
> -	if (mem_cgroup_disabled())
> -		return NULL;
> -	if (split_queue_node(folio_nid(folio)) == queue)
> -		return NULL;
> -	return container_of(queue, struct mem_cgroup, deferred_split_queue);
> -}
> -
> -static struct deferred_split *memcg_split_queue(int nid, struct mem_cgroup *memcg)
> -{
> -	return memcg ? &memcg->deferred_split_queue : split_queue_node(nid);
> -}
> -#else
> -static inline
> -struct mem_cgroup *folio_split_queue_memcg(struct folio *folio,
> -					   struct deferred_split *queue)
> -{
> -	return NULL;
> -}
> -
> -static struct deferred_split *memcg_split_queue(int nid, struct mem_cgroup *memcg)
> -{
> -	return split_queue_node(nid);
> -}
> -#endif
> -
> -static struct deferred_split *split_queue_lock(int nid, struct mem_cgroup *memcg)
> -{
> -	struct deferred_split *queue;
> -
> -retry:
> -	queue = memcg_split_queue(nid, memcg);
> -	spin_lock(&queue->split_queue_lock);
> -	/*
> -	 * There is a period between setting memcg to dying and reparenting
> -	 * deferred split queue, and during this period the THPs in the deferred
> -	 * split queue will be hidden from the shrinker side.
> -	 */
> -	if (unlikely(memcg_is_dying(memcg))) {
> -		spin_unlock(&queue->split_queue_lock);
> -		memcg = parent_mem_cgroup(memcg);
> -		goto retry;
> -	}
> -
> -	return queue;
> -}
> -
> -static struct deferred_split *
> -split_queue_lock_irqsave(int nid, struct mem_cgroup *memcg, unsigned long *flags)
> -{
> -	struct deferred_split *queue;
> -
> -retry:
> -	queue = memcg_split_queue(nid, memcg);
> -	spin_lock_irqsave(&queue->split_queue_lock, *flags);
> -	if (unlikely(memcg_is_dying(memcg))) {
> -		spin_unlock_irqrestore(&queue->split_queue_lock, *flags);
> -		memcg = parent_mem_cgroup(memcg);
> -		goto retry;
> -	}
> -
> -	return queue;
> -}
> -
> -static struct deferred_split *folio_split_queue_lock(struct folio *folio)
> -{
> -	struct deferred_split *queue;
> -
> -	rcu_read_lock();
> -	queue = split_queue_lock(folio_nid(folio), folio_memcg(folio));
> -	/*
> -	 * The memcg destruction path is acquiring the split queue lock for
> -	 * reparenting. Once you have it locked, it's safe to drop the rcu lock.
> -	 */
> -	rcu_read_unlock();
> -
> -	return queue;
> -}
> -
> -static struct deferred_split *
> -folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
> -{
> -	struct deferred_split *queue;
> -
> -	rcu_read_lock();
> -	queue = split_queue_lock_irqsave(folio_nid(folio), folio_memcg(folio), flags);
> -	rcu_read_unlock();
> -
> -	return queue;
> -}
> -
> -static inline void split_queue_unlock(struct deferred_split *queue)
> -{
> -	spin_unlock(&queue->split_queue_lock);
> -}
> -
> -static inline void split_queue_unlock_irqrestore(struct deferred_split *queue,
> -						 unsigned long flags)
> -{
> -	spin_unlock_irqrestore(&queue->split_queue_lock, flags);
> -}
> -

Lots of red, love to see it :)

>  static inline bool is_transparent_hugepage(const struct folio *folio)
>  {
>  	if (!folio_test_large(folio))
> @@ -1346,6 +1245,14 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
>  		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
>  		return NULL;
>  	}
> +
> +	if (folio_memcg_list_lru_alloc(folio, &deferred_split_lru, gfp)) {
> +		folio_put(folio);
> +		count_vm_event(THP_FAULT_FALLBACK);
> +		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
> +		return NULL;
> +	}
> +

As mentioned above, would be good to separate out into helper in mm/huge_memory.c.

>  	folio_throttle_swaprate(folio, gfp);
>
>         /*
> @@ -3854,34 +3761,34 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>  	struct folio *end_folio = folio_next(folio);
>  	struct folio *new_folio, *next;
>  	int old_order = folio_order(folio);
> +	struct list_lru_one *l;

Nit, and maybe this is a convention, but hate single letter variable names,
'lru' or something might be nicer?

> +	bool dequeue_deferred;
>  	int ret = 0;
> -	struct deferred_split *ds_queue;
>
>  	VM_WARN_ON_ONCE(!mapping && end);
>  	/* Prevent deferred_split_scan() touching ->_refcount */
> -	ds_queue = folio_split_queue_lock(folio);
> +	dequeue_deferred = folio_test_anon(folio) && old_order > 1;

Why anon? (This review is partly me learning about the shrinker, an area
I'm weak on :)

> +	if (dequeue_deferred) {
> +		rcu_read_lock();
> +		l = list_lru_lock(&deferred_split_lru,
> +				  folio_nid(folio), folio_memcg(folio));

Hm don't adore this sort of almost 'hidden' RCU lock here, but this
function is pretty disgusting and needs serious work in general.

And any function that took the RCU lock and list_lru lock/did the unlock
equivalent would be equally horrible so yeah, I guess needs deferring to a
refactor.

OTOH, this could be a good excuse for us to pay down some technical debt
and split out for instance the folio_ref_freeze() bits?

Could we do something like:

	bool frozen;

	...

	dequeue_deferred = folio_test_anon(folio) && old_order > 1;
	frozen = folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1);

	if (dequeue_deferred && frozen) {
		struct list_lru_one *lru;

		rcu_read_lock();
		lru = list_lru_lock(&deferred_split_lru,
				    folio_nid(folio), folio_memcg(folio));
		__list_lru_del(&deferred_split_lru, lru,
			       &folio->_deferred_list, folio_nid(folio));
		if (folio_test_partially_mapped(folio)) {
			folio_clear_partially_mapped(folio);
			mod_mthp_stat(old_order,
				MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
		}
		list_lru_unlock(lru);
		rcu_read_unlock();
	}

	if (!frozen)
		return -EAGAIN;

	... rest of logic now one indent level lower ...

Or maybe factor that out into a helper function or something?

static void execute_deferred_dequeue(...) { ... }

With this implemented either way you'd be able to get rid of the else block
too.

obviously only valid if you are able to do the freezing earlier?


> +	}
>  	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
>  		struct swap_cluster_info *ci = NULL;
>  		struct lruvec *lruvec;
>
> -		if (old_order > 1) {

Before was this also applicable to non-anon folios?

> -			if (!list_empty(&folio->_deferred_list)) {
> -				ds_queue->split_queue_len--;
> -				/*
> -				 * Reinitialize page_deferred_list after removing the
> -				 * page from the split_queue, otherwise a subsequent
> -				 * split will see list corruption when checking the
> -				 * page_deferred_list.
> -				 */
> -				list_del_init(&folio->_deferred_list);
> -			}
> +		if (dequeue_deferred) {
> +			__list_lru_del(&deferred_split_lru, l,
> +				       &folio->_deferred_list, folio_nid(folio));
>  			if (folio_test_partially_mapped(folio)) {
>  				folio_clear_partially_mapped(folio);
>  				mod_mthp_stat(old_order,
>  					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>  			}
> +			list_lru_unlock(l);
> +			rcu_read_unlock();
>  		}
> -		split_queue_unlock(ds_queue);
> +
>  		if (mapping) {
>  			int nr = folio_nr_pages(folio);
>
> @@ -3982,7 +3889,10 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>  		if (ci)
>  			swap_cluster_unlock(ci);
>  	} else {
> -		split_queue_unlock(ds_queue);
> +		if (dequeue_deferred) {
> +			list_lru_unlock(l);
> +			rcu_read_unlock();
> +		}
>  		return -EAGAIN;
>  	}
>
> @@ -4349,33 +4259,35 @@ int split_folio_to_list(struct folio *folio, struct list_head *list)
>   * queueing THP splits, and that list is (racily observed to be) non-empty.
>   *
>   * It is unsafe to call folio_unqueue_deferred_split() until folio refcount is
> - * zero: because even when split_queue_lock is held, a non-empty _deferred_list
> - * might be in use on deferred_split_scan()'s unlocked on-stack list.
> + * zero: because even when the list_lru lock is held, a non-empty
> + * _deferred_list might be in use on deferred_split_scan()'s unlocked
> + * on-stack list.
>   *
> - * If memory cgroups are enabled, split_queue_lock is in the mem_cgroup: it is
> - * therefore important to unqueue deferred split before changing folio memcg.
> + * The list_lru sublist is determined by folio's memcg: it is therefore
> + * important to unqueue deferred split before changing folio memcg.
>   */
>  bool __folio_unqueue_deferred_split(struct folio *folio)
>  {
> -	struct deferred_split *ds_queue;
> +	struct list_lru_one *l;

Again nitty thing about single letter var name, OTOH if that's somehow the
convention maybe fine. 'l' is especially problematic as it looks like a 1
in many fonts :)

> +	int nid = folio_nid(folio);
>  	unsigned long flags;
>  	bool unqueued = false;
>
>  	WARN_ON_ONCE(folio_ref_count(folio));
>  	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg_charged(folio));
>
> -	ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
> -	if (!list_empty(&folio->_deferred_list)) {
> -		ds_queue->split_queue_len--;
> +	rcu_read_lock();
> +	l = list_lru_lock_irqsave(&deferred_split_lru, nid, folio_memcg(folio), &flags);
> +	if (__list_lru_del(&deferred_split_lru, l, &folio->_deferred_list, nid)) {

Maybe worth factoring __list_lru_del() into something that explicitly
references &folio->_deferred_list rather than open codingin both places?

>  		if (folio_test_partially_mapped(folio)) {
>  			folio_clear_partially_mapped(folio);
>  			mod_mthp_stat(folio_order(folio),
>  				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>  		}
> -		list_del_init(&folio->_deferred_list);
>  		unqueued = true;
>  	}
> -	split_queue_unlock_irqrestore(ds_queue, flags);
> +	list_lru_unlock_irqrestore(l, &flags);
> +	rcu_read_unlock();
>
>  	return unqueued;	/* useful for debug warnings */
>  }
> @@ -4383,7 +4295,9 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
>  /* partially_mapped=false won't clear PG_partially_mapped folio flag */
>  void deferred_split_folio(struct folio *folio, bool partially_mapped)
>  {
> -	struct deferred_split *ds_queue;
> +	struct list_lru_one *l;
> +	int nid;
> +	struct mem_cgroup *memcg;
>  	unsigned long flags;
>
>  	/*
> @@ -4406,7 +4320,11 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
>  	if (folio_test_swapcache(folio))
>  		return;
>
> -	ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
> +	nid = folio_nid(folio);
> +
> +	rcu_read_lock();
> +	memcg = folio_memcg(folio);
> +	l = list_lru_lock_irqsave(&deferred_split_lru, nid, memcg, &flags);

Do we really need to hold the lock over all the below, but hmm we can't do
an irqsave/restore list_lru_add(), and maybe not worth adding one either,
OK.

Just seems odd to have <lock> <__unlocked_add_variant> <unlock>,
instinctively feels like it should be just <locked_add_variant>.

>  	if (partially_mapped) {
>  		if (!folio_test_partially_mapped(folio)) {
>  			folio_set_partially_mapped(folio);
> @@ -4414,36 +4332,20 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
>  				count_vm_event(THP_DEFERRED_SPLIT_PAGE);
>  			count_mthp_stat(folio_order(folio), MTHP_STAT_SPLIT_DEFERRED);
>  			mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, 1);
> -

Always nice to remove these annoying random newlines :)

>  		}
>  	} else {
>  		/* partially mapped folios cannot become non-partially mapped */
>  		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
>  	}
> -	if (list_empty(&folio->_deferred_list)) {
> -		struct mem_cgroup *memcg;
> -
> -		memcg = folio_split_queue_memcg(folio, ds_queue);
> -		list_add_tail(&folio->_deferred_list, &ds_queue->split_queue);
> -		ds_queue->split_queue_len++;
> -		if (memcg)
> -			set_shrinker_bit(memcg, folio_nid(folio),
> -					 shrinker_id(deferred_split_shrinker));
> -	}
> -	split_queue_unlock_irqrestore(ds_queue, flags);
> +	__list_lru_add(&deferred_split_lru, l, &folio->_deferred_list, nid, memcg);
> +	list_lru_unlock_irqrestore(l, &flags);
> +	rcu_read_unlock();
>  }
>
>  static unsigned long deferred_split_count(struct shrinker *shrink,
>  		struct shrink_control *sc)
>  {
> -	struct pglist_data *pgdata = NODE_DATA(sc->nid);
> -	struct deferred_split *ds_queue = &pgdata->deferred_split_queue;
> -
> -#ifdef CONFIG_MEMCG
> -	if (sc->memcg)
> -		ds_queue = &sc->memcg->deferred_split_queue;
> -#endif
> -	return READ_ONCE(ds_queue->split_queue_len);
> +	return list_lru_shrink_count(&deferred_split_lru, sc);

That's nice :)

>  }
>
>  static bool thp_underused(struct folio *folio)
> @@ -4473,45 +4375,47 @@ static bool thp_underused(struct folio *folio)
>  	return false;
>  }
>
> +static enum lru_status deferred_split_isolate(struct list_head *item,
> +					      struct list_lru_one *lru,
> +					      void *cb_arg)
> +{
> +	struct folio *folio = container_of(item, struct folio, _deferred_list);
> +	struct list_head *freeable = cb_arg;
> +
> +	if (folio_try_get(folio)) {
> +		list_lru_isolate_move(lru, item, freeable);
> +		return LRU_REMOVED;
> +	}
> +
> +	/* We lost race with folio_put() */

Hmm, in the original code, this comment is associated with the partially
mapped logic, BUT this seems actually correct, because folio_try_get()
because it does folio_ref_add_unless_zero() only fails if the folio lost
the race.

So I think you're more correct right?

> +	list_lru_isolate(lru, item);
> +	if (folio_test_partially_mapped(folio)) {
> +		folio_clear_partially_mapped(folio);
> +		mod_mthp_stat(folio_order(folio),
> +			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> +	}
> +	return LRU_REMOVED;
> +}
> +
>  static unsigned long deferred_split_scan(struct shrinker *shrink,
>  		struct shrink_control *sc)
>  {
> -	struct deferred_split *ds_queue;
> -	unsigned long flags;
> +	LIST_HEAD(dispose);
>  	struct folio *folio, *next;
> -	int split = 0, i;
> -	struct folio_batch fbatch;
> +	int split = 0;
> +	unsigned long isolated;
>
> -	folio_batch_init(&fbatch);
> +	isolated = list_lru_shrink_walk_irq(&deferred_split_lru, sc,
> +					    deferred_split_isolate, &dispose);
>
> -retry:
> -	ds_queue = split_queue_lock_irqsave(sc->nid, sc->memcg, &flags);
> -	/* Take pin on all head pages to avoid freeing them under us */
> -	list_for_each_entry_safe(folio, next, &ds_queue->split_queue,
> -							_deferred_list) {
> -		if (folio_try_get(folio)) {
> -			folio_batch_add(&fbatch, folio);
> -		} else if (folio_test_partially_mapped(folio)) {
> -			/* We lost race with folio_put() */
> -			folio_clear_partially_mapped(folio);
> -			mod_mthp_stat(folio_order(folio),
> -				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> -		}
> -		list_del_init(&folio->_deferred_list);
> -		ds_queue->split_queue_len--;
> -		if (!--sc->nr_to_scan)
> -			break;
> -		if (!folio_batch_space(&fbatch))
> -			break;
> -	}
> -	split_queue_unlock_irqrestore(ds_queue, flags);
> -
> -	for (i = 0; i < folio_batch_count(&fbatch); i++) {
> +	list_for_each_entry_safe(folio, next, &dispose, _deferred_list) {
>  		bool did_split = false;
>  		bool underused = false;
> -		struct deferred_split *fqueue;
> +		struct list_lru_one *l;
> +		unsigned long flags;
> +
> +		list_del_init(&folio->_deferred_list);
>
> -		folio = fbatch.folios[i];
>  		if (!folio_test_partially_mapped(folio)) {
>  			/*
>  			 * See try_to_map_unused_to_zeropage(): we cannot
> @@ -4534,64 +4438,32 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>  		}
>  		folio_unlock(folio);
>  next:
> -		if (did_split || !folio_test_partially_mapped(folio))
> -			continue;
>  		/*
>  		 * Only add back to the queue if folio is partially mapped.
>  		 * If thp_underused returns false, or if split_folio fails
>  		 * in the case it was underused, then consider it used and
>  		 * don't add it back to split_queue.
>  		 */
> -		fqueue = folio_split_queue_lock_irqsave(folio, &flags);
> -		if (list_empty(&folio->_deferred_list)) {
> -			list_add_tail(&folio->_deferred_list, &fqueue->split_queue);
> -			fqueue->split_queue_len++;
> +		if (!did_split && folio_test_partially_mapped(folio)) {
> +			rcu_read_lock();
> +			l = list_lru_lock_irqsave(&deferred_split_lru,
> +						  folio_nid(folio),
> +						  folio_memcg(folio),
> +						  &flags);
> +			__list_lru_add(&deferred_split_lru, l,
> +				       &folio->_deferred_list,
> +				       folio_nid(folio), folio_memcg(folio));
> +			list_lru_unlock_irqrestore(l, &flags);

Hmm this does make me think it'd be nice to have a list_lru_add() variant
for irqsave/restore then, since it's a repeating pattern!

> +			rcu_read_unlock();
>  		}
> -		split_queue_unlock_irqrestore(fqueue, flags);
> -	}
> -	folios_put(&fbatch);
> -
> -	if (sc->nr_to_scan && !list_empty(&ds_queue->split_queue)) {
> -		cond_resched();
> -		goto retry;
> +		folio_put(folio);
>  	}
>
> -	/*
> -	 * Stop shrinker if we didn't split any page, but the queue is empty.
> -	 * This can happen if pages were freed under us.
> -	 */
> -	if (!split && list_empty(&ds_queue->split_queue))
> +	if (!split && !isolated)
>  		return SHRINK_STOP;
>  	return split;
>  }
>
> -#ifdef CONFIG_MEMCG
> -void reparent_deferred_split_queue(struct mem_cgroup *memcg)
> -{
> -	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
> -	struct deferred_split *ds_queue = &memcg->deferred_split_queue;
> -	struct deferred_split *parent_ds_queue = &parent->deferred_split_queue;
> -	int nid;
> -
> -	spin_lock_irq(&ds_queue->split_queue_lock);
> -	spin_lock_nested(&parent_ds_queue->split_queue_lock, SINGLE_DEPTH_NESTING);
> -
> -	if (!ds_queue->split_queue_len)
> -		goto unlock;
> -
> -	list_splice_tail_init(&ds_queue->split_queue, &parent_ds_queue->split_queue);
> -	parent_ds_queue->split_queue_len += ds_queue->split_queue_len;
> -	ds_queue->split_queue_len = 0;
> -
> -	for_each_node(nid)
> -		set_shrinker_bit(parent, nid, shrinker_id(deferred_split_shrinker));
> -
> -unlock:
> -	spin_unlock(&parent_ds_queue->split_queue_lock);
> -	spin_unlock_irq(&ds_queue->split_queue_lock);
> -}
> -#endif
> -
>  #ifdef CONFIG_DEBUG_FS
>  static void split_huge_pages_all(void)
>  {
> diff --git a/mm/internal.h b/mm/internal.h
> index f98f4746ac41..d8c737338df5 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -863,7 +863,7 @@ static inline bool folio_unqueue_deferred_split(struct folio *folio)
>  	/*
>  	 * At this point, there is no one trying to add the folio to
>  	 * deferred_list. If folio is not in deferred_list, it's safe
> -	 * to check without acquiring the split_queue_lock.
> +	 * to check without acquiring the list_lru lock.
>  	 */
>  	if (data_race(list_empty(&folio->_deferred_list)))
>  		return false;
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 4b0e59c7c0e6..b2ac28ddd480 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1081,6 +1081,7 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
>  	}
>
>  	count_vm_event(THP_COLLAPSE_ALLOC);
> +
>  	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
>  		folio_put(folio);
>  		*foliop = NULL;
> @@ -1089,6 +1090,12 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
>
>  	count_memcg_folio_events(folio, THP_COLLAPSE_ALLOC, 1);

Do we want to put this stat counter underneath the below so it's not
incremented on fail?

>
> +	if (folio_memcg_list_lru_alloc(folio, &deferred_split_lru, gfp)) {
> +		folio_put(folio);
> +		*foliop = NULL;
> +		return SCAN_CGROUP_CHARGE_FAIL;

Do we not need to uncharge here?

> +	}
> +
>  	*foliop = folio;
>  	return SCAN_SUCCEED;
>  }
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a47fb68dd65f..f381cb6bdff1 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4015,11 +4015,6 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
>  	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
>  		memcg->cgwb_frn[i].done =
>  			__WB_COMPLETION_INIT(&memcg_cgwb_frn_waitq);
> -#endif
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	spin_lock_init(&memcg->deferred_split_queue.split_queue_lock);
> -	INIT_LIST_HEAD(&memcg->deferred_split_queue.split_queue);
> -	memcg->deferred_split_queue.split_queue_len = 0;
>  #endif
>  	lru_gen_init_memcg(memcg);
>  	return memcg;
> @@ -4167,11 +4162,10 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
>  	zswap_memcg_offline_cleanup(memcg);
>
>  	memcg_offline_kmem(memcg);
> -	reparent_deferred_split_queue(memcg);
>  	/*
> -	 * The reparenting of objcg must be after the reparenting of the
> -	 * list_lru and deferred_split_queue above, which ensures that they will
> -	 * not mistakenly get the parent list_lru and deferred_split_queue.
> +	 * The reparenting of objcg must be after the reparenting of
> +	 * the list_lru in memcg_offline_kmem(), which ensures that
> +	 * they will not mistakenly get the parent list_lru.
>  	 */
>  	memcg_reparent_objcgs(memcg);
>  	reparent_shrinker_deferred(memcg);
> diff --git a/mm/memory.c b/mm/memory.c
> index 219b9bf6cae0..e68ceb4aa624 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4651,13 +4651,19 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>  	while (orders) {
>  		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
>  		folio = vma_alloc_folio(gfp, order, vma, addr);
> -		if (folio) {
> -			if (!mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
> -							    gfp, entry))
> -				return folio;
> +		if (!folio)
> +			goto next;
> +		if (mem_cgroup_swapin_charge_folio(folio, vma->vm_mm, gfp, entry)) {
>  			count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK_CHARGE);
>  			folio_put(folio);
> +			goto next;
>  		}
> +		if (folio_memcg_list_lru_alloc(folio, &deferred_split_lru, gfp)) {

Do we need to uncharge here?

> +			folio_put(folio);
> +			goto fallback;
> +		}
> +		return folio;
> +next:
>  		count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK);
>  		order = next_order(&orders, order);
>  	}
> @@ -5169,24 +5175,28 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
>  	while (orders) {
>  		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
>  		folio = vma_alloc_folio(gfp, order, vma, addr);
> -		if (folio) {
> -			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
> -				count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
> -				folio_put(folio);
> -				goto next;
> -			}
> -			folio_throttle_swaprate(folio, gfp);
> -			/*
> -			 * When a folio is not zeroed during allocation
> -			 * (__GFP_ZERO not used) or user folios require special
> -			 * handling, folio_zero_user() is used to make sure
> -			 * that the page corresponding to the faulting address
> -			 * will be hot in the cache after zeroing.
> -			 */
> -			if (user_alloc_needs_zeroing())
> -				folio_zero_user(folio, vmf->address);
> -			return folio;
> +		if (!folio)
> +			goto next;

This applies to the above equivalent refactorings, but maybe worth
separating out this:

if (folio) { ... big branch ... } ->
if (!folio) goto next; ... what was big branch ...

Refactoring into a separate patch? Makes it easier to see pertinent logic
changes + helps review/bisectability/fixes/etc. etc.


> +		if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
> +			count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
> +			folio_put(folio);
> +			goto next;
>  		}
> +		if (folio_memcg_list_lru_alloc(folio, &deferred_split_lru, gfp)) {

Again, do we need to uncharge here?

> +			folio_put(folio);
> +			goto fallback;
> +		}
> +		folio_throttle_swaprate(folio, gfp);
> +		/*
> +		 * When a folio is not zeroed during allocation
> +		 * (__GFP_ZERO not used) or user folios require special
> +		 * handling, folio_zero_user() is used to make sure
> +		 * that the page corresponding to the faulting address
> +		 * will be hot in the cache after zeroing.
> +		 */
> +		if (user_alloc_needs_zeroing())
> +			folio_zero_user(folio, vmf->address);
> +		return folio;
>  next:
>  		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
>  		order = next_order(&orders, order);
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index cec7bb758bdd..f293a62e652a 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1388,19 +1388,6 @@ static void __init calculate_node_totalpages(struct pglist_data *pgdat,
>  	pr_debug("On node %d totalpages: %lu\n", pgdat->node_id, realtotalpages);
>  }
>
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -static void pgdat_init_split_queue(struct pglist_data *pgdat)
> -{
> -	struct deferred_split *ds_queue = &pgdat->deferred_split_queue;
> -
> -	spin_lock_init(&ds_queue->split_queue_lock);
> -	INIT_LIST_HEAD(&ds_queue->split_queue);
> -	ds_queue->split_queue_len = 0;
> -}
> -#else
> -static void pgdat_init_split_queue(struct pglist_data *pgdat) {}
> -#endif
> -
>  #ifdef CONFIG_COMPACTION
>  static void pgdat_init_kcompactd(struct pglist_data *pgdat)
>  {
> @@ -1416,8 +1403,6 @@ static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
>
>  	pgdat_resize_init(pgdat);
>  	pgdat_kswapd_lock_init(pgdat);
> -
> -	pgdat_init_split_queue(pgdat);
>  	pgdat_init_kcompactd(pgdat);
>
>  	init_waitqueue_head(&pgdat->kswapd_wait);
> --
> 2.53.0
>

Overall a lovely amount of code deletion here :)

Thanks for doing this, Cheers Lorenzo

