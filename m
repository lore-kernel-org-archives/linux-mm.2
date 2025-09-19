Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A329ACA1013
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 05:01:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6030940008; Fri, 19 Sep 2025 01:01:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E36F48E0008; Fri, 19 Sep 2025 01:01:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7410940008; Fri, 19 Sep 2025 01:01:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C92CC8E0008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 01:01:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 743CD58D05
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:01:01 +0000 (UTC)
X-FDA: 83904800322.20.F328462
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id AB0C718000A
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:00:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758258059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U1kBTQtfHbXO8X4QoKetcQsC1cpuClKHlG0RlwvSVcc=;
	b=4+8igBff5oQsd86/mR/br5+Mznd4ssRgajhk6cP317uFWd5YNPvEGH+x0O4DBU491LyudR
	qFVwo9bGNMoeR0/IHSMLD8ClbMTDYmoAw//U4hnImT8Xn2bVifVNsIhxaeiTKQ7RBhicf9
	VByPzk6BjXeutqTDoIeLzgt94gsbCe4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758258059; a=rsa-sha256;
	cv=none;
	b=hn2tZho93HEhlveuRb9R79GZbSkk84QhMlAGG+kwpu9ZynQzuwrfvzR4wBdvY72sXN7bdn
	lBkGmzSlQzh66JyML82brrfDoJghkWHCr88OcurwHCLglrR2PitnC4Qnluv+Bp1qwEERa3
	Y0CnqA9ICvmTivfMQ+CbJ7701CfMGzQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 86A991758;
	Thu, 18 Sep 2025 22:00:50 -0700 (PDT)
Received: from [10.164.18.52] (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 06E843F66E;
	Thu, 18 Sep 2025 22:00:54 -0700 (PDT)
Message-ID: <b3a62c9d-22a6-4d83-84ba-699a13e631bf@arm.com>
Date: Fri, 19 Sep 2025 10:30:51 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] mm: page_alloc: optimize pfn_range_valid_contig()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
References: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
 <20250918132000.1951232-2-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250918132000.1951232-2-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AB0C718000A
X-Stat-Signature: dyntbtumjwps8njufat4a37knme4pf5g
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758258059-860298
X-HE-Meta: U2FsdGVkX18kqp4cawEs8IO6VTWYwT4ObmNmd5NTeGsDqrULUkYxwRq8GhsQQpz8UG80LRGnhhPAgM0d5IjUQNWFPLzW4hzpQMjrokWPCsu0EagJgET996zA1pfDDI72SRhsz77ep8t0g+iwvHs91PNSbMx/nxj52ypNSIhkUW1DZCDEe6+W5OEVWcYfDm7EigCUSqsx8TELaFNUCC3c2YeArtSuCa1jaw+ERyWcYKh90kJbABizLP0iIoj1BVy/P9BvUcEwMQG7A08f7vJ5lz6VUvs91cyOPBzZN//AD/Sbl4TmQ8W8ydF2LIr8zL15NjKbhduhep94O5/gINaCCLXuEZS+WncS/uOgG8uqrKZCkfiw2EexWqqytXaYWCTxEUQoQUe/tpFwTDUzZoMwb0A0cfG4DgyajT/pnBA0lKPSEwVdV0rmeld/KcLpx80SzFLGe4rorifb5iE+ZM85+LJGBgL8d0tyP896tdKsUnTB3PImVBtRpZW0dEHc1IX5fR0/61K8i1gBf6lYQjCZWbts0KHzvmahMlKzHQMOgDYVPN3eolYoqBZe/IxyorKB9T9XmcCReATLKxTlKz9sI4pngfB3zACEAXyX8eu7+8jG7SU3XqI3On6ARLzzkpPLUN10cjEk0n+5tzsA0giLk6oxKKJnpzzx3XZ1/o9HrVvVNSsEQo/INBiA26rhs7XQUcBqpVw/2kUEFaSexPjViILgdOCvFVB8kM4TMMtPjaR7W9AghebGargKWqoMcaCzV7F6XGUcrXNqCTkY24Vbtk3tq7Ajou6kYTxlp1PXwOmhxWMJeA9DlP2lUrh/pLXc+Bqk+5ABzJqiucQwktq2oMSAio45hCREt93sKb6kmrCfIPVYA22sReZFow/XLcX/+lwliRSbwJ5ZabgHJz2Uba10IWtq05X+zb7SPi0MPDFCESTt+3nxzO44cp9ODovKLUbgBRQSCn/flYXbIXq
 dmIrFDYV
 YyzBBFRQUwIW27c6TEuwt2jdIhtENDFuRoKUwxLuNY1H3WSNm8H2roLmydrsI8jTNfzdX5C64cSMMYNLOU2yOk7NG46uwXgJizJlyjXJbnTpztVcwuShakRi8YlkrJS+2M09ORaWs2RVBEwitmj437DkBx2bbBRReP5vNKboESxjpx/7esKh7d1wE4pKNKBjsQ5PRyypeqecgwCv9Qs9nojIX5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 18/09/25 6:49 pm, Kefeng Wang wrote:
> The alloc_contig_pages() spends a lot of time in pfn_range_valid_contig(),
> we could check whether the page in this pfn range could be allocated
> before alloc_contig_range(), if the page can't be migrated, no further
> action is required, and also skip some unnecessary iterations for
> compound pages such as THP and non-compound high order buddy, which
> save times a lot too. The check is racy, but the only danger is skipping
> too much.
>
> A simple test on machine with 116G free memory, allocate 120 * 1G
> HugeTLB folios(107 successfully returned),
>
>    time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
>
> Before: 0m2.124s
> After:  0m0.602s
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>   mm/page_alloc.c | 20 ++++++++++++++++++--
>   1 file changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 478beaf95f84..5b7d705e9710 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7012,6 +7012,7 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>   {
>   	unsigned long i, end_pfn = start_pfn + nr_pages;
>   	struct page *page;
> +	struct folio *folio;
>   
>   	for (i = start_pfn; i < end_pfn; i++) {
>   		page = pfn_to_online_page(i);
> @@ -7021,11 +7022,26 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>   		if (page_zone(page) != z)
>   			return false;
>   
> -		if (PageReserved(page))
> +		folio = page_folio(page);
> +		if (folio_test_reserved(folio))
>   			return false;
>   
> -		if (PageHuge(page))
> +		if (folio_test_hugetlb(folio))
>   			return false;
> +
> +		/* The following type of folios aren't migrated */
> +		if (folio_test_pgtable(folio) | folio_test_stack(folio))
> +			return false;
> +
> +		/*
> +		 * For compound pages such as THP and non-compound high
> +		 * order buddy pages, save potentially a lot of iterations
> +		 * if we can skip them at once.
> +		 */
> +		if (PageCompound(page))
> +			i += (1UL << compound_order(page)) - 1;

Can we instead do
if (folio_test_large(folio))
     i += folio_nr_pages(folio) - folio_page_idx(folio, page).

> +		else if (PageBuddy(page))
> +			i += (1UL << buddy_order(page)) - 1;
>   	}
>   	return true;
>   }

