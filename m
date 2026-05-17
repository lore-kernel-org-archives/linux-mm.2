Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8F03CD4F3D
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 21:12:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A55136B0099; Sun, 17 May 2026 17:12:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07096B009B; Sun, 17 May 2026 17:12:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 880B16B009D; Sun, 17 May 2026 17:12:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 777B56B0099
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:12:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3416690131
	for <linux-mm@kvack.org>; Sun, 17 May 2026 21:12:43 +0000 (UTC)
X-FDA: 84778161006.06.7862939
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6FA7CC0007
	for <linux-mm@kvack.org>; Sun, 17 May 2026 21:12:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UCiWPqpN;
	spf=pass (imf10.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779052361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RQWT8fPurddBdUnhb5rfIHvq5IfP2MjZk8Jy51FnWYY=;
	b=pvvCb3P0f1LA0mKIUZgRvLGB3nq9vF2m7PkMgPQAwaDHRjTOEP2cW4qqi8qbDoytfYkL6R
	lKEYh+lUE6cSdSry4GpPDdbDE7UGKNypX+c6gJSO+lqARahAxuIuPNkfVpQdXFVIC5Gc1M
	ZbaPJwKFaowXD6D8Rmj18yx7oWZBQww=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779052361; a=rsa-sha256;
	cv=none;
	b=QT1mbq9zRYhtGEvXYz2uBZaIK1nsSKd4cw9xH+0RPEWBvNVupqNg1Gus0u4Z6Fqi9+xs1D
	UqiOVS88sV3WJriPwZU77hjDAZzUOgtL9St7f4Jftx7XENhhMFWqSGwUoFUvYvkOwZYU1D
	vkCYNEN+ZpGaBwWYM2Wc63bL/qRsr+g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UCiWPqpN;
	spf=pass (imf10.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ECB2B60218;
	Sun, 17 May 2026 21:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852D9C4AF09;
	Sun, 17 May 2026 21:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779052360;
	bh=Qyhnvhg9kwdN/Mu/2S1WfalrWlt7omNMASJrOB2HPP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCiWPqpNh6f5KqxB4DzEtayNWhMudEcd+nUroU+ZnngccFB+SLJdvF+N0MmS56fgR
	 NGNx6qMrQfVJ+Iyp9YJLBC9V7TZdOazR47WDAQO/SL3KmNI0iZQgG60prf/jh1oR9t
	 qORtCR9lDUbyQwZNTpkGR8W4ISDaXnOBPNzqR+X2f5bItiHImmiVwq98oop7+MsapQ
	 qkKiw782tBx7Lc/TtYSxw7rlyTjVlYARUdibAJq/gHBAGtOuoDX35j8FeNL5Hd0aNG
	 6Fpcory9K/w8BRChNuAgKTH7cOI0Ix0/BwDDv4ERcUA65tOQf85rPXlu3uNH9+qyV3
	 w2uiT5C5JgVBw==
From: Tejun Heo <tj@kernel.org>
To: David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	sched-ext@lists.linux.dev,
	bpf@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/8] sched_ext: Sub-allocator over kernel-claimed BPF arena pages
Date: Sun, 17 May 2026 11:12:31 -1000
Message-ID: <20260517211232.1670594-8-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260517211232.1670594-1-tj@kernel.org>
References: <20260517211232.1670594-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6FA7CC0007
X-Rspam-User: 
X-Stat-Signature: 1nfggf6srgabhrz511s3eb5g86nq5hk9
X-HE-Tag: 1779052361-150105
X-HE-Meta: U2FsdGVkX19R2U+3nFd89w2eTPDETfHTWUfygtZ4eZ2/IYR3rhsMlKwXVe0TPt1E1NozTDOurWxStHxGONfkPKwx1eO5KmWr/BW145gQbnBz6mNfoAVwzTsyaj49eI7i4dfVqWjBRCEpOtpumz2egYbv3bBMbQcjv3GTxV2TSDSAq+gSOa4yLa5sH5T6JEPiIo1uqalI/ag3aVMKz/59bgSmRu6JoGwG6EIfhDtsUO41jsBbRoU9D0/MQlsYahRKWMD+NVV3Dg1v8hH7d1PzUwNMcaF7U/A8LTI41XpfeEevgMQGuWyJxZybstOYy6MItsNmF+Sm6ZW3VuX4dvKLIchponuoEM3/BeuGhataTmo8ga//9WddEnCccnZbsmhYUolCWIAwSl1SVfiOxm6nIoeS7iT8xCdsxQ8Sx9bnwtUZkFn/2fvQjB9szMNZkkslAZJvJmdOQN8SPxml1WPnBBMTh5ynKDe1CLBjdoIrA6s1l7HQNGmYiWiESDbU4DWfUGWBKH0DUHyxIGP6jxstFXUS5M9KLocmyIm1qjG0etsntsuk5OYpjL/8i727fxuzWWgUY3Doct0iN8OhlT7oVZb5oGc3ql5gSPSWStWkcnMPju+vdd0iOMPVwLwgv08MBl7K5+TjscjQJAx8F/F4G5ZsFbaJkrntAnTJtsRgCZVJo/oVFlVpJhhePXnphOjVpB4+j4LCj3WbVDnFGmExWHF2H++1b89iMmKs3rASD5JgER7k6VoU+5pvzx3oyQV7c8QO9A8V7NdNO33d0Qoao2Qwrg2Y3RIx68ZsMc/5d6KSaROakzDCS0pz5sxEsIwlmcqStKORzgBObpMLENxaG0hlti9vMxdytaKJT/hcGUdk8O1B3T67ENOvvSHDtjRmlFtI26zYF1ih7iawyi5g4L+WlY+GNPN3SApIJwg3vQwN/r1q0djUkSIJh3AqVEewZRB24UWXoQU8w5hAQ26
 7r6iAdCa
 j/sdLAm5JfnXbMwlywGOLixTYKGCcgbLRLmYRT78PjGPbyKJTdUpwOluEMzC+lMmqLipGQC/OB0vaHsMyeGuOK87NpC4VLMbRv8rFP/mAGHQiLFLvPyAFLQ4UGmEMB3rKrghJuGknKGU0G4UEtbDadRRvmP64TqEUeZ0lqxBENd055AmJnoiQI/BJ/zqTzD+0RjP9JQvqL+7uY2ZosmQ3VZmniudH1lBCOgIo157CGa9ds67jKA8mKU5P1oNPHe8DYJn8xFwnDhMYUW8T5x9eYxMQm+c0IK4y/lNO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Build a per-scheduler sub-allocator on top of pages claimed from the BPF
arena registered in the previous patch. Subsequent kernel-managed
arena-resident structures (e.g. per-CPU set_cmask cmask) carve their storage
from this pool.

scx_arena_pool_init() creates a gen_pool. scx_arena_alloc() returns the
kernel VA. On exhaustion, the pool grows by claiming more pages via
bpf_arena_alloc_pages_sleepable(). Chunks are added at the kernel-side
mapping address; callers translate to the BPF-arena form themselves if
needed.

Allocations sleep (GFP_KERNEL) - they may grow the pool through vzalloc and
arena page allocation. All current consumers run from the enable path (after
ops.init() and the kernel-side arena auto-discovery, before validate_ops()),
where sleeping is fine.

scx_arena_pool_destroy() walks each chunk, returns outstanding ranges to the
gen_pool with gen_pool_free() and then calls gen_pool_destroy(). The
underlying arena pages are released when the arena map itself is torn down,
so the pool destroy doesn't free them explicitly.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/sched/build_policy.c |   4 ++
 kernel/sched/ext.c          |  11 ++++
 kernel/sched/ext_arena.c    | 127 ++++++++++++++++++++++++++++++++++++
 kernel/sched/ext_arena.h    |  18 +++++
 kernel/sched/ext_internal.h |   5 ++
 5 files changed, 165 insertions(+)
 create mode 100644 kernel/sched/ext_arena.c
 create mode 100644 kernel/sched/ext_arena.h

diff --git a/kernel/sched/build_policy.c b/kernel/sched/build_policy.c
index 5e76c9177d54..067979a7b69e 100644
--- a/kernel/sched/build_policy.c
+++ b/kernel/sched/build_policy.c
@@ -59,12 +59,16 @@
 
 #ifdef CONFIG_SCHED_CLASS_EXT
 # include <linux/btf_ids.h>
+# include <linux/find.h>
+# include <linux/genalloc.h>
 # include "ext_types.h"
 # include "ext_internal.h"
 # include "ext_cid.h"
+# include "ext_arena.h"
 # include "ext_idle.h"
 # include "ext.c"
 # include "ext_cid.c"
+# include "ext_arena.c"
 # include "ext_idle.c"
 #endif
 
diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 94aab7037329..3025fbe198d3 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -5009,6 +5009,7 @@ static void scx_sched_free_rcu_work(struct work_struct *work)
 
 	rhashtable_free_and_destroy(&sch->dsq_hash, NULL, NULL);
 	free_exit_info(sch->exit_info);
+	scx_arena_pool_destroy(sch);
 	if (sch->arena_map)
 		bpf_map_put(sch->arena_map);
 	kfree(sch);
@@ -7140,6 +7141,12 @@ static void scx_root_enable_workfn(struct kthread_work *work)
 		sch->exit_info->flags |= SCX_EFLAG_INITIALIZED;
 	}
 
+	ret = scx_arena_pool_init(sch);
+	if (ret) {
+		cpus_read_unlock();
+		goto err_disable;
+	}
+
 	for (i = SCX_OPI_CPU_HOTPLUG_BEGIN; i < SCX_OPI_CPU_HOTPLUG_END; i++)
 		if (((void (**)(void))ops)[i])
 			set_bit(i, sch->has_op);
@@ -7458,6 +7465,10 @@ static void scx_sub_enable_workfn(struct kthread_work *work)
 		sch->exit_info->flags |= SCX_EFLAG_INITIALIZED;
 	}
 
+	ret = scx_arena_pool_init(sch);
+	if (ret)
+		goto err_disable;
+
 	if (validate_ops(sch, ops))
 		goto err_disable;
 
diff --git a/kernel/sched/ext_arena.c b/kernel/sched/ext_arena.c
new file mode 100644
index 000000000000..53174033765d
--- /dev/null
+++ b/kernel/sched/ext_arena.c
@@ -0,0 +1,127 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * BPF extensible scheduler class: Documentation/scheduler/sched-ext.rst
+ *
+ * scx_arena_pool: kernel-side sub-allocator over BPF-arena pages.
+ *
+ * Each chunk added to @sch->arena_pool comes from one
+ * bpf_arena_alloc_pages_sleepable() call and is registered at the
+ * kernel-side mapping address. Callers translate to the BPF-arena form
+ * themselves if needed.
+ *
+ * Allocations grow the pool on demand. Underlying arena pages are released
+ * when the arena map itself is torn down.
+ *
+ * Copyright (c) 2026 Meta Platforms, Inc. and affiliates.
+ * Copyright (c) 2026 Tejun Heo <tj@kernel.org>
+ */
+
+enum scx_arena_consts {
+	SCX_ARENA_MIN_ORDER		= 3,	/* 8-byte minimum sub-allocation */
+	SCX_ARENA_GROW_PAGES		= 4,	/* per growth */
+};
+
+s32 scx_arena_pool_init(struct scx_sched *sch)
+{
+	if (!sch->arena_map)
+		return 0;
+
+	sch->arena_pool = gen_pool_create(SCX_ARENA_MIN_ORDER, NUMA_NO_NODE);
+	if (!sch->arena_pool)
+		return -ENOMEM;
+	return 0;
+}
+
+static void scx_arena_clear_chunk(struct gen_pool *pool, struct gen_pool_chunk *chunk,
+				  void *data)
+{
+	int order = pool->min_alloc_order;
+	size_t chunk_sz = chunk->end_addr - chunk->start_addr + 1;
+	unsigned long end_bit = chunk_sz >> order;
+	unsigned long b, e;
+
+	for_each_set_bitrange(b, e, chunk->bits, end_bit)
+		gen_pool_free(pool, chunk->start_addr + (b << order),
+			      (e - b) << order);
+}
+
+/*
+ * Tear down the pool. Outstanding gen_pool allocations are freed via
+ * scx_arena_clear_chunk() so gen_pool_destroy() doesn't BUG. The underlying
+ * arena pages are released when the arena map itself is torn down.
+ */
+void scx_arena_pool_destroy(struct scx_sched *sch)
+{
+	if (!sch->arena_pool)
+		return;
+	gen_pool_for_each_chunk(sch->arena_pool, scx_arena_clear_chunk, NULL);
+	gen_pool_destroy(sch->arena_pool);
+	sch->arena_pool = NULL;
+}
+
+/*
+ * Grow the pool by @page_cnt pages. bpf_arena_alloc_pages_sleepable() and
+ * gen_pool_add() (which calls vzalloc(GFP_KERNEL)) require a sleepable
+ * context.
+ */
+static int scx_arena_grow(struct scx_sched *sch, u32 page_cnt)
+{
+	u64 kern_vm_start;
+	u32 uaddr32;
+	void *p;
+	int ret;
+
+	if (!sch->arena_map || !sch->arena_pool)
+		return -EINVAL;
+
+	p = bpf_arena_alloc_pages_sleepable(sch->arena_map, NULL,
+					    page_cnt, NUMA_NO_NODE, 0);
+	if (!p)
+		return -ENOMEM;
+
+	uaddr32 = (u32)(unsigned long)p;
+	kern_vm_start = bpf_arena_map_kern_vm_start(sch->arena_map);
+
+	ret = gen_pool_add(sch->arena_pool, kern_vm_start + uaddr32,
+			   page_cnt * PAGE_SIZE, NUMA_NO_NODE);
+	if (ret) {
+		bpf_arena_free_pages_non_sleepable(sch->arena_map, p, page_cnt);
+		return ret;
+	}
+	return 0;
+}
+
+/*
+ * Allocate @size bytes from the arena pool. Returns kernel VA on success, NULL
+ * on failure. May grow the pool via scx_arena_grow() which sleeps. Caller must
+ * be in a GFP_KERNEL context.
+ */
+void *scx_arena_alloc(struct scx_sched *sch, size_t size)
+{
+	unsigned long kern_va;
+	u32 page_cnt;
+
+	might_sleep();
+
+	if (!sch->arena_pool)
+		return NULL;
+
+	kern_va = gen_pool_alloc(sch->arena_pool, size);
+	if (!kern_va) {
+		page_cnt = max_t(u32, SCX_ARENA_GROW_PAGES,
+				 (size + PAGE_SIZE - 1) >> PAGE_SHIFT);
+		if (scx_arena_grow(sch, page_cnt))
+			return NULL;
+		kern_va = gen_pool_alloc(sch->arena_pool, size);
+		if (!kern_va)
+			return NULL;
+	}
+
+	return (void *)kern_va;
+}
+
+void scx_arena_free(struct scx_sched *sch, void *kern_va, size_t size)
+{
+	if (sch->arena_pool && kern_va)
+		gen_pool_free(sch->arena_pool, (unsigned long)kern_va, size);
+}
diff --git a/kernel/sched/ext_arena.h b/kernel/sched/ext_arena.h
new file mode 100644
index 000000000000..4f3610160102
--- /dev/null
+++ b/kernel/sched/ext_arena.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * BPF extensible scheduler class: Documentation/scheduler/sched-ext.rst
+ *
+ * Copyright (c) 2025 Meta Platforms, Inc. and affiliates.
+ * Copyright (c) 2025 Tejun Heo <tj@kernel.org>
+ */
+#ifndef _KERNEL_SCHED_EXT_ARENA_H
+#define _KERNEL_SCHED_EXT_ARENA_H
+
+struct scx_sched;
+
+s32 scx_arena_pool_init(struct scx_sched *sch);
+void scx_arena_pool_destroy(struct scx_sched *sch);
+void *scx_arena_alloc(struct scx_sched *sch, size_t size);
+void scx_arena_free(struct scx_sched *sch, void *kern_va, size_t size);
+
+#endif /* _KERNEL_SCHED_EXT_ARENA_H */
diff --git a/kernel/sched/ext_internal.h b/kernel/sched/ext_internal.h
index d40cfd29ddaa..ff7e882bd67a 100644
--- a/kernel/sched/ext_internal.h
+++ b/kernel/sched/ext_internal.h
@@ -1116,8 +1116,13 @@ struct scx_sched {
 	 * Arena map auto-discovered from member progs at struct_ops attach.
 	 * cid-form schedulers must use exactly one arena across all member
 	 * progs. NULL on cpu-form.
+	 *
+	 * @arena_pool sub-allocates @arena_map. Each gen_pool chunk is added
+	 * at the kernel-side mapping address. Grows on demand and pages are
+	 * not released until sched destroy.
 	 */
 	struct bpf_map		*arena_map;
+	struct gen_pool		*arena_pool;
 
 	DECLARE_BITMAP(has_op, SCX_OPI_END);
 
-- 
2.54.0


