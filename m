Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B24BECD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 14:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25FF16B008A; Thu, 28 May 2026 10:29:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2373E6B008C; Thu, 28 May 2026 10:29:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 127196B0092; Thu, 28 May 2026 10:29:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 019076B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:29:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ABCF712085E
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:29:32 +0000 (UTC)
X-FDA: 84817061784.01.05AF741
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id E0F1640006
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:29:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AUUu8yrt;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779978571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5BA6dKKBNlOGQi64KHMmEqDOAVzKaNmuRrG2iObP2CM=;
	b=7qa8i522q28bkeXrsz+mmTZ2tn6DYDsn5xn5wuU4g+6DRXcmcktBLaGFidBCYfT27Wkn7V
	rWyoNyVz8lw0tQRgrTUH1DJIlD1sGuwfJ5tQNHulikbfw5dUO3nag1m3L++5XhlbYkO5Pp
	X6ZXtQTTxPaWVHR2ohjI/QqKQS5oWlI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AUUu8yrt;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779978571; a=rsa-sha256;
	cv=none;
	b=C9E7CRhrlx26J/cP0nBimcZZedMI5hLX7O1xrIcVnN+TbpPlNXqmGvQps0dPM2lCfkSYyt
	Wd5ZZ8ERpc5rdat1KD/v/2X1NGbp+vC/ZNFLK650ANqy3/DL99MZiDgFpG+Be2um6dMb0y
	z+FIjwqHa0tr58jCg3FZ3KHgBA+yg6s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 12914407A3;
	Thu, 28 May 2026 14:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF9681F000E9;
	Thu, 28 May 2026 14:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779978570;
	bh=5BA6dKKBNlOGQi64KHMmEqDOAVzKaNmuRrG2iObP2CM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AUUu8yrtNtz9lxvBi5v8RskjXS8SYRIECkH8bIL4SrxFeTsTXmvL8y6433fDYU4HM
	 ClQhyqWH5WyBBJOJRIXbQJbJC3B4OjZ/GIkL9SPsqXu7NG3Wi7ZOPlbPULz+oIWcAB
	 /XzKXAxW/wfgevx2iJ9u/b5O3NC2ciKPK8T61u3B2UoeuMZloBg8bSEyUXVQgV7utN
	 rxopDswt8KeAnKtUCrNB1NdkaWtXi8iHId31SvIwTpeKOKFBwSSABZHenwFeXeAjQ8
	 gDgweFe0fAaWVBaG2FiBxhIgOy0NB+1Ipi0FrGx+90iQckdBPxMxpXzgOogaAgTbj1
	 DHpxqskbLJd6w==
Message-ID: <d1fdfb33-12b8-48f8-bd0f-c9d90407a2e1@kernel.org>
Date: Thu, 28 May 2026 16:29:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: fix deferred compaction accounting
Content-Language: en-US
To: fujunjie <fujunjie1@qq.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>,
 Suren Baghdasaryan <surenb@google.com>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Charan Teja Kalla <charante@codeaurora.org>,
 David Rientjes <rientjes@google.com>
References: <tencent_368AF1F3821E46232637BE16D65C45CF3308@qq.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <tencent_368AF1F3821E46232637BE16D65C45CF3308@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E0F1640006
X-Stat-Signature: ob1texabmf9fypofngh6g5bt7rzbfbo3
X-HE-Tag: 1779978570-867211
X-HE-Meta: U2FsdGVkX1/dViYrEcAm/6eDeoAB62pOchlBZGEcqDPCSa/Dl0wmAfqyBQdJlPobW90pGGnvK3Bez4TpVhr0E/g1Nt3SSs6sY58WdMKg92zrWI5F7ZtGI9YKCHtzrxtPEjYA8QTtmQIh3Fbvx++PhlsOvnaxnxlczd70Z96Mo6L/V1ArajB64Cb+f1cqezKzTwCo7xMWSmKeCXBsRGKtOTfqQFOvzgsLLt/FRSQItEMUj6ptzkb+btMGEa9VTt+afTrBAqnCzMaY6ErnKQ4TSgqj6QOVa9shYHloAHShknWymR+P7m30PrI46xTGHqrXrkguq/gUpCAJrRKswadGoTUOS4f09yR41eTOyJtL/DE1yniv+H9UGUqxy38tWrelrXYzl6OTuSSUqWHAqHETClqSBnLT0YR6dEuQZeDq/M9wyKwXI2SY49LSjs1r3hpSDO+K8Telr7gqCayjqkG2qU0pFpB1m60fIcryeZH02eXJol9Jj0Y3W64jSwBp2dCa4YrChbJheNM4GZs2x1COgEC1fZZ7P5dUSmqXghWgHmTVPAOLDH7NZBqcbogoJJTX4P5c+zNHMBIHtjWaHZ7du8yRGWeH32x37nIBYQ+oo0mOct2iM/XbZyxLQV/YAPNEgk+YFJr5wopFvyES58HN1MA5zPYcsuLvIjkcFLx704k4hu2rno6PeBPXh0Cs6Cct70Wg6zas4b/vGXZo3ZmJkXSEuv6nI1aMf9bEmwbI1vtC9NZo2CQnR3oIASXixrkkf3xJdaSW9TKGUJamp+xq/qKAkxXUvYPQDlTZmOHfAyQWRzqszRFzY1xanDMMLvYPXz9OrCN3oLW/oSZ1RdxaMoyeDtU30xiejtoXkpk3qVote3GXP2Ea6t2YHtcMQTbARJ15JwBrsitQ1ewKxTsWnFVhEVguD+u34juAtMqXWIdhlIgg8pSFzQynH4Qmi8XvbFomHwS+AAP9b3YMp6T
 TBG6aX9Z
 3kRsUVY4Y1gmbfjzFMnCrYKsDlw1oUWVzKIOApphbg0X9RZ7fQqLO93RLS3+N0S30h0eOlfSbjIKLYA8vzDOgkT7ZB5stVX6o5e6ZqWeqYQNjpT7sLYcKBC1cAM2ZTuimVnY62sAgVSGtkWqvc/3+hZzBUsOgrImMOSNjbk+lGA/R/OUwA431IikLCSFuU2uBfOMMPXzqbitxjN4zP1iq8qMJ1Efr2oU1m5nni9e644nq0U9NTxjx8oZyHRT+zw220ThYoMwJOZDGWCSVwF03dBLEBmPjxuJXftSBiXjT+rRMe/ij6sWmGgXiugs99mEvrwL2gsHN9o5Z8EDgSas12iBcwgc1/oALalFm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 11:12, fujunjie wrote:
> COMPACT_DEFERRED means compaction did not start because past failures
> caused the zone to be deferred. try_to_compact_pages() returns the
> maximum result seen while walking the zonelist, so a final
> COMPACT_DEFERRED result means no later zone reported that compaction
> actually ran.
> 
> __alloc_pages_direct_compact() skips COMPACTSTALL and COMPACTFAIL
> accounting when try_to_compact_pages() returns COMPACT_SKIPPED, but not
> when it returns COMPACT_DEFERRED. A deferred-only direct compaction
> attempt can therefore look like a stall, and then a failure if the
> allocation still cannot be satisfied.
> 
> Treat COMPACT_DEFERRED like COMPACT_SKIPPED in this accounting path. If
> a later zone runs compaction and returns a result above COMPACT_DEFERRED,
> or compact_zone_order() reports COMPACT_SUCCESS for a captured page, the
> final result is not COMPACT_DEFERRED and the existing accounting still
> runs.
> 
> Signed-off-by: fujunjie <fujunjie1@qq.com>

Hm I wonder why didn't we do that right away in 06dac2f467fe ("mm:
compaction: update the COMPACT[STALL|FAIL] events properly"), seems like
even back then there was nothing that would e.g. convert _DEFERED to
_SKIPPED from try_to_compact_pages(), and the changelog did mention deferred.

So I guess for posterity we could do (but no Cc: stable, it's just stats).

Fixes: 06dac2f467fe ("mm: compaction: update the COMPACT[STALL|FAIL] events
properly")

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

> ---
>  mm/page_alloc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 23c7298d3be2..ddeb79fa12db 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4161,7 +4161,8 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
>  	psi_memstall_leave(&pflags);
>  	delayacct_compact_end();
>  
> -	if (*compact_result == COMPACT_SKIPPED)
> +	if (*compact_result == COMPACT_SKIPPED ||
> +	    *compact_result == COMPACT_DEFERRED)
>  		return NULL;
>  	/*
>  	 * At least in one zone compaction wasn't deferred or skipped, so let's
> 
> base-commit: e8c2f9fdadee7cbc75134dc463c1e0d856d6e5c7


