Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E24B6CD8C85
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 03:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3EEA6B008A; Mon,  8 Jun 2026 23:45:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEF756B008C; Mon,  8 Jun 2026 23:45:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDEB26B0092; Mon,  8 Jun 2026 23:45:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BDEB06B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 23:45:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 521DBC1992
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:45:03 +0000 (UTC)
X-FDA: 84858983286.13.8691E78
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf20.hostedemail.com (Postfix) with ESMTP id ECEA11C0002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:44:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GqlAwjbC;
	spf=pass (imf20.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780976701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cJEBHfzpdSI7jJEj6r2mkE4T7/MNZZCxJ7D6F6LoI5Y=;
	b=rSE06TEaTQmaVFeI6trMCNXX1dKL7v4j8KeOWe0WhKQIsKTEsd5Xmdt9MmTrAX9amMF7k8
	5yBnKd2yGvL0Jv6FaCB1vcYmcAUyu2MWhaXlkh9XTzW3wYEfMD20u2cpbWzdsN0eSj9EKz
	oqvbq6CQY7+A5H9xGs4xuERw0dxrtKg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GqlAwjbC;
	spf=pass (imf20.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780976701;
	b=VzFtWKffaXpg+Kb+GdMlNmQbWaG32UyEJ9l4MbHTYfx5ty1bcoQhDZByMNO0BYFZkCmWsY
	VLYA/sK40iJpP3PVwZDG/rYq5FrGeiWTSnnU6aDL4t3PGGYWVXUuN7B4YsrBp7NZKEftXu
	Y+S5pmHhc7pkJFS76si0dhlxpbbgJiQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=cJEBHfzpdSI7jJEj6r2mkE4T7/MNZZCxJ7D6F6LoI5Y=;
	b=GqlAwjbCyhW4RI4yEiZPHwk/dY5roBbGJrKi9EArE6LHLMvAsS7RauBNLsVr9E3p499erBOPl
	jeQdzcPN4HPQm9UdJWeiUnbMnsgi6YfBFzLjfW1V5mxjFf1UhmAxtorymZ4IgRxS823qinTE0K6
	0pnZ+K7Ms9zr+S1HW6B7kUQ=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gZF2n6hb5zpStk;
	Tue,  9 Jun 2026 11:37:05 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 885E7203B8;
	Tue,  9 Jun 2026 11:44:54 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Jun 2026 11:44:54 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Jun 2026 11:44:52 +0800
Subject: Re: [PATCH v5 1/4] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
To: Jiaqi Yan <jiaqiyan@google.com>
CC: <osalvador@suse.de>, <lorenzo.stoakes@oracle.com>, <jackmanb@google.com>,
	<hannes@cmpxchg.org>, <nao.horiguchi@gmail.com>, <david@kernel.org>,
	<william.roche@oracle.com>, <tony.luck@intel.com>,
	<wangkefeng.wang@huawei.com>, <jane.chu@oracle.com>,
	<akpm@linux-foundation.org>, <muchun.song@linux.dev>, <liam@infradead.org>,
	<rientjes@google.com>, <duenwen@google.com>, <jthoughton@google.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <shuah@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <boudewijn@delta-utec.com>, <ljs@kernel.org>,
	<osalvador@kernel.org>, <ziy@nvidia.com>, <harry.yoo@oracle.com>,
	<willy@infradead.org>
References: <20260531055829.3636554-1-jiaqiyan@google.com>
 <20260531055829.3636554-2-jiaqiyan@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <84a0b176-8534-e03a-9e6e-400c74ddab0b@huawei.com>
Date: Tue, 9 Jun 2026 11:44:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260531055829.3636554-2-jiaqiyan@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ECEA11C0002
X-Stat-Signature: ngqnjwxjhdnyfi87ginghc5jftxsdgro
X-Rspam-User: 
X-HE-Tag: 1780976699-222621
X-HE-Meta: U2FsdGVkX1+FQUT+WUktbX3znQrPhUeCU3dE+YFZSdcvuVGxntHeLnq6qjQYEjMMMDa6NedrAXORzawhfiRZnvv3ZS5dLCLyVQ6KK+ofF+XmR5Sf9FByBJaTR29ZzqwdFTT2X5XY6jHEHU65I+q4Akg87/CsoWsmKMpUR+Nx9ujbqb3r3VDrkwNronXIsWM4u263Js0+K26u1WPoTxrzITqDQjLEeG3HomGSfqHSX1Z79FENp+PjeitGLx4ywJtPY1JEVwXyrPlf9aGBtbOLeF9SydFxUR33TgEsx4J3imfRcIdmi29CBq9i+bX4WUEJtH8vdD0U2Lq7vxNeLZzNspG38qlGQSVgEyBhmTwdw5D56OgMlVj9A6CDlmBZmBKmBB2NsXuSYLZUctFiMpb5xopqG5D3JA7oVN1A3hIvpgjUM/ODWKhPh7cnnsyjkCVCVEVwiVYIcWtq7wyzk09w4khohYN/bF37plC8lrRscKBt3WVNP3cFeA7mWXkaei27vJ2L8knUb6JQZCq/Z0gm1hokun/9vMSwXUFlvqfJKEZqaV1UItHbCtiwS4a9IaBnFpIrq7oMdUrGsnSfE8h+EBTu5FWnlqiLyK8gBApEet9HNPhrb72i2VRa7f0bwEaY3STommazbbWVAifnX9F5wCA3inb4OFBmkXfNF48AtY5t6uf9f4XfEiaXqaM8pUAAk/AlFXB75qTio9JjpHfzk2wPoqgO99QCGokyARDqClNMeBz3taO3Cp2NzhiceXjk3wFYsj40NSyimOQs0VYBkk6YggKADR0jiBaRS1kqDxLWkPhN2/7MqcebVNUguMqjg+HDbcDIz1cErGA+VUjlvRYmiZHUI/qczXF3jwnNpiXW+qhhyojCV/loAQBQEoAIlSAkErWmoso0fr2lqh4qFG7RavmScN5/QneYok2QBojpGypjqNHDE78Jz52CDUOBIAatdiFDIc0i8jvS1Cx
 72jCHiOw
 zhxQoaHdi+Lx9BIVwoPa2l5y/UtVcpRA1gQNGukg4mFp+k0Ny56SmwrtbRrR+YdvUOq8KD9xuS+cjBrrrrWqwCQyJGmcDhzSg48AFW1KluMkD9fTbTHBIsorns+AkgPdGWgzVjnxjwg4lkzl9ZEe9VVGIid0d9gFZpZ6pfEC8t8ZXk1hglKtzA+AZqf6Xs2pNXf4dzPKt/Ayx8kNBGo3+32MqMUIjD6d2jX+vbDJHgran1mq2vgiost4ZjwQ9PpaMk9derURCbFM668ljyJUeESCY3zA2lMC6wGtgtbOsUwEDu5RU0l4KUAn5AVxUinIuCi0FkTX0P2zU/pTuOsCwIA67A0JGGC/2P0HNxTNi2EYr44GcYkoKkvM4xm/9IF2q6pnkKzwhL51FzWH2tcKifY1D9esoK5x2XVszDY/78hinS8OA7b2gs9mXZcXcZQTpxbIsNfVdT0QEV46IvRnrNjBCo3J4eQg70ytVvvd4Kr500R9iXK+nxPfmM/hIMzAQM++TIPGuMsQ9ZFN9Mf0xTz8XJBsu5I1kR/9ZvtrS6Vr/WHzRFVieRz4JoPCO7e7yTZmo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/5/31 13:58, Jiaqi Yan wrote:
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
> Another similar situation is when a transparent huge page (THP)
> runs into memory failure but splitting failed. Such THP will
> eventually be released to buddy allocator when owning userspace
> processes are gone, but with certain subpages having HWPoison.
> 
> One obvious way to avoid both problems is to add page sanity
> checks in page allocate or free path. However, it is against
> the past efforts to reduce sanity check overhead [1,2,3].
> 
> Introduce free_has_hwpoisoned() to only free the healthy pages
> and to exclude the HWPoison ones in the high-order folio.
> The idea is to iterate through the sub-pages of the folio to
> identify contiguous ranges of healthy pages.
> 
> free_has_hwpoisoned() is added in free_pages_prepare() as
> a shortcut and is only invoked if PG_has_hwpoisoned indicates
> HWPoison page exists and after checks and preparations in
> free_pages_prepare() all succeeded. free_has_hwpoisoned() then
> can re-use free_prepared_contig_range() [4] to decompose healthy
> ranges into the largest possible chunks of different orders.
> Every chunk meets the requirements to be freed via free_one_page().
> 
> free_has_hwpoisoned() has linear time complexity wrt the number
> of pages in the folio. While the power-of-two decomposition
> ensures that the number of calls to the buddy allocator is
> logarithmic for each contiguous healthy range, the mandatory
> linear scan of pages to identify PageHWPoison() defines the
> overall time complexity. For a 1G hugepage having 8 HWPoison
> pages, free_has_hwpoisoned() takes around 1ms on average on
> a system having 56 Intel Skylake physical cores. This is
> 15x to the case of freeing no HWPoison page. The cost is far
> from triggering soft lockup, and fair for handling exceptional
> hardware memory errors.
> 
> [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net
> [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net
> [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> [4] https://lore.kernel.org/all/20260401101634.2868165-2-usama.anjum@arm.com
> 
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>

Thanks for your update. This patch looks good to me while some comments below.

> ---
>  mm/page_alloc.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 85 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e47679e7a9db..03df929abca6 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -208,6 +208,7 @@ gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
>  unsigned int pageblock_order __read_mostly;
>  #endif
>  
> +static void free_has_hwpoisoned(struct page *page, unsigned int order);
>  static void __free_pages_ok(struct page *page, unsigned int order,
>  			    fpi_t fpi_flags);
>  static void reserve_highatomic_pageblock(struct page *page, int order,
> @@ -1309,6 +1310,14 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
>  
>  #endif /* CONFIG_MEM_ALLOC_PROFILING */
>  
> +/*
> + * Returns
> + * - true: checks and preparations all good, caller can proceed freeing.
> + * - false: do not proceed freeing for one of the following reasons:
> + *   1. Some check failed so it is not safe to proceed freeing.
> + *   2. A compound page has some HWPoison pages. The healthy pages
> + *      are already safely freed, and the HWPoison ones isolated.
> + */
>  static __always_inline bool __free_pages_prepare(struct page *page,
>  		unsigned int order, fpi_t fpi_flags)
>  {
> @@ -1317,6 +1326,15 @@ static __always_inline bool __free_pages_prepare(struct page *page,
>  	bool init = want_init_on_free();
>  	bool compound = PageCompound(page);
>  	struct folio *folio = page_folio(page);
> +	/*
> +	 * When dealing with compound page, PG_has_hwpoisoned is cleared
> +	 * with PAGE_FLAGS_SECOND. So the check must be done first.
> +	 *
> +	 * Note we can't exclude PG_has_hwpoisoned from PAGE_FLAGS_SECOND.
> +	 * Because PG_has_hwpoisoned == PG_active, free_page_is_bad() will
> +	 * confuse and complaint that the first tail page is still active.
> +	 */
> +	bool should_fhh = compound && folio_test_has_hwpoisoned(folio);
>  
>  	if (fpi_flags & FPI_PREPARED)
>  		return true;
> @@ -1443,6 +1461,16 @@ static __always_inline bool __free_pages_prepare(struct page *page,
>  
>  	debug_pagealloc_unmap_pages(page, 1 << order);
>  
> +	/*
> +	 * After breaking down compound page and dealing with page metadata
> +	 * (e.g. page owner and page alloc tags), take a shortcut if this
> +	 * was a compound page containing certain HWPoison subpages.
> +	 */
> +	if (should_fhh) {
> +		free_has_hwpoisoned(page, order);
> +		return false;
> +	}

When the code reaches here, the hwpoisoned pages have passed through kernel_poison_pages,
kasan_poison_pages, kernel_init_pages, arch_free_page... These functions might write to
the hwpoisoned pages. Is it safe to do so?

> +
>  	return true;
>  }
>  
> @@ -6936,6 +6964,63 @@ void __free_contig_range(unsigned long pfn, unsigned long nr_pages)
>  	__free_contig_range_common(pfn, nr_pages, /* is_frozen= */ false);
>  }
>  
> +/*
> + * Given a high-order compound page containing certain number of HWPoison
> + * pages, free only the healthy ones.
> + *
> + * Pages must have passed free_pages_prepare(). Even if having HWPoison
> + * pages, breaking down compound page and updating metadata (e.g. page
> + * owner, alloc tag) can be done together during free_pages_prepare(),
> + * which simplifies the splitting here: unlike __split_unmapped_folio(),
> + * there is no need to turn split pages into a compound page or to carry
> + * metadata.
> + *
> + * It scans every raw page of the compound page and cause nontrivial overhead.
> + * So only use this when the compound page contains HWPoison page(s).
> + *
> + * This implementation needs rework in memdesc world.
> + */
> +static void free_has_hwpoisoned(struct page *page, unsigned int order)
> +{
> +	unsigned long curr = page_to_pfn(page);
> +	unsigned long end_pfn = curr + (1 << order);
> +	unsigned long next;
> +	unsigned long total_freed = 0;
> +	unsigned long total_hwp = 0;
> +
> +	VM_WARN_ON(order == 0);
> +	VM_WARN_ON(page->flags.f & PAGE_FLAGS_CHECK_AT_PREP);
> +
> +	while (curr < end_pfn) {
> +		next = curr;
> +
> +		while (next < end_pfn && !PageHWPoison(pfn_to_page(next)))
> +			++next;
> +
> +		if (next != end_pfn && PageHWPoison(pfn_to_page(next))) {

Check next != end_pfn should be enough. If we have next != end_pfn, we must have PageHWPoison(pfn_to_page(next))
or we can't exit from above while loop. Or am I miss something?

Thanks.
.

