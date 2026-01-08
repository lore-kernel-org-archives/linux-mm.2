Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 551FED14885
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 01:05:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7A176B0092; Wed,  7 Jan 2026 20:05:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFD3D6B0093; Wed,  7 Jan 2026 20:05:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FC336B0095; Wed,  7 Jan 2026 20:05:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8AB5B6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:05:27 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 282E38BEA5
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 01:05:27 +0000 (UTC)
X-FDA: 84307003494.23.07853FE
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf20.hostedemail.com (Postfix) with ESMTP id F244A1C000C
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 01:05:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=TQkMm8UL;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767834325; a=rsa-sha256;
	cv=none;
	b=b0SEk3EAPgGzWmmJ5wUzGWCNul6HtvGEZjWT8Yi7duzBfeRDZ2UxOr4jhuZUoUdYKmx1B6
	Tarn/kWAn/bjCIgv8OIpDmzHgsg8clhuqNo784x0ajO8AaVMAQ5ZXBsxcrZhmCUW2/zrg4
	B/J1NzL9t1DeIw28TWWBeQULTyD/PlY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=TQkMm8UL;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767834325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ECHBRu0o9BSy6V8xyse8KxOkWVDcoOyIf4bNDwk8cQ4=;
	b=vqy+BuMKRkQU6RVfeOk5MM3pT+J+ZFjP7waJG2URqu3vEarQglEGmI5wLSwOw/x9A5hgMR
	5ABG6pbnXj2+3fuNaZaIue4cXLhJNj0uDgY+PtyBQ/m7qFtH93bBHQxR9ZVOh3wBAvSL7M
	DM0M+xU1shlbz8h1If6e+htY/6XPLHM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ECHBRu0o9BSy6V8xyse8KxOkWVDcoOyIf4bNDwk8cQ4=;
	b=TQkMm8ULsEGg8u9MXzOrwG3G6m5JS54Dl8nG0SQg6VZ0RVJxympzUSmoYikgXuOOcyQdL7Cr0
	SLUAQAgPcAubwO4lyNK4VzbyBt6qIt6O9CUIlHQ5t9Jg9jDda/GVxylsyPTcXCYPoof5x1aclU4
	Rs5jwyXv/iuVrvvd65D+FJw=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4dmmp32LqRzLlXr;
	Thu,  8 Jan 2026 09:02:03 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 757E340539;
	Thu,  8 Jan 2026 09:05:18 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 8 Jan 2026 09:05:17 +0800
Message-ID: <eba617a5-6d8e-4998-bd6d-e25330657380@huawei.com>
Date: Thu, 8 Jan 2026 09:05:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 mm-new 0/6] mm: hugetlb: allocate frozen gigantic folio
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
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <7253A444-97D1-4256-9AD9-BCFF66437510@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F244A1C000C
X-Stat-Signature: sxmboudpskskckqrd575wgbcn8wam6sh
X-Rspam-User: 
X-HE-Tag: 1767834323-692682
X-HE-Meta: U2FsdGVkX1+bOzMjkBJIxc4LeK0dA9LX7fz1f2G5DOpsFc7I9oNIkn6gYcLXyGc1NWKqeZVYUbrC0Tgo+e/CaWiJA/dpwVHYq90+anGMzCo36MWZLDtC781H2XrkU/L/LsRewY+1Ir77Euo12NeqoWN71u3hZ63XzdIu1bheScBhjMRO//xVj3otDYLqi3e2xXfQ6g8NeQS39KXs3CwLCstzh5BK3hkZWWmxdlLpV4M+PXGlL726U/VcNMjzhGFmLOunVlDQGZyQbpkS9329H078Tw51ikhJm0l8g4LGfxFhT0pX3YUJ3cb/u6AbVOOG7s+l8hkp3vHxBZtD7PLSGMYxjEmZ+bN2X5BB8vGsBy76328xUE3X9CAGYsv/8IAQG9gYXZI9vIiIGb2p/4jXwdV2UgeM94/+pwRMe2t6ZxIuVRAmlB+X4KdHliBrsiyOixcUw63ryAcFCs32TxNwTM8Yy8lLUss6nuHQ+LJJevtbdxVjc5kBca5g1zDn9eZBqRQXWvLKmkpG+UZrOmVdgJbqaK6TT/fTy/w4s9p9qaOUDgWcdkOYtXf/hXkiYy0ml1PdfBV6tPt30CBm/9rYVAKj1Jz4dK1tMU05UgPq6AX8eqCwMoFe9IAkKnVs5IRLwvGsrg2i8fSzCBoEhdIsOTqT0qApjN2sDfsIv6jZtAvGRGTPMeIWpjbuFG1pD9iz9HhpWMkK5JFcfviZPc6ilpULt25Il8mF96ti03f3yzv3d+qhYbrB6udYX7RAkXSkuxXnnIDE+hgk8sLZTbNGEs3WSGc0L9YSY+lbYLTT5LaW42DngL1zl5TQxQPIV0AxdBRAr3I9+SM2PRWvpmfrooOIjM1YUjnw1Uu/uYriHPxRKWYxh9Yh/kMD51tx0j9Gxf5VWQFGpgFDvuLl0TunPgxQiXFSZ+QDpFOug4w8D3Gq7wbfJe6q57CHIZST8lSshwhUMM7osBQEGXdK2jt
 Pi4pYMJc
 Ova3zKgQn85u2lTo+IxFWN2NTzv6O8ODnWCv/iNtSLKWNOzdYb/w2gPjcNYR6PJ84A5BnxjOu35rOGGq3YKn8HLKiIAWjTOgY+2nOWuNzuchUYnkiqesHyzXMvJmnwch0vV2DMALRsLDoj41kHo/87ZUmOau6F8GOU9OSaQmKw3LmMIAu4ZQEFcPbsTWtJPUU9S5MJ121q+n8ZCB69jxer52VjERwMiT7A8mLsnpKt2lahCAiwc2WdP9LvPVPIE4wlInOMQ3RWcWEqVCdz4rp5aiLV3YE9VmYWWlZOwki1+ijGcVuEIS7NsD3k6B/RAZU1W4pFaBljPq6bfBpzIl5Xp4UpgJNPRQ3/VfgiG+M/Xi9qPKfcc+a03GjMfjAVJe9yyFCItT09CnIpDtzmP4sWyFvnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/8 3:38, Zi Yan wrote:
> On 7 Jan 2026, at 13:39, Mark Brown wrote:
> 
>> On Wed, Jan 07, 2026 at 07:31:30PM +0200, Claudiu Beznea wrote:
>>> On 12/30/25 09:24, Kefeng Wang wrote:
>>
>>>> Introduce alloc_contig_frozen_pages() and cma_alloc_frozen_compound()
>>>> which avoid atomic operation about page refcount, and then convert to
>>>> allocate frozen gigantic folio by the new helpers in hugetlb to cleanup
>>>> the alloc_gigantic_folio().
>>>
>>> I'm seeing the following issues on the Renesas RZ/G3S SoC when doing suspend
>>> to idle:
>>>
>>> [  129.636729] Unable to handle kernel paging request at virtual address
>>> dead000000000108
>>> [  129.644674] Mem abort info:
>>> [  129.647456]   ESR = 0x0000000096000044
>>
>> This is also introducing OOMs when doing at least audio tests (I don't
>> think these are super relevant) on Raspberry Pi 3B+ running NFS root
>> (probably more relevant):
>>
>> [   64.064256] Unable to handle kernel paging request at virtual address fffffdffc1000000
>>
>> ...
>>
>> [   64.087583] Call trace:
>> [   64.087586]  kmem_cache_free+0x88/0x434 (P)
>> [   64.087598]  skb_free_head+0x9c/0xb8
>> [   64.087608]  skb_release_data+0x120/0x174
>> [   64.087615]  __kfree_skb+0x2c/0x44
>> [   64.087622]  tcp_data_queue+0x948/0xe50
>>
>> Full log:
>>
>>    https://lava.sirena.org.uk/scheduler/job/2341856#L1721
>>
>> Bisection identifies:
>>
>> [fb9a328d30400dbc8b2ea5a57daeb28bedac398b] mm: cma: add cma_alloc_frozen{_compound}()
>>
>> as being the comit that introduces the issue.  Bisect log with links to
>> further test runs:
> 
> Hi Mark and Claudiu,

Thanks for the reports.

> 
> Can you try the patch below to see if it fixes the issue? Basically,
> in cma_release(), count was used to drop page ref and decreased to 0,
> but after the loop, count becomes -1 and __cma_release_frozen()
> is releasing unnecessary pages.

Oh，sorry for introducing the regression, my previous self-tests were
more focused on the hugetlb part, I should be more careful about this,
and thanks Zi Yan for the quick fix, I will do more check and test for
the non-hugetlb part.


