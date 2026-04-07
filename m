Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E289EFEEF33
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 13:02:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 229E36B009F; Tue,  7 Apr 2026 09:02:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DB7B6B00A1; Tue,  7 Apr 2026 09:02:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F1A86B00A2; Tue,  7 Apr 2026 09:02:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED8466B009F
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 09:02:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9595FBB396
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 13:02:32 +0000 (UTC)
X-FDA: 84631773744.18.6D92780
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf23.hostedemail.com (Postfix) with ESMTP id B883F14002D
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 13:02:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775566950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qleby9DODNbNhJ2I4eOSo+5h9fl+V9pt5dPXALCFaiM=;
	b=tLYw7BvDcrzyqq8fnPVbdmUpZkBC4vR9Tcau597QQclgBE9tO9aOr6DSAefCVJDXj2WVUm
	HvV/44UHHZ3Mu5Pz6LEgCTCMO6OuhINoqvQjR/bZnjURm+WWkYYN8cqwRe3es/udrFe+RJ
	e1zTHRTRCDUAmLXNtg3Ymf9LGF5fo40=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775566950; a=rsa-sha256;
	cv=none;
	b=0GAnk5j1YJeyKPHGq9Wv95jjHFUsEG/GBHAw/irQuZonvRhiIWsA7xcMUT3ETLeEXuwiS0
	KD6EY4kR7vbz2HltEXTP7VEpDh5CMNDGVWY6MHdXeN8OpFSVreFSs17S3NUz5CSxzEE2TE
	1bRsC/vJtFbJ/ksSoPiCIh0+yNEIZwE=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4fqmZ60SYrz8Xs6v;
	Tue, 07 Apr 2026 21:02:22 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 637D2F6V003314;
	Tue, 7 Apr 2026 21:02:15 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 7 Apr 2026 21:02:16 +0800 (CST)
X-Zmail-TransId: 2af969d50058bcf-9a1b7
X-Mailer: Zmail v1.0
Message-ID: <20260407210216761qrDj8RR7pN-ycbvYmA69v@zte.com.cn>
In-Reply-To: <adSFyyFWlLy177rB@hyeyoo>
References: 202604062150182836ygUiyPoKcxtHjgF7rWXe@zte.com.cn,adSFyyFWlLy177rB@hyeyoo
Date: Tue, 7 Apr 2026 21:02:16 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <harry@kernel.org>
Cc: <vbabka@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <xu.xin16@zte.com.cn>,
        <yang.tao172@zte.com.cn>, <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2M10gbW0vc2x1YjogZGVmZXIgZnJlZWxpc3QgY29uc3RydWN0aW9uIHVudGlsIGFmdGVyIGJ1bGsgYWxsb2NhdGlvbiBmcm9tIGEgbmV3IHNsYWI=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 637D2F6V003314
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Tue, 07 Apr 2026 21:02:22 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69D5005E.000/4fqmZ60SYrz8Xs6v
X-Rspam-User: 
X-Rspamd-Queue-Id: B883F14002D
X-Stat-Signature: 7cgurx1k9o3gmeay516fyknaiz5i6gpz
X-Rspamd-Server: rspam06
X-HE-Tag: 1775566947-837615
X-HE-Meta: U2FsdGVkX18sNs1naK5ctpJL0MHqVg8F2vKik9nEKltlv5bkFZmNpd3cUbCQpzhQ2cEfWUhcXOA93Lkdr3Md37ogv//EoxEZ9ssTwHqdTpGfIlZv6ayUnbkLlJW/D4zQ6wWuWIghdn/castniNaZM2yQk9lh6DPTFBjt0WWHsIoIfXPEKl+cOzrOapjw991OSG5IVI+uugGTlS12/M66sOaPuyT/UlbGS1XxV+WjuhtHbLgBnQN8I4Bs9n0xR0wzL0Zc40ljUHvJtbvb3QDzdREZ8PS6Hd1VuPx/MItD2AH3+W9LRwzXljRaHhBPys3HUe2dbMkmtz83p8k9NnPi96ieBgQgDkqZP0yGT1IK/YE5Gll4Q2DSCGcxiyF52ey2IcKxkA7Rb7oTSLnKgqQTFmBYXmwhfXC5JeqoB8n3/eMJ09m3fb5M9yzFo58FZJDji4s4L/2k6jEqhIRGQt+KP2Fu3T9ADtGp/vFM8t8nDWPNMAcFyf9TwMaO3D4vxBnSSK8rLFvgp3Uc1kUZ2/4SWJzydZoO/+c69oO05DK/s7fGCtfr5JFJnDoYmceOIM4jzuGXQ0Ql9NT9+009muUKq858ReWOMoRzE/XpeKEjucUruSFsbsKY9FPaM6cfxnZGnnGOt+APU1M+w3oNHRFEkz1CtXKNUVuz4P6J9OXjh2FAy13ZhzzXsqN27QL6QaK+RSRYi9YSGUy8bvUVqFM1JzzyR877zCHmM/SuU6ovacGZtWQeHljLqSKA7+ZYsojGOt7LYKsOfBJ8AcSgAKhMKhkyJ2eGeg+odjlj5I6t62QENd2M1ZC5UaDKNHyMjQPo5i/QyPmiSxYDobuOB9y22m7CcZnN50bz4iK3e1bSzTKbYG0lqYyshp81cFGqa6zlNua3ywmI6Jg7cuz1EKJJhqgavp8SFes31sTWnkb4fFM09wEHl9De5vLzDm74Go9Wx855eoAywWqv9BAsVDa
 H7HiYFSx
 ANVtFwYmFK5cxHxaiPvJjJF+7L2FTR0zvqmjxvg5lZfqSLO1SYjNrnHgbuMuHpWde/ONWLV3PlINAGO9cahM6oIE08eOQqHJVfiGgu5Vma582ITJ0pTGfdVRROF1KH+j6wpOOkWwWygF337AopXE8PvghrtO+Imas4EOJfNsU38U5JPbwUgeZy0fq1TDfn4kJMIxd+ypUCEsyfA99bK8SouUeGHJ7VE/QZjAuf22TlNz77i/NbyXjhJ9z9NJVP10+2gHQ8floIyLJdJcz2fARYgiGwHFGfYcd2NFKvxTUIompTTY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry wrote:

> Hi Shengming, thanks for v3!
> 
> Good to see it's getting improved over the revisions.
> Let me leave some comments inline.
> 

Hi Harry,

Thanks a lot for the detailed review.

> On Mon, Apr 06, 2026 at 09:50:18PM +0800, hu.shengming@zte.com.cn wrote:
> > From: Shengming Hu <hu.shengming@zte.com.cn>
> > 
> > refill_objects() can consume many objects from a fresh slab, and when it
> > takes all objects from the slab the freelist built during slab allocation
> > is discarded immediately.
> > 
> > Instead of special-casing the whole-slab bulk refill case, defer freelist
> > construction until after objects are emitted from the new slab.
> > allocate_slab() now allocates and initializes slab metadata only.
> > new_slab() preserves the existing behaviour by building the full freelist
> > on top, while refill_objects() allocates a raw slab and lets
> > alloc_from_new_slab() emit objects directly and build a freelist only for
> > the remaining objects, if any.
> > 
> > To keep CONFIG_SLAB_FREELIST_RANDOM=y/n on the same path, introduce a
> > small iterator abstraction for walking free objects in allocation order.
> > The iterator is used both for filling the sheaf and for building the
> > freelist of the remaining objects.
> > 
> > This removes the need for a separate whole-slab special case, avoids
> > temporary freelist construction when the slab is consumed entirely.
> > 
> > Also mark setup_object() inline. After this optimization, the compiler no
> > longer consistently inlines this helper in the hot path, which can hurt
> > performance. Explicitly marking it inline restores the expected code
> > generation.
> > 
> > This reduces per-object overhead in bulk allocation paths and improves
> > allocation throughput significantly. In slub_bulk_bench, the time per
> > object drops by about 41% to 70% with CONFIG_SLAB_FREELIST_RANDOM=n, and
> > by about 59% to 71% with CONFIG_SLAB_FREELIST_RANDOM=y.
> > 
> > Benchmark results (slub_bulk_bench):
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
> > before: 4.62 +- 0.01 ns/object
> > after: 2.72 +- 0.01 ns/object
> > delta: -41.1%
> > 
> > obj_size=32, batch=128:
> > before: 6.58 +- 0.02 ns/object
> > after: 3.30 +- 0.02 ns/object
> > delta: -49.8%
> > 
> > obj_size=64, batch=64:
> > before: 10.20 +- 0.03 ns/object
> > after: 4.22 +- 0.03 ns/object
> > delta: -58.7%
> > 
> > obj_size=128, batch=32:
> > before: 17.91 +- 0.04 ns/object
> > after: 5.73 +- 0.09 ns/object
> > delta: -68.0%
> > 
> > obj_size=256, batch=32:
> > before: 21.03 +- 0.12 ns/object
> > after: 6.22 +- 0.08 ns/object
> > delta: -70.4%
> > 
> > obj_size=512, batch=32:
> > before: 19.00 +- 0.21 ns/object
> > after: 6.45 +- 0.13 ns/object
> > delta: -66.0%
> > 
> > - CONFIG_SLAB_FREELIST_RANDOM=y -
> > 
> > obj_size=16, batch=256:
> > before: 8.37 +- 0.06 ns/object
> > after: 3.38 +- 0.05 ns/object
> > delta: -59.6%
> > 
> > obj_size=32, batch=128:
> > before: 11.00 +- 0.13 ns/object
> > after: 4.05 +- 0.01 ns/object
> > delta: -63.2%
> > 
> > obj_size=64, batch=64:
> > before: 15.30 +- 0.20 ns/object
> > after: 5.21 +- 0.03 ns/object
> > delta: -65.9%
> > 
> > obj_size=128, batch=32:
> > before: 21.55 +- 0.14 ns/object
> > after: 7.10 +- 0.02 ns/object
> > delta: -67.1%
> > 
> > obj_size=256, batch=32:
> > before: 26.27 +- 0.29 ns/object
> > after: 7.54 +- 0.05 ns/object
> > delta: -71.3%
> > 
> > obj_size=512, batch=32:
> > before: 26.69 +- 0.28 ns/object
> > after: 7.73 +- 0.09 ns/object
> > delta: -71.0%
> > 
> > Link: https://github.com/HSM6236/slub_bulk_test.git
> > Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> > ---
> > Changes in v2:
> > - Handle CONFIG_SLAB_FREELIST_RANDOM=y and add benchmark results.
> > - Update the QEMU benchmark setup to use -enable-kvm -cpu host so benchmark results better reflect native CPU performance.
> > - Link to v1: https://lore.kernel.org/all/20260328125538341lvTGRpS62UNdRiAAz2gH3@zte.com.cn/
> > 
> > Changes in v3:
> > - refactor fresh-slab allocation to use a shared slab_obj_iter
> > - defer freelist construction until after bulk allocation from a new slab
> > - build a freelist only for leftover objects when the slab is left partial
> > - add build_slab_freelist(), prepare_slab_alloc_flags() and next_slab_obj() helpers
> > - remove obsolete freelist construction helpers now replaced by the iterator-based path, including next_freelist_entry() and shuffle_freelist()
> > - Link to v2: https://lore.kernel.org/all/202604011257259669oAdDsdnKx6twdafNZsF5@zte.com.cn/
> > 
> > ---
> >  mm/slab.h |  11 +++
> >  mm/slub.c | 256 +++++++++++++++++++++++++++++-------------------------
> >  2 files changed, 149 insertions(+), 118 deletions(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index fb2c5c57bc4e..88537e577989 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -4344,14 +4245,130 @@ static __always_inline void maybe_wipe_obj_freeptr(struct kmem_cache *s,
> >              0, sizeof(void *));
> >  }
> >  
> > +/* Return the next free object in allocation order. */
> > +static inline void *next_slab_obj(struct kmem_cache *s,
> > +                  struct slab_obj_iter *iter)
> > +{
> > +#ifdef CONFIG_SLAB_FREELIST_RANDOM
> > +    if (iter->random) {
> > +        unsigned long idx;
> > +
> > +        /*
> > +         * If the target page allocation failed, the number of objects on the
> > +         * page might be smaller than the usual size defined by the cache.
> > +         */
> > +        do {
> > +            idx = s->random_seq[iter->pos];
> > +            iter->pos++;
> > +            if (iter->pos >= iter->freelist_count)
> > +                iter->pos = 0;
> > +        } while (unlikely(idx >= iter->page_limit));
> > +
> > +        return setup_object(s, (char *)iter->start + idx);
> > +    }
> > +#endif
> > +    void *obj = iter->cur;
> > +
> > +    iter->cur = (char *)iter->cur + s->size;
> > +    return setup_object(s, obj);
> > +}
> > +
> > +/* Initialize an iterator over free objects in allocation order. */
> > +static inline void init_slab_obj_iter(struct kmem_cache *s, struct slab *slab,
> > +                      struct slab_obj_iter *iter,
> > +                      bool allow_spin)
> > +{
> > +    iter->pos = 0;
> > +    iter->start = fixup_red_left(s, slab_address(slab));
> > +    iter->cur = iter->start;
> 
> It's confusing that iter->pos field is used only when randomization is
> enabled and iter->cur field is used only when randomization is disabled.
> 
> I think we could simply use iter->pos for both random and non-random cases
> (as I have shown in the skeleton before)?
> 

Right, I introduced cur only to keep the non-random iteration close to
the original form, but I agree that using pos for both cases is cleaner.

> > +#ifdef CONFIG_SLAB_FREELIST_RANDOM
> > +    iter->random = (slab->objects >= 2 && s->random_seq);
> > +    if (!iter->random)
> > +        return;
> > +
> > +    iter->freelist_count = oo_objects(s->oo);
> > +    iter->page_limit = slab->objects * s->size;
> > +
> > +    if (allow_spin) {
> > +        iter->pos = get_random_u32_below(iter->freelist_count);
> > +    } else {
> > +        struct rnd_state *state;
> > +
> > +        /*
> > +         * An interrupt or NMI handler might interrupt and change
> > +         * the state in the middle, but that's safe.
> > +         */
> > +        state = &get_cpu_var(slab_rnd_state);
> > +        iter->pos = prandom_u32_state(state) % iter->freelist_count;
> > +        put_cpu_var(slab_rnd_state);
> > +    }
> > +#endif
> > +}
> >  static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
> >          void **p, unsigned int count, bool allow_spin)
> 
> There is one problem with this change; ___slab_alloc() builds the
> freelist before calling alloc_from_new_slab(), while refill_objects()
> does not. For consistency, let's allocate a new slab without building
> freelist in ___slab_alloc() and build the freelist in
> alloc_single_from_new_slab() and alloc_from_new_slab()?
> 

Agreed, also, new_slab() is currently used by both early_kmem_cache_node_alloc()
and ___slab_alloc(), so I'll rework the early allocation path as well to
keep the new-slab flow consistent.

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
> > @@ -4359,6 +4376,9 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
> >       */
> >      needs_add_partial = (slab->objects > count);
> >  
> > +    /* Target inuse count after allocating from this new slab. */
> > +    target_inuse = needs_add_partial ? count : slab->objects;
> > +
> >      if (!allow_spin && needs_add_partial) {
> >  
> >          n = get_node(s, slab_nid(slab));
> 
> Now new slabs without freelist can be freed in this path.
> which is confusing but should be _technically_ fine, I think...
> 
> > @@ -4370,19 +4390,18 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
> >          }
> >      }
> >  
> > -    object = slab->freelist;
> > -    while (object && allocated < count) {
> > -        p[allocated] = object;
> > -        object = get_freepointer(s, object);
> > +    init_slab_obj_iter(s, slab, &iter, allow_spin);
> > +
> > +    while (allocated < target_inuse) {
> > +        p[allocated] = next_slab_obj(s, &iter);
> >          maybe_wipe_obj_freeptr(s, p[allocated]);
> 
> We don't have to wipe the free pointer as we didn't build the freelist?
> 

Right, maybe_wipe_obj_freeptr() is not needed for objects emitted directly from a fresh slab,
I'll remove it.

> > -        slab->inuse++;
> >          allocated++;
> >      }
> > -    slab->freelist = object;
> > +    slab->inuse = target_inuse;
> >  
> >      if (needs_add_partial) {
> > -
> > +        build_slab_freelist(s, slab, &iter);
> 
> When allow_spin is true, it's building the freelist while holding the
> spinlock, and that's not great.
> 
> Hmm, can we do better?
> 
> Perhaps just allocate object(s) from the slab and build the freelist
> with the objects left (if exists), but free the slab if allow_spin
> is false AND trylock fails, and accept the fact that the slab may not be
> fully free when it's freed due to trylock failure?
> 
> something like:
> 
> alloc_from_new_slab() {
>     needs_add_partial = (slab->objects > count);
>     target_inuse = needs_add_partial ? count : slab->objects;
> 
>     init_slab_obj_iter(s, slab, &iter, allow_spin);
>     while (allocated < target_inuse) {
>         p[allocated] = next_slab_obj(s, &iter);
>         allocated++;
>     }
>     slab->inuse = target_inuse;
> 
>     if (needs_add_partial) {
>         build_slab_freelist(s, slab, &iter);
>         n = get_node(s, slab_nid(slab))
>         if (allow_spin) {
>             spin_lock_irqsave(&n->list_lock, flags);
>         } else if (!spin_trylock_irqsave(&n->list_lock, flags)) {
>             /* 
>              * Unlucky, discard newly allocated slab.
>              * The slab is not fully free, but it's fine as
>              * objects are not allocated to users.
>              */
>             free_new_slab_nolock(s, slab);
>             return 0;
>         }
>         add_partial(n, slab, ADD_TO_HEAD);
>         spin_unlock_irqrestore(&n->list_lock, flags);
>     }
>     [...]
> }
> 
> And do something similar in alloc_single_from_new_slab() as well.
> 

Good point. I'll restructure the path so objects are emitted first, the leftover
freelist is built only if needed, and the slab is added to partial afterwards. For
the !allow_spin trylock failure case, I'll discard the new slab and return 0. I'll
do the same for the single-object path as well.

> >          if (allow_spin) {
> >              n = get_node(s, slab_nid(slab));
> >              spin_lock_irqsave(&n->list_lock, flags);
> > @@ -7244,16 +7265,15 @@ refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
> >  
> >  new_slab:
> >  
> > -    slab = new_slab(s, gfp, local_node);
> > +    slab_gfp = prepare_slab_alloc_flags(s, gfp);
> 
> Could we do `flags = prepare_slab_alloc_flags(s, flags);`
> within allocate_slab()? Having gfp and slab_gfp flags is distractive.
> The value of allow_spin should not change after
> prepare_slab_alloc_flags() anyway.
> 

Agreed. I'll move the prepare_slab_alloc_flags() handling into allocate_slab()
so the call sites stay simpler, and keep the iterator/freelist construction
local to alloc_single_from_new_slab() and alloc_from_new_slab().

I also have a question about the allow_spin semantics in the refill_objects path.

Now that init_slab_obj_iter() has been moved into alloc_from_new_slab(..., true),
allow_spin on this path appears to be unconditionally set to true.

Previously, shuffle_freelist() received allow_spin = gfpflags_allow_spinning(gfp),
so I wanted to check whether moving init_slab_obj_iter() into alloc_from_new_slab()
changes the intended semantics here.

My current understanding is that this is still fine, because refill_objects()
is guaranteed to run only when spinning is allowed. Is that correct?

> > +    allow_spin = gfpflags_allow_spinning(slab_gfp);
> > +
> > +    slab = allocate_slab(s, slab_gfp, local_node, allow_spin);
> >      if (!slab)
> >          goto out;
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
> > -- 
> > 2.25.1
> 
> -- 
> Cheers,
> Harry / Hyeonggon

Thanks again. I will fold these changes into the next revision.
--
With Best Regards,
Shengming

