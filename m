Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C95F606D826
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 19:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=mhUBTmZ/
Received: by kanga.kvack.org (Postfix)
	id 26DA46B05B8; Mon,  2 Nov 2026 14:07:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1855B6B05BA; Mon,  2 Nov 2026 14:07:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA3926B05B8; Mon,  2 Nov 2026 14:07:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 95FAF6B05B7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:07:36 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 54469120215
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:07:34 +0000 (UTC)
X-FDA: 85391112828.05.900E8C4
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8CE124000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:07:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="mhUBTmZ/";
	spf=pass (imf04.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793646452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UdZq/CR4H+fUSd5Op8EkOgOWcjIdVAwSd8f/jayAjsg=;
	b=FpjT7J+OwKMu49UebjhJeubX0v1zWVfZcC11UtYBreRRAunL2pmq45Q0TM0k/aMHrpBfXk
	bcRiDtvqkWqMe9IzyN1HUAqlG13Lm83irkDIp25YvxFs4pReGGsIfFjfeaSUmUCReAZKmx
	Gm3V5NGLTPZwU71dAdtkmcCS8ogXJC0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793646452;
	b=zf0vmQmwvM55u0gQ9a2bgyveYv56pb5IZPl6fbtz6czlH6BD71yhRhaplD7UjmMAqkCsCd
	mpMkA38SNuct0kOMieJIeVHEj26sjGZg4syGiRkoepH4+Z17zMpdkleFNgKvuMqvSLJI9q
	/EKHxm48jb+i+rIzxVtispXV9Vv5IdI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="mhUBTmZ/";
	spf=pass (imf04.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793646451;
	bh=UdZq/CR4H+fUSd5Op8EkOgOWcjIdVAwSd8f/jayAjsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mhUBTmZ/xHvzk7Pb2MIGzDqDzgc/Dc6zJNYxp8u/CBuQLHK7ndWmFbJ5yk2QWGk/c
	 0m1S9PJTMgU17DcxNX3ce2DGKrqtzt2v1/yrKWBu6VKfMGlkWUhuO8JLjocLvDnbmM
	 5ExP0dVBCRAiUW188Me4oeaCfBJd15ryGsQEuUwyHQ+fI1X5OUEmDSahIBPd9Y4mwF
	 A8tSMj9b4vv0zMKwSclquR3yBDbeHqESo/3OwuYiX1YTYIw1ZAagy6ixOp0Dgi74sN
	 33Z+7UVXRM9fJ3r/HbU/t4fP0Uzdfs2I9F1EcVatWcmJWQKWcTdrozn/BkvyIFGUf3
	 SrioTpWFJ0fBQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jJLmz531WzJLW;
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
Subject: [RFC PATCH v23 01/10] lib: introduce hierarchical per-cpu counters
Date: Mon,  2 Nov 2026 14:06:59 -0500
Message-Id: <20261102190708.1287100-2-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261102190708.1287100-1-mathieu.desnoyers@efficios.com>
References: <20261102190708.1287100-1-mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 9z7d5w8rwxrro1jmrbjb6znfn5ts7qoq
X-Rspamd-Queue-Id: 8CE124000C
X-Rspam-User: 
X-HE-Tag: 1793646452-578049
X-HE-Meta: U2FsdGVkX18cMwqTrH/WHDEp0WAoWtCyzIFzvFguLfKGCZCcxxCcuW79eC9Cc6pnRudiSOSv6DXhPy5upyPI948aDOe78Z0N6vXmRNyZ8rRM2a+KC4aHscJ7zYvw3hARDUk5F4qnJiS5JHj6/4pOs4It0tQ8mC4N+IaRyIz0+ox9GIFu6CVOV0vBdl3HAGlFFjKZsrXhgxJJL+3pgWI8oJovm1v7+j1n0FxUnsZuf7sbrIAkSk/Wb+i7Ubtqet9wfOJ4NAUcd8RksgFttV1vmR/hFYoW3nKtBXR1FVM0qENKMrkNAXbyLjI8gV/gguTLnWRPSM9SchY3BHXgGJrHfdJh5VTWEbWz+F3hjIVuchMVErN9PFivAnzXvX9bZCexI+f1Cny00rR+vMpDJndz2faBhiNihjDukE7FuqmdeGtctk6S+zXfldiqR+qQSkl0rOOAm28kb/GxlYGCVDwoDCvCr1XNLpPHbTrWAPK89NPcMx4sDL46CnKdmX3upan8D+2uoMJYZ32FzEkkaReum6Fn7JV3wdIlCDpgTO2igZIR+VYtI2gJDQHDERr9f1xYkvn4K7ZqgiTdfZ1/bWKSFO4IxXPcR1dMLl/4+8SesnulMPFa2TPOWk495RNAwVwaVmS7Wt7Y/GpxJTPxTOReWeVRdD1ja9bejA+KN6T+8wegtCS6xH0cK07n0cR+dSykoMaLrPE2pYpu3W18+QMa5ndKj0jTx+RJHsRCmIm2LopumLpN6XYFNEufmcHVd2s/IU5OgEtPRXrAn4YAzMtdrQO5mVFM0824H1dmlNje+I1ES0h8EFDiFIuXrGbl/CMA+rEMrWc38JlD53ckO9KyyYUzMaWq+a6JgKa8x/nVbmj/FmwwX0V0hVlETR/jlukJi6d8bJMmAk19bOBBuvedYxjRsXvmGvOrPKQ7fvSMhaz11m8HJcz+piXCP14rGRrzgyWhTQ47ZxN/D8mVnVQ
 o7CTgPd+
 M53dqk4bwE31WJis9QAefxLDbDkosG8dRrWv5CwrSSi7Ec8lTfwlvKaxcpwhZNX1frpFbXiJVPHq5TEIc/uzCfXlEn17GldyDLwAVngvNzmoGCufOaMTRAPKuELOx6SaP6gw35awPqd1LKa7Vj6gExWRN9L6FSB28D+T//hLQSeqG/kx/xvpolQ+QwBvJCwMa1Z6IueoryN4CAn6nqPop9aatAg5YMK4+SJ8TV8PNpQ9Jar3t1UZesM7mVx2SbXwzYESCuzH1BV1+ZG5UMO3JVUelEObZydGohCsNjV9Z3E7bQAfMGiAaI7L5Kd8aCID7S9dYJ0K6zNPnhMSP98RJCOORmpbmLPYyCIgAGkAlDbn5zcHo2/gXwHG8UuCUc/v84VBslpBDeIiK48dT5pWF11ZnOdytt0aNf6ELFSR6TsPlhwG/Ej4F/QGzP541ZwJFDjB5wZADDVnPrSZaXV0K3ajSuwpG4cDtZ2Y/SYEORTj1jiPnKDav20ystXYmZqQyTxA4c8UapL5Io8JZtEkKg6+vE/ZvBYNFRC42gNdAyjB84bACJr0gzA5ok9nH0vfGr2cmigZ18kaT44mhVvhleZpWmUI0z7q6RYcqybxLNFu2WUFx204fMklMDKstG6+FBj/DwLKDfgN7MGW8Guo0in2d2np0rZhfC81RJoM1/iA6mhaKJ29DDzFTQg9T0j6KER6DPkC0to5q9RUX/LnrzRouYGnG1pFfaJBJLfsehG1UzfBzY3U0pbRLXTHmxsIzF62ubNVHr8XSyMPAxn0nOcxEwHgR2qXp2kjUBCX9v6MycEXTNPKTcHrpiBf2ybOhBbJCMfPI8Hy2h8dwv9oo7NxxyPiDnatGbsSpl7o2p4qupIDIRwRJO3amrBJZ+fKXXbzyp1HMYT0i/Rb6wdk/bi492cNSZV7saZnc0bverZ/mIyzFXVdxLJosEw9/Zr0P37nvNdIKGmPbPSUw9dGnLoEqzUQf
 EMsq/bwU
 D5IALpMb6SBVoEyUhk8Qey+W7Wb6xN4fGIcFno4WgLD7ZMU2ZqJXL0duTk2IxrCiQB7p5gNMVhLCnu1CqV1DBnQ2foeOY7Hy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Introduce hierarchical per-cpu counters, struct percpu_counter_tree: a
split counter whose approximate sum stays within a fixed bound of its
precise sum, without taking a global lock on updates.  They are meant
for counters updated from many CPUs whose approximation is read often,
such as the RSS counters of an mm.  A following patch uses them for the
RSS counters, to bound their inaccuracy on large many-core systems [1].

* Motivation

The purpose of this hierarchical split-counter scheme is to:

- Minimize contention when incrementing and decrementing counters,
- Provide fast access to a sum approximation,
- Provide a sum approximation with an acceptable accuracy level when
  scaling to many-core systems.
- Provide approximate and precise comparison of two counters, and
  between a counter and a value.
- Provide possible precise sum ranges for a given sum approximation.

* Design

The hierarchical per-CPU counters propagate a sum approximation through an
N-way tree.  When reaching the batch size, the carry is propagated up the
tree, whose fan-out at each level is selected at boot from nr_cpu_ids.  The
batch size of each level is the batch size of the prior level multiplied by
the prior level's fan-out.

The following diagram illustrates the propagation with 8 CPUs through a
binary tree.  This is not an actual configuration: at 8 CPUs, the
default tree is flat (see the default shapes below).  CPU c propagates
into item (c & (L - 1)) of a level holding L items, so the CPUs are
listed in bit-reversed order:

Level 3:  0  (root)
          |   \
          |         \
          |               \
Level 2:  0                   1
          | \                 | \
          |    \              |    \
          |       \           |       \
Level 1:  0         2         1         3
          | \       | \       | \       | \
          |  \      |  \      |  \      |  \
          |   \     |   \     |   \     |   \
Level 0:  0    4    2    6    1    5    3    7

Each counter below the root keeps a residual: once it reaches its batch
size in either direction, it propagates its multiples of the batch size
and subtracts them, which leaves a residual within (-batch, +batch).
This hysteresis absorbs updates going back and forth around a batch size
boundary, instead of propagating them up to the root on each update.
The residual moves in steps of the counter's input: 1 for the per-cpu
counters, which receive the updates, and BATCH(N - 1), the batch size of
the level below, for the counters of level N, which only receive its
carries.  The largest residual is therefore batch - 1 at level 0, and
BATCH(N) - BATCH(N - 1) at level N.  The approximate sum is the precise
sum minus the residuals, so it is within the same distance of the
precise sum in both directions:

  accuracy = nr_cpu_ids * (batch - 1) +
             sum(N >= 1) (BATCH(N) - BATCH(N - 1)) * nr_items(N)

The level 0 per-cpu counters are signed bytes, updated with a
this_cpu_try_cmpxchg() loop, which limits the batch size to 128.

Up to 32 CPUs, the tree is flat: the per-cpu counters propagate directly
to the root, like struct percpu_counter.  From 33 to 64 CPUs, the
per-cpu counters propagate to 4 intermediate counters, each shared by up
to 16 CPUs, so the carries of all CPUs do not contend on the root.
Beyond, each level has a fan-out of 8: a remaining order of 1 gives the
root a fan-out of 16, and a remaining order of 2 adds a level with a
fan-out of 4 below the root.  With a fixed batch size, the maximum
inaccuracy grows with O(n*log(n)) as the number of CPUs increases,
compared to O(n^2) for struct percpu_counter, whose batch size grows
with the number of CPUs.  For example, at 384 logical CPUs with a batch
size of 32, the bound is 40576, compared to 294528 for a struct
percpu_counter with its default batch size of 768.

* CPU hotplug

Like the per-cpu data of struct percpu_counter, the tree is sized at
boot, and is not reshaped on CPU hotplug.  The level 0 residual of an
offline CPU stays in place: the precise sum still reads it, and the
bound, computed from nr_cpu_ids, still holds.  Unlike the default batch
size of struct percpu_counter, which follows the number of online CPUs,
the bound does not shrink when fewer CPUs are online.  When the possible
CPUs are sparse, the tree is still shaped for nr_cpu_ids, the highest
possible CPU number plus one, and the bound also counts the level 0
residuals of the missing CPUs: it holds, but cannot be reached.

* Memory Use

Each counter uses a 32-byte struct percpu_counter_tree, one byte of
per-cpu data per possible CPU, and its tree items.
percpu_counter_tree_init_many() allocates the per-cpu data and the tree
items, whose sizes depend on the number of possible CPUs and on
nr_cpu_ids, so struct percpu_counter_tree has a fixed size.  The items
at the same tree position of all the counters initialized together are
packed in a cache line aligned block, so a set of counters updated
together, such as the 4 RSS counters of an mm, shares cache lines
without false sharing between CPUs updating different branches of the
tree.  When the items of a tree position fit in a cache line, the tree
items come from a slab cache created by
percpu_counter_tree_subsystem_init(), which runs once the slab allocator
is up.

The memory use of nr_counters initialized together, up to 8, on a
64-bit arch with 64-byte cache lines is:

  nr_counters * 32 + ALIGN(nr_counters, 4) * nr_possible_cpus
  + nr_items * 64

as the per-cpu allocator rounds sizes up to 4 bytes.  The tree is shaped
for nr_cpu_ids rounded up to a power of 2: nr_items is 1 (the root) up
to 32 CPUs, 5 up to 64, 17 up to 128, 41 up to 256, 73 up to 512, 145 up
to 1024 and 585 up to 4096.  In comparison, a struct percpu_counter uses
40 bytes and 4 bytes of per-cpu data per possible CPU.

For a set of 4 counters, the hierarchical counters use less memory than
as many struct percpu_counter from 3 to 64 CPUs, and beyond when the
number of CPUs is a power of 2 (at most 0.89 times as much).  Between
powers of 2, fewer CPUs share the cost of the tree items: 0.94 to 1.09
times at 3 * 2^n CPUs (96, 192, 384, ...), and up to 1.47 times just
above a power of 2 (129 CPUs).  A lone counter uses one item of each
cache line: 3.0 to 3.5 times the memory of a struct percpu_counter when
the number of CPUs is a power of 2 beyond 64, and up to 5.7 times just
above.

Link: https://lkml.kernel.org/r/20260227153730.1556542-1-mathieu.desnoyers@efficios.com
Link: https://lore.kernel.org/lkml/20250331223516.7810-2-sweettea-kernel@dorminy.me/ # [1]
Link: https://lkml.kernel.org/r/20260227153730.1556542-2-mathieu.desnoyers@efficios.com
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Martin Liu <liumartin@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: christian.koenig@amd.com
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: David Carlier <devnexen@gmail.com>
Cc: Josh Law <objecting@objecting.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
---
Changes since v22:
- Refactor configuration table, remove duplicated definitions,
  document heuristic, add table content validation, run by the KUnit
  and userspace tests.
- Allocate the per-cpu counters and the tree items in
  percpu_counter_tree_init_many(), instead of taking tree items from
  the caller: remove percpu_counter_tree_items_size(),
  PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE and the items argument of the
  init functions.  struct percpu_counter_tree has a fixed size of 32
  bytes, down from 64.
- Call percpu_counter_tree_subsystem_init() after mm_core_init(), once
  its boot parameters are parsed and slab is up, before the first
  counter is used, and warn about counters initialized before it.
- Use signed bytes for the level 0 per-cpu counters, with the same
  hysteresis as the intermediate levels, updated with a
  this_cpu_try_cmpxchg() loop. Limit the batch size to 128.
- Pack the tree items of the counters initialized together by
  percpu_counter_tree_init_many() in cache lines, allocated from a slab
  cache when the items of a tree position fit in one cache line.
- Use a flat tree up to 32 CPUs, a fan-out of 16 then 4 from 33 to 64
  CPUs to keep the carries of all CPUs from contending on the root, and
  a fan-out of 8 beyond, with a root fan-out of 16 for a remaining order
  of 1, to match the memory footprint and accuracy of struct
  percpu_counter at low CPU counts and bound the inaccuracy with
  O(n*log(n)) at high CPU counts.
- Print the tree shape at boot.
- Document that the accuracy range is a property of settled counters.
  (Reported by Sashiko.)
- Add a diagram of the approximation ranges above compare_delta().
  (Reported by Sashiko.)
- Introduce wrapped_delta(), and document that comparisons are valid
  only for counters differing by less than LONG_MAX. (Reported by
  Sashiko.)
- Fix the direction of the approximation margins in the comparison
  functions. They were swapped, which returned wrong definitive answers
  when 2^arity of a level exceeds the batch size (batch size 2 from 9
  CPUs, batch size 4 from 65 CPUs).
- Add hysteresis to the intermediate tree levels: they keep a residual
  within (-batch, +batch) of their level, and only propagate once it
  reaches their batch size, so updates going back and forth around a
  batch size boundary no longer propagate up to the root on each
  update.
- Replace percpu_counter_tree_approximate_accuracy_range() and its
  "under" and "over" ranges by a single accuracy, the exact bound of the
  residuals, which is the same in both directions:
  percpu_counter_tree_approximate_accuracy().
- Add percpu_counter_tree_check_residuals() for the tests: it checks the
  residuals of the intermediate counters, and that no carry was lost
  or duplicated.
- Extract the carries of the intermediate counters with a cmpxchg on
  the value returned by the addition, so concurrent updaters never
  subtract a carry computed from a stale residual, and explain why
  relaxed ordering is sufficient.
- Read the level 0 counters with READ_ONCE() in the precise sum.
- Document that percpu_counter_tree_set() must not run concurrently
  with updates.
- Add the documentation to the core-api toctree.
- Fix the propagation diagram to match the CPU to item mapping.
- Mark boot-time topology state __ro_after_init, use pr_err().
- Validate the batch size on UP as on SMP.
- Fix the sign of the !CONFIG_SMP value comparisons, and compare on
  the wrapped difference as on SMP.
- Add a MAINTAINERS entry.
- Fix checkpatch warnings.
- Fix documentation typos.
---
 Documentation/core-api/index.rst              |    1 +
 .../core-api/percpu-counter-tree.rst          |  109 ++
 MAINTAINERS                                   |    9 +
 include/linux/percpu_counter_tree.h           |  292 +++++
 init/main.c                                   |    3 +
 lib/Makefile                                  |    1 +
 lib/percpu_counter_tree.c                     | 1119 +++++++++++++++++
 7 files changed, 1534 insertions(+)
 create mode 100644 Documentation/core-api/percpu-counter-tree.rst
 create mode 100644 include/linux/percpu_counter_tree.h
 create mode 100644 lib/percpu_counter_tree.c

diff --git a/Documentation/core-api/index.rst b/Documentation/core-api/index.rst
index 92f91c6a0d79..fe03cefc1734 100644
--- a/Documentation/core-api/index.rst
+++ b/Documentation/core-api/index.rst
@@ -48,6 +48,7 @@ Library functionality that is used throughout the kernel.
    generic-radix-tree
    packing
    this_cpu_ops
+   percpu-counter-tree
    timekeeping
    errseq
    wrappers/atomic_t
diff --git a/Documentation/core-api/percpu-counter-tree.rst b/Documentation/core-api/percpu-counter-tree.rst
new file mode 100644
index 000000000000..6b381deacd83
--- /dev/null
+++ b/Documentation/core-api/percpu-counter-tree.rst
@@ -0,0 +1,109 @@
+.. SPDX-License-Identifier: GPL-2.0+ OR MIT
+
+========================================
+The Hierarchical Per-CPU Counters (HPCC)
+========================================
+
+:Author: Mathieu Desnoyers
+
+Introduction
+============
+
+Counters come in many varieties, each with their own trade offs:
+
+ * A global atomic counter provides a fast read access to the current
+   sum, at the expense of cache-line bouncing on updates. This leads to
+   poor performance of frequent updates from various cores on large SMP
+   systems.
+
+ * A per-cpu split counter provides fast updates to per-cpu counters,
+   at the expense of a slower aggregation (sum). The sum operation needs
+   to iterate over all per-cpu counters to calculate the current total.
+
+The hierarchical per-cpu counters attempt to provide the best of both
+worlds (fast updates, and fast sum) by relaxing requirements on the sum
+accuracy. It allows quickly querying an approximated sum value, along
+with the possible min/max ranges of the associated precise sum. The
+exact precise sum can still be calculated with an iteration on all
+per-cpu counters, but the availability of an approximated sum value with
+possible precise sum min/max ranges allows eliminating candidates which
+are certainly outside of a known target range without the overhead of
+precise sums.
+
+Overview
+========
+
+The hierarchical per-cpu counters are organized as a tree with the
+per-cpu counters as its first level and the tree root as its last
+level.
+
+The intermediate tree levels contain carry propagation counters. When
+reaching a threshold (batch size), the carry is propagated up the
+tree.
+
+Each counter below the root, from the per-cpu counters up, keeps the
+residual it has not propagated yet, and only propagates once this
+residual reaches its batch size in either direction. This hysteresis
+prevents updates going back and forth around a batch size boundary from
+propagating further up the tree each time.
+
+This allows reading an approximated value at the root, which has a
+bounded accuracy determined by the tree topology and the batch size:
+the precise sum is within the same distance of the approximation in
+both directions. This bound grows as O(nr_cpus * log(nr_cpus)).
+
+The per-cpu counters are bytes, which limits the batch size to 128. The
+tree positions are cache line aligned to prevent false sharing between
+CPUs updating different branches of the tree. A tree position holds the
+items of all the counter trees initialized together by
+percpu_counter_tree_init_many(), so a set of counters updated together,
+such as the RSS counters of an mm, shares cache lines.
+percpu_counter_tree_init_many() allocates the per-cpu counters, one per
+possible CPU, and the tree items, whose number depends on nr_cpu_ids, so
+struct percpu_counter_tree has a fixed size.
+
+The fan-out of each tree level is selected at boot from nr_cpu_ids, the
+highest possible CPU number plus one.
+
+The bounded accuracy is a property of the settled tree. While updates are
+in flight the transient error can exceed it, bounded by the number of
+updaters and their increment size.
+
+Likewise, the precise sum is exact when no update runs concurrently. It
+takes no lock: an update which carries from the per-cpu counter to the
+upper levels can be counted in part, the residual it left below read and
+its carry missed on the way up.
+
+Use Cases
+=========
+
+Use cases HPCC is meant to handle involve tracking resources which are
+used across many CPUs to quickly sum as feedback for decision making to
+apply throttling, quota limits, sort tasks, and perform memory or task
+migration decisions. When considering approximated sums within the
+accuracy range of the decision threshold, the user can either:
+
+ * Be conservative and fast: Consider that the sum has reached the
+   limit as soon as the given limit is within the approximation range.
+
+ * Be aggressive and fast: Consider that the sum is over the
+   limit only when the approximation range is over the given limit.
+
+ * Be precise and slow: Do a precise comparison with the limit, which
+   requires a precise sum when the limit is within the approximated
+   range.
+
+One use-case for these hierarchical counters is to implement a two-pass
+algorithm to speed up picking a maximum/minimum sum value from
+a set. A first pass compares the approximated values, and then a second
+pass only needs the precise sum for counter trees which are within the
+possible precise sum range of the counter tree chosen by the first pass.
+
+Because the comparison is on the wrapped difference, it is not transitive:
+ordering is undefined over a set of counters spanning more than LONG_MAX.
+
+Functions and structures
+========================
+
+.. kernel-doc:: include/linux/percpu_counter_tree.h
+.. kernel-doc:: lib/percpu_counter_tree.c
diff --git a/MAINTAINERS b/MAINTAINERS
index 93abbb315065..712af0536005 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11947,6 +11947,15 @@ L:	linux-input@vger.kernel.org
 S:	Maintained
 F:	drivers/hid/hid-logitech-hidpp.c
 
+HIERARCHICAL PER-CPU COUNTERS (HPCC)
+M:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+L:	linux-mm@kvack.org
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+F:	Documentation/core-api/percpu-counter-tree.rst
+F:	include/linux/percpu_counter_tree.h
+F:	lib/percpu_counter_tree.c
+
 HIGH-RESOLUTION TIMERS, TIMER WHEEL, CLOCKEVENTS
 M:	Anna-Maria Behnsen <anna-maria@linutronix.de>
 M:	Frederic Weisbecker <frederic@kernel.org>
diff --git a/include/linux/percpu_counter_tree.h b/include/linux/percpu_counter_tree.h
new file mode 100644
index 000000000000..741a6877aa99
--- /dev/null
+++ b/include/linux/percpu_counter_tree.h
@@ -0,0 +1,292 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+/* SPDX-FileCopyrightText: 2025-2026 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> */
+
+#ifndef _PERCPU_COUNTER_TREE_H
+#define _PERCPU_COUNTER_TREE_H
+
+#include <linux/bug.h>
+#include <linux/atomic.h>
+#include <linux/limits.h>
+#include <linux/percpu.h>
+
+/* Largest batch size: level 0 residuals are within (-batch, +batch) of a signed byte. */
+#define PERCPU_COUNTER_TREE_MAX_BATCH	128
+static_assert(PERCPU_COUNTER_TREE_MAX_BATCH - 1 <= S8_MAX);
+
+#ifdef CONFIG_SMP
+
+struct percpu_counter_tree {
+	/*
+	 * Per-CPU split counters (tree level 0): residuals not propagated
+	 * yet, within (-batch, +batch).
+	 */
+	s8 __percpu *level0;
+	/*
+	 * The batch size is the increment step at level 0 which triggers a
+	 * carry propagation: a power of 2 between 2 and
+	 * PERCPU_COUNTER_TREE_MAX_BATCH. It is stored next to level0, the
+	 * other field read by the update fast path, so both usually share a
+	 * cache line: this leaves a hole before items_stride.
+	 */
+	unsigned char batch_order;
+	unsigned int items_stride;	/* Distance between this counter's consecutive items. */
+	/*
+	 * Approximate sum: this counter's item of the root, in the tree
+	 * items allocated with the per-CPU counters.
+	 */
+	atomic_long_t *approx_sum;
+	long bias;	/* Bias to apply to counter precise and approximate values. */
+};
+
+int percpu_counter_tree_init_many(struct percpu_counter_tree *counters,
+				  unsigned int nr_counters, unsigned long batch_size,
+				  gfp_t gfp_flags);
+int percpu_counter_tree_init(struct percpu_counter_tree *counter,
+			     unsigned long batch_size, gfp_t gfp_flags);
+void percpu_counter_tree_destroy_many(struct percpu_counter_tree *counters,
+				      unsigned int nr_counters);
+void percpu_counter_tree_destroy(struct percpu_counter_tree *counter);
+void percpu_counter_tree_add(struct percpu_counter_tree *counter, long inc);
+long percpu_counter_tree_precise_sum(struct percpu_counter_tree *counter);
+int percpu_counter_tree_approximate_compare(struct percpu_counter_tree *a,
+					    struct percpu_counter_tree *b);
+int percpu_counter_tree_approximate_compare_value(struct percpu_counter_tree *counter, long v);
+int percpu_counter_tree_precise_compare(struct percpu_counter_tree *a,
+					struct percpu_counter_tree *b);
+int percpu_counter_tree_precise_compare_value(struct percpu_counter_tree *counter, long v);
+void percpu_counter_tree_set(struct percpu_counter_tree *counter, long v);
+int percpu_counter_tree_subsystem_init(void);
+
+/**
+ * percpu_counter_tree_approximate_sum() - Return approximate counter sum.
+ * @counter: The counter to sum.
+ *
+ * Querying the approximate sum is fast, but it is only accurate within
+ * the bound returned by percpu_counter_tree_approximate_accuracy().
+ * This is meant to be used when speed is preferred over accuracy.
+ *
+ * Return: The current approximate counter sum.
+ */
+static inline
+long percpu_counter_tree_approximate_sum(struct percpu_counter_tree *counter)
+{
+	unsigned long v = atomic_long_read(counter->approx_sum);
+
+	return (long)(v + (unsigned long)READ_ONCE(counter->bias));
+}
+
+unsigned long percpu_counter_tree_approximate_accuracy(struct percpu_counter_tree *counter);
+
+#if IS_ENABLED(CONFIG_KUNIT)
+unsigned int percpu_counter_tree_check_config(void);
+unsigned int percpu_counter_tree_check_residuals(struct percpu_counter_tree *counter);
+void percpu_counter_tree_copy_state(struct percpu_counter_tree *dst,
+				    struct percpu_counter_tree *src);
+#endif
+
+#else	/* !CONFIG_SMP */
+
+struct percpu_counter_tree {
+	atomic_long_t count;
+};
+
+static inline
+int percpu_counter_tree_init_many(struct percpu_counter_tree *counters,
+				  unsigned int nr_counters, unsigned long batch_size,
+				  gfp_t gfp_flags)
+{
+	/*
+	 * There is no tree to batch into on UP, so @batch_size has no
+	 * effect. Validate it anyway so callers get the same result as
+	 * on SMP.
+	 */
+	if (WARN_ON(batch_size <= 1 || (batch_size & (batch_size - 1)) ||
+		    batch_size > PERCPU_COUNTER_TREE_MAX_BATCH))
+		return -EINVAL;
+	for (unsigned int i = 0; i < nr_counters; i++)
+		atomic_long_set(&counters[i].count, 0);
+	return 0;
+}
+
+static inline
+int percpu_counter_tree_init(struct percpu_counter_tree *counter,
+			     unsigned long batch_size, gfp_t gfp_flags)
+{
+	return percpu_counter_tree_init_many(counter, 1, batch_size, gfp_flags);
+}
+
+static inline
+void percpu_counter_tree_destroy_many(struct percpu_counter_tree *counters,
+				      unsigned int nr_counters)
+{
+}
+
+static inline
+void percpu_counter_tree_destroy(struct percpu_counter_tree *counter)
+{
+}
+
+static inline
+long percpu_counter_tree_precise_sum(struct percpu_counter_tree *counter)
+{
+	return atomic_long_read(&counter->count);
+}
+
+static inline
+int percpu_counter_tree_precise_compare(struct percpu_counter_tree *a,
+					struct percpu_counter_tree *b)
+{
+	/* Compare on the wrapped difference, as on SMP. */
+	long delta = (long)((unsigned long)percpu_counter_tree_precise_sum(a) -
+			    (unsigned long)percpu_counter_tree_precise_sum(b));
+
+	if (delta < 0)
+		return -1;
+	if (delta > 0)
+		return 1;
+	return 0;
+}
+
+static inline
+int percpu_counter_tree_precise_compare_value(struct percpu_counter_tree *counter, long v)
+{
+	/* Compare on the wrapped difference, as on SMP. */
+	long delta = (long)((unsigned long)v -
+			    (unsigned long)percpu_counter_tree_precise_sum(counter));
+
+	if (delta < 0)
+		return -1;
+	if (delta > 0)
+		return 1;
+	return 0;
+}
+
+static inline
+int percpu_counter_tree_approximate_compare(struct percpu_counter_tree *a,
+					    struct percpu_counter_tree *b)
+{
+	return percpu_counter_tree_precise_compare(a, b);
+}
+
+static inline
+int percpu_counter_tree_approximate_compare_value(struct percpu_counter_tree *counter, long v)
+{
+	return percpu_counter_tree_precise_compare_value(counter, v);
+}
+
+static inline
+void percpu_counter_tree_set(struct percpu_counter_tree *counter, long v)
+{
+	atomic_long_set(&counter->count, v);
+}
+
+static inline
+unsigned long percpu_counter_tree_approximate_accuracy(struct percpu_counter_tree *counter)
+{
+	return 0;
+}
+
+static inline
+void percpu_counter_tree_add(struct percpu_counter_tree *counter, long inc)
+{
+	atomic_long_add(inc, &counter->count);
+}
+
+static inline
+long percpu_counter_tree_approximate_sum(struct percpu_counter_tree *counter)
+{
+	return percpu_counter_tree_precise_sum(counter);
+}
+
+static inline
+int percpu_counter_tree_subsystem_init(void)
+{
+	return 0;
+}
+
+#endif	/* CONFIG_SMP */
+
+/**
+ * percpu_counter_tree_approximate_sum_positive() - Return a positive approximate counter sum.
+ * @counter: The counter to sum.
+ *
+ * Return an approximate counter sum which is guaranteed to be greater
+ * or equal to 0.
+ *
+ * Return: The current positive approximate counter sum.
+ */
+static inline
+long percpu_counter_tree_approximate_sum_positive(struct percpu_counter_tree *counter)
+{
+	long v = percpu_counter_tree_approximate_sum(counter);
+
+	return v > 0 ? v : 0;
+}
+
+/**
+ * percpu_counter_tree_precise_sum_positive() - Return a positive precise counter sum.
+ * @counter: The counter to sum.
+ *
+ * Return a precise counter sum which is guaranteed to be greater
+ * or equal to 0.
+ *
+ * Return: The current positive precise counter sum.
+ */
+static inline
+long percpu_counter_tree_precise_sum_positive(struct percpu_counter_tree *counter)
+{
+	long v = percpu_counter_tree_precise_sum(counter);
+
+	return v > 0 ? v : 0;
+}
+
+/**
+ * percpu_counter_tree_approximate_min_max_range() - Return the min and max precise values.
+ * @approx_sum: Approximated sum.
+ * @accuracy: Tree accuracy, from percpu_counter_tree_approximate_accuracy().
+ * @precise_min: Minimum possible value for precise sum (output).
+ * @precise_max: Maximum possible value for precise sum (output).
+ *
+ * Calculate the minimum and maximum precise values for a given approximation
+ * and accuracy. The accuracy is a bound on a settled tree: one with no update
+ * in progress.
+ *
+ * The approximation is within the accuracy of the precise sum, in both
+ * directions:
+ *
+ *   precise_sum - accuracy <= approx_sum <= precise_sum + accuracy
+ *
+ * Therefore, the precise sum is within the accuracy of the approximation:
+ *
+ *   approx_sum - accuracy <= precise_sum <= approx_sum + accuracy
+ */
+static inline
+void percpu_counter_tree_approximate_min_max_range(long approx_sum, unsigned long accuracy,
+						   long *precise_min, long *precise_max)
+{
+	*precise_min = approx_sum - accuracy;
+	*precise_max = approx_sum + accuracy;
+}
+
+/**
+ * percpu_counter_tree_approximate_min_max() - Return the approximation, min and max precise values.
+ * @counter: The counter to sum.
+ * @approx_sum: Approximate sum (output).
+ * @precise_min: Minimum possible value for precise sum (output).
+ * @precise_max: Maximum possible value for precise sum (output).
+ *
+ * Return the approximate sum, minimum and maximum precise values for
+ * a counter.
+ */
+static inline
+void percpu_counter_tree_approximate_min_max(struct percpu_counter_tree *counter,
+					     long *approx_sum, long *precise_min, long *precise_max)
+{
+	unsigned long accuracy = percpu_counter_tree_approximate_accuracy(counter);
+	long v = percpu_counter_tree_approximate_sum(counter);
+
+	percpu_counter_tree_approximate_min_max_range(v, accuracy, precise_min, precise_max);
+	*approx_sum = v;
+}
+
+#endif  /* _PERCPU_COUNTER_TREE_H */
diff --git a/init/main.c b/init/main.c
index 7b0c8c34e6a9..d9614cc5bd63 100644
--- a/init/main.c
+++ b/init/main.c
@@ -108,6 +108,7 @@
 #include <linux/time_namespace.h>
 #include <linux/unaligned.h>
 #include <linux/vdso_datastore.h>
+#include <linux/percpu_counter_tree.h>
 #include <net/net_namespace.h>
 
 #include <asm/io.h>
@@ -1104,6 +1105,8 @@ void start_kernel(void)
 	sort_main_extable();
 	trap_init();
 	mm_core_init();
+	/* After parsing its boot parameters and setting up slab, before the first counter. */
+	percpu_counter_tree_subsystem_init();
 	maple_tree_init();
 	poking_init();
 	ftrace_init();
diff --git a/lib/Makefile b/lib/Makefile
index a2afe954805c..07410b1d20a3 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -182,6 +182,7 @@ obj-$(CONFIG_TEXTSEARCH_KMP) += ts_kmp.o
 obj-$(CONFIG_TEXTSEARCH_BM) += ts_bm.o
 obj-$(CONFIG_TEXTSEARCH_FSM) += ts_fsm.o
 obj-$(CONFIG_SMP) += percpu_counter.o
+obj-$(CONFIG_SMP) += percpu_counter_tree.o
 obj-$(CONFIG_AUDIT_GENERIC) += audit.o
 obj-$(CONFIG_AUDIT_COMPAT_GENERIC) += compat_audit.o
 
diff --git a/lib/percpu_counter_tree.c b/lib/percpu_counter_tree.c
new file mode 100644
index 000000000000..67cdb22c3786
--- /dev/null
+++ b/lib/percpu_counter_tree.c
@@ -0,0 +1,1119 @@
+// SPDX-License-Identifier: GPL-2.0+ OR MIT
+// SPDX-FileCopyrightText: 2025-2026 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+
+/*
+ * Split Counters With Tree Approximation Propagation
+ *
+ * * Overview
+ *
+ * Each counter is a tree of counters. A CPU updates its own level 0
+ * counter, a signed byte. Each counter keeps the residual it has not
+ * propagated yet, and propagates a carry to its parent on the next level
+ * once that residual reaches the batch size of its level, up to the root.
+ * Most updates therefore stay on the updating CPU. The root holds the
+ * approximate sum, read in O(1), and the precise sum adds the residuals of
+ * all levels to it.
+ *
+ * * Tree shape
+ *
+ * Illustration with 8 CPUs and a fan-out of 2 at each level, which makes
+ * 3 levels of counters below the root. This is not an actual
+ * configuration: at 8 CPUs, the default tree is flat.
+ *
+ * Level 3:  0  (root)
+ *           |   \
+ *           |         \
+ *           |               \
+ * Level 2:  0                   1
+ *           | \                 | \
+ *           |    \              |    \
+ *           |       \           |       \
+ * Level 1:  0         2         1         3
+ *           | \       | \       | \       | \
+ *           |  \      |  \      |  \      |  \
+ *           |   \     |   \     |   \     |   \
+ * Level 0:  0    4    2    6    1    5    3    7
+ *
+ * CPU c propagates into item (c & (L - 1)) of a level holding L items,
+ * so the CPUs sharing an item are not adjacent: CPUs 0 and 4 share
+ * level 1 item 0, and CPUs 0, 2, 4, 6 share level 2 item 0. This mapping
+ * uses every item of each level and gives each item the same number of
+ * CPUs, give or take one, even when nr_cpu_ids is not a power of 2. The
+ * diagram lists the CPUs in bit-reversed order to avoid crossing lines.
+ *
+ * The actual fan-out of each level depends on the topology (see
+ * per_nr_cpu_order_config): up to 32 CPUs, the tree is flat, and the
+ * level 0 counters propagate directly to the root.
+ *
+ * * Batch sizes and residuals
+ *
+ * The batch size of a level, BATCH(level N), is the batch size of the
+ * level below multiplied by the fan-out of that level. Example for
+ * BATCH(level 0) = 32, with the tree of the illustration above:
+ *
+ * BATCH(level 0) =  32
+ * BATCH(level 1) =  64
+ * BATCH(level 2) = 128
+ *
+ * Once the residual of a counter reaches +/- BATCH(level N), it propagates
+ * its multiples of BATCH(level N), truncated toward zero, and subtracts
+ * them. This hysteresis prevents updates going back and forth around a
+ * BATCH(level N) boundary from propagating up the tree each time.
+ *
+ * The residual of a settled counter therefore stays within
+ * (-BATCH(level N), +BATCH(level N)), and moves in steps of the counter's
+ * input: level 0 receives the updates, in steps of 1, while a counter
+ * above level 0 only receives the carries of the level below, in steps of
+ * BATCH(level N - 1). The largest residual of a counter is the largest
+ * multiple of its input step below its batch size: BATCH(level 0) - 1 at
+ * level 0, and BATCH(level N) - BATCH(level N - 1) above:
+ *
+ *            input   residual        worst case        worst case
+ *            step    per counter     below precise     above precise
+ * Level 0:   1       [-31 .. 31]     248  (8 * 31)     248  (8 * 31)
+ * Level 1:   32      {-32, 0, 32}    128  (4 * 32)     128  (4 * 32)
+ * Level 2:   64      {-64, 0, 64}    128  (2 * 64)     128  (2 * 64)
+ * Total:                             504               504
+ *
+ * * Approximation accuracy
+ *
+ * The approximate sum is the precise sum minus the residuals, so a
+ * settled counter (no update in progress) is within:
+ *
+ *   precise - 504 <= approx <= precise + 504
+ *
+ * The accuracy returned by percpu_counter_tree_approximate_accuracy() is
+ * exact. It adds the largest residuals of all the counters:
+ * BATCH(level 0) - 1 for each of the nr_cpu_ids level 0 counters, and
+ * BATCH(level N) - BATCH(level N - 1) for each counter of level N above.
+ * Counting each level 0 counter as one BATCH(level 0), minus its input
+ * step of 1:
+ *
+ *   accuracy_multiplier = nr_cpu_ids + sum over levels N >= 1 of
+ *       (number of counters at level N) *
+ *       (BATCH(level N) - BATCH(level N - 1)) / BATCH(level 0)
+ *
+ *   accuracy = BATCH(level 0) * accuracy_multiplier - nr_cpu_ids
+ *
+ * In the example above, accuracy_multiplier = 8 + 4 * 1 + 2 * 2 = 16, and:
+ *
+ *   accuracy = 32 * 16 - 8 = 504
+ *
+ * Every counter above level 0 is reachable from a CPU below nr_cpu_ids,
+ * even when nr_cpu_ids is not a power of 2, so both bounds can be reached
+ * when the possible CPUs are contiguous. When they are sparse, the bound
+ * also counts the level 0 residuals of the missing CPUs: it holds, but
+ * cannot be reached.
+ *
+ * * Carry propagation
+ *
+ * The items at each tree position of the counters initialized together
+ * share cache lines, which are not shared with other tree positions to
+ * prevent false sharing between CPUs.
+ *
+ * Example with expanded values, for the tree and batch sizes above:
+ *
+ * counter_add(counter, inc):
+ *
+ *         if (!inc)
+ *                 return;
+ *
+ *         // Level 0: per-CPU residual within (-32, +32).
+ *         old = percpu_read(counter @ Level 0);
+ *         do {
+ *                 v = old + inc;
+ *                 out = v < 0 ? -(-v & ~0b00011111) : (v & ~0b00011111);
+ *         } while (!percpu_try_cmpxchg(counter @ Level 0, &old, v - out));
+ *         inc = out;
+ *         if (!inc)
+ *                 return;
+ *
+ *         // Levels 1 and 2: add the carry, then extract the multiples
+ *         // of the level batch held by the counter, truncated toward
+ *         // zero. A failed cmpxchg updates res to the current residual.
+ *         res = atomic_long_add_return(counter @ Level 1, inc);
+ *         do {
+ *                 inc = res < 0 ? -(-res & ~0b00111111) : (res & ~0b00111111);
+ *                 if (!inc)
+ *                         return;
+ *         } while (!atomic_long_try_cmpxchg(counter @ Level 1, &res, res - inc));
+ *
+ *         res = atomic_long_add_return(counter @ Level 2, inc);
+ *         do {
+ *                 inc = res < 0 ? -(-res & ~0b01111111) : (res & ~0b01111111);
+ *                 if (!inc)
+ *                         return;
+ *         } while (!atomic_long_try_cmpxchg(counter @ Level 2, &res, res - inc));
+ *
+ *         atomic_long_add(counter @ Level 3, inc);
+ */
+
+#define pr_fmt(fmt) "percpu_counter_tree: " fmt
+
+#include <linux/percpu_counter_tree.h>
+#include <linux/align.h>
+#include <linux/cache.h>
+#include <linux/cpumask.h>
+#include <linux/atomic.h>
+#include <linux/export.h>
+#include <linux/percpu.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/math.h>
+#include <linux/log2.h>
+#include <linux/args.h>
+#include <kunit/visibility.h>
+
+#define MAX_NR_LEVELS 7
+
+/*
+ * The counter configuration is selected at boot time based on the
+ * hardware topology.
+ */
+struct counter_config {
+	/*
+	 * nr_levels is the number of hierarchical counter tree levels. It
+	 * excludes the final level (approximate sum).
+	 */
+	unsigned char nr_levels;
+	/* n-arity of each level from 0 to (nr_levels - 1). */
+	unsigned char n_arity_order[MAX_NR_LEVELS];
+};
+
+/*
+ * The fan-out of each level of the tree is chosen with a heuristic trying to
+ * minimize both the tree depth and the fan-out.
+ */
+#define PCT_COUNTER_CONFIG(order, ...)						\
+	[order] = {								\
+		.nr_levels = COUNT_ARGS(__VA_ARGS__),				\
+		.n_arity_order = { __VA_ARGS__ },				\
+	}
+
+/*
+ * Up to 32 CPUs, the tree is flat: the level 0 counters propagate directly
+ * to the root, like struct percpu_counter. From 33 to 64 CPUs, the level 0
+ * counters propagate to 4 intermediate counters, each shared by up to 16
+ * CPUs, so the carries of all CPUs do not contend on the root. Beyond, each
+ * level has a fan-out of 8. When the order is not a multiple of 3, a
+ * remaining order of 1 gives the root a fan-out of 16, and a remaining
+ * order of 2 adds a level with a fan-out of 4 below the root: a root
+ * fan-out of 16 updates about as fast as a fan-out of 2 below the root,
+ * with one level less, which shrinks the accuracy bound and the tree
+ * items, while a root fan-out of 32 is slower than a fan-out of 4 below
+ * it. This keeps the carry rate reaching each tree item low with the RSS
+ * batch size of 32, and the approximation error grows as
+ * O(nr_cpus * log(nr_cpus)), compared to O(nr_cpus^2) for struct
+ * percpu_counter whose batch size grows with the number of CPUs.
+ *
+ * The tree is shaped for nr_cpu_ids rounded up to a power of 2, and each
+ * tree position takes a cache line. A set of 4 counters initialized together,
+ * such as the RSS counters of an mm, uses less memory than 4 struct
+ * percpu_counter from a few CPUs up to 64, and beyond when nr_cpu_ids is a
+ * power of 2 (at most 0.89 times as much). Between powers of 2, fewer CPUs
+ * share the cost of the tree items: up to 1.1 times at 3 * 2^n CPUs, and
+ * up to 1.48 times just above a power of 2. A lone counter uses one item
+ * of each cache line: 3.0 to 3.5 times the memory of a struct
+ * percpu_counter when nr_cpu_ids is a power of 2 beyond 64, and up to 5.7
+ * times just above.
+ */
+static const struct counter_config per_nr_cpu_order_config[] = {
+	PCT_COUNTER_CONFIG(0),
+	PCT_COUNTER_CONFIG(1, 1),
+	PCT_COUNTER_CONFIG(2, 2),
+	PCT_COUNTER_CONFIG(3, 3),
+	PCT_COUNTER_CONFIG(4, 4),
+	PCT_COUNTER_CONFIG(5, 5),
+	PCT_COUNTER_CONFIG(6, 4, 2),
+	PCT_COUNTER_CONFIG(7, 3, 4),
+	PCT_COUNTER_CONFIG(8, 3, 2, 3),
+	PCT_COUNTER_CONFIG(9, 3, 3, 3),
+	PCT_COUNTER_CONFIG(10, 3, 3, 4),
+	PCT_COUNTER_CONFIG(11, 3, 3, 2, 3),
+	PCT_COUNTER_CONFIG(12, 3, 3, 3, 3),
+	PCT_COUNTER_CONFIG(13, 3, 3, 3, 4),
+	PCT_COUNTER_CONFIG(14, 3, 3, 3, 2, 3),
+	PCT_COUNTER_CONFIG(15, 3, 3, 3, 3, 3),
+	PCT_COUNTER_CONFIG(16, 3, 3, 3, 3, 4),
+	PCT_COUNTER_CONFIG(17, 3, 3, 3, 3, 2, 3),
+	PCT_COUNTER_CONFIG(18, 3, 3, 3, 3, 3, 3),
+	PCT_COUNTER_CONFIG(19, 3, 3, 3, 3, 3, 4),
+	PCT_COUNTER_CONFIG(20, 3, 3, 3, 3, 3, 2, 3),
+};
+
+#undef PCT_COUNTER_CONFIG
+
+/* The configuration table covers every possible number of CPUs. */
+#define MAX_NR_CPUS_ORDER	20
+#if NR_CPUS > (1UL << MAX_NR_CPUS_ORDER)
+#error "NR_CPUS exceeds the hierarchical counter configuration table"
+#endif
+static_assert(ARRAY_SIZE(per_nr_cpu_order_config) == MAX_NR_CPUS_ORDER + 1);
+
+/* Tree topology, selected at boot and shared by all the counters. */
+static struct {
+	/* Hierarchical counter configuration for the hardware topology. */
+	const struct counter_config *config;
+	/* Order of nr_cpu_ids. */
+	unsigned int nr_cpus_order;
+	/*
+	 * Tree items per counter, including the root. UINT_MAX catches early
+	 * boot misuses.
+	 */
+	unsigned int nr_items;
+	/*
+	 * Largest residuals of all the counters, in units of the level 0
+	 * batch size: see percpu_counter_tree_accuracy().
+	 */
+	unsigned long accuracy_multiplier;
+	/* Tree items when those of a tree position fit in one cache line. */
+	struct kmem_cache *items_cachep;
+} tree_topology __ro_after_init = {
+	.nr_items = UINT_MAX,
+};
+
+/*
+ * Size of the items of one tree position for the counters initialized
+ * together by percpu_counter_tree_init_many(), packed in cache lines which
+ * are not shared with other tree positions. Each item is the residual of
+ * the carries received and not propagated yet, within (-batch, +batch) of
+ * its tree level when settled. The items of a tree position are updated
+ * by the same CPUs, so packing them does not add contention between
+ * unrelated CPUs.
+ */
+static
+size_t percpu_counter_tree_position_size(unsigned int nr_counters)
+{
+	return ALIGN(nr_counters * sizeof(atomic_long_t), SMP_CACHE_BYTES);
+}
+
+/* Distance between the consecutive items of each of @nr_counters counters. */
+static inline
+unsigned int percpu_counter_tree_items_stride(unsigned int nr_counters)
+{
+	return percpu_counter_tree_position_size(nr_counters) / sizeof(atomic_long_t);
+}
+
+/* Allocate the zeroed tree items of @nr_counters counters, the root last. */
+static
+atomic_long_t *percpu_counter_tree_alloc_items(unsigned int nr_counters, gfp_t gfp_flags)
+{
+	size_t position_size = percpu_counter_tree_position_size(nr_counters);
+
+	if (position_size == SMP_CACHE_BYTES)
+		return kmem_cache_zalloc(tree_topology.items_cachep, gfp_flags);
+	/* kmalloc() aligns power of 2 sizes on their size. */
+	return kzalloc(roundup_pow_of_two(tree_topology.nr_items * position_size),
+		       gfp_flags);
+}
+
+static
+void percpu_counter_tree_free_items(atomic_long_t *items, unsigned int nr_counters)
+{
+	if (percpu_counter_tree_position_size(nr_counters) == SMP_CACHE_BYTES)
+		kmem_cache_free(tree_topology.items_cachep, items);
+	else
+		kfree(items);
+}
+
+static
+int __percpu_counter_tree_init(struct percpu_counter_tree *counter,
+			       unsigned long batch_size,
+			       s8 __percpu *level0,
+			       atomic_long_t *items, unsigned int items_stride)
+{
+	/* Batch size must be greater than 1, a power of 2, and fit in a byte. */
+	if (WARN_ON(batch_size <= 1 || (batch_size & (batch_size - 1)) ||
+		    batch_size > PERCPU_COUNTER_TREE_MAX_BATCH))
+		return -EINVAL;
+	counter->batch_order = ilog2(batch_size);
+	counter->bias = 0;
+	counter->level0 = level0;
+	counter->items_stride = items_stride;
+	/* The root is the last item. */
+	counter->approx_sum = &items[(tree_topology.nr_items - 1) * items_stride];
+	return 0;
+}
+
+static inline
+unsigned long percpu_counter_tree_batch_size(struct percpu_counter_tree *counter)
+{
+	return 1UL << counter->batch_order;
+}
+
+/* This counter's first item. */
+static inline
+atomic_long_t *percpu_counter_tree_items(struct percpu_counter_tree *counter)
+{
+	return counter->approx_sum - (tree_topology.nr_items - 1) * counter->items_stride;
+}
+
+/*
+ * The residuals of all levels are within (-batch, +batch) of their level,
+ * so the approximation is within the same distance of the precise sum in
+ * both directions: the largest residuals of all the counters, which
+ * accuracy_multiplier counts in units of the level 0 batch size, minus the
+ * input step of 1 of each level 0 counter. See "Approximation accuracy" at
+ * the top of this file.
+ */
+static inline
+unsigned long percpu_counter_tree_accuracy(struct percpu_counter_tree *counter)
+{
+	unsigned long batch_size = percpu_counter_tree_batch_size(counter);
+
+	return batch_size * tree_topology.accuracy_multiplier - nr_cpu_ids;
+}
+
+/**
+ * percpu_counter_tree_init_many() - Initialize many per-CPU counter trees.
+ * @counters: An array of @nr_counters counters to initialize.
+ *	      Their memory is provided by the caller.
+ * @nr_counters: The number of counter trees to initialize
+ * @batch_size: The batch size is the increment step at level 0 which triggers a
+ *		carry propagation.
+ *		The batch size is required to be greater than 1, a power of 2, and at
+ *		most PERCPU_COUNTER_TREE_MAX_BATCH.
+ * @gfp_flags: gfp flags to pass to the per-CPU and tree item allocators.
+ *
+ * Initialize many per-CPU counter trees, with a single allocation of
+ * per-CPU counters and a single allocation of tree items for the
+ * @nr_counters counters. The items at each tree position of the
+ * @nr_counters counters share cache lines. When they fit in one cache
+ * line (up to 8 counters on 64-bit with 64-byte cache lines), the tree
+ * items come from a slab cache; beyond, their allocation is
+ * rounded up to a power of 2, which can double it.
+ *
+ * Return:
+ * * %0: Success
+ * * %-EINVAL:		- Invalid @batch_size argument
+ * * %-ENOMEM:		- Out of memory
+ */
+int percpu_counter_tree_init_many(struct percpu_counter_tree *counters,
+				  unsigned int nr_counters, unsigned long batch_size,
+				  gfp_t gfp_flags)
+{
+	unsigned int items_stride = percpu_counter_tree_items_stride(nr_counters);
+	s8 __percpu *level0;
+	atomic_long_t *items;
+	unsigned int i;
+	int ret;
+
+	/* The tree shape is selected by percpu_counter_tree_subsystem_init() at boot. */
+	if (WARN_ON_ONCE(tree_topology.nr_items == UINT_MAX))
+		return -EINVAL;
+	level0 = __alloc_percpu_gfp(nr_counters * sizeof(*level0),
+				    __alignof__(*counters->level0), gfp_flags);
+	if (!level0)
+		return -ENOMEM;
+	items = percpu_counter_tree_alloc_items(nr_counters, gfp_flags);
+	if (!items) {
+		ret = -ENOMEM;
+		goto free_level0;
+	}
+	for (i = 0; i < nr_counters; i++) {
+		ret = __percpu_counter_tree_init(&counters[i], batch_size, level0 + i,
+						 items + i, items_stride);
+		if (ret)
+			goto free_items;
+	}
+	return 0;
+
+free_items:
+	percpu_counter_tree_free_items(items, nr_counters);
+free_level0:
+	free_percpu(level0);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_init_many);
+
+/**
+ * percpu_counter_tree_init() - Initialize one per-CPU counter tree.
+ * @counter: Counter to initialize.
+ *	     Its memory is provided by the caller.
+ * @batch_size: The batch size is the increment step at level 0 which triggers a
+ *		carry propagation.
+ *		The batch size is required to be greater than 1, a power of 2, and at
+ *		most PERCPU_COUNTER_TREE_MAX_BATCH.
+ * @gfp_flags: gfp flags to pass to the per-CPU and tree item allocators.
+ *
+ * Initialize one per-CPU counter tree.
+ *
+ * Return:
+ * * %0: Success
+ * * %-EINVAL:		- Invalid @batch_size argument
+ * * %-ENOMEM:		- Out of memory
+ */
+int percpu_counter_tree_init(struct percpu_counter_tree *counter,
+			     unsigned long batch_size, gfp_t gfp_flags)
+{
+	return percpu_counter_tree_init_many(counter, 1, batch_size, gfp_flags);
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_init);
+
+/**
+ * percpu_counter_tree_destroy_many() - Destroy many per-CPU counter trees.
+ * @counters: Array of counters trees to destroy.
+ * @nr_counters: The number of counter trees to destroy.
+ *
+ * Release internal resources allocated for @nr_counters per-CPU counter trees.
+ * @counters and @nr_counters must be those passed to
+ * percpu_counter_tree_init_many().
+ */
+void percpu_counter_tree_destroy_many(struct percpu_counter_tree *counters,
+				      unsigned int nr_counters)
+{
+	free_percpu(counters->level0);
+	/*
+	 * @nr_counters selects the allocator of the tree items: on a mismatch
+	 * with the initialization, leak them rather than corrupt the allocator.
+	 */
+	if (WARN_ON_ONCE(counters->items_stride !=
+			 percpu_counter_tree_items_stride(nr_counters)))
+		return;
+	/* The first item of the first counter is the base of the tree items. */
+	percpu_counter_tree_free_items(percpu_counter_tree_items(counters), nr_counters);
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_destroy_many);
+
+/**
+ * percpu_counter_tree_destroy() - Destroy one per-CPU counter tree.
+ * @counter: Counter to destroy.
+ *
+ * Release internal resources allocated for one per-CPU counter tree.
+ */
+void percpu_counter_tree_destroy(struct percpu_counter_tree *counter)
+{
+	return percpu_counter_tree_destroy_many(counter, 1);
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_destroy);
+
+/*
+ * Amount propagated by a counter holding @v: the multiples of @bit_mask,
+ * truncated toward zero.
+ */
+static inline
+long percpu_counter_tree_item_carry(long v, unsigned long bit_mask)
+{
+	if (v < 0)
+		return -(long)(-(unsigned long)v & ~(bit_mask - 1));
+	return (long)((unsigned long)v & ~(bit_mask - 1));
+}
+
+/*
+ * It does not matter through which path the carry propagates up the
+ * tree, therefore there is no need to disable preemption because the
+ * cpu number is only used to favor cache locality.
+ */
+static
+void percpu_counter_tree_add_slowpath(struct percpu_counter_tree *counter, long inc)
+{
+	unsigned int level_items, nr_levels = tree_topology.config->nr_levels,
+		     level, n_arity_order;
+	unsigned long bit_mask;
+	unsigned int stride = counter->items_stride;
+	atomic_long_t *item = percpu_counter_tree_items(counter);
+	unsigned int cpu = raw_smp_processor_id();
+
+	n_arity_order = tree_topology.config->n_arity_order[0];
+	bit_mask = percpu_counter_tree_batch_size(counter) << n_arity_order;
+	level_items = 1U << (tree_topology.nr_cpus_order - n_arity_order);
+
+	for (level = 1; level < nr_levels; level++) {
+		/*
+		 * A multiple of bit_mask would leave the residual of this
+		 * level unchanged: propagate it to the next level directly.
+		 * This trades the hysteresis of this level for not touching
+		 * its cache line.
+		 */
+		if (abs(inc) & (bit_mask - 1)) {
+			atomic_long_t *count = &item[(cpu & (level_items - 1)) * stride];
+			long res;
+
+			/*
+			 * Add the carry to the residual of this level, then
+			 * extract the multiples of bit_mask of the residual,
+			 * truncated toward zero, and propagate them to the
+			 * next level, which leaves the residual within
+			 * (-bit_mask, +bit_mask).
+			 *
+			 * The extraction is a cmpxchg on the value returned by
+			 * the addition, whose cache line is already exclusive,
+			 * so it usually succeeds at once. When a concurrent
+			 * updater changed the residual in between, the cmpxchg
+			 * fails and the carry is recomputed from the current
+			 * value, which is 0 if the other updater extracted it.
+			 * Each carry is thus extracted once, from an exact
+			 * value: the residual only exceeds its range by the
+			 * additions in flight, and is within range once all
+			 * the updaters are done. An addition which does not
+			 * carry stays a single atomic operation, which cannot
+			 * fail.
+			 *
+			 * Relaxed ordering is sufficient for the residual
+			 * itself: the reasoning above only involves this
+			 * atomic, whose modifications all CPUs see in the same
+			 * order, each read-modify-write reading the value
+			 * written by the one just before it, whatever its
+			 * ordering. Ordering only matters relative to the other
+			 * levels, for the precise sum: the release ordering of
+			 * the addition orders the departure of the carry from
+			 * the level below before its arrival here.
+			 */
+			res = atomic_long_add_return_release(inc, count);
+			do {
+				inc = percpu_counter_tree_item_carry(res, bit_mask);
+				if (likely(!inc))
+					return;
+			} while (!atomic_long_try_cmpxchg_relaxed(count, &res, res - inc));
+		}
+		item += level_items * stride;
+		n_arity_order = tree_topology.config->n_arity_order[level];
+		level_items >>= n_arity_order;
+		bit_mask <<= n_arity_order;
+	}
+	atomic_long_add_return_release(inc, counter->approx_sum);
+}
+
+/**
+ * percpu_counter_tree_add() - Add to a per-CPU counter tree.
+ * @counter: Counter added to.
+ * @inc: Increment value (either positive or negative).
+ *
+ * Add @inc to a per-CPU counter tree. This is a fast-path which will
+ * typically increment per-CPU counters as long as there is no carry
+ * greater or equal to the counter tree batch size.
+ */
+void percpu_counter_tree_add(struct percpu_counter_tree *counter, long inc)
+{
+	unsigned long bit_mask = percpu_counter_tree_batch_size(counter);
+	s8 old, new;
+	long v, carry;
+
+	/*
+	 * Keep the residual within (-batch, +batch) and propagate its
+	 * multiples of the batch size, truncated toward zero. This
+	 * hysteresis prevents updates going back and forth around a batch
+	 * boundary from propagating each time.
+	 *
+	 * Preemption stays enabled: the update may go to the level 0
+	 * counter of any CPU, and the cmpxchg validates the value read.
+	 * After a migration or an interrupt between the read and the
+	 * cmpxchg, the cmpxchg either fails and retries with the current
+	 * residual of the current CPU, or succeeds on a residual equal to
+	 * the value read, which the new value correctly replaces. Each
+	 * this_cpu operation is itself safe against preemption and
+	 * interrupts, and the carry may propagate from any CPU, see
+	 * percpu_counter_tree_add_slowpath().
+	 */
+	old = this_cpu_read(*counter->level0);
+	do {
+		v = old + inc;
+		carry = percpu_counter_tree_item_carry(v, bit_mask);
+		new = (s8)(v - carry);
+	} while (!this_cpu_try_cmpxchg(*counter->level0, &old, new));
+	if (likely(!carry))
+		return;
+	percpu_counter_tree_add_slowpath(counter, carry);
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_add);
+
+/*
+ * The precise sum is the sum of the residuals of all tree levels. A carry
+ * leaves a level before reaching a higher level, and the release ordering
+ * of its arrival orders its departure before it. Reading the levels from
+ * the root down, separated by read barriers, therefore never counts a carry
+ * twice. A carry in flight during the sum may be missed: the result is
+ * precise for a counter without concurrent updates.
+ */
+static
+long percpu_counter_tree_precise_sum_unbiased(struct percpu_counter_tree *counter)
+{
+	unsigned int nr_levels = tree_topology.config->nr_levels, i,
+		     level_items[MAX_NR_LEVELS], stride = counter->items_stride;
+	atomic_long_t *item;
+	unsigned long sum;
+	int level, cpu;
+
+	/* Number of items of each level above level 0. */
+	level_items[0] = 1U << tree_topology.nr_cpus_order;
+	for (level = 1; level < (int)nr_levels; level++)
+		level_items[level] = level_items[level - 1] >>
+				     tree_topology.config->n_arity_order[level - 1];
+	sum = atomic_long_read(counter->approx_sum);
+	smp_rmb();	/* Read each level before the level below it. */
+	/* The items of each level precede those of the level above it. */
+	item = counter->approx_sum;
+	for (level = (int)nr_levels - 1; level >= 1; level--) {
+		item -= level_items[level] * stride;
+		for (i = 0; i < level_items[level]; i++)
+			sum += atomic_long_read(&item[i * stride]);
+		smp_rmb();	/* Read this level before the level below it. */
+	}
+	for_each_possible_cpu(cpu)
+		sum += (long)READ_ONCE(*per_cpu_ptr(counter->level0, cpu));
+	return (long)sum;
+}
+
+/**
+ * percpu_counter_tree_precise_sum() - Return precise counter sum.
+ * @counter: The counter to sum.
+ *
+ * Querying the precise sum is relatively expensive because it needs to
+ * iterate over all CPUs.
+ * This is meant to be used when accuracy is preferred over speed.
+ *
+ * The sum is exact when no update runs concurrently. It takes no lock, so
+ * a concurrent update which carries from level 0 to the levels above can
+ * be counted in part: the sum may read the residual it left below and miss
+ * its carry on the way up, an error in either direction of at most the
+ * carries in flight. A carry is never counted twice.
+ *
+ * Return: The current precise counter sum.
+ */
+long percpu_counter_tree_precise_sum(struct percpu_counter_tree *counter)
+{
+	return percpu_counter_tree_precise_sum_unbiased(counter) + READ_ONCE(counter->bias);
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_precise_sum);
+
+/*
+ * The comparison between counters is on the wrapped difference. It is valid
+ * only when the two counters differ by less than LONG_MAX, and results are
+ * undefined beyond that.
+ */
+static inline
+long wrapped_delta(long a, long b)
+{
+	return (long)((unsigned long)a - (unsigned long)b);
+}
+
+/*
+ * Each counter's approximation lies within its accuracy of its precise sum,
+ * in both directions. The comparison only observes the approximations, so
+ * it must reason about the possible precise values around each observed
+ * approximation, which lie within [approx - accuracy, approx + accuracy]:
+ *
+ *                 precise_a range
+ *            <-----------+----------->
+ *         accuracy_a     |     accuracy_a
+ *                    approx_a
+ *                        |                         precise_b range
+ *                        |                    <-----------+----------->
+ *                        |                 accuracy_b     |     accuracy_b
+ *                        |                             approx_b
+ *                        |                                |
+ *                        |<------------ gap ------------->|
+ *  ----------------------+--------------------------------+-------------> values
+ *
+ * The two precise ranges are disjoint, and the comparison can return a
+ * definitive answer, only once the gap between approximations exceeds the
+ * sum of the two accuracies:
+ *
+ *   gap > accuracy_a + accuracy_b
+ *
+ * When comparing against a plain value, the value has zero width, so the
+ * margin reduces to the accuracy of the counter: the value is above the
+ * counter once it exceeds approx + accuracy, and below it once it is less
+ * than approx - accuracy.
+ */
+static
+int compare_delta(long delta, unsigned long accuracy)
+{
+	if (delta >= 0) {
+		if (delta <= accuracy)
+			return 0;
+		else
+			return 1;
+	} else {
+		if (-delta <= accuracy)
+			return 0;
+		else
+			return -1;
+	}
+}
+
+/**
+ * percpu_counter_tree_approximate_compare - Approximated comparison of two counter trees.
+ * @a: First counter to compare.
+ * @b: Second counter to compare.
+ *
+ * Evaluate an approximate comparison of two counter trees. This approximation
+ * comparison is fast, and provides an accurate answer if the counters are
+ * found to be either less than or greater than the other. However, if the
+ * approximated comparison returns 0, the counters respective sums are found to
+ * be within the two counters accuracy range. The two counters are read
+ * independently; the result is not an atomic snapshot of both.
+ * The comparison between counters is on the wrapped difference. It is valid
+ * only when the two counters differ by less than LONG_MAX, and results are
+ * undefined beyond that.
+ *
+ * Return:
+ * * %0		- Counters @a and @b do not differ by more than the sum of their respective
+ *                accuracy ranges.
+ * * %-1	- Counter @a less than counter @b.
+ * * %1		- Counter @a is greater than counter @b.
+ */
+int percpu_counter_tree_approximate_compare(struct percpu_counter_tree *a,
+					    struct percpu_counter_tree *b)
+{
+	unsigned long accuracy = percpu_counter_tree_accuracy(a) + percpu_counter_tree_accuracy(b);
+
+	/* See the range geometry above compare_delta(). */
+	return compare_delta(wrapped_delta(percpu_counter_tree_approximate_sum(a),
+					   percpu_counter_tree_approximate_sum(b)),
+			     accuracy);
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_approximate_compare);
+
+/**
+ * percpu_counter_tree_approximate_compare_value - Approximated comparison of a counter tree
+ *						   against a given value.
+ * @counter: Counter to compare.
+ * @v: Value to compare.
+ *
+ * Evaluate an approximate comparison of a counter tree against a given value.
+ * This approximation comparison is fast, and provides an accurate
+ * answer if the counter is found to be either less than or greater
+ * than the value. However, if the approximated comparison returns
+ * 0, the value is within the counter accuracy range.
+ * The comparison between counters is on the wrapped difference. It is valid
+ * only when @v and the counter differ by less than LONG_MAX, and results are
+ * undefined beyond that.
+ *
+ * Return:
+ * * %0		- The value @v is within the accuracy range of the counter.
+ * * %-1	- The value @v is less than the counter.
+ * * %1		- The value @v is greater than the counter.
+ */
+int percpu_counter_tree_approximate_compare_value(struct percpu_counter_tree *counter, long v)
+{
+	unsigned long accuracy = percpu_counter_tree_accuracy(counter);
+
+	/* See the range geometry above compare_delta(). */
+	return compare_delta(wrapped_delta(v, percpu_counter_tree_approximate_sum(counter)),
+			     accuracy);
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_approximate_compare_value);
+
+/**
+ * percpu_counter_tree_precise_compare - Precise comparison of two counter trees.
+ * @a: First counter to compare.
+ * @b: Second counter to compare.
+ *
+ * Evaluate a precise comparison of two counter trees. As an optimization, it
+ * uses the approximate counter comparison to quickly compare counters which
+ * are far apart. Only cases where counter sums are within the accuracy range
+ * require precise counter sums. The two counters are read independently; the
+ * result is not an atomic snapshot of both. With concurrent updates, the
+ * precise sums can count updates in part, see
+ * percpu_counter_tree_precise_sum().
+ * The comparison between counters is on the wrapped difference. It is valid
+ * only when the two counters differ by less than LONG_MAX, and results are
+ * undefined beyond that.
+ *
+ * Return:
+ * * %0		- Counters are equal.
+ * * %-1	- Counter @a less than counter @b.
+ * * %1		- Counter @a is greater than counter @b.
+ */
+int percpu_counter_tree_precise_compare(struct percpu_counter_tree *a,
+					struct percpu_counter_tree *b)
+{
+	long count_a = percpu_counter_tree_approximate_sum(a),
+	     count_b = percpu_counter_tree_approximate_sum(b);
+	unsigned long accuracy_a = percpu_counter_tree_accuracy(a),
+		      accuracy_b = percpu_counter_tree_accuracy(b);
+	long delta = wrapped_delta(count_a, count_b);
+	int res;
+
+	/* See the range geometry above compare_delta(). */
+	res = compare_delta(delta, accuracy_a + accuracy_b);
+	/* The values are distanced enough for an accurate approximated comparison. */
+	if (res)
+		return res;
+
+	/*
+	 * The approximated comparison is within the accuracy range, therefore at least one
+	 * precise sum is needed. Sum the counter which has the largest accuracy first.
+	 */
+	if (accuracy_b < accuracy_a) {
+		count_a = percpu_counter_tree_precise_sum(a);
+		/* precise_a - approx_b: only b's precise range remains. */
+		res = compare_delta(wrapped_delta(count_a, count_b), accuracy_b);
+		if (res)
+			return res;
+		/* Precise sum of second counter is required. */
+		count_b = percpu_counter_tree_precise_sum(b);
+	} else {
+		count_b = percpu_counter_tree_precise_sum(b);
+		/* approx_a - precise_b: only a's precise range remains. */
+		res = compare_delta(wrapped_delta(count_a, count_b), accuracy_a);
+		if (res)
+			return res;
+		/* Precise sum of second counter is required. */
+		count_a = percpu_counter_tree_precise_sum(a);
+	}
+	delta = wrapped_delta(count_a, count_b);
+	if (delta < 0)
+		return -1;
+	if (delta > 0)
+		return 1;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_precise_compare);
+
+/**
+ * percpu_counter_tree_precise_compare_value - Precise comparison of a counter tree against
+ *					       a given value.
+ * @counter: Counter to compare.
+ * @v: Value to compare.
+ *
+ * Evaluate a precise comparison of a counter tree against a given value. As
+ * an optimization, it uses the approximate counter comparison to quickly
+ * identify whether the counter and value are far apart. Only cases where the
+ * value is within the counter accuracy range require a precise counter sum.
+ * With concurrent updates, the precise sum can count updates in part, see
+ * percpu_counter_tree_precise_sum().
+ * The comparison between counters is on the wrapped difference. It is valid
+ * only when @v and the counter differ by less than LONG_MAX, and results are
+ * undefined beyond that.
+ *
+ * Return:
+ * * %0		- The value @v is equal to the counter.
+ * * %-1	- The value @v is less than the counter.
+ * * %1		- The value @v is greater than the counter.
+ */
+int percpu_counter_tree_precise_compare_value(struct percpu_counter_tree *counter, long v)
+{
+	long count = percpu_counter_tree_approximate_sum(counter), delta;
+	unsigned long accuracy = percpu_counter_tree_accuracy(counter);
+	int res;
+
+	/* See the range geometry above compare_delta(). */
+	res = compare_delta(wrapped_delta(v, count), accuracy);
+	/* The values are distanced enough for an accurate approximated comparison. */
+	if (res)
+		return res;
+
+	/* Precise sum is required. */
+	count = percpu_counter_tree_precise_sum(counter);
+	delta = wrapped_delta(v, count);
+	if (delta < 0)
+		return -1;
+	if (delta > 0)
+		return 1;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_precise_compare_value);
+
+/**
+ * percpu_counter_tree_set - Set the counter tree sum to a given value.
+ * @counter: Counter to set.
+ * @v: Value to set.
+ *
+ * Set the counter sum to a given value. It can be useful for instance
+ * to reset the counter sum to 0. Note that even after setting the
+ * counter sum to a given value, the counter sum approximation can
+ * return any value within the accuracy range around that value.
+ *
+ * The caller is responsible for preventing concurrent updates and
+ * precise sums of @counter while it is being set.
+ */
+void percpu_counter_tree_set(struct percpu_counter_tree *counter, long v)
+{
+	WRITE_ONCE(counter->bias, v - percpu_counter_tree_precise_sum_unbiased(counter));
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_set);
+
+/**
+ * percpu_counter_tree_approximate_accuracy - Query the accuracy of a counter tree.
+ * @counter: Counter to query.
+ *
+ * The approximation differs from the precise sum by the residuals not yet propagated
+ * up the tree. The residuals of all levels are symmetric, so the approximation is
+ * within the same distance of the precise sum in both directions.
+ * The accuracy is derived from the hardware topology and the counter tree batch size.
+ * It is invariant for a given counter tree.
+ * The accuracy describes a settled counter: one with no update in progress.
+ * An update in flight between its per-CPU update and its carry propagation is not covered.
+ * Using this function should not be typically required, see the following functions instead:
+ * * percpu_counter_tree_approximate_compare(),
+ * * percpu_counter_tree_approximate_compare_value(),
+ * * percpu_counter_tree_precise_compare(),
+ * * percpu_counter_tree_precise_compare_value().
+ *
+ * Return: The accuracy of the counter: the approximate sum of a settled counter
+ * is within [precise sum - accuracy, precise sum + accuracy].
+ */
+unsigned long percpu_counter_tree_approximate_accuracy(struct percpu_counter_tree *counter)
+{
+	return percpu_counter_tree_accuracy(counter);
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_approximate_accuracy);
+
+/* Calculate the number of tree items and the accuracy multiplier. */
+static
+void __init calculate_topology(void)
+{
+	unsigned int nr_levels = tree_topology.config->nr_levels, level;
+	unsigned int level_items = 1U << tree_topology.nr_cpus_order;
+	unsigned long batch_size = 1;
+
+	/* The root, and the items of each level above level 0. */
+	tree_topology.nr_items = 1;
+	/* One batch per level 0 counter: see percpu_counter_tree_accuracy(). */
+	tree_topology.accuracy_multiplier = nr_cpu_ids;
+
+	/*
+	 * The multiplier is derived from a batch size of 1 to speed up
+	 * calculating the accuracy at tree initialization. A level N
+	 * counter holds at most BATCH(level N) - BATCH(level N - 1) in
+	 * either direction.
+	 */
+	for (level = 1; level < nr_levels; level++) {
+		unsigned int n_arity_order = tree_topology.config->n_arity_order[level - 1];
+
+		level_items >>= n_arity_order;
+		tree_topology.nr_items += level_items;
+		tree_topology.accuracy_multiplier +=
+			((batch_size << n_arity_order) - batch_size) * level_items;
+		batch_size <<= n_arity_order;
+	}
+}
+
+#if IS_ENABLED(CONFIG_KUNIT)
+/*
+ * Validate the configuration table: the n-arity orders of each entry must
+ * sum to its order.
+ *
+ * Return: The number of invalid entries.
+ */
+unsigned int percpu_counter_tree_check_config(void)
+{
+	unsigned int order, nr_errors = 0;
+
+	for (order = 0; order < ARRAY_SIZE(per_nr_cpu_order_config); order++) {
+		const struct counter_config *c = &per_nr_cpu_order_config[order];
+		unsigned int level, shift = 0;
+
+		for (level = 0; level < c->nr_levels; level++)
+			shift += c->n_arity_order[level];
+		if (shift != order) {
+			pr_err("order %u: arity sum %u\n", order, shift);
+			nr_errors++;
+		}
+	}
+	return nr_errors;
+}
+EXPORT_SYMBOL_IF_KUNIT(percpu_counter_tree_check_config);
+
+/*
+ * Check the invariants of a settled counter (no update in progress):
+ * - a level 0 counter is within (-BATCH(level 0), +BATCH(level 0)),
+ * - a counter at level N, above level 0, holds a multiple of
+ *   BATCH(level N - 1) within (-BATCH(level N), +BATCH(level N)),
+ * - the root holds a multiple of the batch of the last level.
+ *
+ * Return: The number of violated invariants.
+ */
+unsigned int percpu_counter_tree_check_residuals(struct percpu_counter_tree *counter)
+{
+	unsigned int nr_levels = tree_topology.config->nr_levels, level, level_items,
+		     nr_errors = 0, stride = counter->items_stride;
+	atomic_long_t *item = percpu_counter_tree_items(counter);
+	unsigned long lo = percpu_counter_tree_batch_size(counter);
+	long root;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		long v = READ_ONCE(*per_cpu_ptr(counter->level0, cpu));
+
+		if (v <= -(long)lo || v >= (long)lo) {
+			pr_err("cpu %d: level 0 residual %ld, batch %lu\n", cpu, v, lo);
+			nr_errors++;
+		}
+	}
+	level_items = 1U << tree_topology.nr_cpus_order;
+	for (level = 1; level < nr_levels; level++) {
+		unsigned int n_arity_order = tree_topology.config->n_arity_order[level - 1], i;
+		unsigned long hi = lo << n_arity_order;
+
+		level_items >>= n_arity_order;
+		for (i = 0; i < level_items; i++) {
+			long v = atomic_long_read(&item[i * stride]);
+
+			if (v <= -(long)hi || v >= (long)hi || ((unsigned long)v & (lo - 1))) {
+				pr_err("level %u item %u: residual %ld, batch %lu\n",
+				       level, i, v, hi);
+				nr_errors++;
+			}
+		}
+		item += level_items * stride;
+		lo = hi;
+	}
+	root = atomic_long_read(counter->approx_sum);
+	if ((unsigned long)root & (lo - 1)) {
+		pr_err("root %ld: not a multiple of %lu\n", root, lo);
+		nr_errors++;
+	}
+	return nr_errors;
+}
+EXPORT_SYMBOL_IF_KUNIT(percpu_counter_tree_check_residuals);
+
+/*
+ * Copy the state of counter @src into counter @dst, initialized with the
+ * same batch size and without concurrent updates: their per-CPU counters,
+ * tree items and bias.
+ */
+void percpu_counter_tree_copy_state(struct percpu_counter_tree *dst,
+				    struct percpu_counter_tree *src)
+{
+	atomic_long_t *dst_items = percpu_counter_tree_items(dst),
+		      *src_items = percpu_counter_tree_items(src);
+	unsigned int pos;
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		*per_cpu_ptr(dst->level0, cpu) = *per_cpu_ptr(src->level0, cpu);
+	for (pos = 0; pos < tree_topology.nr_items; pos++)
+		atomic_long_set(&dst_items[pos * dst->items_stride],
+				atomic_long_read(&src_items[pos * src->items_stride]));
+	dst->bias = src->bias;
+}
+EXPORT_SYMBOL_IF_KUNIT(percpu_counter_tree_copy_state);
+#endif
+
+/* Format the fan-out of each level, from level 0 to the root, e.g. "8,2,8". */
+static
+int format_shape(char *buf, size_t size, const struct counter_config *config)
+{
+	unsigned int level;
+	int len = 0;
+
+	for (level = 0; level < config->nr_levels; level++)
+		len += scnprintf(buf + len, size - len, "%s%u", level ? "," : "",
+				 1U << config->n_arity_order[level]);
+	return len;
+}
+
+int __init percpu_counter_tree_subsystem_init(void)
+{
+	char shape[8 * MAX_NR_LEVELS + 1] = "";
+
+	tree_topology.nr_cpus_order = get_count_order(nr_cpu_ids);
+	if (tree_topology.nr_cpus_order >= ARRAY_SIZE(per_nr_cpu_order_config)) {
+		pr_err("Unsupported number of CPUs (%u)\n", nr_cpu_ids);
+		return -EINVAL;
+	}
+	tree_topology.config = &per_nr_cpu_order_config[tree_topology.nr_cpus_order];
+	calculate_topology();
+	tree_topology.items_cachep =
+		kmem_cache_create("percpu_counter_tree_items",
+				  tree_topology.nr_items * SMP_CACHE_BYTES,
+				  SMP_CACHE_BYTES, SLAB_PANIC, NULL);
+	format_shape(shape, sizeof(shape), tree_topology.config);
+	pr_info("%u CPUs, fan-out %s, %u tree items\n",
+		nr_cpu_ids, tree_topology.nr_cpus_order ? shape : "none",
+		tree_topology.nr_items);
+	return 0;
+}
-- 
2.47.3


