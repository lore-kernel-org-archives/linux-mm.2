Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C014FCC6B03
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 07:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C1AE6B008C; Thu,  2 Apr 2026 03:03:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0722E6B0093; Thu,  2 Apr 2026 03:03:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC9F86B0095; Thu,  2 Apr 2026 03:03:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC64F6B008C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:03:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B083AE0DA8
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:03:25 +0000 (UTC)
X-FDA: 84612724770.10.0705F68
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf07.hostedemail.com (Postfix) with ESMTP id B2CDE4000B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:03:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf07.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775113403; a=rsa-sha256;
	cv=none;
	b=ISE49wIqYlMPjfpD1ajo2P3EnWIu4jRmR5KgPsTUWmyxo+a34HV4QUGbPOwl95VFJcpe+W
	q/zWywnzGgQN60sxUxJRv8b9DY1ke4WV2ur58+kBsWPzypNiu7i9qUEeONlLWyTBnWxRNX
	Tahorde6lBZ2rn5xDDejC70YmqdNr7Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf07.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775113403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Yr7Ro4gX/ITASP/38nLFFt1P6yha04NKWSuroKoejg=;
	b=qXCxmf+UwDKmoURVDi5gWde5dHiVn/Qo+i44/LjasUXxlD9AKejpOcRRFIf1p+B+X6SpzU
	hrU+1qLNzb20x6xS/WRq4BPHaRrKXO2X78ZR4+ucOuf9NdnOXtfUc68D0srCd6KHJw5aVW
	g8nkXlbRwQnfYM/xTXdm7JkiK/ERwgU=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4fmXr571xwz7Qxrt;
	Thu, 02 Apr 2026 15:03:17 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 632738Qo095033;
	Thu, 2 Apr 2026 15:03:09 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 2 Apr 2026 15:03:10 +0800 (CST)
X-Zmail-TransId: 2afb69ce14aeffb-82ee3
X-Mailer: Zmail v1.0
Message-ID: <20260402150310775aOAcX92pJLmjcUIRoWFER@zte.com.cn>
In-Reply-To: <ac32ZQMxSSZ2VsNY@hyeyoo>
References: 202604011257259669oAdDsdnKx6twdafNZsF5@zte.com.cn,fz2shejnypqsu74zpoy66senjbpyl2bbvcnoxu6hvfs77c7jtr@o2acnd2hzd4x,ac32ZQMxSSZ2VsNY@hyeyoo
Date: Thu, 2 Apr 2026 15:03:10 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <harry@kernel.org>
Cc: <hao.li@linux.dev>, <vbabka@kernel.org>, <akpm@linux-foundation.org>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <xu.xin16@zte.com.cn>,
        <yang.tao172@zte.com.cn>, <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2Ml0gbW0vc2x1Yjogc2tpcCBmcmVlbGlzdCBjb25zdHJ1Y3Rpb24gZm9yIHdob2xlLXNsYWIgYnVsayByZWZpbGw=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 632738Qo095033
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Thu, 02 Apr 2026 15:03:18 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69CE14B5.000/4fmXr571xwz7Qxrt
X-Rspamd-Queue-Id: B2CDE4000B
X-Stat-Signature: yursdhharpazq6cwhm45szz8s9eexkzy
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775113401-936504
X-HE-Meta: U2FsdGVkX19o1T0Inlg74jON+TI9peva0ryA9O8ey0OoxTwud79t2fKW2Q7SHMJsqJR8y+YauH1W2xIf8c9VelHYf7iCA3d02Zra2RIJFkFziIvKmYC/rr/ZPON0VY0P3RMAsMWhXqV0XWmMu4DHKvkrPC5LBzlGsoEXV3zTjOPVXIgHn33AKyw5bL4FXLqpl224desqhta3rr/C7YAYbt6+4Jgl0CbUd0yQPQtG+7Rx7Yi6pletS2Xcqm3Txg8r7j5D2FF+un8UHeeiDr1ZJ5YdnE8H/oqVrYXOZeCcXbayhG5cIABh7WG3YFDMeS4CjF7gg2Ws3Ic51gtsQ5/PLLLoZlJmDyl4ZM+mSeQME/gc24mf/asroEO6J/RfNmwwIN+iGHD22ULXuMcDXtjJoVLiDMLLhIRXS3ulPtQQmesUtyLt/OybvaNiHeAH8Vo33hFz9UariT4gN6pVYJvP5FrZMLHtte9FeSmgImuiKDhgtpkgdEk+ZzdNZGkfU4pOvHKL6lWyMUTnOoXPwaTcrHAXVkCuenbqqXGSD11gis3i8X6iSQMeJ34lUUPZAu3KIRdDuVDUcLgGhRT+1xMVtbOXePIW1VXjn6a/E5Oj2/lV6Okn8d/LWQ/n1zKnl88HUs3IiiDv7oBlC1pcvKlrZWcxD/cjFjWpYP4hvTfXl5+n8S0oZeC1p+c/wiDFCsxAymxcUNVCdM8u1XEJGSR5Buh4UtaM7nhL2AkLgiSGryTRMf4u12G2f38O5SoYL/Qof9iRH9+xjGVuTIOLOJYOq1JQlz8+fBlxicLPh2z6LnymNx4byYd1sHac7c9atV1FGZyVsQgUkUHCtdOLU+qZtG6BjVXj3smjyl8GfhwG2PGrUVYwLIQb7tGGRdzDDV9DxOwU/9dGsd5XJkPvrAGzbIGfJtZU5J+svTbaA3kVgUpbR3ehQDA1F3C4XN2JsI0oyIhxgNxmYl7uvt1qvIW
 CwEXGHgn
 AyXFfVgpa0d53CheBIOh218i0kgAnd+Jpn/nSD0RP0A8aJOYBivFgi2tSvrJZxgBE9m5hSeRPF//9fI1KY6FxJhZyAUbVyuUYTi7Blid5aMuWnKST6R+uNHEyJDimKmQNGXfb72s2Ga0LfUzRfX5igeoiO/Sjh4ZflU+WXnzjAKox9xFPyvZgraBWWIg2+DeowX5XXerB6v8pKnD6XOuNhUyRaUSFBHOyxHaT8gxOmQCTAAiA8rw9Vder39M2FsWy1nQsn+OLf3U2CbJOenmVsI+q0iEEj7q+TV3K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry wrote:
> On Wed, Apr 01, 2026 at 02:55:23PM +0800, Hao Li wrote:
> > On Wed, Apr 01, 2026 at 12:57:25PM +0800, hu.shengming@zte.com.cn wrote:
> > > @@ -4395,6 +4458,48 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
> > >      return allocated;
> > >  }
> > >  
> > > +static unsigned int alloc_whole_from_new_slab(struct kmem_cache *s,
> > > +        struct slab *slab, void **p, bool allow_spin)
> > > +{
> > > +
> > > +    unsigned int allocated = 0;
> > > +    void *object, *start;
> > > +
> > > +    if (alloc_whole_from_new_slab_random(s, slab, p, allow_spin,
> > > +                         &allocated)) {
> > > +        goto done;
> > > +    }
> > > +
> > > +    start = fixup_red_left(s, slab_address(slab));
> > > +    object = setup_object(s, start);
> > > +
> > > +    while (allocated < slab->objects - 1) {
> > > +        p[allocated] = object;
> > > +        maybe_wipe_obj_freeptr(s, object);
> > > +
> > > +        allocated++;
> > > +        object += s->size;
> > > +        object = setup_object(s, object);
> > > +    }
> > 
> > Also, I feel the current patch contains some duplicated code like this loop.
> > 
> > Would it make sense to split allocate_slab() into two functions?
> > 
> > For example,
> > the first part could be called allocate_slab_meta_setup() (just an example name)
> > And, the second part could be allocate_slab_objects_setup(), with the core logic
> > being the loop over objects. Then allocate_slab_objects_setup() could support
> > two modes: one called BUILD_FREELIST, which builds the freelist, and another
> > called EMIT_OBJECTS, which skips building the freelist and directly places the
> > objects into the target array.> 

> Something similar but a little bit more thoughts to unify the code
> (**regardless of CONFIG_SLAB_FREELIST_RANDOM**) and avoid treating
> "the whole slab->freelist fits into the sheaf" as a special case:> 

> - allocate_slab() no longer builds the freelist.
>   the freelist is built only when there are objects left after
>   allocating objects from the new slab.> 

> - new_slab() allocates a new slab AND builds the freelist
>   to keep existing behaviour.> 

> - refill_objects() allocates a slab using allocate_slab(),
>   and passes it to alloc_from_new_slab().> 

>   alloc_from_new_slab() consumes some objects in random order,
>   and then build the freelist with the objects left (if exists).> 

> We could actually abstract "iterating free objects in random order"
> into an API, and there would be two users of the API:
> - Building freelist
> - Filling objects into the sheaf (without building freelist!)> 

> Something like this...
> (names here are just examples, I'm not good at naming things!)> 

> struct freelist_iter {
>     int pos;
>     int freelist_count;
>     int page_limit;
>     void *start;
> };> 

> /* note: handling !allow_spin nicely is tricky :-) */
> alloc_from_new_slab(...) {
>     struct freelist_iter fit;> 

>     prep_freelist_iter(s, slab, &fit, allow_spin);
>     while (slab->inuse < min(count, slab->objects)) {
>         p[slab->inuse++] = next_freelist_entry(s, &fit);
>     }> 

>     if (slab->inuse < slab->objects)
>         build_freelist(s, slab, &fit);
> }> 

> build_freelist(s, slab, fit) {
>     size = slab->objects - slab->inuse;> 

>     cur = next_freelist_entry(s, fit);
>     cur = setup_object(s, cur);
>     slab->freelist = cur;
>     for (i = 1; i < size; i++) {
>         next = next_freelist_entry(s, fit);
>         next = setup_object(s, next);
>         set_freepointer(s, cur, next);
>         cur = next;
>     }
> }> 

> #ifdef CONFIG_SLAB_FREELIST_RANDOM
> prep_freelist_iter(s, slab, fit, allow_spin) {
>     fit->freelist_count = oo_objects(s->oo);
>     fit->page_limit = slab->objects * s->size;
>     fit->start = fixup_red_left(s, slab_address(slab));> 

>     if (slab->objects < 2 || !s->random_seq) {
>         fit->pos = 0;
>     } else if (allow_spin) {
>         fit->pos = get_random_u32_below(freelist_count);
>     } else {
>         struct rnd_state *state;> 

>                 /*                                                              
>                  * An interrupt or NMI handler might interrupt and change       
>                  * the state in the middle, but that's safe.                        
>                  */                                                             
>                 state = &get_cpu_var(slab_rnd_state);                           
>                 fit->pos = prandom_u32_state(state) % freelist_count;                
>                 put_cpu_var(slab_rnd_state);    
>     }> 

>     return;
> }
> next_freelist_entry(s, fit) {
>     /*
>          * If the target page allocation failed, the number of objects on the
>          * page might be smaller than the usual size defined by the cache.
>          */
>         do {
>                 idx = s->random_seq[fit->pos];
>                 fit->pos += 1;
>                 if (fit->pos >= freelist_count)
>                         fit->pos = 0;
>         } while (unlikely(idx >= page_limit));> 

>     return (char *)start + idx;
> }
> #else
> prep_freelist_iter(s, slab, fit, allow_spin) {
>     fit->pos = 0;
>     return;
> }
> next_freelist_entry(s, fit) {
>     void *next = fit->start + fit->pos * s->size;> 

>     fit->pos++;
>     return next;
> }
> #endif> 

Hi Harry,

Thanks a lot for the detailed suggestion. This is a very good direction for
restructuring refill_objects().

I agree that abstracting the free-object iteration and making the flow uniform
regardless of CONFIG_SLAB_FREELIST_RANDOM is a cleaner approach than keeping
the “whole slab fits into the sheaf” case as a special path. Your idea of letting
alloc_from_new_slab() consume objects first and only build the freelist for the
remainder makes a lot of sense, and should also help reduce the duplicated
object-setup logic.

I’ll rework the patch along these lines, incorporating your and Hao suggestions,
and send a v3.

Thanks again for the thoughtful review.

--
With Best Regards,
Shengming

> -- 
> Cheers,
> Harry / Hyeonggon

