Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B607D3CCA0
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 03:05:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0C626B0088; Wed, 14 Jan 2026 22:05:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3B66B0089; Wed, 14 Jan 2026 22:05:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EF976B008A; Wed, 14 Jan 2026 22:05:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A4CC6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:05:24 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 25FD256433
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:05:24 +0000 (UTC)
X-FDA: 84332707368.30.6FB0062
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf29.hostedemail.com (Postfix) with ESMTP id D1B4512000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:05:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MMi15++i;
	spf=pass (imf29.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768446322; a=rsa-sha256;
	cv=none;
	b=yXsFsuB1eyqfTgdYlRBldxun2Sl70nUzd2cEzFzWqeP0RrLotH7Fc8UWYG62AJB5A6Ype6
	T167TZFTaRPILqH0cnB81Rak6r/xwfyai3rrsY6rQML9qswJDQQ8hNNNPWD5bqZHX2LGra
	DltU2VxuGDr+QRXEuF8sIxPjRcUaFlk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MMi15++i;
	spf=pass (imf29.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768446322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mB11v+LNnsjOPr8ngo74fqkZNGCjkh6mT7DwSX4qK6M=;
	b=N03rzR61LORj//vA2den4TpjuCH5qWlD74cjZdqQXIKzzk9aXYsjPFczMDoCeFs33EbKJt
	XZEnvOHBLmfwY9DtYBX70gbbPVw2XmhVynHxCNgiLII6w7TNlNx80uA8lODm/Bo7oZF7Zq
	qp5GFhkAa18URksEFUDeUH+9RtgKV4s=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=mB11v+LNnsjOPr8ngo74fqkZNGCjkh6mT7DwSX4qK6M=;
	b=MMi15++imELKcaTuHsBrm+0y0+P0Kl636jzw7NCmC2P1nLvjYPIteMJe1h33jy6AzvDzJD2Gz
	2rTk+5VF3+tZ3DNHNoGj84aMtJp2VBkIaS40+/FuRq4X6Ajq0Nq7XEJ3/yrkTYYS7iQCJkLseBf
	AX3mKn9wNGeqo7/avR6HftI=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4ds7772JZczRhRw;
	Thu, 15 Jan 2026 11:01:55 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 9A4B440538;
	Thu, 15 Jan 2026 11:05:15 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 15 Jan 2026 11:05:15 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 15 Jan 2026 11:05:13 +0800
Subject: Re: [PATCH v3 2/3] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
To: Jiaqi Yan <jiaqiyan@google.com>
CC: <nao.horiguchi@gmail.com>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <william.roche@oracle.com>,
	<tony.luck@intel.com>, <wangkefeng.wang@huawei.com>, <jane.chu@oracle.com>,
	<akpm@linux-foundation.org>, <osalvador@suse.de>, <muchun.song@linux.dev>,
	<rientjes@google.com>, <duenwen@google.com>, <jthoughton@google.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <jackmanb@google.com>,
	<hannes@cmpxchg.org>, <ziy@nvidia.com>, <harry.yoo@oracle.com>,
	<willy@infradead.org>
References: <20260112004923.888429-1-jiaqiyan@google.com>
 <20260112004923.888429-3-jiaqiyan@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <d6b6ed0a-4bf6-21ac-b00f-3c2d05a8e728@huawei.com>
Date: Thu, 15 Jan 2026 11:05:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260112004923.888429-3-jiaqiyan@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: x8jqj16ai1q88ur1h67s5cprtgze54qr
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D1B4512000B
X-Rspam-User: 
X-HE-Tag: 1768446320-491578
X-HE-Meta: U2FsdGVkX18VhtyFEfxvxDho+WgqXSS3fLdwYExbPCcSgsJYYHZv1PkSaZPv9AAC/8j3jvwecdgjB73bo7DJHH1//JDGiAL+RHLhYC0WVKq3pLqOssJY30Ys7LabaH989gf7/rDD6xhgw6dfRaB+7KgZ3Mnrt6e6Ym7ix/Ao3E4dFFfUK2xYx1N1Z7bwjDldcqW1WZuQ0l2BTc3eerkXCOyb+TV9Z2qfH8A+8ey2nHY4/cqXBSjKMpvV/f1aaEpv72MTuRjfTyP39wgD1hK5DSzrxTKD3b/4zCxtbyOybWGMXYxreCv7rFoe1wfdwZuRnAxsBZ24YZD817lWU1VaKV3iYcsrPF4VPF+4NNvdZCppD5iWBHRPIOjrytlHc+UMlylUKHSKNWJ5IlEUMN/N1dtwa7XmHj6082ZffzgEX96q82PKp4bUw5Vxh9K+cmixm7hIEvj6YDpScd6FjiHzKsWl+TsXltBqP1ItTu3N+dCEAtY9NetW2shQ2UWVerLxM18F//Ted1gaLOfTzCdWXQzKPfNwmMUcLyTLeDt6tDSOBxj0uTVZol4oBTARkPx1HjLhtts/Dt3FuQiD4kvlUPlwEJYJ+rFnwHvGV7gLir8HQz2b4Wd6VP9Z1ucA0CCIKi1vXLvru/9CvlQmjtMHf5aXD/BZ9kt5yk9LeTvAYxxaHbfRiENRCS2PHb79rvqtXzQSmYoB0dcGe5ueomKeQp2ELMBX70TN2zwNDRw1LXbt4mcHqGObsjRmGPSPE/rtjQHyS1qMXH+Be2KyRLoO5T0oLGVg7Lczrddgk8AywLsCeRQ/Bn1CFuY3s8neQ6esnOfRmdIqdnTXK7w+R5OfL9Q4qa64NwX1Dq6I6DNkIoCUhEpEQLxmputmGjSD8m6NG6DQGKqTLGk+q2Sfn2piP5XjeXCa3bAtqmkp1GgAk+5uPpnWymSNKmG4gQ1sPAOo3If+4T1/qOfNL1izJe8
 K/SWEF7h
 stlJrZAwFuScSNn7RHtGce0flQxW+b7Or2NiJ3NwbFuWLHlGMBv6E0gX/8dxO+4xMDZatthILIdm8PAknFzFVOlGas9To5O1ywjwj82TZKUFvnWB58g5XGcDAXSecHgL4WtTP4f2++41Sa2pwG3W+vULsoZD82wu6hSAzvaWnlWQMpgNes57DxoYKVs2GQ+E1MTaPfCIYbDnQh2s06qTL/tXtt6iWcWpJExyn77nF/CE6KbJzVQHVMTk6Y/TE7lJe8y2cmieYjMq4vm5TucE0xCZE6Azko+ii1LFzZ0jEpZXQZurEnlFddjNqwJ7XnpCRO2jj83yp36Q0djYa6ehqzmFr8FG21MQxVENhwQzWsTPIj1heCtsTzGKZHdNZ3knzoxmrjtZ7c9o7ZXPLxDqh6/H62L0mYCeJ1wjUXUYkQMvPWB/C9BF+pnkvQWEYLOnX2s5FV+SsL0NcOxW7IbFXjHYbxeX0uOsUOFp3uuySkI9YogeTvhKquvkunQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/1/12 8:49, Jiaqi Yan wrote:
> At the end of dissolve_free_hugetlb_folio(), a free HugeTLB folio
> becomes non-HugeTLB, and it is released to buddy allocator
> as a high-order folio, e.g. a folio that contains 262144 pages
> if the folio was a 1G HugeTLB hugepage.
> 
> This is problematic if the HugeTLB hugepage contained HWPoison
> subpages. In that case, since buddy allocator does not check
> HWPoison for non-zero-order folio, the raw HWPoison page can
> be given out with its buddy page and be re-used by either
> kernel or userspace.
> 
> Memory failure recovery (MFR) in kernel does attempt to take
> raw HWPoison page off buddy allocator after
> dissolve_free_hugetlb_folio(). However, there is always a time
> window between dissolve_free_hugetlb_folio() frees a HWPoison
> high-order folio to buddy allocator and MFR takes HWPoison
> raw page off buddy allocator.
> 
> One obvious way to avoid this problem is to add page sanity
> checks in page allocate or free path. However, it is against
> the past efforts to reduce sanity check overhead [1,2,3].
> 
> Introduce free_has_hwpoisoned() to only free the healthy pages
> and to exclude the HWPoison ones in the high-order folio.
> The idea is to iterate through the sub-pages of the folio to
> identify contiguous ranges of healthy pages. Instead of freeing
> pages one by one, decompose healthy ranges into the largest
> possible blocks having different orders. Every block meets the
> requirements to be freed via __free_one_page().
> 
> free_has_hwpoisoned() has linear time complexity wrt the number
> of pages in the folio. While the power-of-two decomposition
> ensures that the number of calls to the buddy allocator is
> logarithmic for each contiguous healthy range, the mandatory
> linear scan of pages to identify PageHWPoison() defines the
> overall time complexity. For a 1G hugepage having several
> HWPoison pages, free_has_hwpoisoned() takes around 2ms on
> average.
> 
> Since free_has_hwpoisoned() has nontrivial overhead, it is
> wrapped inside free_pages_prepare_has_hwpoisoned() and done
> only PG_has_hwpoisoned indicates HWPoison page exists and
> after free_pages_prepare() succeeded.
> 
> [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net
> [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net
> [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> 
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>

Thanks for your patch. This patch looks good to me. A few nits below.

> ---
>  mm/page_alloc.c | 157 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 154 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 822e05f1a9646..9393589118604 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -215,6 +215,9 @@ gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
>  unsigned int pageblock_order __read_mostly;
>  #endif
>  
> +static bool free_pages_prepare_has_hwpoisoned(struct page *page,
> +					      unsigned int order,
> +					      fpi_t fpi_flags);
>  static void __free_pages_ok(struct page *page, unsigned int order,
>  			    fpi_t fpi_flags);
>  
> @@ -1568,8 +1571,10 @@ static void __free_pages_ok(struct page *page, unsigned int order,
>  	unsigned long pfn = page_to_pfn(page);
>  	struct zone *zone = page_zone(page);
>  
> -	if (free_pages_prepare(page, order))
> -		free_one_page(zone, page, pfn, order, fpi_flags);
> +	if (!free_pages_prepare_has_hwpoisoned(page, order, fpi_flags))
> +		return;
> +
> +	free_one_page(zone, page, pfn, order, fpi_flags);

It might be better to write as:

if (free_pages_prepare_has_hwpoisoned(page, order, fpi_flags))
	free_one_page(zone, page, pfn, order, fpi_flags);

just like previous one.

>  }
>  
>  void __meminit __free_pages_core(struct page *page, unsigned int order,
> @@ -2923,6 +2928,152 @@ static bool free_frozen_page_commit(struct zone *zone,
>  	return ret;
>  }
>  
> +/*
> + * Given a range of physically contiguous pages, efficiently free them
> + * block by block. Block order is chosen to meet the PFN alignment
> + * requirement in __free_one_page().
> + */
> +static void free_contiguous_pages(struct page *curr, unsigned long nr_pages,
> +				  fpi_t fpi_flags)
> +{
> +	unsigned int order;
> +	unsigned int align_order;
> +	unsigned int size_order;
> +	unsigned long remaining;
> +	unsigned long pfn = page_to_pfn(curr);
> +	const unsigned long end_pfn = pfn + nr_pages;
> +	struct zone *zone = page_zone(curr);
> +
> +	/*
> +	 * This decomposition algorithm at every iteration chooses the
> +	 * order to be the minimum of two constraints:
> +	 * - Alignment: the largest power-of-two that divides current pfn.
> +	 * - Size: the largest power-of-two that fits in the current
> +	 *   remaining number of pages.
> +	 */
> +	while (pfn < end_pfn) {
> +		remaining = end_pfn - pfn;
> +		align_order = ffs(pfn) - 1;
> +		size_order = fls_long(remaining) - 1;
> +		order = min(align_order, size_order);
> +
> +		free_one_page(zone, curr, pfn, order, fpi_flags);
> +		curr += (1UL << order);
> +		pfn += (1UL << order);
> +	}
> +
> +	VM_WARN_ON(pfn != end_pfn);
> +}
> +
> +/*
> + * Given a high-order compound page containing certain number of HWPoison
> + * pages, free only the healthy ones to buddy allocator.
> + *
> + * Pages must have passed free_pages_prepare(). Even if having HWPoison
> + * pages, breaking down compound page and updating metadata (e.g. page
> + * owner, alloc tag) can be done together during free_pages_prepare(),
> + * which simplifies the splitting here: unlike __split_unmapped_folio(),
> + * there is no need to turn split pages into a compound page or to carry
> + * metadata.
> + *
> + * It calls free_one_page O(2^order) times and cause nontrivial overhead.
> + * So only use this when the compound page really contains HWPoison.
> + *
> + * This implementation doesn't work in memdesc world.
> + */
> +static void free_has_hwpoisoned(struct page *page, unsigned int order,
> +				fpi_t fpi_flags)
> +{
> +	struct page *curr = page;
> +	struct page *next;
> +	unsigned long nr_pages;
> +	/*
> +	 * Don't assume end points to a valid page. It is only used
> +	 * here for pointer arithmetic.
> +	 */
> +	struct page *end = page + (1 << order);
> +	unsigned long total_freed = 0;
> +	unsigned long total_hwp = 0;
> +
> +	VM_WARN_ON(order == 0);
> +	VM_WARN_ON(page->flags.f & PAGE_FLAGS_CHECK_AT_PREP);
> +
> +	while (curr < end) {
> +		next = curr;
> +		nr_pages = 0;
> +
> +		while (next < end && !PageHWPoison(next)) {
> +			++next;
> +			++nr_pages;
> +		}
> +
> +		if (next != end && PageHWPoison(next)) {

A comment why clear_page_tag_ref is needed here should be helpful.

> +			clear_page_tag_ref(next);
> +			++total_hwp;
> +		}
> +
> +		free_contiguous_pages(curr, nr_pages, fpi_flags);
> +		total_freed += nr_pages;
> +		if (next == end)
> +			break;
> +
> +		curr = PageHWPoison(next) ? next + 1 : next;

IIUC, when code reaches here, we must have found a hwpoison page or next will equal to end.
So I think PageHWPoison(next) is always true and above code can be simplified as:

	curr = next + 1;

Thanks.
.

