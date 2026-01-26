Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4205D13C20
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 14:37:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 373626B0088; Mon, 26 Jan 2026 09:37:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31DDE6B008A; Mon, 26 Jan 2026 09:37:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 244AC6B008C; Mon, 26 Jan 2026 09:37:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1508B6B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:37:48 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AF8178C3CB
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 14:37:47 +0000 (UTC)
X-FDA: 84374368974.27.866ACB8
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id EE5AA40019
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 14:37:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rehQdevu;
	spf=pass (imf27.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769438266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O3gWPox18R9R0nDM+yJbkJ1B/qOaChMvjCqqEXPSWtY=;
	b=XN+veRBR+o9sH0ufM5OejwEpXJTbZtLyUUCxQTbFpAJHU0yDuqUlev3MzniIhZ2uzkVWVS
	pOUFAf+yB/RnD+DuX8qB+SmJZ7zhgLcNteti9cQktmHzBMSU0f4LKaBRLQYF5bTpCdJ7ai
	YbaRSScvgfhQpxIwND///phmheW79Vk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rehQdevu;
	spf=pass (imf27.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769438266; a=rsa-sha256;
	cv=none;
	b=5chFpXO/UAYhBACYEh7ih7ByiTTYrmX9Hnv4uMFqZRhuqai0uthRY6Fbg5Ya3JlWFvMwU1
	I+nev1yYO2UHCe1BkJBobqe2BsyDCFMxZPFvFAHHsAQc9eHC3cnNRsHGk0PSaCH115bqCI
	RWoxf6VB66Qdv3BdMvsdR30Yib2GZFM=
Date: Mon, 26 Jan 2026 22:37:27 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769438263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O3gWPox18R9R0nDM+yJbkJ1B/qOaChMvjCqqEXPSWtY=;
	b=rehQdevuiw1TNhrO6RLeGjk8vl2XWVm33sLgqKmYpZ4h5yVPSaDPbLevcP6qnAyJ8KG3b5
	AIvJoCvrfKKgwXq0y0MJkvWRDZCHsoxSwgSHCpg1o1YmUzjGKxechwkWyRWkXxXm5vckTm
	dw50gVKh2Z548hagRtfWtNf2FLsf1NU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, cl@gentwo.org, rientjes@google.com, surenb@google.com, 
	kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH V2] mm/slab: avoid allocating slabobj_ext array from its
 own slab
Message-ID: <73gdb2vktj6dmog3z4kzpl2tefkuvt4ckcom24eo6xveznc7lx@v2b74xbwa36r>
References: <20260126125714.88008-1-harry.yoo@oracle.com>
 <aXdmN1jUR5bZ6rK8@hyeyoo>
 <795a4294-001f-4462-8afc-7310e9059943@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <795a4294-001f-4462-8afc-7310e9059943@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: juorjdxdru6ca8j9ny3qwwt443pib34w
X-Rspamd-Queue-Id: EE5AA40019
X-Rspam-User: 
X-HE-Tag: 1769438265-747190
X-HE-Meta: U2FsdGVkX1+U0doNjrvGKNlwtWa2KcevGFgG5nWkRL1NPCCzo9FRQZMWkx6fVMyr8oTu41HfrwDc2svOWEsq5J5MiYUoETieJRLjenNnZtzSl4tP6e2lz5qqhf8EVUdiF9qTVpLN3vNsos/7hX7WM3UgUffQTtiuEWwmDG2SHxIaytBDKWf+Apo+A2MHAGWj/9PR2bwB5Pw1UmbCjBZUvrzWTUnEY1EGUqCh479Dr6eoGsBofGPPsEo6BG701HAoOMkq5p1LE8Sq9wkahDrUKJoMfabL+RMOwgOltVJkkJIDf7wMwfYTzE1O6bPTEYT6miQSTrnNsQqjaY7l4rNM1ZJX1XbSDvcBWqoUo1dDHqrnLT5N63v1GI7gFYY7G077O+vX4I54qqcoGnOHR6yjWoqadDeOFF4SdE22wkxScdFPFsf6d1MsOR3p/o/aHSc/AIb9nUtcD0OLuo5o4Dfp7i+SIskB5UI7Sld2kAZWqkFKaD7SOpdQZRsh65VPlqWGNLBqtxbPgF5Wge5iyww/tluL905ngiU+AGfqn+d09ujvBNMtdyyGQpRtchQgn1pYJPjydgHrgk34VS2C472rgKv5A3ihFnotfJzKtJ37UiTBT/AlqWkOTqR9O+jvivZbVsr2ar6yoLloc8Ha8Bvc+MXwQkHeywihbvuU7ZvQpzrLqWWdO7n/iDnvhxzmJsMDriitMHHS4PapNJ6GqikNPZce7BdnkW6fN8fBbbCg7OIFKEnwuyuyHxjaV6kYMRDyUbdCAp9BKodldv0y9LRaYxyF3iDCJqTzUwtj+eMVLwRuj5c6LF+TUrME4aOl616SL/2DRaRc8LLtd5u1pV+p6IaQk5KozwYN5T3ZPh8S5FkvuhC5OsrofD9Ojd/dBzbATuT7OVs8UCt2Mi8mj++RniFIVsyVfTDoV1B4Qvmr5zrcZH8ebIdM1reVN49W95RZsyR99YYb/RhbymN5vf2
 unu4EuKV
 oLFLJ2jXw9Mppv1bqXygjymH/2Cg30FV1bSz38TiCx0XOqMHE4/PCOFjR6n8prgaaQBR4+pqipgU30alE9rZxFGUSVM5e8tPd3MqscW01ix62iXmDy2oAKKZIxoOdSO1cmsza9++LUKrTi4EbYomQXJdCdvTjAnyMHnJxjl91/oiRzka1Hz2oRyBXhS/6wvSB+3qi/94uoLXzMWnZX1Y5ryToJGYRkTW4G+svonvMNb+bYBgt6Knhj92tzaEPCSCskJtymUex0uNeSj9XMiuFdy2huwTdyepg1UmWJDzP52XzfAMcb12m6yCRmI+hPXa069H2eTZJ9TKer0A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 02:46:46PM +0100, Vlastimil Babka wrote:
> On 1/26/26 14:03, Harry Yoo wrote:
> > On Mon, Jan 26, 2026 at 09:57:14PM +0900, Harry Yoo wrote:
> >> When allocating slabobj_ext array in alloc_slab_obj_exts(), the array
> >> can be allocated from the same slab we're allocating the array for.
> >> This led to obj_exts_in_slab() incorrectly returning true [1],
> >> although the array is not allocated from wasted space of the slab.
> >> 
> >> Vlastimil Babka observed that this problem should be fixed even when
> >> ignoring its incompatibility with obj_exts_in_slab(), because it creates
> >> slabs that are never freed as there is always at least one allocated
> >> object.
> >> 
> >> To avoid this, use the next kmalloc size or large kmalloc when
> >> the array can be allocated from the same cache we're allocating
> >> the array for.
> >> 
> >> In case of random kmalloc caches, there are multiple kmalloc caches
> >> for the same size and the cache is selected based on the caller address.
> >> Because it is fragile to ensure the same caller address is passed to
> >> kmalloc_slab(), kmalloc_noprof(), and kmalloc_node_noprof(), bump the
> >> size to (s->object_size + 1) when the sizes are equal, instead of
> >> directly comparing the kmem_cache pointers.
> >> 
> >> Note that this doesn't happen when memory allocation profiling is
> >> disabled, as when the allocation of the array is triggered by memory
> >> cgroup (KMALLOC_CGROUP), the array is allocated from KMALLOC_NORMAL.
> >> 
> >> Reported-by: kernel test robot <oliver.sang@intel.com>
> >> Closes: https://lore.kernel.org/oe-lkp/202601231457.f7b31e09-lkp@intel.com [1]
> >> Cc: stable@vger.kernel.org
> >> Fixes: 4b8736964640 ("mm/slab: add allocation accounting into slab allocation and free paths")
> >> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> >> ---
> >> 
> >> V1 -> V2:
> >> - Simplified implementation based on Vlastimil's comment
> >> - added virt_to_slab() != NULL check before dereferencing it - because
> >>   (in theory) it may be allocated via large kmalloc.
> >> 
> >>  mm/slub.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++-------
> >>  1 file changed, 53 insertions(+), 7 deletions(-)
> >> 
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index f21b2f0c6f5a..5b4a3b9b7826 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -2095,6 +2095,49 @@ static inline void init_slab_obj_exts(struct slab *slab)
> >>  	slab->obj_exts = 0;
> >>  }
> >>  
> >> +/*
> >> + * Calculate the allocation size for slabobj_ext array.
> >> + *
> >> + * When memory allocation profiling is enabled, the obj_exts array
> >> + * could be allocated from the same slab cache it's being allocated for.
> >> + * This would prevent the slab from ever being freed because it would
> >> + * always contain at least one allocated object (its own obj_exts array).
> >> + *
> >> + * To avoid this, increase the allocation size when we detect the array
> >> + * may come from the same cache, forcing it to use a different cache.
> >> + */
> >> +static inline size_t obj_exts_alloc_size(struct kmem_cache *s,
> >> +					 struct slab *slab, gfp_t gfp)
> >> +{
> >> +	size_t sz = sizeof(struct slabobj_ext) * slab->objects;
> >> +	struct kmem_cache *obj_exts_cache;
> >> +
> >> +	/*
> >> +	 * slabobj_ext array for KMALLOC_CGROUP allocations
> >> +	 * are served from KMALLOC_NORMAL caches.
> >> +	 */
> >> +	if (!mem_alloc_profiling_enabled())
> >> +		return sz;
> > 
> > Hmm maybe we don't need this as there's !is_kmalloc_normal(s) check,
> > but this allows optimizing out the checks below when
> > CONFIG_MEM_ALLOC_PROFILING is not enabled.
> > 
> > So probably worth keeping it.
> 
> Right.
> 
> Thanks, added to slab/for-next as the first commit of the obj_metadata branch.

Hi Vlastimil,

This v2 patch still looks good to me!
Feel free to fold this R-b tag into the commit on slab/for-next.

Reviewed-by: Hao Li <hao.li@linux.dev>

