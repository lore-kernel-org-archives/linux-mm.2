Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BC22C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 08:28:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87E426B0095; Sun, 12 Jul 2026 04:28:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8083B6B0096; Sun, 12 Jul 2026 04:28:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D0A96B0098; Sun, 12 Jul 2026 04:28:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 462626B0095
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 04:28:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DBC104041B
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:28:53 +0000 (UTC)
X-FDA: 84979448946.04.FBA1051
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2A46E40003
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:28:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cBBX6CSc;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783844932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6pa6hwbA29wf7EPVdRkad1vMRwe+QiPcMMB3ckRWsao=;
	b=Dz8TSVJ5R4mxpuGk/c4HEUMbPug0F/NgylT4N0VIyr/h9b2mB/9Bq1cnbCPVe3WtW1lp5Q
	NlKP7etFrKKs/m/QZj4KfxWCTSSTM5b6Swq/ZSY3kDP+xygwOZqan1mKIygMqiXCdSSYDQ
	mHBCvrKT1WgvLx+AYkVz+CF9s/G5MLM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783844932;
	b=ilKdu3kLQZPTkdDrrCgGO0k6amEVxKSJEvYRHn78v867HRmG0CL+zI/ivEH94kJtRCeGt8
	drOf492gWDkbmca/b91RgWv19BNGrOjUwzMdweePrMVmofqkKxjH3uBGf54VLZLHL0OzdW
	ZBi4uMzwwbEYAQwsY6gu6ghRDNgEUqw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cBBX6CSc;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 088774119E;
	Sun, 12 Jul 2026 08:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2DE1F000E9;
	Sun, 12 Jul 2026 08:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783844930;
	bh=6pa6hwbA29wf7EPVdRkad1vMRwe+QiPcMMB3ckRWsao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cBBX6CScu+D8CwN3HIRkedeEtQ4ReeqByes909YEyDbmV+Lp8LuEGZ0e9cWqAC2El
	 1xXNLC4MphXiEcPCr5Ti0RULhizDXaqh3ZDFNpSA7hoX79352D1jO2DdcTvOqLrg7F
	 YOhNcF8CQZvnnkC2vZDdc/CI09zev7bMaLo/GjUfHC7kHz6cpTxHnPtXCJto7LIzSi
	 AamjDyBsHR9l9vfOblYTjN4eLR1HDgXJHWsPLKaEMVmo5+9tNfTzpQrJL7NAbwUyAm
	 8q4+WjaBD2CnAD0N9T9Op/uOMPMQsm3IHtb90caefL2yPKObQe4BNCV84K6RrpHsxl
	 xxrGRqtleW2yg==
Date: Sun, 12 Jul 2026 09:28:36 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	David Carlier <devnexen@gmail.com>, Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] Revert "arm64: Enable vmalloc-huge with ptdump"
Message-ID: <alNP9NGJzLunBq4_@lucifer>
References: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
 <20260710-series-vmap-race-fix-v1-2-5b3794c113fe@kernel.org>
 <daed9269-b397-4f6b-bfda-6d81e1be2f52@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <daed9269-b397-4f6b-bfda-6d81e1be2f52@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2A46E40003
X-Stat-Signature: 64ghfhiixt34epiecppgduxu7xepchjn
X-HE-Tag: 1783844932-661905
X-HE-Meta: U2FsdGVkX1/TT9UY49YuuECULesMiLkC1Fjf3Rx9vd+tppuuyQnaN8MJS8YWhISAvaHEWEvfOvb1Sj3zN6sMArWSA+M33E16LD1cSiCCcsIKjXvIJ+MrgK7giwxETDzCbbduEofDl1RDhMon/uNrdrYsIbDr8L1qFNAQGmtAGXm+rERROi1dL/xM3t0+aw2OD1aTeEXkT19AghREM7ccrVXVOgg/Nu1GE6z7dTn1kHTYRDMoDBDeFtf2xKy5e4SoNxInAXYlbwprD81SoF/v2ItaUr0k1JqWpC8rvaLVUwPOHT2ZkTZ/iYqVRH54lpcdemQm0qAE/MhygF4DFjHx69UZEWsyjlB3yiJtqO23dA2dUD+7ebO9AWHHQo9XQbKj0r7J8kuknHIZtHD8Axlxm+NTMvXxCib1yCgHNrDEYq7iXSp55hPIjZfx1gaCPqDIp117ToqNqnLNytl/vicqzvb+RDXOMxi0v+k8Q1/VXqJN5L9BJQMQ8dKa6LwAZUKQ1YG5kDePpmjrt4D/xEYhnOy5MF1uTzb1Z9/8u3CzKLTp4wQ0vIJJtXY29Bwb7YRTOgXscm0+wFSs/PYMXgLLzN2eayEuk/es312OROzlLLI+hvzDGKN1enbXvyE0qp3AG6WFK7PfuvJcyHgsLx8zYaZJ8ju0JHyPgQGX4WrYu6/YDa94HzFjwDQChQqWwdmpeq6NgtetQTGKRtUAXj/sRHyn42bXTJHQREjO7ug4Q9dK8lXWM5HEbWXuIm1y2t92ViKVUa3nDFl0AH40e+v5m0RIVfl+LuYwj1/hFqOL1Zx1Vufhg/x94g1UiQ6pPL1OFobsVrxDyKAxDnnstMwGyIt7uQjiQzQHwoHR5bBfk5Eh/Mo6CUYSWEDtGnCZaF9wOT43hTKBW2msDQLUt3bI/O3McDMNMh6rCOleFXVmkzoUe9VsAPzzKFQcVEuf0sk7XsO3fQVBAAYuMVyVOf3
 f2maV3iJ
 YfqX6haRc9oEVGCQegbN5Ld12/N/YJlwcl/daNg0BQIDnykdiudWxPOAnKv4ULDnZV0SlsMmLEWnpmCIwwfnmBu7aje30YxD7oi6WqiXGMiCBw97eg8o0KVrD6rqSdUuq4IUAXI4CVfpQrAr/VtJlcBr/oBRgZ7yxwPzxRDvNn0psrBtknfE+tOdPzeicAzEqLldexel1Jgb3Y5ZAorDaAFeFJfULcu9h+eAMUcgoC3g6gKTIkU5UCbBkyf21zJCQFzWCtiUtN8nheQgcGoq+BfXMlh3gYGCUidxnF8Iv6eH+im3AcBTmwBVj7cABMFLMTLRBXhvKEAxnbuYCiyjxXrwdwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 12, 2026 at 01:16:17PM +0530, Dev Jain wrote:
>
>
> On 10/07/26 4:19 pm, Lorenzo Stoakes wrote:
> > This partially reverts commit fa93b45fd397 ("arm64: Enable vmalloc-huge
> > with ptdump"), retaining vmalloc-huge support but eliminating the now
> > redundant mitigation against a race between huge vmap page table freeing
> > and ptdump, as this issue has now been fixed at core.
> >
> > We also simultaneously remove the arm64 ifdeffery when acquiring the mmap
> > read lock upon vmap huge page table promotion as it is no longer required.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> > ---
>
> As pointed out by Mike, the subject line doesn't fit. Perhaps just start with
> "Partially revert ..."

Ack yeah will fix!

>
>
> Reviewed-by: Dev Jain <dev.jain@arm.com>

Thanks!

Cheers, Lorenzo

>
> >  arch/arm64/include/asm/ptdump.h |  2 --
> >  arch/arm64/mm/mmu.c             | 43 ++++-------------------------------------
> >  arch/arm64/mm/ptdump.c          | 11 ++---------
> >  mm/vmalloc.c                    | 15 +++-----------
> >  4 files changed, 9 insertions(+), 62 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
> > index 5b374a6ab34a..50a195eda8ed 100644
> > --- a/arch/arm64/include/asm/ptdump.h
> > +++ b/arch/arm64/include/asm/ptdump.h
> > @@ -7,8 +7,6 @@
> >
> >  #include <linux/ptdump.h>
> >
> > -DECLARE_STATIC_KEY_FALSE(arm64_ptdump_lock_key);
> > -
> >  #ifdef CONFIG_PTDUMP
> >
> >  #include <linux/mm_types.h>
> > diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> > index f2be501468ce..f723bcf68174 100644
> > --- a/arch/arm64/mm/mmu.c
> > +++ b/arch/arm64/mm/mmu.c
> > @@ -49,8 +49,6 @@
> >  #define NO_CONT_MAPPINGS	BIT(1)
> >  #define NO_EXEC_MAPPINGS	BIT(2)	/* assumes FEAT_HPDS is not used */
> >
> > -DEFINE_STATIC_KEY_FALSE(arm64_ptdump_lock_key);
> > -
> >  u64 kimage_voffset __ro_after_init;
> >  EXPORT_SYMBOL(kimage_voffset);
> >
> > @@ -1857,8 +1855,7 @@ int pmd_clear_huge(pmd_t *pmdp)
> >  	return 1;
> >  }
> >
> > -static int __pmd_free_pte_page(pmd_t *pmdp, unsigned long addr,
> > -			       bool acquire_mmap_lock)
> > +int pmd_free_pte_page(pmd_t *pmdp, unsigned long addr)
> >  {
> >  	pte_t *table;
> >  	pmd_t pmd;
> > @@ -1870,25 +1867,13 @@ static int __pmd_free_pte_page(pmd_t *pmdp, unsigned long addr,
> >  		return 1;
> >  	}
> >
> > -	/* See comment in pud_free_pmd_page for static key logic */
> >  	table = pte_offset_kernel(pmdp, addr);
> >  	pmd_clear(pmdp);
> >  	__flush_tlb_kernel_pgtable(addr);
> > -	if (static_branch_unlikely(&arm64_ptdump_lock_key) && acquire_mmap_lock) {
> > -		mmap_read_lock(&init_mm);
> > -		mmap_read_unlock(&init_mm);
> > -	}
> > -
> >  	pte_free_kernel(NULL, table);
> >  	return 1;
> >  }
> >
> > -int pmd_free_pte_page(pmd_t *pmdp, unsigned long addr)
> > -{
> > -	/* If ptdump is walking the pagetables, acquire init_mm.mmap_lock */
> > -	return __pmd_free_pte_page(pmdp, addr, /* acquire_mmap_lock = */ true);
> > -}
> > -
> >  int pud_free_pmd_page(pud_t *pudp, unsigned long addr)
> >  {
> >  	pmd_t *table;
> > @@ -1904,36 +1889,16 @@ int pud_free_pmd_page(pud_t *pudp, unsigned long addr)
> >  	}
> >
> >  	table = pmd_offset(pudp, addr);
> > -
> > -	/*
> > -	 * Our objective is to prevent ptdump from reading a PMD table which has
> > -	 * been freed. In this race, if pud_free_pmd_page observes the key on
> > -	 * (which got flipped by ptdump) then the mmap lock sequence here will,
> > -	 * as a result of the mmap write lock/unlock sequence in ptdump, give
> > -	 * us the correct synchronization. If not, this means that ptdump has
> > -	 * yet not started walking the pagetables - the sequence of barriers
> > -	 * issued by __flush_tlb_kernel_pgtable() guarantees that ptdump will
> > -	 * observe an empty PUD.
> > -	 */
> > -	pud_clear(pudp);
> > -	__flush_tlb_kernel_pgtable(addr);
> > -	if (static_branch_unlikely(&arm64_ptdump_lock_key)) {
> > -		mmap_read_lock(&init_mm);
> > -		mmap_read_unlock(&init_mm);
> > -	}
> > -
> >  	pmdp = table;
> >  	next = addr;
> >  	end = addr + PUD_SIZE;
> >  	do {
> >  		if (pmd_present(pmdp_get(pmdp)))
> > -			/*
> > -			 * PMD has been isolated, so ptdump won't see it. No
> > -			 * need to acquire init_mm.mmap_lock.
> > -			 */
> > -			__pmd_free_pte_page(pmdp, next, /* acquire_mmap_lock = */ false);
> > +			pmd_free_pte_page(pmdp, next);
> >  	} while (pmdp++, next += PMD_SIZE, next != end);
> >
> > +	pud_clear(pudp);
> > +	__flush_tlb_kernel_pgtable(addr);
> >  	pmd_free(NULL, table);
> >  	return 1;
> >  }
> > diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
> > index 1c20144700d7..5a76c59b5ada 100644
> > --- a/arch/arm64/mm/ptdump.c
> > +++ b/arch/arm64/mm/ptdump.c
> > @@ -283,13 +283,6 @@ void note_page_flush(struct ptdump_state *pt_st)
> >  	note_page(pt_st, 0, -1, pte_val(pte_zero));
> >  }
> >
> > -static void arm64_ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm)
> > -{
> > -	static_branch_inc(&arm64_ptdump_lock_key);
> > -	ptdump_walk_pgd(st, mm, NULL);
> > -	static_branch_dec(&arm64_ptdump_lock_key);
> > -}
> > -
> >  void ptdump_walk(struct seq_file *s, struct ptdump_info *info)
> >  {
> >  	unsigned long end = ~0UL;
> > @@ -318,7 +311,7 @@ void ptdump_walk(struct seq_file *s, struct ptdump_info *info)
> >  		}
> >  	};
> >
> > -	arm64_ptdump_walk_pgd(&st.ptdump, info->mm);
> > +	ptdump_walk_pgd(&st.ptdump, info->mm, NULL);
> >  }
> >
> >  static void __init ptdump_initialize(void)
> > @@ -360,7 +353,7 @@ bool ptdump_check_wx(void)
> >  		}
> >  	};
> >
> > -	arm64_ptdump_walk_pgd(&st.ptdump, &init_mm);
> > +	ptdump_walk_pgd(&st.ptdump, &init_mm, NULL);
> >
> >  	if (st.wx_pages || st.uxn_pages) {
> >  		pr_warn("Checked W+X mappings: FAILED, %lu W+X pages found, %lu non-UXN pages found\n",
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 9d0f1fdd6af3..537ff7b3c412 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -170,10 +170,7 @@ static int vmap_try_huge_pmd(pmd_t *pmd, unsigned long addr, unsigned long end,
> >  	 * Therefore, acquire the mmap read lock to prevent use-after-free when
> >  	 * freeing page tables.
> >  	 */
> > -#ifndef CONFIG_ARM64
> > -	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
> > -#endif
> > -	{
> > +	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm) {
> >  		if (!pmd_free_pte_page(pmd, addr))
> >  			return 0;
> >  		return pmd_set_huge(pmd, phys_addr, prot);
> > @@ -230,10 +227,7 @@ static int vmap_try_huge_pud(pud_t *pud, unsigned long addr, unsigned long end,
> >  		return pud_set_huge(pud, phys_addr, prot);
> >
> >  	/* See comment in vmap_try_huge_pmd(). */
> > -#ifndef CONFIG_ARM64
> > -	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
> > -#endif
> > -	{
> > +	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm) {
> >  		if (!pud_free_pmd_page(pud, addr))
> >  			return 0;
> >  		return pud_set_huge(pud, phys_addr, prot);
> > @@ -290,10 +284,7 @@ static int vmap_try_huge_p4d(p4d_t *p4d, unsigned long addr, unsigned long end,
> >  		return p4d_set_huge(p4d, phys_addr, prot);
> >
> >  	/* See comment in vmap_try_huge_pmd(). */
> > -#ifndef CONFIG_ARM64
> > -	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
> > -#endif
> > -	{
> > +	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm) {
> >  		if (!p4d_free_pud_page(p4d, addr))
> >  			return 0;
> >  		return p4d_set_huge(p4d, phys_addr, prot);
> >
>

