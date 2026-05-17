Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35893CD4F48
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 21:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DF726B009B; Sun, 17 May 2026 17:12:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 091A96B009D; Sun, 17 May 2026 17:12:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1B96B009E; Sun, 17 May 2026 17:12:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CC32F6B009B
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:12:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 96B091C1AAF
	for <linux-mm@kvack.org>; Sun, 17 May 2026 21:12:44 +0000 (UTC)
X-FDA: 84778161048.02.0BE20FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id C6C5F2000F
	for <linux-mm@kvack.org>; Sun, 17 May 2026 21:12:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X7e0esLG;
	spf=pass (imf03.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779052363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9R/gNuEv2Xy8ctDACzL9ci7Vb07fIl3Eot3GkHIyB0U=;
	b=dJ5cxepiMCJjaEcE1OUy7Si9/2fHzO6+B7hHOH/I5sumwlHdj+uLdE8AOyKNOkGieqF4sb
	K5iJGW+bcFREsTHnX6V4D73j1u3jVNMFgLHRT0WbCLxJEM+i/h2MoK9vwG6BzO3XX3puAc
	41I1TyR93z/UTFgd6PzM06mhxnV4vxc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779052363; a=rsa-sha256;
	cv=none;
	b=dWeYQb7+vj/gylU2OSMZj8KQxSURvm0zDUrc6jnT3iYHfWLKFDWs4v+uJesfSsh2ee0pBg
	PATbOe1cMYO85B/Hc/WCxTvTHgTbdMfkFq2ciWrILNMgNZcbItFyYUQQnVN0TAvZaBf/ew
	tTZBhUpULUaC/uCOPg//WUEfBRBBmhc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X7e0esLG;
	spf=pass (imf03.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BC67540169;
	Sun, 17 May 2026 21:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C07C2BCB8;
	Sun, 17 May 2026 21:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779052361;
	bh=fxqO7G8tF93+kJY+9znNmCMmTASH/TQjlmFfWTFvw3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7e0esLGqEsECSu554ctMVgJiGaswoYg70obb0+5iSrkuewC73kMczW+t/+CHAiFj
	 yfomcKkHt+Z7EJyYqqY5AUAJkp6v39mc4cG46OuyR3xI/A/z5YYr/80lgzgeZvUouO
	 brK7phL24kasSgJApzHjk1U0gp3m6iC4ptv0ICGK/6MG3p1AxPjGEcKRn5SmJij/y7
	 teLMRK0/paiP4ctaGB9wj9gA+XbbW3YThW4Ls/6hDa132FFjODEVhNfvnHfU7KESlI
	 q3E/hEm2BFtkwIz2t9XAUMfjWikxDy46u9ltHoZyTYvWBuH8oUO5+mWAYlRJlrmkIa
	 QLb2MQ2ZZiKzg==
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
Subject: [PATCH 8/8] sched_ext: Convert ops.set_cmask() to arena-resident cmask
Date: Sun, 17 May 2026 11:12:32 -1000
Message-ID: <20260517211232.1670594-9-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260517211232.1670594-1-tj@kernel.org>
References: <20260517211232.1670594-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C6C5F2000F
X-Stat-Signature: qtubh95djac8rectbuubijm1ka5wfnby
X-Rspam-User: 
X-HE-Tag: 1779052362-18660
X-HE-Meta: U2FsdGVkX1/Ysiqau3ib2dNPM6/qm6yBaoZ+W+/OIEGKEI+T91iv3puy+r2omJQp2v8uktlxlevSUNjO2CfzVPeTKT7UE1a6Cn23oJW6XNMmt8KhSwjbmuFuheoBs5GxzrJ0UNA+t0WMAy+7C1ZUWgg5KbEh2wNajPqZRJ/TdQUN8e3iZF/0LwA7/ZyicBqkvXEJzPnnW1zY1iZK6kVhgH+/XtU82N36Bm8OwJeahj7qhWUMDfR/trcZr1X9ZfivRm+UbFlkhKC9dP3DnrpPLZa0Gd8/6FiMS5er17k8xMsz29xApQC9CZTJN6JLIFdl/O39/FEilNIR7Sr0y34L5cJVKynUrLxxDKdswERGdxvEdFcYJn5kpg2p1Thdn3YdUdWDYAxFc9ax33PYu+RTKXzc8kZK2oj2I8Ismdy0DsJgaG7pv9m1G7KNP8RKAausBkJDDvUzyMF/jkB9iMnFgrAOPTpF/+pJaszpfzcYqm6/d1a1U18/OiauQ08gZcLEFnO5GuwXhmlXxF2AHpLTlclW5nHUiaM9PWhXIm4jIqyfFXuFADlH8vxUduFeALxi6sKx9iDHtUqN5ylV2/dOuBRUlOOkcg9YWF90wWzpL6+EhKGcUXivMUhBMoBFEM5Kyx4Ft4p5Nv60szD7bv3W6t63tBen9Edj5Rr3lxmXuuSH1sfWjqcbsdLuURYGG9FV5DYHtxgC/QfVib8fIpD+FDLRE9eq6F64jiF4SixHrGwSQXNWn4pG5emAsHC0lPpo0joIJYJ0QYLVEmeZZQ5aqSV0WqCV0QBkau/mXeWTSyZsHnyQbpS4EmNNTP0Mp64nbiuebQjHoCMOL6Hpwb2kZoGlu+9q1Z1eHcXLXpTu+qSNvvpNsu+LcTcFfi3oUrwJOJLE9H8m5wzucCcUxFi5730NhrVlBrP+w7EAqZX90OEr8kXS9bzboIxS/ostAj09LzbXX1nDHvexS8xJHJn
 qqYDLqMU
 6RjOuIQa0pHUECdnSoZcF3hn4IvVcGFnGLm9QbRIrk6voiqu7OSSEibATzGChqvFRL7RNdY3kjZKz2PgXSyYOJWYADf7I0+tPWAWuGALShO1vgn73KKMXeQ00Uz6rwlmTBG1MT9G0SQ8uy/se2Qkf0Ab5tTeSgZ+1Di+SvdrwKMOpxLhgBl5Shl8NLljJK0yb5TBX9ZJ/IFb1AkZ1YBv5qsUE4Fq4MdUFV+TLqTSC65gyKNZjx14M0kS1H6buvmJGGMzcKhIDmqSz3uIOy/WsQxJvoQ==
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
index 3025fbe198d3..1369dc7e4b4e 100644
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
@@ -4957,6 +4962,48 @@ static const struct attribute_group scx_global_attr_group = {
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
@@ -5009,6 +5056,7 @@ static void scx_sched_free_rcu_work(struct work_struct *work)
 
 	rhashtable_free_and_destroy(&sch->dsq_hash, NULL, NULL);
 	free_exit_info(sch->exit_info);
+	scx_set_cmask_scratch_free(sch);
 	scx_arena_pool_destroy(sch);
 	if (sch->arena_map)
 		bpf_map_put(sch->arena_map);
@@ -7147,6 +7195,12 @@ static void scx_root_enable_workfn(struct kthread_work *work)
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
@@ -7469,6 +7523,10 @@ static void scx_sub_enable_workfn(struct kthread_work *work)
 	if (ret)
 		goto err_disable;
 
+	ret = scx_set_cmask_scratch_alloc(sch);
+	if (ret)
+		goto err_disable;
+
 	if (validate_ops(sch, ops))
 		goto err_disable;
 
diff --git a/kernel/sched/ext_cid.c b/kernel/sched/ext_cid.c
index 5cd14143f88f..245a39e2e5eb 100644
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
index 257d8bdca966..875003f04bdc 100644
--- a/tools/sched_ext/include/scx/cid.bpf.h
+++ b/tools/sched_ext/include/scx/cid.bpf.h
@@ -669,56 +669,4 @@ static __always_inline void cmask_from_cpumask(struct scx_cmask __arena *m,
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


