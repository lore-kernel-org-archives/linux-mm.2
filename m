Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E3E1CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 01:43:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FF9F6B008A; Wed, 17 Jun 2026 21:43:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B0516B008C; Wed, 17 Jun 2026 21:43:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EE096B0092; Wed, 17 Jun 2026 21:43:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B2BA6B008A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 21:43:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2A40140594
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 01:43:26 +0000 (UTC)
X-FDA: 84891336012.23.277210C
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf25.hostedemail.com (Postfix) with ESMTP id C2497A0005
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 01:43:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=fxz2xU65;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781747004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bi5DqNrmFb34WmdLswI62Z3+M7jjjsiVSWeA21iVAHQ=;
	b=yHM5aTMSzPZ76hQ3AuToMf3mlgH+WlERyH0/XYtVzGIoy3i2ipp5P1JZDGflzCRjfiM7D2
	cQNwHq4XogBHs66JCSM66pDF0Bbogy881xc7JT5/FMYsYARy5XWpcz4CO3uwToxmA9EKSN
	3KbtTDwRbsgOeTwru2vxD6YvlM6b4W0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=fxz2xU65;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781747004;
	b=jt2xIMMbPoIgv2F8tQ831gpq3Q0XUHj4pW3g4dyjMCfwcqXtlquCuyULFCTfJiE50TO0k+
	s+iB3F5y92UKHv6dIAueTFweLIf98sLT4opUPYkogIlENr6CVZ6LJZ5x1dDS8DHmgD4SYu
	vbRQ9gOdohQKfIsdUMoOhCoIwbPjbFw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=bi5DqNrmFb34WmdLswI62Z3+M7jjjsiVSWeA21iVAHQ=;
	b=fxz2xU65Yj62uHkT/fSOayfJ92bzy9v+RSxXsRR4FNh5blOSw0SyOHamkjI6Qh8o8WGMimGQ4
	L0YmPfTBbmU8yIlnIySSu+dYA1dnDCTHEW8VBIb7t+4WW0H8sJOe6yo1h0973/dGikKbjQQLz/1
	HJrJ8vKI3NjdTIOiC4V56HM=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4ggjw64ftMz1cywJ;
	Thu, 18 Jun 2026 09:35:18 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 66F36402AB;
	Thu, 18 Jun 2026 09:43:16 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Jun 2026 09:43:15 +0800
Message-ID: <566ab0ac-b991-48b1-b9d2-48a307edb96d@huawei.com>
Date: Thu, 18 Jun 2026 09:43:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm: mprotect: use walk_page_range_vma() in
 mprotect_fixup()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>
CC: David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
	<liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka
	<vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	<linux-mm@kvack.org>
References: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
 <20260617082622.3397584-3-wangkefeng.wang@huawei.com>
 <DJBE8O7Z6KN9.Y34YAWLQEKWU@nvidia.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <DJBE8O7Z6KN9.Y34YAWLQEKWU@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C2497A0005
X-Stat-Signature: 91bfpartz1rzizckwminwpzmijizq1s4
X-Rspam-User: 
X-HE-Tag: 1781747003-572490
X-HE-Meta: U2FsdGVkX1+VfJ4CeFMPXwhv6+nI6TW4RxgkYrf6LX1tS7ml57yo88Zy+jqKbv5fWnPiDQf5kcapsWdJnAKtY8k5n8QSXCsq98tOsqoALcgLG+iMUaSxbs2T46qlr+miEb5huJwI1bUYytNMwE2ATO1fuxy6J5YYhevv6YpyklKNGvn4vOXLwpRKu0Nr1L5SxuA/p8stW0p2tui81mMRwgSKs+xTxRdPrumScZn673Ts9zqG5OwvtB79G1yVeyz6IuUAWbuYcnjILriwfigw+JCpGh4UJpM8c7A/LG1jyrP9aYCzJth0pyiAQQYfrnqKTS0aYgv+oEAeQ2qAZC1WRhaIT/WpcGAFNqylMaqDRKJAV/iChAAG6jNBVOz7y0P4+7lDdbn3GanTiBum6JSNGrsN8B6OuBNos//tf2V5/lNJYO8BCkP8lfQeO6TXvSI5qYkIWDlSfEAci63lu4RdNi3SzRGa25/WPm3sPqL3JXeKyMfAZYtIE8AkaDNR9OK0sowsZ1cJkBZSyVvh5UdQxTUP998bOmiJ+J3cb20Fxbj0srGfYwO2fpKay1VmOjhkO3d/o2NlUZvD+d91b5TZkpHJ6ErLT+KiOhjk1mvbhjlLaiTXLmCsZwZy1u3Xy4KnxqsyHseWgLeI5gC28VdmE1zDE4u45Lw3LLCqvAOT7MnZioE2qOp6ctRkhtJIHfnP9OmBMpxdElS+71rJ3xl89RGlVQjnunWDGgPFjVmAfENKOe5T3iwuN56QHHKpu2ivfVKSGTVZXpIQb2t++H+uF5FVGe/3JN0K/LwwMHohiG3yaKX1NfCKDsOFtat/1zcDB1ukl5GMBa1Tl2uMi+y7I+uw8BMcbTwUdkHYNCnjv9PcRza4Z81AQRhbF+dDXRGFCogPXj1ejaXtc3MUDtC7ArTxltmw4QSv1eR4WJObqfmBzqQFEpv8qiEgmZnwHA18ei5IATiw+B1aFzvsZ99
 haD/leyQ
 B4CEPz9YAIoB7H+cn5MTIvaQsGhBfFalsWLJguv+70zpbzfrXKszeZo5fXjZnXw4gNcNYxiTPuwb5qfgPkJ7n6pPDnedMvsqWCOgsZtTqq9Xt8FJsQSkAAxkBJsYyU21Xbs+u32lGvOdS6IxzyNiDcfpkyW8XLmMI2Ea3qqdLIDvIFEQ6UbDGSyUQM2A1eUMZuFqPMabnU3m3AD84FqvRJB+9/D6yNQuNBhzNklmFh/r/ivjlUo5b48Lm7QboHqs8psXIVugnXZLe0TJGwouCf8TS08pXsOCCmz0t/rXisk3j4hv0i4avSsHkDQmY6zgLMc9U5mLr+srrn5IGGBFbwy3I2z9QYRIl8FuMAr9NAzQmuLjA+73OxFs5HN/KTA6L3ZzrepMfatQHmgeXNPjkEVw6qeBWJ6fcJsWN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/17/2026 10:28 PM, Zi Yan wrote:
> On Wed Jun 17, 2026 at 4:26 AM EDT, Kefeng Wang wrote:
>> In mprotect_fixup(), the PROT_NONE PFN permission check uses
>> walk_page_range() to walk the page table. Fortunately, the caller
>> always passes start/end that falls within a single VMA, the
>> do_mprotect_pkey() iterates per-VMA via for_each_vma_range(),
>> and setup_arg_pages() passes the whole VMA.
>>
>> Note, walk_page_test() isn't called in walk_page_range_vma(),
>> however, prot_none_test() in prot_none_walk_ops always return 0,
>> so it's safely replace walk_page_range() with walk_page_range_vma()
>> to eliminates an unnecessary find_vma() lookup.
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   mm/mprotect.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>> index 9cbf932b028c..d26e09862daa 100644
>> --- a/mm/mprotect.c
>> +++ b/mm/mprotect.c
>> @@ -753,7 +753,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
>>   	    !vma_flags_test_any_mask(&new_vma_flags, VMA_ACCESS_FLAGS)) {
>>   		pgprot_t new_pgprot = vm_get_page_prot(newflags);
>>   
>> -		error = walk_page_range(current->mm, start, end,
>> +		error = walk_page_range_vma(vma, start, end,
>>   				&prot_none_walk_ops, &new_pgprot);
>>   		if (error)
>>   			return error;
> 
> Like David and Sashiko said, a fixup like below is needed. Otherwise,
> LGTM.

Ack, thanks.

> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> 
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 9cbf932b028cf..323949638894b 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -708,16 +708,9 @@ static int prot_none_hugetlb_entry(pte_t *pte, unsigned long hmask,
>   		0 : -EACCES;
>   }
>   
> -static int prot_none_test(unsigned long addr, unsigned long next,
> -			  struct mm_walk *walk)
> -{
> -	return 0;
> -}
> -
>   static const struct mm_walk_ops prot_none_walk_ops = {
>   	.pte_entry		= prot_none_pte_entry,
>   	.hugetlb_entry		= prot_none_hugetlb_entry,
> -	.test_walk		= prot_none_test,
>   	.walk_lock		= PGWALK_WRLOCK,
>   };
>   
> 
> 
> 


