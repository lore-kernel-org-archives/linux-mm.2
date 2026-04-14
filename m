Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ED9CF9D0CD
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 13:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB4F36B0088; Tue, 14 Apr 2026 09:41:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B65D36B008A; Tue, 14 Apr 2026 09:41:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2D916B0092; Tue, 14 Apr 2026 09:41:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BBD46B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:41:05 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 159EB1A058B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:41:05 +0000 (UTC)
X-FDA: 84657272490.24.DD6BC66
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf25.hostedemail.com (Postfix) with ESMTP id 76D5DA0005
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:41:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776174061; a=rsa-sha256;
	cv=none;
	b=fVTC450gq8SH0Fel1rSpL4rzscwlKxFGoMI5HBXf8j/njhl5ypltUXGFznb9y202e7leIS
	LtJolsC6xhfvR5SrVVo++ehxsULJ2kUXTsgEWhDhPNVnP7b6EhMrpvTBTEPgWrXCt/sA7q
	AxyHPf6/GCH8PmVNiah+Vce5Eif8Wjk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776174061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pwmbNQ1H6X4CMvHlGUkk/5EaL72039YtQyrn95eBijo=;
	b=15R6fl9lSauWMm/ZZwcAHrFTlW/6aCvHWKBxcgat6/zEpOTv7qASI9PCVi2USfLDAXyp+Y
	tnBCoiUEvaF+dysQoRk+CaWUadXhvWcWpmqynmQem2vYbGneKRbPTBenp+g8VEKg/+vIlt
	TgemVnKYDvk4Hs6FK4mhZORVxs1xA9k=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4fw55J3XNnz51SWB;
	Tue, 14 Apr 2026 21:40:52 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 63EDemAR003018;
	Tue, 14 Apr 2026 21:40:48 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 14 Apr 2026 21:40:50 +0800 (CST)
X-Zmail-TransId: 2afc69de43e2aec-d26c3
X-Mailer: Zmail v1.0
Message-ID: <20260414214050619-bhr4zGY4E0xLWc0olEiI@zte.com.cn>
In-Reply-To: <411f9b29-9b1c-4e2f-a212-f583280a6788@kernel.org>
References: 20260413230417835rnfiEWduEx44lc3u4uR9_@zte.com.cn,411f9b29-9b1c-4e2f-a212-f583280a6788@kernel.org
Date: Tue, 14 Apr 2026 21:40:50 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>
Cc: <harry@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <xu.xin16@zte.com.cn>,
        <yang.tao172@zte.com.cn>, <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2Nl0gbW0vc2x1YjogZGVmZXIgZnJlZWxpc3QgY29uc3RydWN0aW9uIHVudGlsIGFmdGVyIGJ1bGsgYWxsb2NhdGlvbiBmcm9tIGEgbmV3IHNsYWI=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 63EDemAR003018
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Tue, 14 Apr 2026 21:40:52 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69DE43E4.000/4fw55J3XNnz51SWB
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 76D5DA0005
X-Stat-Signature: htyi8a6rr4je7jfa8emqxfdnpua7hm9i
X-Rspam-User: 
X-HE-Tag: 1776174060-105987
X-HE-Meta: U2FsdGVkX1+wYwKEOvtcMlshAwdRKBWMR9wWao54HVDByf8UnO2k2uCwR95+KR2NIyoMqWkdKXaJ11kXUG3BEIFhfRlMrk7L0qfZMcey4jZx6mh5Hj5xAQpceMKzJW3C+fRNvhnep8l+FfUM0y+CK4oIMN4aeK6O5Xt1XIkTjzH6RdVxbbPwxneR6tWPilho57y20lzjwyBQSZd01/ZnTw01LnXTyIiHJgOpXAmJnTOsiLugfwmdh8mOHpeYINlDwj/hJ9pw0Z5f74GLe8NvlX5SFuiJ0IMHSyL+8hr5aszzXzqoJzU6EazULjM4FcqE7dj/7Ac0qoXgKxPB8cp7r4sR45GHzJjT94AcVNWkA3255pP2bEi9XyPA4r7V24MDsK0Kl5muCopaNaP5zcOwVsF5Cpv03O6TjQt9ZiWzqkAOr8TuI7+hDh0plvcplYJvGfnEixZwBQlATIOK6CyuvmRT+QtEz5/ln8lzXXNRwsd2Rmd+BnVqR6T7zgCDvWkRW+tJVPmjuMJy8uWnaJbaXWvDlxQW89SMcYRa7xxiBxmCG294IBqJNS9uhU5H1o/5kYjZBGOCsAaI6z3UGCQYyjknQs+nt5KU4CU2jXQkPrKUCd8wjtcEeEVG46l5aU7yg5ItfVamYTanmKMDGveZGu4u95V3H0OfNwUpzVMOyZQTb3bB0qBxy2QTCjNGlZcK2Y63oLLVnPVVN51ymaE5v8c+ehDcFBILwCWyBSfSAkx+79PkrIwLRIaqE636oagPJyPXnHFgMIAvKrquCl2oORQSW2qMbwels7W4EUOGOSxhEbpQoNO2g+b2XD8rf1sZw1qLS/NNiaYTNOIjjGLynMp9QETwmwHgohosEji9fe61tWcuM6KruWu53sMZ/6pFAiBWvYC/ZkXTvyVZ0WNv+TirS3IXZOErdNa3sJs1ZFECZ7HGmjMOk61ZmH1xmF/jr3eRJUF1iH9GmI/DmWp
 9ZnVuGu2
 TbuKR3NCAThy481WGiWmaf2eD6EuS7uOqKQacsILMptVz3plzuU/cfeoeSTceDVm6MMfqQQ3VfJ4Qvc7+4ntzZiIhCPpTQtarqpxhL/XsRoEQ0gJpwCf+d3zaX+SuAqOQZpmq/0lCw2FWoTat4d1+A0fg6ByLp89PQBka/E1COGPt6dMfCnxUkVuSEula4V/XTs/Su8JRRIfIzYIjcUx7pRyKV1PHYUn2ydiShSCq6yBOKg5WQoQfmgZFe49/PSeUNdujhVzuPxV1m2PCuPBYknYD2V22YnZ7GiXWxbSMj9krV8I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Vlastimil wrote:
> On 4/13/26 17:04, hu.shengming@zte.com.cn wrote:
> > From: Shengming Hu <hu.shengming@zte.com.cn>
> > 
> > Allocations from a fresh slab can consume all of its objects, and the
> > freelist built during slab allocation is discarded immediately as a result.
> > 
> > Instead of special-casing the whole-slab bulk refill case, defer freelist
> > construction until after objects are emitted from a fresh slab.
> > new_slab() now only allocates the slab and initializes its metadata.
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
> > This reduces per-object overhead when allocating from a fresh slab.
> > The most direct benefit is in the paths that allocate objects first and
> > only build a freelist for the remainder afterward: bulk allocation from
> > a new slab in refill_objects(), single-object allocation from a new slab
> > in ___slab_alloc(), and the corresponding early-boot paths that now use
> > the same deferred-freelist scheme. Since refill_objects() is also used to
> > refill sheaves, the optimization is not limited to the small set of
> > kmem_cache_alloc_bulk()/kmem_cache_free_bulk() users; regular allocation
> > workloads may benefit as well when they refill from a fresh slab.
> > 
> > In slub_bulk_bench, the time per object drops by about 32% to 70% with
> > CONFIG_SLAB_FREELIST_RANDOM=n, and by about 50% to 67% with
> > CONFIG_SLAB_FREELIST_RANDOM=y. This benchmark is intended to isolate the
> > cost removed by this change: each iteration allocates exactly
> > slab->objects from a fresh slab. That makes it a near best-case scenario
> > for deferred freelist construction, because the old path still built a
> > full freelist even when no objects remained, while the new path avoids
> > that work. Realistic workloads may see smaller end-to-end gains depending
> > on how often allocations reach this fresh-slab refill path.
> > 
> > Benchmark results (slub_bulk_bench):
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
> > before: 4.91 +- 0.07 ns/object
> > after: 3.29 +- 0.03 ns/object
> > delta: -32.8%
> > 
> > obj_size=32, batch=128:
> > before: 6.96 +- 0.07 ns/object
> > after: 3.73 +- 0.05 ns/object
> > delta: -46.4%
> > 
> > obj_size=64, batch=64:
> > before: 10.77 +- 0.12 ns/object
> > after: 4.65 +- 0.06 ns/object
> > delta: -56.8%
> > 
> > obj_size=128, batch=32:
> > before: 19.04 +- 0.22 ns/object
> > after: 6.30 +- 0.07 ns/object
> > delta: -66.9%
> > 
> > obj_size=256, batch=32:
> > before: 22.20 +- 0.26 ns/object
> > after: 6.68 +- 0.06 ns/object
> > delta: -69.9%
> > 
> > obj_size=512, batch=32:
> > before: 20.03 +- 0.62 ns/object
> > after: 6.83 +- 0.09 ns/object
> > delta: -65.9%
> > 
> > - CONFIG_SLAB_FREELIST_RANDOM=y -
> > 
> > obj_size=16, batch=256:
> > before: 8.72 +- 0.06 ns/object
> > after: 4.31 +- 0.05 ns/object
> > delta: -50.5%
> > 
> > obj_size=32, batch=128:
> > before: 11.29 +- 0.13 ns/object
> > after: 4.93 +- 0.05 ns/object
> > delta: -56.3%
> > 
> > obj_size=64, batch=64:
> > before: 15.36 +- 0.24 ns/object
> > after: 5.95 +- 0.10 ns/object
> > delta: -61.3%
> > 
> > obj_size=128, batch=32:
> > before: 21.75 +- 0.26 ns/object
> > after: 8.10 +- 0.14 ns/object
> > delta: -62.8%
> > 
> > obj_size=256, batch=32:
> > before: 26.62 +- 0.26 ns/object
> > after: 8.58 +- 0.22 ns/object
> > delta: -67.8%
> > 
> > obj_size=512, batch=32:
> > before: 26.88 +- 0.36 ns/object
> > after: 8.81 +- 0.11 ns/object
> > delta: -67.2%
> > 
> > Link: https://github.com/HSM6236/slub_bulk_test.git
> > Suggested-by: Harry Yoo (Oracle) <harry@kernel.org>
> > Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> > Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> 
> Nice!
> 
> >  mm/slab.h |  10 ++
> >  mm/slub.c | 283 +++++++++++++++++++++++++++---------------------------
> >  2 files changed, 151 insertions(+), 142 deletions(-)
> 
> And the delta is just 19 new lines of code, good!
> 
> Just some nits.
> 

Hi Vlastimil, 

Thanks for the review.

> 
> > diff --git a/mm/slab.h b/mm/slab.h
> > index bf2f87acf5e3..ada3f9c3909f 100644
> > --- a/mm/slab.h
> > +++ b/mm/slab.h
> > @@ -91,6 +91,16 @@ struct slab {
> >  #endif
> >  };
> > 
> > +struct slab_obj_iter {
> > +    unsigned long pos;
> > +    void *start;
> > +#ifdef CONFIG_SLAB_FREELIST_RANDOM
> > +    unsigned long freelist_count;
> > +    unsigned long page_limit;
> > +    bool random;
> > +#endif
> > +};
> 
> I think this struct could live in slub.c as mothing else needs it?
> 

Agreed. I'll move struct slab_obj_iter into mm/slub.c.

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
> > +    build_slab_freelist(s, slab, &iter);
> > +
> >      if (!alloc_debug_processing(s, slab, object, orig_size)) {
> >          /*
> >           * It's not really expected that this would fail on a
> > @@ -3696,20 +3686,32 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
> >           * corruption in theory could cause that.
> >           * Leak memory of allocated slab.
> >           */
> > -        if (!allow_spin)
> > -            spin_unlock_irqrestore(&n->list_lock, flags);
> >          return NULL;
> >      }
> > 
> > -    if (allow_spin)
> > +    n = get_node(s, slab_nid(slab));
> > +    if (allow_spin) {
> >          spin_lock_irqsave(&n->list_lock, flags);
> > +    } else if (!spin_trylock_irqsave(&n->list_lock, flags)) {
> > +        /*
> > +         * Unlucky, discard newly allocated slab.
> > +         * The slab is not fully free, but it's fine as
> > +         * objects are not allocated to users.
> > +         */
> > +        free_new_slab_nolock(s, slab);
> 
> I was going to complain that we can leave alloc_debug_processing() without a
> corresponding free_debug_processing(). But it seems it can't have any bad
> effect. Only with SLAB_TRACE we would print alloc without corresponding
> free. But I doubt anyone uses it anyway.
> 

Agreed. This should not cause any functional issues, and SLAB_TRACE is
rarely enabled, so I think it is fine as-is. Please let me know
if you have any other comments.

> > +        return NULL;
> > +    }
> > 
> > -    if (slab->inuse == slab->objects)
> > -        add_full(s, n, slab);
> > -    else
> > +    if (needs_add_partial)
> >          add_partial(n, slab, ADD_TO_HEAD);
> > +    else
> > +        add_full(s, n, slab);
> > 
> > -    inc_slabs_node(s, nid, slab->objects);
> > +    /*
> > +     * Debug caches require nr_slabs updates under n->list_lock so validation
> > +     * cannot race with slab (de)allocations and observe inconsistent state.
> > +     */
> > +    inc_slabs_node(s, slab_nid(slab), slab->objects);
> >      spin_unlock_irqrestore(&n->list_lock, flags);
> > 
> >      return object;
> > @@ -4349,9 +4351,10 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
> >  {
> >      unsigned int allocated = 0;
> >      struct kmem_cache_node *n;
> > +    struct slab_obj_iter iter;
> >      bool needs_add_partial;
> >      unsigned long flags;
> > -    void *object;
> > +    unsigned int target_inuse;
> > 
> >      /*
> >       * Are we going to put the slab on the partial list?
> > @@ -4359,33 +4362,30 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
> >       */
> >      needs_add_partial = (slab->objects > count);
> 
> How about
> 
>     bool needs_add_partial = true;
> 
>     ...
> 
>     if (count >= slab->objects) {
>         needs_add_partial = false;
>         count = slab->objects;
>     }
> 
> Then we don't need target_inuse and can use count.
> 

Good suggestion. I'll reuse count and drop target_inuse.

> > -    if (!allow_spin && needs_add_partial) {
> > +    /* Target inuse count after allocating from this new slab. */
> > +    target_inuse = needs_add_partial ? count : slab->objects;
> > 
> > -        n = get_node(s, slab_nid(slab));
> > +    init_slab_obj_iter(s, slab, &iter, allow_spin);
> > 
> > -        if (!spin_trylock_irqsave(&n->list_lock, flags)) {
> > -            /* Unlucky, discard newly allocated slab */
> > -            free_new_slab_nolock(s, slab);
> > -            return 0;
> > -        }
> > -    }
> > -
> > -    object = slab->freelist;
> > -    while (object && allocated < count) {
> > -        p[allocated] = object;
> > -        object = get_freepointer(s, object);
> > -        maybe_wipe_obj_freeptr(s, p[allocated]);
> > -
> > -        slab->inuse++;
> > +    while (allocated < target_inuse) {
> > +        p[allocated] = next_slab_obj(s, &iter);
> >          allocated++;
> >      }
> > -    slab->freelist = object;
> > +    slab->inuse = target_inuse;
> > +    build_slab_freelist(s, slab, &iter);
> > 
> >      if (needs_add_partial) {
> > -
> > +        n = get_node(s, slab_nid(slab));
> 
> The declaration of 'n' could move here.
> 

Right, I'll move it into that block.

--
With Best Regards,
Shengming

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
> 
> Yeah I think this is ok.
> 
> > +            return 0;
> >          }
> >          add_partial(n, slab, ADD_TO_HEAD);
> >          spin_unlock_irqrestore(&n->list_lock, flags);
> > @@ -4456,15 +4456,13 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
> >      stat(s, ALLOC_SLAB);
> > 
> >      if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
> > -        object = alloc_single_from_new_slab(s, slab, orig_size, gfpflags);
> > +        object = alloc_single_from_new_slab(s, slab, orig_size, allow_spin);
> > 
> >          if (likely(object))
> >              goto success;
> >      } else {
> > -        alloc_from_new_slab(s, slab, &object, 1, allow_spin);
> > -
> >          /* we don't need to check SLAB_STORE_USER here */
> > -        if (likely(object))
> > +        if (alloc_from_new_slab(s, slab, &object, 1, allow_spin))
> >              return object;
> >      }
> > 
> > @@ -7251,10 +7249,6 @@ refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
> > 
> >      stat(s, ALLOC_SLAB);
> > 
> > -    /*
> > -     * TODO: possible optimization - if we know we will consume the whole
> > -     * slab we might skip creating the freelist?
> > -     */
> >      refilled += alloc_from_new_slab(s, slab, p + refilled, max - refilled,
> >                      /* allow_spin = */ true);
> > 
> > @@ -7585,6 +7579,7 @@ static void early_kmem_cache_node_alloc(int node)
> >  {
> >      struct slab *slab;
> >      struct kmem_cache_node *n;
> > +    struct slab_obj_iter iter;
> > 
> >      BUG_ON(kmem_cache_node->size < sizeof(struct kmem_cache_node));
> > 
> > @@ -7596,14 +7591,18 @@ static void early_kmem_cache_node_alloc(int node)
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
> > +    build_slab_freelist(kmem_cache_node, slab, &iter);
> > +
> >  #ifdef CONFIG_SLUB_DEBUG
> >      init_object(kmem_cache_node, n, SLUB_RED_ACTIVE);
> >  #endif
> >      n = kasan_slab_alloc(kmem_cache_node, n, GFP_KERNEL, false);
> > -    slab->freelist = get_freepointer(kmem_cache_node, n);
> > -    slab->inuse = 1;
> >      kmem_cache_node->per_node[node].node = n;
> >      init_kmem_cache_node(n);
> >      inc_slabs_node(kmem_cache_node, node, slab->objects);

