Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AAC31076387
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 17:33:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 838966B0005; Wed,  1 Apr 2026 13:33:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80F166B0088; Wed,  1 Apr 2026 13:33:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 726036B0089; Wed,  1 Apr 2026 13:33:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 612096B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:33:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0724E1A017D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:33:10 +0000 (UTC)
X-FDA: 84610682940.21.635B734
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id DDD00140019
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:33:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pa1khK1j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775064788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ronOSmoSJdDkkS2OtRbsZ5sq5u1IqlwG5XpYhAg+T20=;
	b=dkBTCqZ+L+pjWpsiR+VjVVODbfsXGO2Ae/pVbCy6rk4uwPUXOPXCvCouAqmdiixylhmmr1
	WlJCkEuDVQvZ+aCM9TZPtxxkz9BE5OtKZ5dKmsBT09gylOuqE4Jpw2GuB/ntxhC3uEO7+r
	uYjvs9L6JFT/LAErgQVmklF1XeSr9/0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775064788; a=rsa-sha256;
	cv=none;
	b=GmZhv3THRvmWdLha+/bMD3djVT0ab95VeuLoCNB64jWPkidyZNFWFUWXnbRFIdBOG6UWmY
	JwcJDOF0YHEvU7WN32Kb0NgIa3buh+aKUv9q9ta5D7KuhyUzdhOAVMEDdFRUxayXVo1/TY
	RvC0Lw3xK3Zi9z5FYt6TzXh5pFC5Kac=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pa1khK1j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CA979436F0;
	Wed,  1 Apr 2026 17:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7E7C4CEF7;
	Wed,  1 Apr 2026 17:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775064786;
	bh=Ft0ZGWvwaRe8vjzKCBRNJ4Ep4RcJtw9gG4cZdXpAeoo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pa1khK1jrd+UjHl2lyj5pMF3EXuI408XXjyPoKeGj6GTEY0cbzuaVGelOvXeGYINb
	 dN3/omAjaNvT4qjlWOZSsDQduOMWze0fSMxIp9l+oES8b+jBdwsHHJxzF6Fo2RuQVL
	 cvurJQowf2EKFJSPuR6Uy9uwY0XMmqg2gtEOl23hipwqAxX5nvxszYjYyL0HsCi6tm
	 TWRMZiFbkZwNPnk68XhiZ3wcEXWHimqL5EDxsK54pkhfeVZogrtMwpGleb6heXcZji
	 AR9xGkgPKGVRodz08f4smCELOLf3yUwutzPvBLNMqmWvUtG5NdzMF5819rVPxnUKBt
	 WkzVRrE0Ehqfw==
Date: Wed, 1 Apr 2026 18:33:04 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/7] mm: switch deferred split shrinker to list_lru
Message-ID: <a87fdbf4-8e30-465f-b3bd-9ed3ba97c684@lucifer.local>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-8-hannes@cmpxchg.org>
 <0cf8a859-b142-4e53-9113-94872dd68f40@lucifer.local>
 <acqndkLvpRI9bgRK@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acqndkLvpRI9bgRK@cmpxchg.org>
X-Rspamd-Queue-Id: DDD00140019
X-Stat-Signature: 3jhrepoazj5qhhnk7iry8c9mkgirxfdr
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775064787-579008
X-HE-Meta: U2FsdGVkX1+EAMOdhtA0ucnfYvdu2EByE/smcULghaudQwzC9Q7kRqnf6thx/Vjd9mGopMo7K+b/o6qpc02EotvtQGZ11UKRbh44B3/JrCTzqlvS+O05GU7Ld/NK6PEFl0vUCNXMROC52SrzcAJc9R9DoTHZBc4tg3baYgMEo9MQzDee2jOa11OSuOFFjO1gkghU92RzrwT5+3iJHW8f2srLzx7lUGqmER0JTJUYYvyU4YBi1tjv5uY3ZvhJGL4Vr/YqBCzIZyPKCzxNRKivTNKLtEm1rE89K40X6tuV//iQc4rzbIZJgSE407rC9/k3K+syOMaHBQln2zkMFC/KzpmttcFRzXLxuw6Uky4DR4Mi8jouGlVoWzMC7pdHsTp2xrPX/irQosXzNN8UuM2wXq87oL4vhnj5ZRYCfDU3C1LvLB8tJQXBBW27YvyrFp/o4iPu1PkLuz0nZqNw9BIPtqcgSHawccIXh+KlaQrz3XJAeCeQqiiuqjrM09s9k7wpGaialGpHhq5g4ojBSzfpKSGywDfPAmESscWbPCpsgmasN8CZlLHF6X2KWBI7AZ/syj66RNoVvC5suIW0TkIjwbfXvp4N9LgzwxBvu+wX5Eyk1kVoKqZ2iQtl4/btJEziIWonZRFKrsLR0TqXYS3bcd21LoYgMZ20Jsv5CbB6Hbg/x0O7K5XYGG3pJLWhZVNsvpvalt3QNvcux95BMSyqm9OD/tymmefdxeAI3NPdFmH/XOsrAoIZiU3myhFaP1LSGt57qDjLMOE7X0YXyT7RHZHr1djuELdGRlC3HF4mMiKd4jkZW2bfCbExWq1R/JVfJRSpb9Snq8N2syNgr5bKBgscQmVfJpbSdDDbns0a6T7o+PTp85L/NPDCcpWngCHwk4fEn9gv81b0zUnNiCoidlry2vejEfEvdAf6tyLP/p078PWKhpaKdYetrqVDBYg7WufAwO99wxf/hJ2wvVf
 7Gki4Scb
 H5trFxlcO+Ovgd7WPpyMjENO4z4XMXELgB658vH7QMRSIqhiv3lLZcDQhL9S/SmpdNhMOrr1vcNNElyuDCQ3pLlMhpH+S9DFAtlBEL3oLGGqPQ4DQFtr9b10evSK8IPLg4oWB/zXjkJ5/OTRUg4fmUpHxNKMmVRSfPYGHWZFm9Hj34m6/whqCcxrtaIeSLu8h+x44zePTVOdo5qaLkwvuIUDIaMFk2pT96R9pqyeNVaV6kCEhNAofmZ2IuXxW8QlZmBrqZDa1rKKwkiY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 12:40:22PM -0400, Johannes Weiner wrote:
> Hey Lorenzo,
>
> Thanks for taking an in-depth look at this!
>
> Apologies for the late reply, I was traveling last week.
>
> On Tue, Mar 24, 2026 at 01:48:06PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > On Wed, Mar 18, 2026 at 03:53:25PM -0400, Johannes Weiner wrote:
> > > The deferred split queue handles cgroups in a suboptimal fashion. The
> > > queue is per-NUMA node or per-cgroup, not the intersection. That means
> > > on a cgrouped system, a node-restricted allocation entering reclaim
> > > can end up splitting large pages on other nodes:
> > >
> > > 	alloc/unmap
> > > 	  deferred_split_folio()
> > > 	    list_add_tail(memcg->split_queue)
> > > 	    set_shrinker_bit(memcg, node, deferred_shrinker_id)
> >
> > So here it's:
> >
> > __do_huge_pmd_anonymous_page() / do_huge_zero_wp_pmd()
> > -> map_anon_folio_pmd_pf()
> > -> map_anon_folio_pmd_nopf()
> > -> deferred_split_folio()
> > -> set_shrinker_bit()
> >
> > Yeah it makes sense to make the first bit succinct anyway :)
>
> Yep I was trying to keep the focus on those parts that interact with
> the other stacks listed below. Not biblically accurate
> deferred_split_folio() callsites ;)
>
> > > 	for_each_zone_zonelist_nodemask(restricted_nodes)
> > > 	  mem_cgroup_iter()
> > > 	    shrink_slab(node, memcg)
> > > 	      shrink_slab_memcg(node, memcg)
> > > 	        if test_shrinker_bit(memcg, node, deferred_shrinker_id)
> >
> > Hmm there's no such function is this kind of pseudocode, essentially?
> >
> > Wouldn't it be clearer to reference:
> >
> > shrink_slab_memcg() -> do_shrink_slab() -> shrinker->scan_objects ->
> > deferred_split_scan()?
> >
> > Though I get that it adds verbosity :)
> >
> > Sorry not (just) being pedantic here, also so I can understand myself :)
>
> Yes, it's pseudocode. Direct reclaim (shrink_zones) and kswapd
> (wake_all_kswapds) do the "for all nodes" loops. Nested within them
> are the loops that iterate the cgroup tree (shrink_node_memcgs,
> shrink_many, depending on LRU vs MGLRU). And then nested within
> *those* we have the shrink_slab() calls.
>
> Again, I tried to keep the boiler plate low and to the point. The most
> important thing is: 1) the shrinker bit gets set for each node, memcg
> pair that has objects, 2) shrinker visits all nodes x memcgs with it
> set 3) but the shrinker scans happen on per-memcg queue, not node-aware.
>
> Let me know if that works as is, or if you would like me to rephrase
> that. I would like to keep it as simple as possible, but no simpler
> than that ;)

Yeah that's fine, maybe just add a little note to say 'simplified for clarity'
or something so very-literal nutters like me don't get confused ;)

>
> > > 	          deferred_split_scan()
> > > 	            walks memcg->split_queue
> >
> > Ok so overall there's a per-memcg memcg->split_queue, but we set a bit in
> > memcg->nodeinfo[nid]->shrinker_info->unit[blah]->map for it, and when we
> > enter shrink_slab_memcg(), we figure out the shrink_control from the
> > for_each_set_bit() across memcg->...->unit->map?
> >
> > > The shrinker bit adds an imperfect guard rail. As soon as the cgroup
> > > has a single large page on the node of interest, all large pages owned
> > > by that memcg, including those on other nodes, will be split.
> >
> > So at this point, regardless of node, we are invoking deferred_split_scan()
> > and it's the same memcg->split_queue we are walking, regardless of node?
> >
> > Do let me know if my understanding is correct here!
> >
> > Hmm that does sound sub-optimal.
>
> That is exactly what's happening. We have all this dance to be precise
> about the shrinker bit, but the queue itself is not node-aware.
>
> That makes for some pretty erratic behavior.

Yeah that sucks!

>
> > > list_lru properly sets up per-node, per-cgroup lists. As a bonus, it
> > > streamlines a lot of the list operations and reclaim walks. It's used
> > > widely by other major shrinkers already. Convert the deferred split
> > > queue as well.
> >
> > It's odd that it wasn't used before?
>
> The list_lru API was initially explicitly for *slab objects*, doing
> virt_to_page() and mem_cgroup_from_slab_obj() on the passed in list
> heads to derive the proper queue. It was only extended more recently
> in 0a97c01cd20b ("list_lru: allow explicit memcg and NUMA node
> selection") to allow passing in the queue routing information and
> embedding the list heads in other things (such as folios).
>
> The only missing piece now was the support for callside locking of the
> list_lru structures.

Ack

>
> > >  include/linux/huge_mm.h    |   6 +-
> > >  include/linux/memcontrol.h |   4 -
> > >  include/linux/mmzone.h     |  12 --
> > >  mm/huge_memory.c           | 342 ++++++++++++-------------------------
> > >  mm/internal.h              |   2 +-
> > >  mm/khugepaged.c            |   7 +
> > >  mm/memcontrol.c            |  12 +-
> > >  mm/memory.c                |  52 +++---
> > >  mm/mm_init.c               |  15 --
> > >  9 files changed, 151 insertions(+), 301 deletions(-)
> > >
> > > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > > index bd7f0e1d8094..8d801ed378db 100644
> > > --- a/include/linux/huge_mm.h
> > > +++ b/include/linux/huge_mm.h
> > > @@ -414,10 +414,9 @@ static inline int split_huge_page(struct page *page)
> > >  {
> > >  	return split_huge_page_to_list_to_order(page, NULL, 0);
> > >  }
> > > +
> > > +extern struct list_lru deferred_split_lru;
> >
> > It might be nice for the sake of avoiding a global to instead expose this
> > as a getter?
> >
> > Or actually better, since every caller outside of huge_memory.c that
> > references this uses folio_memcg_list_lru_alloc(), do something like:
> >
> > int folio_memcg_alloc_deferred(struct folio *folio, gfp_t gfp);
> >
> > in mm/huge_memory.c:
> >
> > /**
> >  * blah blah blah put on error blah
> >  */
> > int folio_memcg_alloc_deferred(struct folio *folio, gfp_t gfp)
> > {
> > 	int err;
> >
> > 	err = folio_memcg_list_lru_alloc(folio, &deferred_split_lru, gfP);
> > 	if (err) {
> > 		folio_put(folio);
> > 		return err;
> > 	}
> >
> > 	return 0;
> > }
> >
> > And then the callers can just invoke this, and you can make
> > deferred_split_lru static in mm/huge_memory.c?
>
> That sounds reasonable. Let me make this change.

Thanks!

>
> > >  void deferred_split_folio(struct folio *folio, bool partially_mapped);
> > > -#ifdef CONFIG_MEMCG
> > > -void reparent_deferred_split_queue(struct mem_cgroup *memcg);
> > > -#endif
> > >
> > >  void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
> > >  		unsigned long address, bool freeze);
> > > @@ -650,7 +649,6 @@ static inline int try_folio_split_to_order(struct folio *folio,
> > >  }
> > >
> > >  static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
> > > -static inline void reparent_deferred_split_queue(struct mem_cgroup *memcg) {}
> > >  #define split_huge_pmd(__vma, __pmd, __address)	\
> > >  	do { } while (0)
> > >
> > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > index 086158969529..0782c72a1997 100644
> > > --- a/include/linux/memcontrol.h
> > > +++ b/include/linux/memcontrol.h
> > > @@ -277,10 +277,6 @@ struct mem_cgroup {
> > >  	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
> > >  #endif
> > >
> > > -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > > -	struct deferred_split deferred_split_queue;
> > > -#endif
> > > -
> > >  #ifdef CONFIG_LRU_GEN_WALKS_MMU
> > >  	/* per-memcg mm_struct list */
> > >  	struct lru_gen_mm_list mm_list;
> > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > index 7bd0134c241c..232b7a71fd69 100644
> > > --- a/include/linux/mmzone.h
> > > +++ b/include/linux/mmzone.h
> > > @@ -1429,14 +1429,6 @@ struct zonelist {
> > >   */
> > >  extern struct page *mem_map;
> > >
> > > -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > > -struct deferred_split {
> > > -	spinlock_t split_queue_lock;
> > > -	struct list_head split_queue;
> > > -	unsigned long split_queue_len;
> > > -};
> > > -#endif
> > > -
> > >  #ifdef CONFIG_MEMORY_FAILURE
> > >  /*
> > >   * Per NUMA node memory failure handling statistics.
> > > @@ -1562,10 +1554,6 @@ typedef struct pglist_data {
> > >  	unsigned long first_deferred_pfn;
> > >  #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
> > >
> > > -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > > -	struct deferred_split deferred_split_queue;
> > > -#endif
> > > -
> > >  #ifdef CONFIG_NUMA_BALANCING
> > >  	/* start time in ms of current promote rate limit period */
> > >  	unsigned int nbp_rl_start;
> > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > > index 3fc02913b63e..e90d08db219d 100644
> > > --- a/mm/huge_memory.c
> > > +++ b/mm/huge_memory.c
> > > @@ -14,6 +14,7 @@
> > >  #include <linux/mmu_notifier.h>
> > >  #include <linux/rmap.h>
> > >  #include <linux/swap.h>
> > > +#include <linux/list_lru.h>
> > >  #include <linux/shrinker.h>
> > >  #include <linux/mm_inline.h>
> > >  #include <linux/swapops.h>
> > > @@ -67,6 +68,8 @@ unsigned long transparent_hugepage_flags __read_mostly =
> > >  	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG)|
> > >  	(1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
> > >
> > > +static struct lock_class_key deferred_split_key;
> > > +struct list_lru deferred_split_lru;
> > >  static struct shrinker *deferred_split_shrinker;
> > >  static unsigned long deferred_split_count(struct shrinker *shrink,
> > >  					  struct shrink_control *sc);
> > > @@ -919,6 +922,13 @@ static int __init thp_shrinker_init(void)
> > >  	if (!deferred_split_shrinker)
> > >  		return -ENOMEM;
> > >
> > > +	if (list_lru_init_memcg_key(&deferred_split_lru,
> > > +				    deferred_split_shrinker,
> > > +				    &deferred_split_key)) {
> > > +		shrinker_free(deferred_split_shrinker);
> > > +		return -ENOMEM;
> > > +	}
> > > +
> >
> > It's kind of out of scope for the series, but I hate that the huge zero
> > folio stuff has an early exit for persistent but if not, falls through to
> > trying to set that up - it'd be nice to split out the huge zero folio stuff
> > into another function.
> >
> > But probably one for a follow up!
>
> It doesn't bother me personally, but I wouldn't object to it being
> moved to its own function and have the caller do necessary cleanups.
>
> But yeah sounds like an unrelated refactor :)

Yeah it is entirely unrelated for sure, can be an optional follow up!

>
> > >  	deferred_split_shrinker->count_objects = deferred_split_count;
> > >  	deferred_split_shrinker->scan_objects = deferred_split_scan;
> > >  	shrinker_register(deferred_split_shrinker);
> > > @@ -939,6 +949,7 @@ static int __init thp_shrinker_init(void)
> > >
> > >  	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
> > >  	if (!huge_zero_folio_shrinker) {
> > > +		list_lru_destroy(&deferred_split_lru);
> > >  		shrinker_free(deferred_split_shrinker);
> >
> > Presumably no probably-impossible-in-reality race on somebody entering the
> > shrinker and referencing the deferred_split_lru before the shrinker is freed?
>
> Ah right, I think for clarity it would indeed be better to destroy the
> shrinker, then the queue. Let me re-order this one.
>
> But yes, in practice, none of the above fails. If we have trouble
> doing a couple of small kmallocs during a subsys_initcall(), that
> machine is unlikely to finish booting, let alone allocate enough
> memory to enter the THP shrinker.

Yeah I thought that might be the case, but seems more logical killing shrinker
first, thanks!

>
> > > @@ -953,6 +964,7 @@ static int __init thp_shrinker_init(void)
> > >  static void __init thp_shrinker_exit(void)
> > >  {
> > >  	shrinker_free(huge_zero_folio_shrinker);
> > > +	list_lru_destroy(&deferred_split_lru);
> >
> > Same question above as to race/ordering.
>
> ... and this one as well.
>
> > >  	shrinker_free(deferred_split_shrinker);
> > >  }
>
> > > @@ -3854,34 +3761,34 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
> > >  	struct folio *end_folio = folio_next(folio);
> > >  	struct folio *new_folio, *next;
> > >  	int old_order = folio_order(folio);
> > > +	struct list_lru_one *l;
> >
> > Nit, and maybe this is a convention, but hate single letter variable names,
> > 'lru' or something might be nicer?
>
> Yeah I stuck with the list_lru internal naming, which uses `lru` for
> the struct list_lru, and `l` for struct list_lru_one. I suppose that
> was fine for the very domain-specific code and short functions in
> there, but it's grating in large, general MM functions like these.
>
> Since `lru` is taken, any preferences? llo?

ljs? ;)

Could be list?

>
> > > +	bool dequeue_deferred;
> > >  	int ret = 0;
> > > -	struct deferred_split *ds_queue;
> > >
> > >  	VM_WARN_ON_ONCE(!mapping && end);
> > >  	/* Prevent deferred_split_scan() touching ->_refcount */
> > > -	ds_queue = folio_split_queue_lock(folio);
> > > +	dequeue_deferred = folio_test_anon(folio) && old_order > 1;
> >
> > Why anon? (This review is partly me learning about the shrinker, an area
> > I'm weak on :)
>
> This is the type of folios that can be queued through
> deferred_split_folio(). The order check is inside that function
> itself; and the function is only called for anon pages.
>
> File pages are split differently, they don't use the deferred split
> shrinker and we don't allocate list_lru heads for them. However, they
> still come through this split path here, and so I need to gate whether
> it's safe to do list_lru_lock(), __list_lru_del() etc.
>
> > > +	if (dequeue_deferred) {
> > > +		rcu_read_lock();
> > > +		l = list_lru_lock(&deferred_split_lru,
> > > +				  folio_nid(folio), folio_memcg(folio));
> >
> > Hm don't adore this sort of almost 'hidden' RCU lock here, but this
> > function is pretty disgusting and needs serious work in general.
> >
> > And any function that took the RCU lock and list_lru lock/did the unlock
> > equivalent would be equally horrible so yeah, I guess needs deferring to a
> > refactor.
> >
> > OTOH, this could be a good excuse for us to pay down some technical debt
> > and split out for instance the folio_ref_freeze() bits?
> >
> > Could we do something like:
> >
> > 	bool frozen;
> >
> > 	...
> >
> > 	dequeue_deferred = folio_test_anon(folio) && old_order > 1;
> > 	frozen = folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1);
> >
> > 	if (dequeue_deferred && frozen) {
> > 		struct list_lru_one *lru;
> >
> > 		rcu_read_lock();
> > 		lru = list_lru_lock(&deferred_split_lru,
> > 				    folio_nid(folio), folio_memcg(folio));
> > 		__list_lru_del(&deferred_split_lru, lru,
> > 			       &folio->_deferred_list, folio_nid(folio));
> > 		if (folio_test_partially_mapped(folio)) {
> > 			folio_clear_partially_mapped(folio);
> > 			mod_mthp_stat(old_order,
> > 				MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> > 		}
> > 		list_lru_unlock(lru);
> > 		rcu_read_unlock();
> > 	}
> >
> > 	if (!frozen)
> > 		return -EAGAIN;
> >
> > 	... rest of logic now one indent level lower ...
> >
> > Or maybe factor that out into a helper function or something?
> >
> > static void execute_deferred_dequeue(...) { ... }
> >
> > With this implemented either way you'd be able to get rid of the else block
> > too.
> >
> > obviously only valid if you are able to do the freezing earlier?
>
> The reason it locks the list_lru first is because there can be a race
> between the shrinker and a synchronous split attempt.

Ahh!

>
> This is what that comment above it is about:
>
> 	/* Prevent deferred_split_scan() touching ->_refcount */

I _may_ have glossed over this :)

>
> If the shrinker fails to "get" the folio while holding the shrinker
> lock, it thinks it beat the free path to the list_lru lock and will
> feel responsible for cleaning up the deferred split state:
>
> /* caller holds the list_lru lock already */
> static enum lru_status deferred_split_isolate(struct list_head *item,
> 					      struct list_lru_one *lru,
> 					      void *cb_arg)
> {
> 	struct folio *folio = container_of(item, struct folio, _deferred_list);
> 	struct list_head *freeable = cb_arg;
>
> 	if (folio_try_get(folio)) {
> 		list_lru_isolate_move(lru, item, freeable);
> 		return LRU_REMOVED;
> 	}
>
> 	/* We lost race with folio_put() */
> 	list_lru_isolate(lru, item);
> 	if (folio_test_partially_mapped(folio)) {
> 		folio_clear_partially_mapped(folio);
> 		mod_mthp_stat(folio_order(folio),
> 			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> 	}
> 	return LRU_REMOVED;
> }
>
> So if the split path freezes before acquiring the list_lru lock, we
> get them both stepping on the deferred split state.

So we're sort of intentionally doing a lock inversion on the other path (give me
some rope here, I mean broadly speaking :) to avoid this?

>
> This may or may not be safe given the current manifestation of
> list_lru_del() and the folio_test_partially_mapped() tests. But it
> feels pretty hairy to let them race and rely on individual tests into
> what should be a coherent aggregate state.

Yeah sure best not.

But, and I _know_ it's nitty sorry, but maybe worth expanding that comment to
explain that e.g. 'we must take the folio look prior to the list_lru lock to
avoid racing with deferred_split_scan() in accessing the folio reference count'
or similar?

>
> > > +	}
> > >  	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
> > >  		struct swap_cluster_info *ci = NULL;
> > >  		struct lruvec *lruvec;
> > >
> > > -		if (old_order > 1) {
> >
> > Before was this also applicable to non-anon folios?
>
> This branch, yes. But non-anon pages would then fail this:
>
> > > -			if (!list_empty(&folio->_deferred_list)) {
> > > -				ds_queue->split_queue_len--;
> > > -				/*
> > > -				 * Reinitialize page_deferred_list after removing the
> > > -				 * page from the split_queue, otherwise a subsequent
> > > -				 * split will see list corruption when checking the
> > > -				 * page_deferred_list.
> > > -				 */
> > > -				list_del_init(&folio->_deferred_list);
> > > -			}
>
> ..since they aren't ever added. This was okay because accessing that
> list head is always safe. Now I need to be explicit to determine if
> it's safe to call __list_lru_del() which does all these list_lru
> references, which aren't allocated for file.
>
> > > +		if (dequeue_deferred) {
> > > +			__list_lru_del(&deferred_split_lru, l,
> > > +				       &folio->_deferred_list, folio_nid(folio));
> > >  			if (folio_test_partially_mapped(folio)) {
> > >  				folio_clear_partially_mapped(folio);
> > >  				mod_mthp_stat(old_order,
> > >  					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> > >  			}
>
> And honestly, I think it's nicer to be explicit here about the
> expectations of which pages get which treatment.

Yeah for sure.

>
> Filtering file pages on !list_empty() was not very obvious.

Yes :)

>
> > > +	int nid = folio_nid(folio);
> > >  	unsigned long flags;
> > >  	bool unqueued = false;
> > >
> > >  	WARN_ON_ONCE(folio_ref_count(folio));
> > >  	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg_charged(folio));
> > >
> > > -	ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
> > > -	if (!list_empty(&folio->_deferred_list)) {
> > > -		ds_queue->split_queue_len--;
> > > +	rcu_read_lock();
> > > +	l = list_lru_lock_irqsave(&deferred_split_lru, nid, folio_memcg(folio), &flags);
> > > +	if (__list_lru_del(&deferred_split_lru, l, &folio->_deferred_list, nid)) {
> >
> > Maybe worth factoring __list_lru_del() into something that explicitly
> > references &folio->_deferred_list rather than open codingin both places?
>
> Hm, I wouldn't want to encode this into list_lru API, but we could do
> a huge_memory.c-local helper?
>
> folio_deferred_split_del(folio, l, nid)

Well, I kind of hate how we're using the global deferred_split_lru all over the
place, so a helper woudl be preferable but one that also could be used for
khugepaged.c and memory.c also?

>
> > > @@ -4406,7 +4320,11 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
> > >  	if (folio_test_swapcache(folio))
> > >  		return;
> > >
> > > -	ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
> > > +	nid = folio_nid(folio);
> > > +
> > > +	rcu_read_lock();
> > > +	memcg = folio_memcg(folio);
> > > +	l = list_lru_lock_irqsave(&deferred_split_lru, nid, memcg, &flags);
> >
> > Do we really need to hold the lock over all the below, but hmm we can't do
> > an irqsave/restore list_lru_add(), and maybe not worth adding one either,
> > OK.
> >
> > Just seems odd to have <lock> <__unlocked_add_variant> <unlock>,
> > instinctively feels like it should be just <locked_add_variant>.
>
> It protects that auxiliary folio_test_partially_mapped() state that
> the shrinker also touches. LRU + that page flag + the counts is what
> that lock protects.

Ack thanks

>
> > > @@ -4473,45 +4375,47 @@ static bool thp_underused(struct folio *folio)
> > >  	return false;
> > >  }
> > >
> > > +static enum lru_status deferred_split_isolate(struct list_head *item,
> > > +					      struct list_lru_one *lru,
> > > +					      void *cb_arg)
> > > +{
> > > +	struct folio *folio = container_of(item, struct folio, _deferred_list);
> > > +	struct list_head *freeable = cb_arg;
> > > +
> > > +	if (folio_try_get(folio)) {
> > > +		list_lru_isolate_move(lru, item, freeable);
> > > +		return LRU_REMOVED;
> > > +	}
> > > +
> > > +	/* We lost race with folio_put() */
> >
> > Hmm, in the original code, this comment is associated with the partially
> > mapped logic, BUT this seems actually correct, because folio_try_get()
> > because it does folio_ref_add_unless_zero() only fails if the folio lost
> > the race.
> >
> > So I think you're more correct right?
>
> I think the original placement was because that else if made it
> awkward to place where it should be. But yes, the above is more
> correct: the comment refers to what happens when the "get" fails.

Right yeah

>
> > > -	ds_queue = split_queue_lock_irqsave(sc->nid, sc->memcg, &flags);
> > > -	/* Take pin on all head pages to avoid freeing them under us */
> > > -	list_for_each_entry_safe(folio, next, &ds_queue->split_queue,
> > > -							_deferred_list) {
> > > -		if (folio_try_get(folio)) {
> > > -			folio_batch_add(&fbatch, folio);
> > > -		} else if (folio_test_partially_mapped(folio)) {
> > > -			/* We lost race with folio_put() */
> > > -			folio_clear_partially_mapped(folio);
> > > -			mod_mthp_stat(folio_order(folio),
> > > -				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> > > -		}
>
> > > @@ -4534,64 +4438,32 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
> > >  		}
> > >  		folio_unlock(folio);
> > >  next:
> > > -		if (did_split || !folio_test_partially_mapped(folio))
> > > -			continue;
> > >  		/*
> > >  		 * Only add back to the queue if folio is partially mapped.
> > >  		 * If thp_underused returns false, or if split_folio fails
> > >  		 * in the case it was underused, then consider it used and
> > >  		 * don't add it back to split_queue.
> > >  		 */
> > > -		fqueue = folio_split_queue_lock_irqsave(folio, &flags);
> > > -		if (list_empty(&folio->_deferred_list)) {
> > > -			list_add_tail(&folio->_deferred_list, &fqueue->split_queue);
> > > -			fqueue->split_queue_len++;
> > > +		if (!did_split && folio_test_partially_mapped(folio)) {
> > > +			rcu_read_lock();
> > > +			l = list_lru_lock_irqsave(&deferred_split_lru,
> > > +						  folio_nid(folio),
> > > +						  folio_memcg(folio),
> > > +						  &flags);
> > > +			__list_lru_add(&deferred_split_lru, l,
> > > +				       &folio->_deferred_list,
> > > +				       folio_nid(folio), folio_memcg(folio));
> > > +			list_lru_unlock_irqrestore(l, &flags);
> >
> > Hmm this does make me think it'd be nice to have a list_lru_add() variant
> > for irqsave/restore then, since it's a repeating pattern!
>
> Yeah, this site calls for it the most :( I tried to balance callsite
> prettiness with the need to extend the list_lru api; it's just one
> caller. And the possible mutations and variants with these locks is
> seemingly endless once you open that can of worms...

True...

>
> Case in point: this is process context and we could use
> spin_lock_irq() here. I'm just using list_lru_lock_irqsave() because
> that's the common variant used by the add and del paths already.
>
> If I went with a helper, I could do list_lru_add_irq().
>
> I think it would actually nicely mirror the list_lru_shrink_walk_irq()
> a few lines up.

Yeah, I mean I'm pretty sure this repeats quite a few times so is worthy of a
helper.

>
> > > --- a/mm/khugepaged.c
> > > +++ b/mm/khugepaged.c
> > > @@ -1081,6 +1081,7 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
> > >  	}
> > >
> > >  	count_vm_event(THP_COLLAPSE_ALLOC);
> > > +
> > >  	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
> > >  		folio_put(folio);
> > >  		*foliop = NULL;
> > > @@ -1089,6 +1090,12 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
> > >
> > >  	count_memcg_folio_events(folio, THP_COLLAPSE_ALLOC, 1);
> >
> > Do we want to put this stat counter underneath the below so it's not
> > incremented on fail?
>
> We currently increment it also when the cgroup charge fails, which is
> common. The list_lru allocation (a smaller kmalloc) in turn should
> basically never fail - we just managed to get a PMD-sized folio.
>
> Executive summar being: the way we bump them currently is weird. I
> tried to stay out of it to keep this series on track ;)

Ack ok fair enough :)

>
> > > +	if (folio_memcg_list_lru_alloc(folio, &deferred_split_lru, gfp)) {
> > > +		folio_put(folio);
> > > +		*foliop = NULL;
> > > +		return SCAN_CGROUP_CHARGE_FAIL;
> >
> > Do we not need to uncharge here?
>
> folio_put() does that. We could do it for symmetry, but there is no
> need. And the hard and fast rule is that folio_memcg() is immutable
> until the put hits 0, so it would look weird/unexpected.

So it does!

void __folio_put(struct folio *folio)
{
	...
	mem_cgroup_uncharge(folio);
	...
}

I didn't _think_ it would but I guess I didn't realise how much work
__folio_put() was doing :)

>
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index a47fb68dd65f..f381cb6bdff1 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -4015,11 +4015,6 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
> > >  	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
> > >  		memcg->cgwb_frn[i].done =
> > >  			__WB_COMPLETION_INIT(&memcg_cgwb_frn_waitq);
> > > -#endif
> > > -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > > -	spin_lock_init(&memcg->deferred_split_queue.split_queue_lock);
> > > -	INIT_LIST_HEAD(&memcg->deferred_split_queue.split_queue);
> > > -	memcg->deferred_split_queue.split_queue_len = 0;
> > >  #endif
> > >  	lru_gen_init_memcg(memcg);
> > >  	return memcg;
> > > @@ -4167,11 +4162,10 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
> > >  	zswap_memcg_offline_cleanup(memcg);
> > >
> > >  	memcg_offline_kmem(memcg);
> > > -	reparent_deferred_split_queue(memcg);
> > >  	/*
> > > -	 * The reparenting of objcg must be after the reparenting of the
> > > -	 * list_lru and deferred_split_queue above, which ensures that they will
> > > -	 * not mistakenly get the parent list_lru and deferred_split_queue.
> > > +	 * The reparenting of objcg must be after the reparenting of
> > > +	 * the list_lru in memcg_offline_kmem(), which ensures that
> > > +	 * they will not mistakenly get the parent list_lru.
> > >  	 */
> > >  	memcg_reparent_objcgs(memcg);
> > >  	reparent_shrinker_deferred(memcg);
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index 219b9bf6cae0..e68ceb4aa624 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -4651,13 +4651,19 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
> > >  	while (orders) {
> > >  		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
> > >  		folio = vma_alloc_folio(gfp, order, vma, addr);
> > > -		if (folio) {
> > > -			if (!mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
> > > -							    gfp, entry))
> > > -				return folio;
> > > +		if (!folio)
> > > +			goto next;
> > > +		if (mem_cgroup_swapin_charge_folio(folio, vma->vm_mm, gfp, entry)) {
> > >  			count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK_CHARGE);
> > >  			folio_put(folio);
> > > +			goto next;
> > >  		}
> > > +		if (folio_memcg_list_lru_alloc(folio, &deferred_split_lru, gfp)) {
> >
> > Do we need to uncharge here?
>
> Same here. It's folio state that the put cleans up.

Ack, indeed!

>
> > > +			folio_put(folio);
> > > +			goto fallback;
> > > +		}
> > > +		return folio;
> > > +next:
> > >  		count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK);
> > >  		order = next_order(&orders, order);
> > >  	}
> > > @@ -5169,24 +5175,28 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
> > >  	while (orders) {
> > >  		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
> > >  		folio = vma_alloc_folio(gfp, order, vma, addr);
> > > -		if (folio) {
> > > -			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
> > > -				count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
> > > -				folio_put(folio);
> > > -				goto next;
> > > -			}
> > > -			folio_throttle_swaprate(folio, gfp);
> > > -			/*
> > > -			 * When a folio is not zeroed during allocation
> > > -			 * (__GFP_ZERO not used) or user folios require special
> > > -			 * handling, folio_zero_user() is used to make sure
> > > -			 * that the page corresponding to the faulting address
> > > -			 * will be hot in the cache after zeroing.
> > > -			 */
> > > -			if (user_alloc_needs_zeroing())
> > > -				folio_zero_user(folio, vmf->address);
> > > -			return folio;
> > > +		if (!folio)
> > > +			goto next;
> >
> > This applies to the above equivalent refactorings, but maybe worth
> > separating out this:
> >
> > if (folio) { ... big branch ... } ->
> > if (!folio) goto next; ... what was big branch ...
> >
> > Refactoring into a separate patch? Makes it easier to see pertinent logic
> > changes + helps review/bisectability/fixes/etc. etc.
>
> Will do.

Thanks!

>
> > > +		if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
> > > +			count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
> > > +			folio_put(folio);
> > > +			goto next;
> > >  		}
> > > +		if (folio_memcg_list_lru_alloc(folio, &deferred_split_lru, gfp)) {
> >
> > Again, do we need to uncharge here?
>
> folio_put() does it :)

Yeah, I should have just checked __folio_put() :>)

<Insert quote about good programmers, lazy, hubris etc. here :P>

>
> > > +			folio_put(folio);
> > > +			goto fallback;
> > > +		}
> > > +		folio_throttle_swaprate(folio, gfp);
> > > +		/*
> > > +		 * When a folio is not zeroed during allocation
> > > +		 * (__GFP_ZERO not used) or user folios require special
> > > +		 * handling, folio_zero_user() is used to make sure
> > > +		 * that the page corresponding to the faulting address
> > > +		 * will be hot in the cache after zeroing.
> > > +		 */
> > > +		if (user_alloc_needs_zeroing())
> > > +			folio_zero_user(folio, vmf->address);
> > > +		return folio;
> > >  next:
> > >  		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
> > >  		order = next_order(&orders, order);
> > > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > > index cec7bb758bdd..f293a62e652a 100644
> > > --- a/mm/mm_init.c
> > > +++ b/mm/mm_init.c
> > > @@ -1388,19 +1388,6 @@ static void __init calculate_node_totalpages(struct pglist_data *pgdat,
> > >  	pr_debug("On node %d totalpages: %lu\n", pgdat->node_id, realtotalpages);
> > >  }
> > >
> > > -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > > -static void pgdat_init_split_queue(struct pglist_data *pgdat)
> > > -{
> > > -	struct deferred_split *ds_queue = &pgdat->deferred_split_queue;
> > > -
> > > -	spin_lock_init(&ds_queue->split_queue_lock);
> > > -	INIT_LIST_HEAD(&ds_queue->split_queue);
> > > -	ds_queue->split_queue_len = 0;
> > > -}
> > > -#else
> > > -static void pgdat_init_split_queue(struct pglist_data *pgdat) {}
> > > -#endif
> > > -
> > >  #ifdef CONFIG_COMPACTION
> > >  static void pgdat_init_kcompactd(struct pglist_data *pgdat)
> > >  {
> > > @@ -1416,8 +1403,6 @@ static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
> > >
> > >  	pgdat_resize_init(pgdat);
> > >  	pgdat_kswapd_lock_init(pgdat);
> > > -
> > > -	pgdat_init_split_queue(pgdat);
> > >  	pgdat_init_kcompactd(pgdat);
> > >
> > >  	init_waitqueue_head(&pgdat->kswapd_wait);
> > > --
> > > 2.53.0
> > >
> >
> > Overall a lovely amount of code deletion here :)
> >
> > Thanks for doing this, Cheers Lorenzo
>
> Thanks for your feedback!

No worries, thanks for the series :)

Cheers, Lorenzo

