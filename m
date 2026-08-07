Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9573FC2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 05:29:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33B996B008A; Fri,  7 Aug 2026 01:29:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EC566B0092; Fri,  7 Aug 2026 01:29:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 205CE6B0093; Fri,  7 Aug 2026 01:29:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E343C6B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 01:29:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B68D4120287
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 05:29:04 +0000 (UTC)
X-FDA: 85073344608.13.9F783DE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 88FB9140002
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 05:29:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aNUaugrf;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786080543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MfwIUJIU9jK9DrnIt+JpVku/4RqpSGfzmhTFwI2tgmg=;
	b=XjcLa9ZivSM8kM6TjObPIQrPiLVlm0ovVoPhKuQRTYOMw+f/D9VgsLf5qqQDeKRshqrak1
	+T9nyM4qUZ/W6SVvOHjvTKEZSKr2vZYI0/CnDJwaeQxcvzw8ixzFNEbba9Q4kQOkeeD+aG
	NroU72yjYg+WmLnh1AuCotVg1qx8c+s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aNUaugrf;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786080543;
	b=YILq4ZJb18jpOJHlI8HjbmTyCBAlsZete9R7xmFOaXaEtUlyiuz8OimFLnMwuPQ4YBLy+E
	+9jmizfQjIf3CUQT9wv3CojzitNIe0/vT/Wc3N1n1DteTnsJ5lML74oQOGueJjCv0g7RuX
	hG6NANDsYU1hP2snWSWLg5xTVhouiGA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4867D1516;
	Thu,  6 Aug 2026 22:28:57 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8C6043F86F;
	Thu,  6 Aug 2026 22:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786080541; bh=nDAkYo0hrzOnAhrXhE0oVyDa2QZmEKKL8t7FWQER9eQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aNUaugrfiCSqau3AS/lgU+/E5gaA0eGgQy4IjbwjVZFQkx34GWPaEfbhNiTygLF5L
	 eWcjwGrPpGMAY999ECcWrDRZ5a9iB+lYPj9wXTv00KnVu3ZINxHiKGhAElg/kVuUjn
	 DBDNi/x6V5bOFcbvbk8EmDx53yuxxFdzlgwEztpE=
Date: Fri, 7 Aug 2026 10:58:57 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Sourav Panda <souravpanda@google.com>
Cc: Usama Arif <usama.arif@linux.dev>, muchun.song@linux.dev, 
	osalvador@suse.de, akpm@linux-foundation.org, david@kernel.org, surenb@google.com, 
	fvdl@google.com, gthelen@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm/hugetlb_cma: Fix null nodemask dereference in
 hugetlb_cma_alloc_frozen_folio
Message-ID: <2sipzzq7amhd5kn4xbqmtzc25iud2zp76dhpefcujqqpcnpqrt@czyz3dag6hlp>
References: <20260726072935.3513996-1-souravpanda@google.com>
 <20260805202444.1573218-1-usama.arif@linux.dev>
 <2qq6r5zvegrk5bbx7qbkscwqmccda7mxtzuvd3wln24yjm2qhx@663fzadsgmg3>
 <CANruzcT9PEXYRu1t_ge9ZNE8hLBpt6rWP4CwsBUkoZQTtpPKdA@mail.gmail.com>
 <007cdb8b-01e3-4d73-9ac9-1a52ab5798dd@linux.dev>
 <CANruzcR5AZHEg1TdAGG3Qm292vHXMB3BXvssm_rkv+xj+TBnNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANruzcR5AZHEg1TdAGG3Qm292vHXMB3BXvssm_rkv+xj+TBnNQ@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 88FB9140002
X-Stat-Signature: omunyzwqs3bffbunnqsr1ioozd7kk1oh
X-Rspam-User: 
X-HE-Tag: 1786080542-905827
X-HE-Meta: U2FsdGVkX1/nHfPQHQ81EyOXiMSoNv+F8PZC3KVvKwZF8Enu9yQJEDmb8zm32X13TnzbTin3L3lfKv+OgTG9lDiMpK3FV3pxoPzqF7rw5F1V1yY6tMBtcTzaDB3v5NAp44gIJmFYm+2VS+ZghVvoTIfG5eyDvVsY1rF5LC0NY8PgBjBnQ8GUfF4AHo6CAvnc7rbnQMZE331Do29I4fO0puCYgh6OA4DT93i1WBVRbKvAUVfMLRcYqohfKtMr4GQVYq6O6O/Wx+A4NdK3fU+uv2uVsOeot8zm/3dhlzbsO6E5HzbyKnux7+q9zeLp090U9dfBZullwe9SDKi1UGoSajIVLRKNhQrJNpXwqvDOO85z15CEzNyRs3KJ39eMtAAJxcIr/2EEOV2KTllClMpgLYXZyN0I+7kHJFKjtM6AfZvuMpKA+o2HeLvX6Wj5VmQeV1B4SYJ3JAfiKgDcLDP8MDzxS168ZucKHsvsWCwnxe+Wylfzxkds3camLYL454FyYOa9gBrwmgYXIT7bZ9GhJTzLLcrl2TSimmrtVcBgsRL8wR7Vu0/4sB4Wv+3bXxuh/cpwIySRyfn62vhjGdxLLX4t5pEkm1VsKXxRhnssEgT6qJlciXfF+E8zEFSCnqp5zAjbJKe3mvGFL1Ema5yWXQR4VnRG/zzvcwb4NqrdOZ/QtJrHjUHqMJaSs6/EuLwP6nxWYNXKa+uZ93u2nOvoeNnBjYS+JDCk8m0WJ6nc0Wu/Ib4WD9gSxCMBOMIQMakqiX+lWWUaoR6R4s/ozEI9UXdHSw7VynZdf9Q1sh0j5J0CRVWzra3l+FwhXT9e6x1c2/8J39yFJtyiN/07va+crbLaetE2Fj6EWBSxYLE4HQj3U1JPBZ7hqOxFOW5cfY+KAe8gLt70VTZA7hKvFjF98cp4SkQGFiVQZa1zLzT1wed6mRgTaTiC3XBzVoxFr9mRbq//Fli47TLQUp6YDpU
 Fh4SQ945
 vYFOHrqNuk1KymbG8MeuNKEL6jKPQ2v+9hn/k2M3A157lwKM7eW2ZbStiOoU5HWVtZH+z4knG81bEaBUYtowNOOBGCEhh6/o5E+4AgO/18yhci3lmLOyURmBqBiT6+p7k8uj+lkfWVYnfJwIsAWtLvztiP8gvYjqBAWSowPA5IrM6eS5xkoCbFaOljafsNeFcEx22vIF92CY0VgM5+OaVwKAG04roOHx5KsA6K6sryW4tpTf/fF7r6nFpwpFhe9D8Nb1/WknyHJrGGASL4w6eKVWVyIHK8SBesXK9fUi7Jm8wzxN2T/ywR2wkekt9GN4Qx6QLnvQY761Po+8d8aZK2YFwINrjcNQO8NqSDJNjYfmVe+YZ+NiQKLaIsb0uIBDsDwpMcTcaVJEFIaKsgIBRV6VAPyZdqJpZ5MWmMxOL1Dr4v7O6ZrRfvKMm9AVf28EMbtAhE6MDArZ4Fqc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 09:11:29PM -0700, Sourav Panda wrote:
> On Thu, Aug 6, 2026 at 4:07 AM Usama Arif <usama.arif@linux.dev> wrote:
> >
> >
> >
> > On 06/08/2026 06:33, Sourav Panda wrote:
> > > On Wed, Aug 5, 2026 at 7:47 PM Anshuman Khandual
> > > <anshuman.khandual@arm.com> wrote:
> > >>
> > >> On Wed, Aug 05, 2026 at 01:24:42PM -0700, Usama Arif wrote:
> > >>> On Sun, 26 Jul 2026 07:29:34 +0000 Sourav Panda <souravpanda@google.com> wrote:
> > >>>
> > >>>> alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> > >>>> alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> > >>>> nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> > >>>> the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
> > >>>> alloc_gigantic_frozen_folio().
> > >>>>
> > >>>> hugetlb_cma_alloc_frozen_folio() blindly dereferences the nodemask in
> > >>>> node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
> > >>>> leading to a null pointer dereference kernel panic.
> > >>>>
> > >>>> Fix this by checking if nodemask is NULL in
> > >>>> hugetlb_cma_alloc_frozen_folio() and defaulting it to
> > >>>> node_states[N_MEMORY]. This allows hugetlb_cma allocations to fall
> > >>>> back to any node with memory, keeping behavior consistent with
> > >>>> alloc_contig_frozen_pages() and alloc_buddy_frozen_folio().
> > >>>>
> > >>>> >From a userspace perspective, this bug allows an unprivileged user to
> > >>>> crash the kernel (trigger a panic) by requesting a gigantic hugepage
> > >>>> allocation with MPOL_PREFERRED_MANY on a system where CMA is only
> > >>>> configured on a subset of NUMA nodes.
> > >>>>
> > >>>> This can be reproduced by booting a VM with two NUMA nodes, restricting
> > >>>> CMA to Node 1 (e.g., hugetlb_cma=1:1G default_hugepagesz=1G
> > >>>> hugepagesz=1G hugepages=0), and running a program that allocates a
> > >>>> 1GB hugepage area without reserving, restricts allocation to Node 0
> > >>>> using mbind() with MPOL_PREFERRED_MANY, and triggers a page fault:
> > >>>>
> > >>>>   void *ptr = mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
> > >>>>                    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
> > >>>>                    MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
> > >>>>   unsigned long nodemask = 1; /* Node 0 */
> > >>>>   mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
> > >>>>         sizeof(nodemask) * 8, 0);
> > >>>>   memset(ptr, 0, 1UL << 30); /* Trigger fault */
> > >>>>
> > >>>> This results in a NULL pointer dereference:
> > >>>>
> > >>>>   BUG: kernel NULL pointer dereference, address: 0000000000000000
> > >>>>   #PF: supervisor read access in kernel mode
> > >>>>   #PF: error_code(0x0000) - not-present page
> > >>>>   Oops: Oops: 0000 [#1] SMP NOPTI
> > >>>>   RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
> > >>>>   Call Trace:
> > >>>>    <TASK>
> > >>>>    only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
> > >>>>    alloc_surplus_hugetlb_folio+0x6d/0x100
> > >>>>    alloc_hugetlb_folio+0x3c5/0x660
> > >>>>    hugetlb_no_page+0x3d9/0x650
> > >>>>
> > >>>> Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
> > >>>> Cc: stable@vger.kernel.org
> > >>>> Signed-off-by: Sourav Panda <souravpanda@google.com>
> > >>>> ---
> > >>>> Changes in v4:
> > >>>> - Reverted the alloc_fresh_hugetlb_folio() cpuset snapshot approach from v3.
> > >>>>   As Muchun Song pointed out, snapshotting cpuset_current_mems_allowed does
> > >>>>   not prevent false-positive allocation failures without complex retry loops,
> > >>>>   and alloc_contig_frozen_pages() / alloc_buddy_frozen_folio() already handle
> > >>>>   NULL nodemasks safely internally.
> > >>>> - Handled NULL nodemask directly inside hugetlb_cma_alloc_frozen_folio()
> > >>>>   by defaulting nodemask to node_states[N_MEMORY] (Option 2), keeping
> > >>>>   HugeTLB allocators clean and consistent.
> > >>>> - v3: https://lore.kernel.org/linux-mm/20260705175119.440599-1-souravpanda@google.com/
> > >>>> - v2: https://lore.kernel.org/linux-mm/20260704174930.2885785-1-souravpanda@google.com/
> > >>>> - v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-souravpanda@google.com/
> > >>>>
> > >>>>  mm/hugetlb_cma.c | 5 ++++-
> > >>>>  1 file changed, 4 insertions(+), 1 deletion(-)
> > >>>>
> > >>>> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> > >>>> index 39344d6c78d8..5744de0ceeb7 100644
> > >>>> --- a/mm/hugetlb_cma.c
> > >>>> +++ b/mm/hugetlb_cma.c
> > >>>> @@ -34,7 +34,10 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
> > >>>>     if (!hugetlb_cma_size)
> > >>>>             return NULL;
> > >>>>
> > >>>> -   if (hugetlb_cma[nid])
> > >>>> +   if (!nodemask)
> > >>>> +           nodemask = &node_states[N_MEMORY];
> > >>>
> > >>> Hi Sourav,
> > >>>
> > >>> hmm what if cpuset.mems only allows allocation from node 0, and hugetlb CMA
> > >>> is only available on node 1. This will no now allow allocating a gigantic page
> > >>> on node 1 when its explicitly not allowed?
> > >>
> > >> That's fair point but should not the user be also responsible in provding a right
> > >> nodemask containing CMA memory if it prefers avoiding node_states[N_MEMORY] based
> > >> fallback mechanism in kernel ?
> > >>
> >
> > I don't think the task can be made responsible for providing a CMA-aware fallback mask
> > here.  Userspace supplies the MPOL_PREFERRED_MANY preference, but the kernel itself
> > changes the second attempt to a NULL nodemask.  That permits fallback outside the
> > preferred policy nodes; it does not permit fallback outside the task's hardwall cpuset.
> >
> > >
> > > We have precedence for three options, which makes selecting one difficult :)
> > >
> > > 1) nodemask = &cpuset_current_mems_allowed is currently being used in:
> > >        only_alloc_fresh_hugetlb_folio --> alloc_buddy_frozen_folio -->
> > > __alloc_frozen_pages_noprof --> prepare_alloc_pages.
> >
> > Here I think using &cpuset_current_mems_allowed is part of the page allocator's wider cpuset handling.
> >
> > > 2) Some places use cookies with cpuset_current_mems_allowed to prevent
> > > torn writes. But this adds complexity.
> > >        An example would be dequeue_hugetlb_folio_nodemask()
> > > 3) node_states[N_MEMORY] is sprinkled all over the kernel (simplest).
> > >
> >
> > I would prefer option 2.  A NULL mempolicy mask should fall back to
> > cpuset_current_mems_allowed, not all N_MEMORY nodes.
> >
> 
> Sounds good Usama :)
> 
> I will send a patch that replaces nodemask = &node_states[N_MEMORY];
> with the below:
> 
> + unsigned int cpuset_mems_cookie;
> +
> + do {
> + cpuset_mems_cookie = read_mems_allowed_begin();
> + local_node_mask = cpuset_current_mems_allowed;
> + } while (read_mems_allowed_retry(cpuset_mems_cookie));
> +
> + nodemask = &local_node_mask;

Although complexity increases with the above mechanism but probably
it might be better in terms of being compliant with task's hardwall
cpuset as explained by Usama earlier.

> 
> Will send it out tomorrow! Let me know if anyone has any objections.

I would say let's wait for a day or two before sending the respin.

> 
> >
> > >>>
> > >>> Would it not be better to check cpuset as well?
> > >>>
> > >>> Thanks,
> > >>> Usama
> > >>>
> > >>>> +
> > >>>> +   if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
> > >>>>             page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
> > >>>>
> > >>>>     if (!page && !(gfp_mask & __GFP_THISNODE)) {
> > >>>> --
> > >>>> 2.55.0
> > >>>>
> >

