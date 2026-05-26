Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 668D9CD5BCF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 05:54:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC37E6B008A; Tue, 26 May 2026 01:54:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9A396B008C; Tue, 26 May 2026 01:54:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB0946B0093; Tue, 26 May 2026 01:54:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9EADF6B008A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 01:54:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 347891202B8
	for <linux-mm@kvack.org>; Tue, 26 May 2026 05:54:17 +0000 (UTC)
X-FDA: 84808505754.18.CCA0A89
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5751C4000A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 05:54:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LbOk6sh8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779774855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AF1oquPwv5FzXd+tdEAqTJUpMqePbrEeg9P+1wtdYRk=;
	b=rdWKmUyJy58kuQt2u8k+2mzbwZiEHJOVJkyvoGCZvTwjfgZNvCpf2yfyr6Lk4H7nTUvw3o
	Vn1Gwa4X0OWmMKEtYMo02LDWrpezyYA8FYeEtQsmEbyUbhHBv4CBhucb1LnyPqEEcNCxZ/
	KifJv1ifKYYAVi4rMTTtk4iYnRNp9WI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LbOk6sh8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779774855; a=rsa-sha256;
	cv=none;
	b=m5m1mEQYxDsh2sL0duYWMjXCd3M5VyF23Li0tbreBPgMDrseDU/KTof/VCnMVimhqlfXI/
	wMv3DHIb8PDDpRyQsqG+N8VXCIFh+ztw6KN3Cx8hDa3jW0/R/JBmtyF72UN3SWwutFDksX
	WKZGmnHmq8EeNLg4mP4Zr4Mo9yV0sKY=
Date: Tue, 26 May 2026 13:53:55 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779774853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AF1oquPwv5FzXd+tdEAqTJUpMqePbrEeg9P+1wtdYRk=;
	b=LbOk6sh8NNbZjFfzXfJQy5OXuntmVBvRutLEo3yfkz8OegUbuo4znzNYUL3939pJdpd5cc
	ryZU3Aw99YUFK+sBPMAmvCAc4CTOD/GflW99KxDGJw7WxnfC83AG4hFKbvIonmyRG840f7
	Lm5prQ9As5KeiUMe6/ue70BIzzWt7UQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: hu.shengming@zte.com.cn
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhang.run@zte.com.cn, 
	cai.qu@zte.com.cn
Subject: Re: [PATCH v3] mm/slub: free prefilled empty sheaves consistently
Message-ID: <ahU1JTiy27FI9QaU@fedora>
References: <20260525211000387LYqTHmxYL900XIB8qwV3h@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525211000387LYqTHmxYL900XIB8qwV3h@zte.com.cn>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5751C4000A
X-Stat-Signature: t1f9447xaqowf4fxi3c68etbyh78tsr5
X-Rspam-User: 
X-HE-Tag: 1779774855-668848
X-HE-Meta: U2FsdGVkX1/QLJvxNTmOlBVdW4CJgDiVSOd65lvN+PNXT52ScfjrLvVnvAZ9SyobvO7k5FW936pMCh8NBQap34sn/7F7rgWDdy5rjY9XMKN09Rh4tUtPOPBxGRRUYAlvxymXgW4d6UuJrAtGoW/oSu0B1e0aEyGW2x8uvDl3+mzP08zvyab/G/v8+ZUn9dTM1twQuvsXAN3NUKFoZLQK0IMBZofYwwJTSUpKzni2c927Yv3Hjj01z5M+apd3Fep9y9uWPtpZ9n46hFmZEF9NqCsHEcN66zPE9Xg48s4a5fJehokMfZmcb9xD312gBdUVOWWd1rE/hif05NmfaPinFzLLOAvXwEDQSgDh/v/BCktipHsvwliTApP3MKlySqOJwQjZOmohdikyVkf91c0znLPSwsTNhsTFTPo0RsGzH++lwhBMXR7YQsE+JQ1PHK6qxfOsz9mX214F7JQKm8vDDxiiO1phpQkEbqJURXLn2+Kv2OMuaQO7Bo0tt6w8aWSyRPpbsKjXu2+0k5EhefGYbUPHVi9UuADb5PBMuXA3Wchu/MssSJz3IpMc/soUySN9k3slYXi6KcuNeiEhsNEjq5DogFoXrBaVGjxtM71r2i22f9E/YlD0Vbzsrv5kWwyhSRAomBb/VpDvV8i8Wm5xAfkTdcwmaqNWkgcn+OolccvH5fPhix+NOIjNK8rObD1WrPlhMenPT6+sg1CToRs8TRgxArtsL4S8B1iEMKAarU3YeNki6bDeEZlNO9EGrlZN41+zayH8sDkfzXtsmUW4zx8piD9k8CMqgzJQcsr26ORKCpEAoun+nXXv7SQrLEdK3ngZf0l06RP9/D1Ub31lPNEeLwCkQnaX+jcpKbnHHJNAiLlXTwMpqtwZI/1U/133bfmBUcj7eaGh/2X0U8F5gD00kx9FAInIiAp2QlRfenDcb9kv6Z3OzcsxEnQeSuNdZNj0Inx/JIP1v3a/Yx9
 3YBKEtVM
 6NL0HGrZILYRvI3MgUJNsDMKQCUUG4JQvKx7/6gFql4K/m/uH/q4wuE1ishsbx3KIbtC7teNFjXz+QmJ6cRQEHQwvNj4V9taaA++5Lm5rPM59F3F2JN4gwKDPLfxGswbWuQG2iwg4B5an4+jVQaGW0JZOqZqbCKkpDs8j9kUDTXmjQGE+QHGWAFjRMX/NOlQcOi0NMlw+DGykPhBkUjCzT51ygWnxpVGUnbUoz3N9qOPgAwnAGFH5qshlu49dTRfKhgc79PobovUcIRPpZMM3ol/hVpt+03QZ+9MS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 09:10:00PM +0800, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
> 
> Empty sheaves allocated by alloc_empty_sheaf() should be released with
> free_empty_sheaf().
> 
> Move the empty-sheaf capacity initialization into __alloc_empty_sheaf()
> and use it for oversized prefilled sheaves as well.
> 
> This keeps the prefill paths consistent: after flushing an oversized or
> pfmemalloc sheaf, release the now-empty sheaf through free_empty_sheaf()
> instead of kfree().
> 
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> ---
> Changes in v2:
> - Rework the change as suggested by Harry.
> - Teach __alloc_empty_sheaf() to initialize capacity and pfmemalloc.
> - Allocate oversized prefilled sheaves through __alloc_empty_sheaf().
> - Free flushed oversized and pfmemalloc sheaves through free_empty_sheaf().
> - Link to v1: https://lore.kernel.org/all/20260521195015105Y4zvKHj0TfPZEujixy9Vo@zte.com.cn/
> 
> Changes in v3:
> - Address Hao's comments:
> - Drop the redundant `pfmemalloc` initialization in
>   __alloc_empty_sheaf().
> - Keep initializing `capacity` and `pfmemalloc` in the normal-sized
>   prefill path, since the sheaf may be reused rather than freshly
>   allocated.
> - Link to v2: https://lore.kernel.org/all/20260522145900248m-nBcy07_SCDk2ATDWfmg@zte.com.cn/
> 
> ---
>  mm/slub.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 04692a6f9128..f4c06bf43f2d 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2782,6 +2782,7 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
>  		return NULL;
> 
>  	sheaf->cache = s;
> +	sheaf->capacity = capacity;
> 
>  	stat(s, SHEAF_ALLOC);
> 
> @@ -5015,21 +5016,15 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
> 
>  	if (unlikely(size > s->sheaf_capacity)) {
> 
> -		sheaf = kzalloc_flex(*sheaf, objects, size, gfp);
> +		sheaf = __alloc_empty_sheaf(s, gfp, size);
>  		if (!sheaf)
>  			return NULL;
> 
>  		stat(s, SHEAF_PREFILL_OVERSIZE);
> -		sheaf->cache = s;
> -		sheaf->capacity = size;
> 
> -		/*
> -		 * we do not need to care about pfmemalloc here because oversize
> -		 * sheaves area always flushed and freed when returned
> -		 */

just a bit curious, why did you decide to delete these comments?

>  		if (!__kmem_cache_alloc_bulk(s, gfp, size,
>  					     &sheaf->objects[0])) {
> -			kfree(sheaf);
> +			free_empty_sheaf(s, sheaf);
>  			return NULL;
>  		}
> 
> @@ -5097,7 +5092,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
>  	if (unlikely((sheaf->capacity != s->sheaf_capacity)
>  		     || sheaf->pfmemalloc)) {
>  		sheaf_flush_unused(s, sheaf);
> -		kfree(sheaf);
> +		free_empty_sheaf(s, sheaf);
>  		return;
>  	}
> 
> -- 
> 2.25.1

