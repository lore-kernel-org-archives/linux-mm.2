Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FB64C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 08:36:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4980D6B008A; Wed, 26 Aug 2026 04:35:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46FDF6B0092; Wed, 26 Aug 2026 04:35:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3867E6B0096; Wed, 26 Aug 2026 04:35:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1992F6B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:35:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 78A9A1202DF
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:35:57 +0000 (UTC)
X-FDA: 85142762754.16.8606A26
Received: from mta1.migadu.com (out-67.mta1.migadu.com [95.215.58.67])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7C8584000A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:35:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qkROGacs;
	spf=pass (imf12.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.67 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787733355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ctCDnFeGuwrBYSy8Y7fSEhbpQlgXRyhkoTx4fdSuPYU=;
	b=kBEhIjhWJeOGiSnGUkIG5UpJ9BCsRkP0xYnuk0DsLiw/f1aeh0Zo33+XSj+LQjo2Xxwkbi
	ch+VwwrfWCB3WmAhpMLCnH6naufwO8V9bLlCgRXFS//0vIvQ1DG64TCFAQl4NvyNeWQgtK
	WQMtBvuQT1hngV6XSjeT28wrNTQjHLs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qkROGacs;
	spf=pass (imf12.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.67 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787733355;
	b=IQaNNTlDPx/J1VvCKe9/ip01DmEMx+aFw1NLkhffdUnOp9pGaXo8TFWPHAQMMeEUhXuG13
	7IwwWZsKAwG8ZeeAm++QYfb8P3N7bE2/4QihiFSlmc2KYOFH1muR2Epu6AqwX/gLxbc8KJ
	pB3yoLbD6Y0io36qT9qKXhYxfr8F2v8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CsLGx21OxmzsS6r/w1wM+4tvAX2yiYA/4i9KpoVmiXA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787733354; v=1; x=1788338154;
 b=qkROGacsSvEIqkbEgFoB9rYMjvH9BMMO5io0VQuU8TU8QCtynZkbQ4O6lKXHaydkes50vqgz
 A6nn+46dpAGKcgzL2pJk1iAQP/I9rLsL4RsAWfjaXsz4FTRFAfjnKHyBZE8g/AV9WE0a9KtR1na
 aTR+GmNajCUc9NP3tRUTUwYg=
X-Envelope-To: linux-mm@kvack.org
Received: from fedora (117.129.78.49)
	by smtp.migadu.com with ESMTPS id 7113056e3fa926fe;
	Wed, 26 Aug 2026 08:35:53 +0000
X-Mizu-Trace-ID: 7113056e3fa926fe
X-Migadu-Flow: FLOW_OUT
Date: Wed, 26 Aug 2026 16:35:43 +0800
From: Hao Li <hao.li@linux.dev>
To: Longlong Xia <xialonglong2025@163.com>
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, paulmck@kernel.org, 
	rcu@vger.kernel.org, xialonglong@kylinos.cn
Subject: Re: [PATCH v2] mm/slab_common: fix shrink budget underflow in
 kfree_rcu_shrink_scan
Message-ID: <ao6lD5kJMotCFBDU@fedora>
References: <20260826075653.3304251-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826075653.3304251-1-xialonglong2025@163.com>
X-Stat-Signature: jeqqg45dj7unkut4xru7ztw5z1xn19ic
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7C8584000A
X-Rspam-User: 
X-HE-Tag: 1787733355-334644
X-HE-Meta: U2FsdGVkX1+7epGkiD+k8l5Q/vEuE2SXgnkNOeQ6S1wHvsuLnhS9DR7veaHSGxQbbjF8+sfsymgiyo+OUV68DJJKDF1xX8cc314j4DO/KdCTFKIJPahAiCLkQU5LfA2OGCWXro08/7BnFOok0nuFRuDuQufWEP20DDfP6gG64mDKYMUkpkR1zgLBgcJAgUeo5HyA47dqdKMBupq/o5+9JHnSvB3yeqGvfeCHqmQTRwVJbwJOHzUVJXjaNjPNdMzUSK6UQ/QTbWzknWmMXoYVsU0KmozHQ5qn+2hFCe/SuUkAnS1A1b08tNVnrVHm5RNFp6s70RK8bM45kTYlkgE8bbG4zkM+QR10RvGybOILodZc3NHMeZHXHyW40e2H6ieCra1FB133JBZvqkU0HxEUtkDk4KpOCB/+iBqNzmSyavrwKeHH6GBF/popn7muvEQaN+x4ppKIBYzidf32KBbEl71RI3F/aQL7pIZigfczm3ySNZppmmk1hswAZATeV96UuzGDv8LcKo9H4R0tvxY6+gmYOhTMuXZ+8+okRmN3uHh0PZE1kH20nz/sC5hPiA3ChRk/Jo9o4VyQ6f4dJ2YjtX9gAYBCiFWaMSv0r8qU8Lxo0waJO5PlHXLc6Y/hZdo4+FX3PtPC5Fu7VVu7QJRm0uHSqmbox8Lp386aNaqqvdlxaAIi/O/POPJgSRl4jDKX9H18HUPFb3sWoNf8tt1+L5UeZQyHGz1k30U9asrXl1cyRa+xbixDbKscLaaWP7XAmvep3RLxjreyVmYHkXOpU3XkYs5wR5zKsKp4kOfOlUptTYBNoJhyqvA+4SyFfN3jF37yf7w0xFwrCXmtXNEBmUrsTx7r3MMGxqZ9KsnSnBK4AT9f4PdT4F9IaI9SnVyN4OhFiCHxjaIqf6D3X2+Q+bfK3nT4zAjlUUJl9aVUcw9NgteAcfJKPrYwZE8LWEdUP6EFDHNInbJGWHpDdEP
 7ml14DEo
 V0eTXNFIv7hTzSQyoClyU5w9h+VqltpXZNb7u7HWS6o9YmnDSUKZ/jkz5cMJ9/VuJQQklLtRc0YfedK78dgRwxAgOBdoOCx02NYYP6cbH+BQqB4d7znINpJvJ95eVS3xjil0vxi52NWhbnv8MwAqPqLuvjRn/OvL2S05rCRb4o4Ui7NME8c358ACu8WG5+nhIQWdkC/1U9E7SMnQGZqBWolq3sB1/hWEBidHeXqxkqoj1lB8Lg7lubH1+g7/3V7dbK6Q00ubd4W8/q1Q5LSFZors+GkhXsEc1Xy4Fn60MOCmUvPavRufGWkH1fjf7oNB9uggdmhyeNU9epomCMEX2x0YZz66DpiAzhFtEgW/YOv3G7uA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 03:56:53PM +0800, Longlong Xia wrote:
> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> The kfree_rcu shrinker decremented sc->nr_to_scan (unsigned long)
> and then tested the result with <= 0. When a single CPU's object
> count exceeds the remaining budget, the subtraction wraps to a large
> positive value and the <= 0 comparison, which is equivalent to == 0
> for an unsigned type, never fires again. The scan loop then iterates
> through every possible CPU instead of honouring the reclaim budget.
> 
> Accumulate into freed and stop once freed >= nr_to_scan. The shrinker
> core treats nr_to_scan as input-only, so dropping the decrement is
> safe; freed becomes unsigned long to match the return type.
> 
> Suggested-by: Hao Li <hao.li@linux.dev>
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
> ---
> Changes in v2:
> - Rework per suggestion from Hao Li: accumulate into freed directly,
>   compare freed >= nr_to_scan instead of decrementing nr_to_scan, and
>   drop the per-CPU count local; promote freed to unsigned long.
> 
> Link: https://lore.kernel.org/all/20260824091838.1692153-1-xialonglong2025@163.com/
> ---
>  mm/slab_common.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 

Looks good to me. Thanks.
Reviewed-by: Hao Li <hao.li@linux.dev>

> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 657fd75776ea..e227c2ef2a4e 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -2162,20 +2162,17 @@ kfree_rcu_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
>  static unsigned long
>  kfree_rcu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
>  {
> -	int cpu, freed = 0;
> +	int cpu;
> +	unsigned long freed = 0;
>  
>  	for_each_possible_cpu(cpu) {
> -		int count;
>  		struct kfree_rcu_cpu *krcp = per_cpu_ptr(&krc, cpu);
>  
> -		count = krc_count(krcp);
> -		count += drain_page_cache(krcp);
> +		freed += krc_count(krcp);
> +		freed += drain_page_cache(krcp);
>  		kfree_rcu_monitor(&krcp->monitor_work.work);
>  
> -		sc->nr_to_scan -= count;
> -		freed += count;
> -
> -		if (sc->nr_to_scan <= 0)
> +		if (freed >= sc->nr_to_scan)
>  			break;
>  	}
>  
> -- 
> 2.43.0
> 

-- 
Thanks,
Hao

