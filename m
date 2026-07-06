Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5E8AC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 12:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7203A6B00A0; Mon,  6 Jul 2026 08:57:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F8306B00A1; Mon,  6 Jul 2026 08:57:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60DCA6B00B9; Mon,  6 Jul 2026 08:57:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24C476B00A0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:57:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9BB13168A1A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:57:37 +0000 (UTC)
X-FDA: 84958353354.17.DAF1BC7
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8A16F160005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:57:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H88q5VQK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783342655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OjFikUNuPI2n8ZZt1QEzOtihOqsefSty5HS8pTICopI=;
	b=pE/atdr4EHDReCE4HvyFBBfv/FGAQu6POq+DqVb77s7CvzmFaqjRpWCe3Ls38FXw3uD/lf
	Snao0Mnhkdgmpfij5hbxRcPDXElmCDzTlVnU6A1oI58+sEWI3nVydqeTq9l+0dy7eM1GoF
	ahv9IgtEpiYaQeog9WGYRxmN37YYJds=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H88q5VQK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783342655;
	b=jPGcxGj6UcrB0IVIBP1lhb/ONjOsTYItAaxX9zuG2Y7MJolfQDQTAt4CrpCJSyF7RW+6fz
	x7xurdrCgc0ylzxfREoktry1hxn1hF/yVMnloBylIvmbcaBC/qVoYnWJmZ9grxSw/r5Snr
	I0fdZ3kkcy6XW7Mx58S+aDcF75BWu/s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783342653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OjFikUNuPI2n8ZZt1QEzOtihOqsefSty5HS8pTICopI=;
	b=H88q5VQK6NqQgGY3kEsq1eEr14cqrv/6DD2eN3V5JsHcJspPjquBfXAw5Apj1brCu0T6wy
	ggVGuWusnd40U5BETbluOBlNVEtJVnFGQ4ZemBxgd/CrNi0jDnqYDbL5WF7vDrIcRH2SjL
	GLoQoj2mjEjKEJdcGAEY+2srcf+xoXs=
From: Usama Arif <usama.arif@linux.dev>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Usama Arif <usama.arif@linux.dev>,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org,
	ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	kas@kernel.org
Subject: Re: [PATCH v9 11/15] mm/pagemap: add PAGE_IS_ACCESSED for RWP tracking
Date: Mon,  6 Jul 2026 05:57:24 -0700
Message-ID: <20260706125726.729431-1-usama.arif@linux.dev>
In-Reply-To: <20260706084805.8400-12-kirill@shutemov.name>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8A16F160005
X-Stat-Signature: p1oyidzyer57n6egfh7nsagx9puto3j9
X-Rspam-User: 
X-HE-Tag: 1783342655-329175
X-HE-Meta: U2FsdGVkX18QXOZeREDUDml+zCp1ZqfbeyOT2eaUcrZKbunC1RU6gM3A98+jbNgD7Fro94S/ZhSucDBBcJNRO+2m7yGY4UZ6CGNvCE8O0bQdqDbvUccGaybt6y8UcBcN4bhA6CDNkgb3yeOIJscpce9tlQ3qQyuKz1BOajQKXb1vFC+DOdB54+aq78iHSKUqtJIfmHkNmjGjFojXShugs6AM6ZkvIorTs7k4T27uTU3SqZn4LGnxRvRdSLCSOh+8gn2dK66hafpUNwtwq5wiexcIPfORgFr5GF5VoKkJ15jVIV9ahuaFJXVMAwhRO3YvmcW0bhu0H6TC0aNn55BeS28a8f8KEU3dyhsicgC4QPmPtALQkpWbM8qH0anzO10H1ZkhpnrEm96ZFpfxqKWg22uy7ATl7i8weY08JDbDXuMgY2lMVb72jc9EV6K37nEF7QX+AOzK5eUc0BgA/zeyC0dNVFT42IfCWCDHrGbVRps+554gH8XQwzsTGZRlPZNsDJo2NfaxVioJK2ualQBl6/nNAn5OFaovo12uZGlZOI+eluGrFZnxRPLWsrHUaMsRF3VV7UBmjJA50/7IeU5DS5RmJrUnfSMFvfamAyoxXdynbQ+Rh0Rn442HTGBgd60VjibZ0UGz0I0WpKobyE3cPhDfBrUAgN7v+W8hmlQEaQlifASl/VRhFOUkYxsKJY8Fsxn5Q6kp7q4rHg5iyUuKiruGZA+RJ0minYKkqRovhSmutI/o4g4Zsp1PMKq75b7d7uODn6wmc7VWSE1Voe+ETGM4uIDzxFd0y6IZgxV7Hbklu2cu7AR4W1HSktAUXrb1A5/aleCaSQroADiHG6P1DKG8IBq9tjMGp+0PiOaonnkhLkt4sZ3MlMu0IDzehI407D+RdntU3kb0WVtOvR9FWLbP/0itbDOWI7v0UqEDLl1d2b0NoCRUX82a9lI3ddDQ0Ny7Iaypw27bCZezFAO
 6jbLjqgA
 2Fe2uiHfDI1BWCzVtVE52UDDq5PAO4WmCEMDaJoXjDQZEL0kOrcL8KLyLQqLzBE5OGOzVvjH5fBFbWku9UwNjplJCiMNT7XCF9Qn+fJntU/w/9N4IfoTeRK3dKHDBxJ0R+0JprHc8Nji2NffChrd8RN5wCyfPzvnELRuh3RFqbH5Bn+u+RsKpaP6fL9hfecWWaFYk2KAip5VSEdSENKUpQNUQLf1ou85+ZOyQooM1RRyjfbeXjTlGf1p1NATRaSya7m6htzBCNSPYr6aEo9KI9qsdkPEEJm+8CtX3itNUZynKLhcZusSI1SRWJzs2pjghI/wBsTvXGnS3Rs5Act6JmobeiOC248HacZt1nDY/eKHZadW5JFBIGtd1xSeryEfj2Z5Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  6 Jul 2026 09:48:00 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> PAGEMAP_SCAN already reports PAGE_IS_WRITTEN from the inverted uffd
> PTE bit, targeting the UFFDIO_WRITEPROTECT workflow. UFFDIO_RWPROTECT
> reuses the same PTE bit as a marker for read-write protection, but
> "has been written" and "has been accessed" are distinct semantic
> signals — they happen to share one PTE bit today only because the two
> implementations share infrastructure.
> 
> Give RWP its own pagemap category so the UAPI does not conflate them:
> 
>   PAGE_IS_WRITTEN   reported on VM_UFFD_WP VMAs,  !pte_uffd(pte)
>   PAGE_IS_ACCESSED  reported on VM_UFFD_RWP VMAs, !pte_uffd(pte)
> 
> Both still read the same PTE bit today, but each is scoped to the VMA
> whose registered mode makes the bit meaningful. If a future
> implementation moves RWP to a separate PTE bit, only PAGE_IS_ACCESSED
> switches over.
> 
> This is a UAPI narrowing. Outside VM_UFFD_WP VMAs the uffd bit is
> always clear, so PAGEMAP_SCAN used to flag PAGE_IS_WRITTEN on every
> present PTE there — a meaningless duplicate of PAGE_IS_PRESENT. Now
> PAGE_IS_WRITTEN fires only inside VM_UFFD_WP VMAs.
> 
> pagemap_hugetlb_category() now takes the vma like its PTE/PMD peers.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-6
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  Documentation/admin-guide/mm/pagemap.rst | 13 +++--
>  fs/proc/task_mmu.c                       | 63 +++++++++++++++++-------
>  include/uapi/linux/fs.h                  |  1 +
>  tools/include/uapi/linux/fs.h            |  1 +
>  4 files changed, 57 insertions(+), 21 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/pagemap.rst b/Documentation/admin-guide/mm/pagemap.rst
> index c57e61b5d8aa..ffa690a171c8 100644
> --- a/Documentation/admin-guide/mm/pagemap.rst
> +++ b/Documentation/admin-guide/mm/pagemap.rst
> @@ -19,8 +19,11 @@ There are four components to pagemap:
>      * Bit  55    pte is soft-dirty (see
>        Documentation/admin-guide/mm/soft-dirty.rst)
>      * Bit  56    page exclusively mapped (since 4.2)
> -    * Bit  57    pte is uffd-wp write-protected (since 5.13) (see
> -      Documentation/admin-guide/mm/userfaultfd.rst)
> +    * Bit  57    pte is tracked by userfaultfd (since 5.13) — in a
> +      ``VM_UFFD_WP`` VMA this indicates a write-protected PTE; in a
> +      ``VM_UFFD_RWP`` VMA it indicates an RWP-protected PTE. WP and
> +      RWP are mutually exclusive per VMA, so the meaning is
> +      unambiguous. See Documentation/admin-guide/mm/userfaultfd.rst.
>      * Bit  58    pte is a guard region (since 6.15) (see madvise (2) man page)
>      * Bits 59-60 zero
>      * Bit  61    page is file-page or shared-anon (since 3.5)
> @@ -244,7 +247,8 @@ in this IOCTL:
>  Following flags about pages are currently supported:
>  
>  - ``PAGE_IS_WPALLOWED`` - Page has async-write-protection enabled
> -- ``PAGE_IS_WRITTEN`` - Page has been written to from the time it was write protected
> +- ``PAGE_IS_WRITTEN`` - Page in a ``UFFDIO_REGISTER_MODE_WP`` VMA has been
> +  written to since it was write-protected. Only reported inside such VMAs.
>  - ``PAGE_IS_FILE`` - Page is file backed
>  - ``PAGE_IS_PRESENT`` - Page is present in the memory
>  - ``PAGE_IS_SWAPPED`` - Page is in swapped
> @@ -252,6 +256,9 @@ Following flags about pages are currently supported:
>  - ``PAGE_IS_HUGE`` - Page is PMD-mapped THP or Hugetlb backed
>  - ``PAGE_IS_SOFT_DIRTY`` - Page is soft-dirty
>  - ``PAGE_IS_GUARD`` - Page is a part of a guard region
> +- ``PAGE_IS_ACCESSED`` - Page in a ``UFFDIO_REGISTER_MODE_RWP`` VMA has been
> +  accessed since RWP was applied. Only reported inside such VMAs. See
> +  Documentation/admin-guide/mm/userfaultfd.rst for the RWP workflow.
>  
>  The ``struct pm_scan_arg`` is used as the argument of the IOCTL.
>  
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 5b55c59573a3..2d724156763d 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -2283,7 +2283,7 @@ static const struct mm_walk_ops pagemap_ops = {
>   * Bits 5-54  swap offset if swapped
>   * Bit  55    pte is soft-dirty (see Documentation/admin-guide/mm/soft-dirty.rst)
>   * Bit  56    page exclusively mapped
> - * Bit  57    pte is uffd-wp write-protected
> + * Bit  57    pte is tracked by userfaultfd (uffd-wp or RWP)
>   * Bit  58    pte is a guard region
>   * Bits 59-60 zero
>   * Bit  61    page is file-page or shared-anon
> @@ -2418,7 +2418,7 @@ static int pagemap_release(struct inode *inode, struct file *file)
>  				 PAGE_IS_FILE |	PAGE_IS_PRESENT |	\
>  				 PAGE_IS_SWAPPED | PAGE_IS_PFNZERO |	\
>  				 PAGE_IS_HUGE | PAGE_IS_SOFT_DIRTY |	\
> -				 PAGE_IS_GUARD)
> +				 PAGE_IS_GUARD | PAGE_IS_ACCESSED)
>  #define PM_SCAN_FLAGS		(PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC)
>  
>  struct pagemap_scan_private {
> @@ -2443,8 +2443,12 @@ static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
>  
>  		categories = PAGE_IS_PRESENT;
>  
> -		if (!pte_uffd(pte))
> -			categories |= PAGE_IS_WRITTEN;
> +		if (!pte_uffd(pte)) {
> +			if (userfaultfd_wp(vma))
> +				categories |= PAGE_IS_WRITTEN;
> +			if (userfaultfd_rwp(vma))
> +				categories |= PAGE_IS_ACCESSED;
> +		}

The above is an ABI change for existing PAGEMAP_SCAN users although not
sure if there is someone that cares. Would below be a better alternative
to limit the ABI change?

if (!pte_uffd(pte)) {
	if (userfaultfd_rwp(vma))
		categories |= PAGE_IS_ACCESSED;
	else
		categories |= PAGE_IS_WRITTEN;
}


>  
>  		if (p->masks_of_interest & PAGE_IS_FILE) {
>  			page = vm_normal_page(vma, addr, pte);
> @@ -2461,8 +2465,12 @@ static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
>  
>  		categories = PAGE_IS_SWAPPED;
>  
> -		if (!pte_swp_uffd_any(pte))
> -			categories |= PAGE_IS_WRITTEN;
> +		if (!pte_swp_uffd_any(pte)) {
> +			if (userfaultfd_wp(vma))
> +				categories |= PAGE_IS_WRITTEN;
> +			if (userfaultfd_rwp(vma))
> +				categories |= PAGE_IS_ACCESSED;
> +		}
>  
>  		entry = softleaf_from_pte(pte);
>  		if (softleaf_is_guard_marker(entry))
> @@ -2511,8 +2519,12 @@ static unsigned long pagemap_thp_category(struct pagemap_scan_private *p,
>  		struct page *page;
>  
>  		categories |= PAGE_IS_PRESENT;
> -		if (!pmd_uffd(pmd))
> -			categories |= PAGE_IS_WRITTEN;
> +		if (!pmd_uffd(pmd)) {
> +			if (userfaultfd_wp(vma))
> +				categories |= PAGE_IS_WRITTEN;
> +			if (userfaultfd_rwp(vma))
> +				categories |= PAGE_IS_ACCESSED;
> +		}
>  
>  		if (p->masks_of_interest & PAGE_IS_FILE) {
>  			page = vm_normal_page_pmd(vma, addr, pmd);
> @@ -2526,8 +2538,12 @@ static unsigned long pagemap_thp_category(struct pagemap_scan_private *p,
>  			categories |= PAGE_IS_SOFT_DIRTY;
>  	} else {
>  		categories |= PAGE_IS_SWAPPED;
> -		if (!pmd_swp_uffd(pmd))
> -			categories |= PAGE_IS_WRITTEN;
> +		if (!pmd_swp_uffd(pmd)) {
> +			if (userfaultfd_wp(vma))
> +				categories |= PAGE_IS_WRITTEN;
> +			if (userfaultfd_rwp(vma))
> +				categories |= PAGE_IS_ACCESSED;
> +		}
>  		if (pmd_swp_soft_dirty(pmd))
>  			categories |= PAGE_IS_SOFT_DIRTY;
>  
> @@ -2560,7 +2576,8 @@ static void make_uffd_wp_pmd(struct vm_area_struct *vma,
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>  
>  #ifdef CONFIG_HUGETLB_PAGE
> -static unsigned long pagemap_hugetlb_category(pte_t pte)
> +static unsigned long pagemap_hugetlb_category(struct vm_area_struct *vma,
> +					      pte_t pte)
>  {
>  	unsigned long categories = PAGE_IS_HUGE;
>  
> @@ -2575,8 +2592,12 @@ static unsigned long pagemap_hugetlb_category(pte_t pte)
>  	if (pte_present(pte)) {
>  		categories |= PAGE_IS_PRESENT;
>  
> -		if (!huge_pte_uffd(pte))
> -			categories |= PAGE_IS_WRITTEN;
> +		if (!huge_pte_uffd(pte)) {
> +			if (userfaultfd_wp(vma))
> +				categories |= PAGE_IS_WRITTEN;
> +			if (userfaultfd_rwp(vma))
> +				categories |= PAGE_IS_ACCESSED;
> +		}
>  		if (!PageAnon(pte_page(pte)))
>  			categories |= PAGE_IS_FILE;
>  		if (is_zero_pfn(pte_pfn(pte)))
> @@ -2586,8 +2607,12 @@ static unsigned long pagemap_hugetlb_category(pte_t pte)
>  	} else {
>  		categories |= PAGE_IS_SWAPPED;
>  
> -		if (!pte_swp_uffd_any(pte))
> -			categories |= PAGE_IS_WRITTEN;
> +		if (!pte_swp_uffd_any(pte)) {
> +			if (userfaultfd_wp(vma))
> +				categories |= PAGE_IS_WRITTEN;
> +			if (userfaultfd_rwp(vma))
> +				categories |= PAGE_IS_ACCESSED;
> +		}
>  		if (pte_swp_soft_dirty(pte))
>  			categories |= PAGE_IS_SOFT_DIRTY;
>  	}
> @@ -2863,7 +2888,8 @@ static int pagemap_scan_pmd_entry(pmd_t *pmd, unsigned long start,
>  		goto flush_and_return;
>  	}
>  
> -	if (!p->arg.category_anyof_mask && !p->arg.category_inverted &&
> +	if (userfaultfd_wp(vma) && !p->arg.category_anyof_mask &&
> +	    !p->arg.category_inverted &&
>  	    p->arg.category_mask == PAGE_IS_WRITTEN &&
>  	    p->arg.return_mask == PAGE_IS_WRITTEN) {
>  		for (addr = start; addr < end; pte++, addr += PAGE_SIZE) {
> @@ -2938,7 +2964,8 @@ static int pagemap_scan_hugetlb_entry(pte_t *ptep, unsigned long hmask,
>  		/* Go the short route when not write-protecting pages. */
>  
>  		pte = huge_ptep_get(walk->mm, start, ptep);
> -		categories = p->cur_vma_category | pagemap_hugetlb_category(pte);
> +		categories = p->cur_vma_category |
> +			     pagemap_hugetlb_category(vma, pte);
>  
>  		if (!pagemap_scan_is_interesting_page(categories, p))
>  			return 0;
> @@ -2950,7 +2977,7 @@ static int pagemap_scan_hugetlb_entry(pte_t *ptep, unsigned long hmask,
>  	ptl = huge_pte_lock(hstate_vma(vma), vma->vm_mm, ptep);
>  
>  	pte = huge_ptep_get(walk->mm, start, ptep);
> -	categories = p->cur_vma_category | pagemap_hugetlb_category(pte);
> +	categories = p->cur_vma_category | pagemap_hugetlb_category(vma, pte);
>  
>  	if (!pagemap_scan_is_interesting_page(categories, p))
>  		goto out_unlock;
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index bd87262f2e34..34c6f219462a 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -471,6 +471,7 @@ typedef int __bitwise __kernel_rwf_t;
>  #define PAGE_IS_HUGE		(1 << 6)
>  #define PAGE_IS_SOFT_DIRTY	(1 << 7)
>  #define PAGE_IS_GUARD		(1 << 8)
> +#define PAGE_IS_ACCESSED	(1 << 9)
>  
>  /*
>   * struct page_region - Page region with flags
> diff --git a/tools/include/uapi/linux/fs.h b/tools/include/uapi/linux/fs.h
> index 24ddf7bc4f25..f0a26309b6d5 100644
> --- a/tools/include/uapi/linux/fs.h
> +++ b/tools/include/uapi/linux/fs.h
> @@ -364,6 +364,7 @@ typedef int __bitwise __kernel_rwf_t;
>  #define PAGE_IS_HUGE		(1 << 6)
>  #define PAGE_IS_SOFT_DIRTY	(1 << 7)
>  #define PAGE_IS_GUARD		(1 << 8)
> +#define PAGE_IS_ACCESSED	(1 << 9)
>  
>  /*
>   * struct page_region - Page region with flags
> -- 
> 2.54.0
> 
> 

