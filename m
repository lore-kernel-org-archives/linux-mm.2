Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE683F433C5
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 21:11:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 166D56B0005; Wed, 15 Apr 2026 17:11:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13F266B0089; Wed, 15 Apr 2026 17:11:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0541B6B008A; Wed, 15 Apr 2026 17:11:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBD296B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 17:11:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 858E913B433
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 21:11:09 +0000 (UTC)
X-FDA: 84662035458.19.FDCF65A
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6CD31180005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 21:11:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="j/fcrj0e";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776287467; a=rsa-sha256;
	cv=none;
	b=w7+/Wxjs37/EKd6uGDyKHIJ1mHKrHjCURjhFpE115ydZNgMNDpF6Q/B75G4wf8Kt/NA9WK
	/LTnvS1m1jeTOtIG5Phx1ZbWtXbhIlrJrdUFihpi10lvN/wsveIABBedtxjm0TYOx+4W19
	38Z4AoWfWlOMmJtqA/z6wYrAHvsfNgA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="j/fcrj0e";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776287467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TULGaxumukw4hqiyMiXrmR8JwZrOcKaREIVruS3C59o=;
	b=rZ+YlZMUkxobjbC4Nsfktx6DaO7LnPdbSJ6rt2X1lT2BOID4nuIpCXSJNxBmXvtSukgho3
	DA8qqec9PDi/uXG4QNjaoMLcvmafq7QXYCL+jRtW/9MR6xfOomzKuUElLImqhi6Fy5nuG9
	Lzrybop5uAcZkGCqhJYwrXjISXmj3/Y=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-488c2690057so73644285e9.0
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 14:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776287466; x=1776892266; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TULGaxumukw4hqiyMiXrmR8JwZrOcKaREIVruS3C59o=;
        b=j/fcrj0ek+LCH4Tq1CWSTeBmROWKF9FoGO1bsl5i2fGdUcuJJb0RI6aNRe3ehJxBRw
         U/L33HxIn3lg2ljsnt5BhRo47HxlH2Gnr9ry2W6zFWuLomj9DuIqfgEoSq/2ENTkEGK1
         d4fQ8b3q5Rk+FmBdxS5CFahqC/EvXr0ia/U9psfuI9TcIJqwRbRDCbb0KXuVac+5cjFM
         5GKzyfHQOxxDqiiiuWCwpt4MDn6xEsIjBbgA6Ba8+777bWz+YPbaSIwRN0Hz5gKMfAy7
         w6bg8GuooUVYvMYjIh0e1At8+41tHkzu8zq3+sq0uoqwqzr2DZtL1ld3W/9zhI3/hOq0
         JpOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776287466; x=1776892266;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TULGaxumukw4hqiyMiXrmR8JwZrOcKaREIVruS3C59o=;
        b=FMrNt07AIrZF3jG+Ez+WBshg1N19hb4RM0MEV3VQVLAWGfxuuNGcOUFqN6gOBvDZO1
         OMS90g+uUbsJZvUsy2AWZXGErvDch3Gihxn6SUEVkWiwljUj06KyAIwKNOyKzpTUKMGl
         IvI7rpRetgrEWkw20OswTM7BU7IvLm71H/hcFjc3j+nb3JOP/FNYd256wjkjQA93q4YT
         LXQCRbthmUyEGIp6zIUvcACsc72rANayM0lJ3xvzY0BgyRJappGeR2Faze3z9BfpBozw
         +eF+ObJeuj68PYipLA7O9lAUBfvmIpm3Mb0hKAn/MQ4A3drALVajdNBK+20fxaXjl6Lo
         2jNA==
X-Forwarded-Encrypted: i=1; AFNElJ85PhhqJz1Qtx7o3YA5n6Z9Dm00yYdPhxOdL5mszAUBalmqQoArEkVh0oBionXYLQKuNAbJkRF/ag==@kvack.org
X-Gm-Message-State: AOJu0YzF4Pm4cx0NJbQ3/24fBR3H1k1ZWHJSGkxo6BRd7aJ6T1VtqpoW
	qFrtnf/vvTZyoTDpb78U84+oFiZmS0KfgXQxw+u8PHGB2BBpkXA7wLBT
X-Gm-Gg: AeBDieut47WdNg2YoiXqJDWcU0gsUuEX3WLvv4BdlXjEPsWcrFMq6J6px2F2ZyMUXtu
	QlOLl0DvAiESKJygTpC4cxuVsmhsC83KB4bqWxvHmPOurYrE1qcOT5cYhStwRKLvG17uWI/4e1A
	VoVkddYmzlBSQkXcVz+xGxIhF5vGFf2WvhcpoQlqFoSioRIIivEKXc707KIf45iiqUbQi2Qj/Pl
	zBtLdSLcEtpcSGv3l4lrDC8J22Z88MDzGcLJhe2OptVcfARUxu3h3qoHDAHakKWtKgkW5UMat79
	1w/qdKbhybJjjGUn4tOsI7MbuHkWp6GpE2zU0ehnnoyTHJbR6Xd/czkjKd5I4YDctJXfBz4PbU/
	HTaobyZjtdaeSfjU5PcuxrSDeW4qVUT7kHg0mIQHpIGvVYc5PqbNTWxRqC7rE4OgFyYxNdnO4wp
	glY1ckSk4FA8UazdwjxRISDfxGhUksj7l7gNb5HV3EeWA2sw==
X-Received: by 2002:a05:600c:528c:b0:488:a2ac:a337 with SMTP id 5b1f17b1804b1-488d68c2bffmr299093265e9.21.1776287465591;
        Wed, 15 Apr 2026 14:11:05 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:1b17:2901:1431:3a2e:b55b:4b5f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488ede1e050sm270798335e9.5.2026.04.15.14.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 14:11:04 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Boqun Feun <boqun.feng@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 0/4] Introduce QPW for per-cpu operations (v3)
Date: Wed, 15 Apr 2026 18:10:58 -0300
Message-ID: <ad_-4hidfeFgPzRI@WindFlash>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323175544.807534301@redhat.com>
References: <20260323175544.807534301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: t9fndekz8tecs4k4g68cdx6rf849jqmn
X-Rspam-User: 
X-Rspamd-Queue-Id: 6CD31180005
X-HE-Tag: 1776287467-300794
X-HE-Meta: U2FsdGVkX1/KLeQ0tGqjVlpkD9ogqs00g63f2fOI2cuZhYiKXiZADqv2155JN0mCsEYkM2TjubZF3HbdANUke+7OWJwCg/TF2szYajj6krlf5K06lwW319mg7AwXwNYK6c+XivTj+RGVWf8KXn94nxkKapD/cNDXSggKgQ2hn1Qn/rD5JJkqWHtkd7uuIVfN/Gc/77ajHsMZ1y034mX5aTGM1GKOyJDEY5JYuBI11yrpxSFKt+NMhh3K0Mg69vULsQ5FV37/j6mjhofWWsOUMCynZBFTRVXMShxG3GkX64AHencCAEnwQBxTetUV2D+D5hWmwtLsE0Z6xIVyFNMcPh/heVcCNnOKIgGRn9lB2iCwhp51wXORC54e0D2aFx4GZUHnIWmCMBlSfjbjStVJHRHcjQVhmtnPyeQQ2XgTkKhtxySvrkbap9shtxyYt9eP1wi2d7sGZb/Ax1U3cTI1yjQRRz5+OzAc0raqOT7qXKp43N2XjF+j+kM9DbWePZW+yPpE8/WUe4jvarr72jGBg0ffupLrJ3erDtU/DRU66HDAHedIzhf36JXEJUc7UomR/fvBC4N4x7crIzTsjUwCEuL627CBxMAo3kh9K+uhOftGa5eMSnarmMFogWqdFKaqAvb4a5IWx2A8wiphVZARxmtbiWZ/VfnsEb4XmxwWyXXN7bVvhtc4NoKY6fhAfvElpc0Q4q7KDoBdQahEaFoZrWqmCRljXTli/hvIRl/fsinWm70I0ptnKnLMl+v+S3U+XEMqPw6ItT8gHv5aD+lmSk7Izu9Rsd5h15MoLzzjz/uppwd28AWLRok627rXtzFruIWj1SW3uuyKV5jghwcuwEke75Ac+ED+x5wRbPiVTEAOxcpNWj2eb3osTP2sxT6pVT0H7r3vMq8wEMQzaMxoQgXqLtlf+/tkQJUnffx3AuGs2PkDZeFwEi+vF4i9mbNa2dOw9HdroVu8sgg9s6R
 BeJeCNhF
 F5pf0hlVOgJ8hvO5EFHryou8gccbhF0Tv/r7u/+flV8W2wPUa9qg+VYZNXQFrzuGUbLZxxS3X0OZekG5gpW9BCoYyU/HlML4uFVNJrHXj8i+JrmnFbcf+zS6swEeWNGpq3xGQLjSTBNS8IOxLhQts3Kmn8IpLosapF/SgEogR/XN74OHybj5a0w3KiCHctxq8v5XYtz3jAWFXJv/Z0VVvVb/k8q2h+Ogn8XC2nrClQ5QXVYAiU+oyoxby8LWV/b0GdIxDEJzsNQnKA7kst6yB8NUBWQujjiBQdzdAsfvpANXy1t8xgn0ZIoG2ECz56HUx+5NOtW18mXcLXTexjvlqpLfjZTMqkX2HdOM1hV88H3br2GqXJ0fJWGjP5fTy0NHNYwcgH/8X60r2uW/lp5wdcqXSUUNVrmbCFsNNhGlESBFIdmcu+vCph1PvmgQeUwg2SvKe8uXpUYK5PxTYqjkp9Zk+YMWDbXyMJIh5ictbv77/nEk3nVvd3hbPgxW4LcdoQKZxyEhAtAl+2MRu7QbNIJWlO+rheduS4IuEbxzSVFMqccuVOVjDEN4MI68ILovL2/7/8BqgO1a3WWkDX9c2rjfnC1BiWSE0Maz5gyhcro2BuT6m5mh5fIoEw4mzNNjeQke7YsZjAy2jeRJgB2yFpN3bSC25Pesw2DTIdNs28txflEHqhmj1bMJfGU8Ur6uNvddhXKL+Tjfezh2ibyExGnXHo+NfA30CE+fZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cc: Peter Zijlstra <peterz@infradead.org>

On Mon, Mar 23, 2026 at 02:55:44PM -0300, Marcelo Tosatti wrote:
> The problem:
> Some places in the kernel implement a parallel programming strategy
> consisting on local_locks() for most of the work, and some rare remote
> operations are scheduled on target cpu. This keeps cache bouncing low since
> cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> kernels, even though the very few remote operations will be expensive due
> to scheduling overhead.
> 
> On the other hand, for RT workloads this can represent a problem: getting
> an important workload scheduled out to deal with remote requests is
> sure to introduce unexpected deadline misses.
> 
> The idea:
> Currently with PREEMPT_RT=y, local_locks() become per-cpu spinlocks.
> In this case, instead of scheduling work on a remote cpu, it should
> be safe to grab that remote cpu's per-cpu spinlock and run the required
> work locally. That major cost, which is un/locking in every local function,
> already happens in PREEMPT_RT.
> 
> Also, there is no need to worry about extra cache bouncing:
> The cacheline invalidation already happens due to schedule_work_on().
> 
> This will avoid schedule_work_on(), and thus avoid scheduling-out an
> RT workload.
> 
> Proposed solution:
> A new interface called Queue PerCPU Work (QPW), which should replace
> Work Queue in the above mentioned use case.
> 
> If CONFIG_QPW=n this interfaces just wraps the current
> local_locks + WorkQueue behavior, so no expected change in runtime.
> 
> If CONFIG_QPW=y, and qpw kernel boot option =1, 
> queue_percpu_work_on(cpu,...) will lock that cpu's per-cpu structure
> and perform work on it locally. This is possible because on 
> functions that can be used for performing remote work on remote 
> per-cpu structures, the local_lock (which is already
> a this_cpu spinlock()), will be replaced by a qpw_spinlock(), which
> is able to get the per_cpu spinlock() for the cpu passed as parameter.
> 
> v2->v3:
> - Use preempt_disable/preempt_enable on !CONFIG_PREEMPT_RT (Vlastimil Babka).
> - Improve documentation to include local_qpw_lock on operations table
>   (Leonardo Bras).
> - Enable qpw=1 automatically if CPU isolation is enabled (Vlastimil Babka).
> 
> v1->v2:
> - Introduce local_qpw_lock and unlock functions, move preempt_disable/
>   preempt_enable to it (Leonardo Bras). This reduces performance
>   overhead of the patch.
> - Documentation and changelog typo fixes (Leonardo Bras).
> - Fix places where preempt_disable/preempt_enable was not being
>   correctly performed.
> - Add performance measurements.
> 
> RFC->v1:
> 
> - Introduce CONFIG_QPW and qpw= kernel boot option to enable 
>   remote spinlocking and execution even on !CONFIG_PREEMPT_RT
>   kernels (Leonardo Bras).
> - Move buffer_head draining to separate workqueue (Marcelo Tosatti).
> - Convert mlock per-CPU page lists to QPW (Marcelo Tosatti).
> - Drop memcontrol convertion (as isolated CPUs are not targets
>   of queue_work_on anymore).
> - Rebase SLUB against Vlastimil's slab/next.
> - Add basic document for QPW (Waiman Long).
> 
> The performance numbers, as measured by the following test program,
> are as follows:
> 
> CONFIG_PREEMPT_DYNAMIC=y
> Unpatched kernel:                       60 cycles
> Patched kernel, CONFIG_QPW=n:           62 cycles
> Patched kernel, CONFIG_QPW=y, qpw=0:    62 cycles
> Patched kernel, CONFIG_QPW=y, qpw=1:    75 cycles
> 
> CONFIG_PREEMPT_RT:
> Unpatched kernel:                       95 cycles
> Patched kernel, CONFIG_QPW=y, qpw=0:    99 cycles
> Patched kernel, CONFIG_QPW=y, qpw=1:    97 cycles
> 
> kmalloc_bench.c:
> #include <linux/module.h>
> #include <linux/kernel.h>
> #include <linux/slab.h>
> #include <linux/timex.h>
> #include <linux/preempt.h>
> #include <linux/irqflags.h>
> #include <linux/vmalloc.h>
> 
> MODULE_LICENSE("GPL");
> MODULE_AUTHOR("Gemini AI");
> MODULE_DESCRIPTION("A simple kmalloc performance benchmark");
> 
> static int size = 64; // Default allocation size in bytes
> module_param(size, int, 0644);
> 
> static int iterations = 9000000; // Default number of iterations
> module_param(iterations, int, 0644);
> 
> static int __init kmalloc_bench_init(void) {
>     void **ptrs;
>     cycles_t start, end;
>     uint64_t total_cycles;
>     int i;
>     pr_info("kmalloc_bench: Starting test (size=%d, iterations=%d)\n", size, iterations);
> 
>     // Allocate an array to store pointers to avoid immediate kfree-reuse optimization
>     ptrs = vmalloc(sizeof(void *) * iterations);
>     if (!ptrs) {
>         pr_err("kmalloc_bench: Failed to allocate pointer array\n");
>         return -ENOMEM;
>     }
> 
>     preempt_disable();
>     start = get_cycles();
> 
>     for (i = 0; i < iterations; i++) {
>         ptrs[i] = kmalloc(size, GFP_ATOMIC);
>     }
> 
>     end = get_cycles();
> 
>     total_cycles = end - start;
>     preempt_enable();
> 
>     pr_info("kmalloc_bench: Total cycles for %d allocs: %llu\n", iterations, total_cycles);
>     pr_info("kmalloc_bench: Avg cycles per kmalloc: %llu\n", total_cycles / iterations);
> 
>     // Cleanup
>     for (i = 0; i < iterations; i++) {
>         kfree(ptrs[i]);
>     }
>     vfree(ptrs);
> 
>     return 0;
> }
> 
> static void __exit kmalloc_bench_exit(void) {
>     pr_info("kmalloc_bench: Module unloaded\n");
> }
> 
> module_init(kmalloc_bench_init);
> module_exit(kmalloc_bench_exit);
> 
> The following testcase triggers lru_add_drain_all on an isolated CPU
> (that does sys_write to a file before entering its realtime 
> loop).
> 
> /* 
>  * Simulates a low latency loop program that is interrupted
>  * due to lru_add_drain_all. To trigger lru_add_drain_all, run:
>  *
>  * blockdev --flushbufs /dev/sdX
>  *
>  */ 
> #define _GNU_SOURCE
> #include <fcntl.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <sys/mman.h>
> #include <string.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <stdlib.h>
> #include <stdarg.h>
> #include <pthread.h>
> #include <sched.h>
> #include <unistd.h>
> 
> int cpu;
> 
> static void *run(void *arg)
> {
> 	pthread_t current_thread;
> 	cpu_set_t cpuset;
> 	int ret, nrloops;
> 	struct sched_param sched_p;
> 	pid_t pid;
> 	int fd;
> 	char buf[] = "xxxxxxxxxxx";
> 
> 	CPU_ZERO(&cpuset);
> 	CPU_SET(cpu, &cpuset);
> 
> 	current_thread = pthread_self();    
> 	ret = pthread_setaffinity_np(current_thread, sizeof(cpu_set_t), &cpuset);
> 	if (ret) {
> 		perror("pthread_setaffinity_np failed\n");
> 		exit(0);
> 	}
> 
> 	memset(&sched_p, 0, sizeof(struct sched_param));
> 	sched_p.sched_priority = 1;
> 	pid = gettid();
> 	ret = sched_setscheduler(pid, SCHED_FIFO, &sched_p);
> 	if (ret) {
> 		perror("sched_setscheduler");
> 		exit(0);
> 	}
> 
> 	fd = open("/tmp/tmpfile", O_RDWR|O_CREAT|O_TRUNC);
> 	if (fd == -1) {
> 		perror("open");
> 		exit(0);
> 	}
> 
> 	ret = write(fd, buf, sizeof(buf));
> 	if (ret == -1) {
> 		perror("write");
> 		exit(0);
> 	}
> 
> 	do { 
> 		nrloops = nrloops+2;
> 		nrloops--;
> 	} while (1);
> }
> 
> int main(int argc, char *argv[])
> {
>         int fd, ret;
> 	pthread_t thread;
> 	long val;
> 	char *endptr, *str;
> 	struct sched_param sched_p;
> 	pid_t pid;
> 
> 	if (argc != 2) {
> 		printf("usage: %s cpu-nr\n", argv[0]);
> 		printf("where CPU number is the CPU to pin thread to\n");
> 		exit(0);
> 	}
> 	str = argv[1];
> 	cpu = strtol(str, &endptr, 10);
> 	if (cpu < 0) {
> 		printf("strtol returns %d\n", cpu);
> 		exit(0);
> 	}
> 	printf("cpunr=%d\n", cpu);
> 
> 	memset(&sched_p, 0, sizeof(struct sched_param));
> 	sched_p.sched_priority = 1;
> 	pid = getpid();
> 	ret = sched_setscheduler(pid, SCHED_FIFO, &sched_p);
> 	if (ret) {
> 		perror("sched_setscheduler");
> 		exit(0);
> 	}
> 
> 	pthread_create(&thread, NULL, run, NULL);
> 
> 	sleep(5000);
> 
> 	pthread_join(thread, NULL);
> }
> 
> 
> 
> 
> 

