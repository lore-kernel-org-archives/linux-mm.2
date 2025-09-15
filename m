Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A510CA0EE8
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 03:02:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83A538E0002; Sun, 14 Sep 2025 23:02:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811508E0001; Sun, 14 Sep 2025 23:02:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74E018E0002; Sun, 14 Sep 2025 23:02:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E83C8E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 23:02:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D50BC1A03AD
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:02:26 +0000 (UTC)
X-FDA: 83889986292.08.E00A11D
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id B073E20005
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:02:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G+Uo7hGn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757905345; a=rsa-sha256;
	cv=none;
	b=g0MWL1n2WhOYJjWR8fagqtpw94BheUVpOqZmOL1KD66XEicWXyLzLLoVMlvJKayOM4vStl
	EiVTS7Wlaa7HSAydXI5HrHLYaQtvurq0hylqRBr9WEZ0M4ZYoHggbP7B4L+5vIMYk+WPrb
	6y08Y2MXG7hDTZr2qPplqHF5mhofYrs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G+Uo7hGn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757905345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AEcarrc2+8ifIeyobydV/xFWrr9hTTutZzw8IUFdV5g=;
	b=2Hk95BNZwg6yoyJmZwiOkCDhTyA8A8a+tJnUQU0bfKlrkG2zDUxDfgWiDIaWSHh7E33m/z
	w5bAbbca7RtcBA80NNgDvDPegqMvuV6aPmVdcdMN+hxfaAL61hI0+LnX6T6/8gJkGNMLSj
	m9GN7ZvPIhrtm/tQ5vh3GLGN/mFHMUw=
Message-ID: <016e4d4c-c16b-45d5-a903-681afc6b4203@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757905341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AEcarrc2+8ifIeyobydV/xFWrr9hTTutZzw8IUFdV5g=;
	b=G+Uo7hGnDZ1c7SlCcAmx4kxesEfclvRm6kNBIYrJE2rjg3psEjvldYdQdL9oVfBxFTYnNl
	WYaVn1GJPmFzlifBpSeZ4jQIFuR0DifF7W2B6vUMRS+GttAoEuRTTlvsp9ZRnkG9uKkt0V
	V8wD95ttVwwTScYDc30lsKlVEFeL++w=
Date: Mon, 15 Sep 2025 11:02:14 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new 1/3] mm/khugepaged: skip unsuitable VMAs earlier in
 khugepaged_scan_mm_slot()
Content-Language: en-US
To: Dev Jain <dev.jain@arm.com>
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, david@redhat.com
References: <20250914143547.27687-1-lance.yang@linux.dev>
 <20250914143547.27687-2-lance.yang@linux.dev>
 <a62b7461-3faf-494c-bd00-0206de184a5a@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <a62b7461-3faf-494c-bd00-0206de184a5a@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B073E20005
X-Stat-Signature: amgcrprsk5c8tmw5acq56zu33n5cwr78
X-Rspam-User: 
X-HE-Tag: 1757905344-150169
X-HE-Meta: U2FsdGVkX1/pOFbbbcwmNr3RYvxKFavCe36+S+JFWYKozyde8jqZNskKJm11q3Z94SYjvN+xG4D5f/i5Sj/YjPLup8nf1lN8jtE3zr7+g8mqeYszlQrvJIVe6PmJptn1Gy4I1vAmeJE1bF5UGteHoApgZXckrY4NjWeH71szW7F8tLrY7tiN2Wzmb2QxZiSYmX3oqsB4v7kVfhQMLt+Ib8ZaBFI3e13x5EcxKNBJB8A4mE+kVj2fGG2Ar8xo/Pw00PpYBPC8Z/mwUxfdN6+N8Wmhky+WW4lD2qeKYgCF06loYul10mrB2lAOpjW1M2ZghFwmLfSgo1wWUl4HYgUydy+fQBYWITRmm+sckoASpcK1FCqsZua4Xuf58pmyapsuAq2pUwqAofow8je/CRcMXsEWQu5C9SmCZQiZeOTk/iifils6dFqMfu1ZxyXJ9YVhLd392EYh4L7A63wLFFilNu+hhZ70MY5ET+ChI1dfU0p/n0zWGJFlIZR1PVzaR7qTmRV4Z+R5z4cbWIllEaCn97OtC66w+1NI643grg6ZOhR+JpYhvFxz8ZcTUcqwpmdxSiq+DxjM32NDrjFWzxyFlrOqed+9UJkaGfFG99jqHGKV6llK9LADmh/cgZHkYia8diHj0SN9DwRsGawsf2y09C2k+eqnn3frVhM4aoKBotazOWvckc7QoLSL8OqcdgasGuSvdkcsmUjlFkwOLhQERVwne9dk83BV9NKTYLZQ8e/7dVoD8LqF8rICvymqdnXlV4/h2JrrGZjUH9uAfOkTwx4PIRhZurdKV5hgJMzPM75MhiD9C0uJIkeGf2dfCZPmX5sRLIe8KM76s6CI6lRpFSV6i79ztaidBsDLGfYtRr93gc+2KC1zChx1dKxL67STBvDZphlQf1c//QiqngxsCodMMMfPyxyxDyCkjhKbanJjupg+7UIoZxbhjoDEDIGL23if3Ppau2Or+61PA5L
 KrHp+ajM
 HNyJmrRyMCR78eZChkJeugk/QPkb9a0wOC9lKjLEpO0jAZw7zIWqI73OM1yPTz7ZkDp3ionQ6xUCPqN9QRLCzHoVVBU7kA7BiOGx9R1rsOEaQnvYp5MHGZO1tkla11Km3PONR86N2WCcozCxY5MvbF3AM3IhzHd35VrOPKXADuysNHdsvnJMGEJGba0o6055rv+CDX5E+BF+KeNTw/jtqa786/ir4sdeuwy2/lOIU1jhypK+HxjjE2Yv7PIb6Zlb+qzoRG/8qeLkzMaizocdPHT51H0KrBBvuQ2vmyzQsa8ce2j0qUox1dRdB6I2806ZC/ckt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey Dev,

Thanks for taking time to review!

On 2025/9/15 00:16, Dev Jain wrote:
> 
> On 14/09/25 8:05 pm, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> Let's skip unsuitable VMAs early in the khugepaged scan; specifically,
>> mlocked VMAs should not be touched.
>>
>> Note that the only other user of the VM_NO_KHUGEPAGED mask is
>>   __thp_vma_allowable_orders(), which is also used by the MADV_COLLAPSE
>> path. Since MADV_COLLAPSE has different rules (e.g., for mlocked 
>> VMAs), we
>> cannot simply make the shared mask stricter as that would break it.
>>
>> So, we also introduce a new VM_NO_THP_COLLAPSE mask for that helper,
>> leaving the stricter checks to be applied only within the khugepaged path
>> itself.
>>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   include/linux/mm.h |  6 +++++-
>>   mm/huge_memory.c   |  2 +-
>>   mm/khugepaged.c    | 14 +++++++++++++-
>>   3 files changed, 19 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index be3e6fb4d0db..cb54d94b2343 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -505,7 +505,11 @@ extern unsigned int kobjsize(const void *objp);
>>   #define VM_REMAP_FLAGS (VM_IO | VM_PFNMAP | VM_DONTEXPAND | 
>> VM_DONTDUMP)
>>   /* This mask prevents VMA from being scanned with khugepaged */
>> -#define VM_NO_KHUGEPAGED (VM_SPECIAL | VM_HUGETLB)
>> +#define VM_NO_KHUGEPAGED \
>> +    (VM_SPECIAL | VM_HUGETLB | VM_LOCKED_MASK | VM_NOHUGEPAGE)
>> +
>> +/* This mask prevents VMA from being collapsed by any THP path */
>> +#define VM_NO_THP_COLLAPSE    (VM_SPECIAL | VM_HUGETLB)
> 
> VM_NO_KHUGEPAGED should then be defined as VM_NO_THP_COLLAPSE | 
> VM_LOCKED_MASK | VM_NOHUGEPAGE.

Yep, it's a good cleanup ;)

> But...
> 
> I believe that the eligibility checking for khugepaged collapse is the 
> business of
> thp_vma_allowable_order(). This functionality should be put there, we 
> literally
> have a TVA_KHUGEPAGED flag :)

Good spot. That's a much better apporach!

My initial thinking was to keep thp_vma_allowable_order() as generic as
possible, avoiding specific checks for individual callers ;)

BUT you are right, the TVA_KHUGEPAGED flag is only passed from the
khugepaged path, so the compiler will optimize out the branch for other
callers, leaving no runtime overhead.

Will rework this patch for v2 as your suggestion!

Thanks,
Lance

> 
>>   /* This mask defines which mm->def_flags a process can inherit its 
>> parent */
>>   #define VM_INIT_DEF_MASK    VM_NOHUGEPAGE
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index d6fc669e11c1..2e91526a037f 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -134,7 +134,7 @@ unsigned long __thp_vma_allowable_orders(struct 
>> vm_area_struct *vma,
>>        * Must be checked after dax since some dax mappings may have
>>        * VM_MIXEDMAP set.
>>        */
>> -    if (!in_pf && !smaps && (vm_flags & VM_NO_KHUGEPAGED))
>> +    if (!in_pf && !smaps && (vm_flags & VM_NO_THP_COLLAPSE))
>>           return 0;
>>       /*
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 7c5ff1b23e93..e54f99bb0b57 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -345,6 +345,17 @@ struct attribute_group khugepaged_attr_group = {
>>   };
>>   #endif /* CONFIG_SYSFS */
>> +/**
>> + * khugepaged_should_scan_vma - check if a VMA is a candidate for 
>> collapse
>> + * @vm_flags: The flags of the VMA to check.
>> + *
>> + * Returns: true if the VMA should be scanned by khugepaged, false 
>> otherwise.
>> + */
>> +static inline bool khugepaged_should_scan_vma(vm_flags_t vm_flags)
>> +{
>> +    return !(vm_flags & VM_NO_KHUGEPAGED);
>> +}
>> +
>>   int hugepage_madvise(struct vm_area_struct *vma,
>>                vm_flags_t *vm_flags, int advice)
>>   {
>> @@ -2443,7 +2454,8 @@ static unsigned int 
>> khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>               progress++;
>>               break;
>>           }
>> -        if (!thp_vma_allowable_order(vma, vma->vm_flags, 
>> TVA_KHUGEPAGED, PMD_ORDER)) {
>> +        if (!khugepaged_should_scan_vma(vma->vm_flags) ||
>> +            !thp_vma_allowable_order(vma, vma->vm_flags, 
>> TVA_KHUGEPAGED, PMD_ORDER)) {
>>   skip:
>>               progress++;
>>               continue;


