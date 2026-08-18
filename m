Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0797CC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:10:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1036B027C; Tue, 18 Aug 2026 10:10:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C88B6B027D; Tue, 18 Aug 2026 10:10:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F23CD6B03B9; Tue, 18 Aug 2026 10:10:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D5EC46B027C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:10:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6FE8B12029E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:10:44 +0000 (UTC)
X-FDA: 85114576008.06.B7712DF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 654F820009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:10:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=t5Eewfnf;
	spf=pass (imf13.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062242;
	b=OFOEIDzE92P4maOjNDTp8qV/ip3zfyK0pwjD69/kjavsxMja9o2SCVdUsatuTUycSW+KUj
	CQbZGOLynme/pU3eXDna1M+PdatGaagtcmN04PbPpQrRNm+PXEw5/G2NBEeRGtZh9x1V4H
	mjIgcmG3hog60EbUW6WI0iV8nC5s3Dk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=t5Eewfnf;
	spf=pass (imf13.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l03Q5ptSYhWuGPtHN3uRfvI7ji1htrQDlyLsSY8uXvw=;
	b=e5VS/vpEd7iFI0m9huc5Mcm6CInEZ98W170JPX/aX4VZRByBB3St4xz601L0J8lwGUi7hy
	jD1m0VInHb6uVAHphxFeYhU87HjkjMjUmPtJ+6HEUZZQvL/+3JMq5T5QsD5n/VV4093H9C
	Nz+wQvFPztjCe/lpUmzIw2iq1SK4rHg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 93860152B;
	Tue, 18 Aug 2026 07:10:37 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6DB1A3F85F;
	Tue, 18 Aug 2026 07:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062241; bh=ViG9p523Gtj965obqgoqvstIweJ3Dnp0nqQZuKx6Weo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t5EewfnfFIPzdq/m5PX24TI4FOzPov6Iap7L97itk/zFF2JCkMgIjuBE6my9umw9P
	 tFtho4uCZpiIO+IPA9jO61MjT2OuD6svwQBMCmxLRn+dHYIAz6+6ydfZvkZsFQTtnN
	 DMrNb1prYHYEqMTQiMrKfD8+D5z9qlbLSjIWJKDU=
Date: Tue, 18 Aug 2026 15:10:36 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: James Houghton <jthoughton@google.com>
Cc: Will Deacon <will@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Linu Cherian <linu.cherian@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>,
	Frank van der Linden <fvdl@google.com>,
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 08/18] arm64: Implement try_update_vmemmap_pte using the
 AF trick
Message-ID: <aoRn3Fn1dhTdsk6d@arm.com>
References: <20260708031129.3503195-1-jthoughton@google.com>
 <20260708031129.3503195-9-jthoughton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708031129.3503195-9-jthoughton@google.com>
X-Rspamd-Queue-Id: 654F820009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: qckh8po9ee5ye9gf9hnixx6dramy4q7d
X-HE-Tag: 1787062242-234741
X-HE-Meta: U2FsdGVkX1/oKEKFjPe5xjLsZvcyaR8OvcCLBmz8gnBYADCEPTy5/EOB58kM++6h/IJXST4twDPr3MllW2FFI33rSZKev7meHItgDjclBpbxX1x1mUI6xKMCE9cbj2vjRnfLWgdcSz4DY5K38k9VlDI3wndWkwn2G5hr1EmqXd3+Xnk3QS7EGrlCFIlzplQC3eT8KEO1Es5ydCKJNW3WagPjeHHbeM3uMWGh0se+OfytRtsOWDEfXtH20UoINz7JWKqG9jmUw92NJrAb//UsRj4XGBbfZPvOwRw/bCHzMwFa7iqNBEY9H0CQSSFGqFDiC40S7n+86/GRXjj7+aL4k//m86SeRv0vKuuEXudRmFEdyTY+UHifdlTSMK+kFr8JUYKU2hAF9iFKm7KtpjqZr8pCoAM5TfuVD6zGhpGt39D1weloovdTRaaNQeM8XEbhPVBHe6VxyMPnTDlk0sLBBsQCimGkYtyW/+tyCqDn96hBwgJEkv6gHX2mCn1S39ioxlL0m4u/rs8VdK3823iKKrccAjok5FcoWs39BAuQmwC/6gHCBKKMz26slWvf1asK07y4dwXF0RY4oO9aT+uAQg+2UZSlOQf0MD2cuki9cxI+/q5cKxbgY29AcY/k7iutd8KJMSyZ4moRRKmFGaxXTTAoCnQ9C9V9NB7i4GOC0Ejo6sx980ROsfeeeRxVpvm5TCFZZdaJbwRn7Qiqx4OgRwUiY80Am+MUkaizNPi782RUcyeylf5Bi6ffxEbC8AgRlZNgrKJLDUDvhXhaGAb28OYtdq0FrL1xH6Fk660EDM0oxX+iZGoVjoDoLMkvy5NsMSxo4/Zsvtg9kwq37kjOp+oH3e6VyOr8IxFgWYJI7yUHlTE1CgoX4PleqjpyG/SOfTqZI4EtRWsyT9gc2qtIgueZSrNKM+qySDJAuGTV9xJTiLtaL65Lf22FMw2F7Xydxy6BDfkyAeKkaDE1sdB
 Eux8YuvT
 gLmji7plOw7VIU3IZHkND4U0r9LlFY54tYZyoXphSmPJHLJtG9jBU45u0q8sxUgTKSM37FisBTCrjLPzhrjhSUK2/e7ZfXGxNxlcZYdDVykXZRgXurkhJw0RBg3B/2zmRRJUqXacHmEmHmCLmKZYtrEV8D2+CuxzKKZ8U2INoEWL0TaW4IK8TrWtAj4d+ulBed82puHF6QNZssdOWw+xeeOZaHCHiyTTMO8yp1zP+lOVfibLuGCNmHX6MKUL34WeiQic7nsmoo1GbWhoBAcGCw10PkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 03:11:18AM +0000, James Houghton wrote:
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 5f21d3a738ee..7b11aa41d0a0 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1302,8 +1302,7 @@ static inline void __pte_clear(struct mm_struct *mm,
>  	__set_pte(ptep, __pte(0));
>  }
>  
> -static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
> -		unsigned long address, pte_t *ptep)
> +static inline pte_t __ptep_clear_young(pte_t *ptep)
>  {
>  	pte_t old_pte, pte;
>  
> @@ -1315,7 +1314,13 @@ static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
>  					       pte_val(old_pte), pte_val(pte));
>  	} while (pte_val(pte) != pte_val(old_pte));
>  
> -	return pte_young(pte);
> +	return pte;
> +}

At some point, we should use LSE atomics directly here if supported
rather than a CAS loop (well, this is LSE as well if supported but it
doesn't guarantee forward progress of the loop). I reckon we can replace
it with some test_and_clear_bit_relaxed() call.

> +static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
> +		unsigned long address, pte_t *ptep)
> +{
> +	return pte_young(__ptep_clear_young(ptep));
>  }
>  
>  static inline bool __ptep_clear_flush_young(struct vm_area_struct *vma,
> @@ -1793,6 +1798,48 @@ static inline void pte_clear(struct mm_struct *mm,
>  	__pte_clear(mm, addr, ptep);
>  }
>  
> +#define __HAVE_ARCH_TRY_UPDATE_VMEMMAP_PTE
> +static inline int try_update_vmemmap_pte(unsigned long addr, pte_t *ptep,
> +					 const pte_t pte)
> +{
> +	const int max_attempts = 16;
> +	int attempts = 0;
> +	pte_t old_pte;
> +
> +	if (!system_supports_hvo())
> +		return -EOPNOTSUPP;
> +
> +	/* This routine is only to be used for valid-to-valid transitions. */
> +	if (WARN_ON_ONCE(!pte_valid(pte)))
> +		return -EINVAL;
> +
> +	old_pte = __ptep_get(ptep);
> +
> +	do {
> +		if (WARN_ON_ONCE(!pte_valid(old_pte)))
> +			return -EINVAL;
> +
> +		/* We should never get a contiguous PTE here. */
> +		if (WARN_ON_ONCE(pte_valid_cont(old_pte)))
> +			return -EINVAL;
> +
> +		if (pte_young(old_pte)) {
> +			/* __ptep_clear_young() returns the overwritten PTE */
> +			old_pte = pte_mkold(__ptep_clear_young(ptep));
> +
> +			flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
> +		}

I think this is going to do a lot of TLBIs given that the default kernel
prot has PTE_AF. It somewhat defeats the VMEMMAP_REMAP_NO_TLB_FLUSH
flag but I haven't figured exactly how this optimisation works.

If it becomes a problem, we could do a first pass to clear AF as an
optimisation or later via vmemmap_split_pmd(), only map with AF=0. We
still have some page copying that touches the vmemmap, bringing AF back.
Of course, you'd still need the above flush, just wondering whether we
can reduce/coalesce it.

> +	/*
> +	 * Translations without AF cannot be cached, so we can replace
> +	 * them without BBM.
> +	 */
> +	} while (!try_cmpxchg_relaxed(&pte_val(*ptep), &pte_val(old_pte),
> +				      pte_val(pte)) &&
> +		 ++attempts < max_attempts);
> +
> +	return attempts == max_attempts ? -EAGAIN : 0;
> +}

Here, indeed, we do need this bounded, otherwise some pathological cases
may set the AF continuously.

-- 
Catalin

