Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EE42CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 11:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE2948E0002; Thu,  4 Sep 2025 07:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBA1A8E0001; Thu,  4 Sep 2025 07:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6F88E0002; Thu,  4 Sep 2025 07:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CCDA68E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:11:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D6911A0100
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:11:02 +0000 (UTC)
X-FDA: 83851300764.11.0CE4DA9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id E78AC18000D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:11:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756984261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/PTAV17+IuYGzhs0wgKtky3guInxpwjAojrDT1PtQBc=;
	b=sdune1nJKBnG3svtWpN/3Ht93IpmiZDu1ch0CAGlm1aT7Bj6SVf3FsB/nbERg+SRCZblYS
	s4Iyk4mcCz89RSom3lyV1wD3RCrR4fl95YA0xpa6pmT1YRBc9YqGxibkGLA1JUoAqvRq+i
	hbeP7sDe8/O1ArfJn5ftAIUoVTqMgU4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756984261; a=rsa-sha256;
	cv=none;
	b=KXWt9DPzFerzyxTI1MtR3OQq45o/kMkDRk4H+aR8qOqhDOpDB22i6S+daUWIY4akhUOuZG
	HqKV3BGZx8/cOhPrzC7x8ieu0RKJpZdiKq5g26DIel57e4NwhFQNUmjztaS+X1l9BE2JuD
	RHDkf3LuGrsVD6pfE5aWFVueTg2Rk5c=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2CAC1756;
	Thu,  4 Sep 2025 04:10:51 -0700 (PDT)
Received: from [10.1.37.179] (XHFQ2J9959.cambridge.arm.com [10.1.37.179])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 378AB3F6A8;
	Thu,  4 Sep 2025 04:10:58 -0700 (PDT)
Message-ID: <2cf02021-10d2-46f6-b3e6-f5c55546ca9e@arm.com>
Date: Thu, 4 Sep 2025 12:10:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 6/6] arm64: mm: Optimize linear_map_split_to_ptes()
Content-Language: en-GB
To: Yang Shi <yang@os.amperecomputing.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ard Biesheuvel <ardb@kernel.org>, Dev Jain <dev.jain@arm.com>,
 scott@os.amperecomputing.com, cl@gentwo.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <20250829115250.2395585-7-ryan.roberts@arm.com>
 <9d666caf-a799-4229-86b5-3a22a60fa79f@os.amperecomputing.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <9d666caf-a799-4229-86b5-3a22a60fa79f@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E78AC18000D
X-Stat-Signature: s56ds1emqqefxzsr83nppohuxma1t6n9
X-Rspam-User: 
X-HE-Tag: 1756984260-528619
X-HE-Meta: U2FsdGVkX1/ab5su/yQCp3IKQGHEVsXQXPJLesmUEQZ7pDwu620u8IC+Iz3dgyjFDCjSM3Z97EIrm9t7vO490O8tcL5Fy4c0V8UP1NtLi0XyqPFIank3XYyPF8PD6L9drlcTzNMaBV9+DNmfiiIuqZ2zX2LhwhE/d4MW3HiM1LaZplhgR/3yLn4+Y+ffNqqFh0FYiqa+cqgEbG8zi8Bw/NE8GXhjTOYb6ua+YdundyB2ev8Xyt2T87VQJGREpqwJn6rFkOWd0opkF9IsC4NsP0Cr5/BaPNTudi5u6iCpZsRsIAkey2Jtkx+nf89QeDQ143gnXdhGoRx8ApPgJDmrGQ8F9dpoJ1m5ase4H6f0I2j13/qeCXqnHyngpzvC3j2EpOZdbM+huJ7TYh1EzYK3sgdNim46rLv1sgng4K83uPeLlcaJpG+JsZslrjeB360Ead/YXuEfuCVjtWvnk8T0SVSrlxktfD1eqPn0Eqgmbu6WHbW8AcG2RkJu7UCeKNCC4UgDnjXOQYk842yT868dO6SDGecoKZpwlDd1fuu+TCd31fwCJWJPC4Uex33FetV6tnBIHmpA4+ZAOFtXOuODJMeLndtZtdeO2nb+qPLOh8peHN7NMhJxoGcWR38T5e2UqEN27LM0OJ0rclCKhhHkeRWCWVf511x5/nyfutJD1mTHk85FixqaWIMnrwswUx/4xgQCHsfkxCMgX2K3Gs95+hZXkH6E/2v3zGgvXaitJGfCFNc/ueqtZ4+WYwEI3EODUOwPkRt0HhMdSx1Rg8lGHy/wqb++gEWiLqp9/xNp5T9csvCM58j5oPNwU3cpc5xgWuy33OZZ4vkUyukgbfs8wT87FKQqEAAB9O6/kjnDaja+HgyZwnjIOBsX/XrdwLSRaLckDgvMbTU53Uh82y1Hv7gK1nJA7DSk8IQF+1i7MUJIaG0G3OYOFPaJUBijyWqMM8rrzYJkZPgwqrNd/gS
 IQdDhI3N
 emOOP7vZcz3O8BmH1f6khvBUGGx+YQvLrV7i33ht97ZYwSOBXod5/b7E81v2yNBVyWkOVOVqh2Kbe/97KlMtmNSe2UoUFqPC8HwJK9T7smLgmIsD6ID8Y0L2jDme+FH+hgVuX5jnwncf07rav1nsnxSKxLtIqiiAjkn7/UqFZgcxF/6R8yYQZa/PS7vzvKrG/qPccoxWOHpanQNbxY6r7ktAn00yAV1ovN69Mi7DRoqXDUiTIKLUkcF0pNaNa4ba3dbFdQWSL94XadxKkXwpEALGM7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/08/2025 23:27, Yang Shi wrote:
> 
> 
> On 8/29/25 4:52 AM, Ryan Roberts wrote:
>> When splitting kernel leaf mappings, either via
>> split_kernel_leaf_mapping_locked() or linear_map_split_to_ptes(),
>> previously a leaf mapping was always split to the next size down. e.g.
>> pud -> contpmd -> pmd -> contpte -> pte. But for
>> linear_map_split_to_ptes() we can avoid the contpmd and contpte states
>> because we know we want to split all the way down to ptes.
>>
>> This avoids visiting all the ptes in a table if it was created by
>> splitting a pmd, which is noticible on systems with a lot of memory.
> 
> Similar to patch #4, this patch should be squashed into patch #5 IMHO.

That's fine by me. I was just trying to make the review easier by splitting
non-essential stuff out. Let's squash for next version.

> 
> Thanks,
> Yang
> 
>>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> ---
>>   arch/arm64/mm/mmu.c | 26 ++++++++++++++++++--------
>>   1 file changed, 18 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index 6bd0b065bd97..8e45cd08bf3a 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -550,7 +550,7 @@ static void split_contpte(pte_t *ptep)
>>           __set_pte(ptep, pte_mknoncont(__ptep_get(ptep)));
>>   }
>>   -static int split_pmd(pmd_t *pmdp, pmd_t pmd, gfp_t gfp)
>> +static int split_pmd(pmd_t *pmdp, pmd_t pmd, gfp_t gfp, bool to_cont)
>>   {
>>       pmdval_t tableprot = PMD_TYPE_TABLE | PMD_TABLE_UXN | PMD_TABLE_AF;
>>       unsigned long pfn = pmd_pfn(pmd);
>> @@ -568,7 +568,9 @@ static int split_pmd(pmd_t *pmdp, pmd_t pmd, gfp_t gfp)
>>           tableprot |= PMD_TABLE_PXN;
>>         prot = __pgprot((pgprot_val(prot) & ~PTE_TYPE_MASK) | PTE_TYPE_PAGE);
>> -    prot = __pgprot(pgprot_val(prot) | PTE_CONT);
>> +    prot = __pgprot(pgprot_val(prot) & ~PTE_CONT);
>> +    if (to_cont)
>> +        prot = __pgprot(pgprot_val(prot) | PTE_CONT);
>>         for (i = 0; i < PTRS_PER_PTE; i++, ptep++, pfn++)
>>           __set_pte(ptep, pfn_pte(pfn, prot));
>> @@ -592,7 +594,7 @@ static void split_contpmd(pmd_t *pmdp)
>>           set_pmd(pmdp, pmd_mknoncont(pmdp_get(pmdp)));
>>   }
>>   -static int split_pud(pud_t *pudp, pud_t pud, gfp_t gfp)
>> +static int split_pud(pud_t *pudp, pud_t pud, gfp_t gfp, bool to_cont)
>>   {
>>       pudval_t tableprot = PUD_TYPE_TABLE | PUD_TABLE_UXN | PUD_TABLE_AF;
>>       unsigned int step = PMD_SIZE >> PAGE_SHIFT;
>> @@ -611,7 +613,9 @@ static int split_pud(pud_t *pudp, pud_t pud, gfp_t gfp)
>>           tableprot |= PUD_TABLE_PXN;
>>         prot = __pgprot((pgprot_val(prot) & ~PMD_TYPE_MASK) | PMD_TYPE_SECT);
>> -    prot = __pgprot(pgprot_val(prot) | PTE_CONT);
>> +    prot = __pgprot(pgprot_val(prot) & ~PTE_CONT);
>> +    if (to_cont)
>> +        prot = __pgprot(pgprot_val(prot) | PTE_CONT);
>>         for (i = 0; i < PTRS_PER_PMD; i++, pmdp++, pfn += step)
>>           set_pmd(pmdp, pfn_pmd(pfn, prot));
>> @@ -669,7 +673,7 @@ static int split_kernel_leaf_mapping_locked(unsigned long
>> addr)
>>       if (!pud_present(pud))
>>           goto out;
>>       if (pud_leaf(pud)) {
>> -        ret = split_pud(pudp, pud, GFP_PGTABLE_KERNEL);
>> +        ret = split_pud(pudp, pud, GFP_PGTABLE_KERNEL, true);
>>           if (ret)
>>               goto out;
>>       }
>> @@ -694,7 +698,7 @@ static int split_kernel_leaf_mapping_locked(unsigned long
>> addr)
>>            */
>>           if (ALIGN_DOWN(addr, PMD_SIZE) == addr)
>>               goto out;
>> -        ret = split_pmd(pmdp, pmd, GFP_PGTABLE_KERNEL);
>> +        ret = split_pmd(pmdp, pmd, GFP_PGTABLE_KERNEL, true);
>>           if (ret)
>>               goto out;
>>       }
>> @@ -771,7 +775,7 @@ static int __init split_to_ptes_pud_entry(pud_t *pudp,
>> unsigned long addr,
>>       int ret = 0;
>>         if (pud_leaf(pud))
>> -        ret = split_pud(pudp, pud, GFP_ATOMIC);
>> +        ret = split_pud(pudp, pud, GFP_ATOMIC, false);
>>         return ret;
>>   }
>> @@ -786,7 +790,13 @@ static int __init split_to_ptes_pmd_entry(pmd_t *pmdp,
>> unsigned long addr,
>>       if (pmd_leaf(pmd)) {
>>           if (pmd_cont(pmd))
>>               split_contpmd(pmdp);
>> -        ret = split_pmd(pmdp, pmd, GFP_ATOMIC);
>> +        ret = split_pmd(pmdp, pmd, GFP_ATOMIC, false);
>> +
>> +        /*
>> +         * We have split the pmd directly to ptes so there is no need to
>> +         * visit each pte to check if they are contpte.
>> +         */
>> +        walk->action = ACTION_CONTINUE;
>>       }
>>         return ret;
> 


