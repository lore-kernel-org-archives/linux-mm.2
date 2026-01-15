Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D849DD44C4F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 14:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B3BE6B008A; Thu, 15 Jan 2026 09:09:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 461976B008C; Thu, 15 Jan 2026 09:09:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 343916B0092; Thu, 15 Jan 2026 09:09:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 248BB6B008A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:09:40 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A66F858773
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:09:39 +0000 (UTC)
X-FDA: 84334381278.29.9CEA2DA
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1CFFAA0014
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:09:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VN8umt9L;
	spf=pass (imf25.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768486178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MIpAv8VZm1fyBvDsuUrYNffY2jlmWo53T8xLzmAajew=;
	b=gy5K/QeDH7NOV6nTwSkU8DOzMk6vGGbIs+VAW4vNEDXCHkttHOGG25aWovS+R+JMXsRZ0m
	cvqIijalN3uUaQ/5JaX1pC5DYqbWs9CsoMkpIAV9runwTfF6bxPa9AcDJqh63bORVu/E0j
	a+SByJfQwGB+hLp+HvFISozsa6+8gPU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VN8umt9L;
	spf=pass (imf25.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768486178; a=rsa-sha256;
	cv=none;
	b=l5dBy+yUlfLiBHLELtNzzu0AKJwmcrwhWvdqxmc1lFGbsOg52mlpx1mGDX/08eBsLTRcXc
	eUr963DOvb/0opLfDCIyF2rgF2ck+0XFq95avdSjoCXD5Mkc/ANd1J5eAPEgLP3rdkhjok
	3jJgYUtZx+5bTaubkFBLgtlAL0aqjo0=
Date: Thu, 15 Jan 2026 22:09:17 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768486172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MIpAv8VZm1fyBvDsuUrYNffY2jlmWo53T8xLzmAajew=;
	b=VN8umt9LoiWZ2tZPWRHkFq0mEe2RmnIpAyyZSI+knwUtj96/JTdF52EiEgEuQYVGaFxEIL
	CHQXZ9KUfofeBK0ZbSIDN9feso+Q5vJgWNmHDNRttMJ3dHhmK/VzL8pqC++lXqbvWGa97c
	HXxsXK65FI41Qva87qvPekkCF8pbaoc=
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
Subject: Re: [PATCH RFC v2 12/20] slab: remove defer_deactivate_slab()
Message-ID: <sofeahffu5jj5xbre422lelbisfclwdul2i42j7odth3j4yzil@nyxfavdhwmuz>
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-12-98225cfb50cf@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112-sheaves-for-all-v2-12-98225cfb50cf@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 1CFFAA0014
X-Stat-Signature: 6ppoyigke6zi7wkm61ros7kygf1uctwq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768486175-401617
X-HE-Meta: U2FsdGVkX185nXa0xzPN5GhvJJQBXQOYrWe/TJYRlZud7HRwE7hKsjChI0ijOgFIxXDtaey0SWvlE3B0AszL7LrZLwzaNzHvdZmlBeoRIlpIal8zc2srmWcAcEyFfyf1QeJa8Me88cgGYe3Z88+4w8w7hRu6UBBTJqOIo0LSVKEQgILAGN0d721nCjslrEt49LjQmGo/CcnYkD7qi7zOlZKl3pU1SAlVVD88n+hb1rnq5QaU5W0mfyB9Ob81QRziOliDMaQ/65a8nCHLiIIkWoIsG9S+9cm4gGcpK5MNWhzaY7ITEmeFePF5Se9Yx1DLu3Pxc1UkdeyBZcnMz1HQytdbEATqUBnPMh/3BF1q62pIFy0/ws4kCmxriLAvwfhq6es9nuisrjdhQHqcAR2q9zMvDNCJDbkmBAMR9iqIlnh2CRYRRHoAfHKMNh179A5SGd+6x3VuGGnf5i3alcvG+JkSlQZBLDPg/nlFLh3QhtQp/hPIHG3Mtl7/rdHAVKIiRdBFAa1du1pe2nzikY3vPlt30+Nt84dpMKdjD4JQLaiMkoPC5nHf+25ownC91SftsftCNBXDNSBfn3XhRD6bowQCBO7uwl11GflsaXkRMVR0DJM0wfS72jgLz9YZlt1drk/5s/vfPluy6dtSPhgazTJY2cnRg1CiBgLYBuu3f5AmdPdHSmakqAnoWtV1y/qxelV42goUrRqptgWfAqMztdRO1QEVcN55I4eq0WyLiHsuENU/qvCexZAVXcIHfG1OjMpbjRBXyD5SdoSqRFvZHPgu9+laqGls+JEyjXV3HEIJoqs2J7OsFY6aFuORLRcDkCC/Gpc6Y5JZb7nHBhc8I/pgYU/9IU+RrQbyN/g4rBYpYqkI/8MwmStXC06+MsxSwghgboMRqJezBJ1Qa2ybQjSQb+ErlkexuAPdbdhvUQ89W9iRXAyOxBSlbwQkVlorUzLVMSgcykxy0OT6awC
 n1MnVHrQ
 NjBzHDPtMlDx9KIJDi52In/o0JdOT/kFFFe+/1f9C56IzgIoH3bVpClAcZDkArBdsv5e0xc7QJa0F5IARUF6kfy6UDHmslMzsf5wt7DjXin1xI2PF6y1Ff0Gvcs2i8WevJfSOMxhev6X/tfXGTyXUwn6Fhi979HILQujMbj9N7G9Ki8Js1xbrsb7bGvDKhlOSH78zXGVGVxSaWwLjs2f6aNWprg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 04:17:06PM +0100, Vlastimil Babka wrote:
> There are no more cpu slabs so we don't need their deferred
> deactivation. The function is now only used from places where we
> allocate a new slab but then can't spin on node list_lock to put it on
> the partial list. Instead of the deferred action we can free it directly
> via __free_slab(), we just need to tell it to use _nolock() freeing of
> the underlying pages and take care of the accounting.
> 
> Since free_frozen_pages_nolock() variant does not yet exist for code
> outside of the page allocator, create it as a trivial wrapper for
> __free_frozen_pages(..., FPI_TRYLOCK).
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/internal.h   |  1 +
>  mm/page_alloc.c |  5 +++++
>  mm/slab.h       |  8 +-------
>  mm/slub.c       | 51 ++++++++++++++++-----------------------------------
>  4 files changed, 23 insertions(+), 42 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index e430da900430..1f44ccb4badf 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -846,6 +846,7 @@ static inline struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned int ord
>  struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned int order);
>  #define alloc_frozen_pages_nolock(...) \
>  	alloc_hooks(alloc_frozen_pages_nolock_noprof(__VA_ARGS__))
> +void free_frozen_pages_nolock(struct page *page, unsigned int order);
>  
>  extern void zone_pcp_reset(struct zone *zone);
>  extern void zone_pcp_disable(struct zone *zone);
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 822e05f1a964..8a288ecfdd93 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2981,6 +2981,11 @@ void free_frozen_pages(struct page *page, unsigned int order)
>  	__free_frozen_pages(page, order, FPI_NONE);
>  }
>  
> +void free_frozen_pages_nolock(struct page *page, unsigned int order)
> +{
> +	__free_frozen_pages(page, order, FPI_TRYLOCK);
> +}
> +
>  /*
>   * Free a batch of folios
>   */
> diff --git a/mm/slab.h b/mm/slab.h
> index e77260720994..4efec41b6445 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -71,13 +71,7 @@ struct slab {
>  	struct kmem_cache *slab_cache;
>  	union {
>  		struct {
> -			union {
> -				struct list_head slab_list;
> -				struct { /* For deferred deactivate_slab() */
> -					struct llist_node llnode;
> -					void *flush_freelist;
> -				};
> -			};
> +			struct list_head slab_list;
>  			/* Double-word boundary */
>  			struct freelist_counters;
>  		};
> diff --git a/mm/slub.c b/mm/slub.c
> index 522a7e671a26..0effeb3b9552 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3248,7 +3248,7 @@ static struct slab *new_slab(struct kmem_cache *s, gfp_t flags, int node)
>  		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
>  }
>  
> -static void __free_slab(struct kmem_cache *s, struct slab *slab)
> +static void __free_slab(struct kmem_cache *s, struct slab *slab, bool allow_spin)
>  {
>  	struct page *page = slab_page(slab);
>  	int order = compound_order(page);
> @@ -3262,11 +3262,20 @@ static void __free_slab(struct kmem_cache *s, struct slab *slab)
>  	free_frozen_pages(page, order);

Here we missed using the newly added allow_spin.
It should call free_frozen_pages_nolock() when !allow_spin.

-- 
Thanks,
Hao

>  }
>  
> +static void free_new_slab_nolock(struct kmem_cache *s, struct slab *slab)
> +{
> +	/*
> +	 * Since it was just allocated, we can skip the actions in
> +	 * discard_slab() and free_slab().
> +	 */
> +	__free_slab(s, slab, false);
> +}
> +
>  static void rcu_free_slab(struct rcu_head *h)
>  {
>  	struct slab *slab = container_of(h, struct slab, rcu_head);
>  
> -	__free_slab(slab->slab_cache, slab);
> +	__free_slab(slab->slab_cache, slab, true);
>  }
>  
>  static void free_slab(struct kmem_cache *s, struct slab *slab)
> @@ -3282,7 +3291,7 @@ static void free_slab(struct kmem_cache *s, struct slab *slab)
>  	if (unlikely(s->flags & SLAB_TYPESAFE_BY_RCU))
>  		call_rcu(&slab->rcu_head, rcu_free_slab);
>  	else
> -		__free_slab(s, slab);
> +		__free_slab(s, slab, true);
>  }
>  
>  static void discard_slab(struct kmem_cache *s, struct slab *slab)
> @@ -3375,8 +3384,6 @@ static void *alloc_single_from_partial(struct kmem_cache *s,
>  	return object;
>  }
>  
> -static void defer_deactivate_slab(struct slab *slab, void *flush_freelist);
> -
>  /*
>   * Called only for kmem_cache_debug() caches to allocate from a freshly
>   * allocated slab. Allocate a single object instead of whole freelist
> @@ -3392,8 +3399,8 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
>  	void *object;
>  
>  	if (!allow_spin && !spin_trylock_irqsave(&n->list_lock, flags)) {
> -		/* Unlucky, discard newly allocated slab */
> -		defer_deactivate_slab(slab, NULL);
> +		/* Unlucky, discard newly allocated slab. */
> +		free_new_slab_nolock(s, slab);
>  		return NULL;
>  	}
>  
> @@ -4262,7 +4269,7 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
>  
>  		if (!spin_trylock_irqsave(&n->list_lock, flags)) {
>  			/* Unlucky, discard newly allocated slab */
> -			defer_deactivate_slab(slab, NULL);
> +			free_new_slab_nolock(s, slab);
>  			return 0;
>  		}
>  	}
> @@ -6031,7 +6038,6 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  
>  struct defer_free {
>  	struct llist_head objects;
> -	struct llist_head slabs;
>  	struct irq_work work;
>  };
>  
> @@ -6039,7 +6045,6 @@ static void free_deferred_objects(struct irq_work *work);
>  
>  static DEFINE_PER_CPU(struct defer_free, defer_free_objects) = {
>  	.objects = LLIST_HEAD_INIT(objects),
> -	.slabs = LLIST_HEAD_INIT(slabs),
>  	.work = IRQ_WORK_INIT(free_deferred_objects),
>  };
>  
> @@ -6052,10 +6057,9 @@ static void free_deferred_objects(struct irq_work *work)
>  {
>  	struct defer_free *df = container_of(work, struct defer_free, work);
>  	struct llist_head *objs = &df->objects;
> -	struct llist_head *slabs = &df->slabs;
>  	struct llist_node *llnode, *pos, *t;
>  
> -	if (llist_empty(objs) && llist_empty(slabs))
> +	if (llist_empty(objs))
>  		return;
>  
>  	llnode = llist_del_all(objs);
> @@ -6079,16 +6083,6 @@ static void free_deferred_objects(struct irq_work *work)
>  
>  		__slab_free(s, slab, x, x, 1, _THIS_IP_);
>  	}
> -
> -	llnode = llist_del_all(slabs);
> -	llist_for_each_safe(pos, t, llnode) {
> -		struct slab *slab = container_of(pos, struct slab, llnode);
> -
> -		if (slab->frozen)
> -			deactivate_slab(slab->slab_cache, slab, slab->flush_freelist);
> -		else
> -			free_slab(slab->slab_cache, slab);
> -	}
>  }
>  
>  static void defer_free(struct kmem_cache *s, void *head)
> @@ -6102,19 +6096,6 @@ static void defer_free(struct kmem_cache *s, void *head)
>  		irq_work_queue(&df->work);
>  }
>  
> -static void defer_deactivate_slab(struct slab *slab, void *flush_freelist)
> -{
> -	struct defer_free *df;
> -
> -	slab->flush_freelist = flush_freelist;
> -
> -	guard(preempt)();
> -
> -	df = this_cpu_ptr(&defer_free_objects);
> -	if (llist_add(&slab->llnode, &df->slabs))
> -		irq_work_queue(&df->work);
> -}
> -
>  void defer_free_barrier(void)
>  {
>  	int cpu;
> 
> -- 
> 2.52.0
> 

