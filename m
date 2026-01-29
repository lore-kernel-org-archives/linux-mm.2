Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62DF8D358E8
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 09:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A88646B0089; Thu, 29 Jan 2026 04:21:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A367C6B008A; Thu, 29 Jan 2026 04:21:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92E986B008C; Thu, 29 Jan 2026 04:21:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 815206B0089
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 04:21:37 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01AF81B16B6
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:21:36 +0000 (UTC)
X-FDA: 84384458634.23.77ACC6D
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1D319140002
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:21:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qRrduHSy;
	spf=pass (imf09.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769678495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fI8YSEiCKvz8plCIXy9+252lf5EMdjx1vrHxy+V2df8=;
	b=RIquUlQCXLx+9cjk8c6crw1qdF3AcFKquF2kbnD8NbdugzzReceodyArvBP277k3fhW8Mb
	avQ3DpjinTnlesxxXUbc0FONVFNTneB9TztS5eTNvcyA+zGMF1wijajr0bZQoJiSHAKZRp
	8csYAZr6F/kG8GJJsBNwHwoNIzIF3K8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qRrduHSy;
	spf=pass (imf09.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769678495; a=rsa-sha256;
	cv=none;
	b=WUBKWKx/DwcY0kLoCrLD+SmOe3wFHIWdqSCSvW9lLvULqBBqX0b19GBNTCjbmAww8lo4Lr
	jrH1tM9+57/yTYQYsoJPmJyojFE3JPJ/FvAkrZbM6ziW9HJn4aDkgA4nBodCQGKy3Or01F
	CLLc3JGfhOeV+f0dMX88HIb4464cox8=
Date: Thu, 29 Jan 2026 17:21:21 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769678491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fI8YSEiCKvz8plCIXy9+252lf5EMdjx1vrHxy+V2df8=;
	b=qRrduHSyxF9AHp2dBFaCNDrVdOWi6J30wDgh0/y9xAzxPBPzZc1aBrxk6AncooM3FgJ3JU
	+kQMO1TPmYpr9ql/KAkWnhQevdszzPIi2V4XKPqqOjKCK0OcjBShIbIY1b7YBCg7vLRFp9
	IZORX+JTtLgToey9FwjiYgltwVh0Pf4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH] slub: avoid list_lock contention from
 __refill_objects_any()
Message-ID: <r4sorjw4p62mk2pvnjfrfx2w3zmwcz5yuflmcewll3jsmpju42@dniauu6pkm6j>
References: <20260129-b4-refill_any_trylock-v1-1-de7420b25840@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129-b4-refill_any_trylock-v1-1-de7420b25840@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 1fa9dndgmpkidx9d6f39aong18d17ztd
X-Rspamd-Queue-Id: 1D319140002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769678494-64854
X-HE-Meta: U2FsdGVkX1+CP+ikdpbriRcSPnhU4xeZGpH3OMgWLiT8QejIdU0ihmyHBn2MVfxjwqIzuOqBOQotKDBAauZfS+TjV8vcn44jJnYAvhJ73NAOKr417fuBO2wwJNeHQPxrRztSSYlSxcYt+JLinDDK8VH1B3Gm90ox6PdwvHRXTAROlDRiL73sYSnYQOQOskEKVLKuVVho0OTsFRQwVe313q80GAhSk3WW6kAClIniM55K10hNE697x/Ht9xJ58yLyYrmVC64vK3xB4opE28J4Y2NzrMV/EgilUcJKrt2JYITgWzfu9reuuDM6TXdtX/5ODE2+TrtZagDGuY+m6PjYmZlv3ZJC1QYFedOmU4Spkz0ADALdL9Kb4HAMeB40q7urv/2gWNQAEDlgrZTojAZy0VKE6Bjw54/2+6ESgydUMJuOyNBMxUk4JxMIMek4djxZxO6f+Lzql4JFqMXM44y5pRdKqrE/tm/G4lUzQwHoiA9R009vFmN59SQR472lmi1wtlidlS4ObjcKlb6fC3+jaSmL8C2QUPCqc8ihadPWPTIW3bDX165OJb62E7LN5An5+ssEq6QPatXJLBtRSGL1DVJPF/I+5xP5/XfTOV6QECUOC7vGPlt1nVrO0QgY8cdb6j2hY/90Z+cgMQpRTOG2CzYo1VGk+XVglHV9aRb9/U11JYZuunOH5AtgS1Z4zZv5aSJ7P/R/dyo7Oc3+KjUb/VDdHxKRO9tpS7x5Ugo3Bc/+Hn3IgAkKBjAvXfMBte3A+6hYG0yT6lYzffzKNqnNIutGfGud2NdjjNuI72hhdnZXQx/DTnAz28D1yvakskJ3oDicrL4KFQ3F/mz95j/n8T3qkHPwhc9OqJsVue0+yYahWMzoLd3P5z0YP0STcr6u55RY9iig5n22GZP4dGl1CLmo20w9HXmcWfovYEhDh6RHTe8tp22UhJTX3djGFk6WINQSuBT6fF0kCPxyjwt
 Sl8a+YQJ
 jMGf9EON190EM3VSwtz5b7BCs7HwgJCpNIre5CgAqC6+rMIAP7mMocQxaIhTQsUZFgP3GHPd5UttLn/KMD9+BtK3KzVGEjLo1JyW89spPl4NwOSeAeUUqY3Jaxl6tJMeP46fN4qHXQzE3qwPFNszCWH/tvV2BDRXmCkHywYeLcxbQAshLsHJNCuh/ErxFo+Mhf1Dkx3SCoW3srLQdPIEScEYS1F1d2rSoWUf22Gt2cwJzcBtFdavnl56dw3Ez1uOcUaSN+qeM/oTwMrRVuf9GuJqzpND04HjQ8PLz43YgVA0J4Y8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 10:07:57AM +0100, Vlastimil Babka wrote:
> Kernel test robot has reported a regression in the patch "slab: refill
> sheaves from all nodes". When taken in isolation like this, there is
> indeed a tradeoff - we prefer to use remote objects prior to allocating
> new local slabs. It is replicating a behavior that existed before
> sheaves for replenishing cpu (partial) slabs - now called
> get_from_any_partial() to allocate a single object.
> 
> So the possibility of allocating remote objects is intended even if
> remote accesses are then slower. But the profiles in the report also
> suggested a contention on the list_lock spinlock. And that's something
> we can try to avoid without much tradeoff - if someone else has the
> spin_lock, it's more likely they are allocating from the node than
> freeing to it, so we can skip it even if it means allocating a new local
> slab - contributing to that lock's contention isn't worth it. It should
> not result in partial slabs accumulating on the remote node.
> 
> Thus add an allow_spin parameter to __refill_objects_node() and
> get_partial_node_bulk() to make the attempts from __refill_objects_any()
> use only a trylock.
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Link: https://lore.kernel.org/oe-lkp/202601132136.77efd6d7-lkp@intel.com
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

In my testing, this patch improved performance by:

will-it-scale.64.processes +14.2%
will-it-scale.128.processes +9.6%
will-it-scale.192.processes +10.8%
will-it-scale.per_process_ops +11.6%


Tested-by: Hao Li <hao.li@linux.dev>

-- 
Thanks
Hao

> ---
> To be applied on top of:
> https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/log/?h=slab/for-7.0/sheaves
> ---
>  mm/slub.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index eb1f52a79999..ca3db3ae1afb 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3378,7 +3378,8 @@ static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags);
>  
>  static bool get_partial_node_bulk(struct kmem_cache *s,
>  				  struct kmem_cache_node *n,
> -				  struct partial_bulk_context *pc)
> +				  struct partial_bulk_context *pc,
> +				  bool allow_spin)
>  {
>  	struct slab *slab, *slab2;
>  	unsigned int total_free = 0;
> @@ -3390,7 +3391,10 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
>  
>  	INIT_LIST_HEAD(&pc->slabs);
>  
> -	spin_lock_irqsave(&n->list_lock, flags);
> +	if (allow_spin)
> +		spin_lock_irqsave(&n->list_lock, flags);
> +	else if (!spin_trylock_irqsave(&n->list_lock, flags))
> +		return false;
>  
>  	list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
>  		struct freelist_counters flc;
> @@ -6544,7 +6548,8 @@ EXPORT_SYMBOL(kmem_cache_free_bulk);
>  
>  static unsigned int
>  __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
> -		      unsigned int max, struct kmem_cache_node *n)
> +		      unsigned int max, struct kmem_cache_node *n,
> +		      bool allow_spin)
>  {
>  	struct partial_bulk_context pc;
>  	struct slab *slab, *slab2;
> @@ -6556,7 +6561,7 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
>  	pc.min_objects = min;
>  	pc.max_objects = max;
>  
> -	if (!get_partial_node_bulk(s, n, &pc))
> +	if (!get_partial_node_bulk(s, n, &pc, allow_spin))
>  		return 0;
>  
>  	list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
> @@ -6650,7 +6655,8 @@ __refill_objects_any(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min
>  					n->nr_partial <= s->min_partial)
>  				continue;
>  
> -			r = __refill_objects_node(s, p, gfp, min, max, n);
> +			r = __refill_objects_node(s, p, gfp, min, max, n,
> +						  /* allow_spin = */ false);
>  			refilled += r;
>  
>  			if (r >= min) {
> @@ -6691,7 +6697,8 @@ refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
>  		return 0;
>  
>  	refilled = __refill_objects_node(s, p, gfp, min, max,
> -					 get_node(s, local_node));
> +					 get_node(s, local_node),
> +					 /* allow_spin = */ true);
>  	if (refilled >= min)
>  		return refilled;
>  
> 
> ---
> base-commit: 6f1912181ddfcf851a6670b4fa9c7dfdaf3ed46d
> change-id: 20260129-b4-refill_any_trylock-160a31224193
> 
> Best regards,
> -- 
> Vlastimil Babka <vbabka@suse.cz>
> 

