Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A38AEDEC1E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 07:44:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B1026B0088; Wed,  4 Mar 2026 02:44:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25EBF6B0089; Wed,  4 Mar 2026 02:44:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1613B6B008A; Wed,  4 Mar 2026 02:44:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 02FA26B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 02:44:33 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A02B41C5BE
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 07:44:32 +0000 (UTC)
X-FDA: 84507593184.06.DD2CBD2
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf03.hostedemail.com (Postfix) with ESMTP id ACA792000C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 07:44:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Prfd72pi;
	spf=pass (imf03.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772610270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CmH0rlP2i1n3R5SgeOcFWSuLuOaLcRNhakwNeaELXS4=;
	b=U5A8jmi1Evisg7Mi3gG3oun48Kbme8bWKp7Si8zT+7DiRxdlu8a6OtU7PihuivgNOjvIS5
	I5NMnKlFTDjrNSH8QagbDFn3P6TFc5yBhZKafL9pj/74tqUgUfhKLAfhFjHPQpygY2BxD2
	lQMuGYWIvfNH7zNyGykuWSQ462WOrlA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772610270; a=rsa-sha256;
	cv=none;
	b=Iux3CQUduiCFZ4d1z3W8TBG0YM1096YhInXPE0/MlVBVKA6PbQ5MarOrUSu+hsVyUDJ+ps
	wCfagqxDe3CDQuWJTbDf7zhlCxpv89+2luWVIndTmvATlQFI2DCJs8dq1qUX2aI3xz7t1u
	VXYEmzcqUpbXmlU8dE/Eq8ku47wnUFs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Prfd72pi;
	spf=pass (imf03.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 4 Mar 2026 15:44:18 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772610268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CmH0rlP2i1n3R5SgeOcFWSuLuOaLcRNhakwNeaELXS4=;
	b=Prfd72pilPuWrUX3RcEY81R9+5TXX1oI1vfgq0xeekNlyGvzvD0yvA3NguguClWETQcRrd
	IOZKfFtYW8F5Dkgi4J93V4cIWSXfkUSluKtc6pgZfPG+/icJ2keF9E39UcGuegMilURoSZ
	nw2zYUYeEKaLLfqQ3Zqb8LxgPsD3Wr8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH slab/for-next-fixes] mm/slab: allow sheaf refill if
 blocking is not allowed
Message-ID: <3at546the4zbun7g7aoeqrirh46iwsw3vj5ncc4fjhz26gfbb2@tsgplt5o2ybu>
References: <20260302095536.34062-2-vbabka@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302095536.34062-2-vbabka@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ACA792000C
X-Stat-Signature: cq9yprcu8pjaufcss7sfsbkc7yriozrk
X-Rspam-User: 
X-HE-Tag: 1772610270-575752
X-HE-Meta: U2FsdGVkX18yM4Odw6cdFLlFIiApM9fDwxhccekY56wtZK0gt2QjvQGT5W92yS67sl9UzKc1pa0gDeCPln0lLmbYuAburFfKJKdXH9DNMnR/d9NuZ+IB9biLM6CbkhirFjajHZVnE/8DzuuNAuTYZavxGQapM35odln90EDngXHsoOjy0BOS3jYw0jeF+OYvgjyI+aj1jLhlgrM+n3CgJjWmjX+H9UV+gOECHAkn9ULIQ4vDgN+Vv+b8KBb3DMkNyR/NYTioxNBi+aJWlC8mgku4t5QGnKKF48gPr2GDgc8Hg2XyUGfvj6h02B/L4FAG6yHvHkWBu4f68gkycMLeV6mbcBRKLyQkeNWR1zDn9WxXVpQGWdZ5+cxn2SgU5Nh+l1Au6NkXEBIbDYnWFlE/0dzi52hrvcHYn5B/YWeza1KBA9C9eHswbfthY9vA1Suzx8BaReis6iFhrZx+wi/8YaNl1bs+xy0/0HA7S+4epn1YI5OgNkLxJ9rXYSEvbuf6iWxdzYSnsD8b7L9ErklPHpOndWr08Qr0xfI4zFwY7dmTxBLMcbXSHGuHFeP0w1+RsYHLGs4FOmMf9EXipbQgLVvJvHw1FlkyGUixP41reewq6a3fvZCAQbFCxCm5YJB9z7vKtGkiLUdL1E5TagGyzjgXPE0I2gieY0kAv+8ZlKmJcEAJ4uIcxediKKvu7dbwyCYFqj/vIxMg82iQrD9/83ezZTWPRB82VjvZxXTxYXQooxxJq+g/A9/V51P8u0m8apq8lmnSlOBj8FGPqFsJ2lHPlSWII1aoIuY4djaXYXEYXJV7zThBXBGBZrYsRQ3zhF2hzhQJZTNrqoLb8SyIdh+iK5Ej+Yh3y0dwFY7+HqxNUX9bSIt2pR7EDwz6tdhYaMGqdWcVbrrpyHZfM0cs4wEvfkRRYzxpz6DnK76Bk4lrAql5TJqAg0ivH6cr+q32ecbg03b59SxaYz5rUJz
 QvRE2Nyh
 UdCM1StajnZKZOrtwvRLaxVcL9f4lVupdNSo5Ig2Qvtan7hJFg8cvd2/wjW2hMeu3ypl/AJrR8M85vMboHCD1JZ1ONMED9s2ZC5vc63rLdBDHH35wk2br83f2qjYk65hthBRgNGyvjG4vFwubk8+FRVV18dw3NVCRv+yF9wgtzdcVuVP95iNlQbMmKvRffrQPPazkFFMbNqZql5/oLgRkj5TAFPQSFTOXF04aPo4ZZmcSVRpsJKGU8FYoLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 10:55:37AM +0100, Vlastimil Babka (SUSE) wrote:
> Ming Lei reported [1] a regression in the ublk null target benchmark due
> to sheaves. The profile shows that the alloc_from_pcs() fastpath fails
> and allocations fall back to ___slab_alloc(). It also shows the
> allocations happen through mempool_alloc().
> 
> The strategy of mempool_alloc() is to call the underlying allocator
> (here slab) without __GFP_DIRECT_RECLAIM first. This does not play well
> with __pcs_replace_empty_main() checking for gfpflags_allow_blocking()
> to decide if it should refill an empty sheaf or fallback to the
> slowpath, so we end up falling back.
> 
> We could change the mempool strategy but there might be other paths
> doing the same ting. So instead allow sheaf refill when blocking is not
> allowed, changing the condition to gfpflags_allow_spinning(). The
> original condition was unnecessarily restrictive.
> 
> Note this doesn't fully resolve the regression [1] as another component
> of that are memoryless nodes, which is to be addressed separately.
> 
> Reported-by: Ming Lei <ming.lei@redhat.com>
> Fixes: e47c897a2949 ("slab: add sheaves to most caches")
> Link: https://lore.kernel.org/all/aZ0SbIqaIkwoW2mB@fedora/ [1]
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/slub.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index b1e9f16ba435..17b200695e9b 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4567,7 +4567,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>  	struct slab_sheaf *empty = NULL;
>  	struct slab_sheaf *full;
>  	struct node_barn *barn;
> -	bool can_alloc;
> +	bool allow_spin;
>  
>  	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
>  
> @@ -4588,8 +4588,9 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>  		return NULL;
>  	}
>  
> -	full = barn_replace_empty_sheaf(barn, pcs->main,
> -					gfpflags_allow_spinning(gfp));
> +	allow_spin = gfpflags_allow_spinning(gfp);
> +
> +	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
>  
>  	if (full) {
>  		stat(s, BARN_GET);
> @@ -4599,9 +4600,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>  
>  	stat(s, BARN_GET_FAIL);
>  
> -	can_alloc = gfpflags_allow_blocking(gfp);
> -
> -	if (can_alloc) {
> +	if (allow_spin) {
>  		if (pcs->spare) {
>  			empty = pcs->spare;
>  			pcs->spare = NULL;
> @@ -4612,7 +4611,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>  
>  	local_unlock(&s->cpu_sheaves->lock);
>  
> -	if (!can_alloc)
> +	if (!allow_spin)
>  		return NULL;
>  
>  	if (empty) {
> @@ -4632,11 +4631,8 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>  	if (!full)
>  		return NULL;
>  
> -	/*
> -	 * we can reach here only when gfpflags_allow_blocking
> -	 * so this must not be an irq
> -	 */
> -	local_lock(&s->cpu_sheaves->lock);
> +	if (!local_trylock(&s->cpu_sheaves->lock))
> +		goto barn_put;

A quick question to make sure I understand this correctly.

My understanding is that after this patch, there is now a new case where
allocations with __GFP_KSWAPD_RECLAIM set (e.g GFP_ATOMIC) can also reach this
lock-reacquire path.

If we were to keep using local_lock here:

1. On non-RT kernels it seems fine, since alloc_from_pcs() already does a
   local_trylock(&s->cpu_sheaves->lock) check.

2. But on PREEMPT_RT, local_lock could potentially schedule away, which may add
   latency. So the idea of using local_trylock here is to fail fast and return
   without incurring that latency - is that the intent behind this change?

-- 
Thanks,
Hao

