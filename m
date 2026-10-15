Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C971CCC6B2F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 08:34:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDD196B009D; Thu, 15 Oct 2026 04:34:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB47B6B009E; Thu, 15 Oct 2026 04:34:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA39D6B009F; Thu, 15 Oct 2026 04:34:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA27F6B009D
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:34:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B1EA41208CD
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:34:09 +0000 (UTC)
X-FDA: 85324198218.21.6859B67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0EDA440002
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:34:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aaZgNvMA;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792053248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1y2O0PSZS5Bzt/8EZ2Y7b6A1XzbAJe0MR4Va/N0YUuU=;
	b=INaJNiiDjYHTdG3oJ3ZwbmdUwhbBrZUEWhStIwx6tNbnCj3g4ReYWcNJHjFZscmwnGZZly
	UeRZGQFptumODP+5bu0YfPVwT4lGKljSX04VN7TiPBzfw4NjYSwGyESNoD24P1k9HNEITk
	w3S6s931d1MDY0PBA9HAOw9bsBKeEWo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aaZgNvMA;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792053248;
	b=ld/8yaXLhnUaK+U3KikgYDU2XiDr8rIKHT6RDhMuPMglpYsZBddRsqUKZkDkGi6mhLnVOL
	e9+XnDk5+/2XWPZg7twW4oI/OVgKgNNhEuVCuvLNwQAm5kes0wLqauh9Vj2HZ5MPtnFVSh
	6DHbSWmLbrZZ2jJxW5MKYhhvo6+cxK8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F1EF843708;
	Thu, 15 Oct 2026 08:34:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8351F000C4;
	Thu, 15 Oct 2026 08:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792053246;
	bh=1y2O0PSZS5Bzt/8EZ2Y7b6A1XzbAJe0MR4Va/N0YUuU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aaZgNvMANpmUBSrs1hVX5dOBdZ5ubITsPMpzYC6ohqDfmcGNBK0HFP5IIu9enoq6P
	 M90gmP2DGfFq7fJBhjZXldmj7fCOobTX9AHeFQzYBu4OsHOqAPJJq89m5d2JBMLE6d
	 IX1ZzHm67oSWuDWCK9DW06xW9l7a/FAvXx9Q0KKpdbq+YUXOZRCJUzJGIofXanWSnG
	 iZqjvsZlDyceUmFP40JWDI0N5xbgR0TDu1XDbh4oGorzXB8pv2C4VsUYL7MtPYDwtv
	 9k/hkPAULu7KSk8UF8gOha7el2Ie8z8fXbCfvm6aqqNh3aAxRqU6ts/NigbqVxw8SM
	 fCAorPY+owbwQ==
Date: Thu, 15 Oct 2026 11:33:58 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>, Miaohe Lin <linmiaohe@huawei.com>,
	Lokesh Gidra <lokeshgidra@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Kyle Zeng <kylebot@openai.com>, Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/userfaultfd: only allocate anon_vma in CoW mappings
Message-ID: <atCP9hqNdqsdE-y4@kernel.org>
References: <20261014-copy_hugetlb_page_range-v1-1-5b68e03fe7fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-copy_hugetlb_page_range-v1-1-5b68e03fe7fe@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0EDA440002
X-Rspam-User: 
X-Stat-Signature: qpg5jbcc9op3wybgz939734zkspcjr3a
X-HE-Tag: 1792053247-990946
X-HE-Meta: U2FsdGVkX1//jpp+bx6t7C1IZUg1ijcHoBdqIpQaXIx6y9p6EJmqiORaciBfUjj/GP+KD+gV+JQIaPsEFJcfsDnWRlHAP1r9DEjtDodD7grZB5aLzXABfmzWcT48bioVtTfuLBPj/DCbZYgrj3XUQGS/uOb6aBNYFn3XtrKeTDlBjV3kLJ9wUlBU+qCkdXE9iLlh2qURfybyOi88MJjN4zR+ulvMaYYHebavwNCloPrOG+61guIMRelRq7wsLtUnlLE+XwIwWqwSkQaGrp6+VA34N5kLaquFWivcoDGsNdxeYrFJQL4+7zAfi020aVZPnpEAFB71SG7iFAdeVk8sZT1tVYKqLH2FI2DaA4qHlVSGBmYpLZqTNu06kwJGIX+efwkWeFdG8mD8aAotelQ5a/r57hIQlMUkwNkP2WAQzNNya4COxfn4zTv/9/p6lXc0inemtZeWeAXEWz2QDyk2NeteLAQkYSHPKHhSrWpI//DSq+0IJsP5A2mqWFDHzzLY++1RfG+VfgaRClFGvrsGUlYzMBF0iRZ7P8jZAMVjTu9fbOvIAxzOXggrjJ5XeEMS5emSvy1UJAA5EbOmr4N0q/IJ0T/iDtbqIalLGHvlyIs2V4IlIJlBecJTSz4pLzV4db3DMz2hAftUXBVT3hqygnWa4qqhR3bkfwjVnDbPAIUvvHmJmxptH91RjqqDMHAh9/rvYKgaVCqHvgeLK/Rcn5wafagbErQbCmhxLIZVskptEhmxrfXMWOtIbkejLRK/oGM0NioRdmjQ6sfxjo127Nr7w90V9tnTCzjYzX/wq0yEN/f0QSZwK3MjkoxpSomIDxFLJdBk+dZcr28cluS0EBFbJ5T1dsoq6/kEloDasG8/gnwMiqIHQ9HoNEsIjOqUfwZFe0mCLFPFK5XjfJFPNdhjpNI6on9655kfyCydffxQ6WngyYjsFkZQ9CUCT481wZe2PM4oA0qInbeb+AS
 NrtcSO5J
 pl4x6KsNLul5CSq3cUdJCU50rYWx81Qz1uCRagBzjfhVTsa7MM57sA69ySvv5o9hrZv3VT7i1/cSbYgfG9n1AsJeQDJt/LyRRMv8+PMz9ZaPwUC43LRm4yDIvVf3xpdumQxI7Wf6N3Tyx7gbyujVrQASWrMaUbHFSeCqRnvfAo5RoGn/aPUCjQRpFLurmpCnNSodFzqN4QuL5o0+ah3K/R9SNFYP4p+r7EnQysS9ANeMLib50jwqXhpVGutlyIHVXRWJtLbvhXr4AZ2tQ4t8T3MNOr3lgRPBb8eXObLtOODvt5HHezifZbULOMSoVtsNz8n/MtcKacd6TC2HHpn3/JWKPBj9EbB8znB+q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 01:53:11PM +0200, David Hildenbrand (Arm) wrote:
> find_vma_and_prepare_anon() can end up allocating an anon_vma in VMAs that
> are not CoW mappings, which is wrong.
> 
> If we have a MAP_SHARED R/O file mapped, we lack VM_SHARED (but do have
> VM_MAYSHARE) and lack VM_MAYWRITE.
> 
> While uffd later rejects such mappings (uffd registration requires
> VM_MAYWRITE, see comment in validate_dst_vma) find_vma_and_prepare_anon()
> still wrongly allocates an anon vma before it validates the vma.
> 
> This in turn later confuses copy_page_range()->vma_needs_copy() such
> that we end up calling copy_hugetlb_page_range() with ranges that
> actually do not contain *any* per-pagetable information that would
> require copying, which is the basis for PMD-table sharing in the first
> place.
> 
> copy_hugetlb_page_range() should not have to worry about shared
> PMD tables at all: it doesn't make any sense to copy page tables that are
> shared, as they can be fully recreated later. Ending up in the function
> with shareable page tables is the real issue.
> 
> If a destination PMD table is shared in copy_hugetlb_page_range(), it
> might get concurrently unshared as we are not holding relevant
> locks, resulting in us using a page table that is no longer mapped and
> possibly freed after calling:
> 
> 	dst_pte = huge_pte_alloc(dst, dst_vma, addr, sz);
> 
> To fix it, do not allocate an anon_vma in non-CoW mappings and add a
> safety guard to copy_hugetlb_page_range(), making sure that we never
> end up messing with shared PMD tables in there.
> 
> Before commit 867a43a34ff8a ("userfaultfd: use per-vma locks in userfaultfd
> operations") we would always validate the VMA before allocating an
> anon_vma, and consequently never wrongly allocate an anon_vma.
> 
> As uffd_lock_vma() is part of the same lookup machinery and
> also contains a misleading VM_SHARED check, change that one as well
> directly for consistency.
> 
> A follow-up cleanup will stop taking the hugetlb_vma_lock_read(src_vma)
> lock in copy_hugetlb_page_range() entirely. Further, the usage of
> VM_SHARED in userfaultfd code should be cleaned up later to focus on
> CoW vs. non-CoW mappings.
> 
> Reported-by: Kyle Zeng <kylebot@openai.com>
> Fixes: 867a43a34ff8a ("userfaultfd: use per-vma locks in userfaultfd operations")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/hugetlb.c     | 24 ++++++++++++------------
>  mm/userfaultfd.c |  5 ++---
>  2 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 63dc836061c99..60f9b209c8db1 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4984,10 +4984,11 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
>  		raw_write_seqcount_begin(&src->write_protect_seq);
>  	} else {
>  		/*
> -		 * For shared mappings the vma lock must be held before
> -		 * calling hugetlb_walk() in the src vma. Otherwise, the
> -		 * returned ptep could go away if part of a shared pmd and
> -		 * another thread calls huge_pmd_unshare.
> +		 * Shared mappings only need copying when we could have
> +		 * information stored in page tables (e.g., userfaultfd PTE
> +		 * bits or markers), which is incompatible with PMD sharing.
> +		 * Still take the hugetlb VMA lock for now to satisfy
> +		 * hugetlb_walk()'s locking requirements.
>  		 */
>  		hugetlb_vma_lock_read(src_vma);
>  	}
> @@ -4995,6 +4996,13 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
>  	last_addr_mask = hugetlb_mask_last_page(h);
>  	for (addr = src_vma->vm_start; addr < src_vma->vm_end; addr += sz) {
>  		spinlock_t *src_ptl, *dst_ptl;
> +
> +		if (WARN_ON_ONCE(want_pmd_share(src_vma, addr) ||
> +				 want_pmd_share(dst_vma, addr))) {
> +			ret = -EINVAL;
> +			break;
> +		}
> +
>  		src_pte = hugetlb_walk(src_vma, addr, sz);
>  		if (!src_pte) {
>  			addr |= last_addr_mask;
> @@ -5006,14 +5014,6 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
>  			break;
>  		}
>  
> -#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
> -		/* If the pagetables are shared, there is nothing to do */
> -		if (ptdesc_pmd_is_shared(virt_to_ptdesc(dst_pte))) {
> -			addr |= last_addr_mask;
> -			continue;
> -		}
> -#endif
> -
>  		dst_ptl = huge_pte_lock(h, dst, dst_pte);
>  		src_ptl = huge_pte_lockptr(h, src, src_pte);
>  		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 0e0fe9bfef239..82b56a58fc40d 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -115,8 +115,7 @@ struct vm_area_struct *find_vma_and_prepare_anon(struct mm_struct *mm,
>  	vma = vma_lookup(mm, addr);
>  	if (!vma)
>  		vma = ERR_PTR(-ENOENT);
> -	else if (!(vma->vm_flags & VM_SHARED) &&
> -		 unlikely(anon_vma_prepare(vma)))
> +	else if (vma_is_cow_mapping(vma) && unlikely(anon_vma_prepare(vma)))
>  		vma = ERR_PTR(-ENOMEM);
>  
>  	return vma;
> @@ -145,7 +144,7 @@ static struct vm_area_struct *uffd_lock_vma(struct mm_struct *mm,
>  		 * We know we're going to need an anon rmap, so check that
>  		 * early.
>  		 */
> -		if (!(vma->vm_flags & VM_SHARED) && unlikely(!vma_has_anon_rmap(vma)))
> +		if (vma_is_cow_mapping(vma) && unlikely(!vma_has_anon_rmap(vma)))
>  			vma_end_read(vma);
>  		else
>  			return vma;
> 
> ---
> 
> base-commit: 1d0b04a60516de48250b04227dcf483c6c09aab1
> 
> change-id: 20261014-copy_hugetlb_page_range-743d71a2980e
> 
> --
> 
> Cheers,
> 
> David
> 

-- 
Sincerely yours,
Mike.

