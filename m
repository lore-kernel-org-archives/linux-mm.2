Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AAE4C44507
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 07:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B72F86B0099; Fri, 17 Jul 2026 03:19:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4B6B6B009B; Fri, 17 Jul 2026 03:19:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A39E96B009D; Fri, 17 Jul 2026 03:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 76E346B0099
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 03:19:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 00559C039C
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 07:19:25 +0000 (UTC)
X-FDA: 84997417932.07.6B8BE1A
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf09.hostedemail.com (Postfix) with ESMTP id 49E7F140009
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 07:19:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=FACQmsQc;
	spf=pass (imf09.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784272764;
	b=pM7HcxCMBel+1FpOf+HojWsebOfz3VJVgvEAi4yVRXfTAXXZHY6sZjFEoZcPq+IuyptM1J
	XhT5RhPTpoVzCavPcQyEwPKlPH7qGwXwUxc7A9t5E/Dzg25IKs5lWmpILsTKjJirkuDc6f
	7f3iQH9PCZdz2V7PNGDTb1CHyzmtdPI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=FACQmsQc;
	spf=pass (imf09.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784272764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ve7S9uujVjIoNZdwni2CUOfgdqYTTYKhCjgxR8TomvQ=;
	b=TgM87MVU7GPAl085o4KRk0jLBlaePbXjSGfd+lbpJa6l4KbOHFNYSUh81snRIysHoshHnw
	EL32RoJEe7HL4gvSm92EosQoQ+S49gDN0XemE1AreP0dJoIoMeAMceJoLdPpyzxrjn9X+W
	9btsFwCzrElae3LKHLM5toPrS5r1eds=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ve7S9uujVjIoNZdwni2CUOfgdqYTTYKhCjgxR8TomvQ=;
	b=FACQmsQcQR+P8KCfXFdqGsj8q7c6yhMz9IvVMNwenrxjUwXuBTF5yf66EjyA+3t5y4B9zHrBE
	18V8q4+l9qMVyk1Ep7tEWpkmOe+wdbOzE3sLq1WKktkZ+XirScrgDqnxLMltv3PeUVGWGVq0qIV
	sCIXBbwQNW6wJmO47P6l3wk=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4h1gyv1131zLlTg;
	Fri, 17 Jul 2026 15:09:59 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id A7A174048B;
	Fri, 17 Jul 2026 15:19:18 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 17 Jul 2026 15:19:18 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 17 Jul 2026 15:19:16 +0800
Subject: Re: [PATCH v6 2/5] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
To: Jiaqi Yan <jiaqiyan@google.com>
CC: <osalvador@kernel.org>, <harry.yoo@oracle.com>, <willy@infradead.org>,
	<osalvador@suse.de>, <jackmanb@google.com>, <hannes@cmpxchg.org>,
	<nao.horiguchi@gmail.com>, <david@kernel.org>, <william.roche@oracle.com>,
	<tony.luck@intel.com>, <wangkefeng.wang@huawei.com>, <jane.chu@oracle.com>,
	<akpm@linux-foundation.org>, <muchun.song@linux.dev>, <liam@infradead.org>,
	<rientjes@google.com>, <duenwen@google.com>, <jthoughton@google.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <shuah@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <boudewijn@delta-utec.com>, <ljs@kernel.org>,
	<ziy@nvidia.com>, <vbabka@kernel.org>
References: <20260705180714.3708947-1-jiaqiyan@google.com>
 <20260705180714.3708947-3-jiaqiyan@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <d46c6393-c516-4fc0-31d4-b2e9d6de0942@huawei.com>
Date: Fri, 17 Jul 2026 15:19:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260705180714.3708947-3-jiaqiyan@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 49E7F140009
X-Stat-Signature: hybeqzj8rabuhi6tt1d8jtfszmxxrpn8
X-HE-Tag: 1784272763-200274
X-HE-Meta: U2FsdGVkX1/0IrT3RDnxgBNy2Apxqa+pkGAGA8Ib6sTe6dH4aCV8uNf8LphQ84XZOTJOipVgpgNhVkx0uB3CkEE5CeLeVf3GMmvtZWX5bg7f56+nL7K4g9c2osyeI2SE8+tjy51Kev8C2OCQi4AY5lABLkjt0LO+pqfFdNF4aCiNsfgMI+cu/Mzbvhq7jHFwp4O7hH25a+9CKZSNnuEBO3CL2YkjzmkWNpwswsYTsRAa/xJOeZVRTmkwEvcKAHWcTjCYw/FoTWY0y6mPgK1cGS2mzjIIKz/PlaUuNrtMbjM/FZaN/QiRmouI88CnpTWzfekcLYT9K+UOZdIx9jb6ozyWy4ozVcB/syqGe1kPnz6nyGvFX2ne6BZb0gJJ7d2E01FTK6ultDBzPY2yDLxYFIkT62LiVo6vBKXv+uyUyMqPRGK0VtytnLkusiVt0PJ9pTu1Bl4TTcPf+fguJ4E/LB9qWgjT+44cwin9IzAg2Dc3szHV9V21CdCrv0nPP637Cqg3EVAOYzA32BjTURmR+93uBGm6RQdzKCLYAic9x0j7m8eZmDiB4Z8+lIh97seDd7HjwqbC6Vr7t91CGi+pdjwzLB0Ur35ejGvacPp/UfXdQWKqqn0G5hhIFhzUvL9Wl4Sqbh76g5rTytWiF56Jrbzcaraty5Grw5bjdJOjXdiKK5Jnv2JByAiR3MuDUmstm3CsL0CgVC37jqqm7d3ryRh5OpLMyfCfMGFT0nJHd4SkJ0znM8BLwOlpafgD49cW2SR3Qchs3XLcK2Xjq0Ub4aqksC3W0ZjJgTak8slUTkmkSvaSDze05hJe4e8dlXDonr05ZabRwYmXurAn5G2RS7BYnoCV6ECTbq+/gt4G3SLyEhXFeKcjtxJ01m7DQ7YVDIhYeK/pgn61cJAtov9kA5tWWOgC1xDo7uPOcWA0JrtPotFfRayxaszOM8XJ/eQfr3+thg5MZxXA4YTM3U7
 FSLcYa1s
 4Eh14tA6lC+4fZqoekrA3JdR0qS9eafX4w1RWUrDiCin136t/peWll+w8gn22RSuHGkuczFF7EBS9pbMhCgqjv4NJEMfBTLIks4xBL1s03yRjOGJfuituwSjiMJfN0oOCSRAwGIFvtdFoKUj15SuFAVsI+Wlzs3Uiv3HVrFRP5uAGweboHyqCFwkL6GEzCzInxtGJcACad20xVEm+EvAtYW2sbiw5MFN+7fHcSOT95xXfE0OHi6hszLJq5hBHtAht326xqOcIrD9Fou+YvRTuRDvDdkCqX8CSiTvyMaUzYoXhzUGVRnXtbtWm91XBdiEvp+v8BeKpeMZwreT7YAuzXXSzMaUiccAhB/o+yL0Uh23zVbU6US6hFYFhfDRhaF9wSm+v4XzIJD2v88LI7qLEBtSZsyKtUfE0lSUiggx2M/JFwD5c4QqWLHxwjCRv9CoMebPVl+JPdm3/x2Dsbf38o5UUTN1qnIUBCGblARw9/YqNtenlh/uv9JZcFaH3jWhI/xWkF4le/zXMKsk4IIBv3p2xkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/7/6 2:07, Jiaqi Yan wrote:
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
> free_has_hwpoisoned() is added at the end of __free_pages_prepare()
> as a shortcut and only if PG_has_hwpoisoned indicates HWPoison page
> exists and after checks and preparations in __free_pages_prepare()
> all succeeded. It then use __free_prepared_contig_range() to
> decompose healthy range into the largest possible chunks of
> different orders, then freed via __free_frozen_pages().
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
> 
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Nits:

> ---
>  mm/page_alloc.c | 165 ++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 140 insertions(+), 25 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 7d27aff48b15..6418896c9df6 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -93,6 +93,13 @@ typedef int __bitwise fpi_t;
>  /* free_pages_prepare() has already been called for page(s) being freed. */
>  #define FPI_PREPARED		((__force fpi_t)BIT(3))
>  
> +/*
> + * Page(s) needs to go through free_pages_sanitize(), for example, because
> + * free_pages_prepare() cannot sanitize a high-order page block due to
> + * hardware error in some page(s).
> + */
> +#define FPI_SANITIZE		((__force fpi_t)BIT(4))
> +
>  /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
>  static DEFINE_MUTEX(pcp_batch_high_lock);
>  #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
> @@ -210,6 +217,8 @@ gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
>  unsigned int pageblock_order __read_mostly;
>  #endif
>  
> +static void free_has_hwpoisoned(struct page *page, unsigned int order,
> +				fpi_t fpi_flags);
>  static void __free_pages_ok(struct page *page, unsigned int order,
>  			    fpi_t fpi_flags);
>  static void reserve_highatomic_pageblock(struct page *page, int order,
> @@ -1311,14 +1320,73 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
>  
>  #endif /* CONFIG_MEM_ALLOC_PROFILING */
>  
> +/*
> + * Sanitize, which requires writing, a block of pages at the last moment of
> + * preparing to freeing them, i.e. __free_pages_prepare().

s/freeing/free/ ?

> + */
> +static void free_pages_sanitize(struct page *page, unsigned int order)
> +{
> +	bool init = want_init_on_free();
> +	/*
> +	 * __kasan_unpoison_pages() sets kasan tag on every tail page, so
> +	 * it is fine to use should_skip_kasan_poison() when pages here
> +	 * were a set of tail pages from a compound folio.
> +	 */
> +	bool skip_kasan_poison = should_skip_kasan_poison(page);
> +
> +	kernel_poison_pages(page, 1 << order);
> +
> +	/*
> +	 * As memory initialization might be integrated into KASAN,
> +	 * KASAN poisoning and memory initialization code must be
> +	 * kept together to avoid discrepancies in behavior.
> +	 *
> +	 * With hardware tag-based KASAN, memory tags must be set before the
> +	 * page becomes unavailable via debug_pagealloc or arch_free_page.
> +	 */
> +	if (!skip_kasan_poison) {
> +		kasan_poison_pages(page, order, init);
> +
> +		/* Memory is already initialized if KASAN did it internally. */
> +		if (kasan_has_integrated_init())
> +			init = false;
> +	}
> +	if (init)
> +		clear_highpages_kasan_tagged(page, 1 << order);
> +
> +	/*
> +	 * arch_free_page() can make the page's contents inaccessible.  s390
> +	 * does this.  So nothing which can access the page's contents should
> +	 * happen after this.
> +	 */
> +	arch_free_page(page, order);
> +
> +	debug_pagealloc_unmap_pages(page, 1 << order);
> +}
> +
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
>  	int bad = 0;
> -	bool skip_kasan_poison = should_skip_kasan_poison(page);
> -	bool init = want_init_on_free();
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
> @@ -1416,34 +1484,19 @@ static __always_inline bool __free_pages_prepare(struct page *page,
>  					   PAGE_SIZE << order);
>  	}
>  
> -	kernel_poison_pages(page, 1 << order);
> -
>  	/*
> -	 * As memory initialization might be integrated into KASAN,
> -	 * KASAN poisoning and memory initialization code must be
> -	 * kept together to avoid discrepancies in behavior.
> +	 * After breaking down compound page and dealing with page metadata
> +	 * (e.g. page owner and page alloc tags), take a shortcut if this
> +	 * was a compound page containing certain HWPoison subpages.
>  	 *
> -	 * With hardware tag-based KASAN, memory tags must be set before the
> -	 * page becomes unavailable via debug_pagealloc or arch_free_page.
> +	 * FPI_SANITIZE to remember free_pages_sanitize() healthy pages.
>  	 */
> -	if (!skip_kasan_poison) {
> -		kasan_poison_pages(page, order, init);
> -
> -		/* Memory is already initialized if KASAN did it internally. */
> -		if (kasan_has_integrated_init())
> -			init = false;
> +	if (should_fhh) {
> +		free_has_hwpoisoned(page, order, fpi_flags | FPI_SANITIZE);
> +		return false;
>  	}
> -	if (init)
> -		clear_highpages_kasan_tagged(page, 1 << order);
> -
> -	/*
> -	 * arch_free_page() can make the page's contents inaccessible.  s390
> -	 * does this.  So nothing which can access the page's contents should
> -	 * happen after this.
> -	 */
> -	arch_free_page(page, order);
>  
> -	debug_pagealloc_unmap_pages(page, 1 << order);
> +	free_pages_sanitize(page, order);
>  
>  	return true;
>  }
> @@ -6869,7 +6922,14 @@ static void __free_prepared_contig_range(struct page *page,
>  		/*
>  		 * Free the chunk as a single block. Our caller has already
>  		 * called free_pages_prepare() for each order-0 page.
> +		 *
> +		 * If the original compound page has HWPoison page,
> +		 * free_pages_prepare() has to skip sanitize at that time,
> +		 * but now it is good time to do that.
>  		 */
> +		if (fpi_flags & FPI_SANITIZE)
> +			free_pages_sanitize(page, order);
> +
>  		__free_frozen_pages(page, order, fpi_flags | FPI_PREPARED);
>  
>  		pfn += 1UL << order;
> @@ -6956,6 +7016,61 @@ void __free_contig_range(unsigned long pfn, unsigned long nr_pages)
>  	__free_contig_range_common(pfn, nr_pages, /* is_frozen= */ false);
>  }
>  
> +/*
> + * Given some contiguous pages that have certain number of HWPoison page(s),
> + * free only the healthy ones.
> + *
> + * Used at the end of __free_pages_prepare(). Even if having HWPoison pages,
> + * breaking down compound page and clearing metadata (e.g. page owner, alloc
> + * tag) can be done together during __free_pages_prepare(), which simplifies
> + * the splitting here: unlike __split_unmapped_folio(), there is no need to
> + * turn split pages into a compound page or to carry metadata.
> + *
> + * It scans every raw page of the compound page and causes nontrivial overhead.
> + * So only use this when the compound page contains HWPoison page(s).
> + *
> + * It also works when order == 0, regardless of PageHWPoison() or not.

It works but won't be called when order == 0?

Thanks.
.

