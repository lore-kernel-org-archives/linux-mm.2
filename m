Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC796C61DFD
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 01:36:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 987476B0088; Mon, 31 Aug 2026 21:36:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 937FD6B008A; Mon, 31 Aug 2026 21:36:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84D7A6B008C; Mon, 31 Aug 2026 21:36:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 583326B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 21:36:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 49098120326
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:36:01 +0000 (UTC)
X-FDA: 85163477322.09.72D5FC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id B064C1A0007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:35:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UPKr34kg;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788226559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r7mzqnDdkY1VrDdE5e4/l6tKv9BXqjTgShVJWiRcVpo=;
	b=IdVuVsJ1t1Ismbyx2cDumJVpHuEUf4wvbOvtlAcSuUCQpG4lgiF/IjgrlRMUmq9w1APMz4
	8s0tRrGgUzesBys0VoGRvzaj4Vz4mOkkuIhCjrApzdRSE1TK0RbaLc5eVV+XEUXXvJtqEz
	FTUqqOAI4CjNTOtRhJ4Ctz2eidrPm+k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788226559;
	b=Avq7QPMoReuVWRmmiiuYlqJfq424xkNL+CV+UsnO++d/6NAoc2GdUxocSSk3c2m0jliTXm
	cR5PAEagXHuml86jzXO67BdA8lh2semMbWesaxeU/wuDhKkUlnzdBx3qhNqy7l6wcLw/io
	M8Wm4Y0ABJtA415aiW/0CqQJ/F3BzK8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UPKr34kg;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D3F36601DE;
	Tue,  1 Sep 2026 01:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5221F000E9;
	Tue,  1 Sep 2026 01:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788226558;
	bh=r7mzqnDdkY1VrDdE5e4/l6tKv9BXqjTgShVJWiRcVpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UPKr34kg1t2Oqiy1DnXeEZdVBklcuQHtos0Dd5GLPFlpdoyeOaYqlAlai13P4/L+B
	 Hn6x7OxvtmUVrXLZNpOPFhRNRC4AXzdrRDTxm66FIx4MwpKSbeEHfRt9kbSLuc7BmI
	 N2zdPGQddOjdhEDzMCIG9KcWFLmSrYI3v8H1FlqrVWrm+z+btXzwaOMbSk3jhl1yeh
	 TR/sQbOowwA3Ofk7MGhZpw3oRfNs39np09iJm4GcwJpDpo9idm+HCzwf8Nn61H9MHU
	 NpPT/zE7KbgityUhGvJfbu3DaI+etC8/QxUximg/seRg1c0UWMURDXX6TEhJciZbTm
	 5PdtU0e3ijdng==
From: SJ Park <sj@kernel.org>
To: Nathan Gao <zcgao@amazon.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	ryan.roberts@arm.com
Subject: Re: [PATCH v2] mm/damon/vaddr: use a page-aligned address for the sampling walks
Date: Mon, 31 Aug 2026 18:35:50 -0700
Message-ID: <20260901013551.91246-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831221151.50561-1-zcgao@amazon.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 46c7jshu6hhc4asozsi7gms6woxdcoym
X-Rspamd-Queue-Id: B064C1A0007
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788226559-24563
X-HE-Meta: U2FsdGVkX1+kBfAxwFB6P3HcKhYZY6Hb+nvc3gQ62+fCuqeQB3ZA8zprJ/70d6cQh8lOslCQhOn7jTDte6UDRyN7500SF5xAcuCqjkKPIDQ1ybXCrogvnIAQ2dVOcwzqDAi8gLZqDlndZ7kkGHVQCPfoP5Kvsposm1wn9shcgvJk/21ZVXZ77f9xLwQgKWcx/Vg45PEirhvcPKhScQfg1XtWWicWPs4HSy4LCkVHRDIPo1QbWpzAy8GuddYemjSjIRiw+kwN5KmZIXqpowbHAEzswFEjwZAhhwMP2dRRX+0l4vCkxTd9DV2g47r0ZqcsoTs86bf4xAPRfjSGb2UQwSjTgt+/66q1dQa/6huhK0rFYz5Luua3LZGnKEhR0L4/a50l+tZ6N+OLPH29cH4pfOAhat/7tPlxCQ71UX8pAnb11Zanc8m26Lw0Mk9o4sgSNPmd8epAciNHr0eCXwEsWfukHKQ2DKH3xJvqWCf8eEZ8OIDUMP0FTDSB9HTJwRIKlwrvuCaiGfclh2C5NzTDYRACO+gtuf+4cwOgmG3OcLtcJnOm3aVx3/DGm8z6XOJ4eTY8UcGpvnCr9GW3yKtQM/EVPHQjRZ8W6V9iI540/WXQD207j4uF63cUU+IWJw44oCeyMs0M/1EEteAEOHshe1bitVGyyfjIN90y0Sg5RQrxTBffuKO+vj/JD/Sn3vW8TBFCzQHbx95k5/r9qvLBL2btQBENxdFztOTOBCYDKBKQ1KWEOozNbBAFFiXVsggP/E00KnewCGA8sC36XX5EYfA3Tn10e4JVy5SoHwDEqW0J+5ufAxkINnl03eqSYBV978XAo5OesXrLtjBVPxwj7IyCFhL+edyKiF+IAxmydiGsf6T5a5iarj10Z10K0QmAgt2kmahLQMrYxsv/b7pz8Qf/imvVDIO/xfk7i4F27CI17MXMK5GT0lC54/vyR6noNvVqHNSYlqDNyyaNjCn
 mGOrVRUr
 nGoDilTncpotuQKgi/q+44CuEmvLcnIyrxfUo80zgaOYcJcYhzGFS2/KsmSPELNqDTlcsMNsk4Al7DT6XFjk4Kv1RcMWg5t1qCilibU/JzWsg8Q4ki14ucVdiPhcM7A1TAgcmPmYcbRh2v90/CeQNLZ5pGB7+gZr4Y0mNbscOI8hl7JMDrFH6IFBmFK4U4EXMaB4stx43W56hdDYNoo/hRhBQsy61WBe/jCRg2lRrJcjsGnqJ7vyGILzHlpfZ1EywUAU/asbI4ufQOjms4pGrn+//TgD4vH26t+lltMu/Alo9JCy05+IJ/kdt2TfJr+tnPB7iF4L7q4PaDEgqrVdkkvDQAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 15:11:51 -0700 Nathan Gao <zcgao@amazon.com> wrote:

> __damon_va_prepare_access_check() picks a random byte address within the
> region and stores it in r->sampling_addr. There are two users of
> r->sampling_addr in vaddr.c that pass it into a page table walk, and
> both use it as the address of a page.
> 
>   damon_va_mkold(mm, r->sampling_addr)
>     damon_va_walk_page_range(mm, addr, addr + 1)
>       damon_mkold_pmd_entry()
>         damon_ptep_mkold(pte, vma, addr)
>           ptep_test_and_clear_young(vma, addr, pte)
>           mmu_notifier_clear_young(mm, addr, addr + PAGE_SIZE)
> 
>   damon_va_young(mm, r->sampling_addr, &folio_sz)
>     damon_va_walk_page_range(mm, addr, addr + 1)
>       damon_young_pmd_entry()
>         ptep_get(pte)
>         mmu_notifier_test_young(walk->mm, addr)
> 
> For arm64, before commit 6f0e1142173a ("arm64: mm: support batch
> clearing of the young flag for large folios"), the contpte helper walked
> exactly CONT_PTES entries from the aligned-down page table pointer and
> used @addr only to pass down to each entry, so an unaligned value was
> harmless:
> 
>         ptep = contpte_align_down(ptep);
>         addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
>         for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
> 
> Now the range to walk is derived from @addr instead: end = addr +
> nr * PAGE_SIZE, rounded up to CONT_PTE_SIZE. For a sample in the last
> page of a contpte block, the sub-page offset puts end just past the
> block boundary, so the round-up lands a whole block further and the
> walk clears PTE_AF in CONT_PTES entries beyond the sampled block. For
> the last block in a page table page, those entries are past the end of
> that page, so the walk writes into the page that follows.
> 
> Triggered by the full 7.1/7.2 kernel selftest suite on arm64 (EC2
> c/m6g.4xlarge). The kernel sometimes crashes at or shortly after the
> DAMON test.
> 
> What the overrun does depends on the page that happens to follow the
> page table, so there is no single signature. If that page is read-only,
> the write faults in the sampling path itself:
> 
>   Unable to handle kernel write to read-only memory at virtual address ffff0003c5d2d000
>     FSC = 0x0f: level 3 permission fault
>     CM = 0, WnR = 1, TnD = 0, TagAccess = 0
>   CPU: 10 UID: 0 PID: 3487 Comm: kdamond.2
>   pc : contpte_test_and_clear_young_ptes+0x70/0xc0
>   lr : damon_ptep_mkold+0x1e8/0x1f8
>   Call trace:
>    contpte_test_and_clear_young_ptes+0x70/0xc0 (P)
>    damon_mkold_pmd_entry+0x150/0x170
>    walk_pmd_range+0x110/0x2b0
>    walk_pud_range+0x10c/0x208
>    walk_pgd_range+0x134/0x258
>    __walk_page_range+0x98/0x1b0
>    walk_page_range_vma_unsafe+0x90/0x148
>    walk_page_range_vma+0x28/0x40
>    damon_va_walk_page_range+0x114/0x2b8
>    damon_va_prepare_access_checks+0xec/0x1a8
>    kdamond_fn+0x534/0x770
>    kthread+0x128/0x138
>    ret_from_fork+0x10/0x20
> 
> Otherwise the page is writable, the PTE_AF clearing succeeds silently
> and the damage only surfaces later, in whatever happened to own the
> page, so the backtrace is unrelated to DAMON and differs between runs.

Urgh, this must have been a painful debugging.  Sorry about that, and
appreciate your great work on this!

> 
> Align the address down to a page boundary in damon_va_mkold() and
> damon_va_young(), the two users that pass it into a page table walk. It
> is the address of the page to sample, so this matches its intended
> meaning. r->sampling_addr itself is left as is, so the sampling and
> region bookkeeping semantics are unchanged.

I'm still wondering if it makes sense to restore unaligned address support in
contpte_test_and_clear_young_ptes() as a long term fix.

> 
> Fixes: 6f0e1142173a ("arm64: mm: support batch clearing of the young flag for large folios")
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: David Hildenbrand (Arm) <david@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Nathan Gao <zcgao@amazon.com>
> ---
> V1 -> V2:
> - Align inside damon_va_mkold() and damon_va_young(), the two users that
>   pass the address into a page table walk, rather than aligning
>   r->sampling_addr itself, so that sub-page sampling addresses remain
>   possible for future non-PTE access check primitives (SJ)
> - Point Fixes: at 6f0e1142173a instead of 3f49584b262c, since the
>   unaligned address was harmless before that commit (SJ)
> - Describe how the issue was noticed and what it does to the kernel (SJ)
> - Reword the subject to match the narrower change
> 
> v1: https://lore.kernel.org/all/20260827193821.46115-1-zcgao@amazon.com/
> 
>  mm/damon/vaddr.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index 2c1c1952c008d..e7aa18200088f 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -349,6 +349,9 @@ static void damon_va_mkold(struct mm_struct *mm, unsigned long addr)
>  		.hugetlb_entry = damon_mkold_hugetlb_entry,
>  	};
>  
> +	/* Arch helpers can derive a page range from @addr; align it down. */
> +	addr = PAGE_ALIGN_DOWN(addr);
> +
>  	damon_va_walk_page_range(mm, addr, addr + 1, &damon_mkold_ops, NULL);

Could we do the alignment just before passing the addr to
contpte_test_and_clear_young_ptes(), which is the exact function that disallows
the unaligned address?

>  }
>  
> @@ -482,6 +485,9 @@ static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
>  		.hugetlb_entry = damon_young_hugetlb_entry,
>  	};
>  
> +	/* Arch helpers can derive a page range from @addr; align it down. */
> +	addr = PAGE_ALIGN_DOWN(addr);
> +
>  	damon_va_walk_page_range(mm, addr, addr + 1, &damon_young_ops, &arg);

Ditto.

>  	return arg.young;
>  }
> -- 
> 2.50.1
> 
> 


Thanks,
SJ

