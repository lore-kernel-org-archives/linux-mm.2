Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 037CDEA3F2A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 08:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 484496B0005; Tue, 10 Feb 2026 03:58:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 408106B0088; Tue, 10 Feb 2026 03:58:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 313EE6B0089; Tue, 10 Feb 2026 03:58:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1D1B46B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 03:58:03 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ADD7113AF3B
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:58:02 +0000 (UTC)
X-FDA: 84427944804.21.9BC700C
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8761F40002
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:58:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jYSsHnVe;
	spf=pass (imf11.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770713881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pgS3tbDE1ZyYK6CATj5OF3KOOqeRyavEk9RYHzNQJew=;
	b=c9PYXj/637MfHcoJNKbpzi0N84ze89D0QRyqloAtu9CWMHkNVY2Orn3UNOEoLfy7jHZJ3a
	JgmU00EbB16TZGZ2BxtxnUy0i8yJ7LiLEinLmaoTo0IYfJz+IFokqQ+AgfSW2cwK/rkpkZ
	nMw+T5JOYFFIr1u/Xk6US4OMlUgncPg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jYSsHnVe;
	spf=pass (imf11.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770713881; a=rsa-sha256;
	cv=none;
	b=1MdcMxvjrTIPyCaVDRwKF30loFFTVK0VwRDbDTaRM5zUYxezC5A2/sdkZX/9aGpeqE0aY5
	7TBYmYLb1CCdPZMjTtEMu/fSKLnF/j8O+H7OP6WgLzEvhdm9XWZhyh5JWllvG3G7vIHDrQ
	+wWskyakEtN55IO+mng1DOT7KwHiGfU=
Date: Tue, 10 Feb 2026 16:57:42 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770713878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pgS3tbDE1ZyYK6CATj5OF3KOOqeRyavEk9RYHzNQJew=;
	b=jYSsHnVekMuInRbl570vgwJCbb4eg8UtX1x9VrP5LOBh18UuSN8uZI/pAbCEpROjMHjRPh
	c9hCmJsII+G86w65FWyqmGDSeh3el/GpElR7SVOMRC+mpVATB8KOVjUbqfmGCK3u6XJJlK
	9106JnHld+sEZDORWVb/TSTir4cP+/s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH V2 2/2] mm/slab: drop the OBJEXTS_NOSPIN_ALLOC flag from
 enum objext_flags
Message-ID: <ym376ht2w32x3zmfpteiezo6goelaiokvk6ujgp4imdwpw6o2s@tz2f5hvm3ezs>
References: <20260210044642.139482-1-harry.yoo@oracle.com>
 <20260210044642.139482-3-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260210044642.139482-3-harry.yoo@oracle.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 8761F40002
X-Rspamd-Server: rspam07
X-Stat-Signature: g79ynp663msuzqiugor9fkckin7p9qxt
X-HE-Tag: 1770713880-308516
X-HE-Meta: U2FsdGVkX1+v8CnsbHLT1Lp5oWMi8Ezunr+JVuVmTYyYsExr2dm37FZCL79mzXhyjHsdd5VpenN4AThqnhLU3mga6HizDbJwg044hDSeA80c8MLCjn2p7MfK1COTxFXuRcpUiTxhdxIHtNH6gKRGiWaZwjQ7Ph1DpPz4hvkj43X0TPZ5hm5b++VL3MS3S9afPUxYrX4g88j+ShHebWCQxu+bqJC004YHOKvGnWQI0pXIg+T5pnSGYBCXNvlTWKTyYphuOjehHNQMW9efATcVb2Oa/lp0ZhPK4v4boSkmskBSmMXxEUJRIp1J7yPzfxSks2+lorT9rBYYr7D3XbGvvXRdJv+LbUGfT7/pcCWmhOcbVj4s8fYNILsYDYfWPJp8gna+06sCwCucoapjee+66xdydV1YH8g3p5+ksDH2INA5K5LWCaQQmUY8BKL9E4P4UDCxRlx08vt6gObgR8o5U76+o6LlP1QHQcqDN+KeBeueSDh4dYK5dAoTqsldbqpjyF1YLIvNTy27R6ewBlN9qBgZaaWeweQjCnaPkfZBCLWTj6C8nuWTodjPD4Yxw889iK8cvB63ml9LP9pgAXkkK/wTAxHxPPkIPfOhxUBPiHGUXa0uygrDKTBzG1TEqSnah3sRGWTDTuVcE4gr9bmxMEgSjP5R15rj7SnHPLZTNQlMH4Edlnpu1YHcHjB/iJJPtC1VRhX65fAVgxB52XPb8Fwh4nJ2MNwvtOawWwNddtb8KlQsDaVzgKwr6Z0ubp5f33U5hVMoi6Wrslj7YUKJn9AQfzzloUSEFXOl18VqCz2fhfVvnGUIfStUhnBz7oGzaz+7UlFZSfGANvj1itDnEpiH79eSxOE0qkjE1sunzQkEnSDXF6jjcQCYb3j8c4LKmb0CSaBdGp1Oqt9m/QL/qLRQtfItmD3EW3VgrSTn+xnh9YwD4Fx9cO1c5uN22vMAkwEvnx7+DBCYc4vvs/Q
 PFLJPPnB
 /i+t4HxFmSjMD0dQqxVil2yuCVperWZJbL60PH8iY+EmfOwlcBOlj3KHT2fZpNkN+sM/MxLg7qUFcCoIRZ5ze3nf2gM7KLvTmfK3f+4YXgnJcB2SUAv5iaGAYad+FdjLHrtkWJmciBeFV9q4sNX5SG1dZIVI0n2w8OP8hvJBh3YXn4xaRsiiQMeyEq2LjW6Aszx2/LL7FCBM4py0UkZQKxn71MzThZqesEU+4OWJxLNGKOYVDxm+4W/6kqLav7+XZzlyntVarEtdEkAGa7M6eEmLLRI3cMS6izXlP/+Rf13E03A4eIjIAdiqhFXEmE+f9Hy9O+4b4qGifvns=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 01:46:42PM +0900, Harry Yoo wrote:
> OBJEXTS_NOSPIN_ALLOC was used to remember whether a slabobj_ext vector
> was allocated via kmalloc_nolock(), so that free_slab_obj_exts() could
> call kfree_nolock() instead of kfree().
> 
> Now that kfree() supports freeing kmalloc_nolock() objects, this flag is
> no longer needed. Instead, pass the allow_spin parameter down to
> free_slab_obj_exts() to determine whether kfree_nolock() or kfree()
> should be called in the free path, and free one bit in
> enum objext_flags.
> 
> Acked-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  include/linux/memcontrol.h |  3 +--
>  mm/slub.c                  | 18 ++++++++----------
>  2 files changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 0651865a4564..bb789ec4a2a2 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -359,8 +359,7 @@ enum objext_flags {
>  	 * MEMCG_DATA_OBJEXTS.
>  	 */
>  	OBJEXTS_ALLOC_FAIL = __OBJEXTS_ALLOC_FAIL,
> -	/* slabobj_ext vector allocated with kmalloc_nolock() */
> -	OBJEXTS_NOSPIN_ALLOC = __FIRST_OBJEXT_FLAG,
> +	__OBJEXTS_FLAG_UNUSED = __FIRST_OBJEXT_FLAG,
>  	/* the next bit after the last actual flag */
>  	__NR_OBJEXTS_FLAGS  = (__FIRST_OBJEXT_FLAG << 1),
>  };
> diff --git a/mm/slub.c b/mm/slub.c
> index 63b03fd62ca7..a73a80b33ff9 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2189,8 +2189,6 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  			virt_to_slab(vec)->slab_cache == s);
>  
>  	new_exts = (unsigned long)vec;
> -	if (unlikely(!allow_spin))
> -		new_exts |= OBJEXTS_NOSPIN_ALLOC;
>  #ifdef CONFIG_MEMCG
>  	new_exts |= MEMCG_DATA_OBJEXTS;
>  #endif
> @@ -2228,7 +2226,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  	return 0;
>  }
>  
> -static inline void free_slab_obj_exts(struct slab *slab)
> +static inline void free_slab_obj_exts(struct slab *slab, bool allow_spin)
>  {
>  	struct slabobj_ext *obj_exts;
>  
> @@ -2256,10 +2254,10 @@ static inline void free_slab_obj_exts(struct slab *slab)
>  	 * the extension for obj_exts is expected to be NULL.
>  	 */
>  	mark_objexts_empty(obj_exts);
> -	if (unlikely(READ_ONCE(slab->obj_exts) & OBJEXTS_NOSPIN_ALLOC))
> -		kfree_nolock(obj_exts);
> -	else
> +	if (allow_spin)
>  		kfree(obj_exts);
> +	else
> +		kfree_nolock(obj_exts);

Looks good to me.

One small observation from my side: at first glance I briefly wondered if we
could ever allocate in an allow_spin=true context but free in an
allow_spin=false context, potentially resulting in a kmalloc() -> kfree_nolock()
mismatch.

After taking a closer look, the only case where "free_new_slab_nolock() -> ...
-> free_slab_obj_exts()" runs with allow_spin=false is along the "___slab_alloc
-> alloc_single_from_new_slab()/alloc_from_new_slab()" path. In that scenario,
alloc_slab_obj_exts() is also called under allow_spin=false and uses
kmalloc_nolock(), so the allocation/free paths remain consistent. So "kmalloc()
-> kfree_nolock()" case can't happen, and the code looks solid to me!

Reviewed-by: Hao Li <hao.li@linux.dev>

>  	slab->obj_exts = 0;
>  }
>  
> @@ -2323,7 +2321,7 @@ static int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  	return 0;
>  }
>  
> -static inline void free_slab_obj_exts(struct slab *slab)
> +static inline void free_slab_obj_exts(struct slab *slab, bool allow_spin)
>  {
>  }
>  
> @@ -3387,14 +3385,14 @@ static __always_inline void account_slab(struct slab *slab, int order,
>  }
>  
>  static __always_inline void unaccount_slab(struct slab *slab, int order,
> -					   struct kmem_cache *s)
> +					   struct kmem_cache *s, bool allow_spin)
>  {
>  	/*
>  	 * The slab object extensions should now be freed regardless of
>  	 * whether mem_alloc_profiling_enabled() or not because profiling
>  	 * might have been disabled after slab->obj_exts got allocated.
>  	 */
> -	free_slab_obj_exts(slab);
> +	free_slab_obj_exts(slab, allow_spin);
>  
>  	mod_node_page_state(slab_pgdat(slab), cache_vmstat_idx(s),
>  			    -(PAGE_SIZE << order));
> @@ -3498,7 +3496,7 @@ static void __free_slab(struct kmem_cache *s, struct slab *slab, bool allow_spin
>  	page->mapping = NULL;
>  	__ClearPageSlab(page);
>  	mm_account_reclaimed_pages(pages);
> -	unaccount_slab(slab, order, s);
> +	unaccount_slab(slab, order, s, allow_spin);
>  	if (allow_spin)
>  		free_frozen_pages(page, order);
>  	else
> -- 
> 2.43.0
> 

