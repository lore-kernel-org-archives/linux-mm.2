Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77942CF45C6
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 01:24:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4CD76B0005; Mon, 12 Jan 2026 20:24:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFA8A6B0093; Mon, 12 Jan 2026 20:24:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDC2A6B0095; Mon, 12 Jan 2026 20:24:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ACEFD6B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:24:20 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 61916D2941
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:24:20 +0000 (UTC)
X-FDA: 84325195080.19.858B4C8
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf19.hostedemail.com (Postfix) with ESMTP id 42B7E1A0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:24:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BDZMo85u;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768267458; a=rsa-sha256;
	cv=none;
	b=AyzRFsN+jQz/gBlsGkRxk2Jgj0xM3aVrGA4ogZ2xl3kxb0A/5VfccioLP1GAAUZEXn9nTN
	t4c1C6yDs+GBDYHxWDTzXS3dKYsyGu0zKhi9s0PQ2Sp5eBKoOL9FnLJRCuPGCbWHtXgkZs
	06kki0J96FBSK8IcLnc/8bdoDw0R/Uw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BDZMo85u;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768267458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TCG+GYyRIAoBk24+swEYkzzIXTj+XH+IW0jmkCpHZlY=;
	b=2ECXf7fsX85NSVIi+c8Xva4u2C6BgAZGWisRHtFVr7uRAaxgnuvheBO5aC2BzKwZy2vGpW
	s8vvxoQD+/HbyPBmyUQpkDUA0L+ScKHKk0LSpXkRUZVVllGDWpUgWp9m7U7dLpoUdCwhPy
	hFJ4a977ksrrxOPy1iHHkmtw689vfgs=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=TCG+GYyRIAoBk24+swEYkzzIXTj+XH+IW0jmkCpHZlY=;
	b=BDZMo85uXWQ7JQlsS4x4hr3J0rIiCHna6eCgqQthGk+l3ZF6CQuYo1uteCm46Z1x5KKbgMhjT
	MH6HLKFSH2lpxzauc3IycBqjTo6C4rhVtWW1W60INIJ6mGHJraveBZKYNuToh408OixoNpyzZRy
	WoUvYYMz1VB2rcEG5N2qEFE=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4dqrzR142Pz1prLw;
	Tue, 13 Jan 2026 09:20:51 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id E09854056B;
	Tue, 13 Jan 2026 09:24:11 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 13 Jan 2026 09:24:10 +0800
Message-ID: <db7a38dd-77c5-4adc-b0b1-ceee45fb1f51@huawei.com>
Date: Tue, 13 Jan 2026 09:24:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] mm: page_alloc: optimize pfn_range_valid_contig()
To: Zi Yan <ziy@nvidia.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>, <sidhartha.kumar@oracle.com>,
	<jane.chu@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>
References: <20260112150954.1802953-1-wangkefeng.wang@huawei.com>
 <20260112150954.1802953-3-wangkefeng.wang@huawei.com>
 <926A149E-FE2F-4F88-92D6-FA607398605F@nvidia.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <926A149E-FE2F-4F88-92D6-FA607398605F@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Stat-Signature: kgpopbuk4njtfpziqp1tw48r46yqd71p
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 42B7E1A0005
X-HE-Tag: 1768267456-479186
X-HE-Meta: U2FsdGVkX1+HrlG9iA2smJtYWOVhhjYEE3TO/eM/nbP4S65L6EQgupr3vJGCHHorg3WN5S3FIMnexc0iM1eLMEpRL6bNeo1rzRHvqO7x5E4MQt+IF80NpF0H1/VvJDwhuMZoO2HidZzNEo3rtEd7+oJ/yiYiVSXrWBs1gELftetF1+floCOH3jd1fl7kA7hKhVR8inVg2gbkIBQBH3tLcP2+AYc/uWLaPQKieL107k0GlIn0IZ5fnkj1e5MqNtZHLV2Cc7lh3UDIj63z4yHGLveAH9Jk4oJoqb6xybuT5aOUGHMUnKWc+/Euf9TjEeq6FXhtI3F5hzWfAd1qt3PSz5603XNS5Kt+ZJ8YOJsV7DPbtwP69XDaM1Dme1JLElrvFv5nNcC47U8CRSILb8X2R9z0sy1p9G3NP6cYOUC1vDxAia68+IWFziabp/Wc6edgZqRFHJtRGRvvh61D8qdLwSKoBYXkiX73qAjSJHDUqhdDX5X2DX6DmJrSWuefH5ppjhhYHDJEtn37qu4oyhicoB/wPVliBMXgRbUqMGyEbLXFN15ojgwdOzC+k5UJF8Hj/TXjKAfMPq0ECR1sPJhlkR9kJ4aOKvx481ZJlylL0zXMS+/QGkHf/+JzGhnUS23LD1Sjq/hfV6SkRbHVbL7MfWjO9hbO7bKDhsoc7jhQ28b1219aDJTkyJekhE08LC3VUKCb5/FaPi0AX0g7gCf/qUnIud2vYKZSJnZRfc+G3S+Hv9/Ptv/0YxCyD7cIzrMwzfoI1yWzvAkSMyKBr7zl82F138ectAA0rWkHHRJqj+EtNXCDJS4i0wNFlC++NgUu6L6N0/83LwuSy4la3n4b293rljpi2h86cRUMaypbx+VjDRgMTm3M+AweT95zdbsc8bYW2QLCF8o5k1xV2fPhrGjEnbnKMIaDOi/aF1/Eod1gqIEM1Ppi2hLmDKX5SpYDCtQwqpKaPY1jCgm5Dnv
 jSiWyhe6
 wKM1FtwF4qIoekJB27HGteIAFYoyukENUyRsWl72wttFwkP64fwW8yq4tuwXwyZCUZUEHrfj57H2arx5w9WZcBkZIRvudCnvu4D9FFlanSlMSINM5KVUTwsAqsTMA+IpGXdvX1W7wihJc1XRiLhC36QSaFt2aLHNLlLlbGW1lxwlknRqarpxCregqa3g05MI0RwllTOOwtfbeZ45MaWfoME8pIWy083FWiFKwLJxS2IMMfFZ/WhxqpLwRlCxmKPHNxhSR2DwETbsKueAfL4fBvapgGsoFRaQJDXnM2ZOvsxOY5yHQFc880pLXrDUR4PR/apMDRhyMgg7gSgVvt8QhT6EbbkCirhHqQWHcyOgjqYGJAvP3P6uLuOcKavmlQWd4tHbwz0rar8Je8s7Gxm59K3CDWvYfCSw9QApk0JCCblPaCw82Nr2BCFGt5vbXB5j6sBeBtL9ZR40bqWE/nIjOOiJofRSmF/zfQL5Au00nJow+Pbcr4F+YXFD5Mw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/13 1:02, Zi Yan wrote:
> On 12 Jan 2026, at 10:09, Kefeng Wang wrote:
> 
>> The alloc_contig_pages() spends a significant amount of time within
>> pfn_range_valid_contig().
>>
>> - set_max_huge_pages
>>     - 99.98% alloc_pool_huge_folio
>>          only_alloc_fresh_hugetlb_folio.isra.0
>>        - alloc_contig_frozen_pages_noprof
>>           - 87.00% pfn_range_valid_contig
>>                pfn_to_online_page
>>           - 12.91% alloc_contig_frozen_range_noprof
>>                4.51% replace_free_hugepage_folios
>>              - 4.02% prep_new_page
>>                   prep_compound_page
>>              - 2.98% undo_isolate_page_range
>>                 - 2.79% unset_migratetype_isolate
>>                    - 2.75% __move_freepages_block_isolate
>>                         2.71% __move_freepages_block
>>              - 0.98% start_isolate_page_range
>>                   0.66% set_migratetype_isolate
>>
>> To optimize this process, use the new helper has_unmovable_pages()
> 
> s/has_unmovable_pages/page_is_unmovable

Indeed.

> 
>> to avoid more unnecessary iterations for compound pages, such as
>> THP, and high-order buddy pages, which significantly improving the
> 
> s/THP/THP not on LRU/

Sure

> 
>> efficiency of contiguous memory allocation.
>>
>> A simple test on machine with 114G free memory, allocate 120 * 1G
>> HugeTLB folios(104 successfully returned),
>>
>>    time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
>>
>> Before: 0m3.605s
>> After:  0m0.602s
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   mm/page_alloc.c | 25 ++++++++-----------------
>>   1 file changed, 8 insertions(+), 17 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index d8d5379c44dc..813c5f57883f 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -7157,18 +7157,20 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>>   				   unsigned long nr_pages, bool skip_hugetlb,
>>   				   bool *skipped_hugetlb)
>>   {
>> -	unsigned long i, end_pfn = start_pfn + nr_pages;
>> +	unsigned long end_pfn = start_pfn + nr_pages;
>>   	struct page *page;
>>
>> -	for (i = start_pfn; i < end_pfn; i++) {
>> -		page = pfn_to_online_page(i);
>> +	while (start_pfn < end_pfn) {
>> +		unsigned long step = 1;
>> +
>> +		page = pfn_to_online_page(start_pfn);
>>   		if (!page)
>>   			return false;
>>
>>   		if (page_zone(page) != z)
>>   			return false;
>>
>> -		if (PageReserved(page))
>> +		if (page_is_unmovable(z, page, PB_ISOLATE_MODE_OTHER, &step))
>>   			return false;
>>
>>   		/*
>> @@ -7183,9 +7185,6 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>>   		if (PageHuge(page)) {
>>   			unsigned int order;
>>
>> -			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
>> -				return false;
>> -
>>   			if (skip_hugetlb) {
>>   				*skipped_hugetlb = true;
>>   				return false;
>> @@ -7196,17 +7195,9 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>>   			if ((order >= MAX_FOLIO_ORDER) ||
>>   			    (nr_pages <= (1 << order)))
>>   				return false;
> 
> How does page_is_unmovable() interact with the code inside “if (PageHuge(page))”?
> page_is_unmovable() only identify 1GB hugetlb as unmovable, so skip_hugetlb still
> works?

Initially, I wanted to move the skip_hugetlb processing into a new
page_is_unmovable() by introducing a new PB_ISOLATE_MODE, passing the
skip_hugetlb/skipped_hugetlb/nr_pages to page_is_unmovable(), it looks
very complicated/ugly.

if (PageHuage()) {
	if(page is unmovable)
		return;
	skip_hugetlb processing
}

Back to the current code before I made any changes, skip_hugetlb logical
only works for movable huge pages by checking
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION, the checking is not incomplete
since no runtime check, but the new helper made a better judgment.



And after changes,

if (page_is_unmovale())
	return

if (PageHuge())
	skip_hugetlb processing
	
I don' change the skip hugetlb logical, the only drawback is the
PageHuge is checked twice, Maybe I miss something?

> 
>> -
>> -			/*
>> -			 * Reaching this point means we've encounted a huge page
>> -			 * smaller than nr_pages, skip all pfn's for that page.
>> -			 *
>> -			 * We can't get here from a tail-PageHuge, as it implies
>> -			 * we started a scan in the middle of a hugepage larger
>> -			 * than nr_pages - which the prior check filters for.
>> -			 */
>> -			i += (1 << order) - 1;
>>   		}
>> +
>> +		start_pfn += step;
>>   	}
>>   	return true;
>>   }
>> -- 
>> 2.27.0
> 
> 
> Best Regards,
> Yan, Zi


