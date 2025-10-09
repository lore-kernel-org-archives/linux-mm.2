Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73AE5CCD185
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 12:40:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7EB88E0082; Thu,  9 Oct 2025 08:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C28278E0002; Thu,  9 Oct 2025 08:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B18138E0082; Thu,  9 Oct 2025 08:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F4E18E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 08:40:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4DFE3160876
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 12:40:44 +0000 (UTC)
X-FDA: 83978534808.23.FB063D4
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf28.hostedemail.com (Postfix) with ESMTP id ACC43C0008
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 12:40:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Sjlt8Wrj;
	spf=pass (imf28.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760013642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ZMpXrP8NgcqKZQS/c5Y/oIUL2PY+0QJ4pQhIadqfW4=;
	b=4jBxPOFK+hQZ7BjljNKWqYnsCI85XL8ASmFmGEKJkS/vHZwAe2cr8+BcuFL92Bsyt6LP9j
	2p5CR8tj7c58dGlUb6+z+rVOM5525jFEH11v2JEQegDDENdAjTQz5DwqnoICnokW9C+Uyl
	Pi25T9sxTpF8ZKshfEapyGlkAs6t+Wk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760013642; a=rsa-sha256;
	cv=none;
	b=Rh/yDxTPfyTJYdhIYidVtCMhj51Ouu23DJIs4odsqnaqTcclFNYy2ZVlI6XTBVstt8FEVB
	F5tJv+j14YG14VqoUqtY3ihWNnx/3/8EJPOcBsq/XTfxpv7kF9K1KE55sJEaA5S4NINJIU
	/t7fa9ZZt6O/tuwFKuDir96TDxX1Y5c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Sjlt8Wrj;
	spf=pass (imf28.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+ZMpXrP8NgcqKZQS/c5Y/oIUL2PY+0QJ4pQhIadqfW4=;
	b=Sjlt8WrjchWcc2q5q5mIvbbH1J5u9UPxUloy9kregfovZWzMXp+IiYfqnysf5JnW2ssfHsLrZ
	rEOhAAN5+XhfTwPBo/2TqqBvWqtkKpLbBi7swjNMn6clQRisrUJWqACQQV+IH/6jJqNDuOuXgix
	JfQenKmq32+shUriuB1zzyE=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4cj8bD0yVYzpSvj;
	Thu,  9 Oct 2025 20:39:52 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id A620B180485;
	Thu,  9 Oct 2025 20:40:36 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Oct 2025 20:40:35 +0800
Message-ID: <941380bf-7939-4bde-bbaa-8cc19c6a9122@huawei.com>
Date: Thu, 9 Oct 2025 20:40:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH v2 1/8] mm: page_alloc: optimize pfn_range_valid_contig()
To: David Hildenbrand <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Wilcox
	<willy@infradead.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>
References: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
 <20250918132000.1951232-2-wangkefeng.wang@huawei.com>
 <17bd2977-6a04-402f-ae84-306167cd16d6@redhat.com>
Content-Language: en-US
In-Reply-To: <17bd2977-6a04-402f-ae84-306167cd16d6@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam05
X-Stat-Signature: p91redwo5q9f43oobhqqgywr8k7j4x38
X-Rspam-User: 
X-Rspamd-Queue-Id: ACC43C0008
X-HE-Tag: 1760013641-167839
X-HE-Meta: U2FsdGVkX19EXlii5Ez5p+Fw4z3qTKFvcYa5skRdn/MWkLeiNVeT5vh6BMmNFAEuQWvN9M80GQJtJjIKVPaRKlTn9CEwsNG+v4fLZx6u50UgcAGpLu3xlSgQ59gx6CZ6Dri2qbgFazQEuxJPNFyxwZYkzQ7/j9zH78/zuQEt2EMOVcVJS8yR+HixS6vE7jI+e8WKx76AEKNio2qxs3grekUCafSVdLrFfm2MYPe+qP0xnRCeg8Qu0weXgv212SqMXKMtsKxiH1i/3pZQoHiP3pEEPycfhKaGxfjC3kk0JeiaEzlbhy86P0T4Uz1wDeLyri8pTGTaRpaUgXE2Jwgi0GlkN0caYb3vpQYW42K9pGih6j8zQC05OH1/49l7canXDKdus36Uu7KZegii+T+h23kMoH3tUyf74CYGwitn6bn5/tNB5gRpm3iqDYxDSZpTZpfUEBvvQiLOG9uuguGA//pKcw1S8Ri46Qr1gRAumbbVGNqkE4rbWv2F566svye+ZMfqPYn8mSITXdyPoiB3JdwGngU9Mf0jyKBtlPbfofwucISZrglel2WUIuCddeVzrHchk3gco4lBob1uAlXbYp1AtelucWuZirqFsC+9IyEf2+rUvzlIgQT9PDwhGmGCWukIxjSz29iLBfimZoLCuQBDJ6LBd2gZhZhhBHmyb7P9h+Hl0jX/zXWhvmGlU5kqgSNvNrIWgJDkaAYmm0sfy2zH/nmMmBaKc6vxgIq+dn0odv3tcBXyw02ZT7on7TDNGoDHN2ny/fvvqMdJMXTBljexkcxDejaxWlgOQbYeLjwtyYqWhdqTppw08FRwaLzIeQ817rkJb+vVAaC3gfS78DGV8hT3PJy1k1y4k5mXypoXw2ysPrjX/mIyqwjWRVX+7HOMWiCzKFTbwInhbHW+iLZaPGAGJdlkR/rV0qLixw8wQUxTktpmtLM7D0Ss+lo4xBrsp+m4L5AOK5wkso4
 AzWwiCut
 zSa++NEtIawXtYPfVe2HInmDB71S4Nog6dD2ExBibIGxf3Lt716uV8r0A3ANLDxy8HnBhEHb7Y/v6ydEul3MQj05TfcSr4ThtCeUlM+Awy/0LgZz+pWSvSt2yH5nUVaxKU75CfMT2Z2RCl4+WU79rfA9yVB5d83Cx9eAxDWfT5a1gdx2pYfMt7Cg5pl70Jvl48zwrpu2ch6JdFauTmeNIgdUqE5sHVCDqIeOxXixRAgcNwVW/a6o/gOlLHzc7CgiRr8MSAjrP8K73cbXpevYq4X+t7NgIigCMJdPqpmMZqB4efQAB4TBCtbL3wKvwIdS2zIcqXg6Jddc73K5Rv6ewizEYELQpDSQfucgq9s8oUBhoGoX8WpKJRgj//GF1aWKWCmQg0VnL9h7HACOCcVlcJMmPochvJxP5dRIoxY4mhRrDGD/TcyExO/oN/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/30 17:56, David Hildenbrand wrote:
> On 18.09.25 15:19, Kefeng Wang wrote:
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
> 
> I don't enjoy us open coding this here. has_unmovable_pages() has a much 
> better heuristics.
> 
> I suggest you drop this patch for now from this series, as it seems to 
> be independent from the rest, and instead see if you could reuse some of 
> the has_unmovable_pages() logic instead.
> 

OK，I will try to check if has_unmovable_pages() could be used. The new
patches are added when I test alloc_contig_pages/
alloc_contig_frozen_pages with different GFP flags.

Let me remove them and resend them separately.

[1] 
https://lore.kernel.org/linux-mm/39ea6d31-ec9c-4053-a875-8e86a8676a62@huawei.com/



