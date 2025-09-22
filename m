Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F8F2CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 06:50:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 573588E0005; Mon, 22 Sep 2025 02:50:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523D88E0001; Mon, 22 Sep 2025 02:50:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 439588E0005; Mon, 22 Sep 2025 02:50:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F07E8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 02:50:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD9A813B3E9
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:50:31 +0000 (UTC)
X-FDA: 83915962662.10.42F0E05
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1A40D8000A
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:50:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758523830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6/CZ+mX8dBHfec42Jgc65d/pkZGG45QrQUdIuBvXgHA=;
	b=uFPcBSjO00I2WHljARJEHBjF7df2h2r73OUmnO1K2R6Pr8DhxSXLNPG6JvJH4sEfsQYoGY
	6agLUR/KVxa3FKGhacVuDxtrUSgIxi88SSRypWJ0DPOOj9c3VdIeE3YPpOTYr8NM7ODVxq
	c7urS6wjFFN5TTlJZIxC02+q1K2OK6Q=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758523830; a=rsa-sha256;
	cv=none;
	b=UvMVVzRtVChGoJ4TuKTJMlZSZwfV0fhwhL4mlsl9P4VxpTNLZYcxVAdAzM2NSvNc06ZvaN
	VLhkSSXMhCnrNDczVQF6Kji3A+BnMseXJqmfdDWl8ccSbN6mCLP8QPA+D2GHyLUi54MeEM
	FNi/9cGT71wlwTdPgVUkwKvZof56heE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E3FAB1515;
	Sun, 21 Sep 2025 23:50:20 -0700 (PDT)
Received: from [10.164.18.52] (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D0783F66E;
	Sun, 21 Sep 2025 23:50:27 -0700 (PDT)
Message-ID: <c468ffc7-bf4f-4b0e-b02f-f926f1c2a836@arm.com>
Date: Mon, 22 Sep 2025 12:20:24 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Remove PMD alignment constraint in execmem_vmalloc()
To: Anshuman Khandual <anshuman.khandual@arm.com>, akpm@linux-foundation.org
Cc: rppt@kernel.org, ryan.roberts@arm.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250918093453.75676-1-dev.jain@arm.com>
 <2a7e000c-f075-487e-a750-1fa8d29adfe8@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <2a7e000c-f075-487e-a750-1fa8d29adfe8@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1A40D8000A
X-Rspamd-Server: rspam05
X-Stat-Signature: spzikeohkmk9x1jqzb8zfeqsgnufrohg
X-Rspam-User: 
X-HE-Tag: 1758523829-772098
X-HE-Meta: U2FsdGVkX1/duNIk72khN9Otj4I4HX4Encg1HJuV75MgTi9poIPbGH+iYDHJaF/JzkeCkuzB9HkAGQaSLMwvWDJPLojg2NOk8UNkmfvEMpT4qxTpsn6ev0t2o+/voWQXu5cg25uNHhmSiro2JUYSxtJc4sOCWyVgangdNV1Y3jldLZ7R5EUBo9Vc8wHfliOYdFHD5He6al2QD+KxG/UWPHM38gJ9AWACLarCCFaeQx32fNsSXhY3BVTia7OCXCSktxwxwqIdnXkdEuzJmpd4dMGPK2bHjeydUSW0zTEkLkR4kM42WMpoZ/kk24e4amnvxtvspt0At7I3YQziR5mj28Eoc3jInPOjsv3c5xtb9okLC0KwFPQ/eOaPIQwh1byL4N/CAZNYtV5x3CrVKQFMTv+6MfIsIrXbDBwfTv8FJrt05/CsPe94jCiO8zmA8HZsVpzVHZYZZP5YjtXLmwjPu7zvWi8P7MO5zRpl7+Z0ZxwYp0B+j9IGXNdB5ZskmOLAWsnVy6iJ7D/ukl0GTM1MnfbuCXI5tlFrmwhGCp5dxGTmmOS9vytOguCQH+9o7CR08s5pBdWHaakd1JCP0fMx4AfhwFozRjuzaYfNqULrCxpbg5lZSu5Ab98ObwRd+7UXNwTUZTIhIDBMWV5jWJPGA75YXKUb5wSDP1Rfq0t4jMuM/fOtXM6YkuYNS/h61DU3DPtdcuo68MTcbwm0s+MoEEzZKeHdKcB7bi/VR8fW2yK/IBk4hfXdiYCxgM6+E1Zkpx34jJfFByV7QCWKpe+xmCss4yEjh5HLXzqUklEKQnKNk9FmS1cwnuZyumK7Dt9/bGdMZHNkY3VUN6jk71kbBSvX7g2r5W/JpCcCz3NgYVO6W/Ink7CxDQRaMrX3vs/m6lQ57HvC+eIX4clf3VyKkYV0pJTB82WuxCJbj4orevJMAImo0oa55hxw5DE9pUMKfqCAlDBMzoBll56Dhj5
 LY/NXKQK
 BtR9JosrtAsycvuq3meO4QN+8gb6UT1709tFSM1Ga+gkDosWG4+I7K/Xjgf3pxhhzQrxdUIuQhzNDnWwIfFLoXisaAo9vMCp70nTQXIJFFtGu1hPDwYVrzOljoUZVnqUOqXN2EVnwHq+KKHat38aYfbmhbP7By8TVr8pDqqFUwLzBwUydcfhogGSmoG4jG5MNAN5k8klyGqqessPbeaYrY4HHmUSrfTn2YqaI2JT88afAXuPbH0AhSI95/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 22/09/25 11:32 am, Anshuman Khandual wrote:
>
> On 18/09/25 3:04 PM, Dev Jain wrote:
>> When using vmalloc with VM_ALLOW_HUGE_VMAP flag, it will set the alignment
>> to PMD_SIZE internally, if it deems huge mappings to be eligible.
>> Therefore, setting the alignment in execmem_vmalloc is redundant. Apart
>> from this, it also reduces the probability of allocation in case vmalloc
>> fails to allocate hugepages - in the fallback case, vmalloc tries to use
>> the original alignment and allocate basepages, which unfortunately will
>> again be PMD_SIZE passed over from execmem_vmalloc, thus constraining
>> the search for a free space in vmalloc region.
>>
>> Therefore, remove this constraint.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>> mm-selftests pass, but I am not sure if they touch execmem code, and I
>> have no experience with this code.
>>
>>   mm/execmem.c | 3 ---
>>   1 file changed, 3 deletions(-)
>>
>> diff --git a/mm/execmem.c b/mm/execmem.c
>> index 0822305413ec..810a4ba9c924 100644
>> --- a/mm/execmem.c
>> +++ b/mm/execmem.c
>> @@ -38,9 +38,6 @@ static void *execmem_vmalloc(struct execmem_range *range, size_t size,
>>   	if (kasan)
>>   		vm_flags |= VM_DEFER_KMEMLEAK;
>>   
>> -	if (vm_flags & VM_ALLOW_HUGE_VMAP)
>> -		align = PMD_SIZE;
>> -
> So if the above assignment is getting dropped here, probably the local
> variable 'align' could be dropped as well and range->alignment be used
> directly instead ?

Sure, but that isn't a big deal. Replacing with range->aligment will
push the arguments declaration into an extra line in __vmalloc_node_range.
So will prefer not respinning for this triviality, this has already
been pulled into mm-new :)

>>   	p = __vmalloc_node_range(size, align, start, end, gfp_flags,
>>   				 pgprot, vm_flags, NUMA_NO_NODE,
>>   				 __builtin_return_address(0));

