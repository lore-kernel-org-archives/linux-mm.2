Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39A2DEA4E26
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:53:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A7276B0098; Mon,  2 Mar 2026 10:53:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 245166B0096; Mon,  2 Mar 2026 10:53:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA2886B0099; Mon,  2 Mar 2026 10:53:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6F8D6B0098
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:53:31 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60EB5140180
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:53:31 +0000 (UTC)
X-FDA: 84501567822.04.AC094EB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7AA11C0009
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:53:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="WtHonB/J";
	spf=pass (imf28.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772466809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0FcJExh6URZjyjWUCUvehL157kXxK4+CRdEnZ1Cl6Yg=;
	b=dMSanPkxkwFatb2Jv6VG1gXpPE03k+1ir2aIZWAEILyvlqS+RgRFKEFm27RlprGeZu3GkA
	kh+mnZaDaGn0+ReZ+TqmZJSRTJMaLBHCjdW43hLABPs53CkchIQKJbDNViY0cc/AGu6LAq
	keG3ckvgDbJpWaYTtt1rTrxLUHrSaPc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="WtHonB/J";
	spf=pass (imf28.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772466809; a=rsa-sha256;
	cv=none;
	b=Q710xvcWFNAHTbsLtWxmyHKFRFYj4d94oUU7AHBxjOC7QZ6oa7aWb0bp62n4d/nA2qPUtX
	KBmKnlKKDI1grnfO52YTQ3DhsRBLrTVBcROSZNYor/RbiqMZFx2nsbLtvHG7AVZyJ9Jxq0
	xNAzUBf6phYLV3kjdUUf9mvtsHeEGJk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772466808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:content-type:content-type;
	bh=0FcJExh6URZjyjWUCUvehL157kXxK4+CRdEnZ1Cl6Yg=;
	b=WtHonB/JUgn6iA+Ad51qso/oTYz481PsfZ+0jZ0UgxPbVZ1nfVoHdER4rOiJwPny6mOaO6
	8EzeThN9qbKm28FMeNlxkfYkEf1qP0Al8kj+kFYxwYz7ISuAIeXIUoqFka+UDdcLcCnIXe
	7+VabKNx0+jXWahbe14oP4AtcEuPktE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-630--FvjyvKDOCyFg5cYcHDD5g-1; Mon,
 02 Mar 2026 10:53:25 -0500
X-MC-Unique: -FvjyvKDOCyFg5cYcHDD5g-1
X-Mimecast-MFC-AGG-ID: -FvjyvKDOCyFg5cYcHDD5g_1772466803
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8E30319560A7;
	Mon,  2 Mar 2026 15:53:22 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.6])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0BC881800594;
	Mon,  2 Mar 2026 15:53:20 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 874C0401CED19; Mon,  2 Mar 2026 12:53:00 -0300 (-03)
Message-ID: <20260302154945.143996316@redhat.com>
User-Agent: quilt/0.69
Date: Mon, 02 Mar 2026 12:49:45 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>,
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
 Leonardo Bras <leobras.c@gmail.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Waiman Long <longman@redhat.com>,
 Boqun Feun <boqun.feng@gmail.com>,
 Frederic Weisbecker <frederic@kernel.org>
Subject: [PATCH v2 0/5] Introduce QPW for per-cpu operations (v2)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: OFezU6u646QVBXL0nBTJogwnPQZfY633g085cQDY5os_1772466803
X-Mimecast-Originator: redhat.com
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7AA11C0009
X-Stat-Signature: bgexrc93zm4n1yc8ed7uq8trz51ea4rc
X-Rspam-User: 
X-HE-Tag: 1772466809-753382
X-HE-Meta: U2FsdGVkX198mhanK3h9TrO0o2t0BxshDovHdgMvda7NOyc+qZZJImHMLhaMcfPckixnF1Bj6/ubHPI29G3idX5z/O4WPdphaE/eZo2jJnTjYk3PAxffjEN8CF6qLSIMMm1Tnw/FzVKcdps1x3+lOrSvBthYMoHljDQLeiyb6p8v++mI4dZzcUalz9JDxkxoEP1m76S8ndwGbo1qtFz1J850oCUSvQ5xYcrzcvCsefPm8iHzZofVb4jl2A0t7jDnIbOFw1Qw/tBoHNf8YAyOxilibDKRku5VCAthrYnZMboMPz2RhvS3vZkl2ztKLbKAIRczdxwDS02MXonbZGRZrIbEo5kEHN8MvIRYzivIC9284I1Rl3UI2pfLvT5xRm1PtGuHD6AQbv52M6JZkhZLZszeDDhHMc3BELLut5hOvSXHPOFF9iSuvt2zA5mYSGnzSpbw7gSqqcl6YTJG6FV14C3bcfqTrKw5uoS1SUzJ5UuacWOu8va0JZzvFDwzOrOpzTiABfR6wk1JtGFdPbO0XTxe08H43lQXUHG3FvjRo+e+A9eCcl9+lLPy1YcOo0JalLUVzFP5MPp5sMgGUQlL62daLeweN8ZQTNBy3zmgyqxLiRyobFRF0DIV/jGNVjJ+jynDKOuNZJAlFaRn906ZrBkZ2r0fAs+a9MRb6FXlasO5yEFxgydoR2DJgOGx2klOY6Sgz9ogGxK3q3Iz3OGaT3VyYNK65v5fS33YLAgFVK3c7QMU0pTMB5Cg6IbbPVjFL1OzF7a9vEJt0RhybwTVCp1VzIJeIDUwkof+QsAf35TlOo4jEAGzmwGzDWRzfWUnKcF/4bwdefk05/wU6e8pKFGPnvwvNwbeEO/EJDjtzfKfiziyq3elbyF+ABdxOn3Hvd/QxD2ZvHDY+OZHxSKOp9uY9ZTUH1XzX30sQHrcJBkrsN9pYp7q486HF7MYWsq1hNVfOUQMuYSIi0JVtLD
 F57Ck5YA
 IBSHgAdVx0nFUaztJClW0BH7DZimW1MvnYcZ2BaETGnZu2Pq3jITUwlAf22n1QsMi3U+5o5yFiDHctofuhVLUHQfXtQIi3AWPSHCT/2fKzR6Mufr/cPfpB0gYxHerDgqLaRBA2EDoahITWJfFIDrXvymFv8VF2ila/gR1KXt8c+hFOJIno69dBKtwvB7eZ7JRO4mhD7RRrFd429g9G5ZePdE/MxZ3RgdtEgnbsVrF+eT3hpwtuGfMWmEKaEpv8lCAlBZ427KJnWTmBmNq1l2JfAbf2rNlMvQJCvskyagnw4UhrN3MkZJi7jOqb56PqtkNdob1EsddvJWoTJIJq/v64xe8AOt16BlA7T6zHyh1GTglg+5PxOHuFz8ZWgXg/4dWoSsRVaHwwkVFPOYm57AEgjrLLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The problem:
Some places in the kernel implement a parallel programming strategy
consisting on local_locks() for most of the work, and some rare remote
operations are scheduled on target cpu. This keeps cache bouncing low since
cacheline tends to be mostly local, and avoids the cost of locks in non-RT
kernels, even though the very few remote operations will be expensive due
to scheduling overhead.

On the other hand, for RT workloads this can represent a problem: getting
an important workload scheduled out to deal with remote requests is
sure to introduce unexpected deadline misses.

The idea:
Currently with PREEMPT_RT=y, local_locks() become per-cpu spinlocks.
In this case, instead of scheduling work on a remote cpu, it should
be safe to grab that remote cpu's per-cpu spinlock and run the required
work locally. That major cost, which is un/locking in every local function,
already happens in PREEMPT_RT.

Also, there is no need to worry about extra cache bouncing:
The cacheline invalidation already happens due to schedule_work_on().

This will avoid schedule_work_on(), and thus avoid scheduling-out an
RT workload.

Proposed solution:
A new interface called Queue PerCPU Work (QPW), which should replace
Work Queue in the above mentioned use case.

If CONFIG_QPW=n this interfaces just wraps the current
local_locks + WorkQueue behavior, so no expected change in runtime.

If CONFIG_QPW=y, and qpw kernel boot option =1, 
queue_percpu_work_on(cpu,...) will lock that cpu's per-cpu structure
and perform work on it locally. This is possible because on 
functions that can be used for performing remote work on remote 
per-cpu structures, the local_lock (which is already
a this_cpu spinlock()), will be replaced by a qpw_spinlock(), which
is able to get the per_cpu spinlock() for the cpu passed as parameter.

v1->v2:
- Introduce local_qpw_lock and unlock functions, move preempt_disable/
  preempt_enable to it (Leonardo Bras). This reduces performance
  overhead of the patch.
- Documentation and changelog typo fixes (Leonardo Bras).
- Fix places where preempt_disable/preempt_enable was not being
  correctly performed.
- Add performance measurements.

RFC->v1:

- Introduce CONFIG_QPW and qpw= kernel boot option to enable 
  remote spinlocking and execution even on !CONFIG_PREEMPT_RT
  kernels (Leonardo Bras).
- Move buffer_head draining to separate workqueue (Marcelo Tosatti).
- Convert mlock per-CPU page lists to QPW (Marcelo Tosatti).
- Drop memcontrol convertion (as isolated CPUs are not targets
  of queue_work_on anymore).
- Rebase SLUB against Vlastimil's slab/next.
- Add basic document for QPW (Waiman Long).

The performance numbers, as measured by the following test program,
are as follows:

Unpatched kernel:			166 cycles
Patched kernel, CONFIG_QPW=n:		166 cycles
Patched kernel, CONFIG_QPW=y, qpw=0:	168 cycles
Patched kernel, CONFIG_QPW=y, qpw=1:	192 cycles

kmalloc_bench.c:
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/slab.h>
#include <linux/timex.h>
#include <linux/preempt.h>
#include <linux/irqflags.h>
#include <linux/vmalloc.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Gemini AI");
MODULE_DESCRIPTION("A simple kmalloc performance benchmark");

static int size = 64; // Default allocation size in bytes
module_param(size, int, 0644);

static int iterations = 9000000; // Default number of iterations
module_param(iterations, int, 0644);

static int __init kmalloc_bench_init(void) {
    void **ptrs;
    cycles_t start, end;
    uint64_t total_cycles;
    int i;
    pr_info("kmalloc_bench: Starting test (size=%d, iterations=%d)\n", size, iterations);

    // Allocate an array to store pointers to avoid immediate kfree-reuse optimization
    ptrs = vmalloc(sizeof(void *) * iterations);
    if (!ptrs) {
        pr_err("kmalloc_bench: Failed to allocate pointer array\n");
        return -ENOMEM;
    }

    preempt_disable();
    start = get_cycles();

    for (i = 0; i < iterations; i++) {
        ptrs[i] = kmalloc(size, GFP_ATOMIC);
    }

    end = get_cycles();

    total_cycles = end - start;
    preempt_enable();

    pr_info("kmalloc_bench: Total cycles for %d allocs: %llu\n", iterations, total_cycles);
    pr_info("kmalloc_bench: Avg cycles per kmalloc: %llu\n", total_cycles / iterations);

    // Cleanup
    for (i = 0; i < iterations; i++) {
        kfree(ptrs[i]);
    }
    vfree(ptrs);

    return 0;
}

static void __exit kmalloc_bench_exit(void) {
    pr_info("kmalloc_bench: Module unloaded\n");
}

module_init(kmalloc_bench_init);
module_exit(kmalloc_bench_exit);

The following testcase triggers lru_add_drain_all on an isolated CPU
(that does sys_write to a file before entering its realtime 
loop).

/* 
 * Simulates a low latency loop program that is interrupted
 * due to lru_add_drain_all. To trigger lru_add_drain_all, run:
 *
 * blockdev --flushbufs /dev/sdX
 *
 */ 
#define _GNU_SOURCE
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <stdarg.h>
#include <pthread.h>
#include <sched.h>
#include <unistd.h>

int cpu;

static void *run(void *arg)
{
	pthread_t current_thread;
	cpu_set_t cpuset;
	int ret, nrloops;
	struct sched_param sched_p;
	pid_t pid;
	int fd;
	char buf[] = "xxxxxxxxxxx";

	CPU_ZERO(&cpuset);
	CPU_SET(cpu, &cpuset);

	current_thread = pthread_self();    
	ret = pthread_setaffinity_np(current_thread, sizeof(cpu_set_t), &cpuset);
	if (ret) {
		perror("pthread_setaffinity_np failed\n");
		exit(0);
	}

	memset(&sched_p, 0, sizeof(struct sched_param));
	sched_p.sched_priority = 1;
	pid = gettid();
	ret = sched_setscheduler(pid, SCHED_FIFO, &sched_p);
	if (ret) {
		perror("sched_setscheduler");
		exit(0);
	}

	fd = open("/tmp/tmpfile", O_RDWR|O_CREAT|O_TRUNC);
	if (fd == -1) {
		perror("open");
		exit(0);
	}

	ret = write(fd, buf, sizeof(buf));
	if (ret == -1) {
		perror("write");
		exit(0);
	}

	do { 
		nrloops = nrloops+2;
		nrloops--;
	} while (1);
}

int main(int argc, char *argv[])
{
        int fd, ret;
	pthread_t thread;
	long val;
	char *endptr, *str;
	struct sched_param sched_p;
	pid_t pid;

	if (argc != 2) {
		printf("usage: %s cpu-nr\n", argv[0]);
		printf("where CPU number is the CPU to pin thread to\n");
		exit(0);
	}
	str = argv[1];
	cpu = strtol(str, &endptr, 10);
	if (cpu < 0) {
		printf("strtol returns %d\n", cpu);
		exit(0);
	}
	printf("cpunr=%d\n", cpu);

	memset(&sched_p, 0, sizeof(struct sched_param));
	sched_p.sched_priority = 1;
	pid = getpid();
	ret = sched_setscheduler(pid, SCHED_FIFO, &sched_p);
	if (ret) {
		perror("sched_setscheduler");
		exit(0);
	}

	pthread_create(&thread, NULL, run, NULL);

	sleep(5000);

	pthread_join(thread, NULL);
}







