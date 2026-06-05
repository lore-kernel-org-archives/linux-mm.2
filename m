Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 028EFCD6E74
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 11:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 599816B008A; Fri,  5 Jun 2026 07:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 571056B008C; Fri,  5 Jun 2026 07:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48C946B0092; Fri,  5 Jun 2026 07:48:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 37AB06B008A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:48:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C919AC34A8
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:48:23 +0000 (UTC)
X-FDA: 84845686086.30.0184E27
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id EF170A000B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:48:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gQaR97ZI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780660102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F+BmeJkpk7lnOtX+3YvPCn5bRjFC6wSEqIYi3NffkYk=;
	b=mnqnKzx5sbELD4Ma2EW/DRMWL920QkC6YJk6VPfQQHYJ4NbxeQikDBWpT6pMccM20kqKZY
	7ZrNDAShicPncehQVNf2XEb0hFPIsf6L4UDzWMYMm2lCnkvkV49GtzyrVlJeSGIDKwccwg
	4kDX2hhTHkXVkMKffTDH+BYhegkDDA8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gQaR97ZI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780660102;
	b=E/fVgVVEP/KAfGiilvw1NDNORyjvTm5uQvbRYblYzesXWS5V10jlSe9mKD+OW6BtPVOVkL
	9BjIFAgC8XKliUK3y9zr55KgfEUKTmqi5FFtpdo7BVCNH1t4B7E/uiA/JAkZwFd4RHgVL4
	1BUik096xF6j7ghOPsStg4XK4DNhnkA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 392FD40A21;
	Fri,  5 Jun 2026 11:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEDC1F00893;
	Fri,  5 Jun 2026 11:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780660101;
	bh=F+BmeJkpk7lnOtX+3YvPCn5bRjFC6wSEqIYi3NffkYk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gQaR97ZIGbsQN1dRhHE4kN85ro6UbhtBym/Qt4GpoIaqTI/ZQ4sZATyoRCsNzjg7o
	 t1QrSxfUQJVa6o1Z0Ig3BaDzDIpVOKs5Dy3XB9ZIeiAQyIRuC5qHLmMzVV7QS3BMuA
	 I72kEh3vLBXZNalw1qAQ212aDm1A8nwjKSk6ujzMgInTG69zFYQlfPHs+SaiVezlyF
	 zZddhFjvCv0f4AO8ppFCBHJhaGbmqRfdm5B2sSXCoPd/j+3Vt8Kyz4XSyEzEmnVgCp
	 cL0TkejaPOP8ItTjJX+BfebVX8hcQh5dYjptIwfKFevNNKCcyV0hWT1ofz8fR1LivF
	 9ZFaGo1/xIwrg==
Message-ID: <2dc81b31-36f5-40fb-ba3d-e3f80d65cc15@kernel.org>
Date: Fri, 5 Jun 2026 13:48:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/slub: preserve original size in
 _kmalloc_nolock_noprof retry path
Content-Language: en-US
To: hu.shengming@zte.com.cn, harry@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
References: <202606042027323804pk3MRY42Jy7y42OHAhQZ@zte.com.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <202606042027323804pk3MRY42Jy7y42OHAhQZ@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EF170A000B
X-Stat-Signature: ky3zjijrr87pngqx6pyro6g8ojwtt35q
X-HE-Tag: 1780660101-232501
X-HE-Meta: U2FsdGVkX18uPk3J8RiMkmyJne5/+VpJJRKByQ/uk1OaoKQMtqIpCjbmNn8QqdyKfTNdllBaq472iXuh4TEvEnhkr8kZKH7ixCmEeOEz/Wz8yA1HR7l04ds4HD6mjWJWgCBjhn28QllaqtAFSQdW8953lHdTqSy5b+VuySWRwmp0dc7IOM//Sy0Pv1v/+r/FsLRzt3w4lZIt/lnYCNv83KIhHaTl4v+GQel5kRK3rC/E5HArI6SGJlaZ//4rDdOnCQqGa9yladQsGFeU/5Z/J3ff1lVylZsvaFv2g6DxnfB7Xr2ilVzPUPKPmM3ZRo+jKmr8grfS+sWPOMuefPjJWwiCnpw0Mkz2sKVhPSZTZu5qH7Gl8W5KnMMaqdT87usYKpn2lUQc/7IGmTU8bxorVQCPUoDzajpPNXX31a642TtZcuDkzDpDSIVHN8KOBi+M9xUWhWgPwODREWdq/MOj6qonrpJ2wkfxSSPkNTkgo9+d6e6c6R4SXLfHxwYfF3dzuWnANuv7Y3sdyHSjCvQKCgGHW98G4unQdU98QEyJAKzQBLGrXzBh5gMbBIqGTd6LCgtDxfI0CeE73zAUzMj4MZuUx1P+sWgmh6D/Oczot7T1QpcZQrqCWL3eAmRQsBKSoHJBH0wvQYV6xvFlOjr36yKRnbVNN0iXo3Z+z31DD8+hw1T7nz5H+EGEa3Ouw2YkJkIdQJmCPe24jgv5M80Nn0iH/xk8RhZf7xsqiPUPfc0KNhx3zyj4ANdogafwEsPdxnmMO87qPBe9osEcyHM91nSuUiVfiOP9rJPn7UfULaSvLDLjm6hoyve1zoYnvPrcffxeJF/1Owfh4BG0mWBkLzypLMv14W6YtrC3rn3y+XiU3achmQsEPYNF2MolqGeKTOYsDaBKbNQTzJWHkCnKyuEMyg1jcKdINkmMrsyeWa4uBTUUncc20nsGsB4mQeusvNT2TmJbXGIu+yLmKwF
 1yJ2junR
 726d1azCvi+ksGVjjhqRPXC3PBPDnhnncGzL9YXlOV5JxnLTknbAivGJK0XvJAV1cq9U5irxZtUsiTAjO+1GPRQOs9bdmrRe2U6mLoheQSLAhElcryeQ62M2cCBkrz9foX45/qGfUIpZuGBGYNY1JOFwaRmOCsGnvldmHdVI3sMiKxUSwk1VeBtZAhXvG5PiCTvOF4ffIAvjMbiyONi4xCJ2MVot7XxrQjaxEfCkkMbPa/iPnUk9oMKmEUeRexBashFpv5tbibyQDck2rIAoEw4lUdGV7R4xJgk1j45WI8IIqj7w9kp7LF8YZ8VAa3zz6mkfAEDzUJRqRqocaKQIgNg9r7FLeqrUX7qNz+5Db7H+P7XP+h0v+cYmjcmAV+I5Tp+7YbKdnheZxbcs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/4/26 14:27, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
> 
> _kmalloc_nolock_noprof() retries from the next kmalloc bucket when the
> initial allocation fails. The retry currently reuses `size` as the
> bucket selector and overwrites it with s->object_size + 1.
> 
> That value is later passed as the original allocation size to
> __slab_alloc_node(), slab_post_alloc_hook() and kasan_kmalloc(). On a
> successful retry this makes KASAN/slub-debug observe the retry bucket
> selector rather than the caller requested size, potentially widening the
> valid kmalloc range and hiding overflows.
> 
> Keep the caller requested size separately as orig_size and pass it to
> the allocation/debug/KASAN paths. Continue using `size` as the retry cache
> selector.
> 
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock()")
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>

Merged to slab/for-next, thanks!

> ---
> Changes in v2:
> - Use an explicit orig_size variable instead of bucket_size, as suggested
>   by Harry and Vlastimil.
> - Link to v1: https://lore.kernel.org/all/20260603211011530GqLSXP_rgcuQdR47IGQLL@zte.com.cn/
> 
> ---
>  mm/slub.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 67abbbf68fc1..7e1a1fe5daaa 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5350,6 +5350,7 @@ EXPORT_SYMBOL(__kmalloc_noprof);
>  void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, int node)
>  {
>  	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
> +	size_t orig_size = size;
>  	struct kmem_cache *s;
>  	bool can_retry = true;
>  	void *ret;
> @@ -5398,7 +5399,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
>  	 * kfence_alloc. Hence call __slab_alloc_node() (at most twice)
>  	 * and slab_post_alloc_hook() directly.
>  	 */
> -	ret = __slab_alloc_node(s, alloc_gfp, node, _RET_IP_, size);
> +	ret = __slab_alloc_node(s, alloc_gfp, node, _RET_IP_, orig_size);
> 
>  	/*
>  	 * It's possible we failed due to trylock as we preempted someone with
> @@ -5422,9 +5423,9 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
>  success:
>  	maybe_wipe_obj_freeptr(s, ret);
>  	slab_post_alloc_hook(s, NULL, alloc_gfp, 1, &ret,
> -			     slab_want_init_on_alloc(alloc_gfp, s), size);
> +			     slab_want_init_on_alloc(alloc_gfp, s), orig_size);
> 
> -	ret = kasan_kmalloc(s, ret, size, alloc_gfp);
> +	ret = kasan_kmalloc(s, ret, orig_size, alloc_gfp);
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(_kmalloc_nolock_noprof);


