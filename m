Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 823C8606A327
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=G3ZE0lBf
Received: by kanga.kvack.org (Postfix)
	id 5675C6B070C; Fri, 13 Nov 2026 07:27:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 518A16B070D; Fri, 13 Nov 2026 07:27:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 407CE6B070E; Fri, 13 Nov 2026 07:27:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19C666B070C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:27:13 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A92161C3AE3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:27:12 +0000 (UTC)
X-FDA: 85430020704.07.6F0241A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id AEDB8180003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:27:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=G3ZE0lBf;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794572831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQS8+G8zUE7eRedh/eNlx+5Ei152G7Qf9Mz0SPz+noE=;
	b=n+GfHtn28pfXfjoQKD3X/arSX71FC7812HAL6M3RlMxFpvStgjjORbSZ7+P7M68xPFe9Og
	U/CL26P1C6GKbHayEpRvvac65148ApsFyXIbbHf+v0oSU6ctJrTDA4qV5CZvDeo/HAEadO
	Lw1M+ha3ZP/dv6NErRU0U5Dxe7mNYI4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794572831;
	b=3zTAy1wAxxy5Mp/jPj6b93x0pX1StlARIFnZaAQywHMis6Z+4ELgxHi1ivfVdXf7+aLk5e
	fttCenokiFHimclbS2Zqx/b4PvOOgvDtW1QLWV8MtGNkuuLlquqgdPXt41JLt1C0GpxkSH
	LzDQBNnE0+IYcl0ua/13kYazPyAlLSE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=G3ZE0lBf;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7357B1476;
	Fri, 13 Nov 2026 04:27:06 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1F693F673;
	Fri, 13 Nov 2026 04:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794572829; bh=TjVoosr6HqMq8nW/HCbzKJB4G46aGduUougz+nELtKA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G3ZE0lBf0yvMtKjxWs2lS+kwNScICzsuSt3PN/vaXgGRiWOYWIb6EyG35gA5p99XI
	 lmoFC4/gSOeIy5HY8ViwUoBBUzPDEoS4MnqpoeBv1rskyqgs7Scl+nXtorBAOHztk1
	 blRI1d2Xf1UCXz55EOxU/1juRk2+HZiqQMu38DKA=
Date: Fri, 13 Nov 2026 12:27:04 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Breno Leitao <leitao@debian.org>, Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH] slab: allow sheaves for SLAB_NOLEAKTRACE caches
Message-ID: <avcCGNUqCrcwbFG6@arm.com>
References: <20261112-kmemleak_sheaves-v1-1-e40e3d73b253@debian.org>
 <sashiko-outbox-212599@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-212599@kernel.org>
X-Stat-Signature: iwkcr1mri5e9ie6t1pbf1tjthc5smf9q
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AEDB8180003
X-HE-Tag: 1794572830-870666
X-HE-Meta: U2FsdGVkX1+rcui29YK2ytEVaTBDHGmRri0vEfM4f0lGBxNKG4aOypC3dDXn8RlvSUj9p7IHjNUNwButJOfk9W94Azbt8Z/wMYtT42BgGZDxeuMUPUmtKD0pVwHBEDzpNFqTD7pBro2Tzq9ObGjw/d1Oeuc/g2Z78Pua39FJRjgZZuCP5ImgPDdt76gucqego/YMrP2FhVTa3PlfTF6gLvkM9RgGvevNqwieM+uoUtVvU/IlAkQsQoDYt92jxQpVQtQIBbEtSp73x6QgEdgsDOZGpjs6wen5T9BGe9TYUv2jj1Z8oTMl+kJbRTntC4yqlGWU01HuYiKuBzHhO86wD0B2Usu14YHXNNw6Fj/KGiDXu+Cl6B8YugIaEGRFluqVssR3vubjmFIWVPeUpzWnzR8RgTpZuw5Bay72ds4c5kJ8QbCOc6M+lRuTjc0naC1BDT0amDflR2cjmv9X66HxZ1g0PBZmVL4sueQ29OGs4/LmBcnwGIA0grIPqxWUlck6J+WBRLb/v5Y68g+CIaXqRxe5pi8Rsu+jMGWr/Owc3KtDVntRbOmYLcABnLmQAcfgfoGviNf6LWXWdUyd4XUsIs4PSsJPV9ttpyXWqssiEALSCoKSjhe3Tv2iwVDJ3qlL0keOto9eRn8p3YWP72Lg74ARwk7SK50uz5pmFq7KL1k006A73J40xTJeTw3QhIvpKpIFmzmuyQnhm0Dw8L+NfvlKxCvYWcKTkiFcqNdEPaPTxxJKwMWpG/1olHkWiRbzxrPGYO6WzTmjeuUkCNVmUL53EcF8dDii5IG5qao1hqUSBaUvVAcp+qkh+9UlsWG8S8ZWEHD+gIKIhMfKlHPyUNm08wGnqRBErqYIAd/QQ/cnAzT7fJAtZv+FytUvD9tMcOCRg3mbUAGyYCz9dH0u5tpJuUQymcdulMZy2SFyQe9BddGP5Hmy2gIDBVwaYRib+11Soe/B3qUz+6aDT1O
 EruJyfPi
 Hy1n30WV4WDgE0QUYKNFRdvQRDfYkUFK7E0u3gVvCkLZ8oCh6SesPwKyI26s98RAx4fezjBsCqLspWtBBHyEeS4oQarLNZw2YYMqDlVSFnhyHouwa6fJJAky7aoRaPoIanoTjqIRTmAsT7s94BhsYvVNqXbmg+U3QZv1Z33X/w6TqinlmE+5pQCYbW3FVzE1kZ9V0THKCEPmtKBkqvOzz8DX8HVZ0nTJQFIGsyZ2NbtuIfNeq+3HRK4FEU6HTBbkYHDQrvlhMJerpJnlB1/Qz31ALyQmKLfBl8umIuiIKnRHK02I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 10:05:08AM +0000, sashiko-bot@kernel.org wrote:
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 8369853ddca72..f19e20b6f9a4f 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2850,6 +2850,13 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
> >  	if (s->flags & SLAB_KMALLOC)
> >  		alloc_flags |= SLAB_ALLOC_NO_RECURSE;
> >  
> > +	/*
> > +	 * kmemleak allocates its metadata from SLAB_NOLEAKTRACE caches, so
> > +	 * tracking their sheaves would recurse into kmemleak.
> > +	 */
> > +	if (s->flags & SLAB_NOLEAKTRACE)
> > +		alloc_flags |= SLAB_ALLOC_NO_LEAKTRACE;
> > +
> >  	sheaf_size = struct_size(sheaf, objects, capacity);
> >  	sheaf = kmalloc_flags(sheaf_size, gfp | __GFP_ZERO, alloc_flags, NUMA_NO_NODE);
> 
> [Severity: Medium]
> Does SLAB_ALLOC_NO_LEAKTRACE leak into nested sheaf and slabobj_ext
> allocations for the backing normal kmalloc cache?
> 
> When s is a SLAB_NOLEAKTRACE cache (such as kmemleak's object_cache),
> s->flags & SLAB_KMALLOC is false, so __alloc_empty_sheaf() passes
> SLAB_ALLOC_NO_LEAKTRACE to kmalloc_flags() without SLAB_ALLOC_NO_RECURSE.
> If the backing normal kmalloc bucket needs a new empty sheaf in
> alloc_from_pcs() -> __pcs_replace_empty_main() -> alloc_empty_sheaf(),
> that nested sheaf allocation inherits SLAB_ALLOC_NO_LEAKTRACE and is not
> registered with kmemleak.
> 
> Because kmemleak never scans that untracked normal kmalloc sheaf:
> - If the sheaf is later used as pcs->rcu_free in __kfree_rcu_sheaf(),
>   kvfree_call_rcu() returns before kmemleak_ignore(ptr) while freeing is
>   deferred, so kmemleak_scan() misses pcs->rcu_free->objects[] and reports
>   queued objects as false-positive leaks.
> - Any tracked kmalloc sheaf linked between two untracked sheaves on
>   barn->sheaves_full or barn->sheaves_empty is unreachable during
>   kmemleak_scan() and is also reported as a false-positive leak.
> - In slab_post_alloc_hook() -> alloc_tagging_slab_alloc_hook() ->
>   prepare_slab_obj_exts_hook() -> alloc_slab_obj_exts(), the slabobj_ext
>   vector is likewise allocated with SLAB_ALLOC_NO_LEAKTRACE still set,
>   skipping kmemleak registration before calling kmemleak_not_leak(vec).
> 
> Setting SLAB_ALLOC_NO_RECURSE along with SLAB_ALLOC_NO_LEAKTRACE (or
> clearing SLAB_ALLOC_NO_LEAKTRACE before nested allocations) would prevent
> the flag from propagating into the normal kmalloc cache's own metadata.

Sashiko is right here, this could lead to false positives. I don't think
clearing SLAB_ALLOC_NO_LEAKTRACE before nested allocations is correct
since that could reintroduce the original recursion. Adding
SLAB_ALLOC_NO_RECURSE alongside it should fix this.

IIUC, I think we need to include SLAB_NOLEAKTRACE in the
mark_obj_codetag_empty() condition in __free_empty_sheaf(), alongside
SLAB_KMALLOC, if we go with the NO_RECURSE option.

-- 
Catalin

