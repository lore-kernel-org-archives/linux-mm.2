Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22B97C55174
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 02:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BD216B0092; Wed,  5 Aug 2026 22:30:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546A06B0093; Wed,  5 Aug 2026 22:30:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 484546B0095; Wed,  5 Aug 2026 22:30:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C874A6B0092
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 22:30:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 58880805A7
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:30:01 +0000 (UTC)
X-FDA: 85069264602.15.2144C33
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 40530100002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:29:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fClwuejs;
	spf=pass (imf14.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785983399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NVa0zWiLPUeRH28YcFdjAUUK4ATyuteDo/w4PnjWstA=;
	b=UIPxItofGUArL/cJ9cq2xvCw0o6Qd4eS8J9cQaH3zkoRLaN0UmKn6Gm7Z+hKJ91xs11WpC
	myTSsVe3elgRXU7fKqfwYKm7sa8NlykjLQoMGSH+amW9kO239ZzfX6WRRz0e2hRquZbjfi
	UlhOwNydFGKOIpmgLXq9xw0r2f6L560=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fClwuejs;
	spf=pass (imf14.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785983399;
	b=ZXW5D/tmQP7253xFCpbXiBvoF0g3vu050yCYRMoFX1kd79vl00zMO9SEFzw3RprBF3qodI
	clc/G+RioSG19Wr64R9NirTKOrxw3xUIZOOVBVBErIKXe3XI/qrE4WbirvGdeSjqxf9xSK
	LdZtbyiwJG/HW+9mEWGEHb0UyjiSf6o=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF25E153B;
	Wed,  5 Aug 2026 19:29:53 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 201C13F632;
	Wed,  5 Aug 2026 19:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785983397; bh=UdgR++WFVsyM7cNSr+SG64jFGpIq1iZ6UzNdkJcaotY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fClwuejsb4IM9cONZvcOYSJXk6oG1BNPBQSo6wZVUFYayeffQOZ0bWtikYGvsbW0g
	 JpjH2f04SgfPLtwpj8HrH66p/9MSR13M5hsWw2MtZgFWzQW+g/BltuAIdRJoNA9cli
	 Bz/adoORCz0NpZE5kQPX8Xq+DWpblC2vFBsEJOw0=
Date: Thu, 6 Aug 2026 07:59:54 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Sourav Panda <souravpanda@google.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org, 
	david@kernel.org, surenb@google.com, fvdl@google.com, gthelen@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm/hugetlb_cma: Fix null nodemask dereference in
 hugetlb_cma_alloc_frozen_folio
Message-ID: <f7twcacmpwknkfmlmajadcj3yrgfzbzisdmlwr7wjtumtny72l@odkp6wfuvlru>
References: <20260726072935.3513996-1-souravpanda@google.com>
 <nuoxvxqgb453fuj5ezhjn374chawnrao53tev3wdqigpc6pfnm@q5oamexnzqdz>
 <CANruzcTm5_Znta8ySQpAXJO10EXM8Nqov+SY-ZWG_6b03BTQLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANruzcTm5_Znta8ySQpAXJO10EXM8Nqov+SY-ZWG_6b03BTQLg@mail.gmail.com>
X-Stat-Signature: acf7kdtz6gmeqkx11itpkm3s34qwok4c
X-Rspamd-Queue-Id: 40530100002
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785983399-481037
X-HE-Meta: U2FsdGVkX19msPDSRVgPXvH02wlbq8zdGBoDL1XZQAi+k5he0TFBIB+7f8HSFsIgtYzFdPBf7aISvRfqb3C4tB9PO78QqtxubtXfk3btfq8jUIqaciLiZ6iEV30HmBKUo6//Y89aJHNdG6Mw6dD3FcEj+jcGBRbojl2q4v9zqKsoXrTSk+CgKt83Zfs6ItxmDSUrV+SLUhmDwCr1ntziVWRvFwh4rm4CRBXljGQbERYwnfsR+G0xSRlCKvvNwbzi/YnJZ5xOKI/a/IpN4Oo9w/D6nxHsouJU9vJ9o18Gddlwroaw+rzYy04ZEb8L2wlPOlmnspA0Mf0/8PRiuL1F8CNfEcBpXE/bfBK3J7/tkLseG3T0tG3vVQTAePA4JFhPZ75pasjbWdogKDFbvPxVTy/xzTEDT2rttR3Fye1JdN3zBwMtLVSbJOl/wpxa5H7VArC4sJ8rFEkoETgSprLcudU4CRx3LTgDBy2nXUnnomPjQ+1Nt8HqVGLsMRjgYGEBKRBB2qaq7mzNXdSNZxBqZrGjOL2kLd1LWGjySQgC5uGCJ/ZW7Favs7kjCmw+H0/gtKVr31wmlDSQzyWQ4nznkZrFdPidO3ryazEEJU7XdJZ/g1PsgDl3OfDx+9RCES70HAhfmz0NAb0u2CHBwrm7jvarHs3cVaKrpwz5Bnl0XQ2CffnonWHT4CUTnya8ww7sT2ytosv9VyPNmNK6aSSzuS76bQwz/q27y07/BIxuX4Pp5fnVnUXtCl5PERj4QbquhliOBnIt9hXuxqYrXplhjh1HLN9MC9PI5Ur2umJg27mCp+ZCADwwAmUfDkClJmOxJlwTKyW1EH1xEkw1yiYEKsQHqDr7CHdmxpW8M65QD+Iy5qY/AkLxdRoXr6GEfqUOjtiK4rX4PDdWTmeNn/mJDUfk0MsfkMhjAwj9W10XnUjlUxOyoAEpeH/q+CdWZmYa7X4Z73tKO7tfE4NxhSj
 htx58qRk
 u0myRSSgSoS0csj+1ncCJ5eXejBYRmEdPsDW8oqsbiqzdnXNReoFC35SibTCR6AHOjEZ0Ihn3zVxHuRK9+lUNlqg2AVzUzN8jnqGVuHRBnlxBs4vVdTYD6wCjuzfES0VyUlVf+4wyzcEb+ouO4HwEnNAtoQnUJafHkYn7ALvmwZ/OlqTHF80L+K5bfniikYWqvIpHw4us+MjXj46upVv+x1ZYVALAg2Nks2WX92GUcr9quy+/1Z7bxJlPdL3TMW7XtfqGWDSJOM433pRPQW7ajMgpDk+4v1qJ6M63KZlCl9u+Ypan0NNXofReHV9uu4u8snHtsEZymOF+dd22XyGX2Ot7OWjcJMdqW9xOWAJ7tU7bpq0A50BjeZSTANhB2228a4QqTkqoo3j+8C2BhT6jXPK9HRQluzgRi504VHOD0/8dbiwiBikV8DMdfRwBDgka0sCh9QNT+/N27gh6n+G3V6u8r5ZGDh42abjSQ8LOGRCLOhrkLxm/Zkmd+vwJoxsXyjwH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 09:42:45PM -0700, Sourav Panda wrote:
> On Mon, Aug 3, 2026 at 2:48 AM Anshuman Khandual
> <anshuman.khandual@arm.com> wrote:
> >
> > On Sun, Jul 26, 2026 at 07:29:34AM +0000, Sourav Panda wrote:
> > > alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> > > alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> > > nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> > > the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
> > > alloc_gigantic_frozen_folio().
> > >
> > > hugetlb_cma_alloc_frozen_folio() blindly dereferences the nodemask in
> > > node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
> > > leading to a null pointer dereference kernel panic.
> >
> > node_isset() is being addded here in this change right ? OR was there
> > another path via node_isset() which could have been called on a NULL
> > valued nodemask ? Although subsequent for_each_node_mask() could do
> > the required dereference as mentioned earlier.
> >
> 
> Thanks for the review, Anshuman!
> 
> Sashiko [1] suggested adding node_isset(nid, *nodemask) in v1 because
> without it, hugetlb_cma_alloc_frozen_folio() could allocate from a node
> without checking whether it is actually allowed by the caller's memory
> policy / nodemask.

Fair enough.

> 
> Once we added that check, both node_isset(nid, *nodemask) and
> for_each_node_mask(node, *nodemask) became potential NULL pointer
> dereferences when nodemask is NULL.

Got it, thanks !

> 
> [1] https://sashiko.dev/#/patchset/20260702215713.627941-1-souravpanda@google.com
> 
> Thanks!
> Sourav
> 
> 
> > >
> > > Fix this by checking if nodemask is NULL in
> > > hugetlb_cma_alloc_frozen_folio() and defaulting it to
> > > node_states[N_MEMORY]. This allows hugetlb_cma allocations to fall
> > > back to any node with memory, keeping behavior consistent with
> > > alloc_contig_frozen_pages() and alloc_buddy_frozen_folio().
> > >
> > > From a userspace perspective, this bug allows an unprivileged user to
> > > crash the kernel (trigger a panic) by requesting a gigantic hugepage
> > > allocation with MPOL_PREFERRED_MANY on a system where CMA is only
> > > configured on a subset of NUMA nodes.
> > >
> > > This can be reproduced by booting a VM with two NUMA nodes, restricting
> > > CMA to Node 1 (e.g., hugetlb_cma=1:1G default_hugepagesz=1G
> > > hugepagesz=1G hugepages=0), and running a program that allocates a
> > > 1GB hugepage area without reserving, restricts allocation to Node 0
> > > using mbind() with MPOL_PREFERRED_MANY, and triggers a page fault:
> > >
> > >   void *ptr = mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
> > >                    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
> > >                    MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
> > >   unsigned long nodemask = 1; /* Node 0 */
> > >   mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
> > >         sizeof(nodemask) * 8, 0);
> > >   memset(ptr, 0, 1UL << 30); /* Trigger fault */
> > >
> > > This results in a NULL pointer dereference:
> > >
> > >   BUG: kernel NULL pointer dereference, address: 0000000000000000
> > >   #PF: supervisor read access in kernel mode
> > >   #PF: error_code(0x0000) - not-present page
> > >   Oops: Oops: 0000 [#1] SMP NOPTI
> > >   RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
> > >   Call Trace:
> > >    <TASK>
> > >    only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
> > >    alloc_surplus_hugetlb_folio+0x6d/0x100
> > >    alloc_hugetlb_folio+0x3c5/0x660
> > >    hugetlb_no_page+0x3d9/0x650
> > >
> > > Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Sourav Panda <souravpanda@google.com>
> > > ---
> > > Changes in v4:
> > > - Reverted the alloc_fresh_hugetlb_folio() cpuset snapshot approach from v3.
> > >   As Muchun Song pointed out, snapshotting cpuset_current_mems_allowed does
> > >   not prevent false-positive allocation failures without complex retry loops,
> > >   and alloc_contig_frozen_pages() / alloc_buddy_frozen_folio() already handle
> > >   NULL nodemasks safely internally.
> > > - Handled NULL nodemask directly inside hugetlb_cma_alloc_frozen_folio()
> > >   by defaulting nodemask to node_states[N_MEMORY] (Option 2), keeping
> > >   HugeTLB allocators clean and consistent.
> > > - v3: https://lore.kernel.org/linux-mm/20260705175119.440599-1-souravpanda@google.com/
> > > - v2: https://lore.kernel.org/linux-mm/20260704174930.2885785-1-souravpanda@google.com/
> > > - v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-souravpanda@google.com/
> > >
> > >  mm/hugetlb_cma.c | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> > > index 39344d6c78d8..5744de0ceeb7 100644
> > > --- a/mm/hugetlb_cma.c
> > > +++ b/mm/hugetlb_cma.c
> > > @@ -34,7 +34,10 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
> > >       if (!hugetlb_cma_size)
> > >               return NULL;
> > >
> > > -     if (hugetlb_cma[nid])
> > > +     if (!nodemask)
> > > +             nodemask = &node_states[N_MEMORY];
> > > +
> > > +     if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
> > >               page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
> > >
> > >       if (!page && !(gfp_mask & __GFP_THISNODE)) {
> > > --
> > > 2.55.0

