Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30EFECD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 04:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E58906B00CF; Fri, 26 Jun 2026 00:04:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E099E6B00D0; Fri, 26 Jun 2026 00:04:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD1F76B00D1; Fri, 26 Jun 2026 00:04:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A1F256B00CF
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:04:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 06883C1AAF
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:04:08 +0000 (UTC)
X-FDA: 84920720976.20.F932B9D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id D1648100002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:04:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=o+AR3peA;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782446646;
	b=ZeuVI5qAff6ER/7JDZyMAuSnAifkZQ5WaOClw9GrW2c7N75KAnSkfJe48B6nucM5NKsfog
	RXsLXsNecKdh4l6m3aywhnYQFk7eY6IlEO4P2zrhFCOU7uZSDHNjNWbB9Sau8kJ6+U6jEw
	C0CHAw6akW+A15PEShpKF6jrZNfe7TY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782446646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3o5ZiY4fqqe8aO9h1AsI8L/ZSrCUzfYlgFfBNdrkGoM=;
	b=Dg1iBDxzGBekkfwcJGhlgs7xVJIe6Z6Zqhke865O9LArMRSbAvZzUiEzhXGYepMXu51cyc
	M42CN0umkwiIglzI/9PYBSqm2XS0Zp6w7FQPzg14au2GlIjknnKhbdYSTg8AdiuIw/ZKuP
	OnDe5Us9zz8dTx5Whteu4ydmff2EzCc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=o+AR3peA;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F4E522F8;
	Thu, 25 Jun 2026 21:04:00 -0700 (PDT)
Received: from [10.164.148.34] (MacBook-Pro.blr.arm.com [10.164.148.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5EEBB3F905;
	Thu, 25 Jun 2026 21:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782446644; bh=qyp2lulHzizESS3VvJ7MUIf08zH9IfJSzEnsUhYQo1I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=o+AR3peAt7q1C40S6W9MFppuxdb25CQLrAWrtR13P67RSWbzktHKG5lZr8q7a84lq
	 wXTAJUGfJaxcfotOWBWHCI3yYbLBuaBROgfdM4EpzGrwrqycBu5myzKUrHNm74dPhl
	 OdlvlXwuj66UdCC8fFH6txyGOC040Gj+OZQvifGI=
Message-ID: <4619650f-28b5-4fb4-91be-50daa0b4d84b@arm.com>
Date: Fri, 26 Jun 2026 09:33:45 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
To: Muchun Song <muchun.song@linux.dev>
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcampbell@nvidia.com, apopple@nvidia.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, mel@csn.ul.ie, nao.horiguchi@gmail.com,
 ak@linux.intel.com, j-nomura@ce.jp.nec.com, pfalcato@suse.de,
 dave.hansen@intel.com, tglx@kernel.org, jpoimboe@kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com, stable@vger.kernel.org,
 osalvador@suse.de, akpm@linux-foundation.org, ljs@kernel.org,
 david@kernel.org, liam@infradead.org
References: <20260625112955.3254283-1-dev.jain@arm.com>
 <20260625112955.3254283-2-dev.jain@arm.com>
 <f8516534-3b18-4988-b384-251225755285@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <f8516534-3b18-4988-b384-251225755285@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D1648100002
X-Stat-Signature: o4nwbpdx4qcbxenyeempkfqf1yhqyqgh
X-HE-Tag: 1782446645-884502
X-HE-Meta: U2FsdGVkX18gyPyR33SzoRrrxFoO01m74/eKn8ewbyQxufZiHlEJNP66fY6onXKc3LkofEofAYatwZG4bu0OGfR66G8bRB7Hd9DKE2ABmxrqveNofGj79lmJmq46SuuM7LG/ooxo8NEtwYp98TqQveMAkWcOw10rRfHRLf6fihCHROR7A6B5i9Ez2/gXqbmAxRH4uPTWJKjYra5srQTLV7h8CU1gWGd3Jg/ymcA0Q4iqS9JR4SeyqbT/EE59u6Pj1mCtWxxhIkFXkPR5rs+Det5ONGc1Tqgifan06ZBkjUWOEWQoxFYtCZfWFK9Jvgp3yubepZ+Ofe4xq+m08tWsRPlOAZuxJJweFGFkP6vFbokcFj+BkLlbJe9nntPixs/ui/gvzFyvqqgNZHTzwgdo3ldIr6Y1dr+r6FbpQOJ/4mjY35efxcRreSjuJHY1dnSzCmK3OoRpOEibeb+nBPPk9pyyyyHrLxZDKduYPCZEbYHhipgKIgSaxmv4pyF24iJcmW46oWdHHUbWqVvAQ9UlYW4ruQKjfT5uBr40gqZ5L/NgSAM6Qr5jCVvPNBlWDg4Bs/acI19lDkVP1wOQIcqxZbQDWL+KPFWZJrvoCOpOacvAZU7OrhIisiNNjr6jkdZBEKX363wyodjG7B3pM3YDMjJnQkd+540Fb0MXg1EF4lFyi2hEXLmB9qH1pffxjJ5bxzPeN5uyk2IADWHjwvOzY1gUWerQvcKiZ4iNRljqRunD23NKCSTK1vGcHRS74j4/02ySV9SAWPwXU+sIj3UylNl+4shFc9KKSX+dX0O24pW2yz8fspGR874p8rHgqpIBnGS7XTzAMnjlBuxLkrGeAsyEIMp4l99aPEP5OjjQRz7F5rH9HWf0bPZeG1E++nWeoRQCd4GM75CmI8rcu6dmfOsIFp1NqnDTGuFRnBgDY4q2qB+iz943XyKyYmK8fJMqLDMBUCtiOzfC2eyjRyM
 0f4I6OtL
 lmkg6YkqKBE3BX+FIzMWQZHiEFhr0gXhnEdTd5GRGU8J7HWRzP54ucNKYlZz2Mqglqu4tIlIM/241+WkAZZEZAm8ywwoiFA2qMWIFDoS+ELVgEg/KQKfMZwKGuEF2tKS9q13s2SRWtId1CCQHIvm6ALLltyGVEpRSBwdNDMLAnbuKASnIDQpawPGlmTG0fBy3IHhrpMuFPusNG0aDYlZntaF9WRfgnfLsgmNo8Bnh3shTdiCXxBpQoaef61mO5RH4XXGLFpkOyUYMMvLifuyXdsaTO3TfMZvu1jZudpbpPQd+BxrfC3jxwCPcIUZJquorUhOLdSnsDxlFW6dgfenV5iWvBPoy0VYVsSjxpEVzZNzlPptBZijJgkDS3/1NeIHFP8rPC78MqJehFhgC9uX9yf/CllbwqUDeA55e7FNo6l8OXMIgy5jAksA4mB3L0lymVKI7Z/rS3iLMiOk92saI9ddP6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/06/26 8:47 am, Muchun Song wrote:
> 
> 
> On 2026/6/25 19:29, Dev Jain wrote:
>> try_to_unmap_one() handles hugetlb folios when memory failure needs
>> to replace a poisoned hugetlb mapping with a hwpoison entry. In that
>> case page_vma_mapped_walk() returns the pte pointer to the hugetlb folio
>> in pvmw.pte, but the code reads it with ptep_get().
>>
>> On arches which provide their own huge_ptep_get() to dereference a huge
>> pte pointer, accessing via ptep_get() would cause pte_pfn(), pte_present()
>> etc to misbehave.
>>
>> It is not clear whether this has a trivially visible effect to userspace.
>>
>> Just use huge_ptep_get() for dereferencing a huge pte pointer.
>>
>> Fixes: c7ab0d2fdc84 ("mm: convert try_to_unmap_one() to use page_vma_mapped_walk()")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>   include/linux/hugetlb.h |  3 +++
>>   mm/rmap.c               | 16 ++++++++++------
>>   2 files changed, 13 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index 2abaf99321e90..fdb7bdf7645c5 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -1261,6 +1261,9 @@ static inline void hugetlb_count_sub(long l, struct mm_struct *mm)
>>   {
>>   }
>>   +pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr,
>> +            pte_t *ptep);
> 
> Thanks so much for the fix! I'm curious, though: why do we
> need to add a separate declaration for this function here?

For !CONFIG_HUGETLB_PAGE, compiler complains that there is no huge_ptep_get.
So this is to make compiler happy.

> 
> Thanks,
> Muchun
> 
>> +
>>   static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
>>                         unsigned long addr, pte_t *ptep)
>>   {
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 1c77d5dc06e9f..aa8a254efaecc 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2095,11 +2095,16 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>           /* Unexpected PMD-mapped THP? */
>>           VM_BUG_ON_FOLIO(!pvmw.pte, folio);
>>   -        /*
>> -         * Handle PFN swap PTEs, such as device-exclusive ones, that
>> -         * actually map pages.
>> -         */
>> -        pteval = ptep_get(pvmw.pte);
>> +        address = pvmw.address;
>> +        if (folio_test_hugetlb(folio)) {
>> +            pteval = huge_ptep_get(mm, address, pvmw.pte);
>> +        } else {
>> +            /*
>> +             * Handle PFN swap PTEs, such as device-exclusive ones,
>> +             * that actually map pages.
>> +             */
>> +            pteval = ptep_get(pvmw.pte);
>> +        }
>>           if (likely(pte_present(pteval))) {
>>               pfn = pte_pfn(pteval);
>>           } else {
>> @@ -2110,7 +2115,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>           }
>>             subpage = folio_page(folio, pfn - folio_pfn(folio));
>> -        address = pvmw.address;
>>           anon_exclusive = folio_test_anon(folio) &&
>>                    PageAnonExclusive(subpage);
>>   
> 


