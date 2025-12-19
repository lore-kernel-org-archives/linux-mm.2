Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52C71D7495D
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 08:25:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B53426B0088; Fri, 19 Dec 2025 03:25:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B00CA6B0089; Fri, 19 Dec 2025 03:25:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E25C6B008A; Fri, 19 Dec 2025 03:25:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8CE2D6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:25:55 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E817140481
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:25:55 +0000 (UTC)
X-FDA: 84235537470.10.A861C9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 714EA20011
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:25:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f0IbDoos;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766132753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5paFhCd2MStgH1s9GcR6Ks0T7xAHLV90aHWEAjX8t+Q=;
	b=uPYH1cwjbcRR/hNObQd1m0EpWPTNxjsAyA+6Xbkx0nFOjzgm20h5+DVEMX5EmxKemcc7ww
	0hYtKN9MuOiH23uJq3yLu5UVqnTAga9TNBdUHh9R7P4ES7Y/3rChMxZvEWExDNTGRxjYwD
	bnz4nnV0S7it9c02dGN5ac3o/Ehr31s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f0IbDoos;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766132753; a=rsa-sha256;
	cv=none;
	b=WGYYw3k1cV3sGb4cxDwo8VZJJNr/L1h4v5ZU9rEzNcT4Vt6y2u+0hKLBCVnzuY4uUb9FQm
	OJfARQBFrKosUuXV9sraU80NRIEcIg2FNF+FlqmIRjRqqLMzmSW6Dz7V+OIDP+PlaJJVU2
	1NnfyqfiiN+qnTsVbXKHn268HrmigZk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 61F5642A84;
	Fri, 19 Dec 2025 08:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870E8C4CEF1;
	Fri, 19 Dec 2025 08:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766132752;
	bh=/RRZ3mRSlbHOY3u6KA/2jGTrq8Qaxhr/c/ozcV+Y+Fk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=f0IbDoosSzUY1ZyRHNqb732zfUiSXMvzWpxfK/unVQgAuPAwYWbNvqyCsfYWR5fit
	 7+x6bgUuA3CtH3n0GAiOZL9xk/LUcL45zYnr8neQPOgJmqRyuHRUXmN9KjwkF4/Em/
	 X5CM7WgFFQ4dCoKXPcyKh4BCKw5LCWWQhw9lRKCo0KAMJ1h2QwhHQq82iaCQMCm0ye
	 wqoEM3v8Sx0pioqN8h1Y0r7hLBMCbHwEstBASeMw6n4X9rlqwiuTd6EnP3fE6I5lXH
	 UlQ48qppsN89wNNrss1UqRXly3H5rtZ6QBQkUOt8ix1v5B1mqVfRl873piLgi80d/a
	 6+kU8A1On/9mw==
Message-ID: <6dcfeb2a-dba6-4de9-ac1b-39312c6bbcb6@kernel.org>
Date: Fri, 19 Dec 2025 09:25:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 3/3] mm/khugepaged: skip redundant IPI in
 collapse_huge_page()
To: Lance Yang <lance.yang@linux.dev>
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20251213080038.10917-1-lance.yang@linux.dev>
 <20251213080038.10917-4-lance.yang@linux.dev>
 <948d425a-2d6e-4439-a280-0ca9e7521b13@kernel.org>
 <6fdf89ee-3f6a-420f-b4d6-b03e3e2c8c9b@linux.dev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <6fdf89ee-3f6a-420f-b4d6-b03e3e2c8c9b@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 714EA20011
X-Stat-Signature: onxpqk9etrnsfr8jw3in69dimb7gfd3x
X-HE-Tag: 1766132753-724532
X-HE-Meta: U2FsdGVkX1+HJmYAlCuJV1ls8IYNeIv4oGA2loiGhoagvpcKZLDhGUCnmWH3NW6dwR+9D1jh+N/AAhSk/ZeuYjnVumdTr+3XbRe+KhRZRNR5A5O75HICuiiq8EDfOfXSO/IHu1K2aZMFt/PTscpdgwqz/KBTl4liRLiSP3Y3W6hDQBuqkLDpvLFUfEKuP0UxbonsF4PgMi6eZzrkoAsrJIiImBvEfBJQYyFBZjbB4Mlni3NBD/PlpaOSr3xo1babjThk0UiyH5Ti3LF9S89XNYl2aN2Qzpez2KKKgp1h/AMxIKqUiU0Q3d8mZjwyTzM1TsOu1E3orwAHaUIg1IwSHDCnNgZxXhOLNY3C9++TfwinFqaksBKhmfqNIFm2YJhCEPwKecDPBPvgix4W43mBZL+PJ0f6Ynwc0aBHpq7w4Dr1sCWUYeg2IOhyuf0hyqeV2f7aAWsOfpV5zcNz8SML3hSenf1GY116fwExtkKxvEG8wuFqaTYXX4v9USdFtN/bH8c2xIqH7nk9WBRVAGC++dRz18j/pB+O/6uG8zddZQEiL5ZA9T4YlcF5Uhs2H1FF/DP4DC85E8oronyXHkoEj3ooecVQCJ4YJ/emDf7ncLgFwjng9XyDxY6KtaGuZklEW3oASTPZ8+vX6FCF7XIcmmWqxbqiyOcOiGG9LCqTRFo46bBmyAT85fEcqfrvEF/UUuGG4kF7uojOym463bhBO7KICwt1ioh1psEfu+Cw+ojCL1SmqHWfvh0v2Ai/rEEUQbAk88Yma1ZgFW+ysUn5aoTpgNq8htQF7OLuIgZyQhFswZEacf6asRELciSLEs7EMD8mpP2lpYBq8pYqT860Wey3iDTQX9kUwJKkHbMvb53Y1xe6VXcIrSgy3yFKWtS50ENOvuH3gpKNqTzL9drXKgIYxNTYUS2mbTbRUIeGGo6o7cUteiauvu01079hS5D9pq/DAtiimQOTxsxf1+A
 yAXyqFWv
 JGAsX9wJIIu2LxtOEdi4QFTBDhWuF/iyReT6mgRrsCLdQH0W81Jo1FfLeXhCzWat+GNJv6Jv3bZvNSg2n2NeuvnJKMFOSobGIdWJqPAi/SGEvHpeTam6uf4xp6hpWMsvks6BrioPcMhGwUpCovAA5rLirm7m0PKYq49MLhss6WArqZph3u9rgYYEQVch1I42DaaVJd3+yS69cjjvBbc7M/kKNiQf3kmORsy2vopEu8mH5Mc09bhr62soQccRNRVof5TnDPHvua5S347qJ5VLbWSl3lTr+LvTb3GUIzqFbkO2AKDbgKUsl8RPpkXiaXtbRCq/D2CBCm0cbw0L1+ZcvGaj3Mt4kxBD/NPso
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 15:35, Lance Yang wrote:
> 
> 
> On 2025/12/18 21:13, David Hildenbrand (Red Hat) wrote:
>> On 12/13/25 09:00, Lance Yang wrote:
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> Similar to the hugetlb PMD unsharing optimization, skip the second IPI
>>> in collapse_huge_page() when the TLB flush already provides necessary
>>> synchronization.
>>>
>>> Before commit a37259732a7d ("x86/mm: Make MMU_GATHER_RCU_TABLE_FREE
>>> unconditional"), bare metal x86 didn't enable MMU_GATHER_RCU_TABLE_FREE.
>>> In that configuration, tlb_remove_table_sync_one() was a NOP. GUP-fast
>>> synchronization relied on IRQ disabling, which blocks TLB flush IPIs.
>>>
>>> When Rik made MMU_GATHER_RCU_TABLE_FREE unconditional to support AMD's
>>> INVLPGB, all x86 systems started sending the second IPI. However, on
>>> native x86 this is redundant:
>>>
>>>     - pmdp_collapse_flush() calls flush_tlb_range(), sending IPIs to all
>>>       CPUs to invalidate TLB entries
>>>
>>>     - GUP-fast runs with IRQs disabled, so when the flush IPI completes,
>>>       any concurrent GUP-fast must have finished
>>>
>>>     - tlb_remove_table_sync_one() provides no additional synchronization
>>>
>>> On x86, skip the second IPI when running native (without paravirt) and
>>> without INVLPGB. For paravirt with non-native flush_tlb_multi and for
>>> INVLPGB, conservatively keep both IPIs.
>>>
>>> Use tlb_table_flush_implies_ipi_broadcast(), consistent with the hugetlb
>>> optimization.
>>>
>>> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>> ---
>>>    mm/khugepaged.c | 7 ++++++-
>>>    1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 97d1b2824386..06ea793a8190 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -1178,7 +1178,12 @@ static int collapse_huge_page(struct mm_struct
>>> *mm, unsigned long address,
>>>        _pmd = pmdp_collapse_flush(vma, address, pmd);
>>>        spin_unlock(pmd_ptl);
>>>        mmu_notifier_invalidate_range_end(&range);
>>> -    tlb_remove_table_sync_one();
>>> +    /*
>>> +     * Skip the second IPI if the TLB flush above already synchronized
>>> +     * with concurrent GUP-fast via broadcast IPIs.
>>> +     */
>>> +    if (!tlb_table_flush_implies_ipi_broadcast())
>>> +        tlb_remove_table_sync_one();
>>
>> We end up calling
>>
>>       flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
>>
>>       -> flush_tlb_mm_range(freed_tables = true)
>>
>>       -> flush_tlb_multi(mm_cpumask(mm), info);
>>
>> So freed_tables=true and we should be doing the right thing.
> 
> Yep ;)
> 
>> BTW, I was wondering whether we should embed that
>> tlb_table_flush_implies_ipi_broadcast() check in
>> tlb_remove_table_sync_one() instead.
>> It then relies on the caller to do the right thing (flush with
>> freed_tables=true or unshared_tables = true).
>>
>> Thoughts?
> 
> Good point! Let me check the other callers to ensure they
> are all preceded by a flush with freed_tables=true (or unshared_tables).
> 
> Will get back to you with what I find :)

The use case in tlb_table_flush() is a bit confusing. But I would assume 
that we have a TLB flush with remove_tables=true beforehand. Otherwise 
we cannot possibly free the page table.

-- 
Cheers

David

