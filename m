Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1353E67A95
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 08:38:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4018D6B008C; Tue,  3 Mar 2026 03:38:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AF276B0095; Tue,  3 Mar 2026 03:38:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ADFD6B0096; Tue,  3 Mar 2026 03:38:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 16B106B008C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 03:38:30 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9C0128B5D1
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:38:29 +0000 (UTC)
X-FDA: 84504100338.28.0958ED5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 80105A0007
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:38:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772527108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2M/RYer8VqSFpIScaGLnqlWvdg8+Nw01gnVuCu5eeO8=;
	b=taVTXFP2DXYc6mywlaLIJF3raUQgc+w12s+Kk4lHvrFfQhM4VHvSIONIiqZ6PZ9xgXn9ZB
	oWOMEWHowHkmgNcd279lTfhJppSfiY+gzSPedlDJ4lu6vdhl7BhmSI2PzrvT+bDAKzWE7h
	OXsGFtPyJjDeklYC7OTYvzDLf4MvVjU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772527108; a=rsa-sha256;
	cv=none;
	b=S5OyXX/vJkx0wQgiH446r0VlmRWkSDAfQOya3rUCKoYIeK1iDh/4iRsE6KwsYgdyZNfEiP
	UPvQ8UgZM1HomH6qOxTKdzWBBgIt/8bWK+hmQCbRcFJO0U/+S3GIbqRYAgMi1GI/sxrkrW
	ShVsanzlEU8rm9OTXmlH+ZFbDySFXdA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09E9A497;
	Tue,  3 Mar 2026 00:38:20 -0800 (PST)
Received: from [10.57.81.89] (unknown [10.57.81.89])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8222E3F7BD;
	Tue,  3 Mar 2026 00:38:24 -0800 (PST)
Message-ID: <0a10ea33-937a-4294-b9a1-9323c706434d@arm.com>
Date: Tue, 3 Mar 2026 08:38:23 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: contpte: fix set_access_flags() no-op check for
 SMMU/ATS faults
Content-Language: en-GB
To: Piotr Jaroszynski <pjaroszynski@nvidia.com>, Will Deacon
 <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Cc: Alistair Popple <apopple@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
 John Hubbard <jhubbard@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Breno Leitao <leitao@debian.org>, stable@vger.kernel.org
References: <20260303063751.2531716-1-pjaroszynski@nvidia.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260303063751.2531716-1-pjaroszynski@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: f1hzo3njpb3d35r5ccqiijhpd4q9996q
X-Rspamd-Queue-Id: 80105A0007
X-Rspamd-Server: rspam03
X-HE-Tag: 1772527107-633032
X-HE-Meta: U2FsdGVkX18wYXAgzrku+zX1asPZBLq/y7C144Cfq40d0rnJzfqmc+j3vb69AVDKkBqlsdD3Eu7vOiO4LGMO7B0X/xSEhKTBYmkRrLGzJvHuujqo6PtIQYnZ6xgPOQeiTycdZ7i/f6i4TWyFcp6WIZESmumWUYzxKM9gjezUh/jd/wILAocBX81ambLGA2Iy8gQNt1mHYUB+/C87NC1FQzy//lcB5ADJtM+Af4pyXhhlvbK6Tf8Wb6r6XDiiXbABgOAolQvtnb2tSLO1Uld4yqlF31F/F+yCOOugURQpHQXmfmt+oY+63+dT4HFoo0FdzKNjwKWrJaNjuQ3OV4NsjDnC7WDwSfBw/dyPItWXub7ZnPDodCnZ6vcPzVuYkITaPNWjZ1dmNWHI8k3uJQy5buzPvXmP9fsxZGJB/qy81vXXdPvoZAbtM3QquU57+rFWV4+Qk3GFAsTYfXkgAV6Xh8oGnNPlJl4Fn2JQuHSZDaBgyQGM7z4O+L2kSmsGcwNCPh7WkKfYq2tycySsaMZ6JsihkCju5qZfCmozQAOklBdo5hWMabKIsOSp4hzjIQN+TWgghBLKf92WxdUQAFmsSv5CX2i0iR46KsvlkRNoxyyr+wXsxMuDJaAaHGwnWjEsErlLZUAna9B2YA21RAm+8if9qJqN0lhI61ubAoEvlbr4tXVKqVkK4CLfxdvn637xINFZAmn4HE4Lef3/MEPjFUlfyZerDbny2Adxz9rSVgSRB9z4hrdGKjsJY2uqOb7JmC1cHzv5tCviRTHiQs5WxS9eNys/5e5Bntp6Jxj9VCBiVQoniq7wMzJhiMrsrM6p32BLz6kEDVS4Wt6BSXWkU9rjkJ0c62nYXX5JvddIFOVvY5tkrl/CAdvxnrpiIyRGzavax2soGwKV1My4GLp923Puc1zdwFSX0PmT+1Z06M3FUnbhvvLkffiNewaERZAvqfPAQVWpwUrjLpLZLya
 FY9phz5W
 c+gSrmBTd26Sr1x+qM2rjMViITHF3TKfAcUpVKjXqOMpnS//0MU1lCfDli9L/1+rFxYkH/eX/+jSBo89hujqksH0vKC/SCv1a9E7fQoFVaEBR1L7pswoR6zi4sFmuYa65Cqyoya9xtxLdkPeXbjZ/4S6UWuKFcsm+FUx7dx3wGuyQiVGamSpH/2t9CpClg6PKLt6kdk/YWVyKPYgV4AD6Exmt5f3HGjjA8kIpbBfzBgiu84Ej8W2/2yhnV/tViODhFxwv31oXm5we/KKwW5mkh5ztOSainF+cylPnVDVatUVQtVgVBomoKPldLVdc5w2zWgXM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/03/2026 06:37, Piotr Jaroszynski wrote:
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

Ouch; thanks for the fix!

> 
> Gathering can therefore cause false no-ops when only a sibling has been
> updated:
>  - write faults: target still has PTE_RDONLY (needs PTE_RDONLY cleared)
>  - read faults:  target still lacks PTE_AF
> 
> Fix by checking all sub-PTEs' access flags individually (not via the
> gathered view) before returning no-op, and use the raw target PTE for
> the write-bit unfold decision. The access-flag mask matches the one
> used by __ptep_set_access_flags().
> 
> Per Arm ARM (DDI 0487) D8.7.1 ("The Contiguous bit"), any sub-PTE in a CONT
> range may become the effective cached translation and software must
> maintain consistent attributes across the range.
> 
> Fixes: 4602e5757bcc ("arm64/mm: wire up PTE_CONT for user mappings")
> 

nit: there shouldn't be whitespace here.

> Reviewed-by: Alistair Popple <apopple@nvidia.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Breno Leitao <leitao@debian.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Piotr Jaroszynski <pjaroszynski@nvidia.com>

This fix looks good to me:

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>


> ---
>  arch/arm64/mm/contpte.c | 47 +++++++++++++++++++++++++++++++++++++----
>  1 file changed, 43 insertions(+), 4 deletions(-)
> 
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

There are 2 forms of "dirty"; HW and SW. Here you are testing that all ptes in
the contpte block have the same form of dirty, which I think is the correct
thing to do. You could relax to just test that every pte has one of the forms of
dirty, But in that case, if a pte is sw-dirty but not hw-dirty, then the
PTE_RDONLY bit remains set and the SMMU will fault, I think?

If my reasoning is correct, then I think arm64 hugetlb has a similar bug; See
__cont_access_flags_changed(), which just checks for any form of dirty. So I
guess hugetlb is buggy in the same way and should be fixed to use this more
stringent approach?

Thanks,
Ryan

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
>  
> +	/*
> +	 * Use raw target pte (not gathered) for write-bit unfold decision.
> +	 */
> +	orig_pte = pte_mknoncont(__ptep_get(ptep));
> +
>  	/*
>  	 * We can fix up access/dirty bits without having to unfold the contig
>  	 * range. But if the write bit is changing, we must unfold.


