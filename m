Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A28BFD4601
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 06:47:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FD2A6B0005; Fri, 27 Feb 2026 01:47:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AAFD6B0088; Fri, 27 Feb 2026 01:47:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A9616B0089; Fri, 27 Feb 2026 01:47:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 426486B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:47:30 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E4FA01A050C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:47:29 +0000 (UTC)
X-FDA: 84489305418.05.9F5A563
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 47796A0003
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:47:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PPYM0RiM;
	spf=pass (imf25.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772174848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mEN5vr4kMOUu6FGvzSN84qC/mx/J6IWnb35GhSr8CZA=;
	b=zsi11za9LEPeVUNZ0M0QeTtKcN+7/Mt0D0fXZJlzZKgiaO2dR/mMnYHwUxueR+OWwHSl/e
	uqPTxha/mFBJKrNH12TCUO8WLV8NbhP6EgPMgSzJ1UPguHlT+uad0pqTf/LsKBbxovEgHG
	ziO8skXzOCwGPSg0QyBUjBlQVNZYeVM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PPYM0RiM;
	spf=pass (imf25.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772174848; a=rsa-sha256;
	cv=none;
	b=Y+nvbQwzInZQHZzECHIe0lq4NkhXC4eGqeC9fFGppWVHzjzYii03DHTVUxh6+DY6qotZ+a
	Mmch9PsEgAHhI79j13BzfFODa8BvpMePuBOZzftJUutqdtCxW7y2dgYJeZUiTVnH2aY9+T
	LIaNFpF5FIgO9Pura67qxKh6dJ8oE90=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B7C30600AA;
	Fri, 27 Feb 2026 06:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF83C19422;
	Fri, 27 Feb 2026 06:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772174847;
	bh=KO2bW00MM7LDG//quqXYZmj/ahwm2FnxZhGD6CmuPkc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PPYM0RiMcmK4BZUonZBiN7hp3nR4ppxvaDhDxzl0NbcO5XRjZ91TMYXbShCI54IVZ
	 JvN1rA3Ml1woOMP0m+wIjntDHOEu3aRhaIP0zOtPkZ9E/CKzgktxC/jyEMpkxbexf7
	 /czR5FfE/5J98rtUZWaEnsjHK8VYxycf1GGbFpDpN3bMnxMxPSepmdiQaXS2Oyu+zG
	 Npyx/UwNsnLxyP7A/JPD4f5fR831f9pRGSjIKcSNqRUy/5hLhU+NiFgvSF4d+s3mQ8
	 v9AWPK6Y16exoSilsS+YLigMUjHo4g2eU/p0IHsvOVH4LZe6H7/i3oA/LzqlljZK9h
	 zfarBq1DXpLUA==
Message-ID: <abfbe83b-23fb-400d-9069-b8bf4ad21d95@kernel.org>
Date: Fri, 27 Feb 2026 07:47:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 2/2] powerpc/64s: Add support for huge pfnmaps
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org, kvm@vger.kernel.org,
 Alex Williamson <alex@shazbot.org>, Peter Xu <peterx@redhat.com>
References: <0b8fce7a61561640634317a5e287cdb4794715fd.1772170860.git.ritesh.list@gmail.com>
 <d159058a45ac5e225f2e64cc7c8bbbd1583e51f3.1772170860.git.ritesh.list@gmail.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <d159058a45ac5e225f2e64cc7c8bbbd1583e51f3.1772170860.git.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 47796A0003
X-Stat-Signature: r78qdd4awgqtrshi73ryj43dftktipoj
X-Rspam-User: 
X-HE-Tag: 1772174848-987543
X-HE-Meta: U2FsdGVkX1//kSqgBl0x3jtzZvtX80MIEqF80IKXql6ecUr7PdLBy9U0kML9DX2NjgW7gs7ZUTU1LzguDy1OgF/onKAD5qb+EdulGDrstn54PSPRtNYIZ+p610+Fl03uMDH4TeYweURL2AqUNgK9oElcDSZt0ATohbqD4PGTqSctwP3fhFDJ8DQhHxTwiEVSaVOYiCbDFUDHVd94+BinmbZzeVjARcsY5+guyWJ0yhYRslPClAmSraW8iKbus3b0zsnbuVPltHuHcTwyZtqJUl058NrQyil78Tb0XUsnf0lekDzHYbA/XGKghyGTe+OqOX3a/JLahkUmjZgvZFacep+2vDcL6mJn2QlP9bw/AiLqkBB6zMlJIYk2AAeY2OXGZYTQu3b6+HajV9Pe00zbMlWcTMUyhEdKN3bUu3b3x2uXXoRKwcVMoCZx6ENhhuQrK030StU62Cj68NVicB6HI3tPgXON3a3CUcDaayIKNAGaIa8/LBRMv3CLngpsZDVqu+oWZlve/Sf4QghS//DrPWKqiwrKEduyaVeSQcf6+fFFu+ory++u+USGLs33LSxg3gDk0j46JJhpIqFhEjBYU7GVOyHvOklgZ06V4H1Lc9czk6QGAvQHv0iSK07wPL3YDTvbGw9+9ujgEZSyivLsvRRCgYVRvMBpx3h8l2lSu4Q0wojl+RhRdTYRTesSAPe9//AXpJfirwGezyZvYi6oMDtzDuUGCEuWjXk2Y5ryVer8R/F8ALObfzRx7JxwMT8pl4Hco1VjRA86pBqHHGLMCmReR7U+9zWShG6zx4z7GDYh0a+8d6lnaNrfpU8SjG6RM/8iZFmSP3CveNh+XhaK00LX5lpKZtn6C9gUpEBclpzDRveCk1n5Yrek6784QuWeVXrenhOdxI8AL6zlbvdmT3spNtYs76iu4ByyDWCk4O+t9f9C+moTVyc00EqanrKwcD9z6HpI9rHnMfWQ3JF
 l2AFpjWt
 OLh9x7ijs8FCqt9jIsGq31i69lffj3x7MSsKjrqe865qtsq1ipLG6Pk2Td9IXtmftUawr5FUuTwG917f3qykJQ/V1QZLFMD5tk3wafOkz9rqqNb2c3yviXBI5IXZ0eXN6GSFayfYQGyvbztheTtMqKPQKUfJNZovG0t/LcKhLlNrusg5+O/hDgEwZmKjUBHJ/HzU1tsbRxfXfiDEEFNlJfS7a8Ex8kDFgrFWNkjr3ABgUYaUdOwmmsziC22eP8pRM4qUrSpl6gwoT9VQOkYaxmJkLOHgq1iMBVFjcY1sIboyBrl+Yroc/j6/Ub6ZpzC9r2xpsPY/AJk2jwzJ6D4dRwVD1ybELxjvvF/KKX4UfJtDJ1w/YLzVRmkxg+cacrxp2klte8Hy2du0Rt6A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 27/02/2026 à 07:16, Ritesh Harjani (IBM) a écrit :
> This uses _RPAGE_SW2 bit for the PMD and PUDs similar to PTEs.
> This also adds support for {pte,pmd,pud}_pgprot helpers needed for
> follow_pfnmap APIs.
> 
> This allows us to extend the PFN mappings, e.g. PCI MMIO bars where
> it can grow as large as 8GB or even bigger, to map at PMD / PUD level.
> VFIO PCI core driver already supports fault handling at PMD / PUD level
> for more efficient BAR mappings.
> 
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>


> ---
> 
> @linux-mm:
> Is there any official test which I could use to verify this functionality.
> 
> For now I used basic ivshmem setup + vfio using Qemu and validated using some
> basic test to see that we are seeing these prints.
> 
> [ 4351.435050] vfio_pci_mmap_huge_fault: 3 callbacks suppressed
> [ 4351.435234] vfio-pci 0001:00:00.0: vfio_pci_mmap_huge_fault(,order = 5) BAR 2 page offset 0x0: 0x100
> [ 4351.457005] vfio-pci 0001:00:00.0: vfio_pci_mmap_huge_fault(,order = 5) BAR 2 page offset 0x40: 0x100
> [ 4351.463684] vfio-pci 0001:00:00.0: vfio_pci_mmap_huge_fault(,order = 5) BAR 2 page offset 0x20: 0x100
> 
>   arch/powerpc/Kconfig                         |  1 +
>   arch/powerpc/include/asm/book3s/64/pgtable.h | 23 ++++++++++++++++++++
>   arch/powerpc/include/asm/pgtable.h           | 12 ++++++++++
>   3 files changed, 36 insertions(+)
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index ad7a2fe63a2a..cf9283757e5d 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -172,6 +172,7 @@ config PPC
>   	select ARCH_STACKWALK
>   	select ARCH_SUPPORTS_ATOMIC_RMW
>   	select ARCH_SUPPORTS_DEBUG_PAGEALLOC	if PPC_BOOK3S || PPC_8xx
> +	select ARCH_SUPPORTS_HUGE_PFNMAP	if PPC_BOOK3S_64 && TRANSPARENT_HUGEPAGE
>   	select ARCH_SUPPORTS_PAGE_TABLE_CHECK	if !HUGETLB_PAGE
>   	select ARCH_SUPPORTS_SCHED_MC		if SMP
>   	select ARCH_SUPPORTS_SCHED_SMT		if PPC64 && SMP
> diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
> index 1a91762b455d..639cbf34f752 100644
> --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
> +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
> @@ -1289,6 +1289,29 @@ static inline pud_t pud_mkhuge(pud_t pud)
>   	return pud;
>   }
> 
> +#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
> +static inline bool pmd_special(pmd_t pmd)
> +{
> +	return pte_special(pmd_pte(pmd));
> +}
> +
> +static inline pmd_t pmd_mkspecial(pmd_t pmd)
> +{
> +	return pte_pmd(pte_mkspecial(pmd_pte(pmd)));
> +}
> +#endif
> +
> +#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
> +static inline bool pud_special(pud_t pud)
> +{
> +	return pte_special(pud_pte(pud));
> +}
> +
> +static inline pud_t pud_mkspecial(pud_t pud)
> +{
> +	return pte_pud(pte_mkspecial(pud_pte(pud)));
> +}
> +#endif
> 
>   #define __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
>   extern int pmdp_set_access_flags(struct vm_area_struct *vma,
> diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
> index dcd3a88caaf6..2d27cb1c2334 100644
> --- a/arch/powerpc/include/asm/pgtable.h
> +++ b/arch/powerpc/include/asm/pgtable.h
> @@ -63,6 +63,18 @@ static inline pgprot_t pte_pgprot(pte_t pte)
>   	return __pgprot(pte_flags);
>   }
> 
> +#define pmd_pgprot pmd_pgprot
> +static inline pgprot_t pmd_pgprot(pmd_t pmd)
> +{
> +	return pte_pgprot(pmd_pte(pmd));
> +}
> +
> +#define pud_pgprot pud_pgprot
> +static inline pgprot_t pud_pgprot(pud_t pud)
> +{
> +	return pte_pgprot(pud_pte(pud));
> +}
> +
>   static inline pgprot_t pgprot_nx(pgprot_t prot)
>   {
>   	return pte_pgprot(pte_exprotect(__pte(pgprot_val(prot))));
> --
> 2.53.0
> 
> 


