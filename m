Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A96DC61DD6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 03:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FEDC6B008C; Thu,  3 Sep 2026 23:46:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AFBC6B0092; Thu,  3 Sep 2026 23:46:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09F256B0095; Thu,  3 Sep 2026 23:46:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D317C6B008C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 23:46:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 64AEBA495C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:46:16 +0000 (UTC)
X-FDA: 85174691952.14.4358560
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf13.hostedemail.com (Postfix) with ESMTP id C92CA20002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:46:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="6uC/vWv0";
	spf=pass (imf13.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788493574;
	b=cq6r8wqKz1z8vT5XEHhY2YcOiTuYnUqg6zkpnnLOAaBbqGPplqjeWZpcCl3LELupvEK17Z
	xdkDeoCyDGn4Lzzh7IBz2DFkGLfVwOCxRUhcxpBaPYt86hrA2BMC9rkt1ZY/mbknYaEPDD
	/GgmI2GcDCm8L9GtPAI1r8Su95m9ArQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788493574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SIuK7J1YBtgSbsO4y234J+OCLkHRVV8xFBrqxuZcDSY=;
	b=XJDq45TH81XDJmZUIU/ddnWUvUbQctjpXWM/E41p/XG1YcO8QnZwcy+Kke+K8mfAQOTaF+
	OAc0z5howI7E+rpgmIF926fctQg9bLxiYa0R5NkW3gOKfJtQ/dIj9VWEdPO8UHLRO6ls/n
	iNv9Xr6//x0aVpHEAuVKCSCYZdu1sCc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="6uC/vWv0";
	spf=pass (imf13.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=SIuK7J1YBtgSbsO4y234J+OCLkHRVV8xFBrqxuZcDSY=;
	b=6uC/vWv088IcSD3VRAb+C7qMy8CmOjPd0VDzbXrco+qQJERbahSNy8fjOrnfB6pC/+Dz57CDW
	KyQCG/e0CnT7nH2do2JAfb01k2ABou365u01YElwR2uwNmFkKW4mxWBG0CJBfdyluD96/pw1l97
	5r/YE6i0aGIgH0Q2BHmMYbo=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hbhtZ68r4zmVX8;
	Fri,  4 Sep 2026 11:35:18 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 1B8C540580;
	Fri,  4 Sep 2026 11:46:10 +0800 (CST)
Received: from [10.173.124.160] (10.173.124.160) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 4 Sep 2026 11:46:08 +0800
Subject: Re: [PATCH v9 08/15] hugetlb: Use the has_hwpoisoned flag
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
CC: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	<linux-fsdevel@vger.kernel.org>, Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>, "Gregory Price (Meta)" <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>, Jane Chu <jane.chu@oracle.com>,
	<linux-mm@kvack.org>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-9-willy@infradead.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <d30db03b-ffb4-52ce-c922-415ad75661ea@huawei.com>
Date: Fri, 4 Sep 2026 11:46:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260805210557.1118966-9-willy@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C92CA20002
X-Stat-Signature: qt8tdxdc6tkbe16tcgyqh7yrrhx4frtm
X-HE-Tag: 1788493573-650305
X-HE-Meta: U2FsdGVkX1/vMm+vPr+F6FXhMwZS0QykOiFJAyxGInED2D7zsz0jRdrDQKw2vfg8488WU90PxypTrDNBmABfVVBMhzfhkVWDcftnBGo5lozqwhZUjUj6nWoG95+14zLBJA8lHusm9iD0kEz6ovuXFn2vq2WeAqX/Sis08r0iQD0H9nqMbE7B8XILbFZOsuwXosJK+h9EwbTdexWXAYV+IdG1rhhimhYwydvdhUfrkVYjY/LpqUn+VHfFO2Bs2tcdIGD0zJbAEZrFxth9cDYrw9BHYnNDYG7Z0um/mL+0/z2nEQJ7bf9QnullL4YqbleEBm1Ux7rBcjRW8SaU9ePntUBpnpzUz7T+X+XiqbYaQMlCD+TJEx3GfbRInEld4Kl+vFiL4ukeX/sPklyMeufKIMYvx44YU0J5mDZ/yQ0cxFYc+yNstX6ABrjOIoV+/hiRhEdryXF53nSPfBi5HEB0grkXvaH9ATpNGWGHR8ChP/72g11LGUTXgW6uXii3xvHLx9DqKUASqcvRZcBaYhE56GVSptrxNjxeKLbW8YIeLtvKZqqTHCPoWs4ENG2pzg66Fd++Vyv69D+B8X/rrK3iImQ7MRlIBqy6tDvFVFzY3DKXwu7oxcpIP0S6zDXTM3xOEL3Q61Pngm3/UA/2kFD77b0TehTVgEYOin9otg2h+bPko8+apOqnEfKXvgYg/0QIb5h//T+sSmWRLoRvqujDKIVFfc/20MLpMlRIwqEa0csLor4O95xjqsxFZUTCsjSGxMiTn1xGpr9MnNdVtcFtWIAz4nzRGPZ3iDCRCnlLJjBG8AMTRszSIMwHrW+zuzPdBRucb/jazVdzjbazWQBK9SFq0IKEVhlyzGvAKCV+dMA6JLfTDPWeju1vNJUNyPkPDkXV5rZVLe/hwB6r94Z/oYGje/BAt8RufgZUldPvr6TaPBvPrjC5dTzkV2SwLHqaauFHb9Ev/pitBh8Xxwz
 dfqZgcnm
 3JTARGJCygO2eGdkWWL67XVupWFqKMmPNXSRt+SvkUhXImMJB69qXggH+tlOmkqh1MANAcz6In6xtsRHpmIl/LYffpRMbnfOdKzGqouKJ3HW22mnry7xy/J3zk+DF+c/NTjH8IIsLzoAlh8Mw1moa+3pp985ux79awBrnDG7oCXWTOOFIgNN5FJ7ju2VQdMVeL392SoxO7jzqBm/fpTtRHYt2VSPZpuGnr/RYSbymBfk/CcpdEiLj8juIzIX+sRnXKpV4IFxtMg0X++D9VkP2HVS+n9lQ6QrCkUx/EVxEAaN/tTGbSasCOj18WNjaYvviUgjpns0CCEmyDZwgOx8qzZPhwTnifvMVluJmW+m1Y2mIZGrc8E8nNaOvq7f2ZWNLCFTpgNAYR8LgKKRFPE/1VwNbhbZjJtpWKLOOv1p2KHfQkWc+VMqV2CpcyPLXcuNk3FKUgXDIL5ylNK8Rdf+kQ9Mr7m3WK7pIGxN22FNJ9k5Ro33x2ofsfBujkcLzz72mNtXBEtUqrFu7RPlwBZ52qvWAJ4Qw0yfsm1uKLi3mni56PZc/evqT6HoQxHT4lEWmoQUf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/8/6 5:05, Matthew Wilcox (Oracle) wrote:
> Other large folios use the has_hwpoisoned flag.  Convert hugetlb to match.
> This will help us use the per-page hwpoison flag in the future.
> 
> Also introduce a folio_test_huge_poison().  This has exactly the same
> meaning as folio_test_has_hwpoisoned() but can be used when we don't have
> a reference to the folio containing the page.  folio_test_has_hwpoisoned()
> can race with folio splitting / reallocation and trip the assertions
> in const_folio_flags().
> 
> This closes a gap where a page in a previously-poisoned hugetlb folio
> could be observed to not have the hwpoison bit set.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  fs/Kconfig                 |  2 +-
>  fs/hugetlbfs/inode.c       |  2 +-
>  include/linux/page-flags.h | 47 ++++++++++++++++++++++++------
>  mm/Kconfig                 |  6 +++-
>  mm/hugetlb.c               | 10 +++----
>  mm/memory-failure.c        | 58 +++++++++++++++++++++++++++-----------
>  mm/rmap.c                  | 43 +++++++++++++++++-----------
>  7 files changed, 120 insertions(+), 48 deletions(-)
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index cf6ae64776e6..eddac4ed214b 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -272,7 +272,7 @@ endif # HUGETLBFS
>  
>  config HUGETLB_PAGE
>  	def_bool HUGETLBFS
> -	select XARRAY_MULTI
> +	select LARGE_FOLIO
>  
>  config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>  	def_bool HUGETLB_PAGE
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 216e1a0dd0b2..fbac554886c3 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -258,7 +258,7 @@ static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  		} else {
>  			folio_unlock(folio);
>  
> -			if (!folio_test_hwpoison(folio))
> +			if (!folio_test_has_hwpoisoned(folio))
>  				want = nr;
>  			else {
>  				/*
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 4185a03a45cf..7e8784e852fb 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -893,14 +893,20 @@ static inline int PageTransCompound(const struct page *page)
>  TESTPAGEFLAG_FALSE(TransCompound, transcompound)
>  #endif
>  
> -#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
> +#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_LARGE_FOLIO)
>  /*
> - * PageHasHWPoisoned indicates that at least one subpage is hwpoisoned in the
> - * compound page.
> + * The has_hwpoisoned flag indicates that at least one page is hwpoisoned
> + * in the folio.  That page will usually also have the HWPoison flag
> + * set, but this is not possible for folios which have HugeTLB vmemmap
> + * optimization (see hugetlb_update_hwpoison() for the scheme used
> + * in that case).  You probably don't want to call this directly; use
> + * folio_has_hwpoisoned_page() instead.
>   *
>   * This flag is set by hwpoison handler.  Cleared by THP split or free page.
>   */
>  FOLIO_FLAG(has_hwpoisoned, FOLIO_SECOND_PAGE)
> +FOLIO_TEST_SET_FLAG(has_hwpoisoned, FOLIO_SECOND_PAGE)
> +FOLIO_TEST_CLEAR_FLAG(has_hwpoisoned, FOLIO_SECOND_PAGE)
>  #else
>  FOLIO_FLAG_FALSE(has_hwpoisoned)
>  #endif
> @@ -1041,8 +1047,29 @@ PAGE_TYPE_OPS(Slab, slab, slab)
>  
>  #ifdef CONFIG_HUGETLB_PAGE
>  FOLIO_TYPE_OPS(hugetlb, hugetlb)
> +
> +#ifdef CONFIG_MEMORY_FAILURE
> +static inline bool folio_test_huge_poison(const struct folio *folio)
> +{
> +	return (READ_ONCE(folio->page.page_type) >> 23) ==
> +		((PGTY_hugetlb << 1) | 1);
> +}
> +
> +static inline void folio_set_huge_poison(struct folio *folio)
> +{
> +	folio->page.page_type |= (1 << 23);
> +}
> +
> +static inline void folio_clear_huge_poison(struct folio *folio)
> +{
> +	folio->page.page_type &= ~(1 << 23);
> +}
> +#else
> +FOLIO_TEST_FLAG_FALSE(huge_poison)
> +#endif
>  #else
>  FOLIO_TEST_FLAG_FALSE(hugetlb)
> +FOLIO_TEST_FLAG_FALSE(huge_poison)
>  #endif
>  
>  PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
> @@ -1069,9 +1096,10 @@ static inline bool PageHuge(const struct page *page)
>  }
>  
>  /*
> - * Check if a page is currently marked HWPoisoned. Note that this check is
> - * best effort only and inherently racy: there is no way to synchronize with
> - * failing hardware.
> + * Check if a page is currently marked HWPoisoned.  This check is best
> + * effort only and inherently racy: there is no way to synchronize with
> + * failing hardware.  The caller may not have a refcount on the folio
> + * containing the page, so we must be careful to not trip any assertions.
>   */
>  static inline bool is_page_hwpoison(const struct page *page)
>  {
> @@ -1080,12 +1108,15 @@ static inline bool is_page_hwpoison(const struct page *page)
>  	if (PageHWPoison(page))
>  		return true;
>  	folio = page_folio(page);
> -	return folio_test_hugetlb(folio) && PageHWPoison(&folio->page);
> +	if (folio_test_huge_poison(folio))
> +		return true;
> +	/* In case we raced with hugetlb transferring flags */
> +	return PageHWPoison(page);
>  }
>  
>  static inline bool folio_has_hwpoisoned_page(const struct folio *folio)
>  {
> -	return folio_test_hwpoison(folio) ||
> +	return PageHWPoison(&folio->page) ||
>  	       (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
>  }
>  
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 9e0ca4824905..e666dd14ca0c 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -843,11 +843,15 @@ config PERSISTENT_HUGE_ZERO_FOLIO
>  config MM_ID
>  	def_bool n
>  
> +config LARGE_FOLIO
> +	def_bool n
> +	select XARRAY_MULTI
> +
>  menuconfig TRANSPARENT_HUGEPAGE
>  	bool "Transparent Hugepage Support"
>  	depends on HAVE_ARCH_TRANSPARENT_HUGEPAGE && !PREEMPT_RT
>  	select COMPACTION
> -	select XARRAY_MULTI
> +	select LARGE_FOLIO
>  	select MM_ID
>  	help
>  	  Transparent Hugepages allows the kernel to use huge pages and
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 47403d02be88..40ae967b9ecc 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1255,7 +1255,7 @@ static struct folio *dequeue_hugetlb_folio_node_exact(struct hstate *h,
>  		if (pin && !folio_is_longterm_pinnable(folio))
>  			continue;
>  
> -		if (folio_test_hwpoison(folio))
> +		if (folio_test_has_hwpoisoned(folio))
>  			continue;
>  
>  		if (is_migrate_isolate_page(&folio->page))
> @@ -1387,7 +1387,7 @@ static void folio_clear_hugetlb(struct folio *folio)
>  	 * Move HWPoison flag to each error page
>  	 * which makes any healthy pages reusable.
>  	 */
> -	if (unlikely(folio_test_hwpoison(folio)))
> +	if (unlikely(folio_test_has_hwpoisoned(folio)))
>  		folio_clear_hugetlb_hwpoison(folio);
>  
>  	__folio_clear_hugetlb(folio);
> @@ -4003,7 +4003,7 @@ long demote_pool_huge_page(struct hstate *src, nodemask_t *nodes_allowed,
>  		struct folio *folio, *next;
>  
>  		list_for_each_entry_safe(folio, next, &src->hugepage_freelists[node], lru) {
> -			if (folio_test_hwpoison(folio))
> +			if (folio_test_has_hwpoisoned(folio))
>  				continue;
>  
>  			remove_hugetlb_folio(src, folio, false);
> @@ -5814,7 +5814,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
>  		 * don't have hwpoisoned swap entry for errored virtual address.
>  		 * So we need to block hugepage fault by PG_hwpoison bit check.
>  		 */
> -		if (unlikely(folio_test_hwpoison(folio))) {
> +		if (unlikely(folio_test_has_hwpoisoned(folio))) {
>  			ret = VM_FAULT_HWPOISON_LARGE |
>  				VM_FAULT_SET_HINDEX(hstate_index(h));
>  			goto backout_unlocked;
> @@ -6323,7 +6323,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
>  	ptl = huge_pte_lock(h, dst_mm, dst_pte);
>  
>  	ret = -EIO;
> -	if (folio_test_hwpoison(folio))
> +	if (folio_test_has_hwpoisoned(folio))
>  		goto out_release_unlock;
>  
>  	ret = -EEXIST;
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 1dd0e7b99bb1..714e1b398f2c 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1829,7 +1829,7 @@ bool is_raw_hwpoison_page_in_hugepage(struct page *page)
>  	struct folio *folio = page_folio(page);
>  	bool ret = false;
>  
> -	if (!folio_test_hwpoison(folio))
> +	if (!folio_test_has_hwpoisoned(folio))
>  		return false;
>  
>  	if (!folio_test_hugetlb(folio))
> @@ -1881,6 +1881,24 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
>  #define	MF_HUGETLB_FOLIO_PRE_POISONED	3	/* folio already poisoned */
>  #define	MF_HUGETLB_PAGE_PRE_POISONED	4	/* exact page already poisoned */
>  #define	MF_HUGETLB_RETRY		5	/* hugepage is busy, retry */
> +
> +static inline int hugetlb_set_poison(struct folio *folio)
> +{
> +	if (folio_test_set_has_hwpoisoned(folio))
> +		return MF_HUGETLB_FOLIO_PRE_POISONED;
> +	folio_set_huge_poison(folio);
> +	return 0;
> +}
> +
> +static inline int hugetlb_clear_poison(struct folio *folio)
> +{
> +	if (!folio_test_has_hwpoisoned(folio))
> +		return -EBUSY;
> +	folio_clear_huge_poison(folio);
> +	folio_clear_has_hwpoisoned(folio);
> +	return 0;
> +}
> +
>  /*
>   * Set hugetlb folio as hwpoisoned, update folio private raw hwpoison list
>   * to keep track of the poisoned pages.
> @@ -1890,12 +1908,12 @@ static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
>  	struct llist_head *head;
>  	struct raw_hwp_page *raw_hwp;
>  	struct raw_hwp_page *p;
> -	int ret = folio_test_set_hwpoison(folio) ? MF_HUGETLB_FOLIO_PRE_POISONED : 0;
> +	int ret = hugetlb_set_poison(folio);
>  
>  	/*
>  	 * Once the hwpoison hugepage has lost reliable raw error info,
> -	 * there is little meaning to keep additional error info precisely,
> -	 * so skip to add additional raw error info.
> +	 * there is no point in keeping additional error info precisely,
> +	 * so skip adding additional raw error info.
>  	 */
>  	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
>  		return MF_HUGETLB_FOLIO_PRE_POISONED;
> @@ -1950,8 +1968,8 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
>  		return;
>  	if (folio_test_hugetlb_vmemmap_optimized(folio))
>  		return;
> -	folio_clear_hwpoison(folio);
>  	folio_free_raw_hwp(folio, true);
> +	folio_clear_has_hwpoisoned(folio);

Should hugetlb_clear_poison be used here to clear huge_poison flag now that hwpoison flag
is transferred to the raw error pages? Apart from this, this patch looks good to me.

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

