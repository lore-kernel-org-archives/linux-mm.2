Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67624CD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 06:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 805D66B0096; Mon, 25 May 2026 02:38:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B6516B0099; Mon, 25 May 2026 02:38:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F3886B009D; Mon, 25 May 2026 02:38:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59A2F6B0096
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:38:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D6C21C00E7
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:38:30 +0000 (UTC)
X-FDA: 84804988380.19.CFE75FB
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5C6191A0003
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:38:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xeMJRRkA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779691108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uKyMuUK0WLqhGS8J8WKRVk1Ij1jSm2kKaV+KU4tQLDs=;
	b=wIkItMokWHxlRW4n5gbskTqhJ8VP63jH25U6tTVDz8piFj80j6K/i4PCvf5jg0bKSRQQKU
	CFqQZim+gDfaq99xo2TWGXE7iImK63jcV+/qkbcJIjwXTf959I+vRRGs0CPoWxt6HyBs1a
	kKWDfV3xmFt8vbDuewbTSzz3vGBMLgA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xeMJRRkA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779691108; a=rsa-sha256;
	cv=none;
	b=JL6SeLq2f52O3qXV4k39tG/hhDKM1gCGjalRr9SmZrS/0/0aIOIlKMVDXsN319UAufM2gd
	tLUxqG2Es37MiOCTSd7ngTEPhXDwsKYDcjGN9Q+fMyZs5uIJxuL5a3uHKoZLH7wJ7x9ThV
	4zMUkT/Da7BymaKbuatGG/Lpbg6zUrg=
Date: Mon, 25 May 2026 14:38:17 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779691106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uKyMuUK0WLqhGS8J8WKRVk1Ij1jSm2kKaV+KU4tQLDs=;
	b=xeMJRRkAwktnwIFZICXEUBp7PiKdDbRB3GpmgBDp7SkDRY2vk9TQzw02iqAp4x4JalpcOu
	V4EZaKCFTKR6r/3o1SG/4AHAeu1dNfXXXhHove+R9Q0uNf4HUcuSeTB+4wyFJpUkxKWu47
	a1uKlX81yht7R6VdeToJZdUwwG9EJOQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: hu.shengming@zte.com.cn
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhang.run@zte.com.cn, 
	cai.qu@zte.com.cn
Subject: Re: [PATCH v2] mm/slub: free prefilled empty sheaves consistently
Message-ID: <ahPsR0YTfhgQnmwQ@fedora>
References: <20260522145900248m-nBcy07_SCDk2ATDWfmg@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522145900248m-nBcy07_SCDk2ATDWfmg@zte.com.cn>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 1ym13x4764bc6u5fxpcu4o8ejzu7k7k6
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5C6191A0003
X-Rspam-User: 
X-HE-Tag: 1779691108-65905
X-HE-Meta: U2FsdGVkX18U0e0Wa0Hwxhopu/Bycvz61LilNIZyY6bz1fr7a5n9QE0k5qd0IYkIM5Zj63NTQDR8CgsmKYodneCdLulCRgbpZOXyZOR+KWpAc0kzayXGlBjA03JookTuHuVXLwmQxP8RjOi6ryg68Q2yVDVqW4s030VIV2YlpqEY8gdqm+/FLi/jzBY7tYmwWSt+LZXNM/y9fMy90zTkQEDW7QoikZNbEeKSSihUGHkA8g7jsPYUd1OZO6z7IpXbBUujwjTB6Wd5xp/mFIWvNGVt7gkUYAzkqTwj6B0E7xyNGo+4S+xttYr4yVCjfmsdrJlaKaj1cGgJJ78YrRIuty39J8jEo4mljgOKl1t1Uah+U2r55b1AEV2GLR1ExyiFugFqUQMScxtk3eJIss1cCnh0QSX+mJZiNyx06OMl2dROTF7floHFrEoZdnfM6qtgx4EJbBoEJE5ZG6R+uOGxzr+/sbFL/8grGTo0kLYwMBiYfYYvyi7XIuSO5Szk+cT2xc6F/OclhslKQg209ajmwd9RDn5NPW5BDKcgMO/E3+Gc1Hug4h27STXYHjVh+9bhynYCoNa3ZEaf3nu91pKfo7+uTcDG8RnR0gOnxq9C2cKVGadN3lnPbPpiuzjkwKic4dFOme9ub1QBdoi6mhAgejqvxp4N8BRcWKXsUkRjWvMA+K2ZsfPhBn7+/lhLxew97wcwSirgAX4blmkpI6igWhMI6k7TXyh9eKgc4FNRV/gN2Q7zkScoLtFw3PB7vg7kn3RC/F+X0TWn0r4Vafl/IfYrtEeuiuiK9Rczthh9sE/darExm/afz+3FmR+5+UZl+UEkvWANx5o/NP+g6OIJATXsaBRYAdcijbPCp1RioWxoHqF/e9K1Fu11GCuapHoz9VadV9HYdS+l7BD0ffH7N4RDBrkqyWJtVIPKJyVbV3OnPshlqSkZrFfVAKxmjev0P/5fBsAoj6MrJpc5EjM
 cJLAWQge
 l1S/LpoRJU9/3VpgAtii49VyaA2eUk5W+VTM1VuCNYOZR+bmul4H4LjysG08H3fHToAFI48aND2lYlor5EYcYP/+Q2Hwm4e7kTAFnrcMXogpVtpCI8q3sH4wwmSVskugRhrcpYJZ9pO5yq5swMEJvp76mWyrE+0LTq5Aa3DDB0ybJ5zrApygEtug3zimtONL+UVaxSnoiDpZA4u3fIe94lINua8RapsqDZe0eh/mi7r5DgmActW1/EcI5X2+oI1Npvfe38EqtVtv3qSv3KZTbBunlmnr/0Vf1ZOoR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 02:59:00PM +0800, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
> 
> Empty sheaves allocated by alloc_empty_sheaf() should be released with
> free_empty_sheaf().
> 
> Move the common empty-sheaf initialization into __alloc_empty_sheaf(),
> including the capacity and default pfmemalloc state, and use it for
> oversized prefilled sheaves as well.
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
> ---
>  mm/slub.c | 17 +++++------------
>  1 file changed, 5 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 04692a6f9128..bbe8351f1bfa 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2782,6 +2782,8 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
>  		return NULL;
> 
>  	sheaf->cache = s;
> +	sheaf->capacity = capacity;
> +	sheaf->pfmemalloc = false;

we could eliminate `sheaf->pfmemalloc = false;` because the allocation use
kzalloc.

> 
>  	stat(s, SHEAF_ALLOC);
> 
> @@ -5015,21 +5017,15 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
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
>  		if (!__kmem_cache_alloc_bulk(s, gfp, size,
>  					     &sheaf->objects[0])) {
> -			kfree(sheaf);
> +			free_empty_sheaf(s, sheaf);
>  			return NULL;
>  		}
> 
> @@ -5064,9 +5060,6 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
>  		sheaf = alloc_empty_sheaf(s, gfp);
> 
>  	if (sheaf) {
> -		sheaf->capacity = s->sheaf_capacity;
> -		sheaf->pfmemalloc = false;

I think we couldn't delete 'sheaf->pfmemalloc = false;', because the 'sheaf'
pointer here could points to a normal size sheaf via the `if (pcs->spare) {}
else {}` statements above.

> -
>  		if (sheaf->size < size &&
>  		    __prefill_sheaf_pfmemalloc(s, sheaf, gfp)) {
>  			sheaf_flush_unused(s, sheaf);
> @@ -5097,7 +5090,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
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

-- 
Thanks,
Hao

