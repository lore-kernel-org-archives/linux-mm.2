Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15072CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 13:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E64F96B008C; Thu, 18 Jun 2026 09:01:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3C696B0093; Thu, 18 Jun 2026 09:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D78AB6B0095; Thu, 18 Jun 2026 09:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B50056B008C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:01:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 382841206FF
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:01:23 +0000 (UTC)
X-FDA: 84893044446.13.B50C6F5
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf07.hostedemail.com (Postfix) with ESMTP id CD86140009
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:01:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="Tpil/9r7";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781787681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Od7vG4a5OC1S7dx9Q3cEKG35mnRXKvVsZU2aZtWBcdM=;
	b=tgNB9/SjjuTFvjzo/QZiGVXbGuMPd833ckkuXeo6L4703/TdgJrvkkGxUp7WiLyTPHnl/E
	suOZYz5NfNtfZ8/VdFDFKv98zHi+IJUl6uqIEpOGvV/TxLFrFJL4OWBWSsMeJwiwKQRohL
	oeFVUWbgYcsLGH63M1pau5JyQLK8LKc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="Tpil/9r7";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781787681;
	b=XMt2vbOOgepnIvfaARd3Ah3MUFCnIcgrxXR5PbAwuK/guPuvWqh5tybmwh38SR3HTbY4dZ
	SPQbrZurMTqwSOcB7tdLH5Tb4WSPBeJfl92E/m/ZPCAH3quqgcVq62zOEZIpimW5GzQwaO
	6vkk8I3PglloOA+pYgtKGKvhynLzTi4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Od7vG4a5OC1S7dx9Q3cEKG35mnRXKvVsZU2aZtWBcdM=;
	b=Tpil/9r7QXHVjnajd4/lv8iMDzZ8BAg2YMSdHwb+F8keyFFLM6elWToq5rK7zIUMt3LTSuiMQ
	YRvq4CMv1pVCWt7twjyBgCltkbMGS2yIUipF2qcgorsrRHkkLnfR6+vBbeMhbk8af9zAbH54ZB2
	88NPEiF4aWsaGaW/KJduYho=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gh0xJ5g76z12LjK;
	Thu, 18 Jun 2026 20:52:20 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 32A3B40538;
	Thu, 18 Jun 2026 21:01:11 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Jun 2026 21:01:09 +0800
Message-ID: <42e167b2-5676-45fd-8f3a-738d2f4f6623@huawei.com>
Date: Thu, 18 Jun 2026 21:01:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: mincore: use walk_page_range_vma() in
 do_mincore()
To: Pedro Falcato <pfalcato@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>, "Liam R. Howlett"
	<liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka
	<vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	<linux-mm@kvack.org>
References: <20260618092845.3905740-1-wangkefeng.wang@huawei.com>
 <20260618092845.3905740-2-wangkefeng.wang@huawei.com>
 <ajPZlxq5z1hyo1kE@pedro-suse>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <ajPZlxq5z1hyo1kE@pedro-suse>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CD86140009
X-Stat-Signature: tubhyp8mdx371me63awmeh8cszjur4z7
X-HE-Tag: 1781787678-283006
X-HE-Meta: U2FsdGVkX19rHm0AkYmnmNBzw7+bMixm4H86zPvRHDtvODY/Adv7UXnnl/au5u1aKRN2sNO4fDdDD/XA6/IbYkLgAn2AIsluKRHo0cZE6Xm4m+Re6P3pTLW8fNBFWRmUWeReZLDdH0v1myoyCtFLs4ZcQ+sG1vZEmUIaY8yvQoY33sPWuKRpkj0oOSCr+LbBHQvE4yrltcwhtHEE42Hwurl6PGnJpgtVAL7GP6zsevG6sv4b7yBD2JyEBdfbrxPjkUaJidCTKhGo32mbHbHbGfeM9xeJMUPYFQ+IVaKA/+IK5H7SQRFuNXcc4QJFgczU8laZkGzaWJCIFizNIwARnnXsAWkaNZ53e6ydOvk7QHA22tC8ZQVCv8txG3JeX+ftWwYQ4Gic+AcYWc6eOo9/IHFStQGA+CFbE2F4putnOSjbH8kTfj/ZurZofwFR2hxRM1Am0FBN/JxWorVuFzs5Ba/KxSd3/dIPDOejG2lkDUstjnZZ86bYkEStavYBpCLCq+c7t6LovyrjRB/TGHrAdkBSsODP8XL0H84WmuwtZ2IbGMEDp9NhJYOMhRmT2P1e6VOyezaOBUl+KSPBaRoQFtC5IG4rT8/sNVcvzaJa/nbaacZmYMd/suXJmFmObDgT7b7plnB3B/HNN+4wZvhrjTtXhrqkoq5FCHwXHD6VKCEJ62P0LcQbw1py/lwgPRYa9I/v0vM18KP6aspecJU1QXwfp3kTUqy2isxqKmI2XY2enLvt/nzovt32XjgyCpWc7FLulGL5GX8who2YZXt/XgBuoNImYv3Ewju6vdznftnD88qOGY1YqYQNeho8UNi9hQjwBzcagzwnwXCpDB6Ngh5gJxE+aruUEqV88WMYXVx0vTERuz2wqgKdG7JSMZ1UgUqExaVeRe07yJQlnV27sxCh6VrRhxun9pSABWsO2EN5bnOzH6KKsiAgQHvnC4/pAq0U5h3GSoWsKpnKJj0
 LyCwLKE8
 JYiizH4dga5Mr2UxZuEU693wHVl2rgT5g+T0I+y3yDG95Y41lRIx+5WouEzbJ0X2rAaeDmj3hbKurlSDCi8speZKsuFpNhwUk3ETKQTv/0C5XJBgwg7yY1UGJ4PPAYSieTx907XxOfzLdX+itPbXlXhkL6w83BkXNRYiT6h8ZaPvEsJ0GKqRKgMZJCiM1y0Yq4YvQXDFkEqanKnioklK3wjJFFqd7DitX1v8u/JuNWhd5FiGpLCZNCvkIJIF616ELig7IN+xCUKAX/HMjgKSsalWGIBf8h+3mLKFEstKbpFH1bpCVkHDPkXA9Gu4PjJabfbEzafpAmWrrTN0hktKlVaKFQB3wgyH6WT1+cVfQZ9YUYbpuDXmfmAhHl0ibKlY5zvZ4MqzxZiGvnV8SS9f5ALR+LHzYdLV2g9d8PC3TZY5jJYXP1BWvFMLc60B88Wr9o1Pr0khH1I3f8K4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/18/2026 7:49 PM, Pedro Falcato wrote:
> Please CC reviewers properly!
> 

Oh, I will put more reviewes to cc list.

> On Thu, Jun 18, 2026 at 05:28:42PM +0800, Kefeng Wang wrote:
>> The do_mincore() uses walk_page_range() to walk the page table.
>> Fortunately, the caller always passes start/end that falls within
>> a single VMA, so it's safe to use the walk_page_range_vma() in
>> do_mincore() to eliminate an unnecessary find_vma() lookup.
>>
>> Unlike walk_page_range(), walk_page_range_vma() does not call
>> walk_page_test(), which handles VM_PFNMAP by invoking ->pte_hole()
> 
> Why not? Can we fix that instead? I really don't like having this open
> coded in callers. Are there callers of walk_page_range_vma() that expect
> to look at PFNMAP mappings as well? From what I can see, the callers all
> seem to operate on folios (and/or anonymous memory).

As you said, all the other callers don't operate VM_PFNMAP， so we don't
want to add walk_page_test() into walk_page_range_vma(). This hack is to
preserve the original behavior, but as David said[1], we could add a 
follow-up patch to remove the special handling to see if anyone screams,
and this indeed changed some behaviors, so it's better to handle it with
another patch.

[1] 
https://lore.kernel.org/linux-mm/0e619d71-1c3d-4534-8376-2982c7348c31@kernel.org/ 


> 
>> to skip the page table walk. Without this check, PFNMAP PTEs
>> would be treated as present by mincore_pte_range(), changing
>> the returned residency status. Handle VM_PFNMAP explicitly in
>> do_mincore() to preserve the original behavior.
>>
>> Acked-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   mm/mincore.c | 16 +++++++++++++++-
>>   1 file changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/mincore.c b/mm/mincore.c
>> index 296f2e3922b5..0c6731ae6c4d 100644
>> --- a/mm/mincore.c
>> +++ b/mm/mincore.c
>> @@ -259,7 +259,21 @@ static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *v
>>   		memset(vec, 1, pages);
>>   		return pages;
>>   	}
>> -	err = walk_page_range(vma->vm_mm, addr, end, &mincore_walk_ops, vec);
>> +
>> +	/*
>> +	 * walk_page_range_vma() does not call walk_page_test(), which
>> +	 * handles VM_PFNMAP VMA by invoking ->pte_hole() to skip the
>> +	 * page table walk. Without this check, PFNMAP PTEs would be
>> +	 * treated as present by mincore_pte_range(), changing the returned
>> +	 * residency status from the historical "not resident" to "resident".
>> +	 * Handle VM_PFNMAP explicitly to preserve the original behavior.
>> +	 */
> 
> This whole comment looks poised to rot very very quickly.
> 
>> +	if (vma->vm_flags & VM_PFNMAP) {
>> +		__mincore_unmapped_range(addr, end, vma, vec);
>> +		return (end - addr) >> PAGE_SHIFT;
>> +	}
>> +
>> +	err = walk_page_range_vma(vma, addr, end, &mincore_walk_ops, vec);
>>   	if (err < 0)
>>   		return err;
>>   	return (end - addr) >> PAGE_SHIFT;
>> -- 
>> 2.27.0
>>
>>
>>
> 


