Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C8C7CDE002
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 12:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D3D96B0088; Wed, 24 Jun 2026 08:59:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1848C6B008A; Wed, 24 Jun 2026 08:59:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0740B6B008C; Wed, 24 Jun 2026 08:59:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFB7D6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 08:59:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 542181C203B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:59:17 +0000 (UTC)
X-FDA: 84914811954.22.5236159
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf09.hostedemail.com (Postfix) with ESMTP id 37CBA140007
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:59:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NfHfWAOU;
	spf=pass (imf09.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782305955;
	b=n+pmO3JGLbpo63Nf9Cx4FrO6PXLW+gV3bA2mWtcw21AWUA6gi5ePPtxG3uuBph9tNtdr2n
	Jkvn1yMBz5HGb5ClQ5nBhK0oQqtkxT6LwcPdwAmY34ENJwvRGM2g5t+JdCL0aZ09GUfKo9
	rHRXEsWc2TuKW2vqUZ4XSiq/dMzBfm4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782305955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w7mwncPJFc52L9GcJuLCemWszY1t/5oa8NDDGKNs5Xo=;
	b=3zO4bsVVQXrP2R/1fdTzsWkDSFRlGE0r5RiNgIHspw0WGHVjsVOTff3MG5KOcdObjS8VVB
	tZdULupkxldtqW5g+ROZA/m0QUD0wZ5yOAZX5RLcdblF3FHiz9jEwO9B2BTcbPys4jaI81
	/GIfifXWQkPNHonqAlFz8+TZ6jOnM5k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NfHfWAOU;
	spf=pass (imf09.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <dbfce6fd-1a70-49e4-84f0-f8abe0b0686d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782305952;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w7mwncPJFc52L9GcJuLCemWszY1t/5oa8NDDGKNs5Xo=;
	b=NfHfWAOUjme+ZS3K2cqW3zzBU9DDghXYBUACVwF1DP1IhHC7OpK5Dg+VG056EyHSeeXnq+
	d2hck8f1B4+5aF6WEjOXUu98tizJ3d/dkoetmJwOT+C8sRL9MoCoWbRSgtT56dE5GZhUKK
	23iu6/01orE+jSg9Lvj5Ccw4UnfNStE=
Date: Wed, 24 Jun 2026 20:58:49 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/7] Prepare mutable list iterators to cache cursor
 state
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
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
 chengkaitao <chengkaitao@kylinos.cn>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
 <CAADnVQJmPWFT01b7DuLdtafv=8FyB84GYHNZ8zSTck+9Aw0JpA@mail.gmail.com>
 <8f98a3a6-f97b-4673-964f-fb09c8879e2e@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <8f98a3a6-f97b-4673-964f-fb09c8879e2e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 37CBA140007
X-Stat-Signature: akuy5x5pegfsfa37p85knfdgnhirbdkj
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782305955-105645
X-HE-Meta: U2FsdGVkX1+EBFJnzbIj3Zr4GbYbj1wT+s9OIvvDKaD5OQ0p4NIMOlKYaHxu6jy0r1IEvNnnsgHLgJW2Zm4C8ASJ0O5pBC+dnKJDlE0G+8eAybzkPydMOlZeg4tOioPlPE+G6rZfZJA6Rw28XO1D826fR2pSNMVNu9r0HK7lZ0bIBmAAiabw3IJFZF13CqUl0ile9aQnAzmQyUfN/JgCUPPS+FhZDpCiG+IPoQtr++B+9I6iLn+0JywVd9JbpDPei6FzFJARR5m5VIzlKD/dk+/5nzxs78ioq8KqxhQ6WBLIu7NwG8uUWm3wkct9hXxFKeV/hcF+ZLF4ysGeTlSoImTbF+swbm91YwJGnzs1lULZYkSWdI8gxb+JQ/V1z0gzlUvNdu0bChyMWGJBCPudVUAL82c4MTjefiwx96r8CK5fbHfBl3Con6aEEIEO4VsfkGNmxdEw79ITFsATG4U/FCYMqzBrWNUsmqC1QDOcRNZSdNlC5tEcZgGpJFGCsEVoSgbN24TWCsXyXzcddHXJp4wp5uRtGpaVuRlQ240b+mkxt1rhDz9eYbBGsJRXiwsDNL7xr+FKd8qZDmdiI6NbDHwgBj2/jiJSprKxruTaaUWENTv3PJOIjyXjSziGCxeFXexI9eYg/BTJJbr4o6KUJXcqaBRzKYo76d3wwNFeLsdkYHfvZYDvkeC50ZZ+MnXpC80/XT7JKiXABMNmTPzTN9sSp6RoTc0VrmkmeTz6IBstTEgonNCKxa+SS3bvUdenRO2V3E38vKTaTUdwFVvLA1rIyKcLco0qOOqz5Om0w4XOvjCx+9b64F4hvCBroGzaXKzlTg89dAE8MLBi9jORTCoM2DQaf9+poYLqdqGi6cytrKc2s3oDMgreo9VpHwqubyfq40wZKNrUcJ5StkU8z2AMEJdNtOBv/iHylAxdjiqA505HAogsXoWkI3hFxU9QzCbQFaTSk6wcapT9AT/
 ECbbyM7A
 1b1EbVRBjXhjvvDVbbjO+OdgjqNKdv1riqoK3Osj0OnAFHxiIM9AnhaLJj7cr0ZssMzjDYBuiStWGZs1g6lIW5uZRvXaxwnWowYHrv5PPODhp8cfRUL8AZHgDlXwKqc+CJUtkOb4D6441k8CNt5YJ+DW7twyybSfZfvBs2V1Ibnx876E/o/HJcV+pz5QlHm8TKlRRKIzZUwrCBvCyKh71q56m8IwnV8+HVwwJYcbWYiFomATK4JL+7UptMX7LwoR8+p9rzzb7Ztfm66rzXiaryXUmDexkqJ9D+IOxqI/SElih4bvS3TbSgiRT8fu5LwL1czcL41oC25MV3jHCKcSiY1QDtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/6/22 19:27, David Hildenbrand (Arm) 写道:
> On 6/22/26 07:28, Alexei Starovoitov wrote:
>> On Sun, Jun 21, 2026 at 9:06 PM Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
>>>
>>> From: chengkaitao <chengkaitao@kylinos.cn>
>>>
>>> The list_for_each*_safe() helpers are used when the loop body may remove
>>> the current entry.  Their current interface, however, forces every caller
>>> to define a temporary cursor outside the macro and pass it in, even when
>>> the caller never uses that cursor directly.  For most call sites this
>>> extra cursor is just boilerplate required by the macro implementation.
>>>
>>> This is awkward because the saved next pointer is an internal detail of
>>> the iteration.  Callers that only remove or move the current entry do not
>>> need to spell it out.
>>>
>>> The _safe() suffix has also caused confusion.  Christian Koenig pointed
>>> out that the name is easy to read as a thread-safe variant, especially
>>> for beginners, even though it only means that the iterator keeps enough
>>> state to tolerate removal of the current entry.  He suggested _mutable()
>>> as a clearer description of what the loop permits.
>>>
>>> Add *_mutable() iterator variants for list, hlist and llist.  The new
>>> helpers are variadic and support both forms.  In the common case, the
>>> caller omits the temporary cursor and the macro creates a unique internal
>>> cursor with typeof(pos) and __UNIQUE_ID().  If a loop really needs an
>>> explicit temporary cursor, the caller can still pass it and the helper
>>> keeps the existing *_safe() behaviour.
>>>
>>> For example, a call site may use the shorter form:
>>>
>>>   list_for_each_entry_mutable(pos, head, member)
>>>
>>> or keep the explicit temporary cursor form:
>>>
>>>   list_for_each_entry_mutable(pos, tmp, head, member)
>>>
>>> The existing *_safe() helpers remain available for compatibility.  This
>>> series only converts users in mm, block, kernel, init and io_uring.  If
>>> this approach looks acceptable, the remaining users can be converted in
>>> follow-up series.
>>>
>>> Changes in v3 (Christian König, Andy Shevchenko):
>>> - Convert safe list walks to mutable iterators
>>>
>>> Changes in v2 (Muchun Song, Andy Shevchenko):
>>> - Drop the list_for_each_entry_mutable*() helpers from v1 and make the
>>>   cursor change directly in the existing list_for_each_entry*() helpers.
>>> - Open-code special list walks that rely on updating the loop cursor in
>>>   the body, preserving their existing traversal semantics.
>>>
>>> Link to v2:
>>> https://lore.kernel.org/all/20260609061347.93688-1-kaitao.cheng@linux.dev/
>>>
>>> Link to v1:
>>> https://lore.kernel.org/all/20260529082149.76764-1-kaitao.cheng@linux.dev/
>>>
>>> Kaitao Cheng (7):
>>>   list: Add mutable iterator variants
>>>   llist: Add mutable iterator variants
>>>   mm: Use mutable list iterators
>>>   block: Use mutable list iterators
>>>   kernel: Use mutable list iterators
>>>   initramfs: Use mutable list iterator
>>>   io_uring: Use mutable list iterators
>>>
>>>  block/bfq-iosched.c                 |  17 +-
>>>  block/blk-cgroup.c                  |  12 +-
>>>  block/blk-flush.c                   |   4 +-
>>>  block/blk-iocost.c                  |  18 +-
>>>  block/blk-mq.c                      |   8 +-
>>>  block/blk-throttle.c                |   4 +-
>>>  block/kyber-iosched.c               |   4 +-
>>>  block/partitions/ldm.c              |   8 +-
>>>  block/sed-opal.c                    |   4 +-
>>>  include/linux/list.h                | 269 ++++++++++++++++++++++++----
>>>  include/linux/llist.h               |  81 +++++++--
>>>  init/initramfs.c                    |   5 +-
>>>  io_uring/cancel.c                   |   6 +-
>>>  io_uring/poll.c                     |   3 +-
>>>  io_uring/rw.c                       |   4 +-
>>>  io_uring/timeout.c                  |   8 +-
>>>  io_uring/uring_cmd.c                |   3 +-
>>>  kernel/audit_tree.c                 |   4 +-
>>>  kernel/audit_watch.c                |  16 +-
>>>  kernel/auditfilter.c                |   4 +-
>>>  kernel/auditsc.c                    |   4 +-
>>>  kernel/bpf/arena.c                  |  10 +-
>>>  kernel/bpf/arraymap.c               |   8 +-
>>>  kernel/bpf/bpf_local_storage.c      |   3 +-
>>>  kernel/bpf/bpf_lru_list.c           |  25 ++-
>>>  kernel/bpf/btf.c                    |  18 +-
>>>  kernel/bpf/cgroup.c                 |   7 +-
>>>  kernel/bpf/cpumap.c                 |   4 +-
>>>  kernel/bpf/devmap.c                 |  10 +-
>>>  kernel/bpf/helpers.c                |   8 +-
>>>  kernel/bpf/local_storage.c          |   4 +-
>>>  kernel/bpf/memalloc.c               |  16 +-
>>>  kernel/bpf/offload.c                |   8 +-
>>>  kernel/bpf/states.c                 |   4 +-
>>>  kernel/bpf/stream.c                 |   4 +-
>>>  kernel/bpf/verifier.c               |   6 +-
>>>  kernel/cgroup/cgroup-v1.c           |   4 +-
>>>  kernel/cgroup/cgroup.c              |  54 +++---
>>>  kernel/cgroup/dmem.c                |  12 +-
>>>  kernel/cgroup/rdma.c                |   8 +-
>>>  kernel/events/core.c                |  44 +++--
>>>  kernel/events/uprobes.c             |  12 +-
>>>  kernel/exit.c                       |   8 +-
>>>  kernel/fail_function.c              |   4 +-
>>>  kernel/gcov/clang.c                 |   4 +-
>>>  kernel/irq_work.c                   |   4 +-
>>>  kernel/kexec_core.c                 |   4 +-
>>>  kernel/kprobes.c                    |  16 +-
>>>  kernel/livepatch/core.c             |   4 +-
>>>  kernel/livepatch/core.h             |   4 +-
>>>  kernel/liveupdate/kho_block.c       |   4 +-
>>>  kernel/liveupdate/luo_flb.c         |   4 +-
>>>  kernel/locking/rwsem.c              |   2 +-
>>>  kernel/locking/test-ww_mutex.c      |   2 +-
>>>  kernel/module/main.c                |  11 +-
>>>  kernel/padata.c                     |   4 +-
>>>  kernel/power/snapshot.c             |   8 +-
>>>  kernel/power/wakelock.c             |   4 +-
>>>  kernel/printk/printk.c              |  11 +-
>>>  kernel/ptrace.c                     |   4 +-
>>>  kernel/rcu/rcutorture.c             |   3 +-
>>>  kernel/rcu/tasks.h                  |   9 +-
>>>  kernel/rcu/tree.c                   |   6 +-
>>>  kernel/resource.c                   |   4 +-
>>>  kernel/sched/core.c                 |   4 +-
>>>  kernel/sched/ext.c                  |  22 +--
>>>  kernel/sched/fair.c                 |  28 +--
>>>  kernel/sched/topology.c             |   4 +-
>>>  kernel/sched/wait.c                 |   4 +-
>>>  kernel/seccomp.c                    |   4 +-
>>>  kernel/signal.c                     |  11 +-
>>>  kernel/smp.c                        |   4 +-
>>>  kernel/taskstats.c                  |   8 +-
>>>  kernel/time/clockevents.c           |   6 +-
>>>  kernel/time/clocksource.c           |   4 +-
>>>  kernel/time/posix-cpu-timers.c      |   4 +-
>>>  kernel/time/posix-timers.c          |   3 +-
>>>  kernel/torture.c                    |   3 +-
>>>  kernel/trace/bpf_trace.c            |   4 +-
>>>  kernel/trace/ftrace.c               |  49 +++--
>>>  kernel/trace/ring_buffer.c          |  25 ++-
>>>  kernel/trace/trace.c                |  12 +-
>>>  kernel/trace/trace_dynevent.c       |   6 +-
>>>  kernel/trace/trace_dynevent.h       |   5 +-
>>>  kernel/trace/trace_events.c         |  35 ++--
>>>  kernel/trace/trace_events_filter.c  |   4 +-
>>>  kernel/trace/trace_events_hist.c    |   8 +-
>>>  kernel/trace/trace_events_trigger.c |  17 +-
>>>  kernel/trace/trace_events_user.c    |  16 +-
>>>  kernel/trace/trace_stat.c           |   4 +-
>>>  kernel/user-return-notifier.c       |   3 +-
>>>  kernel/workqueue.c                  |  16 +-
>>>  mm/backing-dev.c                    |   8 +-
>>>  mm/balloon.c                        |   8 +-
>>>  mm/cma.c                            |   4 +-
>>>  mm/compaction.c                     |   4 +-
>>>  mm/damon/core.c                     |   4 +-
>>>  mm/damon/sysfs-schemes.c            |   4 +-
>>>  mm/dmapool.c                        |   4 +-
>>>  mm/huge_memory.c                    |   8 +-
>>>  mm/hugetlb.c                        |  56 +++---
>>>  mm/hugetlb_vmemmap.c                |  16 +-
>>>  mm/khugepaged.c                     |  14 +-
>>>  mm/kmemleak.c                       |   7 +-
>>>  mm/ksm.c                            |  25 +--
>>>  mm/list_lru.c                       |   4 +-
>>>  mm/memcontrol-v1.c                  |   8 +-
>>>  mm/memory-failure.c                 |  12 +-
>>>  mm/memory-tiers.c                   |   4 +-
>>>  mm/migrate.c                        |  23 ++-
>>>  mm/mmu_notifier.c                   |   9 +-
>>>  mm/page_alloc.c                     |   8 +-
>>>  mm/page_reporting.c                 |   2 +-
>>>  mm/percpu.c                         |  11 +-
>>>  mm/pgtable-generic.c                |   4 +-
>>>  mm/rmap.c                           |  10 +-
>>>  mm/shmem.c                          |   9 +-
>>>  mm/slab_common.c                    |  14 +-
>>>  mm/slub.c                           |  33 ++--
>>>  mm/swapfile.c                       |   4 +-
>>>  mm/userfaultfd.c                    |  12 +-
>>>  mm/vmalloc.c                        |  24 +--
>>>  mm/vmscan.c                         |   7 +-
>>>  mm/zsmalloc.c                       |   4 +-
>>>  124 files changed, 875 insertions(+), 681 deletions(-)
>>
>> Not sure what you were thinking, but this diff stat
>> is not landable.
> 
> Agreed. If we decide we want this, I guess we should target per-subsystem
> conversions.
> 
> If this goes through the MM tree, I would even appreciate doing this on a per-MM
> component granularity.
> 
> (unless we have some magic "Linus converts all of them" script, which I doubt we
> will have)

I strongly agree with the point above.

> Is there a way forward to replace list_for_each_*_safe entirely, possibly just
> reusing the old name but simply the parameter?

David Laight, Christian König, and Jani Nikula do not agree with using
clever macro syntax to support both calling forms at the same time,
so for now it is not possible to keep the original macro name and only
simplify the parameter. I may revert to the v1 version and ask everyone
for their opinions again.

-- 
Thanks
Kaitao Cheng


