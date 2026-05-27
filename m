Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F22CCD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:11:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DF036B00EC; Wed, 27 May 2026 10:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B6E56B00EE; Wed, 27 May 2026 10:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CC8F6B00EF; Wed, 27 May 2026 10:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 793D26B00EC
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:11:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1BEE2C1F8F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:11:25 +0000 (UTC)
X-FDA: 84813387330.19.B12D6E5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2D27E14001B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:11:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AmDfBmlK;
	spf=pass (imf09.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779891083; a=rsa-sha256;
	cv=none;
	b=AD93HNT94qB7Tt9wVMhoJkDV+cWjrvb7RXoUcj+mPFMNVB5eg2ux/hdcQyYoEXpdEyig7/
	PuHz10naKfQJ04HlI2I67eKFHDuGBoUL+G2VaBI0bf7WjunlLrKh/XHbYeYsMCnVD453Lm
	4bOEQKeTjDxkD/OPD7plKR+U8TXm4i8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AmDfBmlK;
	spf=pass (imf09.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779891083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RZK1e6tGSqx3SOkpVhgOzNyRjcTO65ITv7rQ73O29Fo=;
	b=a5v+2k0u5uhiVaxBStm/Cbj7aA3gIou4vzzOOXiXEXz+61sR8mP14rpSA5nKiZ3LjZVARh
	a4A9s1OfwvdCAX5OP9TI+iqSHgFriJ+AkFPl9HSwJe1rx8F8Cn2kIFzzwZvnKkPW78YHj+
	J4gnRkkRr+CxjySsX7/nWF/xkdXMEF8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0043027DC;
	Wed, 27 May 2026 07:11:17 -0700 (PDT)
Received: from [10.1.36.149] (XHFQ2J9959.cambridge.arm.com [10.1.36.149])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 78AA23F905;
	Wed, 27 May 2026 07:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779891082; bh=EMYKD7dIdvCyC3aowqIV2NFcZLZ0MI2QgKxgRFdYwcA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AmDfBmlKj8HpbsVvbsgw1jbwhZeeWkxSTV7bDMMlg1+bK8fvYnwMsP15d8wko/WWV
	 VOCsPReMRJocbcAJFrEl1EauTUnoE9MZl3UrhBvyh0Jzu284YxDtTleOoXbU9Bh87j
	 17N44GEdiMwH6h8Tklbiu1n+jhO6WyD2SuZV25EE=
Message-ID: <c981c1ba-ab86-4865-b74b-df8d2005507b@arm.com>
Date: Wed, 27 May 2026 15:11:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V2 07/14] arm64/mm: Route all pgtable reads via pxxval_get()
Content-Language: en-GB
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, Usama Arif <usama.arif@linux.dev>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
 <20260513044547.4128549-8-anshuman.khandual@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260513044547.4128549-8-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2D27E14001B
X-Stat-Signature: jzxurgffmuitf16xax13zgj84ra4ft4d
X-HE-Tag: 1779891082-924889
X-HE-Meta: U2FsdGVkX180hghbYqERX+UtlhesJ73aVxeohfANMY5hIrjj9v31YeYwjmrDlk6QT3JQ71HoPIFSm4UXzqc/nORld6ZtUAaSZZM0KyOB7wAqffqojbJHRFITmAAlyaKzANqRU2OxM+sGIW/WWbLITw4dr4/EdGB3yZF21u+uUqsol8sxXkj9wQSjvFb9SgpF6twQJRQEChNyhSH7TxMbgtFb0xWtFjbxVeJmTMMrs5iycBRF8eW3P/v9KVYwbQ0V4wnpFGwg2eO9PP/r+BUWbCcZJVjW0MklsM0PvlqDJgnEqDyr33IwJFl84wCZNZgPhEgylW0+Dbj4Ar4cF2GGnrV2qt5dLJi2esVLnyYjRaI0qbQVBib8OHzLg8/uPxGRFbv4YKu+7ZwIzpfPBUXeWNDrJmbOq9tbjBPJvbEXnK+TGkvAiXmenqVTX7S2MKXeqXHfD5gBC9VuSNNz4o3UPawlkAdalph3ezvYxWHvXoeBBETcfqSOefZ9uB2duvEo/6dYHnJLQLXrPon/KeHssG/FrE/lQSB141Eq2j2GYRw9NWBT5z6vFKEbOB0eXXofIz6Y+pwNdeKR49WgVU14qv8fOh15gnhK9dYP91Mt8siH/IwCpny2fdw9iWcmYI48ICgg6HP1xfwTZ2B9SB3cX1oCtMoAUdD9CQoPnmOGrd6sdvvvKXDVIX6thLpOCv9XFweM5u60qjzKFGFk73i7xURdMJZoGCrik11xK1xV+3Z4wadXNGNwDbTQCO8K8aaVc3i5fUyrazDeIZANKFPIqlZGjtWtSU2n7GNxlLH+zftr65sTKZ5sVhR+bvJiSClg0x9DiO52/KEZ3mznfkFiny/hfaz9iuLo+8Ffwl51er6J2QlgHdiScaKvB1T3VpHWNdemMKt4X4eEKx8Qng6G4r2oe8ITWmVN7cyw4bxiLyA+SZCYl9TPrWJkSJmewZWILsguc31NYSNksHY7L9k
 P8d57XSU
 9PO6rxGIetoKYtiBKu1jOqKcUb65rheOr9sxbacCmnJlx+qvEply/+ORCDUL3SakKTCVLgldSWf4oJzRXabD9B6sb0yiIDhyy4lMb/sLwg6sRDYCiQqaT9L5m/m/UrZ74Sp0hV0NZVEotETVV6ZMlxkp/Vw1dDrczeZksat6/9fd6HtjLNt575ODVzNTNn95EbO2bYkz/WyNpE4I9Bx7bzX9rwM71AFSc9G/XiRlH3ymNNiU0uthpiHc9vC4EbI1IEfY4jD0EuAPiVrteqMCas0FS0xBZabcrQJSSyMWL7EubT/zFnTEA+NqZV50lXsDoE/SUlz9amRvpgvZ2pq+zcfaS/TgtqalRLNCz53cAdtR+rwMh6KXI5CS2yum3p59m3RPrYeyQfxwuCjnbt7gNc+xAgVXsfUtL9zZ48YpzVfniUq8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13/05/2026 05:45, Anshuman Khandual wrote:
> Define arm64 platform specific implementations for new pXdp_get() helpers.
> These resolve into READ_ONCE(), thus ensuring required single copy atomic
> semantics for the page table entry reads.
> 
> In future this infrastructure can be used for D128 to maintain single copy
> atomicity semantics with inline asm blocks.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> Changes in RFC V2:
> 
> - Renamed all ptdesc_ instances as pxxval_ instead
> - Moved arm64 pgtable header READ_ONCE() replacements here in this patch
> 
>  arch/arm64/include/asm/pgtable.h | 38 +++++++++++++++++++++++++++-----
>  1 file changed, 32 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index cefe8ab86acd..72da582e8d12 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -84,6 +84,32 @@ static inline void arch_leave_lazy_mmu_mode(void)
>  	arch_flush_lazy_mmu_mode();
>  }
>  
> +#define pxxval_get(x)		READ_ONCE(x)

I think this would be better as an inline (or __force_inline) function, which
takes a pointer, and dereferences it. READ_ONCE() is special - it's modifying
how the dereference should be done, so it makes sense that the dereference is
done in the caller.

> +
> +#define pmdp_get pmdp_get
> +static inline pmd_t pmdp_get(pmd_t *pmdp)
> +{
> +	return pxxval_get(*pmdp);

This is weird to read. It would be clearer as:

	return pxxval_get(pmdp);

Thanks,
Ryan

> +}
> +
> +#define pudp_get pudp_get
> +static inline pud_t pudp_get(pud_t *pudp)
> +{
> +	return pxxval_get(*pudp);
> +}
> +
> +#define p4dp_get p4dp_get
> +static inline p4d_t p4dp_get(p4d_t *p4dp)
> +{
> +	return pxxval_get(*p4dp);
> +}
> +
> +#define pgdp_get pgdp_get
> +static inline pgd_t pgdp_get(pgd_t *pgdp)
> +{
> +	return pxxval_get(*pgdp);
> +}
> +
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
>  
> @@ -380,7 +406,7 @@ static inline void __set_pte(pte_t *ptep, pte_t pte)
>  
>  static inline pte_t __ptep_get(pte_t *ptep)
>  {
> -	return READ_ONCE(*ptep);
> +	return pxxval_get(*ptep);
>  }
>  
>  extern void __sync_icache_dcache(pte_t pteval);
> @@ -1011,7 +1037,7 @@ static inline phys_addr_t pud_offset_phys(p4d_t *p4dp, unsigned long addr)
>  {
>  	BUG_ON(!pgtable_l4_enabled());
>  
> -	return p4d_page_paddr(READ_ONCE(*p4dp)) + pud_index(addr) * sizeof(pud_t);
> +	return p4d_page_paddr(p4dp_get(p4dp)) + pud_index(addr) * sizeof(pud_t);
>  }
>  
>  static inline
> @@ -1025,7 +1051,7 @@ pud_t *pud_offset_lockless(p4d_t *p4dp, p4d_t p4d, unsigned long addr)
>  
>  static inline pud_t *pud_offset(p4d_t *p4dp, unsigned long addr)
>  {
> -	return pud_offset_lockless(p4dp, READ_ONCE(*p4dp), addr);
> +	return pud_offset_lockless(p4dp, p4dp_get(p4dp), addr);
>  }
>  #define pud_offset	pud_offset
>  
> @@ -1134,7 +1160,7 @@ static inline phys_addr_t p4d_offset_phys(pgd_t *pgdp, unsigned long addr)
>  {
>  	BUG_ON(!pgtable_l5_enabled());
>  
> -	return pgd_page_paddr(READ_ONCE(*pgdp)) + p4d_index(addr) * sizeof(p4d_t);
> +	return pgd_page_paddr(pgdp_get(pgdp)) + p4d_index(addr) * sizeof(p4d_t);
>  }
>  
>  static inline
> @@ -1148,7 +1174,7 @@ p4d_t *p4d_offset_lockless(pgd_t *pgdp, pgd_t pgd, unsigned long addr)
>  
>  static inline p4d_t *p4d_offset(pgd_t *pgdp, unsigned long addr)
>  {
> -	return p4d_offset_lockless(pgdp, READ_ONCE(*pgdp), addr);
> +	return p4d_offset_lockless(pgdp, pgdp_get(pgdp), addr);
>  }
>  
>  static inline p4d_t *p4d_set_fixmap(unsigned long addr)
> @@ -1346,7 +1372,7 @@ static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
>  		unsigned long address, pmd_t *pmdp)
>  {
>  	/* Operation applies to PMD table entry only if FEAT_HAFT is enabled */
> -	VM_WARN_ON(pmd_table(READ_ONCE(*pmdp)) && !system_supports_haft());
> +	VM_WARN_ON(pmd_table(pmdp_get(pmdp)) && !system_supports_haft());
>  	return __ptep_test_and_clear_young(vma, address, (pte_t *)pmdp);
>  }
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */


