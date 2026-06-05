Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76FEACD6E74
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 07:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D426E6B0092; Fri,  5 Jun 2026 03:27:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF30C6B0093; Fri,  5 Jun 2026 03:27:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C56FD6B0095; Fri,  5 Jun 2026 03:27:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7D7A6B0092
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:27:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 76F5293978
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:27:49 +0000 (UTC)
X-FDA: 84845029458.07.9024397
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id A250340004
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:27:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bvx4SnSE;
	spf=pass (imf27.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780644467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pzeMW4oDHPYGz1SVYrNy5ryyyLKS2lEh4AkazzoA850=;
	b=EMblK0z19MnZy5t5gELzw6FrO4M1UnTrBUljigxUq4yfy57+77Uwawlssk6h7Elpm1wFTb
	fLWClfZxAqPRTD8Lr4WUbFpraObhdb7B2ABeL9Cxqz87/5LZQYDZ1cQqAB/D5tWGLos0rC
	pPPOiOlHEsKhOVEoCxyhhYr/UQJmAH0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780644467;
	b=ceg00hHsltSNDD/y6hgjDxvjYUphD6zb+YM3c7WijzAVpjjeOd0jwc5MUbfANAzFvrPsl5
	tbIfxxR2ceIVzshhA6owZHMhETq+54tsdVQQRQcZ3zP/hAw2+NEnQr3uH12SO8tKCCjp6s
	2WX5oaSq1L3HDzG9PBBh6qAQat1buR0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bvx4SnSE;
	spf=pass (imf27.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 5 Jun 2026 15:27:29 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780644465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pzeMW4oDHPYGz1SVYrNy5ryyyLKS2lEh4AkazzoA850=;
	b=bvx4SnSEo6uuj1lJ1ykG80vSCM9pjv0e+eonyRfmu35+BN1+XXJ6mu0weBgsmM7Nkp+mpj
	JhP5+wvfZTxcRyt6pucQyHKfQuggIsUEDostcQqsV8fgSy7NAufu/8aHD5+1hPk3LeFP/V
	StHu5KhgIkyKAuQaTgEC22foOeuD24M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: hu.shengming@zte.com.cn
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhang.run@zte.com.cn, 
	cai.qu@zte.com.cn
Subject: Re: [PATCH v2] mm/slub: preserve original size in
 _kmalloc_nolock_noprof retry path
Message-ID: <aiJ5__26le84QuwK@fedora>
References: <202606042027323804pk3MRY42Jy7y42OHAhQZ@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202606042027323804pk3MRY42Jy7y42OHAhQZ@zte.com.cn>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A250340004
X-Rspam-User: 
X-Stat-Signature: c5oxe9ajaiq5g83qiidrsf4boqgxjwe8
X-Rspamd-Server: rspam08
X-HE-Tag: 1780644467-987151
X-HE-Meta: U2FsdGVkX1/RZ+7rv0XT+8hlZ+XpOvFgLu1srKmr4wviNlVYhoxbFOqANadO4qmYo0DlqRNcc8D5baNPxzSzzJJp7qXIhlPG/mw+9BxXvUSmGUHejkkNP61zJQo2Zdp73G47qTwDo5DqB0PsJzPkXx7c9LyvfTf6WXnlZWCPZ5UbZiGsvxsxNwGi36t0w54+ysfayZLp1SpNQGTBOptEA5evKDOtjtwsMSuI5hyYYKdKFeWgby8iGdFG00YsUlXcABcq3+4wEriPLzPZJosVvX8OEU5WqboLtThCh7hTVE90G+jCG9Fhy/h7VtUGXUKR0cgOzDgLfBfh/hBRdCA2fLEDTinrvDAOXzFfUj29cLIhB24D643EBR9KIJIqdIwtA97P2PQc96Nq2Yo4yVznhIoWisRngFjbq9dRpOc39sgXNNJuNxZp+TAp0uqcYpB2/9wL2mBk5SZpqepAe/4ft8j9P4VL69M739dsirtfVfmiZQSN3Yt+x05O2aKcFloMP36AsDP1IWYVVg5I6tBE3FUHag174rQtkOzMzggnCDjz57yUAtpGrOCaAfWVGWXRy26TtFwrstJ54S2JlkZ01GKU6vg+1VBEliIxGbVbQ6dAytw9rYdl/zo/WtGY8jcGknQlMHC7M3Bk3JYR6qvMDW4DFECGHxAftZ+LEwRv/BWTfoox/J2xzGoa0eUQvjZcspXZOtuhsDjr2klFsRDkxhFrXJ7FMvE3rHIXM0Q/LQ9XT2Tiwud1j7VYq8+GRamOtukJ8W9svgoQ7Ff3YEz4jS7tiJHj74k4mJsuTinJyhCCE62HDzNI2e2BVo4sr56qBGoPrGmvUdScbr1GFyWqPBPoBdShJ/i3UGLXCFqkeFepKMd0wemzeiyQDyMlgd+ou5FGli+Ud3YB7RzgNyME1Vpk2wrmJe1ziC9GK0yYa2K43qnX9t3mkX6Ob83ddRNAJ+xvPMTc/DN9wT3P+Qb
 0QOiEZj2
 3HtjSchwgw0kWmafSUdDwE+Cb7kLLOnZdZ1vS/QCtFfC7mxMy7KOZxPrSpM5HDV1hloRqogIP65AarflfJOwvlUF5mWqvSvGVXEE4KttiEh6icm1PJoDPY0KpC92BYfThNNoMkhCmkmBkwIBc68AzXwsOJiwe9a3GaryrF9IxQwIQR2L9fJcT1xFaKAtyxa8+2Yg58Z8G/fghO80D1fJw3cjhJQo0wchR+wCUmc6d1i5bViGD12G49eE7+4yJ81uDsMGo/f4W07N3hkS/81n1OFSshxVD7nkoKj1wZi+IQA0bEq/pNkOy0xCVvp9Hb5fvvi7urLtjtkMrH6r+04Y5LK8cxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 08:27:32PM +0800, hu.shengming@zte.com.cn wrote:
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
> ---
> Changes in v2:
> - Use an explicit orig_size variable instead of bucket_size, as suggested
>   by Harry and Vlastimil.
> - Link to v1: https://lore.kernel.org/all/20260603211011530GqLSXP_rgcuQdR47IGQLL@zte.com.cn/
> 

LGTM.

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

