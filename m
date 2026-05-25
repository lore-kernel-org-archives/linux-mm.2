Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00A75CD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 10:03:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF5176B0005; Mon, 25 May 2026 06:03:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCCAF6B0088; Mon, 25 May 2026 06:03:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE2E76B008A; Mon, 25 May 2026 06:03:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D45E6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:03:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 56C9C140203
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:03:04 +0000 (UTC)
X-FDA: 84805503888.29.92D7D8A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6902040002
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:03:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FjCmrlGJ;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779703382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x0mhL5vcU+s/d/EqLj9OBWnDvQEhqCVklpI8plUjfIM=;
	b=TNvlpXFgg0xlfLrS6xrZgBi4ml9tf5TYYrgHtY0OD3gbjfbikmM8P8z2ShOc4zUQiLNwBK
	6JkIT+8/hcoM8Y+GoaZOLon+LlzjtNwHi97+uKaGcqet6M/VMnyAm65ax1TeCzMfxzhyOD
	XW+VnIU4s3O9HNwt8H9801TXFeVZmnY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FjCmrlGJ;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779703382; a=rsa-sha256;
	cv=none;
	b=gOrL0cEiVsPTlzPU7CsYwAv4Q9eY1M10/bCuT1dN7aRAs2KMjKQZlOnF4KzcRzZ+EZq/LA
	6Mc88qG5vBcwwEH4dg9KilGIkrO3zmth0a8kKFuMyysyArTIO1c/b4vq+7qBQZUK12Ouu7
	7n6cdQtLXezhDOMEp+NQx2DdezigHLo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F9B543680;
	Mon, 25 May 2026 10:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946EF1F000E9;
	Mon, 25 May 2026 10:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779703381;
	bh=x0mhL5vcU+s/d/EqLj9OBWnDvQEhqCVklpI8plUjfIM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FjCmrlGJvRw2Hf7xIiX6gaNGFNj2oH0Dixotx08k96/MBSiZ/jKWyLVKUZlFLONKu
	 37SsGP/D0LVR5zVy/8jkAt4BI4flwe+eet5Sd9Ulo+bSuqumED+qzbg3AbzbBTeV9/
	 4EWVnXFIX/EqvRjuwpkHRNLIRnioH3L2Ng519jWBpUpZxD1SueauP9/KEuBE19DEuO
	 X+l/uUAstLH8R6MZpbD+kS/Od7MBLnUfSCGxSmRDoWDTMkzrGBw54JZ2kcgOBqBDhE
	 ZVdjZM+ER2CRkBIbgghXxpELz4A5TXf/YZBErdrqhCd1WXAVR3NPy1KuW78TJkc+ey
	 spWSC/pZVlngQ==
Message-ID: <b4e49d71-bcd6-4c6c-87cb-2dbd75b3c2bb@kernel.org>
Date: Mon, 25 May 2026 12:02:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/compaction: cap compact_gap() at COMPACT_CLUSTER_MAX
Content-Language: en-US
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>, akpm@linux-foundation.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260519200851.141955-1-jp.kobryn@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260519200851.141955-1-jp.kobryn@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7zc315wxtwsrnduswxoc4p95s7hni9s7
X-Rspamd-Queue-Id: 6902040002
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779703382-221988
X-HE-Meta: U2FsdGVkX19AuesE//cbaLTKDvoT4Fe9+LsyvG5R+uaBEzeSSLiM3NYreJS4avNJo6rYbecpbUxpUyU4i2EsssmzgCNUheyKYKt5OaDgh7zL+zAQGmsC36AlUQW0SE4caPJ1N7Jf2vd1xKpta8WaEBb0GZlwI4jZZQVH0/kX7q/uEBDuZ7wn7QKxaNAaAzVURjTf9sRs9fxhjGjKOXehkOGE5z8PEXj93LBTpygZsjTxC+InDnnRPZl7UmZvS8ceJYoM2rt0vBrY7KlQsyuzJeSDnPcY6qxFk/kA9+WAkJHjvHUl69G3PzW43Di/TQZHjfHJsIFCiGSsZ1VEdrMQ7rn1FaxcDeWStbYdHVbLdl2YqdBRfl9ucxiap5XoCtyKeZNmNzt9Y3VslF5aZcf7DH5UU1mRY7f8RqFNyQSkTeC47IuW7xwy3e2BevqUmTRFgOF2X7jPGy5f2L5Qd3pqM/E2C8bm4so3+cJ+0ArirOdqdJSB1eWHb8I/2S0TD4iLuhDPKQp5LHidmTsyUr6XaXSxrGUp8GoNkOjITOlIFNC8ghnWca6FaZ2PpYveoBzNYTXNy559XeYEk8bxxpX9pj/mygGoommhHALS9ZNU6hVaSlvW9Eush7Ul7FhiaSWQPjzYSiSVuDLgdUo8ZGEK7Tz82fkadH0sLT3XK0imD2Z/BxgLQ5p77ElDLwcMjcWy1dajeG6h3VL/CIttT7J4ZV0i0Pzve8NtoGnN6bOhDC3TcQYicWRHKtUTicgoX1tuXn6SH6vlgwOJlXDgmbE0wqVdMGL3ETQV7BY51gxlS1SjhR86gG78vuFkh9WB+OrHIv3X2WP0OKrae1TlIoktI3H8laKb1Z2HyxVowyZl0gg8AVmJdeF6cdhhJGE+qynwZNvFgnxLiSlfS+gvf6pWv0vlPdU6ll2OITVo82MCA7j5myXktfWFunY7GWTFDA0KV+p2LJGM29H6h+v+BOr
 wgrBw/+/
 4e8GGnU7/pzq4xdAJ+gDf9Y+YuJd8V85eB55Q7a/yiiKKbuQruB59A41wCzT72a0U49vC5j2gabkfzNCLnl+CujyX60trzeWstdY+Tkn3d+Ru/LeVxBpT9qz3QHKPfNFXUgvu1q4a4g/CiCYQqGFtdVw9VU0vT6Rn2uGush0BYq73hNSm14wxTpeEqVJAh6wr8VoBI/KWlidkPBQL+Uosp86p7o5pnavmPAQ13dvXN8A6OHvaNaMqhJDB3XupyD1sbvaAExfm6AZscdDiUTnDJm3rw+vf/6V2IcElWVI8E66DkNvfcL5nTRIWrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/19/26 22:08, JP Kobryn (Meta) wrote:
> compact_gap() returns 2 << order, which is used as watermark headroom in
> __compaction_suitable() and as a reclaim target in kswapd. The computed
> value scales exponentially by order. For order-9 THP allocations this
> evaluates to 1024 pages, but the compaction free scanner's working set is
> bounded by COMPACT_CLUSTER_MAX (32 pages). The scanner stops isolating free
> pages once it matches the migration batch. The current gap over-reserves by
> 32x.
> 
> On fragmented production hosts, kswapd will try and reclaim up to the gap,
> but it only reaches that threshold 18% of the time, causing reclaim to
> continue a majority of the time.

But doesn't that mean there's genuine memory pressure? We're effectively
raising the high watermark by 4 MB, but if processes are continuously
allocating, we'd be reclaiming without the gap as well? Unless the workload
is sized to fit without the gap.

> The over-sized gap also causes 46% of
> order-9 compaction suitability checks to fail unnecessarily - the zone has
> sufficient free pages for the scanner to operate, but not enough to clear
> the inflated threshold.
> 
> Cap compact_gap() at COMPACT_CLUSTER_MAX to align the watermark headroom
> with the scanner's actual capacity. Orders 0-4 are unaffected since their
> gap is <= 32.
> 
> A/B test on ~100 instagram production hosts (64GB, 60s measurement):

What was the base kernel version?

> Unpatched (43 hosts)
> pgscan_kswapd (mean/host): ~1.6M
> reclaim efficiency (steal/scan): 83.8%
> compaction success (success/stall): 2.1%
> THP success (alloc/alloc+fallback): 4.9%
> forced lru_add_drain (mean/host): ~107K
> 
> Patched (59 hosts)
> pgscan_kswapd (mean/host): ~449K

Did the extra reclaim just disappear because we allow the allocations to use
4MB more memory? Or it shifted to direct reclaim?

> reclaim efficiency (steal/scan): 91.0%
> compaction success (success/stall): 28.3%

Is this compaction success per compaction stall or per alloc stall?

> THP success (alloc/alloc+fallback): 17.2%

Weird that things would improve that much. I would expect the free memory
just to stabilize around the lower gap but then behave similarly. Are we
missing something here?

> forced lru_add_drain (mean/host): ~64K
> 
> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
> ---
>  include/linux/compaction.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/compaction.h b/include/linux/compaction.h
> index 173d9c07a8952..09aea63b8a89d 100644
> --- a/include/linux/compaction.h
> +++ b/include/linux/compaction.h
> @@ -2,6 +2,8 @@
>  #ifndef _LINUX_COMPACTION_H
>  #define _LINUX_COMPACTION_H
>  
> +#include <linux/swap.h>
> +
>  /*
>   * Determines how hard direct compaction should try to succeed.
>   * Lower value means higher priority, analogically to reclaim priority.
> @@ -73,11 +75,9 @@ static inline unsigned long compact_gap(unsigned int order)
>  	 * effectively limited by COMPACT_CLUSTER_MAX, as that's the maximum
>  	 * that the migrate scanner can have isolated on migrate list, and free
>  	 * scanner is only invoked when the number of isolated free pages is
> -	 * lower than that. But it's not worth to complicate the formula here
> -	 * as a bigger gap for higher orders than strictly necessary can also
> -	 * improve chances of compaction success.
> +	 * lower than that.
>  	 */
> -	return 2UL << order;
> +	return min(2UL << order, COMPACT_CLUSTER_MAX);

Shouldn't it at least be 2x COMPACT_CLUSTER_MAX?

>  }
>  
>  static inline int current_is_kcompactd(void)


