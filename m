Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 289A1EDB7E5
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 09:55:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 509596B0088; Tue,  7 Apr 2026 05:55:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BA996B0089; Tue,  7 Apr 2026 05:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A95B6B008A; Tue,  7 Apr 2026 05:55:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 23C0B6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 05:55:18 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AC8D9BAE46
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 09:55:17 +0000 (UTC)
X-FDA: 84631301874.01.D4FD877
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 232F3160011
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 09:55:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BvgwQN0V;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775555716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uts94TTHdOUUxI6Ddi6c0BRUj8bnIJL3KSanAizqlsE=;
	b=zUUnP+xLATbuBBDWMC8erdKof2Gp2O1jmERm2CqLNGslBr9SPg5Rt0rd2gkvCWJaO34fkG
	EEKqoTKvPIEK8kPb9MRz5Hq3Bqa6tE2oLJDCL3huLZu2bzQ/YBQsAszDgfB6fPgoR2kKkS
	TyJS5MkqU+xFLrntiawVnLJI1ZhGklk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BvgwQN0V;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775555716; a=rsa-sha256;
	cv=none;
	b=y4p2G6I3hSS52EJxjzDBFPAUCsEoUfNAy65eSpJjAwYifZBC8rM4oJN668B3Sijvqv/kNo
	emdPla0KHPY6MehkIC4LJZsmLE/CdtcP3hiqWm37LRpIu2EtJL85mgfBR/2CyAvI4PWJOJ
	46hHikgIXATnPXRRVltp0wcW003OkW4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6EEFA600CB;
	Tue,  7 Apr 2026 09:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36357C116C6;
	Tue,  7 Apr 2026 09:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775555715;
	bh=iIg1uWEZrFQPdTqpyJVl9Vs4MBK1inkoiOVZ1r/0N38=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BvgwQN0V2tBvVYYgNIEXMZM/PBqTIcYpisi29agGWK7AoUYDNdp2RDd+LbcqiXemm
	 DP4gxZOOsBI6tE/YT7MjNb61hFf/byEzmgFHG+kd5YoXTLhG9j8x9el7j2bjTjskBa
	 uu3redR2yK16YgP8XYyGye9mzBYGeZNQilzbNbQtBogTq1OTU9GWj2Khk3vrhJCdP3
	 eK89lzUwMTHklNmmEUE5EO+gtEI3LqhlEZLBdcAScqK8GyigLq08mKNt7Zwgzi/hFk
	 r1YMc5Okx3Cd0LT4UqwsT0RKQnCzoCgG0z4mdYRp/12tIe+COLxd9guqHJzS7nPF3y
	 EQiK+PLYXg95Q==
Date: Tue, 7 Apr 2026 10:55:09 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/7] mm: switch deferred split shrinker to list_lru
Message-ID: <adTSMX9AuaPrR4Mk@lucifer>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-8-hannes@cmpxchg.org>
 <0cf8a859-b142-4e53-9113-94872dd68f40@lucifer.local>
 <acqndkLvpRI9bgRK@cmpxchg.org>
 <a87fdbf4-8e30-465f-b3bd-9ed3ba97c684@lucifer.local>
 <adQnp7d8UJQipDSj@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adQnp7d8UJQipDSj@cmpxchg.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 232F3160011
X-Stat-Signature: a1ranjwer66j8tb6xr1zcxwao6whpdek
X-Rspam-User: 
X-HE-Tag: 1775555715-651244
X-HE-Meta: U2FsdGVkX19vMoPp3geVzv5s0TCICNCxiWPcJ0HQXTi0ZicCLpB6VTh27VRdIA3nSkzSliydFQn1x49ggLrmmCJc9756FQw2roVQsj5YN3VZHkcMoP3j2hj4C5vvEzS1p8sSnFZPLIHbnzb+8FJk9OmIojbNYudaj1+Krw5SZL7Ig8gT+GvKWtEwX6ml1yVVyuTq/TrpbUnEUgraaZ1/qAL5DBOEtRqXSv3l8g2keF08C+h+3yzuE9B4Dadj24LwGzDp3pqmm5JjrRm/lYZ1g5u9CJN1Ox8yk/0+GoL1Go1o2WKJDpi3T+YunKnfqPLBZhU4ibmCzRjxYyXb4nw56ka5nFdCyw96rSgR20hqipuoY+P9UfBl2++VQSvQJakPGrmJ8kebX9/Oycn+LabtM6+xtj0j3m7LiCZYDMQOh3FkjqhqtJkkUnWQNFkklJql6/WGC+pu87wemHHVK4tQkwQBQgASQFPyi123kK9iBsMnU5qDS2IKwXzI9VQVdeKsO3e27VmMIpvY0kgG6MSB67VZ7XP+0XuGRM+/RmYJKqfIr4C7Y1Xysn6K/gXKP1Urn6o87ZjWrHDg4cjqxwM1oOic9cb4aZil5PS+saCpEIVumBpnQUe59HaK0gnSoXtnfskZ73FOvBI7zdoZJI7ZNZlXNr0qHx/JYXTbxDpEbPaDEkCYQCRq/+1L4a1OHq/c21NKWshnyMKHkvpyR3ETnoTcIF+PVlC0ucvW2wpe5jQ6sflM5s1mkWZBH3E8TIFV2XBKSgAA83Df8xwvOnwCoFK5Q+O5VisaLXVTmWamNEYk1/pYDSAkltWLH+wsZf/hHjdM9fBwz4vIulfvwYQqqPmr04y67fq29EDtL6LZK5NV5BWl017VcPGuULD7+mbnj8IvIRA8HFc/GlyKdEqIMtXWXNc3/ysLLphX89ZgSXD5j6pYCQkYfuCgWNfAA7KBEr+4UV/1cDjGlTt9h5T
 ZP4Av04u
 aH1Y2ANT9iEzqMcXjL/sdzzaLlSYhIPHi4z4kkc/cyvs9S1v3fi8c3Syq3xLIOLG0wR77lELpbe/Ils7bddhVWC+FCDQNkJW6cz7G8gazTgfDFAd97RjKBYcamV8cxFMbwR7L+B7E66kWeTsnhLach0GfAKjn5NtHO1+gm3yenAlBvU4K22gQk7uh6w5OOZdK3PEC6WI1KVJr0eANdOT7WIEC/PoWAtIfdSHFyGkt03uqkRshSJ2xVMCNa+JZvfyHMlrD0ZFDSqBfVpbv4WAQbHp2WKbnIIkU+AiLxa1sH3gJq77D7+B/mcJMkHhAWce7K3fI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 06, 2026 at 05:37:43PM -0400, Johannes Weiner wrote:
> On Wed, Apr 01, 2026 at 06:33:04PM +0100, Lorenzo Stoakes (Oracle) wrote:
> > On Mon, Mar 30, 2026 at 12:40:22PM -0400, Johannes Weiner wrote:
> > > > > @@ -414,10 +414,9 @@ static inline int split_huge_page(struct page *page)
> > > > >  {
> > > > >  	return split_huge_page_to_list_to_order(page, NULL, 0);
> > > > >  }
> > > > > +
> > > > > +extern struct list_lru deferred_split_lru;
> > > >
> > > > It might be nice for the sake of avoiding a global to instead expose this
> > > > as a getter?
> > > >
> > > > Or actually better, since every caller outside of huge_memory.c that
> > > > references this uses folio_memcg_list_lru_alloc(), do something like:
> > > >
> > > > int folio_memcg_alloc_deferred(struct folio *folio, gfp_t gfp);
> > > >
> > > > in mm/huge_memory.c:
> > > >
> > > > /**
> > > >  * blah blah blah put on error blah
> > > >  */
> > > > int folio_memcg_alloc_deferred(struct folio *folio, gfp_t gfp)
> > > > {
> > > > 	int err;
> > > >
> > > > 	err = folio_memcg_list_lru_alloc(folio, &deferred_split_lru, gfP);
> > > > 	if (err) {
> > > > 		folio_put(folio);
> > > > 		return err;
> > > > 	}
> > > >
> > > > 	return 0;
> > > > }
> > > >
> > > > And then the callers can just invoke this, and you can make
> > > > deferred_split_lru static in mm/huge_memory.c?
> > >
> > > That sounds reasonable. Let me make this change.
> >
> > Thanks!
>
> Done. This looks much nicer. Though I kept the folio_put() in the
> caller because that's who owns the reference. It would be quite
> unexpected for this one to consume a ref on error.

Thanks :) Ack on folio_put()!

>
> > > > > @@ -939,6 +949,7 @@ static int __init thp_shrinker_init(void)
> > > > >
> > > > >  	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
> > > > >  	if (!huge_zero_folio_shrinker) {
> > > > > +		list_lru_destroy(&deferred_split_lru);
> > > > >  		shrinker_free(deferred_split_shrinker);
> > > >
> > > > Presumably no probably-impossible-in-reality race on somebody entering the
> > > > shrinker and referencing the deferred_split_lru before the shrinker is freed?
> > >
> > > Ah right, I think for clarity it would indeed be better to destroy the
> > > shrinker, then the queue. Let me re-order this one.
> > >
> > > But yes, in practice, none of the above fails. If we have trouble
> > > doing a couple of small kmallocs during a subsys_initcall(), that
> > > machine is unlikely to finish booting, let alone allocate enough
> > > memory to enter the THP shrinker.
> >
> > Yeah I thought that might be the case, but seems more logical killing shrinker
> > first, thanks!
>
> Done.

Thanks!

>
> > > > > @@ -3854,34 +3761,34 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
> > > > >  	struct folio *end_folio = folio_next(folio);
> > > > >  	struct folio *new_folio, *next;
> > > > >  	int old_order = folio_order(folio);
> > > > > +	struct list_lru_one *l;
> > > >
> > > > Nit, and maybe this is a convention, but hate single letter variable names,
> > > > 'lru' or something might be nicer?
> > >
> > > Yeah I stuck with the list_lru internal naming, which uses `lru` for
> > > the struct list_lru, and `l` for struct list_lru_one. I suppose that
> > > was fine for the very domain-specific code and short functions in
> > > there, but it's grating in large, general MM functions like these.
> > >
> > > Since `lru` is taken, any preferences? llo?
> >
> > ljs? ;)
> >
> > Could be list?
>
> list is taken in some of these contexts already. I may have
> overthought this. lru works fine in those callsites, and is in line
> with what other sites are using (git grep list_lru_one).

OK that works :)

>
> > But, and I _know_ it's nitty sorry, but maybe worth expanding that comment to
> > explain that e.g. 'we must take the folio look prior to the list_lru lock to
> > avoid racing with deferred_split_scan() in accessing the folio reference count'
> > or similar?
>
> Good idea! Done.

Thanks!

>
> > > > > +	int nid = folio_nid(folio);
> > > > >  	unsigned long flags;
> > > > >  	bool unqueued = false;
> > > > >
> > > > >  	WARN_ON_ONCE(folio_ref_count(folio));
> > > > >  	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg_charged(folio));
> > > > >
> > > > > -	ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
> > > > > -	if (!list_empty(&folio->_deferred_list)) {
> > > > > -		ds_queue->split_queue_len--;
> > > > > +	rcu_read_lock();
> > > > > +	l = list_lru_lock_irqsave(&deferred_split_lru, nid, folio_memcg(folio), &flags);
> > > > > +	if (__list_lru_del(&deferred_split_lru, l, &folio->_deferred_list, nid)) {
> > > >
> > > > Maybe worth factoring __list_lru_del() into something that explicitly
> > > > references &folio->_deferred_list rather than open codingin both places?
> > >
> > > Hm, I wouldn't want to encode this into list_lru API, but we could do
> > > a huge_memory.c-local helper?
> > >
> > > folio_deferred_split_del(folio, l, nid)
> >
> > Well, I kind of hate how we're using the global deferred_split_lru all over the
> > place, so a helper woudl be preferable but one that also could be used for
> > khugepaged.c and memory.c also?
>
> This function is used only in huge_memory.c. I managed to make the
> deferred_list_lru static as well without making any changes to this ^
> particular function/callsite.
>
> Let me know, after looking at the delta diff below, if you'd still
> like to see changes here.

Ack will take a look!

>
> > > > > @@ -4534,64 +4438,32 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
> > > > >  		}
> > > > >  		folio_unlock(folio);
> > > > >  next:
> > > > > -		if (did_split || !folio_test_partially_mapped(folio))
> > > > > -			continue;
> > > > >  		/*
> > > > >  		 * Only add back to the queue if folio is partially mapped.
> > > > >  		 * If thp_underused returns false, or if split_folio fails
> > > > >  		 * in the case it was underused, then consider it used and
> > > > >  		 * don't add it back to split_queue.
> > > > >  		 */
> > > > > -		fqueue = folio_split_queue_lock_irqsave(folio, &flags);
> > > > > -		if (list_empty(&folio->_deferred_list)) {
> > > > > -			list_add_tail(&folio->_deferred_list, &fqueue->split_queue);
> > > > > -			fqueue->split_queue_len++;
> > > > > +		if (!did_split && folio_test_partially_mapped(folio)) {
> > > > > +			rcu_read_lock();
> > > > > +			l = list_lru_lock_irqsave(&deferred_split_lru,
> > > > > +						  folio_nid(folio),
> > > > > +						  folio_memcg(folio),
> > > > > +						  &flags);
> > > > > +			__list_lru_add(&deferred_split_lru, l,
> > > > > +				       &folio->_deferred_list,
> > > > > +				       folio_nid(folio), folio_memcg(folio));
> > > > > +			list_lru_unlock_irqrestore(l, &flags);
> > > >
> > > > Hmm this does make me think it'd be nice to have a list_lru_add() variant
> > > > for irqsave/restore then, since it's a repeating pattern!
> > >
> > > Yeah, this site calls for it the most :( I tried to balance callsite
> > > prettiness with the need to extend the list_lru api; it's just one
> > > caller. And the possible mutations and variants with these locks is
> > > seemingly endless once you open that can of worms...
> >
> > True...
> >
> > >
> > > Case in point: this is process context and we could use
> > > spin_lock_irq() here. I'm just using list_lru_lock_irqsave() because
> > > that's the common variant used by the add and del paths already.
> > >
> > > If I went with a helper, I could do list_lru_add_irq().
> > >
> > > I think it would actually nicely mirror the list_lru_shrink_walk_irq()
> > > a few lines up.
> >
> > Yeah, I mean I'm pretty sure this repeats quite a few times so is worthy of a
> > helper.
>
> It's only one callsite, actually. But I added the helper. It's churny
> on the list_lru side, but that callsite does look much better.

OK, I was possibly misremembering that then :) I am an advocate of using helpers
like this even for a single callsite if it makes the logic easier to understand,
(generally :>) compilers will do the right thing (TM) so this helps the hunam
bwangs reading the code, i.e. the difficult part of kernel development :)

>
> Anyway, I hope I got everything. Can you take a look? Will obviously
> fold this into the respective patches, but just double checking
> whether these things are what you had in mind.

Thanks, OK so I've put some pleased-sounds below under the various bits but
TL;DR is this looks to address all my concerns.

Feel free to plonk a:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

On this patch on respin! I am trusting obviously that nothing breaks and you've
(re-)tested it :>) obv. :P

Thanks, Lorenzo

>
> ---
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 8d801ed378db..b473605b4d7d 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -415,7 +415,8 @@ static inline int split_huge_page(struct page *page)
>  	return split_huge_page_to_list_to_order(page, NULL, 0);
>  }
>
> -extern struct list_lru deferred_split_lru;
> +int folio_memcg_alloc_deferred(struct folio *folio);
> +
>  void deferred_split_folio(struct folio *folio, bool partially_mapped);
>
>  void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
> diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
> index 4bd29b61c59a..733a262b91e5 100644
> --- a/include/linux/list_lru.h
> +++ b/include/linux/list_lru.h
> @@ -83,6 +83,21 @@ int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
>  			 gfp_t gfp);
>
>  #ifdef CONFIG_MEMCG
> +/**
> + * folio_memcg_list_lru_alloc - allocate list_lru heads for shrinkable folio
> + * @folio: the newly allocated & charged folio
> + * @lru: the list_lru this might be queued on
> + * @gfp: gfp mask
> + *
> + * Allocate list_lru heads (per-memcg, per-node) needed to queue this
> + * particular folio down the line.
> + *
> + * This does memcg_list_lru_alloc(), but on the memcg that @folio is
> + * associated with. Handles folio_memcg() access rules in the fast
> + * path (list_lru heads allocated) and the allocation slowpath.
> + *
> + * Returns 0 on success, a negative error value otherwise.
> + */
>  int folio_memcg_list_lru_alloc(struct folio *folio, struct list_lru *lru,
>  			       gfp_t gfp);

LGTM, nice comment thanks!

>  #else
> @@ -118,6 +133,10 @@ struct list_lru_one *list_lru_lock(struct list_lru *lru, int nid,
>   */
>  void list_lru_unlock(struct list_lru_one *l);
>
> +struct list_lru_one *list_lru_lock_irq(struct list_lru *lru, int nid,
> +		struct mem_cgroup *memcg);
> +void list_lru_unlock_irq(struct list_lru_one *l);
> +
>  struct list_lru_one *list_lru_lock_irqsave(struct list_lru *lru, int nid,
>  		struct mem_cgroup *memcg, unsigned long *irq_flags);
>  void list_lru_unlock_irqrestore(struct list_lru_one *l,
> @@ -161,6 +180,9 @@ bool __list_lru_del(struct list_lru *lru, struct list_lru_one *l,
>  bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
>  		    struct mem_cgroup *memcg);
>
> +bool list_lru_add_irq(struct list_lru *lru, struct list_head *item, int nid,
> +		      struct mem_cgroup *memcg);
> +

Nice!

>  /**
>   * list_lru_add_obj: add an element to the lru list's tail
>   * @lru: the lru pointer
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index c8c6c4602cc7..a0cce6a56620 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -69,7 +69,7 @@ unsigned long transparent_hugepage_flags __read_mostly =
>  	(1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
>
>  static struct lock_class_key deferred_split_key;
> -struct list_lru deferred_split_lru;
> +static struct list_lru deferred_split_lru;

Lovely!

>  static struct shrinker *deferred_split_shrinker;
>  static unsigned long deferred_split_count(struct shrinker *shrink,
>  					  struct shrink_control *sc);
> @@ -913,6 +913,11 @@ static inline void hugepage_exit_sysfs(struct kobject *hugepage_kobj)
>  }
>  #endif /* CONFIG_SYSFS */
>
> +int folio_memcg_alloc_deferred(struct folio *folio)
> +{
> +	return folio_memcg_list_lru_alloc(folio, &deferred_split_lru, GFP_KERNEL);
> +}
> +
>  static int __init thp_shrinker_init(void)
>  {
>  	deferred_split_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
> @@ -949,8 +954,8 @@ static int __init thp_shrinker_init(void)
>
>  	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
>  	if (!huge_zero_folio_shrinker) {
> -		list_lru_destroy(&deferred_split_lru);
>  		shrinker_free(deferred_split_shrinker);
> +		list_lru_destroy(&deferred_split_lru);
>  		return -ENOMEM;
>  	}
>
> @@ -964,8 +969,8 @@ static int __init thp_shrinker_init(void)
>  static void __init thp_shrinker_exit(void)
>  {
>  	shrinker_free(huge_zero_folio_shrinker);
> -	list_lru_destroy(&deferred_split_lru);
>  	shrinker_free(deferred_split_shrinker);
> +	list_lru_destroy(&deferred_split_lru);
>  }
>
>  static int __init hugepage_init(void)
> @@ -1246,7 +1251,7 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
>  		return NULL;
>  	}
>
> -	if (folio_memcg_list_lru_alloc(folio, &deferred_split_lru, GFP_KERNEL)) {
> +	if (folio_memcg_alloc_deferred(folio)) {
>  		folio_put(folio);
>  		count_vm_event(THP_FAULT_FALLBACK);
>  		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
> @@ -3761,31 +3766,37 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>  	struct folio *end_folio = folio_next(folio);
>  	struct folio *new_folio, *next;
>  	int old_order = folio_order(folio);
> -	struct list_lru_one *l;
> +	struct list_lru_one *lru;
>  	bool dequeue_deferred;
>  	int ret = 0;
>
>  	VM_WARN_ON_ONCE(!mapping && end);
> -	/* Prevent deferred_split_scan() touching ->_refcount */
> +	/*
> +	 * If this folio can be on the deferred split queue, lock out
> +	 * the shrinker before freezing the ref. If the shrinker sees
> +	 * a 0-ref folio, it assumes it beat folio_put() to the list
> +	 * lock and must clean up the LRU state - the same dequeue we
> +	 * will do below as part of the split.
> +	 */

Great thanks!

>  	dequeue_deferred = folio_test_anon(folio) && old_order > 1;
>  	if (dequeue_deferred) {
>  		rcu_read_lock();
> -		l = list_lru_lock(&deferred_split_lru,
> -				  folio_nid(folio), folio_memcg(folio));
> +		lru = list_lru_lock(&deferred_split_lru,
> +				    folio_nid(folio), folio_memcg(folio));
>  	}
>  	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
>  		struct swap_cluster_info *ci = NULL;
>  		struct lruvec *lruvec;
>
>  		if (dequeue_deferred) {
> -			__list_lru_del(&deferred_split_lru, l,
> +			__list_lru_del(&deferred_split_lru, lru,
>  				       &folio->_deferred_list, folio_nid(folio));
>  			if (folio_test_partially_mapped(folio)) {
>  				folio_clear_partially_mapped(folio);
>  				mod_mthp_stat(old_order,
>  					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>  			}
> -			list_lru_unlock(l);
> +			list_lru_unlock(lru);
>  			rcu_read_unlock();
>  		}
>
> @@ -3890,7 +3901,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>  			swap_cluster_unlock(ci);
>  	} else {
>  		if (dequeue_deferred) {
> -			list_lru_unlock(l);
> +			list_lru_unlock(lru);
>  			rcu_read_unlock();
>  		}
>  		return -EAGAIN;
> @@ -4268,7 +4279,7 @@ int split_folio_to_list(struct folio *folio, struct list_head *list)
>   */
>  bool __folio_unqueue_deferred_split(struct folio *folio)
>  {
> -	struct list_lru_one *l;
> +	struct list_lru_one *lru;
>  	int nid = folio_nid(folio);
>  	unsigned long flags;
>  	bool unqueued = false;
> @@ -4277,8 +4288,8 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
>  	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg_charged(folio));
>
>  	rcu_read_lock();
> -	l = list_lru_lock_irqsave(&deferred_split_lru, nid, folio_memcg(folio), &flags);
> -	if (__list_lru_del(&deferred_split_lru, l, &folio->_deferred_list, nid)) {
> +	lru = list_lru_lock_irqsave(&deferred_split_lru, nid, folio_memcg(folio), &flags);
> +	if (__list_lru_del(&deferred_split_lru, lru, &folio->_deferred_list, nid)) {
>  		if (folio_test_partially_mapped(folio)) {
>  			folio_clear_partially_mapped(folio);
>  			mod_mthp_stat(folio_order(folio),
> @@ -4286,7 +4297,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
>  		}
>  		unqueued = true;
>  	}
> -	list_lru_unlock_irqrestore(l, &flags);
> +	list_lru_unlock_irqrestore(lru, &flags);
>  	rcu_read_unlock();
>
>  	return unqueued;	/* useful for debug warnings */
> @@ -4295,7 +4306,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
>  /* partially_mapped=false won't clear PG_partially_mapped folio flag */
>  void deferred_split_folio(struct folio *folio, bool partially_mapped)
>  {
> -	struct list_lru_one *l;
> +	struct list_lru_one *lru;
>  	int nid;
>  	struct mem_cgroup *memcg;
>  	unsigned long flags;
> @@ -4324,7 +4335,7 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
>
>  	rcu_read_lock();
>  	memcg = folio_memcg(folio);
> -	l = list_lru_lock_irqsave(&deferred_split_lru, nid, memcg, &flags);
> +	lru = list_lru_lock_irqsave(&deferred_split_lru, nid, memcg, &flags);
>  	if (partially_mapped) {
>  		if (!folio_test_partially_mapped(folio)) {
>  			folio_set_partially_mapped(folio);
> @@ -4337,8 +4348,8 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
>  		/* partially mapped folios cannot become non-partially mapped */
>  		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
>  	}
> -	__list_lru_add(&deferred_split_lru, l, &folio->_deferred_list, nid, memcg);
> -	list_lru_unlock_irqrestore(l, &flags);
> +	__list_lru_add(&deferred_split_lru, lru, &folio->_deferred_list, nid, memcg);
> +	list_lru_unlock_irqrestore(lru, &flags);
>  	rcu_read_unlock();
>  }
>
> @@ -4411,8 +4422,6 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>  	list_for_each_entry_safe(folio, next, &dispose, _deferred_list) {
>  		bool did_split = false;
>  		bool underused = false;
> -		struct list_lru_one *l;
> -		unsigned long flags;
>
>  		list_del_init(&folio->_deferred_list);
>
> @@ -4446,14 +4455,10 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>  		 */
>  		if (!did_split && folio_test_partially_mapped(folio)) {
>  			rcu_read_lock();
> -			l = list_lru_lock_irqsave(&deferred_split_lru,
> -						  folio_nid(folio),
> -						  folio_memcg(folio),
> -						  &flags);
> -			__list_lru_add(&deferred_split_lru, l,
> -				       &folio->_deferred_list,
> -				       folio_nid(folio), folio_memcg(folio));
> -			list_lru_unlock_irqrestore(l, &flags);
> +			list_lru_add_irq(&deferred_split_lru,
> +					 &folio->_deferred_list,
> +					 folio_nid(folio),
> +					 folio_memcg(folio));

Also nice :)

>  			rcu_read_unlock();
>  		}
>  		folio_put(folio);
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index a81470f529e3..44a9b1350dbd 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1121,7 +1121,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  	if (result != SCAN_SUCCEED)
>  		goto out_nolock;
>
> -	if (folio_memcg_list_lru_alloc(folio, &deferred_split_lru, GFP_KERNEL))
> +	if (folio_memcg_alloc_deferred(folio))

Much nicer :)

>  		goto out_nolock;
>
>  	mmap_read_lock(mm);
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index 1ccdd45b1d14..23bf7c243083 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -160,6 +160,18 @@ void list_lru_unlock(struct list_lru_one *l)
>  	unlock_list_lru(l, /*irq_off=*/false, /*irq_flags=*/NULL);
>  }
>
> +struct list_lru_one *list_lru_lock_irq(struct list_lru *lru, int nid,
> +				       struct mem_cgroup *memcg)
> +{
> +	return lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/true,
> +				      /*irq_flags=*/NULL, /*skip_empty=*/false);
> +}
> +
> +void list_lru_unlock_irq(struct list_lru_one *l)
> +{
> +	unlock_list_lru(l, /*irq_off=*/true, /*irq_flags=*/NULL);
> +}
> +
>  struct list_lru_one *list_lru_lock_irqsave(struct list_lru *lru, int nid,
>  					   struct mem_cgroup *memcg,
>  					   unsigned long *flags)
> @@ -213,6 +225,18 @@ bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
>  	return ret;
>  }
>
> +bool list_lru_add_irq(struct list_lru *lru, struct list_head *item,
> +		      int nid, struct mem_cgroup *memcg)
> +{
> +	struct list_lru_one *l;
> +	bool ret;
> +
> +	l = list_lru_lock_irq(lru, nid, memcg);
> +	ret = __list_lru_add(lru, l, item, nid, memcg);
> +	list_lru_unlock_irq(l);
> +	return ret;
> +}
> +
>  bool list_lru_add_obj(struct list_lru *lru, struct list_head *item)
>  {
>  	bool ret;
> diff --git a/mm/memory.c b/mm/memory.c
> index 24dd531125b4..23da4720576d 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4658,8 +4658,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>  			folio_put(folio);
>  			goto next;
>  		}
> -		if (order > 1 &&
> -		    folio_memcg_list_lru_alloc(folio, &deferred_split_lru, GFP_KERNEL)) {
> +		if (order > 1 && folio_memcg_alloc_deferred(folio)) {
>  			folio_put(folio);
>  			goto fallback;
>  		}
> @@ -5183,8 +5182,7 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
>  			folio_put(folio);
>  			goto next;
>  		}
> -		if (order > 1 &&
> -		    folio_memcg_list_lru_alloc(folio, &deferred_split_lru, GFP_KERNEL)) {
> +		if (order > 1 && folio_memcg_alloc_deferred(folio)) {

Yeah big improvements on both!

>  			folio_put(folio);
>  			goto fallback;
>  		}

