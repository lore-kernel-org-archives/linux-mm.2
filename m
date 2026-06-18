Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F868CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 01:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AAFF6B0088; Wed, 17 Jun 2026 21:42:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 083176B008A; Wed, 17 Jun 2026 21:42:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F031F6B008C; Wed, 17 Jun 2026 21:42:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C30AE6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 21:42:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 371F28FA87
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 01:42:48 +0000 (UTC)
X-FDA: 84891334416.20.502C3AA
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1FD3D180003
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 01:42:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=5QkmuCeu;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781746965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dY7iB8TfUb49Qe86gfrlEs0QJewdJs84WYuu5n1U9Og=;
	b=0zpRBBSLzWhTJtEL8o7EyxsxzcOwvFLwp2dqiZDs9jSM8aNpwCUwN4PQWiBH47ipMIisQ5
	BMzTnzrUTwOyEwlweDU9hA6fM4LZiTCooI1G9Ghvagl5LUQc8uYxgFwUmh5aI6VrceK+/L
	Nkg3NLr9cvHwLw6z0zuQrGTs0zQfx5Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=5QkmuCeu;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781746965;
	b=dX6MK5wNRmAdKGVpFOfCV4oPNIKiYlXZzWFFSububLOIKMRZFyKMRPQ668OviZAtNAfkXU
	0cqA4uNn1PmVTG4NY3d5VKxMCNe/hRqLzU8PYZ1tSMlhpejHuSDJ7+gPpNU9LS3u7hKn2j
	3xmkKPSIbvTpq2Bxrwl5E+0mlHbjJV8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=dY7iB8TfUb49Qe86gfrlEs0QJewdJs84WYuu5n1U9Og=;
	b=5QkmuCeuCDgu7GawUdkBZs4PWCGcVkZSwOEkcRQHkT7454KcOpe7qPKu/YwFeiTDJoJy9giBF
	wNVVz4DXC5PPUTfnTxIHbpYEH/WdRo6y+IIyvvy0JTANVETfeia0/uUJNVc1kMivYnOud36pXRK
	ySVj/4P9aYZaHjHG3uL9pHk=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4ggjvQ1pXtzRhRL;
	Thu, 18 Jun 2026 09:34:42 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 09BDD40538;
	Thu, 18 Jun 2026 09:42:41 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Jun 2026 09:42:39 +0800
Message-ID: <b60dc990-812e-4449-918a-6a1fa419d931@huawei.com>
Date: Thu, 18 Jun 2026 09:42:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm: mprotect: use walk_page_range_vma() in
 mprotect_fixup()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>
CC: Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, <linux-mm@kvack.org>
References: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
 <20260617082622.3397584-3-wangkefeng.wang@huawei.com>
 <6fa17e01-8aa1-4597-a1e0-fa8d95eb0407@kernel.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <6fa17e01-8aa1-4597-a1e0-fa8d95eb0407@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: mtmzac385duqigz3zsf9n835cohuffjq
X-Rspamd-Queue-Id: 1FD3D180003
X-HE-Tag: 1781746964-632341
X-HE-Meta: U2FsdGVkX1/0W6njW45cv36tCmzm3XyCz+1Fz1cr9+JnPTSbne3rs5kuCcFoHOvzlR7H+1FYs13R9Fse1gEvfI3fxAattERgMUeYD/L4QFFHt4gCU+dRqzzpA+/1doh2SI8Om0HJiIWhQwv3otAu8lDK5FlFlAzlE+9VRMrKhKayRePI9NhB1EV/3brMKRY9cwG0DOrVsZo35j7b1zZ2Fchh7rshda0N3EXMvJycj48td6s9AVcEnIrQktGK5I0SMRfjnyxr5F/Svsxc/UK5zqiOHLTVKDPSPMDvrKInG8fa30znlMWIfhCaee1PtgBQ+fPSKR5R/P93fmeTXyO70zbI5sDsR/fQS80MmFaUbafskUgWjHSZYVYSxCHq0IdiI3GFLc/kiD70UTSnmt9YGvYUB0s9xgBexiBUCFuxVGxuYsWzt3/0VtWLfWVvRBl88bEK7FmFNnYdmU8gr4fbNfvkhaI2NLkqUQhod9kz7GhTvYs8vFAm5XQQyu+OjIeJAqJHLj8i8QF9q8nB9G2QJSgVYcYeYDdHt6nJz1jRXIautUFNp6ppOMiqboQQ9k9920jdm2GXA7K/xd7JHeYlEXw4V4XHawndOUQE7Z0gwECnk12nozRDGfUalbrw7t1vxqPsRg94buUUXfLIkyAk459XpEoAkwkItnxcNLZ4fWtMrmTzu8SNGU0/ggL5wiU517dbYjpnM4rr3zJToQRQksMlbDGSzZhF3Hpr1l57hXyMW2lGSIncAWovKkAKId2nvH3fYr3Clz6DxHmsIIHN7TpIS/PEKM0swZBGwfHXnDyIMKtH0rhs2jMsOE7ch7KMH/fOAY21a5L7iUT7rVvXFw08X7m0RhVXlC05jSSNNAUcYNtfoABDypx/96uCkDTwCMGfgAzygNjUCjHGd5XEBkJxhS6hUXYIIs00KrgqRxjaJyewzHdcYlHwHy/gv20eWy0R8swedDR0xF4m2I6
 XJoyjj/W
 RPlZpJ7vL8gCyVVqSWycEkOG2y0AzVkfTL/5mm0o0DHeLAcVV1AsBmMYFd0yRFUfuqe+Dl/mDwQMQeWKIaDoYSslBX/sssRGhpUTN8vf9jnWQ7DqSi4Dg4Gxbzb7hh7bWEj0HKQtB57ohpjELNuBFIpGOnarOhtrtwYOqZaRXN60FDc/8+2eOk0ID/F8GJ18Z9KP7rONzn4Lu/dwDO8jX7xP09eHfb0g+BS+ZNANEH0wj72fr9c0iVbV0KAUmZijCYEEVmMR2ETjOvgT+zYr4KtkEclhJLOYxKwk6bvR/jqUIxvA0J97bTL4hIU9RQbirpoFncsWL+vhRiF8vbqWxgx5dMowdiaXhZb3L33w+Qu1aaJ0Qi8urVeHWGnZx+8NTBlVF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/17/2026 9:25 PM, David Hildenbrand (Arm) wrote:
> On 6/17/26 10:26, Kefeng Wang wrote:
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
> As Sashiko says, prot_none_test() seems unnecessary now.
> 

Indeed, will remove it.

> Apart from that, LGTM.
> 


