Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B81DC5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 01:00:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83AF26B008C; Mon, 24 Aug 2026 21:00:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C4FC6B0092; Mon, 24 Aug 2026 21:00:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68C846B0095; Mon, 24 Aug 2026 21:00:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B15A6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:00:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B9380402BF
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:00:05 +0000 (UTC)
X-FDA: 85137985170.22.C2E6552
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8C60A20003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:00:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Y+Nj0QVf;
	spf=pass (imf31.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787619603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f4qPy68Jjy02vLHv5nPbtQT7BMvyEVJ0wPWW7uigLt8=;
	b=CyBk/j6sLerPTvVNLOQ/fouoFnOUDMHNSKgeMPI+d6tofd1bj8GvsJhCASCJTsV16Z/vo6
	/X/WhV++FiBjTRLY+H3MJzOMqxURJgrDRHLhh0ZK0V+ZYiWmt6j3pD2qzHWtm08M98fvV5
	YMjVraS8OVI8iHmvGbv9QsVkpRSzrok=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Y+Nj0QVf;
	spf=pass (imf31.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787619603;
	b=ce/FKW/YSX3uJUSxDWEijtqnu7dRgxdpE2QO5fXGT+URGqgHxRXPpKkzXIbT44HJOXqkF+
	05CLlkYuwlFfhSVYI1Wz5axbO9ks5g0aapcGTesJ9P3ZEJqHPMoQ7TcceINnOG8x8e7z8G
	m5ekPpJND0IqkKkYH3PHeQ7tJaltst4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=f4qPy68Jjy02vLHv5nPbtQT7BMvyEVJ0wPWW7uigLt8=;
	b=Y+Nj0QVfpOGaQXqQ3Fi4T5/hmi+uBcDuV+Q9bPxhK2TEOTncZcMm2od73usG2VFQePJJfeocO
	4mVEaN/qqGNPFkjayljH0TsCNIRqvWnkezEaM9skJmnrm09dE+WyiznqGBguT0JNqwWbrWBOEmU
	7vy/6A2RAkh63w9BGgf4jEc=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hTTgY1gFdzRhRG;
	Tue, 25 Aug 2026 08:49:13 +0800 (CST)
Received: from kwepemj100016.china.huawei.com (unknown [7.202.194.10])
	by mail.maildlp.com (Postfix) with ESMTPS id 1BBE24057F;
	Tue, 25 Aug 2026 08:59:56 +0800 (CST)
Received: from [10.174.177.15] (10.174.177.15) by
 kwepemj100016.china.huawei.com (7.202.194.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 25 Aug 2026 08:59:55 +0800
Message-ID: <f53b5d3a-9f16-460c-a7d7-a0f518c2f21d@huawei.com>
Date: Tue, 25 Aug 2026 08:59:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
CC: <mawupeng1@huawei.com>, <liuye@kylinos.cn>, <hannes@cmpxchg.org>,
	<mhocko@kernel.org>, <david@kernel.org>, <ljs@kernel.org>,
	<hughd@google.com>, <mgorman@techsingularity.net>,
	<yang@os.amperecomputing.com>, <zhangqiuhao@huawei.com>,
	<wangkefeng.wang@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] mm: vmscan: fix scan overshoot and ineligible folio
 scanning
To: <akpm@linux-foundation.org>
References: <20260811070849.1332165-1-mawupeng1@huawei.com>
 <20260811184241.e423b81c8a50d5f212af1c3b@linux-foundation.org>
 <ef7a72dc-fc5f-4b08-833c-05c4ab416605@huawei.com>
From: mawupeng <mawupeng1@huawei.com>
In-Reply-To: <ef7a72dc-fc5f-4b08-833c-05c4ab416605@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.15]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemj100016.china.huawei.com (7.202.194.10)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8C60A20003
X-Stat-Signature: uu9ai914uukae74as4x5sekxwjn8cbcc
X-Rspam-User: 
X-HE-Tag: 1787619602-841446
X-HE-Meta: U2FsdGVkX1+cvnzLtoygigHrmEBdOyjK5BHLiFXZoSQEK46zW9czu6oU3/CiTNQs18X4lgs5cargYzsBDnR7V+4n5yDveGs4RC0V6RipEpEsi6ZG04kgWQr07NNC4xE7zsxn9uA5BHj8L/yApYvpxO8i5KrflDgBiAPfo7fTkEgr9h7jy9Q/iEoLkoGfABcgmKk4L7CyPPGcj/I1/hEc4d7IiILecTYR1yA/FzkXEAWd9cwRbFkwHVKI57MZ3dSpju1DO4Vpd0O6tKYAll8PiLMM0aPokYLRgivEJYNmddrc6r7haTUXv4H/W5lyenTf+FaI1DsNOwLx/O+PTi9wsT1edXVq8BtlST6We635pJYhUpZwZHtDgRaYjMbLDLvsld/JVP3qwNRfFyq8f2UdsdTOuf6UTr0UzB+iQOKu5mG3UYgvTUc/81TCduWAQftgl0gBE1RvIl9ZNyLCAUZ6kSdur3HZGsPEWwgK4nbdUBIqTIBkUPFHydd8oPLsyscXPjEoWL7/5cBg5aQi2PJbg6LwNIU1qp4LYO8Glo1iTRgHZcHGOI0cUE9kEctRixk/7YOiRJ6yDNGuu0UGsYpNVRCahCDLQhythS3qAIzQIsQhXO6z9+Jz/m0/fpvMgHzxppxvMjtVp5KxuYti0WkSQZfdf5lE9BOwRvz9Eyt1YKAkhQ+A5YlTKRo/S7f7NgbkocmAnNuvGrJZATfqrw3gQuATK8/yjATrTct51KkhLIofsN68lE/O+BlN7tBKMnIRNWkp8nHCHhNNLCDcRHld6L3KCTctW0wQk2Rn0HjAJusOmmJCRwfuYvx74gi+kej+kX6SjyQ8WznLAQrzyl1N5wsXnyYr7Qxns2QDSlUollw4HufVfouEafR8CjHn7N/3HN/tuZa7iWno56A9c9ny95IDOvX1O4wTJaMkBEUrd0bXrFtVVGACSBucACXRbyD1SwGuRk2cyhesmBRrLgD
 fjslBNXI
 LW+7vhXkhp9SAEIHWnGmej7UgvNdzTaGpqBSHipTqhBvJpTrnvh7AC9Oy7ijthz8SJ+lWjAPeD//lCalJvyWQzW8UuS6A4JR2A8rjlozxBbUr0cpcE1jFiSXECFHS2ywyzcr3XIT5Jq4GqrvsSjVOuLw6X5HtWKYLYQJiP5GxirBoZNsnyRCcVVO/Xfnp+Cq0lvR3zoB0jhzd35kzHgqnQaij47wDG2FNLKkoXalDIFgAq0ByuwbpWlo/gFTxH8t5UQWBY5ZNkBaikaEAdldFft5/PXumafm03te0nC0F2s2JmBnHNBtcN/2aIuG+ltbd5+YnKFYrH3nq4b67EfrO8jNnbQ+iKXj5IRcR4FLH5/162AefJY4eSYWQqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, maintainers
  Kindly ping.

On 周三 2026-8-12 10:29, mawupeng wrote:
> 
> 
> On 周三 2026-8-12 09:42, Andrew Morton wrote:
>> On Tue, 11 Aug 2026 15:08:47 +0800 Wupeng Ma <mawupeng1@huawei.com> wrote:
>>
>>> shrink_lruvec() drives reclaim in SWAP_CLUSTER_MAX (32) chunks, but
>>> isolate_lru_folios() may scan far more than that per call on a single
>>> LRU.  The excess is never charged back, so shrink_lruvec() keeps
>>> rescanning the same folios round after round.  When reclaim targets a
>>> lower zone, the same scanner also keeps walking zone-ineligible folios
>>> that can never satisfy the allocation, inflating nr_reclaimed into a
>>> false progress that delays the OOM.
>>>
>>> This series fixes both:
>>>
>>>   [1/2] Charge the isolate overshoot against the scan quota so the
>>>         next round skips already-scanned folios.
>>>   [2/2] Stop scanning once too many zone-ineligible folios have been
>>>         skipped, instead of force-isolating them.
>>
>> This all sounds fairly bad.  Is there some report?  Real-world test
>> results?  Laboratory test results?  Something to help us understand the
>> impact of the issues and the situations in which they occur.
>>
> 
> Sorry — this background belongs in the cover letter and I left it
> out.  Adding it here.
> 
> ## Situation
> 
> We observed slow, unexpected OOM behavior during extreme stress testing,
> and while digging into the reclaim code during that analysis we spotted
> these latent risks in isolate_lru_folios() — the overshoot never
> being charged back, and the force-isolate path on lower-zone reclaim.
> The concerns below are the ones surfaced from reading the code, then
> confirmed by constructing the situation deliberately.
> 
> The problem only appears when reclaim targets a lower zone while the
> LRU holds folios from a higher zone:
> 
>   - reclaim_idx points at DMA32/DMA (the triggering allocation asked
>     for a lower zone, e.g. __GFP_DMA32), and
>   - the LRU holds folios from a higher zone (Normal/Movable).
> 
> Normal userspace allocations go to the highest zone, so reclaim_idx
> never points below it and the zone-skip branch is never taken.  It
> needs a real lower-zone allocator to drain that zone below watermark;
> that is also why it went unnoticed upstream — the 1c7b17cf hard-lockup
> fix that introduced the force-isolate path was found only on a ~1 TB
> box running DMA32 module allocations.
> 
> ## Impact
> 
> Reproduced on x86 QEMU, 7.2-rc6, with a kernel module doing
> __GFP_DMA32 allocations to drain DMA32 below watermark (LRU folios
> sit in Movable):
> 
>   - A single isolate_lru_folios() call scanned 32794 pages and took
>     25 (32769 skipped): 99.9% wasted on ineligible folios.
>   - Across one run, isolate was called 339 times, 140-165 of which
>     isolated nothing (taken=0, pure empty scans).
>   - shrink_lruvec() charges only the 32-page quota per round and
>     never refunds the overshoot, so the same skipped folios are
>     rescanned round after round.  vmstat on a memcg OOM path:
>     Δpgscan_direct / Δpgsteal_direct = 2836624 / 112719 = 25.2x
>     (isolate -> shrink_folio_list returns the folio -> isolate again).
> 
> Once max_nr_skipped hits SWAP_CLUSTER_MAX_SKIPPED, the current code
> force-isolates the remaining ineligible folios.  On the inactive LRU
> they reach shrink_folio_list() and get reclaimed though they can
> never satisfy the allocation, inflating nr_reclaimed and resetting
> no_progress_loops in should_reclaim_retry(), delaying the OOM.
> 
> ## A/B results (same .config, md5-identical)
> 
> | metric                  | baseline   | patched | note |
> |-------------------------|------------|---------|------|
> | empty scans (taken=0)   | 140-165    | 0       | stable across runs |
> | isolate calls           | 339        | 7       | 48x fewer |
> | total pages scanned     | 343711     | 3140    | 109x fewer |
> | single-call max scan    | 32794      | 3104    | |
> 
> Empty-scan 0 is the stable evidence (holds every run).  The
> Δpgscan/Δpgsteal ratio is volatile (baseline 56-26675x, patched
> 65-1324x, ranges overlap) and is not relied on alone.
> 
> ## Caveats and reproduction
> 
>   - Triggering needs a lower-zone-pressured box.  To confirm the code
>     analysis, the situation was constructed on a small x86 QEMU VM
>     (1500M, CONFIG_LRU_GEN=n) with kernel cmdline
>     `movable_zone=DMA32 kernelcore=256M` (DMA32 small, Normal empty,
>     Movable large), then a kernel module doing
>     `alloc_page(GFP_DMA32)` drains DMA32 below watermark.  LRU folios
>     sit in Movable and are zone-skipped while reclaiming for DMA32.
>     Observed via the `mm_vmscan_lru_isolate` tracepoint and
>     /proc/vmstat (pgscan_direct, pgsteal_direct).
> 
>> Thanks.
> 


