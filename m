Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8588EC5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 05:26:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 431366B007B; Tue, 11 Aug 2026 01:26:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E1CC6B008A; Tue, 11 Aug 2026 01:26:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F99D6B008C; Tue, 11 Aug 2026 01:26:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F26E36B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 01:26:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 681F4120385
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:26:40 +0000 (UTC)
X-FDA: 85087853760.12.9B0BE02
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 79AA1C0003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:26:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=esvCGa4O;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786425998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1iSqChzH165uP0ZoTvKhu/hN5rlz3aMpOZFKAxUN9GE=;
	b=H57pCNy8IkFavyt2Bh9TlyouL7LHnmQPFkOT4x/3zF+OMSgvG7Wavqei9jAG9rrh4XNSxa
	SeBBr3Xz9ZviepZ53NAK2uvg1Ca/Lmyl6GD6HLehzXbQZRwsZ3BOedXdZoqF/trvs6XBNR
	SUcwI92i+K36+lTWsL7IgQn5xmEWuMY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=esvCGa4O;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786425998;
	b=gV6w2cr6CXXam5XYW6w/zrsR5QffGVwTjXW3UAjtEauATqxnWTBU5dknRQCOGEDnUyb059
	qe7TEX+JygOSb2AZUbvSjwNRv2W+r/R/OQX72Z+Niahsw7hjzK+4X0rBQ/ZuS4MXaTxZZM
	LXI1Fo9XOJc5M00Bl7A2N3sRccMtD/s=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 697C31516;
	Mon, 10 Aug 2026 22:26:33 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9F9E63F632;
	Mon, 10 Aug 2026 22:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786425997; bh=DKxY4jNKWv9u/dNcN8aGSWF2va4zsUHSdckpsE1otK8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=esvCGa4ONstSVklpO4gGsxvU/q7TmSjIw9x2muHJhv89V5K9CC8mJuim9/9nPxRpS
	 jpretzLBaHA8EjtZtyvMTt8KflFNgcSLG6rstpKefZe0E8W+Rr3CpQGIOk3lL3F3Jv
	 e0BER5zU5KWd2OEzsJmYeIiD11m54NTPbEN1egxM=
Date: Tue, 11 Aug 2026 10:56:33 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>, osalvador@suse.de, 
	akpm@linux-foundation.org, usama.arif@linux.dev, shakeel.butt@linux.dev, 
	wangkefeng.wang@huawei.com, david@kernel.org, surenb@google.com, fvdl@google.com, 
	gthelen@google.com, hannes@cmpxchg.org, riel@surriel.com, sj@kernel.org, 
	vbabka@suse.cz, mhocko@suse.com, bjackman@google.com, zi.yan@sent.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] mm/hugetlb_cma: Fix null nodemask dereference in
 hugetlb_cma_alloc_frozen_folio
Message-ID: <7bdocyansemdfl2lugkmazjo6xytdunv4ujtabxjzeip3h4qbw@6nsaenwowryh>
References: <20260810230844.3778931-1-souravpanda@google.com>
 <15EAC670-AA9F-4361-985C-F8ED2C322CF9@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15EAC670-AA9F-4361-985C-F8ED2C322CF9@linux.dev>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 79AA1C0003
X-Stat-Signature: 6fmwan81iczgcrqpbdhr5bz6jk3rt7mx
X-Rspam-User: 
X-HE-Tag: 1786425998-425955
X-HE-Meta: U2FsdGVkX1+jDmD1HRr5eNWDxVNj5WML80ckT14Lb5hv28KTpfTC+1vVd3qsiS3nBqzubVgY8cJXmIqLo/iIRCXKKZeckMIskLRCHmJm8RyuKNMUp5UNIzNgSyhRzDO8PTFQKrHz1qf+lmaoaoWOIM26+Xqj9LvM8E0q35byITN+q0/cALJNpnOlinT/reJq4s5AQocEw98pNbH14VzDK6mxeJ3usr56Zn0CVDKUNVTOytJvueGeFprBz/bFmpSAazVfDKg09hRfXKVMRHlFY7b8mwmAJp0dsnMOnQKkCZsDE26QmbjDZozlQ0cImRurCGykRzbTAP6kH3Hl75xveEaCsE9OxCD0Wrjby4EKLKYfqCrB5DBZNMOIe/0KpoUnLdREXyC/5OLgYdOJuPkepKRvQ+Evhkv59tvLx6bmpvqxIyaSg4t3b43ZHzLrnhk9Ox0p5BFm4g//Fkdas5uPH9QsiLATKhidmYxbGtrOxHOP4W57d6pGNXvesVbPrFYB0TCONtbLq9KQLnvFg9QpA2G2/ZuwQMH8PuAO3idI0B7WIIw1GKsAnmdX32QodH3EZmEUIi6wvYr3+8Wk/70WTHI6CT33RB6g/33TbakHJaTic0U3ADNozPlR1WaK+P045vzuuv+WeVohoJQZDP5ly43zmo6uTH+9nxE0eSbfXfmNlvLOknfU5IKLbhbrOZgfIAEouUWiLXMzBuzIH5kVXHmuxz+gPNq+IkKybcie9/IR4LlngQP3zArXtJg7LlPQjYS4+UDmnjVNuSBM5vwZypi91bVOmgxrNkAGo5cFO+JnMOxZLm26yJ98oXrA6wiDv/kfJH8LMmbrZ8pdpLQ42JSWvpVFCBGz5O83foqadnkuwmVXRDT+xOqtuIf3kgXJDnXBpuRMlZFqp9yIKKyAZz1s4H5xxHNBIK2g4QwPFELIZTC0pZ5vNiNG5/gST1ZZtv5iK1xq6/ynDao9NN2
 zq0CFKoV
 UqSoX2X3r4SZ+jQ9x1CUjaKq8Gt/0UdOeuuxvdo8RkfMYaJPVo8BC5AFVMryFJoJKEE9x6WAIV7p/FH9RcK/pSQ7UXuElIOnseEpJDH81wL9LUD2rlJe2u2++Y5vwZYiPxCdePgPnnszZtzmQ7v4SYs0AADivlDOiVx9yQDsyWSaHvdOZ/iANzvWk/IyaPkJtd5mNejjeefW1FK+1y4iK51FZn76i9CcNT3tqGRR1SC4VFjANVb6Vo4+Uk/EhavOlmyDODoPc6Cmk3SpwqnXR9SB0eS6D44XIQUNCWn585Nb4yaI/lkFzKoFQOL/JYwhrtCqtTTy1aa7NmHhlV2G0fm0cCOPYRw1K1Q3k2VP9y/ijuFQKqNQvyI/Rmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 10:48:31AM +0800, Muchun Song wrote:
> 
> 
> > On Aug 11, 2026, at 07:08, Sourav Panda <souravpanda@google.com> wrote:
> > 
> > alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> > alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> > nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> > the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
> > alloc_gigantic_frozen_folio().
> > 
> > Additionally, hugetlb_cma_alloc_frozen_folio() previously attempted
> > allocation on hugetlb_cma[nid] without verifying if nid is included in
> > the caller's nodemask. Adding a node_isset(nid, *nodemask) check ensures
> > the initial preferred node allocation honors the memory policy / nodemask.
> > 
> > However, hugetlb_cma_alloc_frozen_folio() dereferences the nodemask in
> > node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
> > leading to a null pointer dereference kernel panic when nodemask is NULL.
> > 
> > Fix this by checking if nodemask is NULL in
> > hugetlb_cma_alloc_frozen_folio() and defaulting it to
> > cpuset_current_mems_allowed. Enclose the allocation attempts within
> > the cpuset seqcount retry loop so that if the cpuset changes concurrently
> > during allocation, the attempts are retried using the updated nodemask.
> > This ensures that the initial node check and fallback loop safely honor
> > the task's cpuset without violating cpuset constraints or causing NULL
> > pointer dereferences or unexpected allocation failures.
> > 
> > From a userspace perspective, this bug allows an unprivileged user to
> > crash the kernel (trigger a panic) by requesting a gigantic hugepage
> > allocation with MPOL_PREFERRED_MANY on a system where CMA is only
> > configured on a subset of NUMA nodes.
> > 
> > This can be reproduced by booting a VM with two NUMA nodes, restricting
> > CMA to Node 1 (e.g., hugetlb_cma=1:1G default_hugepagesz=1G
> > hugepagesz=1G hugepages=0), and running a program that allocates a
> > 1GB hugepage area without reserving, restricts allocation to Node 0
> > using mbind() with MPOL_PREFERRED_MANY, and triggers a page fault:
> > 
> >  void *ptr = mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
> >                   MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
> >                   MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
> >  unsigned long nodemask = 1; /* Node 0 */
> >  mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
> >        sizeof(nodemask) * 8, 0);
> >  memset(ptr, 0, 1UL << 30); /* Trigger fault */
> > 
> > This results in a NULL pointer dereference:
> > 
> >  BUG: kernel NULL pointer dereference, address: 0000000000000000
> >  #PF: supervisor read access in kernel mode
> >  #PF: error_code(0x0000) - not-present page
> >  Oops: Oops: 0000 [#1] SMP NOPTI
> >  RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
> >  Call Trace:
> >   <TASK>
> >   only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
> >   alloc_surplus_hugetlb_folio+0x6d/0x100
> >   alloc_hugetlb_folio+0x3c5/0x660
> >   hugetlb_no_page+0x3d9/0x650
> > 
> > Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sourav Panda <souravpanda@google.com>
> > ---
> > Changes in v6:
> > - Enclosed the CMA allocation attempts within the cpuset seqcount retry loop,
> >  retrying allocation upon cpuset mems_allowed updates to prevent unexpected
> >  allocation failures as suggested by Muchun Song.
> > - v5: https://lore.kernel.org/linux-mm/20260809043250.2917406-1-souravpanda@google.com/
> > - v4: https://lore.kernel.org/linux-mm/20260726072935.3513996-1-souravpanda@google.com/
> > - v3: https://lore.kernel.org/linux-mm/20260705175119.440599-1-souravpanda@google.com/
> > - v2: https://lore.kernel.org/linux-mm/20260704174930.2885785-1-souravpanda@google.com/
> > - v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-souravpanda@google.com/
> > 
> > mm/hugetlb_cma.c | 23 ++++++++++++++++++-----
> > 1 file changed, 18 insertions(+), 5 deletions(-)
> > 
> > diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> > index 39344d6c78d8..9debf033d4fd 100644
> > --- a/mm/hugetlb_cma.c
> > +++ b/mm/hugetlb_cma.c
> > @@ -3,6 +3,7 @@
> > #include <linux/mm.h>
> > #include <linux/cma.h>
> > #include <linux/compiler.h>
> > +#include <linux/cpuset.h>
> > #include <linux/mm_inline.h>
> > 
> > #include <asm/page.h>
> > @@ -30,15 +31,27 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
> > 	int node;
> > 	struct folio *folio;
> > 	struct page *page = NULL;
> > + 	const nodemask_t *nmask;
> > + 	nodemask_t local_node_mask;
> > + 	unsigned int cpuset_mems_cookie;
> > 
> > 	if (!hugetlb_cma_size)
> > 		return NULL;
> > 
> > - 	if (hugetlb_cma[nid])
> > +		retry_cpuset:
> > + 	if (!nodemask) {
> > + 		cpuset_mems_cookie = read_mems_allowed_begin();
> > + 		local_node_mask = cpuset_current_mems_allowed;
> > + 		nmask = &local_node_mask;
> 
> I don't think we need a local_node_mask, nmask = &cpuset_current_mems_allowed
> is enough. nodemask_t could be a huge array, so it might consume a lot of memory
> on the stack. I don't think we need to do that unless we see a clear necessity.

But does not local_node_mask capture current snapshot for cpuset_current_mems_allowed
after first taking a reference via read_mems_allowed_begin() which ensures that nmask
has a constant value there after. Otherwise nmask could just change value by the time
it actually gets used.

> 
> Otherwise, LGTM.
> 
> Thanks.
> 
> > + 	} else {
> > + 		nmask = nodemask;
> > + 	}
> > +
> > + 	if (hugetlb_cma[nid] && node_isset(nid, *nmask))
> > 		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
> > 
> > 	if (!page && !(gfp_mask & __GFP_THISNODE)) {
> > - 	for_each_node_mask(node, *nodemask) {
> > + 	for_each_node_mask(node, *nmask) {
> > 		if (node == nid || !hugetlb_cma[node])
> > 			continue;
> > 
> > @@ -48,8 +61,12 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
> > 		}
> > 	}
> > 
> > - 	if (!page)
> > + 	if (!page) {
> > + 		if (!nodemask &&
> > + 		    unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
> > + 			goto retry_cpuset;
> > 		return NULL;
> > + 	}
> > 
> > 	folio = page_folio(page);
> > 	folio_set_hugetlb_cma(folio);
> > -- 
> > 2.55.0
> 

