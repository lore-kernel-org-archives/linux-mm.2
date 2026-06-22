Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1F4BCD98F6
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 04:06:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 713A96B0088; Mon, 22 Jun 2026 00:06:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C5226B008A; Mon, 22 Jun 2026 00:06:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B3E16B008C; Mon, 22 Jun 2026 00:06:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 234586B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 00:06:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BAE2D14054C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:06:41 +0000 (UTC)
X-FDA: 84906212202.06.D2645BE
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id E239A16000B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:06:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oHrwj+Sj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782101200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZUWyFEvXeVLfLgRyqSt5dzUpDWIXdvcmv/YrGiPhDm0=;
	b=mzHjDRbBiSAZwL1TydIdmA48VfeHkKP1OcPOF0CFZ5n/K/T8/GZncrVvIP3Clonrc95ePf
	5YkInEKZ5ZUJbNVusTBaYmy2BdmvU5QxWECFsVhEfX7MnPr19zNWRqK3hlolyvD9RNzH2r
	lC9idAZ1z0Yh5Skmyj+iN4w2TNw3YOk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782101200;
	b=n3fLzviVYwUHoDoQtynbvCBieOvFxd5MayMOdeGRxljwMiAqM8974OPkI/SMEwrkPwwS3H
	F2xRO+U2Fl47Uc2SSYsltkcs6v59GG3Ff27+ZUYhg45vE06uuPL1g+FqITAM4Jxg3GCATK
	fExRvEjUTuLSq5B4ysFzLVEhtva/6QY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oHrwj+Sj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782101196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZUWyFEvXeVLfLgRyqSt5dzUpDWIXdvcmv/YrGiPhDm0=;
	b=oHrwj+SjzLCSYGSoHMsBlTyi/BPO1LYEAowZCiJy/BgfowxK1Nhv4wBnxGATzNJAQy2Usu
	3Aui+a8Xl2VwYnUg4vaKt1jLEunHuuM12PdPzSO2e5i/XDE+X1RLFq1HeiZLctcF2EtPOU
	pEKF/++lDxrY0G4TuBJvKoXJ/NqYwTU=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Paul Moore <paul@paul-moore.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Cc: David Howells <dhowells@redhat.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Randy Dunlap <rdunlap@infradead.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Philipp Stanner <phasta@kernel.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-ntfs-dev@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	audit@vger.kernel.org,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	live-patching@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-pm@vger.kernel.org,
	rcu@vger.kernel.org,
	sched-ext@lists.linux.dev,
	linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	damon@lists.linux.dev,
	llvm@lists.linux.dev,
	chengkaitao <chengkaitao@kylinos.cn>
Subject: [PATCH v3 0/7] Prepare mutable list iterators to cache cursor state
Date: Mon, 22 Jun 2026 12:05:30 +0800
Message-ID: <20260622040533.29824-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Stat-Signature: c3jp4isjuzr9t959y8ry34ogq9mfqxk4
X-Rspamd-Queue-Id: E239A16000B
X-Rspam-User: 
X-HE-Tag: 1782101199-185960
X-HE-Meta: U2FsdGVkX192RMAVdevf5ZtHzT28w5+66j3yxzmjRplgFl2LEFhsjmxcVJWzFmEuN9edc2kX9whJaoFy/I99qM//tEkwbNJXdlBHyFj9xgd2x4nNzvsAlkc1skhB0hw7+h5xZioPrr5ce+mSraLry8VJqfVM6V+Jk7xh+rNoCqPqzfdGUwrl/qrerN7GpC99t7ZFb3eH5Gpgo8FB6Aj90065du4s075NLEJ0n/DgH8N/2rha3I9Jvv39Q2ksn9UjeMBtRvJTTXZdQFZbhgezkzA+eLwQF29vqZNAz1EN/yXXGZNqfQukJh9Ilven3kobzdpKymSzWjFK0Ji0E5Rq/RpjjQr/ZtoHXHZFiJR8U9Yc3y60u6auYBrvnuKhTU8UwCFIIU6bKWDFqwVgNd83z3LUbDYJJAyg9JLQNyJtfbJ7RAWfVYNuAtBZeHdtwEnHfo85FKqZEQ1/YcclEYAg2J01QLgrRA+Ypa1egx7yWpE31b5wuNGv0Qfym6/19J32imBAkcLtGleVPNBSsCl9+5ZM3P2sTDszng4YPs9wbbftUak7Quxtd7AK7rmgg7eobJZUo42qRXXeHQLt6RCEPe9VOvUubq33WikZ2PAWGuFYB9dgntWLAP9rj4bp5VsRa6TvD4qDTKtFd+MktPSvPKYEfdAIenl6g0QkDQ6rC1gzeWQIvRVSA06Lz+LrgCHPoXDPHNqZa6dWlds7/tL0/MpeP6HuGH65KWQ3o4z0lUgrMwruJocvR4ouJCLt8RH426c/WWfwpymZp3zhuOB0FGjuKAjfOmJ27NDsRiII1bFAGylVYC4sJcgOZZDwOU5OUtFWePsOKoeWMmNXrAM1zDvn+NOeydNYDT4G1sqZv4/uPXlSZR+7o0F8ofi6yOz7nwp3TTwOl0KAF/gq+DwVnCRD9EzZrkLAB+to3Htfg42qS+Ni68xhzd6Jj0V/aCt/EXWMgDH6iF/yhbYl+9w
 dwGgF+75
 Vn0hxnD6ePbQoWr8cMyxfcjtr1HNOESZEWyKBt5rXzhFWqH+HPJyOt8OObvm7Ax3WRo7PJn+6cnadmgQXQoquAu/83iRbMTkPcxlELOiBfnIsIvEI34tFiYl1HK2kuLQDv0+VYguyh/KS/dQdrbmW8AYhlYIdjQwMboDBh3WnK3Uq4m3FqQF/e1vuv4t/I5lNXy2Q7aqyelOJl18QlGQlWlYHm2wNqTDnaEnAC2XXw15gNmTX55hE0NtEUC/BzWIBI5nf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: chengkaitao <chengkaitao@kylinos.cn>

The list_for_each*_safe() helpers are used when the loop body may remove
the current entry.  Their current interface, however, forces every caller
to define a temporary cursor outside the macro and pass it in, even when
the caller never uses that cursor directly.  For most call sites this
extra cursor is just boilerplate required by the macro implementation.

This is awkward because the saved next pointer is an internal detail of
the iteration.  Callers that only remove or move the current entry do not
need to spell it out.

The _safe() suffix has also caused confusion.  Christian Koenig pointed
out that the name is easy to read as a thread-safe variant, especially
for beginners, even though it only means that the iterator keeps enough
state to tolerate removal of the current entry.  He suggested _mutable()
as a clearer description of what the loop permits.

Add *_mutable() iterator variants for list, hlist and llist.  The new
helpers are variadic and support both forms.  In the common case, the
caller omits the temporary cursor and the macro creates a unique internal
cursor with typeof(pos) and __UNIQUE_ID().  If a loop really needs an
explicit temporary cursor, the caller can still pass it and the helper
keeps the existing *_safe() behaviour.

For example, a call site may use the shorter form:

  list_for_each_entry_mutable(pos, head, member)

or keep the explicit temporary cursor form:

  list_for_each_entry_mutable(pos, tmp, head, member)

The existing *_safe() helpers remain available for compatibility.  This
series only converts users in mm, block, kernel, init and io_uring.  If
this approach looks acceptable, the remaining users can be converted in
follow-up series.

Changes in v3 (Christian König, Andy Shevchenko):
- Convert safe list walks to mutable iterators

Changes in v2 (Muchun Song, Andy Shevchenko):
- Drop the list_for_each_entry_mutable*() helpers from v1 and make the
  cursor change directly in the existing list_for_each_entry*() helpers.
- Open-code special list walks that rely on updating the loop cursor in
  the body, preserving their existing traversal semantics.

Link to v2:
https://lore.kernel.org/all/20260609061347.93688-1-kaitao.cheng@linux.dev/

Link to v1:
https://lore.kernel.org/all/20260529082149.76764-1-kaitao.cheng@linux.dev/

Kaitao Cheng (7):
  list: Add mutable iterator variants
  llist: Add mutable iterator variants
  mm: Use mutable list iterators
  block: Use mutable list iterators
  kernel: Use mutable list iterators
  initramfs: Use mutable list iterator
  io_uring: Use mutable list iterators

 block/bfq-iosched.c                 |  17 +-
 block/blk-cgroup.c                  |  12 +-
 block/blk-flush.c                   |   4 +-
 block/blk-iocost.c                  |  18 +-
 block/blk-mq.c                      |   8 +-
 block/blk-throttle.c                |   4 +-
 block/kyber-iosched.c               |   4 +-
 block/partitions/ldm.c              |   8 +-
 block/sed-opal.c                    |   4 +-
 include/linux/list.h                | 269 ++++++++++++++++++++++++----
 include/linux/llist.h               |  81 +++++++--
 init/initramfs.c                    |   5 +-
 io_uring/cancel.c                   |   6 +-
 io_uring/poll.c                     |   3 +-
 io_uring/rw.c                       |   4 +-
 io_uring/timeout.c                  |   8 +-
 io_uring/uring_cmd.c                |   3 +-
 kernel/audit_tree.c                 |   4 +-
 kernel/audit_watch.c                |  16 +-
 kernel/auditfilter.c                |   4 +-
 kernel/auditsc.c                    |   4 +-
 kernel/bpf/arena.c                  |  10 +-
 kernel/bpf/arraymap.c               |   8 +-
 kernel/bpf/bpf_local_storage.c      |   3 +-
 kernel/bpf/bpf_lru_list.c           |  25 ++-
 kernel/bpf/btf.c                    |  18 +-
 kernel/bpf/cgroup.c                 |   7 +-
 kernel/bpf/cpumap.c                 |   4 +-
 kernel/bpf/devmap.c                 |  10 +-
 kernel/bpf/helpers.c                |   8 +-
 kernel/bpf/local_storage.c          |   4 +-
 kernel/bpf/memalloc.c               |  16 +-
 kernel/bpf/offload.c                |   8 +-
 kernel/bpf/states.c                 |   4 +-
 kernel/bpf/stream.c                 |   4 +-
 kernel/bpf/verifier.c               |   6 +-
 kernel/cgroup/cgroup-v1.c           |   4 +-
 kernel/cgroup/cgroup.c              |  54 +++---
 kernel/cgroup/dmem.c                |  12 +-
 kernel/cgroup/rdma.c                |   8 +-
 kernel/events/core.c                |  44 +++--
 kernel/events/uprobes.c             |  12 +-
 kernel/exit.c                       |   8 +-
 kernel/fail_function.c              |   4 +-
 kernel/gcov/clang.c                 |   4 +-
 kernel/irq_work.c                   |   4 +-
 kernel/kexec_core.c                 |   4 +-
 kernel/kprobes.c                    |  16 +-
 kernel/livepatch/core.c             |   4 +-
 kernel/livepatch/core.h             |   4 +-
 kernel/liveupdate/kho_block.c       |   4 +-
 kernel/liveupdate/luo_flb.c         |   4 +-
 kernel/locking/rwsem.c              |   2 +-
 kernel/locking/test-ww_mutex.c      |   2 +-
 kernel/module/main.c                |  11 +-
 kernel/padata.c                     |   4 +-
 kernel/power/snapshot.c             |   8 +-
 kernel/power/wakelock.c             |   4 +-
 kernel/printk/printk.c              |  11 +-
 kernel/ptrace.c                     |   4 +-
 kernel/rcu/rcutorture.c             |   3 +-
 kernel/rcu/tasks.h                  |   9 +-
 kernel/rcu/tree.c                   |   6 +-
 kernel/resource.c                   |   4 +-
 kernel/sched/core.c                 |   4 +-
 kernel/sched/ext.c                  |  22 +--
 kernel/sched/fair.c                 |  28 +--
 kernel/sched/topology.c             |   4 +-
 kernel/sched/wait.c                 |   4 +-
 kernel/seccomp.c                    |   4 +-
 kernel/signal.c                     |  11 +-
 kernel/smp.c                        |   4 +-
 kernel/taskstats.c                  |   8 +-
 kernel/time/clockevents.c           |   6 +-
 kernel/time/clocksource.c           |   4 +-
 kernel/time/posix-cpu-timers.c      |   4 +-
 kernel/time/posix-timers.c          |   3 +-
 kernel/torture.c                    |   3 +-
 kernel/trace/bpf_trace.c            |   4 +-
 kernel/trace/ftrace.c               |  49 +++--
 kernel/trace/ring_buffer.c          |  25 ++-
 kernel/trace/trace.c                |  12 +-
 kernel/trace/trace_dynevent.c       |   6 +-
 kernel/trace/trace_dynevent.h       |   5 +-
 kernel/trace/trace_events.c         |  35 ++--
 kernel/trace/trace_events_filter.c  |   4 +-
 kernel/trace/trace_events_hist.c    |   8 +-
 kernel/trace/trace_events_trigger.c |  17 +-
 kernel/trace/trace_events_user.c    |  16 +-
 kernel/trace/trace_stat.c           |   4 +-
 kernel/user-return-notifier.c       |   3 +-
 kernel/workqueue.c                  |  16 +-
 mm/backing-dev.c                    |   8 +-
 mm/balloon.c                        |   8 +-
 mm/cma.c                            |   4 +-
 mm/compaction.c                     |   4 +-
 mm/damon/core.c                     |   4 +-
 mm/damon/sysfs-schemes.c            |   4 +-
 mm/dmapool.c                        |   4 +-
 mm/huge_memory.c                    |   8 +-
 mm/hugetlb.c                        |  56 +++---
 mm/hugetlb_vmemmap.c                |  16 +-
 mm/khugepaged.c                     |  14 +-
 mm/kmemleak.c                       |   7 +-
 mm/ksm.c                            |  25 +--
 mm/list_lru.c                       |   4 +-
 mm/memcontrol-v1.c                  |   8 +-
 mm/memory-failure.c                 |  12 +-
 mm/memory-tiers.c                   |   4 +-
 mm/migrate.c                        |  23 ++-
 mm/mmu_notifier.c                   |   9 +-
 mm/page_alloc.c                     |   8 +-
 mm/page_reporting.c                 |   2 +-
 mm/percpu.c                         |  11 +-
 mm/pgtable-generic.c                |   4 +-
 mm/rmap.c                           |  10 +-
 mm/shmem.c                          |   9 +-
 mm/slab_common.c                    |  14 +-
 mm/slub.c                           |  33 ++--
 mm/swapfile.c                       |   4 +-
 mm/userfaultfd.c                    |  12 +-
 mm/vmalloc.c                        |  24 +--
 mm/vmscan.c                         |   7 +-
 mm/zsmalloc.c                       |   4 +-
 124 files changed, 875 insertions(+), 681 deletions(-)

-- 
2.43.0


