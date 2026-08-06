Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFC17C55174
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 02:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 171516B00AC; Wed,  5 Aug 2026 22:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FD416B00AD; Wed,  5 Aug 2026 22:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE01C6B00AE; Wed,  5 Aug 2026 22:47:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 765DE6B00AC
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 22:47:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8BFA11C11C0
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:47:18 +0000 (UTC)
X-FDA: 85069308156.14.12B6D1F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 933B840003
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:47:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Q+QMJLDP;
	spf=pass (imf07.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785984437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wJmAD5vo/TZZdhcLtOhkRyWiHtuje8SVffjXTMJ4MR4=;
	b=bDR4pZnnb4ngkENXoOhLK96MgsBIZWiMh4sDZeb/NMeRtxkocs+4J12NQnV1P53J2YOw5S
	qg1Y4A1vl/rCweRskTo4Cnaloi8XrTARcRFF2wRS6ivSfdQdWhGevXZhH+/wb85rvqu2Cf
	xO9HWuaQ5ISQU7S56OfktXs9nV7Raus=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785984437;
	b=VOL/+Lu2HYIu+Lt1e0tanWMaaYhy7HQHBzjzv09uYJRdk1QCB01Jm7kV3QzPIMQdicjrZt
	XrxBkvbqg6GjIOfCLSl+n8YnUu9Jvf6FeIMvxQ8XPW1xxhFPH5simzjA/IzzKwvTt9J8VZ
	Pr0KPhbBVYLuiiyvozX8BkDnCR03B/0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Q+QMJLDP;
	spf=pass (imf07.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39C34153B;
	Wed,  5 Aug 2026 19:47:11 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7FAEA3F632;
	Wed,  5 Aug 2026 19:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785984435; bh=ZEaoldKX9mi8FK3rkENRpN7gFBP2wioCSrLSNkQ3eRs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q+QMJLDPO7veXKJG3FgcOo+H4D9O4k7kPGw8LxM2lHKui1fnbAJPFYzcHQiBjJ/1Q
	 J6d23b/HGEZuSN0DUQFSMfI/DPQVkpqZeNMjIZCLuTBYGFRtjAHcwmAe9T18YRBO2D
	 b/UKNIJFPnWYgETpMTATg7T20K6k/pb0fZ+6P8UM=
Date: Thu, 6 Aug 2026 08:17:11 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>, muchun.song@linux.dev, 
	osalvador@suse.de, akpm@linux-foundation.org, david@kernel.org, surenb@google.com, 
	fvdl@google.com, gthelen@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm/hugetlb_cma: Fix null nodemask dereference in
 hugetlb_cma_alloc_frozen_folio
Message-ID: <2qq6r5zvegrk5bbx7qbkscwqmccda7mxtzuvd3wln24yjm2qhx@663fzadsgmg3>
References: <20260726072935.3513996-1-souravpanda@google.com>
 <20260805202444.1573218-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805202444.1573218-1-usama.arif@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 933B840003
X-Rspam-User: 
X-Stat-Signature: t37zwqc1oaeiqtjnkj9i1owtj4m4rk4x
X-HE-Tag: 1785984436-678940
X-HE-Meta: U2FsdGVkX1/8W61aN9L2l1XmvFQcz1UJqSbxoaaV7BP4BrKp3cCLXjnqsRqUkeutgRhI6viak1CDDk/wT5fWTTN39ANcux/EihczUbozW4WrhRuytArsde4YPYgOOv1323+i0FAa35pFGNrSQhDI8P8mc6lHvjNz+kso7roSfIZdnQxXJFrKgu2lBOMejyC2z0B0nGoBBwbZVT62TtWOic2LG0WDWy1hmIYf++Sf51fFcLRuNwOLEUgdobKtfx8G8nV/3V4hgacBC+lWEr7VDbLCpP3ghbJoQuKDUOxLBfni1eYPTmuCy4nKLKGU/VaRr960TUH75dx7dEHTjpX2oscMqUrCgm90sonNVAjMu+x/A7Ua0kbpAuWEJYYuPXEktyZSkFdzXbSbGD2zY1kWpAnqIrBx3zSQvFvbw3Z/19KUXJ8OPnwLCDWtLdryTuIXK3dDVk6KoU2YX0GcSr3ERITnG5Zb6Af1NYnotX4hHwGImaDhOCaToaE2rfbfrRbZXXc+pwHah74C2QeelZqG4YjMWN65XIaCX2JxsLv7MCxs0Be6x1q5EiqlILCXH1pj7ULOtQVUkv7hNrjmctk5PDD0zRk1L5Tdy9DyiFpNyBjZtnEcFvSA3Hwf51fKjETlyOP1lU4OUvLjgtymRtbOLyI+ov5BlPi8BJFo0021wfL6twMTzE0P9CUjByVeVZ7R+D1QU3HEouzEvTMbSh2mRX35GEI438yJ0EN4MNK/KYs0Y0wz5e1t86aa5mWmkVlFrfysCR1mr0cP9jTmrydheuMnxS+7OD4C4gRvib4e7LL6JdHjICK/77DI6zhYmU9BYJs5H/gQqXlRC/P+aLuK2jEytKHYYVcydZBXiz8bXVqwtM9I8b3N/gK0Ih5pmid+J+vMfwveBAJMRlhsBrVV2O89bqg54y+latbCfd2+E6lewu0uQqDfisAW0wvlMT5b+iGVPB/yKaydqgGKF/o
 FAxOkcoQ
 dWFeNKbjjJpc/P7V9EX+G913p9u5frIfavEHLuHdMe7onUMCYrZegNQ1ZnZG1aL+CakpL1Z237FxHWsb14Ho6XbKByrxp9agT8S1WT6QmEUodcvAXIUM/dYEbzBHMEbn3CSOJ0wSATBG7rZf1PR17tlDIHAAJGgtHt/kdctvaoqQ6ghNezwXTunRDKOp1QlWzMNn2m3z4QOA5yK/ghFZfjLMEdRccfzn9L+DS4VB6lhQUO9mRJnrdwb+WU3Zt8F6HZYhgGMwjLlNLTDC2nYpWdZMbN/pvmAx8XXyVeVKvzl3eqDLS+NbwiKkVjf11hNhILafHCrD2uRIyIYiLhcFQcSl1FQVVQxpYotxe0Kegy8d7sQrnzIiAK8R0MA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 01:24:42PM -0700, Usama Arif wrote:
> On Sun, 26 Jul 2026 07:29:34 +0000 Sourav Panda <souravpanda@google.com> wrote:
> 
> > alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> > alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> > nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> > the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
> > alloc_gigantic_frozen_folio().
> > 
> > hugetlb_cma_alloc_frozen_folio() blindly dereferences the nodemask in
> > node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
> > leading to a null pointer dereference kernel panic.
> > 
> > Fix this by checking if nodemask is NULL in
> > hugetlb_cma_alloc_frozen_folio() and defaulting it to
> > node_states[N_MEMORY]. This allows hugetlb_cma allocations to fall
> > back to any node with memory, keeping behavior consistent with
> > alloc_contig_frozen_pages() and alloc_buddy_frozen_folio().
> > 
> > >From a userspace perspective, this bug allows an unprivileged user to
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
> >   void *ptr = mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
> >                    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
> >                    MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
> >   unsigned long nodemask = 1; /* Node 0 */
> >   mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
> >         sizeof(nodemask) * 8, 0);
> >   memset(ptr, 0, 1UL << 30); /* Trigger fault */
> > 
> > This results in a NULL pointer dereference:
> > 
> >   BUG: kernel NULL pointer dereference, address: 0000000000000000
> >   #PF: supervisor read access in kernel mode
> >   #PF: error_code(0x0000) - not-present page
> >   Oops: Oops: 0000 [#1] SMP NOPTI
> >   RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
> >   Call Trace:
> >    <TASK>
> >    only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
> >    alloc_surplus_hugetlb_folio+0x6d/0x100
> >    alloc_hugetlb_folio+0x3c5/0x660
> >    hugetlb_no_page+0x3d9/0x650
> > 
> > Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sourav Panda <souravpanda@google.com>
> > ---
> > Changes in v4:
> > - Reverted the alloc_fresh_hugetlb_folio() cpuset snapshot approach from v3.
> >   As Muchun Song pointed out, snapshotting cpuset_current_mems_allowed does
> >   not prevent false-positive allocation failures without complex retry loops,
> >   and alloc_contig_frozen_pages() / alloc_buddy_frozen_folio() already handle
> >   NULL nodemasks safely internally.
> > - Handled NULL nodemask directly inside hugetlb_cma_alloc_frozen_folio()
> >   by defaulting nodemask to node_states[N_MEMORY] (Option 2), keeping
> >   HugeTLB allocators clean and consistent.
> > - v3: https://lore.kernel.org/linux-mm/20260705175119.440599-1-souravpanda@google.com/
> > - v2: https://lore.kernel.org/linux-mm/20260704174930.2885785-1-souravpanda@google.com/
> > - v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-souravpanda@google.com/
> > 
> >  mm/hugetlb_cma.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> > index 39344d6c78d8..5744de0ceeb7 100644
> > --- a/mm/hugetlb_cma.c
> > +++ b/mm/hugetlb_cma.c
> > @@ -34,7 +34,10 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
> >  	if (!hugetlb_cma_size)
> >  		return NULL;
> >  
> > -	if (hugetlb_cma[nid])
> > +	if (!nodemask)
> > +		nodemask = &node_states[N_MEMORY];
> 
> Hi Sourav,
> 
> hmm what if cpuset.mems only allows allocation from node 0, and hugetlb CMA
> is only available on node 1. This will no now allow allocating a gigantic page
> on node 1 when its explicitly not allowed?

That's fair point but should not the user be also responsible in provding a right
nodemask containing CMA memory if it prefers avoiding node_states[N_MEMORY] based
fallback mechanism in kernel ?

> 
> Would it not be better to check cpuset as well?
> 
> Thanks,
> Usama
> 
> > +
> > +	if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
> >  		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
> >  
> >  	if (!page && !(gfp_mask & __GFP_THISNODE)) {
> > -- 
> > 2.55.0
> > 

