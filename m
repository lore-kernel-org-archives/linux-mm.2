Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13931C61DD3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 03:23:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 157146B008C; Tue,  1 Sep 2026 23:23:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12CF76B0095; Tue,  1 Sep 2026 23:23:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0430C6B0096; Tue,  1 Sep 2026 23:23:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D92336B008C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:23:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 618991606DA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:23:01 +0000 (UTC)
X-FDA: 85167375762.16.FC2EBD5
Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1D7D1120009
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:22:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=PGbzWL1i;
	spf=pass (imf29.hostedemail.com: domain of "prvs=6980ef5b6=zcgao@amazon.com" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=6980ef5b6=zcgao@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788319379;
	b=0MOCXc1ocXgrDr0qTWwX3Tlb0eEdHfERKCHTYUMPod02+FkVT2mmHgkarEbuyTCyTfJDbf
	pQDjTnAq6wHRg/jT8QJANl/cp1v5WiIh1GnJpJrmKlo9nJ1zxPCBgskY/rVUrDLG7OQ93I
	vKaxEijjneAxPWlj1vCtF8cSSF3fZ8g=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=PGbzWL1i;
	spf=pass (imf29.hostedemail.com: domain of "prvs=6980ef5b6=zcgao@amazon.com" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=6980ef5b6=zcgao@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788319379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fDa24XfUwuNC5CheixKhacETQZ+iF+EhwNqflwAH/xY=;
	b=iU5FKyU5k/rE40AARrAprCIWzV4T2eqVmEfzbg8Acv/M+ym9gyF/3FU5oAgFNPdT74qXI3
	4sl5Y1V1aAfLTV8yhn8JWEE+aFVOdfuvBzteI5lXxAmxjyVFcRrJCIAT6tkih96wYN0sXk
	KAze51OX6x35vF75Au/RttHKOyyiXrY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1788319379; x=1819855379;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fDa24XfUwuNC5CheixKhacETQZ+iF+EhwNqflwAH/xY=;
  b=PGbzWL1iPF1SC/fW7DCn44uYz5oB4JYIYR5AYL7nlH5t4b+nEZs7sLw1
   zfBqINVTQ9WRF0jd/H3ss6yqLnirtmYOh4Y16HnEkj7+LZuTfiWRchWET
   u9V77IiSCCf+cEjjRHUbgnDSUoUX02n4NsjX04y05wkWRJOLZoWZ4qSu5
   RLa/ExdzcLLusYjnHIiZPVmJjht8SOyO0khyzXg3I4MnAd9Y+abY7OV+R
   VKrpr/droHcfV8Om7oj3SUpZ/BzlBzE7SjwR+VYk9s5xKTitay5AR/5Ic
   7bfK9eYjLD/A9fRgMx9sj7ae9z1/OR1aICGAhbrf3cxjXfVHvg9OZNIxf
   w==;
X-CSE-ConnectionGUID: VoRmV77YRkSl7cE9MTy5OQ==
X-CSE-MsgGUID: 3UwuCVqpSieYpHF33aVWIg==
X-IronPort-AV: E=Sophos;i="6.25,257,1779148800"; 
   d="scan'208";a="27548269"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 03:22:57 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:19572]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.55.52:2525] with esmtp (Farcaster)
 id 4e320bed-27ac-4bc1-9c81-17ec50b9090b; Wed, 2 Sep 2026 03:22:57 +0000 (UTC)
X-Farcaster-Flow-ID: 4e320bed-27ac-4bc1-9c81-17ec50b9090b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Wed, 2 Sep 2026 03:22:56 +0000
Received: from 6c7e67c92ceb.amazon.com (10.187.171.39) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Wed, 2 Sep 2026 03:22:56 +0000
From: Nathan Gao <zcgao@amazon.com>
To: SJ Park <sj@kernel.org>
CC: Nathan Gao <zcgao@amazon.com>, <akpm@linux-foundation.org>,
	<damon@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <baolin.wang@linux.alibaba.com>,
	<david@kernel.org>, <ryan.roberts@arm.com>
Subject: Re: [PATCH v3] mm/damon/ops-common: use a page-aligned address in damon_ptep_mkold()
Date: Tue, 1 Sep 2026 20:22:46 -0700
Message-ID: <20260902032248.86780-1-zcgao@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260902001142.107226-1-sj@kernel.org>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.171.39]
X-ClientProxiedBy: EX19D037UWC002.ant.amazon.com (10.13.139.250) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1D7D1120009
X-Stat-Signature: wpnu6yzk5g6uwkzwguq5p89y6737jd4f
X-HE-Tag: 1788319378-469792
X-HE-Meta: U2FsdGVkX1+Ju6OPeThwzA57wl2sSd1o2gTZIjzNlJzmhGQxs4dzrm5Hc7yxOK3ZRDQ2QTK/VtjkQFoRdN5E//MviDRclHIXCM9BQAM0+j17wvtJLu9Z30zUsejRtW8rVQvi5MhPaa172jKhWmwL0QAAkd4wy9XxrRfLRpKoL/TEMibP8CznNznEPcwWpkU6nvEMfvntdcs25MvtlWvWUIYeBuCd+SNIFSmPMSARvIAOCYnjJ0i4sJCsE+sIhqESpqp8OuMxiosSxkZKnSloRTc5qJjtII6Fj4qKWqJiiqS8RuHwfOobt+e1ZE0ROWPIlCKdgWy4bMtelR5ZcpwjXPUaOJLFtslJqGEoaum6fN3dxH57Yi2tsOcHFkPOmnr93vbjZ2TkW2AMJW6fzSviaGV8lNho2/2EaciPAaH32/D4xfmFLmeWkkh0T+6I/H8ri94exgP6yhF2vMw8bcrgQ9o6FXMMtAckixD/n3YzYmgpeN5auo7gJqr4xo87lfW49HelDq2hieDnP1yN2KmhgNomfd5cK9PZGs8p30WXCxOWyUYw1rGcNox/NobA2wnZ5WkKx6gTqw5hG4DOgn9kkHSUA+Wnbpkg0Ku112g4qiFONM16wbX+mv2NmojztkzxwpdWdLcIa/6j4yPRrh7Dq6m7mMSjvA6jVHkcXigYr0+1KO+xi8Bjb5F48HX3MPkGlGmfKKPvTeo6j7lEzP4AbblTi7aZCyO+VW6nKsNbRgrGg5Wx9Y3ZMpaX1IkRU5ryIJyjIAGJcPnTbqpaEScw98Fl7M1LAOUjPKLT5yeW5Xtg5BNhgROLZYCEcS+ScIGJ1cdLw8kmM4Sv8/E/QhlT2tuekhhaSzLu628sN+DiV8EZq9pbg/d24uCZTL0X/f00I6xufgQPMFV0bY1nOPOLSFYZLxGDZBdlb+hlu7nNuh7vEZ1464zL9zPG6Ixy4c4QvrB7HOub7I4fStDIbG4
 pC53uGbO
 c2fO+ubuJPwgUdHbVlp2UjON3i9ohJowAa/Xb2Z0UKI9msUzYqG21dyHut3pcciF533mskoelm/BrwmVe8TQpy4n/YczHRmJ7wSkMj5LTYMT3LE3jbirsg6xM5j5qF0hnnONhXOykclvh/wf5BuaafUzHRbvr1/G1LoBHfEfW79LxEemw27VugB1WRlP6TgJASDLOP7KMU9j183LYVkxgHS0Tw2riIHJEYFADI0WvFtMbTWJqUUT1j7c0J+ebYxvX2Upu/neRlPwV8kS/r891tEOz/gSYg2PSKVfR4pWXAViwIxcmDLqubDxkVepbvp7Q2dG/r9yKdJZ7lxzkFDHSCNGEugx8ork6v8K/m/ec6vlfWBg5pC9FyfxRkOSiDAHDWLQvX/2RfGesZ96xBz8KfA0DWBwqUMgYUdjeT8B+KTTWTfJUBSN0JzKJQrnM/LLoeoRToizjYhBkFVH1GjPhTyUtYzvn5YJh/tTbpi6ynlHO4drFif4kxL3G9/xqNQoEbJ2WU/LqU14rvuYo2GSIf15WnAQH538Xp9htSAmwp8zF03JU70BUs48U30DJCCG9ebM9/ISCXe2OHiGXwNPc63AdhPuoLYtOJgvDos4ZHHR8Crfz83Ztx6UacacrJgwXZ828L2PzCuA803VCzuE0+6cc7SoarWozo/MUpGZ/QHDTIrRMNtMuxJdHya93zzP0BQMaik5t/+cptgwXu9IB+5UI28HD2tWs9R8STcuozvm/RWmeRyWjKJ8TNUJrc3PIoVLMdQUzK7HyjI9oWd08ERu+0FCJ3Vr/PY0U9iIjwUajbAKpYiM+0BrlZCZED7YREfOU1Hq8x7GPxTRgXvxWpk1ilg2h4tgQ0r/MKbAFJGYC3+mfblQldgAyKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 17:11:41 -0700 SJ Park <sj@kernel.org> wrote:

> On Tue, 1 Sep 2026 13:10:01 -0700 Nathan Gao <zcgao@amazon.com> wrote:
> 
> > __damon_va_prepare_access_check() picks a random byte address within the
> > region and stores it in r->sampling_addr. damon_va_mkold() passes it into
> > a page table walk, which hands it to damon_ptep_mkold() as the address of
> > the page to sample:
> > 
> >   damon_va_mkold(mm, r->sampling_addr)
> >     damon_va_walk_page_range(mm, addr, addr + 1)
> >       damon_mkold_pmd_entry()
> >         damon_ptep_mkold(pte, vma, addr)
> >           ptep_test_and_clear_young(vma, addr, pte)
> >           mmu_notifier_clear_young(mm, addr, addr + PAGE_SIZE)
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
> 
> I just wanted to call out again that I'm wondering if we could restore the
> unaligned address support in the helper.  E.g., as a very dirty hack that I can
> imagine off the top of my head,
> 
> '''
> --- a/arch/arm64/mm/contpte.c
> +++ b/arch/arm64/mm/contpte.c
> @@ -30,6 +30,7 @@ static inline pte_t *contpte_align_addr_ptep(unsigned long *start,
>                                              unsigned long *end, pte_t *ptep,
>                                              unsigned int nr)
>  {
> +       *start = PAGE_ALIGN_DOWN(*start);
>         /*
>          * Note: caller must ensure these nr PTEs are consecutive (present)
>          * PTEs that map consecutive pages of the same large folio within a
> '''
> 
> I and Nathan have no strong clue, so we are looking for Baolin and others'
> opinion.
> 
> While waiting for the opinions, I and Nathan agree we should stop bleeding with
> a pinpoint hotfix change in DAMON.
> 
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
> > 
> > Align the address down to a page boundary in damon_ptep_mkold(). Its
> > ptep_test_and_clear_young() call is the only place DAMON can reach
> > contpte_test_and_clear_young_ptes() from. r->sampling_addr itself is left
> > as is, so the sampling and region bookkeeping semantics are unchanged.
> > 
> > Fixes: 6f0e1142173a ("arm64: mm: support batch clearing of the young flag for large folios")
> > Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Cc: David Hildenbrand (Arm) <david@kernel.org>
> > Cc: Ryan Roberts <ryan.roberts@arm.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Nathan Gao <zcgao@amazon.com>
> > ---
> > V2 -> V3:
> > - Move the alignment into damon_ptep_mkold(), instead of aligning in
> >   damon_va_mkold() and damon_va_young().  The ptep_test_and_clear_young()
> >   call in damon_ptep_mkold() is DAMON's only path to
> >   contpte_test_and_clear_young_ptes(), so damon_ptep_mkold() is the
> >   closest place in DAMON to the function that requires an aligned
> >   address (SJ)
> 
> Thank you for doing this revision for my humble request!
> 
> > 
> > V1 -> V2:
> > - Align inside damon_va_mkold() and damon_va_young() rather than aligning
> >   r->sampling_addr itself, so that sub-page sampling addresses remain
> >   possible for future non-PTE access check primitives (SJ)
> > - Point Fixes: at 6f0e1142173a instead of 3f49584b262c, since the
> >   unaligned address was harmless before that commit (SJ)
> > - Describe how the issue was noticed and what it does to the kernel (SJ)
> > 
> > v2: https://lore.kernel.org/all/20260831221151.50561-1-zcgao@amazon.com/
> > v1: https://lore.kernel.org/all/20260827193821.46115-1-zcgao@amazon.com/
> > 
> >  mm/damon/ops-common.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> > index 0bcad6b1e5b9e..cd8aa08233e54 100644
> > --- a/mm/damon/ops-common.c
> > +++ b/mm/damon/ops-common.c
> > @@ -46,6 +46,12 @@ void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr
> >  	bool young = false;
> >  	unsigned long pfn;
> >  
> > +	/*
> > +	 * Arch implementation of ptep_test_and_clear_young() may require
> > +	 * aligned @addr
> > +	 */
> > +	addr = PAGE_ALIGN_DOWN(addr);
> > +
> >  	if (likely(pte_present(pteval)))
> >  		pfn = pte_pfn(pteval);
> >  	else
> 
> I agree this should fix the issue.
> 
> Maybe I'm being too picky, but...  'addr' is also being used in later
> mmu_notifier_clear_young() call.  Could we further scope down to do the
> alignment only for the function that disallows unaligned address?  For example,
> 
> '''
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -61,7 +61,12 @@ void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr
>          * device aspects.
>          */
>         if (likely(pte_present(pteval)))
> -               young |= ptep_test_and_clear_young(vma, addr, pte);
> +               /*
> +                * Arch implementation of ptep_test_and_clear_young() may
> +                * require aligned @addr
> +                */
> +               young |= ptep_test_and_clear_young(vma, PAGE_ALIGN_DOWN(addr),
> +                               pte);
>         young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
>         if (young)
>                 folio_set_young(folio);
> '''
> 
> 

No problem.  I think I get your point, to scope the fix down as much as
possible.

v4: https://lore.kernel.org/all/20260902031655.84721-1-zcgao@amazon.com/

> > -- 
> > 2.50.1
> 
> 
> Thanks,
> SJ

Thanks,
Nathan

Sent using hkml (https://github.com/sjp38/hackermail)

