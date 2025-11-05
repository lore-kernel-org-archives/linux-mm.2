Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06D51CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:07:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 611028E002C; Wed,  5 Nov 2025 16:07:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C20C8E0002; Wed,  5 Nov 2025 16:07:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B11F8E002C; Wed,  5 Nov 2025 16:07:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 394A88E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:07:46 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EC948160436
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:07:45 +0000 (UTC)
X-FDA: 84077790090.05.8C48260
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 643EB18000F
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:07:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WLDkMjKl;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dbgKzffWJKqQ2O91ySY6yB7U/ycIBfKoY7N3rP0ZXGg=;
	b=5eUEkkzv0GYAi92KIM+XCZbq4N41WhDcewlR/WWxLq4StFf4WSFdxZfuQbN8xHn82WDpGs
	saxr91U0sVPjMfXG13m1LIZAdQLPAH+oWzRsJl/V0lg4Clk0x7DoyRCWFmZoD0TZMHGlCv
	oGG291jb99Vdo5r7BASeSS3Vhl9sI5U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376864; a=rsa-sha256;
	cv=none;
	b=7UAbQz+SXhZBxwsXMuP4bPWodKuQ3vV76LzIgkuuba/141UI/phTHTBKr19tfpAZRVlI5m
	sjuzYq8SeSxmwQvrfGFDtDsXvs5XTYDzJiIfwMiAzsbLYZR5ZxXQ8m6URWZJ+G59YXrYCi
	JYQ8O1pmVM/wL2WhckRdTU4pFxam7Fc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WLDkMjKl;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A5934601F1;
	Wed,  5 Nov 2025 21:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0115EC116B1;
	Wed,  5 Nov 2025 21:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376863;
	bh=6jwYeig2zqPrmwGwM4pQrsHIUOv6qqFjI/kog2VhZlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WLDkMjKlR2GjM6ul10cb70ghHeSr5aremTf7CjKkC/5QKjY04kalvpwuwnKK4I5NY
	 IEO/g7jz17F5MZF1gqOpJNb6UxGmp6JHci/Qa5aPe7GOuNcZsnGK1YtNlkgGRrC+ka
	 DxmVtLqKmpAvFgJvU4RPxh/CZbJHpONR7S74p0VLnz8YRnymh5W+/aGYeh++jcRsgR
	 Js/L3sSGqqg+cb6eDfgLzf69RQ8Pqw98poq7YGmCkDDJT8etX5MyL8Z/gL95TOFsqr
	 BJ5Uly3TzQphQ9EKLsa+FCZImOjNeyUAZRabscSXCaRpMuJc99OamaZpN1Fx7tIPjT
	 6iPf8Cpfdggkw==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 28/31] kthread: Honour kthreads preferred affinity after cpuset changes
Date: Wed,  5 Nov 2025 22:03:44 +0100
Message-ID: <20251105210348.35256-29-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 643EB18000F
X-Stat-Signature: 6d4wzey9gy8x6e3b7msrn6smbz565ubd
X-HE-Tag: 1762376864-644473
X-HE-Meta: U2FsdGVkX1846Lq//0AnfE+x1mx0iWAxZMdhMHv8QgEaF7xDhXut3B60111+1FBNpF+z11iW1TCRMNlBM6REQMObNSTEpxdgn/Q64XCsROOPl76sD77cKhmdE6fTFQ+jYp6U6Fa9acfAQr2HpIAxGucVa5RnMulR0aKRX4B9V82gwLPjcADFyMYdXgG4O0lVXM00VPT3rTRN4sAR7Hluy9CEVm5AptSpz0Wxat4EIagCs8ZTmNgkmSslq3NLBxED0GaOVQf7Lk30UeAYc5llce9G7d3YD5spWDg4xre6M3KaSC3BfuYu5nDc0DD9oMf/7yT7nXLgHwT3S5qqkPtJi94ZMYdtGJnUs3XJGrBiu73ECLoGziBIV9+8mTtCwCo+mhoTBrtUvDk2D3dL82uW8kA+f0apWTHmhfmBDAinVHG9Kzzq1eeCdC00eQ7xHeSRsxGlP1TpLFIjDnCl6yggXvXnzrCiq2larZHd/3l2/q6fA0mm8YWAqjh+877gkpksV875VQ6B9fC/5B9qjKclGnfcOeBojgF5NyqLg5Wt6Ttl1vKC2NXoD1wF++sVJ6rVAi47SPkhoNGmmIZi5o5uyhO56pCf+dMBO0UuapiuWOx+mTTUUFnOPUJ6C4JCDXcDRBLZxtrOjERAgIxQn2lFbVlL7YFCaly5+NzQIgY1R82EAZEImDDyTF+eVgf+ihys814CwVV3Prde3zW/91aEdtIVQNQjyNlsKZ5/j+TR9yL8RFmxwjmORBh0r0/JYO8fWUczX7z1Y9ljZd32R5vXOaw5cZYsWGl4/Op3NP1uiZyodTaWxa0fubvK+1YiinnMpNSosTlRZsvlebG23PHuM7pNvf4A6tSmsH+VV4aBhP1Nv97veLYuXI50I35+byjvbtx4+hD5wqCGuL/crIzN+or7tXF7fB2OKg2PmF0jSigO1dYhAA45pazMr3izPczBDqS+Dh0W+0g6q6GkEXb
 1+3hxlcI
 aCvcNFIWC/2LnqRzY7onWHZFbvLaNrrKPCLjjhM1Dai/iMSn+ESAUmuFQukC2STV0Z5WjGvq3dpZfrxMlXJ91EBiHpMDXx5hhxVMtr/rw1pgwPGO7Y3jds4DMmLQ9gvNtKdQf6A9kurLGq/l2Dz3PFxJn5tr39udP+WcV+qcoi3kcaToSbHYhwhZY+60/1kaJpThR6rgSDW9H0czb8zUg76aBdHXxwgFAv63O+wh7+qbGVBqpBIP0FHVVaITtI/hRa91wN1a/N9qPCe6juF63/+xS5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When cpuset isolated partitions get updated, unbound kthreads get
indifferently affine to all non isolated CPUs, regardless of their
individual affinity preferences.

For example kswapd is a per-node kthread that prefers to be affine to
the node it refers to. Whenever an isolated partition is created,
updated or deleted, kswapd's node affinity is going to be broken if any
CPU in the related node is not isolated because kswapd will be affine
globally.

Fix this with letting the consolidated kthread managed affinity code do
the affinity update on behalf of cpuset.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/linux/kthread.h  |  1 +
 kernel/cgroup/cpuset.c   |  5 ++---
 kernel/kthread.c         | 41 ++++++++++++++++++++++++++++++----------
 kernel/sched/isolation.c |  2 ++
 4 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 8d27403888ce..c92c1149ee6e 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -100,6 +100,7 @@ void kthread_unpark(struct task_struct *k);
 void kthread_parkme(void);
 void kthread_exit(long result) __noreturn;
 void kthread_complete_and_exit(struct completion *, long) __noreturn;
+int kthreads_update_housekeeping(void);
 
 int kthreadd(void *unused);
 extern struct task_struct *kthreadd_task;
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 817c07a7a1b4..bc3f18ead7c8 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1182,11 +1182,10 @@ void cpuset_update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
 
 		if (top_cs) {
 			/*
+			 * PF_KTHREAD tasks are handled by housekeeping.
 			 * PF_NO_SETAFFINITY tasks are ignored.
-			 * All per cpu kthreads should have PF_NO_SETAFFINITY
-			 * flag set, see kthread_set_per_cpu().
 			 */
-			if (task->flags & PF_NO_SETAFFINITY)
+			if (task->flags & (PF_KTHREAD | PF_NO_SETAFFINITY))
 				continue;
 			cpumask_andnot(new_cpus, possible_mask, subpartitions_cpus);
 		} else {
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 69d70baceba2..f535d4e66a71 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -896,14 +896,7 @@ int kthread_affine_preferred(struct task_struct *p, const struct cpumask *mask)
 }
 EXPORT_SYMBOL_GPL(kthread_affine_preferred);
 
-/*
- * Re-affine kthreads according to their preferences
- * and the newly online CPU. The CPU down part is handled
- * by select_fallback_rq() which default re-affines to
- * housekeepers from other nodes in case the preferred
- * affinity doesn't apply anymore.
- */
-static int kthreads_online_cpu(unsigned int cpu)
+static int kthreads_update_affinity(bool force)
 {
 	cpumask_var_t affinity;
 	struct kthread *k;
@@ -929,7 +922,8 @@ static int kthreads_online_cpu(unsigned int cpu)
 		/*
 		 * Unbound kthreads without preferred affinity are already affine
 		 * to housekeeping, whether those CPUs are online or not. So no need
-		 * to handle newly online CPUs for them.
+		 * to handle newly online CPUs for them. However housekeeping changes
+		 * have to be applied.
 		 *
 		 * But kthreads with a preferred affinity or node are different:
 		 * if none of their preferred CPUs are online and part of
@@ -937,7 +931,7 @@ static int kthreads_online_cpu(unsigned int cpu)
 		 * But as soon as one of their preferred CPU becomes online, they must
 		 * be affine to them.
 		 */
-		if (k->preferred_affinity || k->node != NUMA_NO_NODE) {
+		if (force || k->preferred_affinity || k->node != NUMA_NO_NODE) {
 			kthread_fetch_affinity(k, affinity);
 			set_cpus_allowed_ptr(k->task, affinity);
 		}
@@ -948,6 +942,33 @@ static int kthreads_online_cpu(unsigned int cpu)
 	return ret;
 }
 
+/**
+ * kthreads_update_housekeeping - Update kthreads affinity on cpuset change
+ *
+ * When cpuset changes a partition type to/from "isolated" or updates related
+ * cpumasks, propagate the housekeeping cpumask change to preferred kthreads
+ * affinity.
+ *
+ * Returns 0 if successful, -ENOMEM if temporary mask couldn't
+ * be allocated or -EINVAL in case of internal error.
+ */
+int kthreads_update_housekeeping(void)
+{
+	return kthreads_update_affinity(true);
+}
+
+/*
+ * Re-affine kthreads according to their preferences
+ * and the newly online CPU. The CPU down part is handled
+ * by select_fallback_rq() which default re-affines to
+ * housekeepers from other nodes in case the preferred
+ * affinity doesn't apply anymore.
+ */
+static int kthreads_online_cpu(unsigned int cpu)
+{
+	return kthreads_update_affinity(false);
+}
+
 static int kthreads_init(void)
 {
 	return cpuhp_setup_state(CPUHP_AP_KTHREADS_ONLINE, "kthreads:online",
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index bad5fdf7e991..bc77c87e93ac 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -151,6 +151,8 @@ int housekeeping_update(struct cpumask *mask, enum hk_type type)
 	mem_cgroup_flush_workqueue();
 	vmstat_flush_workqueue();
 	err = workqueue_unbound_housekeeping_update(housekeeping_cpumask(type));
+	WARN_ON_ONCE(err < 0);
+	err = kthreads_update_housekeeping();
 
 	kfree(old);
 
-- 
2.51.0


