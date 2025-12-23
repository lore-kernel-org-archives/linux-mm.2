Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A368BE6F061
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 07:45:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FA666B0005; Tue, 23 Dec 2025 02:45:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A8316B0089; Tue, 23 Dec 2025 02:45:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 889446B008A; Tue, 23 Dec 2025 02:45:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 790366B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 02:45:45 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10FBA59736
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 07:45:45 +0000 (UTC)
X-FDA: 84249951450.03.C3BD84D
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf23.hostedemail.com (Postfix) with ESMTP id C0384140003
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 07:45:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=0RDIALuj;
	spf=pass (imf23.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766475943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AoHo9JfWV6Xkphx5gMoMRHhKwDGbvZJnsVAbXgZDjwU=;
	b=TTgnFNOpqVjk38TwEDYdGqK+F7zRy9pV2Hgc99zMP+VUN5/TMUZDjkT5X77QrhbCMBS57p
	g4eVdvAQTlBCP+4hevzLnrKLa2yndjQeF8sWZ83RHp1fWAjlXZQkenddY+8uHuHZf6R7x4
	DYuKHUu+cNyv7nI/esXVjMQKWhiZ4mw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=0RDIALuj;
	spf=pass (imf23.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766475943; a=rsa-sha256;
	cv=none;
	b=1Fw/plGUUXGPMl0kDRwsZDv3VvHqEujQOzk0MZxbOlJKKTWOAUHnlj1eOx6mjWyz9eOzH8
	1PxrU7JmjPBLSvuGpbzipZj71Z1T5L8lUx9Wqny7zaCWzD3t9cIkNT1NXuQlYlLs3Q+Apz
	AwPedOl3CYFynU5B6YJl0Amen4AQW2s=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=AoHo9JfWV6Xkphx5gMoMRHhKwDGbvZJnsVAbXgZDjwU=;
	b=0RDIALujvp6dIVoxEeHOaSXoyXdGovJVh1O5JnV3BCORQJ91VbSLbiHKKyDAUiY6EeLfXwwXj
	ziCwbBu8Pxe9brhamPwQtxN+M2W8C5dePqRyRFYsLR686KweWJyl22hfnHbRbHkarSrvv9/9+g+
	7Uj6EHCWHAZiy6oDz9dwLBI=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4db6RW6l8yz1K96x;
	Tue, 23 Dec 2025 15:42:31 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 2EFAF4056E;
	Tue, 23 Dec 2025 15:45:36 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 23 Dec 2025 15:45:34 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 23 Dec 2025 15:45:33 +0800
Subject: Re: [PATCH v2 2/3] mm/page_alloc: only free healthy pages in
 high-order HWPoison folio
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
References: <20251219183346.3627510-1-jiaqiyan@google.com>
 <20251219183346.3627510-3-jiaqiyan@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <1d42b98b-c7f9-f96a-1a8c-87943075ae1b@huawei.com>
Date: Tue, 23 Dec 2025 15:45:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20251219183346.3627510-3-jiaqiyan@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C0384140003
X-Stat-Signature: qfqf7apmarcdi4fy8aatpfeh7aoybnue
X-HE-Tag: 1766475941-815691
X-HE-Meta: U2FsdGVkX19IEbkbG9CnP+T8K2l8XKWUrgxWThJkdSavzCSzd0RtqkdxKkmDjYx1axSeibBFn2DnUaHbeM+XHAUZLCtIqT6D3MdPgq08s2Uun49gyAL3JPZNQ9/8Cc6ij+wVCLHqmdzML/C8BP7gdi9br1MW8LhCHjpq7rcxBbyB2V9X6AbwPDy4iYGbqB+8M3xzHFkAvDwp37dTx9ujTMsk+9dSHjMJ2KhhvxO0A4rChF9dxxJLD61asbMSw8l5wB4zSaG7gmEsdyOABq4stDnb0npYmuSzCWcOZmOElgrrPFpLAtsujNFhbx5y+iWzORL6SHb3dJVOCBi5jqipXqu1PFhwTe5kih4l12nDNERuLOjK8ZmQpEXr+MVSHscD6a86N5/zB/o2QyF7SkWZVeA3gV+n795m+gY1mJ+wLe6D2DFjcpeea1fPPXM3KDtyj5h4LUFYAj8xob6/TceDzaUNZrElEeqqbEHzw3pghV81Yer9p54rk7VHBY3qjZD10Ao6+P5nwsLGGjhpbVXYeY9WFIhDGb6UTbjFL2rtHes2IjJ8uaUE5ESYAnINbh3mKlgsyDd1UUmIUKoa45V6xnZQkQ4+TaTeOgjPWKRzvMmzqw9lDd0NWUQv2NYMH6xC6FbOM/b8Y5Ob+n/qJs+Gn3OpMYhPa+sLSO5Ml6DL627WN0UfLRdoBj9QkePydmNkWvYRCDaK4lkxZnp6Im2Ln3QUooz/sgzYeuIf8cUJ5lGzWjsfGnCRxwDPk4kdhIud6C/tmqWRRMwSFj+FBFXejIzUS32RAS7O/P2WVqCJ61XnyNTEVDTp/Yj31M9K2KhKif+oDVgCI3FS+BtDlS0CUu5J10MMb2t2cAAI+ZMsasDmegZCLecp5Ya/R7aByLQ6gREK5SCaR4UOTmAlQcn2Q8lGdQYGKh4/o4GfjmkcSA6qsOm7hpUHxEL/nNWfSJ1C0osWmObg5iHXC+4c9hl
 B1TtZWQx
 t50NePBidCQ8tYH2k5n54VimvF8qbL/3A/1Oh3tjLNnPsZjiT463RqWK1pI8OT00UKZacn9accvak7Ahou1qO/8pBZ0z4Ls5G9J2OO1vG2GwXP7IZGIkJMfLGj2nhf5peDao4vi0bXjju34DfQoLYtTqNN27JsFuKPSSO2Mz2WLWuAuyeEadaHqIDRD+R8QFAGSEJnc0VSHKFGpUeAuMuZM0X6r1ZcaP8YoGTzRj6a6WvIlMt0qSJf4GAOJXQMa7UhUtF6/IYAPXY9QEwwOeFSxKl+fSg9JiCYZqrqkfA9TJCF8vg6M0Z14VkiPi5OCAEWcdAnovwIi4MR/+cF2Uekxrg8t/dNPOMS34eHe0eBi7RzJcT01rxZw/OL3ul/tK0pBQbov27FEDn1uHj6JpcVSFhQEQwhwMLnDzdErb3objjVMcbXOOBnOLn/IzzO5nMqYis70XEca8HnRsUAIZmcU8BG2xWnHIooZB39mzt6OHJIC2y+GxcrssWTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/12/20 2:33, Jiaqi Yan wrote:
> At the end of dissolve_free_hugetlb_folio that a free HugeTLB
> folio becomes non-HugeTLB, it is released to buddy allocator
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
> dissolve_free_hugetlb_folio. However, there is always a time
> window between dissolve_free_hugetlb_folio frees a HWPoison
> high-order folio to buddy allocator and MFR takes HWPoison
> raw page off buddy allocator.
> 
> One obvious way to avoid this problem is to add page sanity
> checks in page allocate or free path. However, it is against
> the past efforts to reduce sanity check overhead [1,2,3].
> 
> Introduce free_has_hwpoison_pages to only free the healthy
> pages and excludes the HWPoison ones in the high-order folio.
> The idea is to iterate through the sub-pages of the folio to
> identify contiguous ranges of healthy pages. Instead of freeing
> pages one by one, decompose healthy ranges into the largest
> possible blocks. Each block meets the requirements to be freed
> to buddy allocator (__free_frozen_pages).
> 
> free_has_hwpoison_pages has linear time complexity O(N) wrt the
> number of pages in the folio. While the power-of-two decomposition
> ensures that the number of calls to the buddy allocator is
> logarithmic for each contiguous healthy range, the mandatory
> linear scan of pages to identify PageHWPoison defines the
> overall time complexity.
> 

Thanks for your patch.

> [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net/
> [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net/
> [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> 
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> ---
>  mm/page_alloc.c | 101 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 101 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 822e05f1a9646..20c8862ce594e 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2976,8 +2976,109 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
>  	}
>  }
>  
> +static void prepare_compound_page_to_free(struct page *new_head,
> +					  unsigned int order,
> +					  unsigned long flags)
> +{
> +	new_head->flags.f = flags & (~PAGE_FLAGS_CHECK_AT_FREE);
> +	new_head->mapping = NULL;
> +	new_head->private = 0;
> +
> +	clear_compound_head(new_head);
> +	if (order)
> +		prep_compound_page(new_head, order);
> +}
> +
> +/*
> + * Given a range of pages physically contiguous physical, efficiently
> + * free them in blocks that meet __free_frozen_pages's requirements.
> + */
> +static void free_contiguous_pages(struct page *curr, struct page *next,
> +				  unsigned long flags)
> +{
> +	unsigned int order;
> +	unsigned int align_order;
> +	unsigned int size_order;
> +	unsigned long pfn;
> +	unsigned long end_pfn = page_to_pfn(next);
> +	unsigned long remaining;
> +
> +	/*
> +	 * This decomposition algorithm at every iteration chooses the
> +	 * order to be the minimum of two constraints:
> +	 * - Alignment: the largest power-of-two that divides current pfn.
> +	 * - Size: the largest power-of-two that fits in the
> +	 *   current remaining number of pages.
> +	 */
> +	while (curr < next) {
> +		pfn = page_to_pfn(curr);
> +		remaining = end_pfn - pfn;
> +
> +		align_order = ffs(pfn) - 1;
> +		size_order = fls_long(remaining) - 1;
> +		order = min(align_order, size_order);
> +
> +		prepare_compound_page_to_free(curr, order, flags);> +		__free_frozen_pages(curr, order, FPI_NONE);
> +		curr += (1UL << order);

For hwpoisoned pages, nothing is done for them. I think we should run at least
some portion of code snippet from free_pages_prepare():

if (unlikely(PageHWPoison(page)) && !order) {
		/* Do not let hwpoison pages hit pcplists/buddy */
		reset_page_owner(page, order);
		page_table_check_free(page, order);
		pgalloc_tag_sub(page, 1 << order);

		/*
		 * The page is isolated and accounted for.
		 * Mark the codetag as empty to avoid accounting error
		 * when the page is freed by unpoison_memory().
		 */
		clear_page_tag_ref(page);
		return false;
	}

> +	}
> +
> +	VM_WARN_ON(curr != next);
> +}
> +
> +/*
> + * Given a high-order compound page containing certain number of HWPoison
> + * pages, free only the healthy ones to buddy allocator.
> + *
> + * It calls __free_frozen_pages O(2^order) times and cause nontrivial
> + * overhead. So only use this when compound page really contains HWPoison.
> + *
> + * This implementation doesn't work in memdesc world.
> + */
> +static void free_has_hwpoison_pages(struct page *page, unsigned int order)
> +{
> +	struct page *curr = page;
> +	struct page *end = page + (1 << order);
> +	struct page *next;
> +	unsigned long flags = page->flags.f;
> +	unsigned long nr_pages;
> +	unsigned long total_freed = 0;
> +	unsigned long total_hwp = 0;
> +
> +	VM_WARN_ON(flags & PAGE_FLAGS_CHECK_AT_FREE);
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
> +		if (PageHWPoison(next))
Would it be possible next points to end? In that case, irrelevant even nonexistent page
will be accessed ?

Thanks.
.

