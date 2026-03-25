Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E226109C059
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 18:48:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B10386B0005; Wed, 25 Mar 2026 14:48:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9A326B0089; Wed, 25 Mar 2026 14:48:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A496B008A; Wed, 25 Mar 2026 14:48:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BDA06B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:48:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 107B7BBF61
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:48:21 +0000 (UTC)
X-FDA: 84585470802.30.DFE1C83
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9E17BC000C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:48:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PrkyhMXA;
	spf=pass (imf28.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774464498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K669+jAXFfOnMiVShjbjDrGlaYoW4qKt7UsN03oR2Tk=;
	b=3msVe8S2OUY8UfhOOLT0CShIkGKwC+mQF6QJtKxsR5r3IAt2ocEy9Ed5xOLxh3FQjIwSLU
	swdl4CNvFBuabL+kMtNfaHkkx/CgQHPpQuRLGioY7EXT89VzyMJRSM8vc+CwEdaUtlKUcw
	zSqioqWS7wBl3f7URgh+DvCoIhGAdtQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PrkyhMXA;
	spf=pass (imf28.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774464498; a=rsa-sha256;
	cv=none;
	b=4ic9Vai0UkC1Wl4NNW6ptBMPXrQGuKebndFVG4gmTifNuVeizkuE5lVSodYef88GW/Hd75
	dzN+8gK+Dvncow2WKxVWPNIUgX4CDZdQqGPKYS9zgOAF2nltEcWhRnXN+qtNaThIEyz32E
	pY0F+0mYIXBn3kMTSzY76Yy5Ddmi3+A=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62PD2rww646583;
	Wed, 25 Mar 2026 18:48:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=K669+j
	AXFfOnMiVShjbjDrGlaYoW4qKt7UsN03oR2Tk=; b=PrkyhMXAeiYAgswbUog5R9
	7gVy5oLBN9izZWsF5eCVqlrB21CX7VySH3fqgzG75/3IqjJf70mRpCU8DftvSFfo
	ZnccaGHuimmY48jDqy0UwpMhlwZ321JEIdPr8cZQ5G3X2BwsOAAbqPV4kyiFzg+2
	2RE0THdArOR+iFvTFYTigP0y0eVSN+TOaDGh1K2R7DU3L++Fie0fsK6CDwIQrSbG
	aEwjb6DjXL1yPYbOMrhaWTMXWwbkTRvJiwOxIWPJN1a4I5MrjsviHsRB55iza5tS
	/HJjn0F+dx3VnZ/wTRmL8nygVvmTfgnQYpde6HrlwqzfHgULAJgw0eTcf3uO8ibQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1kums5gj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 18:48:07 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62PFjiKi026685;
	Wed, 25 Mar 2026 18:48:07 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d275kyrfp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 18:48:06 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62PIm6GS63963452
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Mar 2026 18:48:06 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8A7605803F;
	Wed, 25 Mar 2026 18:48:06 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 475B858055;
	Wed, 25 Mar 2026 18:47:58 +0000 (GMT)
Received: from [9.39.25.125] (unknown [9.39.25.125])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 25 Mar 2026 18:47:57 +0000 (GMT)
Message-ID: <14403d89-c77c-4011-bfad-681c7b10187a@linux.ibm.com>
Date: Thu, 26 Mar 2026 00:17:56 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Reimagining Memory Cgroup (memcg_ext)
To: Shakeel Butt <shakeel.butt@linux.dev>, lsf-pc@lists.linux-foundation.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hui Zhu <hui.zhu@linux.dev>,
        JP Kobryn <inwardvessel@gmail.com>,
        Muchun Song <muchun.song@linux.dev>, Geliang Tang <geliang@kernel.org>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Emil Tsalapatis <emil@etsalapatis.com>,
        David Rientjes
 <rientjes@google.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260307182424.2889780-1-shakeel.butt@linux.dev>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260307182424.2889780-1-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 6FmiCLs32PS63n5oqMNtpfe4PvUiBYsr
X-Proofpoint-ORIG-GUID: pJfccnXiV3nwWrj2BDc5BsTHSbA8hxMy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDEzNyBTYWx0ZWRfX3sjkXq14IWb2
 gZ1IZK+3cm8rUowKHKnRHKbcxXFjihOSmWnVAeP9o8VlzL6+LAEqNWg/u3msB+iRQcI1a08+MKL
 Xvo7QsyUvpHdu52TgoFjFsNWFrR8UYcfXNbw1jGo/p1Q9XPaRipJGUyLFUtwVJH8A90S0SedNnR
 0oE7Oe/g5ScWc/A2Zz0QKkecXDRZNOnbsHhvxz7cXDbJbndeQeIhsgNyh9b89xAICSfjAsiecDw
 kqTh6IPiLoGi41RKUxRMk3DY2FRamP0VAyfCukGoDWgs35qaIPT0c14yRKKOHrG+tUKKuMfQDg4
 KqEv8Tluzl2+yAVsQcPhgnpHGt35si3MKbz/t8Ey22v4NN52ZoxS21pPxcWpswcF8og4z8RHLF6
 BItOVy9zb/cS4S+ME/laXIYiIL6/kgFCtf9op5TwA0Ry1mQTSwMvxPMd4NwPJrcXU8QCpE+p+UG
 hNz44EpVAKG0woaNThQ==
X-Authority-Analysis: v=2.4 cv=KbXfcAYD c=1 sm=1 tr=0 ts=69c42de8 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=EWPDJS0nAAAA:8
 a=qRGbQyZx1wJ4HwBk7TQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-25_05,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 malwarescore=0 adultscore=0 clxscore=1011
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603250137
X-Rspamd-Queue-Id: 9E17BC000C
X-Stat-Signature: 38eupxtsbnsg6w8coe4rmzqchsd1ytef
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774464498-853076
X-HE-Meta: U2FsdGVkX1/T3NhTsxT+++tV9WK97pMTUSjZjl3ixYB04tHz0XbH0o8gs+orkJT7HBA2btIEzxBoR4YerlCVpr/h90OG51QThjunoZYaibHyOsMb1Z5W8marrsXERZnUxVcAhdYaKMsmVEs7zG51A9eF/cGb/VQphxtNNr6thxzsJiZ0OghZFGA+L2MqO19Xt7xdc2wF8LqeQXzPeeRnUrGeOdTEWzJSJoe8yDmQI20T2Z/ZF0E9koN+g659iyRAAI+5e4tOhW1AnVKdYX7s45pD/c2K8uS1ocQlVUmrDl7TOFOZxXLW/I6rf8VWdQMDMa84CCy+qrIYNtWM7hxE5WsfIhMtFrXlqgqXAcbBHtj3R4O0PhoIDQ3N6zrPJAUM5EOR4lw3Iv5zNXnes9EczOH7Zv8FWZwR9mwwi2hfPYsDj5tHxWu5PnE9BCgcMi52iWEcnRJWkQ2vWG19Xl1q6vfqeuPSBiA/ctE6YpLIiLOY72dFjnCoOitI34Jh+W504dfpHTQbNacvqUglrZ4QnnkzpxDYDh97IH5rq7jKXUAmwl4guK0J7zXUZcMwxp6OPY9tKdxplDyfqjTqG7HZqCTHJpyysct7KurCpm5OfBlrEpAo1EjLAlCkTBBv0vTllyySrBAhVn+6NU0JsmEYo8Pu18AGpubpZ6hGETBSiDSv2ooZcsITGdmcDd7w4oHU0pEznc7w2c7ewfj5tZaXg2EHZp0cXSdgF0pWZPSBTKxxknBHvDUuijz9I+vXONPO+mt19Bb1Y5nPseeTaJQmzaDacpdYlmgAniKZG52uf5DrwCOiCA0HEOtLrk4S6cGA4Jhd8a18zxOBtjJmVGhzmdJdONm6EELzpKjPD+eIrkJUaNb6/FB7XGz225lu+tEauJ81D4kqMrMJLP/mxft59G0MIGqtKaEBLpmL0ZMQs5SwlaWVaVwAa2qERgLr+4uMLcjfGfoNDsAHjwWf9UL
 yLlzinKv
 k1nIZ7KTP2y4l63+Omaio2qu/Q9ZyM+P2vPIOp3iv0jNtAphC7ahYbtkbZqTJL0Hs7pXzCCQEFZQ6m2F6mL5uzoeByJY4anw9Dtc+Uh1eMKIafEeHpJ5AJ3hph0QyCGGUQq/adDJNXbptcrOahxEoVEecvGPALlyqoN+rcfRY0SkNChIK2yCH/CokriLGhcE8c6oEhl1H4T5qgB+gPZPmudVKnHc+suXlDrm3VUFTiYuYyoWsd3/XwP3nHG/IrPJeAR7mTFDTYSrtDa7A0vXCTuWvR43t+NkBGX35OUm+yRFYuAiS6yirxK0RPyQ3P/zxbuNL/ao4PugArr8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/7/26 11:54 PM, Shakeel Butt wrote:
> Over the last couple of weeks, I have been brainstorming on how I would go
> about redesigning memcg, taking inspiration from sched_ext and bpfoom, with a
> focus on existing challenges and issues. This proposal outlines the high-level
> direction. Followup emails and patch series will cover and brainstorm the
> mechanisms (of course BPF) to achieve these goals.
>
> Memory cgroups provide memory accounting and the ability to control memory usage
> of workloads through two categories of limits. Throttling limits (memory.max and
> memory.high) cap memory consumption. Protection limits (memory.min and
> memory.low) shield a workload's memory from reclaim under external memory
> pressure.
>
> Challenges
> ----------
>
> - Workload owners rarely know their actual memory requirements, leading to
>    overprovisioned limits, lower utilization, and higher infrastructure costs.
>
> - Throttling limit enforcement is synchronous in the allocating task's context,
>    which can stall latency-sensitive threads.
>
> - The stalled thread may hold shared locks, causing priority inversion -- all
>    waiters are blocked regardless of their priority.
>
> - Enforcement is indiscriminate -- there is no way to distinguish a
>    performance-critical or latency-critical allocator from a latency-tolerant
>    one.
>
> - Protection limits assume static working sets size, forcing owners to either
>    overprovision or build complex userspace infrastructure to dynamically adjust
>    them.
>
> Feature Wishlist
> ----------------
>
> Here is the list of features and capabilities I want to enable in the
> redesigned memcg limit enforcement world.
>
> Per-Memcg Background Reclaim
>
> In the new memcg world, with the goal of (mostly) eliminating direct synchronous
> reclaim for limit enforcement, provide per-memcg background reclaimers which can
> scale across CPUs with the allocation rate.
>
> Lock-Aware Throttling
>
> The ability to avoid throttling an allocating task that is holding locks, to
> prevent priority inversion. In Meta's fleet, we have observed lock holders stuck
> in memcg reclaim, blocking all waiters regardless of their priority or
> criticality.
>
> Thread-Level Throttling Control
>
> Workloads should be able to indicate at the thread level which threads can be
> synchronously throttled and which cannot. For example, while experimenting with
> sched_ext, we drastically improved the performance of AI training workloads by
> prioritizing threads interacting with the GPU. Similarly, applications can
> identify the threads or thread pools on their performance-critical paths and
> the memcg enforcement mechanism should not throttle them.
>
> Combined Memory and Swap Limits
>
> Some users (Google actually) need the ability to enforce limits based on
> combined memory and swap usage, similar to cgroup v1's memsw limit, providing a
> ceiling on total memory commitment rather than treating memory and swap
> independently.
>
> Dynamic Protection Limits
>
> Rather than static protection limits, the kernel should support defining
> protection based on the actual working set of the workload, leveraging signals
> such as working set estimation, PSI, refault rates, or a combination thereof to
> automatically adapt to the workload's current memory needs.
>
> Shared Memory Semantics
>
> With more flexibility in limit enforcement, the kernel should be able to
> account for memory shared between workloads (cgroups) during enforcement.
> Today, enforcement only looks at each workload's memory usage independently.
> Sensible shared memory semantics would allow the enforcer to consider
> cross-cgroup sharing when making reclaim and throttling decisions.
>
> Memory Tiering
>
> With a flexible limit enforcement mechanism, the kernel can balance memory
> usage of different workloads across memory tiers based on their performance
> requirements. Tier accounting and hotness tracking are orthogonal, but the
> decisions of when and how to balance memory between tiers should be handled by
> the enforcer.


Hi Shakeel


This looks like a good idea. I was thinking along similar lines,
but wasn’t sure about the best way to implement it.

For memcg with memory tiering, the idea is that we set
memory.high and memory.max as the maximum limits. Within
memory.high, a certain percentage (x%) could be backed by
higher-tier memory, with the remaining portion coming from
lower-tier memory.

In this model, an application would get up to
memory.high * x / 100 from higher-tier memory, and the rest
from lower-tier memory.

Once the higher-tier usage reaches its limit, we would start
demoting pages. If the lower-tier usage also reaches its
limit, we would then start swapping out pages from lower tier.

What is your opinion on how memory tiering should be handled in memcg?


-Donet

>
> Collaborative Load Shedding
>
> Many workloads communicate with an external entity for load balancing and rely
> on their own usage metrics like RSS or memory pressure to signal whether they
> can accept more or less work. This is guesswork. Instead of the
> workload guessing, the limit enforcer -- which is actually managing the
> workload's memory usage -- should be able to communicate available headroom or
> request the workload to shed load or reduce memory usage. This collaborative
> load shedding mechanism would allow workloads to make informed decisions rather
> than reacting to coarse signals.
>
> Cross-Subsystem Collaboration
>
> Finally, the limit enforcement mechanism should collaborate with the CPU
> scheduler and other subsystems that can release memory. For example, dirty
> memory is not reclaimable and the memory subsystem wakes up flushers to trigger
> writeback. However, flushers need CPU to run -- asking the CPU scheduler to
> prioritize them ensures the kernel does not lack reclaimable memory under
> stressful conditions. Similarly, some subsystems free memory through workqueues
> or RCU callbacks. While this may seem orthogonal to limit enforcement, we can
> definitely take advantage by having visibility into these situations.
>
> Putting It All Together
> -----------------------
>
> To illustrate the end goal, here is an example of the scenario I want to
> enable. Suppose there is an AI agent controlling the resources of a host. I
> should be able to provide the following policy and everything should work out
> of the box:
>
> Policy: "keep system-level memory utilization below 95 percent;
> avoid priority inversions by not throttling allocators holding locks; trim each
> workload's usage to its working set without regressing its relevant performance
> metrics; collaborate with workloads on load shedding and memory trimming
> decisions; and under extreme memory pressure, collaborate with the OOM killer
> and the central job scheduler to kill and clean up a workload."
>
> Initially I added this example for fun, but from [1] it seems like there is a
> real need to enable such capabilities.
>
> [1] https://arxiv.org/abs/2602.09345
>

