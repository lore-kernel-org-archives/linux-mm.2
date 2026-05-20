Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CDD3CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 23:51:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 662BA6B009F; Wed, 20 May 2026 19:51:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43D146B00A1; Wed, 20 May 2026 19:51:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 290806B00A3; Wed, 20 May 2026 19:51:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 18C816B009F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 19:51:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3DB9120451
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:51:03 +0000 (UTC)
X-FDA: 84789446406.19.305524E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 22E961A0004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:51:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZuuX3/V3";
	spf=pass (imf19.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779321062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yMhH/6NUdUsOwZ43W9GcUBGpE2q5j2slg3yaBUnYIhk=;
	b=ZBe4H+Ac9vIjxtp1xgFq3C0rAb18hZvsFvzEuTXrkRo+lnmunBOYnbfH9I6my5TpDiiFVN
	wIOrXQbUNoDCsKe7zpBUJhPIbUqnG+lTZzbxr1NUz1SRsq2iekm9s6jiZqY1mxIMevY5Br
	1v2HY0RoZDUjvIbF+/HmqEWuUbEbzRM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZuuX3/V3";
	spf=pass (imf19.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779321062; a=rsa-sha256;
	cv=none;
	b=vGDOX632AMX69yZfi5hWegeDAa4E0SCw/Q9fH2ubaibJPVCUZHNh9EM6zJsTuBDuA5p8/Z
	B3vVE4h+uMzVD2LirsF8kAjrmWWkjKEl2vZYihafJsaa3cwhw2ftWI7baTlfUwtSAlfly9
	UcXMwV0k2HxKBIbqmFMeilqrtRr/iZ0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7805F40AFB;
	Wed, 20 May 2026 23:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6651F00A3A;
	Wed, 20 May 2026 23:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779321061;
	bh=yMhH/6NUdUsOwZ43W9GcUBGpE2q5j2slg3yaBUnYIhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZuuX3/V3xRj61c4UO4p/uU1G8dcy6y2KTeqb5VH9n+x4Xz3f372IZCL8iV76rMwoZ
	 tnioUcaU2bz4nsaSFZWVhApS556BOk+w/2FpHM1FFHgfRwIcmrO+4CXkPOIz6eigZJ
	 DzwbEEqWtJYeEkXrs93b9p3y9JkvbOAjtlwNc6jfckiNJzyWZj9yYJnEr3OqL4qnOs
	 MDOvTC9qB49PmaNaf2/HY20zTVMQbiaZyZQRpdZ5Ka+HFKFFoK5xrarIqmXa2fsyfY
	 zh7ELUzF7SKDYOQ7IIXgj77Q22587Bd6X4LmSUC46vsB0VhoEbTUhHq6v6d1RJf/at
	 RqhMdfi7l4UwA==
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
	linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 8/8] sched_ext: Convert ops.set_cmask() to arena-resident cmask
Date: Wed, 20 May 2026 13:50:52 -1000
Message-ID: <20260520235052.4180316-9-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520235052.4180316-1-tj@kernel.org>
References: <20260520235052.4180316-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 22E961A0004
X-Rspam-User: 
X-Stat-Signature: baxw14pr3rjddeyf56nzof86ep9kxac5
X-HE-Tag: 1779321061-977961
X-HE-Meta: U2FsdGVkX1/RoYSAXPqALOtBMb8kh4HxUwFoo4rcJCf9owozmXFDx+sZ/Q34T11nPOp/u6GdzWN8yq+KjTL4dPuXRThmfkAKSI1Q0No+6zxBXmXewbR/F77CTDIqPivIyUSwAQRxLDa1ZFQhRByFHfNltiTh+QjKN61S1lcAy+XEkIN4NChjmCCoOnF7QYbV9Ru6nExDDH5MK8SKXbLIYJ6e5qqMNPeVrGt9kt7nXsElr2SvEYhSNX1DYmWCkp4x9tOKn/414S862QnzmMPkYDO6WI/GvqiCziyvwB6oS1Oa74nuXyC0ynfoQQP0WpP0TzGjvEeKYQXGs49JiSghU7E6mYvEF8Q4hI8CxAIk2XDyPOPlCpOV23NunA0e5m4azCrMZkwk0wNCEYFHAWvfBwx4iEZ36DlHCtq0xjhGw1nqDW926bvpGt73nndlT9TA7Gzowsfe7IgGJOcrcCy4XY9FbPiIEa/fIwBlQXvq1d/SwfkmFYUxZdjDlwVXcRaDAfminnEVlCLLBB0G3SYaTEEFwLg1OBzm7wqMz+GeVeevUORk1s0iswD1Yyo04XXkBNe9toXnFl/1SZKL0OPDCOrRV0n6NAz2gTe20aSaW2HIEA5QbzNE7ZvUtQ4Gjz+bSlNX9TU4KluClgYLYpZ48UNiA7MVoODvsdK1txmInB5MAgOSPnYhn7N2dX0ZTd2awDzAcvMwk5FUldNrYt5jmaAyDijE7O1dflpTOdVRPzR0gyloscrtbkpPvD1hqAeyQ6WP00ypCi0utQri5VKn0dNMMK8+zwEdrNAFSH1vejlx7JZKw574P81XwupsNSUFWbsPky3pkPXN4P7F4qddm7/A4TG+2+UJYb1ceAgb4wQmhHIq6Uxr3eLOwv5/n1yK65mWa2XdMf6LExeHg29tMtrXwqYWlodd/0F1ITCT7PC5968ahuO2so/fY0D8ESjWlOzNzum8QshAOMxSP+g
 QX7W0Pwh
 45NmqYRRVc24Vja4txSs/DE5Kzi3Y66/xSsSLA4cWJqQa+mq/g/yR2uQQARtn2rkacXJtskB140gM9PsfJSH62eSFTa02OAhhHyDHSyU3xNpPZ3Hbb7HY15clKMS71fH0lO7pAAP3S+3qDLUoCjGLgr7xBteaS1yYarnA1BpBtnz/QcezgmwnYyQRIOKmka5KfdV9u/5giCxPWVjg0MtyF+QMO+MMtV9el8+uOY2GKL0ACz/+4YuJZLkwYOMGMlbRIVnEPd5DoozphrBYLxZO1flQiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ops_cid.set_cmask() expects a cmask. The kernel couldn't write into the
arena, so it translated cpumask -> cmask in kernel memory and passed the
result as a trusted pointer. The BPF cmask helpers all operate on arena
cmasks though, so the BPF side had to word-by-word probe-read the kernel
cmask into an arena cmask via cmask_copy_from_kernel() before any helper
could touch it. It works, but is clumsy.

With direct kernel-side arena access now in place, build the cmask in the
arena. The kernel writes to it through the kern_va side of the dual mapping;
BPF directly dereferences it via an __arena pointer like any other arena
struct.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/sched/ext.c                    | 68 +++++++++++++++++++++++++--
 kernel/sched/ext_cid.c                | 20 +-------
 kernel/sched/ext_internal.h           | 10 +++-
 tools/sched_ext/include/scx/cid.bpf.h | 52 --------------------
 tools/sched_ext/scx_qmap.bpf.c        |  5 +-
 5 files changed, 75 insertions(+), 80 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index fb91079c1244..94562e3350c6 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -621,11 +621,16 @@ static inline void scx_call_op_set_cpumask(struct scx_sched *sch, struct rq *rq,
 		update_locked_rq(rq);
 
 	if (scx_is_cid_type()) {
-		struct scx_cmask *cmask = this_cpu_ptr(scx_set_cmask_scratch);
-
-		lockdep_assert_irqs_disabled();
-		scx_cpumask_to_cmask(cpumask, cmask);
-		sch->ops_cid.set_cmask(task, cmask);
+		struct scx_cmask *kern_va = *this_cpu_ptr(sch->set_cmask_scratch);
+		unsigned long uaddr = (unsigned long)kern_va -
+			bpf_arena_map_kern_vm_start(sch->arena_map);
+		/*
+		 * Build the per-CPU arena cmask and hand BPF the uaddr. Caller
+		 * holds the rq lock with IRQs disabled, which makes us the sole
+		 * user of the scratch area.
+		 */
+		scx_cpumask_to_cmask(cpumask, kern_va);
+		sch->ops_cid.set_cmask(task, (struct scx_cmask *)uaddr);
 	} else {
 		sch->ops.set_cpumask(task, cpumask);
 	}
@@ -4949,6 +4954,48 @@ static const struct attribute_group scx_global_attr_group = {
 static void free_pnode(struct scx_sched_pnode *pnode);
 static void free_exit_info(struct scx_exit_info *ei);
 
+static s32 scx_set_cmask_scratch_alloc(struct scx_sched *sch)
+{
+	size_t size = struct_size_t(struct scx_cmask, bits,
+				    SCX_CMASK_NR_WORDS(num_possible_cpus()));
+	int cpu;
+
+	if (!sch->is_cid_type || !sch->arena_pool)
+		return 0;
+
+	sch->set_cmask_scratch = alloc_percpu(struct scx_cmask *);
+	if (!sch->set_cmask_scratch)
+		return -ENOMEM;
+
+	for_each_possible_cpu(cpu) {
+		struct scx_cmask **slot = per_cpu_ptr(sch->set_cmask_scratch, cpu);
+
+		*slot = scx_arena_alloc(sch, size);
+		if (!*slot)
+			return -ENOMEM;
+		scx_cmask_init(*slot, 0, num_possible_cpus());
+	}
+	return 0;
+}
+
+static void scx_set_cmask_scratch_free(struct scx_sched *sch)
+{
+	size_t size = struct_size_t(struct scx_cmask, bits,
+				    SCX_CMASK_NR_WORDS(num_possible_cpus()));
+	int cpu;
+
+	if (!sch->set_cmask_scratch)
+		return;
+
+	for_each_possible_cpu(cpu) {
+		struct scx_cmask **slot = per_cpu_ptr(sch->set_cmask_scratch, cpu);
+
+		scx_arena_free(sch, *slot, size);
+	}
+	free_percpu(sch->set_cmask_scratch);
+	sch->set_cmask_scratch = NULL;
+}
+
 static void scx_sched_free_rcu_work(struct work_struct *work)
 {
 	struct rcu_work *rcu_work = to_rcu_work(work);
@@ -5003,6 +5050,7 @@ static void scx_sched_free_rcu_work(struct work_struct *work)
 
 	rhashtable_free_and_destroy(&sch->dsq_hash, NULL, NULL);
 	free_exit_info(sch->exit_info);
+	scx_set_cmask_scratch_free(sch);
 	scx_arena_pool_destroy(sch);
 	if (sch->arena_map)
 		bpf_map_put(sch->arena_map);
@@ -7162,6 +7210,12 @@ static void scx_root_enable_workfn(struct kthread_work *work)
 		goto err_disable;
 	}
 
+	ret = scx_set_cmask_scratch_alloc(sch);
+	if (ret) {
+		cpus_read_unlock();
+		goto err_disable;
+	}
+
 	for (i = SCX_OPI_CPU_HOTPLUG_BEGIN; i < SCX_OPI_CPU_HOTPLUG_END; i++)
 		if (((void (**)(void))ops)[i])
 			set_bit(i, sch->has_op);
@@ -7484,6 +7538,10 @@ static void scx_sub_enable_workfn(struct kthread_work *work)
 	if (ret)
 		goto err_disable;
 
+	ret = scx_set_cmask_scratch_alloc(sch);
+	if (ret)
+		goto err_disable;
+
 	if (validate_ops(sch, ops))
 		goto err_disable;
 
diff --git a/kernel/sched/ext_cid.c b/kernel/sched/ext_cid.c
index 0c91b951fd33..808c6390da5a 100644
--- a/kernel/sched/ext_cid.c
+++ b/kernel/sched/ext_cid.c
@@ -7,14 +7,6 @@
  */
 #include <linux/cacheinfo.h>
 
-/*
- * Per-cpu scratch cmask used by scx_call_op_set_cpumask() to synthesize a
- * cmask from a cpumask. Allocated alongside the cid arrays on first enable
- * and never freed. Sized to the full cid space. Caller holds rq lock so
- * this_cpu_ptr is safe.
- */
-struct scx_cmask __percpu *scx_set_cmask_scratch;
-
 /*
  * cid tables.
  *
@@ -54,8 +46,6 @@ static s32 scx_cid_arrays_alloc(void)
 	u32 npossible = num_possible_cpus();
 	s16 *cid_to_cpu, *cpu_to_cid;
 	struct scx_cid_topo *cid_topo;
-	struct scx_cmask __percpu *set_cmask_scratch;
-	s32 cpu;
 
 	if (scx_cid_to_cpu_tbl)
 		return 0;
@@ -63,25 +53,17 @@ static s32 scx_cid_arrays_alloc(void)
 	cid_to_cpu = kzalloc_objs(*scx_cid_to_cpu_tbl, npossible, GFP_KERNEL);
 	cpu_to_cid = kzalloc_objs(*scx_cpu_to_cid_tbl, nr_cpu_ids, GFP_KERNEL);
 	cid_topo = kmalloc_objs(*scx_cid_topo, npossible, GFP_KERNEL);
-	set_cmask_scratch = __alloc_percpu(struct_size(set_cmask_scratch, bits,
-						       SCX_CMASK_NR_WORDS(npossible)),
-					   sizeof(u64));
 
-	if (!cid_to_cpu || !cpu_to_cid || !cid_topo || !set_cmask_scratch) {
+	if (!cid_to_cpu || !cpu_to_cid || !cid_topo) {
 		kfree(cid_to_cpu);
 		kfree(cpu_to_cid);
 		kfree(cid_topo);
-		free_percpu(set_cmask_scratch);
 		return -ENOMEM;
 	}
 
 	WRITE_ONCE(scx_cid_to_cpu_tbl, cid_to_cpu);
 	WRITE_ONCE(scx_cpu_to_cid_tbl, cpu_to_cid);
 	WRITE_ONCE(scx_cid_topo, cid_topo);
-	for_each_possible_cpu(cpu)
-		scx_cmask_init(per_cpu_ptr(set_cmask_scratch, cpu),
-			       0, npossible);
-	WRITE_ONCE(scx_set_cmask_scratch, set_cmask_scratch);
 	return 0;
 }
 
diff --git a/kernel/sched/ext_internal.h b/kernel/sched/ext_internal.h
index ff7e882bd67a..9bb65367f510 100644
--- a/kernel/sched/ext_internal.h
+++ b/kernel/sched/ext_internal.h
@@ -1124,6 +1124,14 @@ struct scx_sched {
 	struct bpf_map		*arena_map;
 	struct gen_pool		*arena_pool;
 
+	/*
+	 * Per-CPU arena cmask used by scx_call_op_set_cpumask() to hand a cmask
+	 * to ops_cid.set_cmask(). The kernel writes through the stored kern_va;
+	 * the BPF-arena uaddr handed to BPF is recovered by subtracting the
+	 * arena's kern_vm_start.
+	 */
+	struct scx_cmask * __percpu *set_cmask_scratch;
+
 	DECLARE_BITMAP(has_op, SCX_OPI_END);
 
 	/*
@@ -1480,8 +1488,6 @@ enum scx_ops_state {
 extern struct scx_sched __rcu *scx_root;
 DECLARE_PER_CPU(struct rq *, scx_locked_rq_state);
 
-extern struct scx_cmask __percpu *scx_set_cmask_scratch;
-
 /*
  * True when the currently loaded scheduler hierarchy is cid-form. All scheds
  * in a hierarchy share one form, so this single key tells callsites which
diff --git a/tools/sched_ext/include/scx/cid.bpf.h b/tools/sched_ext/include/scx/cid.bpf.h
index e281c88fa824..70f2a3829af4 100644
--- a/tools/sched_ext/include/scx/cid.bpf.h
+++ b/tools/sched_ext/include/scx/cid.bpf.h
@@ -675,56 +675,4 @@ static __always_inline void cmask_from_cpumask(struct scx_cmask __arena *m,
 	}
 }
 
-/**
- * cmask_copy_from_kernel - probe-read a kernel cmask into an arena cmask
- * @dst: arena cmask to fill; must have @dst->base == 0 and be sized for @src.
- * @src: kernel-memory cmask (e.g. ops.set_cmask() arg); @src->base must be 0.
- *
- * Word-for-word copy; @src and @dst must share base 0 alignment. Triggers
- * scx_bpf_error() on probe failure or precondition violation.
- */
-static __always_inline void cmask_copy_from_kernel(struct scx_cmask __arena *dst,
-						   const struct scx_cmask *src)
-{
-	u32 base = 0, nr_cids = 0, nr_words, wi;
-
-	if (dst->base != 0) {
-		scx_bpf_error("cmask_copy_from_kernel requires dst->base == 0");
-		return;
-	}
-
-	if (bpf_probe_read_kernel(&base, sizeof(base), &src->base)) {
-		scx_bpf_error("probe-read cmask->base failed");
-		return;
-	}
-	if (base != 0) {
-		scx_bpf_error("cmask_copy_from_kernel requires src->base == 0");
-		return;
-	}
-
-	if (bpf_probe_read_kernel(&nr_cids, sizeof(nr_cids), &src->nr_cids)) {
-		scx_bpf_error("probe-read cmask->nr_cids failed");
-		return;
-	}
-
-	if (nr_cids > dst->nr_cids) {
-		scx_bpf_error("src cmask nr_cids=%u exceeds dst nr_cids=%u",
-			      nr_cids, dst->nr_cids);
-		return;
-	}
-
-	nr_words = CMASK_NR_WORDS(nr_cids);
-	cmask_zero(dst);
-	bpf_for(wi, 0, CMASK_MAX_WORDS) {
-		u64 word = 0;
-		if (wi >= nr_words)
-			break;
-		if (bpf_probe_read_kernel(&word, sizeof(u64), &src->bits[wi])) {
-			scx_bpf_error("probe-read cmask->bits[%u] failed", wi);
-			return;
-		}
-		dst->bits[wi] = word;
-	}
-}
-
 #endif /* __SCX_CID_BPF_H */
diff --git a/tools/sched_ext/scx_qmap.bpf.c b/tools/sched_ext/scx_qmap.bpf.c
index 7e77f22674ea..8a2d6a8ebd8e 100644
--- a/tools/sched_ext/scx_qmap.bpf.c
+++ b/tools/sched_ext/scx_qmap.bpf.c
@@ -919,14 +919,15 @@ void BPF_STRUCT_OPS(qmap_update_idle, s32 cid, bool idle)
 }
 
 void BPF_STRUCT_OPS(qmap_set_cmask, struct task_struct *p,
-		    const struct scx_cmask *cmask)
+		    const struct scx_cmask *cmask_in)
 {
+	struct scx_cmask __arena *cmask = (struct scx_cmask __arena *)(long)cmask_in;
 	task_ctx_t *taskc;
 
 	taskc = lookup_task_ctx(p);
 	if (!taskc)
 		return;
-	cmask_copy_from_kernel(&taskc->cpus_allowed, cmask);
+	cmask_copy(&taskc->cpus_allowed, cmask);
 }
 
 struct monitor_timer {
-- 
2.54.0


