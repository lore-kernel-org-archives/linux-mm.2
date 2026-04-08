Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 742451073C85
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 09:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A894F6B0088; Wed,  8 Apr 2026 05:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3A616B008C; Wed,  8 Apr 2026 05:47:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94FE26B00A0; Wed,  8 Apr 2026 05:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 82ECA6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 05:47:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3ED401B85DF
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:47:38 +0000 (UTC)
X-FDA: 84634911396.15.5A150CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 931E9C0003
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:47:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aECfF2TH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775641656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JUgTpszxFtruozR2e+eoufOGMRhGGFS+5cbUk8IMu58=;
	b=vmkJ7GjD9IdLubcukAu4Xv0M7w7BgAnfhwwRXNDKUhW03K8Ta1nIFxYgHEsHRK7eIE5W4t
	g5HWdJ6jsQjsSUY5uwmnUX2THJxyCX5SMWnsjdIgskAyFXVoJeh+U3WuOpjEGSsRSWo7HG
	59otLz59cnrfh9dgwJ0PkdcZcn8zTSc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775641656; a=rsa-sha256;
	cv=none;
	b=oTQMiFesh/WnFmc6MTx80tt+7Ocb5do6U3TbqAuDA+rMpWg9Kb1EsWsrKJyNIu5bj3/St9
	O3rVFM39QBHDnXlMwfbSPsOtptEP2ZR+5DLB3Dw5OeasFlXspCbwq+euFtG6/lb2BSVzdP
	n946fP+ncl2FWuyaWpfqIdRgVdloEho=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aECfF2TH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 05FA3600AD;
	Wed,  8 Apr 2026 09:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D2FC19421;
	Wed,  8 Apr 2026 09:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775641655;
	bh=161FTND8aX7N/Si1WQ0uVlsbSqWm81xeGF710mBmYJ8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aECfF2TH5qpXPEirhk0ZZZkyaU/bnH9AeFkowVHuMeWRUaw3IfAtfQfOIDCnqsVfU
	 jCREhFEW2ZCsML/0E/CWCT0ZBT3CxKS+fHzXVL0hqaerbevm/4YU1wDjTnp+3yF9Cy
	 yvMhPG8Jh/dQmnG+uhv3a6WsS7JpboEC9a2ade1w/MSOR2nOIfbuN/TWKjPnCEXttv
	 CFj1tvsiCpxUdXTrrtDXcervAvxzHenkRUczzn/BuO7ded2GuAeXg4xPB2YPzkrYP9
	 UEn9r7icEf+AB/wKcQclvFYDg8jYpTwa3AZrAAX5dlUySAakqS/knXwOayhHqkIoPw
	 IbYLAEOjWewxQ==
Message-ID: <22b6ff3c-9d41-4eb0-9beb-cb92f3ada89f@kernel.org>
Date: Wed, 8 Apr 2026 11:47:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: use batch page clearing in
 kernel_init_pages()
Content-Language: en-US
To: Hrushikesh Salunke <hsalunke@amd.com>, akpm@linux-foundation.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rkodsara@amd.com,
 bharata@amd.com, ankur.a.arora@oracle.com, shivankg@amd.com,
 David Hildenbrand <david@redhat.com>
References: <20260408092441.435133-1-hsalunke@amd.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260408092441.435133-1-hsalunke@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 931E9C0003
X-Stat-Signature: o1b5uuexjwkp6iesixzf3sax7qdzcrx1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775641656-694509
X-HE-Meta: U2FsdGVkX1/Y5oUVf5QoqHZ6oXkUOx/RkmDkGJVl3qi6AhGLcCBOD6DiMWNDAY+qSX1BgHadbHN8Tq/5iurqQBAq1xd8tfT926Agz3f/7cCqDhy6qWm/IJeeR/M4NWe+NW7YtmHjnQ/koOuayff0IzE9llgOowPioBq3LELu97N7W2BNkfPf9apanYJpLySpKjTrjEORfzhD0bnSty5KD8jgtySCF2/IwBMFSV0ZO5trrS20ZQ1+tE56T05BOguFOhjAAXmPwTa9GSoBjjeroPs3HG3Z3fBBqbGlSZpBUDmGND/5kNUGmATFot+xkShCB8Z9XwH7kj9Ho3txAamOl2X0srm0oa+Me9gi/TsNsMCxsdLhKrxqynS2f408liRPFgpN5TStePjYHXwThj9b6VPLzZzTf8yzkd+9+yxVsCbapNS8uS4kPv1DBVtEFdGXxuAl4FhrnM/A6IlO7KJlxJW2ieXGnxUktp6/3/Kx+xBlTwB3I4YQBHZXJHw9HQeKlHfc4OCbeHwxs9nQxIKS9oM0PjnGXiiKp3A6Cr9Kw9fayBBkenYPgHGlchFoTrNPpfQn55vAXOhS4xrx0KvUNzHMEuwaUZCBToLPld5KXszSKxo5dnFyTPDF7gJguTDvE03NpvPPGO5AdF0yFO95tFwV8sI+KxH8pMG1JCxVlaf8t5g4csBF/gMFOL6E8qqQd5GRFUMlMxO24QflkSiaeVJDi+dkmgJHkh6tOfuFKEU573zIjl/TQ8m2mXa+Y79wpkxEObGgVGWCjQC+WHG1Y+kQGzcu3ePtBkelr8jvgFc18VO1a39bfzb067TZY8MTUQGsAUn2qr8ZTwxCzZKrhH2gCbSo6ieK+XkWKpEEOGGaHiq3yRPJ1xBL5O/Vm8ZbT4djSMziboR/ShS4JcrE35hWST3NythPBPAVGy0GjgnR5hVDC2ica6xp9Zgf8tOv9pgwXOMt2lvB4UNgtBb
 Rps47zJa
 7EEh3AGRAZIGIhLGrXWqTV+zWI7cWPirmn4SNHa3jBjHHlEtXOHS/VdtnTGUPLoeghNVlACteho4xy6Gcync/z+fo+WdHKSvajNjCLuJUCFjac+tdazZno5mYM7swB5D86025u7c/eu2nBfmSzhNdPn+vH0Z0sttK/by4MTxxHYyGEZ2Gx93JNkOmUBO3XFpzofkdFXWvabqRkozRBhbea1sfi68cdIlUDIVUyo13rETh0MDp8wXTW3G/mtIXQTLAzXjURchA0Nck0aLtfP1gTsQXlVvwJeGsgXxgx0P3lAFiWUNVKs+BEuGQwrzfigBcwHRwQKqHpqEKgFsfXNeE4fQQXIpTNldjayKMgwGFA1go3qMuyc+Uj9GCVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/8/26 11:24, Hrushikesh Salunke wrote:
> When init_on_alloc is enabled, kernel_init_pages() clears every page
> one at a time, calling clear_page() per page.  This is unnecessarily
> slow for large contiguous allocations (mTHPs, HugeTLB) that dominate
> real workloads.
> 
> On 64-bit (!HIGHMEM) systems, switch to clearing pages in batch via
> clear_pages(), bypassing the per-page kmap_local_page()/kunmap_local()
> overhead and allowing the arch clearing primitive to operate on the full
> contiguous range in a single invocation.  The batch size is the full
> allocation when the preempt model is preemptible (preemption points are
> implicit), or PROCESS_PAGES_NON_PREEMPT_BATCH otherwise, with
> cond_resched() between batches to limit scheduling latency under
> cooperative preemption.
> 
> The HIGHMEM path is kept as-is since those pages require kmap.
> 
> Allocating 8192 x 2MB HugeTLB pages (16GB) with init_on_alloc=1:
> 
>   Before: 0.445s
>   After:  0.166s  (-62.7%, 2.68x faster)
> 
> Kernel time (sys) reduction per workload with init_on_alloc=1:
> 
>   Workload            Before       After       Change
>   Graph500 64C128T    30m 41.8s    15m 14.8s   -50.3%
>   Graph500 16C32T     15m 56.7s     9m 43.7s   -39.0%
>   Pagerank 32T         1m 58.5s     1m 12.8s   -38.5%
>   Pagerank 128T        2m 36.3s     1m 40.4s   -35.7%
> 
> Signed-off-by: Hrushikesh Salunke <hsalunke@amd.com>
> ---
> base commit: 1a2fbbe3653f0ebb24af9b306a8a968287344a35

Any way to reuse the code added by [1], e.g. clear_user_highpages()?

[1]
https://lore.kernel.org/linux-mm/20250917152418.4077386-1-ankur.a.arora@oracle.com/

> 
>  mm/page_alloc.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b1c5430cad4e..178cbebadd50 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1224,8 +1224,23 @@ static void kernel_init_pages(struct page *page, int numpages)
>  
>  	/* s390's use of memset() could override KASAN redzones. */
>  	kasan_disable_current();
> -	for (i = 0; i < numpages; i++)
> -		clear_highpage_kasan_tagged(page + i);
> +
> +	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
> +		void *addr = kasan_reset_tag(page_address(page));
> +		unsigned int unit = preempt_model_preemptible() ?
> +					numpages : PROCESS_PAGES_NON_PREEMPT_BATCH;
> +		int count;
> +
> +		for (i = 0; i < numpages; i += count) {
> +			cond_resched();
> +			count = min_t(int, unit, numpages - i);
> +			clear_pages(addr + (i << PAGE_SHIFT), count);
> +		}
> +	} else {
> +		for (i = 0; i < numpages; i++)
> +			clear_highpage_kasan_tagged(page + i);
> +	}
> +
>  	kasan_enable_current();
>  }
>  


