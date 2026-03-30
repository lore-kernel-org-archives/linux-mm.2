Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 880211061B16
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 16:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E57D66B0096; Mon, 30 Mar 2026 12:40:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E083E6B0098; Mon, 30 Mar 2026 12:40:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD0166B0099; Mon, 30 Mar 2026 12:40:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B48AB6B0096
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:40:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 543E41408BF
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:40:31 +0000 (UTC)
X-FDA: 84603292662.15.98ADD92
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id D968EC0004
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:40:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=RANjzEaW;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774888829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uoW/s2DnCvlqDW3gDqz+Z3WVgkG+qLPQ47qk/mXWMc4=;
	b=GSmRx7hUUWjnW0ZPkzTq0FUypaH8dC6za1NVLgdlb9drswpRozMQ2l7IOsglhirZ6Wy/3B
	WkCwaPIP6pU+uwSDkaOpfIT0h2XYSgrBeS4YpN+NLTC+xVZRBpQI8Zq1xOsUvuZEjg0q6Y
	BN9ymNEumz/PBdyamPgOmail5KfSR98=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774888829; a=rsa-sha256;
	cv=none;
	b=gqWCuIvmIIA/itJTHVSMoI71PeZ/BaXGKc4j41zRPyd5mmz1vaG3Gg3QZsOefk7YKLd9U0
	A26XZC4EGQXGPSkgf6uplN6t0OaRIhBGpuNkiKKJGiL0HEGMr3qUjrG6vL/aTaq37udCV8
	5puphGoXi4c85t6mQRHw+N38ry7m5uU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=RANjzEaW;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50b69bf5638so51107301cf.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1774888828; x=1775493628; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uoW/s2DnCvlqDW3gDqz+Z3WVgkG+qLPQ47qk/mXWMc4=;
        b=RANjzEaWoi2xBErV9e7X+NShRxRLxv/1N4mDcA/eK8ixLkCgGnxDFxRGpfUmILY29d
         9XFjzE3ML1M8LOw8NhFSNOQU5xjz+Gp+1kLdMOqo3ZgY6BHtjv7D/yBR/boD1F1HZCaK
         2w31oZJagUhm4vunsIMbfcKUUKpiwfyq1XwWc2XHLyswKWDAKuCMQXkGce4+9hAWPHtI
         dtQ6K9aQJemetaJ36zeOBafD3F+tKWJc2cIJ1MIfpEmr9bUvL8snTLxl0j4nls+YDMq7
         RH8ootGHAnY5VfuOKc0UjOJtWdYDT3smK8W6CeFtmsGk8aUhOStOJbExtrX7rPaoh0+/
         pmQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774888828; x=1775493628;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uoW/s2DnCvlqDW3gDqz+Z3WVgkG+qLPQ47qk/mXWMc4=;
        b=tHN5M/pXPqQe2aX0qAmdp/LLzZBN788le9fyQ4AEX7bMJ6fk5WnX5InkHpO5+94SVi
         gvUZs9lX6ueUhj6EMT0+Ek+2D+zr5+8OCKrgnz0dIJygZp3TlKGM8hfGPxZG8rpP5N0H
         Kqtyroy0RQu+8ZQL02cA7Kv5U4NyRI9Q6rpFV80P99kgvGstHd8Ez6wIe/DqTJqgZZAp
         OW5/5Rf/Rj6XGvm/dny8OF60Ot2xtrXeMybl/FtBOwI4C3w2T6sgWFi2yQRS3AF3MxlR
         KJVWRUwKzjp+0rHDFH4dVBH0Ts2mN3/0DweEbu+Uy5DYLlxnHCTHwagfncM4r1V35X0S
         rOFA==
X-Forwarded-Encrypted: i=1; AJvYcCXV1Q4ruB+oZF1jwDOS3P5sYOM5pZegx3Q/E1wbO1GvE/9yjRnVvxEHnSR4KLxfsVRsby0zSeHO8g==@kvack.org
X-Gm-Message-State: AOJu0YyPCJEjOnWRwF25nYeffLvvVA1QMyYM4dsuR04a+Tu7rL8bKT1c
	4zLAymNfXYLPLANjRf+5cslcR91CINV0L8DhFjnzG31f4MphKln1b4G/pMOiULZdAqU=
X-Gm-Gg: ATEYQzyRsJtlcoaA7wxlgk70Dssb1NmmkH10fbugS9tREyWu+VYiK+0omvTr5KpO6M5
	XMtV4hXT7JG+Viuwrp1puYvaiahnImCRdB9b5Jf7H6R/chGK2+Qslx9tR01Ux7IVTkG5KNMHJPI
	/Yi20hexsgRqg9l0L0Vg3L1BKu5jiDOEELYacJBhT0ctcwkDPhJvL7kWi93oNuiTOLGOAQqy/Yk
	1cT1leVwCF/sDmGF0iDps+WbsH+OrHcCPU4heXqgROJ4GFP48jBOvNtEHXEpBUl+t2dQbU7aOwW
	qH+pBSfEyxMdkpW8UJuV3dX38Jhqt7rHYTPC9BA+WvIhE48YoGOj5nCOUAuVtb0Wy9SFYGd2Izp
	P75YSDjPPjWsaqnFkfJdUv6KwLxRx9HEdZLbDy4uZqDVNqv22mD4kOtfm0uBIPAwHj9pczMpYJk
	R/M+9u6AhVefTOwuO0DnAiDA==
X-Received: by 2002:a05:622a:418f:b0:50b:1e5d:9930 with SMTP id d75a77b69052e-50ba394e023mr172061161cf.58.1774888827230;
        Mon, 30 Mar 2026 09:40:27 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50bb2de76a6sm69487161cf.18.2026.03.30.09.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 09:40:26 -0700 (PDT)
Date: Mon, 30 Mar 2026 12:40:22 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/7] mm: switch deferred split shrinker to list_lru
Message-ID: <acqndkLvpRI9bgRK@cmpxchg.org>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-8-hannes@cmpxchg.org>
 <0cf8a859-b142-4e53-9113-94872dd68f40@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0cf8a859-b142-4e53-9113-94872dd68f40@lucifer.local>
X-Rspamd-Queue-Id: D968EC0004
X-Stat-Signature: ijzor41eohdf8cb6wcbsctz3nm68j3df
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774888828-833485
X-HE-Meta: U2FsdGVkX19mfQangj4H15vm4G9MkHTQ88fD3HT2wUSKi4cU/ruUPKdORPcJYhlwyVoTGRewWiIdJMWMrwT3PaFEUmcXHO/SEkLB/8IK4NQioin3hIXXBxu1vciI8zH0yQ7KCf5wEY73LN423wV29CAGZryN0hID8fHUcrcAD4Pmwdai9w29xFWDwlYlJ0g5G7tZB3XqSDJuk3qbipS6ik23hh8OYgIRXO33Ck/SFiSC3VjLPYH6j1YHVFW/1aYlWaed73rbU4TPKS6IwrLF0vBbM4UK8d3fT1qM0ynVRIUeMyhhDyIUGwUhFZxANHNYj/fdT7fovTbSD7xnKFkIIT8OCgpE1ghE6lj65A7+y0kS+YG20RH6wUaN6bggAHhY3HIsdZZWPV0/537P+H/LJDw45gh04CyqHmwZVjI6/W/5Kbg9B9b1S0ZhPe4BAtoGZUnb8BmldWK2HWcB9oQnKIXFM9leom8KJQzuHTnmcgic3tlJQosJn5NU1WEt7NMvk0CvqDhcdjfX3Ai8d86EGStdnUe0piE9xdknACJ39MmXaFZldh5+UZ4IvnAxVKyaH8KCEydWMFN7tw0ff/XiQ8fqyEB7qnpaZQBrpyM3717PXFkeCYoLFSQicaBAe4uvYqzu08gcM35A9HJcVUV4uQc3KFyyyIMgbqqy8Q3z4w95DWLajzFWqoyO+WsFjTDUS9HFt5SlnAE67J784Y+9cwtPAW9jCZlHjKh8k3wZFbuCOzX+EkU1K39N8BeqcG4ufm0mVOn1wf9SRG3umpvzGAqNCDOG78IYZled0h75QUFbPIciw3P5KpKVAcJjC3cTDaX3H5BjPRv2dhn0o1ZUtMP9EF2HOSksNe6GCszKvjHlYmhc6JRX2MM7VI9B5yIg08c/rjOLWPo83fh9rGGr7Y48X41kd2HMFDgz6QJ2SAwCMqp2AJdQCi7ONt/rr3MBwXyB92eWEWxVheozIJr
 5HzG/J+t
 F6h1l3mtKp4JlCR3X3LB4CD/5HFjRnmgGhp9ZgW8zoEQC1v/9xQEkvWJ9mT6c6yTix3VAjeYMdDX4FB2NSmsEHkq+MiKmeqE44/hODmWrqAKZ1FhFoAMn2LIdRiqU3TJThaXuLLHQv1mRWSt/4ARb9YuIzXUvHCIvwRIBFLf1Rx2ywgupQ8ksCm73Tp8iziquyRhUEKv5/0dtee3c3Ph+3+ennCAbyTS+d2xfy/aA4ZsCiCyPcKoAVXExXc0oc8XSQqdLHDNe2iIEtROnmMl+gSQ5EvqDH727sUCNYhAO6+GDUCP5QhBeyIRySdS2n+vezNjSyJfrL/do7OYXlCs4cPwXf1y1fnbqfWkXp5aZrpUbfViuRADW0qzG33bgX2DWNoUOSjhERC0ql+qb2GD13lFw51q2YU6dHQMco/yBLhOmQZSJAsMCz4umWdmkC1z2itsETlq9XacOc84=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey Lorenzo,

Thanks for taking an in-depth look at this!

Apologies for the late reply, I was traveling last week.

On Tue, Mar 24, 2026 at 01:48:06PM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Wed, Mar 18, 2026 at 03:53:25PM -0400, Johannes Weiner wrote:
> > The deferred split queue handles cgroups in a suboptimal fashion. The
> > queue is per-NUMA node or per-cgroup, not the intersection. That means
> > on a cgrouped system, a node-restricted allocation entering reclaim
> > can end up splitting large pages on other nodes:
> >
> > 	alloc/unmap
> > 	  deferred_split_folio()
> > 	    list_add_tail(memcg->split_queue)
> > 	    set_shrinker_bit(memcg, node, deferred_shrinker_id)
> 
> So here it's:
> 
> __do_huge_pmd_anonymous_page() / do_huge_zero_wp_pmd()
> -> map_anon_folio_pmd_pf()
> -> map_anon_folio_pmd_nopf()
> -> deferred_split_folio()
> -> set_shrinker_bit()
> 
> Yeah it makes sense to make the first bit succinct anyway :)

Yep I was trying to keep the focus on those parts that interact with
the other stacks listed below. Not biblically accurate
deferred_split_folio() callsites ;)

> > 	for_each_zone_zonelist_nodemask(restricted_nodes)
> > 	  mem_cgroup_iter()
> > 	    shrink_slab(node, memcg)
> > 	      shrink_slab_memcg(node, memcg)
> > 	        if test_shrinker_bit(memcg, node, deferred_shrinker_id)
> 
> Hmm there's no such function is this kind of pseudocode, essentially?
> 
> Wouldn't it be clearer to reference:
> 
> shrink_slab_memcg() -> do_shrink_slab() -> shrinker->scan_objects ->
> deferred_split_scan()?
> 
> Though I get that it adds verbosity :)
> 
> Sorry not (just) being pedantic here, also so I can understand myself :)

Yes, it's pseudocode. Direct reclaim (shrink_zones) and kswapd
(wake_all_kswapds) do the "for all nodes" loops. Nested within them
are the loops that iterate the cgroup tree (shrink_node_memcgs,
shrink_many, depending on LRU vs MGLRU). And then nested within
*those* we have the shrink_slab() calls.

Again, I tried to keep the boiler plate low and to the point. The most
important thing is: 1) the shrinker bit gets set for each node, memcg
pair that has objects, 2) shrinker visits all nodes x memcgs with it
set 3) but the shrinker scans happen on per-memcg queue, not node-aware.

Let me know if that works as is, or if you would like me to rephrase
that. I would like to keep it as simple as possible, but no simpler
than that ;)

> > 	          deferred_split_scan()
> > 	            walks memcg->split_queue
> 
> Ok so overall there's a per-memcg memcg->split_queue, but we set a bit in
> memcg->nodeinfo[nid]->shrinker_info->unit[blah]->map for it, and when we
> enter shrink_slab_memcg(), we figure out the shrink_control from the
> for_each_set_bit() across memcg->...->unit->map?
> 
> > The shrinker bit adds an imperfect guard rail. As soon as the cgroup
> > has a single large page on the node of interest, all large pages owned
> > by that memcg, including those on other nodes, will be split.
> 
> So at this point, regardless of node, we are invoking deferred_split_scan()
> and it's the same memcg->split_queue we are walking, regardless of node?
> 
> Do let me know if my understanding is correct here!
> 
> Hmm that does sound sub-optimal.

That is exactly what's happening. We have all this dance to be precise
about the shrinker bit, but the queue itself is not node-aware.

That makes for some pretty erratic behavior.

> > list_lru properly sets up per-node, per-cgroup lists. As a bonus, it
> > streamlines a lot of the list operations and reclaim walks. It's used
> > widely by other major shrinkers already. Convert the deferred split
> > queue as well.
> 
> It's odd that it wasn't used before?

The list_lru API was initially explicitly for *slab objects*, doing
virt_to_page() and mem_cgroup_from_slab_obj() on the passed in list
heads to derive the proper queue. It was only extended more recently
in 0a97c01cd20b ("list_lru: allow explicit memcg and NUMA node
selection") to allow passing in the queue routing information and
embedding the list heads in other things (such as folios).

The only missing piece now was the support for callside locking of the
list_lru structures.

> >  include/linux/huge_mm.h    |   6 +-
> >  include/linux/memcontrol.h |   4 -
> >  include/linux/mmzone.h     |  12 --
> >  mm/huge_memory.c           | 342 ++++++++++++-------------------------
> >  mm/internal.h              |   2 +-
> >  mm/khugepaged.c            |   7 +
> >  mm/memcontrol.c            |  12 +-
> >  mm/memory.c                |  52 +++---
> >  mm/mm_init.c               |  15 --
> >  9 files changed, 151 insertions(+), 301 deletions(-)
> >
> > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > index bd7f0e1d8094..8d801ed378db 100644
> > --- a/include/linux/huge_mm.h
> > +++ b/include/linux/huge_mm.h
> > @@ -414,10 +414,9 @@ static inline int split_huge_page(struct page *page)
> >  {
> >  	return split_huge_page_to_list_to_order(page, NULL, 0);
> >  }
> > +
> > +extern struct list_lru deferred_split_lru;
> 
> It might be nice for the sake of avoiding a global to instead expose this
> as a getter?
> 
> Or actually better, since every caller outside of huge_memory.c that
> references this uses folio_memcg_list_lru_alloc(), do something like:
> 
> int folio_memcg_alloc_deferred(struct folio *folio, gfp_t gfp);
> 
> in mm/huge_memory.c:
> 
> /**
>  * blah blah blah put on error blah
>  */
> int folio_memcg_alloc_deferred(struct folio *folio, gfp_t gfp)
> {
> 	int err;
> 
> 	err = folio_memcg_list_lru_alloc(folio, &deferred_split_lru, gfP);
> 	if (err) {
> 		folio_put(folio);
> 		return err;
> 	}
> 
> 	return 0;
> }
> 
> And then the callers can just invoke this, and you can make
> deferred_split_lru static in mm/huge_memory.c?

That sounds reasonable. Let me make this change.

> >  void deferred_split_folio(struct folio *folio, bool partially_mapped);
> > -#ifdef CONFIG_MEMCG
> > -void reparent_deferred_split_queue(struct mem_cgroup *memcg);
> > -#endif
> >
> >  void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
> >  		unsigned long address, bool freeze);
> > @@ -650,7 +649,6 @@ static inline int try_folio_split_to_order(struct folio *folio,
> >  }
> >
> >  static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
> > -static inline void reparent_deferred_split_queue(struct mem_cgroup *memcg) {}
> >  #define split_huge_pmd(__vma, __pmd, __address)	\
> >  	do { } while (0)
> >
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 086158969529..0782c72a1997 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -277,10 +277,6 @@ struct mem_cgroup {
> >  	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
> >  #endif
> >
> > -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > -	struct deferred_split deferred_split_queue;
> > -#endif
> > -
> >  #ifdef CONFIG_LRU_GEN_WALKS_MMU
> >  	/* per-memcg mm_struct list */
> >  	struct lru_gen_mm_list mm_list;
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 7bd0134c241c..232b7a71fd69 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -1429,14 +1429,6 @@ struct zonelist {
> >   */
> >  extern struct page *mem_map;
> >
> > -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > -struct deferred_split {
> > -	spinlock_t split_queue_lock;
> > -	struct list_head split_queue;
> > -	unsigned long split_queue_len;
> > -};
> > -#endif
> > -
> >  #ifdef CONFIG_MEMORY_FAILURE
> >  /*
> >   * Per NUMA node memory failure handling statistics.
> > @@ -1562,10 +1554,6 @@ typedef struct pglist_data {
> >  	unsigned long first_deferred_pfn;
> >  #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
> >
> > -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > -	struct deferred_split deferred_split_queue;
> > -#endif
> > -
> >  #ifdef CONFIG_NUMA_BALANCING
> >  	/* start time in ms of current promote rate limit period */
> >  	unsigned int nbp_rl_start;
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 3fc02913b63e..e90d08db219d 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -14,6 +14,7 @@
> >  #include <linux/mmu_notifier.h>
> >  #include <linux/rmap.h>
> >  #include <linux/swap.h>
> > +#include <linux/list_lru.h>
> >  #include <linux/shrinker.h>
> >  #include <linux/mm_inline.h>
> >  #include <linux/swapops.h>
> > @@ -67,6 +68,8 @@ unsigned long transparent_hugepage_flags __read_mostly =
> >  	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG)|
> >  	(1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
> >
> > +static struct lock_class_key deferred_split_key;
> > +struct list_lru deferred_split_lru;
> >  static struct shrinker *deferred_split_shrinker;
> >  static unsigned long deferred_split_count(struct shrinker *shrink,
> >  					  struct shrink_control *sc);
> > @@ -919,6 +922,13 @@ static int __init thp_shrinker_init(void)
> >  	if (!deferred_split_shrinker)
> >  		return -ENOMEM;
> >
> > +	if (list_lru_init_memcg_key(&deferred_split_lru,
> > +				    deferred_split_shrinker,
> > +				    &deferred_split_key)) {
> > +		shrinker_free(deferred_split_shrinker);
> > +		return -ENOMEM;
> > +	}
> > +
> 
> It's kind of out of scope for the series, but I hate that the huge zero
> folio stuff has an early exit for persistent but if not, falls through to
> trying to set that up - it'd be nice to split out the huge zero folio stuff
> into another function.
> 
> But probably one for a follow up!

It doesn't bother me personally, but I wouldn't object to it being
moved to its own function and have the caller do necessary cleanups.

But yeah sounds like an unrelated refactor :)

> >  	deferred_split_shrinker->count_objects = deferred_split_count;
> >  	deferred_split_shrinker->scan_objects = deferred_split_scan;
> >  	shrinker_register(deferred_split_shrinker);
> > @@ -939,6 +949,7 @@ static int __init thp_shrinker_init(void)
> >
> >  	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
> >  	if (!huge_zero_folio_shrinker) {
> > +		list_lru_destroy(&deferred_split_lru);
> >  		shrinker_free(deferred_split_shrinker);
> 
> Presumably no probably-impossible-in-reality race on somebody entering the
> shrinker and referencing the deferred_split_lru before the shrinker is freed?

Ah right, I think for clarity it would indeed be better to destroy the
shrinker, then the queue. Let me re-order this one.

But yes, in practice, none of the above fails. If we have trouble
doing a couple of small kmallocs during a subsys_initcall(), that
machine is unlikely to finish booting, let alone allocate enough
memory to enter the THP shrinker.

> > @@ -953,6 +964,7 @@ static int __init thp_shrinker_init(void)
> >  static void __init thp_shrinker_exit(void)
> >  {
> >  	shrinker_free(huge_zero_folio_shrinker);
> > +	list_lru_destroy(&deferred_split_lru);
> 
> Same question above as to race/ordering.

... and this one as well.

> >  	shrinker_free(deferred_split_shrinker);
> >  }

> > @@ -3854,34 +3761,34 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
> >  	struct folio *end_folio = folio_next(folio);
> >  	struct folio *new_folio, *next;
> >  	int old_order = folio_order(folio);
> > +	struct list_lru_one *l;
> 
> Nit, and maybe this is a convention, but hate single letter variable names,
> 'lru' or something might be nicer?

Yeah I stuck with the list_lru internal naming, which uses `lru` for
the struct list_lru, and `l` for struct list_lru_one. I suppose that
was fine for the very domain-specific code and short functions in
there, but it's grating in large, general MM functions like these.

Since `lru` is taken, any preferences? llo?

> > +	bool dequeue_deferred;
> >  	int ret = 0;
> > -	struct deferred_split *ds_queue;
> >
> >  	VM_WARN_ON_ONCE(!mapping && end);
> >  	/* Prevent deferred_split_scan() touching ->_refcount */
> > -	ds_queue = folio_split_queue_lock(folio);
> > +	dequeue_deferred = folio_test_anon(folio) && old_order > 1;
> 
> Why anon? (This review is partly me learning about the shrinker, an area
> I'm weak on :)

This is the type of folios that can be queued through
deferred_split_folio(). The order check is inside that function
itself; and the function is only called for anon pages.

File pages are split differently, they don't use the deferred split
shrinker and we don't allocate list_lru heads for them. However, they
still come through this split path here, and so I need to gate whether
it's safe to do list_lru_lock(), __list_lru_del() etc.

> > +	if (dequeue_deferred) {
> > +		rcu_read_lock();
> > +		l = list_lru_lock(&deferred_split_lru,
> > +				  folio_nid(folio), folio_memcg(folio));
> 
> Hm don't adore this sort of almost 'hidden' RCU lock here, but this
> function is pretty disgusting and needs serious work in general.
> 
> And any function that took the RCU lock and list_lru lock/did the unlock
> equivalent would be equally horrible so yeah, I guess needs deferring to a
> refactor.
> 
> OTOH, this could be a good excuse for us to pay down some technical debt
> and split out for instance the folio_ref_freeze() bits?
> 
> Could we do something like:
> 
> 	bool frozen;
> 
> 	...
> 
> 	dequeue_deferred = folio_test_anon(folio) && old_order > 1;
> 	frozen = folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1);
> 
> 	if (dequeue_deferred && frozen) {
> 		struct list_lru_one *lru;
> 
> 		rcu_read_lock();
> 		lru = list_lru_lock(&deferred_split_lru,
> 				    folio_nid(folio), folio_memcg(folio));
> 		__list_lru_del(&deferred_split_lru, lru,
> 			       &folio->_deferred_list, folio_nid(folio));
> 		if (folio_test_partially_mapped(folio)) {
> 			folio_clear_partially_mapped(folio);
> 			mod_mthp_stat(old_order,
> 				MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> 		}
> 		list_lru_unlock(lru);
> 		rcu_read_unlock();
> 	}
> 
> 	if (!frozen)
> 		return -EAGAIN;
> 
> 	... rest of logic now one indent level lower ...
> 
> Or maybe factor that out into a helper function or something?
> 
> static void execute_deferred_dequeue(...) { ... }
> 
> With this implemented either way you'd be able to get rid of the else block
> too.
> 
> obviously only valid if you are able to do the freezing earlier?

The reason it locks the list_lru first is because there can be a race
between the shrinker and a synchronous split attempt.

This is what that comment above it is about:

	/* Prevent deferred_split_scan() touching ->_refcount */

If the shrinker fails to "get" the folio while holding the shrinker
lock, it thinks it beat the free path to the list_lru lock and will
feel responsible for cleaning up the deferred split state:

/* caller holds the list_lru lock already */
static enum lru_status deferred_split_isolate(struct list_head *item,
					      struct list_lru_one *lru,
					      void *cb_arg)
{
	struct folio *folio = container_of(item, struct folio, _deferred_list);
	struct list_head *freeable = cb_arg;

	if (folio_try_get(folio)) {
		list_lru_isolate_move(lru, item, freeable);
		return LRU_REMOVED;
	}

	/* We lost race with folio_put() */
	list_lru_isolate(lru, item);
	if (folio_test_partially_mapped(folio)) {
		folio_clear_partially_mapped(folio);
		mod_mthp_stat(folio_order(folio),
			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
	}
	return LRU_REMOVED;
}

So if the split path freezes before acquiring the list_lru lock, we
get them both stepping on the deferred split state.

This may or may not be safe given the current manifestation of
list_lru_del() and the folio_test_partially_mapped() tests. But it
feels pretty hairy to let them race and rely on individual tests into
what should be a coherent aggregate state.

> > +	}
> >  	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
> >  		struct swap_cluster_info *ci = NULL;
> >  		struct lruvec *lruvec;
> >
> > -		if (old_order > 1) {
> 
> Before was this also applicable to non-anon folios?

This branch, yes. But non-anon pages would then fail this:

> > -			if (!list_empty(&folio->_deferred_list)) {
> > -				ds_queue->split_queue_len--;
> > -				/*
> > -				 * Reinitialize page_deferred_list after removing the
> > -				 * page from the split_queue, otherwise a subsequent
> > -				 * split will see list corruption when checking the
> > -				 * page_deferred_list.
> > -				 */
> > -				list_del_init(&folio->_deferred_list);
> > -			}

..since they aren't ever added. This was okay because accessing that
list head is always safe. Now I need to be explicit to determine if
it's safe to call __list_lru_del() which does all these list_lru
references, which aren't allocated for file.

> > +		if (dequeue_deferred) {
> > +			__list_lru_del(&deferred_split_lru, l,
> > +				       &folio->_deferred_list, folio_nid(folio));
> >  			if (folio_test_partially_mapped(folio)) {
> >  				folio_clear_partially_mapped(folio);
> >  				mod_mthp_stat(old_order,
> >  					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> >  			}

And honestly, I think it's nicer to be explicit here about the
expectations of which pages get which treatment.

Filtering file pages on !list_empty() was not very obvious.

> > +	int nid = folio_nid(folio);
> >  	unsigned long flags;
> >  	bool unqueued = false;
> >
> >  	WARN_ON_ONCE(folio_ref_count(folio));
> >  	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg_charged(folio));
> >
> > -	ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
> > -	if (!list_empty(&folio->_deferred_list)) {
> > -		ds_queue->split_queue_len--;
> > +	rcu_read_lock();
> > +	l = list_lru_lock_irqsave(&deferred_split_lru, nid, folio_memcg(folio), &flags);
> > +	if (__list_lru_del(&deferred_split_lru, l, &folio->_deferred_list, nid)) {
> 
> Maybe worth factoring __list_lru_del() into something that explicitly
> references &folio->_deferred_list rather than open codingin both places?

Hm, I wouldn't want to encode this into list_lru API, but we could do
a huge_memory.c-local helper?

folio_deferred_split_del(folio, l, nid)

> > @@ -4406,7 +4320,11 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
> >  	if (folio_test_swapcache(folio))
> >  		return;
> >
> > -	ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
> > +	nid = folio_nid(folio);
> > +
> > +	rcu_read_lock();
> > +	memcg = folio_memcg(folio);
> > +	l = list_lru_lock_irqsave(&deferred_split_lru, nid, memcg, &flags);
> 
> Do we really need to hold the lock over all the below, but hmm we can't do
> an irqsave/restore list_lru_add(), and maybe not worth adding one either,
> OK.
> 
> Just seems odd to have <lock> <__unlocked_add_variant> <unlock>,
> instinctively feels like it should be just <locked_add_variant>.

It protects that auxiliary folio_test_partially_mapped() state that
the shrinker also touches. LRU + that page flag + the counts is what
that lock protects.

> > @@ -4473,45 +4375,47 @@ static bool thp_underused(struct folio *folio)
> >  	return false;
> >  }
> >
> > +static enum lru_status deferred_split_isolate(struct list_head *item,
> > +					      struct list_lru_one *lru,
> > +					      void *cb_arg)
> > +{
> > +	struct folio *folio = container_of(item, struct folio, _deferred_list);
> > +	struct list_head *freeable = cb_arg;
> > +
> > +	if (folio_try_get(folio)) {
> > +		list_lru_isolate_move(lru, item, freeable);
> > +		return LRU_REMOVED;
> > +	}
> > +
> > +	/* We lost race with folio_put() */
> 
> Hmm, in the original code, this comment is associated with the partially
> mapped logic, BUT this seems actually correct, because folio_try_get()
> because it does folio_ref_add_unless_zero() only fails if the folio lost
> the race.
> 
> So I think you're more correct right?

I think the original placement was because that else if made it
awkward to place where it should be. But yes, the above is more
correct: the comment refers to what happens when the "get" fails.

> > -	ds_queue = split_queue_lock_irqsave(sc->nid, sc->memcg, &flags);
> > -	/* Take pin on all head pages to avoid freeing them under us */
> > -	list_for_each_entry_safe(folio, next, &ds_queue->split_queue,
> > -							_deferred_list) {
> > -		if (folio_try_get(folio)) {
> > -			folio_batch_add(&fbatch, folio);
> > -		} else if (folio_test_partially_mapped(folio)) {
> > -			/* We lost race with folio_put() */
> > -			folio_clear_partially_mapped(folio);
> > -			mod_mthp_stat(folio_order(folio),
> > -				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> > -		}

> > @@ -4534,64 +4438,32 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
> >  		}
> >  		folio_unlock(folio);
> >  next:
> > -		if (did_split || !folio_test_partially_mapped(folio))
> > -			continue;
> >  		/*
> >  		 * Only add back to the queue if folio is partially mapped.
> >  		 * If thp_underused returns false, or if split_folio fails
> >  		 * in the case it was underused, then consider it used and
> >  		 * don't add it back to split_queue.
> >  		 */
> > -		fqueue = folio_split_queue_lock_irqsave(folio, &flags);
> > -		if (list_empty(&folio->_deferred_list)) {
> > -			list_add_tail(&folio->_deferred_list, &fqueue->split_queue);
> > -			fqueue->split_queue_len++;
> > +		if (!did_split && folio_test_partially_mapped(folio)) {
> > +			rcu_read_lock();
> > +			l = list_lru_lock_irqsave(&deferred_split_lru,
> > +						  folio_nid(folio),
> > +						  folio_memcg(folio),
> > +						  &flags);
> > +			__list_lru_add(&deferred_split_lru, l,
> > +				       &folio->_deferred_list,
> > +				       folio_nid(folio), folio_memcg(folio));
> > +			list_lru_unlock_irqrestore(l, &flags);
> 
> Hmm this does make me think it'd be nice to have a list_lru_add() variant
> for irqsave/restore then, since it's a repeating pattern!

Yeah, this site calls for it the most :( I tried to balance callsite
prettiness with the need to extend the list_lru api; it's just one
caller. And the possible mutations and variants with these locks is
seemingly endless once you open that can of worms...

Case in point: this is process context and we could use
spin_lock_irq() here. I'm just using list_lru_lock_irqsave() because
that's the common variant used by the add and del paths already.

If I went with a helper, I could do list_lru_add_irq().

I think it would actually nicely mirror the list_lru_shrink_walk_irq()
a few lines up.

> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1081,6 +1081,7 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
> >  	}
> >
> >  	count_vm_event(THP_COLLAPSE_ALLOC);
> > +
> >  	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
> >  		folio_put(folio);
> >  		*foliop = NULL;
> > @@ -1089,6 +1090,12 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
> >
> >  	count_memcg_folio_events(folio, THP_COLLAPSE_ALLOC, 1);
> 
> Do we want to put this stat counter underneath the below so it's not
> incremented on fail?

We currently increment it also when the cgroup charge fails, which is
common. The list_lru allocation (a smaller kmalloc) in turn should
basically never fail - we just managed to get a PMD-sized folio.

Executive summar being: the way we bump them currently is weird. I
tried to stay out of it to keep this series on track ;)

> > +	if (folio_memcg_list_lru_alloc(folio, &deferred_split_lru, gfp)) {
> > +		folio_put(folio);
> > +		*foliop = NULL;
> > +		return SCAN_CGROUP_CHARGE_FAIL;
> 
> Do we not need to uncharge here?

folio_put() does that. We could do it for symmetry, but there is no
need. And the hard and fast rule is that folio_memcg() is immutable
until the put hits 0, so it would look weird/unexpected.

> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index a47fb68dd65f..f381cb6bdff1 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -4015,11 +4015,6 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
> >  	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
> >  		memcg->cgwb_frn[i].done =
> >  			__WB_COMPLETION_INIT(&memcg_cgwb_frn_waitq);
> > -#endif
> > -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > -	spin_lock_init(&memcg->deferred_split_queue.split_queue_lock);
> > -	INIT_LIST_HEAD(&memcg->deferred_split_queue.split_queue);
> > -	memcg->deferred_split_queue.split_queue_len = 0;
> >  #endif
> >  	lru_gen_init_memcg(memcg);
> >  	return memcg;
> > @@ -4167,11 +4162,10 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
> >  	zswap_memcg_offline_cleanup(memcg);
> >
> >  	memcg_offline_kmem(memcg);
> > -	reparent_deferred_split_queue(memcg);
> >  	/*
> > -	 * The reparenting of objcg must be after the reparenting of the
> > -	 * list_lru and deferred_split_queue above, which ensures that they will
> > -	 * not mistakenly get the parent list_lru and deferred_split_queue.
> > +	 * The reparenting of objcg must be after the reparenting of
> > +	 * the list_lru in memcg_offline_kmem(), which ensures that
> > +	 * they will not mistakenly get the parent list_lru.
> >  	 */
> >  	memcg_reparent_objcgs(memcg);
> >  	reparent_shrinker_deferred(memcg);
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 219b9bf6cae0..e68ceb4aa624 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4651,13 +4651,19 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
> >  	while (orders) {
> >  		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
> >  		folio = vma_alloc_folio(gfp, order, vma, addr);
> > -		if (folio) {
> > -			if (!mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
> > -							    gfp, entry))
> > -				return folio;
> > +		if (!folio)
> > +			goto next;
> > +		if (mem_cgroup_swapin_charge_folio(folio, vma->vm_mm, gfp, entry)) {
> >  			count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK_CHARGE);
> >  			folio_put(folio);
> > +			goto next;
> >  		}
> > +		if (folio_memcg_list_lru_alloc(folio, &deferred_split_lru, gfp)) {
> 
> Do we need to uncharge here?

Same here. It's folio state that the put cleans up.

> > +			folio_put(folio);
> > +			goto fallback;
> > +		}
> > +		return folio;
> > +next:
> >  		count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK);
> >  		order = next_order(&orders, order);
> >  	}
> > @@ -5169,24 +5175,28 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
> >  	while (orders) {
> >  		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
> >  		folio = vma_alloc_folio(gfp, order, vma, addr);
> > -		if (folio) {
> > -			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
> > -				count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
> > -				folio_put(folio);
> > -				goto next;
> > -			}
> > -			folio_throttle_swaprate(folio, gfp);
> > -			/*
> > -			 * When a folio is not zeroed during allocation
> > -			 * (__GFP_ZERO not used) or user folios require special
> > -			 * handling, folio_zero_user() is used to make sure
> > -			 * that the page corresponding to the faulting address
> > -			 * will be hot in the cache after zeroing.
> > -			 */
> > -			if (user_alloc_needs_zeroing())
> > -				folio_zero_user(folio, vmf->address);
> > -			return folio;
> > +		if (!folio)
> > +			goto next;
> 
> This applies to the above equivalent refactorings, but maybe worth
> separating out this:
> 
> if (folio) { ... big branch ... } ->
> if (!folio) goto next; ... what was big branch ...
> 
> Refactoring into a separate patch? Makes it easier to see pertinent logic
> changes + helps review/bisectability/fixes/etc. etc.

Will do.

> > +		if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
> > +			count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
> > +			folio_put(folio);
> > +			goto next;
> >  		}
> > +		if (folio_memcg_list_lru_alloc(folio, &deferred_split_lru, gfp)) {
> 
> Again, do we need to uncharge here?

folio_put() does it :)

> > +			folio_put(folio);
> > +			goto fallback;
> > +		}
> > +		folio_throttle_swaprate(folio, gfp);
> > +		/*
> > +		 * When a folio is not zeroed during allocation
> > +		 * (__GFP_ZERO not used) or user folios require special
> > +		 * handling, folio_zero_user() is used to make sure
> > +		 * that the page corresponding to the faulting address
> > +		 * will be hot in the cache after zeroing.
> > +		 */
> > +		if (user_alloc_needs_zeroing())
> > +			folio_zero_user(folio, vmf->address);
> > +		return folio;
> >  next:
> >  		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
> >  		order = next_order(&orders, order);
> > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > index cec7bb758bdd..f293a62e652a 100644
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -1388,19 +1388,6 @@ static void __init calculate_node_totalpages(struct pglist_data *pgdat,
> >  	pr_debug("On node %d totalpages: %lu\n", pgdat->node_id, realtotalpages);
> >  }
> >
> > -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > -static void pgdat_init_split_queue(struct pglist_data *pgdat)
> > -{
> > -	struct deferred_split *ds_queue = &pgdat->deferred_split_queue;
> > -
> > -	spin_lock_init(&ds_queue->split_queue_lock);
> > -	INIT_LIST_HEAD(&ds_queue->split_queue);
> > -	ds_queue->split_queue_len = 0;
> > -}
> > -#else
> > -static void pgdat_init_split_queue(struct pglist_data *pgdat) {}
> > -#endif
> > -
> >  #ifdef CONFIG_COMPACTION
> >  static void pgdat_init_kcompactd(struct pglist_data *pgdat)
> >  {
> > @@ -1416,8 +1403,6 @@ static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
> >
> >  	pgdat_resize_init(pgdat);
> >  	pgdat_kswapd_lock_init(pgdat);
> > -
> > -	pgdat_init_split_queue(pgdat);
> >  	pgdat_init_kcompactd(pgdat);
> >
> >  	init_waitqueue_head(&pgdat->kswapd_wait);
> > --
> > 2.53.0
> >
> 
> Overall a lovely amount of code deletion here :)
> 
> Thanks for doing this, Cheers Lorenzo

Thanks for your feedback!

