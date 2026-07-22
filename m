Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E133C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 12:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E65646B0095; Wed, 22 Jul 2026 08:36:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEEEB6B0096; Wed, 22 Jul 2026 08:36:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB6656B0098; Wed, 22 Jul 2026 08:36:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 87B366B0095
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:36:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 09B95120187
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:36:00 +0000 (UTC)
X-FDA: 85016359680.16.676E1F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3E1BE20009
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:35:58 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HyIzudcH;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784723758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Jd1GANGwM+PXpSKQ+CRzq/E6/EDkcfhb0HgkIh9hJw=;
	b=p05NApqKoYsxTGE/BXaGpRdsrnQGeVABIqbzi9L5MwPdadXMInawbfpeFr1cucv5+Nw+Kd
	hW15NOsbbAMPfF8IhjOFFQkxCVtz2xRhWA6G9QWWz5kTggFoRxnUNvXQVrxxcOoqBgdND4
	jYP7ZU/ZoFasF+rgKqCcJYk7qMRUrYA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HyIzudcH;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784723758;
	b=Z665JN+AfwOFjAia1GTmChCaMtRS2oxQXqyYYOpF2PyGwC7OtJNomFc0/d+JF9PwkB5Gsr
	TPxqWi52SeItVp6WrPgojBNUipQrJiqytYzzzjr914Rq2slm/jDu9p788ruMouhpw42r4i
	wmpRb3Ok498QntCoh1ndo0fwPhU1Azg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A1AD40DB7;
	Wed, 22 Jul 2026 12:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003651F000E9;
	Wed, 22 Jul 2026 12:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784723757;
	bh=2Jd1GANGwM+PXpSKQ+CRzq/E6/EDkcfhb0HgkIh9hJw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HyIzudcHgwOZMnwvnVThzTbiSoYQgWKiZ7BSA5Nn93yO5ZwK9lei72TD5EsIyvErW
	 IBdApPWF/AFiQzqCq6bhBEkYP7OBWar0qnqBy6tDn0UVNS/UQDyr4Tr49g9ife1kGG
	 PjgiL6sCmL5DZQR2/qRy3V6BSx7RPXHJ9QG9Tsm6etiWSMv+PcWkqBXCseFJR0wKjC
	 2EiLaTBxgsBcsTcEPY6IrLBGKcD5HpS4iTaK+Ep2QcVcZ/xQT6/7WZKjkyW0RbAhX4
	 2QTChyiE4YyE/kBFyhpYK/tppcL5nZQpL7EuRWN9qfuuxq3FtATsfFiTdrsAKf0uIE
	 phOj7bGLdPLfQ==
Message-ID: <7ddb704c-76a9-4071-8969-06fa1403eb07@kernel.org>
Date: Wed, 22 Jul 2026 14:35:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Content-Language: en-US
To: Salvatore Dipietro <dipiets@amazon.it>, hannes@cmpxchg.org,
 willy@infradead.org
Cc: abuehaze@amazon.com, akpm@linux-foundation.org, alisaidi@amazon.com,
 blakgeof@amazon.com, brauner@kernel.org, dgc@kernel.org,
 dipietro.salvatore@gmail.com, djwong@kernel.org, hch@infradead.org,
 jackmanb@google.com, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
 mhocko@suse.com, ritesh.list@gmail.com, stable@vger.kernel.org,
 surenb@google.com, ziy@nvidia.com
References: <alEz4Chf7Ibyg-ZG@casper.infradead.org>
 <20260714120204.542300-1-dipiets@amazon.it>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260714120204.542300-1-dipiets@amazon.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3E1BE20009
X-Stat-Signature: dsbjgbequ8jfyewb7fuf11uykq6rgzra
X-HE-Tag: 1784723758-20475
X-HE-Meta: U2FsdGVkX18PaVtIdpoIYF+WvpZri3UbbGFb9nONIqzl7sSwU135TzfuxguvbWhXOKb7dWMMxLOg8gpWT04igG+/TZfHdv4gxpMYJrFnkdVAexfTmMFdSGrWi1YHPDtpxAnYk/Nl6jnRy7Ja9HbsB4H5vT1M0k1Ykp7nYf4zOQciIMutQig49UmwMuEF5r5B6jzJ59GwFjO4fQFy+PyeacWKmiTMUHtyor7auGZShPa2evydLQjg+nNPPcUb/p9qORoE3majioVWwLDCR6EnERh3laeHNjCihjO5hUaEZXPD5beCa8zrzYpiVFi8qU3jHXRmy8zWTJdK/GP94fLuVyZILuzFTzaVACz7Cvhxi2VFmU2c9YJiQqx0fBrnDmvMy9PrZbvVNtzg1GGP1qyobN2mIfJfo67Zl2Rt+ni15kmyciFzW9d8AOLq7qhBfJlUd7hOpguZvlkGmqsTLi+7oXvY83hxal9zl4TLhgIBGkL0/AQTEeIPy/9Nv9mqk5/wrkIQWunCG15U9O1YcGtHlfGI5YkFVugvVUaWLEt5TZuyEyGZOB5/gxU0AGhI7hu5x/Yt2pIXOaBUr3/w9Ezsh1aN9HmQaz3oDcPkWl7JL9HMiFHjQOMBr2sQ4TfGmhPMZT/RSwN4XDJnD6/d48YB++Sp41QnVyRjs05pqUC4FSQeuhESIiWTKvLKvnWhmauze3Mo4/PEjcvVp1NKiJ6tWLNqrS1Rfz7Udc0uBxywzDpjnf4uYIff1zzgSpDvir0ikxJJ2JAlAH1OuFpr9At/Ch/ToAvvUJJLdngloZC2ICCYEFi/ZaZVDozy0CmjALI3vPUwK+yqQT6Fz5v6g2fsFE9sZS276jmCceksqGEm8hOVHPGrTn5/fzipImMr1C0Cs7c3qHocYhfyc9JOsuGxZXBbnC3dnzzVjUHY0PmdZXg0b/BaVkdjLckB7SlEPBYkFQQmBaK5CydGINihFdo
 RnygqHog
 uAhJ/BRJlspVPUcVCe6vDx6NCtukjfucHxX6j/CeXaZz53mNryynhorlnBi1V1q3Xn7oUMyvTTctWPSrdbjn8K5phX0RHvcp5nmYqVKH41SDaSYHZTghobw9iccWmujemQh/jgGhkxyb8r+ONZ4sNeewZMLKqritg8J/0bkA9wdQX2K/jy1JYiRf8x+wT+W7bhdcYb2ZlXoKhDwcWdCIH020HfZvXbMGE4KcreKl/mmDkCtROS5VZrcU0XfrE6LcvxAGBqF48T1gUXZarcnSVanvkjrqtIk45XC2kU9tU0iITI80X9tmCslgIkHDxi1eLm29V283Yofpm2DNN079/metEH/l9XFjPpe4d1iOkzJrcbBmgrBR1wIzqglLLUYn1GBG5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 14:02, Salvatore Dipietro wrote:
> 
> Hi Johannes, Matthew,
> 
> Thank you both for the alternative proposals. I've tested both
> approaches on the same test environment used for v3.
> 
> Results (4 runs each):
> 
>   Config                   Avg TPS      % vs Baseline
>   --------------------------------------------------------
>   baseline (no patch)       70,735       -
>   Johannes' approach       156,908      +121.8%
>   Matthew's approach        70,145       -0.8% (within noise)
> 
> 
> Johannes' approach (clearing __GFP_DIRECT_RECLAIM early in the
> slowpath for costly __GFP_NORETRY) delivers the same ~2.2x speedup
> as v3, as expected - it prevents the entire direct reclaim and
> compaction machinery from running for these opportunistic allocations.

AFAICS both your v3 and the implemented Johannes' suggestion effectively
make all the compact_first logic dead code - at least for the intended THP
use case based on costly_order. It will only continue to do something for
the non-movable order>0  case. So that's a significant change which will not
show up in your results, but might affect other workloads (I'd expect mainly
by having fewer THPs).

> Matthew's filemap.c approach does not help in this workload.  The
> reason is that the first allocation attempt at max order still carries
> __GFP_DIRECT_RECLAIM and enters the slowpath with direct compaction
> enabled.  The __GFP_DIRECT_RECLAIM clearing only takes effect for 
> subsequent lower-order attempts in the fallback loop, but the costly 
> compaction has already executed on the first try.
> 
> Let me know if you have any other variant you want me to test, 
> or if I should prepare a v4 based on Johannes' suggestion.
> 
> This is what I tested for Johannes' approach:
> 
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index a63733dac659..6e960c969e67 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4733,10 +4733,10 @@ static inline struct page *
>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  					struct alloc_context *ac)
>  {
> -	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
> -	bool can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
> -	bool nofail = gfp_mask & __GFP_NOFAIL;
>  	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
> +	bool can_direct_reclaim;
> +	bool can_compact;
> +	bool nofail;
>  	struct page *page = NULL;
>  	unsigned int alloc_flags;
>  	unsigned long did_some_progress;
> @@ -4751,6 +4751,20 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	bool can_retry_reserves = true;
>  	unsigned long alloc_start_time = jiffies;
>  
> +	/*
> +	 * Costly __GFP_NORETRY allocations are opportunistic: the caller
> +	 * can fall back to smaller orders.  Don't stall on direct reclaim
> +	 * or compaction; clearing __GFP_DIRECT_RECLAIM makes the entire
> +	 * slowpath treat this as a non-blocking request.  kswapd will wake
> +	 * kcompactd as needed for background defragmentation.
> +	 */
> +	if (costly_order && (gfp_mask & __GFP_NORETRY))
> +		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
> +
> +	can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
> +	can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
> +	nofail = gfp_mask & __GFP_NOFAIL;
> +
>  	if (unlikely(nofail)) {
>  		/*
>  		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
> 
> 
> Thanks,
> Salvatore
> 
> 
> 
> 
> 
> AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico
> 
> 
> 


