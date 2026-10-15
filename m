Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DA20CC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 19:45:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A70F6B008C; Thu, 15 Oct 2026 15:45:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1310A6B0092; Thu, 15 Oct 2026 15:45:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 046E36B0095; Thu, 15 Oct 2026 15:45:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC8D86B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:45:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 42A19140107
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:45:56 +0000 (UTC)
X-FDA: 85325891112.08.2BA8CFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8F31A160009
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:45:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bcqd+HH2;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792093554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kTFEZ49kr33oEAdO5drlS9BF04qwOVSn+b6FDU6toc8=;
	b=XexbJv4jAYCEjf+QUfLG5Ryy/GrGTvxHRNFcwOW8RTXyMyfgd+Lu/l24eI/8VoNUUcATLT
	qjJyO1gQRmVeZNwm1/iT5SNV+xrcb9LW/+v/miPgnnHy1PrsRtL43TQ4wnZjEaFKKfWwGu
	NizfpilbKCyvy/Q2484E3TYRw+uP4g4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bcqd+HH2;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792093554;
	b=N43tV6KIyceaA7jpg7e+IFomNepBHS5AXPX2/AWSaJ5ayPGldyNopH4g4OlNc45iwS2qCl
	lPe7RFzk8MchPo2yQz4aA9HLUA6G34tUkI1ukovgIScs5c8avNvWm1gIZECts56zl7/AIR
	t3DL6bQCU/8HeKxGcE6E2Ih/YV2FEOs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C1321407A7;
	Thu, 15 Oct 2026 19:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10FC1F000C4;
	Thu, 15 Oct 2026 19:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792093553;
	bh=kTFEZ49kr33oEAdO5drlS9BF04qwOVSn+b6FDU6toc8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Bcqd+HH2iwmj6Pwil0HmsygLrhCeYDX7C6OFeH/xUu7GGXjOwTO62tiPu/T2BjKw0
	 7zPETfQ3FjJHaJwk5s5MWu1XcAo82trouQ8l9I9ysLxWyEMHYb7id1ROAoCL4ChnBH
	 7NR9iyk5XjbQNPG4SRgGuEcRkY428k4lbCfWTmb4Xbgvs+nzR3D4B9nr6mBkLQpaXt
	 EN1UIA5AuSL4WeeuREVvhml+oJLHggN50OtTAcwF3nxYJnGx+L/RSZCIN0pVqQSXfP
	 l65/hfj7vA5XaZMeDO92UtYe7lXgWgnDaBKzS5xWQ/LXabdaW3TUp+hp1cSse8L0Ai
	 Xs2k320TrAhOA==
Date: Thu, 15 Oct 2026 20:45:46 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Adam Litke <agl@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@surriel.com>, 
	Peter Xu <peterx@redhat.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, Chris Mason <mason@kernel.org>
Subject: Re: [PATCH 09/10] mm/hugetlb: don't leave a uffd-wp marker when
 zapping an RWP entry
Message-ID: <atEtMwg6_2KERFTr@gremlin>
References: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
 <20261015-urgent_fixes-v1-9-42796911043b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015-urgent_fixes-v1-9-42796911043b@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8F31A160009
X-Rspam-User: 
X-Stat-Signature: re6rktzf1e1nmw9xpfsppffdajfuj178
X-HE-Tag: 1792093554-373246
X-HE-Meta: U2FsdGVkX198V1dZ/+jEn4XCvKQUwSZshsmGazekUepd2CJ4OYbs11pL1Toie/by0M/0HaDWFSKXW3sBPfMQxr1UaBJx7D8pNg9pc1xWKE62TFlbh8R64xCox6ZWQkAYE4sCRohEq7XhibtrWh2ZYe8WwpKcdfo8N6nNnS9HGLyo4Bh6cKZf9KNa0pXt2nXX3v35lG/1xhuYOTZc8oweMn5Sg6quTbuwj0z8ieISyl5mWgYJjAM0V1+AHF1Cv13i0ceXNPismV95ZusMkhUWAd6zF3txaalGCDZVCkPb/0Xn4VWUIdX6gqPINLBSKQHegk3NTNvy+ip2Yd6LYMMoaOouI0bmihIiIGsje4W5gBpz1j9VoRz4EroW83qpIm3cfH0/HA6OWOP8cS1wGYMkLavlDRl0yVFlOIjlTGd6bZKLL4Y23HxAvSfAvv5Lw3jcjE2N4Fe8no9HNVzj58RUzyLZ1c9EOBSkg+WaVULN70mFYSvzRrst+OXsaLqFS+1JAqVspNaEjmWfuwDCoQdMZR3nBkcYCWUQVkdjbSvEhRKmREWCETDfk3LJyYMMXmJJyL/6nQHbTETuJcQv/40sIOB9zVdsQM3Pxo2gHxd4H0DiW++nVelPhCzSEwZkt3uJQ15IJRTShrUeXEDTJia4M5bMKLly3bh5myo4LeGo9wd8BTD+LTWWVQ/P1M6THgnm2FhtjTqRbB+HkSV2aMKLtiFJpZLjt4l0FcYikR0zNtAkCxwPK2Wb+6bLCIO3fgEQAr40CJ57L3S4KmJqU8NxeEF0PZrIQaqXMPIbkJB4gPjElwnxIOwujczy/6bXxGozcIPveyksI/0530fI+XHFPqzgEssrzOXwYUwEZc5II/iUVvz7cm8LNjAO544iGYXyJJhSplRI8w82Tk6f0fLjZWwB3oid5F1usd3jjzmcQoFjOY945SB8simOW+2giVGC3mZGiyDXPXkg6m8Bkj6
 QpMLNtFH
 yB+NgU8FMv1Az891OjwOS0zAOmIAoEkzSz7BLYWyImG83M+wcjfksQCNtNa1fMZR42dZVkH12d6grVJIZDKUmiLT1cJaOuugRx0k1SWgdvDk3Tn8JvnthCtqZSVSnO1hIGShhzHqQDt/GF4P8xZQcRhwaW6FRHhhIrPB87FQS5NLUXm2XewFHSMlufpSNloR+cU2w24UayhUPS/Gjn0DYSEO2AcQTNrJTIBzWzW6OzOGnOLjS/XNlR69zjcJG9zaEFqgpWR9YidFaEZjWQZnGG/U4nXlBM6LLd3WiZNQx3Kxop6QDSccYNKeKKyTYxlt51k6nZ2PgqimeG6PqcCi7pAs3GkeFNm91ETc/nj7LHbSLxwpQpREGK60I6d+M6CeuFM/viCR3OzWwaGysQ19xqC8oFCVESb7nLkHk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 06:07:15PM +0200, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
>
> An entry that is protected with UFFDIO_RWPROTECT is PAGE_NONE with the
> uffd bit set, the bit that userfaultfd write protection uses too.  When
> __unmap_hugepage_range() zaps an entry with that bit it leaves a
> PTE_MARKER_UFFD_WP behind, whatever the VMA is registered for.
>
> In a VMA registered with UFFDIO_REGISTER_MODE_RWP that marker means
> nothing.  The next fault has hugetlb_no_page() turn it into a present,
> read-only entry with the uffd bit.  That is not an RWP entry, since it is
> not PAGE_NONE, and the VMA has no VM_UFFD_WP (the two modes can not be
> registered together).  An earlier fix solved some side effects, now just
> stop the zap from wrongly installing a marker.
>
> Leave a marker only if the VMA is registered for write protection, both
> for present and for non-present entries.  The zap of ordinary page
> tables has the same test, in cond_install_uffd_wp_ptes(), and
> hugetlb_change_protection() says that "uffd_rwp does not install markers".
>
> After a zap the range of an RWP VMA is simply empty, as it is for
> anonymous memory and shmem.  Nothing changes for VMAs with VM_UFFD_WP.  In
> a VMA that is not registered at all a leftover uffd bit or marker is now
> dropped by the zap and no longer kept alive.
>
> Original fix generated by an LLM and sent in private by Josef.
>
> Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
> Cc: stable@vger.kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: a bit of description overhaul+simplification ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Seems sensible to me so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/hugetlb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 1548a6156206b..fb51f7d02cebf 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5267,7 +5267,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  			 * drop the uffd-wp bit in this zap, then replace the
>  			 * pte with a marker.
>  			 */
> -			if (pte_swp_uffd_any(pte) &&
> +			if (userfaultfd_wp(vma) && pte_swp_uffd_any(pte) &&
>  			    !(zap_flags & ZAP_FLAG_DROP_MARKER))
>  				set_huge_pte_at(mm, address, ptep,
>  						make_pte_marker(PTE_MARKER_UFFD_WP),
> @@ -5303,7 +5303,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  		if (huge_pte_dirty(pte))
>  			folio_mark_dirty(folio);
>  		/* Leave a uffd-wp pte marker if needed */
> -		if (huge_pte_uffd(pte) &&
> +		if (userfaultfd_wp(vma) && huge_pte_uffd(pte) &&
>  		    !(zap_flags & ZAP_FLAG_DROP_MARKER))
>  			set_huge_pte_at(mm, address, ptep,
>  					make_pte_marker(PTE_MARKER_UFFD_WP),
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

