Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64DDFEC1106
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 16:48:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A32766B0089; Mon, 23 Feb 2026 11:48:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DFF76B008A; Mon, 23 Feb 2026 11:48:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E2636B008C; Mon, 23 Feb 2026 11:48:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7972C6B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:48:32 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2F04E139A95
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:48:32 +0000 (UTC)
X-FDA: 84476304864.07.4D87EFA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 81BC08000B
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:48:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QpiREUdB;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771865310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fznxlvbrO8SySCVr9rX4eaFSR3ztbvN2q/M2Q4XwxYo=;
	b=BD8ddttSN8u4BJ429zUd9qh/rOSEJcY9+wHJMIeY1PJJ45RVX48HLD7nujCZl2wMi/N+00
	nBnzGijdgG+KizeSSDWJbhojwIIujly9yq0HcsVi4tIzmnXEOpBJkSUeSKKOwpPaHUOymp
	fPLUQrY47jpyaSHBurszOg6BGFjGils=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QpiREUdB;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771865310; a=rsa-sha256;
	cv=none;
	b=dDa/ibdkfcNec9mGRY5DCVLj9ieMHMmocL5351tqDzLPlFWhesIRxmengcGbCPdm8sV0z/
	8z9uTVKK4Tyv25yMQmnxAwIzsvS5bV7EG4DfPAk1fIGf3a9NQesrkgjq1bf/sOEVDz5byW
	0vglyxkrCl3rJy2r986aCSylaSHfenw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E6E116013A;
	Mon, 23 Feb 2026 16:48:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D324DC116C6;
	Mon, 23 Feb 2026 16:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771865309;
	bh=weCpl+lZBhZ/LV1iX/bp8GJFaKaSB09aF8w1UCFzyLM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QpiREUdB6lYUmHAJPgwXeRaN+Gy+bUrQKbfvQHImDodRXHOR71W4pk4DGEGuTFNbv
	 lRBRuQP2JSSTJJhwGur3aGJKeAjEhtVrWaFm3yJFpd/HCbJgCfZJAH5oCp7AOl/sUj
	 58klYWV6MYgqVd+9PWEiIwRkgGrZOPy/MO9cF0sziBvjdFCI8Z441ScY2xbtxlVS+s
	 aWqZZLh1ZlUAhV3ywK3n1RB9gwNhmd1YsUqfnVM8+y8lzLju4kLstfogH8UdfxoOC7
	 tpx8zAFcNnvtljhq0SddX/oZqIBLeR6KVfxaP5deWui2d7E4PacZUlgMgpNuGJ2Wn7
	 Km1PkF011LcJQ==
Message-ID: <e4f3b873-7825-46e3-831c-d0f5d3761ce4@kernel.org>
Date: Mon, 23 Feb 2026 17:48:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: pass __GFP_NOWARN to refill_sheaf() if fallback
 is available
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 linux-mm@kvack.org, Chris Bainbridge <chris.bainbridge@gmail.com>
References: <20260223133322.16705-1-harry.yoo@oracle.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260223133322.16705-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 81BC08000B
X-Stat-Signature: di5eqyuzuihsoge6q9j94mhh66yjmboa
X-HE-Tag: 1771865310-809605
X-HE-Meta: U2FsdGVkX1/k5qXvvds1kUHeGSVQO/wr/nmkaVJXx6Hm4r4t28Oz4IWb/+LlX5h6OO5P47tgKAe7Dt5hATkmVho99z1Eqxyud2+M8tte9O4PWNwutlS0IOLbDyzIGebOpA83sxP7LKiIdL8npSCuf/LhCxBCkwVAf3tx4njdhiez3m8Nvs1Q654tXgpdHfCXNiJH9K5sLG7xv3c5IpJrKN8RpSpd0iI0JWICHb6vM9mhMVOdQ5ruzWlfe7Cwh/ycFS9yOVHo6V4dk3OJwbCiJQtq41NlnNeK1LBzEun4cemc7+8goYHjmnXIzqzZi+/ZKZaxictM2QbaTm6T2w/flsoi49agC3yi1Wpe/4SqdlBZc2YYK25cjnLU20QhProyxXNcXFrh9AYQw1POOrpeo2nIR2I9ZdojL82MmRCgvWbxTM68wDESCa0Oc/B1yP0jQ5EPu0sGD9sM388G3/XPr2dTyNL4kbWzR9bCz2idArPhDngDe4myGpX0yM6Ljyyqzs9eb/7/VMDJA6ThC6SgJMsonymweNKBiEcnz/4iKQQ2XDOurs7DMmFTPrL7h/5x7mr9zUKbftlXAmSeTqjx+qdu4qlQTDVk2BtEndQ08Plr4P1prG6lEQFpDV+EuiJRU4jB/G3QiIXqenHRV2EN4ENibQJmy6d9tAZTtVD466wqrNhGD01HOw8p1AQBANVG5XUUYXcSMCXTjuGT4zu87sWLz8LomF2H38RX0utCGzQQu9CsulMnFlmOkbW1Qj+a1V+YUcOHQ8rdiBH1kG8RzQtRKqCFNYj7joXx4PWB+xGDkOCpv4GVGVspGPLtpusnTD5OgalgTrBGl++J/O3v6B+ORVdVE7WQJwuJJW+NW4/8/o+Qk8QWLwLaPqwj5VIKxAZYtj1NtKpnAZot0K23a6gP+DigQlTOT0cUatk2vZgcVktze7RPXC4NpGaibdCRO6QEyxCoxAryCe4v0n1
 zQz6dKvW
 JvL5PA4/oeSNqbWaXiyDBX4/OvkhkWmRdcx0lsc8EADFMUbEfsikZ9UEeFnO3IK0gNPa4z8Vi7vccVhmuiOWZetdh2+HB7JsjBwXDvNUxgeOGaGqKIAI9sY2SyAZA7bdzBoZU0wUCBwqFHj8jkj956fTqsOiEqoDXkF1j+ICXyBwvIhnYSBDKhmvESjWnXasz6Enx6CRp7nFpLWDVaxNtsZuVQxO9g728nkf6+VVE299JIGS5lN+R+OsNlIno18Jd6b1TuKSqSWnJZfsGC9Ui7j+ii78qDjmubEFopVB9qDhTzsED2otOHAv00Y6VO8KM1Nsx0pZw46pJC5TtfEsg7Q7V6yQNU+4L8btwG0KgMF3TcK8nIezGhxO8cWuvL1RDV9pWonhPxyz0GeqrsHs+bR2PazguIwDLqQlnsjqCtOUfgEW28qgpvt3xuO9Hnh0030kW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 14:33, Harry Yoo wrote:
> When refill_sheaf() is called, failing to refill the sheaf doesn't
> necessarily mean the allocation will fail because a fallback path
> might be available and serve the allocation request.
> 
> Suppress spurious warnings by passing __GFP_NOWARN along with
> __GFP_NOMEMALLOC whenever a fallback path is available.
> 
> When the caller is alloc_full_sheaf() or __pcs_replace_empty_main(),
> the kernel always falls back to the slowpath (__slab_alloc_node()).
> For __prefill_sheaf_pfmemalloc(), the fallback path is available
> only when gfp_pfmemalloc_allowed() returns true.
> 
> Reported-by: Chris Bainbridge <chris.bainbridge@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/aZt2-oS9lkmwT7Ch@debian.local
> Fixes: 1ce20c28eafd ("slab: handle pfmemalloc slabs properly with sheaves")
> Link: https://lore.kernel.org/linux-mm/aZwSreGj9-HHdD-j@hyeyoo
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

Thanks, added to slab/for-next-fixes.
Hopefully Chris can confirm it works (without adding the __NOWARN to btrfs code)

> ---
>  mm/slub.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index afa98065d74f..0c986c240bf6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2823,7 +2823,7 @@ static struct slab_sheaf *alloc_full_sheaf(struct kmem_cache *s, gfp_t gfp)
>  	if (!sheaf)
>  		return NULL;
>  
> -	if (refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC)) {
> +	if (refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
>  		free_empty_sheaf(s, sheaf);
>  		return NULL;
>  	}
> @@ -4576,7 +4576,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>  		return NULL;
>  
>  	if (empty) {
> -		if (!refill_sheaf(s, empty, gfp | __GFP_NOMEMALLOC)) {
> +		if (!refill_sheaf(s, empty, gfp | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
>  			full = empty;
>  		} else {
>  			/*
> @@ -4891,9 +4891,14 @@ EXPORT_SYMBOL(kmem_cache_alloc_node_noprof);
>  static int __prefill_sheaf_pfmemalloc(struct kmem_cache *s,
>  				      struct slab_sheaf *sheaf, gfp_t gfp)
>  {
> -	int ret = 0;
> +	gfp_t gfp_nomemalloc;
> +	int ret;
> +
> +	gfp_nomemalloc = gfp | __GFP_NOMEMALLOC;
> +	if (gfp_pfmemalloc_allowed(gfp))
> +		gfp_nomemalloc |= __GFP_NOWARN;
>  
> -	ret = refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC);
> +	ret = refill_sheaf(s, sheaf, gfp_nomemalloc);
>  
>  	if (likely(!ret || !gfp_pfmemalloc_allowed(gfp)))
>  		return ret;


