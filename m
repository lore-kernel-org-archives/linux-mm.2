Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 762E3CCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 08:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7800D6B00C9; Mon, 19 Oct 2026 04:13:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7579F6B0170; Mon, 19 Oct 2026 04:13:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66F886B0171; Mon, 19 Oct 2026 04:13:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41D526B00C9
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:13:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C09901405CB
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:13:07 +0000 (UTC)
X-FDA: 85338660414.08.D71D752
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9DCD1180002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:13:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ScN3WlME;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792397586;
	b=l82Xt3/B6KW13oEEwtRGLUCvcirCyGPCq90LkAZDZnKC83A6SgnQQ8ia61KSwYoNbtOBkN
	5csNzixDYx9bL84+hlkKsVB50zwQdOoelhUn5qY4lW+XcYP1vrxkryiaoXHSYs5yvQ8Za1
	cf3244w4RDFJU+0xc4ZY4dT9RF131F0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ScN3WlME;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792397586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TE/b1vGpQ3zzRCCJUuIygS9h4aYbpZH8vZP0Ck1WhPk=;
	b=nULbXNBdlMI+9FOu+WRBuRiihzB54RXE/CFmPDEBOBh+cnlRkZ+G/PsjOhoZGuW/mo8buv
	djAtv3Obq9alyq8LSTfFGqWhQMdJhEkp5Hrv7wWtIBp+Tbd6X3koJDaOGvqqVwfUvChdcC
	uSj58epWxK0ji9y5loMW4MJniVjT0sk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 449F11477;
	Mon, 19 Oct 2026 01:13:01 -0700 (PDT)
Received: from [10.164.19.55] (unknown [10.164.19.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 01C893F673;
	Mon, 19 Oct 2026 01:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792397584; bh=J+CS5fDSpkD3yZQR05hOJn3PmeuKCGE/5OUyR0Qg/dA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ScN3WlMECk4NXBAmST1T9qGWJsM371k2ZAqhsGXlCB43d1V6BGnTWNP16+ieLeOAn
	 ChnTbqWSqJDuX3DOttFoSSb1A3JjE8UGnbdr+tUe25JzOtw63gszgPPYJnEnza7GbU
	 eW9b2ajdBqijvSRJqrPcEQ399ZJssTkWnFjh12e8=
Message-ID: <8e54025a-03da-4cba-bae8-1604463c7622@arm.com>
Date: Mon, 19 Oct 2026 13:42:55 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 2/4] mm: compaction: target mTHP order for
 proactive compaction
To: Bo Zhang <zhangbo0325@gmail.com>, akpm@linux-foundation.org,
 vbabka@kernel.org, david@kernel.org
Cc: surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
 hannes@cmpxchg.org, ziy@nvidia.com, ljs@kernel.org, liam@infradead.org,
 rppt@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 kasong@tencent.com, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, zhaonanzhe@xiaomi.com,
 lipengfei28@xiaomi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Bo Zhang <zhangbo56@xiaomi.com>
References: <20261001001412.3837085-1-zhangbo56@xiaomi.com>
 <20261001001412.3837085-3-zhangbo56@xiaomi.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261001001412.3837085-3-zhangbo56@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9DCD1180002
X-Stat-Signature: ttdqtim37gbfsghgbf6sah8deo3iq8qs
X-Rspam-User: 
X-HE-Tag: 1792397585-648977
X-HE-Meta: U2FsdGVkX18kVs9QcCaVeDQ19CdlCwDl9PxCOr5wHFj4vf+EYwR98ilje4QA5KU+lFQPTLzNYPQGuA7U5mzibK/5ddbQYdHzghKtMV+f29P6B/zz+1hbqX3glCLbhJpN5K2QJszXXmbsWn45MhvEaAzAjCvMXtBZyoDHB9Av0/nVkjXMkxhkE1BG3Fr9SUjT+dtUpSQMYUchHbLkwN+UY/1yxqmXUpGcxwnw1vabxIyw9HHk2TH5kxymcBKFVP8xi4V+4hKHhvPM3PIJN8pTeXETu6edzhefW11kN3Umt83Wk4kLOunyGXfY+bmgkurvXWrxJmEaQnFf4yYMzVUPrfAIkH0sy6RApVCx70XvU5lFbcxHkN4y1fgYlyqr4zEw1nE1QSI9A38bL2pj6iCggZYn8U/9uM5VNOYlYfcpvQ3I3F/8rLAov5vEZGyTtkB+a71Ha/LgPHFhIaoFRW0c10OKOP74VYGW1naQ4TCbPNqPmPDYjg1H91kj5/O2STEfSPdIb83POa0Mk+Ze5W1IbAT/n2/T8GEX3g71hYZqVvza2UuVd7z1xuJYibJv9KoYcdOJYyxv8AzI5Y5910m9tk2yVd91PVVs9qc15o3y+3jEzVmqUzzesUgRqWVid4/BbjAVb121stVpPss0OO3oyW4UQNRcppTfPOdJF5HUkstWnjKWMFBerQ4AtxfiCVXpGQhImny46VtD9nrAl/G0W0zLrroVyZmk0PX8zNO7R8iisJg+EejERxjQuSORbRF402Uuawe2Y0P6/pTJoOckvfP8yQn32X/p1dR8Wk2WeWcP/h286XPtwdk4Zbva1diDupkQDhE461nUewL8ln870gkVBpC0338Ye604wSNFfs2wjrYG2A37nqA0aP148MYRlqQ68siNfic5/c+itXsI1e5M2++tCF0EVcFMt7ZMgx4kWfBC7eT51Xl1iVVSLtYG9K6rIgPxuSe56E42TGe
 vBGoNGUT
 ZpniBQTxxwXaG2P1esICC8hV/Rk9WW2Zftevt0ECkb07tK9GA4jH5C89/M7WFlEeyY61POTx09NtCqdkgN2CDJvsd57oPWa5+rJALR1PZWWDgNzcr/acu7z2M66hiV/+5LnHmqadh8q9qKPztFXBIfweP5jIsY+ZM98VxqeQ3erv08CEYlIka9pDHI/jwSuFtpRooAxg84Lw1JmD7dH8NKtuC6SvHR+UE8THJRQpK4inZJeXjWAK8CEPugSDw21gdvjMpbdNFCpnFUmJ3Ko0BV9rqScdGlGdwz0Du
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/10/26 5:44 am, Bo Zhang wrote:
> Proactive compaction triggers against COMPACTION_HPAGE_ORDER (order-9),
> which is too heavyweight and misdirected for mTHP systems where the
> pressure is on smaller orders like order-2.
> 
> Add compact_hpage_order() to return the highest always-enabled anonymous
> mTHP order, and use it as the proactive compaction target in
> should_proactive_compact_node(), __compact_finished() and kcompactd().
> 
> Fragmentation scores are not comparable across orders, a small order
> scores much lower for the same state, so scale the proactive watermarks
> down in proportion to the target order, otherwise order-2 would rarely
> reach the order-9 threshold.
> 
> Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
> ---
>  mm/compaction.c | 40 ++++++++++++++++++++++++++++++++--------
>  1 file changed, 32 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index ecd3e6cf54fc..3928a5483efc 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -24,6 +24,7 @@
>  #include <linux/page_owner.h>
>  #include <linux/psi.h>
>  #include <linux/cpuset.h>
> +#include <linux/huge_mm.h>
>  #include "page_alloc.h"
>  #include "internal.h"
>  
> @@ -81,6 +82,17 @@ static inline bool is_via_compact_memory(int order) { return false; }
>  #define COMPACTION_HPAGE_ORDER	(PMD_SHIFT - PAGE_SHIFT)
>  #endif
>  
> +static inline int compact_hpage_order(void)
> +{
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	unsigned long orders = READ_ONCE(huge_anon_orders_always);
> +
> +	if (orders)
> +		return __fls(orders);
> +#endif
> +	return COMPACTION_HPAGE_ORDER;
> +}
> +
>  static struct page *mark_allocated_noprof(struct page *page, unsigned int order, gfp_t gfp_flags)
>  {
>  	post_alloc_hook(page, order, __GFP_MOVABLE, ALLOC_DEFAULT);
> @@ -2257,24 +2269,36 @@ static unsigned int fragmentation_score_node(pg_data_t *pgdat, unsigned int orde
>  	return score;
>  }
>  
> -static unsigned int fragmentation_score_wmark(bool low)
> +/*
> + * Fragmentation scores are not comparable across orders: a lower order
> + * scores much lower than a higher order for the same fragmentation state.
> + * Scale the watermark proportionally to the target order so a small order
> + * can still trigger proactive compaction; COMPACTION_HPAGE_ORDER keeps the
> + * original threshold.
> + */
> +static unsigned int fragmentation_score_wmark(bool low, unsigned int order)
>  {
> -	unsigned int wmark_low, leeway;
> +	unsigned int wmark_low, leeway, wmark;
>  
>  	wmark_low = 100U - sysctl_compaction_proactiveness;
>  	leeway = min(10U, wmark_low / 2);
> -	return low ? wmark_low : min(wmark_low + leeway, 100U);
> +	wmark = low ? wmark_low : min(wmark_low + leeway, 100U);
> +
> +	if (order < COMPACTION_HPAGE_ORDER)
> +		wmark = wmark * order / COMPACTION_HPAGE_ORDER;
> +
> +	return wmark;
>  }

I wonder if this function should be left alone?

compaction_proactiveness, as I understand is given as a sysfs knob to
ensure that the user can control how much power they want to invest into
compacting. So suppose the value is 20, and the highest mTHP order is
only 2.

This gives wmark = 90 * 2 / 9 = 20. So, even if 80% of the memory can
serve order-2 allocations, we will still perform compaction for order-2.
This seems "extremely proactive" :)

>  
>  static bool should_proactive_compact_node(pg_data_t *pgdat)
>  {
>  	int wmark_high;
> -	unsigned int order = COMPACTION_HPAGE_ORDER;
> +	unsigned int order = compact_hpage_order();
>  
>  	if (!sysctl_compaction_proactiveness || kswapd_is_running(pgdat))
>  		return false;
>  
> -	wmark_high = fragmentation_score_wmark(false);
> +	wmark_high = fragmentation_score_wmark(false, order);
>  	return fragmentation_score_node(pgdat, order) > wmark_high;
>  }
>  
> @@ -2306,7 +2330,7 @@ static enum compact_result __compact_finished(struct compact_control *cc)
>  
>  	if (cc->proactive_compaction) {
>  		int score, wmark_low;
> -		unsigned int order = COMPACTION_HPAGE_ORDER;
> +		unsigned int order = compact_hpage_order();
>  		pg_data_t *pgdat;
>  
>  		pgdat = cc->zone->zone_pgdat;
> @@ -2314,7 +2338,7 @@ static enum compact_result __compact_finished(struct compact_control *cc)
>  			return COMPACT_PARTIAL_SKIPPED;
>  
>  		score = fragmentation_score_zone(cc->zone, order);
> -		wmark_low = fragmentation_score_wmark(true);
> +		wmark_low = fragmentation_score_wmark(true, order);
>  
>  		if (score > wmark_low)
>  			ret = COMPACT_CONTINUE;
> @@ -3239,7 +3263,7 @@ static int kcompactd(void *p)
>  		timeout = default_timeout;
>  		if (should_proactive_compact_node(pgdat)) {
>  			unsigned int prev_score, score;
> -			unsigned int order = COMPACTION_HPAGE_ORDER;
> +			unsigned int order = compact_hpage_order();
>  
>  			prev_score = fragmentation_score_node(pgdat, order);
>  			compact_node(pgdat, true);


