Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C4D0CA1013
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 02:03:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4CB08E0053; Thu, 18 Sep 2025 22:03:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFD748E0008; Thu, 18 Sep 2025 22:03:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EC3A8E0053; Thu, 18 Sep 2025 22:03:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 89FC08E0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 22:03:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A6591DF0D0
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 02:03:31 +0000 (UTC)
X-FDA: 83904353022.23.3FE67E9
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 143941A0005
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 02:03:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758247409; a=rsa-sha256;
	cv=none;
	b=KcidjzCDKt06s4kcHXfsX67whCn9c/sBTFct6eQezzqaP+uXPSk6KJyTEvmBPsT9t2DqZd
	PEm2MWzFwmhqA/oyQ/H8GBa0VynQouMH9K8+AERXHhMZXiFMPrYXS2w/LA2QLGEQ001CMe
	Pl60BqBZoB5bZItKQBkZDLxjPzU6ps4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758247409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XoeJSQrtAl1iIuoT3/FWZLwf037Q6uW1o8LMF8a0kGw=;
	b=HC05x0y3cuGeerjWaRwv0onSs0qkoVAEM3SWhNtZvvisGZckDU6uWFb0fUmKVryqx2T+FJ
	GL3YuHZRrk7g/5MowZvPwJU6na2C8vOIhdjo06AeJkTz0GXIgyme5ZSTzcy3t3ZPRKTf+w
	MPWVbTNY2cNjIxL2R0GQxISJPnhEJa8=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4cSbRQ31Tgz27jTk;
	Fri, 19 Sep 2025 10:04:34 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id D1CF1140296;
	Fri, 19 Sep 2025 10:03:23 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 19 Sep 2025 10:03:22 +0800
Message-ID: <229e5cd0-ed50-488c-88d1-c064b83de5a7@huawei.com>
Date: Fri, 19 Sep 2025 10:03:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] mm: page_alloc: optimize pfn_range_valid_contig()
To: Zi Yan <ziy@nvidia.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
	<sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>
References: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
 <20250918132000.1951232-2-wangkefeng.wang@huawei.com>
 <E25CD56A-2F37-45A3-8A38-190323ADB4DE@nvidia.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <E25CD56A-2F37-45A3-8A38-190323ADB4DE@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 143941A0005
X-Stat-Signature: hksx9r8maorkpowddfm7u71m9xakrnst
X-Rspam-User: 
X-HE-Tag: 1758247407-30800
X-HE-Meta: U2FsdGVkX19epdrWKS0ze6/Kxet1UsFG9f/vfuV3JzsH0r3rHL/U/KmoOpcM3y9eNevqDknGVZ0USpbhs3Lae9DO4AjlvXTKUQHchBdq8tQ0Eugdq34ub2cKqgu5Iuj44Xjs3ySDhh8nhMTHCGXtP0DySoggwfnRZvJ7ZQ1itYkCrw7TLfy102TzQIyQElaohw9jWl9JloI5Z5JTT+oG1bdjiYKbla9NI9HdHAi5jyQ6h9ggH1ex6Hm3PaWfTnBUokJlUdM/L4Og7pS+guZuAsqRglY8AIVe4jBodw/R2Bvc5vNWlONVkCHC3iIikhk7K9au7rNU0IHBxjVwokMcCW9qVPFrgEa3jrz5Ir9rCpcyhhLD30XDIRC95U7S99w4jAwN1axQgpYsGTQoO7eKLmEdNjK9MJ5ZWhs0bjLEmXFJnTdLDYr9gsIyWLMr/CqhrBwefoHirZGvx0a3TETX7twMLnNaqh+IcDtH6IPYy0Dfx5ciFMhxCXKAE421RxOlp8EHrLo8EJF1giloVcZSoZgLi+hgJaZHqVMrVbE9fg7Qn7lpOnnG73Gchh6EimPWhkYq7bUy1od9NinxtnJoRdZadVVFEwsKTC0THtLWmNbM2RrSxXleOgRMx3P/Mz7gCsbn9oMmW6u+/7sjvfJuW0AeLNHMKyaSkooXW0vvwtVB4kyLzexywU6ZoEMotkbY3iKBQzU4RNo7ahn7TyOZ1GxmPeSl2EjXCBndfWxz0bIEX6fQbJ9WluxX0WKDvbEw2OCDs2/CnvdZObBtzo/JfpJoqzC7Mnc7vud/wzhTqjj9NLrsUbCJrdNJRv4t7/iua9qNB+NjjBndZMpMlzckpccanC02DQU/wQqlUJkoYr4YWNtA2GUFRImsffnMRDr83cClwhqmo5V3KDjQccfxzBwRqMNMxfq6zvCCRBlSBBbEt7P7DPe5sO5+bSrgYqZYgTW6Q/5nGQVA2dP6TXt
 dHS5JKKR
 9r53JuJmP7KMY+EMiPHknRkbRMqxo565B4uc7o8hcCYKQkxvkRYU0cp1zGOkKvl2z4RIkXgiDKjkDVbLcTrN0PltBGLTY+OXt7nVfHpjoSfz6iCS64y/ue8Megcf760LG+2gz4CVh1KlQbxrBR8M3ZBPetmJSTwQcPRfuPlJykdajhpjwbdAEoFCNpo3IyEKAuSzo4qs33uudqN40u4MpmZClU41By0iwmK46tARVZK1BfZC+Cs+gb3PEJ3j4O10FwrY+eMN/fs9gXzs0PAFx+DwEADJChK4EhpUYYe35yu1V670AVRiEUg9elGDjTg361GbtWT7C5sJu6cc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/18 23:49, Zi Yan wrote:
> On 18 Sep 2025, at 9:19, Kefeng Wang wrote:
> 
>> The alloc_contig_pages() spends a lot of time in pfn_range_valid_contig(),
>> we could check whether the page in this pfn range could be allocated
>> before alloc_contig_range(), if the page can't be migrated, no further
>> action is required, and also skip some unnecessary iterations for
>> compound pages such as THP and non-compound high order buddy, which
>> save times a lot too. The check is racy, but the only danger is skipping
>> too much.
>>
>> A simple test on machine with 116G free memory, allocate 120 * 1G
>> HugeTLB folios(107 successfully returned),
>>
>>    time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
>>
>> Before: 0m2.124s
>> After:  0m0.602s
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   mm/page_alloc.c | 20 ++++++++++++++++++--
>>   1 file changed, 18 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 478beaf95f84..5b7d705e9710 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -7012,6 +7012,7 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>>   {
>>   	unsigned long i, end_pfn = start_pfn + nr_pages;
>>   	struct page *page;
>> +	struct folio *folio;
>>
>>   	for (i = start_pfn; i < end_pfn; i++) {
>>   		page = pfn_to_online_page(i);
>> @@ -7021,11 +7022,26 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>>   		if (page_zone(page) != z)
>>   			return false;
>>
>> -		if (PageReserved(page))
>> +		folio = page_folio(page);
>> +		if (folio_test_reserved(folio))
>>   			return false;
>>
>> -		if (PageHuge(page))
>> +		if (folio_test_hugetlb(folio))
>>   			return false;
>> +
>> +		/* The following type of folios aren't migrated */
> 
> s/aren’t/cannot be/

ACK.

> 
>> +		if (folio_test_pgtable(folio) | folio_test_stack(folio))
>> +			return false;

should be "||", will fix.

> 
> Maybe worth explicitly stating these two types of pages in the commit log.
> 
OK, will update.

>> +
>> +		/*
>> +		 * For compound pages such as THP and non-compound high
>> +		 * order buddy pages, save potentially a lot of iterations
>> +		 * if we can skip them at once.
>> +		 */
>> +		if (PageCompound(page))
>> +			i += (1UL << compound_order(page)) - 1;
> 
> Just a note here, if page is tail, this just move i to the next page
> instead of next folio.

As no reference held，it is not too precise but we optimize for most
scenarios.

> 
>> +		else if (PageBuddy(page))
>> +			i += (1UL << buddy_order(page)) - 1;
>>   	}
>>   	return true;
>>   }
>> -- 
>> 2.27.0
> 
> Otherwise, LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>
> 
> 

Thanks.

> Best Regards,
> Yan, Zi
> 


