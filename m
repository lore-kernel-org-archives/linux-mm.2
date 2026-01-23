Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F39CD72362
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 09:09:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD5466B0481; Fri, 23 Jan 2026 04:09:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A82E16B0482; Fri, 23 Jan 2026 04:09:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0156B0483; Fri, 23 Jan 2026 04:09:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 890B86B0481
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:09:55 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3A7FC140448
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:09:55 +0000 (UTC)
X-FDA: 84362656350.28.4D474D3
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3A22420004
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:09:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=APpsSnSa;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769159393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=STv13js4Bc2r6nopJtS0XjjA4UEVAP/EJMhJqC0mMhg=;
	b=NpeyN8kY4IR81HRvpNz6E7tRnAuQG2TMwYHuu39ZO0oJ6mDa51l4HLaUeqNSGauwAmTBoH
	SIplmAXsZwyEq0FjM1W5Jl8FF7MNBtK96NZ0ebPQxNTtdb3t0KQNmtAAc8Ar9oAULTvfUR
	SweGs65uB4Lt0VhWlRPWok/Z5g4ygws=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=APpsSnSa;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769159393; a=rsa-sha256;
	cv=none;
	b=H5tnN7p6s9U+ZTdR/6EVmyO/fh124RmFp84pQkmdJ1VXWgy9tvBAYcBS+vN4LNvWvemkwP
	t+cgz28C4uKjP4psDDTyNZW1vg4w6eQK+UT1KHg0ruIatYz1+DNT+upLG0pDn7QyBPdB9O
	KKDVTwFoXqIkvIs3Mx8Jfyz3R94ZQHA=
Message-ID: <5820b1e9-3c45-432c-84aa-638cf92fd240@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769159390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=STv13js4Bc2r6nopJtS0XjjA4UEVAP/EJMhJqC0mMhg=;
	b=APpsSnSa2rtITbm4gLFN+/zsAV18+8naTTMuTQOmVZP/Gd6zFk1AH3CwskRTaEpay16+nX
	pcdiTbZf8I7PPhq0P39Y125m8o5gSRSHMI+L2ZVrPeJEAfbHvO5qivaE00gobdFQMnd93r
	1M2bNdNs0kqlNxLo8sCISgDMx84Ed0Y=
Date: Fri, 23 Jan 2026 17:09:40 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v5 4/5] mm: khugepaged: skip lazy-free folios
Content-Language: en-US
To: Vernon Yang <vernon2gm@gmail.com>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 david@kernel.org, Vernon Yang <yanglincheng@kylinos.cn>,
 akpm@linux-foundation.org
References: <20260123082232.16413-1-vernon2gm@gmail.com>
 <20260123082232.16413-5-vernon2gm@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260123082232.16413-5-vernon2gm@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: a71sg8dmjq8d3hx33jubs1zwkxdxh5nr
X-Rspamd-Queue-Id: 3A22420004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769159392-194099
X-HE-Meta: U2FsdGVkX1/e9a8sM4hE93YHIjyKr3S5lzHsP7HrqgAnRvSQAa31w9SelwYBzXHWWLfaL7lcgiegIUEEjfiEHnWYiPuyLCqUpUttgy6Ohb7EgIDnNUy1H7aItiN0AVHtxhFhDS6ZurJY9sw9xPNJlF3O0Yf5aZ17TKaR9E/0M0IS8jkaYy1ilfjfk17IXOPu1jj4mOQ8cV9qQoW8jv2ryyywSyuW99itWumHc5QFyDHjnPG8BqFL/QqcYlHY+JmfipbZB6ktLgL8SBgJr18PC2Gg3uVYxIGVy9P/HCs9/jIiYLiY4sTFSEJEwT6O2N0qXWmV9UST3MZ5pZV7NhB4pn07677Yn20KGUczLSf2P3MXV2cwP2ZWuMxtuZ7wXQkwwHtn4/Ke2pOIozaYytjIzUCn0KtXj9U4dggoPe6y7g4PQUvXV9k1Z0YvMmV75nYhYAGjOGcFz3z2W//We7/+Hs8WewhVh4QU6+g3rblyyvLkWSNDXotoOVVKsF99YlMm8B20HBlUsVCa6L1HA9PDu0HLQfwYF1IBq1sQ1Uef99iXbH+6F9mSjTbOgxPqc93DYeJsZzmGucORc8ZlQJmasLX6tZPvBDRr0NTZllYDJSvyRkqy52Nr077ImU5+YfD0Fd2a+8DnrsZVOSEXh1Bry4Vchay2CWSGs9IGiMDhuQLeHcnql9IciSGdSBNtGINFTgTafqmj4cq7tDLfMKo6VTaIJBfKYsVqtRvYEZkQmqgihpayfYwI66BGeoJEJ7i3dExIT0XwX9NmgwhIDv9Dui9AgEffP1rFePewHko7F1taqEtIV6hIUGg8SeihwVtGewuMUgUkY7Ct7J0US9tmndgGi59ywPDzvKa+NDdtulBhpgGcqQEEVfb2w4I0y6ZRseUE/oxy889zuSdFNNZ2RSuD8ORZTcb+A1l43Y7XT94NLtxQCVN1BeMf4I/W4jPAM5PDEFMU3el9HBPGKrN
 zAo3Z4uh
 SyR0Vae7W9QGUhn/otN/7s4wY0Ip1iBlaG9TQCqXUdiCOqFBwxgd4DCoRAfz0rN5O2GmFPimTzWZgjJq3mYvtYalGZNJq+5slWV54MlLyMVFHYqy12X+NuTeepbbzqjv1AEuakBV8MfpPEJUva2+i/U6SOYL/CwH0MPT2BAAREziOVBQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/23 16:22, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
> 
> For example, create three task: hot1 -> cold -> hot2. After all three
> task are created, each allocate memory 128MB. the hot1/hot2 task
> continuously access 128 MB memory, while the cold task only accesses
> its memory briefly andthen call madvise(MADV_FREE). However, khugepaged
> still prioritizes scanning the cold task and only scans the hot2 task
> after completing the scan of the cold task.
> 
> And if we collapse with a lazyfree page, that content will never be none
> and the deferred shrinker cannot reclaim them.
> 
> So if the user has explicitly informed us via MADV_FREE that this memory
> will be freed, it is appropriate for khugepaged to skip it only, thereby
> avoiding unnecessary scan and collapse operations to reducing CPU
> wastage.
> 
> Here are the performance test results:
> (Throughput bigger is better, other smaller is better)
> 
> Testing on x86_64 machine:
> 
> | task hot2           | without patch | with patch    |  delta  |
> |---------------------|---------------|---------------|---------|
> | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
> | cycles per access   |  4.96         |  2.21         | -55.44% |
> | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
> | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
> 
> Testing on qemu-system-x86_64 -enable-kvm:
> 
> | task hot2           | without patch | with patch    |  delta  |
> |---------------------|---------------|---------------|---------|
> | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
> | cycles per access   |  7.29         |  2.07         | -71.60% |
> | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
> | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
> 
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>   include/trace/events/huge_memory.h |  1 +
>   mm/khugepaged.c                    | 11 +++++++++++
>   2 files changed, 12 insertions(+)
> 
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> index 384e29f6bef0..bcdc57eea270 100644
> --- a/include/trace/events/huge_memory.h
> +++ b/include/trace/events/huge_memory.h
> @@ -25,6 +25,7 @@
>   	EM( SCAN_PAGE_LRU,		"page_not_in_lru")		\
>   	EM( SCAN_PAGE_LOCK,		"page_locked")			\
>   	EM( SCAN_PAGE_ANON,		"page_not_anon")		\
> +	EM( SCAN_PAGE_LAZYFREE,		"page_lazyfree")		\
>   	EM( SCAN_PAGE_COMPOUND,		"page_compound")		\
>   	EM( SCAN_ANY_PROCESS,		"no_process_for_page")		\
>   	EM( SCAN_VMA_NULL,		"vma_null")			\
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index de95029e3763..be1c09842ea2 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -46,6 +46,7 @@ enum scan_result {
>   	SCAN_PAGE_LRU,
>   	SCAN_PAGE_LOCK,
>   	SCAN_PAGE_ANON,
> +	SCAN_PAGE_LAZYFREE,
>   	SCAN_PAGE_COMPOUND,
>   	SCAN_ANY_PROCESS,
>   	SCAN_VMA_NULL,
> @@ -583,6 +584,11 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>   		folio = page_folio(page);
>   		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
>   
> +		if (!pte_dirty(pteval) && folio_test_lazyfree(folio)) {

I'm wondering if we need "cc->is_khugepaged &&" as well here?

We should allow users to enforce collapse via the madvise_collapse()
path even if pages are marked lazyfree, IMHO.

> +			result = SCAN_PAGE_LAZYFREE;
> +			goto out;
> +		}
> +
>   		/* See hpage_collapse_scan_pmd(). */
>   		if (folio_maybe_mapped_shared(folio)) {
>   			++shared;
> @@ -1330,6 +1336,11 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>   		}
>   		folio = page_folio(page);
>   
> +		if (!pte_dirty(pteval) && folio_test_lazyfree(folio)) {

Ditto.

> +			result = SCAN_PAGE_LAZYFREE;
> +			goto out_unmap;
> +		}
> +
>   		if (!folio_test_anon(folio)) {
>   			result = SCAN_PAGE_ANON;
>   			goto out_unmap;


