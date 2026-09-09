Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B313C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B4D76B0099; Wed,  9 Sep 2026 06:25:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28C166B009B; Wed,  9 Sep 2026 06:25:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A33C6B009D; Wed,  9 Sep 2026 06:25:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E2CEB6B0099
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:25:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 267B212015F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:25:04 +0000 (UTC)
X-FDA: 85193840928.29.BE2E2D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5CA85120009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:25:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fpMCJhe5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788949502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Oo8RomRSAKyfRy1FZeDtz2uQY6X/cSMNb0cISk3DsQ=;
	b=G9cOWq771LzkTixsMwVXZBPPjH74+KZqTOwkGPUaw7Szz7G3rw5ulwGTc+F4QKgAgFEK3Y
	vn1wP9K9u0a9Xp31HPQeDwYyEN9XSjZ21tABqh918l3+Whq+XEvfokUZZPNkpuuCJ2jUxY
	bX08ZSwEUV6SF2WXv+BFY9RoqUzahVA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788949502;
	b=YwcUShOj9zNhvn9MyJ8ZDGQXFYy7zk+SBP89U7MFN7X0R/TlqExz1/gzJuRqu9binLzYTD
	Mse6o0rZLkbGCgo7jyvBErVtV7EvHFx+XTtj3xKyff2cOkrAEFHARNoRYRQmFT8KjYRR+c
	YNkrB00eRAABHL8UOgJCGDNrRIvbay8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fpMCJhe5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 406D143877;
	Wed,  9 Sep 2026 10:25:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E061E1F00A3A;
	Wed,  9 Sep 2026 10:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788949501;
	bh=6Oo8RomRSAKyfRy1FZeDtz2uQY6X/cSMNb0cISk3DsQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fpMCJhe5Bv9trGWnNlO4KnLJBp2H9xjzui7I1epfqOHOJzc1T5/kV4l4X2TuK3GNL
	 xOXCC4MFnfkWoclyvO4woNuwDTD0dQUHacH7WARP2RuGKN7zses/IbQN+//HmulpWG
	 Q45gxIXLAgDs1Kn4pJrqy+CAts28kJUZ1/3irGYFTHEeWk278ZXOrLOD7Fb9VfQDca
	 dTVaCS4JJvL6XULjgw2ax5OmwuAX9FtD7vbGom5hbD7QTPQoo/VtS/eOg6NrPB0f0Y
	 7whzNNPUWqdG8LqnXmMi7WCts/pd7tdrMJHKkFoPh8FtHJ9DwDM24FFMquDl6dtVOJ
	 fRcedjV/qi2SA==
Message-ID: <6fb6b2b8-daae-4707-aa98-c2c447782a44@kernel.org>
Date: Wed, 9 Sep 2026 12:24:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm: define generic pudp_invalidate() implementation
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 ljs@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 mark.rutland@arm.com, ryan.roberts@arm.com, peterx@redhat.com,
 dave.jiang@intel.com, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20260909090018.1991485-1-tujinjiang@huawei.com>
 <20260909090018.1991485-2-tujinjiang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260909090018.1991485-2-tujinjiang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5CA85120009
X-Stat-Signature: yan7ghc4cnw1rio1wn7hu97fy1d6qas6
X-HE-Tag: 1788949502-106871
X-HE-Meta: U2FsdGVkX18gdAB6dpGPQZehdH1yFHK0TVFM6bHdNJmoMJrOWdaxFxmIJJSlslwqa4GFQ4M7owzu0QH4bLFR3JQvIwIxuuz5G9We/tvoUoxdWl1irfrQSxug1p5nAXULmIvouTehfZnFOII18vAqJ5v53N+5L7nF4NG6cgF0VXFNCO6QsNBbpXJXYpXtGzIM086e2BVowUQunYCBqBJ077sT//uFbrLpkqmSBPCkr66zeZjGFLY7MIkdoNVSnUNKRefSVhuIiWG60nzBDkOmkK7tcDQLhEDJ6bqp0P56cxbq0VUvtpzoyv31klwhizP41WUlI7+2NIh2ntEAbnM4+vSphQYSvVvhfhvs1HNt67VUMzgzXmcITE7LRuHbpwb1u1TQKwcvGM1M64uYQ5kMMt8BagIxSvIQy9SoR3B+405/y+8gZZhfwnR8eMjcCiGJvTc5ARhZedaJpO/PNVs6Wpaot/LivLIYaQtu4HJTE0Ivx/QkV+WaPLz0It1E/fIA4XagVluhzaDzGjeSdXZrzVgEXW4x7G6W1zk2fTpf1d/VPPUPhDFC6zFRNdpY6PUFQDNkNGis1+771UQbgUlMeZ2kBriZObhEy4WamJk5h8QfSDUDUBaqyRp6ZH8KeuDY2c9NRNytEb1rW00pCQegBgpFo+3kJxQDtqMzdH0ReTOJQuHcPt9GRRau+SWhVp2ocxnESRHbQkJA7Z4Vlgptd8T5iXir19YTdsICFmGUFVVt3v4yoXafDPAL8KVas7TUNqFmVwjiBPn4CYoIv1sy2634DbCdvNKaugKmRk1vLhxMdW2zytcoGTkUrUG05tu17BIZ2iKajUpIvWJxk6QukN34D48M1GsOgK58sgooy44IDZkMult21Mwq+l6hnI2EnSq4GOIG4qqF9xZnkMnmmGGzpMvwQ28/bAVPmRQD2E6GtkJ3ToG1goSZU7reozM5YFHDCLpStQIpHp+8r3/
 AK6i8fVY
 2eCBROH4Fh/CDv1Y8uHkqIQwdf4VvrD+eLprc5978R0VlOJMg/SJapxnAwDpLm6Fj1SZpd2UrC4NSy2Tx5ACcVPY2P3u3Ztcp+jJdVoLfS1cWbm/jKsYN+5miA6HhtOGYTDGfI3GuOUYZA/5U8lOBCNGbWFrGqaLuoRgXaDFL2YgAkyWyeBv0+9vhcleazVBNvS4R7RwqrMe5BuaxefO+CDk9lv1l6joc9VbNjstthKW/3DTmcW2X8QYV3f/XWeszeI3JIn6BGr/6uiFkQqK0n2K252j+cFoIwNssPSj4N9bnDN+b0PUiaIVC33JG9+sET/JVaZA97NEavTE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 11:00, Jinjiang Tu wrote:
> x86 and riscv have identical pudp_invalidate() implementations. Move it to
> mm/pgtable-generic.c with the __HAVE_ARCH_PUDP_INVALIDATE override guard.
> PowerPC keeps its own implementation. In the later patch, arm64 will use
> the generic implementation too.
> 
> No functional change intended.
> 
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---
>  arch/powerpc/include/asm/book3s/64/pgtable.h |  1 +
>  arch/riscv/include/asm/pgtable.h             |  3 ---
>  arch/riscv/mm/pgtable.c                      |  9 ---------
>  arch/x86/include/asm/pgtable.h               |  3 ---
>  arch/x86/mm/pgtable.c                        | 12 ------------
>  include/linux/pgtable.h                      |  7 +++++++
>  mm/pgtable-generic.c                         | 14 ++++++++++++++
>  7 files changed, 22 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
> index f4db7d7fbd5c..55d33c5537f1 100644
> --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
> +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
> @@ -1419,6 +1419,7 @@ static inline pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm,
>  #define __HAVE_ARCH_PMDP_INVALIDATE
>  extern pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
>  			     pmd_t *pmdp);
> +#define __HAVE_ARCH_PUDP_INVALIDATE
>  extern pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
>  			     pud_t *pudp);
>  
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index 40b1ed4f3ea8..327fa378032b 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -1159,9 +1159,6 @@ static inline pud_t pud_mkinvalid(pud_t pud)
>  	return __pud(pud_val(pud) & ~(_PAGE_PRESENT | _PAGE_PROT_NONE));
>  }
>  
> -extern pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
> -			     pud_t *pudp);
> -
>  static inline pud_t pud_modify(pud_t pud, pgprot_t newprot)
>  {
>  	return pte_pud(pte_modify(pud_pte(pud), newprot));
> diff --git a/arch/riscv/mm/pgtable.c b/arch/riscv/mm/pgtable.c
> index 9c4427d0b187..156e385e7db4 100644
> --- a/arch/riscv/mm/pgtable.c
> +++ b/arch/riscv/mm/pgtable.c
> @@ -154,15 +154,6 @@ pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
>  	return pmd;
>  }
>  
> -pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
> -		      pud_t *pudp)
> -{
> -	VM_WARN_ON_ONCE(!pud_present(*pudp));
> -	pud_t old = pudp_establish(vma, address, pudp, pud_mkinvalid(*pudp));
> -
> -	flush_pud_tlb_range(vma, address, address + HPAGE_PUD_SIZE);
> -	return old;
> -}
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>  
>  pte_t pte_mkwrite(pte_t pte, struct vm_area_struct *vma)
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index d5f4917c1edc..97051c02385e 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -1387,9 +1387,6 @@ static inline pud_t pudp_establish(struct vm_area_struct *vma,
>  extern pmd_t pmdp_invalidate_ad(struct vm_area_struct *vma,
>  				unsigned long address, pmd_t *pmdp);
>  
> -pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
> -		      pud_t *pudp);
> -
>  /*
>   * Page table pages are page-aligned.  The lower half of the top
>   * level is used for userspace and the top half for the kernel.
> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> index cb03f5a2b243..0945908631dc 100644
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -519,18 +519,6 @@ pmd_t pmdp_invalidate_ad(struct vm_area_struct *vma, unsigned long address,
>  }
>  #endif
>  
> -#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
> -	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
> -pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
> -		     pud_t *pudp)
> -{
> -	VM_WARN_ON_ONCE(!pud_present(*pudp));
> -	pud_t old = pudp_establish(vma, address, pudp, pud_mkinvalid(*pudp));
> -	flush_pud_tlb_range(vma, address, address + HPAGE_PUD_SIZE);
> -	return old;
> -}
> -#endif
> -
>  /**
>   * reserve_top_address - Reserve a hole in the top of the kernel address space
>   * @reserve: Size of hole to reserve
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 8c093c119e5a..32173005b087 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1318,6 +1318,13 @@ extern pmd_t pmdp_invalidate_ad(struct vm_area_struct *vma,
>  				unsigned long address, pmd_t *pmdp);
>  #endif
>  
> +#ifndef __HAVE_ARCH_PUDP_INVALIDATE
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +extern pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
> +			     pud_t *pudp);

No "extern" please.

Staring at this file, I do wonder why we are not smarter about combining blocks. E.g., here simply:

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index e3c8ab96941c5..8c9fe3bf580d4 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1229,9 +1229,9 @@ static inline void pmdp_set_wrprotect(struct mm_struct *mm,
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
-#ifndef __HAVE_ARCH_PUDP_SET_WRPROTECT
-#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+#ifndef __HAVE_ARCH_PUDP_SET_WRPROTECT
 static inline void pudp_set_wrprotect(struct mm_struct *mm,
                                      unsigned long address, pud_t *pudp)
 {
@@ -1245,9 +1245,13 @@ static inline void pudp_set_wrprotect(struct mm_struct *mm,
 {
        BUILD_BUG();
 }
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 #endif
+#ifndef __HAVE_ARCH_PUDP_INVALIDATE
+pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
+               pud_t *pudp);
+#endif
+#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */

> +#endif
> +#endif
> +
>  #ifndef __HAVE_ARCH_PTE_SAME
>  static inline int pte_same(pte_t pte_a, pte_t pte_b)
>  {
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index b91b1a98029c..ac1175d9a59a 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -217,6 +217,20 @@ pmd_t pmdp_invalidate_ad(struct vm_area_struct *vma, unsigned long address,
>  }
>  #endif
>  
> +#ifndef __HAVE_ARCH_PUDP_INVALIDATE
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD

I'd revert these and similarly see if they can be combined somehow (likely combining with
pudp_huge_clear_flush is harder as we are quite inconsistent with it, gluing it to
__HAVE_ARCH_PMDP_HUGE_CLEAR_FLUSH).

Which raises the question whether we could also piggy-back on __HAVE_ARCH_PMDP_SET_WRPROTECT
(I suspect no without a closer look.)

-- 
Cheers,

David

