Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26963F327CD
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 09:27:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AD8B6B008A; Tue, 21 Apr 2026 05:27:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 885D46B008C; Tue, 21 Apr 2026 05:27:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7757C6B0092; Tue, 21 Apr 2026 05:27:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 643E46B008A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:27:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E820EC3CB1
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:27:08 +0000 (UTC)
X-FDA: 84682034136.24.1D888DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 19D8940008
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:27:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lm8NxsWt;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776763627; a=rsa-sha256;
	cv=none;
	b=7xQkWrWydFq3Z5LP2LLVJF6kUmUaRUDfAzwIAN36GDSykaKwsFBJVKYgdsL8FC4o8lVxuF
	os1uSWtFv1JA+0ijR4qGENSjvBCOc/pp7JFej1ZiAp+bAp7u5+u4gRMhIP0UNDMV4/83ga
	t/fPm8PLzYT4hKgJaszV6lKIE5GcUVI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lm8NxsWt;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776763627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QeXuvUoejqBKOJeU7rHhnP0CcsdhpBczZoI0Zlg6Zuo=;
	b=i8sOZ8KGqQWFeypwCSGjUYve8XxW8oCqmxmEvh7ANy9GxGVYmZJKO8M+YxaB28hCzRV4zA
	Sn7LR2Dzgpi0DDuHLIhzHIHwFY0t0tU5mOsaVV+lKIPxFRvMsmxdbCNvqtc/tOwl6682tj
	v9XTYph6CgGuLCbDJWNoLuOf+JK56gw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E0B0C4388C;
	Tue, 21 Apr 2026 09:27:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABB3C2BCB0;
	Tue, 21 Apr 2026 09:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776763625;
	bh=MR/GwJdH+bPFnJA+jLQ/+UtlUiXYet/1ZH/US7v3bHE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Lm8NxsWtNqVyR+muCCnRFtHlpHTjvsA01spMNnq0NEPA9JbrqgrK7fsn7nJQctOph
	 4I2w+QkPdRXDO8IUCvVMv0h95A1KrZy5QWxGRg4uaJK1MNS0OEpOQbJN2N6McpSu36
	 FDx3JdDMTUQNzwGkKKGQNLpFGlPelpPFddNM+MuiaZy7pSJ1KLgamqL3ZmIpobmiVX
	 Qs83No089Dt+C4YANol96fE1BFYW2cF+LYu82ot0qUr8UK6bMHWLwgWwjJMP+pBZq4
	 bSKOvJdyNs8332tAB2cYTby9Eh78OHkOhL0uxanWJUaHSt+1aLGOdK8ggPRpGQ6Bl3
	 xD52IqviaC9sQ==
Message-ID: <378ae036-6559-4b81-9bac-c8f0b73e1c98@kernel.org>
Date: Tue, 21 Apr 2026 11:27:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_alloc: use batch page clearing in
 kernel_init_pages()
Content-Language: en-US
To: Hrushikesh Salunke <hsalunke@amd.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rkodsara@amd.com,
 bharata@amd.com, ankur.a.arora@oracle.com, shivankg@amd.com
References: <20260421042451.76918-1-hsalunke@amd.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260421042451.76918-1-hsalunke@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 19D8940008
X-Stat-Signature: g9kti5aickxfayb4up8mfk31rw6ag1yw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776763626-735739
X-HE-Meta: U2FsdGVkX1/JW4N+cM9iEoDHXlWR+0i9G3KyD3LnC3b0q2lOS1OFw0paowRw4JvjFjhluKRNJBnaRCdZWDrTMe7Tr5dA4jzbypBsdIHYB+1ZS2/aSD7PfE0thqwEaVcL8wwcPicQmEel49HpSCXFMMWni/PM+oDtiVWyXy9aTRo1eWl3mUEo3DhIpf8HByMrn6ZffFe0uGMZ4diLZoeW4jRN8OK8VGzN8byG6PGzvRioIIqVdkjLDqHPvX3Pog/B2RnOVwwFBN57nAdncBsuVIdIKbqNkdKp2Y+u9H5ACs7wtEgckGnbmkdgpLwCRHJ7Hwl+wp/s+iZ7cdY7X4u6v9kpCLyxYd9YNGW3l6SoIcBwY01S3sbpOan3UK/tCeBkPMl5L5uU/1zCFO51xugfvg9jA5TLDA7iC4BLdnfYDuNwzuBjTr37Ay8fZ2iMxBc52pUOruIx6YiDDRSOeKE70r8EIs6ojoIm6ithXJtWwaA2GDMlMbvW4X+6SBTHnDPON6pSTB++tT0AuHiJfjJt2iZ/FdyFoWOhTbthQkbZhd2S28KMDXipDkwM7U2l9paTF0X+muKqmg6wngqDDtWyTOXrba/TWaQM4B4DkkhpBSXwJoRwxvNh3ozqockn52iC5aKLnirf4C6H3cKOEzYrQgvCT+1Fy7Zg2BZWpEGpUeFRobvozW0AvavkRFNltHS/yT1coDeGRQEjDiMzHuhvW40jACRyrebesrsIw8JGle2aHM6vYrUApXH3lh9TickAUrIc/HuiI/lMq+sWAs9WxYZjUWJGd9UPrT8bVCzNgMhm+LdwBIw5CCAMXebRQyxcQqXrzOAEGCcq/qbse2zApPXnuM/CBNnmask957F6Wyld1UwaD/1FlMUr4QMbtg7wObzdw8u0/IOciNs5bZUN9WUxSnZMfQ+Wd+GbBuLpZ7h6CENeJyY9AxcxycvA0Fq50O0PwEbPJAHgIMbAXsA
 PpcCpwvZ
 AJu45I81GQqP5YI8nnhqtuDbWHoflXwezmntGSNtjr9P8bHJI0pViGO4uuUbSbzuF+8Yt3CnYTsmPsOCiKZcfYstmJ/GsbjkETxTdL3UYnj0JC09dM7dYlSrM08yCFYnGW/EUsjQUWe4jfsNl0URDWnR0XRgBeQX15GLGYhotHZgrhir0fxrujf3msNmOYfzovrJXXsMfWO93M45/0f9ORS4Qs5O2bGOo4IUrZ7PvhcQ55d7hHOf0hAZ7/L/yQ2Rrv0R5V0KrjkrzYPwdGdQkaOpnFw7sVqhCzS7HoBgUozCUkDhkxFTA6zooC/tqS5BnJAov+rpm+Go7KK+efiblLcTv/pihgSfc8/P9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/21/26 06:24, Hrushikesh Salunke wrote:
> When init_on_alloc is enabled, kernel_init_pages() clears every page
> one at a time via clear_highpage_kasan_tagged(), which incurs per-page
> kmap_local_page()/kunmap_local() overhead and prevents the architecture
> clearing primitive from operating on contiguous ranges.
> 
> Introduce clear_highpages_kasan_tagged() in highmem.h, a batch
> clearing helper that calls clear_pages() for the full contiguous range
> on !HIGHMEM systems, bypassing the per-page kmap overhead and allowing
> a single invocation of the arch clearing primitive across the entire
> allocation. The HIGHMEM path falls back to per-page clearing since
> those pages require kmap.
> 
> Use it in kernel_init_pages() to replace the per-page loop.
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
> base commit: f1541b40cd422d7e22273be9b7e9edfc9ea4f0d7
> 
> v1: https://lore.kernel.org/all/20260408092441.435133-1-hsalunke@amd.com/
> 
> Changes since v1:
> - Dropped cond_resched() and PROCESS_PAGES_NON_PREEMPT_BATCH as
>   kernel_init_pages() runs inside the page allocator and can be
>   called from atomic context, making cond_resched() unsafe. The 
>   original code never had a cond_resched() here, and the 
>   performance gain comes from batching, not rescheduling.
> 
> - Moved the !HIGHMEM/HIGHMEM branching into a new
>   clear_highpages_kasan_tagged() helper in highmem.h, per David's
>   suggestion.
> 
>  include/linux/highmem.h | 12 ++++++++++++
>  mm/page_alloc.c         |  5 +----
>  2 files changed, 13 insertions(+), 4 deletions(-)

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> 
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index af03db851a1d..ad0f42d06ce6 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -345,6 +345,18 @@ static inline void clear_highpage_kasan_tagged(struct page *page)
>  	kunmap_local(kaddr);
>  }
>  
> +static inline void clear_highpages_kasan_tagged(struct page *page, int numpages)
> +{
> +	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
> +		clear_pages(kasan_reset_tag(page_address(page)), numpages);
> +	} else {
> +		int i;
> +
> +		for (i = 0; i < numpages; i++)
> +			clear_highpage_kasan_tagged(page + i);
> +	}
> +}
> +
>  #ifndef __HAVE_ARCH_TAG_CLEAR_HIGHPAGES
>  
>  /* Return false to let people know we did not initialize the pages */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b1c5430cad4e..1aaf7f839ff4 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1220,12 +1220,9 @@ static inline bool should_skip_kasan_poison(struct page *page)
>  
>  static void kernel_init_pages(struct page *page, int numpages)
>  {
> -	int i;
> -
>  	/* s390's use of memset() could override KASAN redzones. */
>  	kasan_disable_current();
> -	for (i = 0; i < numpages; i++)
> -		clear_highpage_kasan_tagged(page + i);
> +	clear_highpages_kasan_tagged(page, numpages);
>  	kasan_enable_current();
>  }
>  


