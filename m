Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB3CDD2F031
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 13:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18E5E6B0088; Tue, 27 Jan 2026 08:58:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1123C6B0089; Tue, 27 Jan 2026 08:58:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01DCA6B008A; Tue, 27 Jan 2026 08:58:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E71B66B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 08:58:48 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9FEEB1A014D
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:58:48 +0000 (UTC)
X-FDA: 84377899536.06.E059B84
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2AA941C0002
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:58:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KKzs1nK7;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769522327; a=rsa-sha256;
	cv=none;
	b=ARrkhBdauI1M5szLcCYkomVxdzskcHlWeU3wNjnwZBuwrCQDYBCT5/ZrjqhCeCPPJTtq5T
	KrWs9V8+JrhNWyxevQ6RBpVKwcy7WtwxiEcVfgcZH+uEH1lH8QRem9UDXgNprhhETSFWLv
	tBurr02pH30aBm4jero63tBSV8sLmng=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KKzs1nK7;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769522327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdnlZ37lmKmZVNr3z6aMCYrl4A2jHiwhyr3lXYvek2E=;
	b=JCgaoH8zgYJica6rjcGd35WXnbWTSa7FXedw2jY9zxgMjgcbG83q+qPr4pZiMAiUjZJm8A
	gXxfCg1sdhUaje/tcWo2borIQFHxqwqMY3LoxBqhpVivZ4h8nBMUI1OBaKpXROwqglFwfj
	beTG7XLD9kk/jq74j2ZgOPSqBStaRkE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kdnlZ37lmKmZVNr3z6aMCYrl4A2jHiwhyr3lXYvek2E=; b=KKzs1nK7CqxQ6Lu8ymAWaKEtRP
	wEq3oCMfpzb7+LRqUaJnsVtkkr3PwQ6g7FeZDECp6Zoqrs00SzriOJ893+QxxSyNXY9KSDykrXeUm
	qGGGDghmEL0KUmoykXPqPvlng3/8OrwDYMI+vw4vplrX3s+xMmPNHoLkOBUddll3I6XO7PO0YJU9J
	2tnbiQ//BSfvLb1yPcE1A29VWYDq/BQv1SO4ahwsKnxSOVhlIo2VhNm6LQOe6cTpFV/sb43+gcdob
	p33KcORvPtmaE7IZJKfAu3gz5qbMkSNhE52wVJuXPPnnEPXeeKRcDatyshuHFkLG/EJYmm8QBp9Lj
	bEuL+Lwg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkjaX-00000007WS2-3JcC;
	Tue, 27 Jan 2026 13:58:37 +0000
Date: Tue, 27 Jan 2026 13:58:37 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: boris.brezillon@collabora.com, loic.molinari@collabora.com,
	maarten.lankhorst@linux.intel.com, mripard@kernel.org,
	airlied@gmail.com, simona@ffwll.ch, frank.binns@imgtec.com,
	matt.coster@imgtec.com, dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/3] drm/gem-shmem: Map pages in mmap fault handler
Message-ID: <aXjEjaYsqo6oIsAl@casper.infradead.org>
References: <20260127132938.429288-1-tzimmermann@suse.de>
 <20260127132938.429288-2-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127132938.429288-2-tzimmermann@suse.de>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2AA941C0002
X-Stat-Signature: icauhyx66yw1mm5ioriqnw99bgudhnau
X-HE-Tag: 1769522325-953663
X-HE-Meta: U2FsdGVkX18uf1EHUqgagUOk/fiozIY4d7mRROjNFEkcUw6yn0Kzxr4/KUJUWDdAH75Ui7+EuYurXzxhJ6IOec3TvDgYJMvOp+kpA59KjWgbz4iF3kdeq5/jzD7WvMaStjMpI+21XCq9xq5RCGCJr8qnDFG48KrXla1PYBgAZk5jGjDdL/VraomXRMQz6lcUsVNNxuyndLY+hxfea8UJEoRamC6PUVLJzqvBlLtHnRhjLVTiSp1Ug0tcoYrxRMk+1FPObC2rUQOspyNpaCntVTqa/nVTozdkP4XvoT85X4iI8cjWG6Ci3fJ4JyMpms01XOAu3TtoQ//uPOFP2/BTZH054IoXaiedO9wIQ450p25DNCy+LFncjfpg49L6j2kvoFPB9HiZjc6tPAraO2CagR0nNNiY1NcPX8crz2hvwhjPjjqAOJ3OW95L8oqI/rTQDYlLUimxIz+t64rqpreV3n9e/+MceHd36rusJQSgw+4U1kUC4zsQBAm9dkuSmFMpXPEeAwUAteTVbOBRsAvpiF/Y0mQaj0fB5omfl8F4PbdVhdHGyQ8sD4rw1F/PB9nhKavfOxl38FldyVF+m2vb/s1rRg4onilBNgeTlkWyoVCtRPaTIxFuHYs80wRRL9eLPOdoYRlaCu3lEUYwW6svpgdkBIxm8Az4i0b/93k1z43KyTX14EdeNKKl3yRMy7aWNT8T35m5uw4tTDZ2EiEebEzQKp3/jC4r3Ea5IeIAYf/EGZCTo4EWVWoy/aattnKOK5MDBB8NwKpiVBsBbx9xV/kDiQgJAk78eJsgny3qG8ogjG6sxwh6jm+IOPFyMbStF/j4c1Lh/YklCLtSjnAnwWpVuisXSRpSyZhqBd9VoGT+kmwz9dgkS1ZZh5XmHU8sjLEOdBipcWoFkDJoFUWnU/xv28r+51Bp+lCH2n/UuHVbyzHF3RazkD176qyvHZbmjEooJFUPUQe/vK1NXWD
 MkjUbcAb
 kgnbw+F8xGGr7EmibjQ4SKAvl8aR3LT5ZH9HEeDTEi+KQwkj0SNS18VN9laeU+YH4VWD0mdoeim7+nxkZiVeVFhtwzXoCsIVEnEnMBMR1bM5lPowqGQFlHyEL5KjVbo7kXoBg0q7DzVZPU3A9pNLJrBunjKOB13vTzMgyVtTbQNePrsd2Rxp14LVUwxNuzfUw/ZK9XSAfobk4x2cAsNerufBm8gWfTtvMybcL3W+9h+U+vax/ZfsscU7pMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 02:16:36PM +0100, Thomas Zimmermann wrote:
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -553,17 +553,18 @@ EXPORT_SYMBOL_GPL(drm_gem_shmem_dumb_create);
>  static bool drm_gem_shmem_try_map_pmd(struct vm_fault *vmf, unsigned long addr,
>  				      struct page *page)
>  {
> -#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
> -	unsigned long pfn = page_to_pfn(page);
> -	unsigned long paddr = pfn << PAGE_SHIFT;
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	phys_addr_t paddr = page_to_phys(page);
>  	bool aligned = (addr & ~PMD_MASK) == (paddr & ~PMD_MASK);
>  
> -	if (aligned &&
> -	    pmd_none(*vmf->pmd) &&
> -	    folio_test_pmd_mappable(page_folio(page))) {
> -		pfn &= PMD_MASK >> PAGE_SHIFT;
> -		if (vmf_insert_pfn_pmd(vmf, pfn, false) == VM_FAULT_NOPAGE)
> -			return true;
> +	if (aligned && pmd_none(*vmf->pmd)) {
> +		struct folio *folio = page_folio(page);
> +
> +		if (folio_test_pmd_mappable(folio)) {
> +			/* Read-only mapping; split upon write fault */
> +			if (vmf_insert_folio_pmd(vmf, folio, false) == VM_FAULT_NOPAGE)
> +				return true;
> +		}
>  	}

It would feel more natural to me to have this function return vm_fault_t
instead of a bool.  What do you think?

> +	pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset within VMA */
> +	struct page *page = pages[page_offset];
> +	vm_fault_t ret;

[...]

> -	if (drm_gem_shmem_try_map_pmd(vmf, vmf->address, pages[page_offset])) {
> -		ret = VM_FAULT_NOPAGE;
> -		goto out;
> +	page = pages[page_offset];

Can page_offset have changed at this point?

> +	if (drm_gem_shmem_try_map_pmd(vmf, vmf->address, page)) {
> +		ret = VM_FAULT_NOPAGE;
> +	} else {
> +		struct folio *folio = page_folio(page);
> +
> +		get_page(page);

folio_get(folio);

> -	vm_flags_set(vma, VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
> +	vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP, VM_PFNMAP);

Just so you know, this is going to change observable behaviour, maybe
in a good way.  For example, we'll now be able to do O_DIRECT I/O to
this range and ptrace accesses.  I think everything will be fine, but
VM_PFNMAP does prohibit some things which are now allowed.

