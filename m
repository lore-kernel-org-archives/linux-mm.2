Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AD91CD4F25
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 07:10:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35FA36B0088; Sat, 16 May 2026 03:10:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 310986B008A; Sat, 16 May 2026 03:10:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EEFF6B008C; Sat, 16 May 2026 03:10:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B41B6B0088
	for <linux-mm@kvack.org>; Sat, 16 May 2026 03:10:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 663F31401F1
	for <linux-mm@kvack.org>; Sat, 16 May 2026 07:10:00 +0000 (UTC)
X-FDA: 84772408560.27.9172604
Received: from mout-y-111.mailbox.org (mout-y-111.mailbox.org [91.198.250.236])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1C3F0A000B
	for <linux-mm@kvack.org>; Sat, 16 May 2026 07:09:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=oyMB6gsV;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=o9uuHquk;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf25.hostedemail.com: domain of a0yami@mailbox.org designates 91.198.250.236 as permitted sender) smtp.mailfrom=a0yami@mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778915398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bCTRR472fL00L0PSNs+VkKzuj6RmTK8wIoiHmuNbRls=;
	b=ey0wEj1wf/BKbHI1gyK759zyk80JW1DtCbuCFUnBo3yacstDmKOLyfY7YjYu/HZ7RJf1SU
	1T8kOyLLdiuDWKIKybABBWPd6F0NvDfm9/Jh/Q83kru/WqKi8r+CFFtRi/z1BlMsTYd2DI
	mlXu7OsYN5Bm7uGunBkqE7fn5TIfmv8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778915398; a=rsa-sha256;
	cv=none;
	b=Dxr50dvoeGsBXJZ425F2HuckLIbP9gCQK84eHjC9OhOmWOmVs/DNUsfP0bJGi/nM1k7nIP
	nK2RVaJav+7aDQz4M8DHDSX0MqcG0Gcf5j2r30xL24s7ndSToNP9qZnAVLjfAEzKNhMF3p
	X+eL438/sOW/kO+5unp9clKxtN6rkK4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=oyMB6gsV;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=o9uuHquk;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf25.hostedemail.com: domain of a0yami@mailbox.org designates 91.198.250.236 as permitted sender) smtp.mailfrom=a0yami@mailbox.org
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-y-111.mailbox.org (Postfix) with ESMTPS id 4gHZvR0sf8z9yVt;
	Sat, 16 May 2026 09:09:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1778915395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bCTRR472fL00L0PSNs+VkKzuj6RmTK8wIoiHmuNbRls=;
	b=oyMB6gsVSD0ghwtNlOgdOxR8dM0Of2tddz2PEWv3N8MIoaEjSebnHERYYcq3/gnchTcMW7
	T1oChKRRnHRPLdCXaKdleZKIGLRUo3GkaJTeq1MKKEil+Nt1CX4q3YXWgMl0DkERVKbEt2
	jRQNb5Cg9VsxFS+my5b4Ig/Nnb2kZtbAouXZTANHYJnkuyBeJauoN/+9Iw7ziENHkcSBB5
	pDv4sGl7MWL7BZZ5qS9w3Usqwb7h1YkpR+Ze3Zs7UuacZsDSuPAlq68SWfGwHnG1sNDKO8
	kRIeKLD+Y5/OmOtLYevI4oxcOquYxHNl3Q+d18UM1iwuPkvQasRo11cQnINejw==
From: Qing Ming <a0yami@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1778915393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bCTRR472fL00L0PSNs+VkKzuj6RmTK8wIoiHmuNbRls=;
	b=o9uuHqukR5PEQQJ2wmOSoCVU49Sf+2P0LanFGDJ1Vs4UlaAct3i8mlyULrcgLtxUz8Sccg
	f0gFs8TK3rxPTv5xa9eRo1V6u2Pj5LfAReUtz96izGOfWkrQsNRxF1iObIB0CkCf6bT0i6
	oRvkCOs7WSHRIZhjlEIG1ttQOE6po/yis1KP5wlg/yaHkrcfyOgW08A03yfC5JxyAN3tWL
	0LwBsasx8OA6hfCsqD2r3t0KURdbvUChc/4JAJJzSdACQ7Gz6tIZpXCBUHgvm7a+yNnLf9
	c3ALg4HSYfGARle732btOo3bC46xx1Wwj4P3Nx6spKWf1oetBdqh91OoQo6oNg==
To: Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Hao Luo <haoluo@google.com>,
	Yosry Ahmed <yosry@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	Qing Ming <a0yami@mailbox.org>
Subject: [PATCH v2] cgroup/rstat: validate cpu before css_rstat_cpu() access
Date: Sat, 16 May 2026 15:08:49 +0800
Message-ID: <20260516070849.106141-1-a0yami@mailbox.org>
In-Reply-To: <20260515122952.59209-1-a0yami@mailbox.org>
References: <20260515122952.59209-1-a0yami@mailbox.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: cqjtyprk1mgmjgi3m5anood8wjajaezk
X-MBO-RS-ID: 2e6ac942611f7cd341e
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1C3F0A000B
X-Stat-Signature: 7zor3nbxer7fsucfifgeiceqr9f8mu33
X-Rspam-User: 
X-HE-Tag: 1778915397-629332
X-HE-Meta: U2FsdGVkX1/No1Rx9SiELh5BfRb9+e1r7UdMUWLH9uPGnRDgvlNmk53NHA00skMyMmynjOg6HyppeLff+kf2EKw8pAt4N2RBs46GO9XU0eNvr0QkwDdokEK7lVHHwIQfaflnKIgAHpblHXec0m/Zf2WUVSHV/HCJUJitIX7firjlQVyEECiqnbeTCtSwrGAkznjFQPYVm1GflQSUSFu/z1/tH6y12w4wNWuagnxBuKaYMx5K63O+yKVomic6ZtmV8SPqppDEPC0NrzcfVAQPu9581jWfHcCFJTfN31ePcR8vs1xfeySN7EpzQvODymYpdw8WgrullGRrP/zjJOXGY4D7Jg8dX/V9RYPR0IQXMJSfnV9Tz9+gqjc0pVAUKio08JowInVpd6puO8IQpoFVwpTlGaWrPi5eDvicxhG/5dh3c+ShAo+kJ6QJIGG5oeNGGBEpHDuVx+9asxSOBSPk6h2Mh361O1zLSWgirx8n3Yw6YYJENccEu2HuJ4KAeK1qk0wC3n+v3PZPbkd+ns+QcVf7lTJx8EH1u+37NnFdd/Togbk27CduVZ6CF1nxloGp22HxS2O0+XQYzIC67LjlQXNUTb1ULom8vK91kzBgBkL9FxZ/+GzddRJ/mIdaacIsVnkgVNp8fa5RxmiR8t2F/KsVzlqm0lS7g1jIOTglwm8xYGw+gIKKH9DFqI8QhYSxVMGHljEQqgxeoCfoN+9Rp454ynemyEc9eq1fqi2t4x72wS3w7NDZ7pQzc95syb8K186kklv903XwlhnT+8VO+mAgelq3goYd0YZHRxZKuFu4F+pbC9Xe3rSIJMFAEs5S7d4NVg5Esw+1f/WiEpw4y01axSVtL63zbK3vcC6/KSD+Lsn87iFu1kGsZ9yqas8UWtI8mIehM8cqxJRNIkwCWTkLdN817BPOdpSNUncD1Ll3H60Na9IZy5KHXjCK8gRmaIlqeqNmCWrUx4I0AwW
 0+PcN/RW
 9psuf7jVfjQd1rmMrsd1kZ6s4ibM+0CqaKDlZHqCX4WCzS5QphNxQFPFjfilZoHb7w1+AG6A1A3ycUwlE7PbcMka+ciXX0ge3pJzbdWSxxfEpaa45F63kXH9vQ0qj8ItnoYZFaxQe/kNrVtL18ArMNxOZv5t+RazmS1CcTydrjnDsgCkY0DXrBwVQQAcPRk7QuIKkCLdnUuOjRH2Deuvq8ScVf/t2UshMRcLrp3YvFPp72v4IifB2wAMcF8wJWkS2nC+0x9q43MmhVhlf0SsKMe8z/+DjJT3VztNGV3xlQqeG1yvtRkLg+e0cQ7s9LoZEdKBYc+lNHRwwHUTR/caPwrEfzeRQc4dS0v8EjMSKjN2uU2sxP82/J0gs/5YD8ru3EsOvEMJAae7Bnorrt/4LB8a0lfKsmI7NNJENDuGgtfRJTkC9Lx/jwp4+xIKVNZK4bcug
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

css_rstat_updated() is exposed as a BPF kfunc and accepts a
caller-provided cpu argument. The function uses cpu for per-cpu rstat
lookups without checking whether it refers to a valid possible CPU.

A BPF iter/cgroup program with CAP_BPF and CAP_PERFMON can pass an
invalid cpu value. On an unfixed UBSCAN_BOUNDS test kernel, cpu ==
0x7fffffff triggers:

  UBSAN: array-index-out-of-bounds in kernel/cgroup/rstat.c:31:9
  index 2147483647 is out of range for type 'long unsigned int [64]'
  Call Trace:
    css_rstat_updated
    bpf_iter_run_prog
    cgroup_iter_seq_show
    bpf_seq_read

Add cpu validation to the BPF-facing css_rstat_updated() kfunc and
move the common implementation to __css_rstat_updated() for in-kernel
callers.

Fixes: a319185be9f5 ("cgroup: bpf: enable bpf programs to integrate with rstat")
Signed-off-by: Qing Ming <a0yami@mailbox.org>
---
v2:
- Split css_rstat_updated() into a BPF-visible wrapper and an internal
  __css_rstat_updated() helper.
- Switch internal callers to __css_rstat_updated().

 block/blk-cgroup.c     |  2 +-
 include/linux/cgroup.h |  1 +
 kernel/cgroup/rstat.c  | 30 ++++++++++++++++++++----------
 mm/memcontrol.c        |  6 +++---
 4 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 554c87bb4a86..bc63bd220865 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -2241,7 +2241,7 @@ void blk_cgroup_bio_start(struct bio *bio)
 	}
 
 	u64_stats_update_end_irqrestore(&bis->sync, flags);
-	css_rstat_updated(&blkcg->css, cpu);
+	__css_rstat_updated(&blkcg->css, cpu);
 	put_cpu();
 }
 
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index f6d037a30fd8..c5648fcf74e2 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -777,6 +777,7 @@ static inline void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen)
 /*
  * cgroup scalable recursive statistics.
  */
+void __css_rstat_updated(struct cgroup_subsys_state *css, int cpu);
 void css_rstat_updated(struct cgroup_subsys_state *css, int cpu);
 void css_rstat_flush(struct cgroup_subsys_state *css);
 
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 150e5871e66f..ed60ba119c68 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include "cgroup-internal.h"
 
+#include <linux/cpumask.h>
 #include <linux/sched/cputime.h>
 
 #include <linux/bpf.h>
@@ -53,7 +54,7 @@ static inline struct llist_head *ss_lhead_cpu(struct cgroup_subsys *ss, int cpu)
 }
 
 /**
- * css_rstat_updated - keep track of updated rstat_cpu
+ * __css_rstat_updated - keep track of updated rstat_cpu
  * @css: target cgroup subsystem state
  * @cpu: cpu on which rstat_cpu was updated
  *
@@ -63,20 +64,17 @@ static inline struct llist_head *ss_lhead_cpu(struct cgroup_subsys *ss, int cpu)
  *
  * NOTE: if the user needs the guarantee that the updater either add itself in
  * the lockless list or the concurrent flusher flushes its updated stats, a
- * memory barrier is needed before the call to css_rstat_updated() i.e. a
+ * memory barrier is needed before the call to __css_rstat_updated() i.e. a
  * barrier after updating the per-cpu stats and before calling
- * css_rstat_updated().
+ * __css_rstat_updated().
  */
-__bpf_kfunc void css_rstat_updated(struct cgroup_subsys_state *css, int cpu)
+void __css_rstat_updated(struct cgroup_subsys_state *css, int cpu)
 {
 	struct llist_head *lhead;
 	struct css_rstat_cpu *rstatc;
 	struct llist_node *self;
 
-	/*
-	 * Since bpf programs can call this function, prevent access to
-	 * uninitialized rstat pointers.
-	 */
+	/* Prevent access to uninitialized rstat pointers. */
 	if (!css_uses_rstat(css))
 		return;
 
@@ -125,6 +123,18 @@ __bpf_kfunc void css_rstat_updated(struct cgroup_subsys_state *css, int cpu)
 	llist_add(&rstatc->lnode, lhead);
 }
 
+/*
+ * BPF-facing wrapper for __css_rstat_updated(). Validate the caller-provided
+ * CPU before passing it to the internal rstat updater.
+ */
+__bpf_kfunc void css_rstat_updated(struct cgroup_subsys_state *css, int cpu)
+{
+	if (unlikely(cpu < 0 || cpu >= nr_cpu_ids || !cpu_possible(cpu)))
+		return;
+
+	__css_rstat_updated(css, cpu);
+}
+
 static void __css_process_update_tree(struct cgroup_subsys_state *css, int cpu)
 {
 	/* put @css and all ancestors on the corresponding updated lists */
@@ -170,7 +180,7 @@ static void css_process_update_tree(struct cgroup_subsys *ss, int cpu)
 		 * flusher flush the stats updated by the updater who have
 		 * observed that they are already on the list. The
 		 * corresponding barrier pair for this one should be before
-		 * css_rstat_updated() by the user.
+		 * __css_rstat_updated() by the user.
 		 *
 		 * For now, there aren't any such user, so not adding the
 		 * barrier here but if such a use-case arise, please add
@@ -614,7 +624,7 @@ static void cgroup_base_stat_cputime_account_end(struct cgroup *cgrp,
 						 unsigned long flags)
 {
 	u64_stats_update_end_irqrestore(&rstatbc->bsync, flags);
-	css_rstat_updated(&cgrp->self, smp_processor_id());
+	__css_rstat_updated(&cgrp->self, smp_processor_id());
 	put_cpu_ptr(rstatbc);
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c03d4787d466..749c128b4fad 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -679,7 +679,7 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, long val,
 	if (!val)
 		return;
 
-	css_rstat_updated(&memcg->css, cpu);
+	__css_rstat_updated(&memcg->css, cpu);
 	statc_pcpu = memcg->vmstats_percpu;
 	for (; statc_pcpu; statc_pcpu = statc->parent_pcpu) {
 		statc = this_cpu_ptr(statc_pcpu);
@@ -2796,7 +2796,7 @@ static inline void account_slab_nmi_safe(struct mem_cgroup *memcg,
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[pgdat->node_id];
 
 		/* preemption is disabled in_nmi(). */
-		css_rstat_updated(&memcg->css, smp_processor_id());
+		__css_rstat_updated(&memcg->css, smp_processor_id());
 		if (idx == NR_SLAB_RECLAIMABLE_B)
 			atomic_add(nr, &pn->slab_reclaimable);
 		else
@@ -3019,7 +3019,7 @@ static inline void account_kmem_nmi_safe(struct mem_cgroup *memcg, int val)
 		mod_memcg_state(memcg, MEMCG_KMEM, val);
 	} else {
 		/* preemption is disabled in_nmi(). */
-		css_rstat_updated(&memcg->css, smp_processor_id());
+		__css_rstat_updated(&memcg->css, smp_processor_id());
 		atomic_add(val, &memcg->kmem_stat);
 	}
 }
-- 
2.53.0


