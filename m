Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19894CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 14:31:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B27926B008C; Fri, 19 Jun 2026 10:31:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD8A16B0092; Fri, 19 Jun 2026 10:31:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C9776B0093; Fri, 19 Jun 2026 10:31:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72F946B008C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:31:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C5C5EC222C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:31:43 +0000 (UTC)
X-FDA: 84896900886.04.3F4DC38
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf08.hostedemail.com (Postfix) with ESMTP id D9098160017
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:31:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781879499;
	b=CFIKvsXnNqoLET//Eu07cZ7xZR+WdCADbndlbj8FoagoizwenNjH/act3glcu+1xKDteZS
	LRd2AJZj72G1yes7lvTu1JW6IVjl4WzHkzeBVP5IoQ3VozTA2bmMprLV+VXgn81X4sLKdq
	87RKX8duscDRlrHHh/at3H7S0tl4mMQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781879499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9SoETUnogv7G2Weuh2l2GyhsBBUD8typddPczE/TZsw=;
	b=gMmFOH23ugXVPfsoLXJlFxuiOm3zPANNZszEZpThDiQy4ydTRKTbSIyoEFQOxJUADSxR0+
	7K62Uid2ejFvq6ajV5FgPbe8vM+F9gA2K83jk4yJxNoEYXvcKjr38qKQtAWJsUKrlWIjfr
	Gw6sCruPy5gMFAUh6nc0XJkmLYWl8n0=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4ghg4n5rqPzJ46BZ;
	Fri, 19 Jun 2026 22:31:05 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 40FA540572;
	Fri, 19 Jun 2026 22:31:34 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 19 Jun 2026 17:31:33 +0300
Message-ID: <d0cda5a2-94f9-4733-8a62-90ad15243041@huawei-partners.com>
Date: Fri, 19 Jun 2026 17:31:33 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] mm/damon: Add mTHP-aware collapse/split with ARM
 SPE feedback
To: Wang Lian <lianux.mm@gmail.com>, <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <daichaobing@sangfor.com.cn>,
	<kunwu.chan@gmail.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<npache@redhat.com>
References: <20260619014707.9297-1-sj@kernel.org>
 <20260619034039.35643-1-lianux.mm@gmail.com>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260619034039.35643-1-lianux.mm@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: s9sptnm3axbictrdj8fe8ka9t38hdbad
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D9098160017
X-Rspam-User: 
X-HE-Tag: 1781879498-553738
X-HE-Meta: U2FsdGVkX1+ZTJ6hHBEhGGHQMyW5lobEmO/E2plsAg0l//AE+PjvHByC9nPjCa6ELA9XM6bfBfnwSt8+B3lZ3nfySGhClWLY2GSvp6OwmSmRp9Ub/ND+KFHcOPkx5RoAuZrwj0DucSPTFnY7McZ5kxtjPA94Hi8BkXC0NeT4cA9lAsuGt0DQmUM+3dLmZ6Uv6uIzmIlcQIzTNv6ZHUBuLHBdXw9I2RinzQQn9q19RpNaj1zJgp3EjY0dYM4WAuYP55yUy2jIlmVoLVobaXrKyAEAQU6QnW/jfm5B4Z/ZdtoK6H14aC1zMebQxKivRKu5IrQ0ukIZrLm/ctGLMfpcQbSWBRQ3Dm3x/UpT5pM41ogOM2chUsV5NN6fWcm0X+Z9I6+siIRkeBs9hgXDWUAhK/nBNpmyFA3W646ndD3mpMK/L+L5+36hIsNJcZS8sOla69Vgvgtjbba+STd+lGUKXaer6cV08qjHD6kv0xGmZBjwy9HcoWnNLFEta2vlUfJojIp8g1PXlSqyr7/yMHweEBjhU6kdPI77bgBfdk542tzOhlo5Pa360OQ+9sRblwkHDoKd9TPNWWyWbTYkJ5JQaQ9+TGc93bZ+hKt1MbR2mTqYgeZh097RuRIaAX93hDEdhGE7PTUBmgPl2ehlRrB57TGgS3FrVnLpr6Jv+q85SChfRdTJ6dM5SPidvjnHmrmRTyRlsinfEtYYgzohaU692M485LQP1pqc4r0BPNDsIBvktk8pG7qdNqkMEr9QDmwibPZcoUMLzh/+9z0/RCx3bbOue6e8DvjNoUbczCmn0uMHe6a2sUuOR2S0HgDwvJe6BHS/hA693lltJXWnnrKjO6UcVpZByMl6FdN2/lRbICQ5RRSy+8oGByxORee8Hh0duilwRtz5PJlGsdHUNRDefHUWp7udACDSNeiQv/mzkgbNrtdkw3M1oMGS7feiw275dwcjTgiZpGsgpJCCdYb
 hMiY5B+y
 ouIHQp8NmtaC+wgUL532DkV81rJSjpmdswYkQfmaWbuPa1rgw40ezm3QKFXhTAbgUPYOv34Qmm3g6wsOMOsjdQx3sATxWQ6ph7ZpL9BL0Xsbbu8BqqS5wsPUSasTBO7z/pv3Pv6OjiPJEiXqmOtKVGlENDloD4TbfY8GZ75U4otyRGqNTupvIXfsPSu05c83EQ7JaIp/uUIBc4X961ipvEFiZcT4ZVKU5ymo3WnaEUHEEWA45qrHI9tgDajCkCT0duUG/gbks+uetoEKVG5Xd1rq3vXIw0xA9b3cfBKtyofIjDP9apDL+7tjWc3CsTdN1of09
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/19/2026 6:40 AM, Wang Lian wrote:
> Hi SeongJae,
> 
> Thank you for the thorough and thoughtful review.  Your feedback on the
> x86 AF behavior was an important correction -- I'll address that and
> your other questions below.
> 
> On Thu, 18 Jun 2026 SeongJae Park <sj@kernel.org> wrote:
> 
>> This makes sense to me.  I also agree this could caused the reported
>> problem.  And this is a known limitation of DAMON.  My suggestion for
>> straightforward workaround of this problem is, using 'age' information
>> of DAMON for better identification of the hot memory.
> 
> Thank you for pointing out idle time percentiles [1].  We agree that 'age'
> helps differentiate frequently-accessed from occasionally-accessed regions,
> and it is a good workaround for many cases.
> 
> However, age operates at region granularity, which is still at or above
> PMD level for THP-mapped memory.  When only a few 4KB subpages within a
> 2MB THP are hot, age tells us the region has been accessed recently, but
> not which subpages are hot.  The split decision needs sub-PMD information,
> which is what the SPE heatmap provides.
> 
> That said, combining age with split could be valuable: split only regions
> that have been consistently hot (high age) AND have sparse sub-page access
> patterns.  We will explore this.
> 
>>> On ARM64, this is compounded by the hardware AF mechanism -- the AF
>>> is only set on a TLB miss.
>>
>> This makes sense to me.  However, I don't get how this is contributing
>> to the problem.  Could you please elaborate?
> 
> The AF-on-TLB-miss behavior creates a second-order problem that directly
> exacerbates the overestimation. 
> 
> When DAMON's mkold path clears the PMD AF, it deliberately skips the TLB 
> flush to minimize overhead. If the dense working set fits entirely within 
> the L2 TLB (e.g., 16MB workload using 8 PMD entries on Kunpeng 920's 2048-entry 
> L2 TLB), subsequent hardware accesses hit the valid, stale TLB entries 
> directly. The hardware MMU never generates a page table walk, so the 
> in-memory PMD AF stays 0. 
> 
> Consequently, DAMON sees `nr_accesses = 0` and assumes the region is completely 
> cold, making it impossible to naturally track the sub-page usage shifts. When 
> sporadic/noise accesses later hit other parts of this "seemingly cold" PMD 
> and trigger an isolated TLB refilling, DAMON abruptly sees the whole 2MB 
> as hot. This binary oscillation (completely blind vs. fully hot) is what 
> drives the massive overestimation under THP.
> 
> We confirmed this TLB-reach aspect empirically via our T1 test:
>   16MB THP (8 PMDs, 0.4% of L2 TLB reach) -> DAMON tracks 0 accesses (blind)
>   16GB THP (8192 PMDs, 400% of L2 TLB reach) -> DAMON tracks normally due to natural eviction
> 
>>> x86 is not subject to this specific blindness under similar
>>> conditions.
>>
>> To my understanding on x86, same issue exists.  If TLB hits, Aceessed
>> bit is not set, and DAMON shows it as unaccessed.  Am I missing
>> something?
> 
> You are entirely right, and I was wrong on this point. I re-checked the 
> kernel source and verified that x86's ptep_test_and_clear_young() does NOT 
> flush the TLB. Even ptep_clear_flush_young() on x86 deliberately skips the 
> flush as a performance optimization (arch/x86/mm/pgtable.c:486-502). The 
> same optimization architectural behavior exists on PowerPC and RISC-V.
> 
> Therefore, both architectures are theoretically vulnerable to this stale-TLB 
> blind spot under identical tightly-fit workloads. Our initial assumption 
> was biased because T1 was only conducted on ARM64. We will reproduce the 
> T1 setup on x86 to verify the exact behavior, and I will correct this 
> claim in the v2 cover letter. Thank you for catching this mistake.
> 
>> Nice!  Asier was planning to do similar work in future.  I think you
>> could collaborate to reduce unnecessary duplicates!
> 
> Great to hear! We would be happy to collaborate with Asier. I'll reach
> out to him to coordinate our efforts.
Sure, I will be happy to cooperate.
>> I'd suggest making the name simpler and consistent to DAMOS_COLLAPSE,
>> though.  Say, DAMOS_SPLIT ?
> 
> Agreed. DAMOS_SPLIT is cleaner and fits the existing naming convention 
> perfectly. Will rename in v2.
> 
>> So you implemented a debugfs interface?  That must be a nice approach
>> for PoC.  But it may be difficult to be upstreamed as is.
>>
>> You could build a control plane that decides the exact address ranges
>> to split, and directly feed it to DAMOS using DAMOS address filter.
> 
> The native perf event approach [3] aligns perfectly with our long-term 
> Phase 2c plan, and we are highly interested in collaborating on it to 
> eliminate the userspace daemon and debugfs bridge entirely.
> 
> However, since native kernel-side SPE handling is a long-term item, we 
> will follow your pragmatic alternative suggestion for v2: use DAMOS address 
> filters or user_input quota goals [2] to feed the split decisions from 
> userspace cleanly. This allows us to upstream the core infrastructure 
> (mTHP target_order for collapse and the new DAMOS_SPLIT action) first.
> 
>> Do you really need to khugepaged together, when you already have
>> DAMOS_COLLAPSE, and anyway you are running DAMON for hugepage splits?
> 
> Excellent point. Running both concurrently on the same VMA introduces 
> redundancy and heavy ping-pong effects. 
> 
> Option (b) is definitely cleaner: we will let DAMON handle both split and 
> re-collapse decisions using its own access data. To make this robust in 
> production environments where khugepaged is globally enabled, we will 
> explore having the DAMOS_SPLIT path temporarily mark the target ranges 
> (e.g., via a pseudo-VM_NOHUGEPAGE backing off mechanism) to prevent 
> khugepaged from immediately undoing DAMON's work.
> 
>>> - The rbtree entry TTL (30s) and signal threshold (1/10 of peak) are
>>>   empirical defaults subject to further tuning.
>>
>> I don't fully understand this part.  Could you please elaborate?
> 
> Since ARM SPE samples hardware accesses instruction-by-instruction, the raw 
> data is highly statistical and noisy. 
> 
> The TTL (30s) defines the lifecycle of our per-folio rbtree tracking entries. 
> Entries not updated within 30 seconds are pruned to prevent stale tracking data 
> from corrupting split decisions after a workload phase change. 30s is selected 
> to comfortably outlive DAMON's aggregation intervals while keeping the rbtree 
> memory footprint tightly bounded.
> 
> The signal threshold (1/10 of peak) filters out the statistical sampling noise. 
> Instead of treating any subpage with access > 0 as hot, the algorithm finds the 
> peak access count inside the 2MB region and only marks sub-chunks with >= 1/10 
> of that peak as genuinely hot. On Kunpeng 920, this specific threshold successfully 
> reduced false-hot subpage classifications from ~50% to <5%. We plan to make 
> these parameters sysfs-configurable.
> 
>>> - The ARM64 DAMON blind spot (WSS < L2 TLB reach) is a pre-existing
>>>   hardware-MMU characteristic, not introduced by this series.  Setting
>>>   nr_accesses/min=0 serves as an effective workaround for the split path.
>>
>> I don't fully understand this, too.  Could you please elaborate and
>> enlighten me?
> 
> The blind spot creates an operational deadlock for the split infrastructure:
>   1. WSS < TLB reach -> All THP entries stay cached in TLB.
>   2. DAMON's page-table scan yields `nr_accesses = 0` globally.
>   3. A scheme requiring `nr_accesses.min = 1` never fires -> DAMOS_SPLIT is never invoked.
>   4. THPs remain unsplit -> WSS remains within TLB reach -> Loop returns to step 1.
> 
> Setting `nr_accesses.min = 0` and `max = 0` breaks this deadlock. It forces 
> DAMON to evaluate these seemingly "dead/cold" regions. Once the split handler 
> invokes, it checks the ARM SPE telemetry (which captures data directly from the 
> instruction pipeline, completely bypassing the MMU page-table AF limitation). 
> If SPE reveals a sparse access heatmap, the split is executed. Once shattered into 
> mTHP/base pages, the TLB reach drops, natural TLB misses resume, and DAMON's 
> standard page-table tracking fully recovers.
> 
> 
> Thanks again for your guidance. The action items for v2 are locked in:
>   1. Rename DAMOS_MTHP_SPLIT -> DAMOS_SPLIT.
>   2. Drop debugfs in favor of DAMOS address filters / control plane.
>   3. Correct x86 AF behavior statements in the cover letter.
>   4. Coordinate with Asier on split/collapse unification.
>   5. Implement back-off to prevent khugepaged ping-pong under Option (b).
> 
> Best regards,
> Wang Lian

-- 
Asier Gutierrez
Huawei


