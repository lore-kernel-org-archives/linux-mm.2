Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62680606A33F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oIaS/a3c
Received: by kanga.kvack.org (Postfix)
	id 6F97C6B05B0; Wed, 18 Nov 2026 11:32:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AB096B05B2; Wed, 18 Nov 2026 11:32:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 598C36B05B5; Wed, 18 Nov 2026 11:32:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 29AEA6B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:32:28 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A8066407DD
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:32:27 +0000 (UTC)
X-FDA: 85448782734.02.048E24D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id DC92E2000F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:32:25 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="oIaS/a3c";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795019546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=drTtZs8QFnjtIGUvlZc1Bgt1LjubynbTgCVephC51cc=;
	b=YF3GLzuzaQCr8Brfn/Kk6ZAZV5z0H5u63sWrKJqcPxTiXm5Rl0tdJc1iO/LELfrV06Yo6W
	6eo4x/4mgRfJEKmVgnSg88IsxljNeOYPC+wxP/eZ9a0cMzUw7PXKPpY30xYPgbP9FrTCgl
	0GC1/7xaBhQQPjO938pANiEa7aXh7yA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="oIaS/a3c";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795019546;
	b=hTvCIvOVDdC9FCzM1cmcT5vhNB0X6Ah7ateKWCD4HJbB3oCBN1eNF2REhS6ZG0+GEZ+Qss
	L5WUR7oeRBGGSRWrLsg8fcjdFRj2JZ3cMsftnOHUjfWO7YoTWzMNFf1oK/59RLa8FaVpWB
	BEL30vT3Htl/J481VLw63Pg3w4nl2UQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 696936297A;
	Wed, 18 Nov 2026 16:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6879D1F000D2;
	Wed, 18 Nov 2026 16:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795019545;
	bh=drTtZs8QFnjtIGUvlZc1Bgt1LjubynbTgCVephC51cc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oIaS/a3cfNudxVlDn5leymKjxjIpsE1Vf/XCpG8UczJek/Q4u4Dqylb8AEqRlQhl2
	 oRtte00LwzlC4dvtHWudaypqe596Lu44XALxqq02bnhPzEakS38NQ/XcIBF7pSIn3P
	 wXNK2QR00Cbr/Qn5INqFMK1tYyvLnCaRfGmemwfYD5SngczyLPM891HvA0jp0P8X3V
	 aZ11nskgCxd4vvsT3spKu18qH/NV0zfVvdrge+zBylheS3rnDM8x3iHzDe0MkQ0yRE
	 T5GwrsFIHbFoZYCZaFy+5vh4v1IpvgXTfxs1uJ/7bdG62RKO4nD5830VbxfouC8S4s
	 yaCtNvLe5Atlw==
Message-ID: <49cf1965-7466-42c3-bc9d-9097cc223c81@kernel.org>
Date: Wed, 18 Nov 2026 17:32:19 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v3 6/7] mm/slab: refactor free_to_pcs()
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
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
References: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
 <20261115-kmalloc-nolock-fixes-v3-6-9034dd4ecaab@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261115-kmalloc-nolock-fixes-v3-6-9034dd4ecaab@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DC92E2000F
X-Rspam-User: 
X-Stat-Signature: mb1wyczmrr6m3kzwyha86yiykwxnw8ou
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795019545-865138
X-HE-Meta: U2FsdGVkX1/soJN3vfh+qGetmd/Arr/RsiAFrvYbNy7yzocatnOYPoL8YB8CL1qffr1w8rRgASmJZAsVIv9sHi1ZfXbfHkaobCQ8fwyfdN4uGXrOSBekhHkNpt5rD9F8mfaPNvuG0vWQJcAcdr5nVQVufrmSIjeYF4RQ+0PDNqtxgpDgsoV+ZRnobQi/Owj/sblw7qHwuxNdmSqZNNrX4XpGC1WdiBDjaPlYS739cOLzAGRQ7YaWQG6PcoLV5nTdq/Lh318mnwhV2cEaeVoAQTZPlpfomRsL3VbQ60F5PZiS+gHnY8vZXimD/bh4VgqN8seJ7GtJoUZWs1TKK9HUWnjATKXocVF6Az2zrlREO9Nykw6ECzjRfioFJvQwOMdrA3nk/6Q8BpVQzzvajBds7CHLFYcDknyx0pJV1jUjp+NJUFO9omkp0T91NlnROx/EdFemcAfJFyBxfHkOjauEsQAdy8EbbWL5vyh2meQu8tkYnZs2gP+iPX+m8jctzZPxr0oKBEOuoUJpllmlQWR4Yp+i9x/BNpuffx12Nn3eTj0xQcc5BYPxg19MTL0rd+eAimIeJbS13LWmPa6dqrVaSYjaPentmtqgY4LsOxaUavL91bdyVmD/9Hxv86sQDpgX/E/drNJXnfjWMR8bjW7u6D/kkgKtVRbrt8bg7+A0ZHDaiBEty5M6rF4b2zaFB40AT/TjpDZVFQQtjm6bHx6IquJbkn3U2rop4XTx0ZvlroB9fuFxgt1ZG1V4ns39V4ZhMB8yetz9oKwpkxJ/iU1obxMe/D6gxMJbXAWZZaJgEVfelD4rkmfr1Ljv3lKF6eTyZWN0lApvZqocgahWdarq0MSQ06k0u2BwUgYx4viRkH94KChEKpCdJjutmsmn0L5JKUcps8kdniKmLsA021JVR8bVKcfiW4G6feBdZDsRl2I+zOcR4sRo+8MErQyblL4CRTd/7EHS8Wgfk5HD/0+
 tz9d9RXw
 d/DzTTXqXKIS0k7ss52x4H72x8a86oHF90zVtxx+0Z465RLIPIXQBAwfIXZ+hujlGj2Oie3vylp/yFRIrDSAlH6VPtoYgRMAxassae6dJ6TypP4TT39O5ckxCu0flWcfeLeogYI9h6gFJW9C6NrBU0s6EMA+tr1wQ21JmAQJAfXweqMjlN31+4hEIzcq9fgWAlCTUIk9zh8XleS7LPV+NbE2qJpshzejlK/XAQltl3xzU+7fsaXGCasID2w8og1tvVEn0cmaHxcAu3wExNRGB0gmaAVGqi42lOoHe4JVZtT1T4ZwaLrq+6Z3mFqG11tgZTV+X2+WiRQGN6Is=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/15/26 16:09, Harry Yoo (Meta) wrote:
> Every caller of free_to_pcs() has to call can_free_to_pcs() before it.
> Refactor this by adding a slab parameter and calling can_free_to_pcs()
> from free_to_pcs(). To do this, move can_free_to_pcs() above
> free_to_pcs().
> 
> Note that can_free_to_pcs() cannot be folded into free_to_pcs() as
> free_to_pcs_bulk() still needs it.
> 
> While at it, let free_to_pcs() take free_flags instead of allow_spin.
> 
> No functional change intended.
> 
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>

Nice.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

I see that makes the nit for 4/7 immaterial.
But I have a new one :)

> ---
>  mm/slub.c | 119 ++++++++++++++++++++++++++++++++------------------------------
>  1 file changed, 61 insertions(+), 58 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index aec9fb6e2235..fd3de3bee1de 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6148,15 +6148,71 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>  	return pcs;
>  }
>  
> +static __always_inline bool can_free_to_pcs(struct slab *slab)
> +{
> +	int slab_node;
> +	int numa_node;
> +
> +	if (!IS_ENABLED(CONFIG_NUMA))
> +		goto check_pfmemalloc;
> +
> +	slab_node = slab_nid(slab);
> +
> +#ifdef CONFIG_HAVE_MEMORYLESS_NODES
> +	/*
> +	 * numa_mem_id() points to the closest node with memory so only allow
> +	 * objects from that node to the percpu sheaves
> +	 */
> +	numa_node = numa_mem_id();
> +
> +	if (likely(slab_node == numa_node))
> +		goto check_pfmemalloc;
> +#else
> +
> +	/*
> +	 * numa_mem_id() is only a wrapper to numa_node_id() which is where this
> +	 * cpu belongs to, but it might be a memoryless node anyway. We don't
> +	 * know what the closest node is.
> +	 */
> +	numa_node = numa_node_id();
> +
> +	/* freed object is from this cpu's node, proceed */
> +	if (likely(slab_node == numa_node))
> +		goto check_pfmemalloc;
> +
> +	/*
> +	 * Freed object isn't from this cpu's node, but that node is memoryless
> +	 * or only has ZONE_MOVABLE memory, which slab cannot allocate from.
> +	 * Proceed as it's better to cache remote objects than falling back to
> +	 * the slowpath for everything. The allocation side can never obtain
> +	 * a local object anyway, if none exist. We don't have numa_mem_id() to
> +	 * point to the closest node as we would on a proper memoryless node
> +	 * setup.
> +	 */
> +	if (unlikely(!node_state(numa_node, N_NORMAL_MEMORY)))
> +		goto check_pfmemalloc;
> +#endif
> +
> +	return false;
> +
> +check_pfmemalloc:
> +	return likely(!slab_test_pfmemalloc(slab));
> +}
> +
>  /*
>   * Free an object to the percpu sheaves.
>   * The object is expected to have passed slab_free_hook() already.
>   */
>  static __fastpath_inline
> -bool free_to_pcs(struct kmem_cache *s, void *object, bool allow_spin)
> +bool free_to_pcs(struct kmem_cache *s, struct slab *slab, void *object,
> +		 unsigned int free_flags)
>  {
> +	bool allow_spin = free_flags_allow_spinning(free_flags);

This could be moved to the if () block below that actually uses allow_spin.

>  	struct slub_percpu_sheaves *pcs;
>  
> +	if (unlikely(!can_free_to_pcs(slab)))
> +		return false;
> +
>  	if (!local_trylock(&s->cpu_sheaves->lock))
>  		return false;
>  
> @@ -6355,57 +6411,6 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
>  	return false;
>  }
>  
> -static __always_inline bool can_free_to_pcs(struct slab *slab)
> -{
> -	int slab_node;
> -	int numa_node;
> -
> -	if (!IS_ENABLED(CONFIG_NUMA))
> -		goto check_pfmemalloc;
> -
> -	slab_node = slab_nid(slab);
> -
> -#ifdef CONFIG_HAVE_MEMORYLESS_NODES
> -	/*
> -	 * numa_mem_id() points to the closest node with memory so only allow
> -	 * objects from that node to the percpu sheaves
> -	 */
> -	numa_node = numa_mem_id();
> -
> -	if (likely(slab_node == numa_node))
> -		goto check_pfmemalloc;
> -#else
> -
> -	/*
> -	 * numa_mem_id() is only a wrapper to numa_node_id() which is where this
> -	 * cpu belongs to, but it might be a memoryless node anyway. We don't
> -	 * know what the closest node is.
> -	 */
> -	numa_node = numa_node_id();
> -
> -	/* freed object is from this cpu's node, proceed */
> -	if (likely(slab_node == numa_node))
> -		goto check_pfmemalloc;
> -
> -	/*
> -	 * Freed object isn't from this cpu's node, but that node is memoryless
> -	 * or only has ZONE_MOVABLE memory, which slab cannot allocate from.
> -	 * Proceed as it's better to cache remote objects than falling back to
> -	 * the slowpath for everything. The allocation side can never obtain
> -	 * a local object anyway, if none exist. We don't have numa_mem_id() to
> -	 * point to the closest node as we would on a proper memoryless node
> -	 * setup.
> -	 */
> -	if (unlikely(!node_state(numa_node, N_NORMAL_MEMORY)))
> -		goto check_pfmemalloc;
> -#endif
> -
> -	return false;
> -
> -check_pfmemalloc:
> -	return likely(!slab_test_pfmemalloc(slab));
> -}
> -
>  /*
>   * Try to free as many objects (already processed by free hooks) as possible to
>   * a single per-cpu sheaf.
> @@ -6642,7 +6647,7 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
>  	if (unlikely(!slab_free_hook(s, object, free_flags)))
>  		return;
>  
> -	if (likely(can_free_to_pcs(slab)) && likely(free_to_pcs(s, object, true)))
> +	if (likely(free_to_pcs(s, slab, object, free_flags)))
>  		return;
>  
>  	__slab_free(s, slab, object, object, 1, addr);
> @@ -6656,7 +6661,6 @@ void memcg_alloc_abort_single(struct kmem_cache *s, void *object,
>  			      unsigned int alloc_flags)
>  {
>  	struct slab *slab = virt_to_slab(object);
> -	bool allow_spin = alloc_flags_allow_spinning(alloc_flags);
>  	unsigned int free_flags = to_free_flags(alloc_flags);
>  
>  	if (slab_want_init_on_free(s))
> @@ -6667,11 +6671,10 @@ void memcg_alloc_abort_single(struct kmem_cache *s, void *object,
>  	if (unlikely(!slab_free_hook(s, object, free_flags)))
>  		return;
>  
> -	if (likely(can_free_to_pcs(slab)) &&
> -	    likely(free_to_pcs(s, object, allow_spin)))
> +	if (likely(free_to_pcs(s, slab, object, free_flags)))
>  		return;
>  
> -	if (likely(allow_spin))
> +	if (likely(free_flags_allow_spinning(free_flags)))
>  		__slab_free(s, slab, object, object, 1, _RET_IP_);
>  	else
>  		defer_free(s, object);
> @@ -6991,7 +6994,7 @@ void kfree_nolock(const void *object)
>  	if (unlikely(!slab_free_hook(s, x, free_flags)))
>  		return;
>  
> -	if (likely(can_free_to_pcs(slab)) && likely(free_to_pcs(s, x, false)))
> +	if (likely(free_to_pcs(s, slab, x, free_flags)))
>  		return;
>  
>  	/*
> 


