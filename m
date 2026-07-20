Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C541C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:35:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CC4B6B0088; Mon, 20 Jul 2026 08:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47D556B008A; Mon, 20 Jul 2026 08:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3940F6B008C; Mon, 20 Jul 2026 08:35:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B7436B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:35:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8721D120177
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:35:22 +0000 (UTC)
X-FDA: 85009100484.09.D0AFB87
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id 39546120007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:35:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BHmMBDG0;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784550921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7P6FSrJnctHNX6YaWSkPu2oDA9U5IPJvuGGW2Jl2di4=;
	b=r9WCDhBaNghbl85zfVxQVGXb+e7RUOZjpbxA5ndyQKmb7tnuP7g/Qo+wxOZY+KJuHBTEAa
	Gp7E3QlPBW3oSe17Kb6qmlaauCthU8MF6ra+5cG3qlQbmPSmVakCToXkX7ZR5kG+SQPbA2
	SZwyIXqKvGrV3XFUYpbWn+I7ivZwSRo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BHmMBDG0;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784550921;
	b=14tQQGFkQwk11R9BJ/xBxSVUdMt3y/Hepqod3cEnDFkvBlQ9OZRhY4cDihT97QHuTorJL3
	ABaZ4vaCwr4EsTcaHaBRmkDYQN2Sht8xm1xiZ/yVS1tRvs15W44kF+MuRc9eiDBi27bgVq
	4oOOvO4oqXlDnwb1Dy7PaZ3URaBz2ww=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784550918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7P6FSrJnctHNX6YaWSkPu2oDA9U5IPJvuGGW2Jl2di4=;
	b=BHmMBDG0ofSXSJZ/mc8RStgaP1ISNssG2tFAsnYucOgi2KOAeWAFQSG+AoowhJj73/oC//
	1j3eZ1ltEtZeJuJ7Boh/Uqcl2ro+d9+1t22RahDENh9++XWd5AnjrKaUVAC+DrMEfNEdfS
	tUS+tOBYMEwMkP6fO4ksTYwKjKfkVlo=
From: Usama Arif <usama.arif@linux.dev>
To: Rik van Riel <riel@surriel.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	kernel-team@meta.com,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH RFC v3 4/6] mm/gup: add get_user_page_vma() to fault in a page under a held lock
Date: Mon, 20 Jul 2026 05:35:04 -0700
Message-ID: <20260720123505.1234897-1-usama.arif@linux.dev>
In-Reply-To: <20260717170036.743149-5-riel@surriel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 39546120007
X-Stat-Signature: ceshydg8ij7iry8uzy79opgr3bt5jc8j
X-HE-Tag: 1784550920-844354
X-HE-Meta: U2FsdGVkX19K+MXxxOPUfhr0ZBkYrsK0Cf7gfXhDuUAnhYB1oVcDeWa3D1bPO1BGKxHtl26YWBQJT779npQuimh6NhyFqRG0NRTjmaVsi2T4f7OUt214C4gNlGNdhwh5amYMP0f87J6n1ZQhFbJbVr2q4tT99Tzp7C3djnEhoQqmiINeKUYPlvCuNbCcShEJhDijRH+KTdObclTbHcEXHoweYGbT9VjQAokXCMzI444/THjUbYodgV7njatlCQlXhmwpWFv9VW8AW0tHwXiXFTgkIVBzV+LqWcewkLf1xuPQrz1VP6qAObSaEiMolnZ3xkGMJByaS61Cj9pGyeFavrZut3xJrCzCEAGogFJAVkQrL1Tqal8iLC8YfyFf18Li3dAaRs7cZjMPDDo2hM4ZT2D+tlh7l5wM/v0owPGON9w7uSHkj/KmZ41KAY8FgYgg6wKGRaoNodMcnJdH3fvFH/jPJKg9AHBaSCumrLufpSxUYj5HTNhatA8JMs1kaVdhw7KaDV+GskLQ+dHEYZFtA4oP1Tpxn66lo/7wAtqvZwi3yj3VFX5mxII+e1zuwzZGRLQoqP3o3CIxucqW852kqecuGUsoikC9M2fNLOGFYeTbkwK+7ep3C2mTtbxegahy3gmd1ZP57OiJ4GLRBVl6FapmYDr9Tl6aVu9QECTnRTLk/vz2ytCnzNnJ06Unxj0ghGE4+ESVFkhGsEi7ZMDEH9T4O+o8KCSMoNhYDW+AHLeWSYU+hsW2MGyQOIS8AcHYGwKUZNSjmd6rcvHkJeGETAY1Wn/qacpmvURmASAJT+JZExazGOE0AwxCnbkWJSzCx+dcMSkQzec5Gf2iDui3oJ3oetzs3ZlJeKh+FGvPXZdfZnVNySXMRKygKn82RK20D4ARQdbBMKtO+BCKBVyfeqM+ed412urpcdle1MdYOd3Vpm3/IHosHhG1MyIzNfAnSbSPbOQHKjFyYPefHHV
 qU3Nk/dX
 T/h9VZFuBe/VcAGKyg2e5/ESaXHAXfyIiloT1wx6RV3iWaaj+S6BZL/f75wdikvWRPqXzet9x+7h4BAWQaNOTOHZeQAYjzm81AeKn+2qztRVZDDwGVxowdcJfF/G/mYrRdPI21+Jhz1co4bcPY6tTz8oteAOtrYSegt5MdMGNXS/dDKg7DuGJPncQr6vdTlN3/NBSFi+l53DWTFekF9MBc7E0vT/06VEy5kjtOHwd3QTzKeHetfEuAexOr1cNgC+9lf+bSLFmv680lWZKgQEANhaUh5uba90ehQkK8D3T3a1Xlyp0R2P/foDxkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Jul 2026 13:00:34 -0400 Rik van Riel <riel@surriel.com> wrote:

> __access_remote_vm() needs a single page from a VMA it has already
> looked up and locked, faulting it in when necessary, under either the
> mmap lock or the per-VMA lock. get_user_pages_remote() does not fit: it
> hard codes the mmap lock and re-looks-up the VMA, neither of which is
> wanted here.
> 
> Add get_user_page_vma(), a simplified __get_user_pages() that walks the
> page tables with follow_page_mask(), faults a missing page in with
> faultin_page(), and on success returns it with a reference and the
> caller's lock still held. Like __get_user_pages() it runs
> check_vma_flags(), so callers need not pre-check the VMA.
> 
> A VM_IO/VM_PFNMAP VMA is the exception to that check: it can still hold
> COWed pages that have a struct page, so follow_page_mask() is allowed to
> look for one. Memory with no struct page -- a raw PFN, or a present PFN
> reported as -EEXIST -- is returned as -EFAULT, so the caller can reach it
> through vma->vm_ops->access().
> 
> The caller sets FOLL_VMA_LOCK when it holds the per-VMA lock rather than
> the mmap lock, which reaches the fault code as FAULT_FLAG_VMA_LOCK.
> 
> Anything that cannot complete under the per-VMA lock -- a dropped fault,
> a userfaultfd VMA (uffd assumes current is the faulting task), a hard
> error, or ->access() memory -- releases the lock and returns -EAGAIN,
> so the caller retries under the mmap lock.
> 
> faultin_page() reports these retries as -EAGAIN for both lock types;
> only the mmap caller records the dropped lock in *locked. A
> VM_FAULT_ERROR that decodes to no errno warns and returns -EFAULT
> rather than BUG(), since the mmap-lock retry produces the definitive
> result.
> 
> Assisted-by: Claude:claude-opus-4.8
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
>  mm/gup.c      | 154 +++++++++++++++++++++++++++++++++++++++++++-------
>  mm/internal.h |   6 +-
>  2 files changed, 139 insertions(+), 21 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 0692119b7904..69b834a71708 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1082,7 +1082,13 @@ static int get_gate_page(struct mm_struct *mm, unsigned long address,
>  /*
>   * mmap_lock must be held on entry.  If @flags has FOLL_UNLOCKABLE but not

Does the above line also need to be changed? mmap_lock is not held on entry in
faultin_page() if passing FOLL_VMA_LOCK, right?

>   * FOLL_NOWAIT, the mmap_lock may be released.  If it is, *@locked will be set
> - * to 0 and -EBUSY returned.
> + * to 0 and -EAGAIN returned.
> + *
> + * The return value does not depend on the lock type: a fault that made
> + * progress but needs a retry (VM_FAULT_RETRY / VM_FAULT_COMPLETED) is reported
> + * as -EAGAIN for both the mmap lock and the per-VMA lock (FOLL_VMA_LOCK). Only
> + * the *@locked side effect is lock-type specific, as the per-VMA lock path has
> + * no unlockable mmap_lock to drop.
>   */
>  static int faultin_page(struct vm_area_struct *vma,
>  		unsigned long address, unsigned int flags, bool unshare,
> @@ -1097,6 +1103,8 @@ static int faultin_page(struct vm_area_struct *vma,
>  		fault_flags |= FAULT_FLAG_WRITE;
>  	if (flags & FOLL_REMOTE)
>  		fault_flags |= FAULT_FLAG_REMOTE;
> +	if (flags & FOLL_VMA_LOCK)
> +		fault_flags |= FAULT_FLAG_VMA_LOCK;
>  	if (flags & FOLL_UNLOCKABLE) {
>  		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
>  		/*
> @@ -1125,41 +1133,147 @@ static int faultin_page(struct vm_area_struct *vma,
>  
>  	ret = handle_mm_fault(vma, address, fault_flags, NULL);
>  
> +	/*
> +	 * A fully completed fault (VM_FAULT_COMPLETED) or one that needs a retry
> +	 * (VM_FAULT_RETRY) has released the lock it was holding. Report both as
> +	 * -EAGAIN so the caller retries: the mmap lock caller retakes it here,
> +	 * the per-VMA lock caller (FOLL_VMA_LOCK) falls back to the mmap lock.
> +	 *
> +	 * Dropping the mmap lock is recorded in *@locked. There is no such lock
> +	 * to drop under the per-VMA lock, where @locked is not used, so leave it
> +	 * alone in that case.
> +	 */
>  	if (ret & VM_FAULT_COMPLETED) {
> -		/*
> -		 * With FAULT_FLAG_RETRY_NOWAIT we'll never release the
> -		 * mmap lock in the page fault handler. Sanity check this.
> -		 */
> -		WARN_ON_ONCE(fault_flags & FAULT_FLAG_RETRY_NOWAIT);
> -		*locked = 0;
> -
> -		/*
> -		 * We should do the same as VM_FAULT_RETRY, but let's not
> -		 * return -EBUSY since that's not reflecting the reality of
> -		 * what has happened - we've just fully completed a page
> -		 * fault, with the mmap lock released.  Use -EAGAIN to show
> -		 * that we want to take the mmap lock _again_.
> -		 */
> +		if (!(flags & FOLL_VMA_LOCK)) {
> +			/*
> +			 * With FAULT_FLAG_RETRY_NOWAIT we'll never release the
> +			 * mmap lock in the page fault handler. Sanity check this.
> +			 */
> +			WARN_ON_ONCE(fault_flags & FAULT_FLAG_RETRY_NOWAIT);
> +			*locked = 0;
> +		}
>  		return -EAGAIN;
>  	}
>  
>  	if (ret & VM_FAULT_ERROR) {
>  		int err = vm_fault_to_errno(ret, flags);
>  
> -		if (err)
> -			return err;
> -		BUG();
> +		/*
> +		 * VM_FAULT_ERROR always decodes to an errno; a zero here would
> +		 * mean handle_mm_fault() returned an unexpected combination.
> +		 * Report -EFAULT rather than crash: under the per-VMA lock the
> +		 * mmap lock retry produces the definitive result.
> +		 */
> +		VM_WARN_ON_ONCE(!err);
> +		return err ? err : -EFAULT;
>  	}
>  
>  	if (ret & VM_FAULT_RETRY) {
> -		if (!(fault_flags & FAULT_FLAG_RETRY_NOWAIT))
> +		if (!(flags & FOLL_VMA_LOCK) &&
> +		    !(fault_flags & FAULT_FLAG_RETRY_NOWAIT))
>  			*locked = 0;
> -		return -EBUSY;
> +		return -EAGAIN;
>  	}
>  
>  	return 0;
>  }
>  
> +/*
> + * get_user_page_vma - get one page from @vma, whose lock the caller already
> + * holds: the mmap lock, or (with FOLL_VMA_LOCK) the per-VMA lock. Walks the
> + * page tables, faulting the page in if needed, and on success returns it with
> + * a reference and the lock still held.
> + *
> + * Runs check_vma_flags() like __get_user_pages(), so callers need not pre-check
> + * the VMA; most rejections are returned as their error. A VM_IO/VM_PFNMAP VMA
> + * is the exception: a COWed page with a struct page is returned, while a raw
> + * PFN has none and yields -EFAULT, to be reached via vma->vm_ops->access().
> + *
> + * Under FOLL_VMA_LOCK, anything that cannot be finished under the per-VMA lock
> + * (a dropped fault, userfaultfd, a hard error, or ->access() memory) releases
> + * the lock and returns -EAGAIN, so the caller retries under the mmap lock.
> + */
> +struct page *get_user_page_vma(struct vm_area_struct *vma, unsigned long addr,
> +			       unsigned int gup_flags)
> +{
> +	bool vma_locked = gup_flags & FOLL_VMA_LOCK;
> +	unsigned long page_mask;
> +	struct page *page;
> +	int locked = 1;
> +	bool pfnmap;
> +	int ret;
> +
> +	/*
> +	 * Validate the VMA up front, like __get_user_pages(). A VM_IO/VM_PFNMAP
> +	 * VMA is not rejected outright: it can hold COWed pages that have a
> +	 * struct page, so let follow_page_mask() look for one, and treat only
> +	 * its struct-page-less PFNs as unreachable. Any other rejection
> +	 * (secretmem, bad permissions, ...) is final.
> +	 */
> +	ret = check_vma_flags(vma, gup_flags);
> +	if (ret && !(vma->vm_flags & (VM_IO | VM_PFNMAP)))

Do you need to somehow restructure check_vma_flags()?

The first thing that check_vma_flags() does is:

	if (vm_flags & (VM_IO | VM_PFNMAP))
		return -EFAULT;

check_vma_flags() returns before evaluating VM_READ,
FOLL_FORCE, FOLL_ANON or the architecture permission check.

The code then ignores that early error and may return a COWed
page through follow_page_mask(). A non-FOLL_FORCE caller
can therefore read a COWed page from a PROT_NONE PFNMAP VMA.

> +		goto fail;
> +	pfnmap = ret;
> +
> +	for (;;) {
> +		if (fatal_signal_pending(current)) {
> +			ret = -EINTR;
> +			goto fail;
> +		}
> +		cond_resched();
> +
> +		page = follow_page_mask(vma, addr,
> +					gup_flags | FOLL_TOUCH | FOLL_GET,
> +					&page_mask);
> +		if (!IS_ERR_OR_NULL(page))
> +			return page;

__get_user_pages() does

	flush_anon_page(vma, subpage, start + j * PAGE_SIZE);
	flush_dcache_page(subpage);

before returning the page. Do you need to that here as well above?

> +
> +		/*
> +		 * No struct page: a raw PFN of a VM_IO/VM_PFNMAP VMA, whether
> +		 * seen by the up-front check (@pfnmap) or reported as -EEXIST
> +		 * for a present PFN. Return -EFAULT so the caller reaches it
> +		 * through vma->vm_ops->access().
> +		 */
> +		if (pfnmap || PTR_ERR(page) == -EEXIST) {
> +			ret = -EFAULT;
> +			goto fail;
> +		}
> +		/* A hard error from the walk itself. */
> +		if (page && PTR_ERR(page) != -EMLINK) {
> +			ret = PTR_ERR(page);
> +			goto fail;
> +		}
> +
> +		/*
> +		 * The page is not present, or needs unsharing. A remote fault
> +		 * under the per-VMA lock cannot deliver userfaultfd (which
> +		 * assumes current is the faulting task), so fall back for those.
> +		 */
> +		if (vma_locked && userfaultfd_armed(vma)) {
> +			ret = -EAGAIN;
> +			goto fail;
> +		}
> +		ret = faultin_page(vma, addr, gup_flags | FOLL_REMOTE | FOLL_GET,
> +				   PTR_ERR(page) == -EMLINK, &locked);
> +		if (ret == -EAGAIN)
> +			return ERR_PTR(-EAGAIN);	/* fault released the per-VMA lock */
> +		if (ret)
> +			goto fail;
> +	}
> +
> +fail:
> +	/*
> +	 * Under the per-VMA lock the caller cannot reach ->access() or act on a
> +	 * hard error (both need the mmap lock), so release the lock and have it
> +	 * retry there; the mmap-lock pass produces the definitive error.
> +	 */
> +	if (vma_locked) {
> +		vma_end_read(vma);
> +		return ERR_PTR(-EAGAIN);
> +	}
> +	return ERR_PTR(ret);
> +}
> +
>  /*
>   * Writing to file-backed mappings which require folio dirty tracking using GUP
>   * is a fundamentally broken operation, as kernel write access to GUP mappings
> diff --git a/mm/internal.h b/mm/internal.h
> index 181e79f1d6a2..0899a37907c1 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1595,6 +1595,8 @@ struct vm_struct *__get_vm_area_node(unsigned long size,
>   */
>  int __must_check try_grab_folio(struct folio *folio, int refs,
>  				unsigned int flags);
> +struct page *get_user_page_vma(struct vm_area_struct *vma, unsigned long addr,
> +			       unsigned int gup_flags);
>  
>  /*
>   * mm/huge_memory.c
> @@ -1641,11 +1643,13 @@ enum {
>  	FOLL_UNLOCKABLE = 1 << 21,
>  	/* VMA lookup+checks compatible with MADV_POPULATE_(READ|WRITE) */
>  	FOLL_MADV_POPULATE = 1 << 22,
> +	/* caller holds the per-VMA lock, not the mmap lock */
> +	FOLL_VMA_LOCK = 1 << 23,
>  };
>  
>  #define INTERNAL_GUP_FLAGS (FOLL_TOUCH | FOLL_TRIED | FOLL_REMOTE | FOLL_PIN | \
>  			    FOLL_FAST_ONLY | FOLL_UNLOCKABLE | \
> -			    FOLL_MADV_POPULATE)
> +			    FOLL_MADV_POPULATE | FOLL_VMA_LOCK)
>  
>  /*
>   * Indicates for which pages that are write-protected in the page table,
> -- 
> 2.53.0-Meta
> 
> 

