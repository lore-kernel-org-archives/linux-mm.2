Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE690C5CFC1
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 08:15:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D74936B008C; Tue, 11 Aug 2026 04:15:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D24D26B0092; Tue, 11 Aug 2026 04:15:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3B286B0093; Tue, 11 Aug 2026 04:15:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9AC3E6B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:15:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 53BD31C0FDE
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:15:00 +0000 (UTC)
X-FDA: 85088277960.28.0A85764
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5CC1C40004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:14:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XtT64zIV;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786436098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n06KfqtkNXhQlNqEjFRRwaaVIqjzOi0Sj4tC7sIqbqQ=;
	b=GEDhmh+Mp4ObagyPAKFmiPwf9g47ENNpEgNTfsjM/anfXU1twJZ1XinBMEG9QWkOHWzer8
	nU3H0s/j/bUHcYm4hTBKO4mv+BdcBl7wu/6ixJOdPY2/af5r7AaRleIWhi2jPY5FaOzmR6
	FoBiIYOsK6rTg6R7Gv5Y4rNNtfmMHHk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XtT64zIV;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786436098;
	b=WkPVYAY8dKdlyYKya/p8StxX0vWjJjH5WLRYPK2kRlyihCzi0CYfPAvq5Eq8p4BdTuioSA
	5qRezdJU9IR+yU7oymJU5oMm1aNBN0bYosZbYITTvghclITRwuYINMFwl0MxBGi/LjSTIB
	BA/TBnEOMR8z8QJuKl+UA61SdSR7EI8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 435B31516;
	Tue, 11 Aug 2026 01:14:53 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 78C863F673;
	Tue, 11 Aug 2026 01:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786436097; bh=IZfnC3W1jx8DOwdmA6H/g4xMnn+4NllgIVeEp2G/EAU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XtT64zIVe/+BggqVXpMVbwZPaCij0g5nlhCkNQ9hpNxlNzeqG8nXTBWkVItokk/Eh
	 UirZJcfHdg7C0VnYvFiAKKtDSMJh9zSOPfjmzR3XiQ0EeVAyLmy8Lbyo34XoDQrPCc
	 8q5HhfUOg/5vymPVbEnXBREol8QsBL/jUPiuHtIA=
Date: Tue, 11 Aug 2026 13:44:53 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Sourav Panda <souravpanda@google.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org, 
	usama.arif@linux.dev, shakeel.butt@linux.dev, wangkefeng.wang@huawei.com, 
	david@kernel.org, surenb@google.com, fvdl@google.com, gthelen@google.com, 
	hannes@cmpxchg.org, riel@surriel.com, sj@kernel.org, vbabka@suse.cz, mhocko@suse.com, 
	bjackman@google.com, zi.yan@sent.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7] mm/hugetlb_cma: Fix null nodemask dereference in
 hugetlb_cma_alloc_frozen_folio
Message-ID: <xehyld3vcboeewkdddbxbjswbkyklc6ctf362fomjfb57ptqjv@o6x5saemiqfd>
References: <20260811052909.475635-1-souravpanda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811052909.475635-1-souravpanda@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: wm1px997gyjuesqeh7anbjrjur6tzcz3
X-Rspamd-Queue-Id: 5CC1C40004
X-HE-Tag: 1786436098-611594
X-HE-Meta: U2FsdGVkX1+lLqt8jhkJ0HvAy2FOoOc/0j5ghZcowQyYocgJq8rQaGTqAZ++rGuUMMUz3DSNGnXSIbMdljdtF3wjJIYhWJDrEdfzEoPK4ECmf+8mcKVgrePeNui8dasTlclQs2qXIQpcgKQOyHr3RxrCVu3ns1mdRBzHL68DXlouTISONHKrx4gTKRiGxIVsZfYVKi1R44rp0+/g4vjgd81fgofI76gQ6Y0aid7DzyzWMPQZCAoOcJO7TT/Y2QzgixTlkyw40AVSIwasORnC4CkMrlCNJLUtY04D9w4Zw2RUJc5CQ1Tvz41YE+z03anAuVcu7aY2Cw09aGY2E6PaiD3LY0ct4YbuCM74HI/v5D6joB3bs15RmVhWXckc+s+V/y8kxjnwsDMNnLUaS9pXbNj1MpDZlCBjq/5nIkMzHTgyUqMgwHUMHoLccR89SD/q389UD+4SAgYm971N+M8xb5b2qJgSEiqYR3/0YuPGhg0MP36LdBbZyCG8sb6dgQL2eHs2U4IjJKec8ugCdMsU+XKntWNIxwFMokItE6bNYIrdMfPjd+0TQ/u9sfwwWsJsrpIpRZXNBylHgc8kMRGSqTyjveilXhHSEkb2FVoW4xzHxd/Sv89iI1Fw6QG7GcIN3YP9ZJOY/9yBagK6yVyqV7VmH2xzvh+T/DHFpSrEgN7f4XMgmjk7BMAuHDrHAaKsbohbyukrPI/CWs1h3YyY+KhO2HxCYYorn8TUTPqvRjb5gDTU9RX/++MnULKl1Iq1PPtQ25swFk13iF2IDaWDVYXwLLZnH7Vsru0cFoYAhdvkB/VACLgZs31jtpz6oK66ZuYnw/DPEEFUvdf/EcKn4gmWqLp/bhYoTHFhL8aUFu2d84qacJo4fiXKqo98Go01uVwGqxUADwVmxXqn3KK2nRzNkgdkygq8wkYXUsukXzL4SQvztwZjfGGfICgDjxzKQsSY29NDzmEMO7PXt/r
 7W+pUger
 ojl7RyuCCrXt6oL7Zde5RR6R/neGFEMUwJ38Rj1zPHjrdpY+XjcXRF+nsVuLAdg5IzBNkRF/tfTQXUMasmwmykwwpZIidy/aNORZmQ2MsMRp300ElhYba9ebEu4zZZmif2b9fQKXgwKdpNHGAbAYQWDYj1Ka661CG1oTnUHDXuGvufM/i0eFeJ4fyX4s+qS3V61fSCQdNEr5nYniVCuxlYsDTToaHNp6CgdNAATcq+uoe9y5OsvGM+QX6/G9E9d34dvVRqWmJvvFyX4upV43DRNp+xCEK4qpEjQPmJvYF1ppuFRpvfd8Wz6XxAA4ySMzuJJRxJ/ZwbIrhXaSRwKP5LnD7vgvYsIb2A6lWQVmxBr689dad3MqpSePFv8XYLCq7Rz3TAUuQM7DZiucYEZBR0L7bH4uWa4InzsoFoE3xnN7YT9TydEHFzah1HA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 05:29:09AM +0000, Sourav Panda wrote:
> alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
> alloc_gigantic_frozen_folio().
> 
> Additionally, hugetlb_cma_alloc_frozen_folio() previously attempted
> allocation on hugetlb_cma[nid] without verifying if nid is included in
> the caller's nodemask. Adding a node_isset(nid, *nodemask) check ensures
> the initial preferred node allocation honors the memory policy / nodemask.
> 
> However, hugetlb_cma_alloc_frozen_folio() dereferences the nodemask in
> node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
> leading to a null pointer dereference kernel panic when nodemask is NULL.
> 
> Fix this by checking if nodemask is NULL in
> hugetlb_cma_alloc_frozen_folio() and defaulting it to
> cpuset_current_mems_allowed. Enclose the allocation attempts within
> the cpuset seqcount retry loop so that if the cpuset changes concurrently
> during allocation, the attempts are retried using the updated nodemask.
> This ensures that the initial node check and fallback loop safely honor
> the task's cpuset without violating cpuset constraints or causing NULL
> pointer dereferences or unexpected allocation failures.
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

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
> Changes in v7:
> - Removed local_node_mask stack variable as suggested by Muchun Song, setting
>   nmask = &cpuset_current_mems_allowed directly to conserve stack space.
> - v6: https://lore.kernel.org/linux-mm/20260810230844.3778931-1-souravpanda@google.com/
> - v5: https://lore.kernel.org/linux-mm/20260809043250.2917406-1-souravpanda@google.com/
> - v4: https://lore.kernel.org/linux-mm/20260726072935.3513996-1-souravpanda@google.com/
> - v3: https://lore.kernel.org/linux-mm/20260705175119.440599-1-souravpanda@google.com/
> - v2: https://lore.kernel.org/linux-mm/20260704174930.2885785-1-souravpanda@google.com/
> - v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-souravpanda@google.com/
> 
>  mm/hugetlb_cma.c | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> index 39344d6c78d8..3e22161686d2 100644
> --- a/mm/hugetlb_cma.c
> +++ b/mm/hugetlb_cma.c
> @@ -3,6 +3,7 @@
>  #include <linux/mm.h>
>  #include <linux/cma.h>
>  #include <linux/compiler.h>
> +#include <linux/cpuset.h>
>  #include <linux/mm_inline.h>
>  
>  #include <asm/page.h>
> @@ -30,15 +31,25 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
>  	int node;
>  	struct folio *folio;
>  	struct page *page = NULL;
> +	const nodemask_t *nmask;
> +	unsigned int cpuset_mems_cookie;
>  
>  	if (!hugetlb_cma_size)
>  		return NULL;
>  
> -	if (hugetlb_cma[nid])
> +retry_cpuset:
> +	if (!nodemask) {
> +		cpuset_mems_cookie = read_mems_allowed_begin();
> +		nmask = &cpuset_current_mems_allowed;
> +	} else {
> +		nmask = nodemask;
> +	}
> +
> +	if (hugetlb_cma[nid] && node_isset(nid, *nmask))
>  		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
>  
>  	if (!page && !(gfp_mask & __GFP_THISNODE)) {
> -		for_each_node_mask(node, *nodemask) {
> +		for_each_node_mask(node, *nmask) {
>  			if (node == nid || !hugetlb_cma[node])
>  				continue;
>  
> @@ -48,8 +59,12 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
>  		}
>  	}
>  
> -	if (!page)
> +	if (!page) {
> +		if (!nodemask &&
> +		    unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
> +			goto retry_cpuset;
>  		return NULL;
> +	}
>  
>  	folio = page_folio(page);
>  	folio_set_hugetlb_cma(folio);
> -- 
> 2.55.0
> 

