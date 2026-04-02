Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A0B1CC6B00
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 04:54:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A38976B0095; Thu,  2 Apr 2026 00:54:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9546B0096; Thu,  2 Apr 2026 00:54:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D7F46B0098; Thu,  2 Apr 2026 00:54:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 791526B0095
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:54:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B47DC1B65
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:54:02 +0000 (UTC)
X-FDA: 84612398724.13.33E3180
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9806B8000E
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:54:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N17R0CTx;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775105640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bY2LEXFR8aB7kVVt/sEmnOOU/O4u68AvqiQtSI8YUhE=;
	b=DUcjL3HtiTiPAszhIX0+yeaTg/3HqAeCFhNjJlOfxe20hsMk7MR5VIcd9LvBWfUZ/W2y+0
	Qvj9uAPccyJ2HCGss3sRINQc/iMGVZ+RmnTSNYuuT9OvUKkdHG948Hlm2z0xWUIsHLBsB0
	GdcGJj833O//LppRchMw+rBDsV4rSy0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N17R0CTx;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775105640; a=rsa-sha256;
	cv=none;
	b=kmtuSuWKR5esrhkERsa4WfwfrZZiztigu2KVrl9K81Mv0MpFZCfEC8yGcl1suYo8uyEum6
	ySKh2b80afRka0VoIyw3BupH1vtJv9QxIzrKPrsMyyqiI0wx9J095F0JvGDw6kjnu6+MMy
	wA9tgqOIqjGdrqXLIuqgHXj5YKjfjmY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F3C4F61855;
	Thu,  2 Apr 2026 04:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F0CC19423;
	Thu,  2 Apr 2026 04:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775105639;
	bh=eH21nATmfeN6FhaBpxnYW7O91zboBrBvU5TlcAbX+n8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N17R0CTxt8pY+BwFURQZTQyl8ZmvhdhI+h5D4iORXgypLYUWSyoycsFUUpjXO06iX
	 kAicocDlXmCN40AQ6sJhqmKvpPhxePcQ0wjrPxgZrIPYGuAMSEXaUTJicz6d7mZnx7
	 X8iPpp/9JEfPwfWWHmgT3Ow/A7uaH3G/gt4jfZYw9VaLLg51O3BkPQIAHbCbDwVtyC
	 3R2gpjFqy24U/fecDcSb8STaZIBfxlX2QonXnIwDo0NldRQ9b8DTJGkrpdAXfidTnt
	 zbxM0hkL4XC/2zRnEOia63xY8zJ3o9HMw3mHmolc62rX6aXMvLjJ5B3rtSbgRvjf6Z
	 9qp4zlO+/tDcg==
Date: Thu, 2 Apr 2026 13:53:57 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>
Cc: hu.shengming@zte.com.cn, vbabka@kernel.org, akpm@linux-foundation.org,
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	zhang.run@zte.com.cn, xu.xin16@zte.com.cn, yang.tao172@zte.com.cn,
	yang.yang29@zte.com.cn
Subject: Re: [PATCH v2] mm/slub: skip freelist construction for whole-slab
 bulk refill
Message-ID: <ac32ZQMxSSZ2VsNY@hyeyoo>
References: <202604011257259669oAdDsdnKx6twdafNZsF5@zte.com.cn>
 <fz2shejnypqsu74zpoy66senjbpyl2bbvcnoxu6hvfs77c7jtr@o2acnd2hzd4x>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fz2shejnypqsu74zpoy66senjbpyl2bbvcnoxu6hvfs77c7jtr@o2acnd2hzd4x>
X-Rspamd-Queue-Id: 9806B8000E
X-Stat-Signature: q64n9aiqfe97q1neqqob3iqizosdy6ew
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775105640-733495
X-HE-Meta: U2FsdGVkX184xmHPRRCR0mLxP9zjtQNvrZecFiDRxuhjkHxR+ONTbzBTzTt8vA1XdZmQ2Rsd/qB7/hUwsqmVIYhnMaGWFWwILNHrhYYw5eN2B9XlaOKP+pYyEx9TqPOyGWgamSAmdr20UMnbvzsBAlZc0XiRvw4FpBRtdNHludXHH3XCu7qwlUZKLyKw8T7O7EGwtwxuSOh661gll6x5yamHDyNJELFUze3AeRiSEjBjaxOtm8oQdbRODuAsOc2hvaMnICO3i6BvGBcD4auT9osMBbirQtjpm32aNow4904mflc2EFUR37O/x/uio/pSFwO397gUy3cqpGPd8Qp2xJosZAR79HidXh5RNtOiuRYRCnxXs3TuuaWME4Z/RSXuyQbwL2mOX5nlhGvbml6EkZd5Dalb/fLMWTONXaxXgElTxC1aIJE/OdbzAuMV3V9i5zvPn5FYY+olD1JiodvmFphsn7wQT1gLL73fLNpq0vMR8Avpi4nedrcv3ujw0tUKDgq1+s/QXo8WtA992i/m9atqqoAIe+WfdDzyfCqFSNDZSFdad7ebwZVK+C3MBWBhZUgazThn0TuLg8lBv4d//g/IBvb6doa2zJ/n5e2XoLNjPGXNSJMg19Z2Ey6bF4g0pousmI3A7bdiX1nSMQP16KlUfGFrtB4jvCNyUa6ED5dtLvZOMeqlY9905lwpIpooAxNhFkFBwhoT0L3dLYgFyUj5wi4i/3G19Nlm2zE7KkQfMqlJd+THKL5FhxE4mWYfSPTYM060a7cQy6Sso0Kjfh/vxewc05W+bwZImc0ej4RNsNhzjbxDdKXwdMDwieVVBgm5KfLvtCI9iRFQqbAxyCI89B8oyQJ0huGQPcO4nBb9Iz0JM2ORAYqEWZniKIReoMk4/SWr8iYlaIxNcCV/CFsq7UDeteiPsEaRwmtSjQNP+jRsRXMcdCpEz6Xz3M9M1DDJAbkgBtrSuWZf8KZ
 zIjExKQj
 279FnhgA8JATWTtmS44ax4A96pyltj9zKPoVQmO9F3sA2eIkDlDfX3j6UJCFdLQJsCX/eYoENwJgqjQr7zBC8aUGARFHJIzmB+Hon9ADCCPOmwNWl/rLeAVea0Ujv9KLhboufNLY0h1FxfBXT29fwUKWmczGU73NH3D6bW2MHR2j6AObTmjdA1kTG7ZUDTr6PbRtm2INQd0dhrHLkEwmKDZsgZ2ahfMQoZXMniUSZLmmlov3Y7p5ZAz8mJP+KEt9qmS+2SxVfLYGRWRzFb5gOqtC9nsXnQ47B6B0c8dGXDsFAZnqNhKZnUyNRNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 02:55:23PM +0800, Hao Li wrote:
> On Wed, Apr 01, 2026 at 12:57:25PM +0800, hu.shengming@zte.com.cn wrote:
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

Something similar but a little bit more thoughts to unify the code
(**regardless of CONFIG_SLAB_FREELIST_RANDOM**) and avoid treating
"the whole slab->freelist fits into the sheaf" as a special case:

- allocate_slab() no longer builds the freelist.
  the freelist is built only when there are objects left after
  allocating objects from the new slab.

- new_slab() allocates a new slab AND builds the freelist
  to keep existing behaviour.

- refill_objects() allocates a slab using allocate_slab(),
  and passes it to alloc_from_new_slab().

  alloc_from_new_slab() consumes some objects in random order,
  and then build the freelist with the objects left (if exists).

We could actually abstract "iterating free objects in random order"
into an API, and there would be two users of the API:
- Building freelist
- Filling objects into the sheaf (without building freelist!)

Something like this...
(names here are just examples, I'm not good at naming things!)

struct freelist_iter {
	int pos;
	int freelist_count;
	int page_limit;
	void *start;
};

/* note: handling !allow_spin nicely is tricky :-) */
alloc_from_new_slab(...) {
	struct freelist_iter fit;

	prep_freelist_iter(s, slab, &fit, allow_spin);
	while (slab->inuse < min(count, slab->objects)) {
		p[slab->inuse++] = next_freelist_entry(s, &fit);
	}

	if (slab->inuse < slab->objects)
		build_freelist(s, slab, &fit);
}

build_freelist(s, slab, fit) {
	size = slab->objects - slab->inuse;

	cur = next_freelist_entry(s, fit);
	cur = setup_object(s, cur);
	slab->freelist = cur;
	for (i = 1; i < size; i++) {
		next = next_freelist_entry(s, fit);
		next = setup_object(s, next);
		set_freepointer(s, cur, next);
		cur = next;
	}
}

#ifdef CONFIG_SLAB_FREELIST_RANDOM
prep_freelist_iter(s, slab, fit, allow_spin) {
	fit->freelist_count = oo_objects(s->oo);
	fit->page_limit = slab->objects * s->size;
	fit->start = fixup_red_left(s, slab_address(slab));

	if (slab->objects < 2 || !s->random_seq) {
		fit->pos = 0;
	} else if (allow_spin) {
		fit->pos = get_random_u32_below(freelist_count);
	} else {
		struct rnd_state *state;

                /*                                                              
                 * An interrupt or NMI handler might interrupt and change       
                 * the state in the middle, but that's safe.                        
                 */                                                             
                state = &get_cpu_var(slab_rnd_state);                           
                fit->pos = prandom_u32_state(state) % freelist_count;                
                put_cpu_var(slab_rnd_state);    
	}

	return;
}
next_freelist_entry(s, fit) {
	/*
         * If the target page allocation failed, the number of objects on the
         * page might be smaller than the usual size defined by the cache.
         */
        do {
                idx = s->random_seq[fit->pos];
                fit->pos += 1;
                if (fit->pos >= freelist_count)
                        fit->pos = 0;
        } while (unlikely(idx >= page_limit));

	return (char *)start + idx;
}
#else
prep_freelist_iter(s, slab, fit, allow_spin) {
	fit->pos = 0;
	return;
}
next_freelist_entry(s, fit) {
	void *next = fit->start + fit->pos * s->size;

	fit->pos++;
	return next;
}
#endif

-- 
Cheers,
Harry / Hyeonggon

