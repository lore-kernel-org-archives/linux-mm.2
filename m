Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66A49CCA471
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 03:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC16C8E0009; Fri,  3 Oct 2025 23:06:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98FF8E0002; Fri,  3 Oct 2025 23:06:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD5ED8E0009; Fri,  3 Oct 2025 23:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9EB838E0002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 23:06:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F6BD8820D
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 03:06:19 +0000 (UTC)
X-FDA: 83958943278.23.E24F759
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7C482180011
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 03:06:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QFiiD5fQ;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759547177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PXNNFB9m2tpLPVfzBH/OyS3UoK141cw9zK+ucGD3NqE=;
	b=HOO/CU7KcoiJourn6b5iPY7q2S+pzO1SWfLGArJ7PohjRxj3yaBWvVLVbIl8z0yFSeEB+c
	9JcdlB+3zm+Eoy57swUr9U10s+NYyTMdjUeLJ5J4K9JzdJbCdwr9+Y55NVZKRq97h2W4OA
	cfj4/qgSzWEuXaikUrsuURwygJeV34A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759547177; a=rsa-sha256;
	cv=none;
	b=1KMkDyCClYqKSc3n5ljGKNsTVbl6msIE1gquhU5pT0wH49hqjyUlGtAH36cCQGJGXT4YAc
	7mfYRTWEpz1uXRaJrDkj/+nkqRncMPR7FkA9PV2+6hmuMFmAAO8p69cHURZX7u3KHjjZc4
	GDWGsJMy/vwvaPMM+YOr6EpY8u7PG6Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QFiiD5fQ;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <b2d2f634-c587-4639-8191-8d74357fe8fe@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759547176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PXNNFB9m2tpLPVfzBH/OyS3UoK141cw9zK+ucGD3NqE=;
	b=QFiiD5fQfK8Dx7oW/mtMnx22p7DIXuSnRzi9FM6gwKqugyl7A35FGw56L/dJgRpG2TgTXT
	aGtDUze/msQHXXHOCfRz7nNPrM49gbEwx16cXMq+1VT1oWJUyDDPcR3g0uw3T3VHVA2Td9
	3osGwZBkPG/d+s1POuCdUAQvCZEcSyU=
Date: Sat, 4 Oct 2025 11:06:02 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new 2/2] mm/khugepaged: merge PTE scanning logic into a
 new helper
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, richard.weiyang@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251002073255.14867-1-lance.yang@linux.dev>
 <20251002073255.14867-3-lance.yang@linux.dev>
 <9DF437D8-E98B-4061-A8C7-521D89070C97@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <9DF437D8-E98B-4061-A8C7-521D89070C97@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: wfmu4tr9ruh4wyo3zexuhydydsibat3z
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C482180011
X-Rspamd-Server: rspam10
X-HE-Tag: 1759547177-124041
X-HE-Meta: U2FsdGVkX1++As4adq61bKmRGGQp+dMG62ISDTQzQVVKtbTDB7X3d/t/jy/TIw97y+oGCUhX6vBUq19YwKKKuPIvBeCUDW6bg69cO0Z23JDtAPwAAEQXVqhGt/cYIe4WyLFpcVzuZha/A6Rxj9xPrgzwu5Ts4f4hv3NLntWX/e60cASlygk2KXaR24z3Vq472390N8TaNC6c2izTXtQX0zO2EmxNY5ue5myRugdK66XUNVqnJ5FFjS/FNod4p0KkN2gq/UYbaDlcecjTfnkgXlEPs6WNZv+RY2HZDqU23o7Hxf5NH6WXdaN4YaPNkW6cPJM/6ClOXfH1gzn2jMg90lxJkyjjPvQP4mUQ/KncJLtebonl04jog+0Ijb22/WMBmQ+uawDRxkDnaowq6Byh+Mi5CmSPa+97ft5Etxw2IXCd/nRLKDT6y17fD1UyqfjdCBpCqKKjABgItWqiDIcC4LisNcJ5dllqTDioO7G6Qr79D2Fhzw60eGUkSzKTy1375VYG/wRnn2CDR7qkzhLXeHiG/XVL1Awnm+A477uL5oLd5dWC0t62J9AgIWrNdDikeFyjquW0iPh1KMZ0LpjA6N6s0sTwftcHy5icq55hftKy1nh7X91ZXJOcCMqwF2vE1EUkhXL0tuRdOcUtVFNl0xaNMWFPv9ZhHI+xFW1ahiHsJ5iXg6ddXPBtzr8izDQi08VMowdfgR6kkomTng2o95JzHPs+YwQxhP10Ffr2CfyVSHQdQ6EsCcUxwOoZIcue6he56CQSYy5s6bCubVRcyVp+zj9DKknnEvOv9T1SIQ6tepvXDqfwbeoAOL2+LFFQMYueAKQ2ELRxtN8GlZqvgRHJ6S9yqIulaMt1xYb+owmC9j05rUXAOYXsxc/c451MnNRoAR/Skd2S60xboT2qfxbe5Eaaajh/SkCmmP9kIfDMplN1jiZjoG4f/fIlHpmBnrFV8pFEI7c8y+yUTJ2
 FMYZxsMz
 jblCdvsjj3i5N2ghRIG3m8zI5qc0nrIrFHBpYOrj4FvV37V9jnifbaLsp2GjpTbouclkqz9QLIdJvPHo2tTzKJEtNxLDcXTpk5JrhGl9x10jKwJmBxlzquPYw6341KxHY6vpjI7Uxxte4jA87nOcms4vqHt+bdhc5S1X3N4Gof69TklmoJodfaKWPabVtuhRJWqRLBQozER706DNZVNQ9q7z92l5Is99Cl+wRD6263uqy+wz+N+ksB1lO1PacjUnhdczvYW9amvRIEZO1d/ofqowWDL0/Sk8BH9Q+QNzrdKYm5eh+YcTvGGF+Aevaox7OytBcbCANyhJQ9sVIs8C5uoeolQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/4 01:11, Zi Yan wrote:
> On 2 Oct 2025, at 3:32, Lance Yang wrote:
> 
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> As David suggested, the PTE scanning logic in hpage_collapse_scan_pmd()
>> and __collapse_huge_page_isolate() was almost duplicated.
>>
>> This patch cleans things up by moving all the common PTE checking logic
>> into a new shared helper, thp_collapse_check_pte().
>>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   mm/khugepaged.c | 167 ++++++++++++++++++++++++++++++------------------
>>   1 file changed, 104 insertions(+), 63 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 808523f92c7b..2a897cfb1d03 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -61,6 +61,12 @@ enum scan_result {
>>   	SCAN_PAGE_FILLED,
>>   };
>>
>> +enum pte_check_result {
>> +	PTE_CHECK_SUCCEED,
>> +	PTE_CHECK_CONTINUE,
>> +	PTE_CHECK_FAIL,
>> +};
>> +
>>   #define CREATE_TRACE_POINTS
>>   #include <trace/events/huge_memory.h>
>>
>> @@ -533,6 +539,87 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>>   	}
>>   }
>>
>> +/*
>> + * thp_collapse_check_pte - Check if a PTE is suitable for THP collapse
>> + * @pte:           PTE to check
>> + * @vma:           VMA the PTE belongs to
>> + * @cc:            Collapse control settings
>> + * @scan_swap_pte: Allow scanning of swap PTEs if true
>> + * @none_or_zero:  Counter for none/zero PTEs (must be non-NULL)
>> + * @unmapped:      Counter for swap PTEs (must be non-NULL if scan_swap_pte
>> + *                 is true)
>> + * @scan_result:   Used to return the failure reason (SCAN_*) on a
>> + *                 PTE_CHECK_FAIL return. Must be non-NULL
>> + *
>> + * Returns:
>> + *   PTE_CHECK_SUCCEED  - Valid PTE, proceed with collapse
>> + *   PTE_CHECK_CONTINUE - Skip this none/zero PTE but continue scanning
>> + *   PTE_CHECK_FAIL     - Abort collapse scan
>> + */
>> +static inline int thp_collapse_check_pte(pte_t pte, struct vm_area_struct *vma,
>> +		struct collapse_control *cc, bool scan_swap_pte,
>> +		int *none_or_zero, int *unmapped, int *scan_result)
>> +{
>> +	VM_BUG_ON(!none_or_zero || !scan_result);
>> +	VM_BUG_ON(scan_swap_pte && !unmapped);
> 
> Please use VM_WARN_ONCE_ON and just return. Or put all stats in a struct,
> pass and check the struct pointer instead.

Yes, will use VM_WARN_ONCE_ON instead of VM_BUG_ON, and just return 
PTE_CHECK_FAIL.

Thanks,
Lance

> 
> 
> Best Regards,
> Yan, Zi


