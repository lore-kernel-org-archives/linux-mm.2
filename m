Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8524EF3C267
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 14:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C614B6B0005; Mon,  9 Mar 2026 10:00:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2C636B008C; Mon,  9 Mar 2026 10:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B587D6B0093; Mon,  9 Mar 2026 10:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A3FDB6B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 10:00:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5089EC0946
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:00:25 +0000 (UTC)
X-FDA: 84526684410.27.FB33651
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6A7E7100018
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:00:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ovj5osbH;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773064823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UVpj/ocorlGwiYME3cThw4GoTD2go/xZAU0PixP4vrE=;
	b=ZAwfNjX4KHdAldo6NNm0DaX/5L7qRZISDa2uAJpJANp6WyvO8OcDrehV9QxjiTbKJKz220
	GuI51e29Chnsq73liJ12avqkNabu/Smx5+7JyetCx85nQC83rlmyV0HxntBZJF4RP3/pmj
	hqr0zKf+Ggwkg6bZCCdG6WtukGjN7tI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ovj5osbH;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773064823; a=rsa-sha256;
	cv=none;
	b=WJwwxleGRkOVlRq7+WzdTHUtBzDetwYqGhZ1yLkzrFp+nQlCjxWvqlWpiUxQy/36rP59hi
	5ETrk37LJE7r4iaWs3wiHyrgnYvohYg8WG5Jf8YODEyG38xeUpE1UNe0lJZ+9RNt5dErxw
	bkkqZTnQaUJrR/G0f1HHPpTv3C9wWmQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6033D42DCA;
	Mon,  9 Mar 2026 14:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0526AC4CEF7;
	Mon,  9 Mar 2026 14:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773064822;
	bh=DnCTxrCceZEz1a9g0WegA+3Sbf1oc314HptMlIzKbcc=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=ovj5osbHOQZAbykrOKjaNKiC/PPZQXDRw1nyH+1XViznnSZDCqkeDx5eL9quBIBsQ
	 UJC+r+PeVEAN8FjGoAUaaUnJPFZsycuEXyK1aLyYFm/GX3yiwe1Fbikx5wo5UJMDLV
	 t10Ji3OWaEXZKc4PSXFCVEo0FVKQnUg5SUgfFK053iSmBp33N2MsYc/DSRmpr/4Jsv
	 vq+RV1XC7qsxFY0uDaafX1ZuQj6Fx7MFR86Q1orM8qJtHBkOGLsO8FwPp2RBLLZbjp
	 8xvRNFuZc0up6rzLjRwgdBlNLKCUbwfCpB6EwHAdTu2Vw3T5Q9uPTXbGs9bbimOBva
	 DxPEH+dJN/kWQ==
Message-ID: <0a25d83b-c6ea-4230-a89d-1f496b91764c@kernel.org>
Date: Mon, 9 Mar 2026 15:00:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: vbabka@kernel.org
Subject: Re: [PATCH] mm/slab: fix an incorrect check in obj_exts_alloc_size()
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: adilger.kernel@dilger.ca, akpm@linux-foundation.org,
 cgroups@vger.kernel.org, hannes@cmpxchg.org, hao.li@linux.dev,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, shicenci@gmail.com,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 viro@zeniv.linux.org.uk, surenb@google.com, stable@vger.kernel.org
References: <aa5NmA25QsFDMhof@hyeyoo>
 <20260309072219.22653-1-harry.yoo@oracle.com>
In-Reply-To: <20260309072219.22653-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6A7E7100018
X-Stat-Signature: rqkud8dxjmqtrbrb4stsu5aum7bzdf8i
X-Rspam-User: 
X-HE-Tag: 1773064823-976182
X-HE-Meta: U2FsdGVkX1+dT91e/TpnIo20QPTo72acT4iUeKCjRsa2rzK3fZc+RZINHVgGqrvRgV5P2n5NjHFREYLjvbE3dZBEmtPHIyHvL8tZtGTArV1tRoBbpLOCy2nvNGy8ze/Qa/3o+6M50doYIv4rnkYs39m8zmE//lTLxw5xpE21vUteQsljb3Q64k9VjIgj6FYO8xSJ4z43b9ajORG0+n6TkQwFCPnldOziSYkjqLI3tPknHHDRXANOrX0oBHzqdyptku1u9m4U22kWdRd/ek2NUr6rKPH8/SAC7YC42Gn7sh15vVJ6tLTV8X/OoyjC/mSZ9blaW7im1lRTQ3ajHna54XqdTQf4EuJVuOGLH5jb8O3ESHB1SeXaO9USz5P5dOuz9IrjFR4y6xipGkaWbh7iJbv3GfImEtlHKf5VNbguLQqhGKGD5h4/uM61j7lZaLwZvbNnjBqs/GrN5HE0WUrjTJXhmozUfxHThOYSSRjHXhylWGQa4H0ttNnDw2x54C7mURcx8A7B+By4W+YtODu9gwsPWrtfPVl0h/EinHJEDaXo1rTTK+O2XF7boN94EgZqgH3xFP6wUaDJXEKG1HJo9wDDBT+OM8ngogQ1mC59XhUJBjJbxy/n6cR/SIuI/xFDMA+xQrm1/3D8gpw++QJdnWUkiNWo9aCUmwzEtweMWYTMNaWsmWm1W3Lpjk/hSkEWdJxoOeO3S3tQRQkn73TB5XIjfWrEC9oAPGCWqsNpEfpmCUL0ykv6D94B8Zjl1pdlex0LZhDFWAaghre/BC+DS0tOzy4EJ9zKATPR+bTJxBz+CwIKlnJWCETmOHkDbxsl+LLXUIJYgtAS0+EsNygqTzOVNnBpmOLXlUMNvcGjFEWO8uSV5N1/srwK2GFMkEf4FG2XrO0/sFTVLyMvfPc26Cvz2FF6+SihaYMXPk+C7wo0DP3Q0uaX7634VKCJB3k6sHl5qT1pNYWlOZTyA9V
 FiW57JjQ
 JHMG5bLSV2E0wL6fZdzjjf9stCj+KfEALYv2Gm7hu35h8+ROGclRWsoYc1SosCRq4QBZ7ZhC932AEytm0l31BJ8D20QNwNx4yfhqZNHJdUkEhTosTiUxA0q/D2O4PzbobMZN0Ail/jwXk/DeKzSNKE6/ORpWsbbwsCShcJNfDZbqexcgCPEW1P8q+2XO+n6HoVbWpMp1YOpXmL0yaF0Yq517gbXadlPw1im1myIh+4YfUuHi4sXuVzhuh9v+ZyUVGQcs9vvX8HEgSXm2ZcS1dED++DO/ZLBA+ApYlGOgpWm04chJXx6o50pSoHxlUHlEABoPSIDubHy6ct5Ah9khdH2/pZJY27MMQMv32WeMzCH2hmOpBAedMhdlD7ImNsqhpxoH0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 08:22, Harry Yoo wrote:
> obj_exts_alloc_size() prevents recursive allocation of slabobj_ext
> array from the same cache, to avoid creating slabs that are never freed.
> 
> There is one mistake that returns the original size when memory
> allocation profiling is disabled. The assumption was that
> memcg-triggered slabobj_ext allocation is always served from
> KMALLOC_CGROUP type. But this is wrong [1]: when the caller specifies
> both __GFP_RECLAIMABLE and __GFP_ACCOUNT with SLUB_TINY enabled, the
> allocation is served from normal kmalloc. This is because kmalloc_type()
> prioritizes __GFP_RECLAIMABLE over __GFP_ACCOUNT, and SLUB_TINY aliases
> KMALLOC_RECLAIM with KMALLOC_NORMAL.

Hm that's suboptimal (leads to sparsely used obj_exts in normal kmalloc
slabs) and maybe separately from this hotfix we could make sure that with
SLUB_TINY, __GFP_ACCOUNT is preferred going forward?

> As a result, the recursion guard is bypassed and the problematic slabs
> can be created. Fix this by removing the mem_alloc_profiling_enabled()
> check entirely. The remaining is_kmalloc_normal() check is still
> sufficient to detect whether the cache is of KMALLOC_NORMAL type and
> avoid bumping the size if it's not.
> 
> Without SLUB_TINY, no functional change intended.
> With SLUB_TINY, allocations with __GFP_ACCOUNT|__GFP_RECLAIMABLE
> now allocate a larger array if the sizes equal.
> 
> Reported-by: Zw Tang <shicenci@gmail.com>
> Fixes: 280ea9c3154b ("mm/slab: avoid allocating slabobj_ext array from its own slab")
> Closes: https://lore.kernel.org/linux-mm/CAPHJ_VKuMKSke8b11AZQw1PTSFN4n2C0gFxC6xGOG0ZLHgPmnA@mail.gmail.com [1]
> Cc: stable@vger.kernel.org
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

Added to slab/for-next-fixes, thanks!

> ---
> 
> Zw Tang, could you please confirm that the warning disappears
> on your test environment, with this patch applied?
> 
>  mm/slub.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 20cb4f3b636d..6371838d2352 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2119,13 +2119,6 @@ static inline size_t obj_exts_alloc_size(struct kmem_cache *s,
>  	size_t sz = sizeof(struct slabobj_ext) * slab->objects;
>  	struct kmem_cache *obj_exts_cache;
>  
> -	/*
> -	 * slabobj_ext array for KMALLOC_CGROUP allocations
> -	 * are served from KMALLOC_NORMAL caches.
> -	 */
> -	if (!mem_alloc_profiling_enabled())
> -		return sz;
> -
>  	if (sz > KMALLOC_MAX_CACHE_SIZE)
>  		return sz;
>  
> 
> base-commit: 6432f15c818cb30eec7c4ca378ecdebd9796f741


