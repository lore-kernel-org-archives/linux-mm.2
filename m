Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 554B6C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 02:59:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 218116B008A; Fri, 26 Jun 2026 22:59:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EF896B0092; Fri, 26 Jun 2026 22:59:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DEDB6B0093; Fri, 26 Jun 2026 22:59:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D82206B008A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 22:59:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5BA8EC3048
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 02:59:27 +0000 (UTC)
X-FDA: 84924186774.21.6631C13
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7351240003
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 02:59:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HUNDZz1I;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782529165;
	b=av7FsjuGp6gRv+961TN6y2xDglczL/9CeNvHqNlBsv0ngVZN2qfBrdLoT/bJkxtyv23N4h
	qkT1K2pOoFHVeF+MLNMkG1tU1iNgAjrDmHZe5+40xUyTfSkz5Of7WvFQHUV/T2iWT5eaXj
	rXY8ef9tv1UibolHJPOZWjH4Ox7DBMA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782529165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xIG1WH1JHTR3E2pytb6E4uisyr919RG1wajEmDiA1og=;
	b=8j5nxDoaZQv2/wBqa/RAnxiVWyeIGnj5ClUKL55PtIo3CPDNyexuKXx5SoULXeMLsH99ec
	DJFDHB2YZHbcmcyu99PAYFt8KBS3fUbust9itiNuUUFhDcxHCEmGAPeLnElZTXnr6TflHU
	B8wHFmAiGNcyhldLznOSNdl/b0BsiYQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HUNDZz1I;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <b7cfc04e-7a57-489e-9459-82d7eb818675@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782529163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xIG1WH1JHTR3E2pytb6E4uisyr919RG1wajEmDiA1og=;
	b=HUNDZz1I1zmsm2yvEdpByTZMAD4cmxX9cV8oH6VsWDhD/ii4iFw87sOrhG8+S4Hq2H68JI
	t1A+5d3yUd77doQ7ZKSVyjdJa6K1QL2hZMEPMQzgZiN0YN7NYIZdWsOzw3KTWHJvIIk3qy
	xzFNuuzfeEJ43OS7b/YmR+vy3EmV3+I=
Date: Sat, 27 Jun 2026 10:59:16 +0800
MIME-Version: 1.0
Subject: Re: [Patch mm-hotfixes v4] mm/page_vma_mapped: fix device-private PMD
 handling
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, ljs@kernel.org, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 ziy@nvidia.com, sj@kernel.org, balbirs@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 "David Hildenbrand (Arm)" <david@kernel.org>
References: <20260624065353.1622-1-richard.weiyang@gmail.com>
 <d060cadd-34f8-42da-b7f7-c8d295050436@kernel.org>
 <20260627020719.ipzfrlhfbvr6ac35@master>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260627020719.ipzfrlhfbvr6ac35@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: ymr6ripu8s3bs11uxyqz8w6eq7919tub
X-Rspamd-Queue-Id: 7351240003
X-Rspamd-Server: rspam06
X-HE-Tag: 1782529165-471893
X-HE-Meta: U2FsdGVkX1/KJUBK7FnFuM3jhA54ebjcWC+Mcwa6cWy9HjQe5PBA7Q9sGYEHcb5YzpG6TuYkqNqTLQRWecLpttQno69plgjNPtWKv8cyzv+EtudDjbALagmL4vKye2Cl5N4720xFPPc5zwzu4wE2ZelDXCTp0Ju35Ra4ZYIHiH/7kTw+P4sa7WipUJ2+UtsEBdSvMq+jnmMVBuimnafk/WvA9OrOsWtJLm4Kx9DXZCFWXJBTbBpKRp/QhHNTmVVqhhPcnVnna2mKfqwzFgdv10SgXz8ml+hEzS4RgnpT5ozIEsEiBFVNSCuOHSoIqEiapjeKlI7lpOzCYT6b9Cjmr/mi+6WAY16pFTCcatwkL13ytc3/pQ4KzmZt6lW6LdFkcByDcd7BxBS7UY5Pr8MUoaQKKb7dBs9/brisD8ofE6auKuOOY6Ge4eYlgiLeuxzifKvvvMFepc4SrEAo9NuFrOiNyKhSgLKPWJ2MKFB0+4k6T8y6vVl1tBhtyXmmRFY1+zZ6iNWLQEJ0XTaJbfUFCTaDyswpg4yFhsaBQDE+RLZXRrDF1RNDZpyMw37776K/S4aiDtfghpxQe6jXU4PjIT8ITeet7QUfXsCrdKm79Dtbt4JeULW+AujrR3kvMz2VOUj4XGzBngXejq1OSsQdDgWdQGg/9RD3rdwlqZuT/iV2x0/4/paY/SpHcb//BgGCdGVdzbsJbkyDkh8sy9F6HDYAHYGJlKHNi/NBOqtmBQcS57iMnNPAG8cmUZAcqc7OpiLebPvJcQoXUBbQ1NKB7p9TGsjiaR5Fj+7biJh0mrfLoyO7YprK+WVA0yERn4oCp6yZwN5jcsukS8eDT0lZ63d1R3XKXNhASIZ/jo4B4WOnug9dkn9H6uE2BIz7qGC4gKTwgGH0+Kn1u77e/5vGW/tCBrnMJZ7hQ+BwW2jq7xvSzOzJ1BmxhC4DDJXmmegUHiqR3FeffslJEhszLKr
 IQufAKLk
 EgYzX0jQ44kQgczm4Zb1PYtORQC6Pb3/DRbW8hXAcICZlnxtO1vtCDKF6bD666RYU9IXZfBeQkqtgjcXXQ1y/dflJlNK6cYv56VdmHUcn5FVwvvj7t2YpSdxEKQCgJr7/CmA9etHQi0GGdyB9Szn8UiO9Pz87j9NHOxHBIWCptbuX1RFre891LnM+ehgCtF4mle+H6pyqho2gjrrouez1M0A5ua49AhajSVyWV6PujYcjjxrqhV/8xJUK0Br9tIE3s1qcpWdphbJ/J0v2z050MdZt244435T9x7TRMfbUR3Pf90j8iOChU5+cQtaLJNHj4INY/FhUx7QtbrFjQmF3oIDnlbb4LYa65yP8AiJBWR8pdAI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/27 10:07, Wei Yang wrote:
[...]
> 
> Hi David
> 
> I did a little adjustment like below. Want to check with you at first.
> 
>>
>> >From 048ecd33673ec649e168fbbb97749a7c0e344fcd Mon Sep 17 00:00:00 2001
>> From: "David Hildenbrand (Arm)" <david@kernel.org>
>> Date: Fri, 26 Jun 2026 12:03:40 +0200
>> Subject: [PATCH] tmp
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>> mm/page_vma_mapped.c | 29 +++++++++++++++++------------
>> 1 file changed, 17 insertions(+), 12 deletions(-)
>>
>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>> index 2ccbabfb2cc17..ed2a23a90e8dd 100644
>> --- a/mm/page_vma_mapped.c
>> +++ b/mm/page_vma_mapped.c
>> @@ -243,21 +243,31 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>> 		 */
>> 		pmde = pmdp_get_lockless(pvmw->pmd);
>>
>> -		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>> +		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
>> +		    pmd_is_device_private_entry(pmde)) {
>> 			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>> 			pmde = *pvmw->pmd;
>> -			if (!pmd_present(pmde)) {
>> +			if (pmd_is_migration_entry(pmde)) {
>> 				softleaf_t entry;
>>
> 
> How about:
> 				const softleaf_t entry = softleaf_from_pmd(pmde);
> 
>> -				if (!thp_migration_supported() ||
>> -				    !(pvmw->flags & PVMW_MIGRATION))
>> +				if (!(pvmw->flags & PVMW_MIGRATION))
>> 					return not_found(pvmw);
>> 				entry = softleaf_from_pmd(pmde);
> 
> could be removed.
> 
>> +				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>> +					return not_found(pvmw);
>> +				return true;
>> +			} else if (pmd_is_device_private_entry(pmde)) {
>> +				softleaf_t entry;
> 
> The same.
> 
>>
>> -				if (!softleaf_is_migration(entry) ||
>> -				    !check_pmd(softleaf_to_pfn(entry), pvmw))
>> +				if (pvmw->flags & PVMW_MIGRATION)
>> +					return not_found(pvmw);
>> +				entry = softleaf_from_pmd(pmde);
>> +				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>> 					return not_found(pvmw);
>> 				return true;
>> +			} else if (!pmd_present(pmde) ){
>> +				return not_found(pvmw);
>> 			}
>> 			if (likely(pmd_trans_huge(pmde))) {
>> 				if (pvmw->flags & PVMW_MIGRATION)
> 
> How about merge this with above? And put at the first case?
> 
> Below is what it looks like:

Why add more churn to a fix with a stable tag? Cleanup can come later no?

[...]

