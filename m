Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F2ACC98317
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 12:21:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F3B86B008A; Thu, 24 Sep 2026 08:21:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97D866B008C; Thu, 24 Sep 2026 08:21:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86C0B6B0092; Thu, 24 Sep 2026 08:21:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E19E6B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:21:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E7C0C1C2698
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:21:38 +0000 (UTC)
X-FDA: 85248566676.14.446A145
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id EA3D340005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:21:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RCb6mJCl;
	spf=pass (imf01.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790252497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5xePOy1AI/uAmoNLk2pom3JdMozQVH6qVeKB1dqEvS8=;
	b=fx5vgqPHHFlcb3q55QxUxAfV6SKNpRz3MfaDPF761DZWuovhjk7+InptdVoHyCWVbUhKhX
	tNCF2H7Bf8trZlh52XrBdcd6JBPsR78AERT6jhjQilwuVvO9bGRU8M2x7YW2LbfpnQSCqd
	crZ7YUTAR/xBpfyFbvVaqjEedhpBFwQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RCb6mJCl;
	spf=pass (imf01.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790252497;
	b=4T4EfYwJ7oyZthNykvH/XVeCWkWvHnnqSZtf3CpV1YGXuX0pkYyCdrkrIOLRWV22WU7kzT
	e20d+fzQdwGyLTPPYKz88ONMqWxz/1psJ7ugxj/C8jH/6fl3/uVS5WKJQaDLs2XpwGhXYA
	04CT+BuC8sUfcWPbu/Nhqe9iTtK911w=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8687A152B;
	Thu, 24 Sep 2026 05:21:32 -0700 (PDT)
Received: from [10.57.83.110] (unknown [10.57.83.110])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ABA9B3F86C;
	Thu, 24 Sep 2026 05:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790252496; bh=rTdcO7n0+nshxu9CDu/EDryDUt+kuTOvFiqhnTEqJCg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RCb6mJClIL5UcTql5vFcsex7DxOdojrWEOrsuD+03U/8LnEkoU4WGd4NklebN4L/q
	 i8SAcsH8Z8iDp7GOdFsb2I3V0awYWc2PApLoDAD0UXrSVigZDqp90z2XYQLFkm59o6
	 Z+aW0c6kZeCZ6al02l/F0iQ5og5z9BpTFQcoNTnk=
Message-ID: <7a600128-bf10-4966-8c08-129eeec3fb91@arm.com>
Date: Thu, 24 Sep 2026 13:21:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] arm64: use hw_pte_val for HW PTE atomics
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
References: <20260922-pte0_arm-v2-0-a3f1ddff0a8a@arm.com>
 <20260922-pte0_arm-v2-2-a3f1ddff0a8a@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260922-pte0_arm-v2-2-a3f1ddff0a8a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EA3D340005
X-Stat-Signature: 5shq55ewymz63xu9rkrbharsjf4hcgn8
X-Rspam-User: 
X-HE-Tag: 1790252496-486143
X-HE-Meta: U2FsdGVkX1/ssIKq57tBqyUmJ3rVv8kTL05QZaSsgwufGmYqATMFsMlfff6YZkdMH4TMzTbVlufrZBhKyfIiaLLqkKDcK8/immyfpxXIDmfYRQXxhdmYPO+FPg9dN+vLjoWjyc8JVr/U1Ilbx+UNSfrIuwbFVwRoo5N5vQXSYU8Qm3CqiSMySyNXS4DFayyJapKpZW3lXrmBg4N9ewaiZWEylNdfZqBF4m+BBJRgOVdTYJW5mlZsbpSmaVmhQyNHrMbWPMaKFp/gvOwZkksvX3vLKmfzZXbuPvK5r28LI208+KN1T9VJsbA/c8eMYd4ig3rBg8evLS+tY3bYxwUVz808ANhcywGGcFlW2lwNguGaJ6jKSZdkNhdoinp+2ZrmBoIp3QWDTQmYh8qaUvPx6NDtFXY+JCBmLbEoXLPK9goqz9aNnNpOPFfj+raaruIi9r93F4GTLP2KWyLtBZJiEPOdo/h2EksGlxuG3gsDMzLb/iS13axQnIVI21M7gYpZUjLlVLS+klU+SRRd2peGSKT5UumsGRCYHUH9xOiM5csDyGkJ5WT4HG+ad+nYmNhFKtqGuUHmzup6K/czbxuoc3y0tHMgefW6e206LqwraNFF/lBg3DPNARBJswRUIIQrVWHi5bA7E+jmPJGCYKmCcSKB3JOSsobOToI7xiVN7RN25Q8uhFofo2Vvk7B4+27XWQJIRyefatZK2vlb8To2wxdUZ+dq+nY25cgUhjasVXv5C05JWOdcxTanWEDw5ykWJbZubP+CgIN3tTTJ09V7UQUCoVU+q/4gNZBecmgnH9zXr/CjguzL5QfJaej4+UoVU1Jc7t2ZZ9cR9CkWwHzDMSrr4mYt31U44o9Q0IVRMRY/cvhQnORJJ7qVkC0GhzU9s7hzKLuXXXVeViSt4mnDh0VVhzyJDLBKcrISas+Mc+JqQKmoOowocUSMac9ji9SJftOtw+hDIdHEkGL7yxT
 nJpDG0NA
 q5UpESE81V/iaX928TE8oV2dADfV5oWEgg0lFGKczESooPICzTb7R6EbGRsBcYgLwUA0tyWKz4nQF8bvmXVWmvnghj7uZZT/69aWHbwguOLBLIaPwPHLhCvqWXa2KTbIw9jy47HVPmNOCqluidR8G9hsLpntwEfUAhhJHjDtlTIr6c35gxHIRaeP+Am09ynrZN42+XUqUbueaheyJfhRD84vXOJFHoMCYj1mDu27vQxM2ID/1x6/NgJllN8oDGAOrZlCvayLoe7hfDvcCHeaaCdMgE/jP4ispJGmRYYRe9jJAL2q391UlXNMjiiauL7VTPp6j94iaTVobNdTDpj7HlDm2+/w37kxeYs76wJZMldKsmSubpyhvQK0ZQZQBS9+cy+0OMUv/S5Lz0AEyA/xfFMfs0kjfxvW5v/ax
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/09/2026 18:31, Muhammad Usama Anjum wrote:
> The low-level atomic PTE update paths take the address of
> pte_val(*ptep). That assumes HW PTE storage can be passed directly to
> the SW PTE value accessor and no longer type-checks when hw_pte_t is
> distinct.
> 
> Use hw_pte_val() for the lvalues passed to compare-exchange and exchange
> operations. The atomic operations and their ordering are unchanged.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
> Chagnes in v2:
> - Remove comment change
> - Move hw_pte_val() to generic series
> ---
>  arch/arm64/include/asm/pgtable.h | 10 +++++-----
>  arch/arm64/mm/fault.c            |  2 +-
>  2 files changed, 6 insertions(+), 6 deletions(-)
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
> index b77f4be88e3ea..3322f4e7174dc 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -235,7 +235,7 @@ int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
>  		pteval ^= PTE_RDONLY;
>  		pteval |= pte_val(entry);
>  		pteval ^= PTE_RDONLY;
> -		pteval = cmpxchg_relaxed(&pte_val(*ptep), old_pteval, pteval);
> +		pteval = cmpxchg_relaxed(&hw_pte_val(*ptep), old_pteval, pteval);
>  	} while (pteval != old_pteval);
>  
>  	/*
> 


