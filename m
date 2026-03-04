Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F9B7EB7ECD
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 11:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88D1D6B0088; Wed,  4 Mar 2026 06:17:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83AD36B0089; Wed,  4 Mar 2026 06:17:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7392C6B008A; Wed,  4 Mar 2026 06:17:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67D2A6B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 06:17:16 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 109B75901D
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:17:16 +0000 (UTC)
X-FDA: 84508129272.28.E59AD3F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id DC04080010
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:17:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772623034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YJumK9oi29LGIfWsc8y1hHwQWVIKDFMi4hbwyi6K11M=;
	b=SQfjGrOe8tYgDFt2JQ3x1dUqgCYhpWkDS4xN24m9+X3j+xcMyoWIjsbrLmXYGJbYsCq7CV
	QwZdiqWdSc4N7q1lYBupYL4Ed8gWC+o4mhfG2PcYk+seDWnxOQxxTKsMpo8B6WOYdeJyf8
	05Nom2ty+bM0518Q3nTOQPR7JKBVsi0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772623034; a=rsa-sha256;
	cv=none;
	b=oEmZl+M82TcfkxHYbwRahXczGpnehMB1frTr/5bxesJvKMxPD4oq/fM2P8emphxx80IjhC
	hF3Pr7hjxJcjmnnXgLdNpgHNiDNftjSJr9C6VI3Lp8mG5/9oLUUC8W7KIJASY81sxVITRj
	+ucXH4QEN9AhA8xivs1D+eGNt8Dfvd4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6921B339;
	Wed,  4 Mar 2026 03:17:06 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E71843F694;
	Wed,  4 Mar 2026 03:17:10 -0800 (PST)
Date: Wed, 4 Mar 2026 11:17:08 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Piotr Jaroszynski <pjaroszynski@nvidia.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	Alistair Popple <apopple@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Breno Leitao <leitao@debian.org>, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: contpte: fix set_access_flags() no-op check for
 SMMU/ATS faults
Message-ID: <aagUtDTca5d0le2Y@arm.com>
References: <20260303063751.2531716-1-pjaroszynski@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303063751.2531716-1-pjaroszynski@nvidia.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: DC04080010
X-Rspamd-Server: rspam08
X-Stat-Signature: nkmpr7z7c18iii7547hob5tt3ywkazwp
X-HE-Tag: 1772623033-646007
X-HE-Meta: U2FsdGVkX1+CrWu3kXJHBltcrWynquwu5LkrrTamFLTWmn87GE2jPPQAiKJ+/0XrvYUvPTY+qfATG05cj+EwXm5jbboEX8o3SoIDjaEMHgiWzS5Sd/D3cbgw5M6lRVTdIDnxRtAePbR4kdLFWxlLTVysMbp3ZX5rQY8nIWp94SEoyS1l6LCoOdqrxSTwTux2PzU6NWEt/u0jimlRG+JMcsQD6JSDDEpk5uji9QlNwEqUeEQalncN4pyG9Wur6ht+ZHAdydJk5H8glzFTYrFSDW6HxGe0NStgXFCny5OeAD4DZFx4V7js+vfaw02jhZFE8kRmlpuT6dWkPo+WHVJ1h2ijzOfzf1rJwGZ/Vv8/gRXfphlFpyyPOZ9Z+122ELKe37CRJI36+XPC4t/U4PPvIv+1FPDS/BLjVlx+lMaliNwL3qihKuM4gHNnIjbGRSv/k8GM/FWMMxNRQGSTF24LHEdy2oiE1qKc7gBcScaXNC8jncut6l/Tl8IDxt8/ifmaSaKrgRAC06xTVfeHoQXTHFX+edaJBl9mznHohfZJLXdTqzigLhuti0ME0HE2Ax/icWNlmQOFyu7BCLNe5jBm2m9LAh5m9KjzPZSzdC65RopBfj1gY5Tctj06NH7q+fns0sByXOTt6iNj+Q60UY5T9cgH/jyV+xa6+wZHYJsOdyIz15pRsqTy1TRvNMYDgvuMM9lkteqzaRY+x1tY/MrQ9Re/VWk4vf/sIZm3a40LAkgH7yReqEGasIA8154RP30xXG26U1Vmg7pL37n0YCEklFlML7A8mjWbXqlKw2+AZhQJLmj/OGWPoG8kzZEORnZJUDOCGIKp4jLZ+ko87CfZu7Sw3c5fI4Fjn7fB+6uxmRnv1e1n+UhcBdml+FuNcsvDT6pvp6voSuwjHbRf6F04MlUPwrds0B7lRVgnP3Dj52UsPFIyR7yx8m9nGh4VU425CMHujRDBImfY92HlxmW
 0bSXF4yb
 XQ4UC4u1HYKMcuhdXvgDRVZOvlEeh2oMlwbGWJIGaC3pWX5tebpbft+wprPmAr6+6MFabboHbRJ/tWvvWfF1Ab0dgfDALwRdDO5mRmyYaGURGHP8qbmSm4ZHG0mrDqCAKQknLJccV3pVcvcbELNIFXPYg2CR+gJauDnRxMVFki1sa/M/vQwASqF3tNQFTXCAnMOfD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 10:37:51PM -0800, Piotr Jaroszynski wrote:
> contpte_ptep_set_access_flags() compared the gathered ptep_get() value
> against the requested entry to detect no-ops. ptep_get() ORs AF/dirty
> from all sub-PTEs in the CONT block, so a dirty sibling can make the
> target appear already-dirty. When the gathered value matches entry, the
> function returns 0 even though the target sub-PTE still has PTE_RDONLY
> set in hardware.
> 
> For CPU page-table walks this is benign: with FEAT_HAFDBS the hardware
> may set AF/dirty on any sub-PTE and the CPU TLB treats the gathered
> result as authoritative for the entire range. But an SMMU without HTTU
> (or with HA/HD disabled in CD.TCR) evaluates each descriptor
> individually and will keep raising F_PERMISSION on the unchanged target
> sub-PTE, causing an infinite fault loop.

This can also happen if not all CPUs support the hardware updates of the
AF/dirty bits.

> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
> index bcac4f55f9c1..9868bfe4607c 100644
> --- a/arch/arm64/mm/contpte.c
> +++ b/arch/arm64/mm/contpte.c
> @@ -390,6 +390,23 @@ void contpte_clear_young_dirty_ptes(struct vm_area_struct *vma,
>  }
>  EXPORT_SYMBOL_GPL(contpte_clear_young_dirty_ptes);
>  
> +static bool contpte_all_subptes_match_access_flags(pte_t *ptep, pte_t entry)
> +{
> +	pte_t *cont_ptep = contpte_align_down(ptep);
> +	const pteval_t access_mask = PTE_RDONLY | PTE_AF | PTE_WRITE | PTE_DIRTY;
> +	pteval_t entry_access = pte_val(entry) & access_mask;
> +	int i;
> +
> +	for (i = 0; i < CONT_PTES; i++) {
> +		pteval_t pte_access = pte_val(__ptep_get(cont_ptep + i)) & access_mask;
> +
> +		if (pte_access != entry_access)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>  int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
>  					unsigned long addr, pte_t *ptep,
>  					pte_t entry, int dirty)
> @@ -399,13 +416,35 @@ int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
>  	int i;
>  
>  	/*
> -	 * Gather the access/dirty bits for the contiguous range. If nothing has
> -	 * changed, its a noop.
> +	 * Check whether all sub-PTEs in the CONT block already have the
> +	 * requested access flags, using raw per-PTE values rather than the
> +	 * gathered ptep_get() view.
> +	 *
> +	 * ptep_get() gathers AF/dirty state across the whole CONT block,
> +	 * which is correct for CPU TLB semantics: with FEAT_HAFDBS the
> +	 * hardware may set AF/dirty on any sub-PTE and the CPU TLB treats
> +	 * the gathered result as authoritative for the entire range. But an
> +	 * SMMU without HTTU (or with HA/HD disabled in CD.TCR) evaluates
> +	 * each descriptor individually and will keep faulting on the target
> +	 * sub-PTE if its flags haven't actually been updated. Gathering can
> +	 * therefore cause false no-ops when only a sibling has been updated:
> +	 *  - write faults: target still has PTE_RDONLY (needs PTE_RDONLY cleared)
> +	 *  - read faults:  target still lacks PTE_AF
> +	 *
> +	 * Per Arm ARM (DDI 0487) D8.7.1, any sub-PTE in a CONT range may
> +	 * become the effective cached translation, so all entries must have
> +	 * consistent attributes. Check the full CONT block before returning
> +	 * no-op, and when any sub-PTE mismatches, proceed to update the whole
> +	 * range.
>  	 */
> -	orig_pte = pte_mknoncont(ptep_get(ptep));
> -	if (pte_val(orig_pte) == pte_val(entry))
> +	if (contpte_all_subptes_match_access_flags(ptep, entry))
>  		return 0;

Actually, do we need to loop over all the ptes? I think it sufficient to
only check the one at ptep since it is the one that triggered the fault.
Instead of ptep_get(ptep), use __ptep_get(ptep). The rest of the
function sets the flags correctly for all the ptes in the contig range.

-- 
Catalin

