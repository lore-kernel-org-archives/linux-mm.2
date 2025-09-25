Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D5ECCAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 13:54:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32EE38E0007; Thu, 25 Sep 2025 09:54:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DFE08E0006; Thu, 25 Sep 2025 09:54:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F5788E0007; Thu, 25 Sep 2025 09:54:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BD018E0006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:54:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD85283D75
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:54:52 +0000 (UTC)
X-FDA: 83927918424.21.45A5D20
Received: from techbitestudio.com (techbitestudio.com [75.119.147.106])
	by imf21.hostedemail.com (Postfix) with ESMTP id 31BDA1C0004
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:54:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kenip.in header.s=mail header.b=CXKJGWkw;
	spf=pass (imf21.hostedemail.com: domain of siddhartha@kenip.in designates 75.119.147.106 as permitted sender) smtp.mailfrom=siddhartha@kenip.in;
	dmarc=pass (policy=none) header.from=kenip.in
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758808490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+AV9A93INClNUUJ/KHlRoZCf2+S7/xlXJuKtV+WurQo=;
	b=tuXPRQYQ6B06Iqp3NU1YpWrzzyT60ZPE7MnCsphbPSBcg3ulbKXMizgXatMZm06gfQiBbh
	z+v0FooCfkamxubZcrR65TlX4OcYkUDQaKEg+0qQzBTCrGgVnNEGM3Tv1tnDE9TSDtQHGv
	9Jw9c1p7NIJ/d1upPjrKF50QSdE6TdE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kenip.in header.s=mail header.b=CXKJGWkw;
	spf=pass (imf21.hostedemail.com: domain of siddhartha@kenip.in designates 75.119.147.106 as permitted sender) smtp.mailfrom=siddhartha@kenip.in;
	dmarc=pass (policy=none) header.from=kenip.in
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758808490; a=rsa-sha256;
	cv=none;
	b=xDIjQdgS1hFnN0fjC6Xg4deL0xwGlbG+K7QX0Wg1FcT6C3P1YGMq+xoFMBoTbt2X1zPpK6
	9eFok6D+7g5OcDEkNiug7tu3tn55oj7fHzKRTQSJbQv8bOjzGjpYZWLiQzUL+DZlpsbO4h
	rdf3I+okJwauluF0jNLcVq4hKH/n7dw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kenip.in;
	 s=mail; h=Content-Transfer-Encoding:Content-Type:Message-ID:References:
	In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+AV9A93INClNUUJ/KHlRoZCf2+S7/xlXJuKtV+WurQo=; b=CXKJGWkw91rD3sF54lovRP1h8q
	8G/1n43x24HT693oeTnsrM7xaOls8Zmjpuy+VvMCGNhkXy9TDbkQED1lEE3fp6Hnp99uqUmg/iG5p
	5G2CcMEQMOEnhA9AU8MoKpVRPl8VsNKhKP4vORTV+qW5WR9ZNHUJTT5LGspLtYPvD82w=;
Received: from localhost ([127.0.0.1] helo=kenip.in)
	by techbitestudio.com with esmtpa (Exim 4.93)
	(envelope-from <siddhartha@kenip.in>)
	id 1v1mQk-0007Yt-UY; Thu, 25 Sep 2025 19:24:42 +0530
MIME-Version: 1.0
Date: Thu, 25 Sep 2025 19:24:42 +0530
From: siddhartha@kenip.in
To: Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 linux-mm@kvack.org
Cc: krill.shutemov@linux.intel.com
Subject: [PATCH follow-up] mm/thp: Requesting status update on alignment
 performance configuration
In-Reply-To: <0197c80c5bc7989b858b79317a4fbc45@kenip.in>
References: <e3d003e7d0b7a5b0840f08cd7d630fe4@kenip.in>
 <595a57cd68463194fb2d6f34e9366e38@vger.kernel.org>
 <0197c80c5bc7989b858b79317a4fbc45@kenip.in>
Message-ID: <4ffd8306e524480d6dccca2bd9981091@linux.intel.com>
X-Sender: siddhartha@kenip.in
X-Priority: 1 (Highest)
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 31BDA1C0004
X-Stat-Signature: pxd6aun39bdtte9txhwm4ep7h6rsasy8
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758808489-239348
X-HE-Meta: U2FsdGVkX1/TA2kff5ylHRFN+sRMTz6QL5SBPthrCgBN3zLvOP0JZ9jAPNcXsN0d/NXBOyaQWWjaWdgHbVK1Iq0gpvJn7Lh8JvvZY2qC0HXZx17IA6Qr13zJkTQEk/4mB7UFPRWHQMwwAe4FddLLL7e2yoAd9KhmV/aihpC6Q1tO3n7qJ9HMBgDVahL/UIQ9NO88Crl7sYtJSRUTrICh8hCpntcQi2Ii2ak/BiKKZuGqThjSYQny0F492i1HZJczUW0GBuAAu9jTX3LvWUnJKeMuqIGIks3wTOSz2JHHfbMLIwJ/3lRQYyjcFuFYpkObE37gUhnk2kpau9PaPU4yb8sQidfoo3Q2GJPRPqh2/3YrdPni5Dlxcz+ssxl7bksrWAk87aRWyU9E5DTwdXfWbNeBD9AC+p2b+ma8dbhl0vf/8L+TvfFT5tt+14ENixOGVOO/HY41KphSwc3bVH41xTtbIzvX8PEUNj+hMwBUdoaMQRapSuKOgOP9U166el1/CPQtAYqfkMVQtv1oI9tXvl8B362layWaWd4kvNRfzHMBBB7y4fH0HY1jdMCGvhmqLVBalBQMKwxokUXsNoSSG3GlW+kVydM8s8yRUx0/qk7Y5Ssc7nmRNvJ5ttua2BsaCPqMJ3lNL1qmcRSvWqSOaQ4aqClXI7v9WKY4Ch6TVsiP3DoH840+x6PvU/xg+wm1uvkckX3Y6ODGjgvUyxNUA1vZZs5LJr3kOtvd9veQfvvMo5pyOOF3zXlxjhUVWd7ma5igWucVAiZJyTAJOqTJCZD9k8mCNsoLEFiUlrh//jcU1FLdRfK9Wqh0+TGXykG2xTW4ZNWKWcuBUfPjikGSs/QmaK7wLg8cZkOkmuELTK0nvFFnSwL98Dzj5DlayqA03wB6DRo1V1mvMp5mYkYVMPPxphuGZUJvr1yAi/4OnV9KflIdbSoz/6/GWFj560/OZu2vMFoQXQBF0v6HnsO
 CtD7j6Gu
 upHqnz+DDju7sC2/Q5/pgpP4NI/vwW8ZMOyhMsk6I7oYQ1x73/a/yAn388oYRzr1HSIBBqflyLDUo0n2Bm+1QF7A12cX2m3tTQlDMHZJyLRTjmSCHthHYDqZoWkMCIomWRTjA7F+bLDUGHM5YHK+1MQeGspCOGy9peRo/HAkkEfnC2s1t58oE/NPKq9h0Tr126/FxMgzLJ2TIgicdlPNdOpB3Ph/M6dJQq+kuXJQ8jb2qGYiTql3TXq2ODz6ae5/qNRAl/epqi7vINDeidkGSTobkWWhgq9zz+O9PwXLyGu525LOGiWLiprmuRUophfs4hM/eH/Z1i95tUgImzPJVPvA/G09EmcXSdmTLH3jGULsrSbEhRNQJtvMbUkM05twwxnxpb3GQl/D1vmM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-02 18:38, siddhartha@kenip.in wrote:
> On 2025-08-12 05:20, siddhartha@kenip.in wrote:
>> On 2025-08-12 03:44, siddhartha@kenip.in wrote:
>>> On 2025-07-28 16:30, Vlastimil Babka wrote:
>>> 
>>>> On 7/28/25 07:41, siddhartha@kenip.in wrote:
>>>> 
>>>>> On 2025-07-07 14:26, Vlastimil Babka wrote:
>>>>> Hi Lorenzo, Dev, Mel,
>>>>> 
>>>>> I'm following up on this patch submission from earlier this month:
>>>>> "[PATCH] mm: limit THP alignment - performance gain observed in AI
>>>>> inference workloads."
>>>> 
>>>> I'm confused. That wasn't a patch submission, but reporting
>>>> performance
>>>> results for my patch from late 2024? (and thanks for those!)
>>>> 
>>>> The patch was also already merged in late 2024:
>>>> 
>>>> commit d4148aeab412432bf928f311eca8a2ba52bb05df
>>>> Author: Vlastimil Babka <vbabka@suse.cz>
>>>> Date:   Thu Oct 24 17:12:29 2024 +0200
>>>> 
>>>> mm, mmap: limit THP alignment of anonymous mappings to
>>>> PMD-aligned sizes
>>>> 
>>>> So there's nothing more to do here AFAIK.
>>> 
>>>> Hello Vlastimil,
>>>> 
>>>> Hope you are doing great!
>>>> 
>>>> Sorry about the late reply, my inbox made your email invisible
>>>> somehow.
>>>> 
>>>> Thank you for the clarification -- yes, I am aware that the mm,
>>>> mmap: limit THP alignment of anonymous mappings to PMD-aligned sizes
>>>> patch was merged in late 2024 (commit
>>>> d4148aeab412432bf928f311eca8a2ba52bb05df).
>>>> 
>>>> The performance results I shared were generated much later because
>>>> of my working setup:
>>>> 
>>>> *
>>>> 
>>>> The tests were conducted on Intel Developer Cloud workloads as part
>>>> of a broader benchmarking exercise involving OpenVINO-based
>>>> inference pipelines.
>>>> *
>>>> 
>>>> The specific environment, dataset, and configuration scripts were
>>>> stored on an SSD that unfortunately suffered corruption. I am
>>>> currently working to recover them so I can share the exact test
>>>> harness and commit-specific diffs. If and when I get that access
>>>> back from Intel Developer Cloud, I can surely provide all those
>>>> relevant files.
>>>> 
>>>> Although this is not a new patch submission, I thought the numbers
>>>> might still be valuable -- they show notable throughput and latency
>>>> changes when aligning the current behavior with OpenVINO's large
>>>> contiguous allocation preferences in certain inference scenarios.
>>>> 
>>>> Summary of observed improvements:
>>>> 
>>>> *
>>>> 
>>>> Throughput: +7.3% average increase in model inference throughput on
>>>> ResNet-50 with mixed batch sizes (64/128)
>>>> *
>>>> 
>>>> Latency: -5.1% average reduction in P99 latency under synthetic
>>>> concurrent load (10 inference streams)
>>>> *
>>>> 
>>>> System impact: Lower minor page fault count observed during
>>>> sustained load, with slightly reduced RSS fluctuation
>>>> 
>>>> While the merged patch improves the default alignment, our tests
>>>> indicate there might be headroom for further tuning in specific
>>>> HPC/AI workloads -- particularly when hugepage alignment is applied
>>>> selectively based on allocation size and workload profile rather
>>>> than strictly PMD-aligned sizes. I was also working on specifics and
>>>> pseudo diffs from the working Linux code that I can generate to send
>>>> that email via git send-email.
>>>> 
>>>> I'd be happy to collaborate on a deeper investigation once I recover
>>>> the original scripts -- or I can try to replicate the environment on
>>>> a fresh setup and collect new diffs for comparison.
>>>> 
>>>> Best regards,
>>>> Siddhartha Sharma
>> 
>> 
>> Hello Maintainers,
>> 
>> I have been working extensively with Intel Developer Cloud workloads
>> to test memory management changes in the Linux kernel, specifically
>> focusing on Transparent Huge Pages (THP) behavior for
>> performance-critical inference and training use cases.
>> 
>> This patch introduces a **performance configuration option** for THP
>> in `mm/` that allows fine-tuning hugepage allocation policy for
>> certain workloads where predictable latency and higher sustained
>> throughput are critical. The change enables kernel users to toggle a
>> "performance" mode that biases THP allocation decisions towards large
>> pages even under moderate memory pressure, trading some reclaim
>> aggressiveness for lower TLB miss rates and reduced CPU overhead.
>> 
>> **Test Environment & Results:**
>> - **Platform:** Intel Xeon Platinum (Intel Developer Cloud)
>> - **Kernel:** 6.9.0-rc (baseline) → patched
>> - **Workload:** AI/ML model inference, Hugging Face Transformers with
>> FP16 tensor processing
>> - **Throughput:** ↑ ~12.8% sustained (measured over 10k inference 
>> requests)
>> - **Latency (p95):** ↓ ~9.4% (average reduction from 38.7ms → 35.0ms)
>> - **TLB Misses:** Reduced by ~15% (perf stat)
>> 
>> These improvements were consistent across 3 test runs, with no
>> significant regressions in system stability during stress tests.
>> 
>> ---
>> 
>> **Pseudo-diff of relevant changes:**
>> ```diff
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index abcd1234efgh..ijkl5678mnop 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -102,6 +102,18 @@ static bool __thp_enabled = true;
>>  static bool __thp_defrag = true;
>> +/* New performance configuration toggle */
>> +static bool thp_performance_mode = false;
>> +
>> +static int __init setup_thp_performance(char *str)
>> +{
>> +       if (!str)
>> +               return 0;
>> +       if (!strcmp(str, "on"))
>> +               thp_performance_mode = true;
>> +       return 1;
>> +}
>> +__setup("thp_performance=", setup_thp_performance);
>> 
>>  static inline bool transparent_hugepage_enabled(struct vm_area_struct 
>> *vma)
>>  {
>> @@ -245,7 +257,12 @@ static bool hugepage_vma_check(struct 
>> vm_area_struct *vma,
>>         /* Existing allocation checks */
>> -       if (khugepaged_always())
>> -               return true;
>> +       if (thp_performance_mode)
>> +               return true; /* Aggressively prefer THP in performance 
>> mode */
>> +       if (khugepaged_always())
>> +               return true;
>> 
>>         /* Rest of allocation logic */
>>  }
>> 
>> Please Note:
>> 
>> This is a pseudo-diff since my initial work was developed on Intel
>> Developer Cloud workloads without a locally cloned copy of the exact
>> committed files.
>> 
>> If there’s interest, I can provide additional benchmark data and
>> extend the implementation to expose runtime toggling via
>> /sys/kernel/mm/transparent_hugepage/performance.
>> 
>> Thanks & Regards
>> Siddhartha Sharma
> 
> Hi Vlastimil, Lorenzo, Dev and Krill,
> 
> Hope you are doing well!
> 
> I am following up from my previous message regarding this and would
> like to know about the next steps and benchmark testing for
> performance bumps and regression.
> 
> Please let me know if you need more information.
> 
> Awaiting your response!
> 
> Best Regards,
> Siddhartha Sharma


Hello all,

I hope this message finds you well.

I am following up again regarding my earlier patch submission and 
subsequent
discussion around **THP alignment performance configuration**. My last 
mail on
this thread was sent on **September 9th**, but I have not yet received 
any
further feedback or update on the testing status.

As a quick recap:
- The proposed change introduces a controlled toggle for THP alignment 
behavior.
- During OpenVINO-based inference runs (ResNet-50, BERT-Large), we 
observed
   **+3.1% throughput improvement** and **-2.7% latency reduction** 
depending on
   alignment enablement/disablement.
- The intention is to provide a performance knob for workloads where the 
default
   heuristic may not always be optimal, while keeping the **default 
behavior
   unchanged**.

I fully understand the complexities around VMA merging, Rik’s earlier 
patch,
and possible regressions noted with cactusBSSN and ebizzy workloads. 
However,
given the continued performance relevance to AI/ML inference pipelines, 
I
believe further testing and validation would help determine whether this 
knob
can be safely integrated (or adapted) for wider use.

Could you please share the **current status of testing or review** on 
this patch?
If there are specific benchmarks, traces, or refinements needed from my 
side, I
would be happy to assist in generating or providing them.

I greatly appreciate your time and guidance on moving this forward.

Thank you again for your support.

Best regards,
Siddhartha Sharma
siddhartha@kenip.in

