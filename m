Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67E3DEE20A8
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 14:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F3E76B0092; Fri,  6 Feb 2026 09:40:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EA4F6B0096; Fri,  6 Feb 2026 09:40:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 694496B0093; Fri,  6 Feb 2026 09:40:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 563E16B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:40:18 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F3CF35634D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:40:17 +0000 (UTC)
X-FDA: 84414292074.17.A187230
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id ED9D540005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:40:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ds9jtKUp;
	spf=pass (imf17.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770388816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZJOPyIeuN4YpQvteY0c57G969uic9qUJI9o0lGN6g88=;
	b=tyHPl+wiGpsKVDPeNO79oYrbVm2wALe0BQEsHBmaa7ad6SycHCjtQQUjc0pXPqJ1uGVPYW
	GnJWewa4moFWXFJnpV18SaQVSGtERDnt37ZEEB2OgBzckVW9RG++C+npGP+Xt2/t6SLrYP
	ClpTvxk7GHOm0jfUbiEDD+iHAwV6YZo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ds9jtKUp;
	spf=pass (imf17.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770388816; a=rsa-sha256;
	cv=none;
	b=wNv337lGXOwbvFqMrSyrFUhVKbfLZ2qUAJS52R3YQ8rekQ/3jd3ihylqzrqfJ/OGpUYhwA
	c5y41eyIx2iJQFKtYXhKdAkEoplgklcXsXEbEfro05NLhtgMd2j05sbB22uGtd5JloMUb4
	OTAQ/0gOEJyGtLqxBwa34oIG3jGnv8A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770388815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:content-type:content-type;
	bh=ZJOPyIeuN4YpQvteY0c57G969uic9qUJI9o0lGN6g88=;
	b=Ds9jtKUpgMiN/yXyqaAwiQsibHbmw4qavXaG3xcz5IXrmYi9DZfMV5k5seScZrCDTSJybH
	kK3BjiVjQlI6fmqeJ+8oVh3NhFyXLIMoj2hTSNgrbhFkbEPbMylbWc/nCZvWFGlOcmQoyZ
	c2l9QTzTDBFwGd5y0D/D1kK//ZxQyAk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-647-_sk-7kBwPcOgQlIMf14EzA-1; Fri,
 06 Feb 2026 09:40:12 -0500
X-MC-Unique: _sk-7kBwPcOgQlIMf14EzA-1
X-Mimecast-MFC-AGG-ID: _sk-7kBwPcOgQlIMf14EzA_1770388809
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF63118005B6;
	Fri,  6 Feb 2026 14:40:09 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.22.74.16])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3DF8B19373D8;
	Fri,  6 Feb 2026 14:40:07 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id A16CE400DF80B; Fri,  6 Feb 2026 11:39:20 -0300 (-03)
Message-ID: <20260206143430.021026873@redhat.com>
User-Agent: quilt/0.66
Date: Fri, 06 Feb 2026 11:34:30 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
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
 Leonardo Bras <leobras@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Waiman Long <longman@redhat.com>,
 Boqun Feng <boqun.feng@gmail.com>
Subject: [PATCH 0/4] Introduce QPW for per-cpu operations
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: dAEAIyYyUM-27y-V8MPJ0mdirD5-Zh2BWp4Yxgpsgwo_1770388809
X-Mimecast-Originator: redhat.com
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam11
X-Stat-Signature: hmjxs8rjp8yn745zor6yuthskzukmd4a
X-Rspam-User: 
X-Rspamd-Queue-Id: ED9D540005
X-HE-Tag: 1770388815-130775
X-HE-Meta: U2FsdGVkX19ltpBEvUwuKhOjm6NP4tkRbKdCs4ryxeVimHoIai/REY645+Fbr5WhDncZK1YQz3/Fab72wtD8O4CK0Ac966H6q9atnolNk26l5jxhR0BoOgH58iVePUPlhIJQhwr7yb82w4wSRPzUr8+YxgbTV/9/vGOBKV7w4yEVKbtqitVLMuvlKHVJmaluyETGTDaT29PsmT9cla/giClLZF/vws6us4FfwfZARif+gVOeBuyryb3Z6QMuGi3OqSrq904pVWaSxAQdTXwa0+7tyjt4cIlyMS+aOp/bMFO3zgLAMKn3PdgAlS9P3NI30NWxEl1GL3NHSuWTeSarmF7gUPBLF8WNqkQq+yG0sTZ7RQdyqFiiVQFlRdTmCefZA3kjT0EhJzOYXZsdqzH8gQYoOoAV9UWULBo7gi6STS2Cwb/j+stB8VyP+bMVpdBHaxgvy1eq01eusou4OrSxezyMm6GsldlQetYMBq4IFhfMgxUhR0C+YfAFJPeYt4YT0ssmL+zUf/CdzkoNyc/629HtWN/43qzmxn0uqLkfF7njo/v0ZKBuS3m5CIplvXymyZ9ZMaGkLRDHgXok7paiLh32bkMkIb3F9R71Qh+p+4GjEPifRorroYdCqJhplk6F2HAlXA8doq2EVh+IN9sGFnYalWk0KuEEPiNu11PMMnSfEWUY7y02omwZmYAMwTXQHWSsgv01A4zkjt1oFY2XY/sQK4tzH4z54EBNO/Iq14+Hg1e58WRtn7xCD2QZsXHDTEWQ/2P8cKB25AZLXR5rFAxqAAsfJuKIY6Jb7phZUN36DOzV6QH+w4X8DXBw1XBtHgkV7EWOkq7bsATlxc4uP1BRBkyaugWFAtps2lEuuC5+9b68aIXsN+KE+aKgS7Bd9Imaclx8ujtGg71pDe/DXFW7zk08S9fwckCny3ovRsa+ubsDowuKJ9jarOn2EVxxrs7BeYs9PuTGL5t2fXd
 wNpest6h
 xh3ej9p4bftsIxKE1uO9tyGe/cO+rB3kc7i0ztxQOToD2F838qpWxpTp4ejzrkJXphYAQoKBvf69C+NDpUEyI+HONpHiHv07R/qqRrmOk6s2Ot0SYi8wSuu+JFdtnUv3wC3JxxJ4EW9wZBEUpbVHiWqjye7uzZ7CVjd5YzK4su61w40c3UactS8q2Sn7mQWOmXjhvq2l7to6nP1TsnWyhf5QU12UXh7nmj058xD3F2y16z8luaEh+HNK51foBnf5TEnTHnvzQuhwW3TQh6+nqavMppSxS9qRIgY2Nd6bTjCyv/H7LDCtYSvXtNBk9d1ywdd0yknflqSiwmB5/zz8QCSFtze4LhZC7gwg+ctihiN7rcLZFltfM1PtML1iwLV7cDAcpLMqSbwOmDDYXWzAkfOi7KA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

If PREEMPT_RT=n this interfaces just wraps the current
local_locks + WorkQueue behavior, so no expected change in runtime.

If PREEMPT_RT=y, or CONFIG_QPW=y, queue_percpu_work_on(cpu,...) will
lock that cpu's per-cpu structure and perform work on it locally. 
This is possible because on functions that can be used for performing
remote work on remote per-cpu structures, the local_lock (which is already
a this_cpu spinlock()), will be replaced by a qpw_spinlock(), which
is able to get the per_cpu spinlock() for the cpu passed as parameter.

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



