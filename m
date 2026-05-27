Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAD4FCD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 08:28:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 086456B0005; Wed, 27 May 2026 04:28:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05E2F6B008A; Wed, 27 May 2026 04:28:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDDBB6B008C; Wed, 27 May 2026 04:28:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCCEC6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 04:28:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 891E61C0412
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:28:05 +0000 (UTC)
X-FDA: 84812522130.09.22A7264
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id BF49A4000C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:28:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QHsKKMwG;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779870483; a=rsa-sha256;
	cv=none;
	b=aLFpgCM6PinuX34nDAE/jYHDL164JjJUk109j0ixw5pluH1PMijDjtuDq8str/Mslt4xFt
	kdvgYJcjkq7pdbpl5NgF+g9u2UCeQjgxtsLGLqTJcL3p3ne9JZaHMr46VMzLvV9BnyOCOk
	wQGoz2MpJ3hh+ISs4qiDWlsHeIQ0aOQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QHsKKMwG;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779870483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9J49Os8avM03pcKxT1/hTZ/Z159dOkFm8fYJNoACPhw=;
	b=b2hVYmSU1a4V4X0iXD58wAqGwEMvbM6Ci870TPInBpXWnw2teumfEuYMCzI9HPrEspEN7w
	9/KSrdfdqcRxpkncoV9bwynHkcVjXGpiZSU82EPkvlw9dpl0bWNExwfGsrrx4wCH4IjD8D
	FXD1XisIAB3SEFM/Ig+RFrHTpd5lDqs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DAE082880;
	Wed, 27 May 2026 01:27:57 -0700 (PDT)
Received: from [10.164.19.7] (unknown [10.164.19.7])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA27D3F7D8;
	Wed, 27 May 2026 01:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779870482; bh=zqMwayjvGNQaNb1jqTGaRplGikMOmx9Kmixu6dv1Veo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QHsKKMwGP18WsqNGBObxNHu/wRN2qzvaTMPP6VCByY/l1/dY9p7BMOCdN3lJW9zPz
	 fr9zo2x4dzUU8sEebR42jOwW/Z66FwdWXVTpvlSM6hOL8ouhtWjOHrbcc1HzUrweVS
	 CwRvhY6w9YNz4xyH0T+cn0bWSm0lGsUspT7ebhYs=
Message-ID: <340c811e-2501-46c3-8a55-19e955c5ae8a@arm.com>
Date: Wed, 27 May 2026 13:57:54 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
To: Wen Jiang <jiangwenxiaomi@gmail.com>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 will@kernel.org, akpm@linux-foundation.org, urezki@gmail.com
Cc: baohua@kernel.org, Xueyuan.chen21@gmail.com, rppt@kernel.org,
 david@kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com,
 ajd@linux.ibm.com, linux-kernel@vger.kernel.org, jiangwen6@xiaomi.com
References: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
 <20260522053146.83209-6-jiangwenxiaomi@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260522053146.83209-6-jiangwenxiaomi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BF49A4000C
X-Stat-Signature: sxxdxox45fp51q6yrsm8k97q4ysi56pr
X-HE-Tag: 1779870483-322531
X-HE-Meta: U2FsdGVkX19eT2TDaWzh3FK2EhcUXtRevSvgm62nRxqA7/oM2KWptmW4uHWGoQhG7mhquVxTNiW5y5VH2p3zgTmBHmCosrlSmtpqMNiobA3OVXjYXoFXzI6tx/N2uisdhceIYZPx8v463TSHNgKprUtUXvaS6Na+1oxusFNrD7onrsP8hUhqz0MpIJLTcrDCoLZxaxl2vzkB/sNmxob36mwIn35KMNQNaccHrx7Rd7WxEZj/GLrhr/OJ49de1z5lJMSHXOSXCZ0hcK8DkjG2yKs/soxVLj+Bxn7SB9GOVtae4l8K95aop31lLBTr8WiKjgKZrcBuSAFyT26BMQ2jgUVbX32EfDdZYImEKGgjo4VYOFnevNrLe1iCeG+gGaIvlsTnZT14Js5iV+hRrnBc+bF92dDGIM/gCJ9FWrcPLgRIAZZ9zcFWo4UKFpbcABtgiZxyXqBEzAInxp+1ROHSKO8/b0irHuftpeVL2cZehZICWD4JuBmlLXIu0u+tl4VyFubguTepD+5ludYh1fSa/a4SypxTLfmuS9b1nUjgnlErsKmy7haLPBMsROZkuaNXlA4PmORhfw/yYGGRVvbe2e6NmLEAYf9SCHl6hwMUwAzSbwkeASxFrXzC7/jfyT6seJ91xOehzv7+ow8s/sepjQ4b3pslcXf8DscLxpOJRpCU3IiGMO9DHzvvouun6Vys2qSWm14ARa2EC5DUQGtqjG5GTi63IwvZzrBaxWmMQ7gCVCtwL3E69xajqH87BejmPyvj8wGa8G+iTPCCrdRNUBU/0k8yAodA8K3FEGBNk8sEf4Iuvp9CgHTcLwosv+Z+56vhz5GVH04LgFx1W+80i15SyZTUELhHVPZ5Y4cyYPeHjhLY8Qeu+zqI6SNObmYcy2R8iXP6nPUYDeeB0ShakeNnjkaeI3BdFwRrGd1FtK//FqhKJ9EOFjxfjdxdV9l9L9QMP3LqIUEwa178x+k
 6f9pPeL0
 9U/FeWqttxaW4SCZQizA20xtMgqPkp0jliWYmTg0cSinSY9C0uklRlajwkFQ9vMIuZlskRTAhw+CRBiKBj23V9ZSesCtCEAmiiUAPjJKMAtZlNoKucIMmrZs+746gJzhbw69tQKk6pp0M04HZuWiE91hAeYm+NuNiWXS6ipUIe+LZBtfqjGWj1zX3bGpvGgvBuYHUqm4HgaB8WTErVTImvnIYaBCJyUzquf32s/x2qdWV8iDu5CEh6bl45g7SJR84i29MsE7/RBtn3khUmJg8vacu3YYJBKXTTyyHo/AL2XOIMDJFAqIvoy/jm9Yc5DIo8O+RC+uxJ+Fknu0R84oH9jZ2Vve+Uw+rSwdX6YBCmQ6kYy+nCB1qVRAzsrqCzoTUrn2rB2Uhw7xoyDElGkGBFKtcomsyFEnXcR6jUTVqGbhv3e544XTwGOjkDPTCkM00xq4FdRE3ZtMIW1I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22/05/26 11:01 am, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> In many cases, the pages passed to vmap() may include high-order
> pages. For example, the systemheap often allocates pages in descending
> order: order 8, then 4, then 0. Currently, vmap() iterates over every
> page individually—even pages inside a high-order block are handled
> one by one.
> 
> This patch detects physically contiguous pages (regardless of whether
> they are compound or non-compound) by scanning with
> num_pages_contiguous(), and maps them as a single contiguous block
> whenever possible. The first page's pfn must be aligned to the
> mapping order for the batched mapping to be used.
> 
> Pages with the same page_shift are coalesced and mapped via
> vmap_pages_range_noflush_walk() to avoid page table rewalk.
> 
> As users typically allocate memory in descending orders (e.g.
> 8 → 4 → 0), once an order-0 page is encountered, we stop scanning
> for contiguous pages since subsequent pages are likely order-0 as well.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Co-developed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  mm/vmalloc.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 80 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index deb764abc0571..50642246f4d40 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3542,6 +3542,84 @@ void vunmap(const void *addr)
>  }
>  EXPORT_SYMBOL(vunmap);
>  
> +static inline int get_vmap_batch_order(struct page **pages,
> +		unsigned int max_steps, unsigned int idx)
> +{
> +	unsigned int nr_contig;
> +	int order;
> +
> +	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP) ||
> +			ioremap_max_page_shift == PAGE_SHIFT)


Why bail out on ioremap_max_page_shift == PAGE_SHIFT? The code
path for ioremap is different from vmap right?


> +		return 0;
> +
> +	nr_contig = num_pages_contiguous(&pages[idx], max_steps);
> +	if (nr_contig < 2)
> +		return 0;
> +
> +	order = fls(nr_contig) - 1;
> +
> +	if (arch_vmap_pte_supported_shift(PAGE_SIZE << order) == PAGE_SHIFT)
> +		return 0;
> +
> +	/* Ensure the first page's pfn is aligned to the order */
> +	if (!IS_ALIGNED(page_to_pfn(pages[idx]), 1 << order))
> +		return 0;
> +
> +	return order;
> +}
> +
> +static int vmap_batched(unsigned long addr, unsigned long end,
> +		pgprot_t prot, struct page **pages)
> +{
> +	unsigned int count = (end - addr) >> PAGE_SHIFT;
> +	unsigned int prev_shift = 0, idx = 0;
> +	unsigned long start = addr, map_addr = addr;
> +	int err;
> +
> +	err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
> +						PAGE_SHIFT, GFP_KERNEL);
> +	if (err)
> +		goto out;
> +
> +	for (unsigned int i = 0; i < count; ) {
> +		unsigned int shift = PAGE_SHIFT +
> +			get_vmap_batch_order(pages, count - i, i);
> +
> +		if (!i)
> +			prev_shift = shift;
> +
> +		if (shift != prev_shift) {
> +			err = vmap_pages_range_noflush_walk(map_addr, addr,

It would be worth documenting vmap_pages_range_noflush_walk() that
it can take an array of pages which are not all contiguous, but it
may have contiguous chunks, as hinted by page_shift.

Otherwise this looks good.

> +					prot, pages + idx,
> +					min(prev_shift, PMD_SHIFT));
> +			if (err)
> +				goto out;
> +			prev_shift = shift;
> +			map_addr = addr;
> +			idx = i;
> +		}
> +
> +		/*
> +		 * Once small pages are encountered, the remaining pages
> +		 * are likely small as well.
> +		 */
> +		if (shift == PAGE_SHIFT)
> +			break;
> +
> +		addr += 1UL << shift;
> +		i += 1U << (shift - PAGE_SHIFT);
> +	}
> +
> +	/* Remaining */
> +	if (map_addr < end)
> +		err = vmap_pages_range_noflush_walk(map_addr, end,
> +				prot, pages + idx, min(prev_shift, PMD_SHIFT));
> +
> +out:
> +	flush_cache_vmap(start, end);
> +	return err;
> +}
> +
>  /**
>   * vmap - map an array of pages into virtually contiguous space
>   * @pages: array of page pointers
> @@ -3585,8 +3663,8 @@ void *vmap(struct page **pages, unsigned int count,
>  		return NULL;
>  
>  	addr = (unsigned long)area->addr;
> -	if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
> -				pages, PAGE_SHIFT) < 0) {
> +	if (vmap_batched(addr, addr + size, pgprot_nx(prot),
> +				pages) < 0) {
>  		vunmap(area->addr);
>  		return NULL;
>  	}


