Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5F05CC6B25
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 08:12:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AEC16B0088; Thu,  2 Apr 2026 04:12:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25FA36B0089; Thu,  2 Apr 2026 04:12:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 175316B008A; Thu,  2 Apr 2026 04:12:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 032086B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:12:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A58AC1B8251
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 08:12:27 +0000 (UTC)
X-FDA: 84612898734.08.15EFB11
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0EF294000A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 08:12:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HnNQngf6;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775117546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nKcyiSG08gecqgvhLkZQuNPWM+H193B2280f+FdL/D8=;
	b=P4MTfmJQhyJlQTCEgxfAmY5d9yXydg2lNnCvTWBp81tisKERpB6pvWweXR1ylK9kMKbUzV
	6mTQcTaZDYPBDNT7yRphh0yzx4Ik0uWqCKD+StNn0cy/ScP7MWaDxYpA8tc7jqko+H+E9B
	qZDsIdaJA781TYBr736+w/lfj+bCnM4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HnNQngf6;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775117546; a=rsa-sha256;
	cv=none;
	b=HlBs2QHZxIjuqq8qvR2VyxzAcvYM7VgnPDGEyyWYS1iBR+P864PqYyD9Oe48N8Sjx+dUmc
	Vhwz0AEMRBNk6ZWVUuQ82i3jpcXGpQkck9WkQva5sNIgMLlrNbd3UcAN9ZZJ26nDL6eeVg
	vd8gpwOwb2eNBdnRBT3vv0rLZFMGAr4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FC4161868;
	Thu,  2 Apr 2026 08:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6AC4C19423;
	Thu,  2 Apr 2026 08:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775117545;
	bh=VknL4AdnzR6qUdsQ+NMK8f67UeiWg2riW9Xmd1I55kE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HnNQngf65p7BFj5Je9j9WIg1+9SUvfVml2dJrslWSAiAFiYYBqJ7DIKZnl72vVfbu
	 XWFhtwucvVl6BmhrPAbcBozAMnW7IaScP9cLGy6dHKuhmRiL2j8KhDSsuFhlXHpK4x
	 lUz1yy+Dv6ZqQ2G7z+HgrD2sxKqo3iZgqMuoz1iLQtX2xdPMzrJN4QTAmEHdLNv393
	 /bR07gDBrkolJJ/5Q/HaYUbZ2GiPAm7rGGLkziM5vZSt09vGqWi0sO5DSjUOke+jUm
	 MiiXTm8JCxWAjItA2KcOZsKvwEMlqZNkmBB091rHODyPik+00dlRriVuCJNI5hBn1I
	 Gqh6eTZ08AuNA==
Date: Thu, 2 Apr 2026 17:12:23 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: hu.shengming@zte.com.cn
Cc: hao.li@linux.dev, vbabka@kernel.org, akpm@linux-foundation.org,
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	zhang.run@zte.com.cn, xu.xin16@zte.com.cn, yang.tao172@zte.com.cn,
	yang.yang29@zte.com.cn
Subject: Re: [PATCH v2] mm/slub: skip freelist construction for whole-slab
 bulk refill
Message-ID: <ac4k5yhq3zok6m1u@hyeyoo>
References: <ac32ZQMxSSZ2VsNY@hyeyoo>
 <20260402150310775aOAcX92pJLmjcUIRoWFER@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260402150310775aOAcX92pJLmjcUIRoWFER@zte.com.cn>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0EF294000A
X-Stat-Signature: zsogu5aw5py6ru5h6e3wja4ouhqw58c7
X-Rspam-User: 
X-HE-Tag: 1775117545-559766
X-HE-Meta: U2FsdGVkX19HGLxhwzTui4yw1ggxqGtpZXos+Bp2c6kdzIcO3RMpq2nhl8nZPu3zlN0pyfWD2svmz70ycNejjzWjYl1G6ozM5uTvrFIXP0FG2ev1PyI1xs4r1qbQeJaxgp+CKF+KSe6kkx8XejO4iMh/iobUGTdBp7bix5mb1RIlkLBsF04nnw8qMjHl2kX6iIB4RpLrcwELrcw4gZsIeBAZNAqq8NH8ky+7pbDLgDkvCCrtI3nfY/dCnjOqQtjx3IbjdsKShw1FhTlbvg9CsB7sMvVZhW+IEVhg2XTOkDUVi5JZVLpXM71JQqdZioB1ST90pZGo36X7W57JeWCouV7Urvb5MkhwVq6aDy8MIJgCPv3Iu6XeJcfdxVZqxXMiH1NM9LGaf/o+mmqNjLGHvh5LYQuf5zyCcAjLZWXaZwUdmfAiXLbfO1HSuuWd+VV0FEA6Nj539/EGeSeWlkYdjioUYKXpesNLwR0+mGhPMsbcBeKVsDb7qTQsMFVFzqaej4i31/HlS/+7y3GLH/C3oy4sUMCYc6dj0EiAunNrySSD00lCgKQn7YqzWi3/kkp85jdlSFASyK3b1rWRM5+5k/xlhGLvI7OiwCO3ADb+H2L0/0jyMQQ5eFbWy0+N+Y0rVH3gT6Lpgeb5B1tX9pRhUK+ZL4qDhmxQcHNq96dQ5vEOiMJCGstYJyEWkkzsjs7N+TxAs2tHBAEvuXWHq/tF+yBjr7+kCPbbVXL7E8ZQ1wWyYKt+BVtUvGdK2pg2GpZT+dsQxKWadvjmVnCBkXUWupn7f3roiX8CRAyEyg7XI6UPM1h3apaqspateR4VTWGiOQcID6zBz/aZEeXFku0clMYKWXCQojAOiVVjnXwF78xfSDANb6HoiditsRZIu+I9Sp0488LPXYlv7TkvRd1EOocq+kveJ9/3VIiqdI6/J7dS2jnp31ZYGMC/IvIl/0BY7Oj/52NYZ7KbCc5UHXU
 DtV96kJz
 gYm7wcO8EcpVfy5zZ8FbiTdmS25BqpcsXCCL0ScmkmEnkyTNxHSS9ItK2Q3hIWu8++aei/MhfOZCc3J6kVBWrpurQykBLFnjdbVeTdglqXbFtyHsjeud6kEg+e1dIOhxQz0yIUEedh42SVUYh2+mW47rAKiBE7q6rIu3HVhzj+ktywgpBbHknuDnO9L2jMDvxIMI4Y+2ToppO21Ke+o4nPSUGVjzlvo+PxknAsFOZiV/yQam7bOfS3ACJM86I62ne6MZwEDcXY+0HwxyyVXK5eAX7WKf1vutpmODd8SbXYpC6zt9c2ZLoQ8yP704bPwZXicpgCVtZX9aguK0OI01mfV/uog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 03:03:10PM +0800, hu.shengming@zte.com.cn wrote:
> Harry wrote:
> > On Wed, Apr 01, 2026 at 02:55:23PM +0800, Hao Li wrote:
> > > On Wed, Apr 01, 2026 at 12:57:25PM +0800, hu.shengming@zte.com.cn wrote:
> > > > @@ -4395,6 +4458,48 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
> > > >      return allocated;
> > > >  }
> > > > +static unsigned int alloc_whole_from_new_slab(struct kmem_cache *s,
> > > > +        struct slab *slab, void **p, bool allow_spin)
> > > > +{
> > > > +
> > > > +    unsigned int allocated = 0;
> > > > +    void *object, *start;
> > > > +
> > > > +    if (alloc_whole_from_new_slab_random(s, slab, p, allow_spin,
> > > > +                         &allocated)) {
> > > > +        goto done;
> > > > +    }
> > > > +
> > > > +    start = fixup_red_left(s, slab_address(slab));
> > > > +    object = setup_object(s, start);
> > > > +
> > > > +    while (allocated < slab->objects - 1) {
> > > > +        p[allocated] = object;
> > > > +        maybe_wipe_obj_freeptr(s, object);
> > > > +
> > > > +        allocated++;
> > > > +        object += s->size;
> > > > +        object = setup_object(s, object);
> > > > +    }
> > > 
> > > Also, I feel the current patch contains some duplicated code like this loop.
> > > 
> > > Would it make sense to split allocate_slab() into two functions?
> > > 
> > > For example,
> > > the first part could be called allocate_slab_meta_setup() (just an example name)
> > > And, the second part could be allocate_slab_objects_setup(), with the core logic
> > > being the loop over objects. Then allocate_slab_objects_setup() could support
> > > two modes: one called BUILD_FREELIST, which builds the freelist, and another
> > > called EMIT_OBJECTS, which skips building the freelist and directly places the
> > > objects into the target array.> 
> 
> > Something similar but a little bit more thoughts to unify the code
> > (**regardless of CONFIG_SLAB_FREELIST_RANDOM**) and avoid treating
> > "the whole slab->freelist fits into the sheaf" as a special case:> 
> 
> > - allocate_slab() no longer builds the freelist.
> >   the freelist is built only when there are objects left after
> >   allocating objects from the new slab.> 
> 
> > - new_slab() allocates a new slab AND builds the freelist
> >   to keep existing behaviour.> 
> 
> > - refill_objects() allocates a slab using allocate_slab(),
> >   and passes it to alloc_from_new_slab().> 
> 
> >   alloc_from_new_slab() consumes some objects in random order,
> >   and then build the freelist with the objects left (if exists).> 
> 
> > We could actually abstract "iterating free objects in random order"
> > into an API, and there would be two users of the API:
> > - Building freelist
> > - Filling objects into the sheaf (without building freelist!)> 
> 
> > Something like this...
> > (names here are just examples, I'm not good at naming things!)> 
> 
> > struct freelist_iter {
> >     int pos;
> >     int freelist_count;
> >     int page_limit;
> >     void *start;
> > };> 
> 
> > /* note: handling !allow_spin nicely is tricky :-) */
> > alloc_from_new_slab(...) {
> >     struct freelist_iter fit;> 
> 
> >     prep_freelist_iter(s, slab, &fit, allow_spin);
> >     while (slab->inuse < min(count, slab->objects)) {
> >         p[slab->inuse++] = next_freelist_entry(s, &fit);
> >     }> 
> 
> >     if (slab->inuse < slab->objects)
> >         build_freelist(s, slab, &fit);
> > }> 
> 
> > build_freelist(s, slab, fit) {
> >     size = slab->objects - slab->inuse;> 
> 
> >     cur = next_freelist_entry(s, fit);
> >     cur = setup_object(s, cur);
> >     slab->freelist = cur;
> >     for (i = 1; i < size; i++) {
> >         next = next_freelist_entry(s, fit);
> >         next = setup_object(s, next);
> >         set_freepointer(s, cur, next);
> >         cur = next;
> >     }
> > }> 
> 
> > #ifdef CONFIG_SLAB_FREELIST_RANDOM
> > prep_freelist_iter(s, slab, fit, allow_spin) {
> >     fit->freelist_count = oo_objects(s->oo);
> >     fit->page_limit = slab->objects * s->size;
> >     fit->start = fixup_red_left(s, slab_address(slab));> 
> 
> >     if (slab->objects < 2 || !s->random_seq) {
> >         fit->pos = 0;
> >     } else if (allow_spin) {
> >         fit->pos = get_random_u32_below(freelist_count);
> >     } else {
> >         struct rnd_state *state;> 
> 
> >                 /*                                                              
> >                  * An interrupt or NMI handler might interrupt and change       
> >                  * the state in the middle, but that's safe.                        
> >                  */                                                             
> >                 state = &get_cpu_var(slab_rnd_state);                           
> >                 fit->pos = prandom_u32_state(state) % freelist_count;                
> >                 put_cpu_var(slab_rnd_state);    
> >     }> 
> 
> >     return;
> > }
> > next_freelist_entry(s, fit) {
> >     /*
> >          * If the target page allocation failed, the number of objects on the
> >          * page might be smaller than the usual size defined by the cache.
> >          */
> >         do {
> >                 idx = s->random_seq[fit->pos];
> >                 fit->pos += 1;
> >                 if (fit->pos >= freelist_count)
> >                         fit->pos = 0;
> >         } while (unlikely(idx >= page_limit));> 
> 
> >     return (char *)start + idx;
> > }
> > #else
> > prep_freelist_iter(s, slab, fit, allow_spin) {
> >     fit->pos = 0;
> >     return;
> > }
> > next_freelist_entry(s, fit) {
> >     void *next = fit->start + fit->pos * s->size;> 
> 
> >     fit->pos++;
> >     return next;
> > }
> > #endif> 
> 
> Hi Harry,
> 
> Thanks a lot for the detailed suggestion. This is a very good direction for
> restructuring refill_objects().
> 
> I agree that abstracting the free-object iteration and making the flow uniform
> regardless of CONFIG_SLAB_FREELIST_RANDOM is a cleaner approach than keeping
> the “whole slab fits into the sheaf” case as a special path.
>
> Your idea of letting alloc_from_new_slab() consume objects first and only
> build the freelist for the remainder makes a lot of sense,

I believe Hao is working on trying to allow consuming all objects (from new
and partial slabs) to fill sheaves when possible, but it'd still be nice to
do this as long as it keeps the implementation simple.

> and should also help reduce the duplicated object-setup logic.

Yeah, less code means less tokens, so better for the environm... oh wait,
April Fools day is over! (just joking).
 
> I’ll rework the patch along these lines, incorporating your and Hao suggestions,
> and send a v3.

Thanks for working on this.

> Thanks again for the thoughtful review.

No problem!

-- 
Cheers,
Harry / Hyeonggon

