Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0930CCD184
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 07:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19CC88E0010; Tue,  7 Oct 2025 03:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14D268E0005; Tue,  7 Oct 2025 03:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03CA28E0010; Tue,  7 Oct 2025 03:54:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E23F68E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 03:54:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E045140835
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 07:54:42 +0000 (UTC)
X-FDA: 83970556404.09.722ABE4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id D65BAA0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 07:54:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759823681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UK9DiR0wjCbf3kGpNnQN1bHlQo4LZ2YMKJ9Qxm3wCnU=;
	b=5vFuKFfC4fBb6V+YbXyayE7IxIxG6DX7p50sZS4iGl2/KOiMAGlabt6FVCuzoZbWNURBou
	fM7MfWtHTdobgshNyYZaTPUI05RZVwuYHohuJjd+zheqBWog7DssCkAb9qIKatCGSYjhrl
	M2k1jEhqXajI1HgCXTeVLz/rjnwBKUY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759823681; a=rsa-sha256;
	cv=none;
	b=UmMwqF4aArpe7bMgnc1gPvDtxKpFtNKnoAB3NILvz7bupMUvX6NFZp9hjSztf/5mehSx9i
	KqUJRkZpx4hMhrzAB1kbTOhSWicvBjYq8M5iIm9T5n+qCydDUCxtqGaJpjTCP8SW4U/DdK
	ahy+j/Cdv9wWRy1Y/Ltn7sjfgOohl2w=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5098514BF;
	Tue,  7 Oct 2025 00:54:30 -0700 (PDT)
Received: from [10.164.18.47] (unknown [10.164.18.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C305B3F59E;
	Tue,  7 Oct 2025 00:54:36 -0700 (PDT)
Message-ID: <627da4d5-5c6b-4bf4-9544-9021062d378e@arm.com>
Date: Tue, 7 Oct 2025 13:24:33 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Replace READ_ONCE() with standard page table
 accessors
To: Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
References: <20251007063100.2396936-1-anshuman.khandual@arm.com>
 <584fea72-e564-4cf6-9435-ce4b03f2fd65@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <584fea72-e564-4cf6-9435-ce4b03f2fd65@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D65BAA0005
X-Stat-Signature: watxk6ouzj1s65jmbyug8481g1jbwc8i
X-Rspam-User: 
X-HE-Tag: 1759823680-942398
X-HE-Meta: U2FsdGVkX1/7aKA2L1B0y2t7uHieH8Iz0Pum34lB2jJ0JJ213BFcAJjo1nV8cEGaO4QASc54j6+Gs55E9BFm+t6y7Z4obU4WYl64yFyMqNmU8ABZXn0snyhkO8wS+4JmahdZ5kj5XsN3kSIQAO1zv8GGprZwg3eLDrZxSGs2a2dvxhNY3Fr+pHBCGELA6KIgDcjT+gPnffXCxzu1U8CoX6CNu2+UrFQp9cU+CG5DrfUVIbPTgBXz6XqyGeQJSFk2IvhpOzqXv0nH3CTqn6Dj3DsENiCdMULXkkuW9BblVljm3MQR7WqBQaKyfCC9UekQJBoYXwCDqx/42jY9XviT8K4xBj9kC4TDwBjEtaaFQGY/+V5LueFFgGkq7uTvzxFf2Zee7GATguGVp+WgkvL4O0zVoh+Ma8mva+a5r4tfmoPVgbV6gDarVDL2AnK2ghboW1VaX1w1ypUysOtuHLVNBSEKu6mzqdYSLCnUGchjdas1G1KWtj0QmHgfobplPKTCbNPJA3tdYhm+thb+COeVzWkoV1PLAlj24RhqX5wkmLELLsiWA7dwyHwbn9zkUZg3LmmIpOQy+KwRSi+omyy7/5A2z0b1Zy1UPENrqUsirpE+X/d8Aw3d4g4M0IkbQtQDqoWzh+SWCbHaL6xlRI2o+VdkimhgEORXoMTp0zetgZQIU0PG8g5tQlq6Ny3LEeAoo1vCLwaV2kiHF5Ch77eiSNBTxZBWI9+MpFUVh/DnVvIVD4FRC+/pciCGwgzh+adbpXJ0nRwJdP516Z9+BQOS+iPk2dsnTmEbBIlRZQyOpOwjNWTJ73LYdXoonOttGtYWgfxRyYQ7oUfpbRG5GYcxjKPm9l/A899ptQ5iB3GZZ2n1tH4pjvd1yjXk4/p3U/31lE3xxDjnRs6Gu5QSLN526Ya9U9yGqEusm0Xe7VFpx8eox0SN2RcvZD6Y8fIjxicXP2XTTyB2nuQtprSsNIJ
 FUfHsRAn
 eSb8q9LpzYI/zPbyal2ua86Q5TiP2NcQ9sM2qGLg2Gie0MmVUDLjML4NB3xDh5+Hk1GyIH8aBzSmvEQiGWKei0kleGwIHpB2nfhzXpQctWrI1H1Hxb/W+Cb6e79HK+lUU52ejm3ayHJrZKfmqxQA8k5aHWWy052XhVhB51Dnzq39aszUNZQwUAUIATe9Es82TvKqERzxMxkDSdhByOg05wHA0SmYF9rGVcNSUsWp2c4LnaV55ZaYm386aWjMb0HZhkMtwpi5GZkmKylUQP8JcOLhT/SZe0p7jg+puF9WNXSSsIbiQofc+wI0v066cE/em+j10qRcHC8T8pwXyNGjfEb9b6MowFpUM94TBMWe/z9MVwVpQGGAxV9FEuwkNgtW2lDkH1KEKzCCjabHrU4kjzB2Aqj5gOi+wtZs31WeZxWzoHDE1XSzqCTZ7WJe+rEErgS1XRAsKTMlWDK1ZDRwsO2AtLA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 07/10/25 12:41 PM, Dev Jain wrote:
> 
> On 07/10/25 12:01 pm, Anshuman Khandual wrote:
>> Replace all READ_ONCE() with a standard page table accessors i.e pxdp_get()
>> that defaults into READ_ONCE() in cases where platform does not override.
> 
> Does any platform override into something else currently? The way you write
> the description implies that.

That's how the callbacks have been designed to be overridden when required.
> 
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>   mm/gup.c            | 10 +++++-----
>>   mm/hmm.c            |  2 +-
>>   mm/memory.c         |  4 ++--
>>   mm/mprotect.c       |  2 +-
>>   mm/sparse-vmemmap.c |  2 +-
>>   mm/vmscan.c         |  2 +-
>>   6 files changed, 11 insertions(+), 11 deletions(-)
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 0bc4d140fc07..37e2af5ed96d 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -964,7 +964,7 @@ static struct page *follow_pud_mask(struct vm_area_struct *vma,
>>       struct mm_struct *mm = vma->vm_mm;
>>         pudp = pud_offset(p4dp, address);
>> -    pud = READ_ONCE(*pudp);
>> +    pud = pudp_get(pudp);
>>       if (!pud_present(pud))
>>           return no_page_table(vma, flags, address);
>>       if (pud_leaf(pud)) {
>> @@ -989,7 +989,7 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
>>       p4d_t *p4dp, p4d;
>>         p4dp = p4d_offset(pgdp, address);
>> -    p4d = READ_ONCE(*p4dp);
>> +    p4d = p4dp_get(p4dp);
>>       BUILD_BUG_ON(p4d_leaf(p4d));
>>         if (!p4d_present(p4d) || p4d_bad(p4d))
>> @@ -3080,7 +3080,7 @@ static int gup_fast_pud_range(p4d_t *p4dp, p4d_t p4d, unsigned long addr,
>>         pudp = pud_offset_lockless(p4dp, p4d, addr);
>>       do {
>> -        pud_t pud = READ_ONCE(*pudp);
>> +        pud_t pud = pudp_get(pudp);
>>             next = pud_addr_end(addr, end);
>>           if (unlikely(!pud_present(pud)))
>> @@ -3106,7 +3106,7 @@ static int gup_fast_p4d_range(pgd_t *pgdp, pgd_t pgd, unsigned long addr,
>>         p4dp = p4d_offset_lockless(pgdp, pgd, addr);
>>       do {
>> -        p4d_t p4d = READ_ONCE(*p4dp);
>> +        p4d_t p4d = p4dp_get(p4dp);
>>             next = p4d_addr_end(addr, end);
>>           if (!p4d_present(p4d))
>> @@ -3128,7 +3128,7 @@ static void gup_fast_pgd_range(unsigned long addr, unsigned long end,
>>         pgdp = pgd_offset(current->mm, addr);
>>       do {
>> -        pgd_t pgd = READ_ONCE(*pgdp);
>> +        pgd_t pgd = pgdp_get(pgdp);
>>             next = pgd_addr_end(addr, end);
>>           if (pgd_none(pgd))
>> diff --git a/mm/hmm.c b/mm/hmm.c
>> index d545e2494994..126c3f42e525 100644
>> --- a/mm/hmm.c
>> +++ b/mm/hmm.c
>> @@ -431,7 +431,7 @@ static int hmm_vma_walk_pud(pud_t *pudp, unsigned long start, unsigned long end,
>>       /* Normally we don't want to split the huge page */
>>       walk->action = ACTION_CONTINUE;
>>   -    pud = READ_ONCE(*pudp);
>> +    pud = pudp_get(pudp);
>>       if (!pud_present(pud)) {
>>           spin_unlock(ptl);
>>           return hmm_vma_walk_hole(start, end, -1, walk);
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 0ba4f6b71847..50f841ee6e84 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -6549,12 +6549,12 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
>>           goto out;
>>         p4dp = p4d_offset(pgdp, address);
>> -    p4d = READ_ONCE(*p4dp);
>> +    p4d = p4dp_get(p4dp);
>>       if (p4d_none(p4d) || unlikely(p4d_bad(p4d)))
>>           goto out;
>>         pudp = pud_offset(p4dp, address);
>> -    pud = READ_ONCE(*pudp);
>> +    pud = pudp_get(pudp);
>>       if (pud_none(pud))
>>           goto out;
>>       if (pud_leaf(pud)) {
>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>> index 113b48985834..988c366137d5 100644
>> --- a/mm/mprotect.c
>> +++ b/mm/mprotect.c
>> @@ -599,7 +599,7 @@ static inline long change_pud_range(struct mmu_gather *tlb,
>>               break;
>>           }
>>   -        pud = READ_ONCE(*pudp);
>> +        pud = pudp_get(pudp);
>>           if (pud_none(pud))
>>               continue;
>>   diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index dbd8daccade2..37522d6cb398 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -439,7 +439,7 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
>>               return -ENOMEM;
>>             pmd = pmd_offset(pud, addr);
>> -        if (pmd_none(READ_ONCE(*pmd))) {
>> +        if (pmd_none(pmdp_get(pmd))) {
> 
> I believe sparse-vmemmap is only for 64 bit arches so we are safe.
> 
>>               void *p;
>>                 p = vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 674999999cd0..14c2722b955b 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -3772,7 +3772,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
>>       pud = pud_offset(p4d, start & P4D_MASK);
>>   restart:
>>       for (i = pud_index(start), addr = start; addr != end; i++, addr = next) {
>> -        pud_t val = READ_ONCE(pud[i]);
>> +        pud_t val = pudp_get(pud + i);
>>             next = pud_addr_end(addr, end);
>>   


