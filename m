Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B624C531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 214F86B00C8; Mon, 27 Jul 2026 10:51:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EB8D6B00D2; Mon, 27 Jul 2026 10:51:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 102AA6B00D3; Mon, 27 Jul 2026 10:51:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD0D76B00C8
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:51:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7019B1402D6
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:51:35 +0000 (UTC)
X-FDA: 85034845350.03.8729E6D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id DC09D180007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:51:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=IO+ysveH;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785163893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4WLvl4z1mlw8PwVBwzpQShS1aPPG3mcmlz4u5T49hbc=;
	b=yTs0wVog/8/xmNsCT7JA9iqHnuymFsXYP1Ig8zlRyY3s1Zav2cZCh9czWITebkYyTf9QkX
	gpxZ3AWToLiBIHXgynyxHfnjyeN/2V50sTiIlWCMCsxofnIxWero0Xr/Xu0mK1GRDlrq+G
	0hwFgzI2CXOjWcJBm1TTssAB4ZIlXN8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785163894;
	b=GSv85ClxqlM6fEMt/07VdiAW56GSuEp3OnXYSfOULaJJ4qJ4C2uuR7+CJaIKU5Ga5RPSa1
	EPNFpAF6pPMwqMOockjSNo1t3021cQBv+YRFfD9HX8cdRfsVhDKlB/Jq+H4SXSXA+fJaLh
	eiJOPzocdE7Q8jTOmKLwPulhLi9GUz8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=IO+ysveH;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4WLvl4z1mlw8PwVBwzpQShS1aPPG3mcmlz4u5T49hbc=; b=IO+ysveHHPCt6r2bfF/uIbJzR4
	q284PPc1oCSzaF6wGlB8zMPLHVOev/kWX2bfBNwbdhd6psXmmFt57GpC+TO/i71cpDYV7AzuuG3MH
	V39thLJeRr/1QXsbPjKYqpuIOfVKEUHim0sa6jxcvS334jl81aBHNYKX8CiYPkK+/HdpmcbgAa++z
	9vE0Skj+pc2I69I3+COHn55QWpOrr5+N7NhDi7qJgONqAq+K2Bz2Lbaatg1DRbhMra/KYJEWwxurS
	1Hcm7dlh3G2vwump+sPvQnbh5PIKnrMHDU1Fiy4dxfNYcARgSvR8l5HaqLFsxINRtY2Yoyb3+gzHD
	oCFAFOFg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woMfy-0000000AtAg-0kmD;
	Mon, 27 Jul 2026 14:51:30 +0000
Date: Mon, 27 Jul 2026 15:51:29 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>, Usama Arif <usama.arif@linux.dev>
Subject: Re: [PATCH v5 02/12] mm: Rename folio_contain_hwpoison_page() to
 folio_has_hwpoison_page()
Message-ID: <amdwca1VRNPjEl8j@casper.infradead.org>
References: <20260725160042.1557264-1-willy@infradead.org>
 <20260725160042.1557264-3-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260725160042.1557264-3-willy@infradead.org>
X-Stat-Signature: 1q5giydwu8en9bkmwgudacgfs36kj7bm
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DC09D180007
X-HE-Tag: 1785163892-753105
X-HE-Meta: U2FsdGVkX19IPrUCZmqLoqq0mNJCULpUQnrURpuLrwKzcR6irFLzjBG6TetcCYekPhMipEXDLTEsbSAz62sHwj9N331seazZpf3gMBj+xs7Fjely7/ueUSeCMwWkJ5rtT5F4cZP0SCl4fgjUoF6/bXHVLtgcQV+zkQBptKMEW44xAcWtDfDIUMLJkBeE8APO3bkHhzUjmcNRtsYUPg8l2DeSMeyUYcJhk5xmKv6saIMERrlCXNvmzBeP3o3P13zfIMOnozcV3owIpQ8zT1xRxr5NEhMDqWdifRNbjB4ml3wIfzKvIqqrnKek1fxN8wHPxshbvxvH/m2Z90OCUyoVGlRJU4Pfc8Qh9O+mqlE3xM6HN6Oqi2uAC87emAGwPlkv4H6FR/CatOyb694WmdPObeYQUpkSu2X8puvSkxzn2qAmvcL/e6OxYBCHTOx+48FkYUCWk/lSkaOnj4kfXg/AzDpibj45GsegD9HFcT2Ke4wz6tf3T+RATvFUn8daRbpPCjiLdZt2yuRvtGqk+NeOQHS5cqwvJ4eL/Hj/vtotVqNpZoWUMy6sBdd0apbCqHss5ztQK8AtVoJ7KPTDcqUmchZPdZgH0JqIo7351p0KQ34nxQuPUbWytk/hG+acm5Zz6hrOxD2jMWI59ANGewKzy6g/nhlGMnJCO1TyoZqw62e1j6vsbZHep5ZNBEke1mycCwuVQbpSvNsDtzBL6yB0v/7f3AdA+WddFN7oJdZTVjurLAf0L7YNUbUgP9+hXxDg/RGZifF5qFLa28oaxIFPLMCHcR/Dul3CvWufH5TFlNUt5NsQRfoKPrE9NZ4vgRoNqM6ouMzZuzfWoU9c9ZHsFC2q1l2l+OUVRvm2Ky24TUImGKduREKl+UkvbrWXvnuKSDbYhg48VIO4Z+ZvIl3vpPtKQBElN2ccC94BOK7iKcVcofQ0ktfCWHCO7RpTyHCMpE00Xhd540MacjKlMW6
 rrgu+0f8
 MfgPnRcDK0FvUfCtDqPUC/HnTy4YV4jnizx5xKf1bbVJdRwl+l0wXl8NT4p0RerIUU8acAshALJpem4oqFCKZvxsDsH1fy7oQf2QDZZOMgDDyLoMPb56FsfGdcXUZw/XkUJS9n2Ea+zKOeXFd0tGnrCXGcnzsqYr8SDaVZzFbZCR1+5jO1pChCOofU59GfoIVdG6eBf4xWQnZFzh0WpyGjzdjLasmTrtn7+YFALROU+zAhnPBeyuiC961V9vcoMvRPdoM8ZSfBjDNNOXFq3Ca3fhKBxF4iKKHTAcywAmiXoua1KQlWqcrtfnv2Dw80ViCE3Die2nZrC76tDdPNWXaslx/E2ZZJCaEov1cPpNdBwJLxz84STZskg6L8HA3g/X8ESW3fhWiPLI2F4UGXdeiZYeQmPZO8ZWMytnL9duZb591yxU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko review:
> --- Patch [2]: [PATCH v5 02/12] mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page() ---
> commit 8fadf59bc3118e11dab2620f6cc376507c16b29a
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page()
> 
> This is a better name for this predicate.  Also make the argument const
> to allow other callers to be made const.  No functional change.
> 
> > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > index 7223f6f4e2b40..4185a03a45cf7 100644
> > --- a/include/linux/page-flags.h
> > +++ b/include/linux/page-flags.h
> > @@ -1083,10 +1083,10 @@ static inline bool is_page_hwpoison(const struct page *page)
> >  	return folio_test_hugetlb(folio) && PageHWPoison(&folio->page);
> >  }
> >  
> > -static inline bool folio_contain_hwpoisoned_page(struct folio *folio)
> > +static inline bool folio_has_hwpoisoned_page(const struct folio *folio)
> >  {
> >  	return folio_test_hwpoison(folio) ||
> > -	    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
> > +	       (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
> >  }
> 
> This isn't a bug introduced by this patch, but can KSM trigger a machine check
> exception when scanning memory?

Good lord.  I renamed a function.  Which apparently causes Sashiko to
look for bugs in every caller

> Looking at cmp_and_merge_page() in mm/ksm.c, the KSM scanner initiates page
> hash calculation:
> 
> mm/ksm.c:cmp_and_merge_page() {
>     ...
>     checksum = calc_checksum(page);
>     ...
> }
> 
> which then maps and reads the page content:
> 
> mm/ksm.c:calc_checksum() {
>     ...
>     void *addr = kmap_local_page(page);
>     checksum = xxhash(addr, PAGE_SIZE, 0);
>     ...
> }
> 
> If a page becomes hardware-poisoned before KSM scans it, shouldn't there be a
> PageHWPoison(page) or folio_has_hwpoisoned_page(folio) check before the read
> to prevent a fatal MCE?
> 
> 
> This is a pre-existing issue, but does migration risk panicking on poisoned
> memory?

Yes, lots of things risk panicking on poisoned memory.  It's never been
a priority for Linux.

> During page migration, pages are passed to __migrate_folio() which copies the
> contents without validation:
> 
> mm/migrate.c:__migrate_folio() {
>     ...
>     rc = folio_mc_copy(dst, src);
>     if (unlikely(rc))
>         return rc;
>     ...
> }
> 
> This executes the page copy in folio_mc_copy():
> 
> mm/util.c:folio_mc_copy() {
>     ...
>     if (copy_mc_highpage(folio_page(dst, i), folio_page(src, i)))
>         return -EHWPOISON;
>     ...
> }
> 
> On architectures lacking copy_mc support, this falls back to copy_highpage().
> Without a prior folio_has_hwpoisoned_page(src) check, could migrating a
> poisoned page via mbind() or move_pages() read poisoned memory and trigger a
> kernel panic?
> 
> 
> This is a pre-existing issue, but does kill_accessing_process() return the
> wrong error code when a task lacks an mm?
> 
> In memory failure handling, if the task is exiting or is a kernel thread,
> p->mm is NULL:
> 
> mm/memory-failure.c:kill_accessing_process() {
>     ...
>     if (!p->mm)
>         return -EFAULT;
>     ...
> }
> 
> Since the memory_failure() API protocol requires returning 0 for a successfully
> recovered state (no user signal needed), does returning -EFAULT cause the
> architecture MCE handler, such as kill_me_maybe(), to erroneously conclude
> recovery failed? Could this trigger unnecessary warnings and incorrectly
> attempt to force a SIGBUS on the dying task?

Dunno, and I'm done with side-quests.  Somebody else can decide if this
is a real problem that needs to be fixed.

