Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AA82C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 14:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03BDF6B009E; Tue,  7 Jul 2026 10:21:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2EC06B009F; Tue,  7 Jul 2026 10:21:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E449D6B00A2; Tue,  7 Jul 2026 10:21:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C09F56B009E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:21:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F8681C7D8A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:21:10 +0000 (UTC)
X-FDA: 84962192700.07.8FBAB19
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf28.hostedemail.com (Postfix) with ESMTP id 528D9C0011
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:21:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=IxZEmYmd;
	spf=pass (imf28.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783434068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9UR0DJFDYdTjLSKD+Ox3btFqKcvzvk1RG06ceexCIxs=;
	b=clkPem6FxpxgI/MrxOozvdvqHiLhjLi+ywS7NIqsg1R8ugwza417+RC74LPMBPIk/Z9lmt
	sr+CJV/kM120AkwhbaE5mGzvndHHUzSnyPMK0pRGZrhb3kgqMIIb8vPyRW/VOnEHVDcQdz
	mPn11hj8Ob7KdP+7BKTR9n/UBm3dEvU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=IxZEmYmd;
	spf=pass (imf28.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783434068;
	b=26qkQwMCsBJMUh6XJHjPvPD6nopWy5agX6AXdj20eCX/ZnPCZkRvp48uhZb8ME2hEwjFv+
	9Dnt7hM+f6Nd+oPQiCu21ug51piEKn8pJX0AdHQ42c5q6LG3tf6ZagF63+l/dvOAqwT2Ej
	lkUuLCnE6yu0hQfQUBaWIGzYkADKR0s=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=9UR0DJFDYdTjLSKD+Ox3btFqKcvzvk1RG06ceexCIxs=;
	b=IxZEmYmdgIQZcIZxCEPghLCXKN2APrDU7BMTcge+MC/YSkRaLG+uOagSSgHgOgd35JlTzCrKZ
	hWnXxH4kUiR9hoCV4MdVFfV4inrMYw6+315UKE6w76lWvmmsQTmQk2H3BOq0+l2SXzOF1OCz5KY
	6Y3zyuGEbzbc8Nt2OcmIlG8=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gvjpx2k3rznTVW;
	Tue,  7 Jul 2026 22:12:25 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id D5E984055B;
	Tue,  7 Jul 2026 22:21:01 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 7 Jul 2026 22:21:00 +0800
Message-ID: <6f7a4d08-f8fc-4ca9-a0c0-9d35cfe97072@huawei.com>
Date: Tue, 7 Jul 2026 22:20:59 +0800
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
 <5a097591-5a6a-44f2-b440-44a2395fa788@huawei.com>
 <56665ebc-a8de-4d59-a4bc-94b42a6b74cf@kernel.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <56665ebc-a8de-4d59-a4bc-94b42a6b74cf@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 528D9C0011
X-Stat-Signature: 19chika4jedw3hzsgmtirxw4rhm8kk9p
X-HE-Tag: 1783434066-581712
X-HE-Meta: U2FsdGVkX1/zT2DJKXKYUsn/jpUvSbIuBpLLDTM0eYKVQOLV5ANZrhCt4olVV5bFfmpTof7v9n3XbHGFXo+y8sDiUCn873e1pq18oKPLUpUMCMqTwteKlrkl8/7ikH00yladqS2EGhUqdlbHpwS4uoo17bpmANhmVTxFcMnCi+Z4DjL9RNAHR9FQtA8M5fHl4SYBwe0E9Mt+hfO3OkmLzyCxbqhgMTXyQTRxRmIPKthpV4U4o3wqgRFbBGumgefO4kWBfkeGCp6mjxEs/6Ig75ncKjzLjn+aoCtgjfbvGdvwnN2FwIeAuKyF50sczUYVZtr5b7g/D6OCftJ2xo1uY456DTc2WKhf7KMxg4N+W95O8r5Ip4+QLPYDFqzw2pj1nKAPDmhEgT3LL8KOtpaBK2IoDUvFjvENsGtui8CRNbrP0SoMN42yOn2To2WSl/HA99cAV71pqITF55IpchHvjwGp0TDw/A1jovKFHgsq636MqA2SfeLuquCgENX10KDo68hDs8eo1NEEPg3pA9ZPepSSKuPpu7MB8Qjwls4En+kIOzA3tX6JLmVn7lIWfJWY80IUjLfLly0zdT+aYB093cMd4LwzTIuVnm+m45IynhEk0kPun5HJ25E0I9CnxuuJHeqmUk26xliJ/0uMk11V/s5/vG8n4eW300CEQVr7NbhD7MfH/pVZe4nP31H13nermoNmazy66AkvSxvJJzsfQvVOoCoq5ay6uRsHX7wO4IXF9hdrkZYlr1Bku2s+NvYNiht4vwbBy/j4KQyFtckk4rIcrEjZ+xNiGqnXFrbkSR8Z+cU+wc7NbTGEBBM93Q4fTohLiu0q9Aoi6aT8/8ud6N3KxBLzCnC1Khd7mfqbiD9Cpn4o8E85rEJp0pdASgnkB+U3DvmcVInezVe7aUM3N/ar4umoZIuOfuHpWfHTuC7KB+GQxMJAq6/gxQL2IrWrs5MKqrvkgeONafwRwz1
 LU8cNlom
 b944ZsMBFQ2DyDko/kPREfVxvHS4KrSZi0tEezUBdJgXAGAhewfP6oDetw52aX4GguaKcWB8nRxNVfYeFqJhW5D0DyGh4am3o/2ZymsepZYuwn88lUhpf6sz5Cl/SI/kQrGe2V3hev1c4I+2OXW0vXM7Ll8JJibY+3S5t7UfassmaM0JxgbVQg3Lt3OEFHc40n2bQPv9j2oxypjFgheUooI8/4bP2Uc5dl2D6Qv26gS/uqWUpHU+lrStzxzaFIDiBLXVlQ5p80Pvrurwwbdk2AGK3JHlB1ENJ/F5lDx346e/vItOQwn5igAZkuvrjDAouen0M+FSOq8Ff+Wxn9LWSBmM9qsnVCci3e4CGpwNU3bmMuuJnwal70CZ/3EhcsM7t7GobO8/HqJRmzT3kRxW3nEXmQCrY+iQf9dWliQXmQmdglN5seJ5uGqgzDA7DHTMUPQEBCTYGpDiMIeeFeSRt/UAb6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/7/2026 9:03 PM, David Hildenbrand (Arm) wrote:
> On 7/7/26 11:33, Kefeng Wang wrote:
>>
>>
>> On 7/7/2026 3:04 PM, David Hildenbrand (Arm) wrote:
>>> On 7/7/26 03:28, Kefeng Wang wrote:
>>>>
>>>>
>>>>
>>>> Yes，device-private entries.
>>>>
>>>>
>>>> I couldn't find a more suitable commit, before a3589e1d5fe3, the
>>>> flush_cache_page() only called under anon_exclusive, not a device
>>>> private entry, so there is no issue. This is the reason why I chose
>>>> this commit.
>>>
>>> What makes you believe device-private entries wouldn't have PAE set?
>>>
>>> This likely goes back to initial support for device-private.
>>>
>>
>> We only need to make sure that flush_cache_page(..,pte_pfn(pte)) won't
>> be called under no-present pte, I go back and find the
>> flush_cache_page function was first introduced to
>> migrate_vma_collect_pmd in commit 6c287605fd56, so maybe this commit is
>> better for fix tag? what's your option?
> 
> That looks about right. For device-private we wouldn't need the ptep_clear_flush
> (ptep_get_and_clear would be sufficient), but that's a different optimization.
> 
OK， thanks for your confirm, will send v2.

