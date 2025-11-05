Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A955CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 795C38E0021; Wed,  5 Nov 2025 16:06:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76CB48E0002; Wed,  5 Nov 2025 16:06:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 683278E0021; Wed,  5 Nov 2025 16:06:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5676C8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:06:19 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2524413B070
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:06:19 +0000 (UTC)
X-FDA: 84077786478.27.6AC7684
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id A6B76A0012
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:06:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MyltMr5p;
	spf=pass (imf25.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HUC84cln5g3UfUxMpPaBLVyjM6j43/I9v2Us/cVkk+M=;
	b=yLPtsstokvjPW2uhlviMTxKiXQwLl+G0A0kSalxY22D5d4s1Q3/U5hra48Cgtm4EXZ14CI
	AcLRQpWijpqHtTcYBMjJTwdj6xrdA/ekenleB6rqqTMEuJGnVLER0cEcfgGGCUCIMwZJHi
	xvMSyAcSOaRMirwrVE3ZKKA6AB57a6w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MyltMr5p;
	spf=pass (imf25.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376777; a=rsa-sha256;
	cv=none;
	b=jz5P9bxpUgUgxG1Cjjxn3TsjHhlgbjIzg04+myNCAzOe5yDkJtWI+pjanc+sf810ydEt/l
	yIaOmBizVaaeShG7KrAvT9l0GY8VYNTvrFdur+wvFLZsl9SEwXR7PXK6fcbjnsSXZVbMfC
	pgBiblKKG3fGq+oVwPKwTxsQO3WwyxA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 21A1160222;
	Wed,  5 Nov 2025 21:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54997C4CEF5;
	Wed,  5 Nov 2025 21:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376776;
	bh=loTWvdxqHDkI7ziyDaTEdsHDniRN0/Kv9B5PIMcBLqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MyltMr5ptM7YrDB923RK+oyskliOi3MIym+9tnhn1S5Pe8fXJ1sRM75av96ENfY/u
	 zkPQYYHQReS8Sz5vZW1GdKfBgZ76lvDmGdqTpZgF3Q4lPGx5tAjEtf+dSQVsE2eMJz
	 1R03mSwTv62GxYfVA5MvFn6Zp+Dkz7rh3Iq+RAcrjnAF8pycT9cQ0myeZviFgjNvbS
	 h0zbHmKeMJXCU5x6R0+D0nsHQAZnfPNx3mgl/GhsK+SLXwKEpLtYD4wjqst1Z9wQow
	 aeECMugZnWI1usI2r9jgeqGy3wXuLDFeXNQ/DZCS8h8deCdZ4ef9BfmVZH7lPx9scB
	 geOwsWPdq8H5Q==
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
Subject: [PATCH 17/31] cpuset: Propagate cpuset isolation update to workqueue through housekeeping
Date: Wed,  5 Nov 2025 22:03:33 +0100
Message-ID: <20251105210348.35256-18-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A6B76A0012
X-Stat-Signature: knpihyrcmj34e8a5c4ch33g396awe8ad
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762376777-797813
X-HE-Meta: U2FsdGVkX1/d9O7ZlLDoL/uEiixbXUR9CIsVGLuCPZatm/3eP8Qq50GWbobjGSLwbxL5MLN0Lv9KxzohVQTAu5m+t4Xcx5C/7Kf9jszP/oEzCHAz50A9IpBXT7jrcBic6UPXtMjHvleYtpv4Wi7wSsje0zzTafeYkIm80Bf+FEX2bdjGpumc2QM1YJHpFpxOH91yyQE3rnOV2a62NTB8jkme1CptHvzHfEBpLroKaeHEyoERF8h0GNwvqoggUmjKfXF177X3GcPLWoZgCk8AICH3puRPF2JAnOuTT9E7KadjQ+AGpxx+PTitdGTjrHxrBYU66bF6zgeaRS0n2g318qHejbvrf1ktgWbEbT79ucosbuBfsaHc0bW4/egPGMYQQB62xY+3dXQMFYOMitnYXAphq3KcKWkAQQxcZw/6kRSYVzRRxMsMmKw8w6ec79QixKKWl6b5BUjEBze5mBnQuyAcfr4YWqTenPzghlqRQegFp0104d+uID7u5K7AzrPvusxs4T0cZq5v4YSx/tIILPJ/TZv04yfGW/XdB7IICJu8UkLd4qXwEs7FnawE9FVgByJBF7GeZhQi2LjEffuftdSTxY3UFOg/kLabUCR9MyvtAW9Klq7KHtIdUfj6GrdsLExvCgPJVnrWbU3GwnIoxGXjg12bl1pv6VFKtOr3NP64lVWz59cY9v9XkQEMblrdXLQawlOAjHOyCX5eBQlkgoZ58MyyKPy1SPt7SIr+8A0XDvtqvdD679YLHVj999xU190NDHxXSOPxLNZG/FcQoORlRLtZHaZp6iZsZ9QXDP339b6W1kA9UWf9OxlAOpA63yC6d6hae2xZKWqzQG5WHnk3rOAIb/MYSsbPgxFjYq9Z3J7HNhFp1fW6uQzknsJKCUpwCxWkyIM+Uq5NiwFmP/agTWqPZhTEVYhsG1j8uVc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Until now, cpuset would propagate isolated partition changes to
workqueues so that unbound workers get properly reaffined.

Since housekeeping now centralizes, synchronize and propagates isolation
cpumask changes, perform the work from that subsystem for consolidation
and consistency purposes.

For simplification purpose, the target function is adapted to take the
new housekeeping mask instead of the isolated mask.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/linux/workqueue.h |  2 +-
 init/Kconfig              |  1 +
 kernel/cgroup/cpuset.c    | 14 ++++++--------
 kernel/sched/isolation.c  |  4 +++-
 kernel/workqueue.c        | 17 ++++++++++-------
 5 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index dabc351cc127..a4749f56398f 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -588,7 +588,7 @@ struct workqueue_attrs *alloc_workqueue_attrs_noprof(void);
 void free_workqueue_attrs(struct workqueue_attrs *attrs);
 int apply_workqueue_attrs(struct workqueue_struct *wq,
 			  const struct workqueue_attrs *attrs);
-extern int workqueue_unbound_exclude_cpumask(cpumask_var_t cpumask);
+extern int workqueue_unbound_housekeeping_update(const struct cpumask *hk);
 
 extern bool queue_work_on(int cpu, struct workqueue_struct *wq,
 			struct work_struct *work);
diff --git a/init/Kconfig b/init/Kconfig
index cab3ad28ca49..a1b3a3b66bfc 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1247,6 +1247,7 @@ config CPUSETS
 	bool "Cpuset controller"
 	depends on SMP
 	select UNION_FIND
+	select CPU_ISOLATION
 	help
 	  This option will let you create and manage CPUSETs which
 	  allow dynamically partitioning a system into sets of CPUs and
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b04a4242f2fa..ea102e4695a5 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1392,7 +1392,7 @@ static bool partition_xcpus_del(int old_prs, struct cpuset *parent,
 	return isolcpus_updated;
 }
 
-static void update_unbound_workqueue_cpumask(bool isolcpus_updated)
+static void update_housekeeping_cpumask(bool isolcpus_updated)
 {
 	int ret;
 
@@ -1401,8 +1401,6 @@ static void update_unbound_workqueue_cpumask(bool isolcpus_updated)
 	if (!isolcpus_updated)
 		return;
 
-	ret = workqueue_unbound_exclude_cpumask(isolated_cpus);
-	WARN_ON_ONCE(ret < 0);
 	ret = housekeeping_update(isolated_cpus, HK_TYPE_DOMAIN);
 	WARN_ON_ONCE(ret < 0);
 }
@@ -1558,7 +1556,7 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
 	list_add(&cs->remote_sibling, &remote_children);
 	cpumask_copy(cs->effective_xcpus, tmp->new_cpus);
 	spin_unlock_irq(&callback_lock);
-	update_unbound_workqueue_cpumask(isolcpus_updated);
+	update_housekeeping_cpumask(isolcpus_updated);
 	cpuset_force_rebuild();
 	cs->prs_err = 0;
 
@@ -1599,7 +1597,7 @@ static void remote_partition_disable(struct cpuset *cs, struct tmpmasks *tmp)
 	compute_excpus(cs, cs->effective_xcpus);
 	reset_partition_data(cs);
 	spin_unlock_irq(&callback_lock);
-	update_unbound_workqueue_cpumask(isolcpus_updated);
+	update_housekeeping_cpumask(isolcpus_updated);
 	cpuset_force_rebuild();
 
 	/*
@@ -1668,7 +1666,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 	if (xcpus)
 		cpumask_copy(cs->exclusive_cpus, xcpus);
 	spin_unlock_irq(&callback_lock);
-	update_unbound_workqueue_cpumask(isolcpus_updated);
+	update_housekeeping_cpumask(isolcpus_updated);
 	if (adding || deleting)
 		cpuset_force_rebuild();
 
@@ -2027,7 +2025,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		WARN_ON_ONCE(parent->nr_subparts < 0);
 	}
 	spin_unlock_irq(&callback_lock);
-	update_unbound_workqueue_cpumask(isolcpus_updated);
+	update_housekeeping_cpumask(isolcpus_updated);
 
 	if ((old_prs != new_prs) && (cmd == partcmd_update))
 		update_partition_exclusive_flag(cs, new_prs);
@@ -3047,7 +3045,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	else if (isolcpus_updated)
 		isolated_cpus_update(old_prs, new_prs, cs->effective_xcpus);
 	spin_unlock_irq(&callback_lock);
-	update_unbound_workqueue_cpumask(isolcpus_updated);
+	update_housekeeping_cpumask(isolcpus_updated);
 
 	/* Force update if switching back to member & update effective_xcpus */
 	update_cpumasks_hier(cs, &tmpmask, !new_prs);
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 303cc3419ecb..bad5fdf7e991 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -121,6 +121,7 @@ EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
 int housekeeping_update(struct cpumask *mask, enum hk_type type)
 {
 	struct cpumask *trial, *old = NULL;
+	int err;
 
 	if (type != HK_TYPE_DOMAIN)
 		return -ENOTSUPP;
@@ -149,10 +150,11 @@ int housekeeping_update(struct cpumask *mask, enum hk_type type)
 	pci_probe_flush_workqueue();
 	mem_cgroup_flush_workqueue();
 	vmstat_flush_workqueue();
+	err = workqueue_unbound_housekeeping_update(housekeeping_cpumask(type));
 
 	kfree(old);
 
-	return 0;
+	return err;
 }
 
 void __init housekeeping_init(void)
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 45320e27a16c..32a436b76137 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -6945,13 +6945,16 @@ static int workqueue_apply_unbound_cpumask(const cpumask_var_t unbound_cpumask)
 }
 
 /**
- * workqueue_unbound_exclude_cpumask - Exclude given CPUs from unbound cpumask
- * @exclude_cpumask: the cpumask to be excluded from wq_unbound_cpumask
+ * workqueue_unbound_housekeeping_update - Propagate housekeeping cpumask update
+ * @hk: the new housekeeping cpumask
  *
- * This function can be called from cpuset code to provide a set of isolated
- * CPUs that should be excluded from wq_unbound_cpumask.
+ * Update the unbound workqueue cpumask on top of the new housekeeping cpumask such
+ * that the effective unbound affinity is the intersection of the new housekeeping
+ * with the requested affinity set via nohz_full=/isolcpus= or sysfs.
+ *
+ * Return: 0 on success and -errno on failure.
  */
-int workqueue_unbound_exclude_cpumask(cpumask_var_t exclude_cpumask)
+int workqueue_unbound_housekeeping_update(const struct cpumask *hk)
 {
 	cpumask_var_t cpumask;
 	int ret = 0;
@@ -6967,14 +6970,14 @@ int workqueue_unbound_exclude_cpumask(cpumask_var_t exclude_cpumask)
 	 * (HK_TYPE_WQ ∩ HK_TYPE_DOMAIN) house keeping mask and rewritten
 	 * by any subsequent write to workqueue/cpumask sysfs file.
 	 */
-	if (!cpumask_andnot(cpumask, wq_requested_unbound_cpumask, exclude_cpumask))
+	if (!cpumask_and(cpumask, wq_requested_unbound_cpumask, hk))
 		cpumask_copy(cpumask, wq_requested_unbound_cpumask);
 	if (!cpumask_equal(cpumask, wq_unbound_cpumask))
 		ret = workqueue_apply_unbound_cpumask(cpumask);
 
 	/* Save the current isolated cpumask & export it via sysfs */
 	if (!ret)
-		cpumask_copy(wq_isolated_cpumask, exclude_cpumask);
+		cpumask_andnot(wq_isolated_cpumask, cpu_possible_mask, hk);
 
 	mutex_unlock(&wq_pool_mutex);
 	free_cpumask_var(cpumask);
-- 
2.51.0


