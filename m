Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2E35CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 01:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C24B86B0088; Wed, 17 Jun 2026 21:46:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD5C06B008A; Wed, 17 Jun 2026 21:46:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEB3C6B008C; Wed, 17 Jun 2026 21:46:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8535F6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 21:46:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DFB89C2856
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 01:46:19 +0000 (UTC)
X-FDA: 84891343278.02.71EF29C
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3B525180004
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 01:46:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="mcbz/abh";
	spf=pass (imf24.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781747178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jZ6QavdZs3gb/3kv0s0NJhBE9A4igxS20/p2ZRO8te8=;
	b=i84UN77WvT/d9FzuKtY3nAlaqfhMPNPbEP2p6FHFlkOz/6NITRVQZbu6J9NrALP4tsVbvE
	1yjwL+pt9rOYEcFjhFYn4SMhhKG1LL68l6sljvZXWtIZN+v7MGuZm8xU4XTkTvUxsIsBYB
	eE6bLjQfbIFKrwyCBy4EKTHTgE7sq4Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="mcbz/abh";
	spf=pass (imf24.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781747178;
	b=ztktEWyg0wYnewzzj3KOdR8tnESRMzk6Lt1i9oTwpNhWCf95y1wb3nCeWuYjgn7pk1BH4L
	Mi2cOmNSMA/BF0bahXZRVjUzmHLmyECy8HoSqXdDldPxcVPrrHzXHfIun6RPSOWxi2k+Zn
	KOlEzSAxbvJ0LDwmUjTJtUT78NbcuWI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=jZ6QavdZs3gb/3kv0s0NJhBE9A4igxS20/p2ZRO8te8=;
	b=mcbz/abhc9oKO4ApmN5/gO9z8b2tZLscC5wqk2FPTYkhOTrtAlHcAnXNo3O0TXMtunLb1tLG8
	M7oZjFinctlpWRb02z1KiLpxK0Y7dlulRMBoEoYAf9nes+rdHxKHYjQMAIGkn+WfJ7rHUJkSSbP
	/Cf5xdhGyH8kC/OoRcDIEaI=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4ggjzV2YRFz1cyR0;
	Thu, 18 Jun 2026 09:38:14 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 20989405D0;
	Thu, 18 Jun 2026 09:46:12 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Jun 2026 09:46:10 +0800
Message-ID: <84b16b25-e62c-430a-8732-45bb2d180e66@huawei.com>
Date: Thu, 18 Jun 2026 09:46:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm: migrate_device: use walk_page_range_vma() in
 migrate_vma_collect()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>
CC: Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, <linux-mm@kvack.org>
References: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
 <20260617082622.3397584-5-wangkefeng.wang@huawei.com>
 <a0335462-5bfc-4d8c-ae55-cfe2587ecd0e@kernel.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <a0335462-5bfc-4d8c-ae55-cfe2587ecd0e@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 3B525180004
X-Stat-Signature: mkwmka1nje3z89z3dt9mn6zyp9bzysch
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781747177-134298
X-HE-Meta: U2FsdGVkX1+iWUkO2yoOu63tCCZV0PVWzcyS+XQdqbK2br3/m4s6sSxQseSUtITKqD4ZgSFGLTio+8NOEE1hqq2LMX6OOz7yB69nKIQtHCuNCqhYMjVFyh5lJ/RcHxYC3dqF0F/TddQJAPjci0LK2JamMXY29siL/WqISyM7UDnf2ywmayULU6muX08xXK8YL6jOGEMud8HLEuc73NJbU548WuiM/OD3Kd/TkKcVN92uAttdTyhhC37Klzkoqc29OtcdGuPOMQP67KRolxRqYSTNp4R+VkC/qJy5/3olH8knSmp+CUoYQzF4ytX/tZyaVDg0u2TPJTnxh0P3TESBnwAx1+3xuLbvfcVJOgvpEJgOZnTyqbFDL1ZAeZqa3Ue+5LWhbt6xByHKdoBOVO5EHuICFZSpxr7vMw8cMtgvYVFZj+7DP/R6c/ptUSh9tN2uwwMs6zEMb4ghAFkAZhJaTHXHJuwBVYpTufVlsQd1ewT80uTuG5ujkmEQ+UuLvNiwHObs6AAr45R+LRdW4fOQEajtvPr9tZlgwbvfZuUDmzsIDkR2on6Zc8JaKeiTH2K2Sx7NKhW/+PBiALyvOVmPsjKFzjyFdOieG4do/mdy6wp6k1LaHGh3lASjtRRoZ/Ezy9MtFX4N9omk1HOrICFCFTh5Jj01EudflpenN5WzTdXEYE9e8u6+KouxXXga3CaMhGZH9ELlFzJcrBfyMZSvYn4CkxAv5A+3C3p1Yoq6iJMtKGhlZD62eMmwdlyXFQiIHcH4tTeXYfhsqjVG6MegVVXSUFXhAeJDQqq636yyIwf0uJimEL/69kniGXlHETBXYJwV0GepGxqM9Mv2bmr6WkQmBBS1i3Z3CJFlBgw8D9rmXSicXSgGZ6DY+QC2ofixl6tSqhPQJ0qsiHfEFY0epqteERL/K6BNH97NT0cSXHg4DoICuWTa9IShzRd7kuQ9IGkIy/m4qPKQ79ZdzrU
 rfYZO/Mn
 OTa4cVRx+GjE7Cuf54Y+QQLY5y2NMNvE7+agSKzIVEdFcxHWxWvzk8YQDL72WIDxfpJ3ZNcCh9VCf++DxpPfpkkuhN4gwZXXjUfhnXXskxfDt30cPxr6PbmUK8jL20mW4EPPAv5XChauSzptRykIULIl5ENl7xXucM9r95/BTOdv5oyLMA7STTkzQ0AXlD7SQd1oluSXAMNoIDd53XBO+k7hRQNh7KdcNQF+B8aqj+niduHjNObTFneH+/hvedc4RbxvWOR2DDz4cZ2arnUcSqLJb1oW4Ot9M74hHKpMgRLIOb96W/6G5uhpYh+N1h1kr0HX4ziS7BVutP3dwZZknVFSdo8HTXmJMWTh2kkQSCrrL8zi0WwEa9PLQ6eKAaHuyU/6+yZaSwbFTK283c3dkaOBM/CEuSsg7u3i2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/17/2026 9:30 PM, David Hildenbrand (Arm) wrote:
> On 6/17/26 10:26, Kefeng Wang wrote:
>> The migrate_vma_collect() uses walk_page_range() to walk the page
>> table. Fortunately, migrate_vma_setup() already validates that the
>> entire range falls within a single VMA.
>>
>> Since there is no .test_walk in migrate_vma_walk_ops and VM_PFNMAP
>> VM_PFNMAP
> 
> You mention VM_PFNMAP twice.
> 
>> has filtered by  migrate_vma_setup(), it's safetly replace
> 
> s/has/was/
> 
> s/  / /
> 
> s/safetly/safe to/
> 
>> walk_page_range() with walk_page_range_vma() to eliminates an
> 
> s/eliminates/eliminate/

Forgive my poor English, will fix them.

> 
>> unnecessary find_vma() lookup.
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   mm/migrate_device.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 554754eb26ff..ae39173d6a0e 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -513,7 +513,7 @@ static void migrate_vma_collect(struct migrate_vma *migrate)
>>   		migrate->pgmap_owner);
>>   	mmu_notifier_invalidate_range_start(&range);
>>   
>> -	walk_page_range(migrate->vma->vm_mm, migrate->start, migrate->end,
>> +	walk_page_range_vma(migrate->vma, migrate->start, migrate->end,
>>   			&migrate_vma_walk_ops, migrate);
>>   
>>   	mmu_notifier_invalidate_range_end(&range);
> 
> LGTM
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 

Thanks.


