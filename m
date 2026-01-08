Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B285D1488A
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 01:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C0636B0092; Wed,  7 Jan 2026 20:54:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 098556B0093; Wed,  7 Jan 2026 20:54:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED9146B0095; Wed,  7 Jan 2026 20:54:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DB9AD6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:54:06 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 97CC31A05F2
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 01:54:06 +0000 (UTC)
X-FDA: 84307126092.07.C22EA35
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf05.hostedemail.com (Postfix) with ESMTP id AD4BA100005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 01:54:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=qZQ7AwSk;
	spf=pass (imf05.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767837244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+rD0zoOieZOqOtlkVgBVwio1Io4gWwc7IBLYiunUW/0=;
	b=PixPSMRML/rs0KCZS1VmqPJ+ANqQWxsyW5O0ALnbi0polRRbNdAn+2zQip6oLs//BTC7Yl
	LfAXnRu3L/WUs2EhFvuqTjHPGIRdZClI81fX/sXeC/2za/rkJuRdnl9WpV8+62+MGf/vxY
	RcyYEVHetY6V3WCTx704tvuZX2c58c8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=qZQ7AwSk;
	spf=pass (imf05.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767837244; a=rsa-sha256;
	cv=none;
	b=OE4pxwhyyjktAfZYK8mY0b/Cwt9ADeE9tHLO0J7yNdKAXrxk7ixP7NSKYPi3uNXuWJBZRl
	tvZJsWobmUVUk5qJHX1mXh9JTUCT7nPVNM2sGY8bJH3DIIBC6rNUcevoG8g/aFQE5bnGWp
	GIRzTA1n5vOwa2SV6t0i62qoLKjF/1o=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+rD0zoOieZOqOtlkVgBVwio1Io4gWwc7IBLYiunUW/0=;
	b=qZQ7AwSkdNdZ7mUsiIaKXu1EAIYj+8EqYn00de4ToPzsKsjMycE/BMSMJEQvq4LD2ivwFuaBK
	AFrOIG/o8NotuzwqQFSzyRf8YVT4HKxmHquLVDX1g3LjhSSeQuI3fct7y1pU8vr7X+ci2T9L4wp
	i/SMPh33lPWQiDGp91TRCYA=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dmnt76XXszKm6Y;
	Thu,  8 Jan 2026 09:50:39 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 6BEBF40565;
	Thu,  8 Jan 2026 09:53:56 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 8 Jan 2026 09:53:53 +0800
Message-ID: <7b0330e8-e42d-4aa8-91ab-1098a9f89c7e@huawei.com>
Date: Thu, 8 Jan 2026 09:53:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 mm-new 0/6] mm: hugetlb: allocate frozen gigantic folio
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Zi Yan <ziy@nvidia.com>, Mark Brown <broonie@kernel.org>, Claudiu Beznea
	<claudiu.beznea@tuxon.dev>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>, <sidhartha.kumar@oracle.com>,
	<jane.chu@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>
References: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
 <4211be25-3fc0-4395-9b24-a5ff0b3caa34@tuxon.dev>
 <13ad5888-2d53-40c8-9269-22bc6001754a@sirena.org.uk>
 <7253A444-97D1-4256-9AD9-BCFF66437510@nvidia.com>
 <eba617a5-6d8e-4998-bd6d-e25330657380@huawei.com>
Content-Language: en-US
In-Reply-To: <eba617a5-6d8e-4998-bd6d-e25330657380@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam02
X-Stat-Signature: 4bg7w4bp5g13gg675m57g38u37ibhyda
X-Rspam-User: 
X-Rspamd-Queue-Id: AD4BA100005
X-HE-Tag: 1767837243-376135
X-HE-Meta: U2FsdGVkX18j8SWWPZ1zUNZIXNIAHhFpTIamQGQtPLcYF2Hjwzq+akhZT92cVatKi26V2iZO3cDJNv5m3QNJOQpbuyPiS+47acOA+Anb14gf0ZUNZhoSssi+BScBh1NGGG4fcazmxWZn00UKGVbBBu2K5DHQntMZ39GwF5FcO0igYAmKc43JigfIW+9YLH0JnGY75VNBQNnOQEDUR6QwgwqShyykT5O8MftrWZknwTKVMX02Zy5208DecmDJ7b0tROdREoslblMUgx/+XSH3Rd7Ew9YMPd8zPR2QbumNFHe7cZVPaWvBP7tFOX3ne4GkfDMXkaedsa8kb5rVjxMJkGQfPPbnMlpdzgdvqlZDOrGoVQMzVyMXVLWtbZ9f9MjY1vGyTAG1x0b6/I9ilIUoQ1PQxFcD4oVQK+coIZcpua76b+X5y2ne//DukwIe4UltRJLJT84vA3WCktwqAhDLKGmhgvoEuSqZwXmz7ARf6WCc2nYGqzfCEbk5yBGEGrEeiWFKdf0nb0u7jFMR0DtmHK9KaFMDlXQxxLPSSpB31DxbCweJZeazy4/3q9VMtMUl1zAMwlEKkLwaPntL/VMN29HEMwFXvoGmSzkGnUWxoZHxe/m/tms3b+tNHgj6Wx675x639Gdp7S/zW3odWnPfNgIyRorwROSdqaX3oG3ZYLZuFMfYkHVDSMeZJVwL4YHGF5Yq7Ehn1wjMFLNButYZMAT4PHI8s3ch17ZKbRmt998Xs4qHDTQT1GjxsqpeteV+kF3YqONMvMyDXPfXqik4dv2ESsdbFp5R3PIAIqmCIO31ta6ZGoPe379XSCzgLFiHb9Q1+xoljXKi56qEx7uHlZ7PIbgDy9CvDRaRfl3BNV4hrKTEu0xxMi2FmVCWdBIML65X/WppOSuADEvq/7sFk3Q3Q/cpNqtdppOBFeLHv9SQwYE7kp0C2h3TnSBET7O/eOXbu86CXI9VFtQpl3w
 oEz/lKxL
 MfaTLlF/LJneaGxi8fR4a6kJdqeCkASkajgWsqOzSYudlV5G014CbOD/adh5vbhyLau9m+3U2DWU0qHA+9oSo4oZmV0/ylIxQurBAIz0sYP1fjSJ+bM/Axgb91+LcjlfK6nQAoi/prt3jlyO+7Zw4DqwiAl5N1moIpGuhbwP2rhR6MvBHcEmYsrh2NwpkL4KqC2gnFGKtQDANdKl1xoz1rBsqepiaMJIOwkXwHcaSQcfI2fUJxyBL/FaAfxKEldhryO20gkIG2A1de3U52UDAxSRDhQ0+BPXPhSV5IflKfLZ0I/XxX92RNgFx17A/FSEVjUTpsFl3mO3KEPV8H+gqe5g8RibteF6jIR3aSVXEb3fhKMhHjjyKefXubnAeFiWnP7Bxi8zO8A1a+y61klrnKbh/Kw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/8 9:05, Kefeng Wang wrote:
> 
> 
> On 2026/1/8 3:38, Zi Yan wrote:
>> On 7 Jan 2026, at 13:39, Mark Brown wrote:
>>
>>> On Wed, Jan 07, 2026 at 07:31:30PM +0200, Claudiu Beznea wrote:
>>>> On 12/30/25 09:24, Kefeng Wang wrote:
>>>
>>>>> Introduce alloc_contig_frozen_pages() and cma_alloc_frozen_compound()
>>>>> which avoid atomic operation about page refcount, and then convert to
>>>>> allocate frozen gigantic folio by the new helpers in hugetlb to 
>>>>> cleanup
>>>>> the alloc_gigantic_folio().
>>>>
>>>> I'm seeing the following issues on the Renesas RZ/G3S SoC when doing 
>>>> suspend
>>>> to idle:
>>>>
>>>> [  129.636729] Unable to handle kernel paging request at virtual 
>>>> address
>>>> dead000000000108
>>>> [  129.644674] Mem abort info:
>>>> [  129.647456]   ESR = 0x0000000096000044
>>>
>>> This is also introducing OOMs when doing at least audio tests (I don't
>>> think these are super relevant) on Raspberry Pi 3B+ running NFS root
>>> (probably more relevant):
>>>
>>> [   64.064256] Unable to handle kernel paging request at virtual 
>>> address fffffdffc1000000
>>>
>>> ...
>>>
>>> [   64.087583] Call trace:
>>> [   64.087586]  kmem_cache_free+0x88/0x434 (P)
>>> [   64.087598]  skb_free_head+0x9c/0xb8
>>> [   64.087608]  skb_release_data+0x120/0x174
>>> [   64.087615]  __kfree_skb+0x2c/0x44
>>> [   64.087622]  tcp_data_queue+0x948/0xe50
>>>
>>> Full log:
>>>
>>>    https://lava.sirena.org.uk/scheduler/job/2341856#L1721
>>>
>>> Bisection identifies:
>>>
>>> [fb9a328d30400dbc8b2ea5a57daeb28bedac398b] mm: cma: add 
>>> cma_alloc_frozen{_compound}()
>>>
>>> as being the comit that introduces the issue.  Bisect log with links to
>>> further test runs:
>>
>> Hi Mark and Claudiu,
> 
> Thanks for the reports.
> 
>>
>> Can you try the patch below to see if it fixes the issue? Basically,
>> in cma_release(), count was used to drop page ref and decreased to 0,
>> but after the loop, count becomes -1 and __cma_release_frozen()
>> is releasing unnecessary pages.
> 
> Oh，sorry for introducing the regression, my previous self-tests were
> more focused on the hugetlb part, I should be more careful about this,
> and thanks Zi Yan for the quick fix, I will do more check and test for
> the non-hugetlb part.
> 
> 

Based on the cma_debug interface, I performed quick tests to reproduce
the issue before Zi's fix. With the fix applied, the crash was resolved,
and no other issues were observed during testing.





