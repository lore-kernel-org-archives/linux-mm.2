Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05C03CDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 12:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCC246B0088; Wed, 24 Jun 2026 08:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7C016B008A; Wed, 24 Jun 2026 08:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6BD56B008C; Wed, 24 Jun 2026 08:30:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 93DBD6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 08:30:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 09C6F120348
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:30:02 +0000 (UTC)
X-FDA: 84914738244.19.F8D8E4D
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id BD1ED1C000C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:29:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R0l5uaRB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782304200;
	b=ClbexMQ5SytCSx4hGnfipN8a0FFO29/8H+9GZkxXCia7s5fyXhncQUCCvZJ2G6oheMpa0j
	Pu2DIPp7IyMUXWTSW8ryDwg8AngG8oHG62G7FsoEvLdAeEEso7n6Kn+SOnEjwqN1pKG6HA
	xBhSOfsskzr3ZgbTrLHESouLpW0dk0Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782304200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eNfuHxO86n8b93ev9jYNFJxXkathlRXlXpz1k/8S9nI=;
	b=FoQ3jpaCLhlx0N9azjZFr3YjNWAPnXlbym+NpZwF7KYWIQc7abihyDpIpBWywhrdzZgHDa
	YriQ6QVw9M1JD/XOgbxn7TI2geNcjZEjvzxENB9O+BURw7c56R7OCkuW1hdANdEO7qtnhE
	dUfvAiy+yH2IjawIiD3BQg+lTf38bnY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R0l5uaRB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
Message-ID: <f99b70cc-e11c-42a9-a986-d20b3f232a31@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782304195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eNfuHxO86n8b93ev9jYNFJxXkathlRXlXpz1k/8S9nI=;
	b=R0l5uaRBMcxiN2aXXeE7sJmbbWZ+nIwvYOIBg2hW4xeZNywWJj11l3PcvXG3Ip7YlbinqT
	P/PQ6kfAvOv13VlW7fdMv2tpC85uXP91R5VJRz9HOOc6aZfnOL/SuWOVvCXI8elJq6bVmX
	Hq88NW9qj4aWnLm21y4nDBq7fAgYa9M=
Date: Wed, 24 Jun 2026 20:29:26 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/7] Prepare mutable list iterators to cache cursor
 state
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Tejun Heo <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Paul Moore <paul@paul-moore.com>, "Paul E. McKenney" <paulmck@kernel.org>,
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
 <8c8f1849-86d3-4c69-be27-30bbdffdf616@linux.dev>
 <ajkSftEbdGoiJXYs@ashevche-desk.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <ajkSftEbdGoiJXYs@ashevche-desk.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BD1ED1C000C
X-Stat-Signature: kksjmbdc69ctj9esugn8sk85hwb7th8t
X-HE-Tag: 1782304199-23107
X-HE-Meta: U2FsdGVkX1+whYHWsd9KGwHvSWiKb9gYDDqj6Lh3F+Pu1WebDBoLGNDDQx3gMwkJ3xyNkn+O4RpSZdLZFvZPdsxHZYg6RFCcnx17eP1qh4AhtvNjr7FpTu3RK23w5mtCT04+cMQ+W2DFA4YQEagnssC7pXDLYTb3BYDjbG7U73Wn0mJlVAbwbLahrXGd1MKj62y1prevckRJuHCouoya13m1p1dj7j1BDQ3GEhWOKldDxvfErUFvLuZ4RJgvwNRykEN9sabJEL1K6s2zaoQ2JadNKKxCAkd2ybDZQLRH60EmQ1Sd2NYrcKARVonB4TtOr5EBdyzarQtCzz/i7zrtr5FpWpmq9MTiEly+Avkj3y89kIMeGyWxQDafOYkSn5kmeAJRU5VxxVjzsCsysFUn9+WBFz2O+Qw2SUAxZwln+VoWgTS8/EZHNlbFDhow+zn9UvPaP7Osh0jCD4lD9bj+00eBnoB6nJvUAuM8S1IKvzMNRRMUwEU+YQl2sxn1xgN3cvasH1LhMhC3rv6F/b2bv5q99k5kPeGByiu0ohsSAY7TidXw/LJET8F6suKN2wne3g+/yZtrt/cow5iWhoeHApXC4624Jqwb0IiT3ohkPpDwRDPCmiXS0+8eRKFZezzVPZUC7i1WqfwxJqQMA7OXugvtlhQH3X1CpuIK2P96llYPsu/7S0XA95PaggpFvMJWoV0bkWMowjnXFgfwywK7gUkPimj+JgUxXGGV9c6XEhbTOCbi0ETgFtnyGTlDbp6nfA/JsZcAeFZMozEovQWYgYSbB1vwxnFQApCnLGhvEdzLQHEg1CMJ7KZ8F+coQuvpKhG8a1H0Eg/GWrUykpchDe6WdEvxyxlklotPddU13SjgW+26QSnUa4qj3EnE0j1WvQez6srhgKVAndruqQnEQKPCuV+9wC0GK1w0TM4Mp7WI4tEfBrNmY09gyF3U7G5/FD1+zr3n5r9nsf1A+vY
 kH672PPf
 hQfcmA25aUMskFLpEM18IRHpuJd/vB4ZBDlvEFFpkFbj1hgNdxCsGyzGJDSmOVpK57gscUwq+WKrS98NYFXrRxL03IzfMImDDIKB0tkoQ9NsP9us60QcFggKWh/Hv5G+uPtyBW3rnuTJhpIDz+FMN2top6zSdoXCyz4CmVpRNx3v9JUdou4Mkknu4VDiYW/l+Fa7PP2h5etVtLIxcr4qRL9aywYbn2RrwW70Q4NObl4yMNAr0qcdSwXm4qgCkPlNupYKfBPXG2LWoq8NgrrdAZFSe1YOSrq0cgoT6G8xB9fgP+hSMbM1d4/qYKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/6/22 18:46, Andy Shevchenko 写道:
> On Mon, Jun 22, 2026 at 02:15:01PM +0800, Kaitao Cheng wrote:
>> 在 2026/6/22 13:28, Alexei Starovoitov 写道:
>>> On Sun, Jun 21, 2026 at 9:06 PM Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> 
> ...
> 
>>>>  block/bfq-iosched.c                 |  17 +-
>>>>  block/blk-cgroup.c                  |  12 +-
>>>>  block/blk-flush.c                   |   4 +-
>>>>  block/blk-iocost.c                  |  18 +-
>>>>  block/blk-mq.c                      |   8 +-
>>>>  block/blk-throttle.c                |   4 +-
>>>>  block/kyber-iosched.c               |   4 +-
>>>>  block/partitions/ldm.c              |   8 +-
>>>>  block/sed-opal.c                    |   4 +-
>>>>  include/linux/list.h                | 269 ++++++++++++++++++++++++----
>>>>  include/linux/llist.h               |  81 +++++++--
>>>>  init/initramfs.c                    |   5 +-
>>>>  io_uring/cancel.c                   |   6 +-
>>>>  io_uring/poll.c                     |   3 +-
>>>>  io_uring/rw.c                       |   4 +-
>>>>  io_uring/timeout.c                  |   8 +-
>>>>  io_uring/uring_cmd.c                |   3 +-
>>>>  kernel/audit_tree.c                 |   4 +-
>>>>  kernel/audit_watch.c                |  16 +-
>>>>  kernel/auditfilter.c                |   4 +-
>>>>  kernel/auditsc.c                    |   4 +-
>>>>  kernel/bpf/arena.c                  |  10 +-
>>>>  kernel/bpf/arraymap.c               |   8 +-
>>>>  kernel/bpf/bpf_local_storage.c      |   3 +-
>>>>  kernel/bpf/bpf_lru_list.c           |  25 ++-
>>>>  kernel/bpf/btf.c                    |  18 +-
>>>>  kernel/bpf/cgroup.c                 |   7 +-
>>>>  kernel/bpf/cpumap.c                 |   4 +-
>>>>  kernel/bpf/devmap.c                 |  10 +-
>>>>  kernel/bpf/helpers.c                |   8 +-
>>>>  kernel/bpf/local_storage.c          |   4 +-
>>>>  kernel/bpf/memalloc.c               |  16 +-
>>>>  kernel/bpf/offload.c                |   8 +-
>>>>  kernel/bpf/states.c                 |   4 +-
>>>>  kernel/bpf/stream.c                 |   4 +-
>>>>  kernel/bpf/verifier.c               |   6 +-
>>>>  kernel/cgroup/cgroup-v1.c           |   4 +-
>>>>  kernel/cgroup/cgroup.c              |  54 +++---
>>>>  kernel/cgroup/dmem.c                |  12 +-
>>>>  kernel/cgroup/rdma.c                |   8 +-
>>>>  kernel/events/core.c                |  44 +++--
>>>>  kernel/events/uprobes.c             |  12 +-
>>>>  kernel/exit.c                       |   8 +-
>>>>  kernel/fail_function.c              |   4 +-
>>>>  kernel/gcov/clang.c                 |   4 +-
>>>>  kernel/irq_work.c                   |   4 +-
>>>>  kernel/kexec_core.c                 |   4 +-
>>>>  kernel/kprobes.c                    |  16 +-
>>>>  kernel/livepatch/core.c             |   4 +-
>>>>  kernel/livepatch/core.h             |   4 +-
>>>>  kernel/liveupdate/kho_block.c       |   4 +-
>>>>  kernel/liveupdate/luo_flb.c         |   4 +-
>>>>  kernel/locking/rwsem.c              |   2 +-
>>>>  kernel/locking/test-ww_mutex.c      |   2 +-
>>>>  kernel/module/main.c                |  11 +-
>>>>  kernel/padata.c                     |   4 +-
>>>>  kernel/power/snapshot.c             |   8 +-
>>>>  kernel/power/wakelock.c             |   4 +-
>>>>  kernel/printk/printk.c              |  11 +-
>>>>  kernel/ptrace.c                     |   4 +-
>>>>  kernel/rcu/rcutorture.c             |   3 +-
>>>>  kernel/rcu/tasks.h                  |   9 +-
>>>>  kernel/rcu/tree.c                   |   6 +-
>>>>  kernel/resource.c                   |   4 +-
>>>>  kernel/sched/core.c                 |   4 +-
>>>>  kernel/sched/ext.c                  |  22 +--
>>>>  kernel/sched/fair.c                 |  28 +--
>>>>  kernel/sched/topology.c             |   4 +-
>>>>  kernel/sched/wait.c                 |   4 +-
>>>>  kernel/seccomp.c                    |   4 +-
>>>>  kernel/signal.c                     |  11 +-
>>>>  kernel/smp.c                        |   4 +-
>>>>  kernel/taskstats.c                  |   8 +-
>>>>  kernel/time/clockevents.c           |   6 +-
>>>>  kernel/time/clocksource.c           |   4 +-
>>>>  kernel/time/posix-cpu-timers.c      |   4 +-
>>>>  kernel/time/posix-timers.c          |   3 +-
>>>>  kernel/torture.c                    |   3 +-
>>>>  kernel/trace/bpf_trace.c            |   4 +-
>>>>  kernel/trace/ftrace.c               |  49 +++--
>>>>  kernel/trace/ring_buffer.c          |  25 ++-
>>>>  kernel/trace/trace.c                |  12 +-
>>>>  kernel/trace/trace_dynevent.c       |   6 +-
>>>>  kernel/trace/trace_dynevent.h       |   5 +-
>>>>  kernel/trace/trace_events.c         |  35 ++--
>>>>  kernel/trace/trace_events_filter.c  |   4 +-
>>>>  kernel/trace/trace_events_hist.c    |   8 +-
>>>>  kernel/trace/trace_events_trigger.c |  17 +-
>>>>  kernel/trace/trace_events_user.c    |  16 +-
>>>>  kernel/trace/trace_stat.c           |   4 +-
>>>>  kernel/user-return-notifier.c       |   3 +-
>>>>  kernel/workqueue.c                  |  16 +-
>>>>  mm/backing-dev.c                    |   8 +-
>>>>  mm/balloon.c                        |   8 +-
>>>>  mm/cma.c                            |   4 +-
>>>>  mm/compaction.c                     |   4 +-
>>>>  mm/damon/core.c                     |   4 +-
>>>>  mm/damon/sysfs-schemes.c            |   4 +-
>>>>  mm/dmapool.c                        |   4 +-
>>>>  mm/huge_memory.c                    |   8 +-
>>>>  mm/hugetlb.c                        |  56 +++---
>>>>  mm/hugetlb_vmemmap.c                |  16 +-
>>>>  mm/khugepaged.c                     |  14 +-
>>>>  mm/kmemleak.c                       |   7 +-
>>>>  mm/ksm.c                            |  25 +--
>>>>  mm/list_lru.c                       |   4 +-
>>>>  mm/memcontrol-v1.c                  |   8 +-
>>>>  mm/memory-failure.c                 |  12 +-
>>>>  mm/memory-tiers.c                   |   4 +-
>>>>  mm/migrate.c                        |  23 ++-
>>>>  mm/mmu_notifier.c                   |   9 +-
>>>>  mm/page_alloc.c                     |   8 +-
>>>>  mm/page_reporting.c                 |   2 +-
>>>>  mm/percpu.c                         |  11 +-
>>>>  mm/pgtable-generic.c                |   4 +-
>>>>  mm/rmap.c                           |  10 +-
>>>>  mm/shmem.c                          |   9 +-
>>>>  mm/slab_common.c                    |  14 +-
>>>>  mm/slub.c                           |  33 ++--
>>>>  mm/swapfile.c                       |   4 +-
>>>>  mm/userfaultfd.c                    |  12 +-
>>>>  mm/vmalloc.c                        |  24 +--
>>>>  mm/vmscan.c                         |   7 +-
>>>>  mm/zsmalloc.c                       |   4 +-
>>>>  124 files changed, 875 insertions(+), 681 deletions(-)
>>>
>>> Not sure what you were thinking, but this diff stat
>>> is not landable.
>>
>> [PATCH v3 1/7] and [PATCH v3 2/7] contain the main logic and can
>> be merged directly. They are also compatible with the old API.
>> [PATCH v3 3/7] through [PATCH v3 7/7] are just simple interface
>> replacements and do not change any functional logic. They can be
>> left unmerged for now; individual modules can pick them up later
>> if needed.
>>
>> In v2, Andy Shevchenko mentioned: "If it's done by Linus himself
>> during the day when he prepares -rc1, it's fine."
> 
> Yes, but you need to get his blessing first to go with this.
> Have you communicated with him on this?

Not yet, because the overall approach is still not mature. People
have different opinions on the implementation details and on how
to move this forward, so I think we should iterate through a few
versions first before making a final decision.

>> Even so, the
>> changes in this patch series are indeed quite large and touch
>> almost every subsystem. I have only converted part of them for
>> now, so I wanted to send this out first and see what people think.
> 
> That's why it's better to provide a script to convert (e.g., coccinelle)
> instead of tons of patches.

I tried writing conversion scripts with Coccinelle, but there were
always cases that got missed. In contrast, I found that using AI
for focused replacements was actually more efficient.

As David Hildenbrand mentioned, "If we decide we want this, I guess
we should target per-subsystem conversions." I would like to provide
the new interface first; adapting each subsystem on demand later may
be easier to achieve.
-- 
Thanks
Kaitao Cheng


