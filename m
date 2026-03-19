Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC628108E1F0
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 11:28:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D2456B047E; Thu, 19 Mar 2026 07:28:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1833B6B0480; Thu, 19 Mar 2026 07:28:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 099456B0481; Thu, 19 Mar 2026 07:28:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E90AF6B047E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:28:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0690B99D2
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:28:13 +0000 (UTC)
X-FDA: 84562588866.19.563F99D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id DC3DE80009
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:28:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a1iRZAYB;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773919692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y1j0MCfzGZpTFacEYPci8LVbiS0cQRQJ0gEZSKNRcwI=;
	b=wNaIp/tz1lFdIRumpCtws4DteqM1CA8CW7Ma+A2MvnhlApiVKTW35IN6IVDxpPPw7c4+c/
	cGsGMg4jzYK4PETVyBIXlVqa92JDE86PG2ARdRQbSa4yZQae4NVhcG2/TxGzagkqJYSpRD
	IuNoXhaFnQcOHbW++bSyfA3nNxWANmM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773919692; a=rsa-sha256;
	cv=none;
	b=JbFxZENUHChIzGnAHFeqLHvjm+zXHh2SzEYWtzbdDK1JKSO5/kL/0sYT/yn6yW+nyh9l0n
	oOAkeavP47B1yziE7eJKawAXMDXs+pDSmrKaI6U/5cpjbAwSw7+vzWxUmBaA8L5YmfJjzO
	8qIBiP5PMAaPCWInOA2FFRw47GY3Jcg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a1iRZAYB;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E6586400F6;
	Thu, 19 Mar 2026 11:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACAAC2BC87;
	Thu, 19 Mar 2026 11:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773919690;
	bh=gwKupKmJtMf2w3Ic//RR17rxaIVEZO5ItMIA7WhbaNM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a1iRZAYB6x0ucTX78RhUqm62uLVRv5+4vHiZcFiG65MeIqmybZV8Dx/nbVc0FSnLs
	 ajCH5ntleS1TeTexmZwYy9YUHsD+1ZrmNOsuiFCeThdAig9S2EjbPfvn9iI+0PR4wu
	 Z1MdM4E/pIzmkMPRRry855G2cCc3KLTa0m/zGxHR8ImhJVWlQigb5UVXgc3deGuyKc
	 dzqUBnX1kkYcXqUNBjH/V/g25zs5Bp0/GqCGR3DUgpD4Foi96h9M/okNUkxxlgNz3m
	 AksUrHnLE8wywc22+deyPH8CzjjWvPKpMViVxc6ukWBvi9LZxdZXesfW3FJdvNvXUz
	 14dvxco60t68w==
Date: Thu, 19 Mar 2026 11:28:03 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, Liam.Howlett@oracle.com, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	kvm@vger.kernel.org, open <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] mm: change to return bool for
 ptep_test_and_clear_young()
Message-ID: <1e664c93-603a-4c16-94f4-595a90744980@lucifer.local>
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
 <3fa94c3c89fd93fe22c8cb59967f064787d686aa.1773890510.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fa94c3c89fd93fe22c8cb59967f064787d686aa.1773890510.git.baolin.wang@linux.alibaba.com>
X-Rspam-User: 
X-Stat-Signature: 5rub1ph9r39tzg5znf4sayumgtfyp8rn
X-Rspamd-Queue-Id: DC3DE80009
X-Rspamd-Server: rspam03
X-HE-Tag: 1773919691-970217
X-HE-Meta: U2FsdGVkX19RqFCBLIPDgF4NWeP2+7tiTrckFb6+7Z9U15EQnaf0ydiKLlO06mxOKnROS+r6tVnVJpTIYul9ISWImUqOGIKmpsgSCiCWO8NPbVsE2PKFpXb3s93KjtAd5rgYxeJtKAghA8YKnJoaL8vufo6bkhNzx0yganabgFZXejwWlVTHkyA5E2FGROP7yxeB6U9GUAx1QNKoQ4Ht32QquQvB1bQbwSP9MATzZAGpKe6nJeurME/mefu/OhEfx1Cug8Dc3v9vr+8jcRMdrdEbzEP6ZghBwpcsrZ/L3Ldt8j+Elbi2q4N5awcVhRAN2woiJYRKXIbsiF7D0SQD3CrhlMo2LpmyiBtpF9byNo9D1JYgbSv7wqT+86NPqtp5uCkPlp6DtMmqK4NxpiTTqHRZEco8SBFWffzq7SDH80y2tneHxzGFQdP5OfuTTT+RYpphWF7MrHzMPDoFAFWmYqkWudcZR5mu4Pz0kxrejWqW5uk6+17bskn0aKNlnh42/Yncnd3+Vjj32/1M+/OaDhUVYsm90Z6NocPef8jfSjyGj8yoWTiFZhdGYkpgHwpKk7wpxscDP/EdlI3k7xNfe37Xfd966IPjN7r9FKUfEpFlTifAOj/lyRSrRrldM3zGgTHSSNfPmDU2UtMF7U7FE6JpGwHvxYbr1GBn5N2fE4M3LjeHzt8H5HOHLf86z0ozZ94ljowAr+uysgdWdHiJtzgmZLbS8HdpuaMk8Vin6G8Y4tjXLyzU8nEfOV+MlJb+TZuDW7a5nWEoPlQqvpO7VqhR6AOBHKI/XzNs5HogEJFVm8SRQnVhFJ3Y9NMcDK+k04uUJgCVy+V8cTC3Nw9j/0PPkmbBFQfuE00j9LbdW9/zcyK7D+pGClFPEIdkbUr40xxV/b3EUptjYzxRFrN5o7rCfvP0nY1/kzsufNQqcq7IPGIbQfGtVarnxPPAT44I8Yg1S9Av50emQ9m01W+
 1YGFHVJ0
 SbKN+LSuzhKGCPFf6H+iRQ+XA4QDxN7VXFyY4GDmRBqdSDC5PyH4ZsL2OwNLkhQNOQmir2OseNNoM3BR4mukCy/7kImS0eR4KOAANExVBA7HcV3ZW5/u+2bfIBhEEJYloEbbs0+pFZDqfR1lTuoPKeHaGTKNYILkdH1SofPmM3c7pjF5UJAKfBOpg9bgYUZ8ZKnPYIDfQTMHaAdkuB0B722i008lJgx7Cg92Y7EFJFcoU6JnK6HeXoYOp2y3edh70c5qKOmQzFXW1dElC/G9eSHVNqMJzCoMkCK6Gw56Jdm1Iiq6mk7FRcURZkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 11:24:00AM +0800, Baolin Wang wrote:
> Callers use ptep_test_and_clear_young() to clear the young flag and check
> whether it was set. Change the return type to bool to make the intention
> clearer.
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Couple nits about dropping externs below but otherwise LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  arch/arm64/include/asm/pgtable.h             |  8 ++++----
>  arch/arm64/mm/contpte.c                      |  4 ++--
>  arch/microblaze/include/asm/pgtable.h        |  2 +-
>  arch/parisc/include/asm/pgtable.h            |  6 +++---
>  arch/powerpc/include/asm/book3s/32/pgtable.h |  4 ++--
>  arch/powerpc/include/asm/book3s/64/pgtable.h |  6 +++---
>  arch/powerpc/include/asm/nohash/pgtable.h    |  4 ++--
>  arch/riscv/include/asm/pgtable.h             |  4 ++--
>  arch/riscv/mm/pgtable.c                      |  8 ++++----
>  arch/s390/include/asm/pgtable.h              |  4 ++--
>  arch/x86/include/asm/pgtable.h               |  4 ++--
>  arch/x86/mm/pgtable.c                        |  6 +++---
>  arch/xtensa/include/asm/pgtable.h            |  6 +++---
>  include/linux/pgtable.h                      | 16 ++++++++--------
>  14 files changed, 41 insertions(+), 41 deletions(-)
>
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index ab451d20e4c5..8c651695204c 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1282,7 +1282,7 @@ static inline void __pte_clear(struct mm_struct *mm,
>  	__set_pte(ptep, __pte(0));
>  }
>
> -static inline int __ptep_test_and_clear_young(struct vm_area_struct *vma,
> +static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
>  					      unsigned long address,
>  					      pte_t *ptep)
>  {
> @@ -1646,7 +1646,7 @@ extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
>  extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>  				unsigned long addr, pte_t *ptep,
>  				unsigned int nr, int full);
> -int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
> +bool contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
>  				unsigned long addr, pte_t *ptep, unsigned int nr);
>  int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
>  				unsigned long addr, pte_t *ptep, unsigned int nr);
> @@ -1813,7 +1813,7 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
>  }
>
>  #define test_and_clear_young_ptes test_and_clear_young_ptes
> -static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
> +static inline bool test_and_clear_young_ptes(struct vm_area_struct *vma,
>  					    unsigned long addr, pte_t *ptep,
>  					    unsigned int nr)
>  {
> @@ -1824,7 +1824,7 @@ static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
>  }
>
>  #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
> -static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
> +static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
>  				unsigned long addr, pte_t *ptep)
>  {
>  	return test_and_clear_young_ptes(vma, addr, ptep, 1);
> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
> index 1519d090d5ea..0b88278927a4 100644
> --- a/arch/arm64/mm/contpte.c
> +++ b/arch/arm64/mm/contpte.c
> @@ -508,7 +508,7 @@ pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>  }
>  EXPORT_SYMBOL_GPL(contpte_get_and_clear_full_ptes);
>
> -int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
> +bool contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
>  					unsigned long addr, pte_t *ptep,
>  					unsigned int nr)
>  {
> @@ -525,7 +525,7 @@ int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
>  	 */
>
>  	unsigned long end = addr + nr * PAGE_SIZE;
> -	int young = 0;
> +	bool young = false;
>
>  	ptep = contpte_align_addr_ptep(&addr, &end, ptep, nr);
>  	for (; addr != end; ptep++, addr += PAGE_SIZE)
> diff --git a/arch/microblaze/include/asm/pgtable.h b/arch/microblaze/include/asm/pgtable.h
> index ea72291de553..7678c040a2fd 100644
> --- a/arch/microblaze/include/asm/pgtable.h
> +++ b/arch/microblaze/include/asm/pgtable.h
> @@ -318,7 +318,7 @@ static inline void set_pte(pte_t *ptep, pte_t pte)
>
>  #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
>  struct vm_area_struct;
> -static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
> +static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
>  		unsigned long address, pte_t *ptep)
>  {
>  	return (pte_update(ptep, _PAGE_ACCESSED, 0) & _PAGE_ACCESSED) != 0;
> diff --git a/arch/parisc/include/asm/pgtable.h b/arch/parisc/include/asm/pgtable.h
> index f6fb99cb94d9..d5e39f2eb415 100644
> --- a/arch/parisc/include/asm/pgtable.h
> +++ b/arch/parisc/include/asm/pgtable.h
> @@ -438,16 +438,16 @@ static inline pte_t ptep_get(pte_t *ptep)
>  }
>  #define ptep_get ptep_get
>
> -static inline int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
> +static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
>  {
>  	pte_t pte;
>
>  	pte = ptep_get(ptep);
>  	if (!pte_young(pte)) {
> -		return 0;
> +		return false;
>  	}
>  	set_pte_at(vma->vm_mm, addr, ptep, pte_mkold(pte));
> -	return 1;
> +	return true;
>  }
>
>  int ptep_clear_flush_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep);
> diff --git a/arch/powerpc/include/asm/book3s/32/pgtable.h b/arch/powerpc/include/asm/book3s/32/pgtable.h
> index 001e28f9eabc..2a889e2093e8 100644
> --- a/arch/powerpc/include/asm/book3s/32/pgtable.h
> +++ b/arch/powerpc/include/asm/book3s/32/pgtable.h
> @@ -295,8 +295,8 @@ static inline pte_basic_t pte_update(struct mm_struct *mm, unsigned long addr, p
>   * for our hash-based implementation, we fix that up here.
>   */
>  #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
> -static inline int __ptep_test_and_clear_young(struct mm_struct *mm,
> -					      unsigned long addr, pte_t *ptep)
> +static inline bool __ptep_test_and_clear_young(struct mm_struct *mm,
> +					       unsigned long addr, pte_t *ptep)
>  {
>  	unsigned long old;
>  	old = pte_update(mm, addr, ptep, _PAGE_ACCESSED, 0, 0);
> diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
> index 1a91762b455d..25e3a86943e2 100644
> --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
> +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
> @@ -349,13 +349,13 @@ static inline unsigned long pte_update(struct mm_struct *mm, unsigned long addr,
>   * For radix: H_PAGE_HASHPTE should be zero. Hence we can use the same
>   * function for both hash and radix.
>   */
> -static inline int __ptep_test_and_clear_young(struct mm_struct *mm,
> -					      unsigned long addr, pte_t *ptep)
> +static inline bool __ptep_test_and_clear_young(struct mm_struct *mm,
> +					       unsigned long addr, pte_t *ptep)
>  {
>  	unsigned long old;
>
>  	if ((pte_raw(*ptep) & cpu_to_be64(_PAGE_ACCESSED | H_PAGE_HASHPTE)) == 0)
> -		return 0;
> +		return false;
>  	old = pte_update(mm, addr, ptep, _PAGE_ACCESSED, 0, 0);
>  	return (old & _PAGE_ACCESSED) != 0;
>  }
> diff --git a/arch/powerpc/include/asm/nohash/pgtable.h b/arch/powerpc/include/asm/nohash/pgtable.h
> index e6da5eaccff6..43cf52f0c7d6 100644
> --- a/arch/powerpc/include/asm/nohash/pgtable.h
> +++ b/arch/powerpc/include/asm/nohash/pgtable.h
> @@ -101,8 +101,8 @@ static inline pte_basic_t pte_update(struct mm_struct *mm, unsigned long addr, p
>  }
>  #endif
>
> -static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
> -					    unsigned long addr, pte_t *ptep)
> +static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
> +					     unsigned long addr, pte_t *ptep)
>  {
>  	unsigned long old;
>
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index ab4ce1cc9d9c..fb010dcdf343 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -659,8 +659,8 @@ static inline void pte_clear(struct mm_struct *mm,
>  extern int ptep_set_access_flags(struct vm_area_struct *vma, unsigned long address,
>  				 pte_t *ptep, pte_t entry, int dirty);
>  #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG	/* defined in mm/pgtable.c */
> -extern int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long address,
> -				     pte_t *ptep);
> +extern bool ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long address,
> +				      pte_t *ptep);

Let's drop the extern.

>
>  #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
>  static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
> diff --git a/arch/riscv/mm/pgtable.c b/arch/riscv/mm/pgtable.c
> index b1ed2f14dc3a..de24a19e8ebd 100644
> --- a/arch/riscv/mm/pgtable.c
> +++ b/arch/riscv/mm/pgtable.c
> @@ -29,12 +29,12 @@ int ptep_set_access_flags(struct vm_area_struct *vma,
>  	return true;
>  }
>
> -int ptep_test_and_clear_young(struct vm_area_struct *vma,
> -			      unsigned long address,
> -			      pte_t *ptep)
> +bool ptep_test_and_clear_young(struct vm_area_struct *vma,
> +			       unsigned long address,
> +			       pte_t *ptep)
>  {
>  	if (!pte_young(ptep_get(ptep)))
> -		return 0;
> +		return false;
>  	return test_and_clear_bit(_PAGE_ACCESSED_OFFSET, &pte_val(*ptep));
>  }
>  EXPORT_SYMBOL_GPL(ptep_test_and_clear_young);
> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
> index 1c3c3be93be9..da1a7a31fa22 100644
> --- a/arch/s390/include/asm/pgtable.h
> +++ b/arch/s390/include/asm/pgtable.h
> @@ -1164,8 +1164,8 @@ pte_t ptep_xchg_direct(struct mm_struct *, unsigned long, pte_t *, pte_t);
>  pte_t ptep_xchg_lazy(struct mm_struct *, unsigned long, pte_t *, pte_t);
>
>  #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
> -static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
> -					    unsigned long addr, pte_t *ptep)
> +static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
> +					     unsigned long addr, pte_t *ptep)
>  {
>  	pte_t pte = *ptep;
>
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index 54289f4587a4..563a6289ea44 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -1232,8 +1232,8 @@ extern int ptep_set_access_flags(struct vm_area_struct *vma,
>  				 pte_t entry, int dirty);
>
>  #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
> -extern int ptep_test_and_clear_young(struct vm_area_struct *vma,
> -				     unsigned long addr, pte_t *ptep);
> +extern bool ptep_test_and_clear_young(struct vm_area_struct *vma,
> +				      unsigned long addr, pte_t *ptep);

Let's drop the extern.

>
>  #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
>  extern int ptep_clear_flush_young(struct vm_area_struct *vma,
> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> index 2e5ecfdce73c..c594976afc5c 100644
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -443,10 +443,10 @@ int pudp_set_access_flags(struct vm_area_struct *vma, unsigned long address,
>  }
>  #endif
>
> -int ptep_test_and_clear_young(struct vm_area_struct *vma,
> -			      unsigned long addr, pte_t *ptep)
> +bool ptep_test_and_clear_young(struct vm_area_struct *vma,
> +			       unsigned long addr, pte_t *ptep)
>  {
> -	int ret = 0;
> +	bool ret = false;
>
>  	if (pte_young(*ptep))
>  		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,
> diff --git a/arch/xtensa/include/asm/pgtable.h b/arch/xtensa/include/asm/pgtable.h
> index 61f07d981a94..b962ef4652f5 100644
> --- a/arch/xtensa/include/asm/pgtable.h
> +++ b/arch/xtensa/include/asm/pgtable.h
> @@ -304,15 +304,15 @@ set_pmd(pmd_t *pmdp, pmd_t pmdval)
>
>  struct vm_area_struct;
>
> -static inline int
> +static inline bool
>  ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr,
>  			  pte_t *ptep)
>  {
>  	pte_t pte = *ptep;
>  	if (!pte_young(pte))
> -		return 0;
> +		return false;
>  	update_pte(ptep, pte_mkold(pte));
> -	return 1;
> +	return true;
>  }
>
>  static inline pte_t
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 17d961c612fc..8e75dc9f7932 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -491,17 +491,17 @@ static inline pgd_t pgdp_get(pgd_t *pgdp)
>  #endif
>
>  #ifndef __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
> -static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
> -					    unsigned long address,
> -					    pte_t *ptep)
> +static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
> +		unsigned long address, pte_t *ptep)
>  {
>  	pte_t pte = ptep_get(ptep);
> -	int r = 1;
> +	bool young = true;
> +
>  	if (!pte_young(pte))
> -		r = 0;
> +		young = false;
>  	else
>  		set_pte_at(vma->vm_mm, address, ptep, pte_mkold(pte));
> -	return r;
> +	return young;
>  }
>  #endif
>
> @@ -1123,10 +1123,10 @@ static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
>   *
>   * Returns: whether any PTE was young.
>   */
> -static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
> +static inline bool test_and_clear_young_ptes(struct vm_area_struct *vma,
>  		unsigned long addr, pte_t *ptep, unsigned int nr)
>  {
> -	int young = 0;
> +	bool young = false;
>
>  	for (;;) {
>  		young |= ptep_test_and_clear_young(vma, addr, ptep);
> --
> 2.47.3
>

