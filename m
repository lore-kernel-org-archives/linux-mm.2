Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD56ECA5FA5
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 05:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A7296B0088; Thu,  1 Oct 2026 01:19:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 858F36B008A; Thu,  1 Oct 2026 01:19:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76F246B008C; Thu,  1 Oct 2026 01:19:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E0EA6B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 01:19:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 33C751A02DC
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 05:19:56 +0000 (UTC)
X-FDA: 85272905592.23.34B02F4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 21E4F20004
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 05:19:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=P40KV9dD;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790831994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hkT9L937VAi52o0juv8wPugu/7r2luzcqgob2DMEdj0=;
	b=u0tx4ZMCmhjcl2sxanUWEYljdRDNlDR4dBkbMqwcYafvsvrOw+Qni4PXHgKCIq8946oytH
	qqKvVBauuqLV4Le2KYGv5JSuFx/ief0JZw+dg//XTgnkf800rXbtnd0eDiAiQtSoW/ygl+
	FmxTDVSRTcICGViKx9haeHJ/uhuoXA0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=P40KV9dD;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790831994;
	b=q/1+kL1gbnixKe+TAvHVMuzjMTE20GCR+/DOSqMTpZF2/XBsaNto6AybdlGL+ae+0PFxnC
	YqLwzt3h4awZUjlkoNNFIRRr97lKyv1Zo0+YmoDe9irLErB1p+MFgKbLrv/6jvF7hvUlxW
	Br57gMJ5pmN8BC103HLhWFNkBiXpPGc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F690497;
	Wed, 30 Sep 2026 22:19:49 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3F4F23F763;
	Wed, 30 Sep 2026 22:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790831993; bh=bMfDoIT+TbfeJqCCR5qMy8XKQZHNg7cp5zQagKUX0HA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P40KV9dDBU4ztgULAau0o/rzI9PV37m4Z30GHUE/b5MMptX1fvV0ZnkFOnc1fjwSR
	 GEnJ3BLpudy4ZH4jayibKeT0FdThHUA1e6xBDGMiz6oK8tv43ZhyctBHnU8kq11k/h
	 nYhAYVABJvH61JkCUzMVvHI+iJ1SI2QoFyDD9lbU=
Date: Thu, 1 Oct 2026 10:49:49 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH] mm/memory: remove unused vmf_insert_mixed_mkwrite()
Message-ID: <nwwd35ikeinmyl5eug3eoon6h34eo7danw4pdq7htikzbgpmd5@4encqsdqicxd>
References: <20260929143707.450805-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929143707.450805-1-ekffu200098@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 21E4F20004
X-Stat-Signature: hyec3dhn1nwrayubwjqi9chsbkpa8kf5
X-Rspam-User: 
X-HE-Tag: 1790831993-227378
X-HE-Meta: U2FsdGVkX1/gxWB8uU6UfPk+qYUam4EAaAO5EdOF4kNU24xO6gIfS++oBy3YGcwhVroXafdqP4UULRBRYIGl6E8pIsfPHioc+kCSZZSae6BlLkneQvTyissBoyDIWgSGbY14pVoxqJhiBSHK0FTwmELA/Jtez1WxpgAjP/EgXI7I5dmoQr1P9/s3BiyBfAAxoJsoifbumhl+xXiZKITlZRQ+AUdWjqTIFvJLD8TKYnzYHCjEI9pQ07occxtpWihjr0A0JqERFM1gjM+fZqvIXVwiqBaZhBrUJ81hRA/LKn/mp2wHWnXcqFZt+tDyZu1W/RVSWsWNXuBqB2e+JzTLZ8FJ7Y/seiJ4Ct8AI+6c/4UPLktc1vB7t7Hyp7bVnU8MtKMoxe1Ayk1fQ8fbE1PL8pdtfyZuCvrqHmpYnQs+GDovqPzqdd/Uet5ghb1qtMj44u3K8ipiCAHQtqZvsHxg3s8BCvsk9XYSASd+qV0uq7ojz46e4Qq4IeoJGl+busp9z77mi8GDShx/oHEQHdA003alFVi0qJZZ4kWtDZPT/g2wE+waYOOLOHnbQPhRB/gzREoiKArSDY6quQBNRJpTzpMLgNGe8ZpEsKHCab8V/bCuulUtiIipREO2EwuDed3OIkLypZIELa/bH5e/rRTy72H5zIchUhOKZUN03K5bDwg9guTetG/QpbEuUjQkFEbJWVOlFTixhY8a5gi/wyXD88fx031dn0i7KRFZFq+x72p+V6uMlSUa7pZH+kTo5kCKBLcVPCAov8U6gxq4rSNeORTHQ2eZiDWwLD110xGR3U57LJMFSaVaq68SiHqLX/Rd1mPJBY0ZrwGjP8/ZmYlXRsCFJou0/rakO1j8ITc/2BJFOK5n9DSAJrjX67lk1IW/A+U/9t3GL3n/W795zCAoxbuVK+rP9198O5pnUgvu34jwvZxMngiS1WosvsutbbSiro8A+FIN9oYMc+7R9UY
 P+m96ZVT
 eK5OfjchK5j+T45bFVDjnygqlM9Of6aXy75whfcyZtWTqSal1vTRrqiEAvhhYZC6xdibZG5kSs/aKOnm4OwjWe/jLJTPC/bD6P2AT0TpiHQJfG2POL9ygfFf3yXLJP0GQfejrPj0B9gEQIdm/h9B7hS37PJjGWoj1NSR6HsEcZaPI1qmSQC/OjLY/dgS7+47RMMjkorJ/iysAmtBef+VZY8d79kCjghd3BNAA5aTdsDx+EGc/f+5TekmY7CWz5Y4nCoPsliP9x6cnquC7x5vA3bWZ+Mqqxkeo4y4cIyWVp/wk3G0wgWuo2YTCZc8d7wpSJSamD+gXvknMFEYU36vH7zOFbyndsN1TKFv7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 11:37:06PM +0900, Sang-Heon Jeon wrote:
> Since commit 38607c62b34b ("fs/dax: properly refcount fs dax pages"),
> vmf_insert_mixed_mkwrite() has no callers, so the mkwrite argument of
> __vm_insert_mixed() and insert_pfn() is always false.
> 
> So remove the function, the mkwrite argument and the unreachable
> mkwrite branches. Also merge __vm_insert_mixed() into vmf_insert_mixed().
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

This patch is doing multiple independent changes and should be split IMHO

1. mm: Drop vmf_insert_mixed_mkwrite()
	- No users after 38607c62b34b ("fs/dax: properly refcount fs dax pages")
	- Unreachable function and should be dropped

3. mm: Drop mkwrite argument from __vm_insert_mixed()
	- With vmf_insert_mixed_mkwrite() dropped
		- mkwrite is always false in __vm_insert_mixed()
			- mkwrite is always false in insert_pfn()
			+ mkwrite is always false in vm_mixed_ok()
	- Drop mkwrite from __vm_insert_mixed(), insert_pfn() and vm_mixed_ok()
	- Drop mkwrite based conditional handling
	- Rename __vm_insert_mixed() as vm_insert_mixed()

The above improves the clarity/readability making it easier to review.

> ---
>  include/linux/mm.h |  2 --
>  mm/memory.c        | 76 ++++++++++++----------------------------------
>  2 files changed, 19 insertions(+), 59 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index c038d06825c3..2ac734efd4ec 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -5008,8 +5008,6 @@ vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
>  			unsigned long pfn, pgprot_t pgprot);
>  vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
>  			unsigned long pfn);
> -vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
> -		unsigned long addr, unsigned long pfn);
>  int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
>  
>  static inline vm_fault_t vmf_insert_page(struct vm_area_struct *vma,
> diff --git a/mm/memory.c b/mm/memory.c
> index 330cde31bf8b..1f83a26f8733 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2453,7 +2453,14 @@ static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
>  		if (!mkwrite)
>  			return -EBUSY;
>  
> -		/* see insert_pfn(). */
> +		/*
> +		 * For read faults on private mappings the PFN passed in may
> +		 * not match the PFN we have mapped if the mapped PFN is a
> +		 * writeable COW page.  In the mkwrite case we are creating a
> +		 * writable PTE for a shared mapping and we expect the PFNs to
> +		 * match. If they don't match, we are likely racing with block
> +		 * allocation and mapping invalidation.
> +		 */
>  		if (pte_pfn(pteval) != page_to_pfn(page)) {
>  			WARN_ON_ONCE(!is_zero_pfn(pte_pfn(pteval)));
>  			return -EFAULT;
> @@ -2858,7 +2865,7 @@ int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
>  EXPORT_SYMBOL(vm_map_pages_zero);
>  
>  static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
> -			unsigned long pfn, pgprot_t prot, bool mkwrite)
> +			unsigned long pfn, pgprot_t prot)
>  {
>  	struct mm_struct *mm = vma->vm_mm;
>  	pte_t *pte, entry;
> @@ -2868,38 +2875,12 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>  	if (!pte)
>  		return VM_FAULT_OOM;
>  	entry = ptep_get(pte);
> -	if (!pte_none(entry)) {
> -		if (mkwrite) {
> -			/*
> -			 * For read faults on private mappings the PFN passed
> -			 * in may not match the PFN we have mapped if the
> -			 * mapped PFN is a writeable COW page.  In the mkwrite
> -			 * case we are creating a writable PTE for a shared
> -			 * mapping and we expect the PFNs to match. If they
> -			 * don't match, we are likely racing with block
> -			 * allocation and mapping invalidation so just skip the
> -			 * update.
> -			 */
> -			if (pte_pfn(entry) != pfn) {
> -				WARN_ON_ONCE(!is_zero_pfn(pte_pfn(entry)));
> -				goto out_unlock;
> -			}
> -			entry = pte_mkyoung(entry);
> -			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
> -			if (ptep_set_access_flags(vma, addr, pte, entry, 1))
> -				update_mmu_cache(vma, addr, pte);
> -		}
> +	if (!pte_none(entry))
>  		goto out_unlock;
> -	}
>  
>  	/* Ok, finally just insert the thing.. */
>  	entry = pte_mkspecial(pfn_pte(pfn, prot));
>  
> -	if (mkwrite) {
> -		entry = pte_mkyoung(entry);
> -		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
> -	}
> -
>  	set_pte_at(mm, addr, pte, entry);
>  	update_mmu_cache(vma, addr, pte); /* XXX: why not for insert_page? */
>  
> @@ -2967,7 +2948,7 @@ vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
>  
>  	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
>  
> -	return insert_pfn(vma, addr, pfn, pgprot, false);
> +	return insert_pfn(vma, addr, pfn, pgprot);
>  }
>  EXPORT_SYMBOL(vmf_insert_pfn_prot);
>  
> @@ -2998,11 +2979,9 @@ vm_fault_t vmf_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>  }
>  EXPORT_SYMBOL(vmf_insert_pfn);
>  
> -static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn,
> -			bool mkwrite)
> +static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn)
>  {
> -	if (unlikely(is_zero_pfn(pfn)) &&
> -	    (mkwrite || !vm_mixed_zeropage_allowed(vma)))
> +	if (unlikely(is_zero_pfn(pfn)) && !vm_mixed_zeropage_allowed(vma))
>  		return false;
>  	/* these checks mirror the abort conditions in vm_normal_page */
>  	if (vma->vm_flags & VM_MIXEDMAP)
> @@ -3012,13 +2991,13 @@ static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn,
>  	return false;
>  }
>  
> -static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
> -		unsigned long addr, unsigned long pfn, bool mkwrite)
> +vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
> +		unsigned long pfn)
>  {
>  	pgprot_t pgprot = vma->vm_page_prot;
>  	int err;
>  
> -	if (!vm_mixed_ok(vma, pfn, mkwrite))
> +	if (!vm_mixed_ok(vma, pfn))
>  		return VM_FAULT_SIGBUS;
>  
>  	if (addr < vma->vm_start || addr >= vma->vm_end)
> @@ -3045,9 +3024,9 @@ static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
>  		 * result in pfn_t_has_page() == false.
>  		 */
>  		page = pfn_to_page(pfn);
> -		err = insert_page(vma, addr, page, pgprot, mkwrite);
> +		err = insert_page(vma, addr, page, pgprot, false);
>  	} else {
> -		return insert_pfn(vma, addr, pfn, pgprot, mkwrite);
> +		return insert_pfn(vma, addr, pfn, pgprot);
>  	}
>  
>  	if (err == -ENOMEM)
> @@ -3057,6 +3036,7 @@ static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
>  
>  	return VM_FAULT_NOPAGE;
>  }
> +EXPORT_SYMBOL(vmf_insert_mixed);
>  
>  vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *page,
>  			bool write)
> @@ -3078,24 +3058,6 @@ vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *page,
>  }
>  EXPORT_SYMBOL_GPL(vmf_insert_page_mkwrite);
>  
> -vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
> -		unsigned long pfn)
> -{
> -	return __vm_insert_mixed(vma, addr, pfn, false);
> -}
> -EXPORT_SYMBOL(vmf_insert_mixed);
> -
> -/*
> - *  If the insertion of PTE failed because someone else already added a
> - *  different entry in the mean time, we treat that as success as we assume
> - *  the same entry was actually inserted.
> - */
> -vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
> -		unsigned long addr, unsigned long pfn)
> -{
> -	return __vm_insert_mixed(vma, addr, pfn, true);
> -}
> -
>  /*
>   * maps a range of physical memory into the requested pages. the old
>   * mappings are removed. any references to nonexistent pages results
> 
> base-commit: 1c2b8d2725f84b43fabe3b3e9628c91db8ca6c65
> -- 
> 2.43.0
> 
> 

