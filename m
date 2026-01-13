Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16630D29DFC
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 09:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81E646B0089; Tue, 13 Jan 2026 04:56:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DF296B008A; Tue, 13 Jan 2026 04:56:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 719076B008C; Tue, 13 Jan 2026 04:56:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 62AE76B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:56:03 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 068DF1AD28C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:56:03 +0000 (UTC)
X-FDA: 84326484606.07.1E2B2B2
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf06.hostedemail.com (Postfix) with ESMTP id 61812180002
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:55:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=17UoLV4v;
	spf=pass (imf06.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768298161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z1uDSgYCvrv6D2OKPsbVkajv9M1D2NhT8Gze+K7ZoM8=;
	b=u3bJE0gr//MrN2rrFggPez7XhJy57nTdm5FJVu0HdbtQGhg66we8ctmZF4lCkEQ6yF86iw
	Hcl/2KouC0LnseEEPK8LLIpsOLA/e0mzsjp0ZQ8i174zRn8qUGmD0FaM+371zNMhG5dQHH
	JGgP8qVeTjqWimm88O/IUPijvGLbYOc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=17UoLV4v;
	spf=pass (imf06.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768298161; a=rsa-sha256;
	cv=none;
	b=7jLKHRAAv1BGPDqc3PkcA1lSSaEYmnDnfz9oNGDmRGGnQmrWCsYo5gkjSFgtVIdzex1N2y
	B0ETBBl0NF98Qvr77AUqZlzTWcwSc3gQVgiBz48R/6Ov6vIypKECHL7g3C9lan5mCMWl8M
	8hHG5Ggx6M7LEx4DzqiH6LqYT+jYm5U=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=z1uDSgYCvrv6D2OKPsbVkajv9M1D2NhT8Gze+K7ZoM8=;
	b=17UoLV4v/O8SrmaKa/80dmkd5BgZY6sjrIDUi7I59T9VoJZnFhj59AieKdq6BCCdJMZII+5/4
	B0xWu9ntIG5QXOy1uCMgNHCfXl/17eQp2b0NYrRW43fHWb2j9Bz9K1Qsoud7Ps6EfPhLhmhRaMN
	Mm3wS142noK9nwi1dPX7Ddg=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dr4Kg6YcRzpT0x;
	Tue, 13 Jan 2026 17:52:23 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id B92F940363;
	Tue, 13 Jan 2026 17:55:55 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 13 Jan 2026 17:55:54 +0800
Message-ID: <69484ee1-3d4b-4be2-80f5-8e1b39eb9319@huawei.com>
Date: Tue, 13 Jan 2026 17:55:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] mm: page_alloc: optimize pfn_range_valid_contig()
To: Oscar Salvador <osalvador@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	<linux-mm@kvack.org>, <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi
 Yan <ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>
References: <20260112150954.1802953-1-wangkefeng.wang@huawei.com>
 <20260112150954.1802953-3-wangkefeng.wang@huawei.com>
 <aWXUvSIvoXVWCXBU@localhost.localdomain>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <aWXUvSIvoXVWCXBU@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 61812180002
X-Stat-Signature: 6fwq3acpyzkqt4b3nt41u5e7e567smp6
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768298159-253728
X-HE-Meta: U2FsdGVkX181pgJ6+m7850EQCgbGk89+J+vmly7yxbjE3cQsPlmVuIURTHMNPEqYWYBcoPUpW5qEkSIlCoh6/v4MsS6fu/yPondIwbSg1bPnfdNlby9ke7bvAAZX9KREO+GhPhj79sin1jQR64W2v3XdIYy+YZQ6tu00YGI9ORwLR3wC2/gRI5uPn2TytYlX/O1tKzte7h3L0SdCkD6vV9WLNk0vUyllhCmuQNLCMjRMVeUmUNTVz1gLkTcaREu7Cs/0uO07ZRdeyTnNn91r6ebXcXmAmAL6ti1+glZo1sIvS2Vl/KUD+QSRSCjW08JX8WtiVSp4WpxjkO4IP0fWmcD82vbFGL4s0YCUyZ9sJDaQsv3YH48CNWRq1csfgPVwSKp8mkp2lp/auTMzC6hMduQpoF41iWz/DD6xs0k22VZOxj9P+W+h4rEPhgtTxxkA1+KZgPAGeMi2330V7/BEf7GHdiAv+8VZCA3BATwWAeoU1qJhtFWI/pbVvgdZuljU9ohhGy/NCXWVwZQ03wfKpm4aekFORrw22QV2rAefD7QKkuH4x6DRfZzFgQ9zJure9k7QAHfX3AUylSmNanC14z8Cx1WBPEM+VV8nYj+U5ba9WRdRPdfWMuZzMj3SarY14QdLx63FfUcZduxkoHAgWVIEoO4TpIuUrOAYIRcKBx9DMy90dJsqDE+l9KJWSPfW0SZBGpLa46Q3xdJbjxgBCZO9CSVODXbrDzEMa495samYA4ZfBQyEkyb+n6MuR6MxdGIQRGZwBAJQ7jqMQ08bjfI58WgSxBjY/hQBSUIDtGRXsFRpXULezUzWc5VmNrOPVDsZPXrVLZHRJHwqDW4gycySESzJLL7VzQeLB9DI/fJw9fGNkc16QhxxgjkAGWwrgH3IOr1Ey3ylelsK4JhGtuYBi2r56rzAZ0RucDVNOju5kZWDjA/FK0tKV2e8XEcF9xVxFbD5CJHQ/mQzbJ5
 ECCW91bP
 n3yRODdYm4GItLJ6ljI2o8CZfYoL2eMmx0UJDDzZBSnyupQDYCQTvLP55GE1Nc/G9OT0ZpuR1u0VTHnlCk+qJiDY0PIXeoYLLCSZ3EfNRL9Z3kwQz2DJGJpnA8VRbde9Y9IwmPyAhmNhhxLkia0ymuT1HXSJiXm2c1e7UP/9pk/oPXoQ7GXi7PkKR947IqfcDBAEtYdUk2fO6K1+2F7so1HzIq6VtIpYq0cuAsLUnVkvKPe80rSJkEYXaN08ZG0ilGuDjmnKc1WJ9zhz9ifqhexE6xs0uj5wBnNPAH4DqiPsD8eWtZjw1S8X3cFm6pK0ETwMg0Ok4iMsACgsoXn4bRXM0KuNA+yIWpg3Eoos1Vt2e/SwN3Pxawnr0yvjq18BJC2R5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/13 13:14, Oscar Salvador wrote:
> On Mon, Jan 12, 2026 at 11:09:51PM +0800, Kefeng Wang wrote:
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
>> to avoid more unnecessary iterations for compound pages, such as
>> THP, and high-order buddy pages, which significantly improving the
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
> 
> Looks good to me, just have a question below:
> 
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> 
>>   mm/page_alloc.c | 25 ++++++++-----------------
>>   1 file changed, 8 insertions(+), 17 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index d8d5379c44dc..813c5f57883f 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
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
> 
> Does this not get already covered in page_is_unmovable() somehow?
> size_to_hstate() would return no state for order >= MAX_FOLIO_ORDER
> folio sizes?

Yes, I think so.

> I mean, it is subtle, and I am perfectly fine leaving as is, just asking.
> 
>   
Let's keep it as is for explicit checking.


