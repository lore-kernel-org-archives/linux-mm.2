Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9064A60A263F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VYQ6iK1v
Received: by kanga.kvack.org (Postfix)
	id 9358D6B00EF; Wed, 18 Nov 2026 11:24:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90E4E6B05B2; Wed, 18 Nov 2026 11:24:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 823C86B05B9; Wed, 18 Nov 2026 11:24:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2189C6B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:24:28 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 826F84060A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:24:27 +0000 (UTC)
X-FDA: 85448762574.10.4EA4E6B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id AD54320006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:24:25 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VYQ6iK1v;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795019065;
	b=1EZQXI/fS1lbZXJrjqDvynWlrsZYZ/pNzaDE2pD/ZLajKWfCojpPtj6/32SxIyQu7u21Mb
	+1MExeEMcZz8qmhe1tbmxnKcMRUFnYlR3/nrYd77cQOiCrDUA3qKfy6VZvqirUV7zhe/W7
	A51SsxNmnYxoGb4mbTRwbpRf9ih4QLg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VYQ6iK1v;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795019065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hyyvwqh0yUCrKvJZHku7usPSuKgxk7/6YeOVXPVE234=;
	b=faKZRH0oFLqk1R4Cjq5kvViIu7SIYj+ylLLRNbbVruWrX7xBXAta/UJN1C0fZAF35KsuAZ
	r9U6/JrG1bnE8w7H9vNGGOqLXQONovKAZ8He2dSjdiSqmv+NKtfxEg3law64ZP1swdy4Zl
	yoe7b8G+rbLDtSYW0iQhKVsBtWvSUfM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DF59946621;
	Wed, 18 Nov 2026 16:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDEF51F000C5;
	Wed, 18 Nov 2026 16:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795019064;
	bh=hyyvwqh0yUCrKvJZHku7usPSuKgxk7/6YeOVXPVE234=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VYQ6iK1vi6FHFW84MrhdkFONbt4aEau9XczusyK5CLhQaKISBgiYb9QEf+pMVSAZC
	 7CS7yb2kyDszUaZVo4m6EjIIYx0AgTpRIGFoJqZ2l0THzAAC7tCdolmeWTJk0hVT+j
	 vLYFsbBA1lZ173kFzYIBhEhmgyd0/XlKq8bTr3s8YbxDYXdRv/ou8P1BCjbckSoiqw
	 6YroToxg40CQAFHKtUr5oGvZ+98pujuxWDEuGK11S2xMJtqrCBH0GV7397ngf3xNC9
	 vtzs8fYfKBNXsug2DAwNIrwmN+t1++HWGwVk/IO/HD+jAyxv+l2X3Hmymi/9B8sNn0
	 mWvWbR9ojFiVQ==
Message-ID: <02c600ac-c968-4143-9e70-ccd2da858e09@kernel.org>
Date: Wed, 18 Nov 2026 17:24:19 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v3 4/7] mm/slab: fix a deadlock in
 memcg_alloc_abort_single()
Content-Language: en-US
To: "Harry Yoo (Meta)" <harry@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 Sashiko <sashiko-bot@kernel.org>
References: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
 <20261115-kmalloc-nolock-fixes-v3-4-9034dd4ecaab@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261115-kmalloc-nolock-fixes-v3-4-9034dd4ecaab@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AD54320006
X-Stat-Signature: 1wbgdyxxifd8h7z7s7z4wedscbqgc199
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795019065-403766
X-HE-Meta: U2FsdGVkX1/p8KFvf9lDbJ5ITrpUfk113I2VURvX2A9Yb6npKqZw5ar2deOKBsBJyVGwXbOSqf21qzN0Twzhhg5jZ8jyCrSqsO3FM9p1yeDU6rvviTYPsuBjL+1pbPtj5sTVzEcv1/Bus+M46FaNaNDbCDiYUCAqza/Q5NxRga9s2h6yfDuDrB+YYZhYXgD8Flf10NU0mkuamdfCh+HDI6H0T5s0HBwDXuVBoakX3je6NV3FeDcYLOaAvYgwTqSp+mGpYsdKKO1DAeOvws6Pqzn2cnapH7KzXMN3WO15epGqNSUp5TV5xOL/SKAqHcJ2g6ZwDJBu/wqIQ936dt1EPeGJ4uW4oy869HFoz65++9sOIJfKjIcs0d4ozdcWlDJnB95vRNXdpK1FVFK3RDks4Fek7oOX6zaKE85hYpRAGnlSnOA7PC5vm5PaCwRS2brxxL7FcoFoWsNG7/uHel6LBdtvgAsRKBNNF1BRBkk5WPrFhvvVNQqVV8uiXhggW4rnDY/G6OubOwcXg0Ir6j3sBkiqrp79kYhxyFh3KQM2PnQ2lNitPVFMxNDHXlv8dehn/w1zI2aoWOdMAWz3xEDyFsiApQONXsu3ZfS+yjyMs9CPsGajQJHYkreDHOkmVOF2gyxrKbj1vaIuNdNh1DM5u0L5SB7W/uh40/Hza4XG1xmFrFVCPMp/nmVqbctqW5hcCiS3gN2zpxH5HS97ZJscERN07rL6GMX0jBbgpvq1vsLHSoCwYLI2FPd+y9ewaxFAksf6GIMvkFXROok410FcEZkwSyd7GMl2cG9ERZRarAzXUm3Q+ypIOzhYu6DJm3nVI17aUXDn7eQt0kySaMiaCP3VZlC1faQeYIekeItvvwJNnsJ5a/98LZ5cGpyDKUlkxA/Mj9hAW4kD+e8pmhbWOxRmREvEGt4/qCZXbWs+yWV6s3kjzfSWFpVu8inWK2RA814bUeF1pdGHhTnIyBc
 450OZVeN
 VvcO/uJGT7w2Nvr0qPF7AJWZaWg954FZQE0N4xOXBYb3FOdc3rNKYyMT0jsZOQS4MpbKauubHgeGL+/pUA5JNMfBzFJbBqehM/Qzyh+IkLzV3RTf9+cPAlbHdkR8PC6irsb0k9Szw3oRoxbSQYpT6w+S9OR89AvS2yCPWapoM0+QSUx68XtFzW0a24PTSaug/CipLYmfrTeDl7y1hC52T1zfZo6v9G5V4TwPGDdmVR6H1H6lTV2+jSmD1LaPsrtWg3dy53y6EPNCy5qE7vohOfbICJoMqvWi0IjHt4vDYkdNzwcojl/jwk3Mxm7CSnj6C4u61nErluiGEnTgIqLuLKDeR0TJlO7+4yByxhRyUVJCsUAjeypMvCU0rnTI7y25IQ05vO9nbP/tkKsg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/15/26 16:09, Harry Yoo (Meta) wrote:
> When kmalloc_nolock() successfully grabs a slab object but memcg aborts
> the allocation, the object is freed via __slab_free(). Calling
> __slab_free() in unknown context is not allowed and can lead to a
> deadlock.
> 
> Free the object via defer_free() when spinning is not allowed.
> 
> While at it, try freeing the object to the percpu sheaves first in both
> contexts, as kmem_cache_free_bulk() already does for bulk allocations.
> This also avoids queueing an irq_work for every failed charge when
> spinning is not allowed.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260610-slab_alloc_flags-v2-0-7190909db118%40kernel.org?part=9
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

nit (not worth respinning just for that)

> ---
>  mm/slab.h |  8 ++++++++
>  mm/slub.c | 22 +++++++++++++++++-----
>  2 files changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index 15b0d98ae1d4..fb80a72ad952 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -37,6 +37,14 @@ static inline unsigned int to_alloc_flags(unsigned int free_flags)
>  		return SLAB_ALLOC_DEFAULT;
>  }
>  
> +static inline unsigned int to_free_flags(unsigned int alloc_flags)
> +{
> +	if (alloc_flags & SLAB_ALLOC_NOLOCK)
> +		return SLAB_FREE_NOLOCK;
> +	else
> +		return SLAB_FREE_DEFAULT;
> +}
> +
>  static inline bool alloc_flags_allow_spinning(const unsigned int alloc_flags)
>  {
>  	return !(alloc_flags & SLAB_ALLOC_NOLOCK);
> diff --git a/mm/slub.c b/mm/slub.c
> index 7c0adc104988..8252c0b681cc 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2531,7 +2531,8 @@ static inline void slab_obj_ext_has_codetag_init(void)
>  
>  #ifdef CONFIG_MEMCG
>  
> -static void memcg_alloc_abort_single(struct kmem_cache *s, void *object);
> +static void memcg_alloc_abort_single(struct kmem_cache *s, void *object,
> +				     unsigned int alloc_flags);
>  
>  static __fastpath_inline
>  bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
> @@ -2549,7 +2550,7 @@ bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
>  		return true;
>  
>  	if (likely(size == 1)) {
> -		memcg_alloc_abort_single(s, *p);
> +		memcg_alloc_abort_single(s, *p, ac->alloc_flags);
>  		*p = NULL;
>  	} else {
>  		kmem_cache_free_bulk(s, size, p);
> @@ -6647,18 +6648,29 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
>  #ifdef CONFIG_MEMCG
>  /* Do not inline the rare memcg charging failed path into the allocation path */
>  static noinline
> -void memcg_alloc_abort_single(struct kmem_cache *s, void *object)
> +void memcg_alloc_abort_single(struct kmem_cache *s, void *object,
> +			      unsigned int alloc_flags)
>  {
>  	struct slab *slab = virt_to_slab(object);
> -	unsigned int free_flags = SLAB_FREE_DEFAULT;
> +	bool allow_spin = alloc_flags_allow_spinning(alloc_flags);
> +	unsigned int free_flags = to_free_flags(alloc_flags);
>  
>  	if (slab_want_init_on_free(s))
>  		free_flags |= SLAB_FREE_INIT;
>  
>  	alloc_tagging_slab_free_hook(s, slab, &object, 1);
>  
> -	if (likely(slab_free_hook(s, object, free_flags)))
> +	if (unlikely(!slab_free_hook(s, object, free_flags)))
> +		return;
> +
> +	if (likely(can_free_to_pcs(slab)) &&
> +	    likely(free_to_pcs(s, object, allow_spin)))

I think it could be a single likely(x && y)

> +		return;
> +
> +	if (likely(allow_spin))
>  		__slab_free(s, slab, object, object, 1, _RET_IP_);
> +	else
> +		defer_free(s, object);
>  }
>  #endif
>  
> 


