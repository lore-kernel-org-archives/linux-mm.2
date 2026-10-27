Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93364606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HUTOmsFy
Received: by kanga.kvack.org (Postfix)
	id 84A006B0642; Tue, 27 Oct 2026 05:01:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 821BE6B0643; Tue, 27 Oct 2026 05:01:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75E266B0644; Tue, 27 Oct 2026 05:01:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E43B6B0642
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:01:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8BA411609B6
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:01:01 +0000 (UTC)
X-FDA: 85367811522.15.7377CB3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id E44E4C0002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:00:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HUTOmsFy;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793091659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+/MYNnK8DUYGBHVGnq4qUIdmGywNXoT3ALheU2qVv/c=;
	b=Ad8ACjOMls5o9lwVfTd4EXj3KrBtgnXw61rtWST62lJtAEYYBZ1PoDR9b9EUppc6TpXucX
	7RS49iNNIYiNx18QbTHKLydO7bKG/+2YqSmOs0M16PDrMKTZZ/sq8nxfnw0GjpIoGAz9mo
	lPLdQvpV4Tx0JXHjJY4sCrI+oCVahkg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HUTOmsFy;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793091659;
	b=o8tS99OC7tOAVxWQPeYPmuxrTf1M6ZEfZH7FrwLmrUDuQAMnU8cUcNJFnINjLpjLOHxRvG
	A9KIK5zmB5MNfoe+34/iee8hHNOC+IE65SwASnpbCK/xcaloAuUY/Uv+q3JqyjyadT6/op
	Rcyh02uOtRMvkzHw3a8mv9L6EzxbnSU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5FA4F601FB;
	Tue, 27 Oct 2026 09:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF751F01825;
	Tue, 27 Oct 2026 09:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793091659;
	bh=+/MYNnK8DUYGBHVGnq4qUIdmGywNXoT3ALheU2qVv/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HUTOmsFyCwPQlGk/S3zhcBsAr8cTW5+2CMv1yjmQ6bUinDyX4V2yoyFNvwh/1e4vu
	 WWZFki+IFbYa6GHlzdddV7MD0+qRWb/ngFAwumTPrtciRUO/TvbRGR76BWTZAMzjNJ
	 sxed1QvHde9n6j10JT+/P5Nm6k2T+ehhCipyLd8HeSRDyP2Be1vNrimizTUNLj8Xdv
	 X9//cUF85Th1QcwuAXwXIE1H46VW0MVSngyvyxMII5vUYrOAGMVeVZ31+LhIFniCg7
	 TfNEaoOTUBZGhMDoF8r+JAL/PH0j7gsvkfsNDpYR3FDXt5ASODJOgcrap9BS2uyPd9
	 QgBAmExgEHVAw==
Date: Tue, 27 Oct 2026 09:00:41 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, Chris Mason <mason@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 40/46] mm/ksm: check large swap-cache folios before
 mapping them
Message-ID: <auBnb7gpqVIg0wzL@gremlin>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-40-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-40-6f74bec9a5bb@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E44E4C0002
X-Stat-Signature: a3cjfu4tpfjw494qkj8yf4qm4x5fkzhx
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793091659-294328
X-HE-Meta: U2FsdGVkX1+nP0QXerGy3HHF+1mvva2HflzLlQg9f8ouAG1a23gmBt5YGBNuBqFoNA2q7eRyjHinPCs3iF9Amj0djxLKYckHMgAJFk4mM9E7FjUn9w1cWxkMOzqS3e4ZAMIkwFinBeCCS5b9h7PN0ozhxUMRBZ1MEgKSAm62KgjxaqNbQ256sJSqmsvO+ySec5KmQO5tfUIC9EQQAEFDhfGShRVzrhnHN2AwMoPCRLC0P9zMUooS+QGW5Owlb5nJlLDquQi4WVGDWL2V9HvSg8c6zXQZchpmmONzc9DeqLygnu4IS4d/j6/c+ZgnFWWEV410ydVl+bthtga6o8dfabKiAHImEo0jQyb9iqAZIp9P2K3C5evAONRTRCuTtw/frlh0gfbA8PTaAYKZrErPqzxLUHUJOMQrD9wcogvUdgylZOM+iAn2TfJrkjmCkM6E+esc6B1GNuntQoa+bx7xeWS+Tic217ni9/zJAd2mgsGEvwNasKGc/qugqsW0NXcXk/LfMjPdXTSUZ/CDqPvG/sadpLbLLdpRmSJOkvcbGI/o9/DQEOj252lgnpqJ4vARhYSDQ7g43ZmLHN9DxhSTD9I9KzDOGlVnK+Bxc/2iAeqCjdJxMNO1GGqV5DHU54Wqsb4J8pgE8hH9J36+7iEGGOcod7nhR8PRhxqHnEDyRaCv1BHh+HhL70qS1XkKdtO2fHFtjRWwP+9ZxDHGJTgI3BbDW33PjPMCnxgWsI1z8l+fTt1zSAD4qExNyW3wBoxB9DGJJ3Af2qnLwmzcnZ5JXoFtH4SEYBwPoXaJ2tfnQXVixXO3e36tt64stLbi1sM3cNajrxUieHRUN6arMnf2jQG3Hu1fIu5Rz+oNN6/bo1RN8E+PKbGpbEJdXrJ/haQRc2h2KzoFkODCUXwMGVoCvrl5puiqkNWq9BrC9h3dw6Un/xvrI5Dc9Tneyqfkj7gaGwNTVY5R97K1pLQ+4tI
 dQISb8j3
 2QEWNt1If9T5RUvKuBhppmL1z8i7Wn3fT/LnEdVdZNicdy9lLw37jFAJ7Q9+TqgjBJftOGCmhuem7/pBMeqe0m0vNqElgyGMzdiJjIITKijNghSp0etvzCusXLZPbyqcNRuKbRTsj4bXMaQDfA3lCbGW7jEeRC7XszGVP+WDzykprPCxcJzdwmfYUh5X4QNDL9FT8SGTeji/GLCX9giMb92IjCzLZiPjfeMGSnTL2xLnzoK1bAeSGeri+k8jBpKlFuehYGaQOjyHiJ5C+zL8anXO19Fjx/TZiss6AGxejcxEeo86CAPlJkmXcB4qAb2tOqcspWSiu6ggnoWgbMY4+uKJnqVnCz602yorG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:18:00AM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
>
> KSM folios are always small, but their shared swap slots can be read
> back as part of a large folio in the swap cache. ksm_might_need_to_copy()
> skips large folios, so another process can map a page with an incompatible
> anon_vma or page index. Reverse mapping then cannot find the new
> mapping, preventing migration or reclaim.
>
> Apply the same compatibility checks to large folios as to small ones.
> Pass the page corresponding to the swap entry and copy only that page
> when necessary. In do_swap_page()'s copy path, decrement only that slot's
> swap count, because the source swap-cache folio can now be large.
>
> Fix generated by an LLM and sent by Chris Mason in private.
>
> Fixes: f1879e8a0c60 ("mm, swap: never bypass the swap cache even for SWP_SYNCHRONOUS_IO")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

As reviewed off-list :)

All very, very horrifying, but I convinced myself that swapped-in large folios
containing previously-order-0 KSM pages _are_ real and _can_ hurt you...

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/ksm.h |  6 +++---
>  mm/ksm.c            | 22 ++++++++++++----------
>  mm/memory.c         |  5 +++--
>  mm/swapfile.c       |  3 ++-
>  4 files changed, 20 insertions(+), 16 deletions(-)
>
> diff --git a/include/linux/ksm.h b/include/linux/ksm.h
> index d39d0d5483a23..a0d358a1feb63 100644
> --- a/include/linux/ksm.h
> +++ b/include/linux/ksm.h
> @@ -91,8 +91,8 @@ static inline void ksm_exit(struct mm_struct *mm)
>   * We'd like to make this conditional on vma->vm_flags & VM_MERGEABLE,
>   * but what if the vma was unmerged while the page was swapped out?
>   */
> -struct folio *ksm_might_need_to_copy(struct folio *folio,
> -			struct vm_area_struct *vma, unsigned long addr);
> +struct folio *ksm_might_need_to_copy(struct folio *folio, struct page *page,
> +		struct vm_area_struct *vma, unsigned long addr);
>
>  void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc);
>  void folio_migrate_ksm(struct folio *newfolio, struct folio *folio);
> @@ -145,7 +145,7 @@ static inline int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
>  }
>
>  static inline struct folio *ksm_might_need_to_copy(struct folio *folio,
> -			struct vm_area_struct *vma, unsigned long addr)
> +		struct page *page, struct vm_area_struct *vma, unsigned long addr)
>  {
>  	return folio;
>  }
> diff --git a/mm/ksm.c b/mm/ksm.c
> index e050b1bdf810d..e95f6b6723602 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -3138,19 +3138,20 @@ void __ksm_exit(struct mm_struct *mm)
>  }
>
>  static bool folio_anon_rmap_compatible(const struct folio *folio,
> -		struct vm_area_struct *vma, unsigned long addr)
> +		const struct page *page, struct vm_area_struct *vma,
> +		unsigned long addr)
>  {
>  	const struct anon_vma *anon_vma = folio_anon_vma(folio);
>  	struct anon_vma_chain *avc;
>
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> -	VM_WARN_ON_ONCE_FOLIO(folio_test_large(folio), folio);
> +	VM_WARN_ON_ONCE_FOLIO(page_folio(page) != folio, folio);
>  	VM_WARN_ON_ONCE_FOLIO(folio_test_ksm(folio), folio);
>  	vma_assert_stabilised(vma);
>
>  	if (!anon_vma)
>  		return true;
> -	if (folio->index != linear_anon_page_index(vma, addr))
> +	if (page_pgoff(folio, page) != linear_anon_page_index(vma, addr))
>  		return false;
>
>  	/*
> @@ -3167,20 +3168,21 @@ static bool folio_anon_rmap_compatible(const struct folio *folio,
>  	return false;
>  }
>
> -struct folio *ksm_might_need_to_copy(struct folio *folio,
> -			struct vm_area_struct *vma, unsigned long addr)
> +struct folio *ksm_might_need_to_copy(struct folio *folio, struct page *page,
> +		struct vm_area_struct *vma, unsigned long addr)
>  {
> -	struct page *page = folio_page(folio, 0);
>  	struct folio *new_folio;
>
> -	if (folio_test_large(folio))
> -		return folio;
> -
> +	/*
> +	 * A KSM folio is small, but the slot that it left behind can be swapped
> +	 * in as a part of a large folio by one of the processes that shared it.
> +	 * So test, and copy, the page of the slot.
> +	 */
>  	if (folio_test_ksm(folio)) {
>  		if (folio_stable_node(folio) &&
>  		    !(ksm_run & KSM_RUN_UNMERGE))
>  			return folio;	/* no need to copy it */
> -	} else if (folio_anon_rmap_compatible(folio, vma, addr)) {
> +	} else if (folio_anon_rmap_compatible(folio, page, vma, addr)) {
>  		return folio;		/* still no need to copy it */
>  	}
>  	if (PageHWPoison(page))
> diff --git a/mm/memory.c b/mm/memory.c
> index 230a2f4dafa13..be4c05db37d33 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5096,7 +5096,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  	 * folio->index of non-ksm folios would be nonlinear inside the
>  	 * anon VMA -- the ksm flag is lost on actual swapout.
>  	 */
> -	folio = ksm_might_need_to_copy(folio, vma, vmf->address);
> +	folio = ksm_might_need_to_copy(folio, page, vma, vmf->address);
>  	if (unlikely(!folio)) {
>  		ret = VM_FAULT_OOM;
>  		folio = swapcache;
> @@ -5278,7 +5278,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  	if (unlikely(folio != swapcache)) {
>  		folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
>  		folio_add_lru_vma(folio, vma);
> -		folio_put_swap(swapcache, NULL);
> +		folio_put_swap(swapcache,
> +			       folio_file_page(swapcache, swp_offset(entry)));
>  	} else if (!folio_test_anon(folio)) {
>  		/*
>  		 * We currently only expect !anon folios that are fully
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 254ce86fa923e..71ef9e2efb3a9 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2514,7 +2514,8 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
>  		return 0;
>
>  	swapcache = folio;
> -	folio = ksm_might_need_to_copy(folio, vma, addr);
> +	folio = ksm_might_need_to_copy(folio,
> +				       folio_file_page(folio, swp_offset(entry)), vma, addr);
>  	if (unlikely(!folio))
>  		return -ENOMEM;
>  	else if (unlikely(folio == ERR_PTR(-EHWPOISON))) {
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

