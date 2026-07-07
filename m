Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51A07C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 09:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 385006B00A0; Tue,  7 Jul 2026 05:34:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 335596B00A1; Tue,  7 Jul 2026 05:34:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24B0E6B00A3; Tue,  7 Jul 2026 05:34:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F292B6B00A0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 05:33:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A4E48D797
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:33:59 +0000 (UTC)
X-FDA: 84961468998.08.96FCCAC
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf25.hostedemail.com (Postfix) with ESMTP id DDB0CA0009
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:33:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="DMJM/Yzf";
	spf=pass (imf25.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783416837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mzUK8deixpoAm2/ofbul5LTC1qdxdHJXL9I0TYD9huU=;
	b=VCJv/Inse2/twKnoD5c3jL94r7CxQFoK9Rerq6OIsCRK22wOOTuKMzggv+Wa92NjMvK4Le
	bUuvi1IiWAIagI9uCAJgdYko12rRTdmx+HOzMqzyKuWMWVUsH9itzlRvmaMxIOyhsnW6DH
	Vy/+jRapHfK2AYRYWwuX0fWEZNxvdCs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="DMJM/Yzf";
	spf=pass (imf25.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783416837;
	b=ij1mXMPe4VyCGcy/8vFXbfJxnYLpjvcVtI9a8iIG4EKQ5UrF8SF0S5USfAOxApwYfFbdoV
	jDsDt9ia0g7gGSJmrMPAkOzsg8NLI7hiHfrrXAWlJvDaZz4fTo13hho5jBgBR9W/rGgDLL
	HLZt/wBtq6J+3zG+egWEmm5ZlVARZwA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=mzUK8deixpoAm2/ofbul5LTC1qdxdHJXL9I0TYD9huU=;
	b=DMJM/Yzf0FO+Uekv1x9HVt3+opLrSNe+atRCXHUuxPhJn3eUPAMpcLtaydIKsYz6lM9yOILMv
	51ROd2sjKoqvUugIXlKIQkySHmISEfg5hTaJB0kULvt+RldMnWTUJLddyBbv98FSPwBlus8oHEP
	hZQvuW1UbN6tf/vusHSf3vw=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gvbRZ4W2xznTVZ;
	Tue,  7 Jul 2026 17:25:14 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 3E69F4048B;
	Tue,  7 Jul 2026 17:33:51 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 7 Jul 2026 17:33:50 +0800
Message-ID: <5a097591-5a6a-44f2-b440-44a2395fa788@huawei.com>
Date: Tue, 7 Jul 2026 17:33:49 +0800
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
 <9beedaa7-0896-4aa2-810e-26042476e7a7@huawei.com>
 <2e749bbc-86d1-4a10-9809-4777bb5061e7@kernel.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <2e749bbc-86d1-4a10-9809-4777bb5061e7@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DDB0CA0009
X-Stat-Signature: wh57bej5dznh5tw6d17bnk57718yurdb
X-HE-Tag: 1783416835-367266
X-HE-Meta: U2FsdGVkX1/SwzNAyGTF2f90WAxyXbGcNJfwHY+b1/pC9/mjCvl5zxbR1oYiPav+VAjDNNyWpuvWc9UcYJ9PIBojyr2HLuyR9GEGyBEYV9tr9vmXGpDS8q2Anbglo2jCYNNN89RoD+i9F5QJxJj7IwQ57dBDZoL1wHtd0bc3KEjUcxxf6rZftuXhO0UoKB1DUGCoYBC8uY6LudWEzGzK9v9MVSS7wyOHGZBLipPzm6HcoxbqrDuyAeajr/8zyCGI6kRwKXGeO3g7i5Grvpzh6Ns2jgUBSKt1Mx/rHoDOm+f0zHIMuQH9JzRggMn/9GPV/Q8wSWXahvqW0gD4ewLBJrXqFsxpB4acQNahET2a+J/eJuFXSA5bYCrnKF0BkJ2tuzmfSDSXWOxdtRsfo2m1VF9vmlMwilD6+s1Py6+yWv/H69AOSsYyrSlUWuEyL0Wbi/YTVuMaFQon+xFufDFX0o8v/w5Ny18o8s7+lwBjXmM6Q/K15oyqjD2BWOWILet8s/KIUQBW3FECI3p7Oi57MSNPqi4nVcqtzAgHyBA+yftThEbmItkFAyjVUbdIZlABZqcjEyqN8qRFaLwTQB+mjVLXHB0ZRCIczaupTAoCWOZxoLFvu3suNQ0acmcR9xkj3/GP2DEeW2WEsRZzAkPeGB0d2Mxd+PHj0tyarH3aQMcBkMS1fpBEum54rQAtxwlrb+iNa4PCkNBMS0/7KZbucVRY1+uQqfnV4e1NgQyfwNK3fVWu6kNpLbkqOW6ydmgrq+0mp2nm1G/5pqYdtQtW2Q9L2S6BtQXwJ0VI4VBvy59rRvps8TWKi713wR60B/JMXt6beHqUkamzVjshhr6oAA0xI+5iBkI12CehYi7/20UvQBpAhUwgPEi8Lymt3OB20bkq97rqkznwexzokY+gXoRV8poQshY5uHuPz6/IHl5Q3PEKdMwe8QpTe0Pn+czkFxirgvy75jox1fT2h5S
 AfX8aUkA
 LymN9gKXoY57fbjXV75fqUt9z30iMHEPPGJF2mbmiWKLoLJ3XRufEQlOLfUtMs7agSzSk5KNCl1pdYliJ/c1FxSDDZNJF9QgdLFjncOtiT27XNi950BVYc6VNg8yr9zfpYGd7KpwfQqrpTMds0/YC0/zUQOv5iHMwk4eSGO77m7aE1BNX6wATOkAbaBc3HWI8O6JHtHHFUOFGR+F6xJaNskjMBZboEkmZKB/H0CZWkbqsBFWMvbijVscTRonlO9wojWDXucRUfJgFbc7edY3xMs0QhHazPV17FkEUM4Fs4FsJHORfIybHwR/U7hr/JjdNK4SE+zdUwD8G/rv4iDTH9DVl/ycmwIPh5WPk5VrxlWVBy6GbF/8a4e70OSn9tUugpO83QHbnyEYAJT6F1eSGykT18HEIFXwlve3/3u43E3DJ9MJYmzGPoOF2qfd+0T3XlCwMMN1ICjJp9i4AorxkxsDwdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/7/2026 3:04 PM, David Hildenbrand (Arm) wrote:
> On 7/7/26 03:28, Kefeng Wang wrote:
>>
>>
>> On 7/7/2026 2:30 AM, David Hildenbrand (Arm) wrote:
>>> On 7/6/26 13:19, Kefeng Wang wrote:
>>>> pte_pfn() and pte_dirty() have undefined behaviour when called on a
>>>> non-present PTE. In migrate_vma_collect_pmd(), these functions may be
>>>> invoked on non-present entries (e.g., swap PTEs), leading to potential
>>>
>>> Certainly not real swap PTEs, as the previous function handling is
>>>
>>>      if (!pte_present(pte)) {
>>>          ...
>>>          if (!softleaf_is_device_private(entry))
>>>              goto next;
>>>
>>> Only device-private entries?
>>
>> Yes，device-private entries.
>>
>>>
>>>
>>>> crashes from pte_pfn() or incorrect dirty folio accounting from
>>>> pte_dirty(). Fix both by guarding with pte_present() checks.
>>>>
>>>> Fixes: fd35ca3d12cc ("mm/migrate_device.c: copy pte dirty bit to page")
>>>> Fixes: a3589e1d5fe3 ("mm/migrate_device.c: add missing flush_cache_page()")
>>>
>>> I suspected device-private code, but indeed, these seem to be added afterwards.
>>>
>>> But a3589e1d5fe3 only moved the flush_cache_page()? So that one seems wrong.
>>
>> I couldn't find a more suitable commit, before a3589e1d5fe3, the
>> flush_cache_page() only called under anon_exclusive, not a device
>> private entry, so there is no issue. This is the reason why I chose
>> this commit.
> 
> What makes you believe device-private entries wouldn't have PAE set?
> 
> This likely goes back to initial support for device-private.
> 

We only need to make sure that flush_cache_page(..,pte_pfn(pte)) won't
be called under no-present pte, I go back and find the
flush_cache_page function was first introduced to
migrate_vma_collect_pmd in commit 6c287605fd56, so maybe this commit is
better for fix tag? what's your option?


