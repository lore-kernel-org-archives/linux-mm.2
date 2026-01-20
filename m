Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73484D2ED0F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 09:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87EF86B0398; Tue, 20 Jan 2026 04:32:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82CE66B039A; Tue, 20 Jan 2026 04:32:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7630E6B039B; Tue, 20 Jan 2026 04:32:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 655046B0398
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 04:32:52 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 17403B7B4A
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:32:52 +0000 (UTC)
X-FDA: 84351827784.01.01EB30E
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id 22802100006
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:32:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZYE6svoZ;
	spf=pass (imf05.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768901570; a=rsa-sha256;
	cv=none;
	b=sDkSQ3qzenl4lCDi4wcHNauSUmu/MKltPswIchm60+VoWJcUZf6e9NXrAQ1r19XZpBOz84
	fkvFDYw6gC91Qpd6t2lg0wEHaEUAeHEiqsxkECwuVJE8ge14JVkyKvVjHoop9zXvgvLIqd
	YTiLrsAJF8OjU9LJ/gJT93ISw3n98WY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZYE6svoZ;
	spf=pass (imf05.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768901570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kHHh12InGybJlgb+yVFYP3fxoRRSSX2x0XpjMmVp7aY=;
	b=1F1NNVhq3Q2n+nfPP5P8GnWepUFFCfTlkY+np+lt005bhInEFcrmxru3vHamy6qf7AV4Lk
	VYfD4B/JiJ+jLGfRkXixyXjrDCGo1o4O2XJIVQjNI5TktbAD9VDXtGZfohUzlAkUIlGReM
	1lN9e/JBUQFsTUORf4JaJy8455R/qJ8=
Date: Tue, 20 Jan 2026 17:32:37 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768901567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kHHh12InGybJlgb+yVFYP3fxoRRSSX2x0XpjMmVp7aY=;
	b=ZYE6svoZOmJtF9deg4k49Cw62GzmDfZmWfTCEfZ+EMirLCOdTGeWWKUxmJFGg7OJv2TYLQ
	r3WdcAJbcl782ZRZMBe8+8OQEb2kReroeGK6QOyxCSFjtsfo5nrB7O1YIouLbaduF5wRVc
	Xfa+lRmA4fKAdV99WPLtq4HmAP0S7u4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 09/21] slab: add optimized sheaf refill from partial
 list
Message-ID: <zo75mmcyxdzrefl7fo4vy2zqfpzcox4vrmjsk63qtzzmwigbzk@2hb52by2j7yy>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-9-5595cb000772@suse.cz>
 <aW3SJBR1BcDor-ya@hyeyoo>
 <e106a4d5-32f7-4314-b8c1-19ebc6da6d7a@suse.cz>
 <aW7dUeoDALhJI0Ic@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aW7dUeoDALhJI0Ic@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 8ypbzxzhorb6rkmsh1g9mic6gj9sut3r
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 22802100006
X-Rspam-User: 
X-HE-Tag: 1768901569-894307
X-HE-Meta: U2FsdGVkX1/rGo2Eu/X4XueJ44FevdyGCCxwAv4EJ+wMLg0wmBnpch50m9MPqyx23dlMV/h8YHfGjqxiLWQ/Y1t4JivpCa6oh17SwPFxpaSrtd5qsL9SrnB4LnAh6JZ3naiVyZW27uBS1OOlRPm9OomuZ76QXo19WZ9BJ8ifTDGpQxJ9en7lbOIXNozKdW7g8RB/2kILrb7RW/LAlKnbs5VBhPXs7epwsZZMxN78SIyVxE8ovM4Yo9yfaCrGW/q/w4IhEWwVcVDx0uMv6qeC3oIq6/s7+mLHekF0aL+G+uqhIymN65D+rq5F3iBgYHN4MAfUmL8//hjxu4XdP7Vqe4gwOwWET9vqDt4MC7S3MwM3ksFjN3cw52fDPlRjiUJNHedAoi88mMRFLgG1vr26GiMKa6pXIUBGhp9xSU9cUsphkaqLgxKUmJhMJpglfeJF8UwjEToRb2wpYFF2cAVrD919WU3936eRIU3E9asEjhZm/g8x9cz1hzZLvO1RqxdkrhL4/gF5dsn2rgfaUzIRWYHdbOCwMC+DymwreJCqN5jqtIJJ9+/oEhv/GHH+uLIw01OdDtpuEoNQHT10lwpKvqToQgezYRnKD+ibbMXo8N71yQX/jnmD5AtCqKiTUNqVBRLlkV0nnCqBsp0VpwBLpZ7TCPre5RKovb7fzCEpZpbD+6kFGOORl/HsrLjsfAj/zu4IaDfVK3XYgWrd3THaMXKrW+Xh+iACWcxa+JiDv1VlAGnFK0ap1wk93bQ4tI6Yx0O/ezxCsk5VrewAY0sUxYQamQnzKDczFA54+oIOdZhuMsj/3OTubvIIW16DTTbZRqnRp4J6jF8587gluN46nbZen3MKPC91GGs1WI0ZFVu1eClJcrHUgVg7eIjEeRRJ+i0tUgrS6CUHBd3lDzMMy1k6q7VP0HZY7x6F5riHQL15zs8YlbuUBuKz8HDiIPe1AgHfbKXtz+CFknNH0ya
 8WdVAJEQ
 5zM9k5Q/JVeH6aRHAija28XgO9JhdG1cIqYyO11J2tC2+D7Jwl2eWfEVmQh6M293jWMyjz6pvxExCzt6nV8xTvq6aP53PzM3lPX3+GATwHK8ZiC//M2g9WqmD2SfeV079Kk3lhUatuHBGO6w+COvNZQqQnekbzhpzhfKoB5VtnEoTvxEUboUl5OCs7NUodDNsWlihyu5goKCsEgQhR1ktovxK4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 10:41:37AM +0900, Harry Yoo wrote:
> On Mon, Jan 19, 2026 at 11:54:18AM +0100, Vlastimil Babka wrote:
> > On 1/19/26 07:41, Harry Yoo wrote:
> > > On Fri, Jan 16, 2026 at 03:40:29PM +0100, Vlastimil Babka wrote:
> > >>  /*
> > >>   * Try to allocate a partial slab from a specific node.
> > >>   */
> > >> +static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
> > >> +		void **p, unsigned int count, bool allow_spin)
> > >> +{
> > >> +	unsigned int allocated = 0;
> > >> +	struct kmem_cache_node *n;
> > >> +	unsigned long flags;
> > >> +	void *object;
> > >> +
> > >> +	if (!allow_spin && (slab->objects - slab->inuse) > count) {
> > >> +
> > >> +		n = get_node(s, slab_nid(slab));
> > >> +
> > >> +		if (!spin_trylock_irqsave(&n->list_lock, flags)) {
> > >> +			/* Unlucky, discard newly allocated slab */
> > >> +			defer_deactivate_slab(slab, NULL);
> > >> +			return 0;
> > >> +		}
> > >> +	}
> > >> +
> > >> +	object = slab->freelist;
> > >> +	while (object && allocated < count) {
> > >> +		p[allocated] = object;
> > >> +		object = get_freepointer(s, object);
> > >> +		maybe_wipe_obj_freeptr(s, p[allocated]);
> > >> +
> > >> +		slab->inuse++;
> > >> +		allocated++;
> > >> +	}
> > >> +	slab->freelist = object;
> > >> +
> > >> +	if (slab->freelist) {
> > >> +
> > >> +		if (allow_spin) {
> > >> +			n = get_node(s, slab_nid(slab));
> > >> +			spin_lock_irqsave(&n->list_lock, flags);
> > >> +		}
> > >> +		add_partial(n, slab, DEACTIVATE_TO_HEAD);
> > >> +		spin_unlock_irqrestore(&n->list_lock, flags);
> > >> +	}
> > >> +
> > >> +	inc_slabs_node(s, slab_nid(slab), slab->objects);
> > > 
> > > Maybe add a comment explaining why inc_slabs_node() doesn't need to be
> > > called under n->list_lock?

I think this is a great observation.

> > 
> > Hm, we might not even be holding it. The old code also did the inc with no
> > comment. If anything could use one, it would be in
> > alloc_single_from_new_slab()? But that's outside the scope here.
> 
> Ok. Perhaps worth adding something like this later, but yeah it's outside
> the scope here.
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 698c0d940f06..c5a1e47dfe16 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1633,6 +1633,9 @@ static inline void inc_slabs_node(struct kmem_cache *s, int node, int objects)
>  {
>  	struct kmem_cache_node *n = get_node(s, node);
>  
> +	if (kmem_cache_debug(s))
> +		/* slab validation may generate false errors without the lock */
> +		lockdep_assert_held(&n->list_lock);
>  	atomic_long_inc(&n->nr_slabs);
>  	atomic_long_add(objects, &n->total_objects);
>  }

Yes. This makes sense to me.

Just to double-check - I noticed that inc_slabs_node() is also called by
early_kmem_cache_node_alloc(). Could this potentially lead to false positive
warnings for boot-time caches when debug flags are enabled?

-- 
Thanks,
Hao

