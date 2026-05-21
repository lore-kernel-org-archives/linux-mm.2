Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82F0CCD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 17:37:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E99086B009D; Thu, 21 May 2026 13:37:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E70FF6B00A3; Thu, 21 May 2026 13:37:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D871E6B00A4; Thu, 21 May 2026 13:37:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C84996B009D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:37:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F31F8FD03
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:37:49 +0000 (UTC)
X-FDA: 84792134658.24.BB63D2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 09812180004
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:37:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d3igy71x;
	spf=pass (imf24.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779385068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=BjUntsL1zbDdYXkHjIcMkg8tcGqvrlDoumlv4NJQkZ4=;
	b=ljZNZ3BURpv4qf5s1GAUqAeJrgvMXTF9zNk2RO59YWcHY9q3qJsLtUKX5gAE4Ox0X95UPs
	KMM5zhSt/gNFAgd3AZdXCvdVrQnmCs3dCHoi8zSRBmcvhNgUpyj26fIzwCvol3ZucDqrji
	DHzh9FmTabjb8cS97Xl8oa9Wo6LUBqA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d3igy71x;
	spf=pass (imf24.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779385068; a=rsa-sha256;
	cv=none;
	b=To7qkvX3lS/U2ab3EIISJqFEkUGNKhm8WHeyPY0LWqmMlSoAJWxw9W3kLwR/KkqaAvhXfL
	lkgqsd5hbJrn6Gdi810vvSefh1AVES/1nyX8IEGMDi86DXOyU1mqu+j+qezkQEWNX6n27U
	iOUwbVupwC7YYEGcN/Bm9NUfOew1UCs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A27A560122;
	Thu, 21 May 2026 17:37:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336441F000E9;
	Thu, 21 May 2026 17:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779385067;
	bh=BjUntsL1zbDdYXkHjIcMkg8tcGqvrlDoumlv4NJQkZ4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=d3igy71xt4iIckeZZ2WkMTK56JYSFKYfjoUFktZysN3DVPSWus0v3D8PZy4VyTqBP
	 12KBuP1kw9j1jlgWtQPVDcmM6evIjv5ph0ayj6XAmo9+slkLkWSo1cICV2uVIkWxRC
	 ZT67uKr16Dd8AXpRiilze6BbPZci/XoE6PrxSD7bC2gosk5BTdWLUfjxw+rPic/8lH
	 TKV8F0XSdmXJMffKMcbtBu9ELO6ichfPc0Ervqilp8zIpcAeMqU+awjRQSbWTsPfBv
	 HXaHF3dt+E6hU39CZlrHnCZHNcAB3oZAv/WaV9+KIbzP9DcTVMwIP388QydoDVkLfT
	 EuuZzYOlukzDw==
Date: Thu, 21 May 2026 07:37:46 -1000
Message-ID: <dd5b3702a826666242b6eb6e805bf83f@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
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
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/8] sched_ext: Sub-allocator over kernel-claimed BPF arena pages
In-Reply-To: <20260520235052.4180316-8-tj@kernel.org>
References: <20260520235052.4180316-1-tj@kernel.org>
 <20260520235052.4180316-8-tj@kernel.org>
X-Stat-Signature: wgwmp4dufnuropcoaygjby7j96x464we
X-Rspamd-Queue-Id: 09812180004
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779385067-642965
X-HE-Meta: U2FsdGVkX19c04AqOZXUyQP3gRMOniZFBowM7TC76GET1OS6DM+/i4ZzcWsdKk2UHZBZPDTMvFQwp9y3p0154MgrPKElnmwCCYzmwVjMQRFm0ZcbT2qs51Vgd0MQQo4xLHAzz776EAXktIF0nbzuP5eL6OTS8rlfu6ergH0ElpHbfCr8in9EWTX14AXigNKFbThkqWpEQk7d5IVoX71vKT/ddjSOpwohAKj+0p1MtRTSNDD//A1iTW2LsKIi2qFtzluH/sTawe3u539w1lUW/YA9en0PloTFkW+ZzA4LJ3iXtdd+b1Wk0dbS3wM0foaWsA2axSy2/kzEiFG8yUGyJOc4fV0rUF0SolvMZ1okI0SlAuv1JM462TQ+tOpLypXAMFKSWnDEe861X9v2qNuKVvaGv8Js906ozQY5rA43r1j+CRMjyUeDgh0lhLcaC8tlYjRf9ISrkwQUSWUISNj7RYoUj/guUQtMhG7KoN0C0YUmPt1qMY7+ZvJHnXrcFtvTXAoy/ZEAQt9OiV8CyI8j579B4Qin0c56MVY0g7X6uki+tjMG1orwxB7HEFpjPMVHrMnhBsceRcftv795wyNxjqcgtY4u5e8+jtLD6OAdNNQykL+GH9BsbVPZ7Yp6MzOHzV9g/u1YwRHjmSe10KuG/qAAuiSjZm/xFaxmTcUzY/hr7gU6HBzzUplx+MepkEycz6TEfX0mEWkbIi/RPlfyJCt+CwWgNNvpQlAJ0YmHllpC7BHHxkPAZbI/jQgr/0B2Qd5PRL61OtXScsXoQb9uKc6sSYCUBpfD+9aGfvyWyUww6hKX5Ozm4U6fpgdDME5M+E4jhptGIC4pwO1eQ3ckFsqgmsT1R5/kFDDi7IZomue7yTUIrnZPutElDn7OeOw8MH4CKwDH1W0Ou3NwoaaqW2soQBTnGxA0zCkmsm+bQ6gfgRftLXD7Cz/+5UF9a21mm5wv+3qDcxt/qBUqmti
 N5JjQ6X9
 sHZr6xscnk3Rvl1hElk0jWa/4upxQcgxSW3cKrRJgu2lGBVngT6HXAEag0kNkfaOToDdaqgXxO+edRzqWqvK+I2AJONIGPajgvHQVy+7kJAepX/jtJrySJFBl93xvCErc8kLZnD8wmKwixcolNoQIEU1xKGDtcDXJGvkuFFaO3IZAK5MI2loNuYmhDK9gMBaChWJKJlMUrekjYgqYJCQgsogfpdEjJKlz2CE7ue/xzahyLcjifqAIQlMXjZ/Ng1FPVDbuR6/V9IgE2B0C/Nknm/FF+80oLra4JNRpEzQuptOXgLY=
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

v2: Switch scx_arena_alloc() to a loop. (Andrea)

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrea Righi <arighi@nvidia.com>
---
 kernel/sched/build_policy.c |    4 +
 kernel/sched/ext.c          |   11 +++
 kernel/sched/ext_arena.c    |  126 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/ext_arena.h    |   18 ++++++
 kernel/sched/ext_internal.h |    5 +
 5 files changed, 164 insertions(+)

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
 
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -5003,6 +5003,7 @@ static void scx_sched_free_rcu_work(stru
 
 	rhashtable_free_and_destroy(&sch->dsq_hash, NULL, NULL);
 	free_exit_info(sch->exit_info);
+	scx_arena_pool_destroy(sch);
 	if (sch->arena_map)
 		bpf_map_put(sch->arena_map);
 	kfree(sch);
@@ -7155,6 +7156,12 @@ static void scx_root_enable_workfn(struc
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
@@ -7473,6 +7480,10 @@ static void scx_sub_enable_workfn(struct
 		sch->exit_info->flags |= SCX_EFLAG_INITIALIZED;
 	}
 
+	ret = scx_arena_pool_init(sch);
+	if (ret)
+		goto err_disable;
+
 	if (validate_ops(sch, ops))
 		goto err_disable;
 
--- /dev/null
+++ b/kernel/sched/ext_arena.c
@@ -0,0 +1,126 @@
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
+	while (true) {
+		kern_va = gen_pool_alloc(sch->arena_pool, size);
+		if (kern_va)
+			break;
+		page_cnt = max_t(u32, SCX_ARENA_GROW_PAGES,
+				 (size + PAGE_SIZE - 1) >> PAGE_SHIFT);
+		if (scx_arena_grow(sch, page_cnt))
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
 

