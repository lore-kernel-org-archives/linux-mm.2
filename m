Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80A29109190B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E61B66B0586; Thu, 19 Mar 2026 14:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E393A6B0588; Thu, 19 Mar 2026 14:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4FF86B0589; Thu, 19 Mar 2026 14:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C3C3D6B0586
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:59:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 71D02140706
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:59:39 +0000 (UTC)
X-FDA: 84563726478.22.1E7D839
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C589BC000D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:59:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eDXLzpm0;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773946777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cE90Dy65vDx9i5Egvmz2RKSmYxOP6LytEQ4+latQkJI=;
	b=DP+kwP0ExMeMqJ3RdYMSJwOd5pL+j6bwnnlIxMU4PXxsdxPEqPbcqENJmRuV1gPB4FZBAq
	fFRmBx3Z8XGosWK3eQ08hVZeVF5Vajfltg78EKYbmFqwH/nCKsZeGhLLIBcyKJBgpNgHq5
	MtQn0z4OOu2aMSI8Us7kGZ1kTJKQJxU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eDXLzpm0;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773946777; a=rsa-sha256;
	cv=none;
	b=VBdq0t5yZGa0/C+hf1lXXAmBUr43NAwRfz91cMFvl9FwheKIQ3DWNaKY1T5Q9CP/SVVVYN
	HAt2gVKmede5J+uCz0u2sabZ6prSEcZ+ScKsVhmkOSP31jZyWDyOAascpYvp/ZjGZK53kz
	E2nJ9A4lStagx2WGK43SVcLj2zJlUnk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A8FF6013F;
	Thu, 19 Mar 2026 18:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F26C2BC87;
	Thu, 19 Mar 2026 18:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773946776;
	bh=T4+wW+BE9ML0BadDhp8f1BCyI336OhYAsXdLtfCgUMI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eDXLzpm0frb6weL4G0nCG2ZWQmwkhdsnDtJOo/GLP6yPbIGp2fKj8uKYCkVZq5dvB
	 JpdoPaJCrq+Zpp4C2xk3QoW0+4VeTn/5kiR5tl+dx5zJPstwQs3/UgzZW4abulBtUg
	 SCOm1wP3eXYKMiqMnuDQXQRKuCJhsMcrQuoPy+gzv/79flPpnC40PPptjfprDNDzcl
	 9NJ2bIC6jbYFcXX9aoTsrmFIwCLbSM94+0OUEBsAPnttB2VRW7Mce77J/+ASaqQyMb
	 hLPthZ8H+jyVDtRRps1IXFhSlR77W+bQTnbskCLIU+XjTOj9FOgUSmop2QFHyKN+Yw
	 SqEdo7Se3YIyA==
Date: Thu, 19 Mar 2026 18:59:31 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, David Hildenbrand <david@kernel.org>, 
	Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>, jhladky@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm/mprotect: encourage inlining with __always_inline
Message-ID: <cecfa4ac-1fab-49c9-be69-0071596f78ce@lucifer.local>
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-2-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319183108.1105090-2-pfalcato@suse.de>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C589BC000D
X-Stat-Signature: mwao63p1cp3yuux5jx9y6643g3xqnu5f
X-Rspam-User: 
X-HE-Tag: 1773946777-728883
X-HE-Meta: U2FsdGVkX19A1MBu4SAqcjRPDyMCXqt96qJhIjxISPdcDdn2B+ithyFGLPO71nYKAicpk9S76LzJ5Px2rW1yVhVBC5BvV9QU6ny7zH/J01SUdWzWcSw5ridiX6pY40AdD3ROvFznSJAJwYAT75Ko8gwwJFhci/nzrGdSLDEeQqiCe4NeNLNebol4LVbxs1gAoPfAZU8DjLiIqfIQygFw23P18FjFwP5/RxngvMpdTx1ozPoMY36HtX+hHsvqnzpovHgMsDYyZiIFTdIhBxeuY+NkVGow5uM219SWHi/XrAm1eRfksZCdRl3QVU3UEDlet8Vbesk1LOXW91EmMbbgPrLObs6QhOYTiPK13IIworS6xs9RtIJ3oyJp1vUgE9J+pDJKvcWINjGYOXL+U+SzwX3zx+RFkgVDnLOBmV4TJcs8bka3g9eGMrBNDQ1EG5b+E4JMjxD6T8PpfGGTRvVWRIy4PZThXtr0He0OJ5I7BvRcImmAlCD1YRDU0nPanaBJiC71HIEz1ctTKJjNxq/DrnYg24RsWUML/Sf5uMmOjMSUNrLWtHqhz6EqEKSA1z2/mlQTLNygM4iEUB7WPHZgLQr+J5PPG9vVlQBVndKicfXh6DRYKwrz2X2wZyftubfqL+hzcWRX5BEMtj+DQKzfCvej0KfZe8+cPSARenq/hBIa0KTnrT/abvZVKCHoeq0P4UnN5z0d78coSifZlHDqxKHK9/eVblkAF4/sAJWZEVNYJezjZPiX8SiG94NV/IlXxjgZeP93SB7rESjjULjVj1PgZ307hfoji2k6/c18+Ivs0S87UE9z1Qr6AS5+8U0lRX6t/VGEnt8Vx14KEJquIguhIjVz36T5HFlUzlHor3VDNdMeuISu2Oro/emNd6Ti/iCGSz75FTZNT86QjWVDEzNcpIIIRY7GOLkhRJPQPMbhvQG4NR8F2fmq4D6th7UxMsV+JkY1H21HDXikqEk
 IylKXtfi
 Op+XfQ96JMOcvxtsLeoGWn0JiWKVb8tyGn3A5NwkIjEWrP7KaFAtUkO6IQh9BLqW2TWCulKnd/S9EMUflqz6naRaBpv+XNQyRqjDZvVJ13jKZhjIHmecUEAYOeaNLBXFibx8RILyMaLmx7eya/SkkU2PbtR10fVV5j6aCbIAmKM3n1o3liUC32uKNDEvOLcW8GiFq3NeV4T2pFBnlI/80WtkILJ0ALd68j0h7oTXj41xMBypOm+QYbmrOHEWS26ESiE0a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 06:31:05PM +0000, Pedro Falcato wrote:
> Encourage the compiler to inline batch PTE logic and resolve constant
> branches by adding __always_inline strategically.

>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

Does this vary by compiler/arch that much?

I wonder about how much ends up on the stack here too given the HUGE number of
arguments passed around but I guess you'd be pushing and popping some even if
these weren't inlined.

I wonder if we wouldn't want to carefully check different arches for this
though!

> ---
>  mm/mprotect.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 9681f055b9fc..1bd0d4aa07c2 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -103,7 +103,7 @@ bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
>  	return can_change_shared_pte_writable(vma, pte);
>  }
>
> -static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
> +static __always_inline int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>  				    pte_t pte, int max_nr_ptes, fpb_t flags)
>  {
>  	/* No underlying folio, so cannot batch */
> @@ -117,9 +117,9 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>  }
>
>  /* Set nr_ptes number of ptes, starting from idx */
> -static void prot_commit_flush_ptes(struct vm_area_struct *vma, unsigned long addr,
> -		pte_t *ptep, pte_t oldpte, pte_t ptent, int nr_ptes,
> -		int idx, bool set_write, struct mmu_gather *tlb)
> +static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma,
> +		unsigned long addr, pte_t *ptep, pte_t oldpte, pte_t ptent,
> +		int nr_ptes, int idx, bool set_write, struct mmu_gather *tlb)
>  {
>  	/*
>  	 * Advance the position in the batch by idx; note that if idx > 0,
> @@ -169,7 +169,7 @@ static int page_anon_exclusive_sub_batch(int start_idx, int max_len,
>   * pte of the batch. Therefore, we must individually check all pages and
>   * retrieve sub-batches.
>   */
> -static void commit_anon_folio_batch(struct vm_area_struct *vma,
> +static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
>  		struct folio *folio, struct page *first_page, unsigned long addr, pte_t *ptep,
>  		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
>  {
> --
> 2.53.0
>

