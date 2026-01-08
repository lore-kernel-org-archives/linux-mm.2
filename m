Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3192ED1489D
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 05:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FE046B0092; Thu,  8 Jan 2026 00:52:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D6136B0093; Thu,  8 Jan 2026 00:52:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E2146B0095; Thu,  8 Jan 2026 00:52:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D1A46B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 00:52:28 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D23591B957
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:52:27 +0000 (UTC)
X-FDA: 84307726734.27.291022A
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf26.hostedemail.com (Postfix) with ESMTP id 186DC140006
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:52:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D2y9RNUj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767851546; a=rsa-sha256;
	cv=none;
	b=8cFZnW+cirqLV7t2N1SlIOwPiNWMSh/+PCziWes6S0QZ+pM4lNw4SSvsqtSTW+WHcZ4iEI
	b8QWD+TPPvN5+mEmq3djUu504Lsm4HUWfV50ORVhRBV7tikn4FuccnZVwr6xttdOR1cMLc
	H1OxVXP1ntdRjHVUdW9HsYO+RIfT9gc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D2y9RNUj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767851546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SW6dTmD4uXyZNGwcyRd1qnlXwRXWFy6PgtQ3T3sfabA=;
	b=yG+tB0Myc9d0/4FYM3crXMZ5InZrTfW/8rYVV4gl2H4ZdC0dNCG08vUYPxF0iPE94KW4xU
	MsgTi+BgMM8FtX9J3Kw2p0dXivkj8VmcNLmrmAa5ya9GWaFvcYGjKq66NQvYKqqm7PI3xz
	SMuaNNCbYYbbhWiMi6FhbSwenBwdXvw=
Date: Thu, 8 Jan 2026 13:52:09 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767851540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SW6dTmD4uXyZNGwcyRd1qnlXwRXWFy6PgtQ3T3sfabA=;
	b=D2y9RNUjmgCIN1CauVZ9TtkZQ6gOnAMXE4heuFw3f3bvOe3sHStYH9+ASxnUqVh2V42ZUo
	rQRcqsIGD8kXUKL6WeIEPInCG1Ss6RPJNVDuTQvW2+eD+48+i4dsNvo4uiMWxpkutmpQSD
	kr0CXWkCVlu3bj72P5kSWRVfoiyX/xQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, andreyknvl@gmail.com, 
	cl@gentwo.org, dvyukov@google.com, glider@google.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev, rientjes@google.com, 
	roman.gushchin@linux.dev, ryabinin.a.a@gmail.com, shakeel.butt@linux.dev, 
	surenb@google.com, vincenzo.frascino@arm.com, yeoreum.yun@arm.com, tytso@mit.edu, 
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH V5 8/8] mm/slab: place slabobj_ext metadata in unused
 space within s->size
Message-ID: <fgx3lapibabra4x7tewx55nuvxz235ruvm3agpprjbdcmt3rc6@h54ln5tfdssz>
References: <20260105080230.13171-1-harry.yoo@oracle.com>
 <20260105080230.13171-9-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105080230.13171-9-harry.yoo@oracle.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 186DC140006
X-Stat-Signature: c85it7c581hngaai5z6udsdca6pq8ttt
X-HE-Tag: 1767851545-385519
X-HE-Meta: U2FsdGVkX183DdEyfuKAeCQQ7d45BugA9kZ8wUqTK4bsEATK9IdZalbzm2uTHNrv4Ba+P9Qje4fSplKbrtul2HppKjfLJM5MXyoBG9mizrfv5xn5K7br14gu/DoMTnErVNGAeI3Ct3rZEVAqVFdgYQcKCuD9w76wq9Y8KW2uuCK3X2Yw30XnRP9DiLCr9CnMxFpLzJnqTf5LdNqKVP1a9YUXIclsP9IA8hYW2x82OF+zR/5KlOTHPnaAenIaWdFZ6EYhl26tE8u48vMyZSJeLxT5Rjgb2TTGL62TVMqYpZ1410zJzCmlpWawIQXng5DFFfa7i/3Q77PEaCh09k1d1Rf4a7Xeegm96SDRqcvC1pbnd8SbfQBVBdQjjNvZt1GwNfqX0be1+u1MPTIwLeHN9R4nvp1FLFadF77vjnAj5ztjdXohmcCTAZHNP/V0OYeAO08k4eCd3BAH415e5iGgQmfAC0H7+VWmgXOtteTgmdFMAlYvY39jMZGqetFdqi2fwX6USq21tIbNGxsg0BMwTZRqhdlu8iAN0j27dLrj2apJyeZsJz7jF9dntNQBOjOqHbXovoiqbqez2RnMfm9PWjM2fZgoQLjFqSvpmDA0IBnkcbeat/juIWvicy9536dWmTg4PB4Vu/Q70ZZyn6WkUQ/PUcRIhZ0tblThbX2Y2yT7qlpeebi7C63XxZ1MicArkPRwLJsPyOUQSkuheEMcNu0u5EOun1Em9QMxW/kjq8Q9I+FAGRR6sgy6kZW4hAdMyFfiWqkV4z/2WwdbXxDDTeWnBPf9ZzjziNa0NFENiAQJvrLI1yHdR1EpecHoVyrT0em/BM752/WBDm0JO3yIGCp4wy+lF0mw2wGfukM9Cqm0fZNKoxT5WRUgJr8mkERU8NRg04KxJRPcmJd9WL7a2NRRq01fEIFNXCbXU35xCMHc6dESoEnkEjW4QnMU5lVpm1+qGhpnOaTD84ylL3N
 PCfek6HF
 tGlhpgW8RwL2KYSeGx3ORkSE4IaAkgvF1qbhqPB7PQNrIddH9HPpHZ5d263E03iJILbtZeS6g/aID90E8tu1/UnlL1StjFNx6FS5kp8f0z2UYNdDoGH6lGyS3XItGha6a8u/RIZ8DWnk7zLUO2KT7deerqVnB7Rt4R6Qzjp6ulm+4HXtL9TDn9N8CNqRLQCJxRU26POFoSEvozM8KTqL/UxsHZz/G/bzWufKPOjyTBV6Y4gO1+JJM27Y9t5ynlXnXrkiFDpN70UxnJS+KZrFWK6Z1KkZoPaqnobdekoLmocot4nWUfJq/I53M+RuUJdJmuNP+ewY/enWVPatroB2h/fA37GldwnADYOoH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 05:02:30PM +0900, Harry Yoo wrote:
> When a cache has high s->align value and s->object_size is not aligned
> to it, each object ends up with some unused space because of alignment.
> If this wasted space is big enough, we can use it to store the
> slabobj_ext metadata instead of wasting it.

Hi, Harry,

When we save obj_ext in s->size space, it seems that slab_ksize() might
be missing the corresponding handling. It still returns s->size, which
could cause callers of slab_ksize() to see unexpected data (i.e.
obj_ext), or even overwrite the obj_ext data.

-- 
Thanks,
Hao

> 
> On my system, this happens with caches like kmem_cache, mm_struct, pid,
> task_struct, sighand_cache, xfs_inode, and others.
> 
> To place the slabobj_ext metadata within each object, the existing
> slab_obj_ext() logic can still be used by setting:
> 
>   - slab->obj_exts = slab_address(slab) + s->red_left_zone +
>                      (slabobj_ext offset)
>   - stride = s->size
> 
> slab_obj_ext() doesn't need know where the metadata is stored,
> so this method works without adding extra overhead to slab_obj_ext().
> 
> A good example benefiting from this optimization is xfs_inode
> (object_size: 992, align: 64). To measure memory savings, 2 millions of
> files were created on XFS.
> 
> [ MEMCG=y, MEM_ALLOC_PROFILING=n ]
> 
> Before patch (creating ~2.64M directories on xfs):
>   Slab:            5175976 kB
>   SReclaimable:    3837524 kB
>   SUnreclaim:      1338452 kB
> 
> After patch (creating ~2.64M directories on xfs):
>   Slab:            5152912 kB
>   SReclaimable:    3838568 kB
>   SUnreclaim:      1314344 kB (-23.54 MiB)
> 
> Enjoy the memory savings!
> 
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  include/linux/slab.h |  9 ++++++
>  mm/slab_common.c     |  6 ++--
>  mm/slub.c            | 73 ++++++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 83 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 4554c04a9bd7..da512d9ab1a0 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -59,6 +59,9 @@ enum _slab_flag_bits {
>  	_SLAB_CMPXCHG_DOUBLE,
>  #ifdef CONFIG_SLAB_OBJ_EXT
>  	_SLAB_NO_OBJ_EXT,
> +#endif
> +#if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
> +	_SLAB_OBJ_EXT_IN_OBJ,
>  #endif
>  	_SLAB_FLAGS_LAST_BIT
>  };
> @@ -244,6 +247,12 @@ enum _slab_flag_bits {
>  #define SLAB_NO_OBJ_EXT		__SLAB_FLAG_UNUSED
>  #endif
>  
> +#if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
> +#define SLAB_OBJ_EXT_IN_OBJ	__SLAB_FLAG_BIT(_SLAB_OBJ_EXT_IN_OBJ)
> +#else
> +#define SLAB_OBJ_EXT_IN_OBJ	__SLAB_FLAG_UNUSED
> +#endif
> +
>  /*
>   * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
>   *
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index c4cf9ed2ec92..f0a6db20d7ea 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -43,11 +43,13 @@ DEFINE_MUTEX(slab_mutex);
>  struct kmem_cache *kmem_cache;
>  
>  /*
> - * Set of flags that will prevent slab merging
> + * Set of flags that will prevent slab merging.
> + * Any flag that adds per-object metadata should be included,
> + * since slab merging can update s->inuse that affects the metadata layout.
>   */
>  #define SLAB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
>  		SLAB_TRACE | SLAB_TYPESAFE_BY_RCU | SLAB_NOLEAKTRACE | \
> -		SLAB_FAILSLAB | SLAB_NO_MERGE)
> +		SLAB_FAILSLAB | SLAB_NO_MERGE | SLAB_OBJ_EXT_IN_OBJ)
>  
>  #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
>  			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT)
> diff --git a/mm/slub.c b/mm/slub.c
> index 50b74324e550..43fdbff9d09b 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -977,6 +977,39 @@ static inline bool obj_exts_in_slab(struct kmem_cache *s, struct slab *slab)
>  {
>  	return false;
>  }
> +
> +#endif
> +
> +#if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
> +static bool obj_exts_in_object(struct kmem_cache *s)
> +{
> +	return s->flags & SLAB_OBJ_EXT_IN_OBJ;
> +}
> +
> +static unsigned int obj_exts_offset_in_object(struct kmem_cache *s)
> +{
> +	unsigned int offset = get_info_end(s);
> +
> +	if (kmem_cache_debug_flags(s, SLAB_STORE_USER))
> +		offset += sizeof(struct track) * 2;
> +
> +	if (slub_debug_orig_size(s))
> +		offset += sizeof(unsigned long);
> +
> +	offset += kasan_metadata_size(s, false);
> +
> +	return offset;
> +}
> +#else
> +static inline bool obj_exts_in_object(struct kmem_cache *s)
> +{
> +	return false;
> +}
> +
> +static inline unsigned int obj_exts_offset_in_object(struct kmem_cache *s)
> +{
> +	return 0;
> +}
>  #endif
>  
>  #ifdef CONFIG_SLUB_DEBUG
> @@ -1277,6 +1310,9 @@ static void print_trailer(struct kmem_cache *s, struct slab *slab, u8 *p)
>  
>  	off += kasan_metadata_size(s, false);
>  
> +	if (obj_exts_in_object(s))
> +		off += sizeof(struct slabobj_ext);
> +
>  	if (off != size_from_object(s))
>  		/* Beginning of the filler is the free pointer */
>  		print_section(KERN_ERR, "Padding  ", p + off,
> @@ -1446,7 +1482,10 @@ check_bytes_and_report(struct kmem_cache *s, struct slab *slab,
>   * 	A. Free pointer (if we cannot overwrite object on free)
>   * 	B. Tracking data for SLAB_STORE_USER
>   *	C. Original request size for kmalloc object (SLAB_STORE_USER enabled)
> - *	D. Padding to reach required alignment boundary or at minimum
> + *	D. KASAN alloc metadata (KASAN enabled)
> + *	E. struct slabobj_ext to store accounting metadata
> + *	   (SLAB_OBJ_EXT_IN_OBJ enabled)
> + *	F. Padding to reach required alignment boundary or at minimum
>   * 		one word if debugging is on to be able to detect writes
>   * 		before the word boundary.
>   *
> @@ -1474,6 +1513,9 @@ static int check_pad_bytes(struct kmem_cache *s, struct slab *slab, u8 *p)
>  
>  	off += kasan_metadata_size(s, false);
>  
> +	if (obj_exts_in_object(s))
> +		off += sizeof(struct slabobj_ext);
> +
>  	if (size_from_object(s) == off)
>  		return 1;
>  
> @@ -2280,7 +2322,8 @@ static inline void free_slab_obj_exts(struct slab *slab)
>  		return;
>  	}
>  
> -	if (obj_exts_in_slab(slab->slab_cache, slab)) {
> +	if (obj_exts_in_slab(slab->slab_cache, slab) ||
> +			obj_exts_in_object(slab->slab_cache)) {
>  		slab->obj_exts = 0;
>  		return;
>  	}
> @@ -2326,6 +2369,23 @@ static void alloc_slab_obj_exts_early(struct kmem_cache *s, struct slab *slab)
>  			obj_exts |= MEMCG_DATA_OBJEXTS;
>  		slab->obj_exts = obj_exts;
>  		slab_set_stride(slab, sizeof(struct slabobj_ext));
> +	} else if (obj_exts_in_object(s)) {
> +		unsigned int offset = obj_exts_offset_in_object(s);
> +
> +		obj_exts = (unsigned long)slab_address(slab);
> +		obj_exts += s->red_left_pad;
> +		obj_exts += offset;
> +
> +		get_slab_obj_exts(obj_exts);
> +		for_each_object(addr, s, slab_address(slab), slab->objects)
> +			memset(kasan_reset_tag(addr) + offset, 0,
> +			       sizeof(struct slabobj_ext));
> +		put_slab_obj_exts(obj_exts);
> +
> +		if (IS_ENABLED(CONFIG_MEMCG))
> +			obj_exts |= MEMCG_DATA_OBJEXTS;
> +		slab->obj_exts = obj_exts;
> +		slab_set_stride(slab, s->size);
>  	}
>  }
>  
> @@ -8023,6 +8083,7 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
>  {
>  	slab_flags_t flags = s->flags;
>  	unsigned int size = s->object_size;
> +	unsigned int aligned_size;
>  	unsigned int order;
>  
>  	/*
> @@ -8132,7 +8193,13 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
>  	 * offset 0. In order to align the objects we have to simply size
>  	 * each object to conform to the alignment.
>  	 */
> -	size = ALIGN(size, s->align);
> +	aligned_size = ALIGN(size, s->align);
> +#if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
> +	if (aligned_size - size >= sizeof(struct slabobj_ext))
> +		s->flags |= SLAB_OBJ_EXT_IN_OBJ;
> +#endif
> +	size = aligned_size;
> +
>  	s->size = size;
>  	s->reciprocal_size = reciprocal_value(size);
>  	order = calculate_order(size);
> -- 
> 2.43.0
> 

