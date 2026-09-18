Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E01B7C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 15:55:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A02EC6B0098; Fri, 18 Sep 2026 11:55:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B33A6B0099; Fri, 18 Sep 2026 11:55:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F0E26B009B; Fri, 18 Sep 2026 11:55:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C43C6B0098
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:55:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9EC6EA6184
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:55:15 +0000 (UTC)
X-FDA: 85227332190.09.B9C61DC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id A213720008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:55:13 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Slvyn6V4;
	spf=pass (imf31.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789746913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j466s7jbzClVSsJ+FEvZE7NgG+aTMlJRi85iOwX0jN8=;
	b=1goISE41ml5GORkG9xCUbSXxzSlNaebgvd/2+WDE1T7mi3/IUKSauetD2gH33iBmGaZ3kp
	AMMuYM9UndSr5Okgy5xdXYe9/Bjz2gt8Celd8vz0hvhLeijmixK7tduaTccg0vLZR1eLJK
	4JbVL/3vPJaWJ2k8HgevP/ErUaAJWjs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789746913;
	b=mhV8MK4VSXZeV3eTjQCbRmDGklEyabyVe9mDPpo95S1deOGCGEc+wQpgMCZFJbL4d4J8EC
	4hEVBbFpSz6wviHH7OTF40MlhymtNGrokmHs/8oZ9c5cT2xmM9OPSAWlS4cEU/FsoUNh5P
	NaZi+s+1kxkEX2kYmwI554nrYvhjOrI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Slvyn6V4;
	spf=pass (imf31.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 00D69168F;
	Fri, 18 Sep 2026 08:55:09 -0700 (PDT)
Received: from [10.57.83.108] (unknown [10.57.83.108])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 93FD43F7B4;
	Fri, 18 Sep 2026 08:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789746912; bh=h6rfWJQHWA6AbcMjJ6geNACzDmvpZX6SlmU6TfDDjl4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Slvyn6V4Oo34Au5DOF1kboWsJhCsaV1c3o8YhZGZ1uDZIq6kJGrq06wenZFv5EDFt
	 rc1I3KnVukf8/IyOeNPvQrdNuKb9cmLZVVwgE+SE8jrEkLVZCoxFvYokUmGawc8WSZ
	 yCfWVIgzMcDRelK8r6NIxI4xxV77Jr9WyJ/BldhY=
Message-ID: <f9a7cd29-8aa3-4436-a95e-999c03aad0d7@arm.com>
Date: Fri, 18 Sep 2026 16:55:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] arm64: use hw_pte_val for HW PTE atomics
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
References: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
 <20260914-pte0_arm-v1-2-bb53b663e396@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260914-pte0_arm-v1-2-bb53b663e396@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A213720008
X-Stat-Signature: fdabjz4drqm9bwr9m5j117sde6cimi9n
X-Rspam-User: 
X-HE-Tag: 1789746913-726181
X-HE-Meta: U2FsdGVkX1/mIbZrzu0OKMQmE3eTOAUQJdRUP+B7N1hce1cm6PDU8bdMlsz/S7uFhTKc8AUOWvRVeDm31aZct0SSfLfytof1dX/I7wRMaVhxa6DwXhvywCgFosFJ6UeDkMrmzLYJMpNieWI5Q1Sw26QELVeQh38NqWyuXSsXC/wSC1EqfNUCXPTNlSMWwkJbVVr6MUi/wfDsM7BWC9k31G+74y5UXrVNHivk97fJVb6VaFD/tSPoBxouFO+lqg9+7Uee/oigP7wLRuiMBXAC3ddSODCpRwgObK7OiNcBvEc6YzQDs00fSy6JsHCFyc0HbwMhb5ssEAhVKkGbAm/NSlKNTSMamxU61GEnnqBF7+cQDOGsgfw9rA05pq0OImsg/zv72Q5wnzWby9P0QiJ97aQa8EN6J6n6Ttzi7IT7lVSjK7zRXYVY+l8CkvSN33bkaQfOfo4ZXRLN2pCwFCnew29qxXKJMJZj9VCePauqPbsrc0LLvJRl5BX41BVGgxDKQRvDSgZcy34w7LclK6NWcxjV4/fuL43zDDRnhVaGEcdW7FDQ0RSgZAzj7qtoDScN4J2qlmcp1xO2mqLBWBETJXk2EQfAingeID36TmLIIZrC0jihPnHzKBvlTKxeUGGeIbt9MObZXPt5hBQtLp1KatXuIp2mnby+HhnecZviTLvYb2JHU7GbD9nr2JCfqAXnlJOQMJqsHqxMBIclFCfGmCd+WPAfdHUw88McGyJWzAWMJwnqTEiCqaN50RWeRPA5qNA0Q3jVvp/zyjrvUoo/7GM76b39PZWHSQJ3fv6iU4ek9q3+k6TOgkFbN0Wq/VhqXGpKDmIlqFhgsls1Lr3T6hpVpKH8S5gvKy5tmotijxpczoFX9PyYspwqf+R/7nRFpb1pPMYzBsgQACMI4FrbJ3qBUygQqZoWV41DFgBeKAvhVA1ywCr5VgcdkwLvPvguXZhE9cLqxd8mprgIJU8
 QyiIO6fH
 gc5908GmDtN9rSxkCSSeblOrlksycTINgj+0EOp+8o20HGN6cFM78ITvw9dCuveX0KaR2kaX0ZnXVe1Qdgbk4KMwtvnxgMFOeRHcvrgny8pMS+d05neCNOqvEE8voLH6cZGarIj6/cNR33obrmHKTW9pwALJqmgg0C4y84sRjsfKICsMYdW+hHGvaowb4ULc+Fy/rwutvDkbAAX+pAeDaNad5WHBix8kgEUA62HsyHK8U3sWki5+2CKu56WWQRHl88cMmVxmCW8Pd7tPBKESMmNI8vDRu+o5RN6OWZdxQjwUncJZnp3q5/OS19BfZAra4lnn9ANwn/KF0MlOC+sM33uIk2vgxoo8/Io5pNl3nb0MEzvXZiOWQDrZnt1eILevW5UmfLXy8sZSOToiNJIB7FFC63t12OWqgQO+5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14/09/2026 14:51, Muhammad Usama Anjum wrote:
> Add hw_pte_val() to preserve an lvalue for the HW PTE bits, so atomic
> updates can take their address. pte_val() expects a SW PTE value and
> cannot operate directly on a distinct hw_pte_t.
> 
> With ARCH_HAS_HW_PTE_T, use pte_val() on the wrapper's __pte member;
> otherwise, use pte_val() directly.
> 
> The atomic operations and their ordering are unchanged.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
>  arch/arm64/include/asm/pgtable.h | 10 +++++-----
>  arch/arm64/mm/fault.c            |  6 +++---
>  include/linux/pgtable_types.h    |  4 ++++
>  3 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 652ce413be389..4768ec59de555 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1303,7 +1303,7 @@ static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
>  	do {
>  		old_pte = pte;
>  		pte = pte_mkold(pte);
> -		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
> +		pte_val(pte) = cmpxchg_relaxed(&hw_pte_val(*ptep),
>  					       pte_val(old_pte), pte_val(pte));
>  	} while (pte_val(pte) != pte_val(old_pte));
>  
> @@ -1346,7 +1346,7 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
>  					       hw_pte_t *ptep,
>  					       unsigned long pgsize)
>  {
> -	pte_t pte = __pte(xchg_relaxed(&pte_val(*ptep), 0));
> +	pte_t pte = __pte(xchg_relaxed(&hw_pte_val(*ptep), 0));
>  
>  	switch (pgsize) {
>  	case PAGE_SIZE:
> @@ -1422,7 +1422,7 @@ static inline void ___ptep_set_wrprotect(struct mm_struct *mm,
>  	do {
>  		old_pte = pte;
>  		pte = pte_wrprotect(pte);
> -		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
> +		pte_val(pte) = cmpxchg_relaxed(&hw_pte_val(*ptep),
>  					       pte_val(old_pte), pte_val(pte));
>  	} while (pte_val(pte) != pte_val(old_pte));
>  }
> @@ -1460,7 +1460,7 @@ static inline void __clear_young_dirty_pte(struct vm_area_struct *vma,
>  		if (flags & CYDP_CLEAR_DIRTY)
>  			pte = pte_mkclean(pte);
>  
> -		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
> +		pte_val(pte) = cmpxchg_relaxed(&hw_pte_val(*ptep),
>  					       pte_val(old_pte), pte_val(pte));
>  	} while (pte_val(pte) != pte_val(old_pte));
>  }
> @@ -1830,7 +1830,7 @@ static inline bool ptep_try_set(hw_pte_t *ptep, pte_t new_pte)
>  {
>  	pteval_t old = 0;
>  
> -	if (!try_cmpxchg(&pte_val(*ptep), &old, pte_val(new_pte)))
> +	if (!try_cmpxchg(&hw_pte_val(*ptep), &old, pte_val(new_pte)))
>  		return false;
>  
>  	/*
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index b77f4be88e3ea..7d6c30f27214e 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -225,8 +225,8 @@ int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
>  	/*
>  	 * Setting the flags must be done atomically to avoid racing with the
>  	 * hardware update of the access/dirty state. The PTE_RDONLY bit must
> -	 * be set to the most permissive (lowest value) of *ptep and entry
> -	 * (calculated as: a & b == ~(~a | ~b)).
> +	 * be set to the most permissive (lowest value) of the current PTE and
> +	 * entry (calculated as: a & b == ~(~a | ~b)).

This seems like an unrelated and unecessary comment change?

>  	 */
>  	pte_val(entry) ^= PTE_RDONLY;
>  	pteval = pte_val(pte);
> @@ -235,7 +235,7 @@ int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
>  		pteval ^= PTE_RDONLY;
>  		pteval |= pte_val(entry);
>  		pteval ^= PTE_RDONLY;
> -		pteval = cmpxchg_relaxed(&pte_val(*ptep), old_pteval, pteval);
> +		pteval = cmpxchg_relaxed(&hw_pte_val(*ptep), old_pteval, pteval);
>  	} while (pteval != old_pteval);
>  
>  	/*
> diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
> index d6c5a7548550b..ee4eace5c3e1c 100644
> --- a/include/linux/pgtable_types.h
> +++ b/include/linux/pgtable_types.h
> @@ -9,9 +9,13 @@
>  #ifdef CONFIG_ARCH_HAS_HW_PTE_T
>  typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
>  #define __pte_from_hw(pte)	((pte).__pte)
> +

nit: why the newline here (and equivalent below)?

> +#define hw_pte_val(x)  pte_val((x).__pte)

Wouldn't it be better to add these as part of the generic series? I know we
prefer to add an api along with its first user, but in this case it seems odd,
because you're effectively requiring that arm64 is the first merged arch to
support this? You could also use the same argument to say that none of this
should be merged until the commit where an arch turns on ARCH_HAS_HW_PTE_T.

Thanks,
Ryan


>  #else
>  #define hw_pte_t pte_t
>  #define __pte_from_hw(pte)	(pte)
> +
> +#define hw_pte_val(x)  pte_val(x)
>  #endif
>  
>  #endif /* !__ASSEMBLY__ */
> 


