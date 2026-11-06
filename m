Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C423C606A330
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 15:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nIN9eJWk
Received: by kanga.kvack.org (Postfix)
	id BB1506B05B4; Fri,  6 Nov 2026 10:56:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B618C6B05B5; Fri,  6 Nov 2026 10:56:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4FC76B05B8; Fri,  6 Nov 2026 10:56:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73ADF6B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:56:11 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED4D8140D97
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:56:10 +0000 (UTC)
X-FDA: 85405145700.14.6D76D16
Received: from mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf10.hostedemail.com (Postfix) with ESMTP id C3C3BC0009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:56:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nIN9eJWk;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793980569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UfD8ZnH6BJz/4LIcV1+SpPJwWoacvDCqotJJBOhRHbY=;
	b=e4s088N8key7c/vBe4U0ByR3ZATdKzvYYFPhXmNlGjHpGKPmY1901OS7MSIlUYp3IKz6gC
	mwLoBkTXijWbwKHJM7c5bf6us7Q2hAOblccLHjegNYDW3GdF93PupmR43ywJWtjhCMM559
	kWT1ZdEjO6lUNSLJzLjz5N7avwAxi+w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793980569;
	b=yDwOoBu9Jq/SeS4EpEsbpazDNOYruFt3NOxUQNslX5/Bq1tOj+hI/QEGx3dFRSWp1bL+Tu
	5qUJV8UJ0sjlAmZ/+yGOoMhasbh+s9MfwxWML6CDclD2iq4zKfE/yIf14h961dG/tEKNLx
	QNjhb65PWuCK3B58z1aca6kM7hQ2+kk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nIN9eJWk;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IUxtcrSK4ScUgL4iwrR/fCWoiD4BzoTR6aRMHmOVWZw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793980567; v=1; x=1794585367;
 b=nIN9eJWkx0/Zp/tqNTNTIvfGLDUajdmUzVXC0+QaFWbCFAy2R9/Ih25xdkqBZ7HDtFUqSmKE
 oPvIQGjNMhiMAfVLoJ2QIEZ8nrCHtV1dqzun4eQFtCp9m72m0pGRyYmw5EW+soHwI2Rp+Zzrph5
 VW24hOtLjtiGG7UAilnor9hg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 7a7c6486c02f11c8;
	Fri, 06 Nov 2026 15:56:07 +0000
X-Mizu-Trace-ID: 7a7c6486c02f11c8
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm: don't allocate a page table under RCU in do_set_pmd()
Date: Fri,  6 Nov 2026 07:56:03 -0800
Message-ID: <20261106155604.3999641-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261106-khugepaged_set_pmd-v2-2-d2457b5e377a@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: m347ey539p44xa3nhosisk6kxi6dmy77
X-Rspamd-Queue-Id: C3C3BC0009
X-Rspam-User: 
X-HE-Tag: 1793980568-996273
X-HE-Meta: U2FsdGVkX1+3Uu2KyMYNp7F46fqhLK5K2ZOx4yRo9MX8sb2lhfcO2BY2Q0Tx6R3M4NOO7c7i9obn9q8LFlPY+S86m50mT+sqZ/UXt128iAasYAuiqPKoo2NxWp6Gnp+Dk9z/cmALSARH0Ah2kj2OU2iwH9hOfAWV/O6ZZnKI56LDWYj2Jjo6e4VXCQ4nOFZINoStoFkQmedAs6JajKh6oiynCT019YRiJBd/5kFcpQueJhrbKMFfRaWJcBn3THLuStsr0QsR9LxqvorAmetAXq49rp3hyYt2Z9PTtOsmoUFJWNU3PmwLsxKhAJuR7+zuOSBitfIKv7iedtgtxRqKpFh+Wd8bP/dxvEYDwmgj5Ezi7OodOp8X5amM5ITkr1r2dgcbke9o54rN7ok5uML3RC3lGW4WlAuQiwMY6x6J5wyWJDCj1W5obZV8bRMmaQxYRO7ScFKcF1SsgXVoUejEycyDD4KQNRuEddAOy5Oxqr8XlueddUDZEg8GFvY1oPmUun/WUpxRb+SKS5gbq0ZwsnGz0uB3+WpZ0V/UQ9o87sJELQeM4cndJ6bP/Owf09VWkh1Wlud5NP7/fKA1bA7uuKRTNtAE/ZxL0DhC8Slq0rs3bvsQtjP4zpr9kbqrg05xW9Qf6bkymbpdisM8OnSNj5l3DxfcvqBBC9zadqE2xj2QbVxpEwLz0LqXEeMjB2skpzOSbNAsWy032Yj11a9K08kVe9hRlRZbRr3eBsTXjpjEkoiVppu9eCRO2wLceG2q4xKhbjLAGU713SWJqNkzqbBvEnHYeI24Gf1nHkRadkn7d+s9EMOG8Py31oWv2KCITnBWhAbxFTOM+AiISvbV51dkUHbzoQgNHFYqed5cupO4MK3njK0NP5BSGJZmXPxg+8cb+bcNme0jfdSj33rkzIphscOUXQvOL5/KoSzCziLu+aRZUoX4x9Yccxta31z/BV4yiDb9VgHPmiQ9s3R
 3Nw5Ne5k
 Dl2Q+BpnB2vPCGrDXUWJFPzjgtVRRlKo4A2ONoP+lN2BQ6AkB+i8P98iH+YsKmNEelfCbtOk2oQF5yfvyD4vuCLTddTquDWkcB6bn2uuW5vb+Lv8xvDU/+6etp7ci8uvvnOUW4KE50X+nqQYYUukY5eYazh/zgicu4k/Y4BtNAE0Fl36O4RvKSLZ53PN+FEP4geGEyVCO6XRgPm8uNLi7d7XlNVej+dHS8B99zcA1Xxdz1v4Pic9Q8FP1Unix3n0eac/njAMDOJldR9ViXvMyERwkRzdRq9eafYYkDXuk7Z4WnFI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 06 Nov 2026 13:36:13 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> do_fault_around() skips PTE table preallocation when the PMD already points
> to a PTE table. A concurrent collapse can then retract that table and
> clear the PMD before filemap_map_pages() locks the new PMD-sized folio.
> 
> filemap_map_pmd() can then call do_set_pmd() with an empty PMD and no
> preallocated table. On PowerPC hash MMU, do_set_pmd() then tries
> allocating a PTE table to deposit. But filemap_map_pmd() calls
> do_set_pmd() under RCU, so allocating from that context is not good.
> 
> This race became possible when retract_page_tables() stopped taking the
> mmap and VMA locks. Previously, those locks excluded retraction while
> the fault was in progress.
> 
> Add a may_alloc argument to do_set_pmd() and pass false from
> filemap_map_pmd(), so we can fail with VM_FAULT_FALLBACK instead of
> trying to allocate.
> 
> This issue should be fairly hard to hit in practice.
>

Yes, I imagine it was very difficult to reproduce, doing a sleeping
pte_alloc_one() inside filemap_map_pmd()'s RCU read-side section
when a concurrent retract_page_tables() empties the PMD. Only
possible on PowerPC.

> Fixes: 1d65b771bc08 ("mm/khugepaged: retract_page_tables() without mmap or vma lock")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Acked-by: Usama Arif <usama.arif@linux.dev>

>  include/linux/mm.h |  3 ++-
>  mm/filemap.c       |  2 +-
>  mm/khugepaged.c    |  2 +-
>  mm/memory.c        | 10 +++++++---
>  4 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index a2dd76cc5bbfe..bd144fec5f5da 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2156,7 +2156,8 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
>  	return pte;
>  }
>  
> -vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page);
> +vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page,
> +		bool may_alloc);
>  void set_pte_range(struct vm_fault *vmf, struct folio *folio,
>  		struct page *page, unsigned int nr, unsigned long addr);
>  
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 86297841f9955..9871b4f32a916 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3745,7 +3745,7 @@ static bool filemap_map_pmd(struct vm_fault *vmf, struct folio *folio,
>  
>  	if (pmd_none(*vmf->pmd) && folio_test_pmd_mappable(folio)) {
>  		struct page *page = folio_file_page(folio, start);
> -		vm_fault_t ret = do_set_pmd(vmf, folio, page);
> +		vm_fault_t ret = do_set_pmd(vmf, folio, page, /* may_alloc= */ false);
>  		if (!ret) {
>  			/* The page is mapped successfully, reference consumed. */
>  			folio_unlock(folio);
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 8d9f05a39afb3..5836e08abc984 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1826,7 +1826,7 @@ static enum scan_result set_huge_pmd(struct vm_area_struct *vma, unsigned long a
>  	}
>  
>  	vmf.pmd = pmdp;
> -	if (do_set_pmd(&vmf, folio, page))
> +	if (do_set_pmd(&vmf, folio, page, /* may_alloc= */ true))
>  		return SCAN_FAIL;
>  
>  	folio_get(folio);
> diff --git a/mm/memory.c b/mm/memory.c
> index 421064aef3cf0..6eeed43b05a19 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5682,7 +5682,8 @@ static void deposit_prealloc_pte(struct vm_fault *vmf)
>  	vmf->prealloc_pte = NULL;
>  }
>  
> -vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page)
> +vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page,
> +		bool may_alloc)
>  {
>  	struct vm_area_struct *vma = vmf->vma;
>  	bool write = vmf->flags & FAULT_FLAG_WRITE;
> @@ -5723,6 +5724,8 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
>  	 * related to pte entry. Use the preallocated table for that.
>  	 */
>  	if (arch_needs_pgtable_deposit() && !vmf->prealloc_pte) {
> +		if (!may_alloc)
> +			return VM_FAULT_FALLBACK;
>  		vmf->prealloc_pte = pte_alloc_one(vma->vm_mm);
>  		if (!vmf->prealloc_pte)
>  			return VM_FAULT_OOM;
> @@ -5764,7 +5767,8 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
>  	return ret;
>  }
>  #else
> -vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page)
> +vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page,
> +		bool may_alloc)
>  {
>  	return VM_FAULT_FALLBACK;
>  }
> @@ -5888,7 +5892,7 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
>  
>  	if (pmd_none(*vmf->pmd)) {
>  		if (!needs_fallback && folio_test_pmd_mappable(folio)) {
> -			ret = do_set_pmd(vmf, folio, page);
> +			ret = do_set_pmd(vmf, folio, page, /* may_alloc= */ true);
>  			if (ret != VM_FAULT_FALLBACK)
>  				return ret;
>  		}
> 
> -- 
> 2.43.0
> 
> 

