Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C7E0CD5BB4
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 17:22:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9A8E6B00C0; Fri, 22 May 2026 13:22:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A77C96B00C2; Fri, 22 May 2026 13:22:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EB556B00C3; Fri, 22 May 2026 13:22:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EB826B00C0
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:22:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2926E1A0863
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:22:31 +0000 (UTC)
X-FDA: 84795724902.21.8473BD0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 905DCC0007
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:22:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M3sn00kP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779470548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eX0Mxlx1n6AwVGSB1X8Y1otXtKX0cegACAfNOUMD+j4=;
	b=T0AmtaLaSXzX9pBAUuBxdDMpSGEAS8QoXQ2SV8cjVtPq0loHzQJZzun5Y9YBYVVK96uL6F
	8bmwkL8iWp1HrS5PX0pasvebOlLSO72MMUTj//SMU4GdpwPoBFFx+HZaMDk6uLvapzcepw
	XgW4hc7lm7wYiX0d8I30sOtOfWgVnZA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M3sn00kP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779470548; a=rsa-sha256;
	cv=none;
	b=G6Baig0JHETIrc/vxZ1HRUEXLAZ+SohYCmVGc1g3hUYXD6Hdn218pMM3C90e2qZAt/FLIY
	+h73RJje0HDjqShSDCObsWVN4GGvQI60T9gTbgsPbxcZzrHD25XpV0d+3gGKYHNA9uk+6Q
	6OD8iY73XEFyRZmpHZqWHbSgp6rkQyY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 21EAA6022E;
	Fri, 22 May 2026 17:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27791F00A3F;
	Fri, 22 May 2026 17:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779470547;
	bh=eX0Mxlx1n6AwVGSB1X8Y1otXtKX0cegACAfNOUMD+j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M3sn00kPfnYp6fE1gGLPv/h1VIy9g2pURe2Jpw3twBNUcNRpIyFQj7Y6Hkpjdengy
	 D6OhOuIU8sTcjA3WC5lEVdWFcLRZokaEnCKxrfZeKx3NkZ3lcd/yFhs3K4wabzpZKI
	 y7kD+UiLJGsou+kSioRuvxcpMc22Z18oF3d1cuZg3CV0mkcWebD7iCjpWTHVjTPj9/
	 M68qrDqANsf+jVp3h0QB10D14m3Mr8mza144wa03yEyXzHPFFsJc1TfM4YFHUFnV4+
	 zbpbTS4KZligU+2AkAIc3AcLkIf1u1TSpOf4kgMfdtdnaWvjsEa6EEIFL/2tEbKeZF
	 zpEkCyQ9q1kXw==
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
Date: Fri, 22 May 2026 07:22:19 -1000
Message-ID: <20260522172219.1423324-9-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522172219.1423324-1-tj@kernel.org>
References: <20260522172219.1423324-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 905DCC0007
X-Stat-Signature: ne6hk9o8ohbsqbym4jaoag8fud5m3tkg
X-Rspam-User: 
X-HE-Tag: 1779470548-600149
X-HE-Meta: U2FsdGVkX1/h47psm69sCDrqgK20+gex5i3uR/QepPklyLCkSrwniejHG+isvYcEpCoWK8Yutga0aRhv/qss8vO6feyMBY8jQNI4vGvyHd29Ql8Gpy2Bsdl0i2qXqnlyXys10U0qL4UjtBRRjaQMVXz6BqsUMy+1zzB/VmumPkxuvr7/+7JEq4pkG2NkBPxXRukQ/6i3cDPl7ay2aYEVyKKBFAe1n1NEIydliHP+qY1K6UyOTyB4W8gsuFffzuEVpOy+G6HIoQAQvcyWHSmewir0RoetzM8+S6FXQEQy7rg6BDf5JR5Nge1+X+8YuiqnCBAD5nGhu74BjXlF3upuMkyizaRSSYTO1/OD6U79JYk2gal4llayh47vNQOKi2oVehxZAQYVEgDBi4DeHoOvDbHURiO6huc+T7lLjcBFJEBFmR2v2fbT4PaFJ4Ulps8K0VcDu+L6bM8CnS+exoORdywdnG32vKgWYo36eORUrx0Z4I8CeqE8CusqDW1xMD0jlMhjhmTDEYN+qK2wovVZIl2TpW9dAsSPN71tb52e2/dnZLkbvEJ0p41E8Go4dBCrHdEZ4UiSZ9GafJ6prMbYI1f6AbWpTWPbUqeS9QlCvUR4vO1lsPNwQYm33qCzwkEUpXAQ3CdweZyEeaNNipmuyNB0IWuRAjwDZRZ+VSJPCRXHBY/SuknH3EiVAhylL2R7IE3Msqlwx+MZBkIyE9xH7/KCei4yoNzFCzqgBZtWloFMb1aA+O+MxZj2ebPTWxpa1nei0gtW27bKaSW1Sjh+9N81fTuT6zZ6uXABNUxPmN5fzSRm0ARO/ZezDtY3/Ew+y0iQai97GCVRK582Dne1O7TK6GpAUGx1U7bVUbHNpQzF6imwAI9jOZpEILmFojGgVzOrKK5itPkDxqcG4j2WWMdmM96NYofANQqaQp9dxcPWw7Yw/twLiq7p7CnYH2Lizj5nNm81iIVwgCPcUW8
 yq1hzSS/
 VPjN6YqWIYwcn98Po2zZ7PoX4xtTLBCyXrGImYyFDjvnqaEAxfSF2AmobC36SY+Wo7eOSI5w7zv5WOqjuHs0tOWB77M6/MvVRPfxfopFod1nQEXMlv/ohwhN4pxeaa9bCT6Y+Mmryx88135r2Y2luZb9FI2TwzolcSpXJnJcec9Lk1s71MQwlO0IODvdgxdZQq4WgD0j2YGbh6kSnm1el/qDmAqgyej5iTRRjkq660SpWTV2/E1DKoEwolXCdM2HV7S7UbniD1LAfzvzkQTiQis8EZkb41Q5HSn8oTIV26H98ladb91OIn/H9FoVdihc6pY50tIbGZ74zEpPzJREI6p920A==
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
arena. The kernel writes to it through the kern_va side of the dual mapping.
BPF directly dereferences it via an __arena pointer like any other arena
struct.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
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


