Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AFAA606E487
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=mQcxeC6t
Received: by kanga.kvack.org (Postfix)
	id 5FBA96B05FD; Mon, 16 Nov 2026 06:18:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D3346B0600; Mon, 16 Nov 2026 06:18:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 510D36B0604; Mon, 16 Nov 2026 06:18:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 320D06B05FD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:18:02 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C3E191608D6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:18:01 +0000 (UTC)
X-FDA: 85440732762.12.81F08BE
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8D543C0004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:17:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=mQcxeC6t;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gcSYfJo9DBtW87ibrEcEB+4TxGxQarLrxm69h/JCdcA=;
	b=fj1FISLmd+krWq2Yg6r+a4VjVo31Ha0I1RKHCp5B3OwQW4Z/BCVIB7z0G5xG3LbEUsty+G
	EBpEq34LV6Qi0UvuYldoUyE6fAO6BJzkfo60auOAXbkIUl8nLky6+4rQtzb5IseEMKMBim
	7Akd9WBR/rGp/GRbpfd7GrUHsrJgu3c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=mQcxeC6t;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827880;
	b=dVBZsx0soTqAsjIbOqUOeNTTc1DRRq5tqfCCI9nHKpeLdlUEdGdCwVTDJFK2s607vfAqhz
	8eZW7WY8bnAGE2QCTP091bKupPPbucnZH93XT4XCrdodtwUertmPw/q5Pns+PZmvOrzaj+
	VMFpiiBQoIhwFu1KJTJL3mTTLpw2n9E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794827870; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=gcSYfJo9DBtW87ibrEcEB+4TxGxQarLrxm69h/JCdcA=;
 b=mQcxeC6tNSjEUQqT1PHD9V7k1HbfoEE3KELg89HubxEA97yFDXM9EtbD4F9tKVWOGoQ2gY
 RMfsd1avzgnoSVOBDbDRW5wKY5iSx9e3Bh3m2YMbQIOvOohcMR1FLEbqvM3/a02HtWwi15
 cSY7pzarXdhyHFfiq/lg8h9E8CDXgbv266+7lwOIn7nVjkC7Sfw+NOSb3bQ9q4qBryBSZ+
 WYLa3mUGNEDq7zs79X3YBv8aVRNSLNbdO9utyS7I9gDoFc8mSd3TTTAE99n3c9zDbKd/DD
 DzyD6y/VGMkCGaKuQ6m8yfFJVFyTQxqBAaNp95lIPoMIsXpGq3C9gGQl23O2Uw==
References: <20261113033442.62970-1-songmuchun@bytedance.com> <179482576829.2379196.3205677806966393313.b4-review@b4>
In-Reply-To: <179482576829.2379196.3205677806966393313.b4-review@b4>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: "Andrew Morton" <akpm@linux-foundation.org>, 
	"David Hildenbrand" <david@kernel.org>, 
	"Oscar Salvador" <osalvador@suse.de>, 
	"Andrew Popple" <apopple@nvidia.com>, 
	"Balbir Singh" <balbirs@nvidia.com>, "Lorenzo Stoakes" <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, 
	"Vlastimil Babka" <vbabka@kernel.org>, 
	"Suren Baghdasaryan" <surenb@google.com>, 
	"Michal Hocko" <mhocko@suse.com>, "Muchun Song" <muchun.song@linux.dev>, 
	"James Houghton" <jthoughton@google.com>, 
	"Lance Yang" <lance.yang@linux.dev>, "Qi Zheng" <qi.zheng@linux.dev>, 
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
X-Lms-Return-Path: <lba+26afae65c+834d37+kvack.org+lizhe.67@bytedance.com>
Date: Mon, 16 Nov 2026 19:17:27 +0800
Message-Id: <f38322fb-abb7-4284-b6d5-bd6e747333bb@bytedance.com>
User-Agent: Mozilla Thunderbird
To: "Mike Rapoport" <rppt@kernel.org>, 
	"Muchun Song" <songmuchun@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH v2 00/14] mm: Unify memmap initialization for compound pages
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8D543C0004
X-Stat-Signature: g5stmw65bq3q78n16ws564fc9y8hp1fx
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794827877-126646
X-HE-Meta: U2FsdGVkX18uMsCCi/FlrLf5+GKka3ryXZWzQsG6nrau1BtkbZGvq9Ck+2jH21MKTT9MHZdCbtp7mgu5gpvJCG6VOoLU8Vr2nOYb4mQrg3yMFF5OMUIfHfptESQjA82jQ2RuCIKKqBu4FmChtFJWWnlKtdnKE7JIpIM+Ub6rnnePKqcY91PbmHpvtKMvRm4e10GwxuvBZYTjKIwHLGEgVy4ZcRlTPJnknC2hLhJb78gZOwZPLKXOhLLOsJLOXhqKkcdgisHqNOgHtXyfww73XNFa7zFr10JrVGvGricHwXSapKWDZTpOqr2vBFvEWzMCvHlbqwkGd1eA04CpEAwqxRhnMyN8ZkfrQwLU5vd5qyqg4sJvSzzOECLm861myDuyJFG0vhv1SlpCcCJoJfKPlQIunmnMOi+lXrinGYrsdPn/n9iwEI4cVqatCfNSfLv4VAufI6LJOJq3YET8V9qqUSIny8c9kEYsXul7vKf+lQvA6PsfSyVMvFIL2DgVYc7jRQnIXAfL60GtqO/xjRSt+9ETLBVfoHNueerWmBzDsLmqXlK6Ui8K6HQLs74MQD1HnZSBgLN+m7iQRI+4leSlMEpfOeLb3I/09cQbUE4OgdApY1PkR2OCNX6Abr87OX4PdkNM67r7+6+UOLDrTVJIewcy8DR92w6krPQGhq3BKMcsI+OFXYMPFsf4o+xipr1fssFqKb/ycxrWp0uEiCx1jfd3YXLy0OJ6FTWH4WPptb93GVe21IvF8x07vtw2ZZz5+xE5C2yavwSWY2O9y097mMuzM10QZldLJAsXBxSM2VhUvTV1TjZnTY67akXUzRAgJlEVzhSx1PzRPnArP4FNEk+w4Eeu/YcxoCNPPq7Y4aVTLybqTZH1VV2p4PrfFLoXArpfy+kEo132WbsVlKqjityyr4yJfBcTML5YeJ/rre5AK1XZa4rh9VlCdsPjOjl/J0Qe7fz7iUEU9b+jj06
 N1g/fSBq
 UjB4/P1nOHMfPuS7FwizJqXVBDJn/ckearBhTT/vENJYYEFJgX10FOxhNyfB6/w3ojWPMv5s5ZatmPUejbRVIMXD7M5lxxqPkTyg+GH8XE5l5RrZ/dsVUhQZwUXfha0TUxi+NOGizFuVbyAheGYjRJTIjL8sMM9TcuYP/vLppKDyYYfO34OPAKZuScQa7Op43Qf+tfQSXp3CCI/XB4kUMLiyoiZfsuApxCO5XFuBoqVioGAydKvXVKN0cdLBCZmHW89Msxipw6XHN/u/H/P056h+gtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 6:42 PM, Mike Rapoport wrote:
> Hi,
>
>> Hi,
>>
>> This v2 is based on the mm-new branch at commit daed51c91051.
>>
>> This series is split out from the earlier, larger series
>> "mm: Generalize HVO for HugeTLB and device DAX" [1]. That series
>> generalized vmemmap optimization across HugeTLB and device DAX. One
>> remaining piece is the separate compound struct page initialization used
>> by boot-time gigantic HugeTLB pages and compound ZONE_DEVICE ranges.
>>
>> This v2 also folds in Li Zhe's two-patch series, using that series' v2
>> as the integration point [2].
>>
>> Li Zhe (2):
>>    mm/mm_init: factor out memmap_init_page_from_template()
>>    mm/hugetlb: optimize bootmem hugepage tail vmemmap init
>>
>> Muchun Song (12):
>>    mm/mm_init: verify zones for template-initialized pages
>>    mm/mm_init: factor out common struct page initialization
>>    mm/mm_init: simplify zone device page initialization
>>    mm/mm_init: factor out frozen compound page initialization
>>    mm/hugetlb: drop boot-time HVO handling for gigantic folios
>>    mm/hugetlb: initialize all struct pages for bootmem hugepages
>>    mm/hugetlb: use common compound page initialization helper
>>    mm/mm_init: make __init_single_page() static
>>    mm/mm_init: make memmap_init_page_from_template() static
>>    mm/cma: centralize CMA pageblock initialization
>>    mm/cma: localize init_cma_pageblock() to cma.c
>>    mm/mm_init: move pageblock migratetype init to memmap helpers
>>
>>   include/linux/mm.h   |   8 --
>>   mm/cma.c             |  24 +++--
>>   mm/hugetlb.c         | 111 ++-----------------
>>   mm/hugetlb_vmemmap.c |  17 +--
>>   mm/mm_init.c         | 247 +++++++++++++++++--------------------------
>>   mm/mm_init.h         |  13 +--
>>   mm/sparse-vmemmap.c  |   7 +-
>>   7 files changed, 129 insertions(+), 298 deletions(-)
> That's nice :)
>
> The series would be easier to review if Li Zhe's patches were integrated
> rather than stacked in. I hoped that the changes for template
> initialization would fit into the patches that rework other parts.
>
> The way it's done now several patches in the beginning of the series
> change code that the later patches remove or turn some of new functions
> into static.
>
> Another thing is that the numbers Li Zhe measured were for a different
> implementation, so they would be stale for the state after these
> changes.


Agreed. I would be happy to provide updated performance numbers once the
final integrated form is ready.

Thanks,
Zhe

>
> I have some nits and naming comments in a few patches, other than that
> the series LGTM.

