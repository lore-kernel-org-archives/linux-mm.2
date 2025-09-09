Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81DB0CAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 07:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4E2A8E0011; Tue,  9 Sep 2025 03:11:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C26038E0001; Tue,  9 Sep 2025 03:11:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B62D38E0011; Tue,  9 Sep 2025 03:11:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A50898E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 03:11:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4DB101A03C6
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:11:54 +0000 (UTC)
X-FDA: 83868842148.22.3524448
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9B4CB1C0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:11:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757401912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cdwHXxAo4JdWBobprc3yzb+PmylxJS5l+Pf7X7HvL0M=;
	b=EoropI6Mn17QIk5zORuW7DSSluvGnKsPC4O0ZX6Si/coWZh1MhmWIJW6e5c/WaowHAwZLd
	IaTqF5UMf8c9rFpxA1tlpRilo6nnaNSK+1m2daz/198LU2S0gZlQMZhK583WcyJNt66s5r
	iGsiuM/wOnD6ExYktcXayl2/FTYKP/Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757401912; a=rsa-sha256;
	cv=none;
	b=jFylZ/TkUHDSk5F7OcgNqYsb0ArBmpFwcM8OVyOnHQoSgEWP7jOdkPqLWkCu7qTNShQDTi
	WMkrEwNycIW2oBouEdnwp6o8SQgueYZW51+SM5opsmm2O8Mkxp9o08oKYUXoQwrVkc62Ni
	1i/1KlGQeLc4TE6LhQ+M1tzDsgMO7YY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4cLZfl32n5z24hrN;
	Tue,  9 Sep 2025 15:08:31 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 783491A016C;
	Tue,  9 Sep 2025 15:11:45 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Sep 2025 15:11:44 +0800
Message-ID: <6fc277ef-81b5-4aa3-b6a2-64da1d645231@huawei.com>
Date: Tue, 9 Sep 2025 15:11:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/9] mm: hugetlb: directly pass order when allocate a
 hugetlb folio
To: Zi Yan <ziy@nvidia.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, <linux-mm@kvack.org>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-4-wangkefeng.wang@huawei.com>
 <64DE9265-7B31-4128-9949-84AF050CBFF4@nvidia.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <64DE9265-7B31-4128-9949-84AF050CBFF4@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: wfnampwbdjk18rg9fsd777xo1a5uhsos
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B4CB1C0003
X-Rspamd-Server: rspam10
X-HE-Tag: 1757401911-798564
X-HE-Meta: U2FsdGVkX1+l/rOQnvkAJGlVFGPcU81ycj+aqNslkrKJxoZmAZjCvHjnyNETsEIlFIW6rh6OikEEFiGDlRMTZry7xhjATyCComGb/oN5AfQWj/eQ88taKGaYOopzP5mcNV+19ImiVesqKLzJecrZ8K8ArPC1UBPjPW2TmzeqPiyQn2xzs5D3w63WuvImeR9v8ndkQ4MPrYhndF/hebuX7mlizqql96SsSose6K+rARxYYIUPamglFp7WlUGbDTHkQVFgzgJDyihqIWJQCIpkdSlh0ccoMCatMa7YQpKKTZI7QJ61dMrh2ENbFYfcBevbX4uGGxrkR70eDn1mNXj+4FL9l35pKqufROb7NCzHjeJH9dQmg8jxTR47yrsPlBPKFVbhccKmhteDoFQmvNF+rp9wg7cYgzjflJY1i3hxHSBEBxI0qxuwN4mRNrmyMGjIYQTrpeCEqXNcL22hpl4mz4ZbAKmPJBuphHQU+UUYm9s4wtql8aVk8aIzU/H5DofVlsD1RwLJMXd1cX9PSdN0t43iT0z3UILN6bzIJd+QJ0noiMDQi0KliF8dFBeOfpXoabtnLAu4ts5sqa2hDDScNMY/QCoimp53xCNEBt1MB/Wwcca0IklH2axmc1mNRJWKsQ3lA/9QCc80KV1fh9+fPQiTs4Bwbk4DAVXRRT5l7RY5FqKmONJogx3UQRkVJXkKcOQJrs8L0Rh8JURZQQ1ZS+blYTxf1jXN4A60FNAUOX/MuaYikIFrqjdLiejQNxHk3V//p4aDeaqIlFVYVFhFFHZ0OhbRLb7AKSjh5+tAx4fVTLU12piNNMZ04CVO+EBZp0sKgMZVS6oaEbBitfHVVoY5kMcIuHzCI/o7jZrAIaQfKfTgvI+ZhpGw27BwNvJcpZC3RbC1uiYZGZThuiIsnYEvv8AjOawbuQeHjvT4XwUQBKUZJLstHnLKRKhpWi/Al3NO0XLrxDw374Wa6um
 npjZX7nr
 OTSPSle900dVJFXEiKd1GLRBGO2VJx0k7yWuZjTWejGT3C7Y6fS1ef9gafigg4Lw4USnIQulJ4taO0pXD0Q468zlW9K69se4h7c19ojDhX/BwyegG4prW2u3mx3wSmH9gQI6wLaOq8O5Nmr7dDbuVVE5jknSbXBBR44w1tgvlyaC/zkWklpTVa+qrXITqBxnMRMb7tnummxqPXF6MqeQirvCNGC1QHMvOI13RXaEn362h/Ds4wj1WKVbkBD5fjJ68gD6YdmcatSF6TxOtrzD1xxMTJTlynaD25vOc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/9 9:11, Zi Yan wrote:
> On 2 Sep 2025, at 8:48, Kefeng Wang wrote:
> 
>> Use order instead of struct hstate to remove huge_page_order() call
>> from all hugetlb folio allocation.
>>
>> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
>> Reviewed-by: Jane Chu <jane.chu@oracle.com>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   mm/hugetlb.c     | 27 +++++++++++++--------------
>>   mm/hugetlb_cma.c |  3 +--
>>   mm/hugetlb_cma.h |  6 +++---
>>   3 files changed, 17 insertions(+), 19 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 4131467fc1cd..5c93faf82674 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -1473,17 +1473,16 @@ static int hstate_next_node_to_free(struct hstate *h, nodemask_t *nodes_allowed)
>>
>>   #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>>   #ifdef CONFIG_CONTIG_ALLOC
>> -static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
>> +static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
>>   		int nid, nodemask_t *nodemask)
>>   {
>>   	struct folio *folio;
>> -	int order = huge_page_order(h);
>>   	bool retried = false;
>>
>>   	if (nid == NUMA_NO_NODE)
>>   		nid = numa_mem_id();
>>   retry:
>> -	folio = hugetlb_cma_alloc_folio(h, gfp_mask, nid, nodemask);
>> +	folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
>>   	if (!folio) {
>>   		if (hugetlb_cma_exclusive_alloc())
>>   			return NULL;
>> @@ -1506,16 +1505,16 @@ static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
>>   }
>>
>>   #else /* !CONFIG_CONTIG_ALLOC */
>> -static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
>> -					int nid, nodemask_t *nodemask)
>> +static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
>> +					  nodemask_t *nodemask)
>>   {
>>   	return NULL;
>>   }
>>   #endif /* CONFIG_CONTIG_ALLOC */
>>
>>   #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE */
>> -static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
>> -					int nid, nodemask_t *nodemask)
>> +static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
>> +					  nodemask_t *nodemask)
>>   {
>>   	return NULL;
>>   }
>> @@ -1926,11 +1925,9 @@ struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio)
>>   	return NULL;
>>   }
>>
>> -static struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
>> -		gfp_t gfp_mask, int nid, nodemask_t *nmask,
>> -		nodemask_t *node_alloc_noretry)
>> +static struct folio *alloc_buddy_hugetlb_folio(int order, gfp_t gfp_mask,
>> +		int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry)
>>   {
>> -	int order = huge_page_order(h);
>>   	struct folio *folio;
>>   	bool alloc_try_hard = true;
>>
>> @@ -1980,11 +1977,13 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
>>   		nodemask_t *node_alloc_noretry)
>>   {
>>   	struct folio *folio;
>> +	int order = huge_page_order(h);
>>
>> -	if (hstate_is_gigantic(h))
>> -		folio = alloc_gigantic_folio(h, gfp_mask, nid, nmask);
>> +	if (order > MAX_PAGE_ORDER)
> 
> Would it be better to add
> 
> bool order_is_gigantic(unsigned int order)
> {
> 	return order > MAX_PAGE_ORDER;
> }
> 
> for this check? And change hstate_is_gigantic() to
> 
> return order_is_gigantic(huge_page_order(h));
> 
> To make _is_gigantic() check more consistent.
> BTW, isolate_or_dissolve_huge_folio() can use order_is_gigantic() too.


It may not be very valuable, but I could do it in the next.

> 
> Otherwise, Reviewed-by: Zi Yan <ziy@nvidia.com>
> 

Thanks.

