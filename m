Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BAEDCCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 09:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 534488E00D4; Tue, 14 Oct 2025 05:20:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E47C8E00AB; Tue, 14 Oct 2025 05:20:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AD288E00D4; Tue, 14 Oct 2025 05:20:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 266A58E00AB
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:20:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4A4E011AD03
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:20:12 +0000 (UTC)
X-FDA: 83996173464.12.71BFDEC
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf08.hostedemail.com (Postfix) with ESMTP id B9C15160013
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:20:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ZcDC38fQ;
	spf=pass (imf08.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760433610; a=rsa-sha256;
	cv=none;
	b=yktoMu4Mrm6OJd1Epu3qOQT44AcRKkfIO9zujJKOu8CzB/vO1es01fURLX/UPCPxsjkKYY
	q8TA1AX1JEHAkwEW+t/zV+cPs9ktJ12U8HT1VrPWvhWfLG3dFKo2d3ran1O94jgYUOh9X5
	YaZ64ka4oCfhjzwxIXKyQSsP2Sgo118=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ZcDC38fQ;
	spf=pass (imf08.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760433610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RZJv8dOMs3XlDmJKajl//WZANZEjslLFxpO/nWDUbP0=;
	b=m70bktTVYf3G4g93FqaNphHo+ITLmPlipzr0v2ZlEWjznQQi77ZjMu8T55WEdjIa9TTYD0
	ljyKk7YJmVJ6PU4wJ86hdCTyjhnPFKdYHrXl6nm3Mc1h6nEdz10J+JGRbpXhZ+hF94y6Lm
	KITiSZv6QElwjB8m16flWAmQE9clMbk=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=RZJv8dOMs3XlDmJKajl//WZANZEjslLFxpO/nWDUbP0=;
	b=ZcDC38fQxnuwD/mq4FRXQFjoOPi8LbkB8c/VXo5gmVZazTS35sez4ivjMBlB0L8648xUMQgZt
	HabJzMltwAcKfW505rw/LpREVKzSw/xIibPazU2sZNW7PHOZhT5jSEzWTswn4el+fiI9n5B7r2w
	ClNCpxDDDV1J59596Jv6p+s=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4cm7vL5vjFzpSv6;
	Tue, 14 Oct 2025 17:19:10 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id B02391401F4;
	Tue, 14 Oct 2025 17:20:03 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 14 Oct 2025 17:20:02 +0800
Message-ID: <c83cf379-3941-41bb-a743-e0e93c83caca@huawei.com>
Date: Tue, 14 Oct 2025 17:19:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm: mprotect: avoid unnecessary struct page accessing
 if pte_protnone()
To: David Hildenbrand <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>
References: <20251013121536.2373249-1-wangkefeng.wang@huawei.com>
 <20251013121536.2373249-3-wangkefeng.wang@huawei.com>
 <93d00bb0-8aa7-4f52-b9ba-ef777ec191dc@redhat.com>
 <4469b9c3-3656-44f5-897d-b024e030587f@huawei.com>
 <93736a75-3fc5-47b0-8985-96e1b0b98b8a@redhat.com>
 <364ceb89-6327-498a-9582-bb1fbe2bd98e@huawei.com>
 <9282d8f3-4824-4109-9e9f-3b75284d2e04@redhat.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <9282d8f3-4824-4109-9e9f-3b75284d2e04@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Stat-Signature: zxu7mekyr7tjice4qszfhkjjfk3wrycp
X-Rspamd-Queue-Id: B9C15160013
X-Rspamd-Server: rspam09
X-HE-Tag: 1760433608-972099
X-HE-Meta: U2FsdGVkX197hcjEoIdtK39XqWqVc8CTKwMsOMBIMD12Ze9GG6LwZcXVyY5gMqP1R1O9IhI2rg2QIRTWSkTRmvawsCyJrFyKtvy351zHVGhQ3pplj6m/fyzgQrwu2WJZuacPVLpUaSOctMq05hcBN7xNJuURfNFSp7GbJI4OxeGFgq3zcCLir3QydOFYkOTU5IAWEli/ezEnZ65AvNrX4GDFZTnZLwbB26RO+rcOWhUcZ9f4crro66qBmNPBiYddNrgGSUB2FWLAUlQ/09s9WyN8K8shRvdzuDztW41Z5AEIJf95hV5ipvS5qYwZtMs6LG97ma4Cpxfjxzf+yLACDS75rnRc+nJWqVUQ43cX22mdC464ajZAn9ybli2w0g+kjximbTVvdqyvkq0uk9+2Qvzk0x39oXn3e028YUZiBvj68/exoc30zLbqZd0EtvI5A33Vgp62A2/0QXorl1LplqZdwAMX2aWsgRxzBXiAgp7Toq/Q6SPSBG/5l4Z+mzazls7vJBreyHPSjHnnKSneKMOCsnVc2NhyWW9C55XDVUlDZmC5Uu1mTAlN8Nar8x0FZN8rRdcWch2QlL1S3vpFXb1N4bKhVgowDPhCaPqRAC863n0KyHRNNvA4YwLekb4JDk8qPhFwrFm9h2LFI2ERaHExobH7HxeJsk3STfyL7f5Zr+E/nAjzC/ARFui4LkP7AafMKwq1t2d8OoSUgWrzdtfC/qGvZCAZBXdq0vIKHKrtzpJnOvppUIBsRMc/udkDNHqZRs6jUAzz3bKEXtSAIpDoBD6Ul9tUoOS27nCRS2ywf9qAdv8twoi8QAM8GlCljbrY3C1MbbRBlr8SGzNh0Y0yn0zLfOUfbrRfKeciic893eGV7WpYBXReB4QCK9ThOAOBnGbvkbN0l9BuG0skI7IN1U8QpDyc4WxS3lg+VqG6KWqRsVOPZu+ebOeX0jae4UKlMnubOG9M5dX5Vj4
 P0wKDvfp
 /8FHWn9ITUuP7HEO9VS1hzyeDDJpb8rAapj7Hp6V8VhMjc9TEfif5maU0+HxFpsp0fMrvf82HTdXfy0X/HFaEdMrZ1jeZj6xgviE95iXWoUQU50GxdObmMLVJyLbqFmvHFQVyZAtSed9w6gPwqTb9Xgg/DhzfV2tntS3HirrkmM/elYuACMsZ/eFKmGRyqop9WB4ncGhWB5pjWq2qGV5bVoIBZXGMn0dvV3u/vnO9VSgwrE6nofrp54A1r0wbjrRJt/i4PIoUeZBZdNXmHW4ibM0aHEB8czUjE+hcW1PTxjmz31VVHUxRusB0vZz5ver+2oK5OWE3SoEb2aCgn+5sjpMumIIQ//LW2LkE2XCejmCrK4+Wub2SPEqf3eu/c5FB1+k5cElm5T9UCrpLlLaChfUIdlC3R560s9iAMFqLAQWUjadK6xZ6BmF6Ug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/14 16:56, David Hildenbrand wrote:
> On 14.10.25 10:02, Kefeng Wang wrote:
>>
>>
>> On 2025/10/14 15:16, David Hildenbrand wrote:
>>>>>
>>>>>> +            if (prot_numa && pte_protnone(oldpte))
>>>>>> +                continue;
>>>>>> +
>>>>>>                 page = vm_normal_page(vma, addr, oldpte);
>>>>>>                 if (page)
>>>>>>                     folio = page_folio(page);
>>>>>
>>>>> I could have sworn we discussed that while fixing the prot_numa_skip()
>>>>> fallout.
>>>>
>>>> I'm not follow the thread, but we found that vm_normal_page does
>>>> introduce regression for mprotect benchmark(libMicro) with
>>>> this vm_normal_page().
>>>>
>>>
>>> Right, I raised it here:
>>>
>>> https://lkml.kernel.org/r/aa496798-5ac6-4cb0- 
>>> bdc2-91515172e935@redhat.com
>>
>> Thanks for the links, let's fix it now ;)
>>
>>>
>>> I questioned how relevant it would be in practice.
>>>
>>> I'm surprised it shows up in a mprotect() benchmark: mprotect() itself
>>> would never be able to set MM_CP_PROT_NUMA, so the code wold not
>>> actually be executed.
>>>
>>
>> Sorry, my description is very clear, the regression is not about prot
>> numa, I mean the vm_normal_page does introduce some regression when
>> mprotect benchmark in libMicro, before cac1db8c3aad （"mm: optimize
>> mprotect() by PTE batching"), we only call vm_normal_page in
>> can_change_pte_writable(), but now it is unconditional called and
>> 10% regression in some libMicro mprotect benchmark.
> 
> Right, I think we discussed that as well at some point, and possible 
> ways to optimize if we ever have to. We don't have to optimize for each 
> and every microbenchmark that heavily, though.
> 

OK, let's do it if real benchmark hint the issue.


