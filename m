Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F41AACD37AC
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 12:05:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 464EA6B0088; Sun, 17 May 2026 08:05:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4154E6B008C; Sun, 17 May 2026 08:05:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32B356B0092; Sun, 17 May 2026 08:05:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F8FE6B0088
	for <linux-mm@kvack.org>; Sun, 17 May 2026 08:05:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B6E7D1C0E67
	for <linux-mm@kvack.org>; Sun, 17 May 2026 12:05:50 +0000 (UTC)
X-FDA: 84776782860.10.B3D8D3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id DB500C000A
	for <linux-mm@kvack.org>; Sun, 17 May 2026 12:05:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bvlgAYNp;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779019549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kEgnYc9YnKLoewlfdNqYWhaBi5JdVxvU8jOymvASpzc=;
	b=z99t3oYqJ/wjFnccAPnRy6nWH5cL9V65tpiBbCvF7qmw+rKL0vpnYpIeELYvUK+qFs5thl
	cvFrMbY25Jnj0MwUhtAzbVeCwLe05PxJBb9eRPNfSYGZ2b49qj8YkzuvNW/UFnWTK2Jq9z
	LdQl6T+x3mp+O1h0wlSgdNgMAtbpx6o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bvlgAYNp;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779019549; a=rsa-sha256;
	cv=none;
	b=3usnGlwUa0qJCNTRoOPEsjr0OJ7SesSsk+T0mqR8wwbYnQTJDuSRKGTxZEZ1eGdKfWGDMe
	C/UB0Dp42UkOeZW9ObXrTMHIELwAKGT5mdpPUwFM9m6oLsNbz5pahKOAbzZ2+x5LyElrI4
	BURCBcYYsRemBf1sHtRqNDTctzPC1Ew=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B61E0436DD;
	Sun, 17 May 2026 12:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FCAC2BCB0;
	Sun, 17 May 2026 12:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779019547;
	bh=nmtHAVGEjkCpzZzciMaaD5k4+dRrHQg7cMrtoXJRU5Y=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=bvlgAYNpEscnKYQW60kFuedsLUAFxvXcrXDr/3u7/XYZ9NvTGJN8dZuQkAl9e4zct
	 MPVTz1PoiqNTpPCSk0Kdt1CGpxLaW1yEfjS7w6VMIfhfpxceXH2ZNl41vpmB+mXflA
	 gJWdINOz5fDGbiEU/HrwDLGg3vYDrnNge2aPnWZRfxF3t/wW60oXfDp2lKBCG/Ea1A
	 xOtKOHEzV9zy9p5MyoblDgjbpq1x3D56pliQIxrvMrSRA4s/ZtDh/LmSRsVa6xU3wC
	 jvju1+nnQgbu/aGV03cN94i252veX1CGmIFLtlb3ZhVEJUyS9aFKkn2khn3K/7toDw
	 owEk15X3jgdGw==
Message-ID: <5fba246a-fefa-4ac6-80a4-46b1d3b5480e@kernel.org>
Date: Sun, 17 May 2026 21:05:23 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Harry Yoo <harry@kernel.org>
Subject: Re: [PATCH] mm/slub: fix typo in sheaves comment
To: Wilson Zeng <cheng20011202@gmail.com>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260516164033.1566208-1-cheng20011202@gmail.com>
Content-Language: en-US
In-Reply-To: <20260516164033.1566208-1-cheng20011202@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: f9zfh3ndxq16ia1gokykdnifie8a4z6s
X-Rspamd-Queue-Id: DB500C000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779019548-433359
X-HE-Meta: U2FsdGVkX18MYtJ79gUrwD3mTX+BAG5a+T6UFsOt3NQG82uUCrxwtA3+wIEbZlKjPk8l5E/4nvOl7Xmm8I+eD+ICSbvnqygiZDSZB+wJailkkq8Fhuk0ueA5GnqbaLYrrUSsZTERpFC2/0E34g4tGT5yoUctnRQxYU69rPv4bYXlsnIFu4HxTt/9FDnSggo1yfsDCPEGfSSVB8G9ENJZcImHAPBS/drof9MmwLzJxT3pFpTECy8XZaDA7eDhtq6YzwEMDHIf4MNY1qKnU0vYKNDuCrgGGJhWbCqnYKuj6MCLSqs9dOiIgZCaPsvQAJQgxE6kZ5sxy9aImUBvi4B7xN3mGzo3t+JfJ+emYb1DmF9cP8dMHzR66DcJjkQtx3lnhRNwLD3B9jphNpjqiyfAnkh5VBMxlDVWV+bao/zVRklZukn0oKCcPaFpxcMjw5OcJZ6GClI54NTiWnNPZY2nlaX1K443Z0nKbEonbhdCb9sao8RCHPOsWYjVQzPeDjMlS6nlBY69sy01ZG7Pl7g+4r5C+2KGo0lrIbQ08LQ812POp88WW6a/OQlFUOgne92HJju2wDoHNWRdMn2Nqkz6H5eEitmSNf7KfmoPhsjKgmJ2U+61y0mXsMyPQBnLj+9rmR+pjD2HjprNsMmkeGzOqItunvlIojzJmpCzAQ+A7SCgZ5IIh9/aL8qfHfzKyMoSKb/KuM54frhLNu2XolZV4a1THjrsJZpaQVouxoveVH/0JqxjUS31/6jzDjmUy1uzHp15Z/EnpktL0uGeEZ/icaRHXF/9mEnJLdmQb7KXfybI6yAEY0at9Mv7sCeFx6nn3KtfloW5k7S+IDLTC5WB2zugrnvmITrIOmn2cAI7RuuKcQ+6PDw7yAKbwR+/xoyYuf/54XRUoUmr2/zl1z3Rod/DGEw20iLrxx7CQaXEwBgbfBtJOwsedUx5J8Y03NR16Xz4JBgJ73MBKJ1G5A6
 l3nbXu+h
 S48yPN3uJGDAR1YNtRj+6UaatFzhHnvsXhyNe0FbCDOmAIXYycr7UeAJqlfo+e+uiF3KGSmjUltwV8v6qqhwoKsAkM38B7T7bTNQKODA9RNSLxOk1HMelHd4YCPZRfvY61y7cf8UcoX2GNl+n6+q40k6pnoHKVDmebVN6QxJjJqtbDkRC6lnCb+BeFc3rCfCUvAmn90ZoVy6mKXDPMM1EdOZ+dlrWYq9rf+M/C72jvA8sUOhnlScMZXuW9jja/W9heG5k3ICmY4qplwalCrAJDcFGiUOdAAYS06IxbsZrZGgHHfc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 5/17/26 1:40 AM, Wilson Zeng wrote:
> Fix a typo in the comment describing oversize sheaves handling:
> "area" should be "are".
>
> Signed-off-by: Wilson Zeng <cheng20011202@gmail.com>
> ---

Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

>   mm/slub.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 8f9004536729..686559479273 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5011,7 +5011,7 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
>   
>   		/*
>   		 * we do not need to care about pfmemalloc here because oversize
> -		 * sheaves area always flushed and freed when returned
> +		 * sheaves are always flushed and freed when returned
>   		 */
>   		if (!__kmem_cache_alloc_bulk(s, gfp, size,
>   					     &sheaf->objects[0])) {

-- 
Cheers,
Harry / Hyeonggon


