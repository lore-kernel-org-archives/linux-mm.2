Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2962BC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 04:59:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3419C6B009E; Tue, 14 Jul 2026 00:59:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CC1F6B00A1; Tue, 14 Jul 2026 00:59:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 197356B00A2; Tue, 14 Jul 2026 00:59:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA4B06B009E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:59:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 48176120247
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:59:22 +0000 (UTC)
X-FDA: 84986178564.20.DBA6DF8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1950640007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:59:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=C14wT9XV;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784005160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8tI0V2ApnDohdABK4zP1JsQQfok8T1YeTUyqSi3IawE=;
	b=CcjpQLxbVEZVCEia9FcVeG0CrDsLc55NF0CT+B+uEhRyd43s/rONBBNMxJIkHeJ8UfoLcL
	uX0vpfI+AwEPR5zCTjbdgkXGL522lH0QlTFdHNC2YY9uUmPulhpFkqsTIV3FPEnEcOx0Wb
	Djb4jwdAoZbwtYdlyFuVFueBJfYluJk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=C14wT9XV;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784005160;
	b=n5mYN2tFpVpLB7ykn7iHRSnIIjEVqrRsDHt6loFsDxOOxIRxx8n/pslhZzSl5ICkw/1Sjr
	yh7fECMOGDF5hZ1By6A6ZJTGuwbsrGtNDcI6ypKQvEcukwDpzb/cIDT+EbfH5/6nDL9M5u
	XgvnTLOGlhPxHjjhwtF9eSHETcnS64M=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BB2081570;
	Mon, 13 Jul 2026 21:59:14 -0700 (PDT)
Received: from [10.164.148.52] (unknown [10.164.148.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0853A3F7B4;
	Mon, 13 Jul 2026 21:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784005159; bh=hdQIJRcFrMnwMJI9ziOCW4Y68+P83FaYpP9RkJTdKVU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=C14wT9XVQrQyxn6c7vjT1nH48hKNL6FrbVNbRRK5Jt5xMgXuevqbO2JBAkotu4XBl
	 nsVWl20kGja9VA+gZF24BFiEuz514qH5y4dy5r5rTz+XAlnfPQ24YsQaaAo1YBq3d6
	 eKy1BVnUWIYKKDQUKRHDfN4mOv80GdbSmF/hgt9Y=
Message-ID: <255873b5-62d3-46da-a8b0-e1dabf1fae70@arm.com>
Date: Tue, 14 Jul 2026 10:29:10 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 5/6] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
To: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org
Cc: Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, anshuman.khandual@arm.com,
 david@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, rppt@kernel.org, ryan.roberts@arm.com,
 "Barry Song (Xiaomi)" <baohua@kernel.org>, Wen Jiang <jiangwen6@xiaomi.com>,
 Leo Yan <leo.yan@arm.com>
References: <20260709073823.6643-1-jiangwen6@xiaomi.com>
 <20260709073823.6643-6-jiangwen6@xiaomi.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260709073823.6643-6-jiangwen6@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1950640007
X-Stat-Signature: sxowq5zocpzfe1rhn3x8cs7795ahec9d
X-HE-Tag: 1784005159-879415
X-HE-Meta: U2FsdGVkX1+qN8kU99RcuFHm+zVZ0800MZ/qDOg7pGKulN72j+34vxCDpwEaO4qVDJlfTrr73X/k7hr6IMdRXCOISluQbu1lEJ0YvMVnr1QMBIIDwt6J9QfZpdnFvLHZfMgyqDHrbCN4XBQmADylBVVFXDVWMXN8aG+ELLhTNKvK9WufYC64gznzSmtQw3CqchqXyc+Rf+nhhtekkJMchpS/BEGLlWB43WXs1Lzv+NnoCFIH9XsX02fKegm1mTiDVskn/GUKoG4GZTbRDty4OyTgjkH6SVoYd6scHpST1qa0N3L/Q8pzkNpTpAuDK6Ma5pPFO9g5pqX53Tb0tml3aCRdnVTKdlhdLtloBK7iizyCM25GSua9fxMLKPzkqWwT2Ysgvn+1C1LNRm5ycdGs2vbEtaRfRJFihA8NQdh9b462RMaVF0EwhN/H213ZSByLoq+QZ9OsCOzltjOlVGd5vKiydJLTgxTU1w7yq3ja7O+CJ+D/HW+1zsIWJF/O6T6M+Q2nddeYQNXsZjHHc2AYIKeCc/6sccmNyPuHWXZ32vZ8BZB5aqe1gfUIg9fh9s6Pu0zUSqYoU4eOWid0FynL7PEt6Yr3+p7vF43xDnFJxsHaBEgmS9OOHwiPPqtjf9529yJE6Ga0C9A530yomZT9euBeFjQTJCsk87yV77LtRf8ruFJwOo5c15GRyMwVkhaTiaFF+/4KiT2Q+s4+df2gSv2bYTz93kL8WZkgyZD5rSuCSme1iAB2RUI8ndfQeqZBDQd2tQo5RPZBaPJZKnuqBKdC6lBHRkzEDAgdgIq1x2RLpJOe+Oqhqh3f69bXyKUfcQCb7y26Zq9UJ31AUyWdBDMchr28qSrwRl/+Rj2P98LwFn56KabWI++5wTD7fmgOXgdt/f+dkad9xGnZL0GuE/q/lggf7Gio7OCPCDzCRFUiNIromUGtt0AnNajqAM4vzhvO2Rt1firSNuXzJG1
 bCpgzMQR
 AlyTw0I2GCAjLbxUuNhqKmjUudEmsSfsatleW5QPggN2AiTen/tb8WvVI/GHkKZKbA1EuiATEnA16VWCSHfMTrOjTU6wYnvgxLSZ+DqZaMIjynFC8cuG28ypmahLWHy+6HFB7OYaMjH7OtSyeBoG2EM8rpx0FGTw+pB/mnvd02FoBEOYBpE0JqdJMyGZoVXfTn4E+Xny6uA3SUXgZvKLbFDqdM7VKFo+C1MI/9XwKt6RqkqOnfxw9t8+WGo0TXk7SFYkN9oMlD3Ga2ewExjhMMaXuOnnRTX5+ACJ8+LSGvsE2RRi25LlcxD6n0tPGAwDi1cnLbFP5n2qRSMlcnuEFcqCZD5bxMv7Elp0SsXYNe490LSUBvlpbq3fvtVwRsK+QyYx5FnV9v11racV++x+dIVSATJ7VT+bX0HHEK8WPZI8jYOsrHERCa0z0kaBSkOxOaCGYEjYkWsilcPrsPcwcq5bz/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/07/26 1:08 pm, Wen Jiang wrote:
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
> whenever possible. The mapping order is determined by taking the
> minimum of the contiguous page count and the pfn alignment, allowing
> graceful degradation when pfn alignment is less than the contiguous
> range.
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
> Tested-by: Leo Yan <leo.yan@arm.com>
> ---
>  mm/vmalloc.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 85 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index d2a4d649af549..db0492151ad08 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3543,6 +3543,89 @@ void vunmap(const void *addr)
>  }
>  EXPORT_SYMBOL(vunmap);
>  
> +static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
> +{
> +	if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
> +		return PMD_SHIFT;
> +
> +	return arch_vmap_pte_supported_shift(size);
> +}
> +
> +static inline int get_vmap_batch_order(struct page **pages,
> +		pgprot_t prot, unsigned int max_steps, unsigned int idx)
> +{
> +	unsigned int nr_contig;
> +	int order;
> +
> +	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
> +		return 0;
> +
> +	nr_contig = num_pages_contiguous(&pages[idx], max_steps);
> +	if (nr_contig < 2)
> +		return 0;
> +
> +	order = ilog2(nr_contig);
> +
> +	/* Limit order by pfn alignment */
> +	order = min_t(int, order, __ffs(page_to_pfn(pages[idx])));

As said previously, you need to account for the case where pfn is zero.


> +
> +	if (vm_shift(prot, PAGE_SIZE << order) == PAGE_SHIFT)
> +		return 0;

Correct. There is no point in clamping the order by vm_shift(), because then
we won't be able to batch multiple cont blocks. So in case (PAGE_SIZE << order) is
a quantity less than CONT_PTE_SHIFT, simply bail out from batching.


> +
> +	return order;
> +}
> +
> +static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
> +		pgprot_t prot, struct page **pages)
> +{
> +	unsigned int count = (end - addr) >> PAGE_SHIFT;
> +	unsigned int prev_shift = 0, idx = 0;
> +	unsigned long map_addr = addr, batch_end = addr;
> +	int err;
> +
> +	err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
> +						PAGE_SHIFT, GFP_KERNEL);

Nit: Indentation. PAGE_SHIFT should start right below addr.

Apart from these two points, nothing jumped at me. So after these
are taken care of:

Reviewed-by: Dev Jain <dev.jain@arm.com>



> +	if (err)
> +		goto out;
> +
> +	for (unsigned int i = 0; i < count; ) {
> +		unsigned int shift = PAGE_SHIFT +
> +			get_vmap_batch_order(pages, prot, count - i, i);
> +
> +		if (!i)
> +			prev_shift = shift;
> +
> +		if (shift != prev_shift) {
> +			err = vmap_pages_range_noflush_walk(map_addr, batch_end,
> +					prot, pages + idx, prev_shift);
> +			if (err)
> +				goto out;
> +			prev_shift = shift;
> +			map_addr = batch_end;
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
> +		batch_end += 1UL << shift;
> +		i += 1U << (shift - PAGE_SHIFT);
> +	}
> +
> +	/* Remaining */
> +	if (map_addr < end)
> +		err = vmap_pages_range_noflush_walk(map_addr, end,
> +				prot, pages + idx, prev_shift);
> +
> +out:
> +	flush_cache_vmap(addr, end);
> +	return err;
> +}
> +
>  /**
>   * vmap - map an array of pages into virtually contiguous space
>   * @pages: array of page pointers
> @@ -3586,8 +3669,8 @@ void *vmap(struct page **pages, unsigned int count,
>  		return NULL;
>  
>  	addr = (unsigned long)area->addr;
> -	if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
> -				pages, PAGE_SHIFT) < 0) {
> +	if (vmap_pages_range_batched(addr, addr + size, pgprot_nx(prot),
> +				pages) < 0) {
>  		vunmap(area->addr);
>  		return NULL;
>  	}


