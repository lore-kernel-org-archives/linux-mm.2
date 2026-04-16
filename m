Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9B1FF8A146
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 09:10:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3F466B0005; Thu, 16 Apr 2026 05:10:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F16856B0089; Thu, 16 Apr 2026 05:10:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E532D6B008A; Thu, 16 Apr 2026 05:10:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D4C7C6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:10:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 87192C2902
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:10:30 +0000 (UTC)
X-FDA: 84663848220.09.C8B4C71
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id D8F5E40009
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:10:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oTPvzIgL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776330629; a=rsa-sha256;
	cv=none;
	b=75TxCmRZKz7gQXSK1qaLs0fGDSokbE1fyU4TkV/XC4cM9ivM5aXtV/arhhJSTuIFcnsukB
	n29GzWgyxPZxBSgDWR+5oNwJ1D4aTPOfQMOTHkQWyxvEYmKuq0pmktt91VAdrdyH5sm+KT
	m/pbiQkIh1yR9K5wM7RolKX77PsqnCQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oTPvzIgL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776330629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3PMkvBbUqEE4rpKvA05kkxj38UAP8MllAb0e2po2fTs=;
	b=XIfx0HciO2fZrQ+z03yMYo7oZTFUVntTwDZ19uLCcmEMqGU9EUMR4OEGYDiSdc28pwG0oR
	iGHhB17il0l3DpQimCHc1ZRDRCmvFs81U7zLAciVwInyfIc6PE1/MmOwLPYEzawIjMt8jR
	6wZxvrVrc6IGurP6eOSPL6IDhoiE6wI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D4BAF43709;
	Thu, 16 Apr 2026 09:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A249C2BCAF;
	Thu, 16 Apr 2026 09:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776330627;
	bh=uZlWW/ny1fbjNrth95d6p0NzCm2ARch+5GxGfyr6RWw=;
	h=From:To:Cc:Subject:Date:From;
	b=oTPvzIgLGnC93OUsU0o8B8xb10kelaxog2gBtrpi/1oq2BFV12vfNJN9O8USiF/ds
	 1ypFjtJtU4WqLMo6ix/Fd0kuW99oJEGYpQyiTpHL4bNpg/1Bm2OWWLJsSGnRqAQnGM
	 DMOMDXdIj9L2pJvDSJCgQ66356i8qYFeDaWs4BfVGdfwZ+JTxIpGbSet1yNRD3NxNB
	 ftsobdSrp/k13LXjfasOG8L2dIiPWgFvM9u11NS1eThWuhFl2Rh7zVMfGssi1YDQK6
	 5IiKJ7vwQLWclX2sX/OnZfIBJ9kH04GYoHlrVdxnMIMFC+AVCbFFDh2aqNWUM3np6w
	 OS9LjDq47A9XQ==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>,
	Zqiang <qiang.zhang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	rcu@vger.kernel.org,
	linux-mm@kvack.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Subject: [RFC PATCH v2 0/8] kvfree_rcu() improvements
Date: Thu, 16 Apr 2026 18:10:14 +0900
Message-ID: <20260416091022.36823-1-harry@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: as1a4r6cma1pn3ccxzaupeuk57ftqpji
X-Rspam-User: 
X-Rspamd-Queue-Id: D8F5E40009
X-HE-Tag: 1776330628-665901
X-HE-Meta: U2FsdGVkX1/L0pmdBITlHE0tcUun7I+MPUv+G/VXOtR6yzIRj7cpiOVlTAOB89S12ZfR73wIasjXcWfhqI6YzlOt3BBkvG9EVv7LvFpiZrYMd1fJ7RJBMK+hMt3NlaZd64pX6bpF0NJoXG+XbMTvrsTjto0MEzgUAQLM8cLZgYpTFfY2uagPuj0tUyXKWXurn+H9K+uz/NMCM5YYTJfQsyLAi1BTEKyk8BVMNC4JOjDsdvfDUZ4xeYRVyAWnpnGMI9OLNY9y9THODLIhHJ3coMHKl+9CBFCMgTvp33Yx2d40ZNl1N2LEBZfW/7nNXdICk+61oDqbF3VwiuRYnJKi2aEzYFR/I3vonKPVXQBtmEZ7XPNQ7XN6npbl9fezTK7/9/YafwP3cUA6pUL0nHm+Fjf8q1XIOZhaE1JKhu0ktdvoWtSvMYTdu6CsTR+R5L+9QXc8SA5Mie0vvZwFLsE6QkEaID4C+7E41QJCE7zylCW3L93OaUEcHMH86UPvl/1yxQwHSazQBOoUE8pXekcC3kaA8b8Fc7Hr9HUYSwHcaQBvIx0glsoYGCv4bpQe45Fj+iHN/OeplL4PQM1gVq+FAoYgLd/KItDedmWWyOxmC7658njRqhm2t37dqSjzoo24Ov4IlszPlmNDkebwETz8N1WN4kv2JRE1V3+6/WWBQo/Gc/mRCrbXdSWcPuTAOC75BRztdm9UHoyvXfUKrhOuteibSCh7AmmuhBXPUaSlC4uRd/7U8JR3iiswtae7srSdmcVaf1tccctzISgE6F/BFwvH5t/RvQ8VfDlZik7+qdve2XKrQWRf7Koq2pZfYWL4vMVDLoMU2OrHayhs93/BmDahR4uqeY10b6jOVkZOhUrhCz42kIpb9tw9jccTrci0bW+ts7FkOeTqYy5HRHyC12/aalHmirEH0CTVmxPvaPpO0ae8T3gkJTXJ3dDUT0fITfOQTAZXEp0drpP09na
 9bh8UP6G
 9ztiWSEVa88AyKUQN/ab+BdJKUbeLCkP8E6nT7KfAP99whxN4zF8Y/M2ofcHzlctQ39BaikoYABsJHALrotr61KkZNLYjymoKvWXv7ZZOl5QikOsd5bWBCt+LRU4QDcW4KGdedcpYejvEdTZe9wUpgiqNgPXFhYqi/PEdNinEvywVzvpfZryUgackbUvGi3r+MrKoCC/PpOw1jDKOTNMUm4I5OMdhR6piYsAB3y88IlswQNiGm/Ueaxpu+9GgslQMx++wOO7hXw5vPYCEw19MGE0fHlpohyPFdMPswUNFr4KIVRgG3R0gKDbFQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These are a few improvements for k[v]free_rcu() API,
suggested by Alexei Starovoitov. This aims to tackle two problems:

  1) Allow an 8-byte field to be used as an alternative to
     struct rcu_head (16-byte) for 2-argument kvfree_rcu()
     to save memory.

  2) Add kfree_rcu_nolock() API for an unknown context.

  "Unknown context" means the caller does not know whether spinning
  on a lock is safe. For example, a BPF program attached to an
  arbitrary kernel function may run while the CPU already holds
  krcp->lock. However, in practice, it's not held most of the time.

# Discussion

Now that we have sheaves for kmalloc caches, most of frees go through
the sheaves layer. However, when sheaves becomes full w/ !allow_spin,
call_rcu() cannot be called because the context is unknown. (e.g., it
might have preempted call_rcu()). There are two possible approaches:

  a) Implement a general call_rcu_nolock() in the RCU subsystem that
     defers call_rcu() when it's not safe.

  b) Handle this as a special case only for rcu sheaf submission
     in mm/slab_common.c, without touching the RCU core.

This series takes approach (b). This is because a general
call_rcu_nolock() would need to flush deferred callbacks before
rcu_barrier() to preserve its guarantee, increasing the cost of
rcu_barrier() for all RCU users, not just kfree_rcu. By keeping the
deferred call_rcu logic in the slab subsystem, only
kvfree_rcu_barrier() pays the extra cost.

One downside of the current approach is that slab uses the condition
`!allow_spin && irqs_disabled()` to determine whether it's safe to
call call_rcu(), which creates a dependency on RCU's implementation
details. I'd like to hear thoughts on this.

# Part 1. Allow an 8-byte field to be used as an alternative to
  struct rcu_head for 2-argument kvfree_rcu()
  (patches 1-2)

Technically, objects that are freed with k[v]free_rcu() need
only one pointer to link objects, because we already know that
the callback function is always kvfree(). For this purpose,
struct rcu_head is unnecessarily large (16 bytes on 64-bit).

Allow a smaller, 8-byte field (of struct rcu_ptr type) to be used
with k[v]free_rcu(). Let's save one pointer per slab object.

I have to admit that my naming skill isn't great; hopefully
we'll come up with a better name than `struct rcu_ptr`.

With this feature, either a struct rcu_ptr or rcu_head field
can be used as the second argument of the k[v]free_rcu() API.

Users that only use k[v]free_rcu() are may use struct rcu_ptr to save
memory (if there can be a lot of objects). However, some users,
such as maple tree, may use call_rcu() or k[v]free_rcu() for objects
of the same type. For such users, struct rcu_head remains the only
option.

Patch 1 implements the struct rcu_ptr feature (for
CONFIG_KVFREE_RCU_BATCHED), and patch 2 converts fs/dcache external_name
to use struct rcu_ptr as an example user, saving a pointer per
dynamically allocated external file name.

# Part 2. Add kfree_rcu_nolock() for unknown contexts
  (patches 3-8)

Currently, kfree_rcu() cannot be called when the context is unknown,
which might not allow spinning on a lock. In such a context, even
calling call_rcu() is not legal, forcing users to implement some
sort of deferred freeing. Let's make users' lives easier with
a new kfree_rcu_nolock() variant.

Note that only the 2-argument variant is supported, since there is
not much we can do when trylock & memory allocation fails.

When spinning on a lock is not allowed, try to acquire the spinlock
using spin_trylock(). When trylock succeeds, do either:

  1) Use the rcu sheaf to free the object. Note that call_rcu() cannot
     be called in an unknown context, because it might have preempted
     call_rcu(). When the rcu sheaf becomes full by freeing the object,
     defer the submission of the full sheaf using irq_work
     (defer_call_rcu).

  2) Use bnode (of struct kvfree_rcu_bulk_data) to store the pointer.
     If trylock succeeded but no cached bnode is available, fall back
     and queue page cache worker just like normal 2-args kvfree_rcu()
     path.

In rare cases where trylock fails, a non-lazy irq_work is used to
defer calling kvfree_call_rcu().

When certain debug features (kmemleak, debugobjects) are enabled,
freeing is always deferred because they use spinlocks.

Patch 3 moves code for preparation.
Patch 4 introduces kfree_rcu_nolock().
Patch 5 teaches the rcu sheaf to handle the !allow_spin case.
Patch 6 wraps rcu sheaf handling with CONFIG_KVFREE_RCU_BATCHED ifdef.
Patch 7 introduces deferred submission of rcu sheaves for the
!allow_spin case when IRQs are disabled.
Patch 8 adds a kunit test case for kfree_rcu_nolock().

Changes since RFC V1 [1]:
  - Dropped the kmalloc_nolock() -> kfree[_rcu]() path support
    and the objexts_flags cleanup as they already have landed mainline.
  - Dropped rcu_ptr conversions in mm/ (previous patch 2) and instead
    added struct external_name in fs/dcache.c as a user(new patch 2).
  - (Fix) Handle kfence addresses correctly using is_kfence_address()
    and kfence_object_start().
  - Reworked kfree_rcu_nolock() (patch 4):
    - When trylock succeeds, now attempts to use cached bnodes
      (like normal kvfree_rcu 2-arg path) instead of only inserting
      into krcp->head.
    - Added allow_spin parameter to __schedule_delayed_monitor_work()
      and run_page_cache_worker() to defer work submission via
      irq_work when spinning is not allowed (Joel).
    - (Fix) Introduced defer_kvfree_rcu_barrier() to flush deferred
      objects before flushing rcu sheaves, preserving correctness of
      kvfree_rcu_barrier().
    - (Fix) Moved kvfree_rcu_barrier()/kvfree_rcu_barrier_on_cache()
      to slab_common.c on CONFIG_KVFREE_RCU_BATCHED=n, and made them
      wait for deferred irq_works even without kvfree_rcu batching.
    - Introduced object_start_addr() helper to deduplicate the
      start address calculation logic.
  - Instead of falling back when the rcu sheaf becomes full,
    implemented deferred submission of rcu sheaves using irq_work
    (new patch 7) (Vlastimil, Alexei).
  - Wrapped rcu sheaf handling with CONFIG_KVFREE_RCU_BATCHED ifdef
    (new patch 6).
  - Added a kunit test for kfree_rcu_nolock() (new patch 8).

[1] RFC V1: https://lore.kernel.org/linux-mm/20260206093410.160622-1-harry.yoo@oracle.com

RFC V2 branch is available at:
https://git.kernel.org/pub/scm/linux/kernel/git/harry/linux.git/log/?h=kvfree-rcu-improvements-rfc-v2r1

RFC V1 branch is available at:
https://git.kernel.org/pub/scm/linux/kernel/git/harry/linux.git/log/?h=kvfree-rcu-improvements-rfc-v1r1

What haven't changed since RFC v1:

- PREEMPT_RT support for kfree_rcu_sheaf() (Vlastimil): that is worth
  addressing and I think it's doable, but it'll be a too big change to
  be part of this series.

- Reducing struct rcu_ptr on !KVFREE_RCU_BATCHED (Vlastimil): I tried,
  but I'm not still sure it's worth the complexity for
  CONFIG_KVFREE_RCU_BATCHED=n users. Also, this inevitably introduces
  some delay in freeing objects which is against the purpose of
  RCU_STRICT_GRACE_PERIOD.

- While writing this cover letter, just realized that I should probably
  try to reduce the number of irq work structures (pointed out by Joel)
  (at least to 2 for lazy and non-lazy instead of 4). Will explore this
  in the next version.

Harry Yoo (Oracle) (8):
  mm/slab: introduce k[v]free_rcu() with struct rcu_ptr
  fs/dcache: use rcu_ptr instead of rcu_head for external names
  mm/slab: move kfree_rcu_cpu[_work] definitions
  mm/slab: introduce kfree_rcu_nolock()
  mm/slab: make kfree_rcu_nolock() work with sheaves
  mm/slab: wrap rcu sheaf handling with ifdef
  mm/slab: introduce deferred submission of rcu sheaves
  lib/tests/slub_kunit: add a test case for kfree_rcu_nolock()

 fs/dcache.c              |   8 +-
 include/linux/rcupdate.h |  64 ++++--
 include/linux/slab.h     |  16 +-
 include/linux/types.h    |   9 +
 lib/tests/slub_kunit.c   |  73 +++++++
 mm/slab.h                |   8 +-
 mm/slab_common.c         | 452 +++++++++++++++++++++++++++++----------
 mm/slub.c                |  47 +++-
 8 files changed, 514 insertions(+), 163 deletions(-)


base-commit: 7e0445f673205fd045f3358cacb52b3557627317
-- 
2.43.0


