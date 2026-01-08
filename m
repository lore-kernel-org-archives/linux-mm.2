Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E4DBD148A3
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 06:57:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D08C6B0088; Thu,  8 Jan 2026 01:57:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47ECF6B0092; Thu,  8 Jan 2026 01:57:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 380A66B0093; Thu,  8 Jan 2026 01:57:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 26A9A6B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 01:57:34 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2AB91B993
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 06:57:33 +0000 (UTC)
X-FDA: 84307890786.12.7493E9D
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf17.hostedemail.com (Postfix) with ESMTP id F2FC940004
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 06:57:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=UTe6Ecu6;
	spf=pass (imf17.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767855451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bow57oT3rGSpIfTThK0TDTs+Slu2l4ZvaANz+0nCNcc=;
	b=dB3d2JOS1AWn0iXzapA9OilyxqT2GSpebFWK6HjVircne6BG01oIBp2IK15WZ76NLSJjja
	z1RiDRcL5AjBpEQnzEU6CP36U8OlXr1HlYD1hnN6GXGZoyrTvKDqg2NscDQSAXJyERQarD
	C7X/mMQxY+qmX3EMOKbN9ZUiloqUut0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=UTe6Ecu6;
	spf=pass (imf17.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767855451; a=rsa-sha256;
	cv=none;
	b=XH+8gZsq6BwfWbCn3Az3TLoRc3C1syz81n5HWEmK6LdI64rkTh7AbmnzLZAk5zG4Gqp1Ns
	BZl5fR8R1gvsZir+W1dKpnmlSAj7/lxzRZ2BZC3vDvteqexLJy1D29fY0S00G4UnE+Ento
	Ozy9ECodKjc2druaIOQusq3YD/DrXRg=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Bow57oT3rGSpIfTThK0TDTs+Slu2l4ZvaANz+0nCNcc=;
	b=UTe6Ecu6qfsQYdyeHYZc928+L/V4Mm1zJWSER7X87+aQYLe3pLDqdQNREWYiUoAlPQQjUqBmH
	xfdbGFrqV88Qq31ES+MASE+Aj7OeIpsnYsDzk2yX1fL68GCWAsuMlbDHr4UgivYWJZShh5M9hb0
	PodK0ZuXtl++K+Lk9PskOZg=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4dmwcJ5zs4z1cyPr;
	Thu,  8 Jan 2026 14:54:08 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 499BD40563;
	Thu,  8 Jan 2026 14:57:24 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 8 Jan 2026 14:57:23 +0800
Message-ID: <fe460dca-82db-478d-8fcb-b212ab34ead1@huawei.com>
Date: Thu, 8 Jan 2026 14:57:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/6] mm: cma: add cma_alloc_frozen{_compound}()
To: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>, <sidhartha.kumar@oracle.com>,
	<jane.chu@oracle.com>, Zi Yan <ziy@nvidia.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
References: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
 <20251230072422.265265-6-wangkefeng.wang@huawei.com>
 <aV8wOx_O5Esy5fni@umbar.lan>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <aV8wOx_O5Esy5fni@umbar.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F2FC940004
X-Stat-Signature: sm8r9wqynrbnnpwkqjbinc3ry1j41mgf
X-HE-Tag: 1767855449-463291
X-HE-Meta: U2FsdGVkX1+i6O7326WNcqekuRTPblwePkFzHB2Gz8W7kIVMreTGvfca9QJRf7s4SA2d4AOpoykxM7iGayq8YUdIPqv0e+nOs+vLhDgOYAF/+8/uZtpq9kZCD8pzRWDfAwaYQjV06a++hgKKQiW5SURbLmlBf4C9Mji9LeF2kpUBEt5nTIUiqCuC7EZjN6pJZNswfhWtpKKPrkZLIilBdVNQSxvGGpjC+lxD88ZYcDmUkUCCMeepxgmeWx4ZYr1P/78dW4pkQBQXS+Hl9BngItNhbioPvkWqg04N2qcFHIDvJl8jJGe8rs14oxGkjGg09Fz7pZGCvlc5LrPdaUeC9gYU2PHQU28aoT7D7zKNiYcJW7MwXT7+eej7LVWgdoot4lSr84uN7HzGnoY+nboPZKtmxrwvyB9THYfUukQ5qt2NcSQz+2PkxBF41ujthJASsTClTiLzSJsWe2XLqDj/tqC9QbFUk+C0JgUofCjMqBYZe7lA15uCOrMhgHNDqMhaTYEPjDbUTo/hUiEdYGcF7vOwSg/xjNgWlQLxoysK9ILPEM4i25PEkx7PdzAbcKmjsw6uwO+9iQQvI6ogcRiWtQ9eeh0FZ2zOV5+0Vh0IKkCHCVl13kgmfKVNyuJu2XBE5kBu6lEjvauqCxrSayc68VBuwg1ODr6K0XfwmIE0iwOS6f9KQ+srL9Ktt5q8FrcsM8T6sW8NC8YvbntEXupD6Pt5rAdcchWHZIFbx6vR60ptOoCdZDnqe5vfY2D1iulwk1NqngVVdSr0vYDXT3pPXnFa7pohI4vkZqy9tTJYOjLhuADDD//LjvFiOAGRyuvi2mFteTaUpo24hhmKeMRxi/0ffwEt8jP2+kvo5dRD6ufuFUvWbuEfHNTnzK5YGrdiBJSeMQJizmbGhP91j9Qf353s8vloK53XS3VCdnSRR/yrVesNhpZB7LwSI99u43jYhhTfRtCW52orZxBv5ZB
 ouT25GJe
 5BrJIxslF68UEr/ybY/wdqmCAvsJVNnOQhEl02HNj63iyduIy0Va8k84I/rfPrnsHH1qPt81RvHc09NLBIWvQ4J6ElC4pUV95+eCIQppl+JbnMJbuTThRIWuxme548yIZEQeHNmTgMLgtkv6tw+qqXLhxnBIqioxKK1gFD4AIojRXGJDNFzjsBwfQZUAGH6GFApoKovAWXme55clvjfQEhriX9fLAh2QYD/SuOz8kT8mmrGOjhm9Vrvs6OgO+DgODBpT45Ao2Be7h8Riw+WUELxlDOqPpQKCZ1wpGicHDRdl3dMcqxTzCB0TWovr9yXhTn8C202npFtz6kLX/gtClpINtPc9xerCOKwys4WOKJ0t2q376GZ3pXdu+lQ/QWZiTRrVvvXsJxR2iAV+oCkw8xhW4oRJd2zpYg4smUI4RegzhetkhtWhBQK0Bpg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/8 12:19, Dmitry Baryshkov wrote:
> On Tue, Dec 30, 2025 at 03:24:21PM +0800, Kefeng Wang wrote:
>> Introduce cma_alloc_frozen{_compound}() helper to alloc pages without
>> incrementing their refcount, then convert hugetlb cma to use the
>> cma_alloc_frozen_compound() and cma_release_frozen() and remove the
>> unused cma_{alloc,free}_folio(), also move the cma_validate_zones()
>> into mm/internal.h since no outside user.
>>
>> The set_pages_refcounted() is only called to set non-compound pages
>> after above changes, so remove the processing about PageHead.
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   include/linux/cma.h |  26 +++--------
>>   mm/cma.c            | 107 +++++++++++++++++++++++++++++---------------
>>   mm/hugetlb_cma.c    |  24 +++++-----
>>   mm/internal.h       |  10 ++---
>>   4 files changed, 97 insertions(+), 70 deletions(-)
>>
> 
> This breaks booting of Qualcomm RB3 Gen2:

Thanks for your report, sorry for the regression, Zi has post a fix [1],
could you try it? I will do more test and resend a new version.

[1] 
https://lore.kernel.org/linux-mm/7253A444-97D1-4256-9AD9-BCFF66437510@nvidia.com/

> 
> [    9.500774] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000008
> [    9.509862] Mem abort info:
> [    9.512745]   ESR = 0x0000000096000004
> [    9.516597]   EC = 0x25: DABT (current EL), IL = 32 bits
> [    9.522050]   SET = 0, FnV = 0
> [    9.525194]   EA = 0, S1PTW = 0
> [    9.528429]   FSC = 0x04: level 0 translation fault
> [    9.533440] Data abort info:
> [    9.536400]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
> [    9.542030]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
> [    9.547224]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
> [    9.552684] [0000000000000008] user address but active_mm is swapper
> [    9.559237] Internal error: Oops: 0000000096000004 [#1]  SMP
> [    9.565054] Modules linked in:
> [    9.568202] CPU: 7 UID: 0 PID: 59 Comm: kworker/u32:1 Not tainted 6.19.0-rc3-00212-gfb9a328d3040 #4016 PREEMPT
> [    9.578552] Hardware name: Qualcomm Technologies, Inc. Robotics RB3gen2 (DT)
> [    9.585792] Workqueue: events_unbound deferred_probe_work_func
> [    9.591791] pstate: 204000c5 (nzCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [    9.598941] pc : __get_pfnblock_flags_mask.isra.0+0x30/0x60
> [    9.604669] lr : free_pcppages_bulk+0x120/0x274
> [    9.609327] sp : ffff8000808ab610
> [    9.612741] x29: ffff8000808ab610 x28: 0000000000000001 x27: ffff0001797fa380
> [    9.620071] x26: ffffa5ded75b3800 x25: 0000000000000004 x24: ffff0001797fa390
> [    9.627399] x23: ffffa5ded7850ea0 x22: 0000000000000001 x21: 000000000000003a
> [    9.634728] x20: ffff00017f41b020 x19: ffff0001797fa3f0 x18: ffff000080a2a9e8
> [    9.642057] x17: ffff000080a2a9e8 x16: ffff0000803c1b50 x15: 0000000000000003
> [    9.649385] x14: 0000000000000028 x13: 0000000000006aa1 x12: 0000000000000000
> [    9.656707] x11: 0000000000000001 x10: 0000000000000000 x9 : fffffdffc1f8c000
> [    9.664037] x8 : ffff00017f41b028 x7 : ffff00017f41ae00 x6 : fffffdffc1f8c008
> [    9.671364] x5 : fffffc08070506c0 x4 : 000001fffff8100e x3 : 0001fffff8100e0a
> [    9.678693] x2 : 0000000000000000 x1 : 0000000000000017 x0 : fffffc08070506c0
> [    9.686021] Call trace:
> [    9.688537]  __get_pfnblock_flags_mask.isra.0+0x30/0x60 (P)
> [    9.694257]  free_frozen_page_commit.isra.0+0x1a8/0x478
> [    9.699628]  __free_frozen_pages+0x240/0x5c0
> [    9.704013]  free_contig_frozen_range+0xc8/0x110
> [    9.708764]  __cma_release_frozen+0x54/0x188
> [    9.713159]  cma_release+0x4c/0x78
> [    9.716661]  dma_free_contiguous+0x2c/0x74
> [    9.720870]  dma_direct_free+0xf4/0x188
> [    9.724814]  dma_free_attrs+0xa8/0x1d8
> [    9.728666]  qcom_scm_pas_init_image+0x178/0x18c
> [    9.733414]  qcom_mdt_pas_init+0x130/0x23c
> [    9.737623]  qcom_mdt_load+0x44/0xa0
> [    9.741299]  venus_boot+0x14c/0x2e8
> [    9.744891]  venus_probe+0x32c/0x5d8
> [    9.748567]  platform_probe+0x5c/0xa4
> [    9.752332]  really_probe+0xbc/0x2c0
> [    9.756009]  __driver_probe_device+0x78/0x120
> [    9.760483]  driver_probe_device+0x3c/0x160
> [    9.764779]  __device_attach_driver+0xb8/0x140
> [    9.769347]  bus_for_each_drv+0x88/0xe8
> [    9.773290]  __device_attach+0xa0/0x198
> [    9.777232]  device_initial_probe+0x50/0x54
> [    9.781527]  bus_probe_device+0x38/0xac
> [    9.785468]  deferred_probe_work_func+0x90/0xcc
> [    9.790130]  process_one_work+0x214/0x64c
> [    9.794251]  worker_thread+0x1bc/0x360
> [    9.798103]  kthread+0x14c/0x220
> [    9.801424]  ret_from_fork+0x10/0x20
> [    9.805103] Code: f8647842 f100005f 8b231043 9a821062 (f9400442)
> [    9.811358] ---[ end trace 0000000000000000 ]---
> 


