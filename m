Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 043D0C43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 05:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95A396B00FE; Fri,  3 Jul 2026 01:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90BF86B0100; Fri,  3 Jul 2026 01:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F9EC6B0101; Fri,  3 Jul 2026 01:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 56E956B00FE
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 01:30:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0B9EC1FE5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:30:23 +0000 (UTC)
X-FDA: 84946339926.30.86B3D7B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 06A014000A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:30:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YtDDG9+n;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783056620;
	b=00AJxxXDBPo/lKB2n7ePoOUaUozqrmVFWwj7b8spTQzGZ3pKwTCbRg2+kvOUtmkPaMUZg3
	jCmHN78rrxOH5R7YUuhiLELoQYMRQuCkpdSmBwGH6o9E6V4e0806/ykCxtZWRO8TeFJTgI
	iq4RYJwNkhsFsFsbmFLJWocZMX/q8Ao=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783056620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V4iIBY89FDo1UzdzB/uBcAQK/RPNiJ0sNDuJsScMG6k=;
	b=vjQ72cMEYyjYBpz8BlT7KXika1UzMwwEO50fbXtffzwu4cXAsQ/p75xJTjOw7qJH4ekwZg
	9WmoVD+QsSlREmz84f7+QEMntYEB67r4WQcp+l1JLp+Qgw6m52uJCKkomLEDOoB4+nG1IG
	e+blbaA66OFd7WKlZ4xL7ogAz8W9bHI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YtDDG9+n;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22BD51D14;
	Thu,  2 Jul 2026 22:30:09 -0700 (PDT)
Received: from [10.164.19.15] (unknown [10.164.19.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C07E3F673;
	Thu,  2 Jul 2026 22:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783056613; bh=UFr9Wdq1njDGvt6poz4+T8rHJby7UnZmUIqtj/UdkVQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YtDDG9+n6E2IK/NpzkunB8X0k+Xu7zlG2Mf5SenOvVidxgMMYHZg26V+CGrvrecH6
	 Phd+lP85qg5BeenR7AD3hjvJsYiHZNu7FLsqlY3Hi9oaCyU7BotAHiGSuPCbr1ubOC
	 BlLtVt9t0QMmj5jX0Bv5+rJ7pk5lVZwwL53kf6vU=
Message-ID: <1b1f6281-2a46-4811-bbea-24a666c0a772@arm.com>
Date: Fri, 3 Jul 2026 11:00:01 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
To: "David Hildenbrand (Arm)" <david@kernel.org>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcampbell@nvidia.com, apopple@nvidia.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, j-nomura@ce.jp.nec.com,
 nao.horiguchi@gmail.com, ak@linux.intel.com, mel@csn.ul.ie,
 pfalcato@suse.de, jpoimboe@kernel.org, dave.hansen@intel.com,
 tglx@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20260702051341.126509-1-dev.jain@arm.com>
 <20260702051341.126509-3-dev.jain@arm.com>
 <00d6e0fb-dcba-45d5-98c0-f5ed81604ca0@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <00d6e0fb-dcba-45d5-98c0-f5ed81604ca0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspam-User: 
X-Stat-Signature: j6tfpdkoqwc8usiikoxf7u3w8kk44pox
X-Rspamd-Queue-Id: 06A014000A
X-HE-Tag: 1783056619-550146
X-HE-Meta: U2FsdGVkX195e3lWSDxKiHsqMJgK6gnOxXnsD4VZNDQKcL5Dm3AHoFjIEyUdGXTB/tdQI/dmSEVYM60v/gbpJSHGKQ8uYuDQijQQSKf5m3uEc2AsU4prtu5L2yXcol69aYGvN8RJSDoHpja7X+i81fSQOzyvc/3dlNaCTzv9i94D3NePrz+Otlxb60bY97Y6qFgjNmhdyVy+3ivGMVqgs8YOQ90jRoI57G255RU5o5Oia/Lxan0AZH7KT8Fr0Xc3mHlu9JfPN3QVduz98mMOKnhHSQZRdzSMiEHSz0XpxREhBe3yGRoVIbIDYvRAWh1YPOHG90HxqWKCXXh1Go4UpYampmSkoz/wMmuCM2rk3o7dusGnv2xMfsxOq95nq/BK/1yBafIETT4I+NLyiQrJbweEg7jAWX0li/CrOSuxgBvCy/BHv7uwHzF/yspwdRja9XP+rC6vBaFr4fz/WokxiE8Kuw3jW8ypvz0vZm4RmnEbKs1tTJM/lbK3WU3GnCVDC/Kg2ImrBVDS7IziiFLsWeHTBKWe44GpKWFaDWWMDpbhqpNXmUXn2qBJ2q8W80Ps/Un0wbuUtRex5O5zeaJhgwcM/VfnhFA4QzVhY6VGNdEtDqHU9oWDLlv+ocNGe6ubKnVvt5MkUX2tlEJvueUYu1KsXYCi9tqyAVwrV908pQKBQdSWNWnEgDb8B/4jPY3qaX08YdUq4th5+mnKywL5Gz+FnwnQ2lmaP4yFGyOZCb/2nEAwHwmQl0HrzfgvkRloeAdOKRMa+KBA8hZdvwYRYg8PwlPFx7BYFFzl7jsvsTlwYDjrdamzAAdXMdXRxAionKeWHzGeyJjdAsBAOfxoW7sxBFoJ/183XlyqUwpJgZrhvY24NZdYbTMZrz1IKiktaIhm262BJwA6xwWS6b4KdKU3yRs8w88ZbvjnDBYAzqUrfHkzI2UrwDzUVsIPpHiiEkhz5ibIQC8lQf9GVYv
 ttup16r6
 j+9SrRPMhZ6bly5Z4OOZ4RNmDTkt5yAwdaX1YX+z2MUOpKDs39WYAvrBtbE/ZOPEqoN53tQ7z6om3vaUysn7xjVmD93+QCNLGWs/uaLyXMXKb/GiLi0js5uiSwY9GMXhKG9u3icqZARYB36K3cOtcsAUj9dyfhW2Qulk+Uw85oubFVivGZJYht6twKosw2PhOGeS9kAY50nVUR81EvOhYJsoYo9HIqEfoIcvWk5Sw5HWjHRZl9QF+HgQIb4bEoE70P3XvS7dPmTVHcNHoz/0ZX7YrniXMaUXKMFJe4XEu+DNy3EzUiAenp4DK02zq1KF6lndqIOSCVAcmr9su9fripTiZT6ABhAfIl6NqJKFiBVy2dtcwaSzcjdVqxhM1C3pUNJ5HCKVGo9r69C2haoUBC4HLZNCOmc7y1QoMeon1/J430OyvbdR1hmbWyoLdEwMtqrvG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/07/26 9:02 pm, David Hildenbrand (Arm) wrote:
> On 7/2/26 07:13, Dev Jain wrote:
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
>> Reported-by: David Hildenbrand <david@kernel.org>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  include/linux/hugetlb.h |  3 +++
>>  mm/rmap.c               | 16 ++++++++++------
>>  2 files changed, 13 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index 2abaf99321e90..fdb7bdf7645c5 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -1261,6 +1261,9 @@ static inline void hugetlb_count_sub(long l, struct mm_struct *mm)
>>  {
>>  }
>>  
>> +pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr,
>> +		    pte_t *ptep);
> 
> Two tabs, or just in a single line.
> 
> If others prefer a stub, I don't care. This here is shortest to let the linker
> bail out.
> 
>> +
>>  static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
>>  					  unsigned long addr, pte_t *ptep)
>>  {
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 1c77d5dc06e9f..aa8a254efaecc 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2095,11 +2095,16 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  		/* Unexpected PMD-mapped THP? */
>>  		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
>>  
>> -		/*
>> -		 * Handle PFN swap PTEs, such as device-exclusive ones, that
>> -		 * actually map pages.
>> -		 */
> 
> That comment now actually belongs above the pte_present() check below.

Oops I mindlessly just copied the comment.

I will then rather put it in the else block which gets the pfn from the softleaf,
that is the most appropriate.

> 
> 


