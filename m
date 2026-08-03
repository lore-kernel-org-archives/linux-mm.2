Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABB0FC55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B99F46B009F; Mon,  3 Aug 2026 09:24:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4A4D6B00A9; Mon,  3 Aug 2026 09:24:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A60416B00AF; Mon,  3 Aug 2026 09:24:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 874E26B009F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:24:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8988F16065D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:48:45 +0000 (UTC)
X-FDA: 85059483810.25.3831457
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6F75240002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:48:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Lx1gfa5p;
	spf=pass (imf12.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785750524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L9YPEA+IKMBSl5jDa5B9kbkctoGjpz54u8UyuiJTi48=;
	b=RDWpk1poy/2F2/dg4uiMfABQMD//B+hTr9Hv9L93+6M5enZSKUgj5HvCcGvTng01V+dwuZ
	UYzplsf8mdW8dYpqMN4fqM9ea9ZCFbHbBTwNle09QHXaj/SSg7gW1t01dsAVLcuh9kbYzO
	LZgWvX5hff+d63Kqop4w9Fapwx3lNbg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785750524;
	b=idc5MO42ltNUeiDmDcG/EImeW6FxUNyPrYTMBT3f2xl+S8iVNJtiLIHMwOzZJYz1ovTbz0
	tg9nD5fZIIIu4fzetJDd9MW9tKa47wVQPG8SLxNWsztsABpHiyUiRblrECJmYE6XszVTQD
	KmILNdq1eSV+K0BqiNYvLEiiSuC2R/w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Lx1gfa5p;
	spf=pass (imf12.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 25CE6143D;
	Mon,  3 Aug 2026 02:48:38 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 748583F66F;
	Mon,  3 Aug 2026 02:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785750522; bh=lb4qfPPLO9iO2vjesheq/P4y96HKy+MHgFddlZZcwNo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lx1gfa5pSF07yWS5yZJrp76eaVY8dvqpZvL5BWXbuuGiiIIsXnhth3mQoJd2ZNm9w
	 v7PWGiLujwv7P+KCQu+RfP923mYm+opIf66ePfv1Ozs6Fap9KC8pfEJ+g3o9Xm438p
	 xT8BzmqWqlFx3hXJu/4K0aHI1m8yoSCFFgp2Kam4=
Date: Mon, 3 Aug 2026 15:18:38 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Sourav Panda <souravpanda@google.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org, 
	david@kernel.org, surenb@google.com, fvdl@google.com, gthelen@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm/hugetlb_cma: Fix null nodemask dereference in
 hugetlb_cma_alloc_frozen_folio
Message-ID: <nuoxvxqgb453fuj5ezhjn374chawnrao53tev3wdqigpc6pfnm@q5oamexnzqdz>
References: <20260726072935.3513996-1-souravpanda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726072935.3513996-1-souravpanda@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6F75240002
X-Stat-Signature: jmffp76dr73q9iaq7ohris88a3o1ykxi
X-HE-Tag: 1785750523-671832
X-HE-Meta: U2FsdGVkX19ts9CqolTY5sOrqwoVufH//5yhEAZPFNidqPyejDYT3y02qLOIZbbi75+GRSRv9fv3fK7uIqs/XGWoPBDY1bApRi6zyun/eUJ9OxCSjIu0p6E6HG36zD9SLSaccHrlU2VIztQB/OTi9RfQuk/kh18vd3VfUzb65H1E4OpDRh9NLDg+5wzLWTdlLCJCGdCHa70Q5NIGhtQxKEvZb5DVeBSwjP9HJzPrYbhrCA0Myy/5blv3BH5tacGB/k6Ws4RET2gAC6PQsj+4wZzTItmQVzF/E9o2IyySaqeF0K/kcv264VSNalGhTxkTap9yjst0e+OUQ8ghccpAm5WnCmg/DPMY2uhoFvY62y7cAAiKQ/1vTtBbiNZXWfkIzcxPVmef3aICuLmk0/8eh2lZqAWntctoS4VjKaNcmw9q1FOGKT6QKz3aqYonvnDctMDN2c862PwH0K8XyUcG3dJxGNCPstfY/PVI9RJPh602ZH6ZCVbjfI4rgjklMYv6h2gbmZurr8K5oj951LpDuFLxakphOWGA0YW3WYDwZ4ilgZrBghKsUG0XlW3zUkbXFXH8SX8qFehnWHNvX2Flhwlpt5CwGfeek6f6XEKOBj8xxcxOcepAWW4+23xygdK/RCYKgCTXTlxrLE3s4n8eb3CcPnlSxXhy5Sodx1YjtfqjfPYaB6hdUHJu9SNctecCqpyr2fcIgyzlmxZPn5jZpZecTcwIHybAbbYp/KwYjdbumKdjg6QvIz9MHSo4/9NvUGvj8l6rAQJm1q6TwQO5CPjVgYHY4Cq+m1rzI8GktooWrQeh7nLs3W72HlRiRpFa7+jT03u6BIWJh7J8k1hsDcc67HItFXTtwq6t7crY87v8zyhv2EqrazHimCd3hlIf7sUaWrPVaRAxBPb6XCmsFpQCTGLSBFBis4b34KNHj64L7l8kjz02pia1WrEHO70CTXCqOHfCfBpkEnP8m10
 MEjejyDq
 bYnMs57w7uWs+BVMG17ChTPKWpAZAMoMMrW1vqY9hs6xpbt8M+6UT1YJisRGCbetD5EONv0SY7PUi+ML9mymMujHPuLBt1M8JQnp4WcTAceaDC+GKqarvOgVeYRWCfFgJWGjZn9+ENxO2Z574bTjCgmDUH3HEo3X3njt7yEsm72LyFKrwR+z0UxdXGExrtY34fBGYhEn589FrrJrdYtiYTTFRXfBB4XYHWRkn93hOCO09k4PaMye2L7JrEFoj9i4cVuGbE1UFC8ivy1MabpIPvMe/gtdfIxV43cYqsg7cNq0xt+dQS0hH7Z+zQ86mbpAlbHt4EOxKG0eQ6t3IBLMFdVi/LBUY4ZfpGMQ6NddZZa4mpFGqdcM6uZg5Aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 07:29:34AM +0000, Sourav Panda wrote:
> alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
> alloc_gigantic_frozen_folio().
> 
> hugetlb_cma_alloc_frozen_folio() blindly dereferences the nodemask in
> node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
> leading to a null pointer dereference kernel panic.

node_isset() is being addded here in this change right ? OR was there
another path via node_isset() which could have been called on a NULL
valued nodemask ? Although subsequent for_each_node_mask() could do
the required dereference as mentioned earlier.

> 
> Fix this by checking if nodemask is NULL in
> hugetlb_cma_alloc_frozen_folio() and defaulting it to
> node_states[N_MEMORY]. This allows hugetlb_cma allocations to fall
> back to any node with memory, keeping behavior consistent with
> alloc_contig_frozen_pages() and alloc_buddy_frozen_folio().
>
> From a userspace perspective, this bug allows an unprivileged user to
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
> +
> +	if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
>  		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
>  
>  	if (!page && !(gfp_mask & __GFP_THISNODE)) {
> -- 
> 2.55.0

