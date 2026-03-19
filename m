Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D525C108E1F0
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 11:32:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4988A6B0482; Thu, 19 Mar 2026 07:32:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4704A6B0484; Thu, 19 Mar 2026 07:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3854F6B0485; Thu, 19 Mar 2026 07:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 26D0A6B0482
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:32:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DCB061401DB
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:32:08 +0000 (UTC)
X-FDA: 84562598736.19.746F3CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5097E1C0017
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:32:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X2OyEQky;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773919927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y63+VS6Ui6u2uD65V7I/tnWHyuvPlwZc8zO/RDjC0zU=;
	b=MTAK9PpgXmbhIWhsaeg0+arDOnltMg0j54hDSBogfIQt47OaGIt16Cf7AMf+h4Q58YmT7b
	4kMND0GvsN7xiJKH+Z6sDNi4QCKxMXqy/EMspajOt2QSYiGj+BYFSryRN8jqxfD6zxahTZ
	TXDOPA2T2Kx1UzPRw3GPwW7cSaeeJjk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X2OyEQky;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773919927; a=rsa-sha256;
	cv=none;
	b=z1lLJh711cirgyk6bwAfP6iP9BAH+An8bnwY5JerWf3IkywyIouHGrTOHgjHizBG5grx1+
	8FTIKeWbVqFRpD4fkby5nWWw7XOKzeafW7yIjSVb5T2ekWgXCMFwL5C5b2c5Rf+0Rhbc9r
	uPQ+LbR+MRztazv1NvhvCBufQt/deec=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A9AFA600AD;
	Thu, 19 Mar 2026 11:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87ECBC19424;
	Thu, 19 Mar 2026 11:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773919926;
	bh=ugQLkf+Im/G2ICHzfRRGmINpZCFsd5Ug2LKZKDtrCQc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X2OyEQkyM6gUfaXokm8qxkuv0WTQ10u+7Ts4unJj/PT1yGFvsITG7LB/Td5BC6kGR
	 kFrpofMPgQALPtj6R6PdXlViWz9aW87C/3LOV16eT02ve0oMBCkKvzVXVKrhF2MK+M
	 ljkDYbXZQ3ywYYxmHkIQigMocTVr+c+qn77LgA35CNdezZ0tk1MFeWl5oaPIyZEg+9
	 VphrsyzoEREy7BFbtc+/nj/sm3FQCeYEHDiNG3V2SIkxeqOf+iGj1ZEskGD9MDJkzt
	 CaE9smJJ38g5f7JqtzLcCFYJjDlVv5oq7rr2n6trUdfLlelwiW1/WeF+vw5SIetes6
	 YRHJNiULNqD4A==
Date: Thu, 19 Mar 2026 11:31:59 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, Liam.Howlett@oracle.com, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	kvm@vger.kernel.org, open <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] mm: change to return bool for
 pmdp_test_and_clear_young()
Message-ID: <4cf8eac4-f601-4f39-8094-d904edbf454d@lucifer.local>
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
 <8025b898d0841a4bcbd766998959b4e2ae4d4abc.1773890510.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8025b898d0841a4bcbd766998959b4e2ae4d4abc.1773890510.git.baolin.wang@linux.alibaba.com>
X-Rspamd-Queue-Id: 5097E1C0017
X-Rspamd-Server: rspam07
X-Stat-Signature: 7oq9o9n8xz8h65oj6keeeb89sfnfg88a
X-Rspam-User: 
X-HE-Tag: 1773919927-6709
X-HE-Meta: U2FsdGVkX18vVtkOZPPEyWp+T8C+k5HJ3+JstSkZcsPDyU+JLJ8llSM3nZEbMm8McPm/b9pP7TCjR2r1pAcXiXGUq4wXjsfGDbiBLa7sLfxPh1IArrxL8nKtFRQJvoLskxWcaS2HB/uHjj7TqDZYBnrfcrNETVIc6ESAh6CVzOpGrDkw4Fq8bfDSJ5OL/huh5jAhf/UMGXB8aNdS3Vd6sVtDa4XMvp3BTyhZt2bCUotanoYY83M1T0V8rgsLFhBlqUv1DgcRqTqnNldx7b7xGkAKvm6jUpeZs4Lk/xHsmmJPsMzgp6LA9KOtUAcBGw2oePYuRZxAhtZ3wlnci35vuWkAs/KGmvJ+ebOVxDcHjn4RGlNA9DmzbIfW+g8d2vry8ZMVD37CdJkbM3xUx8DrJv1YgqhcmUBd0KsJVIX3/RCD0GreaQ+9Ng2yq7ramVnroGpVBP9bfDjNfWMwxtHX1ae0P5XQ5kuI8n2HCzKQThZCX+hsVMM9NlQu18Q1ingg8lZcJFFmQeJUcspAf4fRtVQr5MUDOLq+qwBVknkvq28xb1BwpdbyJURqnhra6qEMHFjXhESUVvdPE0rYu/VSPu7r1E9N7ddyjCfsxq6LTPFYWBf3PEIiWRd4uRGmLACdUA1GiCYmqtnoFLde78jMbiSQTj3f6rhQ31hnSJNdQwJwu0mBB7vxryqyK2DVwnVKdUgXSjaoUhJ5i7jVDGRe71jiKMsKSLV7v22juEVqpWBojdzZO8kb36gCsOHp2GV6aY+Y8DIZiUtCjgY+T6xNg1miSOapBiXPyoxDjjb7UYSDV3Ru0uB8KPg2kxlfDl514SSmq0zUwW6XC3jB9O+HHnYSZ/KVRrM88vi2arjvDRJbPakL3VygczWj7pj9mz96mHTxQFtY1GnRD2F/nTrY1q1PL8z4ko+DA5VFaUus+WPn73ltltDizVNffANIkLCR/VC6SBm0tB9PIS+0DWe
 ZlMufWrr
 RHo/5ghVL6I97RFmU0jUNrts4hELJKAZSzZbm22sQ2UvfJ/0COodSKQKTMATFak/oyQdC/ZS9bgAk9nD6PiycZXU+PeKbA9xQKz3nHv/YkhwIoOGI4Q+Z0KZA1hxhq4D0rs+eP4ZRQOlRAqVDSsfcUwwvGN338kH5lai/x+XsZrFwSRmYcCgpdHGBYPr3j1kRVso48pgzn222/rwf6+nTxJSiLlYy+tYlK46suAGQRjHICeoSk4qUjb9jzq5j+ylpSX7bAAPSmYTwX3+SnfaI0hkak36wbfGHu7avwV64Gz49S6dp9ltIbIcAwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 11:24:02AM +0800, Baolin Wang wrote:
> Callers use pmdp_test_and_clear_young() to clear the young flag and check
> whether it was set for this PMD entry. Change the return type to bool to
> make the intention clearer.
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Some nits similar to before, otherwise LGTM so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  arch/arm64/include/asm/pgtable.h             |  6 +++---
>  arch/powerpc/include/asm/book3s/64/pgtable.h | 10 +++++-----
>  arch/powerpc/mm/book3s64/pgtable.c           |  4 ++--
>  arch/riscv/include/asm/pgtable.h             |  2 +-
>  arch/s390/include/asm/pgtable.h              |  4 ++--
>  arch/x86/include/asm/pgtable.h               |  4 ++--
>  arch/x86/mm/pgtable.c                        |  6 +++---
>  include/linux/pgtable.h                      | 19 +++++++++----------
>  8 files changed, 27 insertions(+), 28 deletions(-)
>
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 393a9d1873f6..7ea16f6ad564 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1321,9 +1321,9 @@ static inline bool __ptep_clear_flush_young(struct vm_area_struct *vma,
>
>  #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG)
>  #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
> -static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
> -					    unsigned long address,
> -					    pmd_t *pmdp)
> +static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
> +					     unsigned long address,
> +					     pmd_t *pmdp)

Similar comment as before re: indetation, let's use 2 tabs please, so this would
become:

static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
		unsigned long address, pmd_t *pmdp)

Thanks!

Same comment to all other cases here.

>  {
>  	/* Operation applies to PMD table entry only if FEAT_HAFT is enabled */
>  	VM_WARN_ON(pmd_table(READ_ONCE(*pmdp)) && !system_supports_haft());
> diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
> index 25e3a86943e2..0f34011665a6 100644
> --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
> +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
> @@ -1161,13 +1161,13 @@ pud_hugepage_update(struct mm_struct *mm, unsigned long addr, pud_t *pudp,
>   * For radix we should always find H_PAGE_HASHPTE zero. Hence
>   * the below will work for radix too
>   */
> -static inline int __pmdp_test_and_clear_young(struct mm_struct *mm,
> -					      unsigned long addr, pmd_t *pmdp)
> +static inline bool __pmdp_test_and_clear_young(struct mm_struct *mm,
> +					       unsigned long addr, pmd_t *pmdp)
>  {
>  	unsigned long old;
>
>  	if ((pmd_raw(*pmdp) & cpu_to_be64(_PAGE_ACCESSED | H_PAGE_HASHPTE)) == 0)
> -		return 0;
> +		return false;
>  	old = pmd_hugepage_update(mm, addr, pmdp, _PAGE_ACCESSED, 0);
>  	return ((old & _PAGE_ACCESSED) != 0);
>  }
> @@ -1300,8 +1300,8 @@ extern int pudp_set_access_flags(struct vm_area_struct *vma,
>  				 pud_t entry, int dirty);
>
>  #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
> -extern int pmdp_test_and_clear_young(struct vm_area_struct *vma,
> -				     unsigned long address, pmd_t *pmdp);
> +extern bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
> +				      unsigned long address, pmd_t *pmdp);

Remove the extern please!

>  #define __HAVE_ARCH_PUDP_TEST_AND_CLEAR_YOUNG
>  extern int pudp_test_and_clear_young(struct vm_area_struct *vma,
>  				     unsigned long address, pud_t *pudp);
> diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
> index 4b09c04654a8..aed39bba891e 100644
> --- a/arch/powerpc/mm/book3s64/pgtable.c
> +++ b/arch/powerpc/mm/book3s64/pgtable.c
> @@ -98,8 +98,8 @@ int pudp_set_access_flags(struct vm_area_struct *vma, unsigned long address,
>  }
>
>
> -int pmdp_test_and_clear_young(struct vm_area_struct *vma,
> -			      unsigned long address, pmd_t *pmdp)
> +bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
> +			       unsigned long address, pmd_t *pmdp)
>  {
>  	return __pmdp_test_and_clear_young(vma->vm_mm, address, pmdp);
>  }
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index 11f57ccf6dc9..bac559d29036 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -1015,7 +1015,7 @@ static inline int pmdp_set_access_flags(struct vm_area_struct *vma,
>  }
>
>  #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
> -static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
> +static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
>  					unsigned long address, pmd_t *pmdp)
>  {
>  	return ptep_test_and_clear_young(vma, address, (pte_t *)pmdp);
> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
> index c9ab81caaf75..1f5efb7be71d 100644
> --- a/arch/s390/include/asm/pgtable.h
> +++ b/arch/s390/include/asm/pgtable.h
> @@ -1683,8 +1683,8 @@ static inline int pmdp_set_access_flags(struct vm_area_struct *vma,
>  }
>
>  #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
> -static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
> -					    unsigned long addr, pmd_t *pmdp)
> +static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
> +					     unsigned long addr, pmd_t *pmdp)
>  {
>  	pmd_t pmd = *pmdp;
>
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index 554dea93eb99..bd02ee730a23 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -1295,8 +1295,8 @@ extern int pudp_set_access_flags(struct vm_area_struct *vma,
>  				 pud_t entry, int dirty);
>
>  #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
> -extern int pmdp_test_and_clear_young(struct vm_area_struct *vma,
> -				     unsigned long addr, pmd_t *pmdp);
> +extern bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
> +				      unsigned long addr, pmd_t *pmdp);

Remove the extern please!

>  extern int pudp_test_and_clear_young(struct vm_area_struct *vma,
>  				     unsigned long addr, pud_t *pudp);
>
> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> index 0007dc3d739e..10a5e0b2be36 100644
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -456,10 +456,10 @@ bool ptep_test_and_clear_young(struct vm_area_struct *vma,
>  }
>
>  #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG)
> -int pmdp_test_and_clear_young(struct vm_area_struct *vma,
> -			      unsigned long addr, pmd_t *pmdp)
> +bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
> +			       unsigned long addr, pmd_t *pmdp)
>  {
> -	int ret = 0;
> +	bool ret = false;
>
>  	if (pmd_young(*pmdp))
>  		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 1198e216fde3..e53220b0a9a3 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -507,25 +507,24 @@ static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
>
>  #ifndef __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
>  #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG)
> -static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
> -					    unsigned long address,
> -					    pmd_t *pmdp)
> +static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
> +		unsigned long address, pmd_t *pmdp)
>  {
>  	pmd_t pmd = *pmdp;
> -	int r = 1;
> +	bool young = true;
> +
>  	if (!pmd_young(pmd))
> -		r = 0;
> +		young = false;
>  	else
>  		set_pmd_at(vma->vm_mm, address, pmdp, pmd_mkold(pmd));
> -	return r;
> +	return young;
>  }
>  #else
> -static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
> -					    unsigned long address,
> -					    pmd_t *pmdp)
> +static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
> +		unsigned long address, pmd_t *pmdp)
>  {
>  	BUILD_BUG();
> -	return 0;
> +	return false;
>  }
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
>  #endif
> --
> 2.47.3
>

