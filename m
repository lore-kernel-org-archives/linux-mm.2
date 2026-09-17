Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AF9CC982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:13:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 423DB6B008C; Thu, 17 Sep 2026 05:13:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D51B6B0092; Thu, 17 Sep 2026 05:13:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EC336B009D; Thu, 17 Sep 2026 05:13:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 014BD6B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:13:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B84DC0288
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:13:49 +0000 (UTC)
X-FDA: 85222691778.27.2ACC4E4
Received: from mta0.migadu.com (out-222.mta0.migadu.com [91.218.175.222])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6E4928000A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:13:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QRy2KXqQ;
	spf=pass (imf02.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.222 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789636427;
	b=Svewta+8zNV7uqSvhIrkYJ75yOiMuXyLAcYUBgZEfcHPFZen8VUFLG3U/yDAiSCmCv3Upn
	2yGUjrchRgDRwI+u9CG0tZ7g5AtMlUC+7pNFRj3Gl1ayHlZ6McSBwCaRxNMcZBvxdSV2Ax
	i79F9QdrC/9bOvVyzgFxjA5L4iDFcsM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QRy2KXqQ;
	spf=pass (imf02.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.222 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789636427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YPtwYOVDllfTigYn6WwV0UAuadX7yRLBIaKQhkAiL84=;
	b=xU8e1TW5cxPadMfDFqD4HqwtIST1u+hYZOWFgYrXZcq/tSikNfz5Dveo14QeFTxeysggw2
	gHOiTnnthBr/7TyH6x/KlBCmI0zZqsZ1gGtxKmYusHPzVDsuzfh3C50nHJs8ecZ3ZKSAa3
	NL8/XK6MMJNOMN5TvwnL6Qehcs8hmBg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BvI+zmx0bHsSDRwo8/eGXtzYLY6Y0EC/pcKbtQ5XLG8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789636426; v=1; x=1790241226;
 b=QRy2KXqQu6WCdJRyUYRN2Tg1fZOy//8PfYrpGbsf7QCOQd8NyM0i6hjR88ZEhcxdxBb4TERl
 i9bRu34LxQbzjSS3tDfZkO9+8JKRt5dKsM1KVurw4QuKt7ff6PHV6OQg+BVg0jY6dK7V3DdW4Fj
 8RZ/hKulSICy/cI5dRnUMqkE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ec8b15142238164a;
	Thu, 17 Sep 2026 09:13:45 +0000
X-Mizu-Trace-ID: ec8b15142238164a
X-Migadu-Flow: FLOW_OUT
Date: Thu, 17 Sep 2026 17:13:39 +0800
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, harry@kernel.org, 
	akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] mm/slub: introduce slab parking to reduce
 list_lock contention
Message-ID: <aqun4pdMge4QVmnL@fedora>
References: <20260824122004.3652-1-hao.li@linux.dev>
 <20260824122513.3829-1-hao.li@linux.dev>
 <20260824122513.3829-2-hao.li@linux.dev>
 <8d73f087-42e2-454c-8e5f-93c1b64cb969@kernel.org>
 <aqPlMzUIw-4g2iOX@fedora>
 <23b15032-01c3-43fa-866f-296138228b5a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23b15032-01c3-43fa-866f-296138228b5a@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6E4928000A
X-Rspam-User: 
X-Stat-Signature: gfbwtbhzmyqeswozwxcy3d69im54incj
X-HE-Tag: 1789636427-554723
X-HE-Meta: U2FsdGVkX18p4UIg7+kxQTNozC+M1iumHn0DohjO75BpGJ/TwaiyBtz2vygriFPXcigwwjOWfp+1VU/GWEbkDnnV0J4BUtvoYaG/hTutIiCTvfegtvi84UVTzumQDZJSo/1fV2McrfWD8sfXbbaJ8xGR7yvX4DEtE4YYCmteM8JxZrux+m9I3FhhWY+hEnRHFwQoLVirHIpdc9ZKs+Kjo92ovLUUKArwGlWdyQXID68iCJVoDamejwtQVZAW/fuHodgcpDLEUI2DpTjZe8SFts36bfhj49he6APmq/a0m/kUCnu7rBfWku9v8GhlqU6MJtnDMyQMjcCkKzfuGI3Vck3ztNFkHIXlhD3HGM04n0ZmRA1KAfIhO7oWSb5nARkFdMJhHkDAuB3NNnhOPpv7kusUsgMlCMrBWagP2P4URygEJeuU+1v23eiNPFSS7WKcgDcQ4xGvmdoKNK/0Bsb8V6imXAjOzfkFAyv62xZNvcVCEwoxibEVzyr2zmXezWhwOtC7/mOyYRdkvAfJi5B3uajHDCra5+cknMgHPWszH8rlhUXMaKaOsc5r8045B6LCjDF//Rser1rBlQtTTQW4wLL0f1zuhYVUpoppNmrbh1eKRfSIr5Jc8Z7Gy88m1rCkw8hXeQQxCoEjlIbu9ijCXahqrMpi7z2HwvFFZcvkD1aV3DKBEd1mLurotbfzhbi/hm4+K/En8ec+Bd0sdVAJn7e+T+JeZ1rjJutFwx4hKSl2lqJHVhTO5IMMpP+QenaHCS87mb8Ga0YdqTBJsUKmaBGLq1UL3tuuWDy/Vq6zpsLSx/8PJvRb0z7u7YUd8qC+liUI3mZWHebbc09S39MfmMHbrZvevjpFA+4QMnmmrNpEv6ofzkEMuC+QbJ7kvreqR9fNVB9GpfYLaL1O7nOHlKGVhyM7IVKpy9nvdDL1T5WBwI4ZibKghGdp8ZjSPlkVlzH8zyigVRvvM9naSdo
 057tcUo4
 KZrRdUWdcjjh2VvNvJEazzUPmb3n2qUZdgEiUmDXDVahi98MSmLIgU1SFKckbmX9IhKBBl3B0X3sPyG/ulgcG4o5722jt6Vnuur8uormc+i5X8lgZXQAOIHb/9C1IIfCOqKgFTlpoCteaG2tC72/grmfJNlT9TTpNGNd9RfyO79ljaaXP8nRrmqnRCcXrqNgwQbjgrhl4C2DShB+pNc/vzG+UtcChX1Jpqhi+j3E+eUwVaE4aPZAZm4JKIuGmhCdT0O9Tmk9+9N+ufvVC8rUd9iUWQanoRyJdidioDlPbBalxYdQqX8F2KE4gdwV4pUSe7uAS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 10:01:00AM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/11/26 15:06, Hao Li wrote:
> > --- >8 ---
> > mm/slub: refill prefilled sheaves from the barn
> > 
> > For evaluation.
> > 
> > ---
> >  mm/slub.c | 118 +++++++++++++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 112 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 27a78d63f537..7d337dbe26a5 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -427,6 +427,8 @@ struct node_barn {
> >  	spinlock_t lock;
> >  	struct list_head sheaves_full;
> >  	struct list_head sheaves_empty;
> > +	/* leftovers of prefill or refill, protected by barn->lock */
> 
> All the fields are protected by the lock so I don't think it's worth
> pointing out specifically.

Yeah, make sense to me.

> "prefill or refill" sounds like it may include also internal sheaf refill,
> which is not the case

Yeah, agreed, refill is a generic word, so I will remove the comment and let
the code speak for itself.

> (but maybe something worth exploring later)

Yes! later we can see if partial_sheaf can have more use cases.

> 
> > +	struct slab_sheaf *sheaf_partial;
> >  	unsigned int nr_full;
> >  	unsigned int nr_empty;
> >  };
> > @@ -3183,6 +3185,69 @@ static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
> >  	return empty;
> >  }
> >  
> > +/*
> > + * Exchange @sheaf, which holds fewer objects than requested, for a full sheaf
> > + * from the barn. The objects of @sheaf stay in the barn: it becomes the barn's
> > + * partial sheaf, or its objects are merged into the existing one, which becomes
> > + * a full sheaf when it reaches capacity. That way the leftovers neither occupy
> > + * a full-sheaf count nor have to be flushed.
> > + *
> > + * Returns NULL if the barn has no full sheaf.
> > + */
> > +static struct slab_sheaf *barn_replace_partial_sheaf(struct kmem_cache *s,
> > +						     struct node_barn *barn,
> > +						     struct slab_sheaf *sheaf)
> > +{
> > +	struct slab_sheaf *full, *partial;
> > +	unsigned int to_move;
> > +	unsigned long flags;
> > +
> > +	if (!data_race(barn->nr_full))
> > +		return NULL;
> > +
> > +	spin_lock_irqsave(&barn->lock, flags);
> > +
> > +	if (unlikely(!barn->nr_full)) {
> > +		spin_unlock_irqrestore(&barn->lock, flags);
> > +		return NULL;
> 
> Hmm what if there's no full, but there's sheaf_partial with enough objects
> to make a full sheaf together with @sheaf?

This is very inspiring, thanks!

And I feel this doesn't just apply when barn->nr_full == 0. At any time, as
long as the @sheaf and sheaf_partial together have enough objects to make a
full sheaf, we can always complete a full sheaf out of the two and skip the
barn list operations entirely.

This small optimization is essentially equivalent to what the current patch
does, because the current code basically takes a full sheaf from the barn, then
put the newly assembled full sheaf back into the barn, which is an
unnecessary round trip.

On top of that, to be more efficient, we could compare their sizes first to
make sure we always copy from the one with fewer objects to the one with more.

I ran a quick test, the performance and stats difference isn't very noticeable,
but logically it feels much more elegant.

I'll roll this into a non-rfc patch and send it out later.

> 
> > +	}
> > +
> > +	full = list_first_entry(&barn->sheaves_full, struct slab_sheaf,
> > +				barn_list);
> > +	list_del(&full->barn_list);
> > +	barn->nr_full--;
> > +
> > +	partial = barn->sheaf_partial;
> > +	if (partial) {
> > +		to_move = min(sheaf->size, s->sheaf_capacity - partial->size);
> > +		sheaf->size -= to_move;
> > +		memcpy(&partial->objects[partial->size],
> > +		       &sheaf->objects[sheaf->size], to_move * sizeof(void *));
> > +		partial->size += to_move;
> > +
> > +		if (partial->size == s->sheaf_capacity) {
> > +			list_add(&partial->barn_list, &barn->sheaves_full);
> > +			barn->nr_full++;
> > +			barn->sheaf_partial = NULL;
> > +		}
> > +	}
> > +
> > +	if (sheaf->size) {
> > +		/* no partial sheaf, or it just became full */
> > +		barn->sheaf_partial = sheaf;
> > +	} else {
> > +		list_add(&sheaf->barn_list, &barn->sheaves_empty);
> > +		barn->nr_empty++;
> > +	}
> > +
> > +	spin_unlock_irqrestore(&barn->lock, flags);
> > +
> > +	full->capacity = s->sheaf_capacity;
> > +	full->pfmemalloc = false;
> 
> I think this belongs more to the caller which deals with the prefilled
> sheaves specifically, and this helper is more low level.

Makes sense to me! will do.

> 
> Otherwise LGTM!

Awesome, thanks!

> 
> > +
> > +	return full;
> > +}
> > +
> >  /*
> >   * The following two functions are used mainly in cases where we have to undo an
> >   * intended action due to a race or cpu migration. Thus they do not check the
> > @@ -3317,6 +3382,7 @@ static void barn_init(struct node_barn *barn)
> >  	spin_lock_init(&barn->lock);
> >  	INIT_LIST_HEAD(&barn->sheaves_full);
> >  	INIT_LIST_HEAD(&barn->sheaves_empty);
> > +	barn->sheaf_partial = NULL;
> >  	barn->nr_full = 0;
> >  	barn->nr_empty = 0;
> >  }
> > @@ -3334,6 +3400,10 @@ static void barn_shrink(struct kmem_cache *s, struct node_barn *barn)
> >  	barn->nr_full = 0;
> >  	list_splice_init(&barn->sheaves_empty, &empty_list);
> >  	barn->nr_empty = 0;
> > +	if (barn->sheaf_partial) {
> > +		list_add(&barn->sheaf_partial->barn_list, &full_list);
> > +		barn->sheaf_partial = NULL;
> > +	}
> >  
> >  	spin_unlock_irqrestore(&barn->lock, flags);
> >  
> > @@ -5233,12 +5303,49 @@ void *kmem_cache_alloc_node_noprof(struct kmem_cache *s, gfp_t gfpflags, int nod
> >  }
> >  EXPORT_SYMBOL(kmem_cache_alloc_node_noprof);
> >  
> > +/*
> > + * Refill by swapping *@sheafp for a full sheaf from the barn. The old sheaf and
> > + * its objects stay in the barn. Returns true when the new sheaf is full.
> > + */
> > +static bool refill_sheaf_from_barn(struct kmem_cache *s,
> > +				   struct slab_sheaf **sheafp)
> > +{
> > +	struct node_barn *barn = get_barn(s);
> > +	struct slab_sheaf *sheaf = *sheafp;
> > +	struct slab_sheaf *full;
> > +
> > +	/* objects from pfmemalloc slabs must not enter the barn */
> > +	if (!barn || sheaf->pfmemalloc)
> > +		return false;
> > +
> > +	full = barn_replace_partial_sheaf(s, barn, sheaf);
> > +	if (!full)
> > +		return false;
> > +
> > +	stat(s, BARN_GET);
> > +	*sheafp = full;
> > +
> > +	/*
> > +	 * The sheaf may hold fewer than capacity objects: rcu_free_sheaf()
> > +	 * puts it in the barn as full even when slab_free_hook() has taken
> > +	 * some out (KFENCE, KASAN). __prefill_sheaf_pfmemalloc() then
> > +	 * continues to refill it.
> > +	 */
> > +	return full->size == s->sheaf_capacity;
> > +}
> > +
> >  static int __prefill_sheaf_pfmemalloc(struct kmem_cache *s,
> > -				      struct slab_sheaf *sheaf, gfp_t gfp)
> > +				      struct slab_sheaf **sheafp, gfp_t gfp)
> >  {
> > +	struct slab_sheaf *sheaf;
> >  	gfp_t gfp_nomemalloc;
> >  	int ret;
> >  
> > +	if (refill_sheaf_from_barn(s, sheafp))
> > +		return 0;
> > +
> > +	sheaf = *sheafp;
> > +
> >  	gfp_nomemalloc = gfp | __GFP_NOMEMALLOC;
> >  	if (gfp_pfmemalloc_allowed(gfp))
> >  		gfp_nomemalloc |= __GFP_NOWARN;
> > @@ -5331,7 +5438,7 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
> >  		sheaf->pfmemalloc = false;
> >  
> >  		if (sheaf->size < size &&
> > -		    __prefill_sheaf_pfmemalloc(s, sheaf, gfp)) {
> > +		    __prefill_sheaf_pfmemalloc(s, &sheaf, gfp)) {
> >  			sheaf_flush_unused(s, sheaf);
> >  			free_empty_sheaf(s, sheaf);
> >  			sheaf = NULL;
> > @@ -5401,11 +5508,10 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
> >   * the given size.
> >   *
> >   * Return: 0 on success. The sheaf will contain at least @size objects.
> > - * The sheaf might have been replaced with a new one if more than
> > - * sheaf->capacity objects are requested.
> > + * The sheaf might have been replaced with a new one.
> >   *
> >   * Return: -ENOMEM on failure. Some objects might have been added to the sheaf
> > - * but the sheaf will not be replaced.
> > + * and the sheaf might have been replaced.
> >   *
> >   * In practice we always refill to full sheaf's capacity.
> >   */
> > @@ -5427,7 +5533,7 @@ int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
> >  
> >  	if (likely(sheaf->capacity >= size)) {
> >  		if (likely(sheaf->capacity == s->sheaf_capacity))
> > -			return __prefill_sheaf_pfmemalloc(s, sheaf, gfp);
> > +			return __prefill_sheaf_pfmemalloc(s, sheafp, gfp);
> >  
> >  		if (!__kmem_cache_alloc_bulk(s, gfp, sheaf->capacity - sheaf->size,
> >  					     &sheaf->objects[sheaf->size]))
> > 
> 

