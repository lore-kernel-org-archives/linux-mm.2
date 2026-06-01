Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB0BACD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 05:02:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3D226B0251; Mon,  1 Jun 2026 01:02:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F14FC6B0253; Mon,  1 Jun 2026 01:02:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E51AC6B0254; Mon,  1 Jun 2026 01:02:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D29D26B0251
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:02:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B16240514
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:02:09 +0000 (UTC)
X-FDA: 84830147178.05.67D1810
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 62BF440004
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:02:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MTu7+33H;
	spf=pass (imf17.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780290127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gUsAVJggoi/K3HxTnoVgh3p7dIoAeKpu8pTBQY4Rgn0=;
	b=JbHH21LBzqj3dGAac4SUqotx7ZMvpCgGdm3uZjEmL4hE2IjFXZkdqjJbO5iFDCgl+ZU2e2
	T7WbCP3mLyvMO9FuoMUrqEeNKRsDIwykWs08OXY59qaurJo1ZfJRF2buDkJcuX756PAA1F
	gtyXlQQGOezSJ1KAyF1p/ave5nHPtpg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MTu7+33H;
	spf=pass (imf17.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780290127; a=rsa-sha256;
	cv=none;
	b=veZ85sWTofIQ9MfRv3XtfvWNGelccYiTPgLmhUIJYQBF3JGCredEejesrTimqSfDkhV3q/
	osKxe35qbJ9qTP/sz27onF95yNRhQQ+RvyUd6zwJ6W/2MaAbdfi0A2KIn0gRJie2nGdzWB
	FK30b+ZLYXGB01UA2dtIoHraXQN/YjE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 52F1E1E8D;
	Sun, 31 May 2026 22:02:01 -0700 (PDT)
Received: from [10.164.18.45] (unknown [10.164.18.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4F0283F93E;
	Sun, 31 May 2026 22:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780290126; bh=eLhjNs220y5uHRNrMiXUfKBzDSiUq0OzoNZWUdU02Vw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MTu7+33HfwoK52MCslYpG45Jblw0DwK/LDvbi0t4eOltNGt78kgVEvlJRGfrJBx/W
	 gREOZmYytTMWcgIDztMaljJNvbxuLR+2oyvy65dX1Exw5c7S3L22pTBevM+cEJqcTO
	 c02jMugrIxXuWmnKfxvueYmYWbDyni8NrIDmIew0=
Message-ID: <944a2ca8-c3de-4053-97cc-34e9b4f08b77@arm.com>
Date: Mon, 1 Jun 2026 10:31:59 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V2 07/14] arm64/mm: Route all pgtable reads via pxxval_get()
To: Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, Usama Arif <usama.arif@linux.dev>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
 <20260513044547.4128549-8-anshuman.khandual@arm.com>
 <c981c1ba-ab86-4865-b74b-df8d2005507b@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <c981c1ba-ab86-4865-b74b-df8d2005507b@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 62BF440004
X-Stat-Signature: kjah7rjqiyzppwnu8udtxzdwjymoh67s
X-HE-Tag: 1780290127-628804
X-HE-Meta: U2FsdGVkX18CUfIk+qcY+oYxhWl83WDRh+s2w9xc7x+QtyaKJeGEOanjguoGCsXXPfhRrWp4QcmmzhOwCaDQZNHZygKULpx4+Bu55x1VEAT5Au5sSNSXe5WebxdYX/SwAHVudkD+05xV40LvqI1zkBIonV7R6klai9xGRydUetiqwcT0A97TsH5ugmsOtjmI4z5crtkJ46/w/9wEzArj/8qnqyyB+MdhnwlW2Xy342zEdM6F75Pwrfx4g1WuKI/a0SAnDQOblUwIX8zGq76yAGxGV4nsS2mi/ZuyO2nn6y3PRK4xXtQmR+3iACJVIusDm1XOyASk6ML6CFyOJMU3CDpmOx4DS2ZKv/+HmrX5O3GETQZUqDLrYJjH+LagH3ToFk7kDh1jByxkxtY4b20L3lMZco19zmbFvIGo60/5Y415lYQoEpDOg97byAVsmKjUcIy1NmBZYfhBU1g5INeKPw6j28xi2H9HsYfJUCxxp0WYwqDi2eRgfm931zXTaF1oh0yZcJ8ac8Safk4+SDqNxh7iEsnXxLpZcFSbxh1XG/tbCFqVOj4sbbLRtJaHrxJY4VB7pzdAtWfiQ556+jfEaCVq9KiG42nKWuyP1vQbobVKIE72kIHgNiyEci9KMK44EOCIUD7S7uNnaP7Iu5///5X6hwWzzVwX4c/82s01q2WCPKBUXEvQDsmnCQHahLbmGU4b2L5mtkNHSbz4ELhAXpRC1FKdipPiWby31tvM/dxB0fGFKDSdpN9QRQG3Egxr/F7AQhY3DWFJ6ezazkKnMzVwfvzgzKO9h+UKPie73jrnVTD9CtTm06gyFhrImlFJF4uRppKQYB9c/pFACDg8uWWhmX2EEUlrvOyIIl+4MkJxYS9igml5f1Z3Jl9l1QQwpXJkrVQQe/XP+/4XWNytnnwM0RkoG28v+oK5b7y8Iwqn4AM2/N20sPuGKvSkZOTmX156lUp4ScL+f4iGugr
 p6XdlqEg
 QGjjR62Qnap5Fup2QYiVJTaNxs1Muebgg/0NjlMVfkZJ4CxSw9ej+1hhBQZ6BCARoFGNLBIg60kntWqE6fIccsLCGMD4Z3Q+KmcT8cdMSNy551neqgCSF+22Od8LXEb1sgejItzXOxbWOxbG1w0iOpre2j8jSDnk7is+C3bW/WIIX1hKFNaS51992LZoZEiAAsl81eqeTMbN49T58tRlPtYThB7K/eKRI6urcK8CUU8r0I64farsbDRlmrxrA2kmK0AyvgFjZE90aZG3130eqO7HFVxfPih57BOAPNGIQzAT6qIl3sX37tPYTJzu/Ag8GSh2sRRUHfTsB3fs9hb55C6SLdagut7wjL70Pi/es5i2TqBBtKsVTJ0olXgXngxLmXPxN7WCbvND/G8O+amK5aOnBRWEBv3oMeNQ+/Ek+5Ip/QuA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 27/05/26 7:41 PM, Ryan Roberts wrote:
> On 13/05/2026 05:45, Anshuman Khandual wrote:
>> Define arm64 platform specific implementations for new pXdp_get() helpers.
>> These resolve into READ_ONCE(), thus ensuring required single copy atomic
>> semantics for the page table entry reads.
>>
>> In future this infrastructure can be used for D128 to maintain single copy
>> atomicity semantics with inline asm blocks.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>> Changes in RFC V2:
>>
>> - Renamed all ptdesc_ instances as pxxval_ instead
>> - Moved arm64 pgtable header READ_ONCE() replacements here in this patch
>>
>>  arch/arm64/include/asm/pgtable.h | 38 +++++++++++++++++++++++++++-----
>>  1 file changed, 32 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index cefe8ab86acd..72da582e8d12 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -84,6 +84,32 @@ static inline void arch_leave_lazy_mmu_mode(void)
>>  	arch_flush_lazy_mmu_mode();
>>  }
>>  
>> +#define pxxval_get(x)		READ_ONCE(x)
> 
> I think this would be better as an inline (or __force_inline) function, which
> takes a pointer, and dereferences it. READ_ONCE() is special - it's modifying
> how the dereference should be done, so it makes sense that the dereference is
> done in the caller.
> 
>> +
>> +#define pmdp_get pmdp_get
>> +static inline pmd_t pmdp_get(pmd_t *pmdp)
>> +{
>> +	return pxxval_get(*pmdp);
> 
> This is weird to read. It would be clearer as:
> 
> 	return pxxval_get(pmdp);

But being a macro enables pxxval_get() to be used for all page table
levels as the dereference is done in the callers. Otherwise we would
need separate inline functions which take the corresponding pointers
for each pgtable level. Just wondering - would that be any better ?

Although pxxval_get(*pmdp) format does look bit weird to read.
> 
> Thanks,
> Ryan
> 
>> +}
>> +
>> +#define pudp_get pudp_get
>> +static inline pud_t pudp_get(pud_t *pudp)
>> +{
>> +	return pxxval_get(*pudp);
>> +}
>> +
>> +#define p4dp_get p4dp_get
>> +static inline p4d_t p4dp_get(p4d_t *p4dp)
>> +{
>> +	return pxxval_get(*p4dp);
>> +}
>> +
>> +#define pgdp_get pgdp_get
>> +static inline pgd_t pgdp_get(pgd_t *pgdp)
>> +{
>> +	return pxxval_get(*pgdp);
>> +}
>> +
>>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>  #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
>>  
>> @@ -380,7 +406,7 @@ static inline void __set_pte(pte_t *ptep, pte_t pte)
>>  
>>  static inline pte_t __ptep_get(pte_t *ptep)
>>  {
>> -	return READ_ONCE(*ptep);
>> +	return pxxval_get(*ptep);
>>  }
>>  
>>  extern void __sync_icache_dcache(pte_t pteval);
>> @@ -1011,7 +1037,7 @@ static inline phys_addr_t pud_offset_phys(p4d_t *p4dp, unsigned long addr)
>>  {
>>  	BUG_ON(!pgtable_l4_enabled());
>>  
>> -	return p4d_page_paddr(READ_ONCE(*p4dp)) + pud_index(addr) * sizeof(pud_t);
>> +	return p4d_page_paddr(p4dp_get(p4dp)) + pud_index(addr) * sizeof(pud_t);
>>  }
>>  
>>  static inline
>> @@ -1025,7 +1051,7 @@ pud_t *pud_offset_lockless(p4d_t *p4dp, p4d_t p4d, unsigned long addr)
>>  
>>  static inline pud_t *pud_offset(p4d_t *p4dp, unsigned long addr)
>>  {
>> -	return pud_offset_lockless(p4dp, READ_ONCE(*p4dp), addr);
>> +	return pud_offset_lockless(p4dp, p4dp_get(p4dp), addr);
>>  }
>>  #define pud_offset	pud_offset
>>  
>> @@ -1134,7 +1160,7 @@ static inline phys_addr_t p4d_offset_phys(pgd_t *pgdp, unsigned long addr)
>>  {
>>  	BUG_ON(!pgtable_l5_enabled());
>>  
>> -	return pgd_page_paddr(READ_ONCE(*pgdp)) + p4d_index(addr) * sizeof(p4d_t);
>> +	return pgd_page_paddr(pgdp_get(pgdp)) + p4d_index(addr) * sizeof(p4d_t);
>>  }
>>  
>>  static inline
>> @@ -1148,7 +1174,7 @@ p4d_t *p4d_offset_lockless(pgd_t *pgdp, pgd_t pgd, unsigned long addr)
>>  
>>  static inline p4d_t *p4d_offset(pgd_t *pgdp, unsigned long addr)
>>  {
>> -	return p4d_offset_lockless(pgdp, READ_ONCE(*pgdp), addr);
>> +	return p4d_offset_lockless(pgdp, pgdp_get(pgdp), addr);
>>  }
>>  
>>  static inline p4d_t *p4d_set_fixmap(unsigned long addr)
>> @@ -1346,7 +1372,7 @@ static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
>>  		unsigned long address, pmd_t *pmdp)
>>  {
>>  	/* Operation applies to PMD table entry only if FEAT_HAFT is enabled */
>> -	VM_WARN_ON(pmd_table(READ_ONCE(*pmdp)) && !system_supports_haft());
>> +	VM_WARN_ON(pmd_table(pmdp_get(pmdp)) && !system_supports_haft());
>>  	return __ptep_test_and_clear_young(vma, address, (pte_t *)pmdp);
>>  }
>>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
> 


