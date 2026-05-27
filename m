Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0562CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 12:24:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4E046B00AD; Wed, 27 May 2026 08:24:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FE6D6B00AE; Wed, 27 May 2026 08:24:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EDB96B00AF; Wed, 27 May 2026 08:24:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B8916B00AD
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:24:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2EDF91C1988
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:24:29 +0000 (UTC)
X-FDA: 84813117858.22.3143F0C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 08BBC18000F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:24:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lBe3ZX3V;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779884667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cGeamoObf1qbjghhGJkIscnw/Fsp6/UIlrdZOPEQVao=;
	b=MM0qDd3ZgJYzfaQQv/N9a4SVDUt5eHhJbXfgWOVpkFKAQ6HfGt084xj/nlkeFFEMphg3Us
	U002iIU2OGF6Y4DdS51VPmM/c0Ba7DEcke/7AC8+8rKJi7My3wcM8eeL3HF/DB5FasdF4l
	5rh9S7p2C1SFVz55cjdaOvFX/R8L91M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779884667; a=rsa-sha256;
	cv=none;
	b=GT3cbXYnWRjuPkfK3JkD3726OVwY4UHiXdiK+S7WWNtLSWbFCa+hY1qZ9VyYFJaek9lwAW
	Qb+2iPa4laUQtM7HzUxyJ1VlpaayVkw6UKTyh58qp/t6vnCTivmuO+bLkkJTFztsxXv8+I
	kMYSc1u7PMV/PIcsmh2gCvy589+mR4k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lBe3ZX3V;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B6942C3D;
	Wed, 27 May 2026 05:24:20 -0700 (PDT)
Received: from [10.164.19.7] (unknown [10.164.19.7])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A70A43F905;
	Wed, 27 May 2026 05:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779884665; bh=UotxsZ+zZr/XhydpYBQL8pv0WmoT4CF/hvzZHlKS1wI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lBe3ZX3VofaulxbGxDNMYHhGSvjPT3XdKH4EXZZetS4djxu0JFRfKn/pdasiSVkNW
	 2Nu5MPl/CJbYh+REJ+3ixRKC6FiHTlZ3FU5o3LG8N2CLRJTSRzn8/IxQ9AL2d/C7tr
	 YIEo8Qurl5gJrZCjR8uegmh+i9jLeQziPgLEAD3w=
Message-ID: <38ee9d6e-4331-48b0-82e4-2e6ae0aee705@arm.com>
Date: Wed, 27 May 2026 17:54:05 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable RFC v4 4/7] mm/huge_memory: refactor
 copy_huge_pmd()
To: Yin Tirui <yintirui@huawei.com>, Andrew Morton
 <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Juergen Gross <jgross@suse.com>, Jonathan Cameron <jic23@kernel.org>,
 Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Peter Xu <peterx@redhat.com>,
 Luiz Capitulino <luizcap@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H . Peter Anvin"
 <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Anshuman Khandual
 <anshuman.khandual@arm.com>, Rohan McLure <rmclure@linux.ibm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>, Alistair Popple <apopple@nvidia.com>,
 Andrew Donnellan <andrew+kernel@donnellan.id.au>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Baoquan He <bhe@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Coiby Xu <coxu@redhat.com>,
 Dan Williams <djbw@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>,
 Lu Baolu <baolu.lu@linux.intel.com>,
 Conor Dooley <conor.dooley@microchip.com>, Rik van Riel <riel@surriel.com>,
 wangkefeng.wang@huawei.com, chenjun102@huawei.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 linux-pm@vger.kernel.org
References: <20260526145003.88445-1-yintirui@huawei.com>
 <20260526145003.88445-5-yintirui@huawei.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260526145003.88445-5-yintirui@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 8hykjty8eie3qn3knnz69jmc4s5q3mwo
X-Rspamd-Queue-Id: 08BBC18000F
X-Rspam-User: 
X-HE-Tag: 1779884666-906362
X-HE-Meta: U2FsdGVkX18+Qg094P2d3yDPkjkfKwPGLgEzAk6OACPnljDXfsAEzNoS5xZAYnmIwCD99RE0LCWBDAZv7S38/GwWmbtH54XEzDnOpoXQFaYMqqNX4q9WBZk9mFAccfjb7wNDqJl7oNz+Z5rXp5jXSUr6gSvwgOK7W5jofO2zA5ZGyHsr55iCsBCfWQYM7b37WhEiy9U8sIXQrfqU6BhRCX6jbW+MOWZkL781opSyrsG697VKbgG864nTyFBCURAS2k5sgmblYH/cVVHteqr2fCASE1JeVXnk11ZsNoViN1HlpGLoCYNKxHgAfeTzixZLiy681I6pPQFAMiwI99Qw7bdGDiB27C0gAdRiQw0MZ2LX1ROfIMAHlLns3WdUmROuQ+jLZZOoDz+aDf4057spQOYecRiZnNaDLo0i/IG5AqvbJeslGBPoXYonVWZq4FhmKD1F5+Pyi67xvP5hwqp2a7AbMKjZ2/nG0QPOX+Df0BECXMSrWBb0k5a1sECK/6X6dMkY9kKBh6QMXjM8FVIDTCcu7sM+6Yo7xLHp8Qpqa/mvNZPH/crG2/q4dLsdkUsay38c+lMS2WeF1nh6s9uPNehom6qWiY55elfdq4jODHS/x3yalP3GRTf6/KMu94f5fvAgFntF0ccKD/f/wz7UiYp4N2bWhfJtzyIuYq8P7WI+5IITMsUhkiLraTQUIOnEu7mOrHrAh5/46dAAvhmI4HgjJZFIj2jXzhq5g15nckAR9XFvwBgX0mpAG6ijqcHC8o6iLAE6Mt1IDmPFCx0xKdLLV29J0PShIOKjP2IxIY7E1RKdmRM/o3+p2/twLqFPsbohICwHEWjW+MmYBbrN/umV1akRcupxliCKtuxnkh5ocynHltgEoSgUmCzDC/otjkOrahG86bBAP95CHfuPBwVhxxU6VsA8JNeRBPkQ5CZSc8vbYZu0LNeCzIuJzBRoanLvvcg2YAkPZphjXnD
 mLhis1sn
 475dRn/wwLtZDqZvc8iaa6qKjQuuC+xq7ARLpSAq5Trf6WNuPW4l0LpqG59dS138j1RK6haCtv1dQInNa6t5AwERf+ieuuIiIZPLKuaWNEQw7HQNcR6Z+rogicAIbVEdAbBBFgLweTkwVqpezMO92cimAOJnc3Y3kCsCOheTI2Q3ty5eHJw7Dmz4FJw/VhDR6x07P6aOxFhDkQEI/y8MXb709xset+FrBfH3O/Ef931jX1A99TzqAjI+ixjZz2Eha3FYyROPoAJpqEfOJhsuKuNGxYZ3O5qjp9XPGRqlLwz6pNjCsActFQX9TRJPaABIP0AmcmkPI4w0CSNunW+KxClVuqDZ+FS1AjNKsyu6nsEnsISrf4pIrOpu/r46XEmoM++dS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/05/26 8:20 pm, Yin Tirui wrote:
> Classify the source PMD via pmd_present() and vm_normal_folio_pmd(),
> matching the way the PTE path uses pte_present() and vm_normal_page().
> This moves the present-PMD decision from VMA identity checks to the
> actual PMD/folio state.
> 
> Drop the defensive "if (!pmd_trans_huge(pmd)) goto out_unlock" branch:
> with mmap_write_lock held during fork, it should not occur.

Split this from this patch? This is a functional change so will be better
to review it separately.

> 
> Extract the present-PMD side of copy_huge_pmd() into
> copy_present_huge_pmd(). The helper owns the child pgtable passed by the
> caller: it either deposits the pgtable when installing a copied PMD, or
> frees it on paths that do not install one.
> 
> The child pgtable is now allocated once up front and freed on every skip
> path. This makes file/shmem and PFNMAP/special skip paths take the PMD
> locks and free the preallocated pgtable before returning. These are not
> expected to be hot paths, and the PFNMAP case is reused by the follow-up
> PMD PFNMAP copy support.
> 
> Signed-off-by: Yin Tirui <yintirui@huawei.com>
> ---

Since the series is still marked RFC, I think it would be better to send
the refactor patches separately?

>  mm/huge_memory.c | 175 +++++++++++++++++++++++++----------------------
>  1 file changed, 95 insertions(+), 80 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 9832ee910d5e..3964258ff91d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1879,6 +1879,82 @@ bool touch_pmd(struct vm_area_struct *vma, unsigned long addr,
>  	return false;
>  }
>  
> +static int copy_present_huge_pmd(
> +		struct mm_struct *dst_mm, struct mm_struct *src_mm,
> +		pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
> +		struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
> +		pmd_t pmd, pgtable_t pgtable, bool *need_split)
> +{
> +	struct folio *src_folio;
> +	bool wrprotect = true;
> +
> +	src_folio = vm_normal_folio_pmd(src_vma, addr, pmd);
> +	if (!src_folio) {
> +		/*
> +		 * When page table lock is held, the huge zero pmd should not be
> +		 * under splitting since we don't split the page itself, only pmd to
> +		 * a page table.
> +		 */
> +		if (is_huge_zero_pmd(pmd)) {
> +			/*
> +			 * mm_get_huge_zero_folio() will never allocate a new
> +			 * folio here, since we already have a zero page to
> +			 * copy. It just takes a reference.
> +			 */
> +			mm_get_huge_zero_folio(dst_mm);
> +			goto set_pmd;
> +		}
> +
> +		/*
> +		 * Making sure it's not a CoW VMA with writable
> +		 * mapping, otherwise it means either the anon page wrongly
> +		 * applied special bit, or we made the PRIVATE mapping be
> +		 * able to wrongly write to the backend MMIO.
> +		 */
> +		VM_WARN_ON_ONCE(is_cow_mapping(src_vma->vm_flags) && pmd_write(pmd));
> +		pte_free(dst_mm, pgtable);
> +		pgtable = NULL;
> +		wrprotect = false;
> +		goto set_pmd;
> +	}
> +
> +	/* File THPs are copied lazily by refaulting. */
> +	if (!folio_test_anon(src_folio)) {
> +		pte_free(dst_mm, pgtable);
> +		return 0;
> +	}


You removed !vma_is_anonymous to condense it into !folio_test_anon.
For private-file mappings that is not true, but okay since PMD mapping
is not supported.

> +
> +	folio_get(src_folio);
> +	if (unlikely(folio_try_dup_anon_rmap_pmd(src_folio,
> +							&src_folio->page,
> +							dst_vma, src_vma))) {
> +		/* Page maybe pinned: split and retry the fault on PTEs. */
> +		folio_put(src_folio);
> +		pte_free(dst_mm, pgtable);
> +		*need_split = true;
> +		return -EAGAIN;
> +	}
> +	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
> +
> +set_pmd:
> +	if (pgtable) {
> +		mm_inc_nr_ptes(dst_mm);
> +		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
> +	}
> +
> +	if (wrprotect) {
> +		pmdp_set_wrprotect(src_mm, addr, src_pmd);
> +		if (!userfaultfd_wp(dst_vma))
> +			pmd = pmd_clear_uffd_wp(pmd);
> +		pmd = pmd_wrprotect(pmd);
> +	}
> +
> +	pmd = pmd_mkold(pmd);
> +	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
> +
> +	return 0;
> +}
> +
>  static void copy_huge_non_present_pmd(
>  		struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  		pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
> @@ -1940,104 +2016,43 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  		  struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
>  {
>  	spinlock_t *dst_ptl, *src_ptl;
> -	struct page *src_page;
> -	struct folio *src_folio;
> -	pmd_t pmd;
>  	pgtable_t pgtable = NULL;
> -	int ret = -ENOMEM;
> -
> -	pmd = pmdp_get_lockless(src_pmd);
> -	if (unlikely(pmd_present(pmd) && pmd_special(pmd) &&
> -		     !is_huge_zero_pmd(pmd))) {
> -		dst_ptl = pmd_lock(dst_mm, dst_pmd);
> -		src_ptl = pmd_lockptr(src_mm, src_pmd);
> -		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
> -		/*
> -		 * No need to recheck the pmd, it can't change with write
> -		 * mmap lock held here.
> -		 *
> -		 * Meanwhile, making sure it's not a CoW VMA with writable
> -		 * mapping, otherwise it means either the anon page wrongly
> -		 * applied special bit, or we made the PRIVATE mapping be
> -		 * able to wrongly write to the backend MMIO.
> -		 */
> -		VM_WARN_ON_ONCE(is_cow_mapping(src_vma->vm_flags) && pmd_write(pmd));
> -		goto set_pmd;
> -	}
> -
> -	/* Skip if can be re-fill on fault */
> -	if (!vma_is_anonymous(dst_vma))
> -		return 0;
> +	bool need_split = false;
> +	int ret = 0;
> +	pmd_t pmd;
>  
>  	pgtable = pte_alloc_one(dst_mm);
>  	if (unlikely(!pgtable))
> -		goto out;
> +		return -ENOMEM;
>  
>  	dst_ptl = pmd_lock(dst_mm, dst_pmd);
>  	src_ptl = pmd_lockptr(src_mm, src_pmd);
>  	spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
>  
> -	ret = -EAGAIN;
>  	pmd = *src_pmd;
>  
> -	if (unlikely(thp_migration_supported() &&
> -		     pmd_is_valid_softleaf(pmd))) {
> -		copy_huge_non_present_pmd(dst_mm, src_mm, dst_pmd, src_pmd, addr,
> +	if (likely(pmd_present(pmd))) {
> +		ret = copy_present_huge_pmd(dst_mm, src_mm, dst_pmd, src_pmd, addr,
> +					  dst_vma, src_vma, pmd, pgtable, &need_split);
> +	} else if (unlikely(thp_migration_supported() && pmd_is_valid_softleaf(pmd))) {
> +		if (unlikely(!vma_is_anonymous(dst_vma)))
> +			pte_free(dst_mm, pgtable);
> +		else
> +			copy_huge_non_present_pmd(dst_mm, src_mm, dst_pmd, src_pmd, addr,
>  					  dst_vma, src_vma, pmd, pgtable);
> -		ret = 0;
> -		goto out_unlock;
> -	}
> -
> -	if (unlikely(!pmd_trans_huge(pmd))) {
> +	} else {
> +		VM_WARN_ONCE(1, "unexpected non-present PMD %llx\n",
> +				(unsigned long long)pmd_val(pmd));
>  		pte_free(dst_mm, pgtable);
> -		goto out_unlock;
> -	}
> -	/*
> -	 * When page table lock is held, the huge zero pmd should not be
> -	 * under splitting since we don't split the page itself, only pmd to
> -	 * a page table.
> -	 */
> -	if (is_huge_zero_pmd(pmd)) {
> -		/*
> -		 * mm_get_huge_zero_folio() will never allocate a new
> -		 * folio here, since we already have a zero page to
> -		 * copy. It just takes a reference.
> -		 */
> -		mm_get_huge_zero_folio(dst_mm);
> -		goto out_zero_page;
> +		ret = -EAGAIN;
>  	}
>  
> -	src_page = pmd_page(pmd);
> -	VM_BUG_ON_PAGE(!PageHead(src_page), src_page);
> -	src_folio = page_folio(src_page);
> +	spin_unlock(src_ptl);
> +	spin_unlock(dst_ptl);
>  
> -	folio_get(src_folio);
> -	if (unlikely(folio_try_dup_anon_rmap_pmd(src_folio, src_page, dst_vma, src_vma))) {
> -		/* Page maybe pinned: split and retry the fault on PTEs. */
> -		folio_put(src_folio);
> -		pte_free(dst_mm, pgtable);
> -		spin_unlock(src_ptl);
> -		spin_unlock(dst_ptl);
> +	if (unlikely(need_split))
>  		__split_huge_pmd(src_vma, src_pmd, addr, false);
> -		return -EAGAIN;
> -	}
> -	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
> -out_zero_page:
> -	mm_inc_nr_ptes(dst_mm);
> -	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
> -	pmdp_set_wrprotect(src_mm, addr, src_pmd);
> -	if (!userfaultfd_wp(dst_vma))
> -		pmd = pmd_clear_uffd_wp(pmd);
> -	pmd = pmd_wrprotect(pmd);
> -set_pmd:
> -	pmd = pmd_mkold(pmd);
> -	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
>  
> -	ret = 0;
> -out_unlock:
> -	spin_unlock(src_ptl);
> -	spin_unlock(dst_ptl);
> -out:
>  	return ret;
>  }
>  


