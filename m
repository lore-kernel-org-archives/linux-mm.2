Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 352DBC5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 16:23:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34F576B029D; Thu, 13 Aug 2026 12:23:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 329196B02A7; Thu, 13 Aug 2026 12:23:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 264306B0543; Thu, 13 Aug 2026 12:23:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 07D806B029D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:23:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8107E1C0974
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:23:55 +0000 (UTC)
X-FDA: 85096767630.20.DFB502A
Received: from mta1.migadu.com (out-25.mta1.migadu.com [95.215.58.25])
	by imf25.hostedemail.com (Postfix) with ESMTP id 563CAA0003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:23:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xD3qSirc;
	spf=pass (imf25.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.25 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786638233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ig2gtwEZ7YEv18caEyN0/dCFh+D4Oeu5ya2HHQfIC7E=;
	b=QrDfDmcpEzn827zvtSoeNgbBm/Q/sMAVs7dUyV/M2N5j4nSnRFuS/zwnG5qFQj4bNBCNjn
	foDtFzhmTlnfdUdSvF01RQ/K/URbkldj50A+cZOYLm7wVl8NieG/tQBJSqGPg78oF7iIGK
	vw6Ff7e4PPaiVkPS2NJ0MSve8OrCXfs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xD3qSirc;
	spf=pass (imf25.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.25 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786638233;
	b=HAO1cErPKiGOtNXfsheaXxNDEUVxlordXZlWTwDJq9rJswI86/MslpUKTfmYSNm6+Geega
	bhc356tJOO9wJOzykHiVX3lxH9uBhomHhzglPHSOWY1CZ2h+EUaL8pOAL120a69xnzUoot
	KgZw1GEgl2v9WKmuvOH17GMgip3oVhk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=b8g8o1EPbroInUM8DUJk/BET1LeblPQuGgrDZpp4Q4k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786638231; v=1; x=1787243031;
 b=xD3qSircX7iV4urAj/Q6jf8IcQBOyniKXqSSGVVtNhVQQBmXLTpjOWNFPrsFjcjjir4/wTLz
 YRlKZDY1oJOHgUsVdYXsMJks0e4hyTYqPb656Srao30SlXOl5kxUgUVDmZrzyrgkCMSgeDemJ0B
 5ZBIKgY1l4esz8tsEIOb1ZsE=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (77.97.51.77)
	by smtp.migadu.com with ESMTPS id 394f813be1b9a82f;
	Thu, 13 Aug 2026 16:23:51 +0000
X-Migadu-Flow: FLOW_OUT
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 13 Aug 2026 17:23:46 +0100
Message-Id: <DKNYE6DOGOPF.34MEA11Q7ACZR@linux.dev>
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Yosry Ahmed" <yosry@kernel.org>, "Brendan Jackman"
 <jackmanb@google.com>
Cc: "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport"
 <rppt@kernel.org>, "Wei Xu" <weixugc@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Lorenzo Stoakes"
 <ljs@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <x86@kernel.org>, "Sumit Garg" <sumit.garg@oss.qualcomm.com>, "Will Deacon"
 <will@kernel.org>, <rientjes@google.com>, "Kalyazin, Nikita"
 <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, "Itazuri, Takahiro"
 <itazur@amazon.co.uk>, "Andy Lutomirski" <luto@kernel.org>, "David Kaplan"
 <david.kaplan@amd.com>, "Thomas Gleixner" <tglx@kernel.org>, "Patrick
 Bellasi" <derkling@google.com>, "Reiji Watanabe" <reijiw@google.com>, "Sean
 Christopherson" <seanjc@google.com>
Subject: Re: [PATCH v3 07/26] x86/mm: introduce mm-local region
X-Mailer: aerc 0.21.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-7-6f5729aa9832@google.com>
 <anES7O7T_PN2bV0v@google.com>
In-Reply-To: <anES7O7T_PN2bV0v@google.com>
X-Stat-Signature: kn5zmhnpcfp7y34bxqpmckstkw937yqf
X-Rspamd-Queue-Id: 563CAA0003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786638233-223610
X-HE-Meta: U2FsdGVkX1+DSZ/lwqaNJhdoIqmUThnlMpBcxVy9CX4iPQJSRxMnkXZqGuDPlyY2I5MjQKqSg2HzamQ7HXHVnwtgTNcQC3nCpQRc9694fbCWjNKZC419z9MuFhzNyME9X88ugkNQfTIgxUlzP/ELMC8P1XCNLR7HG46uRtCV2mmjBX+jP6Toe13q2xz/hxZ15ZMhiHtJPWdTv8VOVSQcdNCTSKv0mlcDOWFqkL8fbA4GZGsgVY+tx0Xyp+leHFMsuaq8m6RiPbhPNQV+pCUd+KCaj9vOkCyipX2cz+CcmNtziBabvyF2KuHXu1b1SguU0T296m0MhC+mHwuNG8atd4kx1g1vUSQFpo1rOi50pnl+J/3HTUURG6G9zB65D6bKShxEnqPRtO6KCXsdjeVmRVp1StwarRHMClUV/AZOqhz7sjG5/9MUmyL2aV+4n6g0gwDGvmUfO6VFl1vXO3ki6tEV5g9m212oyzv1V9bZlqb0LRpF9WeaCNMhiuOgYHOKxGANt8VJxh8/UTEF5sBvkRsgwRDusCVlzMyoHbnoiRO2KgmVOIA15aVyhUMALpK8MriHLXCXufQXGz2zVYZ10Ljsz9zg4VNTWA2OZOgOwrNA2ojRAElycpxG18GyrVz+bhGtz2e9dGk6hLskWWKdYWzQR3rDLeFEyQusTZ87QsPLjtwqsH9oxwiBsVSgTD4t8trC1DkyyAEc6xgbpW6S8qJpMLyuuBu+vXU3jIRnUNY2M8OtL5lCs5L6DJXkiRiCgZulKKna83eXS01tuKplahb6YbQC/EooGpivP3gcjQc4eTAG3yafGoSvA8016+Io/UtbpLri0AcyJTClAfpod5mJ/wmq4FZYQaNk0IAZVWnES9AQ8lzRiVghR4jCYoKSCr1evBFBm9d+euOmd5ztnEbisZivw8Jy9purdu7z1Ifg4JRlf2lcBS/oVPiNIo+eCYifWd9bz+607BiqVmT
 RmqaADzh
 n03CPTpvG/da5YSYEresLy7gm2DJeCumvva+tMtY72euAi+ypscrRndF+0/zGNr9sXgk3FooRejAyQwHbZPQDEfc1G1sbi8Xl3UBk/J4Ywvorh9GzT56ti9lTV5aNjELzibRtExccRcnht6SkVW/756yVQXgWMmo6EadmVxwQtFrQD+1Adqzh+Vm0C6lpykwScRRtirXirpN5ysGNx0EUSa/C3gwtfq6E7MVXCehK2YN1RgKkwf7bc67SLhENHwcUwJ75gewuNZQ5nY2abiZOqu5tLjp2AA1y3rBr/lUs4EUuHncuf9EdDe/B9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Aug 3, 2026 at 11:29 PM BST, Yosry Ahmed wrote:
...
>> +#ifdef CONFIG_MM_LOCAL_REGION
>> +static inline void mm_local_region_free(struct mm_struct *mm)
>> +{
>> +	if (!mm_local_region_used(mm))
>> +		return;
>> +
>> +	struct mmu_gather tlb;
>> +	unsigned long start =3D MM_LOCAL_BASE_ADDR;
>> +	unsigned long end =3D MM_LOCAL_END_ADDR;
>
> These declarations should probably go at the beginning of the function.

Oops, ack.

>> +
>> +	/*
>> +	 * Although free_pgd_range() is intended for freeing user
>> +	 * page-tables, it also works out for kernel mappings on x86.
>> +	 * Use tlb_gather_mmu_fullmm() to avoid confusing the
>> +	 * range-tracking logic in __tlb_adjust_range().
>> +	 */
>> +	tlb_gather_mmu_fullmm(&tlb, mm);
>> +	free_pgd_range(&tlb, start, end, start, end);
>> +	tlb_finish_mmu(&tlb);
>> +
>> +	mm_flags_clear(MMF_LOCAL_REGION_USED, mm);
>> +}
>> +
>> +#if defined(CONFIG_MITIGATION_PAGE_TABLE_ISOLATION) && defined(CONFIG_X=
86_PAE)
>
> Would it be clearer to have nested #ifdefs instead?
>
> #ifdef CONFIG_MITIGATION_PAGE_TABLE_ISOLATION
>
> #ifdef CONFIG_X86_PAE
> ...
> #else /* CONFIG_X86_PAE */
> ...
> #endif /* CONFIG_X86_PAE */
>
> #else /* CONFIG_MITIGATION_PAGE_TABLE_ISOLATION */
>
> #endif /* CONFIG_MITIGATION_PAGE_TABLE_ISOLATION */
>
> Maybe not, just thinking out loud.

Hm, I wrote it out in the editor and no I don't think it's clearer. I
think as the reader it just means you basically have to reconstruct the
&&/elif in your head since you need to see this as a "three-headed if"
for it to make any sense.

...
>> +#elif defined(CONFIG_MITIGATION_PAGE_TABLE_ISOLATION)
>> +static inline int mm_local_map_to_user(struct mm_struct *mm)
>> +{
>> +	pgd_t *pgd;
>> +	int err;
>> +
>> +	err =3D preallocate_sub_pgd(mm, MM_LOCAL_BASE_ADDR);
>> +	if (err)
>> +		return err;
>> +
>> +	pgd =3D pgd_offset(mm, MM_LOCAL_BASE_ADDR);
>> +	set_pgd(kernel_to_user_pgdp(pgd), *pgd);
>> +	return 0;
>> +}
>
> The code above bears a lot of similarity to the LDT code removed in
> patch 8, and reviewing them separately is annoying. I realize that they
> were a single patch in the previous version and Dave complained that it
> was too large.
>
> What if we go a different way:
> 1. Move the LDT functions that will be repurposed to mmu_context.h.
> 2. Rename the functions to the mm_local_* domain where needed.
> 3. Actually perform the switch for LDT to use mm local region.
>
> Maybe (2) and (3) should be combined, depending on what the git diff
> looks like.
>
> I think this will make the diffs much clearer, for example
> mm_local_map_to_user() mainly differ from map_ldt_struct_to_user() in
> preallocation.

Sounds fine to me, let's try it out and I'll come back here if it turns
out to be messy.

>> +#else
>> +static inline int mm_local_map_to_user(struct mm_struct *mm)
>> +{
>> +	WARN_ONCE(1, "mm_local_map_to_user() not implemented");
>> +	return -EINVAL;
>> +}
>> +#endif
> [..]
>> diff --git a/arch/x86/include/asm/pgtable_32_areas.h b/arch/x86/include/=
asm/pgtable_32_areas.h
>> index 921148b429676..7fccb887f8b33 100644
>> --- a/arch/x86/include/asm/pgtable_32_areas.h
>> +++ b/arch/x86/include/asm/pgtable_32_areas.h
>> @@ -30,9 +30,14 @@ extern bool __vmalloc_start_set; /* set once high_mem=
ory is set */
>>  #define CPU_ENTRY_AREA_BASE	\
>>  	((FIXADDR_TOT_START - PAGE_SIZE*(CPU_ENTRY_AREA_PAGES+1)) & PMD_MASK)
>> =20
>> -#define LDT_BASE_ADDR		\
>> -	((CPU_ENTRY_AREA_BASE - PAGE_SIZE) & PMD_MASK)
>> +/*
>> + * On 32-bit the mm-local region is currently completely consumed by th=
e LDT
>> + * remap.
>> + */
>> +#define MM_LOCAL_BASE_ADDR	((CPU_ENTRY_AREA_BASE - PAGE_SIZE) & PMD_MAS=
K)
>> +#define MM_LOCAL_END_ADDR	(MM_LOCAL_BASE_ADDR + PMD_SIZE)
>> =20
>> +#define LDT_BASE_ADDR		MM_LOCAL_BASE_ADDR
>>  #define LDT_END_ADDR		(LDT_BASE_ADDR + PMD_SIZE)
>> =20
>>  #define PKMAP_BASE		\
>> diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/=
asm/pgtable_64_types.h
>> index 7eb61ef6a185f..1181565966405 100644
>> --- a/arch/x86/include/asm/pgtable_64_types.h
>> +++ b/arch/x86/include/asm/pgtable_64_types.h
>> @@ -5,8 +5,11 @@
>>  #include <asm/sparsemem.h>
>> =20
>>  #ifndef __ASSEMBLER__
>> +#include <linux/build_bug.h>
>>  #include <linux/types.h>
>>  #include <asm/kaslr.h>
>> +#include <asm/page_types.h>
>> +#include <uapi/asm/ldt.h>
>> =20
>>  /*
>>   * These are used to make use of C type-checking..
>> @@ -100,9 +103,12 @@ extern unsigned int ptrs_per_p4d;
>>  #define GUARD_HOLE_BASE_ADDR	(GUARD_HOLE_PGD_ENTRY << PGDIR_SHIFT)
>>  #define GUARD_HOLE_END_ADDR	(GUARD_HOLE_BASE_ADDR + GUARD_HOLE_SIZE)
>> =20
>> -#define LDT_PGD_ENTRY		-240UL
>> -#define LDT_BASE_ADDR		(LDT_PGD_ENTRY << PGDIR_SHIFT)
>> -#define LDT_END_ADDR		(LDT_BASE_ADDR + PGDIR_SIZE)
>> +#define MM_LOCAL_PGD_ENTRY	-240UL
>> +#define MM_LOCAL_BASE_ADDR	(MM_LOCAL_PGD_ENTRY << PGDIR_SHIFT)
>> +#define MM_LOCAL_END_ADDR	((MM_LOCAL_PGD_ENTRY + 1) << PGDIR_SHIFT)
>
> Any reason not keep the current formula (i.e. MM_LOCAL_BASE_ADDR +
> PGDIR_SIZE)?

Er no I don't see any good reason I changed this.

>> +
>> +#define LDT_BASE_ADDR		MM_LOCAL_BASE_ADDR
>> +#define LDT_END_ADDR		(LDT_BASE_ADDR + PMD_SIZE)
>
> Looks like the LDT area was silently changed to PMD_SIZE here. I assume
> this is to give the rest of the pgd-mapped address space to the mermap,
> but maybe we should call this out explicitly, or do it when the mermap
> is introduced (or separately)?

Right. This might be a bug  that causes us to leak pagetables on some
platforms. Haven't checked as it gets fixed in the next commit
regardless, but let's just do what you suggested.

