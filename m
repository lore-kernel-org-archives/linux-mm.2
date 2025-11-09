Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67E34CCFA13
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 16:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 479F68E0003; Sun,  9 Nov 2025 11:26:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 451718E0002; Sun,  9 Nov 2025 11:26:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3672F8E0003; Sun,  9 Nov 2025 11:26:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1FCE68E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 11:26:57 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C12E71A09BE
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 16:26:56 +0000 (UTC)
X-FDA: 84091597632.17.D81FD9E
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8C155180004
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 16:26:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pwyW2EW6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762705615; a=rsa-sha256;
	cv=none;
	b=THptcEuMNNmaF8Mrv7Ggmk1rZHErep0dhk+8HHPB7Xo/XADATYehrj5sjl2IEzhS8HqMPo
	bUV9Bhk1B+Dj5PnYOjP2d1hpe02h4CS47ydgtlVmV5Slfuhno4eEBZjzg//XeaJYe7tkGq
	U24wwWQxOEcLxuFPNKfC5ptadGgmfsA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pwyW2EW6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762705615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oc0nS0Oa6VgyqrdvhkSTK7B+nOWIW7alkYgFANGDZPQ=;
	b=S+KLt3vWysDnbDvxojYiZBqSWXkyCO3yJQXVanqP7tsqwTseCM+baNaGsNLDiirG6bTI3a
	bi3+grwY0KA6cfpBEK0JJbWwq6bu7AQeNkeODN1265bsiJY9Hg2lFbnQ211oZjj1uOupId
	WqJJPgslr6/XuC7clo8S9/do7KPTbiI=
Message-ID: <5ed51639-604c-4e15-84ae-4bf3777f83c1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762705611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oc0nS0Oa6VgyqrdvhkSTK7B+nOWIW7alkYgFANGDZPQ=;
	b=pwyW2EW686jL52qUi8I2VuTz1EmNkWpfSru0DsgZMM+9Q0p0FNTrkdRidIItTWCToFu7KE
	n9z0y9FEp1NXnIrrKUnS0acP2LaEfRrFzFZYM6R/qjdwf2GSGPEVniFjn2kGZ4QpoXZKdK
	dRzKFf0NJRNE89MT5AE5NrJjf4gimIk=
Date: Mon, 10 Nov 2025 00:26:26 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 01/16] mm: correctly handle UFFD PTE markers
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
 SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Pedro Falcato <pfalcato@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-arch@vger.kernel.org, damon@lists.linux.dev
References: <cover.1762621567.git.lorenzo.stoakes@oracle.com>
 <0b50fd4b1d3241d0965e6b969fb49bcc14704d9b.1762621568.git.lorenzo.stoakes@oracle.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <0b50fd4b1d3241d0965e6b969fb49bcc14704d9b.1762621568.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8C155180004
X-Rspamd-Server: rspam07
X-Stat-Signature: p4c8zmiahsxrmqx31yif1q78hmaxf48u
X-Rspam-User: 
X-HE-Tag: 1762705614-413578
X-HE-Meta: U2FsdGVkX1+lj/c/a0TE1pn+uPsMc9rCNM6cEXgtzICvBJHMf+/+lpnE/OzcWyM95Iz/5/ps75QhNICF98NkqUWDLj33PweEQ63ln38O3/+B1IqYpb6fTcDUefI6RjPBv2aHcAd3bzAIk1HHxfbekAaDZFUjYuxt7S6DSuQxH4eU4E1DGBYeij/A8XhGXq+7JVwxJ17qgF+t+0+uKDG40damuMXt6fqgybTcShb+RHoo4Jo6peKC7rxXwkIB2x+vgq/VJ82cMghGW953t/iRSoemYd2rR+BwXp9k6F5H5k99bk3Z4T07TNT+8XALKq7bbyac8laLJs0AmoBC1s3b9Fg4iG+78bdFfFTzTSzEd4FoYdAjTvxgnzuw/SG653kGCWyvvLP58u/zQK2cBXaG26pu0Ok2MJhpqFLkEPdHwGXD5O23FC/PU+J5bDZ9qiXkoRHYaA5ijoy30slsMNO2OK6KEXbRyTMAPyuF1YZeAh8Jra7pSH51ewa8UxPLaozVNWaCsxW+rXkWkFRJfjR8qCxxR0Y7Z3pJz3ovRU7zPYkWTBA7EtHcDOM97aSVeSBzKDE+wBGDSxtzEmB00JV8ozXguLq2Gpk5lEk7t7fjMPkzG3RWm85WzLIwadKSicnW0DRyC3q25HyyWPGWu3BG+BI7KRelQN3b2xd6nnhDM8hCUTWcZRSH5yVlPfIqqyRukzFG9RhjxDiq2WfYhimcyVq9rJDLprK2iQg/zDWpGxoGLm1NG9RqLLB8qw0HBZSHHzFRSak6/LEsR3nbkYbD5Cf6dU1CEQTnq5MMkZcQjsRcaHoNYbCs062vJRzbA3fukyn8mKold7p0yaSnYnyPKFTtovpq8+EBHNKyog+O88y6tv1OLOLYgbzIno6QhDpBBx/fvKtEUWeG+ngYqs8D8cluM0ReT5SGyjcia458U/s0k3arRz1Jqca7+X1ZZm9PORGvrD2+YcT/mt4bfar
 tHqiAFbp
 2gIpWoW1m/1zLj2FptBRKh/dDlRs+WqMx5g+Pi9vKSIY48J+SWmXPfmDd84JQD+iqfkXTJlZ3wavyJQsmJfmMRkTAcqNm0ptmeNYl4ECpRtHWHw59L17gjs9I6kM12OQauQfnhNPyeSque1YaaHWj1J9WGeKuR5d5iQ7Itm7Z4+w6VtpPYMGEAv4UJtVcGXDn6+5AGqSI4QkFJKvYbAAEaUp6gowWnhX1esEh8kvdZRQPYn5z/vU/oIyUOXxjP3+fdWvh2zWs9cvO1VHKlBcQxLpKeOsD7zZHI13pD572jXgoBlg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/9 01:08, Lorenzo Stoakes wrote:
> PTE markers were previously only concerned with UFFD-specific logic - that
> is, PTE entries with the UFFD WP marker set or those marked via
> UFFDIO_POISON.
> 
> However since the introduction of guard markers in commit
>   7c53dfbdb024 ("mm: add PTE_MARKER_GUARD PTE marker"), this has no longer
>   been the case.
> 
> Issues have been avoided as guard regions are not permitted in conjunction
> with UFFD, but it still leaves very confusing logic in place, most notably
> the misleading and poorly named pte_none_mostly() and
> huge_pte_none_mostly().
> 
> This predicate returns true for PTE entries that ought to be treated as
> none, but only in certain circumstances, and on the assumption we are
> dealing with H/W poison markers or UFFD WP markers.
> 
> This patch removes these functions and makes each invocation of these
> functions instead explicitly check what it needs to check.
> 
> As part of this effort it introduces is_uffd_pte_marker() to explicitly
> determine if a marker in fact is used as part of UFFD or not.
> 
> In the HMM logic we note that the only time we would need to check for a
> fault is in the case of a UFFD WP marker, otherwise we simply encounter a
> fault error (VM_FAULT_HWPOISON for H/W poisoned marker, VM_FAULT_SIGSEGV
> for a guard marker), so only check for the UFFD WP case.
> 
> While we're here we also refactor code to make it easier to understand.
> 
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>   fs/userfaultfd.c              | 83 +++++++++++++++++++----------------
>   include/asm-generic/hugetlb.h |  8 ----
>   include/linux/swapops.h       | 18 --------
>   include/linux/userfaultfd_k.h | 21 +++++++++
>   mm/hmm.c                      |  2 +-
>   mm/hugetlb.c                  | 47 ++++++++++----------
>   mm/mincore.c                  | 17 +++++--
>   mm/userfaultfd.c              | 27 +++++++-----
>   8 files changed, 123 insertions(+), 100 deletions(-)
> 
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index 54c6cc7fe9c6..04c66b5001d5 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -233,40 +233,46 @@ static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
>   {
>   	struct vm_area_struct *vma = vmf->vma;
>   	pte_t *ptep, pte;
> -	bool ret = true;
>   
>   	assert_fault_locked(vmf);
>   
>   	ptep = hugetlb_walk(vma, vmf->address, vma_mmu_pagesize(vma));
>   	if (!ptep)
> -		goto out;
> +		return true;
>   
> -	ret = false;
>   	pte = huge_ptep_get(vma->vm_mm, vmf->address, ptep);
>   
>   	/*
>   	 * Lockless access: we're in a wait_event so it's ok if it
> -	 * changes under us.  PTE markers should be handled the same as none
> -	 * ptes here.
> +	 * changes under us.
>   	 */
> -	if (huge_pte_none_mostly(pte))
> -		ret = true;
> +
> +	/* If missing entry, wait for handler. */
> +	if (huge_pte_none(pte))
> +		return true;
> +	/* UFFD PTE markers require handling. */
> +	if (is_uffd_pte_marker(pte))
> +		return true;
> +	/* If VMA has UFFD WP faults enabled and WP fault, wait for handler. */
>   	if (!huge_pte_write(pte) && (reason & VM_UFFD_WP))
> -		ret = true;
> -out:
> -	return ret;
> +		return true;
> +
> +	/* Otherwise, if entry isn't present, let fault handler deal with it. */
> +	return false;
>   }
>   #else
>   static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
>   					      struct vm_fault *vmf,
>   					      unsigned long reason)
>   {
> -	return false;	/* should never get here */
> +	/* Should never get here. */
> +	VM_WARN_ON_ONCE(1);
> +	return false;
>   }
>   #endif /* CONFIG_HUGETLB_PAGE */
>   
>   /*
> - * Verify the pagetables are still not ok after having reigstered into
> + * Verify the pagetables are still not ok after having registered into
>    * the fault_pending_wqh to avoid userland having to UFFDIO_WAKE any
>    * userfault that has already been resolved, if userfaultfd_read_iter and
>    * UFFDIO_COPY|ZEROPAGE are being run simultaneously on two different
> @@ -284,53 +290,55 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
>   	pmd_t *pmd, _pmd;
>   	pte_t *pte;
>   	pte_t ptent;
> -	bool ret = true;
> +	bool ret;
>   
>   	assert_fault_locked(vmf);
>   
>   	pgd = pgd_offset(mm, address);
>   	if (!pgd_present(*pgd))
> -		goto out;
> +		return true;
>   	p4d = p4d_offset(pgd, address);
>   	if (!p4d_present(*p4d))
> -		goto out;
> +		return true;
>   	pud = pud_offset(p4d, address);
>   	if (!pud_present(*pud))
> -		goto out;
> +		return true;
>   	pmd = pmd_offset(pud, address);
>   again:
>   	_pmd = pmdp_get_lockless(pmd);
>   	if (pmd_none(_pmd))
> -		goto out;
> +		return true;
>   
> -	ret = false;
>   	if (!pmd_present(_pmd))
> -		goto out;
> +		return false;
>   
> -	if (pmd_trans_huge(_pmd)) {
> -		if (!pmd_write(_pmd) && (reason & VM_UFFD_WP))
> -			ret = true;
> -		goto out;
> -	}
> +	if (pmd_trans_huge(_pmd))
> +		return !pmd_write(_pmd) && (reason & VM_UFFD_WP);
>   
>   	pte = pte_offset_map(pmd, address);
> -	if (!pte) {
> -		ret = true;
> +	if (!pte)
>   		goto again;
> -	}
> +
>   	/*
>   	 * Lockless access: we're in a wait_event so it's ok if it
> -	 * changes under us.  PTE markers should be handled the same as none
> -	 * ptes here.
> +	 * changes under us.
>   	 */
>   	ptent = ptep_get(pte);
> -	if (pte_none_mostly(ptent))
> -		ret = true;
> +
> +	ret = true;
> +	/* If missing entry, wait for handler. */
> +	if (pte_none(ptent))
> +		goto out;
> +	/* UFFD PTE markers require handling. */
> +	if (is_uffd_pte_marker(ptent))
> +		goto out;
> +	/* If VMA has UFFD WP faults enabled and WP fault, wait for handler. */
>   	if (!pte_write(ptent) && (reason & VM_UFFD_WP))
> -		ret = true;
> -	pte_unmap(pte);
> +		goto out;
>   
> +	ret = false;
>   out:
> +	pte_unmap(pte);
>   	return ret;
>   }
>   
> @@ -490,12 +498,13 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
>   	set_current_state(blocking_state);
>   	spin_unlock_irq(&ctx->fault_pending_wqh.lock);
>   
> -	if (!is_vm_hugetlb_page(vma))
> -		must_wait = userfaultfd_must_wait(ctx, vmf, reason);
> -	else
> +	if (is_vm_hugetlb_page(vma)) {
>   		must_wait = userfaultfd_huge_must_wait(ctx, vmf, reason);
> -	if (is_vm_hugetlb_page(vma))
>   		hugetlb_vma_unlock_read(vma);
> +	} else {
> +		must_wait = userfaultfd_must_wait(ctx, vmf, reason);
> +	}
> +
>   	release_fault_lock(vmf);
>   
>   	if (likely(must_wait && !READ_ONCE(ctx->released))) {
> diff --git a/include/asm-generic/hugetlb.h b/include/asm-generic/hugetlb.h
> index dcb8727f2b82..e1a2e1b7c8e7 100644
> --- a/include/asm-generic/hugetlb.h
> +++ b/include/asm-generic/hugetlb.h
> @@ -97,14 +97,6 @@ static inline int huge_pte_none(pte_t pte)
>   }
>   #endif
>   
> -/* Please refer to comments above pte_none_mostly() for the usage */
> -#ifndef __HAVE_ARCH_HUGE_PTE_NONE_MOSTLY
> -static inline int huge_pte_none_mostly(pte_t pte)
> -{
> -	return huge_pte_none(pte) || is_pte_marker(pte);
> -}
> -#endif
> -
>   #ifndef __HAVE_ARCH_HUGE_PTEP_SET_WRPROTECT
>   static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
>   		unsigned long addr, pte_t *ptep)
> diff --git a/include/linux/swapops.h b/include/linux/swapops.h
> index 2687928a8146..d1f665935cfc 100644
> --- a/include/linux/swapops.h
> +++ b/include/linux/swapops.h
> @@ -469,24 +469,6 @@ static inline int is_guard_swp_entry(swp_entry_t entry)
>   		(pte_marker_get(entry) & PTE_MARKER_GUARD);
>   }
>   
> -/*
> - * This is a special version to check pte_none() just to cover the case when
> - * the pte is a pte marker.  It existed because in many cases the pte marker
> - * should be seen as a none pte; it's just that we have stored some information
> - * onto the none pte so it becomes not-none any more.
> - *
> - * It should be used when the pte is file-backed, ram-based and backing
> - * userspace pages, like shmem.  It is not needed upon pgtables that do not
> - * support pte markers at all.  For example, it's not needed on anonymous
> - * memory, kernel-only memory (including when the system is during-boot),
> - * non-ram based generic file-system.  It's fine to be used even there, but the
> - * extra pte marker check will be pure overhead.
> - */
> -static inline int pte_none_mostly(pte_t pte)
> -{
> -	return pte_none(pte) || is_pte_marker(pte);
> -}
> -
>   static inline struct page *pfn_swap_entry_to_page(swp_entry_t entry)
>   {
>   	struct page *p = pfn_to_page(swp_offset_pfn(entry));
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index c0e716aec26a..da0b4fcc566f 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -479,4 +479,25 @@ static inline bool pte_swp_uffd_wp_any(pte_t pte)
>   	return false;
>   }
>   
> +
> +static inline bool is_uffd_pte_marker(pte_t pte)
> +{
> +	swp_entry_t entry;
> +
> +	if (pte_present(pte))
> +		return false;
> +
> +	entry = pte_to_swp_entry(pte);
> +	if (!is_pte_marker_entry(entry))
> +		return false;
> +
> +	/* UFFD WP, poisoned swap entries are UFFD handled. */
> +	if (pte_marker_entry_uffd_wp(entry))
> +		return true;
> +	if (is_poisoned_swp_entry(entry))
> +		return true;
> +
> +	return false;
> +}
> +
>   #endif /* _LINUX_USERFAULTFD_K_H */
> diff --git a/mm/hmm.c b/mm/hmm.c
> index a56081d67ad6..43d4a91035ff 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -244,7 +244,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>   	uint64_t pfn_req_flags = *hmm_pfn;
>   	uint64_t new_pfn_flags = 0;
>   
> -	if (pte_none_mostly(pte)) {
> +	if (pte_none(pte) || pte_marker_uffd_wp(pte)) {
>   		required_fault =
>   			hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0);
>   		if (required_fault)
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 1ea459723cce..01c784547d1e 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6743,29 +6743,28 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>   	}
>   
>   	vmf.orig_pte = huge_ptep_get(mm, vmf.address, vmf.pte);
> -	if (huge_pte_none_mostly(vmf.orig_pte)) {
> -		if (is_pte_marker(vmf.orig_pte)) {
> -			pte_marker marker =
> -				pte_marker_get(pte_to_swp_entry(vmf.orig_pte));
> -
> -			if (marker & PTE_MARKER_POISONED) {
> -				ret = VM_FAULT_HWPOISON_LARGE |
> -				      VM_FAULT_SET_HINDEX(hstate_index(h));
> -				goto out_mutex;
> -			} else if (WARN_ON_ONCE(marker & PTE_MARKER_GUARD)) {
> -				/* This isn't supported in hugetlb. */
> -				ret = VM_FAULT_SIGSEGV;
> -				goto out_mutex;
> -			}
> -		}
> -
> +	if (huge_pte_none(vmf.orig_pte))
>   		/*
> -		 * Other PTE markers should be handled the same way as none PTE.
> -		 *
>   		 * hugetlb_no_page will drop vma lock and hugetlb fault
>   		 * mutex internally, which make us return immediately.
>   		 */
>   		return hugetlb_no_page(mapping, &vmf);
> +
> +	if (is_pte_marker(vmf.orig_pte)) {
> +		const pte_marker marker =
> +			pte_marker_get(pte_to_swp_entry(vmf.orig_pte));
> +
> +		if (marker & PTE_MARKER_POISONED) {
> +			ret = VM_FAULT_HWPOISON_LARGE |
> +				VM_FAULT_SET_HINDEX(hstate_index(h));
> +			goto out_mutex;
> +		} else if (WARN_ON_ONCE(marker & PTE_MARKER_GUARD)) {
> +			/* This isn't supported in hugetlb. */
> +			ret = VM_FAULT_SIGSEGV;
> +			goto out_mutex;
> +		}
> +
> +		return hugetlb_no_page(mapping, &vmf);
>   	}
>   
>   	ret = 0;
> @@ -6934,6 +6933,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
>   	int ret = -ENOMEM;
>   	struct folio *folio;
>   	bool folio_in_pagecache = false;
> +	pte_t dst_ptep;
>   
>   	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON)) {
>   		ptl = huge_pte_lock(h, dst_mm, dst_pte);
> @@ -7073,13 +7073,14 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
>   	if (folio_test_hwpoison(folio))
>   		goto out_release_unlock;
>   
> +	ret = -EEXIST;
> +
> +	dst_ptep = huge_ptep_get(dst_mm, dst_addr, dst_pte);
>   	/*
> -	 * We allow to overwrite a pte marker: consider when both MISSING|WP
> -	 * registered, we firstly wr-protect a none pte which has no page cache
> -	 * page backing it, then access the page.
> +	 * See comment about UFFD marker overwriting in
> +	 * mfill_atomic_install_pte().
>   	 */
> -	ret = -EEXIST;
> -	if (!huge_pte_none_mostly(huge_ptep_get(dst_mm, dst_addr, dst_pte)))
> +	if (!huge_pte_none(dst_ptep) && !is_uffd_pte_marker(dst_ptep))
>   		goto out_release_unlock;
>   
>   	if (folio_in_pagecache)
> diff --git a/mm/mincore.c b/mm/mincore.c
> index 8ec4719370e1..151b2dbb783b 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -32,11 +32,22 @@ static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
>   	spinlock_t *ptl;
>   
>   	ptl = huge_pte_lock(hstate_vma(walk->vma), walk->mm, pte);
> +
>   	/*
>   	 * Hugepages under user process are always in RAM and never
>   	 * swapped out, but theoretically it needs to be checked.
>   	 */
> -	present = pte && !huge_pte_none_mostly(huge_ptep_get(walk->mm, addr, pte));
> +	if (!pte) {
> +		present = 0;
> +	} else {
> +		const pte_t ptep = huge_ptep_get(walk->mm, addr, pte);
> +
> +		if (huge_pte_none(ptep) || is_pte_marker(ptep))
> +			present = 0;
> +		else
> +			present = 1;
> +	}
> +
>   	for (; addr != end; vec++, addr += PAGE_SIZE)
>   		*vec = present;
>   	walk->private = vec;
> @@ -175,8 +186,8 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>   		pte_t pte = ptep_get(ptep);
>   
>   		step = 1;
> -		/* We need to do cache lookup too for pte markers */
> -		if (pte_none_mostly(pte))
> +		/* We need to do cache lookup too for UFFD pte markers */
> +		if (pte_none(pte) || is_uffd_pte_marker(pte))

Seems like something is changed, new is_uffd_pte_marker check will
miss non-UFFD markers (like guard markers) , and then would fall
through to the swap entry logic to be misreported as resident by
mincore_swap().

```
		/* We need to do cache lookup too for UFFD pte markers */
		if (pte_none(pte) || is_uffd_pte_marker(pte))
			__mincore_unmapped_range(addr, addr + PAGE_SIZE,
						 vma, vec);
		else if (pte_present(pte)) {
			unsigned int batch = pte_batch_hint(ptep, pte);

			if (batch > 1) {
				unsigned int max_nr = (end - addr) >> PAGE_SHIFT;

				step = min_t(unsigned int, batch, max_nr);
			}

			for (i = 0; i < step; i++)
				vec[i] = 1;
		} else { /* pte is a swap entry */
			*vec = mincore_swap(pte_to_swp_entry(pte), false);
		}
```

Wouldn't the generic is_pte_marker() be safer here?

Thanks,
Lance

>   			__mincore_unmapped_range(addr, addr + PAGE_SIZE,
>   						 vma, vec);
>   		else if (pte_present(pte)) {
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 00122f42718c..cc4ce205bbec 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -178,6 +178,7 @@ int mfill_atomic_install_pte(pmd_t *dst_pmd,
>   	spinlock_t *ptl;
>   	struct folio *folio = page_folio(page);
>   	bool page_in_cache = folio_mapping(folio);
> +	pte_t dst_ptep;
>   
>   	_dst_pte = mk_pte(page, dst_vma->vm_page_prot);
>   	_dst_pte = pte_mkdirty(_dst_pte);
> @@ -199,12 +200,15 @@ int mfill_atomic_install_pte(pmd_t *dst_pmd,
>   	}
>   
>   	ret = -EEXIST;
> +
> +	dst_ptep = ptep_get(dst_pte);
> +
>   	/*
> -	 * We allow to overwrite a pte marker: consider when both MISSING|WP
> -	 * registered, we firstly wr-protect a none pte which has no page cache
> -	 * page backing it, then access the page.
> +	 * We are allowed to overwrite a UFFD pte marker: consider when both
> +	 * MISSING|WP registered, we firstly wr-protect a none pte which has no
> +	 * page cache page backing it, then access the page.
>   	 */
> -	if (!pte_none_mostly(ptep_get(dst_pte)))
> +	if (!pte_none(dst_ptep) && !is_uffd_pte_marker(dst_ptep))
>   		goto out_unlock;
>   
>   	if (page_in_cache) {
> @@ -583,12 +587,15 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
>   			goto out_unlock;
>   		}
>   
> -		if (!uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE) &&
> -		    !huge_pte_none_mostly(huge_ptep_get(dst_mm, dst_addr, dst_pte))) {
> -			err = -EEXIST;
> -			hugetlb_vma_unlock_read(dst_vma);
> -			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
> -			goto out_unlock;
> +		if (!uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE)) {
> +			const pte_t ptep = huge_ptep_get(dst_mm, dst_addr, dst_pte);
> +
> +			if (!huge_pte_none(ptep) && !is_uffd_pte_marker(ptep)) {
> +				err = -EEXIST;
> +				hugetlb_vma_unlock_read(dst_vma);
> +				mutex_unlock(&hugetlb_fault_mutex_table[hash]);
> +				goto out_unlock;
> +			}
>   		}
>   
>   		err = hugetlb_mfill_atomic_pte(dst_pte, dst_vma, dst_addr,


