Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2912CC6B35
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 09:01:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D57456B0088; Thu,  2 Apr 2026 05:01:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2ECE6B0089; Thu,  2 Apr 2026 05:01:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C44C26B008A; Thu,  2 Apr 2026 05:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B35926B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:01:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 54873C20CF
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:01:09 +0000 (UTC)
X-FDA: 84613021458.24.4270A26
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0F3EB12000E
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:01:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XMoeXPTV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775120467; a=rsa-sha256;
	cv=none;
	b=N8lvGrPgnAv1a7ylzcgYUTW1GlDkm3iTVBkSWh7YtkV8QyAPnGF+bbhkeeh7ItRL1hTOEe
	t1FmSUHJp+6gNYKfGuPYwc4fwS5Xlr/4WUYXVDdf776VDOen+zvqx3nrnuvDCN6LQ6SB+e
	2l6P3cC+nzzdrtkBJqQRpuRmmSzckZk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XMoeXPTV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775120467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OdtWjXiRlBkB7nKEXP3cSbCZsVWVuOVA4JJ6xkb7YsQ=;
	b=nDcbXmVcuI2QYG7G8qRMC5gWKH/nG1g914YcnBSeQ4LNejNMGLa6fhHCEpln/ltllmEI2t
	XPohHN+AbWarEDWvGc3TpOJ99IynMrPMW9NLe6d0aFXZw+Rm8fNZh/MxW9j7Xy+DYAHmSf
	Txji5btn3ElRNIhNirt0AU4T8bA1nTI=
Date: Thu, 2 Apr 2026 17:00:26 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775120454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OdtWjXiRlBkB7nKEXP3cSbCZsVWVuOVA4JJ6xkb7YsQ=;
	b=XMoeXPTVwcCUTNEk8ka56+erJ+NWJW1vsTU3fdi67noxzwABtyFIDq8EVK0znbC+w/yuIC
	rfZNPnUf2o/fzZ5GqMmaCxMspG9XUQjQsFht4MdwQFHP6TrWRdze7nxVmbJ8fhWsnJJHTc
	tD/mWKGwAqeiaDfBgeA7hQY4eAQkxzg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: hu.shengming@zte.com.cn, vbabka@kernel.org, akpm@linux-foundation.org, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhang.run@zte.com.cn, 
	xu.xin16@zte.com.cn, yang.tao172@zte.com.cn, yang.yang29@zte.com.cn
Subject: Re: [PATCH v2] mm/slub: skip freelist construction for whole-slab
 bulk refill
Message-ID: <k2cytuzrmrtzxd36faxp2apfpzrctzuthaifhifitilbddsczu@lfv4hvsien6d>
References: <ac32ZQMxSSZ2VsNY@hyeyoo>
 <20260402150310775aOAcX92pJLmjcUIRoWFER@zte.com.cn>
 <ac4k5yhq3zok6m1u@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac4k5yhq3zok6m1u@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: a5j4pe1dmbp11buiii6zghbiyh9yihj6
X-Rspamd-Queue-Id: 0F3EB12000E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775120466-985503
X-HE-Meta: U2FsdGVkX18hXTpkH85oSXfcpEgtYllp3xovCgDqkT7Ov4i1/Hku3aCP1KEDSa+aJNfVsj1X2RcHu1HKc1tJZDEw7ErOYzERrar27nv9yv+DmMAJxeenVU9AUcMjaXzVC5z5EugM6abXR+O1tyyPEt3inMltZHS7AYxlueUfAHRBRVk1EjbcJnq5/O+NMS8hRR/AhxEXIAIZhGTsVKwg3qUY/Ov3Hbmy5LHsxqFDF7J7ykJ+4nXI9F8qNp53RgDb6aht/yYPCL6tUCurLsl0VXzRvf8g9oT3/vZrnennJ1Xt827b0wi56MlWendSd3xfMymzje5WJrNv/SiiMq+y2oS6gZ+sp3Mdw/dJIX8QQxYKryGfUvgsXHuOcnp2l1lYGwdlZu6lKL/h/+dS8BMLFkHG2LGzHqdojcjljr1ALUnRUpK2CE6QYmc0cdRLoTJbJEn6EkUFiJqNNpqR9oMkznorv61Jh907izqeM3+icu7rWJ8NoWxsmtXLcMZtj0hXrKpgOjO0Pq332dm530IoyAllp987m6Pa0cOCQ5oC8GDVUrQdHFIS76to8LyUiKk5zQRocS/APz/sYL8WHao69Ei43U+wpJ6+gG9h1LolTpd0IbN0xZCamA+EWHZJXUMho0OkvnNcJd9DFVVNmaZweARPhtV9dTjrRGUWRL1Ryi6w6B6IMlVnmMI/WQv0VrbKLk2TcLTj7bMK2Qu5S3vEQ11BCDXExaAMsHFjTtxPFmo1t4OalTGtx/bKLYKMF4w2Ukt8KLXysojB45ABsokPhEf3Vc9MMbJsIXt7THI8nvZkXJ3UwPQ2tJ/NzRmt5ZiTduIpOC5XQnKBmwWlSaIRRiWYCG89aSebMNnd9Z53O7uqmU1p9cJQmihLSI3f+lYm6oHrIeGnT/QD24DByFVAc1g1PTdyrpp+13o2f3gdXg0p2C7OhTEMLGGDPn1v88/msagj9nqTqf33NqmGQ2x
 pplVmFtb
 na6zPCsUIJ+Bfax7euhwJhOfyyl6nvkdI5d4pK95f/cgyXKAfqsR201SCg8kqqOUE1KIDTFVFtWYx3wPRANpR25Rl7+w59pbh/OMjDrfvssXeViJ6ZGuZpJQaousWObfY2mrIHrkzVZAK+oVIym4+kBcywB3I5jpQJUPWfcTxZKnrW7sofVXX7VuxJ8oFxNtEasEykRgonhEdsYgX6QLGYhI4LPD15MPEMRT85Dp6DPt5QE5deAArsm6cTBbYZiJzJvNxP1Ps7wICCVaHI2oYJcrAaKQcGUGPS+WHLPpsLaLQf/8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 05:12:23PM +0900, Harry Yoo (Oracle) wrote:
> On Thu, Apr 02, 2026 at 03:03:10PM +0800, hu.shengming@zte.com.cn wrote:
> > Harry wrote:
> > > On Wed, Apr 01, 2026 at 02:55:23PM +0800, Hao Li wrote:
> > > > On Wed, Apr 01, 2026 at 12:57:25PM +0800, hu.shengming@zte.com.cn wrote:
> > > > > @@ -4395,6 +4458,48 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
> > > > >      return allocated;
> > > > >  }
> > > > > +static unsigned int alloc_whole_from_new_slab(struct kmem_cache *s,
> > > > > +        struct slab *slab, void **p, bool allow_spin)
> > > > > +{
> > > > > +
> > > > > +    unsigned int allocated = 0;
> > > > > +    void *object, *start;
> > > > > +
> > > > > +    if (alloc_whole_from_new_slab_random(s, slab, p, allow_spin,
> > > > > +                         &allocated)) {
> > > > > +        goto done;
> > > > > +    }
> > > > > +
> > > > > +    start = fixup_red_left(s, slab_address(slab));
> > > > > +    object = setup_object(s, start);
> > > > > +
> > > > > +    while (allocated < slab->objects - 1) {
> > > > > +        p[allocated] = object;
> > > > > +        maybe_wipe_obj_freeptr(s, object);
> > > > > +
> > > > > +        allocated++;
> > > > > +        object += s->size;
> > > > > +        object = setup_object(s, object);
> > > > > +    }
> > > > 
> > > > Also, I feel the current patch contains some duplicated code like this loop.
> > > > 
> > > > Would it make sense to split allocate_slab() into two functions?
> > > > 
> > > > For example,
> > > > the first part could be called allocate_slab_meta_setup() (just an example name)
> > > > And, the second part could be allocate_slab_objects_setup(), with the core logic
> > > > being the loop over objects. Then allocate_slab_objects_setup() could support
> > > > two modes: one called BUILD_FREELIST, which builds the freelist, and another
> > > > called EMIT_OBJECTS, which skips building the freelist and directly places the
> > > > objects into the target array.> 
> > 
> > > Something similar but a little bit more thoughts to unify the code
> > > (**regardless of CONFIG_SLAB_FREELIST_RANDOM**) and avoid treating
> > > "the whole slab->freelist fits into the sheaf" as a special case:> 
> > 
> > > - allocate_slab() no longer builds the freelist.
> > >   the freelist is built only when there are objects left after
> > >   allocating objects from the new slab.> 
> > 
> > > - new_slab() allocates a new slab AND builds the freelist
> > >   to keep existing behaviour.> 
> > 
> > > - refill_objects() allocates a slab using allocate_slab(),
> > >   and passes it to alloc_from_new_slab().> 
> > 
> > >   alloc_from_new_slab() consumes some objects in random order,
> > >   and then build the freelist with the objects left (if exists).> 
> > 
> > > We could actually abstract "iterating free objects in random order"
> > > into an API, and there would be two users of the API:
> > > - Building freelist
> > > - Filling objects into the sheaf (without building freelist!)> 
> > 
> > > Something like this...
> > > (names here are just examples, I'm not good at naming things!)> 
> > 
> > > struct freelist_iter {
> > >     int pos;
> > >     int freelist_count;
> > >     int page_limit;
> > >     void *start;
> > > };> 
> > 
> > > /* note: handling !allow_spin nicely is tricky :-) */
> > > alloc_from_new_slab(...) {
> > >     struct freelist_iter fit;> 
> > 
> > >     prep_freelist_iter(s, slab, &fit, allow_spin);
> > >     while (slab->inuse < min(count, slab->objects)) {
> > >         p[slab->inuse++] = next_freelist_entry(s, &fit);
> > >     }> 
> > 
> > >     if (slab->inuse < slab->objects)
> > >         build_freelist(s, slab, &fit);
> > > }> 
> > 
> > > build_freelist(s, slab, fit) {
> > >     size = slab->objects - slab->inuse;> 
> > 
> > >     cur = next_freelist_entry(s, fit);
> > >     cur = setup_object(s, cur);
> > >     slab->freelist = cur;
> > >     for (i = 1; i < size; i++) {
> > >         next = next_freelist_entry(s, fit);
> > >         next = setup_object(s, next);
> > >         set_freepointer(s, cur, next);
> > >         cur = next;
> > >     }
> > > }> 
> > 
> > > #ifdef CONFIG_SLAB_FREELIST_RANDOM
> > > prep_freelist_iter(s, slab, fit, allow_spin) {
> > >     fit->freelist_count = oo_objects(s->oo);
> > >     fit->page_limit = slab->objects * s->size;
> > >     fit->start = fixup_red_left(s, slab_address(slab));> 
> > 
> > >     if (slab->objects < 2 || !s->random_seq) {
> > >         fit->pos = 0;
> > >     } else if (allow_spin) {
> > >         fit->pos = get_random_u32_below(freelist_count);
> > >     } else {
> > >         struct rnd_state *state;> 
> > 
> > >                 /*                                                              
> > >                  * An interrupt or NMI handler might interrupt and change       
> > >                  * the state in the middle, but that's safe.                        
> > >                  */                                                             
> > >                 state = &get_cpu_var(slab_rnd_state);                           
> > >                 fit->pos = prandom_u32_state(state) % freelist_count;                
> > >                 put_cpu_var(slab_rnd_state);    
> > >     }> 
> > 
> > >     return;
> > > }
> > > next_freelist_entry(s, fit) {
> > >     /*
> > >          * If the target page allocation failed, the number of objects on the
> > >          * page might be smaller than the usual size defined by the cache.
> > >          */
> > >         do {
> > >                 idx = s->random_seq[fit->pos];
> > >                 fit->pos += 1;
> > >                 if (fit->pos >= freelist_count)
> > >                         fit->pos = 0;
> > >         } while (unlikely(idx >= page_limit));> 
> > 
> > >     return (char *)start + idx;
> > > }
> > > #else
> > > prep_freelist_iter(s, slab, fit, allow_spin) {
> > >     fit->pos = 0;
> > >     return;
> > > }
> > > next_freelist_entry(s, fit) {
> > >     void *next = fit->start + fit->pos * s->size;> 
> > 
> > >     fit->pos++;
> > >     return next;
> > > }
> > > #endif> 
> > 
> > Hi Harry,
> > 
> > Thanks a lot for the detailed suggestion. This is a very good direction for
> > restructuring refill_objects().
> > 
> > I agree that abstracting the free-object iteration and making the flow uniform
> > regardless of CONFIG_SLAB_FREELIST_RANDOM is a cleaner approach than keeping
> > the “whole slab fits into the sheaf” case as a special path.
> >
> > Your idea of letting alloc_from_new_slab() consume objects first and only
> > build the freelist for the remainder makes a lot of sense,
> 

Hi, Harry and Shengming

I just finished understanding the new detailed code skeleton, and I think the
idea looks really promising. It seems to unify the handling of shuffle and
non-shuffle cases, while also naturally covering scenarios where a new slab is
not fully consumed. It looks very nice. Let's see how v3 performs going
forward.

> I believe Hao is working on trying to allow consuming all objects (from new
> and partial slabs) to fill sheaves when possible,
>

Yeah, I've had some work going on in that area too, and I'm trying to keep it
from stepping on the changes in the current patch :)

> but it'd still be nice to
> do this as long as it keeps the implementation simple.

Yes, exactly.

> 
> > and should also help reduce the duplicated object-setup logic.
> 
> Yeah, less code means less tokens, so better for the environm... oh wait,
> April Fools day is over! (just joking).

Oh, I didn't even realize yesterday was April Fools' Day. I guess my clock must
be broken :P

>  
> > I’ll rework the patch along these lines, incorporating your and Hao suggestions,
> > and send a v3.
> 
> Thanks for working on this.
> 
> > Thanks again for the thoughtful review.
> 
> No problem!
> 
> -- 
> Cheers,
> Harry / Hyeonggon

-- 
Thanks,
Hao

