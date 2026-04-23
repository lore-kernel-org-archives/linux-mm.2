Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D133FDEE3F
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 18:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 064626B0098; Thu, 23 Apr 2026 14:07:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F30A96B0099; Thu, 23 Apr 2026 14:07:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF7E46B009B; Thu, 23 Apr 2026 14:07:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CB88D6B0098
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:07:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 50BE7C1BAB
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 18:07:56 +0000 (UTC)
X-FDA: 84690604152.23.2B8A2FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id B5AFF40003
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 18:07:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uYM/2E6I";
	spf=pass (imf04.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776967674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=VzVM8yDoLwnCJscR4HtGD7tqUKySCfsqpXRGN11uzGk=;
	b=uaLuAq2d9YhyAprsXcIOBGBchg3HsiYrXvPzO02tQTvkhmYhaLXQF7pAFumhr84ajtjtqL
	kh31QVO+QEDFhgV2ONnpYngC799ER/M7XWmmcwcjlySkF1OOuzvyPPbwujsBnVP42srdpw
	mSQy+LrNCmw5wdXiQtcitq2YgmIHoX0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776967674; a=rsa-sha256;
	cv=none;
	b=dPxDbhNlvNNkfLJBWQKZkGcFLqJdVL6ucheN9KmhPmrD5TOBpTBw/zJfQCSNhl+/hjyWzZ
	c+EXH3r17wbodRL8mE0bZWsrs/c6au6V4aNMtWdpP0vW2+lPRY+wcsYNXz3uJNIHYsoUQQ
	3sBQQfHQfQa1oNBmcMOppVJZJ0/PHdE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uYM/2E6I";
	spf=pass (imf04.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C805D60139;
	Thu, 23 Apr 2026 18:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6278CC2BCAF;
	Thu, 23 Apr 2026 18:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776967673;
	bh=Yjuu/SxuRj411uYT2o/S4SkiBQqVvFVCipOk1uaH6gw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=uYM/2E6If0xjeIZ4GY7mCggHCaYlyPHY9gvOXiXky81sMBAPhMzOSzBMTBUnP9l4f
	 6aY3+mVFA5B41xMruDVbqMt42In+727djlrN6kcPNk2/xATzejNYkiYywlDKuTYh0C
	 JcSABnoK//uty6bYWk5kEpRtNIK7K6DRG/w6JqEGpU6z0Ejz/3/fuRW/40n5F0mm8w
	 l1DLIVO1HJ56B2sgjAdpAW9SWsDGbOP3bx1rj241D8mfSkCFBT2bSkHrc/vN9p41bP
	 8G3BEnXva8QObsH0eQOsRZ6a1ag/pzW0HyphlNA0E4WoEsOk3aaIBGuPh2ZiE7fB0w
	 txNeMbyjWYm6g==
Date: Thu, 23 Apr 2026 13:07:52 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
Cc: david@kernel.org, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
	apopple@nvidia.com, baolin.wang@linux.alibaba.com,
	gladyshev.ilya1@h-partners.com, harry.yoo@oracle.com,
	kirill@shutemov.name, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com,
	muchun.song@linux.dev, rppt@kernel.org, surenb@google.com,
	torvalds@linuxfoundation.org, vbabka@suse.cz, willy@infradead.org,
	yuzhao@google.com, ziy@nvidia.com, artem.kuzin@huawei.com
Subject: Re: [PATCH v2 1/2] mm: drop page refcount zero state semantics
Message-ID: <20260423180752.GA31613@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9fd8ebbc0f4f45be611bae0d03dd25dd994233c0.1776350895.git.gorbunov.ivan@h-partners.com>
X-Stat-Signature: nz1y1chbfniwhixhnfu7twucjf18xkce
X-Rspam-User: 
X-Rspamd-Queue-Id: B5AFF40003
X-Rspamd-Server: rspam05
X-HE-Tag: 1776967674-593898
X-HE-Meta: U2FsdGVkX1/XqbXyifgMzoUp1Cpz6tzykJhjCb48VtvRzKpgotgMQcz9R3HVHfB9VbzewRYiA+wB7LY6WnqYeS29ELLDOdxZ2ySSUDuvGutD70g0UZiNUgMN37izUf1GSoGwuhJBnDAKo3bs+S8/Pb+gntoX31cA20S0JMss84FfD6LHHZhZjVdEBN1Xi1t+vJkd0w1FY5DR+38gwch1Y7jdBbVpfeEVMwwxFi/VagBF02hqjgj1mGv/fl2wWuPi9+rHQM+nDUtRWAU+tZlQMWD+TCO1oTZSgbeOA2NC5p4qkgGdq02XP5QuZeDhZfqtmLawcsmZy679f7Boljkq00MCZo7UeYOOzTIsJnJDvQjONXRCW7q9qQwryZr1B1JlAXj8GjnHJzIvyUZ04hOAGMLU8Dl6a5QT7YcwdDVuW+ivzxi9o5hbLUf+cNFnJ/DM9qTP0TF7K5La9b3SXDRx7Az94ihvzXqww3ju+icX7Liyumh6ntyAWwvX8FIC4Ew3PiHMTEIT0zGOYwdFV7hML2+dEutE1ZLQJPqUJrSdP4/pJ8zJ39ys8C94H2N9Uf0Rqzo7zdq7scfLkpUx+kEfPAqSvWjZFvlN7BXtvfkXnxH5t6aECFCRJg5AaPz6QQjuneJoq8DI5b9AsnGY84RAzhU5xcKeKxisYUunAlUCK4nhZ+ogwi1iP020WYsAGE3DgkPqz9YSjSZSRnhGnjD7JsswSq5DC60qLRaWrOBp3ZanfgmAJhTYwNoD6Y5c708NEi7W8GdBapN5iAWgVMSpvaBDhVBfu1dVbsyifnko7amEvpHf0OGNjaEg0jkyHrN0TskexRDwaxnFozuA4wezzhuhOPdEEmNiX8GgbcTIFx36TOy3YWm6YXeD3W/NaGqtzQJERvDC6h0hnwgUEL/XDXWA6iFEf0+4rwu9mC/TEpyxgAHZRzXst29WVUipAi7ab0qbs0cHietYShcQnrx
 nTAocM3j
 ucc1TGQUkWaOv8HlFJqRMRp7yLI7C1Z5Jn2mstubMrpupd30bkOQaq/gNHYXt45c67CZCghkOoHg9LeO7pYWLBzN3wTrcL6kEyQTsSb6KR5QCJ35OJZth0oRCZzFRKysKgyStHhvj3Ifwy+WWcJ3t0Vnp759uPRhUv5MZvW/yqNJAKBR+28ZxO4X5BxdNk6Ko2QSj4KdAacuHnw3eGO/g2/QqkQ0EY8N2G4BaBbPQrLHfXkGUcXB1u40AIBSJSWz8qXxSA/YaEa5cIzAa5ytV9qp8VJ4aTh5QSzz495zGzvBqYeY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 08:01:18AM +0000, Gorbunov Ivan wrote:
> Right now 'zero' state could be interpreted in 2 ways
> 1) Unfrozen page which right now has no explicit owner
> 2) Frozen page
> 
> This states can be 'logically' distinguished by operations such as
> page_ref_add, page_ref_inc, etc. In the first we would want the counter to
> increase.
> 
> For example one can write
> 
> page = alloc_frozen_page(...);
> page_ref_inc(page, 1);
> 
> But in the second state increasing a counter of a frozen page, shouldn't be valid at all.
> 
> Another reason for change is our other patch (mm: implement page refcount locking via dedicated bit)
> in which frozen pages do not have 0 value in refcount when frozen.
> 
> This patch proposes 2 changes
> 1) Deprecate invariant that the value stored in reference count of frozen page is 0
> (Getter functions folio_ref_count/page_ref_count must still return 0 for frozen pages)
> 2) Allow modification operations like page_ref_add to be used only with
>    pages with owners
> 
> We've looked at places where pages are allocated, and they are
> always initialized via functions like set_page_count(page, 1). However, for
> clarity, we've added a debug BUG_ON inside modification functions to ensure
> that they are called only on pages with owners. In future those
> checks can be improved by replacing operations with their results
> returning analogs, if needed.
> 
> Co-developed-by: Gladyshev Ilya <gorbunov.ivan@h-partners.com>
> Signed-off-by: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
> Signed-off-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>

No opinion about the rest of the content, but the p2pdma.c change
looks like a no-op, so:

Acked-by: Bjorn Helgaas <bhelgaas@google.com> # p2pdma.c

You might consider rewrapping this commit log to fit in 75 columns or
so, as the log for the second patch does.

> ---
>  drivers/pci/p2pdma.c               |  2 +-
>  include/linux/page_ref.h           | 17 +++++++++++++++++
>  kernel/liveupdate/kexec_handover.c |  2 +-
>  mm/hugetlb.c                       |  2 +-
>  mm/mm_init.c                       |  6 +++---
>  mm/page_alloc.c                    |  4 ++--
>  6 files changed, 25 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index e0f546166eb8..e060ae7e1644 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -158,7 +158,7 @@ static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
>  			 * because we don't want to trigger the
>  			 * p2pdma_folio_free() path.
>  			 */
> -			set_page_count(page, 0);
> +			set_page_count_as_frozen(page);
>  			percpu_ref_put(ref);
>  			return ret;
>  		}
> diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
> index 94d3f0e71c06..a7a07b61d2ae 100644
> --- a/include/linux/page_ref.h
> +++ b/include/linux/page_ref.h
> @@ -62,6 +62,11 @@ static inline void __page_ref_unfreeze(struct page *page, int v)
>  
>  #endif
>  
> +static inline bool __page_count_is_frozen(int count)
> +{
> +	return count == 0;
> +}
> +
>  static inline int page_ref_count(const struct page *page)
>  {
>  	return atomic_read(&page->_refcount);
> @@ -115,8 +120,14 @@ static inline void init_page_count(struct page *page)
>  	set_page_count(page, 1);
>  }
>  
> +static inline void set_page_count_as_frozen(struct page *page)
> +{
> +	set_page_count(page, 0);
> +}
> +
>  static inline void page_ref_add(struct page *page, int nr)
>  {
> +	VM_BUG_ON(__page_count_is_frozen(page_count(page)));
>  	atomic_add(nr, &page->_refcount);
>  	if (page_ref_tracepoint_active(page_ref_mod))
>  		__page_ref_mod(page, nr);
> @@ -129,6 +140,7 @@ static inline void folio_ref_add(struct folio *folio, int nr)
>  
>  static inline void page_ref_sub(struct page *page, int nr)
>  {
> +	VM_BUG_ON(__page_count_is_frozen(page_count(page)));
>  	atomic_sub(nr, &page->_refcount);
>  	if (page_ref_tracepoint_active(page_ref_mod))
>  		__page_ref_mod(page, -nr);
> @@ -142,6 +154,7 @@ static inline void folio_ref_sub(struct folio *folio, int nr)
>  static inline int folio_ref_sub_return(struct folio *folio, int nr)
>  {
>  	int ret = atomic_sub_return(nr, &folio->_refcount);
> +	VM_BUG_ON(__page_count_is_frozen(ret + nr));
>  
>  	if (page_ref_tracepoint_active(page_ref_mod_and_return))
>  		__page_ref_mod_and_return(&folio->page, -nr, ret);
> @@ -150,6 +163,7 @@ static inline int folio_ref_sub_return(struct folio *folio, int nr)
>  
>  static inline void page_ref_inc(struct page *page)
>  {
> +	VM_BUG_ON(__page_count_is_frozen(page_count(page)));
>  	atomic_inc(&page->_refcount);
>  	if (page_ref_tracepoint_active(page_ref_mod))
>  		__page_ref_mod(page, 1);
> @@ -162,6 +176,7 @@ static inline void folio_ref_inc(struct folio *folio)
>  
>  static inline void page_ref_dec(struct page *page)
>  {
> +	VM_BUG_ON(__page_count_is_frozen(page_count(page)));
>  	atomic_dec(&page->_refcount);
>  	if (page_ref_tracepoint_active(page_ref_mod))
>  		__page_ref_mod(page, -1);
> @@ -189,6 +204,7 @@ static inline int folio_ref_sub_and_test(struct folio *folio, int nr)
>  static inline int page_ref_inc_return(struct page *page)
>  {
>  	int ret = atomic_inc_return(&page->_refcount);
> +	VM_BUG_ON(__page_count_is_frozen(ret - 1));
>  
>  	if (page_ref_tracepoint_active(page_ref_mod_and_return))
>  		__page_ref_mod_and_return(page, 1, ret);
> @@ -217,6 +233,7 @@ static inline int folio_ref_dec_and_test(struct folio *folio)
>  static inline int page_ref_dec_return(struct page *page)
>  {
>  	int ret = atomic_dec_return(&page->_refcount);
> +	VM_BUG_ON(__page_count_is_frozen(ret + 1));
>  
>  	if (page_ref_tracepoint_active(page_ref_mod_and_return))
>  		__page_ref_mod_and_return(page, -1, ret);
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index b64f36a45296..36c21f3d8250 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -390,7 +390,7 @@ static void kho_init_folio(struct page *page, unsigned int order)
>  
>  	/* For higher order folios, tail pages get a page count of zero. */
>  	for (unsigned long i = 1; i < nr_pages; i++)
> -		set_page_count(page + i, 0);
> +		set_page_count_as_frozen(page + i);
>  
>  	if (order > 0)
>  		prep_compound_page(page, order);
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 1d41fa3dd43e..b364fda29111 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3186,7 +3186,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>  	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
>  		__init_single_page(page, pfn, zone, nid);
>  		prep_compound_tail(page, &folio->page, order);
> -		set_page_count(page, 0);
> +		set_page_count_as_frozen(page);
>  	}
>  }
>  
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index cec7bb758bdd..e4ec672a9f51 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1066,7 +1066,7 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>  	case MEMORY_DEVICE_PRIVATE:
>  	case MEMORY_DEVICE_COHERENT:
>  	case MEMORY_DEVICE_PCI_P2PDMA:
> -		set_page_count(page, 0);
> +		set_page_count_as_frozen(page);
>  		break;
>  
>  	case MEMORY_DEVICE_GENERIC:
> @@ -1112,7 +1112,7 @@ static void __ref memmap_init_compound(struct page *head,
>  
>  		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
>  		prep_compound_tail(page, head, order);
> -		set_page_count(page, 0);
> +		set_page_count_as_frozen(page);
>  	}
>  	prep_compound_head(head, order);
>  }
> @@ -2250,7 +2250,7 @@ void __init init_cma_reserved_pageblock(struct page *page)
>  
>  	do {
>  		__ClearPageReserved(p);
> -		set_page_count(p, 0);
> +		set_page_count_as_frozen(p);
>  	} while (++p, --i);
>  
>  	init_pageblock_migratetype(page, MIGRATE_CMA, false);
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 65e702fade61..27734cf795da 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1639,14 +1639,14 @@ void __meminit __free_pages_core(struct page *page, unsigned int order,
>  		for (loop = 0; loop < nr_pages; loop++, p++) {
>  			VM_WARN_ON_ONCE(PageReserved(p));
>  			__ClearPageOffline(p);
> -			set_page_count(p, 0);
> +			set_page_count_as_frozen(p);
>  		}
>  
>  		adjust_managed_page_count(page, nr_pages);
>  	} else {
>  		for (loop = 0; loop < nr_pages; loop++, p++) {
>  			__ClearPageReserved(p);
> -			set_page_count(p, 0);
> +			set_page_count_as_frozen(p);
>  		}
>  
>  		/* memblock adjusts totalram_pages() manually. */
> -- 
> 2.43.0
> 

