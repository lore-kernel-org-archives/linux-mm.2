Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC048C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 20:26:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DABE06B0088; Tue,  1 Sep 2026 16:26:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5D436B008A; Tue,  1 Sep 2026 16:26:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C24B76B008C; Tue,  1 Sep 2026 16:26:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9EB6C6B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:26:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 265BB1604F5
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:26:10 +0000 (UTC)
X-FDA: 85166325300.22.F5BA16B
Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	by imf20.hostedemail.com (Postfix) with ESMTP id C39041C0008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:26:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=fYdZx2vq;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf20.hostedemail.com: domain of "prvs=697d64fe3=zcgao@amazon.com" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=697d64fe3=zcgao@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788294368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j1+lz1XGiX0BvlzPaXPOzNmEwexlRwPc116ec8ON0iw=;
	b=Q8TUpib7dleeDiyagHE+VvwEUFA15/Ia5dObWV5sQE9ChvrNDEnH4RK+8DjG97FLoByeMD
	jD0yyldg90q2TZT1hu1njLFjV5JmQz0g3XmQmj+K8d4DAWH18SVgUx5pHKjQYw1kBKM3mM
	+lcGPjx7JVwndyNidZtwc+QBwx2MbPk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=fYdZx2vq;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf20.hostedemail.com: domain of "prvs=697d64fe3=zcgao@amazon.com" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=697d64fe3=zcgao@amazon.com"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788294368;
	b=eTVmR2w3O5KH7Gu5PwCF54ogiMPMLmGQydliME6Wd3hTDkhpbNhgYik0mVAh3m2IDLfgG3
	axRdqPSu4tEr2+NIeQfDVNRpFDUvkrA0Oe58TISSMSpUIrnoY3mVxzQv9mp2Scb7YbOU3s
	L4uwuwZk+G4+Nno6NQXD4XkM/DPnv5w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1788294367; x=1819830367;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j1+lz1XGiX0BvlzPaXPOzNmEwexlRwPc116ec8ON0iw=;
  b=fYdZx2vquDuvsY4PTUMnBjafHxHvf3Qzu7O9fZdhimkxkjx9KheQNsng
   io8kgntgiJgc6dhdKrJxctd7Okl6vBvXVU7zyrti7hnC4Jb8Ft22t/pvW
   MBOzwwCvflnrbfKWA550tW8rahqheleyhVobU4lAAMx7F/RXbPP3D43mK
   zj9W/9xlgwmPXMJCjQ2U+S4SgUi/rftYZl1ZlPulUDmuOr26k4U1nIlXT
   XzngHEnQqO82J/5a3/l1HHy+heaXI+VNw5tyAZhTi3TvoQnlSoZmq2bb/
   l+osxt5DMksZWEHi6hPa/r+wjH78OLi/2biDXSm/LNLWy3RnFh034yDo1
   Q==;
X-CSE-ConnectionGUID: TMfv6vunRVuzQxhi7I5z0w==
X-CSE-MsgGUID: 3XFDF2SwSuydFlJDKdPE+A==
X-IronPort-AV: E=Sophos;i="6.25,256,1779148800"; 
   d="scan'208";a="27441235"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 20:26:06 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:3112]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.52.146:2525] with esmtp (Farcaster)
 id ade34076-eba1-46fe-9270-4f79be2b816f; Tue, 1 Sep 2026 20:26:06 +0000 (UTC)
X-Farcaster-Flow-ID: ade34076-eba1-46fe-9270-4f79be2b816f
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Tue, 1 Sep 2026 20:26:06 +0000
Received: from 6c7e67c92ceb.amazon.com (10.187.170.39) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Tue, 1 Sep 2026 20:26:05 +0000
From: Nathan Gao <zcgao@amazon.com>
To: SJ Park <sj@kernel.org>
CC: Nathan Gao <zcgao@amazon.com>, <akpm@linux-foundation.org>,
	<damon@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <baolin.wang@linux.alibaba.com>,
	<david@kernel.org>, <ryan.roberts@arm.com>
Subject: Re: [PATCH v2] mm/damon/vaddr: use a page-aligned address for the sampling walks
Date: Tue, 1 Sep 2026 13:25:36 -0700
Message-ID: <20260901202556.39515-1-zcgao@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260901013551.91246-1-sj@kernel.org>
References: <20260831221151.50561-1-zcgao@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.170.39]
X-ClientProxiedBy: EX19D040UWA004.ant.amazon.com (10.13.139.93) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: djea98mb3a7bu9zmrew83i9pxkp5uoyg
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C39041C0008
X-Rspam-User: 
X-HE-Tag: 1788294367-272234
X-HE-Meta: U2FsdGVkX1/MJhCeCPvgiU0YRrxSvNG6KXZ91Z4mRFMRQCoUjryCTdn9t+ToGw+3eQzeAE9He/QPaiZ5iuf6WXqeqwYt+bNKNXbou2DDPtCO+hR5HyE1W71zW3Dfl8kvy7m3Gg9BX7husQMCTmaYRzhYL7vMd+2lpF9dXmZMC/WMHGhjcZQs+OPZOZ5khQFULfTCxwnySBiDCFC7Q7mUE5/GaNWJ2F2ajw6fAe6cu68PD6DjVboeLtXcrDo+7b0U5gOvWLOj4mG3aNDwTrl1RPAmD5y6f2Ape5sz2c2/BF+uRrgLKoka6HjtXOpZ+FW3QF7+8nkZClGO9qAHkq9DcxlqOgvMNOqwYNeEo21wBb937jQo9iintrnNRfAaEDdNV0WIs1B9U1OO60od0XkyPfRtlX0xmT6A7I7emAxVOPfeRhHNtvCzrJ9XVl4DKSyRKUOK2RZb5YVcwpO1EpU5e7UVGp7qLS4sNnYDBfxCtXJTrwqsNP0yQBaFjgyWTFJaL7mqYb9qY85cQaY2YgxV/p73Go3HLFMcXsDBEUiw+xMRnN8jqWJ11WBwtnXVsgdriGrmXcZUnpVdq4WfSKTsvCtfceDeuGAH/K+RdG63e89OVmsJavu1ZwC/7/AXkzbIHUd3Oy2kAIZsN325DGEgRZAf6Kjyd/ETJn//1bkgtShd/2s+v1GQIeBkxM7+VFaEUUf1GzgYo02Cq/J6SeWFrCQJtNNs/bKacrSi5HYhW1i/9YGTkhua6UXRtU/xLZJgBM3GMaa9OG0yrEerm183qxre1IYCKVQSsIQQ0Vx8LuAM9nUwM1ncprUQVnco+OKPYpnnh8vIywRuzvNKJQu/blRaJMJ95SLXVilP8d4wiB0wcEk7ndEXlpJaqBfkcQyq/JLXi81euja3Fevd56/qagbbTL5La48Tpp4KOPM3uN0WcXugazNItcW6dGkV8QLe9KLqL604PAnEr5mnTE/
 HyhSn/Hw
 WRjZ0WavGmM/pdNT9UQwCDfo20x+zUubjXvs1yo/UAX21e5xdBWlNfR9AiotAPC0DqGWM2343sYfehvdHU2wDReEoKehMAPeHCyJg2dt8R5rqdQCnpZ/mmYIlOJG9SYz1E0ZkGGX54S789A6/L/HPj0Aru/zngzvjd8KRsINhM6ngOV3RXMgT4xSBIL9qNy7eX/PDQlPLFeCeJxa58NqXJApR2kAjDElAaIL4GKlJEugxz8S0Bjm2499LCkkyiPvYGxiq1WaVJzknLmchDXre0myz0hfZLqd5mn4Pff/Thnf69djZnGZihsgOnXBFNfSvBvkp99Yqwne48BHOGTI91ebVZo2HOUGIjj5Xx1z7lEbviYjBXkzmWZKvVN2uxHq57sR3RK7egq5A7wmycr4QkYmpGCFEk+dxhfey3LSEsyg3+B3hQiyyU1CJ+mHq4RODROZm+5e8RtMVUdvnrZ72XkQcjhQgGVTtjvuWMfaRGNkUSMYXNZCtK6KmJWCPcc+TWrHDFTNpRnTLwoLCpWSFouhZFs8UZ9bcV30prVMYLQFcNnwnMjzG6hV84NRrOXysR+SJiSXXStACZICqjxiLUDUuI47H6qA8TTT8XDNGRmexZGqNbwvqTyln0UrnMAaXN1zVagM7Y5WkGKazuqokQcnuk8aDo7F1ZSOlmR26VVJYYzoIvbDCqqkR+9M55PerGwP7R1JSMt+WxLCc1uUAW734+4N6DdGgk8nMTeKd04raW5hIxazJyXly/ltzWH9BWMn/gknu/uLEbVkknfUASz/IVgiSf8tYM+qimFodNopumqHR344EWBFob4phackt68EtGlzrxpV7WA8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 18:35:50 -0700 SJ Park <sj@kernel.org> wrote:

> On Mon, 31 Aug 2026 15:11:51 -0700 Nathan Gao <zcgao@amazon.com> wrote:
> 
> > __damon_va_prepare_access_check() picks a random byte address within the
> > region and stores it in r->sampling_addr. There are two users of
> > r->sampling_addr in vaddr.c that pass it into a page table walk, and
> > both use it as the address of a page.
> > 
> >   damon_va_mkold(mm, r->sampling_addr)
> >     damon_va_walk_page_range(mm, addr, addr + 1)
> >       damon_mkold_pmd_entry()
> >         damon_ptep_mkold(pte, vma, addr)
> >           ptep_test_and_clear_young(vma, addr, pte)
> >           mmu_notifier_clear_young(mm, addr, addr + PAGE_SIZE)
> > 
> >   damon_va_young(mm, r->sampling_addr, &folio_sz)
> >     damon_va_walk_page_range(mm, addr, addr + 1)
> >       damon_young_pmd_entry()
> >         ptep_get(pte)
> >         mmu_notifier_test_young(walk->mm, addr)
> > 
> > For arm64, before commit 6f0e1142173a ("arm64: mm: support batch
> > clearing of the young flag for large folios"), the contpte helper walked
> > exactly CONT_PTES entries from the aligned-down page table pointer and
> > used @addr only to pass down to each entry, so an unaligned value was
> > harmless:
> > 
> >         ptep = contpte_align_down(ptep);
> >         addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
> >         for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
> > 
> > Now the range to walk is derived from @addr instead: end = addr +
> > nr * PAGE_SIZE, rounded up to CONT_PTE_SIZE. For a sample in the last
> > page of a contpte block, the sub-page offset puts end just past the
> > block boundary, so the round-up lands a whole block further and the
> > walk clears PTE_AF in CONT_PTES entries beyond the sampled block. For
> > the last block in a page table page, those entries are past the end of
> > that page, so the walk writes into the page that follows.
> > 
> > Triggered by the full 7.1/7.2 kernel selftest suite on arm64 (EC2
> > c/m6g.4xlarge). The kernel sometimes crashes at or shortly after the
> > DAMON test.
> > 
> > What the overrun does depends on the page that happens to follow the
> > page table, so there is no single signature. If that page is read-only,
> > the write faults in the sampling path itself:
> > 
> >   Unable to handle kernel write to read-only memory at virtual address ffff0003c5d2d000
> >     FSC = 0x0f: level 3 permission fault
> >     CM = 0, WnR = 1, TnD = 0, TagAccess = 0
> >   CPU: 10 UID: 0 PID: 3487 Comm: kdamond.2
> >   pc : contpte_test_and_clear_young_ptes+0x70/0xc0
> >   lr : damon_ptep_mkold+0x1e8/0x1f8
> >   Call trace:
> >    contpte_test_and_clear_young_ptes+0x70/0xc0 (P)
> >    damon_mkold_pmd_entry+0x150/0x170
> >    walk_pmd_range+0x110/0x2b0
> >    walk_pud_range+0x10c/0x208
> >    walk_pgd_range+0x134/0x258
> >    __walk_page_range+0x98/0x1b0
> >    walk_page_range_vma_unsafe+0x90/0x148
> >    walk_page_range_vma+0x28/0x40
> >    damon_va_walk_page_range+0x114/0x2b8
> >    damon_va_prepare_access_checks+0xec/0x1a8
> >    kdamond_fn+0x534/0x770
> >    kthread+0x128/0x138
> >    ret_from_fork+0x10/0x20
> > 
> > Otherwise the page is writable, the PTE_AF clearing succeeds silently
> > and the damage only surfaces later, in whatever happened to own the
> > page, so the backtrace is unrelated to DAMON and differs between runs.
> 
> Urgh, this must have been a painful debugging.  Sorry about that, and
> appreciate your great work on this!
> 

No problem at all!  Had fun digging into this. 

> > 
> > Align the address down to a page boundary in damon_va_mkold() and
> > damon_va_young(), the two users that pass it into a page table walk. It
> > is the address of the page to sample, so this matches its intended
> > meaning. r->sampling_addr itself is left as is, so the sampling and
> > region bookkeeping semantics are unchanged.
> 
> I'm still wondering if it makes sense to restore unaligned address support in
> contpte_test_and_clear_young_ptes() as a long term fix.
> 

I'd appreciate Baolin's thoughts here.  If it turns out callers are
expected to do the alignment, it would be better to have a WARN to expose
the issue.

> > 
> > Fixes: 6f0e1142173a ("arm64: mm: support batch clearing of the young flag for large folios")
> > Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Cc: David Hildenbrand (Arm) <david@kernel.org>
> > Cc: Ryan Roberts <ryan.roberts@arm.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Nathan Gao <zcgao@amazon.com>
> > ---
> > V1 -> V2:
> > - Align inside damon_va_mkold() and damon_va_young(), the two users that
> >   pass the address into a page table walk, rather than aligning
> >   r->sampling_addr itself, so that sub-page sampling addresses remain
> >   possible for future non-PTE access check primitives (SJ)
> > - Point Fixes: at 6f0e1142173a instead of 3f49584b262c, since the
> >   unaligned address was harmless before that commit (SJ)
> > - Describe how the issue was noticed and what it does to the kernel (SJ)
> > - Reword the subject to match the narrower change
> > 
> > v1: https://lore.kernel.org/all/20260827193821.46115-1-zcgao@amazon.com/
> > 
> >  mm/damon/vaddr.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> > index 2c1c1952c008d..e7aa18200088f 100644
> > --- a/mm/damon/vaddr.c
> > +++ b/mm/damon/vaddr.c
> > @@ -349,6 +349,9 @@ static void damon_va_mkold(struct mm_struct *mm, unsigned long addr)
> >  		.hugetlb_entry = damon_mkold_hugetlb_entry,
> >  	};
> >  
> > +	/* Arch helpers can derive a page range from @addr; align it down. */
> > +	addr = PAGE_ALIGN_DOWN(addr);
> > +
> >  	damon_va_walk_page_range(mm, addr, addr + 1, &damon_mkold_ops, NULL);
> 
> Could we do the alignment just before passing the addr to
> contpte_test_and_clear_young_ptes(), which is the exact function that disallows
> the unaligned address?
> 

Sent a v3.  It moves the alignment into damon_ptep_mkold(), the only place
in DAMON that reaches contpte_test_and_clear_young_ptes(), so it is as
close to that function as DAMON can get:

https://lore.kernel.org/all/20260901201001.33271-1-zcgao@amazon.com/

> >  }
> >  
> > @@ -482,6 +485,9 @@ static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
> >  		.hugetlb_entry = damon_young_hugetlb_entry,
> >  	};
> >  
> > +	/* Arch helpers can derive a page range from @addr; align it down. */
> > +	addr = PAGE_ALIGN_DOWN(addr);
> > +
> >  	damon_va_walk_page_range(mm, addr, addr + 1, &damon_young_ops, &arg);
> 
> Ditto.
> 
> >  	return arg.young;
> >  }
> > -- 
> > 2.50.1
> > 
> > 
> 
> 
> Thanks,
> SJ

Thanks,
Nathan

Sent using hkml (https://github.com/sjp38/hackermail)

