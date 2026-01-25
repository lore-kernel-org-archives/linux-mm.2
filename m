Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ACE0D7237B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75E216B009E; Sun, 25 Jan 2026 17:49:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7256C6B00A3; Sun, 25 Jan 2026 17:49:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 614EF6B00C5; Sun, 25 Jan 2026 17:49:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DCAA6B009E
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:49:59 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1FD6A1A050D
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:49:59 +0000 (UTC)
X-FDA: 84371980518.13.7BCD087
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id BA76180007
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:49:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kvQ5Lnyz;
	spf=pass (imf30.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C9Nm9/UDIo43IcDUT0eKYVHqVsy1qWtWdi8Lz6ZU9Cw=;
	b=cgnvE4EpSTJW1/eYrucmxFpAzlJqi5x0m5lwbuFa4yw4GRfaUiDWzyWM4frHswVJHrXumM
	9pKLgdqGUixDD7aabJNXO5Wn4bZf6EgVSnLEwi7KX+2ZBvFfsG5rv3LG2x4adkHCBY0nfk
	eNHGo0Ssxt2n9YdHOVvhrFf2pwao7wA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kvQ5Lnyz;
	spf=pass (imf30.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381397; a=rsa-sha256;
	cv=none;
	b=eMT9k5eJqV/LhHnd0X+b5BhMx61vt+bnf/EWpY0/fmvdlB9htRXCm2ngYc376y4EohY0Zp
	7+AmX1/PG3mE20x6ptVXwthWKfjTfrlYewC//Hl4PUB9URRiIIffNP85L9l90xBE+BsuWO
	h7fXLmDBAcw+p0X/oWt0eb0IC6Oql/0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A657600C3;
	Sun, 25 Jan 2026 22:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128EFC4CEF1;
	Sun, 25 Jan 2026 22:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381397;
	bh=h4+1N6+onxTB3qHJHE3W5TiIbyuzvrEMpQNEnSESUL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kvQ5LnyzA+O6y4LUBWv/7wEJYWp46+ofYDM2EyONjVw1AIkqi6EB56+Oel9II/NLK
	 HHdKlb4PyDtYcmib4xuM5xdF8Af8P0DlSMiEcAtKW0KelHaT8vmw0qLVWbA9m+qoC7
	 tG+aNiq5gxL88NVCMk2hmDNjRsFYl9HKjZpsEdD9TsnHiXRrNFZD8zxXUssjMNHmqj
	 7i0PUx4Oyef4qEgji6Ns+v0gCbdZvVdcOaAqMJiNUHJpSKToUf0pDY3aXKvlxVkClJ
	 9/HGLvRC+cBbT8Fbyi27zOmB3eoGNswFV7aOlH4M+1RfBOxBANuYTERwWSSzl1GjLP
	 jt/8h7dy5BLBw==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
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
Subject: [PATCH 30/33] kthread: Honour kthreads preferred affinity after cpuset changes
Date: Sun, 25 Jan 2026 23:45:37 +0100
Message-ID: <20260125224541.50226-31-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: kcsbj9ggrt6sd57836sw4xtbjd99mfu4
X-Rspam-User: 
X-Rspamd-Queue-Id: BA76180007
X-HE-Tag: 1769381397-516259
X-HE-Meta: U2FsdGVkX19u5QIAjzdVN7YR3dcXYVK/93bnTN2iUYCceGM9pOL+fwh6FB1aCi+92n2dsAStnY5vLLOHHwwYkfG9EQvOq+9gkersGr4WR933YAqiXBYS/aHmDS657y4bCuAFnYdOnSH74d1GlaHubzPk27jjAMsGPP/tHFzhJ+za/jRi0OqD13f6ac0mZGHqgrgeas/diNbgdDCIRIUmnw7d8kz8PVIkoW802SWZY4EP8kzm5bRXZywpc5Dq25T5pmtoQbYFfA1qzVpiCxDEwoH4MfrzInPgoo52rWoy11UCyRc6FSDsSd8Bd7wdWLf4TsDqFLQePjfvtqtFyZ5xIaK+FDEcbYyBXDMfXhgAViukqHw+9oRwR99ojdCnzlpXx+gc8xF+gfTeLvmN9Fe+eMGv2JkE5dlWwGq7UafBddYn0HgUFttj5n/H/SHKIMP0s7u82pRNu6hu392OwOAKy799zLYUiHGr/FKOLCSFLmYRmhGRu/T/dCaAKMzx+D6B3Svwk9jOzTmrJJs7Fktz/2zBS3HbDLvUuKqMKdXq6JwsV3n/gLYGHsitlSo2ATYEQ7zyblUP+k2nSkabHDrrhTn183jn7aYZPOaZN3d6I/XLadHzPgrYFcwlT8KGdLzwBed1yiG8KM1Hs89NcMSK2iWEaVnvVZpceKuiHMPl8zsg8e2QuAMzNmE8QKEcUpaaSLTnobENodeitRLQZfOR3HdH6j+R+P7U7zfSZFKk1q02HPA7oeIoe2E+FbEucKdI3ymzEIB/w/KxVrWXChuTuA1OWWEXq+w0h5NApYvDEes25IE+KaJHI25VwUdpM33KMMgfmnDO/lmovrFY3ml1TehRToLsMEf1BipBgtRiY4K3dJS55bEksSwbma8NqLD3LSHDBcuBm4ovCw0OU5ScuPlz/JnJ7Slfsle/T8YEpcjeHiz9BPLuQg==
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
Reviewed-by: Waiman Long <longman@redhat.com>
---
 include/linux/kthread.h  |  1 +
 kernel/cgroup/cpuset.c   |  5 ++---
 kernel/kthread.c         | 41 ++++++++++++++++++++++++++++++----------
 kernel/sched/isolation.c |  3 +++
 4 files changed, 37 insertions(+), 13 deletions(-)

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
index 801694de82a3..9a8292b7c7f1 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1208,11 +1208,10 @@ void cpuset_update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
 
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
index 968fa5868d21..03008154249c 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -891,14 +891,7 @@ int kthread_affine_preferred(struct task_struct *p, const struct cpumask *mask)
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
@@ -924,7 +917,8 @@ static int kthreads_online_cpu(unsigned int cpu)
 		/*
 		 * Unbound kthreads without preferred affinity are already affine
 		 * to housekeeping, whether those CPUs are online or not. So no need
-		 * to handle newly online CPUs for them.
+		 * to handle newly online CPUs for them. However housekeeping changes
+		 * have to be applied.
 		 *
 		 * But kthreads with a preferred affinity or node are different:
 		 * if none of their preferred CPUs are online and part of
@@ -932,7 +926,7 @@ static int kthreads_online_cpu(unsigned int cpu)
 		 * But as soon as one of their preferred CPU becomes online, they must
 		 * be affine to them.
 		 */
-		if (k->preferred_affinity || k->node != NUMA_NO_NODE) {
+		if (force || k->preferred_affinity || k->node != NUMA_NO_NODE) {
 			kthread_fetch_affinity(k, affinity);
 			set_cpus_allowed_ptr(k->task, affinity);
 		}
@@ -943,6 +937,33 @@ static int kthreads_online_cpu(unsigned int cpu)
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
index a30d19b641f7..3b725d39c06e 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -156,6 +156,9 @@ int housekeeping_update(struct cpumask *isol_mask)
 	err = tmigr_isolated_exclude_cpumask(isol_mask);
 	WARN_ON_ONCE(err < 0);
 
+	err = kthreads_update_housekeeping();
+	WARN_ON_ONCE(err < 0);
+
 	kfree(old);
 
 	return 0;
-- 
2.51.1


