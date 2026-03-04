Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B375EB7EAC
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 08:54:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2D0B6B008C; Wed,  4 Mar 2026 03:54:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C04466B0092; Wed,  4 Mar 2026 03:54:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B242D6B0093; Wed,  4 Mar 2026 03:54:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A14536B008C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 03:54:40 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38189140509
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:54:40 +0000 (UTC)
X-FDA: 84507769920.06.6A7FA21
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9A3B7120005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:54:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kN8+2zA1;
	spf=pass (imf29.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772614478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bARe5vahzlBecaWQ8CByabip2fvZsODg61fvn/CTpxY=;
	b=B4Epak7ORcIw6CqqBrMmejDwWdENgNYMhRmO4042qsoK2JmIhm1dNJRciH2YakBqpeLpRk
	Cg8U+Oi+fOsi+VWu6uX2H525xfTkbFM48tnhHQ8mzLvIVZz7rzaYxkldlXTkdULoh/1cPU
	H2Mv7Qg03uKWciEoWxqAFIv0aNVbVRo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kN8+2zA1;
	spf=pass (imf29.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772614478; a=rsa-sha256;
	cv=none;
	b=VZM2Izf5htdsCpzeNnxppFiw1687Hsxo71qbB3V8n8oUOHvZX83h1eIzivU2jsSDCu5TjI
	uLmSdTD2CQC9FptfRmJk3x3zhkeIkEhbLaSSh2P8o858dSn18QLqJe0by+FFaw+hEJKtOf
	t7w6K1M31ecnSzC36+E8JgLcz0hBmNQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B6F060097;
	Wed,  4 Mar 2026 08:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B57C19423;
	Wed,  4 Mar 2026 08:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772614477;
	bh=0bD5+ytOm5kpMEcwWBYleyhFBrc8X6uiBo5uYxm/1EQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kN8+2zA1E6Ozz23iEINk4XkaIUU9MBTbgeDZPYooipd4PtNDfmE4BAF0rYq+/UfNY
	 NGadN4jE3eKkfm5kKgUtX9qKP6006J987V5HFaW+PF224G+z6mCOvYmASJIz9bygCi
	 7MkIO2hT8xBxlW0eD/MC8K0BSVwjhvNMpM8Z40SX2DYwRQNG/OxE9skSOBh7yWob7l
	 j+DiwTsiD9NH0Mig2jhEwuuKuIK1m/SgTjDKvyxtNpD3pbpXMxjUmpzijsY0PiPPpw
	 TWuz4+azrBUQEhzVAMbB8s3R2shHAxLHXLDieWd0gJBwgT4CqZr5ptXV7GvqzWmU51
	 d4QvbgLXqubAA==
Message-ID: <8112d5f0-8d4d-4c48-98f9-231c786e59d8@kernel.org>
Date: Wed, 4 Mar 2026 09:54:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 02/10] powerpc: book3s64: Fix unmap race with PMD THP
 migration entry
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Pavithra Prakash <pavrampu@linux.vnet.ibm.com>
References: <cover.1772013273.git.ritesh.list@gmail.com>
 <6a1d3d5992307e181082b35ba238d7e09acc77a6.1772013273.git.ritesh.list@gmail.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <6a1d3d5992307e181082b35ba238d7e09acc77a6.1772013273.git.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4e1nhqra97r7k65hk4bn15nw9nerbtf8
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A3B7120005
X-HE-Tag: 1772614478-587678
X-HE-Meta: U2FsdGVkX1/DAssjhucxZ2HXUotBK9N3kAMWeRawO3EUDh2Td01fy1NNUgWtAW/uX5dbDBrRkWBoceEJz3FFcXUoH/NcrFb/LqxNV9sFMorsQ5z4mebyQBBxBlQsmjeodFrMpNqjT+G8nwwONgi7FVclTOXcuZVoCH536NELEHGz5a+tYNRd3rgaUZx/HlPzk8jObwbAL+gGpkhasultDBPFDo/lA1/6U2OjPh+RU6yfho2aDnl+HWoDOO0GqzUZoCg0cBu9VF8x9KtyRqgCJUqmtWBNPvZWI1SWrafmETFaC7vVX5tpLiS01tKlecvntaH865tvL3AEr2YGAs4bqjh947rs3i/EyQm3oIFXqR9IcFiYUYTukUJXryzxZ2LVtenRxBMw7s5Vd/ky4kWv/EX/7RVg/LKazXgs4LYK5IfqiqjvPDExnLX1r2pTpi2E8Mpj/5bc79I6CsOnqZiMSStjf4r8XkmBoiXsvPh4pcmr3zLYVTQapYCzCljWlL1JOQXFG2GQ3pLNo8foAcMgM++/mmggfrR8G4nTeWe928RFIijlUORSgGJvI7GBmzcVKsa5HPqVcV4pGho9OTV+vAzux+xH/g0sqTG2SW105SKd6bYnnIHZQz8BxVpsQIv71sXvpx2YK1OzDAn/1F36n0R6161mOT7baKDjt1Io0J4WqHzv19n+SXlrDWa4hs5IDZl/EgsMWV3RBTxmBprCW1/6rqEAJzNnoxI1paOrj3J+fST8mO6Aid2KLnRNamKd4N/iNF3Xmo9RQWIE0JAuWgU8s0184P/iZrF5mdhs9jTe15bavQ7IwbgPMZkVr9fae88u6belB7OFk0zyw9ZxRoY9oU1JmXDQW9yT+XKHS07JHotkQcU7onCT6ykDk36MGWanVSFzQ3jYTxq5QsAd+U/JW+CZkEhhx1x2lkh4ciq9JY/dQ3zfslREnFWNtmNVlvdUyp34+vngERFcCNj
 nIInTvI8
 fZmma+yos4ep8tZle4xgsRoICVIV0rLWQkAN5XRB24R2FU1Lhda0sCL01m1Xqv/XEfvtnyTo/3uDB7HwMTO4Qb4R1eGjvZ529DIvGlqmjgwQHJNwJpCs6s+dOuP6adfGaJtm0bkkRGp8n+Jees5HSfmeIqjbMjnIY0e2dxC3ASA2zDYuGl+CYe1/nVvnXMD8sXRBW6sO1y/12irNCMmaNkysF3rITaBQRlbY4ZwyjNfo/bbrgeIwBxUzyZmb1JcNaJ3uflo33UABR0OnZIuyZG3gmNdJJQh4L3DLk9pAwWG8tFSrPrGuDBBFL25lIdqIVjEtg5+p8pdZkfmNJZ1N/cw2PfztGlrYbgCWB7dlBEZlj8SDj7tZY/FaKxYSmAn/uI2TYPE2qdZ/oi42S1ezI7JomUyJG+JM7JwpRrSvWx5lC+Xw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 25/02/2026 à 12:04, Ritesh Harjani (IBM) a écrit :
> The following race is possible with migration swap entries or
> device-private THP entries. e.g. when move_pages is called on a PMD THP
> page, then there maybe an intermediate state, where PMD entry acts as
> a migration swap entry (pmd_present() is true). Then if an munmap
> happens at the same time, then this VM_BUG_ON() can happen in
> pmdp_huge_get_and_clear_full().
> 
> This patch fixes that.
> 
> Thread A: move_pages() syscall
>    add_folio_for_migration()
>      mmap_read_lock(mm)
>      folio_isolate_lru(folio)
>      mmap_read_unlock(mm)
> 
>    do_move_pages_to_node()
>      migrate_pages()
>        try_to_migrate_one()
>          spin_lock(ptl)
>          set_pmd_migration_entry()
>            pmdp_invalidate()     # PMD: _PAGE_INVALID | _PAGE_PTE | pfn
>            set_pmd_at()          # PMD: migration swap entry (pmd_present=0)
>          spin_unlock(ptl)
>          [page copy phase]       # <--- RACE WINDOW -->
> 
> Thread B: munmap()
>    mmap_write_downgrade(mm)
>    unmap_vmas() -> zap_pmd_range()
>      zap_huge_pmd()
>        __pmd_trans_huge_lock()
>          pmd_is_huge():          # !pmd_present && !pmd_none -> TRUE (swap entry)
>          pmd_lock() -> 		# spin_lock(ptl), waits for Thread A to release ptl
>        pmdp_huge_get_and_clear_full()
>          VM_BUG_ON(!pmd_present(*pmdp))  # HITS!
> 
> [  287.738700][ T1867] ------------[ cut here ]------------
> [  287.743843][ T1867] kernel BUG at arch/powerpc/mm/book3s64/pgtable.c:187!
> cpu 0x0: Vector: 700 (Program Check) at [c00000044037f4f0]
>      pc: c000000000094ca4: pmdp_huge_get_and_clear_full+0x6c/0x23c
>      lr: c000000000645dec: zap_huge_pmd+0xb0/0x868
>      sp: c00000044037f790
>     msr: 800000000282b033
>    current = 0xc0000004032c1a00
>    paca    = 0xc000000004fe0000   irqmask: 0x03   irq_happened: 0x09
>      pid   = 1867, comm = a.out
> kernel BUG at :187!
> Linux version 6.19.0-12136-g14360d4f917c-dirty (powerpc64le-linux-gnu-gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40) #27 SMP PREEMPT Sun Feb 22 10:38:56 IST 2026
> enter ? for help
> [link register   ] c000000000645dec zap_huge_pmd+0xb0/0x868
> [c00000044037f790] c00000044037f7d0 (unreliable)
> [c00000044037f7d0] c000000000645dcc zap_huge_pmd+0x90/0x868
> [c00000044037f840] c0000000005724cc unmap_page_range+0x176c/0x1f40
> [c00000044037fa00] c000000000572ea0 unmap_vmas+0xb0/0x1d8
> [c00000044037fa90] c0000000005af254 unmap_region+0xb4/0x128
> [c00000044037fb50] c0000000005af400 vms_complete_munmap_vmas+0x138/0x310
> [c00000044037fbe0] c0000000005b0f1c do_vmi_align_munmap+0x1ec/0x238
> [c00000044037fd30] c0000000005b3688 __vm_munmap+0x170/0x1f8
> [c00000044037fdf0] c000000000587f74 sys_munmap+0x2c/0x40
> [c00000044037fe10] c000000000032668 system_call_exception+0x128/0x350
> [c00000044037fe50] c00000000000d05c system_call_vectored_common+0x15c/0x2ec
> ---- Exception: 3000 (System Call Vectored) at 0000000010064a2c
> SP (7fff9b1ee9c0) is in userspace
> 0:mon> zh
> 
> Fixes: 75358ea359e7c ("powerpc/mm/book3s64: Fix MADV_DONTNEED and parallel page fault race")
> Reported-by: Pavithra Prakash <pavrampu@linux.vnet.ibm.com>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
>   arch/powerpc/mm/book3s64/pgtable.c | 19 +++++++++++++++++--
>   1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
> index 4b09c04654a8..359092001670 100644
> --- a/arch/powerpc/mm/book3s64/pgtable.c
> +++ b/arch/powerpc/mm/book3s64/pgtable.c
> @@ -210,8 +210,23 @@ pmd_t pmdp_huge_get_and_clear_full(struct vm_area_struct *vma,
>   {
>   	pmd_t pmd;
>   	VM_BUG_ON(addr & ~HPAGE_PMD_MASK);
> -	VM_BUG_ON((pmd_present(*pmdp) && !pmd_trans_huge(*pmdp)) ||
> -		   !pmd_present(*pmdp));
> +	VM_BUG_ON((pmd_present(*pmdp) && !pmd_trans_huge(*pmdp)));
> +
> +	if (!pmd_present(*pmdp)) {
> +		/*
> +		 * Non-present PMDs can be migration entries or device-private
> +		 * THP entries. Since these are non-present, so there is no TLB
> +		 * backing. This happens when the address space is being
> +		 * unmapped zap_huge_pmd(), and we encounter non-present pmds.
> +		 * So it is safe to just clear the PMDs here. zap_huge_pmd(),
> +		 * will take care of withdraw of the deposited table.
> +		 */
> +		pmd = pmdp_get(pmdp);
> +		pmd_clear(pmdp);
> +		page_table_check_pmd_clear(vma->vm_mm, addr, pmd);
> +		return pmd;
> +	}
> +
>   	pmd = pmdp_huge_get_and_clear(vma->vm_mm, addr, pmdp);
>   	/*
>   	 * if it not a fullmm flush, then we can possibly end up converting
> --
> 2.53.0
> 


