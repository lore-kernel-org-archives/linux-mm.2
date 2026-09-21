Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1BCDC982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 19:26:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9EC36B00C9; Mon, 21 Sep 2026 15:26:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E76286B00CB; Mon, 21 Sep 2026 15:26:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8C8B6B00CC; Mon, 21 Sep 2026 15:26:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD90D6B00C9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:26:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2BF78120281
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:26:38 +0000 (UTC)
X-FDA: 85238751276.03.ADCB964
Received: from mta0.migadu.com (out-163.mta0.migadu.com [91.218.175.163])
	by imf05.hostedemail.com (Postfix) with ESMTP id 340C2100002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:26:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h1YidvtP;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.163 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790018796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7f7EOXwzoamvWzGbNlpdrcMdL30l4l32b/eCwUyxVTM=;
	b=zMQn1LjOV6qiOT5L94PmUTCeh13ISInttfu1bRCk+3TtCd79FFj8cM0qZw2qXoi54AXymO
	aZ4IHg0WgF0oSHq6+Du2MzXYHGRJSeDmDqzCXBYHkFbZc5f1xl/COHIy0XMTRXQRzFRRem
	q2k5w7E8P/rFjpLggsxsgGLpvxCf34w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790018796;
	b=DKP5jakLezWbJhsCGsT6yd44i9nvzEfZKXEroo7Wjn/u+Nn2SPSkAlZ7AMROGm40zMfY9H
	5w+w4g5sJDC/qVCC7H8I1L38GZhmptdShIR/BB7BlAVbG2t61x5Cy1ehY6t3sU2Y5XnE8q
	T/GaK446yU4tggrqrfsmNuGln4u3KKM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h1YidvtP;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.163 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=S4IiI0QtQMZJ6UHYEdTwEsQ4SJWFZYS+fNpb6Z0WBxU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790018794; v=1; x=1790623594;
 b=h1YidvtPF/BMmhACJVDlhSVdqZR0Q2VpuuiNocO/6hDPxq3TbMfAZsyzHS1mMv8uIcDu7FX/
 OeDmh4XubtmXU/C1LU2QJPuaMSjAbnN+uFgJtv4ekidvhKwYEUsT/T1FsOp1IukiRrHag+7jU+a
 /GKyASDiqCEPLOz2n1qqBQVs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 923039e922c66b75;
	Mon, 21 Sep 2026 19:26:34 +0000
X-Mizu-Trace-ID: 923039e922c66b75
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <jp.kobryn@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Amery Hung <ameryhung@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	hui.zhu@linux.dev,
	Donet Tom <donettom@linux.ibm.com>,
	Greg Thelen <gthelen@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 4/4] selftests/bpf: add a cgroupfs lock-holder bpf_memcg_ops sample
Date: Mon, 21 Sep 2026 12:25:59 -0700
Message-ID: <20260921192559.2619635-5-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260921192559.2619635-1-shakeel.butt@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nnk39dhh84myxghnwz7zopck8fzjcgs7
X-Rspam-User: 
X-Rspamd-Queue-Id: 340C2100002
X-Rspamd-Server: rspam03
X-HE-Tag: 1790018795-966883
X-HE-Meta: U2FsdGVkX1/LbW7xjscb2pSfsaXx37MpKAwv9awG0bi9K7Sno4vYYiBKjDRSbcp54zhjSj6tp03qDEXZ3onpS3moWnv/8OSG+Sx5bkVW8Q/69GuHh2wKsXUUoPgHVSk4r5wDu96YuID58h0cOaI6TRBQnw0acrf3Wzu8jYrhRZ0QmthxgbtH7RiXbcN5bH4l7+UHMPFhWMes4bBgWq71PGOijyX3YrdI/3DGFl8BTGSZb+lfay9doB9111mJzJarPOJPmcj+5D6fwLXzAZ6Wd6gh11MLL5RzhxGCQmFOak7lww5AQuoVrvPCXJYrHBN8korEuGtlZVZ5+d4hyUZyN62MxHuZLwGf2v6ICPQgZaMkQqbthFIURB5C/mZk8j3heNNVlN/dBGLkl+Z3y0SGjmPADPnxrwcPgx6+MOzNlNvkCID6TJ3PL6tiHiHMHCmvBo4d8RGv2kPuaPJKuO8lO3ofmbM8kIDL6AI59bTlvX132z4Oxp5StJoOUr3EnjIV4FotjEkqPagHBRj2fLvSJ5dn+d2UeS218db92rp5BUp5/InvDsxpZ010quBjWffbHWJY25cPmjSMiyJiHNSilRtqKdVIzjzqrkPXGW4rpmnNQBtowwe0d9rcPetayzHwHusfTt8AGUNKmYCO1d1gAa20Kic8vSTXXOeCPT1JuVIfwzvHECZiC3EOORxm8hPlPng06x1rp4Fv3ewJx8+aSUFINjmOiSTjh7vScn4vmM73DW477yak9TpYY6QQhxC0qSQAnC418NxnVBJE9VUbernvYJH7mCnw3GXFfbX0o3V2g1wtnoxUfASEZrTJAZZaXgu5TDVqETWWtaUuLGJMhpJIVKPQ3TgKfbYGKVDlixL3yjrkFdL0riQJdH03qlZH6HNejmMLyzMxB6Cs6GyGjQ8hPy0um8aREidP0lC90vNNKLln7Q7rm+AQqO5ZnEPl8ObER7YPn1vvMdov/QO
 ZDUOrjBu
 jmCl+TuVY78US/XZ93I5YqGLJSWCJRVTIceJKPQuc1vVLatr3HrEb43B/iJdxklbgq5kAZbhAn/4k4xCXPv1ODbqQsiCmsdkdHYi3rUTvHr5afRJHTdvcceLqD8A2BOZwT3QOXpTVspw3vZoB+avy+3lte6xnny1jJ04WTdj9pNW7rCy4JzjhzGN7AmXIFL3/0QpRqRWoRHynNxDkmTZQRZOflMKKD9LGHzvyFBHXDKJzD5FBDHplVAwFZqWdbJGbnxG9XLCVdAraKrNlinmodLL/qxNAhQfNCsIptaCdHnRgpMFunSh56zOTLdEqZVvQdhO4jmH89Nn4su3C3nBiBnO9+kDBRxkxdgW/mYsxmHj/mxWhXq3ksGkwqEXtvdM5zIAzGx2GDB+qDBI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A bpf_memcg_ops policy that keeps tasks holding a cgroupfs kernfs lock out
of inline memory.high enforcement.

About forty functions take that lock, one of them through guard(rwsem_read),
so the sample tracks the lock rather than its callers.  A SEC("syscall")
program finds kernfs_rwsem and kernfs_supers_rwsem inside
cgrp_dfl_root.kf_root, and fentry/fexit on the rwsem primitives keeps a
per-task depth for those two addresses.  Every other kernfs user has its own
kernfs_root, so its own locks, which keeps this to cgroupfs.

down_*() return once the lock is held, so an acquire is counted on their
exit and a release on the entry of up_*().  The killable, interruptible and
trylock forms are covered too, checking the return so a failed acquire does
not count.  downgrade_write() needs no hook.  The depth is clamped at zero
for tasks already holding the lock when the hooks went on.

Two counters guard against passing for the wrong reason: one counts a holder
that reached inline enforcement anyway, and one counts a holder that could
not be tracked.  Both must be 0.

Measured with a reproducer [1] for the bug fixed by the patch proposed
in [2], on a kernel without that fix:

                                      baseline    policy    upstream fix
  max kernfs_rwsem hold, worker        2.049 s     199 us   not taken
  max kernfs_supers_rwsem hold         2.049 s     4.8 ms   2.056 s
  max kernfs_rwsem write wait          4.096 s     6.2 ms   8.7 ms
  walker passes over /sys/fs/cgroup        352       5711   6700
  churn mkdir+rmdir ops                 13 059    364 832   415 488
  churn max latency                     30.7 s    15.1 ms   12.7 ms

The policy does better than the fix on kernfs_supers_rwsem, which the fix
does not help: it drops kernfs_rwsem from the delivery loop, while the
policy stops the worker stalling at all.

The throughput columns are about 8% under what the same policy reaches
hooking one function.  That is the cost of the tracking and motivates
more optimized way to track the shared locks which can cause isolation
issues between unrelated workloads.

There is no harness yet, so these numbers come from the reproducer and not
from the test suite.

[1] https://github.com/shakeelb/mempressure-repros/tree/main/kernfs-notify-memcg
[2] https://lore.kernel.org/20260910045406.485295-1-shakeel.butt@linux.dev/

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 .../bpf/progs/memcg_ops_lockholder.c          | 222 ++++++++++++++++++
 1 file changed, 222 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_ops_lockholder.c

diff --git a/tools/testing/selftests/bpf/progs/memcg_ops_lockholder.c b/tools/testing/selftests/bpf/progs/memcg_ops_lockholder.c
new file mode 100644
index 000000000000..09a74f21f3da
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/memcg_ops_lockholder.c
@@ -0,0 +1,222 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Keep tasks holding a cgroupfs kernfs lock out of inline memory.high
+ * enforcement.
+ */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+
+char _license[] SEC("license") = "GPL";
+
+/* cgrp_dfl_root has no BTF variable, so take it as an untyped ksym. */
+extern const void cgrp_dfl_root __ksym;
+
+/* Set by resolve_locks() below, before any of the hooks are attached. */
+__u64 kernfs_rwsem_addr;
+__u64 kernfs_supers_rwsem_addr;
+
+struct lock_state {
+	__s32 depth;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_TASK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, struct lock_state);
+} lock_state SEC(".maps");
+
+/* Charges from a task holding one of the locks: each is a stall avoided. */
+__u64 deferrals;
+/* Charges from everyone else, where we said nothing. */
+__u64 passthroughs;
+/* A holder reached inline enforcement anyway.  Must stay zero. */
+__u64 violations;
+/*
+ * A holder went untracked because task storage could not be created.  That
+ * looks just like a pass, and gets likelier under the pressure we are
+ * testing.  Must stay zero too.
+ */
+__u64 mark_failures;
+
+/*
+ * Find the two rw_semaphores in the cgroup2 kernfs_root.  The loader runs this
+ * once before attaching the hooks, so none of them sees a zero address.  Every
+ * other kernfs user has its own kernfs_root, hence its own locks, which is
+ * what keeps this to cgroupfs.
+ */
+SEC("syscall")
+int resolve_locks(void *ctx)
+{
+	struct cgroup_root *root = (struct cgroup_root *)&cgrp_dfl_root;
+	struct kernfs_root *kf;
+
+	kf = BPF_CORE_READ(root, kf_root);
+	if (!kf)
+		return 1;
+
+	kernfs_rwsem_addr = (__u64)kf +
+		bpf_core_field_offset(struct kernfs_root, kernfs_rwsem);
+	kernfs_supers_rwsem_addr = (__u64)kf +
+		bpf_core_field_offset(struct kernfs_root, kernfs_supers_rwsem);
+	return 0;
+}
+
+static __always_inline bool is_cgroup_kernfs_lock(const void *sem)
+{
+	__u64 addr = (__u64)sem;
+
+	return addr && (addr == kernfs_rwsem_addr ||
+			addr == kernfs_supers_rwsem_addr);
+}
+
+static __always_inline void note_acquire(const void *sem)
+{
+	struct lock_state *st;
+
+	if (!is_cgroup_kernfs_lock(sem))
+		return;
+
+	st = bpf_task_storage_get(&lock_state, bpf_get_current_task_btf(), NULL,
+				  BPF_LOCAL_STORAGE_GET_F_CREATE);
+	if (!st) {
+		__sync_fetch_and_add(&mark_failures, 1);
+		return;
+	}
+	st->depth++;
+}
+
+static __always_inline void note_release(const void *sem)
+{
+	struct lock_state *st;
+
+	if (!is_cgroup_kernfs_lock(sem))
+		return;
+
+	st = bpf_task_storage_get(&lock_state, bpf_get_current_task_btf(), NULL, 0);
+	if (!st)
+		return;
+	/* A task already holding it when we attached has no acquire to match. */
+	if (st->depth > 0)
+		st->depth--;
+}
+
+/*
+ * down_*() return once the lock is held, so the hold runs from their exit to
+ * the entry of up_*().  That excludes the wait.
+ *
+ * downgrade_write() needs no hook: the lock stays held, and the up_read()
+ * after it pairs with the original down_write().
+ */
+
+SEC("fexit/down_read")
+int BPF_PROG(down_read_exit, struct rw_semaphore *sem)
+{
+	note_acquire(sem);
+	return 0;
+}
+
+SEC("fexit/down_write")
+int BPF_PROG(down_write_exit, struct rw_semaphore *sem)
+{
+	note_acquire(sem);
+	return 0;
+}
+
+/* The killable and interruptible forms return 0 when they got the lock. */
+SEC("fexit/down_read_killable")
+int BPF_PROG(down_read_killable_exit, struct rw_semaphore *sem, int ret)
+{
+	if (!ret)
+		note_acquire(sem);
+	return 0;
+}
+
+SEC("fexit/down_read_interruptible")
+int BPF_PROG(down_read_interruptible_exit, struct rw_semaphore *sem, int ret)
+{
+	if (!ret)
+		note_acquire(sem);
+	return 0;
+}
+
+SEC("fexit/down_write_killable")
+int BPF_PROG(down_write_killable_exit, struct rw_semaphore *sem, int ret)
+{
+	if (!ret)
+		note_acquire(sem);
+	return 0;
+}
+
+/* The trylocks return 1 when they got the lock. */
+SEC("fexit/down_read_trylock")
+int BPF_PROG(down_read_trylock_exit, struct rw_semaphore *sem, int ret)
+{
+	if (ret == 1)
+		note_acquire(sem);
+	return 0;
+}
+
+SEC("fexit/down_write_trylock")
+int BPF_PROG(down_write_trylock_exit, struct rw_semaphore *sem, int ret)
+{
+	if (ret == 1)
+		note_acquire(sem);
+	return 0;
+}
+
+SEC("fentry/up_read")
+int BPF_PROG(up_read_enter, struct rw_semaphore *sem)
+{
+	note_release(sem);
+	return 0;
+}
+
+SEC("fentry/up_write")
+int BPF_PROG(up_write_enter, struct rw_semaphore *sem)
+{
+	note_release(sem);
+	return 0;
+}
+
+/* If a holder gets here, the policy did not work. */
+SEC("fentry/__mem_cgroup_handle_over_high")
+int BPF_PROG(over_high_enter)
+{
+	struct lock_state *st;
+
+	st = bpf_task_storage_get(&lock_state, bpf_get_current_task_btf(), NULL, 0);
+	if (st && st->depth > 0)
+		__sync_fetch_and_add(&violations, 1);
+	return 0;
+}
+
+/* BPF_PROG() uses "ctx" for the raw argument array, hence "mctx" here. */
+SEC("struct_ops")
+__u32 BPF_PROG(kernfs_high_policy, const struct bpf_memcg_ctx *mctx)
+{
+	struct lock_state *st;
+
+	/*
+	 * mctx->task is the charging task.  No F_CREATE, so this is just an
+	 * RCU read, and the counters are atomics on .bss.  Both are fine here.
+	 */
+	st = bpf_task_storage_get(&lock_state, mctx->task, NULL, 0);
+	if (!st || st->depth <= 0) {
+		__sync_fetch_and_add(&passthroughs, 1);
+		return BPF_MEMCG_HIGH_NO_OPINION;
+	}
+
+	__sync_fetch_and_add(&deferrals, 1);
+
+	/* The kernel ORs this with what the other policies return. */
+	return BPF_MEMCG_HIGH_DEFER_INLINE;
+}
+
+SEC(".struct_ops.link")
+struct bpf_memcg_ops kernfs_lockholder = {
+	.high_policy = (void *)kernfs_high_policy,
+};
-- 
2.53.0-Meta


