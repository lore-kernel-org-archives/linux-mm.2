Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6EDAD29DFE
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 09:55:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04FD56B0005; Tue, 13 Jan 2026 04:55:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 010216B0089; Tue, 13 Jan 2026 04:55:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E54AA6B008A; Tue, 13 Jan 2026 04:55:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D99B36B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:55:53 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7A88616022D
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:55:53 +0000 (UTC)
X-FDA: 84326484186.18.1D9C998
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf25.hostedemail.com (Postfix) with ESMTP id D6533A0003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:55:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=JnPPs1sk;
	spf=pass (imf25.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768298151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fhtgw3zCh4IN3NcaL58aW7PjNk7s9V2wTddOthEN+rs=;
	b=tYKw82nf0YwyoNh+zJftt8FniLpaOkd/7ua+aXYc3lYXiLQiYHyUdzHZq3jNRrglXksW6O
	adsv/0j5GKZW+g8O6Imj5NJZLOpvZSn1J3abKXYlQXaj8d1oP2gqiA9xN7h+3sitU3xL9R
	z3/pTpCOfFiA/o4Zxio3HxZZWxnOslE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768298151; a=rsa-sha256;
	cv=none;
	b=hosJGN7GOyQJyOK01lzJJQFHf5VM/a57l3FRlIAtT3in7wRX8GCWekckB2zbyXSH8p7LYC
	T1ZZ+ny5fF9ENp6VoJFcGxUqMFrHeF7uO5InhLqav17iFnPIteW4g1Xdb8kXMWEJ24Ao4/
	09fM3RpYgYeJWqCCXbCfeV22k8MQOHQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=JnPPs1sk;
	spf=pass (imf25.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Fhtgw3zCh4IN3NcaL58aW7PjNk7s9V2wTddOthEN+rs=;
	b=JnPPs1sk16PJ8/zCuxcR76im2Us2eOxvv62S2n2xYMZ3VyKRKYsN70D3sM6OsnZjMnq6lGLN/
	+1aZfuSv/73uLk4nnptN48TJ7pNzNK7m81GnCKuG+ZUy9e/y8Hi1AXklRfVyMznRWTILVzxaHyh
	g6lK65lQVEy/+CGdXZSngaY=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dr4Kk1rHHzKm5n;
	Tue, 13 Jan 2026 17:52:26 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id E652A402AB;
	Tue, 13 Jan 2026 17:55:45 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 13 Jan 2026 17:55:44 +0800
Message-ID: <500811d3-67e9-44d3-bb67-095b23728aaa@huawei.com>
Date: Tue, 13 Jan 2026 17:55:43 +0800
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
 <db7a38dd-77c5-4adc-b0b1-ceee45fb1f51@huawei.com>
 <9FC904C5-1C5A-45BE-BE0F-556AF573AD4A@nvidia.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <9FC904C5-1C5A-45BE-BE0F-556AF573AD4A@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D6533A0003
X-Rspam-User: 
X-Stat-Signature: o5u1ykfnu8i7w1zsdndqnshyfua4csid
X-HE-Tag: 1768298150-405589
X-HE-Meta: U2FsdGVkX18oqa4DwETSkFLuAxA79fcVU7Taly7gDvtsM1VMISsF42BzqTJy4W4Qx4tQen0uF9XpNuKPpXaO1raO+iG9VLqibMjc1+5uycj/dLuhIq0IFMVUxXHbmU4TRrDVoADrrPGHi89olt+aUJh4sc+XV5vcGA+Qawl0BGPN2VWA3gYponZg2cj8tHSTt8xz0ZiM5eGusgraVIYPI2tdC1ZuWe0HO9GtPyTrNrP8JCobT+c8xl3cAiOWo7B5STGJ98CnNLUeJ+Tb2lGWPqbZ/eA+iCwJTPyeJXyHyTmViuX+4LvHq2b8ekhAZtYwBYTUPqnGGxT/Xjr2+bBSsk7HPpA8C7DiB08sI7U+q+4eJnjWebo5TxiaJTpeI96X2UDEUa7SR8fgn6szqyZaN7AXYr6Y6HWnwZx60YngpuPAV8yeqfzHGMB3NQKC8Gy6O+ys5uh/UrpLMqO5wrpIoN0j+N9C23KvXDGtl+Tpv9cxyNTVDJVWriB3NuXhuG+2h+TgUhXC/wukOkIf15RmNnUnQRIWukrdamFSYarlOaJ1AHOEtPqVvrOkLqC9+iS2rrcc9ikP7QUcwKxVMke9K+jZh907LcwcByybzNdKfvXFcwHZLcavoir4IIyivnlvx45VmTYz+tDk6pv/REi/tJZfT59znsj3krTHy7lPbCFBMmAPRaizPtg8YkG7AvETaE7QKJuazNVU76VHamaOkgAnY7lH3dgWU6OrAiNXxrie2deCSzMpZskNKJIioivHW0zeHh9KXaLqhZWrpI9G8D+klIcKptikcOMJWZGKbWXZ3q903vGMYeEbXR+CC8dt7v5o/rxA1C/uJTyJQ8WZPc+d4VZ02V+q1+llZp5RAvloUlAhfl9Or+TQgl9TumHHA85K566MhTlA2mlO8hROvx0LmOPF4bJY+1SOby+XBGWSJ+a8Dz5yQMcQDjdv20t8B4jZ432jxjN965bQtzn
 EtIfOuki
 R6JNjaE8wysdzIBmGw8Ft8hY9AoYbr9xCAnRvDgQirCynkBU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/13 9:27, Zi Yan wrote:
> On 12 Jan 2026, at 20:24, Kefeng Wang wrote:
> 
>> On 2026/1/13 1:02, Zi Yan wrote:
>>> On 12 Jan 2026, at 10:09, Kefeng Wang wrote:
>>>
>>>> The alloc_contig_pages() spends a significant amount of time within
>>>> pfn_range_valid_contig().
>>>>
>>>> - set_max_huge_pages
>>>>      - 99.98% alloc_pool_huge_folio
>>>>           only_alloc_fresh_hugetlb_folio.isra.0
>>>>         - alloc_contig_frozen_pages_noprof
>>>>            - 87.00% pfn_range_valid_contig
>>>>                 pfn_to_online_page
>>>>            - 12.91% alloc_contig_frozen_range_noprof
>>>>                 4.51% replace_free_hugepage_folios
>>>>               - 4.02% prep_new_page
>>>>                    prep_compound_page
>>>>               - 2.98% undo_isolate_page_range
>>>>                  - 2.79% unset_migratetype_isolate
>>>>                     - 2.75% __move_freepages_block_isolate
>>>>                          2.71% __move_freepages_block
>>>>               - 0.98% start_isolate_page_range
>>>>                    0.66% set_migratetype_isolate
>>>>
>>>> To optimize this process, use the new helper has_unmovable_pages()
>>>
>>> s/has_unmovable_pages/page_is_unmovable
>>
>> Indeed.
>>
>>>
>>>> to avoid more unnecessary iterations for compound pages, such as
>>>> THP, and high-order buddy pages, which significantly improving the
>>>
>>> s/THP/THP not on LRU/
>>
>> Sure
>>
>>>
>>>> efficiency of contiguous memory allocation.
>>>>
>>>> A simple test on machine with 114G free memory, allocate 120 * 1G
>>>> HugeTLB folios(104 successfully returned),
>>>>
>>>>     time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
>>>>
>>>> Before: 0m3.605s
>>>> After:  0m0.602s
>>>>
>>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>> ---
>>>>    mm/page_alloc.c | 25 ++++++++-----------------
>>>>    1 file changed, 8 insertions(+), 17 deletions(-)
>>>>
>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>> index d8d5379c44dc..813c5f57883f 100644
>>>> --- a/mm/page_alloc.c
>>>> +++ b/mm/page_alloc.c
>>>> @@ -7157,18 +7157,20 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>>>>    				   unsigned long nr_pages, bool skip_hugetlb,
>>>>    				   bool *skipped_hugetlb)
>>>>    {
>>>> -	unsigned long i, end_pfn = start_pfn + nr_pages;
>>>> +	unsigned long end_pfn = start_pfn + nr_pages;
>>>>    	struct page *page;
>>>>
>>>> -	for (i = start_pfn; i < end_pfn; i++) {
>>>> -		page = pfn_to_online_page(i);
>>>> +	while (start_pfn < end_pfn) {
>>>> +		unsigned long step = 1;
>>>> +
>>>> +		page = pfn_to_online_page(start_pfn);
>>>>    		if (!page)
>>>>    			return false;
>>>>
>>>>    		if (page_zone(page) != z)
>>>>    			return false;
>>>>
>>>> -		if (PageReserved(page))
>>>> +		if (page_is_unmovable(z, page, PB_ISOLATE_MODE_OTHER, &step))
>>>>    			return false;
>>>>
>>>>    		/*
>>>> @@ -7183,9 +7185,6 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>>>>    		if (PageHuge(page)) {
>>>>    			unsigned int order;
>>>>
>>>> -			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
>>>> -				return false;
>>>> -
>>>>    			if (skip_hugetlb) {
>>>>    				*skipped_hugetlb = true;
>>>>    				return false;
>>>> @@ -7196,17 +7195,9 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>>>>    			if ((order >= MAX_FOLIO_ORDER) ||
>>>>    			    (nr_pages <= (1 << order)))
>>>>    				return false;
>>>
>>> How does page_is_unmovable() interact with the code inside “if (PageHuge(page))”?
>>> page_is_unmovable() only identify 1GB hugetlb as unmovable, so skip_hugetlb still
>>> works?
>>
>> Initially, I wanted to move the skip_hugetlb processing into a new
>> page_is_unmovable() by introducing a new PB_ISOLATE_MODE, passing the
>> skip_hugetlb/skipped_hugetlb/nr_pages to page_is_unmovable(), it looks
>> very complicated/ugly.
>>
>> if (PageHuage()) {
>> 	if(page is unmovable)
>> 		return;
>> 	skip_hugetlb processing
>> }
>>
>> Back to the current code before I made any changes, skip_hugetlb logical
>> only works for movable huge pages by checking
>> CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION, the checking is not incomplete
>> since no runtime check, but the new helper made a better judgment.
>>
>>
>>
>> And after changes,
>>
>> if (page_is_unmovale())
>> 	return
>>
>> if (PageHuge())
>> 	skip_hugetlb processing
>> 	
>> I don' change the skip hugetlb logical, the only drawback is the
>> PageHuge is checked twice, Maybe I miss something?
> 
> Sounds good to me. Thanks. I just want to double check with you.
> 
> With the changes to the commit message, feel free to add

OK, I will update it.

> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> 

Thanks.

