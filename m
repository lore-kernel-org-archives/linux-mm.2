Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0E77CAC597
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 08:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA6558E0005; Sat, 20 Sep 2025 04:19:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7E6D8E0002; Sat, 20 Sep 2025 04:19:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBAEA8E0005; Sat, 20 Sep 2025 04:19:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C8B478E0002
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 04:19:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 75F881DFBA2
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 08:19:49 +0000 (UTC)
X-FDA: 83908930098.30.EF0E168
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf14.hostedemail.com (Postfix) with ESMTP id 56A48100008
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 08:19:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758356387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i284YwAn0ZHSQDqR6MOp66lNs3Gu/auiyy+CmmgYcSs=;
	b=cjQFZ8PzHJYvIygyYqEAxl/Ggl2RF2Cbgs9GU0cWuXh+bLktxzqnerQjeimIn5Av1zzIoK
	0/t3v1Ibm4v6dS18rDhFUnHiNCPGcF9+QdrOnJsBQdI0RPDRSOYDjr1Xrbg2aZR/0zpHGM
	Fwxd4A9RBoti3hKP5YqiuhEIzuuz7ag=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758356387; a=rsa-sha256;
	cv=none;
	b=Jk37AysDKCxUljneW9NArimF1ukXcfboMinZqHP7nRIxBPgTCP+7et0St2bHdV40z6uzB8
	cpl1M2UXXFwLA/8Vg8krx422cCgFb8TpbZhtBk/cQybg5gcRDMXeVt4roSvck/0h0cIwiY
	u+bBYAiJB79I5MojZ+rzXc1LpiqPItU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cTMjR71QFz14MPk;
	Sat, 20 Sep 2025 16:19:23 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id B7777140159;
	Sat, 20 Sep 2025 16:19:41 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 20 Sep 2025 16:19:40 +0800
Message-ID: <4faf520f-18c1-4194-b736-e74dc68e7a3d@huawei.com>
Date: Sat, 20 Sep 2025 16:19:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] mm: page_alloc: optimize pfn_range_valid_contig()
To: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
	Muchun Song <muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Wilcox
	<willy@infradead.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>
References: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
 <20250918132000.1951232-2-wangkefeng.wang@huawei.com>
 <b3a62c9d-22a6-4d83-84ba-699a13e631bf@arm.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <b3a62c9d-22a6-4d83-84ba-699a13e631bf@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: sbywrec5ranqow6eedtypfdmqa4bq5nf
X-Rspamd-Queue-Id: 56A48100008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758356385-240000
X-HE-Meta: U2FsdGVkX1/aq/qRpXagWKL3f2sOSevjIh7NsrAJYu1+Lt9cZjY0+fCOcaC6/m8Kk53j4rJ4fSkw9Asv4kO4E+IBxvLAMYglqD3b+kUZY9+vztOYF6But+VEJLAuvjfTJ2u+I5g85NeuDu0YUN0M4qhMDa9oeF/yWnFecH/fEzXfdvRWzMC9u6bN975tLwkTpwAHuBwiSnG8pr1IBMn6e+hAb+qbzqjmL9P98udPuMF+lhzBsqD41uZaBX7qSLwp3VGh+45am1c/wi3rTOgoa6Hy3pdERKviX/Vh+0DxN+p1Qg2FqS2ovDt8B3UZWX1RSjxkfFi11zuJg/UlHg381pQvpZS6Zek6RLiEQ21llV+DBf+/3nhQYqyE7ZtNyMYb7UV18TLaKGwf+0zA7Rh2zgqoZJiFVBB3QRzLcXkuRj+wzLRg4i8Vd5MnAvUhF1mtjHt88+4qKV+n+nwjgcf+gO9ex+ck6s3oS13nB2rkUlNsJw+R/1fNbxLJDtZhvwq2G9yvyalTrCnUjrlEDPpxfZ0jVTEE7eAW6AufF48dHlNYk4P+tE9H4XoVCn4uKdtR/A4s1qRO4LCmrakh5sw7HSQZNvx7c6iM5yaEhB4iirAvRenPce4ovA7UskNUyrl/NxAROo/tKqNgvSMZZUkKnUJQ5/H5V+KD6etOKQz2W6dWiebbOXK4aosYxagBx0lnf3ZJM4Zowfrek2V1SwTA6d2vuXFr5f3BoHJ7BC8wyCiWY+WMzwtWXl5/2QDkcOQuRpPLq54E7HHY/1A966tMmvPY3mHXnWy1zyjHtIS3cxIbgpaefglbvn88iI4y51GxrY9nzG0lhoad+vkL1pRcK6BfiEKsA76RN8ZUic+7RpMIoFg+kzO7g0+qnFUI7FdcX5340BC/uZ7xwhRhdnmUzSroeubWL4OXwcy2vI6ItBvHlrAcLUWpoWGsRVDOL/y7Ff2gzZfk09ovtUdcnsJ
 tV6N1f0u
 pjqpmof365RqMUXzUQ6TDncyQLKYdJ9EetPfh8L0TsacuaGotRdYLknNAGP/MLLpqqWJcj4fBvlWuz9l5cOQ+rzOlNJsaTsZAw94v+C6nUymjCoJFiEpEraNC4HDA0kAIFIGm5G9z454e4Ckbv7wa3wrXIUg0Cd49L6UMBjY1gruDNuq71F6A38uOniv1kfB2xUxThzKuCLOPMOVRFJzZNoZ+CaRUl4+tPJJ6B2xg4c1fTKaTRhWIKjPL3Q5mBcC8TWrG7k148QKM9CTAC8Ewu3d9bPnFrahbE177KWyIwWjenxd9iOyw7mr80A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/19 13:00, Dev Jain wrote:
> 
> On 18/09/25 6:49 pm, Kefeng Wang wrote:
>> The alloc_contig_pages() spends a lot of time in 
>> pfn_range_valid_contig(),
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
>>    time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/ 
>> nr_hugepages
>>
>> Before: 0m2.124s
>> After:  0m0.602s
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   mm/page_alloc.c | 20 ++++++++++++++++++--
>>   1 file changed, 18 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 478beaf95f84..5b7d705e9710 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -7012,6 +7012,7 @@ static bool pfn_range_valid_contig(struct zone 
>> *z, unsigned long start_pfn,
>>   {
>>       unsigned long i, end_pfn = start_pfn + nr_pages;
>>       struct page *page;
>> +    struct folio *folio;
>>       for (i = start_pfn; i < end_pfn; i++) {
>>           page = pfn_to_online_page(i);
>> @@ -7021,11 +7022,26 @@ static bool pfn_range_valid_contig(struct zone 
>> *z, unsigned long start_pfn,
>>           if (page_zone(page) != z)
>>               return false;
>> -        if (PageReserved(page))
>> +        folio = page_folio(page);
>> +        if (folio_test_reserved(folio))
>>               return false;
>> -        if (PageHuge(page))
>> +        if (folio_test_hugetlb(folio))
>>               return false;
>> +
>> +        /* The following type of folios aren't migrated */
>> +        if (folio_test_pgtable(folio) | folio_test_stack(folio))
>> +            return false;
>> +
>> +        /*
>> +         * For compound pages such as THP and non-compound high
>> +         * order buddy pages, save potentially a lot of iterations
>> +         * if we can skip them at once.
>> +         */
>> +        if (PageCompound(page))
>> +            i += (1UL << compound_order(page)) - 1;
> 
> Can we instead do
> if (folio_test_large(folio))
>      i += folio_nr_pages(folio) - folio_page_idx(folio, page).

I'm afraid not, see 9342bc134ae7 ("mm/memory_hotplug: fix call
folio_test_large with tail page in do_migrate_range").


