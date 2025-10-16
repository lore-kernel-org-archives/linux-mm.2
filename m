Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C41CCCD185
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 01:35:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 730978E007A; Wed, 15 Oct 2025 21:35:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E16D8E0008; Wed, 15 Oct 2025 21:35:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D0488E007A; Wed, 15 Oct 2025 21:35:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4BA488E0008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 21:35:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E75DCB61DD
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:35:41 +0000 (UTC)
X-FDA: 84002260482.15.0E18095
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf22.hostedemail.com (Postfix) with ESMTP id EBEA5C000F
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:35:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=v86NiB8o;
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760578540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y0U8b94M/QxLDvLHBTc5mvJQnf2bosiBnQnhzMdzbqA=;
	b=q5W9qxxabUFJQnt3SazQ2n2ULYW5shE4bAN+K6CqrnzUtWeIMS72TDD0hKJWxb7tgZ4+Us
	XzBclwLlSFFAISlIT4yx/cb0MfNQBHYtGOp/2dSUKB3FJevRhr+YW2/hb8ahgqtYjNxpX3
	plmU1G0Qq3XHRBdqOeN+bM/nQ3Lz9No=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=v86NiB8o;
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760578540; a=rsa-sha256;
	cv=none;
	b=tyiqWrP6IBG0J95ML94bG2P3Mc7TDcH9srp9wIFX56S/BD4hpDqGdeeU2/sDQrqJtPhUiS
	ww/cOSeL2+joB+zkDF/e6mZk+0xvSliwlb7oShvXtTIt0J0rMYxAlnQYtrexl0Eh3YWGYO
	h9G/XJBcQIRtyF2uhWh7qoTCpfHf1dQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Y0U8b94M/QxLDvLHBTc5mvJQnf2bosiBnQnhzMdzbqA=;
	b=v86NiB8oBJDOdXIvcpvZU0M2MjO6gTYhquMHgzkz6XUN1/F6nBR0Rrc02n9NTE662QFgcFJxc
	T+7WkO6euCjiXxlMPuRsCX+MnEVRFGqKX4WWDCblyXZjcRtmbBL0S8DYhNZuMTPk2F97hSKbLSr
	wYmihLWPi/zyKno0DrkU8nQ=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4cn9VQ07n3zpStq;
	Thu, 16 Oct 2025 09:34:38 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id BDF181400CD;
	Thu, 16 Oct 2025 09:35:33 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 16 Oct 2025 09:35:32 +0800
Message-ID: <9c8834d0-cdc2-4c04-bc9d-0bab5ae26f76@huawei.com>
Date: Thu, 16 Oct 2025 09:35:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm: mprotect: avoid unnecessary struct page
 accessing if pte_protnone()
To: Zi Yan <ziy@nvidia.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Sidhartha Kumar <sidhartha.kumar@oracle.com>
References: <20251015123516.2703660-1-wangkefeng.wang@huawei.com>
 <20251015123516.2703660-3-wangkefeng.wang@huawei.com>
 <DAF946DE-0D7A-4B15-BF28-BF6464ADFD2F@nvidia.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <DAF946DE-0D7A-4B15-BF28-BF6464ADFD2F@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: 4tyisn9s7ukaqsewkwrdnwh7dscyhznc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EBEA5C000F
X-HE-Tag: 1760578538-554993
X-HE-Meta: U2FsdGVkX19+AVGZjnK6XTTqdKPrJuOJd/L7JPQRS5PHMjKSS6Bt2EYKJAa9u0SZUzUH6KGCNITfn4xo26gyfdihIyovqrzWEST6/aAGNLDG/Uczx2WhS057uE93fGLXkCIlpZFyeEkqI4ywgVtrovOYEiKE+l1BcfsA5Z/3UcpMto1cY1QLIp0ExagfTqh17gsL99dIR9SiBuW1JskqKzXF32UR8cvINOWQxNXHeGsyMxAVmzOIbdMA23+gdjI5cW6iETpFs09weqIt1Y1Tl99OMk83je96pZgdsQoGpagChnGwMdXJS/QFjaJeai8qLevgPXArjTc0u0lN4cysLR+CwabB5N0NMUDOgeugd9HSto/50Yn/CRVZbVc4E5IGKfjr8ni710aAxpChL/6osFbAaj7D1sLVApej7S+5d5QxZERX4rXm5dz+1LyzWz8jpu6LfUrkMUpwHm8LKjcwNMEkEK5lwpnMd2vSk9x9ScChVSMgzQ94wNcUAIgWuSQTJ5MTfIOermc6qXM8m2CPJ18B4mndp9e4xAI6G9l6HNMWUH7RvTrE5Bsx5mNgq3UFzL9b1NrkCdfenBFjxgOnm6uBDpGizYXCf7QnPkB7gkpg9gwPuaiyM2TTlX9dNDefTwcWlGM9GZrsGqiOQCapqtwgALHIBprOoNtwisUvZSSsY61CCvu9C+lbe0u6k9/0/e0RLikt84puEOJ+47ThV5P+UaYPlVWaptILQ3KxeQv+QDnIMHdJZcJkHaZ+mtUJrIJ3MMi5Em9QsPI6aPw6A9Nzv2hg12w7U+A+q9Cm3/OWR2TZ0RkoyqhSXBbHOfO9pSrGIZJfOe5EdlnHsiaZQnqqt0YNuSgJ3S1mkac95hYmKK8fiArkD2lD4DWRzXAIquISkj6okpeS///TJe5OLq0keDiom600KQ8Sb4JWQ1lNygpAcv32O4Ag8TBIloOXPtbBe87dOPJVWzON1Nh
 vj2FS/1L
 3wzWvfR1z2BxD7VTHKxHmEi2ktCP2nA7UUhHSBXyYNYJELFs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/16 9:28, Zi Yan wrote:
> On 15 Oct 2025, at 8:35, Kefeng Wang wrote:
> 
>> If the pte_protnone() is true, we could avoid unnecessary struct page
>> accessing and reduce cache footprint when scanning page tables for prot
>> numa, the performance test of pmbench memory accessing benchmark
>> should be benifit, see more commit a818f5363a0e ("autonuma: reduce cache
>> footprint when scanning page tables").
>>
>> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   mm/mprotect.c | 30 +++++++++++++-----------------
>>   1 file changed, 13 insertions(+), 17 deletions(-)
>>
>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>> index bb59a42809b8..ed44aadb7aaa 100644
>> --- a/mm/mprotect.c
>> +++ b/mm/mprotect.c
>> @@ -118,18 +118,13 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>>   	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
>>   }
>>
>> -static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
>> -			   pte_t oldpte, pte_t *pte, int target_node,
>> -			   struct folio *folio)
>> +static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
>> +		struct folio *folio)
>>   {
>>   	bool ret = true;
>>   	bool toptier;
>>   	int nid;
>>
>> -	/* Avoid TLB flush if possible */
>> -	if (pte_protnone(oldpte))
>> -		goto skip;
>> -
>>   	if (!folio)
>>   		goto skip;
>>
>> @@ -307,23 +302,24 @@ static long change_pte_range(struct mmu_gather *tlb,
>>   			struct page *page;
>>   			pte_t ptent;
>>
>> +			/* Already in the desired state. */
>> +			if (prot_numa && pte_protnone(oldpte))
>> +				continue;
> 
> For a folio pte batch, instead of calculating nr_ptes to skip, this just
> skip PTEs one by one. Looking at folio_pte_batch_flags(), this way looks
> better.

folio_pte_batch_flags need a folio, we want to avoid it,
maybe use pte_batch_hint() here.

> 
>> +
>>   			page = vm_normal_page(vma, addr, oldpte);
>>   			if (page)
>>   				folio = page_folio(page);
>> +
>>   			/*
>>   			 * Avoid trapping faults against the zero or KSM
>>   			 * pages. See similar comment in change_huge_pmd.
>>   			 */
>> -			if (prot_numa) {
>> -				int ret = prot_numa_skip(vma, addr, oldpte, pte,
>> -							 target_node, folio);
>> -				if (ret) {
>> -
>> -					/* determine batch to skip */
>> -					nr_ptes = mprotect_folio_pte_batch(folio,
>> -						  pte, oldpte, max_nr_ptes, /* flags = */ 0);
>> -					continue;
>> -				}
>> +			if (prot_numa && prot_numa_skip(vma, target_node,
>> +							folio)) {
>> +				/* determine batch to skip */
>> +				nr_ptes = mprotect_folio_pte_batch(folio,
>> +					  pte, oldpte, max_nr_ptes, /* flags = */ 0);
>> +				continue;
>>   			}
>>
>>   			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
> 
> Acked-by: Zi Yan <ziy@nvidia.com>

Thanks.
> 
> --
> Best Regards,
> Yan, Zi
> 


