Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F301C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 20:24:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAB0A6B0099; Wed,  5 Aug 2026 16:24:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5B996B009B; Wed,  5 Aug 2026 16:24:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 971C56B009D; Wed,  5 Aug 2026 16:24:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 621146B0099
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:24:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C34A0A0295
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 20:24:55 +0000 (UTC)
X-FDA: 85068344550.14.328D44D
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf02.hostedemail.com (Postfix) with ESMTP id A48D78000C
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 20:24:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wB//v4fh";
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785961494;
	b=vlufnfhwBsmGwPR3sY89rjhNg+vEZjenw40Fe6KESa8sC0E/OKT4unV05qvLnImd3Dsfo9
	MeqieH3D4+MmuDb5XBEd5PaSV+XbGo6y6IQCF1lzIVnML/R9/8gyhdZreRIdnFgAIVMaZ6
	zD7oV3YNx/Sq3zcxpZHMPK4EaZ1+vd8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wB//v4fh";
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785961494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nEH2CoFwohGH5dxkOgSIARejt1oXPrA3YkjsFxuFaSs=;
	b=XSOpiGQZ7HNQnbsx/q5crvWEPnlIpKIRDwzsTUZ0l0YMfV8XJhCxuQ0ykhalkiix0rFbex
	cEklj9i49se/gKZiD2eM2b8fQWt/jvKuP+y26CYugsGmHNalUsZgnTgw2ks6xyqDOwjwrn
	hMbkpUYOj3CYqzo4dUfq4X5uJPSA9AI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785961490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nEH2CoFwohGH5dxkOgSIARejt1oXPrA3YkjsFxuFaSs=;
	b=wB//v4fhgHnHncyhvD/4oDNstyL4uRWD5SeyhoV5/SCL+0CFsL+g6OC0LHzYfeH8TnY1WA
	tL8aw5Ly9b2wNmtOpP+ne6M/Y/xqG0xTeukDSMe0GjuWzvt55MZh6ccIZcG61pMmFRwa8L
	azRJxcsXIUPtJnn7JnyEBLpgnq820ho=
From: Usama Arif <usama.arif@linux.dev>
To: Sourav Panda <souravpanda@google.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	david@kernel.org,
	surenb@google.com,
	fvdl@google.com,
	gthelen@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm/hugetlb_cma: Fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio
Date: Wed,  5 Aug 2026 13:24:42 -0700
Message-ID: <20260805202444.1573218-1-usama.arif@linux.dev>
In-Reply-To: <20260726072935.3513996-1-souravpanda@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A48D78000C
X-Stat-Signature: cq75dpttn5ndgez8wynsyjo9mkpuz8bt
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785961492-66647
X-HE-Meta: U2FsdGVkX197Vvx0iZ+aTIFiEcCnSVIpl7LMeX2XRhwAYgAnjlFc6FnWTPVgrUVz4M4O7ZSyC5BIpy1BsJhrfWexvPkggACWBbRLw9qC8iutVXSIjesRjRiSbhXMxXKbyc27C9yBzgfByxdEClqRMgxfVA127DvKSqpZQkFDe+SZITuX8y0AmU+7u47a+7YhU7jGyoYADjy/R+pKo4AhMezLVpjhYRsY8Z+wbjp/K0P2UPXhIKPJ3c2reZQtCVGq+6+NDJXt1rPXoLjc/s9ynRHvn6vVIrZQJoUB8TrLQ0bGSgjXO9yPmU80gEeeMn0tWi0o+vmGVVL/gbnaxZKgYazJT2dWuPJysXlfRdEDtaLs/KyV5xW1tTWOlhLkjZtGkgnbYZbqnd7EtNJNiyhNuRAToCiUB1g8aifZBuq40BCuIoAKZqTpHM2DWeDkexKvmMkKaQaBxPxzSsMBDeE7LP+S1ob4DIIOoCrfRH34T9f6mm9YtRh8sGFRT3V2pf5gfolV0wJRpGBZb9Dopoxd/3KrXmA5oOZz0u65nNjmYXQrOatqEwU/gX5zB3qJyhJqaE/kbTI8cgN7oTmSDf1KnzyNMu78+SuUor0QVXFzI+q7Xt89cTYouaWg7CG/fRGuygv3W7ayoZUHh7edIbTzhT+1jVLYWIJEVJxgUXrURdhrentVYAt6qk6GPMfrcJlokv61ro2Itc4oF7Yi1aicQr2HjWSPDN6atdJqAF1kNoRVxzkfdscTax4iY95n45TxRBGFvyDaHUjLTq8PW0yeebb4Sa9Fh2+/cOUED0vxfnCuPZJg6qh0VcTQPh6qQtNQ3i+urQf3VzjN89ORClAvfLU4sWdbdZDTC4dtG8oWlDKL1da4vLqFi+XOaebkwnwjzLyiJKyb7L6Lgcdou+rv9wAfnzIA3GAn8tRn1cJS5pMLUbdbpCSyJ/XrQ8FMKvUKQYEkDq3/9FB+rJlavKK
 qt08CpUS
 HaDJVe0DDtdKUpBQQYT+SUrg6Q6J63voYZVHSc2yEmLnY3NPsUy3npCx9c9hINRBz8GdCAqG248rSdrP+jjMJxyj+cob9KlsgZ17mesztpNcAanoXMsfBzVTLRGs/jTHamD9lNCtteNDCuOzR0+dCkMDks2L6JFwz/1IM841QHUB5f/J08YdYU7OoAgwwNAoGLa8S+d9RB/J7TIE4KzQYnnrbJUYGwuppcYbzfGQZGzldmRzl56+/kBBC4j/ZZO08oKjkMKdAaR47AYdMLsq8J7anSXE1qUDQmMJ+rrpegWiVAjQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Jul 2026 07:29:34 +0000 Sourav Panda <souravpanda@google.com> wrote:

> alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
> alloc_gigantic_frozen_folio().
> 
> hugetlb_cma_alloc_frozen_folio() blindly dereferences the nodemask in
> node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
> leading to a null pointer dereference kernel panic.
> 
> Fix this by checking if nodemask is NULL in
> hugetlb_cma_alloc_frozen_folio() and defaulting it to
> node_states[N_MEMORY]. This allows hugetlb_cma allocations to fall
> back to any node with memory, keeping behavior consistent with
> alloc_contig_frozen_pages() and alloc_buddy_frozen_folio().
> 
> >From a userspace perspective, this bug allows an unprivileged user to
> crash the kernel (trigger a panic) by requesting a gigantic hugepage
> allocation with MPOL_PREFERRED_MANY on a system where CMA is only
> configured on a subset of NUMA nodes.
> 
> This can be reproduced by booting a VM with two NUMA nodes, restricting
> CMA to Node 1 (e.g., hugetlb_cma=1:1G default_hugepagesz=1G
> hugepagesz=1G hugepages=0), and running a program that allocates a
> 1GB hugepage area without reserving, restricts allocation to Node 0
> using mbind() with MPOL_PREFERRED_MANY, and triggers a page fault:
> 
>   void *ptr = mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
>                    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
>                    MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
>   unsigned long nodemask = 1; /* Node 0 */
>   mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
>         sizeof(nodemask) * 8, 0);
>   memset(ptr, 0, 1UL << 30); /* Trigger fault */
> 
> This results in a NULL pointer dereference:
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   Oops: Oops: 0000 [#1] SMP NOPTI
>   RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
>   Call Trace:
>    <TASK>
>    only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
>    alloc_surplus_hugetlb_folio+0x6d/0x100
>    alloc_hugetlb_folio+0x3c5/0x660
>    hugetlb_no_page+0x3d9/0x650
> 
> Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sourav Panda <souravpanda@google.com>
> ---
> Changes in v4:
> - Reverted the alloc_fresh_hugetlb_folio() cpuset snapshot approach from v3.
>   As Muchun Song pointed out, snapshotting cpuset_current_mems_allowed does
>   not prevent false-positive allocation failures without complex retry loops,
>   and alloc_contig_frozen_pages() / alloc_buddy_frozen_folio() already handle
>   NULL nodemasks safely internally.
> - Handled NULL nodemask directly inside hugetlb_cma_alloc_frozen_folio()
>   by defaulting nodemask to node_states[N_MEMORY] (Option 2), keeping
>   HugeTLB allocators clean and consistent.
> - v3: https://lore.kernel.org/linux-mm/20260705175119.440599-1-souravpanda@google.com/
> - v2: https://lore.kernel.org/linux-mm/20260704174930.2885785-1-souravpanda@google.com/
> - v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-souravpanda@google.com/
> 
>  mm/hugetlb_cma.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> index 39344d6c78d8..5744de0ceeb7 100644
> --- a/mm/hugetlb_cma.c
> +++ b/mm/hugetlb_cma.c
> @@ -34,7 +34,10 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
>  	if (!hugetlb_cma_size)
>  		return NULL;
>  
> -	if (hugetlb_cma[nid])
> +	if (!nodemask)
> +		nodemask = &node_states[N_MEMORY];

Hi Sourav,

hmm what if cpuset.mems only allows allocation from node 0, and hugetlb CMA
is only available on node 1. This will no now allow allocating a gigantic page
on node 1 when its explicitly not allowed?

Would it not be better to check cpuset as well?

Thanks,
Usama

> +
> +	if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
>  		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
>  
>  	if (!page && !(gfp_mask & __GFP_THISNODE)) {
> -- 
> 2.55.0
> 

