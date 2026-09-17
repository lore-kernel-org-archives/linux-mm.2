Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA25BC982CF
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 14:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC02D6B0093; Thu, 17 Sep 2026 10:00:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D711C6B0096; Thu, 17 Sep 2026 10:00:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C87A16B0098; Thu, 17 Sep 2026 10:00:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9BDAD6B0093
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:00:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 28BCBC035E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:00:13 +0000 (UTC)
X-FDA: 85223413506.25.9C3C843
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 23D091A0003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:00:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V5zw2bKn;
	spf=pass (imf19.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789653611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rF0BtYMFWD7pbUoewLZT8mBNaLMLep6fnG7M6eFSgew=;
	b=zTKqWFLTaoeaO5At0dB2NwH6hveaJfQe7JIJZhEY8yzmV+/c9JZ2WqvE5Yoihgd/xA60qS
	R/0iDqwKXGneJQfYAa2qp9mEsiGqssndk0JJI6wUblYwazGLYg+cMkUsBams15z5F2oVvm
	udy0WUx1em+MrwxvREBbc8d57FdWzXw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789653611;
	b=UMkTW/K1/vOSYa0qaVi+tOIvwZTUr+Wyvf/LbgQt7ESxXybFhK1Ebdylovp3AuleokRkER
	29p9Pf5KgyzsZZ4Mu26CVAQnlJfr2CovAV2fgpFc+dijTF3jT8M6FU616Ua5DB5kf22ZQd
	q+QmylzIylpZ2WsM5aC8lf/XBqVbLBw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V5zw2bKn;
	spf=pass (imf19.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 04964436B7;
	Thu, 17 Sep 2026 14:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2351F000FF;
	Thu, 17 Sep 2026 14:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789653609;
	bh=rF0BtYMFWD7pbUoewLZT8mBNaLMLep6fnG7M6eFSgew=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=V5zw2bKn13/jSs5oYoBaVSxDvVGNH5RAFypAh0bqZw5RVdBazKjorZGSozYJi0rKR
	 qrdBhf5YWC9rDRmzz0bTjcnXOH0CZrAYY8VRSqierzDIf04pI6MBlHJKlLpkPJj+UC
	 nDwhjPVTlRNWwld+zl03AF+e0uBDLKdcrOm3+KRSRq6omTdsOlcsPBngKo8TtXxeTd
	 JlrwIqe3ielkYtrwB8L8P53XLDPu4aCUv22o/hwzZvUmLcq1kJr5MUUjcTupngwM+Q
	 Y5ZLpMsUJn2tIFiQoKXR/3PjxO8yUmnFLk046Qu4tSIGQrLGr6mZN59Tn5kliAmrQm
	 d+k0M8EebydDw==
Message-ID: <27072d94-13bf-4bea-948a-d8a67976601e@kernel.org>
Date: Thu, 17 Sep 2026 16:00:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 03/10] mm/vmalloc: use pte_set_huge()/pte_clear_huge()
 for PTE-level block mappings
To: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org
Cc: Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, anshuman.khandual@arm.com,
 baohua@kernel.org, david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com,
 leo.yan@arm.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, rppt@kernel.org,
 ryan.roberts@arm.com
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
 <20260917052933.188679-4-jiangwenxiaomi@gmail.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260917052933.188679-4-jiangwenxiaomi@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 23D091A0003
X-Stat-Signature: rt5nwbjbfkfb9efueceno6x6grj8rgot
X-Rspam-User: 
X-HE-Tag: 1789653610-472612
X-HE-Meta: U2FsdGVkX18uA8zhNCMURu05KgRBogaiNaE0wx/0s47qmiuFGAxiXgYmIFQEoFIf9fgdGShPnUAHoQial9Fgp2GqzH0QU/UdfYz2z7iL/y9/XRa0ArKlCfz8OTo1JO6FF+SZaCihGNYfCgMrbeOYSqrsGiGxpVKPCUrlb/6xGpk5+Hpqvc9MDDUhvImbrxnzFhzInYFQvW1IXBBMdbQYDKEoIqgGTceIQ0PtMKGR09Qp68VNUDA1Qzb+Vcksi1GI7Ci88N62BfOpyK6g07Mk8UcYkQibjEeEz3p+5IesxFLUoktMFeCFZv7z9pmOhPtDK06gaPXzsaCpdGbkjSyner3fRwyRa4JGFXfGBWBn7Ghz2b9TVPo3mltdkvPo0Zf+JvoES1gx+7fNRecVrP0cz8lQ/bKlzoMqk07RQKkmlTKTkhQOrTFP2w4VhURncctrOUvs2tEqr9IN1G3j6qe9EKuFY0LU79MI1QjVUil9nhfOyddRaxXmp2zwCfKtZtCbwmvZfRKrq+ZPHWliPxL7nYfM/O87GeSXm2kSGZakAamDRVb2lOP76iBY1pfTmDFopx6+iSMvHj8MVtOFF2Rqr2ctubwNBFMvNVV0CgaTrBuZj1gK0cdx5J8b0+rpseTCYjLQtq5A/uCrC/su1puzehYPcHfaNFlnoQhtJkkVRNWWPXJ1jgyN+feRrlLUGTJKBS1JzaW6MzPt4BFL4hS/PiOXj+Kg5kFJtMjJkTPY+wHR0AdYTVETRAl1gapvsusswyT1Oa3uqw69M4G+G+hOvWXiUNgY7MjE3wISsSUoC+pKsb/38n0SEyFfd2dvkyigOn77iaRhsjmBGFcNjn1v0j4A/csPLtZ+NL+xm1SIdLAoaA3u37CS1YVlzpMydWMQrsl1Sz/c9eO3As+Ty196nEJwXDW1Ocs5XWY7ghX31rEaZ0F/+iqNIpQyWrFydBDwGnkGBoszst/rXQg9un2
 cLEOekPL
 CEgYrf78xqYG6+2iybXoGHRRHIPYAZa9V4zv0CTrL0nopk0pt05PkrVP1sVAURkUmNowz2GRUgsM+IounzCygRwZz4I3rYUTmfL1tT88LFAe8I+3eUGD9diTNNO4Asqx4H5x/swJiPR6oaj+ibXOnyewvrvZkScprb4ZKexX9HnhxDw+w29xpoVJbGdnmO5mWnGtFgwZLhpa+PWSsyuSKBdg0Ja2Ycrclz0lAOMQCQhM2A+f6rqlt8lnwMJKiKReoZsgStq8k6Sqi8wWJe/eIiTdfgsiaAoqLBj+ucWaHSxa9OwjSRJNXb/WvckHp0O28Qtazdr7xIVafePXRiYSsq/eBfrPBer62pMnjInhSRCQGt7rnUz8UnTYtO7VoDRdxi7hkMtrF+qBXfn9n6apwdIllAYQY/NrC+wuCxIruhnf0Rcw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 17/09/2026 à 07:29, Wen Jiang a écrit :
> From: Wen Jiang <jiangwen6@xiaomi.com>
> 
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
> which requires an arch implementation. WARN_ON_ONCE() makes that
> explicit rather than silently doing nothing.
> 
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> ---
>   include/linux/pgtable.h | 29 +++++++++++++++++++++++++++++
>   mm/vmalloc.c            | 19 ++++++-------------
>   2 files changed, 35 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index cdd68ed3ae1a9..349ced999f959 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -2134,6 +2134,35 @@ static inline int pmd_free_pte_page(pmd_t *pmd, unsigned long addr)
>   }
>   #endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
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
> +	WARN_ON_ONCE(1);

BUILD_BUG_ON() would be better here.

It should be possible because fallback arch_vmap_pte_range_map_size() 
will constant-fold PAGE_SIZE so pte_set_huge() will never be called.

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
> +	WARN_ON_ONCE(1);
> +	return __pte(0);

Same I guess.

> +}
> +#endif
> +
>   #ifndef __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>   /*

