Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94BA5105D991
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 01:38:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78786B0088; Tue,  7 Apr 2026 21:38:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B29F16B0089; Tue,  7 Apr 2026 21:38:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3F556B008A; Tue,  7 Apr 2026 21:38:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 919D06B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 21:38:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F05298C9DA
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 01:38:36 +0000 (UTC)
X-FDA: 84633679032.28.E2D827A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6295440009
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 01:38:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pYMUC06T;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775612315; a=rsa-sha256;
	cv=none;
	b=8pA5esFq9JkoIoU+I0q81ySXyU8Teku0tHiUqHBprh+Ng9WwyN7EHhAsKPnKTWcGcm6slr
	AeAG5Hc8+msokvjMg525zU5OS7XN6DhCuDDi6qWsVzFYOCcxGFxmW5JtVfSbpDhU/6XFlB
	0CtkAliv+xsyLkmWhGT8ZM0RgDRoJCg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775612315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pU7KO9tuLTYvSMi1eBL8b53sP9TaEYK9+CkL6tk5R1E=;
	b=w8hfbETzXN2sEiBrPMmkERIolqg4o9Gy7WbzR9ybymAxNZlC7PoEUzhkVlsQHK1TKsveqj
	/gRJYUljc5HDyvDrtCGb7hZUkgVI4eBEzpkfn8LrfCxtQ+IidXEC3OlH/0yCIOu5ceVA8+
	oVK0stS2dHypgsBBX8H/Jv3yroj3QJo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pYMUC06T;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CF45E6012B;
	Wed,  8 Apr 2026 01:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E6EC19421;
	Wed,  8 Apr 2026 01:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775612314;
	bh=K8m42IOYFnKEeERMd4eWHH9pYeXT5uciLN7M1Iy9Pd0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pYMUC06TOe4DYzOSe9U826zQCYoG7FWrVUrS52NDNXKbOIPjvmePKVr6CPUWHMeoR
	 XgUWpMbG/jgOlti3N2WRoc0716abLsGen4OLQ7HAgEnbD8JeYYBxiFEJQ7Uv3WGRwZ
	 TMtBUR1g+GANnWX4pRaACtQECG9+Db6BCuKf2whNwjMMYh0W0V1lsu+piIlK8PMAPl
	 bDd4w5LHy6sNDCm1vcTvjcW+lhShIN/NEaY1b5/nuo6om9lKwnGRhlPy4i/DzUqt7i
	 EwEnWWj9GpLx5hLv/AS9nESWabcuc3THhYlTZ8+aPrhMU7/9rdgDW+lZfqX88i/M6m
	 t6TAvJNHW4CLA==
Date: Wed, 8 Apr 2026 10:38:32 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: hu.shengming@zte.com.cn
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev,
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	zhang.run@zte.com.cn, xu.xin16@zte.com.cn, yang.tao172@zte.com.cn,
	yang.yang29@zte.com.cn
Subject: Re: [PATCH v3] mm/slub: defer freelist construction until after bulk
 allocation from a new slab
Message-ID: <adWxmEzU23nza_pn@hyeyoo>
References: <adSFyyFWlLy177rB@hyeyoo>
 <20260407210216761qrDj8RR7pN-ycbvYmA69v@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407210216761qrDj8RR7pN-ycbvYmA69v@zte.com.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6295440009
X-Stat-Signature: pj96btsy5azrihx3jm1yxgz79t1w5uc1
X-HE-Tag: 1775612315-259242
X-HE-Meta: U2FsdGVkX18tJOifZOeZ2ltVpnpEqNmO27mSuUKlIro1CxpjeU55FBbI5aNaESHCE1oWwgEqBXCSpj9snAvbugJbjQ0TNRGiPEEdpamJfUmAWKyOaBd2B33qWZyRtMWbPPDc+EdSEpDT6i+U19mRj0Fvbi6fmD74pXrutwHbnRY5aydPuexasunNVCF3T1P4CsmWJgsnOZzcxTDvWpjnX3+tGZ0+JcY1kF7s5WFWfZ1u320S6YxbcIV0S5F9bCcsctKmXsUy66cRC7LiLYlGQg6N9REDZwhKxR22UrJv19138ahqLSR0ip49WdDhBITakPsA2w60xJ8lcvSyUYxdmIzJdpGu0XAG46Y4EG5rLYBRnXtiAL0o5U0Vja4A6VV64JzMLRZhmK4oUYdqj/iPwslT9O6S7EUgzYeD37aWxlfWDxuO3BqrNgQ1pVbssvs4wAa6kqaBuM5/D47brZR655vGaL9nbj3DUZfuN6Igl7u5AsrvmY7TbliGliS0GWp5tFL/yK2128eCFBVoUtgndFBO+7z8jtU1wdp4DYF62tGn3jGdDtb+w2iIBRf+wO7/AcfANh976gadjK8TRRHuhyIbGyhI3ZU0DJcdkcEznNqDua1EXQ3xe0BHtFjlAnortE7oTNg12IVeWVFyLGwJu0FYaDPr0uxzwJgqMZaYEnK1jqpPX7Imbz7MW0JUg1NOZ9mEZ+XY6o4IVVCI3gQtJmygnv6ZrL2PutgFWsaeh1IqVrLoz3wRhKgtYTwfblLCv9HlWamYZgO4mKHgO2VWhNPqINFuPkVnUHlXjRQOZgdA5eVruSfwvybEscgvn4gttgwuyH+OF6MStC9XZ0SPAcYI5HhTryiYGk6ynudXmhNKxYNWVMyGFYpUEetR609Jlir/Ex7pyuCjBlSjD+/TfOA3QUwloNsbddAlG/4qDzO0h+BQ3qlLtvw1tlP7nnSta18gLYRwJvHg2fhAcM/
 o/zBPrpu
 zxboefOwO3083A5B8Br08XxjJRxwFtOqRJ/QXn35gnUHKs+Vpmj8Ep4hOnk8WekxR3CzlPAbPeJPgj6sB3r2KBAxL+9iQqdpEL8YEcdO8nBPPN3f0Q64k6SzUxAtcm6v8RtVbLOzrN4xHwuO9UTLGFQaxbJ3NqMt8oYHHnPtvhBBmDFZ2EfWyENm2/WmuM3EnEDk3QMhjZtIwyJnjwHfh0tVptQi4GULjbAnZ9IaW5qbW7ZLg8pzfTYpbRGrs1NpDs3LUYJafnrbwYMhpR1/yTH8JqZbQWSXwj0R6akVLaxzUTBO5AA+x3R1+hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 09:02:16PM +0800, hu.shengming@zte.com.cn wrote:
> > > diff --git a/mm/slub.c b/mm/slub.c
> > > index fb2c5c57bc4e..88537e577989 100644
> > > --- a/mm/slub.c
> > > +++ b/mm/slub.c
> > > +#ifdef CONFIG_SLAB_FREELIST_RANDOM
> > > +    iter->random = (slab->objects >= 2 && s->random_seq);
> > > +    if (!iter->random)
> > > +        return;
> > > +
> > > +    iter->freelist_count = oo_objects(s->oo);
> > > +    iter->page_limit = slab->objects * s->size;
> > > +
> > > +    if (allow_spin) {
> > > +        iter->pos = get_random_u32_below(iter->freelist_count);
> > > +    } else {
> > > +        struct rnd_state *state;
> > > +
> > > +        /*
> > > +         * An interrupt or NMI handler might interrupt and change
> > > +         * the state in the middle, but that's safe.
> > > +         */
> > > +        state = &get_cpu_var(slab_rnd_state);
> > > +        iter->pos = prandom_u32_state(state) % iter->freelist_count;
> > > +        put_cpu_var(slab_rnd_state);
> > > +    }
> > > +#endif
> > > +}
> > >  static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
> > >          void **p, unsigned int count, bool allow_spin)
> > 
> > There is one problem with this change; ___slab_alloc() builds the
> > freelist before calling alloc_from_new_slab(), while refill_objects()
> > does not. For consistency, let's allocate a new slab without building
> > freelist in ___slab_alloc() and build the freelist in
> > alloc_single_from_new_slab() and alloc_from_new_slab()?
> > 
> 
> Agreed, also, new_slab() is currently used by both early_kmem_cache_node_alloc()
> and ___slab_alloc(), so I'll rework the early allocation path as well to
> keep the new-slab flow consistent.

Sounds fine to me.

> > > -        slab->inuse++;
> > >          allocated++;
> > >      }
> > > -    slab->freelist = object;
> > > +    slab->inuse = target_inuse;
> > >  
> > >      if (needs_add_partial) {
> > > -
> > > +        build_slab_freelist(s, slab, &iter);
> > 
> > When allow_spin is true, it's building the freelist while holding the
> > spinlock, and that's not great.
> > 
> > Hmm, can we do better?
> > 
> > Perhaps just allocate object(s) from the slab and build the freelist
> > with the objects left (if exists), but free the slab if allow_spin
> > is false AND trylock fails, and accept the fact that the slab may not be
> > fully free when it's freed due to trylock failure?
> > 
> > something like:
> > 
> > alloc_from_new_slab() {
> >     needs_add_partial = (slab->objects > count);
> >     target_inuse = needs_add_partial ? count : slab->objects;
> > 
> >     init_slab_obj_iter(s, slab, &iter, allow_spin);
> >     while (allocated < target_inuse) {
> >         p[allocated] = next_slab_obj(s, &iter);
> >         allocated++;
> >     }
> >     slab->inuse = target_inuse;
> > 
> >     if (needs_add_partial) {
> >         build_slab_freelist(s, slab, &iter);
> >         n = get_node(s, slab_nid(slab))
> >         if (allow_spin) {
> >             spin_lock_irqsave(&n->list_lock, flags);
> >         } else if (!spin_trylock_irqsave(&n->list_lock, flags)) {
> >             /* 
> >              * Unlucky, discard newly allocated slab.
> >              * The slab is not fully free, but it's fine as
> >              * objects are not allocated to users.
> >              */
> >             free_new_slab_nolock(s, slab);
> >             return 0;
> >         }
> >         add_partial(n, slab, ADD_TO_HEAD);
> >         spin_unlock_irqrestore(&n->list_lock, flags);
> >     }
> >     [...]
> > }
> > 
> > And do something similar in alloc_single_from_new_slab() as well.
> > 
> 
> Good point. I'll restructure the path so objects are emitted first, the leftover
> freelist is built only if needed, and the slab is added to partial afterwards. For
> the !allow_spin trylock failure case, I'll discard the new slab and return 0. I'll
> do the same for the single-object path as well.

Thanks. Please keep in mind that you need to enable SLUB_TINY or slab_debug
to test the alloc_single_from_new_slab() path.

> > >          if (allow_spin) {
> > >              n = get_node(s, slab_nid(slab));
> > >              spin_lock_irqsave(&n->list_lock, flags);
> > > @@ -7244,16 +7265,15 @@ refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
> > >  
> > >  new_slab:
> > >  
> > > -    slab = new_slab(s, gfp, local_node);
> > > +    slab_gfp = prepare_slab_alloc_flags(s, gfp);
> > 
> > Could we do `flags = prepare_slab_alloc_flags(s, flags);`
> > within allocate_slab()? Having gfp and slab_gfp flags is distractive.
> > The value of allow_spin should not change after
> > prepare_slab_alloc_flags() anyway.
> > 
> 
> Agreed. I'll move the prepare_slab_alloc_flags() handling into allocate_slab()
> so the call sites stay simpler, and keep the iterator/freelist construction
> local to alloc_single_from_new_slab() and alloc_from_new_slab().

Thanks.

> I also have a question about the allow_spin semantics in the refill_objects path.
> 
> Now that init_slab_obj_iter() has been moved into alloc_from_new_slab(..., true),
> allow_spin on this path appears to be unconditionally set to true.
> 
> Previously, shuffle_freelist() received allow_spin = gfpflags_allow_spinning(gfp),
> so I wanted to check whether moving init_slab_obj_iter() into alloc_from_new_slab()
> changes the intended semantics here.
> 
> My current understanding is that this is still fine, because refill_objects()
> is guaranteed to run only when spinning is allowed. Is that correct?

That's correct and it's fine.

> > > +    allow_spin = gfpflags_allow_spinning(slab_gfp);
> > > +
> > > +    slab = allocate_slab(s, slab_gfp, local_node, allow_spin);
> > >      if (!slab)
> > >          goto out;
> > >  
> > >      stat(s, ALLOC_SLAB);
> > >  
> > > -    /*
> > > -     * TODO: possible optimization - if we know we will consume the whole
> > > -     * slab we might skip creating the freelist?
> > > -     */
> > >      refilled += alloc_from_new_slab(s, slab, p + refilled, max - refilled,
> > >                      /* allow_spin = */ true);
> > >  
> > > -- 
> > > 2.25.1
> > 
> > -- 
> > Cheers,
> > Harry / Hyeonggon
> 
> Thanks again. I will fold these changes into the next revision.

Thanks!

> --
> With Best Regards,
> Shengming

-- 
Cheers,
Harry / Hyeonggon

