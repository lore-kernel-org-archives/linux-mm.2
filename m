Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FDD1FA3755
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 18:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B1016B0088; Fri,  2 Jan 2026 13:30:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55F016B0089; Fri,  2 Jan 2026 13:30:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46AD46B008A; Fri,  2 Jan 2026 13:30:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32E616B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 13:30:05 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C0AC11A096C
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 18:30:04 +0000 (UTC)
X-FDA: 84287863128.03.D8BD631
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id EF3A12000F
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 18:30:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FBgbRAC3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767378603; a=rsa-sha256;
	cv=none;
	b=iiT8hhUtoJag5soinx5HaY4RYt4mBralJxWVjPinsGauYXCoj/+vYSqWq/+mLCB0kXMUhQ
	+W5j2jKMKQur4oIWpEhKerYWLyC2hUis/bmB5BTvf7Dju9NLiwSDAXbYQgroiVyragvHuq
	Tvkh0jokCKweauZ4u/QwqB9m/fxrEWI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FBgbRAC3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767378603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUGgrw/NV2mN64Y9fKr3VZa07jqcIcG4E1LzDi5Y2Uo=;
	b=0gYh0tfyOIlBrcTDBH1qlY9xv+dwNYhxSOVOth2j1bmcy81bPo7M7kFkaYOlkr6d49+/Ua
	/zv7HtZ2N9leTWKfoClSEBgRJxyXngkZ3LkkbDx4mt+MF8oAcwznXhO7Asn3Tf7u3MiIsl
	hlf4wdaMYmdnn5yWKET4BkqZM8nMAiQ=
Date: Fri, 2 Jan 2026 18:29:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767378600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zUGgrw/NV2mN64Y9fKr3VZa07jqcIcG4E1LzDi5Y2Uo=;
	b=FBgbRAC32l2+kjgITMye0OKfcLx1wOm5J/iyyL9apG9YasiVCWyfOByb3QfEcPj6kEudKb
	sFwhQKTFIksMTeaFZisyXiBCJCUBZpm4F5jX7uQIztfquFuIQZ7LLX2EBI1U5pGnzIQIgt
	EXjIaOepuhK2h3az7iGsczIAou/D7Ms=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
Message-ID: <ddfs43qldaws5urlnpah3ibp5xeu7st37p5hgdfajvdtwor4sd@fkcm3brinygo>
References: <20260101013814.2312147-1-senozhatsky@chromium.org>
 <20260101013814.2312147-3-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260101013814.2312147-3-senozhatsky@chromium.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EF3A12000F
X-Stat-Signature: a7u7z3yjfwwikxiymprcqk4kiy5e3gfi
X-Rspam-User: 
X-HE-Tag: 1767378602-898938
X-HE-Meta: U2FsdGVkX1/Vjupu3AGAkty0IhWiF78LNSwOf1Ip3GlChsl51i9l7NHvY8aOU5oGKzsiJGceLb124pSlobvlpRHWz0eN0WNjwrHbUPerr14jU1WTF7lVjM4NRNCvetgrKbOSl8IE2FCtHIS5+j7l6tYsKQAAMcm96kQg2RreiEhWADV3DrbTQBA999XfiRoV7t/2sqP9vFIvzpDlbdZd2lK9qjQ17P3utmbJoLqBez4cwWTmN2hFwm6Ut6vZScm6hDqJH23jsC+zF3z+XqyiGaqN0aqUXyyDkwnGA0eN8k2P3mnlGpD4YeB0iNoBmLTm4ZGxiFvbSUOgkpl0y5+pD40IrmE1IilPgqJDGEzMiw9NvgK4rRMmlmgukWFGIRThv866Lqcj9kGAbhJplb4jUQBryUqxU8zOEt122T6Mntdh2dYhjadmbIaR49BxTSKuPm7JpFHTdvr9tm02Jj5eSWqAdJyST8ufv8CSaVujvrQm/wR/9T1b7KaFQutTFuq7/c1TUUnB3YeGLTgbqu0iath9m6xx524uvbwBdN9pB/wLjPaArtH2QMKQSjEl1xrAbmFL3955j2kGyicGzHYYfzd2z4WonVPxlI14Ki4UTam0IMDkycG2xNDqFUKu3YHSAPG4QSay04A4e7kl1hR5oKbo3X7pcNoeuvjcQB94+7XCAmKPt+fIKq50HmQZYdB3WJCqcj/sFIuJnKl7xyTCCcQVM1yDt0lSJDcACQg8dx5AS2QLcRZ3kvr71AWdUykhQUHUHmBdDv6OJKcJk4KVbDrxsY9RreeNrt4mwCZRGgiEIfmUtC/8x3XUEsrKR652GQVbaeqFr3eBNSA6cIk68UgTWtNv/HLkdU8cFBu8Bn4yr8HnYR5bvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 01, 2026 at 10:38:14AM +0900, Sergey Senozhatsky wrote:
> This is the first step towards re-thinking optimization strategy
> during chain-size (the number of 0-order physical pages a zspage
> chains for most optimal performance) configuration. Currently,
> we only consider one metric - "wasted" memory - and try various
> chain length configurations in order to find the minimal wasted
> space configuration.  However, this strategy doesn't consider
> the fact that our optimization space is not single-dimensional.
> When we increase zspage chain length we at the same increase the
> number of spanning objects (objects that span two physical pages).
> Such objects slow down read() operations because zsmalloc needs to
> kmap both pages and memcpy objects' chunks.  This clearly increases
> CPU usage and battery drain.
> 
> We, most likely, need to consider numerous metrics and optimize
> in a multi-dimensional space.  These can be wired in later on, for
> now we just add some heuristic to increase zspage chain length only
> if there are substantial savings memory usage wise.  We can tune
> these threshold values (there is a simple user-space tool [2] to
> experiment with those knobs), but what we currently is already
> interesting enough.  Where does this bring us, using a synthetic
> test [1], which produces byte-to-byte comparable workloads, on a
> 4K PAGE_SIZE, chain size 10 system:
> 
> BASE
> ====
>  zsmalloc_test: num write objects: 339598
>  zsmalloc_test: pool pages used 175111, total allocated size 698213488
>  zsmalloc_test: pool memory utilization: 97.3
>  zsmalloc_test: num read objects: 339598
>  zsmalloc_test: spanning objects: 110377, total memcpy size: 278318624
> 
> PATCHED
> =======
>  zsmalloc_test: num write objects: 339598
>  zsmalloc_test: pool pages used 175920, total allocated size 698213488
>  zsmalloc_test: pool memory utilization: 96.8
>  zsmalloc_test: num read objects: 339598
>  zsmalloc_test: spanning objects: 103256, total memcpy size: 265378608
> 
> At a price of 0.5% increased pool memory usage there was a 6.5%
> reduction in a number of spanning objects (4.6% less copied bytes).
> 
> Note, the results are specific to this particular test case.  The
> savings are not uniformly distributed: according to [2] for some
> size classes the reduction in the number of spanning objects
> per-zspage goes down from 7 to 0 (e.g. size class 368), for other
> from 4 to 2 (e.g. size class 640).  So the actual memcpy savings
> are data-pattern dependent, as always.

I worry that the heuristics are too hand-wavy, and I wonder if the
memcpy savings actually show up as perf improvements in any real life
workload. Do we have data about this?

I also vaguely recall discussions about other ways to avoid the memcpy
using scatterlists, so I am wondering if this is the right metric to
optimize.

What are the main pain points for PAGE_SIZE > 4K configs? Is it the
compression/decompression time? In my experience this is usually not the
bottleneck, I would imagine the real problem would be the internal
fragmentation.

> 
> [1] https://github.com/sergey-senozhatsky/simulate-zsmalloc/blob/main/0001-zsmalloc-add-zsmalloc_test-module.patch
> [2] https://github.com/sergey-senozhatsky/simulate-zsmalloc/blob/main/simulate_zsmalloc.c
> 
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---
>  mm/zsmalloc.c | 39 +++++++++++++++++++++++++++++++--------
>  1 file changed, 31 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 5e7501d36161..929db7cf6c19 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -2000,22 +2000,45 @@ static int zs_register_shrinker(struct zs_pool *pool)
>  static int calculate_zspage_chain_size(int class_size)
>  {
>  	int i, min_waste = INT_MAX;
> -	int chain_size = 1;
> +	int best_chain_size = 1;
>  
>  	if (is_power_of_2(class_size))
> -		return chain_size;
> +		return best_chain_size;
>  
>  	for (i = 1; i <= ZS_MAX_PAGES_PER_ZSPAGE; i++) {
> -		int waste;
> +		int curr_waste = (i * PAGE_SIZE) % class_size;
>  
> -		waste = (i * PAGE_SIZE) % class_size;
> -		if (waste < min_waste) {
> -			min_waste = waste;
> -			chain_size = i;
> +		if (curr_waste == 0)
> +			return i;
> +
> +		/*
> +		 * Accept the new chain size if:
> +		 * 1. The current best is wasteful (> 10% of zspage size),
> +		 *    accept anything that is better.
> +		 * 2. The current best is efficient, accept only significant
> +		 *    (25%) improvement.
> +		 */
> +		if (min_waste * 10 > best_chain_size * PAGE_SIZE) {
> +			if (curr_waste < min_waste) {
> +				min_waste = curr_waste;
> +				best_chain_size = i;
> +			}
> +		} else {
> +			if (curr_waste * 4 < min_waste * 3) {
> +				min_waste = curr_waste;
> +				best_chain_size = i;
> +			}
>  		}
> +
> +		/*
> +		 * If the current best chain has low waste (approx < 1.5%
> +		 * relative to zspage size) then accept it right away.
> +		 */
> +		if (min_waste * 64 <= best_chain_size * PAGE_SIZE)
> +			break;
>  	}
>  
> -	return chain_size;
> +	return best_chain_size;
>  }
>  
>  /**
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 

