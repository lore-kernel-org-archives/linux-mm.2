Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31C1CCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 06:57:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23BC48E000C; Fri, 12 Sep 2025 02:57:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EC458E000A; Fri, 12 Sep 2025 02:57:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DB7E8E000C; Fri, 12 Sep 2025 02:57:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ECE758E000A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:57:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 55537C0710
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:57:51 +0000 (UTC)
X-FDA: 83879693142.24.AACA50E
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5D9F1140007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:57:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757660269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rEeUP1T0lx5PRAjhkMef4Hyxcf8QsiH+anEc80YJTug=;
	b=8XCkcH/QKitUZF7DFLQpQSSVupJ30FWLXuFCmyPYW0anl2bkk+kHLw3GTiBm5Gj4Q1ZOX7
	iJ1EbDkbVINwN29PrbIw6TFQVa5AnwG7L0456kueDsGF1h6QypPoSCG3UG+ur+muYZt6ew
	hz1Z0LpBbOiHnEyZIWiSv75QoCzjOf0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757660269; a=rsa-sha256;
	cv=none;
	b=rJzWWlr66wpQHsizh449tKsSF/lV9YPpc6LzOX2FyjEkHd1qF+SG+840jpEdGLx7gPeLGf
	qr9tz7nUkEgKjcxUSoXGLESoP0tHGl5KXEhr4BDBxKocqib/xjKvqhuQjxsdsaWL11ZXke
	DdWs0gkbfhMGyUqWZuZFLgB/vFVfOtU=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cNQ9Z6C6mzQlKs;
	Fri, 12 Sep 2025 14:53:06 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id F0504180064;
	Fri, 12 Sep 2025 14:57:43 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 12 Sep 2025 14:57:42 +0800
Message-ID: <d63e7e02-b2ab-46fb-b981-ad4f4f28d634@huawei.com>
Date: Fri, 12 Sep 2025 14:57:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm: hugetlb: allocate frozen pages in
 alloc_gigantic_folio()
To: David Hildenbrand <david@redhat.com>,
	<20250910133958.301467-1-wangkefeng.wang@huawei.com>, Andrew Morton
	<akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Wilcox
	<willy@infradead.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>
References: <20250911065659.617954-1-wangkefeng.wang@huawei.com>
 <20250911065659.617954-5-wangkefeng.wang@huawei.com>
 <90e926c9-40cb-4791-8360-e3d145fe3503@redhat.com>
 <8508e8fb-77cc-43a7-8460-456f68a552ba@huawei.com>
 <667133bd-0021-4d4e-9cde-fc8c1324522a@redhat.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <667133bd-0021-4d4e-9cde-fc8c1324522a@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 5D9F1140007
X-Rspamd-Server: rspam05
X-Stat-Signature: 4jd9dp3zdrtumxot87bct3hstt8bnkbs
X-Rspam-User: 
X-HE-Tag: 1757660268-525780
X-HE-Meta: U2FsdGVkX187MoIdbEORAzKLbHJO799ieRVDXo5HziztsoGof3OQmNlh95w6de3IcDlxrvAVxWrX6th6k/DAoVAr1a9WW5ApBsLwXfCrlsel5PmUDjDMW5za4wMFIe4saDP3DrsxRnk2a4VOmuWl8qeroyw66PedHXb0ieDJ7yc/NeJ/tlixnJAEw8av7PpnLqygZKcJTw9FoM7DUL6PpxrFpWrXjUTA9LGSPB46Ix2HTrdVbdVNncUSvIzy7qv/rPJ1wqaZfQG/NW9pa8kAtftjNhXfz7wdmwNMPAxJrt9OlEYUWWRJfdm0z8mgH/PK6NITxx5E0+JJH8oH2UXlcj7DTC7q0f5/p1iX1j0OZLjL/P9+N9fNFxGzx5j93d+ihA+DxxhBreXzDcoZOsK1F54scy3VT6bmFu9jEazG6xVy1VXWJwel+vwLyQA4LOZndR37Nflg5PLpcVouEySzocYmeVpu4ht5Ce0nI+QEqtJotd+bsbywF/blHUgdMDx4eWT8sxJsGDNrPxvWFsCgN6EC/a4hgptz6ExQxKmdHP7biW8Cp6QTEf/9xSljyHNSSYN4Xjtnf5xM9rmubdjg0cJXaWbacWQE1KuawIfbOHg1VRwZtBdwch6yUp0Zbi1u1ozKlwyjDIxmYql0uvFl2R4Cae2Zx8peJwtI+MIOZNUr0smkXAW4rrWYQUCtaiNDBaD/MAEBWtVPQf0ASGAVyoVCuKFFN7tdTUgIXt+3dcTHRUB7ZvkJZ8cycbKA/ZOQr/NwJIj85CVAkATfEci9iIV9FiFpOstFBGShtUiqE3YwLk/fzRrjNrbtXyVnWULV3SBXZCdZ3jcfEwi/Lw0qoVG6Uy4jZHbl5NkvCJOorSd3puhWHA55bq/dCeEsRS2JvA/hAopja75ysP8wAmrQZd3Eo89jlSQIuKuLqld6L3hZlrzzIr5uo/bPGKYo0YmOR8HlPzASRpltg2ItoII
 oXk9r00+
 j762mewe+HQ6Ipits8wDxnQh5jUDF/AypHkaRR+MaZvNGv5rNE0r4S0ezEuKpI+evANZH4fzkmAp6ckJ3hOoqG7T7NmhTLTdloJ7ZoNxupi8FxPWo9vZ0oYgNElaTqDNJ7S1y2GQQtfU15i6O6NCEq9PAgrpre+xqO5YhRnBiCo1IY8YXpAkWlMud7vlL8IOs7FGFK3mbt+DYeAL05/TBuqvLnNveEGCXaIAOkd7Q9IlU6tT76jBOzL4ECeYwZgYZEcerzC4jz7x0ZqrtGruDX2zsu8O29ciYa8ei
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/12 2:56, David Hildenbrand wrote:
> On 11.09.25 11:11, Kefeng Wang wrote:
>>
>>
>> On 2025/9/11 16:25, David Hildenbrand wrote:
>>> On 11.09.25 08:56, Kefeng Wang wrote:
>>>> The alloc_gigantic_folio() allocates a folio by alloc_contig_range()
>>>> with refcount increated and then freeze it, convert to allocate a 
>>>> frozen
>>>> folio directly to remove the atomic operation about folio refcount, 
>>>> also
>>>> saving atomic operation during __update_and_free_hugetlb_folio too.
>>>>
>>>> Rename some functions to make them more self-explanatory,
>>>>
>>>>     folio_alloc_gigantic            -> folio_alloc_frozen_gigantic
>>>>     cma_{alloc,free}_folio          -> cma_{alloc,free}_frozen_folio
>>>>     hugetlb_cma_{alloc,free}_folio  -> hugetlb_cma_{alloc,free}
>>>> _frozen_folio
>>>
>>> Can we just get rid of folio_alloc_frozen_gigantic?
>>>
>>
>> OK, we could kill it.
>>
>>> Further, can we just get rid of cma_{alloc,free}_frozen_folio() as well
>>> and just let hugetlb use alloc_contig_range_frozen() etc?
>>
>> HugeTLB can allocate folio by alloc_contig_frozen_pages() directly, but
>> it could allocate from hugetlb_cma, cma_alloc_folio() need change some
>> cma metadata, so we need to keep it.
> 
> Hm. Assuming we just have cma_alloc_frozen() -- again, probably what 
> cma_alloc() would look like in the future, hugetlb can just construct a 
> folio out of that.

I get your point，firstly, we could convert to use cma_alloc_frozen()
instead of cma_alloc_folio() in hugetlb_cma_alloc_folio().

> 
> Maybe we just want a helper to create a folio out of a given page range?
> 
> And that page range is either obtained through cma_alloc_frozen() or 
> alloc_contig_frozen_pages().
> 
> Just a thought, keeping in mind that these things should probably just 
> work with frozen pages and let allcoating of a memdesc etc. be taken 
> care of someone else.
> 
> I'd be happy if we can remove the GFP_COMPOUND parameter from 
> alloc_contig*.

But not sure about this part,  GFP_COMPOUND for alloc_contig* is
introduced by commit e98337d11bbd "mm/contig_alloc: support __GFP_COMP",
if we still allocate a range of order-0 pages and create a folio
outside, it will slow the large folio allocation.


> 
> @Willy, what's your take?
> 


