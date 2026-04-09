Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBE42E9DE41
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 06:56:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C57C6B0005; Thu,  9 Apr 2026 02:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 376A76B0088; Thu,  9 Apr 2026 02:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28C1F6B008A; Thu,  9 Apr 2026 02:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D2F16B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:56:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A7F4C1603D4
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:55:59 +0000 (UTC)
X-FDA: 84638107638.08.62B4D1E
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5A4AD20005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:55:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775717757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wY3D2XIYf0Ybx2eRDdItrf8Hqu0scp9C9RjjI0cGfp0=;
	b=zu5r+1N1qHyblAqpaGCn0ktJPjNrzxvDWAxZmP8YEq9ric1PufrjZeaEOj4HsqTaXgdcMs
	Ag1rs3rLjjDGSM1f3me3XWZMwYChSFsLp8Gh4xcWb0r6CigYGMWcrOB4km28aI/ot9D12W
	jK6Rn8Mv0TREmx+QG7YfKV8gsFEjPSI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775717757; a=rsa-sha256;
	cv=none;
	b=Uzg/lyitPpm1D3PaaCA1/we2odpKZblBa8KUgFsNLHWEtyrAn/GK9HmZ45Wq/qq9rpZlsx
	Osen0fPDp3pwq1BB3Cphfrx5890xsxYy7QNMgIs31Bt6bNiNdhgGEs4aihjZBj9FGpFrUq
	G55Arl2HTVOEpfE7jJhStuJXGJVxdUE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4frrLJ3CWSz5B101;
	Thu, 09 Apr 2026 14:55:52 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 6396tjxu096620;
	Thu, 9 Apr 2026 14:55:45 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 9 Apr 2026 14:55:47 +0800 (CST)
X-Zmail-TransId: 2afb69d74d73347-a8e2a
X-Mailer: Zmail v1.0
Message-ID: <20260409145547118i_wLC0TKs3zXR0sNH5fWr@zte.com.cn>
In-Reply-To: <adcqFQR4XGSJqtAP@hyeyoo>
References: 2026040823281824773ybHpC3kgUhR9OE1rGTl@zte.com.cn,adcqFQR4XGSJqtAP@hyeyoo
Date: Thu, 9 Apr 2026 14:55:47 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <harry@kernel.org>
Cc: <vbabka@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <xu.xin16@zte.com.cn>,
        <yang.tao172@zte.com.cn>, <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2NF0gbW0vc2x1YjogZGVmZXIgZnJlZWxpc3QgY29uc3RydWN0aW9uIHVudGlsIGFmdGVyIGJ1bGsgYWxsb2NhdGlvbiBmcm9tIGEgbmV3IHNsYWI=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6396tjxu096620
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Thu, 09 Apr 2026 14:55:52 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69D74D78.000/4frrLJ3CWSz5B101
X-Rspamd-Server: rspam12
X-Stat-Signature: ryj3e9e75nq613ffis4kxgfbk6iwr34y
X-Rspamd-Queue-Id: 5A4AD20005
X-Rspam-User: 
X-HE-Tag: 1775717755-731103
X-HE-Meta: U2FsdGVkX1+0ihwcWmcZIsozThyYoBIjk2WWlx/eD1FprEugjxu8/Ad0mLs5lPQg/l3P9yQVxWQhCUb+8JZtf1OdsGMJa9MRQjCqSVE5bfzp316sNkkOO8ijKsbumQj9aD0hAMApKSQFRpbcXJpMNxL3PxNZ6mTp5+mMim7uLvOgR6ogytaDlGMyoUjijHztOSf/La1d46i91k64pF8VS61kaoMysmrmApuvks2Imaoigg+QwrA16A5ZimoMnDuy4QX1GYw71KSVlsyPmyONpYu6T3moNRfXbPL0QXiHCRbBLalur/D2KJJKpk7nghO5dNoWfnSWx4GpLlyStb7ECqeAEyRi0Mi9SCK7I3w3xBr4DypwJtw6t8AM4pIYyc/ZeFOUzd5Ub0sJR6qxisGaGKEkvNVtBrMjFEaLGxK5g1hPjZAP+Cv6EmXUMfoeNFY9WfyshxdwtHb1XYuclnMh8JTn8UHZnTMOMtw++RKpZX1m2nKpZuxSn+orV2uFo87gM3XUrxQV9bvP/s0SE1AeYtocoUSRXehkSK6spNQz12DZ+WLSqg95jQ6cLqPPSeijxfPdbFZua/fMixeOefHJvf4e0QWqIwcET5utYblEEh6V+I/Vk5UNJm6I/GjFl3ONmjx24XtteltH6F1ZK4B47voyuebxwqGT5Sf7s+AauSK6SmVDCujtS6BIrQYppP0BtN+oLKjr23DcLkk1VqT6oPiZdUcvFsjxdkN28CBCTtTCfj88YccHYHfzxbh1aw84AydzakKaZUiwqAEhiw6Dk/XtsUbrvWiTCL0Dp4Ltvkgn5m7Wyzls+Pe4yvWw0gUQkZ2vxKBmkvV3vN52XqZLHF87+DV98bcWH6EB1YterEsGT+y0nweynmS3OWhGIm7g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry wrote:
> On Wed, Apr 08, 2026 at 11:28:18PM +0800, hu.shengming@zte.com.cn wrote:
> > From: Shengming Hu <hu.shengming@zte.com.cn>
> > 
> > Allocations from a fresh slab can consume all of its objects, and the
> > freelist built during slab allocation is discarded immediately as a result.
> > 
> > Instead of special-casing the whole-slab bulk refill case, defer freelist
> > construction until after objects are emitted from a fresh slab.
> > new_slab() now only allocates the slab and initializes its metadata.
> 
> Oh, in v3 new_slab() built the freelist and allocate_slab() didn't,
> but in v4 new_slab() doesn't build the freelist.
> 
> That was a subtle change but ok.
> 

Yes, I'll mention that change explicitly in the next changelog.

> > refill_objects() then obtains a fresh slab and lets alloc_from_new_slab()
> > emit objects directly, building a freelist only for the objects left
> > unallocated; the same change is applied to alloc_single_from_new_slab().
> > 
> > To keep CONFIG_SLAB_FREELIST_RANDOM=y/n on the same path, introduce a
> > small iterator abstraction for walking free objects in allocation order.
> > The iterator is used both for filling the sheaf and for building the
> > freelist of the remaining objects.
> > 
> > Also mark setup_object() inline. After this optimization, the compiler no
> > longer consistently inlines this helper in the hot path, which can hurt
> > performance. Explicitly marking it inline restores the expected code
> > generation.
> > 
> > This reduces per-object overhead in bulk allocation paths and improves
> > allocation throughput significantly. In slub_bulk_bench, the time per
> > object drops by about 35% to 72% with CONFIG_SLAB_FREELIST_RANDOM=n, and
> > by about 60% to 71% with CONFIG_SLAB_FREELIST_RANDOM=y.
> > 
> > Benchmark results (slub_bulk_bench):
> 
> There are only a few bulk alloc/free API users.
> Non-bulk alloc/free may also benefit from this when refilling
> sheaves.
> 

Right. Besides the bulk alloc/free users, the slowpath refill path should
also benefit from this change.

> > Machine: qemu-system-x86 -m 1024M -smp 8 -enable-kvm -cpu host
> > Kernel: Linux 7.0.0-rc7-next-20260407
> > Config: x86_64_defconfig
> > Cpu: 0
> > Rounds: 20
> > Total: 256MB
> > 
> > - CONFIG_SLAB_FREELIST_RANDOM=n -
> > 
> > obj_size=16, batch=256:
> > before: 4.72 +- 0.03 ns/object
> > after: 3.06 +- 0.03 ns/object
> > delta: -35.1%
> 
> Hmm, the number is too good for slowpath optimization.
> 
> Probably it's because the bulk size in the microbenchmark
> is too large (256MB? oh...) to be served from sheaves in the barn.
> 
> And the microbenchmark doesn't really touch objects and
> thus not building freelist removes the need to fetch
> cache lines and hence leading to much less cache footprint?
> 
> So the number doesn't seem to show benefits of realistic workloads
> (per Amdahl's Law, the actual speedup is bounded by the fraction of time
> spent in the slowpath, which should be low), but that's fine
> as long as it doesn't complicate things.
> 

Agreed. In my test case, alloc count == slab->objects on each iteration,
which is the best-case path for this optimization: before this patch we
still build a freelist covering all objects, while after this patch no
freelist needs to be built when no objects remain. I'll clarify this in
the commit message so the benchmark results are not overstated.

> > obj_size=32, batch=128:
> > before: 6.69 +- 0.04 ns/object
> > after: 3.51 +- 0.06 ns/object
> > delta: -47.6%
> > 
> > obj_size=64, batch=64:
> > before: 10.48 +- 0.06 ns/object
> > after: 4.23 +- 0.07 ns/object
> > delta: -59.7%
> > 
> > obj_size=128, batch=32:
> > before: 18.31 +- 0.12 ns/object
> > after: 5.67 +- 0.13 ns/object
> > delta: -69.0%
> > 
> > obj_size=256, batch=32:
> > before: 21.59 +- 0.13 ns/object
> > after: 6.05 +- 0.14 ns/object
> > delta: -72.0%
> > 
> > obj_size=512, batch=32:
> > before: 19.44 +- 0.14 ns/object
> > after: 6.23 +- 0.13 ns/object
> > delta: -67.9%
> > 
> > - CONFIG_SLAB_FREELIST_RANDOM=y -
> > 
> > obj_size=16, batch=256:
> > before: 8.71 +- 0.31 ns/object
> > after: 3.44 +- 0.03 ns/object
> > delta: -60.5%
> > 
> > obj_size=32, batch=128:
> > before: 11.11 +- 0.12 ns/object
> > after: 4.00 +- 0.04 ns/object
> > delta: -64.0%
> > 
> > obj_size=64, batch=64:
> > before: 15.27 +- 0.32 ns/object
> > after: 5.10 +- 0.13 ns/object
> > delta: -66.6%
> > 
> > obj_size=128, batch=32:
> > before: 21.49 +- 0.23 ns/object
> > after: 6.93 +- 0.20 ns/object
> > delta: -67.8%
> > 
> > obj_size=256, batch=32:
> > before: 26.23 +- 0.42 ns/object
> > after: 7.42 +- 0.20 ns/object
> > delta: -71.7%
> > 
> > obj_size=512, batch=32:
> > before: 26.44 +- 0.35 ns/object
> > after: 7.62 +- 0.27 ns/object
> > delta: -71.2%
> > 
> > Link: https://github.com/HSM6236/slub_bulk_test.git
> > Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> > ---
> >  mm/slab.h |  10 ++
> >  mm/slub.c | 278 +++++++++++++++++++++++++++---------------------------
> >  2 files changed, 149 insertions(+), 139 deletions(-)
> > 
> > diff --git a/mm/slab.h b/mm/slab.h
> > index bf2f87acf5e3..ada3f9c3909f 100644
> > --- a/mm/slab.h
> > +++ b/mm/slab.h
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 4927407c9699..67ec8b29f862 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -3483,6 +3409,7 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
> >      slab->frozen = 0;
> > 
> >      slab->slab_cache = s;
> > +    slab->freelist = NULL;
> > 
> >      kasan_poison_slab(slab);
> >
> 
> nit: We could drop this hunk and call build_slab_freelist()
> unconditionally instead. If slab->inuse == slab->objects, ->freelist
> is set to NULL.
> 
> I think
> 
> "build_slab_freelist() is called unconditionally. It builds the freelist
>  if there is any object left, otherwise set ->freelist to NULL"
> 
> is easier  to follow than
> 
> "Oh we didn't call build_slab_freelist(). where is ->freelist set to
>  NULL?, oh, it's set in allocate_slab()"
> 

Good point. I will remove this “slab->freelist = NULL;” in v5.

> >  /*
> >   * Called only for kmem_cache_debug() caches to allocate from a freshly
> >   * allocated slab. Allocate a single object instead of whole freelist
> >   * and put the slab to the partial (or full) list.
> >   */
> >  static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
> > -                    int orig_size, gfp_t gfpflags)
> > +                    int orig_size, bool allow_spin)
> >  {
> > -    bool allow_spin = gfpflags_allow_spinning(gfpflags);
> > -    int nid = slab_nid(slab);
> > -    struct kmem_cache_node *n = get_node(s, nid);
> > +    struct kmem_cache_node *n;
> > +    struct slab_obj_iter iter;
> > +    bool needs_add_partial;
> >      unsigned long flags;
> >      void *object;
> > 
> > -    if (!allow_spin && !spin_trylock_irqsave(&n->list_lock, flags)) {
> > -        /* Unlucky, discard newly allocated slab. */
> > -        free_new_slab_nolock(s, slab);
> > -        return NULL;
> > -    }
> > -
> > -    object = slab->freelist;
> > -    slab->freelist = get_freepointer(s, object);
> > +    init_slab_obj_iter(s, slab, &iter, allow_spin);
> > +    object = next_slab_obj(s, &iter);
> >      slab->inuse = 1;
> > 
> > +    needs_add_partial = (slab->objects > 1);
> > +    if (needs_add_partial)
> 
> nit: Again this condition is already checked within build_slab_freelist().
> Let's call it unconditionally.
> 

Good point. I'll do that in v5 and make the related paths call
build_slab_freelist() unconditionally for consistency.

> > +        build_slab_freelist(s, slab, &iter);
> > +
> >      if (!alloc_debug_processing(s, slab, object, orig_size)) {
> >          /*
> >           * It's not really expected that this would fail on a
> > @@ -4359,33 +4360,30 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
> >       */
> >      needs_add_partial = (slab->objects > count);
> > 
> > -    if (!allow_spin && needs_add_partial) {
> > -
> > -        n = get_node(s, slab_nid(slab));
> > -
> > -        if (!spin_trylock_irqsave(&n->list_lock, flags)) {
> > -            /* Unlucky, discard newly allocated slab */
> > -            free_new_slab_nolock(s, slab);
> > -            return 0;
> > -        }
> > -    }
> > +    /* Target inuse count after allocating from this new slab. */
> > +    target_inuse = needs_add_partial ? count : slab->objects;
> > 
> > -    object = slab->freelist;
> > -    while (object && allocated < count) {
> > -        p[allocated] = object;
> > -        object = get_freepointer(s, object);
> > -        maybe_wipe_obj_freeptr(s, p[allocated]);
> > +    init_slab_obj_iter(s, slab, &iter, allow_spin);
> > 
> > -        slab->inuse++;
> > +    while (allocated < target_inuse) {
> > +        p[allocated] = next_slab_obj(s, &iter);
> >          allocated++;
> >      }
> > -    slab->freelist = object;
> > +    slab->inuse = target_inuse;
> > 
> >      if (needs_add_partial) {
> > -
> > +        build_slab_freelist(s, slab, &iter);
> 
> nit: per the suggestion above build_slab_freelist() should be called
> regardless of needs_add_partial...
> 

Good point. I'll do that in v5.

> > +        n = get_node(s, slab_nid(slab));
> >          if (allow_spin) {
> > -            n = get_node(s, slab_nid(slab));
> >              spin_lock_irqsave(&n->list_lock, flags);
> > +        } else if (!spin_trylock_irqsave(&n->list_lock, flags)) {
> > +            /*
> > +             * Unlucky, discard newly allocated slab.
> > +             * The slab is not fully free, but it's fine as
> > +             * objects are not allocated to users.
> > +             */
> > +            free_new_slab_nolock(s, slab);
> > +            return 0;
> 
> Sashiko raised a very good point [1] here.
> https://sashiko.dev/#/patchset/2026040823281824773ybHpC3kgUhR9OE1rGTl%40zte.com.cn
> 
> Now that we unconditionally fill the @p array, it becomes problematic that
> ___slab_alloc() doesn't check the return value of
> alloc_from_new_slab() but the value of `object` variable:
> |        if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {              
> |                object = alloc_single_from_new_slab(s, slab, orig_size, allow_spin);
> |
> |                if (likely(object))
> |                        goto success;                                           
> |        } else {                                                                
> |                alloc_from_new_slab(s, slab, &object, 1, allow_spin);           
> |
> |                /* we don't need to check SLAB_STORE_USER here */
> |                if (likely(object))
> 
> That's a use-after-free bug.
> It should really check the return value and not `object`.
> 
> if (alloc_from_new_slab(...))
>     return object;
> 
> |                        return object;
> |        }      
> 

Great catch — both from Sashiko and the Gemini-3.1-pro-preview. I'll fix the
___slab_alloc() side to check the return value of alloc_from_new_slab()
in v5.

> >          }
> >          add_partial(n, slab, ADD_TO_HEAD);
> >          spin_unlock_irqrestore(&n->list_lock, flags);
> > @@ -7596,14 +7591,19 @@ static void early_kmem_cache_node_alloc(int node)
> >          pr_err("SLUB: Allocating a useless per node structure in order to be able to continue\n");
> >      }
> > 
> > -    n = slab->freelist;
> > +    init_slab_obj_iter(kmem_cache_node, slab, &iter, true);
> > +
> > +    n = next_slab_obj(kmem_cache_node, &iter);
> >      BUG_ON(!n);
> > +
> > +    slab->inuse = 1;
> > +    if (slab->objects > 1)
> > +        build_slab_freelist(kmem_cache_node, slab, &iter);
> 
> nit: ditto. let's call build_slab_freelist() unconditionally.
> 
> >  #ifdef CONFIG_SLUB_DEBUG
> >      init_object(kmem_cache_node, n, SLUB_RED_ACTIVE);
> >  #endif
> >      n = kasan_slab_alloc(kmem_cache_node, n, GFP_KERNEL, false);
> > -    slab->freelist = get_freepointer(kmem_cache_node, n);
> > -    slab->inuse = 1;
> >      kmem_cache_node->per_node[node].node = n;
> >      init_kmem_cache_node(n);
> >      inc_slabs_node(kmem_cache_node, node, slab->objects);
> 
> Otherwise LGTM!
> 

Thanks again for the detailed review and for your patience across versions. :)

--
With Best Regards,
Shengming

> -- 
> Cheers,
> Harry / Hyeonggon

