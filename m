Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88689CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 15:14:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EABBF8E0017; Mon, 20 Oct 2025 11:14:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5C648E0002; Mon, 20 Oct 2025 11:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D727A8E0017; Mon, 20 Oct 2025 11:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C60618E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:14:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A821C01F1
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:14:46 +0000 (UTC)
X-FDA: 84018839772.24.CC414F6
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf09.hostedemail.com (Postfix) with ESMTP id C455F140015
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:14:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=11rHxsBF;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760973284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T9j2qc8PYGfA3WRyZpSUifHa7sD31DVH5gwpNbhUH0w=;
	b=MLchp1scJqzMuYYT43pGPE7vNtOdaLMH6EjynK40yIJ9H5LfG1zLrs0SfoRN1qGamE2yXw
	aPnztXKRhrybSnjl9mBrng7i4gpysApHBVAI0si9juxxbvVJ23vSA9WGCxn+Ovfna8+/ZV
	aS5VAY37seRQBEEQVVv0FFZENCBTMys=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760973284; a=rsa-sha256;
	cv=none;
	b=C2g8TOstiOacoewanFMmuPGUYG63EhjmHscPBZXzPO90Mud8FJtqor/gQ+PkqIYE0vADBS
	i84sYQ+MBNx5IMOpoWld3zlBTHcB/78zZJNUADcWZ+jNS0dS1zd1zOfDF8qAnOnnw1AzEp
	MFJnM+43wRvDI6XTLiPYXC9d/cuDauU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=11rHxsBF;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=T9j2qc8PYGfA3WRyZpSUifHa7sD31DVH5gwpNbhUH0w=;
	b=11rHxsBFnpW1lceIHPvfKncqB57cxv1kSkMLcEjBTrGS3nL53+hI9Ik62ajyv9GKBYOtzlCPQ
	3A286EhSj4IpS/CflfJlbPhmn8bat/eGxTg8l8QIRhNQB8WJ9L4G7awOMMGgHUFtui5+P54GDjs
	moc/LSaXWGY4r+Uo1nFSEFU=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4cqzVF5SMQzLlVc;
	Mon, 20 Oct 2025 23:14:13 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 49FC71A0188;
	Mon, 20 Oct 2025 23:14:37 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 20 Oct 2025 23:14:36 +0800
Message-ID: <1a97f0e2-fc97-4257-8540-cff06a789e32@huawei.com>
Date: Mon, 20 Oct 2025 23:14:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/4] mm: mprotect: convert to folio_needs_prot_numa()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, <linux-mm@kvack.org>, Zi Yan <ziy@nvidia.com>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
	<lance.yang@linux.dev>, <Liam.Howlett@oracle.com>
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
 <20251020061845.3347258-4-wangkefeng.wang@huawei.com>
 <335895bc-c2ef-4ee1-a423-06c673a67147@lucifer.local>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <335895bc-c2ef-4ee1-a423-06c673a67147@lucifer.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam05
X-Stat-Signature: rtrcda6fc8uro451j7b3zun58etqf9bp
X-Rspam-User: 
X-Rspamd-Queue-Id: C455F140015
X-HE-Tag: 1760973282-19173
X-HE-Meta: U2FsdGVkX19RcHgkUW1ZSjAeSpa/1BDpaRviEhYpqOCteobBr+ElbpNoyudMyzf6jfuDbenwr36oDe1zgtA95V5fyV+oF6mOTFcBbp346Uo67i/1EBZBO4JstZdE/xYDCmLy5c5POERIjyYTPW+koSh4cf4mWsfqTzoLfPW1KEH7qpr3DV8/X49bS2JX2Qd5kg8v8w4RaM+JPT8PoJvNLxQjKMkT4jS3Dh3H/WivPUxPBGrXblnXgaEVHR9NL0zlJX0y/IMpltuhR8qsTV8InR04NIq3CCKS8+jWxgcvwpQ+ulrbYo7228g5xKzsFB8awdpbmLJu6YW/T2uBZgv7LLkBxUS8wdJkY5tsesRzQqisp8j98gSuydYtXRG+Xh2a9wh4B9wjJyz5xd48mgHTxjMPxrlPz/0Smk8SEDjQ0boGIBB2Wu+2rQHEYfVm+kwRIpKqrmVThCW2/0IZqt2um5zbuQsT+zimNlKrN6lCWFW41XSf2nJ+oKa81/0umK2czB3zZwH3cpO4tzwrLvtkzjLq6Nmz4ie2ZAeftxi5W6LeZ3pR3T26nXiMEwjRG/GarOT/NmQyQyL4BVN5szFT+F0KgXTqq8KJsAOjEAZoaq25KUZ+LAgt3mIoS+5cldxlu486x3tyJ3YL3wSRSmu0SkkPg7Li5TBlE4dx2lBywV0JBuX+R6jHfuLqM3Wz4ZPdziOuU1hvaIYoC8O/ELd6M56GixDLBuTwHgZTvfX5ljUyyOp4r6dLwoHEbGXTdW2dDT7FJEN8KED2XqhLxOZMKqdUwMPCL8ZZnUMViXFTZ2qqBoMAho7shjTc1KY8bYsGsuPJyUaT6U6N8RBzScv010Qs4Dj75jmwhu4YW9LiEyf/PkS2DUQcXesSwZ2GM9N99INYjHkJynPDi9tkO04OhX55wvJ+WfD5kWRCjczd7Vdl6Zt634/1OMGBegOLE4q/pNCsrdFizH/M0SRwlzr
 xEGWqC+Q
 nB3wZxr7IYoy6o/wzGlhg6zxfWMH8DZXh81QQp8DTo765L0GT21Nm564ZCxp1Op7XcEfCvmuT14iy0K8bxYeKDX32DGju+UcYBDGCwmR/TxyyMJNYXGTnpWD2ciK5xLp4EeyIIhKpICNGwvhjlnHbgKXefqwyCZ8HiTYCzfbL9AJoabZ06NrbndFoNQe03VJLISjziBJxfsKTKV36+7raaITNpN97V7/YyEnaIf2BhqfwtgxGsRSjxlaoTakZwl1GIq5fUPUu4R015INzZJfR0GcAs/MHEGCA1Cj91wceAh7ma4uGW0sjOEuMaFfuFp787S8eB8B0saOnuBGKLrlm10gGrNYwXji0R5s7B2jAcX5owSqPk2haIKR+KhBjTN0qwk04N9PcPy5KdUoaK2hXMVv0zvWHsVqiqz1m/a94WE4D0wlQqC/p3stx1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/20 21:10, Lorenzo Stoakes wrote:
> On Mon, Oct 20, 2025 at 02:18:44PM +0800, Kefeng Wang wrote:
>> The prot_numa_skip() naming is not good since it updates the folio
>> access time except checking whether to skip prot NUMA, so rename it
>> to folio_needs_prot_numa(), and cleanup it a bit, remove ret by
> 
> Hmm not sure 'folio_needs_prot_numa()' is any better in terms of indicating
> that you're updating the access time to be honest.
> 
> Also it seems to suggest that you're determining whether a mapping of the
> folio should be made a NUMA hint by the folio alone rather than the reality
> that the mapping is being considered for NUMA hinting and you're checking
> to see if you actually have to do it.
> 
> prot_numa_hint_needed() seems better to me?
> 
> folio_xxx() stuff all seems to be derived from the folio alone.

Naming is hard, David suggested it with folio_ prefix in v2,
the most check are derived from folio, but I could update it if
we like the new prot_numa_hint_needed().

> 
>> directly return value instead of goto style, also make it non-static
>> function so that it can be reused.
> 
> It's worth saying you plan to reuse it in change_huge_pmd() in the next
> commit, otherwise 'so it can be reused' seems like like premature not
> optimisation but abstract perhaps?

Will add change_huge_pmd() part in the message.

> 
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> 
> this functionally LGTM so With the naming, comment nits addressed:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
>> ---
>>   mm/internal.h |  3 +++
>>   mm/mprotect.c | 43 ++++++++++++++++++++++---------------------
>>   2 files changed, 25 insertions(+), 21 deletions(-)
>>
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 6691d3ea55af..b521b5177d3c 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -1403,6 +1403,9 @@ int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
>>   		      unsigned long addr, int *flags, bool writable,
>>   		      int *last_cpupid);
>>
>> +bool folio_needs_prot_numa(struct folio *folio, struct vm_area_struct *vma,
>> +		int target_node);
>> +
>>   void free_zone_device_folio(struct folio *folio);
>>   int migrate_device_coherent_folio(struct folio *folio);
>>
>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>> index 6236d120c8e6..1369ba6f6294 100644
>> --- a/mm/mprotect.c
>> +++ b/mm/mprotect.c
>> @@ -118,26 +118,30 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>>   	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
>>   }
>>
>> -static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
>> -		struct folio *folio)
>> +/**
>> + * folio_needs_prot_numa() - Whether the folio needs prot numa
>> + * @folio: The folio.
>> + * @vma: The VMA mapping.
>> + * @target_node: The numa node being accessed.
>> + *
>> + * Return: True if folio needs prot numa and the access time of
>> + *	   folio is adjusted. False otherwise.
> 
> Yeah this comment isn't really helpful :)
> 
> You're basically putting the function name into a longer form.
> 
> You should mention NUMA hinting, that we are checking to see if the folio
> actually indicates that we need to make the mapping one which causes a NUMA
> hinting fault, as there are cases where it's simply unnecessary.
> 
> You should also explain that you're checking a folio whose mapping is
> already being considered for being made NUMA hintable.
> 
> As right now it isn't clear that you're not somehow checking for prot numa
> based on the folio alone :)

Ignore the naming，borrowing from your suggestion,

/**
  * folio_needs_prot_numa() - check whether the folio needs prot numa
  * @folio: The folio whose mapping considered for being made NUMA hintable
  * @vma: The VMA mapping.
  * @target_node: The numa node being accessed.
  *
  * This function checks to see if the folio actually indicates that we
  * need to make the mapping one which causes a NUMA hinting fault,
  * as there are cases where it's simply unnecessary, and the folio's
  * access time is adjusted for memory tiering if prot numa needed. 

  *
  * Return: True if the mapping of the folio need to be changed, false 
otherwise.
  */

Please forgive my pool English.


