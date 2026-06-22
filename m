Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42668CDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 06:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19A386B0088; Mon, 22 Jun 2026 02:16:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C2B6B008A; Mon, 22 Jun 2026 02:16:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03A626B008C; Mon, 22 Jun 2026 02:16:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C99A56B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 02:16:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 503521C55DF
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:16:18 +0000 (UTC)
X-FDA: 84906538836.16.3EB5522
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id A9BA31C0002
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:16:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t15fr1vS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782108976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uc01vIZYGfTIV3fdEG67Z2UKVAOKK7e6urfcQoWTPXs=;
	b=KSR/atADrT0h+mPnRA7NJFWRlcS0Hkc+8wlQx3ZMZoy7gk+o7WuuNn/AmIeC+cNgKOuwaG
	aZYVuHW+CJZ602MOi59MajMJXx6vofr1Scr3Ddsg9OiGe7XANaM/aei2zPKpmIRWyB7MvQ
	3ARzm8qFemUZ6I2omPQkGdHz4Fts3lI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t15fr1vS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782108976;
	b=PXzN1jBNoz21WZKyMxL7og61kNopvwp2k9S2Em2KidAiOXXenvC1C7eM8AH8FGaktZdEDi
	GFregT54mYosIdTmOZgutI89RVxybblLpIf0ZOyC7cUh6E2TUlAE+taPRaiZa8SGY0Rw3C
	FrsF9a6gs0NzAoIt8e14zWWCDsg9m+o=
Message-ID: <8c8f1849-86d3-4c69-be27-30bbdffdf616@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782108966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uc01vIZYGfTIV3fdEG67Z2UKVAOKK7e6urfcQoWTPXs=;
	b=t15fr1vSWPqYuOVx1/bxMEqBYsgHtm0lD1qKuOgL6xYl94f+kJLWMkDtNXA1O6oXS4NWrk
	UXfi4I4xGSapixdXs6K5v7yl7QxZTsj0xBO+b54oW8Z9JaKuiK5OobLxhWf+TcWH/AL++5
	EurPaDWOivYCOI4YE0QW4UrJN1dv49Y=
Date: Mon, 22 Jun 2026 14:15:01 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/7] Prepare mutable list iterators to cache cursor
 state
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Tejun Heo <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Paul Moore <paul@paul-moore.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 David Howells <dhowells@redhat.com>, Simona Vetter <simona.vetter@ffwll.ch>,
 Randy Dunlap <rdunlap@infradead.org>,
 Luca Ceresoli <luca.ceresoli@bootlin.com>,
 Philipp Stanner <phasta@kernel.org>, linux-block@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>,
 "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
 linux-ntfs-dev@lists.sourceforge.net,
 Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
 io-uring <io-uring@vger.kernel.org>, audit@vger.kernel.org,
 bpf <bpf@vger.kernel.org>, Network Development <netdev@vger.kernel.org>,
 dri-devel@lists.freedesktop.org,
 "linux-perf-use." <linux-perf-users@vger.kernel.org>,
 linux-trace-kernel <linux-trace-kernel@vger.kernel.org>,
 kexec@lists.infradead.org, live-patching@vger.kernel.org,
 linux-modules@vger.kernel.org,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Linux Power Management <linux-pm@vger.kernel.org>, rcu@vger.kernel.org,
 sched-ext@lists.linux.dev, linux-mm <linux-mm@kvack.org>,
 virtualization@lists.linux.dev, damon@lists.linux.dev,
 clang-built-linux <llvm@lists.linux.dev>,
 chengkaitao <chengkaitao@kylinos.cn>, Muchun Song <muchun.song@linux.dev>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
 <CAADnVQJmPWFT01b7DuLdtafv=8FyB84GYHNZ8zSTck+9Aw0JpA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <CAADnVQJmPWFT01b7DuLdtafv=8FyB84GYHNZ8zSTck+9Aw0JpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A9BA31C0002
X-Stat-Signature: 8gtpnu9u9tmfh693eeq4c3hq6ah77syk
X-Rspam-User: 
X-HE-Tag: 1782108974-874318
X-HE-Meta: U2FsdGVkX1/JWYxBlmUfTN58G63NQDKke+NhZgRaYKFPC9NDeP1w9X4lYJfUeGlKKGGcgQBR+xKHwn4RKyb+Rm5cVvbnped9bcPGiyPz6lZNygIXE3pjLrPT5N3tEueNLV4Wz/9qXgB/onKVF1gZALHxGuGwVInrnZ+/HIfl5salSDfaA6Z3//yzYdU9Ob8uhCpzy1gk3g+U1XmZcNy7g2wN8nyc6fDfYDTSuOhxKoVFuFMzEUCZJV+6CQN06+MQT+GXZJU9SbuS8CNi+PKG3E7M0mW1QSWZXOKncYhklYeUYc/ABQLKJFi2IC7J32T4Elw8U6F3tgQ4b0FzBLT7exLnKQavaTCVt+JnystQZ4R8CmLMjeGZeeNekRxAeikXTwBYh1HLD8n7hidJ45Q/Q8epk47mMS2xvsmSZouxWUfDDIhN2+OMPgOfbVn773aTj63VfeXPRwZutAl11GO4VwtQGp6YBzUm7lz4/3ZD2cDv5DpROa1BPa5yWSjpU9wRiL8Xa2yWhvt0sOEXAvNqm7Eebw+0B1qs628NZX8sS+M5vPmg4uK2dUYUGij59qmf8oKseZNmspirD5zCD+Dc2r+BqZEFF7wyFI7LT8Xas7aIGE1uK+RZHu7mflDyJ7QSxp6KiEEyIBLOD0M3L5P5KYf0BG8LNs9CzHuxQIY/8Lxqr6+XWTVunrnE61ppbZJ6gvmjHUqyQDqtmMJ1bVXpi8sZ39vUGDF7oEST/hyVAZ0NEmtQw0nTp9WHj26xBX6TGGGpzjUx56FIqUZhYXP+xtzsQrsP6zwWC9UAv8sth6XBmJHDhG7HqBkAKjb01CC4CQcCH8qjxec6VM+dGRoeGtp6pDRvQfqSNZzYxA+q2TdvCv1dPANoUSVpZ+lkUuBdPEb6Qnnyqqn9gC+brxsshzZk4ZNOgLtfP3zoVOTETaXCCkrSRpM7AHxCTPxy/PF0w/6BHPzHdfUVxZp3lur
 Ea4hmcHo
 wzgzjVKZPSTRzALmYe8o2s0Z2/MSYI1SxOcwQn6mnvBpqxKkN6mETtkLrB3Nxwt8HZ4uiAPCb4ETTZOtlvkvsYzcTGqkdJ4ngqdPMl23ucx5aXmnTv4yrDZ949HY/kWeV4aN7oUTL6jD7Fgl7uObz/Z3wcQVwUiGjrxHdNAi0vBFfO/SBsTDvdm1j9ftUMqRT21yKichAGHkoOfPs8lIfgq0X8gmaTnOxqLmdKsu1LwaEvs6Xo49IhslPyyuVJ3XhSS4r2X7T5ue7Oy9CkezSLDulx9sBQSoyAML/kB3OIrd6+wYpyAb58A3S4iqXLKVk2pcooVC+qtYyuTm8cLmnvO1j2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/6/22 13:28, Alexei Starovoitov 写道:
> On Sun, Jun 21, 2026 at 9:06 PM Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
>>
>> From: chengkaitao <chengkaitao@kylinos.cn>
>>
>> The list_for_each*_safe() helpers are used when the loop body may remove
>> the current entry.  Their current interface, however, forces every caller
>> to define a temporary cursor outside the macro and pass it in, even when
>> the caller never uses that cursor directly.  For most call sites this
>> extra cursor is just boilerplate required by the macro implementation.
>>
>> This is awkward because the saved next pointer is an internal detail of
>> the iteration.  Callers that only remove or move the current entry do not
>> need to spell it out.
>>
>> The _safe() suffix has also caused confusion.  Christian Koenig pointed
>> out that the name is easy to read as a thread-safe variant, especially
>> for beginners, even though it only means that the iterator keeps enough
>> state to tolerate removal of the current entry.  He suggested _mutable()
>> as a clearer description of what the loop permits.
>>
>> Add *_mutable() iterator variants for list, hlist and llist.  The new
>> helpers are variadic and support both forms.  In the common case, the
>> caller omits the temporary cursor and the macro creates a unique internal
>> cursor with typeof(pos) and __UNIQUE_ID().  If a loop really needs an
>> explicit temporary cursor, the caller can still pass it and the helper
>> keeps the existing *_safe() behaviour.
>>
>> For example, a call site may use the shorter form:
>>
>>   list_for_each_entry_mutable(pos, head, member)
>>
>> or keep the explicit temporary cursor form:
>>
>>   list_for_each_entry_mutable(pos, tmp, head, member)
>>
>> The existing *_safe() helpers remain available for compatibility.  This
>> series only converts users in mm, block, kernel, init and io_uring.  If
>> this approach looks acceptable, the remaining users can be converted in
>> follow-up series.
>>
>> Changes in v3 (Christian König, Andy Shevchenko):
>> - Convert safe list walks to mutable iterators
>>
>> Changes in v2 (Muchun Song, Andy Shevchenko):
>> - Drop the list_for_each_entry_mutable*() helpers from v1 and make the
>>   cursor change directly in the existing list_for_each_entry*() helpers.
>> - Open-code special list walks that rely on updating the loop cursor in
>>   the body, preserving their existing traversal semantics.
>>
>> Link to v2:
>> https://lore.kernel.org/all/20260609061347.93688-1-kaitao.cheng@linux.dev/
>>
>> Link to v1:
>> https://lore.kernel.org/all/20260529082149.76764-1-kaitao.cheng@linux.dev/
>>
>> Kaitao Cheng (7):
>>   list: Add mutable iterator variants
>>   llist: Add mutable iterator variants
>>   mm: Use mutable list iterators
>>   block: Use mutable list iterators
>>   kernel: Use mutable list iterators
>>   initramfs: Use mutable list iterator
>>   io_uring: Use mutable list iterators
>>
>>  block/bfq-iosched.c                 |  17 +-
>>  block/blk-cgroup.c                  |  12 +-
>>  block/blk-flush.c                   |   4 +-
>>  block/blk-iocost.c                  |  18 +-
>>  block/blk-mq.c                      |   8 +-
>>  block/blk-throttle.c                |   4 +-
>>  block/kyber-iosched.c               |   4 +-
>>  block/partitions/ldm.c              |   8 +-
>>  block/sed-opal.c                    |   4 +-
>>  include/linux/list.h                | 269 ++++++++++++++++++++++++----
>>  include/linux/llist.h               |  81 +++++++--
>>  init/initramfs.c                    |   5 +-
>>  io_uring/cancel.c                   |   6 +-
>>  io_uring/poll.c                     |   3 +-
>>  io_uring/rw.c                       |   4 +-
>>  io_uring/timeout.c                  |   8 +-
>>  io_uring/uring_cmd.c                |   3 +-
>>  kernel/audit_tree.c                 |   4 +-
>>  kernel/audit_watch.c                |  16 +-
>>  kernel/auditfilter.c                |   4 +-
>>  kernel/auditsc.c                    |   4 +-
>>  kernel/bpf/arena.c                  |  10 +-
>>  kernel/bpf/arraymap.c               |   8 +-
>>  kernel/bpf/bpf_local_storage.c      |   3 +-
>>  kernel/bpf/bpf_lru_list.c           |  25 ++-
>>  kernel/bpf/btf.c                    |  18 +-
>>  kernel/bpf/cgroup.c                 |   7 +-
>>  kernel/bpf/cpumap.c                 |   4 +-
>>  kernel/bpf/devmap.c                 |  10 +-
>>  kernel/bpf/helpers.c                |   8 +-
>>  kernel/bpf/local_storage.c          |   4 +-
>>  kernel/bpf/memalloc.c               |  16 +-
>>  kernel/bpf/offload.c                |   8 +-
>>  kernel/bpf/states.c                 |   4 +-
>>  kernel/bpf/stream.c                 |   4 +-
>>  kernel/bpf/verifier.c               |   6 +-
>>  kernel/cgroup/cgroup-v1.c           |   4 +-
>>  kernel/cgroup/cgroup.c              |  54 +++---
>>  kernel/cgroup/dmem.c                |  12 +-
>>  kernel/cgroup/rdma.c                |   8 +-
>>  kernel/events/core.c                |  44 +++--
>>  kernel/events/uprobes.c             |  12 +-
>>  kernel/exit.c                       |   8 +-
>>  kernel/fail_function.c              |   4 +-
>>  kernel/gcov/clang.c                 |   4 +-
>>  kernel/irq_work.c                   |   4 +-
>>  kernel/kexec_core.c                 |   4 +-
>>  kernel/kprobes.c                    |  16 +-
>>  kernel/livepatch/core.c             |   4 +-
>>  kernel/livepatch/core.h             |   4 +-
>>  kernel/liveupdate/kho_block.c       |   4 +-
>>  kernel/liveupdate/luo_flb.c         |   4 +-
>>  kernel/locking/rwsem.c              |   2 +-
>>  kernel/locking/test-ww_mutex.c      |   2 +-
>>  kernel/module/main.c                |  11 +-
>>  kernel/padata.c                     |   4 +-
>>  kernel/power/snapshot.c             |   8 +-
>>  kernel/power/wakelock.c             |   4 +-
>>  kernel/printk/printk.c              |  11 +-
>>  kernel/ptrace.c                     |   4 +-
>>  kernel/rcu/rcutorture.c             |   3 +-
>>  kernel/rcu/tasks.h                  |   9 +-
>>  kernel/rcu/tree.c                   |   6 +-
>>  kernel/resource.c                   |   4 +-
>>  kernel/sched/core.c                 |   4 +-
>>  kernel/sched/ext.c                  |  22 +--
>>  kernel/sched/fair.c                 |  28 +--
>>  kernel/sched/topology.c             |   4 +-
>>  kernel/sched/wait.c                 |   4 +-
>>  kernel/seccomp.c                    |   4 +-
>>  kernel/signal.c                     |  11 +-
>>  kernel/smp.c                        |   4 +-
>>  kernel/taskstats.c                  |   8 +-
>>  kernel/time/clockevents.c           |   6 +-
>>  kernel/time/clocksource.c           |   4 +-
>>  kernel/time/posix-cpu-timers.c      |   4 +-
>>  kernel/time/posix-timers.c          |   3 +-
>>  kernel/torture.c                    |   3 +-
>>  kernel/trace/bpf_trace.c            |   4 +-
>>  kernel/trace/ftrace.c               |  49 +++--
>>  kernel/trace/ring_buffer.c          |  25 ++-
>>  kernel/trace/trace.c                |  12 +-
>>  kernel/trace/trace_dynevent.c       |   6 +-
>>  kernel/trace/trace_dynevent.h       |   5 +-
>>  kernel/trace/trace_events.c         |  35 ++--
>>  kernel/trace/trace_events_filter.c  |   4 +-
>>  kernel/trace/trace_events_hist.c    |   8 +-
>>  kernel/trace/trace_events_trigger.c |  17 +-
>>  kernel/trace/trace_events_user.c    |  16 +-
>>  kernel/trace/trace_stat.c           |   4 +-
>>  kernel/user-return-notifier.c       |   3 +-
>>  kernel/workqueue.c                  |  16 +-
>>  mm/backing-dev.c                    |   8 +-
>>  mm/balloon.c                        |   8 +-
>>  mm/cma.c                            |   4 +-
>>  mm/compaction.c                     |   4 +-
>>  mm/damon/core.c                     |   4 +-
>>  mm/damon/sysfs-schemes.c            |   4 +-
>>  mm/dmapool.c                        |   4 +-
>>  mm/huge_memory.c                    |   8 +-
>>  mm/hugetlb.c                        |  56 +++---
>>  mm/hugetlb_vmemmap.c                |  16 +-
>>  mm/khugepaged.c                     |  14 +-
>>  mm/kmemleak.c                       |   7 +-
>>  mm/ksm.c                            |  25 +--
>>  mm/list_lru.c                       |   4 +-
>>  mm/memcontrol-v1.c                  |   8 +-
>>  mm/memory-failure.c                 |  12 +-
>>  mm/memory-tiers.c                   |   4 +-
>>  mm/migrate.c                        |  23 ++-
>>  mm/mmu_notifier.c                   |   9 +-
>>  mm/page_alloc.c                     |   8 +-
>>  mm/page_reporting.c                 |   2 +-
>>  mm/percpu.c                         |  11 +-
>>  mm/pgtable-generic.c                |   4 +-
>>  mm/rmap.c                           |  10 +-
>>  mm/shmem.c                          |   9 +-
>>  mm/slab_common.c                    |  14 +-
>>  mm/slub.c                           |  33 ++--
>>  mm/swapfile.c                       |   4 +-
>>  mm/userfaultfd.c                    |  12 +-
>>  mm/vmalloc.c                        |  24 +--
>>  mm/vmscan.c                         |   7 +-
>>  mm/zsmalloc.c                       |   4 +-
>>  124 files changed, 875 insertions(+), 681 deletions(-)
> 
> Not sure what you were thinking, but this diff stat
> is not landable.

[PATCH v3 1/7] and [PATCH v3 2/7] contain the main logic and can
be merged directly. They are also compatible with the old API.
[PATCH v3 3/7] through [PATCH v3 7/7] are just simple interface
replacements and do not change any functional logic. They can be
left unmerged for now; individual modules can pick them up later
if needed.

In v2, Andy Shevchenko mentioned: "If it's done by Linus himself
during the day when he prepares -rc1, it's fine." Even so, the
changes in this patch series are indeed quite large and touch
almost every subsystem. I have only converted part of them for
now, so I wanted to send this out first and see what people think.

-- 
Thanks
Kaitao Cheng


