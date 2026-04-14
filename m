Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 971CDF531EA
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 03:56:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 057616B0088; Mon, 13 Apr 2026 23:56:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02F156B008A; Mon, 13 Apr 2026 23:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E86E56B0092; Mon, 13 Apr 2026 23:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D62156B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 23:56:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 72FD6588E5
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:56:10 +0000 (UTC)
X-FDA: 84655798500.27.03B95A7
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id A70C4160009
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:56:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eSc0ovaO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776138968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mDoJdnP8HPkkIqmmxUqnVNtEqsYM1X9CNiGkQpd9dSc=;
	b=6oaKktxyjS4LlspR8hR3dvuWiUvvu71sT4+X9ABJSAXy6i1uqnGKpMutmE4qCKKENCR8nV
	kRTJtoUxa0rmNPxUysgKOKDsP0XO2B3xYH8FT/RQwQNUjkRRUEfBtYDR2xUbvkclcNsvAh
	04a/wonKZoT+ahuuHAaHVflm/9xOBz0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776138968; a=rsa-sha256;
	cv=none;
	b=lc4fjRoJ7g3CecfOi4SYomC9ar/kjTxo+TR2FjrOdEANvnOBSGj3Wl/KQE2o+0zWoUl7GT
	1JDcSaMX9iSQKF0F+y6Jj1z3ds5fN3pN6sztpiB6be/ic3VQpPwSBaa2WFPJJDvZUNjN5B
	QomIT+u+7t8uSoJaLHgqK4yr4op0XmQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eSc0ovaO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=hao.li@linux.dev
Date: Tue, 14 Apr 2026 11:55:55 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776138967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mDoJdnP8HPkkIqmmxUqnVNtEqsYM1X9CNiGkQpd9dSc=;
	b=eSc0ovaOXWhOfudkQbOkcUJkUAcCqVraJeyNrZnUK935g68YcEBqrtsS3nM1IVRYshEFTJ
	IMonzgAAkWMy9/y+BRCSnhqAdppuoQdy2TvMDTP7xF3pyI6O33HzJJXwciz2KwWGSfgPtp
	QtZEYCnuYl3N1zUzHaVRvkIyNPS/P5g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: hu.shengming@zte.com.cn
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhang.run@zte.com.cn, 
	xu.xin16@zte.com.cn, yang.tao172@zte.com.cn, yang.yang29@zte.com.cn
Subject: Re: [PATCH v6] mm/slub: defer freelist construction until after bulk
 allocation from a new slab
Message-ID: <6hedy72mmajtutplztj57k63odkidzjr5zyn7yh7p3c62ybbj7@jupudx6k4lpz>
References: <20260413230417835rnfiEWduEx44lc3u4uR9_@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413230417835rnfiEWduEx44lc3u4uR9_@zte.com.cn>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A70C4160009
X-Stat-Signature: 8ce7jfiyffbxzsijmnsie9xybjk7ejx8
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776138968-873738
X-HE-Meta: U2FsdGVkX1+88MOellL1EuoK2N37jw0sGJcEVO7cf/dgSOQlsNP4sd/Jal13VFHUvY2/TDUgKkqiHJf9RberQH0pYxZKYXXAXnoKzZQ4xpeFYd5JE3FvGN4duw28ojF0IPMDESYK7jXZa7kORB5/Ss2GZDjB1kLOs9rVK0XgN3bMueDAW/J5yRysltVzx3a+J0NJwL98dqpbYzacBUBc+P/D69ZJjEWk2ycbRKZbcMJomyObjvmVSSklW1vgq6QFsrAnguyDkfJPVIXe+Cq4Li4iGs9O7bC0tgzmYYeVbSc5BePTTug76l8Q1zgOwgVvtBOrYNW7iu3xS0JNEygVFxp4ttDtEHTU19lN8UbYFn9+1hufXV/dpaT2qUq4AHGoYANOVnna+8nlcD3F4Ik9ZPeFEnaqPelqm1NmLTWvfvIb1zy8PoCnRouDYjmH/bZujSPAPwyZb10ckS5EJmh6DiMqaNo4asDegaxKn9APANDknPCsa+g7+3ncFurUSYDzwo04y95RaU1qw0LszdQw73VWLpBy/8jxNo20//yoRjnKGoexEbeLc6tWAjfqodwNtLUl+bcHHjxNJoo8p56372yS39weKEv0wuVV4jJA+lVNwtJEXJ4pUHFMOyGTDqKBLSr0oGpkQpD5Iqos3EjI7TI6JFnCZKzxR6zQnA7xmnxgf4EdoijCaOA+UWiTxlVr/gfM0Sqj0uqQu7vPDpfMAbT1INp95R+StVPDEU4mQfOPKGMqEuqK5j5Bh6J6BwDhC7FGAM+JCHB9WqPgnXrvSqsjufS79FjpRl413t5BIxJANtAXvcbq1pk8sK4YIbA1kLvgZ/I0QbFyOrF0Bk7TJFH5h2FQV4ZZlKUVvgFHuBzPu3Uw+xfwrWbB80by2qayYGgEzYoHvzEj3UGKktqguuQVbM4ze5AXRYpppvSP8cGS64wCIceIqbKEL/o9/yLKsWqhyvsayTDwShWw0XQ
 PsL8jbHD
 Vl2F5kUYl7cI+UNnfFNnuF4UbZz+YeXO/mg5No5+xGLMpIlJwIXb5auU2co4yIAMdJVaOUsICspWpUkYFfal6tF/TCGjEX42JlchoDjKSTO6r1N1KJ5thiz4qf/X3dXG6Zm/pGR1oTIfFv1MSLufjkW0z2Dt7XZh+e+2rWGkB9ujZrSYJkiN2E5HbA6BiBcWSTj7CVq0WrLxvaXM1SR4JjocclQLPq/um1VIeQGLYYm5I7CPacpTxq3KbAuqeWqmBNMfJqT1Pk8ML7NY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 11:04:17PM +0800, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
> 
> Allocations from a fresh slab can consume all of its objects, and the
> freelist built during slab allocation is discarded immediately as a result.
> 
> Instead of special-casing the whole-slab bulk refill case, defer freelist
> construction until after objects are emitted from a fresh slab.
> new_slab() now only allocates the slab and initializes its metadata.
> refill_objects() then obtains a fresh slab and lets alloc_from_new_slab()
> emit objects directly, building a freelist only for the objects left
> unallocated; the same change is applied to alloc_single_from_new_slab().
> 
> To keep CONFIG_SLAB_FREELIST_RANDOM=y/n on the same path, introduce a
> small iterator abstraction for walking free objects in allocation order.
> The iterator is used both for filling the sheaf and for building the
> freelist of the remaining objects.
> 
> Also mark setup_object() inline. After this optimization, the compiler no
> longer consistently inlines this helper in the hot path, which can hurt
> performance. Explicitly marking it inline restores the expected code
> generation.
> 
> This reduces per-object overhead when allocating from a fresh slab.
> The most direct benefit is in the paths that allocate objects first and
> only build a freelist for the remainder afterward: bulk allocation from
> a new slab in refill_objects(), single-object allocation from a new slab
> in ___slab_alloc(), and the corresponding early-boot paths that now use
> the same deferred-freelist scheme. Since refill_objects() is also used to
> refill sheaves, the optimization is not limited to the small set of
> kmem_cache_alloc_bulk()/kmem_cache_free_bulk() users; regular allocation
> workloads may benefit as well when they refill from a fresh slab.
> 
> In slub_bulk_bench, the time per object drops by about 32% to 70% with
> CONFIG_SLAB_FREELIST_RANDOM=n, and by about 50% to 67% with
> CONFIG_SLAB_FREELIST_RANDOM=y. This benchmark is intended to isolate the
> cost removed by this change: each iteration allocates exactly
> slab->objects from a fresh slab. That makes it a near best-case scenario
> for deferred freelist construction, because the old path still built a
> full freelist even when no objects remained, while the new path avoids
> that work. Realistic workloads may see smaller end-to-end gains depending
> on how often allocations reach this fresh-slab refill path.

Thanks for both Shengming and Harry's hard work!

This patch looks good to me, and the overall approach makes sense. I did not
see any other issues, so:

Reviewed-by: Hao Li <hao.li@linux.dev>

I also ran a few tests on my machine. From what I saw, the mmap and ublk
cases did not show a very noticeable difference, but I also did not observe any
regression, which is great. My guess is that the fully consumed case as an
ideal scenario may still be relatively uncommon in practice.

Tested-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

