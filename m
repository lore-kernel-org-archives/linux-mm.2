Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C7C5C531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 10:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8745A6B0165; Thu, 23 Jul 2026 06:01:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 824596B0166; Thu, 23 Jul 2026 06:01:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EC666B0167; Thu, 23 Jul 2026 06:01:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A2576B0165
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 06:01:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B9ECB40415
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:01:37 +0000 (UTC)
X-FDA: 85019599434.26.FE1DB2E
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf16.hostedemail.com (Postfix) with ESMTP id ABC14180004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:01:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B3tN3CMm;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784800896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/IOPEWFyLCrkOKDL5TmCaxllcKhpBFa1PGm5TdS+JwA=;
	b=qH6S4RyQeRfxAMiRi1eh3e6veKqpzFepCPPchvQiy7VDKTrfmLSTHREvip5xYLKVX6eeHQ
	RYrSS6SrmkyWZYql5ENlKs779ku4VuSY4TuNsXu8ySFv56qL6Wyj95RNwX0TE3ICYWlmNs
	6leQwCGxZTkmfZWcgedlMxl9e/nVwro=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784800896;
	b=RKKJu83OtrVoB3fzXdnUoG8v1X2KBr42q9jejojLdof1qzuekfcFTHpRiZlHkZDi6J5S5y
	bbNUB5usBhvs44kN8gqy79BHa+QyL4gmN3+GSP+PKhw/iza0AF89ps1KeIagJ0A8JpTnOV
	5GCIJ06SC5dS+NzQ9ZJGBy78CmAITqQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B3tN3CMm;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 23 Jul 2026 18:01:07 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784800889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/IOPEWFyLCrkOKDL5TmCaxllcKhpBFa1PGm5TdS+JwA=;
	b=B3tN3CMmCpKLZ3NrTYsrJ4RLkX3LFQJRJLgVEIuQsXk/GkMvH5ZafyBK62EAo0LIvT2D50
	fAKJeIjSiLb7ygdHnxWK0DaWeYIXONIZaWgnhZYOEC7DvUfbyNhUa9RtOtJ0mXfO3rfymO
	FwBtaicdmtSjfbwmIZf+DeT8vEaPrX4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 12/13] mm/slab: add cache_ and slab_needs_objcg()
 helpers
Message-ID: <amHldYIo_-Bgm7Ek@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-12-2fa7c6f60dbe@kernel.org>
 <amHbnLLrpOmwmusv@fedora>
 <e8b503fe-c97f-4747-aa95-97be42cdd832@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8b503fe-c97f-4747-aa95-97be42cdd832@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: ABC14180004
X-Stat-Signature: prmtcoq8dy9kn5od1h7rs3cqchdquaor
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784800895-276286
X-HE-Meta: U2FsdGVkX19qNyndwSUKtsPZMO/3+vdvRFbKwgVFTtDJDaNCeu+2xiXLN+qklAPR9RCQNkebfHjQduJT4J4jxyePIOk4wMOaFkjwubd7mJvTemNvIrHto3zNkenrFF33POhJj8xlxYRwoH89fGHUjcLZO/Vy/yWkNf8/vezy5n7gzsc8XWQlO+Ah6aBluwAOdkwASPZgh42XtFi/7aA2nPyU04MImW9I2l2btUnY3phy4ZaSmJ0OIKAt++sZDFUJMfdHw8GEZ/H6w2fkv52/gwjTbA+DttR/ugWZsQo2vLyzBPvbQ6xvGLD0eRQWsrww/h0a4nOnDyAj02G2fVBXBPXv1Px3ZO9KEbLIzWLB/Al1iihl7LCgoAr/V7UbgtTdKjsKfsu17t4NOaznuFJRjI+yUhTUzDUUUj/NNS4AjyquPDF7ZqXUWGKaUeHzx1XvEZnRLo66kfMdAbG35ui8efG6wMkvPgzkcHROf2DX+SmwOv5XS6lMHX3E4a4FW6pS/WbIXAIL/IlOlBJD7g7O+P5P2Tbc0IchGKZTnmWtAza+4+NGhT4PIW+fJAFFOklinBjSzhj3bPv4+rY+epYO1vFaKVG98cwXEaZv5FiMP8SpH2t2piQACxEFCXUge5eorUpchT0LZ+G8Oetj7ZDp8bEdaZnfyIsnjDo02u+uWgAlMYUBvhLdsFj8sEkmeDZOoZsP5VhFZlGGyLLgFFzKOKDKoijiIvQzfMEqi0s2CXVEX0fhgTnhBtQACI9D5tTWMXZgiqKSqEIcgXltlxNC2s3GLYLMoA0ZmJIbnZFDTXuO4lzY7o2w1T+GHB0ixNocg6YtkOLBgryGDtC0ao9XNIWgkwWmeFqXgpK8XRJeysmoSQXgfAu6+5TXUCQu45jpNL5KiYvI6gcjrdl3oxHH+QtDCUqbGqROAxgQ9wThd/ufpDg6kK0Tc667MqPh45a/mTV4l4Hmw/UIx0CHeQH
 C3Letkwu
 tohYzmXBJYy5rlDjLyiBjhsH4lagShgIWgCBxxe8eQQCW++YPLbQ+cHpQzdqBjjdyAYycOdtTaSMAy5vlQtgQp9Cs5slUaOV4EYU2Fy9APIdg8QM1z39qOs8cPAeTJKiOqG9xOejmBfFuIiEY18LJeFkt/YrZ5WEd1DQDO1NKzxJppXZeJ9hNrxkWzZhYKE2EiaDtakjZRW4gdK+RsKjaOUBir80Ss0s1mh0PnrlK6ojk/wjIogaHTig9qsoAiZpqe5uY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 11:30:49AM +0200, Vlastimil Babka (SUSE) wrote:
> On 7/23/26 11:25, Hao Li wrote:
> > On Mon, Jul 20, 2026 at 04:16:26PM +0200, Vlastimil Babka (SUSE) wrote:
> >> @@ -359,6 +359,13 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
> >>  		goto out_unlock;
> >>  	}
> >>  
> >> +	/*
> >> +	 * For now we assume any cache can be used with __GFP_ACCOUNT and thus
> >> +	 * may need to store objcg pointers for objects
> >> +	 */
> >> +	if (!mem_cgroup_kmem_disabled())
> >> +		flags |= SLAB_MAY_ACCOUNT;
> > 
> > if memcg itself is disabled via `cgroup_disable`, mem_cgroup_kmem_disabled()
> > still return false, so maybe we can use:
> 
> Aha, but then shouldn't rather mem_cgroup_kmem_disabled() take that into
> account on its own?

Yeah, it's better to handle two cases in mem_cgroup_kmem_disabled!
This could also be a standalone patch, but including it to this patchset it totally
fine.

> 
> > if (!mem_cgroup_disabled() && !mem_cgroup_kmem_disabled())
> > 	flags |= SLAB_MAY_ACCOUNT;
> > 
> >> +
> >>  	/* Fail closed on bad usersize of useroffset values. */
> >>  	if (!IS_ENABLED(CONFIG_HARDENED_USERCOPY) ||
> >>  	    WARN_ON(!args->usersize && args->useroffset) ||
> >> @@ -984,11 +991,19 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
> >>  #endif
> >>  
> >>  	/*
> >> -	 * If CONFIG_MEMCG is enabled, disable cache merging for
> >> -	 * KMALLOC_NORMAL caches.
> >> +	 * If memcg_kmem is enabled and this is a KMALLOC_NORMAL cache and  not
> >> +	 * aliased with any other type, make sure it's never merged with any other
> >> +	 * cache.
> >> +	 *
> >> +	 * In other cases the kmalloc cache may end up being used for a
> >> +	 * __GFP_ACCOUNT allocation so mark it as such
> >>  	 */
> >> -	if (IS_ENABLED(CONFIG_MEMCG) && (type == KMALLOC_NORMAL))
> >> -		flags |= SLAB_NO_MERGE;
> >> +	if (!mem_cgroup_kmem_disabled()) {
> > 
> > the same as above
> > 
> > Others look good to me.
> > 
> > Reviewed-by: Hao Li <hao.li@linux.dev>
> 
> Thanks!
> 
> > 
> >> +		if (type == KMALLOC_NORMAL && KMALLOC_RECLAIM != KMALLOC_NORMAL)
> >> +			flags |= SLAB_NO_MERGE;
> >> +		else
> >> +			flags |= SLAB_MAY_ACCOUNT;
> >> +	}
> >>  
> >>  	if (minalign > ARCH_KMALLOC_MINALIGN) {
> >>  		aligned_size = ALIGN(aligned_size, minalign);
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index d78d3e50c877..30435e2509ea 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -2557,7 +2557,7 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
> >>  	 * of slab_obj_exts being allocated from the same slab and thus the slab
> >>  	 * becoming effectively unfreeable.
> >>  	 */
> >> -	if (is_kmalloc_normal(s))
> >> +	if (!cache_needs_objcg(s))
> >>  		return true;
> >>  
> >>  	/* Ignore already charged objects. */
> >> @@ -3435,6 +3435,10 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags,
> >>  
> >>  	slab->objects = oo_objects(oo);
> >>  
> >> +#ifdef CONFIG_64BIT
> >> +	if (cache_needs_objcg(s))
> >> +		slab->obj_exts_needs_objcg = 1;
> >> +#endif
> >>  	slab->slab_cache = s;
> >>  
> >>  	kasan_poison_slab(slab);
> >> 
> >> -- 
> >> 2.55.0
> >> 
> > 
> 

-- 
Thanks,
Hao

