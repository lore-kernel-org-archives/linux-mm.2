Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45AC0CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:05:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88A9C8E000D; Tue,  9 Sep 2025 22:05:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 862378E0005; Tue,  9 Sep 2025 22:05:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79EA18E000D; Tue,  9 Sep 2025 22:05:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6493B8E0005
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:05:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 194E413B454
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:05:57 +0000 (UTC)
X-FDA: 83871699954.20.EEC7417
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf25.hostedemail.com (Postfix) with ESMTP id E26D3A0008
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:05:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757469955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FA2zqg6E3njNH4bo2LCqKXDIyZ+LC+Uk67cQvqQNd60=;
	b=gD6YoVIgfAv1w5zqe9raJOI7EEHsgKduoe9vpzlm5zLNEtanfH/jeA950JOHaPr4Kc4DmT
	HsT3Jc0RwirFwNMh2UKI3twBwlz5+xROHYXCvXBGtBbo8AfD67Q+uQEpc3GRNmxiOj7L+U
	4NvmDjV4N6HYQn94JSWW/OQy2jSWUos=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757469955; a=rsa-sha256;
	cv=none;
	b=P34AP7d2+Kn1bh2uMY6qznTbYbWr0sWTqLxMr70EVFck5SoiwuNiBC/v4DoC8gSCtrivLH
	vnIjuvOpgAR1ra8wBP2UWaFcDZcgupAwHi2+QtdwPZOFkjAzBmUnhBzhphvy8OQGT2m7Nl
	3BD2289C6YFRS7SLKnwXRB4ACu1yFaI=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4cM3pt4J8dz24j8p;
	Wed, 10 Sep 2025 10:02:14 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id A7CAC140142;
	Wed, 10 Sep 2025 10:05:29 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 10 Sep 2025 10:05:28 +0800
Message-ID: <ce5cbd2b-ccbd-496a-95c0-501b972cd691@huawei.com>
Date: Wed, 10 Sep 2025 10:05:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/9] mm: page_alloc: add alloc_contig_frozen_pages()
To: Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, <linux-mm@kvack.org>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-7-wangkefeng.wang@huawei.com>
 <aMB4KhOX7IeFXaOZ@casper.infradead.org>
 <B41EB8CB-3337-45B3-B952-70359AAFF2D7@nvidia.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <B41EB8CB-3337-45B3-B952-70359AAFF2D7@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: E26D3A0008
X-Rspamd-Server: rspam05
X-Stat-Signature: 3zhqkdijp1nufww4arj65ufishtrs1k6
X-Rspam-User: 
X-HE-Tag: 1757469953-773567
X-HE-Meta: U2FsdGVkX1+geTnTGYfx42gX8hDMtbW4WLMOqbMQUF/LUXSBAP7b5U2m+j2oXRevhlW0RGc+oeni/+ZGB5MnwAQJU28gUl4jGq7xzzxqg6Q7IcHn24x2GD7QTtcprQ6zcQ+ADi3LR1RfVBjaVRaj+wvDL4c+TiVZAlxUWoO5fgA/qBEgGYY1Nh/4H6SMJ6sPsJ/f37ASZVT1ExkZJUzttx7W2jwrw/qFBzQIXoQyPOXLveVZrW8sGQVn0AQAUV5g4u8NKmIG3iIofQkBzG1r6KMgS84Q1os1JyEzAhEXGcWtktf7j7aEfK6nH+K7BpDIIvbEGJNapGr0iAPeicq5tA+J8ZTN5MA9FdDWtZ+uqHxfJ9fl858jDE3UAZDt+jJYN5UDB0x9w5MKToQY7KdKPeEhI7eAH3npNbCcjHUZ15LlV01qXN+s6uMcwg/RyyZgi9Cyo4PmAIfzsq5bXT65Ksy1y9oB6Zmebc20Xr4youLCfvTSuxNva57OINNSjmxvOAx7fKEV1Z21JOtvNbsu+/5p7iqmWiA6pNOiLmlZTp6oE0pI33vivPFgvgREFbNHYZJeYCcF3rAY8CxwDbk6+Ap0VAXHQ/B7Y8fITx+abzFLoiYXv4GBZhmwno+ikA6KZpoEcWK3G8zrj1QHeq5bNunGOJ+WTONkQvRU5GNw3xJJlXT9LcOWN9KyVhrdANSHySbhuwqpWrT6Knm1ad3pGIyg1Sx1e4K2hnqpUYw5UpRb3M54SVNbypCrWOWxL/Flv6N0jayp8A3Z/IxbBUDsu1R0GD4pW5cbTMU62O/dm9Q+sYxzOk3IdHJ1iIcjLIzDEuJ9lLNfhQmt1Wc4Jlp0FDDXXcHUd3rTD7/W/t7WE2z6uLObTUBGkYw5IrWEKIXflCg875r2rMmZxLM5prsn8CXgby9HErvpoqOKRyh4RXvBtNkYeRfkvt8jHswA0QrOfgtVdeFXbOGBKvNBr+d
 WqC3fVv5
 7KOHb8KsR6lgWmSCYmJQiXfW5t5KGKaBhkG+BqoQFh76Pv5+ICiomUSVM2r6kpNjmaCjSN1+NWDKKw9H09hUpM77fNuhGNhaRFvM5lhprXyvsITIdzNznTSB8WW0zz8LtRWd3EtYFYj3r1KU9qESZZOzLVcL72JfE5vLOMqbhrTa5D7RrESG3Pl/q+JsoCetRHDR2GB2BxEJGRkAwyhbZgAbrmG9a5GE8sqGUKRndBC02YDBygwgKiVzOaWHndVm9mnAs6BCVnAvCbrkrn9UD+ft5lCd0bI9NPNMsU9kz7jYePag0LwCAlV80wQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/10 3:08, Zi Yan wrote:
> On 9 Sep 2025, at 14:55, Matthew Wilcox wrote:
> 
>> On Tue, Sep 02, 2025 at 08:48:17PM +0800, Kefeng Wang wrote:
>>> Introduce a ACR_FLAGS_FROZEN flags to indicate that we want to
>>> allocate a frozen compound pages by alloc_contig_range(), also
>>> provide alloc_contig_frozen_pages() to allocate pages without
>>> incrementing their refcount, which may be beneficial to some
>>> users (eg hugetlb).
>>
>> No, this is not the way to do it.  We're moving towards a future where
>> pages don't have refcounts (their owning structs eg folios may have a
>> refcount, but struct page does not have a refcount).  So work towards
>> that; if you need to keep compatibility with some users, then by all
>> means keep alloc_contig_range_noprof() as a wrapper that calls
>> alloc_contig_range_frozen_noprof() and then calls set_page_refcounted()
>> if alloc_contig_range_frozen_noprof() does not return NULL.  But I'd
>> be looking to see if alloc_contig_range_noprof() can always return a
>> non-refcounted page.
> 

Yes, Zi has been comment this shown below, alloc_contig_pages_noprof()
is called by may driver(directly or indirectly), I originally only hoped
to minimize the changes, if we follow your plan, we can do a bit more,
let me try the new way. Also I will separate this patchset to let the 
cleanup patch could be merged first.

> Something like:
> 
> struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
> 		int nid, nodemask_t *nodemask)
> {
> 	struct page *page = __alloc_frozen_contig_pages_noprof(...);
> 	
> 	// just added page == NULL check
> 	if (!page)
> 		return NULL;
> 
> 	if (gfp_mask & __GFP_COMP)
> 		set_page_refcounted(page);
> 	else {
> 		unsigned long i;
> 
> 		for (i = 0; i < nr_pages; i++)
> 			set_page_refcounted(page + i);
> 	}
> 	return page;
> }
> 
> as I suggested in another email[1] (of course I forgot to check page == NULL).
> 
> And other TODOs:
> 
> 1. remove set_page_refcounted() in split_free_pages();
> 2. a new split_frozen_page() to do split_page() work without
>     set_page_refcounted() and split_page() can just call it;
> 3. a new free_frozen_contig_range() and free_contig_range()
>     calls it.
> 


Thanks Matthew/Zi.


> 
> [1] https://lore.kernel.org/linux-mm/298B40E0-8EA5-4667-86EF-22F88B832839@nvidia.com/
> 
> Best Regards,
> Yan, Zi


