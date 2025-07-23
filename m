Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CC26C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 02:02:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6B496B0098; Tue, 22 Jul 2025 22:02:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B14CF6B009C; Tue, 22 Jul 2025 22:02:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A03A26B009F; Tue, 22 Jul 2025 22:02:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DC096B0098
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 22:02:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 11638160502
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 02:02:29 +0000 (UTC)
X-FDA: 83693880018.07.F772D33
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 55BE6120007
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 02:02:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of mawupeng1@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753236147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d2agrBvBemACrENpUmf6pE87fxbXMZrvKnaOPWkYKL4=;
	b=Jv4trFSl8xXAKZfMP0v+ythhDcZFGsBZz6wWUfMGFXyHlKm9kpTbxeFFxTXjtNKLo4j+qZ
	tiA6Ib0RWRMpuMkwCfOELN5h26ZsQc5xDrmLRy5oy2wbs05W9xXvyxopnMpXAvstlAcT+q
	7fDu8C7JsWWBWMxjjC1L7OR9DIl8i58=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of mawupeng1@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753236147; a=rsa-sha256;
	cv=none;
	b=NHA6Mg2lHlhWimsu59CcEP7TLwFC4IxVK5awvmeGIUbT1aQhMxjzbEqtqMZ5XE0R+ETQpI
	jiwGW0PY8KVwDMMA/0p8cDJ/d6UgilnekXXSbtksqnMfMXBm14ezmJmpktGOJerLZpUOZE
	7N3gMi1DmtIIL82OouRWGXB3iqVxcuI=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4bmy8p0YMDz16TKP;
	Wed, 23 Jul 2025 10:03:22 +0800 (CST)
Received: from kwepemg100017.china.huawei.com (unknown [7.202.181.58])
	by mail.maildlp.com (Postfix) with ESMTPS id DC5DD140257;
	Wed, 23 Jul 2025 10:02:21 +0800 (CST)
Received: from [10.174.178.114] (10.174.178.114) by
 kwepemg100017.china.huawei.com (7.202.181.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 23 Jul 2025 10:02:21 +0800
Message-ID: <d197fe6c-9541-444f-91b9-15653ea70644@huawei.com>
Date: Wed, 23 Jul 2025 10:02:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: mawupeng <mawupeng1@huawei.com>
Subject: Re: [PATCH] mm: ignore nomap memory during mirror init
To: <rppt@kernel.org>
CC: <mawupeng1@huawei.com>, <akpm@linux-foundation.org>, <ardb@kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
References: <20250717085723.1875462-1-mawupeng1@huawei.com>
 <aHjQp9zPVPuPyP3B@kernel.org>
 <9688e968-e9af-4143-b550-16c02a0b4ceb@huawei.com>
 <aHj8mfecDhJJZW1Y@kernel.org>
 <8d604308-36d3-4b55-8ddb-b33f8b586c1a@huawei.com>
 <aHzjOxg_oPp06blC@kernel.org>
 <205873c9-b8cd-4aa7-822e-3c1d6a5a5ea7@huawei.com>
 <aH9KfV8XM5fNsR/Y@kernel.org>
In-Reply-To: <aH9KfV8XM5fNsR/Y@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.114]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemg100017.china.huawei.com (7.202.181.58)
X-Rspam-User: 
X-Rspamd-Queue-Id: 55BE6120007
X-Rspamd-Server: rspam06
X-Stat-Signature: imiekm4tkzc6667dmp6nchzyyyq3e181
X-HE-Tag: 1753236145-612077
X-HE-Meta: U2FsdGVkX194cMlI840qz/DlrObkehvpXjEmOpjFvwieyC5xPxdngSP38WfhIqyGktWt8xdqZmdqHcWAJeTXPQJiEUd9WIn+9vJUtIriwmJlUrbCraKaFgooXR+f3oSSon2ZjVCJ72KYk7dbYd6Id8ZIbTlOIbroM23n99fnbDvX/oLmRiJ8viOCq7KJZ+ffsj5xKKGcf1Q59B8XEE64g0/4a43X52H9NvBMY4xLg/dvSgsXQ+QfB+nS479ZVkoPupMtMv7yRJYUzKQXgE8vjO9fSVzMkNkwfuM3tUKxH7DDNKjGB5K9WNZSq9sN+QuIHuN4ok9zjcw9znZLIacV4mTeqTyI1q96vzpUVGnrOTddOhsEDMECdSUFi4FoPaLkozxGxnd7/Adc1A9853o0IOX64mjEn6PuigKsETHcX6orVthQuaDz7HllRHejYWUahEaBMLd9h4wBH3izR69ItTxct6EZlZhnVy66rNJcJ1jEjtcG0cVB8IRNT22uLDrVpErsHsbVXHZTkDd9p7HQ78tH4/WgRVStx/LrfbaeY7YVxpHdigFNjqKajsua0fP7AYbkIWtC5VUai1JipD4tb0+ustuNgkaATYA7xSV35SLATM9fuAgNhKJavFE04g8SLTwmlxXIqIkLW/HdVPT7nwgdhQQkB80BSXUmslKC4z0UEHH7bVMQzXUFk3x2xLPkT0E0JJMN32+0mp60ceR3/qXd3hM2MIHa/xbPaRMP8b+pfKvES4FfssGK8PGcgITUrg5whL7T0rAKqDxm+fFQCHdO27h9JT9+7yb4UBb4PYA+vWcdLaH3W2yq70E94Zycjr/Dwy6gPHLk791ln3T63nu0rRmkY74s6raZBKsI1sb0i3nsHIyh56mcBTAVDULoUSyeijkycEzTgSZGX/XB5Qu/x8iZNidsWCrc7CX+5YDxANhyqp/O0t7w4un5/FjG6qCwy9wOAMFjjd1abTW
 E1NrAkUX
 SvE8LqUMMwoFs+P8mj6moHgNZgDWHhXU5+stj4Q6p0H9pR8gGAq6QeBKomYnkCAWUzCWxLPVkV7qMd1F+GJAiJtGO6FpujFqNdbGOVu0M0soCXbKrrhozRFtD4iWLBcNwVyfEQbSAqOLPB2ZunfKLxabbNVAY6MUFZWfyLWu2uVg00x/uDpM/nDgyTPjuXyQ6ifCDinAPPRX+T3bGUDSJ9B6nXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/7/22 16:23, Mike Rapoport wrote:
> On Mon, Jul 21, 2025 at 10:11:11AM +0800, mawupeng wrote:
>> On 2025/7/20 20:38, Mike Rapoport wrote:
>>> On Fri, Jul 18, 2025 at 09:37:48AM +0800, mawupeng wrote:
>>>>
>>>>
>>>> On 2025/7/17 21:37, Mike Rapoport wrote:
>>>>> On Thu, Jul 17, 2025 at 07:06:52PM +0800, mawupeng wrote:
>>>>>>
>>>>>> On 2025/7/17 18:29, Mike Rapoport wrote:
>>>>>>> On Thu, Jul 17, 2025 at 04:57:23PM +0800, Wupeng Ma wrote:
>>>>>>>> When memory mirroring is enabled, the BIOS may reserve memory regions
>>>>>>>> at the start of the physical address space without the MR flag. This will
>>>>>>>> lead to zone_movable_pfn to be updated to the start of these reserved
>>>>>>>> regions, resulting in subsequent mirrored memory being ignored.
>>>>>>>>
>>>>>>>> Here is the log with efi=debug enabled:
>>>>>>>>   efi:   0x084004000000-0x0842bf37ffff [Conventional|   |  |MR|...|WB|WT|WC|  ]
>>>>>>>>   efi:   0x0842bf380000-0x0842c21effff [Loader Code |   |  |MR|...|WB|WT|WC|  ]
>>>>>>>>   efi:   0x0842c21f0000-0x0847ffffffff [Conventional|   |  |MR|...|WB|WT|WC|  ]
>>>>>>>>   efi:   0x085000000000-0x085fffffffff [Conventional|   |  |  |...|WB|WT|WC|  ]
>>>>>>>> ...
>>>>>>>>   efi:   0x084000000000-0x084003ffffff [Reserved    |   |  |  |...|WB|WT|WC|  ]
>>>>>>>>
>>>>>>>> Since this kind of memory can not be used by kernel. ignore nomap memory to fix
>>>>>>>> this issue.
>>>>>>
>>>>>> Since the first non-mirror pfn of this node is 0x084000000000, then zone_movable_pfn 
>>>>>> for this node will be updated to this. This will lead to Mirror Region 
>>>>>>   - 0x084004000000-0x0842bf37ffff
>>>>>>   - 0x0842bf380000-0x0842c21effff 
>>>>>>   - 0x0842c21f0000-0x0847ffffffff
>>>>>> be seen as non-mirror memory since zone_movable_pfn will be the start_pfn of this node
>>>>>> in adjust_zone_range_for_zone_movable().
>>>>>
>>>>> What do you mean by "seen as non-mirror memory"?
>>>>
>>>> It mean these memory range will be add to movable zone.
>>>>
>>>>>
>>>>> What is the problem with having movable zone on that node start at
>>>>> 0x084000000000?
>>>>>
>>>>> Can you post the kernel log up to "Memory: nK/mK available" line for more
>>>>> context?
>>>>
>>>> Memory: nK/mK available can not see be problem here, since there is nothing wrong
>>>> with the total memory. However this problem can be shown via lsmem --output-all
>>>
>>> I didn't ask for that particular line but for *up to that line*.
>>>  
>>>> w/o this patch
>>>> [root@localhost ~]# lsmem --output-all
>>>> RANGE                                  SIZE  STATE REMOVABLE         BLOCK NODE   ZONES
>>>> 0x0000084000000000-0x00000847ffffffff   32G online       yes   67584-67839    0 Movable
>>>> 0x0000085000000000-0x0000085fffffffff   64G online       yes   68096-68607    0 Movable
>>>>
>>>> w/ this patch
>>>> [root@localhost ~]# lsmem --output-all
>>>> RANGE                                  SIZE  STATE REMOVABLE         BLOCK NODE   ZONES
>>>> 0x0000084000000000-0x00000847ffffffff   32G online       yes   8448-8479    0  Normal
>>>> 0x0000085000000000-0x0000085fffffffff   64G online       yes   8512-8575    0 Movable
>>>
>>> As I see the problem, you have a problematic firmware that fails to report
>>> memory as mirrored because it reserved for firmware own use. This causes
>>> for non-mirrored memory to appear before mirrored memory. And this breaks
>>> an assumption in find_zone_movable_pfns_for_nodes() that mirrored memory
>>> always has lower addresses than non-mirrored memory and you end up wiht
>>> having all the memory in movable zone.
>>
>> Yes.
>>
>>>
>>> So to workaround this firmware issue you propose a hack that would skip
>>> NOMAP regions while calculating zone_movable_pfn because your particular
>>> firmware reports the reserved mirrored memory as NOMAP.
>>>
>>> Why don't you simply pass "kernelcore=32G" on the command line and you'll
>>> get the same result.
>>
>> Since mirrored memory are in each node, not only one, "kernelcore=32G" can
>> not fix this problem.
> 
> I don't see other nodes in lsmem output. And I asked for the kernel log
> exactly to see how kernel sees the memory on the system.

Sorry for my mistake.

[    0.000000] efi: Processing EFI memory map:
[    0.000000] efi:   0x00005fff0000-0x00005fffefff [Conventional|   |  |  |  |  |  |  |  |  |  |   |WB|WT|WC|  ]
[    0.000000] efi:   0x00005ffff000-0x00005fffffff [Boot Data   |   |  |  |  |  |  |  |  |  |  |   |WB|WT|WC|  ]
[    0.000000] efi:   0x000060000000-0x00007fffffff [Conventional|   |  |  |  |  |  |  |  |  |  |   |WB|WT|WC|  ]
[    0.000000] efi:   0x082080000000-0x08247fffffff [Conventional|   |  |MR|  |  |  |  |  |  |  |   |WB|WT|WC|  ]
[    0.000000] efi:   0x082880000000-0x083fffffffff [Conventional|   |  |  |  |  |  |  |  |  |  |   |WB|WT|WC|  ]
[    0.000000] efi:   0x084004000000-0x0842bf37ffff [Conventional|   |  |MR|  |  |  |  |  |  |  |   |WB|WT|WC|  ]
[    0.000000] efi:   0x0842bf380000-0x0842c21effff [Loader Code |   |  |MR|  |  |  |  |  |  |  |   |WB|WT|WC|  ]
[    0.000000] efi:   0x0842c21f0000-0x0847ffffffff [Conventional|   |  |MR|  |  |  |  |  |  |  |   |WB|WT|WC|  ]
[    0.000000] efi:   0x085000000000-0x085fffffffff [Conventional|   |  |  |  |  |  |  |  |  |  |   |WB|WT|WC|  ]
[    0.000000] efi:   0x282000000000-0x2820ffffffff [Conventional|   |  |MR|  |  |  |  |  |  |  |   |WB|WT|WC|  ]
[    0.000000] efi:   0x282200000000-0x283f9bffffff [Conventional|   |  |  |  |  |  |  |  |  |  |   |WB|WT|WC|  ]
[    0.000000] efi:   0x283f9c000000-0x283fffffffff [Loader Code |   |  |  |  |  |  |  |  |  |  |   |WB|WT|WC|  ]
[    0.000000] efi:   0x284000000000-0x2841ffffffff [Conventional|   |  |MR|  |  |  |  |  |  |  |   |WB|WT|WC|  ]
[    0.000000] efi:   0x284400000000-0x285fffffffff [Conventional|   |  |  |  |  |  |  |  |  |  |   |WB|WT|WC|  ]
[    0.000000] efi:   0x000000000000-0x000003ffffff [Reserved    |   |  |  |  |  |  |  |  |  |  |   |WB|WT|WC|  ]
[    0.000000] efi:   0x000004000000-0x000007dfffff [Reserved    |   |  |  |  |  |  |  |  |  |  |   |  |  |  |UC]
[    0.000000] efi:   0x000007e00000-0x000007efffff [Reserved    |   |  |  |  |  |  |  |  |  |  |   |WB|WT|WC|  ]
[    0.000000] efi:   0x000007f00000-0x000007f5ffff [Reserved    |   |  |  |  |  |  |  |  |  |  |   |  |  |  |UC]
[    0.000000] efi:   0x000008000000-0x00000bffffff [Reserved    |   |  |  |  |  |  |  |  |  |  |   |WB|WT|WC|  ]
[    0.000000] efi:   0x00000c200000-0x00000fffffff [Reserved    |   |  |  |  |  |  |  |  |  |  |   |WB|WT|WC|  ]
[    0.000000] efi:   0x00001c000000-0x00001fffffff [Reserved    |   |  |  |  |  |  |  |  |  |  |   |WB|WT|WC|  ]
[    0.000000] efi:   0x0004002c0000-0x0004002cffff [MMIO        |RUN|  |  |  |  |  |  |  |  |  |   |  |  |  |UC]
[    0.000000] efi:   0x008410000000-0x008410000fff [MMIO        |RUN|  |  |  |  |  |  |  |  |  |   |  |  |  |UC]
[    0.000000] efi:   0x00c580030000-0x00c580030fff [MMIO        |RUN|  |  |  |  |  |  |  |  |  |   |  |  |  |UC]
[    0.000000] efi:   0x084000000000-0x084003ffffff [Reserved    |   |  |  |  |  |  |  |  |  |  |   |WB|WT|WC|  ]
[    0.000000] efi: Memory: 61376M/462861M mirrored memory
[    0.000000] ACPI: SRAT: Node 1 PXM 1 [mem 0x82080000000-0x83fffffffff]
[    0.000000] ACPI: SRAT: Node 0 PXM 0 [mem 0x84000000000-0x85fffffffff]
[    0.000000] ACPI: SRAT: Node 1 PXM 1 [mem 0x00000000-0x7fffffff]
[    0.000000] ACPI: SRAT: Node 3 PXM 3 [mem 0x282000000000-0x283fffffffff]
[    0.000000] ACPI: SRAT: Node 2 PXM 2 [mem 0x284000000000-0x285fffffffff]
[    0.000000] NUMA: NODE_DATA [mem 0x847ffff0b00-0x847ffffffff]
[    0.000000] NUMA: NODE_DATA [mem 0x8247fff0b00-0x8247fffffff]
[    0.000000] NUMA: NODE_DATA [mem 0x2841fffc9b00-0x2841fffd8fff]
[    0.000000] NUMA: NODE_DATA [mem 0x2820ffff0b00-0x2820ffffffff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000000000-0x00000000ffffffff]
[    0.000000]   DMA32    empty
[    0.000000]   Normal   [mem 0x0000000100000000-0x0000285fffffffff]
[    0.000000]   ExtMem   empty
[    0.000000]   Device   empty
[    0.000000] Movable zone start for each node
[    0.000000]   Node 0: 0x0000084000000000
[    0.000000]   Node 1: 0x0000082880000000
[    0.000000]   Node 2: 0x0000284400000000
[    0.000000]   Node 3: 0x0000282200000000
[    0.000000] Early memory node ranges
[    0.000000]   node   1: [mem 0x0000000000000000-0x0000000003ffffff]
[    0.000000]   node   1: [mem 0x0000000007e00000-0x0000000007efffff]
[    0.000000]   node   1: [mem 0x0000000008000000-0x000000000bffffff]
[    0.000000]   node   1: [mem 0x000000000c200000-0x000000000fffffff]
[    0.000000]   node   1: [mem 0x0000000011000000-0x000000001bffffff]
[    0.000000]   node   1: [mem 0x000000001c000000-0x000000001fffffff]
[    0.000000]   node   1: [mem 0x0000000020000000-0x000000005e26ffff]
[    0.000000]   node   1: [mem 0x000000005e270000-0x000000005fbeffff]
[    0.000000]   node   1: [mem 0x000000005fbf0000-0x000000007fffffff]
[    0.000000]   node   1: [mem 0x0000082080000000-0x000008247fffffff]
[    0.000000]   node   1: [mem 0x0000082880000000-0x0000083fffffffff]
[    0.000000]   node   0: [mem 0x0000084000000000-0x0000084003ffffff]
[    0.000000]   node   0: [mem 0x0000084004000000-0x00000847ffffffff]
[    0.000000]   node   0: [mem 0x0000085000000000-0x0000085fffffffff]
[    0.000000]   node   3: [mem 0x0000282000000000-0x00002820ffffffff]
[    0.000000]   node   3: [mem 0x0000282200000000-0x0000283fffffffff]
[    0.000000]   node   2: [mem 0x0000284000000000-0x00002841ffffffff]
[    0.000000]   node   2: [mem 0x0000284400000000-0x0000285fffffffff]
[    0.000000] mminit::pageflags_layout_widths Section 0 Node 8 Zone 3 Lastcpupid 20 Kasantag 0 Gen 3 Tier 2 Flags 26
[    0.000000] mminit::pageflags_layout_shifts Section 21 Node 8 Zone 3 Lastcpupid 20 Kasantag 0
[    0.000000] mminit::pageflags_layout_pgshifts Section 0 Node 56 Zone 53 Lastcpupid 33 Kasantag 0
[    0.000000] mminit::pageflags_layout_nodezoneid Node/Zone ID: 64 -> 53
[    0.000000] mminit::pageflags_layout_usage location: 64 -> 28 layout 28 -> 26 unused 26 -> 0 page-flags
[    0.000000] Initmem setup node 0 [mem 0x0000084000000000-0x0000085fffffffff]
[    0.000000] mminit::memmap_init Initialising map node 0 zone 4 pfns 2214592512 -> 2248146944
[    0.000000] Initmem setup node 1 [mem 0x0000000000000000-0x0000083fffffffff]
[    0.000000] mminit::memmap_init Initialising map node 1 zone 0 pfns 0 -> 1048576
[    0.000000] mminit::memmap_init Initialising map node 1 zone 2 pfns 1048576 -> 2214592512
[    0.000000] mminit::memmap_init Initialising map node 1 zone 4 pfns 2189950976 -> 2214592512
[    0.000000] Initmem setup node 2 [mem 0x0000284000000000-0x0000285fffffffff]
[    0.000000] mminit::memmap_init Initialising map node 2 zone 2 pfns 10804527104 -> 10838081536
[    0.000000] mminit::memmap_init Initialising map node 2 zone 4 pfns 10808721408 -> 10838081536
[    0.000000] Initmem setup node 3 [mem 0x0000282000000000-0x0000283fffffffff]
[    0.000000] zone_type: 0, zone_low: 0x0, zone_high: 0x100000
[    0.000000] mminit::memmap_init Initialising map node 3 zone 2 pfns 10770972672 -> 10804527104
[    0.000000] mminit::memmap_init Initialising map node 3 zone 4 pfns 10773069824 -> 10804527104
[    0.000000] On node 1, zone DMA: 15872 pages in unavailable ranges
[    0.000000] On node 1, zone DMA: 256 pages in unavailable ranges
[    0.000000] On node 1, zone DMA: 512 pages in unavailable ranges
[    0.000000] On node 1, zone DMA: 4096 pages in unavailable ranges
[    0.000000] Fallback order for Node 0: 0 1 2 3 
[    0.000000] Fallback order for Node 1: 1 0 2 3 
[    0.000000] Fallback order for Node 2: 2 3 0 1 
[    0.000000] Fallback order for Node 3: 3 2 0 1 
[    0.000000] mminit::zonelist general 0:Movable = 0:Movable 1:Movable 1:Normal 1:DMA 2:Movable 2:Normal 3:Movable 3:Normal 
[    0.000000] mminit::zonelist thisnode 0:Movable = 0:Movable 
[    0.000000] mminit::zonelist general 1:DMA = 1:DMA 
[    0.000000] mminit::zonelist general 1:Normal = 1:Normal 1:DMA 2:Normal 3:Normal 
[    0.000000] mminit::zonelist general 1:Movable = 1:Movable 1:Normal 1:DMA 0:Movable 2:Movable 2:Normal 3:Movable 3:Normal 
[    0.000000] mminit::zonelist thisnode 1:DMA = 1:DMA 
[    0.000000] mminit::zonelist thisnode 1:Normal = 1:Normal 1:DMA 
[    0.000000] mminit::zonelist thisnode 1:Movable = 1:Movable 1:Normal 1:DMA 
[    0.000000] mminit::zonelist general 2:Normal = 2:Normal 3:Normal 1:Normal 1:DMA 
[    0.000000] mminit::zonelist general 2:Movable = 2:Movable 2:Normal 3:Movable 3:Normal 0:Movable 1:Movable 1:Normal 1:DMA 
[    0.000000] mminit::zonelist thisnode 2:Normal = 2:Normal 
[    0.000000] mminit::zonelist thisnode 2:Movable = 2:Movable 2:Normal 
[    0.000000] mminit::zonelist general 3:Normal = 3:Normal 2:Normal 1:Normal 1:DMA 
[    0.000000] mminit::zonelist general 3:Movable = 3:Movable 3:Normal 2:Movable 2:Normal 0:Movable 1:Movable 1:Normal 1:DMA 
[    0.000000] mminit::zonelist thisnode 3:Normal = 3:Normal 
[    0.000000] mminit::zonelist thisnode 3:Movable = 3:Movable 3:Normal 
[    0.000000] Built 4 zonelists, mobility grouping on.  Total pages: 108375876
[    0.000000] Policy zone: Normal
[    0.000000] Memory: 464660912K/440384512K available (14848K kernel code, 5388K rwdata, 10340K rodata, 5696K init, 10981K bss, 18446744073685275216K reserved, 0K cma-reserved)

>  
> Another question is do you really need ZONE_MOVABLE? Most of the time MM
> core operates on the pageblock granularity and even if all the memory are
> in ZONE_NORMAL the pageblocks are still movable.

With feature kenrelcore=mirror, movable zone is needed to limit kernel memory usage.
The kernel and drivers default to allocating memory from mirrored memory, enhancing
reliability during Uncorrectable Errors (UE).

> 


