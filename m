Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97D6EC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 01:28:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DA766B0005; Mon,  6 Jul 2026 21:28:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38BF36B009E; Mon,  6 Jul 2026 21:28:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27ABE6B009F; Mon,  6 Jul 2026 21:28:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE7206B0005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 21:28:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 63B661C7D5E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 01:28:48 +0000 (UTC)
X-FDA: 84960246336.16.B176F1F
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf18.hostedemail.com (Postfix) with ESMTP id E621C1C0004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 01:28:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MJ7+HoR1;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783387726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xHlA3qIW2tB0lrvd5sEBRrmbMwl1oXqw6jt7l/Ead98=;
	b=2yxpSYyrF4SoHfsdC2a2WjZqpxMraKLoUGkd+zaTt6skvZj/3JW3jaXvUOSNnpLbj881DO
	Nwtnvrjs2OMLlSPl91ehCByYnsK975klL0oam9YWU86chQ1JkiudHCsp9kIfm+8DLu1CXZ
	z5TfWSxfD7lWtT3DKwnGujpSiSfWH+0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MJ7+HoR1;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783387726;
	b=TjcT3QRguWMYtkCZutQ1cPhLw8YCnOZNpI7MFa29ODUOFX+Yrs4m+0Nvc1sxcRdBhNDnfw
	hV6FrqgimB5c1Lo6/mULdwGJcBjYlB0amBs9s0cJQGM1LLyc9zc696DCrZ/vwHdhejg8RM
	qfzf0X/jsYqKBTILV3uDT5oHUwQwrpw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=xHlA3qIW2tB0lrvd5sEBRrmbMwl1oXqw6jt7l/Ead98=;
	b=MJ7+HoR1z95CrniOQkXrR26XdIPi+7g/QjrsB8jU6tiraSyNrbwP6lcqcp2q+KTFqUayKXlR0
	4SBqFrdx2pH9Feai0n0J6PyC6OkDNCxZBKiFVYRZ7Smqi9v1omrLvJkTdXwHtj6D61VgdmX889M
	61OYoLDACj4y/WwmyoDnbAk=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gvNg03RxqzKm5j;
	Tue,  7 Jul 2026 09:19:24 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 372824048B;
	Tue,  7 Jul 2026 09:28:40 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 7 Jul 2026 09:28:39 +0800
Message-ID: <9beedaa7-0896-4aa2-810e-26042476e7a7@huawei.com>
Date: Tue, 7 Jul 2026 09:28:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: migrate_device: fix pte_pfn/pte_dirty called on
 non-present PTE
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>
CC: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, Joshua
 Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
	<byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
	<linux-mm@kvack.org>
References: <20260706111958.3649651-1-wangkefeng.wang@huawei.com>
 <892b2a73-4dbd-4090-89c5-46929530b855@kernel.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <892b2a73-4dbd-4090-89c5-46929530b855@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E621C1C0004
X-Stat-Signature: rj4xhdz88zbxqgyd87w4nuap97kkh1hu
X-HE-Tag: 1783387724-912829
X-HE-Meta: U2FsdGVkX1/z0tWZ9JzaNz6nTIhSGkSW0FK+0Wz/7qgej+w/XxUbjjAyXFjcui3v4dLwk52UuAz4p1Vzgn6K/tQORDq8LcIXbM26Y919HMUz/phZMWIhSv4UrXAJMo1beuzRxhkED9RQUL4DHF4wA/d599UsRUpKdRR9Ez5wnqHl3VycSCO0NXoB6Oi6ndv5kGFgE0FFN0OBZl3WiRZQ74lkpBDw+CuBLjhd+Wd29TuKM0+SmWrzQ+soIwRwWSrnkciIAc2OXh+MYmc4YtoKHvX9y6J90Johsf9Pj1NEPCGFMkjXidLMdY1rnFLwMpoK4bN6n5ZcbySxIthAez5o834gpN9RKU8maoyz8PQbZc5KK69PUAbN9FD2AzSwQ+hw6Xfv1wc1lEzWwJWVMLrlQf+p4Db2tCEjKgBCNEM4c33FhcFo4QLCJWXaR03dtlp5nuc9UEngd2Lma6WFjDiAQLeRJ+EPAWSSi289VWRkQAWNnvzSs7lVhj6oEp71vRysLg6wDTkWvmswK7giLaDpNfz3bi0as1m7tJYoBPtonWT2VSMY+/l0JVm1/c7CxVbDAHAgtvzIY3moPEwqQQeWFCkNUcfDPxwxX2umCLMgaGhr2dUvne62vzhHcJ2nDaX/DG0BnU3nr1m8MenjpX1aIHNvbC82EXR4zPG/RYgK2KnikYmA80SGIuyNXDSL1TBlovH8bsZFNFW6OkYQcYhytH8NSCivnWQrAWm6Y/HuyHyBaCxuGqDgPY+0MdYwvtZnm+fUl+73KE2YeUvMT2VbS0iZ4ZHz70nb4laKsTc2lUSfkFcXuL1C4QtZECnmiwpMteHGRy8c7TCDcD3tjRMJLFGOvll5vyU4VjYTWXoeSBO+xsQpZOLG3OFFg9iPK+6XshmKOuRHzGs1UlV6NhE8eEzgpupdHpkDZlqAmnvW5foKLiKap9I5/Ks7Uch9VeklbII/H19QkPwnUNaQJD9
 x7qSVbNl
 WbgvSS9/VXBecoJcrhP8WLB8A6KUV2LHG45RU/zq57GtIOP5OiA3o62hPxeS1ChkRpJGCjscVdDq665grWNOAZIG4pd/lDZvx8MqYzHOh4Wbf5bxOtB2lwJKjhbbjS76WrwGyE5CliyWflQ+GTbksZmjvTPRWcdXWUMeH/JUrkMkAzLQ8snf0kAY1Z5RzkHBNb6d+6bTsmE3B0d3mFeXpNjFImNTNr4EH9qxLokj5TePY9WZVAxU4oq8v7gn11gL8lCOaiXDsXEH4RWOXHa4kBJ39UQILk2Fd+tl/1HgKFVGBNqsOXdcGxkN73rLoZle+jpFveWjaFipbuDuiBE8fE025wz7hCcJ1bVgvS0Mzuqr/MY5WvIw64J8E8DCqPM/5NRqszPxp50ddJFEAIVd7A+AcgxkveOHZ8zX1aNZhdq5Ge4BK0O6E6+ZhnqYrJHnneG4plLlMgGQS/8vPIaNUu45by10Vw6jhpmr7y/1xlTeWGG8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/7/2026 2:30 AM, David Hildenbrand (Arm) wrote:
> On 7/6/26 13:19, Kefeng Wang wrote:
>> pte_pfn() and pte_dirty() have undefined behaviour when called on a
>> non-present PTE. In migrate_vma_collect_pmd(), these functions may be
>> invoked on non-present entries (e.g., swap PTEs), leading to potential
> 
> Certainly not real swap PTEs, as the previous function handling is
> 
> 	if (!pte_present(pte)) {
> 		...
> 		if (!softleaf_is_device_private(entry))
> 			goto next;
> 
> Only device-private entries?

Yes，device-private entries.

> 
> 
>> crashes from pte_pfn() or incorrect dirty folio accounting from
>> pte_dirty(). Fix both by guarding with pte_present() checks.
>>
>> Fixes: fd35ca3d12cc ("mm/migrate_device.c: copy pte dirty bit to page")
>> Fixes: a3589e1d5fe3 ("mm/migrate_device.c: add missing flush_cache_page()")
> 
> I suspected device-private code, but indeed, these seem to be added afterwards.
> 
> But a3589e1d5fe3 only moved the flush_cache_page()? So that one seems wrong.

I couldn't find a more suitable commit, before a3589e1d5fe3, the
flush_cache_page() only called under anon_exclusive, not a device
private entry, so there is no issue. This is the reason why I chose
this commit.


> 
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   mm/migrate_device.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 052167f9ad54..6e711381f092 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -411,7 +411,8 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>   			bool anon_exclusive;
>>   			pte_t swp_pte;
>>   
>> -			flush_cache_page(vma, addr, pte_pfn(pte));
>> +			if (pte_present(pte))
>> +				flush_cache_page(vma, addr, pte_pfn(pte));
>>   			anon_exclusive = folio_test_anon(folio) &&
>>   					  PageAnonExclusive(page);
>>   			if (anon_exclusive) {
>> @@ -432,7 +433,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>   			migrate->cpages++;
>>   
>>   			/* Set the dirty flag on the folio now the pte is gone. */
>> -			if (pte_dirty(pte))
>> +			if (pte_present(pte) && pte_dirty(pte))
>>   				folio_mark_dirty(folio);
>>   
>>   			/* Setup special migration page table entry */
> 
> Changes look good.
> 


