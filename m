Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 686961076381
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 13:57:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFD0A6B008A; Wed,  1 Apr 2026 09:57:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B868B6B008C; Wed,  1 Apr 2026 09:57:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4E4E6B0092; Wed,  1 Apr 2026 09:57:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E8C86B008A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:57:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 614011608B4
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:57:01 +0000 (UTC)
X-FDA: 84610138242.24.421FB34
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 913F4A0013
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:56:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775051818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mcgd6HcOldiupIcmaKM5PJTHT8tV7b1DRTc3krJPWVM=;
	b=ptRTKUen0Z6LIfjPu79QB4OttngHIM4c+yUEEMw0kRIAFXe4+HJXDOGueWF/WSF0vaQ57K
	7cIg4P6B/I2k+MXSC8uGhB9TvcvNyPbCrkVCPv1RteJ4aKjN1Vzf17pbjlb9tBcJ86ikOV
	2837psgcyAsaJgiqVAYCxKSW5avTnts=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775051818; a=rsa-sha256;
	cv=none;
	b=zhWa6d1KZC976T9u8cpA+WXRhuXDmj7OBcx7XuzmBmPHr/BpJqH5z40mU+uY34kkE2R+4N
	nkUOZpcc0oiseaE/R0IiFJFUjo7gUKnFzeJL9nxSBmYBjkzsN1QWOORodHDnj9emsU3HyT
	IoPaDR5JaGzkrHSzqEfYqfoUX1VWwfQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4fm63l5LWZz4yjjG;
	Wed, 01 Apr 2026 21:56:51 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 631DujA4015455;
	Wed, 1 Apr 2026 21:56:46 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 1 Apr 2026 21:56:49 +0800 (CST)
X-Zmail-TransId: 2afc69cd24211c4-ff52a
X-Mailer: Zmail v1.0
Message-ID: <202604012156491419-Nl283guZ6jw8h0k2omv@zte.com.cn>
In-Reply-To: <fz2shejnypqsu74zpoy66senjbpyl2bbvcnoxu6hvfs77c7jtr@o2acnd2hzd4x>
References: 202604011257259669oAdDsdnKx6twdafNZsF5@zte.com.cn,fz2shejnypqsu74zpoy66senjbpyl2bbvcnoxu6hvfs77c7jtr@o2acnd2hzd4x
Date: Wed, 1 Apr 2026 21:56:49 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <hao.li@linux.dev>
Cc: <vbabka@kernel.org>, <harry@kernel.org>, <akpm@linux-foundation.org>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <xu.xin16@zte.com.cn>,
        <yang.tao172@zte.com.cn>, <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2Ml0gbW0vc2x1Yjogc2tpcCBmcmVlbGlzdCBjb25zdHJ1Y3Rpb24gZm9yIHdob2xlLXNsYWIgYnVsayByZWZpbGw=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 631DujA4015455
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Wed, 01 Apr 2026 21:56:51 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69CD2423.000/4fm63l5LWZz4yjjG
X-Rspamd-Server: rspam12
X-Stat-Signature: cbre1ca74z7ke36zsmat45cbyb4haes5
X-Rspamd-Queue-Id: 913F4A0013
X-Rspam-User: 
X-HE-Tag: 1775051817-746567
X-HE-Meta: U2FsdGVkX1+g76/TrQ65XY88MzmAm7NpUSsjLr3eCN/bO7cGEocDrz/q3ptzdlnPuatB8YsyF6S8gibBQr8oVW8eK7Mj4owS5YElwsqhJwoP91hKuwTVdeAyUUYzLzlid6kB3P6MF8YOhwcZIXy9tZf9RXyqgAuVgVNAs9sjxwFiPPJN4AvSiWMwWIgpPmi8tEh8edCpZECrQ0nuU4P8+dd8DH8eSZ0MTxRDqDpI2HSftgEsQ4vbIw/DpqniyVZr/FWRiW/Eq8vzLDd3eCKjwzC8T1n5cFWn56ZjqeZ4upyG+QbaP0EZF+hin4Umx2Isky/A9ZS5tAXgNDWZd2iMKbIQ3qUdZt1P9bn1R4kfXs8VrhFbA/12S+CEhoX7yI6qUmdAQ+oNuQawJ9uwlIrmLxZbZ+AvkTQ5SKqfyP/P6PZAdm7mfmAy7hPtrX92CM+gToKPvDu6pxRrsqWW7ilfI0WV8Wys2Yp3mlzClbfqzaNlZivOSxMKAzdMABO1T/FXBbqcFsdYaOR1hlhllOfLClVz6+GsEPJWzUGTvHg5uVHJKjuuR18xzI6tNeY/A6Nfck+ckxux4irqXoBEGXEz0eenl0WRSFecwTsGyKaiz34gkmBxGt8Vb0eGrENYafSHJTnbcYyg4LKSbYN0ckaRmnWEPcsqGpiHyHpCwk0XqXoDGqR+oyjmk1JyoGFnlvf2u8zYEXBHYA3Gpg2+8IqqxZVdhxMTBJgt09gB3hZBps8JkFSTLQegs14jIBZ2fQq5mPQfxHKC9QhYZtEKt4LCapNiBNcL8SvRKBeazH27hcB6/jjzay+RaKxI0XHrlmOYFG9SzG0xbtp0PUxKhygUtacwGGnzcZ6lqo+ii8iKbDaCwtf0KZjS5Z8geadOqZ5l05csgkGbwmPw7xhWBnuOw9Z6bICQ6u1MgzjXfz6WT7OJKy+qNH4MPsvXusFKVaI06fWlzHseyjP5QtZIQ5/
 36TaZql4
 CLlgU41cJW6QuLC7Hq9K4dA4hdS2kaxqTaWvQrUmqN3NVgkwKn9SO/ivPG+sCepZMyhc9/l8EsuJ/Qh14IN/MuwkLf73ClEcW2LN4hXjfRCtlLYqfli7QeVO8xNQXiyhcpTyKydjsE3nTkD8ogfZe9wBX2ApOHOmDKLvM6sEUlTR/YknBmF6TfbptX/yTgAtrp8uy2XbYse+3KeebCDyZl+2S20fsXexav3aw9BTM/IcMPUsnTxhV3MWFyMner7vxO7CDWwe+w+M01zL4bRvtn5qSTfWYrMbKD10q1+AM3KbRmLo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Wed, Apr 01, 2026 at 12:57:25PM +0800, hu.shengming@zte.com.cn wrote:
> > From: Shengming Hu <hu.shengming@zte.com.cn>
> > 
> > refill_objects() already notes that a whole-slab bulk refill could avoid
> > building a freelist that would be drained immediately.
> > 
> > When the remaining bulk allocation is large enough to consume an entire
> > new slab, building the freelist is unnecessary overhead. Instead,
> > allocate the slab without initializing its freelist and hand all objects
> > directly to the caller.
> > 
> > Handle CONFIG_SLAB_FREELIST_RANDOM=y as well by walking objects in the
> > randomized allocation order and placing them directly into the caller's
> > array, without constructing a temporary freelist.
> > 
> > Also mark setup_object() inline. After this optimization, the compiler no
> > longer consistently inlines this helper in the hot path, which can hurt
> > performance. Explicitly marking it inline restores the expected code
> > generation.
> > 
> > This reduces per-object overhead in bulk allocation paths and improves
> > allocation throughput significantly. In slub_bulk_bench, the time per
> > object drops by about 54% to 74% with CONFIG_SLAB_FREELIST_RANDOM=n, and
> > by about 62% to 74% with CONFIG_SLAB_FREELIST_RANDOM=y.
> 
> Thanks for the patch.
> Here are some quick review..
> 

Hi Hao,

Thanks for the quick review!

> > 
> > Benchmark results (slub_bulk_bench):
> > 
> > Machine: qemu-system-x86 -m 1024M -smp 8 -enable-kvm -cpu host
> > Kernel: Linux 7.0.0-rc6-next-20260330
> > Config: x86_64_defconfig
> > Cpu: 0
> > Rounds: 20
> > Total: 256MB
> > 
> > - CONFIG_SLAB_FREELIST_RANDOM=n -
> > 
> > obj_size=16, batch=256:
> > before: 5.29 +- 0.73 ns/object
> > after: 2.42 +- 0.05 ns/object
> > delta: -54.4%
> > 
> > obj_size=32, batch=128:
> > before: 7.65 +- 1.89 ns/object
> > after: 3.04 +- 0.03 ns/object
> > delta: -60.2%
> > 
> > obj_size=64, batch=64:
> > before: 11.07 +- 0.08 ns/object
> > after: 4.11 +- 0.04 ns/object
> > delta: -62.9%
> > 
> > obj_size=128, batch=32:
> > before: 19.95 +- 0.30 ns/object
> > after: 5.72 +- 0.05 ns/object
> > delta: -71.3%
> > 
> > obj_size=256, batch=32:
> > before: 24.31 +- 0.25 ns/object
> > after: 6.33 +- 0.14 ns/object
> > delta: -74.0%
> > 
> > obj_size=512, batch=32:
> > before: 22.48 +- 0.14 ns/object
> > after: 6.43 +- 0.10 ns/object
> > delta: -71.4%
> > 
> > - CONFIG_SLAB_FREELIST_RANDOM=y -
> > 
> > obj_size=16, batch=256:
> > before: 9.32 +- 1.26 ns/object
> > after: 3.51 +- 0.02 ns/object
> > delta: -62.4%
> > 
> > obj_size=32, batch=128:
> > before: 11.68 +- 0.15 ns/object
> > after: 4.18 +- 0.22 ns/object
> > delta: -64.2%
> > 
> > obj_size=64, batch=64:
> > before: 16.69 +- 1.36 ns/object
> > after: 5.22 +- 0.06 ns/object
> > delta: -68.7%
> > 
> > obj_size=128, batch=32:
> > before: 23.41 +- 0.23 ns/object
> > after: 7.40 +- 0.07 ns/object
> > delta: -68.4%
> > 
> > obj_size=256, batch=32:
> > before: 29.80 +- 0.44 ns/object
> > after: 7.98 +- 0.09 ns/object
> > delta: -73.2%
> > 
> > obj_size=512, batch=32:
> > before: 30.38 +- 0.36 ns/object
> > after: 8.01 +- 0.06 ns/object
> > delta: -73.6%
> > 
> > Link: https://github.com/HSM6236/slub_bulk_test.git
> > Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> > ---
> > Changes in v2:
> > - Handle CONFIG_SLAB_FREELIST_RANDOM=y and add benchmark results.
> > - Update the QEMU benchmark setup to use -enable-kvm -cpu host so benchmark results better reflect native CPU performance.
> > - Link to v1: https://lore.kernel.org/all/20260328125538341lvTGRpS62UNdRiAAz2gH3@zte.com.cn/
> > 
> > ---
> >  mm/slub.c | 155 +++++++++++++++++++++++++++++++++++++++++++++++-------
> >  1 file changed, 136 insertions(+), 19 deletions(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index fb2c5c57bc4e..52da4a716b1b 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2733,7 +2733,7 @@ bool slab_free_freelist_hook(struct kmem_cache *s, void **head, void **tail,
> >  	return *head != NULL;
> >  }
> >  
> > -static void *setup_object(struct kmem_cache *s, void *object)
> > +static inline void *setup_object(struct kmem_cache *s, void *object)
> >  {
> >  	setup_object_debug(s, object);
> >  	object = kasan_init_slab_obj(s, object);
> > @@ -3399,6 +3399,53 @@ static bool shuffle_freelist(struct kmem_cache *s, struct slab *slab,
> >  
> >  	return true;
> >  }
> > +static __always_inline void maybe_wipe_obj_freeptr(struct kmem_cache *s,
> > +						   void *obj);
> > +
> > +static inline bool alloc_whole_from_new_slab_random(struct kmem_cache *s,
> > +					struct slab *slab, void **p,
> > +					bool allow_spin,
> > +					unsigned int *allocatedp)
> > +{
> > +	unsigned long pos, page_limit, freelist_count;
> > +	unsigned int allocated = 0;
> > +	void *next, *start;
> > +
> > +	if (slab->objects < 2 || !s->random_seq)
> > +		return false;
> > +
> > +	freelist_count = oo_objects(s->oo);
> > +
> > +	if (allow_spin) {
> > +		pos = get_random_u32_below(freelist_count);
> > +	} else {
> > +		struct rnd_state *state;
> > +
> > +		/*
> > +		 * An interrupt or NMI handler might interrupt and change
> > +		 * the state in the middle, but that's safe.
> > +		 */
> > +		state = &get_cpu_var(slab_rnd_state);
> > +		pos = prandom_u32_state(state) % freelist_count;
> > +		put_cpu_var(slab_rnd_state);
> > +	}
> > +
> > +	page_limit = slab->objects * s->size;
> > +	start = fixup_red_left(s, slab_address(slab));
> > +
> > +	while (allocated < slab->objects) {
> > +		next = next_freelist_entry(s, &pos, start, page_limit,
> > +					     freelist_count);
> > +		next = setup_object(s, next);
> > +		p[allocated] = next;
> > +		maybe_wipe_obj_freeptr(s, next);
> > +		allocated++;
> > +	}
> > +
> > +	*allocatedp = allocated;
> 
> It seems we does not need to return the allocated count through allocatedp,
> since the count should always be slab->objects.
> 

Agreed, I'll drop allocatedp.

> > +	return true;
> > +}
> > +
> >  #else
> >  static inline int init_cache_random_seq(struct kmem_cache *s)
> >  {
> > @@ -3410,6 +3457,14 @@ static inline bool shuffle_freelist(struct kmem_cache *s, struct slab *slab,
> >  {
> >  	return false;
> >  }
> > +
> > +static inline bool alloc_whole_from_new_slab_random(struct kmem_cache *s,
> > +					struct slab *slab, void **p,
> > +					bool allow_spin,
> > +					unsigned int *allocatedp)
> > +{
> > +	return false;
> > +}
> >  #endif /* CONFIG_SLAB_FREELIST_RANDOM */
> >  
> >  static __always_inline void account_slab(struct slab *slab, int order,
> > @@ -3438,7 +3493,8 @@ static __always_inline void unaccount_slab(struct slab *slab, int order,
> >  			    -(PAGE_SIZE << order));
> >  }
> >  
> > -static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
> > +static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node,
> > +				  bool build_freelist, bool *allow_spinp)
> >  {
> >  	bool allow_spin = gfpflags_allow_spinning(flags);
> >  	struct slab *slab;
> > @@ -3446,7 +3502,10 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
> >  	gfp_t alloc_gfp;
> >  	void *start, *p, *next;
> >  	int idx;
> > -	bool shuffle;
> > +	bool shuffle = false;
> > +
> > +	if (allow_spinp)
> > +		*allow_spinp = allow_spin;
> 
> It seems unnecessary for allocate_slab() to compute allow_spin and return it
> via allow_spinp.
> We could instead calculate it directly in refill_objects() based on gfp.
> 

Yes, that makes sense. I'll compute allow_spin directly in refill_objects()
and remove the allow_spinp plumbing from allocate_slab()/new_slab().

> >  
> >  	flags &= gfp_allowed_mask;
> >  
> > @@ -3483,6 +3542,7 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
> >  	slab->frozen = 0;
> >  
> >  	slab->slab_cache = s;
> > +	slab->freelist = NULL;
> >  
> >  	kasan_poison_slab(slab);
> >  
> > @@ -3497,9 +3557,10 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
> >  	alloc_slab_obj_exts_early(s, slab);
> >  	account_slab(slab, oo_order(oo), s, flags);
> >  
> > -	shuffle = shuffle_freelist(s, slab, allow_spin);
> > +	if (build_freelist)
> > +		shuffle = shuffle_freelist(s, slab, allow_spin);
> >  
> > -	if (!shuffle) {
> > +	if (build_freelist && !shuffle) {
> >  		start = fixup_red_left(s, start);
> >  		start = setup_object(s, start);
> >  		slab->freelist = start;
> > @@ -3515,7 +3576,8 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
> >  	return slab;
> >  }
> >  
> > -static struct slab *new_slab(struct kmem_cache *s, gfp_t flags, int node)
> > +static struct slab *new_slab(struct kmem_cache *s, gfp_t flags, int node,
> > +			     bool build_freelist, bool *allow_spinp)
> >  {
> >  	if (unlikely(flags & GFP_SLAB_BUG_MASK))
> >  		flags = kmalloc_fix_flags(flags);
> > @@ -3523,7 +3585,8 @@ static struct slab *new_slab(struct kmem_cache *s, gfp_t flags, int node)
> >  	WARN_ON_ONCE(s->ctor && (flags & __GFP_ZERO));
> >  
> >  	return allocate_slab(s,
> > -		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
> > +			     flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK),
> > +			     node, build_freelist, allow_spinp);
> >  }
> >  
> >  static void __free_slab(struct kmem_cache *s, struct slab *slab, bool allow_spin)
> > @@ -4395,6 +4458,48 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
> >  	return allocated;
> >  }
> >  
> > +static unsigned int alloc_whole_from_new_slab(struct kmem_cache *s,
> > +		struct slab *slab, void **p, bool allow_spin)
> > +{
> > +
> > +	unsigned int allocated = 0;
> > +	void *object, *start;
> > +
> > +	if (alloc_whole_from_new_slab_random(s, slab, p, allow_spin,
> > +					     &allocated)) {
> > +		goto done;
> > +	}
> > +
> > +	start = fixup_red_left(s, slab_address(slab));
> > +	object = setup_object(s, start);
> > +
> > +	while (allocated < slab->objects - 1) {
> > +		p[allocated] = object;
> > +		maybe_wipe_obj_freeptr(s, object);
> > +
> > +		allocated++;
> > +		object += s->size;
> > +		object = setup_object(s, object);
> > +	}
> 
> Also, I feel the current patch contains some duplicated code like this loop.
> 
> Would it make sense to split allocate_slab() into two functions?
> 
> For example,
> the first part could be called allocate_slab_meta_setup() (just an example name)
> And, the second part could be allocate_slab_objects_setup(), with the core logic
> being the loop over objects. Then allocate_slab_objects_setup() could support
> two modes: one called BUILD_FREELIST, which builds the freelist, and another
> called EMIT_OBJECTS, which skips building the freelist and directly places the
> objects into the target array.
> 

I may be missing part of your idea here, so please correct me if I misunderstood.

Regarding the duplicated loop, this patch adds two loops: one in
alloc_whole_from_new_slab() and the other in
alloc_whole_from_new_slab_random(). I did not merge them because the
allocation path differs when CONFIG_SLAB_FREELIST_RANDOM is enabled versus
disabled.

As for allocate_slab(), my intention with the current build_freelist flag
was to keep the change small and reuse the existing allocate_slab() path,
since the only behavior difference here is whether we build the freelist for
the new slab.

Could you elaborate a bit more on the refactoring you have in mind?

> > +
> > +	p[allocated] = object;
> > +	maybe_wipe_obj_freeptr(s, object);
> > +	allocated++;
> > +
> > +done:
> > +	slab->freelist = NULL;
> > +	slab->inuse = slab->objects;
> > +	inc_slabs_node(s, slab_nid(slab), slab->objects);
> > +
> > +	return allocated;
> > +}
> > +
> > +static inline bool bulk_refill_consumes_whole_slab(struct kmem_cache *s,
> > +		unsigned int count)
> > +{
> > +	return count >= oo_objects(s->oo);
> 
> It seems using s->oo here may be a bit too strict. In allocate_slab(), the
> object count can fall back to s->min, so using s->objects might be more
> reasonable (If I understand correctly...).
> 

Good point. I do not see s->objects in current linux-next; did you mean
slab->objects?

oo_objects(s->oo) is the preferred-layout object count, while the actual
object count of a newly allocated slab is only known after allocate_slab(),
via slab->objects, since allocation can fall back to s->min.

So I used oo_objects(s->oo) because this check happens before slab
allocation. It is conservative, but safe.

I agree that slab->objects would be a more accurate basis if we move this
decision after slab allocation.

Thanks again for the review.

--
With Best Regards,
Shengming

> > +}
> > +
> >  /*
> >   * Slow path. We failed to allocate via percpu sheaves or they are not available
> >   * due to bootstrap or debugging enabled or SLUB_TINY.
> > @@ -4441,7 +4546,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
> >  	if (object)
> >  		goto success;
> >  
> > -	slab = new_slab(s, pc.flags, node);
> > +	slab = new_slab(s, pc.flags, node, true, NULL);
> >  
> >  	if (unlikely(!slab)) {
> >  		if (node != NUMA_NO_NODE && !(gfpflags & __GFP_THISNODE)
> > @@ -7244,18 +7349,30 @@ refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
> >  
> >  new_slab:
> >  
> > -	slab = new_slab(s, gfp, local_node);
> > -	if (!slab)
> > -		goto out;
> > -
> > -	stat(s, ALLOC_SLAB);
> > -
> >  	/*
> > -	 * TODO: possible optimization - if we know we will consume the whole
> > -	 * slab we might skip creating the freelist?
> > +	 * If the remaining bulk allocation is large enough to consume
> > +	 * an entire slab, avoid building the freelist only to drain it
> > +	 * immediately. Instead, allocate a slab without a freelist and
> > +	 * hand out all objects directly.
> >  	 */
> > -	refilled += alloc_from_new_slab(s, slab, p + refilled, max - refilled,
> > -					/* allow_spin = */ true);
> > +	if (bulk_refill_consumes_whole_slab(s, max - refilled)) {
> > +		bool allow_spin;
> > +
> > +		slab = new_slab(s, gfp, local_node, false, &allow_spin);
> > +		if (!slab)
> > +			goto out;
> > +		stat(s, ALLOC_SLAB);
> > +		refilled += alloc_whole_from_new_slab(s, slab, p + refilled,
> > +						      allow_spin);
> > +	} else {
> > +		slab = new_slab(s, gfp, local_node, true, NULL);
> > +		if (!slab)
> > +			goto out;
> > +		stat(s, ALLOC_SLAB);
> > +		refilled += alloc_from_new_slab(s, slab, p + refilled,
> > +						max - refilled,
> > +						/* allow_spin = */ true);
> > +	}
> >  
> >  	if (refilled < min)
> >  		goto new_slab;
> > @@ -7587,7 +7704,7 @@ static void early_kmem_cache_node_alloc(int node)
> >  
> >  	BUG_ON(kmem_cache_node->size < sizeof(struct kmem_cache_node));
> >  
> > -	slab = new_slab(kmem_cache_node, GFP_NOWAIT, node);
> > +	slab = new_slab(kmem_cache_node, GFP_NOWAIT, node, true, NULL);
> >  
> >  	BUG_ON(!slab);
> >  	if (slab_nid(slab) != node) {
> > -- 
> > 2.25.1

