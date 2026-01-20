Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 788E2D2ECFE
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 02:55:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA4576B0351; Mon, 19 Jan 2026 21:55:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D27756B0352; Mon, 19 Jan 2026 21:55:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5DB76B0353; Mon, 19 Jan 2026 21:55:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B62286B0351
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 21:55:57 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 42C5B8B0A2
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 02:55:57 +0000 (UTC)
X-FDA: 84350827554.07.D1CE0AE
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7AC8340004
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 02:55:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ul671Yoi;
	spf=pass (imf17.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768877755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=inDvl4GaipWhYSp0U8tScgUdBjqvSGDRhS8Caxa209Y=;
	b=wQYgize93gdXKrtebAGdMhkDT+mZUKMAaxj+eK0X7ay0rljtnZskVvFS+gk/aHn+4HrbHv
	MVR3Z4h4e8LuBJJy+BjFjODfhBJNsBAz5Nzyf+s3KtlFJ7183WcWjdAVnjIi6CJAu/K9mQ
	QPR7LHBeDyFNdYlAcYrVZLZWcpjz0YE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768877755; a=rsa-sha256;
	cv=none;
	b=bbKMYL/lJGK6QCTnv65J46okXix5cW9gEMHuc/CprYycr1R8HfpMYdnCIv+2XNO1s/X+ne
	zLzQkbS8+u3iMsrjblRJ23Pt1lWX7GOfsZHMKRHJ2Gd6g/vrMMMnXfR6SdcJH19cVHdctc
	u0O9WKsX94vAuhtJis9K7M2+aPRA7lY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ul671Yoi;
	spf=pass (imf17.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 20 Jan 2026 10:55:25 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768877753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=inDvl4GaipWhYSp0U8tScgUdBjqvSGDRhS8Caxa209Y=;
	b=ul671YoiONtDqTS7xjqdHK4X3D3Owh+owPHC7p9o2xf3i7N+8ciy56TQYlYyc7/Q5ZKJW4
	D6NudN0qKhjeL7HzUnSyWXP7TZe0hth0jPtLqD6KzCT4QFHSWJLwjBcMJsxYdhnrAHFGQZ
	wLKPDyWep2KgRvrn5a0joUvFP4eMhmM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 09/21] slab: add optimized sheaf refill from partial
 list
Message-ID: <mxrcthlqj6rbecg5z33lc7oqnbicr5fn5lmvni2tjo2dc3oe76@u5vettfyypl4>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-9-5595cb000772@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116-sheaves-for-all-v3-9-5595cb000772@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7AC8340004
X-Rspam-User: 
X-Stat-Signature: s5at5wzmjmx4bdxsh6ddimuzueonh4t1
X-HE-Tag: 1768877755-326412
X-HE-Meta: U2FsdGVkX19TO2o0WQ/mhFYX1HAQV/8rz/+O18FHfCgcN7iFhtCC6nKZUbWIKwY8Cvlh7xBTLoBpyjOLn1wKLao46CPKxDdshK1hnSDPHp/xwPMmGlFILkTWopC3r4wcun+wjhO5Q5aj9hhKB4hzizFJUq6tB7fzVVhSBE/Y4VvSkvvIixsaC5aScaPaqEn7Za4ewWAc5rqOHhvCLpSLjs/ONFgjkLwtVoF7mUuENj9QfMyeL//M6VFEYfPI0FbUTAeNSDC2RNBZIVcRoF5I6mAx60lz+xGBv1RzaHXe64/VKz9DE7BVMr4BbqW8bGKQ7LfxHRtQgvHDUXHUhuOYfd1S9vuM4kMtSf2hkIzjCw1qpC0nMoLVwLhmVOFLd/i+YFpU12pkEA3kJ83/OZleD27ZHDJ5FElx5shGJhlfIoLUI/tfI97YhllDc3Q4VsdHqT2LKFgUKHv85W10Nk0s6I7UBe2h1CBrizparH/jGuFAM+pATtsXsX/jDJ7QxLM+tIpKEXf8645wB6i9br7Fv9OeJI33N37zx6niYui8lH/uUlCpzAwwOF2N/PsLUG5mBFPr2VuRXOd4RqjVyklgWRHhWdxnwFg9OUudJ4z/2cEb1JFeUc+pENRLyI9jm81NTK9hob+6+2zGDtH586Pw7fi91t9vJUMOSL8KymywjGweaROcgrA8tgWFA4lgjQDOUYL/9DIebOLNkItV1HSUh9a0fVPv8tbQ4wTmAe3vB9hMtIxohEjao7vYLXh90+5d3b6ZG2yFb9HZcbWtVEP/xmbYovyaZgHvIh4IaSNDaqEWwGHp1cgaRHgrZAsKbtk4AvzcUOp3ap0qOjU24+KMU2KSn4+oU+zkowlxurMTZcJU1RNd78uxYLHw6PuoSA0vPW3WEr9785e2jPilR6CHw10CH0j3gyzyBelYfpLI5Imjw+38aUJRyQEBSFeuAn28HwxtES/0QBW+OWQBDj2
 8yiOTmIa
 lC2UgNWVO0a35aJcJVDJgaxXKCmRK9xrG7zfcN0pN6SMBXfJIFTEbSl/ewMrCNJPgCKmaxKbvcfI5Wxt1/VijV8oeCgAutDQSitwy7K2rF6ayss2L6GblEmj3VVVs+vchO6OjCKlblXzM7arwSGtaBoheRTFsT9ZhABBraj/lHkIiyKsbv8tZpemSsgG2yrcAuHhdB133WMUu7RA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:40:29PM +0100, Vlastimil Babka wrote:
> At this point we have sheaves enabled for all caches, but their refill
> is done via __kmem_cache_alloc_bulk() which relies on cpu (partial)
> slabs - now a redundant caching layer that we are about to remove.
> 
> The refill will thus be done from slabs on the node partial list.
> Introduce new functions that can do that in an optimized way as it's
> easier than modifying the __kmem_cache_alloc_bulk() call chain.
> 
> Extend struct partial_context so it can return a list of slabs from the
> partial list with the sum of free objects in them within the requested
> min and max.
> 
> Introduce get_partial_node_bulk() that removes the slabs from freelist
> and returns them in the list.
> 
> Introduce get_freelist_nofreeze() which grabs the freelist without
> freezing the slab.
> 
> Introduce alloc_from_new_slab() which can allocate multiple objects from
> a newly allocated slab where we don't need to synchronize with freeing.
> In some aspects it's similar to alloc_single_from_new_slab() but assumes
> the cache is a non-debug one so it can avoid some actions.
> 
> Introduce __refill_objects() that uses the functions above to fill an
> array of objects. It has to handle the possibility that the slabs will
> contain more objects that were requested, due to concurrent freeing of
> objects to those slabs. When no more slabs on partial lists are
> available, it will allocate new slabs. It is intended to be only used
> in context where spinning is allowed, so add a WARN_ON_ONCE check there.
> 
> Finally, switch refill_sheaf() to use __refill_objects(). Sheaves are
> only refilled from contexts that allow spinning, or even blocking.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 284 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 264 insertions(+), 20 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 9bea8a65e510..dce80463f92c 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -246,6 +246,9 @@ struct partial_context {
>  	gfp_t flags;
>  	unsigned int orig_size;
>  	void *object;
> +	unsigned int min_objects;
> +	unsigned int max_objects;
> +	struct list_head slabs;
>  };
>  
...
> +static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
> +		void **p, unsigned int count, bool allow_spin)
> +{
> +	unsigned int allocated = 0;
> +	struct kmem_cache_node *n;
> +	unsigned long flags;
> +	void *object;
> +
> +	if (!allow_spin && (slab->objects - slab->inuse) > count) {

I was wondering - given that slab->inuse is 0 for a newly allocated slab, is
there a reason to use "slab->objects - slab->inuse" instead of simply
slab->objects.

> +
> +		n = get_node(s, slab_nid(slab));
> +
> +		if (!spin_trylock_irqsave(&n->list_lock, flags)) {
> +			/* Unlucky, discard newly allocated slab */
> +			defer_deactivate_slab(slab, NULL);
> +			return 0;
> +		}
> +	}
> +
> +	object = slab->freelist;
> +	while (object && allocated < count) {
> +		p[allocated] = object;
> +		object = get_freepointer(s, object);
> +		maybe_wipe_obj_freeptr(s, p[allocated]);
> +
> +		slab->inuse++;
> +		allocated++;
> +	}
> +	slab->freelist = object;
> +
> +	if (slab->freelist) {
> +
> +		if (allow_spin) {
> +			n = get_node(s, slab_nid(slab));
> +			spin_lock_irqsave(&n->list_lock, flags);
> +		}
> +		add_partial(n, slab, DEACTIVATE_TO_HEAD);
> +		spin_unlock_irqrestore(&n->list_lock, flags);
> +	}
> +
> +	inc_slabs_node(s, slab_nid(slab), slab->objects);
> +	return allocated;
> +}
> +
...

