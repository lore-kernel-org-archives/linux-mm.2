Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A40D6CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 08:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAF246B0088; Wed,  3 Jun 2026 04:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5FA06B008A; Wed,  3 Jun 2026 04:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9C2B6B008C; Wed,  3 Jun 2026 04:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C9FE26B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 04:20:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B2E0A0292
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:20:59 +0000 (UTC)
X-FDA: 84837905838.16.BCB6173
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8EFB7A000C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:20:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yon+l6xv;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780474857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pRq08K52AkaLabs+jxp0xNc16t19qkjFsQsci3lW46U=;
	b=oA88pM65MXVV1LCcF6asrtleSLuPifUIwa6a2pdTqM5H+kbKkULMNvN/m02U/DyXziNUwN
	59f3/Vq+G8bwVW2NPmymCaTScUK9wVZSRUckOeftbBH2B4DwLKGkoPaC8zzBRT4q/8Z3Hp
	5GNNXVu4mjEYLOZyBkfiN9FwOCNb88Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780474857;
	b=PVAhmcPjZi48zMkPFby1MMSTYfhbdlFS144HBJhCCeV4HkwAWuTDbM2+swP3+bc8OlOcb0
	5Pv6jK/k4xqOB/C0mkwvievu9zH98o2lbz8bOijKOaqjvtFmIwbuMV9KCXzwdeTxF6RWRK
	8KXSTdDeFKX+9mf7lsYjHzfcRBGE7OI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yon+l6xv;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 915DF402FF;
	Wed,  3 Jun 2026 08:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876031F00893;
	Wed,  3 Jun 2026 08:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780474856;
	bh=pRq08K52AkaLabs+jxp0xNc16t19qkjFsQsci3lW46U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Yon+l6xv26goOGhhSdePN8NWbgDf1PVL1auDkr/lBwrgNBxCRcN98yH5Qf7dHaJdt
	 WykOJy3d8zrluxD6+rutk4eyES4j4HscjBpEndXJmFaH+EUJ1SmgByhPRgBUT5zjNd
	 C0F4G7u2zo/cWZL2SO6QRXccr3f1BxzaPIczJZ0rOXHo8stFqa4jR59aVTdTDdhSYq
	 bxG1WlrDamIR97USXvKBv1fV4qC3+o0k6YfTQZB0F7VtoE3ctfBQvI+Ssiu65fxJLy
	 dgFNzXwMy6NjrILlhNtGj/80v+fM/7afFSho0s9Sisj7yQLjlAdu1PpYwsulClTt/L
	 KD2zL1pRykpQg==
Message-ID: <19983eab-0fcd-4ec3-955d-a18233bc4b59@kernel.org>
Date: Wed, 3 Jun 2026 10:20:53 +0200
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
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260519200851.141955-1-jp.kobryn@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8EFB7A000C
X-Stat-Signature: wstsxucmrmwxgt73bpr9t5i8c5sob61z
X-HE-Tag: 1780474857-23217
X-HE-Meta: U2FsdGVkX1/UVTptwLiLU3YuaDvJAMeqKAfCFmLyzk3uUm0cvBGBlGmHhk0ZBkN9dAop5OzcOUvyZfnswBdpASwqmeHUUNWTbpAlLku/qNx7hnxT56uKyUYPNH/hUtybaMv+/Phh604dBla693ZntM2s/BI636HZhpwHsBra9LdLdAvCTyVSP9GFUdDDeO2BFjBwor706yir6soKP82mjXxJZ3lF/tOmYxrbhZWs8aAb8Ubf66N1XF0dCj85AybG7s+AJIIXFNY3YUso0TzaawMbSl+IJS1hjxb83dpf9ve2NX352yHIwPTQUGW8+z13cRnmP5VTgvH7Odr9LvjmYASLuinDQTcaTf2owBUOcwUEKVtuPzdRIHB95qEsljXWWWbBlXdvbUUDxTiG3TQtINQXMQihSXySIEHowZBn1uK00IVmKg7cknUaFl0fewAFP8Rc62DBjEsJ9+ZQFMqdysqMq15/iWh+J0UACX2uzbuozUdvZfvVeW9FOCsgC/2Ny71ZD9VuMx97t3k7ih/TCh0PoelQku4ZRR9Sk4/VeY9ZJRHZE0kqnPHujT7PoDZdpco55H898wkuAjBRv91kcwlY4gaShy0U/mD8NgY1I3Y3NJVCTN0EzY9qqEghP7IOWDEOP6vw/KsRzr48y/ZbTfgffgt8ShQcZpe8NgnKTfrDabi0p6Y3x/41Y77dg2Vsj8vOcOJqxKdvI0U36+8zCEqlJkx6Ikk7O5Co5uHhvDa9hLobeG921cqYGm6V/xsNwLcsMMzaX4Z68QHqWRkwECwKdXx6ls3e5daoG3zdGTSf0VLwdmEjtH21REzh947YTF5ywRGLyJw8Wmxr5zAOyBKX6fSClDsQFWbRJltnmCPJAUgteDB0YauYBDXSn1KXyHhvyB5+lWW4fwoSF0g1xbBvEaQIXoItnKwavjjkuyKP/XMTEQVcwzV0PaFsoUQvXyhsxqVEPdWTeV3fjhP
 SDUqIFEz
 tolfUnj6TbnTOvCuBnLeedVlAgiv25P44sz0CT1S5voD6B8k1gc7yB02Pteo3C1OvTEofZnv/+ZzcVQq0LO0VVkQKbz7cMuhwus9rgIcX6MOaxk/xizOcGWctRNEC7/M0rbi/kIRtmbQHGiSYVQjUiOxLbqEEGjVOtquYfb5UPTL1oiL2yvUC3SPlyiHtpeevA9OIgciY7ACnBjIVYRkg3Wk/lB8+ieyEAxnJ3N67KoTPgIO/6N4uLmpVia9Jxy+Lf740yON/KB1t+B3kTwiZQ8aq/2YB2mFSJ9pJOx+SoVfgxpF/mLqvzawMbtAtpKCrlfaOfQt3ImhKaXs=
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
> continue a majority of the time. The over-sized gap also causes 46% of
> order-9 compaction suitability checks to fail unnecessarily - the zone has
> sufficient free pages for the scanner to operate, but not enough to clear
> the inflated threshold.
> 
> Cap compact_gap() at COMPACT_CLUSTER_MAX to align the watermark headroom
> with the scanner's actual capacity. Orders 0-4 are unaffected since their
> gap is <= 32.
> 
> A/B test on ~100 instagram production hosts (64GB, 60s measurement):
> 
> Unpatched (43 hosts)
> pgscan_kswapd (mean/host): ~1.6M
> reclaim efficiency (steal/scan): 83.8%
> compaction success (success/stall): 2.1%
> THP success (alloc/alloc+fallback): 4.9%
> forced lru_add_drain (mean/host): ~107K
> 
> Patched (59 hosts)
> pgscan_kswapd (mean/host): ~449K
> reclaim efficiency (steal/scan): 91.0%
> compaction success (success/stall): 28.3%
> THP success (alloc/alloc+fallback): 17.2%
> forced lru_add_drain (mean/host): ~64K
> 
> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

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
>  }
>  
>  static inline int current_is_kcompactd(void)


