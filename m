Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F724C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 06:53:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 652346B009D; Tue, 11 Aug 2026 02:53:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62A366B009E; Tue, 11 Aug 2026 02:53:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F35A6B009F; Tue, 11 Aug 2026 02:53:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 20E1C6B009D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:53:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A574160397
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:53:04 +0000 (UTC)
X-FDA: 85088071488.11.86C809C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6C8521C0007
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:53:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qrBPBpZy;
	spf=pass (imf21.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786431183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WhT42ZPvnytTc8n7JRNBc2FArzw6lq1bbdrJPBg6wRg=;
	b=u8UBZf/jgNllXrqJv/GDC4FRQ5FNiafO0VC+xxW9RI43wK7lTPm+d56Y9BJP6JGGJGhBAz
	XZXCGw1HAU5wn9DdXoWgwTplPJGLZqTYY5GbtIJ+iO/DESyhx52czn5uXE/sKesTJ9+Tsb
	MaLRpJgl3x7/Xoym8G3UnNVBJEn+Iww=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786431183;
	b=X7x8pqvc3y8Lk9AayDPy954jctdF0R3d+p2TDDrLA5KWmJShb4Rcuz5/0341RTxcGQzFgv
	HhqkoKlVZRtjEbv/yswj+2Q3NJD8LxT+kbBK0bFjpd7w+BYZZhIZRJNA05H9RPHTQIui/U
	1+NZjkhAsVJBBYFtkRAHl9FPahhJkiI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qrBPBpZy;
	spf=pass (imf21.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66E2F1516;
	Mon, 10 Aug 2026 23:52:57 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 971E23F673;
	Mon, 10 Aug 2026 23:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786431181; bh=J8Nv0C6Lj8xcIh+Afqe0SiCKMJsACdLRYm+oO4U/o7k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qrBPBpZy/jN8FuBdTDCXCIS1n5Bqs2z+wzwQhr137260pdowOKy7HfPqS2iZirUD0
	 tf51P6uNLwN1yRy2arY2XThEoADy4HmM5vMfzxI7earp6B4w76teA1fBVSY1qt3izj
	 542gpmSH+nrKY8IfmWcZYjnx7xqD/+z+oxaslr9Y=
Date: Tue, 11 Aug 2026 12:22:57 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Sourav Panda <souravpanda@google.com>
Cc: Muchun Song <muchun.song@linux.dev>, osalvador@suse.de, 
	akpm@linux-foundation.org, usama.arif@linux.dev, shakeel.butt@linux.dev, 
	wangkefeng.wang@huawei.com, david@kernel.org, surenb@google.com, fvdl@google.com, 
	gthelen@google.com, hannes@cmpxchg.org, riel@surriel.com, sj@kernel.org, 
	vbabka@suse.cz, mhocko@suse.com, bjackman@google.com, zi.yan@sent.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] mm/hugetlb_cma: Fix null nodemask dereference in
 hugetlb_cma_alloc_frozen_folio
Message-ID: <7v5fy74amcqbqkk4qhqzlislk7kfpkig57m7mudehamddhzfcc@t34pik4a6rz2>
References: <20260810230844.3778931-1-souravpanda@google.com>
 <15EAC670-AA9F-4361-985C-F8ED2C322CF9@linux.dev>
 <7bdocyansemdfl2lugkmazjo6xytdunv4ujtabxjzeip3h4qbw@6nsaenwowryh>
 <CANruzcSkTm15OTcYExR8nS6h-x0FMgDF++WdhgLsxC3VMxKtMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANruzcSkTm15OTcYExR8nS6h-x0FMgDF++WdhgLsxC3VMxKtMA@mail.gmail.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: kxa49iej11ujkgap9woan9q5iqiweiz9
X-Rspamd-Queue-Id: 6C8521C0007
X-HE-Tag: 1786431182-417084
X-HE-Meta: U2FsdGVkX19p9xioJUWsedTew+V97qIJaB4LAGFojrXzuOBQJRlRFeTeiGNMh/wSq7pQtiEd1555pn6VdDBYRpKZB0o0IzbwxIQ/y9ngE/uMDiajyNiOOedXcuyBnnx2HIxh5OJJWsP04a5Eq8bcB4rCElqxuSs4LBEiBSaSVR8xUzEHis1pNZ8XBiaKpxm2KYX23MziVCy53wKwzLYLd9AzzBZKMKxMFTJ4r2BmYfOZY/ujZumfLCa0gfVvuC2tNr5VK3qBclDkDbsFakjRVtrOt7JjxKnJ0XCVzgs7GDTjHcmXJvM2KMKyKmfrMck0UnrDERjEhn1l31RmcKCL/l673AzuVY6hfgsPsRuUdoGNNNd6fEJijLS9RsfSnXh52MvgCk61JnZnbibyrqaM/OhgtEbh0exhKFxh51gES1efOFvxAkWtk5wU1LHDNoVJVGrwWh87tL+4N4nwDr4jqUMTLzq0+Tds5MfNYRnkAtUMXbBDcpvXgEWoKZTx3dk3I7PmNHkTbICvWCPAWGEvtAmKlN5sSIvqtkA+O05NtlU6m3GYQv+DmShn5jnQ9RGiCOeuVkVuUdab1yFq6dQvunELDmDbpAHw74bJoh5a8oEF/3IBxC+Blk2/WOjzRErsfOFmlMbL3zfcm5Ju2ymbIvdJEbif2HbTxGgEoJB3PMo1Ht22ccy/tW+BAmNyytiffygSEBHbCr/m+ZaiKtO9tBdEMmPxouu2j/t/yfQqSTQoxT3tr0l0BCM43AD20FYQxnrpeKfydKnTsUcsj6EwRQlHlaKbY9v02HEt5Bz/MonYrWSY8RMAnYzrL9ClTIzepuoHmjB8zLqekvYZPPVoYbxVJg7N1HHV9moHxegtrbsS47VTLRM50rQ+xB109tIhhEbHYnZ/BDzqWf/32fHWn9azdT8GK8mRXCAlcDf8MuRrjzeiUYRHNztqq1V1OAH1A8bl00E3ZD0HNrPNtds
 NPsST3IX
 qmq0TyTsj9mBE6ywVg2nj1krUc1W3apOCSWu/j5u7ZnJiiRAa3n5cn4829kND0SNJ50z/vYsiLaPYnsLgK+irbSMVQ+2ZTcmayIHlqw8ElOWHkTAUjgI4trzJKjPpQuZwwCCjq9KVYYKGXqWFIrRgWsUPqXAcc7sSB0byhMECRFMfs1eRXbiVMiGs9r85EUWHYw4qYJ68Ndt6iUIMAW033LDSy7Q8qhYaZNjtttK5u7eUlqe7jwi3D8wBwO3dQN74bJxeuZyKsVtfWJqlrndARERf53AzIHAjWEn1FmwzF944CZ5BVZCTLZcV/84amxcjBXOP6UBy7qyddO1kivbYNF1/pyW120ZdIXoyyEejmE6/t2baU0rtKLLWC0QDBkzQCBT+dZrXZhG68ZL73UWknIMnliLwUhc8DBMzWJ2q7ZG2ejjWWYKvYLSWrA2c22M4LQphb42Na8tDY5o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 10:45:44PM -0700, Sourav Panda wrote:
> On Mon, Aug 10, 2026 at 10:26 PM Anshuman Khandual
> <anshuman.khandual@arm.com> wrote:
> >
> > On Tue, Aug 11, 2026 at 10:48:31AM +0800, Muchun Song wrote:
> > >
> > >
> > > > On Aug 11, 2026, at 07:08, Sourav Panda <souravpanda@google.com> wrote:
> > > >
> > > > alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> > > > alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> > > > nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> > > > the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
> > > > alloc_gigantic_frozen_folio().
> > > >
> > > > Additionally, hugetlb_cma_alloc_frozen_folio() previously attempted
> > > > allocation on hugetlb_cma[nid] without verifying if nid is included in
> > > > the caller's nodemask. Adding a node_isset(nid, *nodemask) check ensures
> > > > the initial preferred node allocation honors the memory policy / nodemask.
> > > >
> > > > However, hugetlb_cma_alloc_frozen_folio() dereferences the nodemask in
> > > > node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
> > > > leading to a null pointer dereference kernel panic when nodemask is NULL.
> > > >
> > > > Fix this by checking if nodemask is NULL in
> > > > hugetlb_cma_alloc_frozen_folio() and defaulting it to
> > > > cpuset_current_mems_allowed. Enclose the allocation attempts within
> > > > the cpuset seqcount retry loop so that if the cpuset changes concurrently
> > > > during allocation, the attempts are retried using the updated nodemask.
> > > > This ensures that the initial node check and fallback loop safely honor
> > > > the task's cpuset without violating cpuset constraints or causing NULL
> > > > pointer dereferences or unexpected allocation failures.
> > > >
> > > > From a userspace perspective, this bug allows an unprivileged user to
> > > > crash the kernel (trigger a panic) by requesting a gigantic hugepage
> > > > allocation with MPOL_PREFERRED_MANY on a system where CMA is only
> > > > configured on a subset of NUMA nodes.
> > > >
> > > > This can be reproduced by booting a VM with two NUMA nodes, restricting
> > > > CMA to Node 1 (e.g., hugetlb_cma=1:1G default_hugepagesz=1G
> > > > hugepagesz=1G hugepages=0), and running a program that allocates a
> > > > 1GB hugepage area without reserving, restricts allocation to Node 0
> > > > using mbind() with MPOL_PREFERRED_MANY, and triggers a page fault:
> > > >
> > > >  void *ptr = mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
> > > >                   MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
> > > >                   MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
> > > >  unsigned long nodemask = 1; /* Node 0 */
> > > >  mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
> > > >        sizeof(nodemask) * 8, 0);
> > > >  memset(ptr, 0, 1UL << 30); /* Trigger fault */
> > > >
> > > > This results in a NULL pointer dereference:
> > > >
> > > >  BUG: kernel NULL pointer dereference, address: 0000000000000000
> > > >  #PF: supervisor read access in kernel mode
> > > >  #PF: error_code(0x0000) - not-present page
> > > >  Oops: Oops: 0000 [#1] SMP NOPTI
> > > >  RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
> > > >  Call Trace:
> > > >   <TASK>
> > > >   only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
> > > >   alloc_surplus_hugetlb_folio+0x6d/0x100
> > > >   alloc_hugetlb_folio+0x3c5/0x660
> > > >   hugetlb_no_page+0x3d9/0x650
> > > >
> > > > Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Sourav Panda <souravpanda@google.com>
> > > > ---
> > > > Changes in v6:
> > > > - Enclosed the CMA allocation attempts within the cpuset seqcount retry loop,
> > > >  retrying allocation upon cpuset mems_allowed updates to prevent unexpected
> > > >  allocation failures as suggested by Muchun Song.
> > > > - v5: https://lore.kernel.org/linux-mm/20260809043250.2917406-1-souravpanda@google.com/
> > > > - v4: https://lore.kernel.org/linux-mm/20260726072935.3513996-1-souravpanda@google.com/
> > > > - v3: https://lore.kernel.org/linux-mm/20260705175119.440599-1-souravpanda@google.com/
> > > > - v2: https://lore.kernel.org/linux-mm/20260704174930.2885785-1-souravpanda@google.com/
> > > > - v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-souravpanda@google.com/
> > > >
> > > > mm/hugetlb_cma.c | 23 ++++++++++++++++++-----
> > > > 1 file changed, 18 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> > > > index 39344d6c78d8..9debf033d4fd 100644
> > > > --- a/mm/hugetlb_cma.c
> > > > +++ b/mm/hugetlb_cma.c
> > > > @@ -3,6 +3,7 @@
> > > > #include <linux/mm.h>
> > > > #include <linux/cma.h>
> > > > #include <linux/compiler.h>
> > > > +#include <linux/cpuset.h>
> > > > #include <linux/mm_inline.h>
> > > >
> > > > #include <asm/page.h>
> > > > @@ -30,15 +31,27 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
> > > >     int node;
> > > >     struct folio *folio;
> > > >     struct page *page = NULL;
> > > > +   const nodemask_t *nmask;
> > > > +   nodemask_t local_node_mask;
> > > > +   unsigned int cpuset_mems_cookie;
> > > >
> > > >     if (!hugetlb_cma_size)
> > > >             return NULL;
> > > >
> > > > -   if (hugetlb_cma[nid])
> > > > +           retry_cpuset:
> > > > +   if (!nodemask) {
> > > > +           cpuset_mems_cookie = read_mems_allowed_begin();
> > > > +           local_node_mask = cpuset_current_mems_allowed;
> > > > +           nmask = &local_node_mask;
> > >
> > > I don't think we need a local_node_mask, nmask = &cpuset_current_mems_allowed
> > > is enough. nodemask_t could be a huge array, so it might consume a lot of memory
> > > on the stack. I don't think we need to do that unless we see a clear necessity.
> >
> > But does not local_node_mask capture current snapshot for cpuset_current_mems_allowed
> > after first taking a reference via read_mems_allowed_begin() which ensures that nmask
> > has a constant value there after. Otherwise nmask could just change value by the time
> > it actually gets used.
> >
> Hi,
> 
> Apologies for the poor netiquette of rushing out v7 so quickly (I just
> saw your message after sending v7)! I am heading out on a long
> vacation starting this Thursday, so I wanted to get an updated version
> out for review before leaving.

Not a problem.

> 
> Regarding local_node_mask: I thought the seqcount mechanism
> (read_mems_allowed_begin() / read_mems_allowed_retry()) guarantees
> correctness here without needing a stack copy. If
> current->mems_allowed changes at any point while nmask is being used
> (even during allocation) and the allocation fails,
> read_mems_allowed_retry() detects the sequence change and jumps back
> to retry_cpuset to retry with the updated nodemask.

read_mems_allowed_begin() --> read_mems_allowed_retry() --> Retry seems
to be sufficient for retrying allocation again if and when the nodemask
changes while causing an allocation failure.

But is there a possibility for the loop inside for_each_node_mask() to
detect a changed node mask and then successfully allocate from there ?
I guess that is semantically correct as the allocation happened from
task's cpuset_current_mems_allowed which might have changed afterwards.

Dropping the local variable here seems right.

> 
> I've incorporated this into v7 (Sorry again - for sending it so fast):
> https://lore.kernel.org/linux-mm/20260810230844.3778931-1-souravpanda@google.com/
> 
> Thanks,
> Sourav
> 
> > >
> > > Otherwise, LGTM.
> > >
> > > Thanks.
> > >
> > > > +   } else {
> > > > +           nmask = nodemask;
> > > > +   }
> > > > +
> > > > +   if (hugetlb_cma[nid] && node_isset(nid, *nmask))
> > > >             page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
> > > >
> > > >     if (!page && !(gfp_mask & __GFP_THISNODE)) {
> > > > -   for_each_node_mask(node, *nodemask) {
> > > > +   for_each_node_mask(node, *nmask) {
> > > >             if (node == nid || !hugetlb_cma[node])
> > > >                     continue;
> > > >
> > > > @@ -48,8 +61,12 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
> > > >             }
> > > >     }
> > > >
> > > > -   if (!page)
> > > > +   if (!page) {
> > > > +           if (!nodemask &&
> > > > +               unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
> > > > +                   goto retry_cpuset;
> > > >             return NULL;
> > > > +   }
> > > >
> > > >     folio = page_folio(page);
> > > >     folio_set_hugetlb_cma(folio);
> > > > --
> > > > 2.55.0
> > >

