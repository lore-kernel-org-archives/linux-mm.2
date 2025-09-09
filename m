Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEE87CAC589
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 07:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23BF28E0009; Tue,  9 Sep 2025 03:35:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213D78E0001; Tue,  9 Sep 2025 03:35:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 150D38E0009; Tue,  9 Sep 2025 03:35:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 03BAC8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 03:35:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9D37613AC2B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:35:00 +0000 (UTC)
X-FDA: 83868900360.08.3B12587
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2091C4000A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:34:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757403298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wWqwnLu21iaRBkTeVDXSVjy/dtrDLQKY88fSbXxxJNg=;
	b=UIsLlgwzZDyWhQ1QHL/HrcS9VYmicck6JT1u3alM9i+yJ8Y6JhbewmM1WSCvyiEt3HwElh
	Mgbnc0pUqLryG9TG0EPwIAHiwkdi7MHtf73UNK/McxSr4ygOM2sjf5rNSFfMDOKTpR4xO8
	7aKyfWTo5KvZ/UDziT1dEIJSne7yq9E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757403298; a=rsa-sha256;
	cv=none;
	b=HvbS3ep15Ba1iuFzNNxYKOOny8Qn3x0lBb114rfslxZHRc9MQsPVs8qpe1hPbnGwbq4Gtx
	69qLq/vlIXTzcg2BxENkP+7qjY6FPnCpJ2gjV7SsOs+z/59ScxHJiaWMvEut30nTMxh07o
	YKYiq0qaL3ojX/doVzABImfABRlVsd0=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cLbD72SpgztSph;
	Tue,  9 Sep 2025 15:33:59 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id A83751402C4;
	Tue,  9 Sep 2025 15:34:54 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Sep 2025 15:34:53 +0800
Message-ID: <631af84e-c2e0-4d4d-b55d-eda41fbe58ba@huawei.com>
Date: Tue, 9 Sep 2025 15:34:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 9/9] mm: hugetlb: allocate frozen pages in
 alloc_gigantic_folio()
To: Zi Yan <ziy@nvidia.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, <linux-mm@kvack.org>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-10-wangkefeng.wang@huawei.com>
 <FAA075C3-7C56-434A-BB23-973E947E8F24@nvidia.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <FAA075C3-7C56-434A-BB23-973E947E8F24@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 2091C4000A
X-Rspamd-Server: rspam05
X-Stat-Signature: 4kh7zszd1ttpq6fh39z3at8doe6s9zp3
X-Rspam-User: 
X-HE-Tag: 1757403297-427064
X-HE-Meta: U2FsdGVkX18ybAU8dHgFpxyOfiXq2J/iYDLrTj1HP7cdMWIvHCNZCkAzL/x3dP3bTj5Oy0iO1gqrG8p0DNFSh9BAyKTHsbXNje9wGP6/QbaVNw+2y/bTahQM8kbUBybZGdHnXKS6O2FsjemRtFCtQ4hprhPBzisGE+mMIGwl6oypsHLN0bjIWdj2jPthAnZFla6pS9a71Z/xRJofw1rz8lL2Mk9GeTschq8TxyoDtobE8Ft2fDQFi5e5D8R5/Z0eTa27MCDQVjo8Wyxfd+BP/a1c6wkV7AlwAzkfhLCo8mRLG6q3Sj84BetmVQ84iToOXC2Mhsoomq11EKqkFly3zrkESIprYrdeaD85Cyz7nlH6MpoRXk8Rnq1JsBDM2XASJumuiCkmBSq/ynd3I0djfCb7BbDhTI28VC2umyT6VuSfHMPjNRyGsJBfRnQOLdn5ZCjG1kuea3v9cTHHfbFYty0pzSla+PB5rbMiy5fLZANNtT+Pb8+VhpPOHUSjmS4q8YfrQ4aj5ESq78aj6/1xKRfZe3dfXmB3LCITT0FZTR+PUU5GvORCe5eESMp+Douxx7+aKi6sw49JZNPVXNzOmB2XRh4IlUaoAFByPXV+bNCK338U5Cf/gpz8OCbJaqjt58MB1biLMMJD94PjEIlCrEMGPpVgmgsy1PpepxL5geygU/92S4ycYGCcHV+XQ3I2qRc49wwacSGUZb9PSjJH9TSGXcnDIsfJOW7bXnji4x1xKd2Yy5XXIxFZ5fyWstOkNhWOBnANYTMsHij8aNC+FQlTmSqoRoJx+Ceiw7DGGVBIBThkD53WFGleRzZ5BfuVQrSbgui7sN7PIwh7sanU9qG2rvjAcpORhUt/WL/MpqgyLlhi6UIlbNkUbAGYeWg+E8SYU3/s3C7XnivzIS8h/iaw+7b+hCBxt6P1R0N9iqbnmthYWmO3mPVbvvLNcyvpTwi1bkxgdhEEng0Z5jL
 1Rbo2tli
 TIrNQy2Yfcxnr/Q55fZZA+oVhI449NDkKmv5WBJhaUh6Klo0/K+pXquYCK6oS0YFXxrX5UcBIpfZox684oz/QiYqT9dcMM6UNQcAE9iPPP7u9npFp8KvhMa5uF7dgK20/eN9GdSNhtzTRsJgD7fZfDgouqvYdHIkstUAVwtMkYDKU9DmaNyNCyCnSJnYiYBMgHatFSO6UIACGA9eTw3W334igc6ShZ8lzm2Vdq/NAD//YzYCcLUJ+icb4PG6w1pSW8gcB5URCERktFnNXxUcL1SWzdgkas0qEiM9huCx92C8yVj6OjsIiNszQ/HMJFKBLksCP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/9 10:02, Zi Yan wrote:
> On 2 Sep 2025, at 8:48, Kefeng Wang wrote:
> 
>> The alloc_gigantic_folio() will allocate a folio by alloc_contig_range()
> 
> s/will allocate/allocates, since you are describing an existing behavior.
> It confused me when I look at the code change.

OK,

> 
>> with refcount increated and then freeze it, convert to allocate a frozen
>> folio directly to remove the atomic operation about folio refcount, also
>> saving atomic operation during __update_and_free_hugetlb_folio too.
>>
>> Rename some functions to make them more self-explanatory,
>>
>>    folio_alloc_gigantic		-> folio_alloc_frozen_gigantic
>>    cma_alloc/free_folio		-> cma_alloc/free_frozen_folio
> 
> s/cma_alloc/cma_alloc_folio, s/cma_alloc/cma_alloc_frozen_folio.
> If you do not want to type folio multiple times,
> 
> {cma_alloc,free}_folio -> {cma_alloc,free}_frozen_folio would be
> less confusing.
> 
>>    hugetlb_cma_alloc/free_folio	-> hugetlb_cma_alloc/free_frozen_folio
> 
> ditto.

Will update,

> 
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   include/linux/cma.h |  8 ++++----
>>   include/linux/gfp.h | 14 ++++++-------
>>   mm/cma.c            | 22 +++++++++++++-------
>>   mm/hugetlb.c        | 50 +++++++++------------------------------------
>>   mm/hugetlb_cma.c    | 13 ++++++------
>>   mm/hugetlb_cma.h    | 10 ++++-----
>>   6 files changed, 47 insertions(+), 70 deletions(-)
>>
>> diff --git a/include/linux/cma.h b/include/linux/cma.h
>> index e5745d2aec55..cceec7b25bae 100644
>> --- a/include/linux/cma.h
>> +++ b/include/linux/cma.h
>> @@ -57,16 +57,16 @@ extern bool cma_intersects(struct cma *cma, unsigned long start, unsigned long e
>>   extern void cma_reserve_pages_on_error(struct cma *cma);
>>
>>   #ifdef CONFIG_CMA
>> -struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp);
>> -bool cma_free_folio(struct cma *cma, const struct folio *folio);
>> +struct folio *cma_alloc_frozen_folio(struct cma *cma, int order, gfp_t gfp);
>> +bool cma_free_frozen_folio(struct cma *cma, const struct folio *folio);
>>   bool cma_validate_zones(struct cma *cma);
>>   #else
>> -static inline struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
>> +static inline struct folio *cma_alloc_frozen_folio(struct cma *cma, int order, gfp_t gfp)
>>   {
>>   	return NULL;
>>   }
>>
>> -static inline bool cma_free_folio(struct cma *cma, const struct folio *folio)
>> +static inline bool cma_free_frozen_folio(struct cma *cma, const struct folio *folio)
>>   {
>>   	return false;
>>   }
>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>> index d0047b85fe34..ceda042be704 100644
>> --- a/include/linux/gfp.h
>> +++ b/include/linux/gfp.h
>> @@ -447,26 +447,26 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
>>   void free_contig_range(unsigned long pfn, unsigned long nr_pages);
>>
>>   #ifdef CONFIG_CONTIG_ALLOC
>> -static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
>> -							int nid, nodemask_t *node)
>> +static inline struct folio *folio_alloc_frozen_gigantic_noprof(int order,
>> +		gfp_t gfp, int nid, nodemask_t *node)
>>   {
>>   	struct page *page;
>>
>>   	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
>>   		return NULL;
>>
>> -	page = alloc_contig_pages_noprof(1 << order, gfp, nid, node);
>> +	page = alloc_contig_frozen_pages_noprof(1 << order, gfp, nid, node);
>>
>>   	return page ? page_folio(page) : NULL;
>>   }
>>   #else
>> -static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
>> -							int nid, nodemask_t *node)
>> +static inline struct folio *folio_alloc_frozen_gigantic_noprof(int order,
>> +		gfp_t gfp, int nid, nodemask_t *node)
>>   {
>>   	return NULL;
>>   }
>>   #endif
>> -/* This should be paired with folio_put() rather than free_contig_range(). */
>> -#define folio_alloc_gigantic(...) alloc_hooks(folio_alloc_gigantic_noprof(__VA_ARGS__))
>> +/* This must be paired with free_frozen_pages() rather than free_contig_range(). */
>> +#define folio_alloc_frozen_gigantic(...) alloc_hooks(folio_alloc_frozen_gigantic_noprof(__VA_ARGS__))
>>
>>   #endif /* __LINUX_GFP_H */
>> diff --git a/mm/cma.c b/mm/cma.c
>> index b4413e382d5d..49d53879c1d0 100644
>> --- a/mm/cma.c
>> +++ b/mm/cma.c
>> @@ -924,20 +924,21 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
>>   			   ACR_FLAGS_CMA);
>>   }
>>
>> -struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
>> +struct folio *cma_alloc_frozen_folio(struct cma *cma, int order, gfp_t gfp)
>>   {
>>   	struct page *page;
>>
>>   	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
>>   		return NULL;
>>
>> -	page = __cma_alloc(cma, 1 << order, order, gfp, ACR_FLAGS_CMA);
>> +	page = __cma_alloc(cma, 1 << order, order, gfp,
>> +			   ACR_FLAGS_CMA | ACR_FLAGS_FROZEN);
>>
>>   	return page ? page_folio(page) : NULL;
>>   }
>>
>>   static bool __cma_release(struct cma *cma, const struct page *pages,
>> -			  unsigned long count)
>> +			  unsigned long count, bool frozen_page)
>>   {
>>   	unsigned long pfn, end;
>>   	int r;
>> @@ -960,7 +961,14 @@ static bool __cma_release(struct cma *cma, const struct page *pages,
>>   	if (r == cma->nranges)
>>   		return false;
>>
>> -	free_contig_range(pfn, count);
>> +	if (frozen_page) {
>> +		struct page *head_page = compound_head((struct page *)pages);
> 
> A WARN_ONCE refcount check might be helpful, since there are two
> cases here.

ACK, thanks for all comments.

> 
>> +
>> +		free_frozen_pages(head_page, compound_order(head_page));
>> +	} else {
>> +		free_contig_range(pfn, count);
>> +	}
>> +
> 
> Best Regards,
> Yan, Zi


