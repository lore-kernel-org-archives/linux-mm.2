Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0440BC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 02:50:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6836B0088; Mon, 13 Jul 2026 22:50:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A868D6B008C; Mon, 13 Jul 2026 22:50:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99D5B6B0096; Mon, 13 Jul 2026 22:50:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 698916B0088
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 22:50:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DA98B1601FF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:50:26 +0000 (UTC)
X-FDA: 84985853652.18.E170348
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3837AC0006
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:50:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="hiBkdD/S";
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783997425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jNJoHU87nSBvCFlt3auXmfy2Vb6oZ56F943v1fbfsuM=;
	b=w4mygpxk0AYsS0Lr9s2AfUG+RUIq3BM1wuuqndH2W+ORN+g04IAuM9NhSL+Zdv9hFAcJ4j
	ABeS17xr61R/AN967WK66dIpXQgl8LWH32pVWQHpC6kRXGvb1SLWqRA8OuSez+TJZmaL/k
	a4Vspk5lHGizqksg9homSyREKaTm1Qw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="hiBkdD/S";
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783997425;
	b=8pds8W2ek82mkT72vK0w4LxcXMI754NRlCWKbX01KY7nGd6A5JvWobJXxkqI7psG6Q0kC4
	7Ri7G90m7JxU3Lb0ADOWkV2TN5iP3E8q+YMhMTi/o5uyTc3FL53rZjSwFFP1EXUWcP9ujZ
	N9gVx6wNCUnxDbMjfIyxFiqqnFZx1QI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=jNJoHU87nSBvCFlt3auXmfy2Vb6oZ56F943v1fbfsuM=;
	b=hiBkdD/SVc8SirUlEiAR5/aPciyF247mGp0oFyKSsBXxNtb2BHyV2M0+yCxMcLKNo7kuoqI+L
	xtNlaQP7jIgIY06KWpbSLWirqelQ9xS3Kdf4minx37B4E+mjXoumnhQg8jDU10YO9QT5/RfrNG1
	EaqkQODQgzSuolHozXEknpY=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4gzk7z0DvYz1cyQ8;
	Tue, 14 Jul 2026 10:41:03 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 2D3C64055B;
	Tue, 14 Jul 2026 10:50:19 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 14 Jul 2026 10:50:18 +0800
Message-ID: <1295105d-cef7-4336-a1ac-c511c7ffc779@huawei.com>
Date: Tue, 14 Jul 2026 10:50:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] mm: mincore: improve mincore_hugetlb()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, "Liam R . Howlett" <liam@infradead.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
	<jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Zi Yan <ziy@nvidia.com>
References: <20260710120052.103886-1-wangkefeng.wang@huawei.com>
 <20260710120052.103886-5-wangkefeng.wang@huawei.com>
 <8992ac30-340d-42c7-8799-2d797b92b59c@kernel.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <8992ac30-340d-42c7-8799-2d797b92b59c@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3837AC0006
X-Stat-Signature: zkz8e41zggont534j447fniaf938mwqd
X-HE-Tag: 1783997424-364222
X-HE-Meta: U2FsdGVkX18KDr3dvvWgR61RKSqdLMXMijHRV2xqIb/n/0DJPCUDjtngkwE/K3y404pN206CfRYRqRrQjyWx56F3ngWaYJKgWIypkLHReFQ9cWF4dtN8w6BXwuupK1D+ESrKQMaZY9JNcUzcpUw1j36MH5InLhJPsPUFgaRSPw4jecWZQ5Y+6tkA1IC53sx3H0sOrG8LvdMTATFf8QvjV/Hkx1rWdRprNC+QKg6eOlHeWzSPS5Du8pVNxJ8r+vGW4Hq/SiXtPpKPm9jyUsyt2Fn3FWpvvXqc6ZaBSZo+tXvTljMx9nOvzYR0fEZL9SoQplFIvV9+RJSWkMnJT07CMI6ySI7MB5T4wW89LC3rx33ImZDRO1f9lnvuaxHJbJ3uobDG/BiFxHEV4nzXhn99x1yWyzzO2rPuT9qGhiCt06IaD+7Cqgm2HCoDI3ilgv3iAh5wkWqWQHbuMdlD8jdAhSdNeiYkM79nTwYCzFwTTOQOOPsmYqJyiDNHaJf4FJyUjQBIqndHzrml95C++QY2C/brLldu0xklVyNitVktSNivXjCDfew4DSie2Of9aTKX7NZrXH0X8UqlOk8UfwptiLKaDsrdMRVsrvAEoaPCdCSE9Hb0ZXW9TmWzcmjOHQKm/EFcc87gNPYkJLufgYfS0/Dh9JWUZCE9iQVuEHKBoFF5oLfsrv2U9h4GrFDspz4zJ74t4vrIEwFRnkufszM39M43hZpBQzHAngku65/lU1zzIoA46vPM9ygQF8LpPVgjh9KEeAtRleixTL2iWFe+i/8CUv89MlvmGRJR4dxWVrIRrHlBFdP6uOH/QPhNp0oruVPPLloOgYu2n+L3R6/KQSloO0HlXSX4Ca2BNvHrJj2IxAXitVBNWTygwWuJkCIuZYVcEp0/eMazNPtyX2XB3UxjOtHPWzUDrKgvLjDOxbZKbzaJYYdHcYyZPKXvm+BnkC5oPCqOKVLkh9zPyfi
 XG73I/cp
 lWFheNJMV1CrAi7Xw/D0FybxUAfdpNQ79X+LnL1ncmZ2FXgOMGZ4YxCckWpT8qMqz1VJY9bfuoB4XjVFJNrd0UFPwWFMJQ1P/PZzVoSDmW37sMcnK+uvNFu0bEDHK9yfSTyRd1nMeqNNXtliXoWAlF6zaNCIRbbUXPNvweaq7c7FsNmcYLMtbQDrQYCpkcksRP4aFsNO/MJmfZ5v5sTfPhwKKeuklJbHsthol5cg1uGq8kaPWfCP8eBROS4KOrfxp5PEwRYR/kfF+RHlnPoREtoQpWMNKDJIY5yg7ostZMDXlWVzTLedcTGc7KcqLtVp5Ffv8c79aGba+Zctl0BfbNto7n23e7k6FB4nwnvs3XEmIdAO8mU039y9oHWmuNg6juPjI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/10/2026 8:17 PM, David Hildenbrand (Arm) wrote:
> On 7/10/26 14:00, Kefeng Wang wrote:
>> The walk_hugetlb_range() always passes a non-NULL pte, so remove the
>> dead NULL check. Replace the per-page iteration loop with memset()
>> for better performance.
>>
>> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   mm/mincore.c | 27 +++++++--------------------
>>   1 file changed, 7 insertions(+), 20 deletions(-)
>>
>> diff --git a/mm/mincore.c b/mm/mincore.c
>> index 8b5e6afefb91..9952bc3edf76 100644
>> --- a/mm/mincore.c
>> +++ b/mm/mincore.c
>> @@ -28,30 +28,17 @@ static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
>>   			unsigned long end, struct mm_walk *walk)
>>   {
>>   #ifdef CONFIG_HUGETLB_PAGE
>> -	unsigned char present;
>> +	unsigned long nr = (end - addr) >> PAGE_SHIFT;
>>   	unsigned char *vec = walk->private;
>> +	unsigned char present;
>>   	spinlock_t *ptl;
>> +	pte_t ptep;
>>   
>>   	ptl = huge_pte_lock(hstate_vma(walk->vma), walk->mm, pte);
>> -
>> -	/*
>> -	 * Hugepages under user process are always in RAM and never
>> -	 * swapped out, but theoretically it needs to be checked.
>> -	 */
>> -	if (!pte) {
>> -		present = 0;
>> -	} else {
>> -		const pte_t ptep = huge_ptep_get(walk->mm, addr, pte);
>> -
>> -		if (huge_pte_none(ptep) || pte_is_marker(ptep))
>> -			present = 0;
>> -		else
>> -			present = 1;
>> -	}
>> -
>> -	for (; addr != end; vec++, addr += PAGE_SIZE)
>> -		*vec = present;
>> -	walk->private = vec;
>> +	ptep = huge_ptep_get(walk->mm, addr, pte);
>> +	present = !(huge_pte_none(ptep) || pte_is_marker(ptep));
> 
> Easier to read as
> 
> 	present = !huge_pte_none(ptep) && !pte_is_marker(ptep);

OK.

> 
> But now I wonder "why not pte_present()".
> 
> Calling this "present" is misleading. It's maybe "resident"?
> 
> I guess we want to indicate migration entries and hwpoison entries as "1".
> 

mincore - determine whether pages are resident in memory,  so resident
is much clear, will rename it, thanks.

