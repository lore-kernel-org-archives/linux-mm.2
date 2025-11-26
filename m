Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42226D1038C
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 08:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FF356B0008; Wed, 26 Nov 2025 03:15:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CFBD6B000A; Wed, 26 Nov 2025 03:15:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10D086B000C; Wed, 26 Nov 2025 03:15:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F267A6B0008
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 03:15:35 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8D04C89875
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 08:15:35 +0000 (UTC)
X-FDA: 84152049030.06.320127C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C507F40010
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 08:15:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pm0W/0/S";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764144933; a=rsa-sha256;
	cv=none;
	b=vXKx00sfz8IHEKtIIqiBp8SKjWOSupuTXQ+Ek7p0S3zyxjQqSEDh+EZaCAZDMBbl1vvtEq
	CxRZBfxsV7Dcoyo3Zawms+pMBPrVUYraOAU3eoPAqrrQbO84czUJrSMoeFGHnveZ8SAYrr
	0SJbYiA9ghxmGJpzHdEMPm4ToJ1Pn6s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pm0W/0/S";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764144933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SuU9mIxxXpfyaTJ/lXKE5S54hsvHU3Ycqs02YDH7STw=;
	b=d6YG8dTaVPa4SzGt4Hnd0KGuH/7hXl3UAxEDerHFYtI60jhGHF/8NCePJbC8kmh/0Utpe1
	jBNjfUDe8L19XgBPi0qM3H+pT37Hcg5A51S3OxRT3NN/IaPxa5RrMt+VKld6i079yOSoCo
	86JP//eY5qDxuLG1yr7tDX5/8o6+A7s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 008F16013A;
	Wed, 26 Nov 2025 08:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EACC16AAE;
	Wed, 26 Nov 2025 08:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764144932;
	bh=FepWQ35cuYgqvGT7kvsj3i0VNm1MVcS3LXs8XscS8lA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pm0W/0/SeDvPAnTd2qWG5JuuXXO4bBCEvKxSBfWi55hoJjYU9QxqqhMGWljHVpfRq
	 yOOrSBM+LSGRinii+0T530oHcslQf33RNx5zgIoPwZ8oLUgQS7wX9MzHeYU9T8cg32
	 EfawuxlH3yRx+I465HfkdQMHjiJsbPM12nh+D/JsQPmy65nim0LTdM9hUYEmwiEiOu
	 m2BW1LSc7zFBoPM/CpNlzUhIGbzvGVH5jDFsiGdjx5yqMJUL4He/fOCUtGv+1GtCrc
	 Wt4CN29o+lMwxI/B1sapyIaUgHqgqU7XyDGTF3HkWU+v9IS6f+7ugIx/1bMgXE/Hud
	 7InTEeRsliqyA==
Message-ID: <9c32675d-c48d-405f-a38f-4c90a8edac74@kernel.org>
Date: Wed, 26 Nov 2025 09:15:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: use standard page table accessors
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev
Cc: linux-mm@kvack.org
References: <20251126064723.4053-1-richard.weiyang@gmail.com>
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Content-Language: fr-FR
In-Reply-To: <20251126064723.4053-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C507F40010
X-Stat-Signature: 7e1d6ftg8qcqwafh6119wbt7hh4xdg46
X-Rspam-User: 
X-HE-Tag: 1764144933-705368
X-HE-Meta: U2FsdGVkX1+rLr6k9IEyPjRvJx1+OnOnZgfl8crgHkG9fX+xTIJhTMdeeWCcqnxjjSMpXhctLooC8bOccFiYyOSb0N+TzYwZ/qkNyorfgZ5gB3W2ikmtwKfO8Ji+lDdvCTbVw0sfbEDElXuHNuikOKjR3BW488OAdz2VMR/MfAlwTFH28qhTYUVMZjqfx/F1tehjDUsojmyyazBzQqqaG7NWHHl4TNZa3Q86pq3uing/mJGg8wHAMGfU/cEjRrw1tE9vh2vnQx8pr2bCA+lEi9rNyeZ34Oul3U2VNwFQo4EkI1mbYp6KyQ9Og9xfZ+Pxd3P0bepZiLdcf/dDlgLmiTTKzMZm3wqXdv1SFNZYbo74tohJ+DDP6KkXrX2U9hha8+uuL5Jd4hjTbSbF7nGMI3Ww/LCJ6dvEJf/TSxbSLKE5Sl4H1rFll2Lqfl+aoiCZRwNtdeJ+tyBZnUuMiLjxq4Vd7c6B2VJfWE+K3zR83pHKDUoZCKRLJ611FEDy4BwAwOUC4a9EgNsig+U+NQUuuDJgDzeHS+H3xL7ZOBOq1gwPdfN5wkzTPV6476jYjYJtoQLDdvGP08stQoWs3q0LNFeR0fsQfFN+Kz1WDLc/WiMcUzlB/g6SMEcxyMHTAp71gQFCyhZU8Blz7saFt3sfICmpw1nHZLe2ME+h1ysmV6Ogw/riwR82+MylsbpB5I+GXVNLbRP4raa3hK5/0ArvxSLb1ogvmUTEDFU4LUpIs55xq9kxvC+JdrWjrE14iI/5BCWBNgAjvcoy/Vp+QtPJeYJU/ZBk8uVIf0AmUqPprVNvcJ7xGuPQABcTvrJi+El0zsvJVnqU2zHOUNp+mFsmsVCQ9+BGBDEc/hBiyuh5ylkMpaB/c+673tD+QQcS4H/tRX+1SRIkFmjHnjO8KTAobCaxblfPZoyxNFNv6CkmiZ945Pu6oDRpYHTVUMPrbcp4wFObwjKW5M/Cf5656nh
 4eVCMtFy
 ZQdH8guPiGVjh5IbYhkfdSXGMUTS0uYTW7VBnZwCugXMKjasbJ7iowvJwNToGzet2cj0Nn84qz8MP1pwWzzrkRXOS6sC/xJHErBdMqeYvT6c03tgrRSEIJ1pEivkZT0DJ+EziBoOr/78BYjl+NstOzOOMrO/2qePk8XDeeLdBz51XprIfzxvdFHYUALHUQmhzFwEZpdUAhuVZArkLt89A//bc5ZIuQW219FNIwAPh+oeTofjX2klSpTvlJhhJj7T0VmofZVbJQu92rv1pfsCj26+rRkUqJ7IKe7CIIgj24vnjPyQcQafeRlY2Nt7KJyZpB0HqmbcMKUWbSFiTNIrGqFy9yJK9dNt6Lbi+AS3KK0Dy9sTaujpi6TFBZDy7hxCp5l5IjVp3FsEldR+eq48M9kQ2h0sqbPlGlLbkY+jhGnV1tX8lVfBvkn5NBcXrGz2JRZ9cHLvnX2JJXByuBCzkvysJSX1C+n5qGEnOnPYbcuAwAVY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 26/11/2025 à 07:47, Wei Yang a écrit :
> Use standard page table accessors i.e pxdp_get() to get the value of
> pxdp.

Please provide more detail of why you want to do that and how you are 
sure it doesn't break existing implementation.

There was similar tentative in the past already which proved to give 
suboptimal results, see discussion here:

https://lore.kernel.org/all/f40ea8bf-0862-41a7-af19-70bfbd838568@csgroup.eu/

Christophe

> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---
>   include/linux/pgtable.h | 2 +-
>   mm/huge_memory.c        | 2 +-
>   mm/memory.c             | 8 ++++----
>   3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index b13b6f42be3c..a9efd58658bc 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1810,7 +1810,7 @@ static inline int pud_trans_unstable(pud_t *pud)
>   {
>   #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
>   	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
> -	pud_t pudval = READ_ONCE(*pud);
> +	pud_t pudval = pudp_get(pud);
>   
>   	if (pud_none(pudval) || pud_trans_huge(pudval))
>   		return 1;
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 0d2ac331ccad..dd3577e40d16 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1486,7 +1486,7 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>   		}
>   		vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
>   		ret = 0;
> -		if (pmd_none(*vmf->pmd)) {
> +		if (pmd_none(pmdp_get(vmf->pmd))) {
>   			ret = check_stable_address_space(vma->vm_mm);
>   			if (ret) {
>   				spin_unlock(vmf->ptl);
> diff --git a/mm/memory.c b/mm/memory.c
> index 8933069948e5..39839bf0c3f5 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -6193,7 +6193,7 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
>   {
>   	pte_t entry;
>   
> -	if (unlikely(pmd_none(*vmf->pmd))) {
> +	if (unlikely(pmd_none(pmdp_get(vmf->pmd)))) {
>   		/*
>   		 * Leave __pte_alloc() until later: because vm_ops->fault may
>   		 * want to allocate huge page, and if we expose page table
> @@ -6309,13 +6309,13 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
>   	if (!vmf.pud)
>   		return VM_FAULT_OOM;
>   retry_pud:
> -	if (pud_none(*vmf.pud) &&
> +	if (pud_none(pudp_get(vmf.pud)) &&
>   	    thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PUD_ORDER)) {
>   		ret = create_huge_pud(&vmf);
>   		if (!(ret & VM_FAULT_FALLBACK))
>   			return ret;
>   	} else {
> -		pud_t orig_pud = *vmf.pud;
> +		pud_t orig_pud = pudp_get(vmf.pud);
>   
>   		barrier();
>   		if (pud_trans_huge(orig_pud)) {
> @@ -6343,7 +6343,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
>   	if (pud_trans_unstable(vmf.pud))
>   		goto retry_pud;
>   
> -	if (pmd_none(*vmf.pmd) &&
> +	if (pmd_none(pmdp_get(vmf.pmd)) &&
>   	    thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PMD_ORDER)) {
>   		ret = create_huge_pmd(&vmf);
>   		if (ret & VM_FAULT_FALLBACK)


