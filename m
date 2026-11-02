Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 345B5606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 19:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=gT92ilfw
Received: by kanga.kvack.org (Postfix)
	id 26F826B05B2; Mon,  2 Nov 2026 14:07:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21FD66B05B3; Mon,  2 Nov 2026 14:07:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04D826B05B5; Mon,  2 Nov 2026 14:07:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9B256B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:07:34 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1BC2280221
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:07:34 +0000 (UTC)
X-FDA: 85391112828.12.ECA4721
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf13.hostedemail.com (Postfix) with ESMTP id 874832000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:07:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=gT92ilfw;
	spf=pass (imf13.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793646452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=facLPGn/+qga3YSbDc6N/+NwNj3uIaPlZZmodCVjN5M=;
	b=ExxL53zCxYun53PV6ZPyNb0hyhXa5fJ7LZRpwAlxoFoSVvqIc+s6da9uZctNALumzcnDSr
	2jx46Lp3dbAKplbQ0HUiTQbZrcM39ed4JWcZdTFmq1MfXmx9d/Qh9Qznj0bwY6eMCfii8f
	k0VX/UM5RmF2yLFeX+jqwJK3H/1dI1Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793646452;
	b=JQGJyIQ6MvrWSZmoxIAymQVEgpLclpdZFf90kXwUR04N5bHuvTPY/rg5IezHGoGceF8BR1
	xkKK4Q3uByq6Dpvq8g7oxWJw1D+/sEZvOMnOkUjtfuiAMSXBd4S0Oa0hFurAeOYOStTASG
	sogkPSiMgosFkpNV1pj9xU4EHDFZ6IY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=gT92ilfw;
	spf=pass (imf13.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793646451;
	bh=facLPGn/+qga3YSbDc6N/+NwNj3uIaPlZZmodCVjN5M=;
	h=From:To:Cc:Subject:Date:From;
	b=gT92ilfwMYKwFYfzeRNQR7LnWOZ16CQNsLHfz9YkzqPez3sTVG+8HUP4/BBPZpTVF
	 Ne3ibJfMLq6H3XdMqR9ZoksF10NEEEtkRe0dvgrWWWSd/XGEtKH9ePN9xgM7svBYJb
	 IyeE7U6j8vXIX9ZCG3YoiE61ACa0dji5d06q05oLPcvjjQSLXMy4aY/QDdxgMljiPV
	 WOX1pSN981/KJHRCNyeVrBVU6OMFIi5aQl12mU8msQmKXk7o5V5FS1oa8HKi+Uo93M
	 kuKa96RdpnO07Z6wY3YMpHYSVsiLkcL6f4Q580rn5YCb4rqjq/nqJyPtlr55ncwuPJ
	 hRzNbwSySlKfg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jJLmz3T8pzJpy;
	Mon, 02 Nov 2026 14:07:31 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Hildenbrand <david@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>,
	christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	David Carlier <devnexen@gmail.com>,
	Josh Law <objecting@objecting.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-doc@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	linux-trace-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Oleg Nesterov <oleg@redhat.com>
Subject: [RFC PATCH v23 00/10] Hierarchical Percpu Counters for RSS
Date: Mon,  2 Nov 2026 14:06:58 -0500
Message-Id: <20261102190708.1287100-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: sdhoe1ro4fqsqgnku6hapecrq45znts9
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 874832000C
X-Rspam-User: 
X-HE-Tag: 1793646452-873411
X-HE-Meta: U2FsdGVkX186AuES1dMCzKIdolSyTc+EiM0r7qGAH77CNmWu6IsXf3gP0HfMsjojS36DLQF8Q1YHfG0137behszq73WYrIQNgtXxOHqKdo/AgaoAhT9vvoFHZ4QNUAQBiVLq06JtH8ZpHRUG5zyiRURplOd/BLFkHpPdNmIv1c26TQORy4yooBi2hJeTGNxkWMUMozwCSKPWaI5522VP3g3w/M17b9G26kjyi2Z2RwxyWRq7DAWav0jO9KX7PE6xoOBOpmay9uD58sjpJ8QbMA6cjmwCex52iKQEFuEeMMH6terGTZJ0nXQWjGrfPcu52/h2iBEu3ho9zMzGvattR+QXB24ZEjw7qJWuNdSQ4syDzg7Iinoh2Mu4628MbzeBwPqSixwxLqLa3X09oEkjxCfyoHW9llq3Jqd37rcMbBUU+eK6yTSs/8f/a9o/NzpKH7FGaV2mUW3zGZF3UsThunMxqkP76w6PphhJ7VnqHe1MVw7Ua6/ODCh3szO5aYvYgKQCK92o3BeHPmSErHSpf0z0Dn6K2/x/YIm3fco0YVyUtblcStFhjcWS2Re7yE6MkG7qChCZeuoFYxu7WeC1dL1PyBAfsuccAcPCFCSmpsXECth5k9UAyRupT7XDfGtLqPm9TSmug24uEd5mFTC2Wj79W8cfxcruKy7WoooGnkXk7DWyrEQfBJ5EsAMq5q1W9OupExWOAkPq0fOPu+W10MRXZ6gQ+/GW3OEo6ZyCwXbowh70fCOKa1f/aqEetZQmsSd4vqDGN9HosCEHxv4T4V2eCur+4GhT98D6QLKOJgbRc3KxQIxD8FXrzqVXbOW0HthJi6KEw5FtARHXgqF11QQB5sC35X2Ib9HzJUw8L48TaPbITxP98DleVqVUC/oq0OQ/PuQc9oQ9OpVO4T1/vY9+cxvMJT3Pyr1jntp9W9FaimYXf8uj0f/9nVJVLVzhewiNWLOWmibuFYQQSFi
 6dO4gqh4
 Brs1RMpZorMtRcFmhV/2QtmuXpLp1e/TP7QVpnBGo/GhYOT/0ubDBSd6eJd5GqujTT/Zq0H05ALhqRJMjVnX1M5S2uDWz6mPShu+qMjSFDt2uJ77nK7OFp4z02YvgtSIlPT+mjMRDnTt0WVG0GaB7CLG1oNH4gzf8uTgMgRET2upcQgG2924/srjcxzVLxgddFq8rKHqkfAEF9vlGuGixhkV0WG3kl5pqwEn4wewntXGabCol1vMsfbafHzilPXezjqaTx1Ey7+EHNuAU8imY4LIX4otMSk+jB4OSedGLk2+LA2eWe5juAbXhfpcKTgltyFRDXFpc/fOzDUJpjGTHjlSy1sl14XKlJUjvFWmuSzbdKJDNCS1/OVCbKGRJ2Jp5L8GBJj3fD8VqfAAjKb1DLgnkrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

Here is the hierarchical per-cpu counters series for the RSS counters,
based on v7.4-rc1.  It is an RFC because of the questions at the end,
and because of the significant changes since v22 [1], notably the
per-cpu counter size (long -> byte), the configuration heuristics, and
the lazy activation introduced by patches 6 and 7.

The problem
-----------

Since commit f1a7941243c1 ("mm: convert mm's rss stats into
percpu_counter"), the RSS counters are struct percpu_counter with a
batch size of max(32, 2 * nr_cpus): their approximation error grows with
O(nr_cpus^2), up to 1.1GB per counter at 384 logical CPUs.
/proc/PID/status, /proc/PID/statm and the OOM killer moved to precise
sums (commits 82241a83cd15 and 5898aa8f9a0b), but the other readers
still use the approximation: the RSS high watermark (VmHWM, the
ru_maxrss reported as "Maximum resident set size" by /usr/bin/time -v,
taskstats), /proc/PID/stat (ps, top, monitoring agents), the taskstats
RSS-time integral (coremem, sampled at each tick), NUMA balancing and
the mark_victim tracepoint.  On the test machine below, the
/proc/PID/stat RSS of a test process was off by 17MB while
single-threaded, and by up to 134MB with 64 threads.

Precise sums cannot fix the high watermark or the RSS-time integral:
update_hiwater_rss() samples the RSS on every unmap path, and the
integral at each tick, while a precise sum reads every possible CPU,
about 4us per counter at 384 logical CPUs.  A smaller struct
percpu_counter batch takes the counter spinlock on every carry: at batch
32, an update of the counters of a shared mm costs 4.4 to 69us with one
thread per CPU, compared to 26ns to 1.2us with this series.

The series
----------

Patches 1 to 5 replace struct percpu_counter for the RSS counters with
hierarchical per-cpu counters: per-cpu bytes carry into a tree of atomic
counters shaped at boot from nr_cpu_ids, with a fixed batch of 32, an
error bound in O(n*log(n)) and no global lock.  Each level carries only
once its residual reaches the batch in either direction, so updates
going back and forth around a boundary do not climb the tree.  The
comparison functions have no user in this series; a follow-up will use
them for a faster OOM killer task selection.

Patches 6 and 7 keep the RSS counters of single-threaded processes exact
and without per-cpu memory: until a second thread shares the mm, the
task running on the mm adds to the bias of each counter without atomic
instructions, and other tasks add to its atomic bias, both read in O(1).
Creating the second thread allocates the per-cpu counters and tree
items, and activates the tree.  struct percpu_counter cannot do this as
is: its count is an s64 under a raw spinlock, which the remote updates
(reclaim, khugepaged, remote GUP) would then take.

Patches 8 to 10 are the tools to tune the tree shape on other hardware:
the percpu_counter_tree.arity= and rss_stat_batch= boot parameters, and
a KUnit benchmark.  The default shapes were measured on one machine,
with up to 384 logical CPUs, so results from other hardware are welcome.

Results
-------

2-socket AMD EPYC 9654, 192 cores, 384 logical CPUs with SMT (the CPU
counts in this letter are logical CPUs, as in nr_cpu_ids), tree 8,8,8,
batch 32, whole series; details in patches 3 and 7.  The bare-metal
results were measured on v7.3: the rebase onto v7.4-rc1 had no conflict,
and the hpcc update costs of the series as sent, measured in a pinned
384-vCPU guest, match the bare-metal ones within 2%.

  Accuracy per counter: bound, and largest |approximate - precise| seen
  by get_mm_counter() while a process hops across all CPUs doing
  mmap/munmap of 1 to 16 pages (384-vCPU KVM guest pinned to the host):

                                        hpcc   upstream
    bound                            158.5MB      1.1GB
    measured, single-threaded      0 (exact)      841MB
    measured, with a second thread      96MB      845MB

  Update cost, ns per update per thread, one thread per CPU, bare metal
  (mm: the 4 counters of one mm; private: one counter per thread; batch
  32: local change of the benchmark, bound 46.5MB):

                                              upstream   upstream
                                       hpcc  batch 768   batch 32
    mm, +1                               26        288       4370
    mm, random +-32                     135        385      69171
    mm, random +-512                   1174      20229      69186
    private, random +-32                 31         20          -

  /proc/PID/statm read with 1000 to 16000 processes, bare metal:
  5.3-6.5us vs 16.5-19.0us for single-threaded processes, on par for
  multi-threaded ones (14.4-16.0us vs 14.5-17.1us, guest).  fork + exit
  of a single-threaded child: 116us vs 139us.  will-it-scale
  page_fault1, 2 and 3: no regression (-0.6% to +5.1%, one boot each,
  the upstream one on the previous day).

  Memory per mm, counting the slab objects of mm_struct and of the tree
  items, and the per-cpu memory of the RSS counters, in bytes (guest,
  v7.4-rc1):

                  single-threaded   threaded   upstream
    16 CPUs                  1820       1948       2076
    384 CPUs                 1928       8145       8072
    1024 CPUs                2185      17204      18569

  The tree items are allocated with the per-cpu counters when the second
  thread is created, and the mm_struct slab object keeps its upstream
  size.

Behavior changes
----------------

- The allocation of the per-cpu counters and tree items moves from
  fork() to the second thread (clone() with CLONE_VM, without
  CLONE_VFORK), which can then fail with -ENOMEM.
- mm_struct gains rss_owner, the task running on the mm, compared with
  current and never dereferenced, and rss_stat_mutex, which serializes
  the activations of the tree, as mm_cid.mutex serializes the mode
  changes of mm_cid at fork and exit.
- The precise sums (/proc/PID/status, /proc/PID/statm, the OOM killer)
  take no lock: under concurrent updates of a multi-threaded process,
  they can miss a carry on its way up the tree, where upstream counts
  each concurrent update either whole or not at all.  They are exact for
  a process at rest.
- The rss_stat tracepoint reports the approximation (patch 5): exact for
  single-threaded processes, within the bound otherwise.
- Like struct percpu_counter, the tree is sized at boot and not
  reshaped on hotplug; its shape and bound depend on nr_cpu_ids, while
  the default upstream batch follows the online CPUs.

Caveats
-------

- From 33 to 39 CPUs, up to 1.37 times less accurate than upstream.
- The tree is shaped for the number of CPUs rounded up to a power of 2:
  just above a power of 2, the RSS counters of a threaded process, with
  rss_owner and the mutex, use up to 1.50 times the memory of upstream
  (129 CPUs, 1.28 times at 65 and 1.38 times at 257), compared to at
  most 0.90 times at a power of 2, and 1.02 times at 384 logical CPUs.
- Private counters with random +-32 updates: 31ns vs 20ns, the price of
  a 7 times tighter bound.
- A multi-threaded process which ran on few CPUs can hold more error
  than upstream: 2047 pages per CPU path vs 767 at 384 logical CPUs.  A
  follow-up could index the counters by concurrency ID (mm_cid) instead
  of CPU, so the accuracy bound and the precise sums would scale with
  the concurrency the process uses.
- Before activation, concurrent remote updates of a single-threaded
  process contend on one atomic per counter.
- The second thread allocates per-cpu memory, which the per-cpu
  allocator serializes, as it does upstream at every fork: with 384
  threads at once, init + destroy of 4 counters takes 874us per
  operation (1004us upstream, 6.0us alone).  Tree item slab objects
  owning their per-cpu counters, with slab destructors, could avoid it.
- The accuracy was measured in a guest, with a debug patch and a test
  program which are not part of the series.  The bound is analytic and
  tested in both directions.

Changes since v22 [1]
---------------------

- Per-cpu byte counters with hysteresis, updated with
  this_cpu_try_cmpxchg(); the tree items of counters initialized
  together share cache lines; the library allocates the per-cpu
  counters and tree items, so struct percpu_counter_tree has a fixed
  size of 40 bytes, like struct percpu_counter, and mm_struct no longer
  embeds tree items.
- Flat tree up to 32 CPUs, 16,4 up to 64, fan-out 8 beyond, with a root
  fan-out of 16 when one order remains (8,16 at 128 CPUs, 8,8,16 at
  1024).
- New patches 6 and 7, for single-threaded processes.
- Fixed approximation margins in the comparison functions; hysteresis
  on the intermediate levels, so the accuracy range is exact and
  symmetric.
- Userspace test of every tree configuration, KUnit tests on per-CPU
  workqueues, Sashiko review comments, MAINTAINERS entry.

Testing: every commit builds without warnings on x86_64 (SMP and UP),
arm64, ppc64le and 32-bit powerpc, sparse adds no warnings, KUnit passes
on bare metal (v7.3) and in guests with 1, 16 and 384 vCPUs, the
userspace test passes on simulated topologies up to 65536 CPUs, and the
RSS counters match a page table walk from 1 to 64 threads.  KUnit and
the RSS check also pass with lockdep (PROVE_LOCKING) in guests with 16
and 64 vCPUs, without report.

Starting from v22, which I wrote, an LLM coding assistant drove the
implementation of this revision from my design decisions: it wrote the
code, the tests, the benchmark and the measurement scripts, ran the
measurements in guests and prepared the bare-metal ones, and drafted the
comments, the changelogs and this letter.  I made the design decisions,
reviewed every change and directed the rework through my review
comments.

Questions
---------

1. Is mm->rss_owner acceptable, or would you prefer current->mm == mm
   (without PF_KTHREAD) and an "activated" flag?
2. Is moving the -ENOMEM from fork() to the second thread acceptable?
3. Would you rather take the single-threaded mode first, on its own?
4. Should the rss_stat tracepoint report the approximation, stay
   precise, or report both?
5. Should the tuning tools be merged, built only with the benchmark
   config, or dropped later?  Who could run them on non-AMD, 4-socket,
   arm64 or POWER machines?
6. Is tools/testing/hpcc the right home for the topology test?

Thanks,

Mathieu

[1] https://lore.kernel.org/lkml/20260227153730.1556542-1-mathieu.desnoyers@efficios.com/

Mathieu Desnoyers (10):
  lib: introduce hierarchical per-cpu counters
  lib: test hierarchical per-cpu counters
  mm: use hierarchical per-cpu counters for the RSS counters
  tools/testing/hpcc: add userspace test of hierarchical per-CPU
    counters
  mm: report the approximate RSS in the rss_stat tracepoint
  lib: percpu_counter_tree: add lazy tree activation
  mm: keep the RSS counters of single-threaded processes exact
  lib: percpu_counter_tree: add the arity boot parameter
  mm: add the rss_stat_batch boot parameter
  lib: add a benchmark of hierarchical per-cpu counters

 .../admin-guide/kernel-parameters.txt         |   24 +
 Documentation/core-api/index.rst              |    1 +
 .../core-api/percpu-counter-tree.rst          |  145 ++
 MAINTAINERS                                   |   12 +
 fs/exec.c                                     |    5 +
 include/linux/mm.h                            |   28 +-
 include/linux/mm_types.h                      |   19 +-
 include/linux/percpu_counter_tree.h           |  365 +++++
 include/trace/events/kmem.h                   |    3 +-
 init/main.c                                   |    3 +
 kernel/exit.c                                 |    3 +
 kernel/fork.c                                 |   61 +-
 lib/Kconfig                                   |   27 +
 lib/Makefile                                  |    1 +
 lib/percpu_counter_tree.c                     | 1450 +++++++++++++++++
 lib/tests/Makefile                            |    3 +
 lib/tests/percpu_counter_tree_bench.c         |  604 +++++++
 lib/tests/percpu_counter_tree_kunit.c         | 1050 ++++++++++++
 tools/testing/hpcc/.gitignore                 |    2 +
 tools/testing/hpcc/Makefile                   |   18 +
 tools/testing/hpcc/include/hpcc_shim.h        |  203 +++
 tools/testing/hpcc/include/kunit/visibility.h |    2 +
 tools/testing/hpcc/include/linux/args.h       |    4 +
 tools/testing/hpcc/include/linux/atomic.h     |    2 +
 tools/testing/hpcc/include/linux/bug.h        |    2 +
 tools/testing/hpcc/include/linux/cache.h      |    2 +
 tools/testing/hpcc/include/linux/cpumask.h    |    2 +
 tools/testing/hpcc/include/linux/errno.h      |    3 +
 tools/testing/hpcc/include/linux/limits.h     |    2 +
 tools/testing/hpcc/include/linux/math.h       |    2 +
 .../testing/hpcc/include/linux/moduleparam.h  |   12 +
 tools/testing/hpcc/include/linux/percpu.h     |    2 +
 .../hpcc/include/linux/percpu_counter_tree.h  |    2 +
 tools/testing/hpcc/include/linux/preempt.h    |    2 +
 tools/testing/hpcc/include/linux/slab.h       |    2 +
 tools/testing/hpcc/main.c                     |  536 ++++++
 36 files changed, 4592 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/core-api/percpu-counter-tree.rst
 create mode 100644 include/linux/percpu_counter_tree.h
 create mode 100644 lib/percpu_counter_tree.c
 create mode 100644 lib/tests/percpu_counter_tree_bench.c
 create mode 100644 lib/tests/percpu_counter_tree_kunit.c
 create mode 100644 tools/testing/hpcc/.gitignore
 create mode 100644 tools/testing/hpcc/Makefile
 create mode 100644 tools/testing/hpcc/include/hpcc_shim.h
 create mode 100644 tools/testing/hpcc/include/kunit/visibility.h
 create mode 100644 tools/testing/hpcc/include/linux/args.h
 create mode 100644 tools/testing/hpcc/include/linux/atomic.h
 create mode 100644 tools/testing/hpcc/include/linux/bug.h
 create mode 100644 tools/testing/hpcc/include/linux/cache.h
 create mode 100644 tools/testing/hpcc/include/linux/cpumask.h
 create mode 100644 tools/testing/hpcc/include/linux/errno.h
 create mode 100644 tools/testing/hpcc/include/linux/limits.h
 create mode 100644 tools/testing/hpcc/include/linux/math.h
 create mode 100644 tools/testing/hpcc/include/linux/moduleparam.h
 create mode 100644 tools/testing/hpcc/include/linux/percpu.h
 create mode 100644 tools/testing/hpcc/include/linux/percpu_counter_tree.h
 create mode 100644 tools/testing/hpcc/include/linux/preempt.h
 create mode 100644 tools/testing/hpcc/include/linux/slab.h
 create mode 100644 tools/testing/hpcc/main.c


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.47.3


