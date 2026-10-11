Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4ECDCA9EBD
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 14:30:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 285EB6B0088; Sun, 11 Oct 2026 10:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235B16B008A; Sun, 11 Oct 2026 10:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 124C46B008C; Sun, 11 Oct 2026 10:30:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D4B646B0088
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 10:30:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5B37BA068E
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 14:30:01 +0000 (UTC)
X-FDA: 85310579802.21.DCE49E1
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id 83B4C1C0004
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 14:29:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="KNu/H/V0";
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791728999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tDlRoiYs+oXn7JVOx13TUze+GLTM7H/QsH7PUCzNbOI=;
	b=4YtJdZHx6qZDxZJhvhSJ/dIVkZKO1HM7uxNSlbs74f/x++cpO046/n39idURKV3SDJcLEZ
	sB1lcCYd67jUnf1OCkYddI+OpyVhY5Ybp3rdgo2CYw5lRmkheTRCplU75KUkILejMDxZAk
	AEt8imt1Zu8KmiZTzToYHK+CxX3SDW0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791728999;
	b=aJ/YikWciMrekA8rUqtNtPLAgvQbPBLjd3VsTYEVRABKPIBgjrIYvf7Qye8QcOwTGZVQ/p
	AVzw9SO4PRa6ordYev5pIV0JuVLmrMaNSIQeVtseTpnb0Eip7V4Z+K3gwVsTBFDUI5Ah1Y
	2Pl3IVrTI78vyibfzEYkfPwSIuvQtYM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="KNu/H/V0";
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c29c6a3930bso141372266b.3
        for <linux-mm@kvack.org>; Sun, 11 Oct 2026 07:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791728998; x=1792333798; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tDlRoiYs+oXn7JVOx13TUze+GLTM7H/QsH7PUCzNbOI=;
        b=KNu/H/V0pxRoBvCF5lQYZYcZCsVyhRcVJ93Q9kF5BKLY+sa5G67y5SRqoOcqbOoe9I
         zn50ucJrx/IA+0qHZQaDexIlYkdmwnGzSMC3Sz8JOl55+Y1SSfdYm1BO2vsgo24ITpNT
         okcBlpZR4xmlI87G6nBdvmQam1iqoXEAuTrVFiO0Xc9U2pqEQ83iFgr9JyUPudZ7LtFY
         SQ2xzdPOyhGyNdccsPpF0yt1szzc5d0GrApJUxW2c9KzN8BBBDwmwRk3VqQe++HKcqbo
         afj2jGXDQW74N4E1aBRuGkH1YOGmdTo3QlOerX3CXgOL6tZUrtjLwu9qN/7dpNZhXHSH
         rsvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791728998; x=1792333798;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tDlRoiYs+oXn7JVOx13TUze+GLTM7H/QsH7PUCzNbOI=;
        b=0JZWUFhBMIkRFWMi1aqDeWz7krmwKTGH+lBqMKG27Azd1rX6Lkj0PMsC70vPYtNPdI
         CZBuItUHGfL5b1mRb5aBxM7NF31/jRfBnoSntBpz182WfhNt85YVWa2SrnUcnw9cFw8x
         lbHUUKm8gVMy3nqKYn7yzczXuJpe3F3FNh12Bt8vWDYIEvb4udb2JXgi0qfdhupNy56O
         UkQFA07t2zvKfBd0A8SawZDwttfczB3k6fqSQG6CrZvOJ59Dit96rX+liEkN9XCvCJHs
         wmnwzLgDZizoYz5QTN2P6kDnWnNlEEg1BtizXOKKJxv3ZoabJq4ZVm74EE61ynfVDlYg
         aJDw==
X-Forwarded-Encrypted: i=1; AKwUvBw5opuepONKS5Lpun2GpHPB9ZUTpmwyc+NC2fSJQ2xJ0m+M1Oymy1sg3H7/2wwCgTtIXTDjdglG6A==@kvack.org
X-Gm-Message-State: AFq9FYICIFmRwjr5TJ11MzZE1V8MgrLEul5h9aaxE+Em8bCtuUXVrQSP
	+tvCAGBg6dv/AZtdpuz+VXieV9w5TyEA40ldIGJPi9uCGPde1AAUChRP
X-Gm-Gg: AYBFou1yWmwbThAze4m/nL/UtaiWNzTANGSDVIGAAVpQkOibtOMTnhX71g18GRprUjY
	eSeYZzH+Z/B7VUdIc3kkoXZuTYLDnCbbIeIKXaCV3BJKMkr9dyb42lbl+IUTU7G3Hkhl35TGKA9
	XCM1t5LPWnvXzw2NuvEGhHx0hFJqJfsV0movbO4IhJeDNJRxB9vL6pzgvA1vJrP/6+h6tmlOtIo
	Ubn015KiCh2Dao+KRGTXLLeXeNuebrKvmqZJxQqEk/5iRBt3vC1Hf5zblsRRbOTOUqtPBdJESfc
	3R/GLUw+HMRZiP6svQCj6fteDpiaIKM03WU713lvVlcA1U9UsS40llC39pbeLjpuJTTTBuijQVB
	CF0jbKKVlPACj1tCHj3L1aI3tHu8k1bg/x3PEYfW/DwMqx1r3pmt7H6nTHzO0RWAD08/FoVdvyd
	Mz3OT65xU5IUnRR6wLA/7QD/LWQTEJgsAegxHZ
X-Received: by 2002:a17:907:3f25:b0:c31:82aa:dd4c with SMTP id a640c23a62f3a-c31a9d15f06mr712746366b.24.1791728997857;
        Sun, 11 Oct 2026 07:29:57 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c34f8bd471dsm13420566b.9.2026.10.11.07.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 07:29:57 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Sun, 11 Oct 2026 16:29:55 +0200
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org,
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com, anshuman.khandual@arm.com, baohua@kernel.org,
	chleroy@kernel.org, david@kernel.org, dev.jain@arm.com,
	jiangwen6@xiaomi.com, leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com,
	mpe@ellerman.id.au, npiggin@gmail.com, rppt@kernel.org,
	ryan.roberts@arm.com
Subject: Re: [PATCH v10 03/10] mm/vmalloc: use
 pte_set_huge()/pte_clear_huge() for PTE-level block mappings
Message-ID: <asudY_EhrT5fZGmZ@milan>
References: <20261002090947.869220-1-jiangwen6@xiaomi.com>
 <20261002090947.869220-4-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002090947.869220-4-jiangwen6@xiaomi.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 83B4C1C0004
X-Stat-Signature: 34cybf5f1weibz977r1f1js5grqjxedb
X-HE-Tag: 1791728999-412634
X-HE-Meta: U2FsdGVkX1/zsGufaHFGa7mz9It2x/07sp6wy71LnDQ4ROc4fo4Han9G3t2iSWBLGz4yPkOQ6/bv0eaeHT65/CMOWNpsxaiEKAZGKEcRjjoBL1cnXxZPmk1vK16KVfN7cheW4gnHBmhACx0uif6r7jrWnECp26CLHijQQnndKp+LPXuWaQGSHS2JDbImYf4WX8IO4Ak9YIrjmdndvfWbALHC9oO/9QPOux2HRBA0kExgo72799muraH0u7IjYE5kQUhGcbLz5H2kxDHEX8rM31Bj4NK11y+ALWSgazhCItXK+DAcFHwGjvViXk4zchYaqJxtodauC4keqb0nfZzZwot4qgRNpSFR5R7A4GpjwWoJOXYKtB6ME5oe+hcaHaJQA7eqUMzLiH7NnNNudsELmksShA7jOQXOd2NWk5eQV/cSPNVtTXInxzyy1lOpAzVzcTGIOO50kFw87aYK4f08J49gZcqvxEj37lUmhhd8oM/auwVtsgr/NbuwSQLHLq2//u0OawrRiil9+z0/kPqW6P4r6uOp5FfU72iEoAokMt4su4SzUWUmD7uxd/+oKJQgCW0QiC8w/k3K3SIJDB2Iw0fig92zlU8b/YMOmoBAAlSyxvAqfgAKtBorMtqLHDXFnnd+j/kqvoKxyzTyk1jBaRUcGzjqqdYJNw+juJ55drFWU6CXsFjBPA4xZyo/sxFa8mksTzi1EFGbbhYAMDLWi26/Sjr6luNRpjVMmBqyFNP/27aoW3aR+MOYbZcBlf799LtJzwU5ULVJ1dJANw13BtMTpq7J2I35j7NWWY/V1mB9Z1C3GRvelnenGSu4SE/6vIvdymp2BJaCKcL5uryD85z8crj/Sn6KcSpzPJGJ2UPqXcq3W0wLDFFBfvhET9MpCNxDOk6lbgW8eDBc/bMTTGnsAduvKzO8f6nK8Ajn4L9ZGfRCYvEPGyztYtUcjTrsyNJKd7mjMfYzIpJG6lB
 madq2cUx
 EL8UdzGl8JDXdT9XLVR37EJ42wj3GA6zwWLWMwLoV0J6KOwwhlp235VQNIqnPLsm62nZFjC+idtHY3QZT5M6DY1Ta0vfXTm1RBmjqXlzt/nuTFaelpkFlfmLVSPtejMMwMvPZHBIjPAj9nbGcM1cNL+UEcl/VNauKwDQPoI5z54U2yF8QmA6tiVR067IntphbNT/iIJ1JiV5jOluqBG64oqnj9Z6gKD5Ju88hnPdmbNDGKVMJ1uLPlSXn9IU7wwddDtN0TmP3reRKDksMAhAzz/gyS4ZHBVFAzv0JZE0CMLvk5x1W0khh7GoSH1fqsnJ26fh7qfplxZ+PscQXOPDw48ws2ruXtkn5BrqoJIdxb3BzfH56L+4sbc+cVPltV5GjLViEsUoUAZiqqomN9+35ZMtYpF/sl7y3OdMnS7OxrtTGyA5qckJ7F+oL5CWs8pO75Uq+0cRtpHKIg9bQBxm1081CvpERCisq1eBzZuPfCEIjaL+04HpGMR4pOd1uMfi/jmWGPtNhZ5yCGuzaW8ylxZbhBmU5HUUbyL2s+2ogYrjZXHjOLSulKNXLrtZDQQlBl+Nl67SB1+quC0Bo03XtIDWyisE0bkKWvNF23uqgifzIsc0IdkmxMvDUTAOy/wtqP8yY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 05:09:40PM +0800, Wen Jiang wrote:
> vmap installs PTE-level block mappings by reusing set_huge_pte_at() and
> huge_ptep_get_and_clear() under #ifdef CONFIG_HUGETLB_PAGE. This makes
> the feature silently unavailable on CONFIG_HUGETLB_PAGE=n kernels and
> couples mm/vmalloc.c to HugeTLB internals it does not otherwise need.
> 
> Now that arm64 and powerpc/8xx provide pte_set_huge() and
> pte_clear_huge(), add the generic fallbacks next to the existing
> pmd/pud_set_huge() family and convert vmap_pte_range() and
> vunmap_pte_range() to the new helpers. The CONFIG_HUGETLB_PAGE guards
> around the block-mapping paths are dropped, so PTE-level block mappings
> now also work on CONFIG_HUGETLB_PAGE=n kernels, and mm/vmalloc.c no
> longer includes <linux/hugetlb.h>.
> 
> The fallbacks exist only to keep the build working on architectures
> without PTE-level block mapping support. They are unreachable there:
> the callers only run when arch_vmap_pte_range_map_size() or
> arch_vmap_pte_range_unmap_size() return a size other than PAGE_SIZE,
> which requires an arch implementation. BUILD_BUG() makes that
> explicit rather than silently doing nothing.
> 
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> ---
>  include/linux/pgtable.h | 29 +++++++++++++++++++++++++++++
>  mm/vmalloc.c            | 19 ++++++-------------
>  2 files changed, 35 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 8c093c119e5a8..a7fd51fec8a17 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -2204,6 +2204,35 @@ static inline int pmd_free_pte_page(pmd_t *pmd, unsigned long addr)
>  }
>  #endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
>  
> +/*
> + * PTE-level block mappings for vmap.
> + *
> + * pte_set_huge() only has to be implemented by architectures whose
> + * arch_vmap_pte_range_map_size() can return a size other than PAGE_SIZE.
> + */
> +#ifndef __HAVE_ARCH_PTE_SET_HUGE
> +static inline void pte_set_huge(pte_t *ptep, unsigned long addr,
> +				phys_addr_t phys, pgprot_t prot,
> +				unsigned long size)
> +{
> +	BUILD_BUG();
> +}
> +#endif
> +
> +/*
> + * Likewise, pte_clear_huge() only has to be implemented by architectures
> + * whose arch_vmap_pte_range_unmap_size() can return a size other than
> + * PAGE_SIZE.
> + */
> +#ifndef __HAVE_ARCH_PTE_CLEAR_HUGE
> +static inline pte_t pte_clear_huge(pte_t *ptep, unsigned long addr,
> +				   unsigned long size)
> +{
> +	BUILD_BUG();
> +	return __pte(0);
> +}
> +#endif
> +
>  #ifndef __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  /*
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index bea9f76ed7e74..fb757d95bde25 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -38,7 +38,6 @@
>  #include <linux/rbtree_augmented.h>
>  #include <linux/overflow.h>
>  #include <linux/pgtable.h>
> -#include <linux/hugetlb.h>
>  #include <linux/sched/mm.h>
>  #include <asm/tlbflush.h>
>  #include <asm/shmparam.h>
> @@ -100,7 +99,7 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  	pte_t *pte;
>  	u64 pfn;
>  	struct page *page;
> -	unsigned long size = PAGE_SIZE;
> +	unsigned long size;
>  
>  	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
>  		return -EINVAL;
> @@ -121,17 +120,12 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  			BUG();
>  		}
>  
> -#ifdef CONFIG_HUGETLB_PAGE
>  		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
>  		if (size != PAGE_SIZE) {
> -			pte_t entry = pfn_pte(pfn, prot);
> -
> -			entry = arch_make_huge_pte(entry, ilog2(size), 0);
> -			set_huge_pte_at(&init_mm, addr, pte, entry, size);
> +			pte_set_huge(pte, addr, PFN_PHYS(pfn), prot, size);
>
As far as i understand, X86_64 arches do not use this path. This
specifically is only for ARM64 or powerpc. pte_set_huge() makes me
thinking about huge-page mappings(PMD/PUD/hugetlb). This helper is
about mutli page mapping on the PTE level.

Better naming? pte_set_large()?

Any thoughts?

Other then that:

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

