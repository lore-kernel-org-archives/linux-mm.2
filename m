Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5411AF33A8E
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 17:33:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC5A86B0005; Thu,  5 Mar 2026 12:33:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9CF16B0088; Thu,  5 Mar 2026 12:33:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC7216B0089; Thu,  5 Mar 2026 12:33:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9B5746B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 12:33:37 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CAFC160224
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 17:33:37 +0000 (UTC)
X-FDA: 84512706474.14.B1F21AD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 507F6C000E
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 17:33:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772732015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6KxDPXzKlZXyg0YT04s+mgKVvzxgPJkOZP0QSTDCW7E=;
	b=HNL1NoGltBDvNfRoP/KFS+C56bpx/vjxquRep0RVtA0IQO+C2FWpWwbWYc6hylPKYdaK7o
	cqnmU0rxBkAVwg+tNATEyWBq/17TO2FBqFiw8CbKhX3VH46TdJh+D6gLdTpmlwHXsWzj9l
	ehZYer2BEpgHJkT2HgORUpmra/t6fFA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772732016; a=rsa-sha256;
	cv=none;
	b=tuTgej9dCkeUPkPmSHoVL2jC9JGmMEOShUzyDvzCoMhPSfOSJq50V55cSL0MXRAnCPdIFK
	JCJ8tTJ0M7inqDoUbAD8WIUsKK9eFME/gQsAZ9gpx8NHesFLpmzMKW9V/W+Yr5J470yYUm
	lse7wAl0KCJY4J4B9a/yreGrryGw1ds=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C36DD339;
	Thu,  5 Mar 2026 09:33:27 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C9F63F694;
	Thu,  5 Mar 2026 09:33:32 -0800 (PST)
Date: Thu, 5 Mar 2026 17:33:25 +0000
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
Message-ID: <aam-ZSHWrkYX8spV@arm.com>
References: <20260303063751.2531716-1-pjaroszynski@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303063751.2531716-1-pjaroszynski@nvidia.com>
X-Rspamd-Queue-Id: 507F6C000E
X-Rspamd-Server: rspam07
X-Stat-Signature: qahpydu9ea5cofsa8d9e5yhwpbf3c6xa
X-Rspam-User: 
X-HE-Tag: 1772732015-525003
X-HE-Meta: U2FsdGVkX19Xc9hvXAD5tr+esA5Rf0Yq1Kijw0F1W9eZdh/jrrKwgaNEDjTFM0HTnU+G5amNTT+EBhCvQeB5Ql7PJg86Fzni3nXl233bgrBj9KfLTsJu3Y1jYawjZ/J4ZJC9F3sa/tfw10PcB8tioSY1VXZwYxIyA9noF0B6SF5AEJVuDaJe9sw9MADTMdJXrPqrYUSRuWqZ6mnqZUtBvOk2IhaNrsScB0TzbIU8ZFDtBimfbZMZF2OIEB0g2kRhDEsa/uSxRwfsjzsqnG9dfcIBTP8UVNwq4BbbX+ix/8j12+XQbq8UwQ6hyflO2SBI/x+CAEOWbDarSL74n1QhVp1I2UgjrCf9AVl7J5kKB28/BRtHgilyz9Gyn4avy9eFgaTkrjyFuOaY5CJgRcsMlfPjTDo0zDu7mNTUqmAw89hS6raxdv63Vc6aUQ2LYdIqeG64dCdnZwNaLNVjeePkkI4s6Cqzg7kFhokuD54TA1Dd8yfBnyGw671mrjz8FJASyu7jH1XbQo1xL+Mw/UXllz5qUOCfZo3AyVs0wP5+9VsR1PfZNKzAxzjZN9QnvmdQbgEtcvL4xixPPYm+vYtLMQ7+ZcC/Q9smcYkFqkxHo94aaMJg5wUyCibFhvno0D6vWWHf4OWnv6EulTYx4fZh3FWWQ8GHj3Yj7+lsDCbWFHYKXWarvRggiOhD/WIz/SuP5Iwxq2BBVF8DMfcLtooFw5cW22CN7Wj+czXyuIJuUpYcao2MpemoWwrVOVaQA4w/6eMrXXytXFwjhAQ2X0f14UCOoyj9OL6MQK0UNbk5YcLkYFbgBnqDe1p+WDxHbPlY3iWFMMjSo5pR4E/sjJF5KmiGcS80uPbl8QyI7ORm11ny8pk3CNInNgvPSFstAhvBxdeYcpUzT6Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looking at the patch again, some more comments.

On Mon, Mar 02, 2026 at 10:37:51PM -0800, Piotr Jaroszynski wrote:
> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
> index bcac4f55f9c1..9868bfe4607c 100644
> --- a/arch/arm64/mm/contpte.c
> +++ b/arch/arm64/mm/contpte.c
> @@ -390,6 +390,23 @@ void contpte_clear_young_dirty_ptes(struct vm_area_struct *vma,
>  }
>  EXPORT_SYMBOL_GPL(contpte_clear_young_dirty_ptes);
>  
> +static bool contpte_all_subptes_match_access_flags(pte_t *ptep, pte_t entry)

More of a nitpick: since this checks both the flags and write
permission, I'd rename to something else. Maybe contpte_ptep_same() to
somewhat resemble pte_same() used by __ptep_set_access_flags().

> +{
> +	pte_t *cont_ptep = contpte_align_down(ptep);
> +	const pteval_t access_mask = PTE_RDONLY | PTE_AF | PTE_WRITE | PTE_DIRTY;

We can drop the PTE_DIRTY from the mask as it's not relevant to the
hardware permission. It probably doesn't matter in practice.

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

It's not just about the access flag but AF, dirty and write permission,
all can be changed by this function (and only to a more permissive
setting).

> +	 *
> +	 * ptep_get() gathers AF/dirty state across the whole CONT block,
> +	 * which is correct for CPU TLB semantics: with FEAT_HAFDBS the
> +	 * hardware may set AF/dirty on any sub-PTE and the CPU TLB treats
> +	 * the gathered result as authoritative for the entire range. But an
> +	 * SMMU without HTTU (or with HA/HD disabled in CD.TCR) evaluates

Or CPU equally, we don't force all CPUs in a system to support DBM.

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

This is fine since all should have the same PTE_WRITE bit.

Anyway, nothing major, so:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

