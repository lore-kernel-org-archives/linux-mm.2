Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4311FC87FDA
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 00:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE25D6B0099; Tue,  5 Aug 2025 20:56:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBA616B009A; Tue,  5 Aug 2025 20:56:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF77F6B009C; Tue,  5 Aug 2025 20:56:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C03886B0099
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 20:56:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 81EE78127C
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:56:39 +0000 (UTC)
X-FDA: 83744517318.28.772DFAF
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf15.hostedemail.com (Postfix) with ESMTP id AE3FEA000B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:56:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754441797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LamENp37R9zkAebo5gvBFXWTSsGDFkmXjOTQ3o4sf+U=;
	b=WBPODeNAhJZ8/hezg5E9N4HgWCTbG4qj+QKHueTibD8O+9YQE20hN4WspNFLvZZjT5Dorn
	OC9s3R6MYQim7effp2KZ1r4R19xUdLVuKnpC+Pxs55NUc+2dFHIEY+AWGpjhB5VgYL8mvN
	Ra40VQQhurRvRxWk+VUW0F4YcAOE11U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754441797; a=rsa-sha256;
	cv=none;
	b=w9ETXPmu1bWjG69+ISy0CS4+X1OGZEsxs70t1X5o1wD84ZvQxg9RuPHocQ/f+qmHN14AL1
	CGJinD5cvbq/3Fqpj98UVIMcYM5D5qyq1l/mN9GfYlVbORXDnItgi13ZgvW1tW5NiP821R
	W6MeC4f4zN4vFVgIDzkHZcLdTDZ/hmc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4bxWvX3h8Vz14MHj;
	Wed,  6 Aug 2025 08:51:36 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 9848914010D;
	Wed,  6 Aug 2025 08:56:32 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 6 Aug 2025 08:56:31 +0800
Message-ID: <04d3e3c0-3b22-4d47-b183-6382a8e5c74d@huawei.com>
Date: Wed, 6 Aug 2025 08:56:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] mm: hugetlb: convert to
 alloc_fresh_hugetlb_hvo_folio()
To: <jane.chu@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Muchun
 Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@redhat.com>
CC: <linux-mm@kvack.org>
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-2-wangkefeng.wang@huawei.com>
 <920efb15-581e-4efb-be74-088113bf2035@oracle.com>
 <a8a8c674-6f8b-4aa9-befe-7ccdc66307b6@oracle.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <a8a8c674-6f8b-4aa9-befe-7ccdc66307b6@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AE3FEA000B
X-Stat-Signature: tcfu3ese96zymy8nj1pac9gjac49a4dk
X-Rspam-User: 
X-HE-Tag: 1754441796-731386
X-HE-Meta: U2FsdGVkX18tmfRXPQtMSnboMm975bu/VTuR+qo4BkxFTOnCldGcIP+y4ppbEelkbSne5SumGRQ3ZbcEF5n/UJEUNvrv/TYbdpJg0hsIv5Ya6xO0yl3PieuHMdZNo3r+vpiM3cFgw99bzWdY5RFcpTftWb0Qy/2LEVA5b91gz84DguEMdxwFEXyo9J78BNOh5RWpd7pp8iDMh4Fw+R4JWSDVRDaGpwT3qq+B5plmTQFtOZj1J3+4lregwCKgrKkzbDXtbh5ZoWtaqx8ekJOFnWPkoeWSrPihhQU8hQuGZtBDvsgRhsH0u81SceysInudTHtqxR4LrJ+SYgfmjQE5jyh7zkwNB8pFCpRc//jJ8024aPBbxREbkn5IqyXZAFth8eV7GMLSxCKAC1YV5RPuPRnOIF2WEo2jisqmg7+Yt/6+daJKg5i66PZ0PJM98abK58HVQ8459MwmMWA3/6/sF6croDw4mrRN2cbUjpnyjPeYnXIgBbDjEGZFK+IP51tB3d/dOsM4Pm/68M6Bo/mRrwhAnDyNdPos/B4ruGetjWGR+cRd//IQuHrjdv+Z+T8qBx+EVZFyhFbb8Yw8V3fWo/gF7ackGOh7acrG0IG5s5Y/YgSgkXqesZCpAio9ZaDbawzpD+7Hj4SP9G4BjcuVvCUXJ5VRjlOBMVifLfvyLNuyLzUvkquvDSsVeMSNivIzNjeGTJqB/j6ft62lgkIyp8LE8YpqgTibqSGvjS7rT0a8b6+BIKFbsXLP5Q2mMyNMvIEBpa7uUMecgArOiuRYtoqvG+DJEaU0CNRGigieqvpkX3IErnUKgtOblKSMh0aD28Ybwcwi7CzNJ5rR8awYyr+F1I0dE8IfmMJSAwNyAB5txzCygbzZb3HWxOYoSXVbOIh9Vk5acIkqLJa+a466feMaQ6njNFY0xYIIXnVy9FLhhuzrSydXml2NEs4RBDjpM/MPDjIVDoKzI85NoYF
 M9R5FRN8
 ZKsRZxL8hDdC9gqf4vBPZ4uoPEI4ethsVBWgXKcC8yKnpabZUbplIHMusnjNRGC/thQhDOJZlVxknSpddC6mHaL+n/UNSxb+NFqRqRPDFLhfjg80tpNFIBCMWYgFjE+jKPRVOkAFcy5w+TY0VkAYjkN0UTIQyRrxQVJNOtp2g925Sz4P0OxGFW8/0GHjwqOI1KlZ8RiOC2RuznWsI4WM8HBs2aHzCNZ70HTaItLm+6/WSCuycctYGnxLjbItMEYLp/uTw5EYaEt+yoc4h8MQ07RvlNLNBZfRlsa2g0IHX/gcY4l9Wow1bTpnz0qSRqvgJz+iEF/cVsWWKrFI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/6 8:33, jane.chu@oracle.com wrote:
> 
> 
> On 8/5/2025 3:18 PM, jane.chu@oracle.com wrote:
>>
>> On 8/2/2025 12:31 AM, Kefeng Wang wrote:
>>> Now alloc_fresh_hugetlb_folio() is only called by
>>> alloc_migrate_hugetlb_folio(), cleanup it by converting to
>>> alloc_fresh_hugetlb_hvo_folio(), also simplify the
>>> alloc_and_dissolve_hugetlb_folio() and alloc_surplus_hugetlb_folio()
>>> too which help us to remove prep_new_hugetlb_folio() and
>>> __prep_new_hugetlb_folio().
>>>
>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>> ---

...

>> Thanks for trying to clean up the clunky names and eliminate a couple 
>> not really needed helpers.
>>
>> The decision to do HVO is baked in __hugetlb_vmemmap_optimize_folio(),
>> ultimately all hugetlb pages go thru 
>> __hugetlb_vmemmap_optimize_folio(), so let's not to add on 'hvo' in 
>> function name to indicate additional decision.
>>
>> The difference between only_alloc_fresh_hugetlb_folio() and
>> alloc_fresh_hugetlb_folio() is that the latter invokes 
>> __hugetlb_vmemmap_optimize_folio(), while the former is used for huge
>> folio allocation in batch, and then __hugetlb_vmemmap_optimize_folio() 
>> is applied to a list of folios back to back.
>>
>> Therefore, to hopefully make the names sound a bit more natural,
>> how about
>>    s/only_alloc_fresh_hugetlb_folio/alloc_hugetlb_folio_pre/
>>    s/alloc_fresh_hugetlb_folio/alloc_hugetlb_folio/
>> dropping "fresh", how is newly allocated folio not fresh?
> 
> MY bad, didn't notice that alloc_hugetlb_folio() is already in use for 
> allocating hugetlb folio from the reservation pool.
> 
> So, how about just
>     s/only_alloc_fresh_hugetlb_folio/alloc_fresh_hugetlb_folio_pre/
> while keep alloc_fresh_hugetlb_folio() as is?
> 


Hi Oscar/Jane, thanks for your comments, what about

s/only_alloc_fresh_hugetlb_folio/__alloc_fresh_hugetlb_folio/
alloc_fresh_hugetlb_folio


Thanks.

