Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 157D6D4A603
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 06:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F7A26B0089; Fri, 16 Jan 2026 01:27:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5AF6B008A; Fri, 16 Jan 2026 01:27:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C4DC6B008C; Fri, 16 Jan 2026 01:27:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D8056B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 01:27:47 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 24AAF1BDB3
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:27:47 +0000 (UTC)
X-FDA: 84336846174.09.B88CE98
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8F424140004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:27:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YTxvBXK0;
	spf=pass (imf09.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768544865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZtRqq1YheiNBBvVmImDMizfzqDOKIgcriEPR9727W+A=;
	b=YVrLBvSYYnHWORw3zIp5QM1jY5wrs2aRBi6MlcmGb5RZov4JIVd68sA60REMK86xU6RrFo
	H3hbzs2OrEKP9++JqDnEBZzG0tVOkdGd81ZLnSHBZemCHpD0vRlY1J0TcgSl7Qg1nT8GCh
	g4Khh+UiQ09zFitfe0tEzH61uHbQE8A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YTxvBXK0;
	spf=pass (imf09.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768544865; a=rsa-sha256;
	cv=none;
	b=XawjZg0PtRzuK2GKox4eoKRc3/sqM1LUMzW+Rv6aQFePJWgnErx41KRVgmTnd3Z3oY4/f7
	dZdm7+4pIA+FXKk1ESzO5ig+sybdqfjJU0sRD8PmiuBgWLDQZ9EbDtKf6U3zyzjKhQFQlR
	IudQq7lqfqLnWPbrlSY5szcrf/85478=
Date: Fri, 16 Jan 2026 14:27:28 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768544859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZtRqq1YheiNBBvVmImDMizfzqDOKIgcriEPR9727W+A=;
	b=YTxvBXK0JBNk0RbWd3h8MJih88revancn1zLe8lx27VZO9joNgTadN2VzM/l6k1bIL5pap
	czE0RgU8pSmFOxCnYRduit8IdxaQhwO+0ObsWermDa+LI1bEr82fMrAXrzsmmlZa4XhfDI
	xw1CXap5a2b4p/rnYcg01tNYL6P88+U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH RFC v2 08/20] slab: add optimized sheaf refill from
 partial list
Message-ID: <kp7fvhxxjyyzk47n67m4xwzgm7gxoqmgglqdvzpkcxqb26sjc4@bu4lil75nc3c>
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-8-98225cfb50cf@suse.cz>
 <38de0039-e0ea-41c4-a293-400798390ea1@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38de0039-e0ea-41c4-a293-400798390ea1@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8F424140004
X-Stat-Signature: 8pbw5jj6snm6sfz1bopnimzr9iwyqo4y
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768544863-906383
X-HE-Meta: U2FsdGVkX1/Ei7GR6KcSSt8xHb/XT2mvaMCZtDQ85h/9AGAf+ek+mtRymYdJoy0ZEAb5HhreLejv/Zu8C5ss2jZuwLZwj8RIo+LkbIAMvVqOfr6yz7DNPE5NXHo7r04XHVWRaZnT/VQNF2McZwphJ5S5FCB7uvJ6irhf21phXbQEbc5GbU7jtBqF6gSsPpNVXhTF0BZ6ZA2w/pxdMXM8MfFZNzgD5bwkEvdNDx98CeAU8ArL2b/slCJfOjazbE1LPmgu4ZWXgOMEqw6ZfPfIMhaQO+MjCgjmcBQMDfaCyNuS0xzHdpo213obceS1/d6zEZaOZ5YeUvIdYQ8QZgExlsEbUl/rU+VHa7SX5tH4nAYdGAsym9WvgMwQv3+XYyUKe1pmipyNluZU9ELHRnpk/OmvpmjdmL3F/kagU0wVWoxBUSkGEhTyhqsC3H5msJw+LO63bGHOT8TCevauhrzk0lWr8qE+e1GVpUdAHYmVpZBvBYkGwMxwCQAmCpFp91Mhh5+3fj196xIQ/Jt+qvLdLONtN+HuFLTdRQgllBVu3uhLw4ZoOQ37s4eQtKLHBPr/zfb8lUIowiOrQc6ZtvE1MmmptyBDH4mWM/Ioo33F3CsWulMq8aTQll/gdoPs8hynjth2WoADP094g2CuvVfVjJITdD91Nige3llwuNCGDGs0X0ORzOpB90PkcuJzy55zNyA1fhQc/LWEGAGAV7hwGfv9QF2iTPNdeO2GoL0t5r6vMtC38L8TjRNFgQpAdOeY8AbcdhvKF+T/oOcnLACKKJvs5QD92zGNqrMO334VTqlCaAQxhg3p8axj36c/xf+GtD/LBz0r9vcqhyeJOrhcujAQn/f3sKZe0ndhPk/+TOpu2qNzy++URgXR7G0iBzXLLFQW6bngjfzGECmpw5HtX65bBJ8dQbOk3ebvD+ct3pJ3MQb4QjXzXkn9ABMAo2mYelDRQSYjW3/Fitk1TX+
 B8eTs59e
 DT6vs1q/7Kxf9aUin18trVNsQHEOjVrw6+RmP3F/4vAjOTRmN/GgEAj1LU7Rxq5xKIiicvJaiV2NJfS1zv2f3OoBQ/Zlx32Y71syFbUB8PpuxRgNpPtgE9XAiuuYs2punKqbrA9GahXlgWHPCt3aoX2Fo8S3MlWs2oXq7o0Ml5apQLB1J4zhf/ixxl+aEhbu+PKblbTjiZWXTWsnDiaHcGZIsmw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 03:25:59PM +0100, Vlastimil Babka wrote:
> On 1/12/26 16:17, Vlastimil Babka wrote:
> > At this point we have sheaves enabled for all caches, but their refill
> > is done via __kmem_cache_alloc_bulk() which relies on cpu (partial)
> > slabs - now a redundant caching layer that we are about to remove.
> > 
> > The refill will thus be done from slabs on the node partial list.
> > Introduce new functions that can do that in an optimized way as it's
> > easier than modifying the __kmem_cache_alloc_bulk() call chain.
> > 
> > Extend struct partial_context so it can return a list of slabs from the
> > partial list with the sum of free objects in them within the requested
> > min and max.
> > 
> > Introduce get_partial_node_bulk() that removes the slabs from freelist
> > and returns them in the list.
> > 
> > Introduce get_freelist_nofreeze() which grabs the freelist without
> > freezing the slab.
> > 
> > Introduce alloc_from_new_slab() which can allocate multiple objects from
> > a newly allocated slab where we don't need to synchronize with freeing.
> > In some aspects it's similar to alloc_single_from_new_slab() but assumes
> > the cache is a non-debug one so it can avoid some actions.
> > 
> > Introduce __refill_objects() that uses the functions above to fill an
> > array of objects. It has to handle the possibility that the slabs will
> > contain more objects that were requested, due to concurrent freeing of
> > objects to those slabs. When no more slabs on partial lists are
> > available, it will allocate new slabs. It is intended to be only used
> > in context where spinning is allowed, so add a WARN_ON_ONCE check there.
> > 
> > Finally, switch refill_sheaf() to use __refill_objects(). Sheaves are
> > only refilled from contexts that allow spinning, or even blocking.
> > 
> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> 
> ...
> 
> > +static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
> > +		void **p, unsigned int count, bool allow_spin)
> > +{
> > +	unsigned int allocated = 0;
> > +	struct kmem_cache_node *n;
> > +	unsigned long flags;
> > +	void *object;
> > +
> > +	if (!allow_spin && (slab->objects - slab->inuse) > count) {
> > +
> > +		n = get_node(s, slab_nid(slab));
> > +
> > +		if (!spin_trylock_irqsave(&n->list_lock, flags)) {
> > +			/* Unlucky, discard newly allocated slab */
> > +			defer_deactivate_slab(slab, NULL);
> 
> This actually does dec_slabs_node() only with slab->frozen which we don't set.

Hi, I think I follow the intent, but I got a little tripped up here: patch 08
(current patch) seems to assume "slab->frozen = 1" is already gone. That's true
after the whole series, but the removal only happens in patch 09.

Would it make sense to avoid relying on that assumption when looking at patch 08
in isolation?

> 
> > +			return 0;
> > +		}
> > +	}
> > +
> > +	object = slab->freelist;
> > +	while (object && allocated < count) {
> > +		p[allocated] = object;
> > +		object = get_freepointer(s, object);
> > +		maybe_wipe_obj_freeptr(s, p[allocated]);
> > +
> > +		slab->inuse++;
> > +		allocated++;
> > +	}
> > +	slab->freelist = object;
> > +
> > +	if (slab->freelist) {
> > +
> > +		if (allow_spin) {
> > +			n = get_node(s, slab_nid(slab));
> > +			spin_lock_irqsave(&n->list_lock, flags);
> > +		}
> > +		add_partial(n, slab, DEACTIVATE_TO_HEAD);
> > +		spin_unlock_irqrestore(&n->list_lock, flags);
> > +	}
> 
> So we should only do inc_slabs_node() here.
> This also addresses the problem in 9/20 that Hao Li pointed out...

Yes, thanks,
Looking at the patchset as a whole, I think this part - together with the later
removal of inc_slabs_node() - does address the issue.

> 
> > +	return allocated;
> > +}
> > +
> 
> ...
> 
> > +static unsigned int
> > +__refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
> > +		 unsigned int max)
> > +{
> > +	struct slab *slab, *slab2;
> > +	struct partial_context pc;
> > +	unsigned int refilled = 0;
> > +	unsigned long flags;
> > +	void *object;
> > +	int node;
> > +
> > +	pc.flags = gfp;
> > +	pc.min_objects = min;
> > +	pc.max_objects = max;
> > +
> > +	node = numa_mem_id();
> > +
> > +	if (WARN_ON_ONCE(!gfpflags_allow_spinning(gfp)))
> > +		return 0;
> > +
> > +	/* TODO: consider also other nodes? */
> > +	if (!get_partial_node_bulk(s, get_node(s, node), &pc))
> > +		goto new_slab;
> > +
> > +	list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
> > +
> > +		list_del(&slab->slab_list);
> > +
> > +		object = get_freelist_nofreeze(s, slab);
> > +
> > +		while (object && refilled < max) {
> > +			p[refilled] = object;
> > +			object = get_freepointer(s, object);
> > +			maybe_wipe_obj_freeptr(s, p[refilled]);
> > +
> > +			refilled++;
> > +		}
> > +
> > +		/*
> > +		 * Freelist had more objects than we can accomodate, we need to
> > +		 * free them back. We can treat it like a detached freelist, just
> > +		 * need to find the tail object.
> > +		 */
> > +		if (unlikely(object)) {
> > +			void *head = object;
> > +			void *tail;
> > +			int cnt = 0;
> > +
> > +			do {
> > +				tail = object;
> > +				cnt++;
> > +				object = get_freepointer(s, object);
> > +			} while (object);
> > +			do_slab_free(s, slab, head, tail, cnt, _RET_IP_);
> > +		}
> > +
> > +		if (refilled >= max)
> > +			break;
> > +	}
> > +
> > +	if (unlikely(!list_empty(&pc.slabs))) {
> > +		struct kmem_cache_node *n = get_node(s, node);
> > +
> > +		spin_lock_irqsave(&n->list_lock, flags);
> > +
> > +		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
> > +
> > +			if (unlikely(!slab->inuse && n->nr_partial >= s->min_partial))
> > +				continue;
> > +
> > +			list_del(&slab->slab_list);
> > +			add_partial(n, slab, DEACTIVATE_TO_HEAD);
> > +		}
> > +
> > +		spin_unlock_irqrestore(&n->list_lock, flags);
> > +
> > +		/* any slabs left are completely free and for discard */
> > +		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
> > +
> > +			list_del(&slab->slab_list);
> > +			discard_slab(s, slab);
> > +		}
> > +	}
> > +
> > +
> > +	if (likely(refilled >= min))
> > +		goto out;
> > +
> > +new_slab:
> > +
> > +	slab = new_slab(s, pc.flags, node);
> > +	if (!slab)
> > +		goto out;
> > +
> > +	stat(s, ALLOC_SLAB);
> > +	inc_slabs_node(s, slab_nid(slab), slab->objects);
> 
> And remove it from here.
> 
> > +
> > +	/*
> > +	 * TODO: possible optimization - if we know we will consume the whole
> > +	 * slab we might skip creating the freelist?
> > +	 */
> > +	refilled += alloc_from_new_slab(s, slab, p + refilled, max - refilled,
> > +					/* allow_spin = */ true);
> > +
> > +	if (refilled < min)
> > +		goto new_slab;
> > +out:
> > +
> > +	return refilled;
> > +}
> > +
> >  static inline
> >  int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
> >  			    void **p)
> > 
> 

