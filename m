Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB1BCD58E47
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 04:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B55B46B0095; Sun,  1 Mar 2026 23:34:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B03E66B0096; Sun,  1 Mar 2026 23:34:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E4DA6B009B; Sun,  1 Mar 2026 23:34:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F27A6B0095
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 23:34:14 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 280391A0919
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 04:34:14 +0000 (UTC)
X-FDA: 84499856028.25.EE71546
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3D8DCC0004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 04:34:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772426052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cMLe22ZH8ax/OwtpsGVAKqhua1x5KYk9QkH3LqCQoDk=;
	b=Avk88LXRoJtNbIXd8IxMv6HzcfYh+04YiTDAb4zCh5Ylc5uNbZ16jR44mkUR8bIS+hBhTI
	Mc6Edui2B0seIyX2btIcc4BkuR/8JlmsgLVS/VO6TSbyW8uWCCi+CgbK78NpmwvLLHIHy4
	UoxFv3K1+V0Pb7whs3ULCJs+WPnufbA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772426052; a=rsa-sha256;
	cv=none;
	b=4/YkdMNPC2xfpvj/d0NUbknGQdDiFAumFme6b/YGhYnfKBaM7KXGs2yUq7rXNzeuv1dMdq
	7dAGkwxZFtE3F3oWKsjbWajnd4siGNqMbMDkYjwLMR78Sv+n+8Rcy95Q8rhtw8d2M/+LD/
	R4GYnwStuJuXhy6Ubl8yEJGVbZdBQww=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDEAB14BF;
	Sun,  1 Mar 2026 20:34:04 -0800 (PST)
Received: from [10.164.18.51] (unknown [10.164.18.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A82023F7BD;
	Sun,  1 Mar 2026 20:34:07 -0800 (PST)
Message-ID: <7f7130d0-f348-451e-960e-b7e6ae9c9ee7@arm.com>
Date: Mon, 2 Mar 2026 10:04:04 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 09/16] arm64/mm: Route all pgtable reads via ptdesc_get()
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-10-anshuman.khandual@arm.com>
 <aaLO3yOu1ShO2tNz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <aaLO3yOu1ShO2tNz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3D8DCC0004
X-Stat-Signature: 75iz7mwz7a886wj38je7bh1idaxzww91
X-Rspam-User: 
X-HE-Tag: 1772426052-878538
X-HE-Meta: U2FsdGVkX1/CQKlyE40CvjkQQjfaOtnLG6fnBBv6MNsQzY58lYoNNQkdzcMYOJWl9tWuQt5vDB2Ym1Kf8kbybvp8jvV0FS1iVHd042By887W0jGjn6E6TWIp5jjI7cw/WB3E8BKNpKroauzAhcWBq9JrFap2LZHxIZsN/SMu60JE+blCIa25DR+YwFoUV6Qy7hnjCgBt4zOJv8YZVCd4blOPVEnBSMIa2XxdYjXYMO7FWw3D9tNUSgZiAxKZySNCw09IyX74uii2K9J0LJJT/0DOOx3Pf7+B1qZRUBSi8vndEulGeb0c2kcTFM9IMBXZFF+cCiMXPl1Jho/c7ewRW2UjzCLEfEFYmHVhiPsCZSaQUeSXL0wSUwDD7sl2oKyeVknpEaoFhYSdULxLCFz1PLmZVbXOIx2nxMXdrEM4NGoQETGsm/kKYvcLzaLktnZ8xCjrW0ZgaL4+TdP+zBi4epCemQMaDfg8odnFJ1eQf+w7s/oPFkP8yzJ1kWhk4pzmZKS0zE3tbDyCiRtrb+DDT0W3DqJj52ctgStzgjwDydq7Tea1doUXJAiSMBPDMZLFhGlCi26vmPaN+cZF7HhmnFMxa5uTW1uX1Rx5yTpwwOsCOyQ71Bnsg5vzEPdZp/y3hkenPaFuZ7KZcY1oAbyumC6+zinINV/Yf4l9xGwdu8UnkwCCcQte8NdWAhBBl+9Pf4+7uXGx8XYVrKZr97f6JRzplwxdGR37uztvJTRZqQpMSIZORGHOsi8VUh+gnaAxX6+9F+Qm4E1MNbUnI9m9/20cYJfHCLY5A3F+T9Fb6BzKkGlckNA0WKhtowQe5OWMRfM8ictglBZUrS46euGNwy+TM9vH+gYUwMY3pqBtXbbTPs4byAwqKG5kWrudAHk8qa7yQJJMLyp6DrEwRT2v/m9VgYYaVv+YzUWoYKFK3RQ5n7rwmohICBi5sT3jjmHatusgLgOPDwecmoiYa2O
 G1ZQs8PX
 KcwfTQWV7u0/uiqA633RKFWEyz7Sdsa/R/aiD1CsGCLz64mRxjbAoi/SuoaljhwvpMBxj0nuk1uF+yoROkWw4i9M+V++kcm78VytBy4uo+JkxEna1sjFR5Jgk8cZs+IXJMpr26MfY3UP5Kp0y4dKbLBxep9mymF3eXFbg1HNyO4oMYJXJcoknamq/g/8gkOfJeOWeDywIFQ2t6e/Pv3oD5pRtjxR+PW7aPJwFEHnVZzsDbYWgEYNgtlTmchV9fiKvO6HIjZbybHnstA/kFUth7p4dZbqakos54NfJVUkdPEUOD6MN+uNQ8Wa72x9kzf/5mU9fHaF2NSHQ+Gk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 28/02/26 4:47 PM, Mike Rapoport wrote:
> Hi Anshuman,
> 
> On Tue, Feb 24, 2026 at 10:41:46AM +0530, Anshuman Khandual wrote:
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
>>  arch/arm64/include/asm/pgtable.h | 28 +++++++++++++++++++++++++++-
>>  1 file changed, 27 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index 257af1c3015d..804ef49aea88 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -84,6 +84,32 @@ static inline void arch_leave_lazy_mmu_mode(void)
>>  	arch_flush_lazy_mmu_mode();
>>  }
>>  
>> +#define ptdesc_get(x)		READ_ONCE(x)
> 
> This will be confusing with 'struct ptdesc' APIs, maybe ptent_get()?

Created 'ptdesc_t' earlier on arm64 platform as an unified data type, which could
represent page table entries including their protection fields and masks for any
level.

typedef u64 ptdesc_t;

typedef ptdesc_t pteval_t;
typedef ptdesc_t pmdval_t;
typedef ptdesc_t pudval_t;
typedef ptdesc_t p4dval_t;
typedef ptdesc_t pgdval_t;

But now it conflicts with generic 'struct ptdesc'. Agreed that overall renaming is
required. Probably ptent_t along with ptent_get/set() could be an option. But that
is probably orthogonal to the series and can be done later in a separate patch.

> 
>> +#define pmdp_get pmdp_get
>> +static inline pmd_t pmdp_get(pmd_t *pmdp)
>> +{
>> +	return ptdesc_get(*pmdp);
>> +}
>> +
>> +#define pudp_get pudp_get
>> +static inline pud_t pudp_get(pud_t *pudp)
>> +{
>> +	return ptdesc_get(*pudp);
>> +}
>> +
>> +#define p4dp_get p4dp_get
>> +static inline p4d_t p4dp_get(p4d_t *p4dp)
>> +{
>> +	return ptdesc_get(*p4dp);
>> +}
>> +
>> +#define pgdp_get pgdp_get
>> +static inline pgd_t pgdp_get(pgd_t *pgdp)
>> +{
>> +	return ptdesc_get(*pgdp);
>> +}
>> +
>>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>  #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
>>  
>> @@ -384,7 +410,7 @@ static inline void __set_pte(pte_t *ptep, pte_t pte)
>>  
>>  static inline pte_t __ptep_get(pte_t *ptep)
>>  {
>> -	return READ_ONCE(*ptep);
>> +	return ptdesc_get(*ptep);
>>  }
>>  
>>  extern void __sync_icache_dcache(pte_t pteval);
>> -- 
>> 2.43.0
>>
> 


