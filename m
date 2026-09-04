Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B8E9C624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:20:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 780B66B008A; Fri,  4 Sep 2026 06:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 758446B008C; Fri,  4 Sep 2026 06:20:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6474E6B0095; Fri,  4 Sep 2026 06:20:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 398816B008A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:20:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CD4A0140513
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:20:42 +0000 (UTC)
X-FDA: 85175685924.07.0941728
Received: from mta0.migadu.com (out-34.mta0.migadu.com [91.218.175.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id C51FA100007
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:20:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PQFUkLx6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.34 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788517241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Of7RSoon2HKaCSPxSM4nQgfeDIDCAqDEhkpJnvWECZk=;
	b=0n3g1H1f1E8pZJS8L5XMh1DG1ZsDBRKx5B77ZnOXY14p7nLHZtw0fVbDfdS7/Hl59CT7v/
	TprOeP0XxCrufCmf9vKkWiUqV2Iy1kyHPq9YFE/3p6mn0kfydffIfDLXuq57KTzadSTpht
	tXYWAPs8XLjCms1ViR44GMh/RjS30SE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PQFUkLx6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.34 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788517241;
	b=v1gBN9DjJNZTfmTX5+B2BcERFPmLMoA7+zVRrvXoRsDILHGKwlYzxZISwxy0ix7CiUhbrD
	ZFTkmIgLzc7X+Kpm7yLgITQe+1soqgpXtGT/R8wvzkJuxGorjmEZ8Wj2/Zgk1kc4KlAdwY
	yTjNVLDSOG2UKq3vrgslauJGYDnUOUU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=e2bYH44q/8AfgjOwJwS9piErOJXaBSrhE6dzjbPUEFA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788517239; v=1; x=1789122039;
 b=PQFUkLx6vIbnrDgu35T+/jFGQF8cj5E83PUt6tLx4eAWu7T7FMO31vK41WWYCTW17kQl5Oub
 9ZNi3+CPz9NKZ7YjQOf4N6FTqCBBZYMaJd/Atxi+qwD2XmYZlzPE+orAac1GjJxJZlqYZcKVgag
 EAmWijw+JqdKs/etp+XC7Tlk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4403d1e925e362b7;
	Fri, 04 Sep 2026 10:20:39 +0000
X-Mizu-Trace-ID: 4403d1e925e362b7
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Shuah Khan <shuah@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH bpf-next v7 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
Date: Fri,  4 Sep 2026 18:20:19 +0800
Message-ID: <7d8b77dc99ffe99a7bef874a257472fdaaf07e1c.1788516769.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1788516769.git.zhuhui@kylinos.cn>
References: <cover.1788516769.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5mqitam75wd8ia8586fax1dack8gfg7m
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C51FA100007
X-Rspam-User: 
X-HE-Tag: 1788517240-349646
X-HE-Meta: U2FsdGVkX19pgqwXwejA0Gt+QMAXkrrrHPkYRESyRZNGzltZsRaVSgkQWrRTMwi/kCxagrKtdd861ZdzTt/MrcCycSWxrtGRt5oHW725Yw8bZl/KVN5U+L3piwEDx/V3zREiu4jyLecWkmzEQRTbb2bG11tYVsUG/JZNxR/5hDsnp5zCrTtuxlubA6zsd7/yAwxJtf54uNttHwNwDBtgxTZR2L97O+QXsZsA3hRnc5uXIfDz/PcrjFNyUuPGEYdVhR0EcZ5fFwlXUdAIJTssEz4Wz0UoUYda7Hb5Z+urZhG+5S8JiZniBGLfS34sy1OsTo+4JHVKXUNvFStAjr7niiN7cGbnQmCKwe9FXRUuYAE5vRNA2n5yy97siRyICXWOYXc0OSPyJ3Fk3YNO6b3PsR71o+zOR0RmG6p9P5/O6ovdt+IT4W/cuta7bAkjQDVs2x/Y/AC39veNkm0v2H2iQyUMipPpIpE4oc2TZxW4Ui+cqV24xtHgZ4OuFn+xlMU+qub5hk68jZj/bfjxieS3o93clzh1y+F+jVysrRGwAWDrhtdqzxXdmE6aU74Mwbqyn8L3HuH1u0g2Wx93bFuwPVjHgYIxwkH1I9EZFIoza+/LC1cGJ+CYaFz1zbDE7SlUBmnN/f3Z1plCPyhGISHkonfc/mdek7LRbAL1SlAjEOHugRlqNhylSdx9qx1Zl9ucqgRT5XIL3RPIoDaEVkZniYQ+GOFBs7er31jJQEO0XLlR2XFzxTcVVWCo9BH4PI/lYYcc8UZd4af3Pi3TU79PCtbwKRVYwLScD/SFioPeFA//0WeENZkkaZScnmTNJw59dLDDSR2ibqM4+RTaNLUu9wMe32G5+q6Qtl6SVIq4E5U5/6rMwreN3jMMO3CYZqTm3Vr+jp4IOuNsf5Csa2EL+yVtvFqf2et5am8PmzM+xL+0HOOvf9bbT8MFTFlNco6TdwaKhte0gtLb7JvJsLF
 4umrHYKz
 HCr9X/fj/Z7yoD9lr0W+MK00bNwFV7tjhakIs9YenA3yLKxpVt1EiZUTObo5Z5E5pX6fB51Qd6it+G0hpC/kJZstsvwgd2Mg6Y6HZtaHE1jCzWkcbCvlPejPpdMElKVuZBQt05qi4hno/i10TNZZEYH7JYt0KiZedQfw92aHyjjKQhOorVanCz8BbPZ6Ey29CzuShmozsBZIigIJ9Tw/30x8A+pl0H06FsmzXNyagprGIINk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Add bpf_proactive_reclaim(), a sleepable kfunc which performs one
proactive reclaim pass on a given memory cgroup, similar to a write
to memory.reclaim but without retrying until the target is reached.

The kfunc is restricted to BPF_PROG_TYPE_SYSCALL so that reclaim
always runs in a clean process context. Generic sleepable programs
may execute with filesystem locks held or in NOFS/NOIO contexts,
where the reclaim path could deadlock in filesystem shrinkers. A
SYSCALL program can still drive reclaim asynchronously through
bpf_wq or task_work callbacks, which run in process context and
keep the SYSCALL program type, so they can call the kfunc too.

The kfunc refuses to reclaim if the calling task is already in a
reclaim context, as a nested reclaim would corrupt the outer reclaim
state.

The reclaim target of a single call is clamped to MEMCG_CHARGE_BATCH.
try_to_free_mem_cgroup_pages() takes nr_to_reclaim as a lower bound,
so nothing else limits how long one call scans. An unbounded call
stalls other work on a shared workqueue, and since lru_lock is held
with interrupts disabled the contention delays IPI handling and can
cause CSD lock stalls. MEMCG_CHARGE_BATCH is the bound already used
by high_work_func(), so each call becomes a bounded unit of work.

Reclaiming more than one batch is left to the BPF program. This is
documented in the kfunc rather than enforced: call the kfunc once
per bpf_wq callback and requeue the same work item for the next
batch instead of looping inside a callback, and give each target
memcg its own bpf_wq item. Keeping the policy in BPF lets a program
decide when to reclaim and when to stop, e.g. once the target cgroup
is dying.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/bpf_memcontrol.c | 95 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 93 insertions(+), 2 deletions(-)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 716df49d7647..92f35ba66309 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/memcontrol.h>
+#include <linux/swap.h>
 #include <linux/bpf.h>
 
 __bpf_kfunc_start_defs();
@@ -159,6 +160,74 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 	mem_cgroup_flush_stats(memcg);
 }
 
+/*
+ * Reclaim must not recurse: try_to_free_mem_cgroup_pages() overwrites
+ * current->reclaim_state, so a nested call would corrupt the outer
+ * reclaim state. Reclaim windows are marked with PF_MEMALLOC;
+ * reclaim_state is also checked because it is installed slightly
+ * before PF_MEMALLOC.
+ */
+static bool bpf_in_reclaim_context(void)
+{
+	return (current->flags & PF_MEMALLOC) || current->reclaim_state;
+}
+
+/**
+ * bpf_proactive_reclaim - proactively reclaim memory from a memory
+ *                         cgroup
+ * @memcg: the target memory cgroup to reclaim from
+ * @size:  the amount of memory to reclaim, in bytes, clamped to
+ *         MEMCG_CHARGE_BATCH (64 pages)
+ *
+ * Trigger one proactive reclaim pass on @memcg, similar to a write to
+ * memory.reclaim, but without retrying until @size is reached.
+ *
+ * @size is clamped so that one call is a bounded unit of work, matching
+ * the memory.high workqueue fallback in high_work_func(). To reclaim
+ * more, call this kfunc repeatedly instead of passing a larger @size.
+ *
+ * This kfunc is restricted to BPF_PROG_TYPE_SYSCALL to ensure it runs
+ * in a clean process context. The SYSCALL program can schedule the
+ * actual reclaim work via bpf_wq or timers, which also execute in
+ * safe process context (workqueue, task_work).
+ *
+ * When reclaim is driven from a bpf_wq, call this kfunc once per
+ * callback and requeue the same work item for the next batch rather
+ * than looping inside the callback: a long-running callback stalls
+ * other work on the shared workqueue, and because lru_lock is held with
+ * interrupts disabled the resulting contention also delays IPI
+ * handling. Give each target memcg its own bpf_wq item, so that
+ * reclaiming one memcg neither serializes behind nor piles up on top of
+ * another. Deciding whether to submit the next batch is up to the BPF
+ * program, which can stop at any point, e.g. once the target cgroup is
+ * dying.
+ *
+ * Must not be called with a filesystem lock held: the reclaim path
+ * may deadlock on it via filesystem shrinkers.
+ *
+ * Return: The amount of memory reclaimed, in bytes, or 0 if @size is
+ * smaller than a page or the task is already in a reclaim context.
+ */
+__bpf_kfunc unsigned long bpf_proactive_reclaim(struct mem_cgroup *memcg,
+						unsigned long size)
+{
+	unsigned long nr_reclaimed;
+	unsigned long nr_pages;
+
+	if (size < PAGE_SIZE || unlikely(bpf_in_reclaim_context()))
+		return 0;
+
+	nr_pages = min(size / PAGE_SIZE, (unsigned long)MEMCG_CHARGE_BATCH);
+
+	nr_reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages,
+						    GFP_KERNEL,
+						    MEMCG_RECLAIM_MAY_SWAP |
+						    MEMCG_RECLAIM_PROACTIVE,
+						    NULL);
+
+	return nr_reclaimed * PAGE_SIZE;
+}
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
@@ -171,22 +240,44 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_memory_events)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_usage)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
-
 BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
 
+/*
+ * Proactive reclaim needs a clean process context, so it is restricted
+ * to BPF_PROG_TYPE_SYSCALL. The bpf_wq and task_work callbacks that a
+ * SYSCALL program schedules run as the same program type, so they can
+ * still invoke it; generic sleepable programs (e.g. fentry on reclaim
+ * paths, inode_rmdir) cannot.
+ */
+BTF_KFUNCS_START(bpf_memcontrol_reclaim_kfuncs)
+BTF_ID_FLAGS(func, bpf_proactive_reclaim, KF_SLEEPABLE)
+BTF_KFUNCS_END(bpf_memcontrol_reclaim_kfuncs)
+
 static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
 	.owner          = THIS_MODULE,
 	.set            = &bpf_memcontrol_kfuncs,
 };
 
+static const struct btf_kfunc_id_set bpf_memcontrol_reclaim_kfunc_set = {
+	.owner          = THIS_MODULE,
+	.set            = &bpf_memcontrol_reclaim_kfuncs,
+};
+
 static int __init bpf_memcontrol_init(void)
 {
 	int err;
 
 	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC,
 					&bpf_memcontrol_kfunc_set);
-	if (err)
+	if (err) {
 		pr_warn("error while registering bpf memcontrol kfuncs: %d", err);
+		return err;
+	}
+
+	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL,
+					&bpf_memcontrol_reclaim_kfunc_set);
+	if (err)
+		pr_warn("error registering bpf reclaim kfuncs: %d", err);
 
 	return err;
 }
-- 
2.53.0


