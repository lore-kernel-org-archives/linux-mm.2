Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA63FC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 07:04:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B21186B008C; Tue, 11 Aug 2026 03:04:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD29E6B0093; Tue, 11 Aug 2026 03:04:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E7E66B0095; Tue, 11 Aug 2026 03:04:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC996B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:04:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F24ACA03AF
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:04:46 +0000 (UTC)
X-FDA: 85088100972.28.4033A6B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0E1F31C000B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:04:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=csM7pPfq;
	spf=pass (imf18.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786431885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=btBvudwJIgZuKa60ffDju+jDk02ka3qMCqerEoqmUGc=;
	b=foLalOt0H5ayuV7QNdVHYFrPYIulDSl7bSbZ1sjr5a1qGcycgfnQ6aQ/sTfwGSg8GP2BSK
	8PupUjY2Ae2XSUb5JDuxTAl2KScPLnnUV9wO6SKAwQo6sXZAmP1OARW6amYhB/HfBkULPP
	xvJtMFtWACGbfGOjtiSWjz2ES7VzUbA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786431885;
	b=AWnartlAbGblnIorAqrdOBlhz7Y3Iy/TZ4Dn4k9BFfKm6BfJEVlLD1eKFD4Ey57JSd/zv/
	ZQFgxtuZI28rC8eJ9u2DR8q0QQzh2HQ7jgO0LcTqNO8CTwbWvr64vIVVrXoGvB+j7f5lBW
	fq9nD+BEMv2yj7LIST9XN6IxzPle6JA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=csM7pPfq;
	spf=pass (imf18.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 18B1F1516;
	Tue, 11 Aug 2026 00:04:40 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4D10F3F632;
	Tue, 11 Aug 2026 00:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786431884; bh=iCrqv1LKkGDGzIeBjXjqnjQnj6ZWlo+Io7WbsnmVpmU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=csM7pPfqpnCybRAkg7zYo+ci6tqmALXOh4okoT+Mcb2M/XXmbNUeL0Qg/rOCx0tdi
	 gBDBoBRplwDSeNdVpZEGm4tqhWjeWAG5MZD9a1VdJ4QhpQyqZhyevpSzbLNthJpJgO
	 cXANW3WVXy79UpI97rLfwn0o+x34eNP1ReZrB0tc=
Date: Tue, 11 Aug 2026 12:34:40 +0530
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
Message-ID: <smo2p6y3dvpr62hiy73tsvruilertnc6qeqlxihwfx7lc465j6@l3jylqyhecxq>
References: <20260810230844.3778931-1-souravpanda@google.com>
 <15EAC670-AA9F-4361-985C-F8ED2C322CF9@linux.dev>
 <7bdocyansemdfl2lugkmazjo6xytdunv4ujtabxjzeip3h4qbw@6nsaenwowryh>
 <02941826-584C-4914-9700-1C75ACBE4D24@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02941826-584C-4914-9700-1C75ACBE4D24@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0E1F31C000B
X-Stat-Signature: 7cy8anhas66qhx5ns6sw18kd9wq9izy8
X-HE-Tag: 1786431884-777912
X-HE-Meta: U2FsdGVkX1+nNYlhbR42tp2SjTxJSSMClp8siq1Au10Wv7MSxH1dp2SisbfdP6boqB/h6sTL47EHb4e0f4Ta4QnRMcaRELtU95naIY//grzI7LUShCC8OUkPtLIhQuFySSsXj07c1H0dolgkBT5fApoYfFXaxYrFnE33TKtT5CIlqr9CU4/nzjkn2p9sAZoeg4mEHAI9IMmG63oDebaomurOoBU/3dXsq9d77xOcAzVSWDRoifKu8awtx7w9/cX3QQvjevUvSyTekqjOvuuyGhNYpek+jRA2n8hH2JdLwE4DHI17FX4YiwV16PWhTq9j551aUwMtqpUItm8mqSSXfW/WRyTPOnRFmHIIoW/KEXHKStJf/mit2rfXumFrQ3EPN1Q4Y2khnAHadmdX+OF5SpIW/Qzs49djTeED9JE/mvoizPImDRo3Ip+sW8fC+hlA8oqtaWNI+QFD1j2G8FGNVLw6gSSUxlEAykbG+AcuyMuP8WhEiB+o7gJxTzheLnVZY1IQ++cc33qqjUyOUThyWpSZVUqdeTKE85rf+k8XqOZnpPvFNuBPzDi4kExAsiJohKdGzst0KKbVNEalfjrpnkk3Rhh6JT3mJ8COJE/6G/NTgkmUlTst11S4ASLriFuO1OCaARTbErd+mCK3owBDdhonY011cXHEB8XNo++i2CdNPKre7CbS0ms1Tkac/WG96mo5SxsjUHlXAF5zdIBWPBcN+enIbSF+hQXwI6LP2dvL73WnSWWO3kt0iR9YuPddVaTNSZYkdRRldVeUz1iH3uy77klyuKm7OeQcQplp1H6AA7TFhPKST5rW9TZ0UvamvMNPcz4k7viAsJhSmhItIM9hckrTTW+m8QVLV3IEte6I+Vr5Xpib1uAK3nzEPqAtDcOmSwzEJNkYD7ddT5zTaQVl/+9LZpizJ0z8yOGiDkJDVXbEyT6k8ynNVkRxG3BCCU7NAhUXdX4qspA8MZ7
 XutQMezh
 vRQYYj9Z4eM3ASyLTdfIefpYQieXekw6HtyUbjJoXqotXb0DN35scjouaDpKBEso47MKP+2Km3qfUYDag5xCf7WWfvGkBG7bI1vtEKHn3YXPtbzsmk+0lKq53ESGfEiRzXVaN65ys7qAlJmWW1oFIt3BaQPT/xxT+7E5ffBv1aqC4rt4YFjFjxKo9Zr0OBKJKnDuRPgqKPODz9spx7r+rO7l/u6uodI22OJuSQ0dewDwJHG090Z+wdXcQLIgkEzZHwon9y+tlhTMw4tTUhRx2J71aopzbn3aBCqsKuz4MqRt5s+cTShsTtvWq+7fxBmbqabL9YJUVznyUfFJfeW4rPNHSFANb8tS3FSwTLSFPRvk+4TriLPuovwUpeSjSHWYV1ZYPSLao0GUo0D5MGV+DgCV2HvP4vobq+LGKdnS7CWEfq7n5CqoAfpa85g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 02:26:44PM +0800, Muchun Song wrote:
> 
> 
> > On Aug 11, 2026, at 13:26, Anshuman Khandual <anshuman.khandual@arm.com> wrote:
> > 
> > On Tue, Aug 11, 2026 at 10:48:31AM +0800, Muchun Song wrote:
> >> 
> >> 
> >>> On Aug 11, 2026, at 07:08, Sourav Panda <souravpanda@google.com> wrote:
> >>> 
> >>> alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> >>> alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> >>> nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> >>> the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
> >>> alloc_gigantic_frozen_folio().
> >>> 
> >>> Additionally, hugetlb_cma_alloc_frozen_folio() previously attempted
> >>> allocation on hugetlb_cma[nid] without verifying if nid is included in
> >>> the caller's nodemask. Adding a node_isset(nid, *nodemask) check ensures
> >>> the initial preferred node allocation honors the memory policy / nodemask.
> >>> 
> >>> However, hugetlb_cma_alloc_frozen_folio() dereferences the nodemask in
> >>> node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
> >>> leading to a null pointer dereference kernel panic when nodemask is NULL.
> >>> 
> >>> Fix this by checking if nodemask is NULL in
> >>> hugetlb_cma_alloc_frozen_folio() and defaulting it to
> >>> cpuset_current_mems_allowed. Enclose the allocation attempts within
> >>> the cpuset seqcount retry loop so that if the cpuset changes concurrently
> >>> during allocation, the attempts are retried using the updated nodemask.
> >>> This ensures that the initial node check and fallback loop safely honor
> >>> the task's cpuset without violating cpuset constraints or causing NULL
> >>> pointer dereferences or unexpected allocation failures.
> >>> 
> >>> From a userspace perspective, this bug allows an unprivileged user to
> >>> crash the kernel (trigger a panic) by requesting a gigantic hugepage
> >>> allocation with MPOL_PREFERRED_MANY on a system where CMA is only
> >>> configured on a subset of NUMA nodes.
> >>> 
> >>> This can be reproduced by booting a VM with two NUMA nodes, restricting
> >>> CMA to Node 1 (e.g., hugetlb_cma=1:1G default_hugepagesz=1G
> >>> hugepagesz=1G hugepages=0), and running a program that allocates a
> >>> 1GB hugepage area without reserving, restricts allocation to Node 0
> >>> using mbind() with MPOL_PREFERRED_MANY, and triggers a page fault:
> >>> 
> >>> void *ptr = mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
> >>>                  MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
> >>>                  MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
> >>> unsigned long nodemask = 1; /* Node 0 */
> >>> mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
> >>>       sizeof(nodemask) * 8, 0);
> >>> memset(ptr, 0, 1UL << 30); /* Trigger fault */
> >>> 
> >>> This results in a NULL pointer dereference:
> >>> 
> >>> BUG: kernel NULL pointer dereference, address: 0000000000000000
> >>> #PF: supervisor read access in kernel mode
> >>> #PF: error_code(0x0000) - not-present page
> >>> Oops: Oops: 0000 [#1] SMP NOPTI
> >>> RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
> >>> Call Trace:
> >>>  <TASK>
> >>>  only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
> >>>  alloc_surplus_hugetlb_folio+0x6d/0x100
> >>>  alloc_hugetlb_folio+0x3c5/0x660
> >>>  hugetlb_no_page+0x3d9/0x650
> >>> 
> >>> Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
> >>> Cc: stable@vger.kernel.org
> >>> Signed-off-by: Sourav Panda <souravpanda@google.com>
> >>> ---
> >>> Changes in v6:
> >>> - Enclosed the CMA allocation attempts within the cpuset seqcount retry loop,
> >>> retrying allocation upon cpuset mems_allowed updates to prevent unexpected
> >>> allocation failures as suggested by Muchun Song.
> >>> - v5: https://lore.kernel.org/linux-mm/20260809043250.2917406-1-souravpanda@google.com/
> >>> - v4: https://lore.kernel.org/linux-mm/20260726072935.3513996-1-souravpanda@google.com/
> >>> - v3: https://lore.kernel.org/linux-mm/20260705175119.440599-1-souravpanda@google.com/
> >>> - v2: https://lore.kernel.org/linux-mm/20260704174930.2885785-1-souravpanda@google.com/
> >>> - v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-souravpanda@google.com/
> >>> 
> >>> mm/hugetlb_cma.c | 23 ++++++++++++++++++-----
> >>> 1 file changed, 18 insertions(+), 5 deletions(-)
> >>> 
> >>> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> >>> index 39344d6c78d8..9debf033d4fd 100644
> >>> --- a/mm/hugetlb_cma.c
> >>> +++ b/mm/hugetlb_cma.c
> >>> @@ -3,6 +3,7 @@
> >>> #include <linux/mm.h>
> >>> #include <linux/cma.h>
> >>> #include <linux/compiler.h>
> >>> +#include <linux/cpuset.h>
> >>> #include <linux/mm_inline.h>
> >>> 
> >>> #include <asm/page.h>
> >>> @@ -30,15 +31,27 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
> >>> int node;
> >>> struct folio *folio;
> >>> struct page *page = NULL;
> >>> +  const nodemask_t *nmask;
> >>> +  nodemask_t local_node_mask;
> >>> +  unsigned int cpuset_mems_cookie;
> >>> 
> >>> if (!hugetlb_cma_size)
> >>> return NULL;
> >>> 
> >>> -  if (hugetlb_cma[nid])
> >>> + retry_cpuset:
> >>> +  if (!nodemask) {
> >>> +  cpuset_mems_cookie = read_mems_allowed_begin();
> >>> +  local_node_mask = cpuset_current_mems_allowed;
> >>> +  nmask = &local_node_mask;
> >> 
> >> I don't think we need a local_node_mask, nmask = &cpuset_current_mems_allowed
> >> is enough. nodemask_t could be a huge array, so it might consume a lot of memory
> >> on the stack. I don't think we need to do that unless we see a clear necessity.
> > 
> > But does not local_node_mask capture current snapshot for cpuset_current_mems_allowed
> > after first taking a reference via read_mems_allowed_begin() which ensures that nmask
> > has a constant value there after. Otherwise nmask could just change value by the time
> > it actually gets used.
> 
> However, this value can change while you are copying it, so a snapshot itself is not
> a consistent value. Right?

Yes it can change while copying, although it stays consistent for the for loop
later but that might not be necessary after all. As mentioned earlier it seems
OK drop the local variable here.

> 
> > 
> >> 
> >> Otherwise, LGTM.
> >> 
> >> Thanks.
> >> 
> >>> +  } else {
> >>> +  nmask = nodemask;
> >>> +  }
> >>> +
> >>> +  if (hugetlb_cma[nid] && node_isset(nid, *nmask))
> >>> page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
> >>> 
> >>> if (!page && !(gfp_mask & __GFP_THISNODE)) {
> >>> -  for_each_node_mask(node, *nodemask) {
> >>> +  for_each_node_mask(node, *nmask) {
> >>> if (node == nid || !hugetlb_cma[node])
> >>> continue;
> >>> 
> >>> @@ -48,8 +61,12 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
> >>> }
> >>> }
> >>> 
> >>> -  if (!page)
> >>> +  if (!page) {
> >>> +  if (!nodemask &&
> >>> +      unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
> >>> +  goto retry_cpuset;
> >>> return NULL;
> >>> +  }
> >>> 
> >>> folio = page_folio(page);
> >>> folio_set_hugetlb_cma(folio);
> >>> -- 
> >>> 2.55.0
> 
> 

