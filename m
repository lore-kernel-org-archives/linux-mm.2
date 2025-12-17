Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DFD3D6408D
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 08:09:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F01616B00AA; Wed, 17 Dec 2025 03:09:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC9516B00AB; Wed, 17 Dec 2025 03:09:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF5216B00AC; Wed, 17 Dec 2025 03:09:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CCB126B00AA
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 03:09:35 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6FA39160945
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 08:09:35 +0000 (UTC)
X-FDA: 84228238710.17.D675AA6
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf30.hostedemail.com (Postfix) with ESMTP id D614580002
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 08:09:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=IdYRFb5F;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765958972; a=rsa-sha256;
	cv=none;
	b=yfkn/68jZ3eKPnwvRYaX2VuluGXaaagISdUoOtmvQwzvgkeu66Suet4pUhg2H4P2BMkH0f
	zEGABpc6IknHU+0DiSMWKMBDVViQAmusbJhotouGs6qvSuHtfP+qmJUP6qqnjcAS77XNkA
	8G/vgB2SwOoAK3Srz120c4iCpadnACg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=IdYRFb5F;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765958972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=adLEJ1K9GwkFV3Pi18g66LPqTiYedGBQjPOlmR6+t88=;
	b=iOtjPWkPf4FqA5iMD63YJwVZYQaYWp/PEq5o4WMdKExnVPKjVSM8xU+16ZatDzIdGgt90w
	e7l6rnEfPNe7Yudp4GhtJ3WjItBa5fvqZN55XuVz1WR3G6dwmkbrgQDGjbSLFqJQrrz1tm
	phuL2oN7rd+xdLxt+2b9H8MkjB9VpKw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=adLEJ1K9GwkFV3Pi18g66LPqTiYedGBQjPOlmR6+t88=;
	b=IdYRFb5FuKu2PaTVp530CSh1v77z7TOpaoHIWet5igR7U8GMg96SyEj2zJG61UTLOFJWBoQhZ
	PYBoIURSDTgEYMl4/xGy+3p8jQmHFYXxMjlI47Oh7x+CGVGfPKANQp90te7Ojb/0Wj42KIjxt5g
	WDfMBQ2BBW1vw4lUfCxI40s=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4dWRFt2CkLz1K96F;
	Wed, 17 Dec 2025 16:06:26 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id DD6E4140279;
	Wed, 17 Dec 2025 16:09:26 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 17 Dec 2025 16:09:25 +0800
Message-ID: <de2e93ca-830a-4bc0-841a-1ed70ab1a61f@huawei.com>
Date: Wed, 17 Dec 2025 16:09:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/6] mm: hugetlb: allocate frozen pages in
 alloc_gigantic_folio()
To: Zi Yan <ziy@nvidia.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>, <sidhartha.kumar@oracle.com>,
	<jane.chu@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, David Hildenbrand <david@kernel.org>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
 <20251216114844.2126250-7-wangkefeng.wang@huawei.com>
 <EA31F2A7-D0BF-4A49-8F05-C2E7B73A3556@nvidia.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <EA31F2A7-D0BF-4A49-8F05-C2E7B73A3556@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D614580002
X-Stat-Signature: smp6wccpakiguqqgxtrkbro5i4br84ke
X-Rspam-User: 
X-HE-Tag: 1765958971-462410
X-HE-Meta: U2FsdGVkX1+YDGZhc1EqbbqA2fsKOnSn4i90mC0tjAY5AiNtduR+ei/XsPhzuvgIeHX6UhZ+Nc8/Q5p9slkAdnHQZepl44AOXviihO6kRYUBlAHq8Tt3LjtnCpJ3v4kqvEv8hblCObiI7aPOL6rSD3G7F5iFEHO3fmPcKGSsOliaQuo99mbEiB/YFEOS9dE0lsWF90rLu2LouzUt77PRMO0OMP8ZiZLAPtR1zNmHLWfuum00T6twugbIBVl8LLrnAuuR65v6xNuoKF3RIc0CGeT5+/O3Q97jpIqrRbn5MisxwRgxx255fhUq36kQ9IYhDYG7fyXi7QY2koQF+2rWJDmv2ZGvlUFsEK+MBrZaGEbaP+NF45NvjqT9SRh1QSV5UL7hBQp6e1M27t7ni/fNIuUIkCzvI72FNQAiF2O18vBrDFMq2TAbGoJXJLHcDo2E7XFTQv2fJpguopsNXNoZG09OZeBKp5hHP7zKLGRos+MDAoAweqcnX0b7RhkfNm2QI2ysTS06GWqVZ3CDvErP4BwCa5RUpA8ND6KiokA/PM6DxoiYnfGGlkvDDkw3+CP3TmQVobE9ppRChnJMT14emvVuCBi99CKYlvCxTZ5hu2ZH+2mStotbfwtckV4OfsKRKfqjVvNqqdWy19TVt7SDipcTcWvcecpXuhFkjhL+Wz7F1ckSEmIo5gz78ipVNSKei3CGaKdBNpOE9GWnfYwrmTzyKL3awsaiNM9j2tIpldCyv2JyU3E1SrlHw0JAI3Wajl3bFelvb7GRrWBH2rQy4zvk7IuroHXjLfiKIBDV9mAwd9URYwq+bujsn+ILQREmoijLV0htXfyJQ6gGWiODHZoMc5j4f3KC/d8maCxwcvrVzFcaTu/PBTY9oHLW23bINR95OA9X4NTm769cox0hMAR4EkQDzbb4PuH1gMzr4dot+h1xaBIieGr5b7EP0N9nOPSpl90GE93nLvov6hq
 o7z0WfjB
 BrnJjT34AvOXB7XPTgwW5FXDQldbLSmaLVJ9VjGS6/NfVzu1aNEg38A6J4GWMgQ+0A1KdfCPsYemoRgeOZnnIWp1B11xm0QL5hIbQPRTy2qM0pwSM7+Ej58B5Rz+KRyMnJAdHsrLnb3qX0AYKKjFc3qur0d6VuWW9g2WW4wafD7k4hvB9LnLmNHQrX5B8F/+uzKlrWiy7fyJ1JGB5RlrXRwcwvtzw+QGKVM9afiYdhU+K+mUj73aUZ9SLOAJN8HRZkxoLHhKG88XE5DlUKriooo52R9EB1M3mA7W9KpulVw5gn4Ro0hIe6shhDzN704cDvql3Qe48BANvvdj8oOK1OW+AmAagDWNhwk0zsDnWJ7jrc83YwvwObjfZ4sZRbSA75gqO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/17 2:44, Zi Yan wrote:
> On 16 Dec 2025, at 6:48, Kefeng Wang wrote:
> 
>> The alloc_gigantic_folio() allocates a folio with refcount increated
>> and then freeze it, convert to allocate a frozen folio to remove the
>> atomic operation about folio refcount, and saving atomic operation
>> during __update_and_free_hugetlb_folio() too.
>>
>> Besides, rename hugetlb_cma_{alloc,free}_folio() with frozen which
>> make them more self-explanatory.
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   mm/hugetlb.c     | 63 +++++++++++-------------------------------------
>>   mm/hugetlb_cma.c |  9 +++----
>>   mm/hugetlb_cma.h | 10 ++++----
>>   3 files changed, 22 insertions(+), 60 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index ed185bbca419..7779ec838da0 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -121,16 +121,6 @@ static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
>>   		unsigned long start, unsigned long end, bool take_locks);
>>   static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
>>
>> -static void hugetlb_free_folio(struct folio *folio)
>> -{
>> -	if (folio_test_hugetlb_cma(folio)) {
>> -		hugetlb_cma_free_folio(folio);
>> -		return;
>> -	}
>> -
>> -	folio_put(folio);
>> -}
>> -
>>   static inline bool subpool_is_free(struct hugepage_subpool *spool)
>>   {
>>   	if (spool->count)
>> @@ -1417,51 +1407,24 @@ static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
>>   	return NULL;
>>   }
>>
>> -#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>> -#ifdef CONFIG_CONTIG_ALLOC
>> +#if defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE) && defined(CONFIG_CONTIG_ALLOC)
>>   static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
>>   		int nid, nodemask_t *nodemask)
>>   {
>>   	struct folio *folio;
>> -	bool retried = false;
>>
>> -retry:
>> -	folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
>> -	if (!folio) {
>> -		struct page *page;
>> -
>> -		if (hugetlb_cma_exclusive_alloc())
>> -			return NULL;
>> -
>> -		page = alloc_contig_frozen_pages(1 << order, gfp_mask, nid, nodemask);
>> -		if (!page)
>> -			return NULL;
>> -
>> -		set_page_refcounted(page);
>> -		folio = page_folio(page);
>> -	}
>> -
>> -	if (folio_ref_freeze(folio, 1))
>> +	folio = hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, nodemask);
>> +	if (folio)
>>   		return folio;
> 
> alloc_gigantic_folio() actually returns a frozen folio. Should it be renamed
> to alloc_frozen_gigantic_folio()?

I don't change it as alloc_buddy_hugetlb_folio is not with frozen, we 
could change both of them if you prefer with frozen :)
	

> 
> 
> Best Regards,
> Yan, Zi
> 


