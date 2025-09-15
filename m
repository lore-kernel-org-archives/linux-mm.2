Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6819CAC58E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 04:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE3FB8E0003; Mon, 15 Sep 2025 00:24:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94948E0001; Mon, 15 Sep 2025 00:24:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA9E18E0003; Mon, 15 Sep 2025 00:24:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C94348E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 00:24:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6C5551A03CD
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 04:24:49 +0000 (UTC)
X-FDA: 83890193898.28.AB2B282
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id F36A7160003
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 04:24:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uER8sLex;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757910287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ehnEhT9IwpoRpyq7W3B9rNarRzhELO0M7YbeeCPAQMM=;
	b=TEV1gfJ6sc44AGeHlV5UzYDS22X5n6IYd0QI3lFFsEXS9noDTQvMWY9JGKGQq67blrqpM7
	TMd109RURZ5g/fMdg2b7nj8MJ3UKWJzqv+gzuYU7SV5Xqvw2SPWe2GT7crv5xz7o27Ov4W
	t1W44fi7otyTJt3bnDrMP4e3ikU697w=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uER8sLex;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757910287; a=rsa-sha256;
	cv=none;
	b=6PAWFPCjM1QMJl673q5vNHWrryyEVGSATpZZmTZcoeIVmj4TtMtbTFM9atc3/QHADs1XoK
	aIpWqx1MtlkmNiWmUINPrtfan8EN+loph76gZo117eiKziDkDVCKiz6bTk1C8/lgabHbtB
	DIRNd0NWXIrkWHznrZqzcPU/MDDyKrk=
Message-ID: <434ecc5a-3aec-4381-8477-8a7d09220051@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757910284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ehnEhT9IwpoRpyq7W3B9rNarRzhELO0M7YbeeCPAQMM=;
	b=uER8sLexksdHO9XbHYOptdkH/NAAPFYOzOUJVgerwDt80blqcBLHvrqWNDz7+G4w8LzTlA
	GC+tt+uJ0Ivobr6/GHjNDSAKDmfu6l3H7x9psd+Z+emAk+uqhUL/8aSBrVIEJqT0MZ1zCL
	nTBGcgAtpfaGLLHgFP2UZ8NknmN9Jyk=
Date: Mon, 15 Sep 2025 12:24:19 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new 2/3] mm: clean up and expose is_guard_pte_marker()
Content-Language: en-US
To: Dev Jain <dev.jain@arm.com>
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, lorenzo.stoakes@oracle.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Kairui Song <kasong@tencent.com>, akpm@linux-foundation.org, david@redhat.com
References: <20250914143547.27687-1-lance.yang@linux.dev>
 <20250914143547.27687-3-lance.yang@linux.dev>
 <e2c6f52b-23c3-40ef-99d3-325a0a3cb4d4@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <e2c6f52b-23c3-40ef-99d3-325a0a3cb4d4@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: F36A7160003
X-Stat-Signature: goyx47rn5m61wybhfw7e5xg1qwhnp6hp
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757910286-204627
X-HE-Meta: U2FsdGVkX1/3wxQbupmSfX68BNHPi/GM5QD+XkKCfvpvaXD7hHpGYFQtMXV/+og+8DfK4AwSOxGHYnYDM0DpzosWQeQsBkzpeHsHNelS3l5rTRzs4Z3cRyD1J8osQ27BUgYj3cTq762AIdsZ4BsbRmDZQy0oPCjvrsKuHE3fyN1VvHQOjqwOupDOMV+3MuobxKghhKHHtKM+aOC0Dv15fGsNr+ND85bkDfuyPN1ifZOyWeXRy1Y8Qzar8hWlhtbq/MopOS2GxI6hoGxnNDT9vrATx5ngpS2yVhGb2BIu/+X/9oT3aMoYAx1KbW+WtGp1GTy9pem4FGic33KQWL6Bqi6MNiGv2W2ypvBQEFqr6lckKljEISLy9yDgUZm7cgQ0uLKEGNWVAKzUbhP+I3NOPOSfgoY9l4QMubmMi59fgPaXpn1CEoO5CaTaXe/hQUOV0f+vw387xzmoDABxpv7DGT9n2iL7hsZ+YgUyBYKjVECWs8RY3uI5eKE1MnXOEahPuJeBOb9Xo01d8PSUjUAmX8X+ri9COtve8BWBVkknyalE4Zo04G+IKARha4hCwj/NrQtAY0pOdiaH3qfDQ/MYx/RH/mHYJeTnWa+MQ6Bt45+uwMl1sHErK2kn4uoztK5FjXoOv7FQI6VcGpIGVao3F60K0oLzLlKogXIxb14XvnNYIERzllLHlPMcs2FVqxV764fqdz5uwalXYoYW0+EVndqaiW5m2UjI3R47MIgp/QLfzQf+SVHpHg9Bq6C+iIFQuG7gb4DJOO3dKYsAAuNhFmYDEDxqasQY9jYgkDJq2/Nb2cmZrhMH/DfnKy5cz3EXMztyzkbEfkhPwI8K5S2Ksi7lDqL18xnResu+KeFJIpflviRURWj4lHVpzvAeR1XLCj1d211wc8bYwYgSelTqxjYrRzlmzMI8+niMkHc0TK5/u0/d3PzIdqhW0rSJ4cv9RiEBoAozev1B5ROQuvi
 H9TvHqDj
 OzrWnh9fOOUjLBZlDvrel6bPeyGK1Cz0i2I7QQKx8YzGJ09sBoLZtkKjb8YQc65ixuRQFhnD0tfLJ0XttccoX84y1BqwcmN6J0Mz+1FP41ChiMXg+mtuXWdsmuWS/BqsHP3v93D3DU0TFKOTIkiwfzKnoa4ibjNZ5t+JArUZiCZHvFtoWha3nESXgtSlTatTcfwMTsVf2mXBputCA2QnLAL7fn9qo+jtJF1HBW4qH2RHItkpKEtqU+VkWgnYbDkn5IImPy+jpsUs2AV8HfMg/dfGGXhIc2A0+L5u7v0I5C7jegxhyVlETBbnNhVXVDrPMI3M2OBueCrgmLrUfI26BXERSvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2025/9/15 00:38, Dev Jain wrote:
> 
> On 14/09/25 8:05 pm, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> is_guard_pte_marker() performs a redundant check because it calls both
>> is_pte_marker() and is_guard_swp_entry(), both of which internally check
>> for a PTE marker.
>>
>> is_guard_pte_marker()
>>   |- is_pte_marker()
>>   |   `- is_pte_marker_entry()  // First check
>>   `- is_guard_swp_entry()
>>       `- is_pte_marker_entry()  // Second, redundant check
>>
>> While a modern compiler could likely optimize this away, let's have clean
>> code and not rely on it ;)
>>
>> Also, make it available for hugepage collapsing code.
> 
> The movement of the code should be merged with the next patch.

Thanks for the suggestion ;)

I'd prefer to keep them as separate patches to make them easier to review,
if that's okay.

Cheers,
Lance

> 
>>
>> Cc: Kairui Song <kasong@tencent.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   include/linux/swapops.h | 6 ++++++
>>   mm/madvise.c            | 6 ------
>>   2 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/linux/swapops.h b/include/linux/swapops.h
>> index 59c5889a4d54..7f5684fa043b 100644
>> --- a/include/linux/swapops.h
>> +++ b/include/linux/swapops.h
>> @@ -469,6 +469,12 @@ static inline int is_guard_swp_entry(swp_entry_t 
>> entry)
>>           (pte_marker_get(entry) & PTE_MARKER_GUARD);
>>   }
>> +static inline bool is_guard_pte_marker(pte_t ptent)
>> +{
>> +    return is_swap_pte(ptent) &&
>> +           is_guard_swp_entry(pte_to_swp_entry(ptent));
>> +}
>> +
>>   /*
>>    * This is a special version to check pte_none() just to cover the 
>> case when
>>    * the pte is a pte marker.  It existed because in many cases the 
>> pte marker
>> diff --git a/mm/madvise.c b/mm/madvise.c
>> index 35ed4ab0d7c5..bd46e6788fac 100644
>> --- a/mm/madvise.c
>> +++ b/mm/madvise.c
>> @@ -1069,12 +1069,6 @@ static bool is_valid_guard_vma(struct 
>> vm_area_struct *vma, bool allow_locked)
>>       return !(vma->vm_flags & disallowed);
>>   }
>> -static bool is_guard_pte_marker(pte_t ptent)
>> -{
>> -    return is_pte_marker(ptent) &&
>> -        is_guard_swp_entry(pte_to_swp_entry(ptent));
>> -}
>> -
>>   static int guard_install_pud_entry(pud_t *pud, unsigned long addr,
>>                      unsigned long next, struct mm_walk *walk)
>>   {


