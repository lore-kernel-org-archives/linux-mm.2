Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23AFDF483DE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 18:06:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F25136B008C; Mon, 23 Mar 2026 14:06:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E86C36B009B; Mon, 23 Mar 2026 14:06:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD9D76B009E; Mon, 23 Mar 2026 14:06:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B17A16B008C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:06:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7AB53160CFD
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:06:24 +0000 (UTC)
X-FDA: 84578107488.20.358B9E0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id ADF0E2000A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:06:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gOKpV25S;
	spf=pass (imf03.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774289182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wkP2QjIdWDzhfk8spPSyVBANKc4VDOi5FyORC6jFrWQ=;
	b=0jTkp6IuqmfpjvDIzrWnCHuWn+I/XsrUsSgrDTrG0IHjdrZgelrN1dbDuJT6qsWVva2oKN
	yeVWH6AYL8LY35V8PTyUa3eBdT3RFyHcF+Kgd/lMsxbVJ+nDyA7yfk8h4JCNMCiIxNyud+
	LPe2A17NQGF4RqNzJR/BJTdM/vEfiOo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gOKpV25S;
	spf=pass (imf03.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774289182; a=rsa-sha256;
	cv=none;
	b=4h+Qrk2WwvuMVgTRsopP2ysqKlFNBAYKtB1nKqXcewe/3RhS+rJBq2QBV86c6XPR44GWda
	u8UHzDYpQIhZ9ywLDlC4CmERAqLt0oasYcps7dGxC8D0lEIeW6Sr/a2Wc/suG1mJ/JKbif
	RkLc010WdUxNwr6ckX6qqCVB1cMoGGk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774289182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:content-type:content-type;
	bh=wkP2QjIdWDzhfk8spPSyVBANKc4VDOi5FyORC6jFrWQ=;
	b=gOKpV25SJu7L7YqKOHto+sTXyMAB5xUTwHxughahCgrwhJziG+oLB/ptTUd/us8kMVjiTb
	SibOe7tBpFQ0lmERX7xczFooVec8lwRSZo2vM25IY9TuFAPZv8LfiU+MUkfmg4rdMhMFfw
	5/vKtzlq8Sj7s0lpI6ogpsIBhCMBA/I=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-136-HR5oLdZLMm66ok4t9u6dfg-1; Mon,
 23 Mar 2026 14:06:15 -0400
X-MC-Unique: HR5oLdZLMm66ok4t9u6dfg-1
X-Mimecast-MFC-AGG-ID: HR5oLdZLMm66ok4t9u6dfg_1774289173
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0D7CE1800281;
	Mon, 23 Mar 2026 18:06:13 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.4])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 98B561800351;
	Mon, 23 Mar 2026 18:06:11 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id A4C7B4018D5B2; Mon, 23 Mar 2026 15:05:44 -0300 (-03)
Message-ID: <20260323175544.807534301@redhat.com>
User-Agent: quilt/0.69
Date: Mon, 23 Mar 2026 14:55:44 -0300
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
Subject: [PATCH v3 0/4] Introduce QPW for per-cpu operations (v3)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: uOLFziff3unQOWtNlgjaAPXBGAGpyOyyZPTudFqZzlE_1774289173
X-Mimecast-Originator: redhat.com
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: ADF0E2000A
X-Stat-Signature: t7uybzk7w19e7rgt5xssr9cx9au5h6t4
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774289182-425866
X-HE-Meta: U2FsdGVkX1+rWHlb4VEJEQ9HtN3M6PlH0HAVLyNSvWj/BPFR0QmnqCrcVudgIya5mqrcUZQVrgionZQ3YD+wQ00BzVoUGyt/5+qr+5aUPH3NFH8gmcjpD6NVKg90pKga1BiYOrod3HCx8LUQH/yBb7mzi2CETm1XIVXKDWs4lNHE/qEuTGhQB8ooDR57t7GGJ2BdtaEWu9eT5/qko/DXV9EfDri6paoowvecz+AD4RFZmyz+jLr6l2MOGqyzOOphNATRstgkksvQPb55+/8dS4pP3nPVWgavdbp48Ceb9etR94YW/bB0iBkCY1uao0RmFjSSvbcaAgx/Q+dEnhKyZ3lU62SMXQq3X0iD6PnTNaK20qnoF5CSoTosH1vcWxe3hM6S55xGUbIK4HVLQnhOqYkk9pOIvOKPz06FnXmBmG0HXKtGQ3ajfWkvOqqfLD/8m0bt+2AjMW4bDuE05vGki908QXKIuXUH1J3z4GSB8flsoJPre+2/yRgCh6Jt6K7+c56S0sk449B0gTX3Pr4S/HPv79GsTJTuztkSjTytNYp82s+dpL8fIJLHWTf1ZKDujFlm0GeuQ/oPGKFR6Oy+9MWH4j4FP9UYJBOjvvsv0G31e3wNLns+jlQjtO/C1xjPI9ZvDZyR1qFmuQAVlykMuuJGdxueQlw4xtB5TpCve20AH8k2NqjOHhaHFkbVbbPLvXdv+inhQCpDY49bwzVEBH37n0SnRzgtT0oD46Xf+JYd4hk0X5kAL5LTy9Cr7J933YCOwxNyvZduwm/pbYcmUuy0+H8dKz69BdyyNrYURrgfSOrCcCd1LV+tTz8ZfyCLoB+GdSYdijqA0q1Oi65kOYYFKqSr5EwojYJwEMiiuAFq8mjE0dybq+l+RcssOQxpgeU+qMHiMYQMsBaLdhN+4221WEb8BuZ+4A0c+O+NPhP3kDRHgVH5FHf93p35VLxiOaV34f3YBzSDYdKkNvB
 4JhM+BuY
 PtOGzhluz8S/uw3AwnddTBot9eQxuJ5sEKIDuNZ3PYxyub/6OjD4ruSVFlFtdExjTuYVeC4fC3+imC4lJFAmWpTYKH/rPyiZMcpq36+e+3bLIAE2SJvsemp9AYLioRmpocAsh8w2rWpbSlKuO+GHhJ68xXF6rnts4dK6C3AXQYf5RtPE5Mg1UyFlC0NL4fG9e4mqQew32TUdXigDh2ZG5PmrFQ6+PLCDFQV+UOWxCSiDU0qGmmnBKse9MXNUzNonaI0O+1gQS57ft7MURChaqzyzg/NQmjLCK592X9W2Bp05JUMabYcB6eILZVACpiOEeEMWhzySP0zo+rxsDBL8Lgky3cHlpZ1Q/VqPbOGU2rgzWy4i4Sje2A0SEp/b/vmdIqAdc01rzYBXZ/wyxXUxtaRKAPg==
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

v2->v3:
- Use preempt_disable/preempt_enable on !CONFIG_PREEMPT_RT (Vlastimil Babka).
- Improve documentation to include local_qpw_lock on operations table
  (Leonardo Bras).
- Enable qpw=1 automatically if CPU isolation is enabled (Vlastimil Babka).

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

CONFIG_PREEMPT_DYNAMIC=y
Unpatched kernel:                       60 cycles
Patched kernel, CONFIG_QPW=n:           62 cycles
Patched kernel, CONFIG_QPW=y, qpw=0:    62 cycles
Patched kernel, CONFIG_QPW=y, qpw=1:    75 cycles

CONFIG_PREEMPT_RT:
Unpatched kernel:                       95 cycles
Patched kernel, CONFIG_QPW=y, qpw=0:    99 cycles
Patched kernel, CONFIG_QPW=y, qpw=1:    97 cycles

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






