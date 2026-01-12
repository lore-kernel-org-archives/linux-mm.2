Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDA8CD2502E
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 01:02:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34D5E6B0088; Sun, 11 Jan 2026 20:02:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32AAF6B008C; Sun, 11 Jan 2026 20:02:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 241AD6B0092; Sun, 11 Jan 2026 20:02:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 14F306B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 20:02:42 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9FFC9D24B0
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 01:02:41 +0000 (UTC)
X-FDA: 84321511722.11.154A190
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf07.hostedemail.com (Postfix) with ESMTP id 48B9940007
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 01:02:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2GL4nCqS;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768179759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aPg6vaCImr+ip55lfi4oRdXLrN6Qwtt0VRIZwuaq5lg=;
	b=PKTv0a8ofk1dE2a3R8TwCarx5CdMnK+3a7Obde8sEE97AJwdMi0mi6sBfoWGP9jqXtWPQG
	1HsS47P5pUPsyD7WToG16oIfE/FPU5vBUalZU3Wgql5PyLQ+FXDXF5l99EZTEUUHlsRXzo
	crK0+weZc33DSBJBHo0v+wsZsGqcaYw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2GL4nCqS;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768179759; a=rsa-sha256;
	cv=none;
	b=P2K6GSsa37jioWSZT6w7TMQUTmFXPFkrp93OEgNL41626qCr4MrTdNbke8FTlZF4LVNYhK
	rYv4LCnCzGjo/SGT0MFwSFwsbiYak5kANIMAI3VInnlzEuqTWj6iu5HasxYAlVeO0s0lKx
	iRvdUbuCDMyUbiu5Efk7hNtC35SHvdc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=aPg6vaCImr+ip55lfi4oRdXLrN6Qwtt0VRIZwuaq5lg=;
	b=2GL4nCqS+yevqC9rPhkgLQP9aAeDas5HZQ3bkGvB7uCA6XuRsB8W+ODC7/FiS5U+B0bHDhxqn
	H7XZk20KUcU59W/hBpAADp7+3XBHcb7QLOjTS5p44iPOt5nYhIqVfSdIZdPXT85SRvzqO38c8xd
	YpWHDdn7WOuMg6I270LiS2Y=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4dqDYH0tRYz12Lfl;
	Mon, 12 Jan 2026 08:59:31 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id B25A2404AD;
	Mon, 12 Jan 2026 09:02:32 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 12 Jan 2026 09:02:31 +0800
Message-ID: <1f8d9e87-ffb7-4cf5-b408-90e576115402@huawei.com>
Date: Mon, 12 Jan 2026 09:02:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm: page_alloc: optimize pfn_range_valid_contig()
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Muchun Song <muchun.song@linux.dev>, <linux-mm@kvack.org>,
	<sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
References: <20260110042111.1541894-1-wangkefeng.wang@huawei.com>
 <20260110042111.1541894-2-wangkefeng.wang@huawei.com>
 <20260110154327.6a723dc91c059ac219272bcb@linux-foundation.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20260110154327.6a723dc91c059ac219272bcb@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: k7d8ieydnc39er4atfa4fawwhecstnjo
X-Rspamd-Queue-Id: 48B9940007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768179757-46562
X-HE-Meta: U2FsdGVkX1+AtfdS/8FwaWIlZiDb8Cwhjs/iajaepNLvsfe1IyTnxJ/clmwvRG+34vHy4OTzeKniocGXYJQNTFBCQ7FTtR/Bn7hY3Ne6+DWHJEcZWujsqqpkjXF70nbOq6bhDmfIMJ2dUa+B1XzPpkV6VOazg+7cf14NwZRBA4dJJJyniisPOW8lQhJou6eGTqJ2c82zBPvr0P0Vuna9AalwvE35qtmb4w7EiD7cyS8fiNvQHPe+bHw5cVkJrIDhsnCVISKn1sGxlkI7kWVbnNldevYQMvSIl3gOfEQ/nykaVis/5wgPqPBs6FYuLixpjYrMyoDSuNXufwqOdQhmk9uTd2ypQC6cO0G3D1zfDohc0lxv+mCOG59/M9io7flaCz3/bfE01KlfVjL0cXfD8gcbKVS6AWEvzSz8sn3Xf42mC7SL0jWvpmTvAJEzWpXT527dX8sbUu0Mh8gR144tZfhYKsmmmJn9rllmn+6spoV3pyjbl5+yJ6UqotwuzajJ7YbVoiwL5YHYKRX11qWW5TOM04FfXTTlVZh/kKXRCd8rAfq4H2XVTpBvQhW5gxSyyqF6w59h/7zu7IOZ0D++uNEKOK6qBEr9y+GpnuoHKpNbEnP8STqOpBN6OQhl0IRRiOj9MaOsmiw9Qpz3WlnqzF8w5NWpeayQtn0xB4cYZKIDKxtiU++ooATmEKSLzE0+5jriYQSBmK1nLYtvLwZD2qk5degQk4ZLPn/hWWUAAX8OckGudatqhb5ZeHfmKHmpfiY9CX/yR5ZcpnMf8cozaSTCaTVKbPM3tXD67ZHMPcbWa4hHlml5p2cFqVZcbswSntiwBnpYKnJcOjYJWbRXnJhMY6l4qxU88UEU9bFp8LQMUSlEMllxjmRV0G2JjFYggdOemkCyhEH3BUJrPju6fxR6r0WWircjkXZWoppn8l+BNBD1lX+fklOUMyJ1soad27znzm+CL1lbFt/kFuu
 8ipCFKSc
 6RZdrdn98jIfWi9G5cHKrl4uYFKoHHtF4RaLCbUH5M8fqkQpB4bxEhckPaIiQfqhM6z3kG0SpXo9IZhisrUOD9O/Yt5SIW24G20MB89sYo8Aom/EIuYtnCJsmX4+2dxB/aJDnLWL+dPDNhdI6bDJpaK8Krk3g9W7xP9M9bxSXTAnmgztWOxWx/QHIFnn3eXBenbzfFNAAmLe04ptwvI+LM4EDJKAcNlaGXPcz9lix8Nv9MzQyS0cnwuxgYOI9HjONwJUljj5AcQG0zdNUjq9qT7Xo8YzD00vvMNh2LdlwkXxq/jakfSIMZBr4Vev3s7nrevLMnzoo555F6e7e8w6tEBcD4hlrnCyPLnvLQeXbuGg+sn+WOPvciaE9E6hhqfSizjM+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/11 7:43, Andrew Morton wrote:
> On Sat, 10 Jan 2026 12:21:09 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
> 
>> The alloc_contig_pages() function spends a significant amount of time
>> within the pfn_range_valid_contig() function.
> 
> Trivia time: saying "the foo() function" is no more useful than simply
> saying "foo()".  "foo() spends a significant..." is shorter and causes
> no information loss!

Sure.

> 
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
>> To optimize this process, implement a new helper page_is_unmovable(),
>> which reuses the logic from has_unmovable_pages(). This function avoids
>> unnecessary iterations for compound pages, such as THP, and non-compound
>> high-order buddy pages, which significantly improving the efficiency of
>> contiguous memory allocation.
>>
>> A simple test on machine with 114G free memory, allocate 120 * 1G
>> HugeTLB folios(104 successfully returned),
>>
>>    time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
>>
>> Before: 0m3.605s
>> After:  0m0.602s
> 
> Well dang,  I'm surprised that the previous code was so bad.

I found this when testing the previous patch(frozen gigantic folio
allocation), The efficiency of traversing each pfn is too low.

> 
> The patch does a lot of code movement, which makes it hard to see
> what it actually does.  Is it possible to split these apart?
> move-stuff-around, then speed-stuff-up?

OK, will split it.

> 


