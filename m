Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DC04CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC38E8E007C; Mon, 13 Oct 2025 16:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9AFA8E0036; Mon, 13 Oct 2025 16:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB0CB8E007C; Mon, 13 Oct 2025 16:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8D628E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:34:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 779CC59B49
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:34:14 +0000 (UTC)
X-FDA: 83994243228.05.29CD0AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id D9D7E2000E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:34:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eouwi2Id;
	spf=pass (imf03.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4O9vPgC640EUx5IYlYxCDv6aqHs8TWRGOXWlhapg1Mo=;
	b=E+LnlABrTI+q7XlaOVpTnx1ga7FE8f9Qm0o0WnH7kYSZZqPhVZ4b5uEUyj+CJZiJFaLtcy
	Oo0EA50zOLe/2h16XoYNdLtCP0nDJ16PBcNlfVLNffzibHTLSc1GNsU3PReRu9EO4YLtmt
	GmivhKABlrbKGaVOUuiwIri4YVKanVQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eouwi2Id;
	spf=pass (imf03.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387652; a=rsa-sha256;
	cv=none;
	b=JYU96Kp/l2EZxlOSZSAYxlOye5F00uoamPhfd8THtRF6wLde9rQBdaY34nV1jRCVNNdppg
	hlG51ZrfvFlHau/ZbwRoO7oG21gehekpmecp7VIzNTnE04DZI0aN6BsDSzbRI8YTjM5wi+
	vHYj1gELIVSc0TU79BWJlFZS6tuRQWY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 51890604A3;
	Mon, 13 Oct 2025 20:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047BFC4CEF8;
	Mon, 13 Oct 2025 20:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387652;
	bh=6PZmrWuVNCdSpSok/fV5uDLteoMQFeo3tQJfHyrWZCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eouwi2IdHMbI79ILuKMFjc8eDXQfTMCt2ZSfrPfZVQHhNsHob9pj7A64ga3QUs9nX
	 tT8/ULtN1jQ4BnsOlyCeVIsB/dhwfIKzMuXrmaphsaoIaaPlDNwftnBMI3u2ZVcKDx
	 M+2Nfk5PVmBgIEXRQY9pWgl9+Dm5RsetcJLa+S4r0BQoq6Nk8QspQpnQyddiwSPiOh
	 zTuC2D06Xtd/GOlJOORMNEdVH+UR3Ujkkpxk+2FbvwGlXxcES16JII3whSzp+S09wy
	 jQ8FKBAtdDMhDbcEmpnX7vqnHmjpFVLE82+sZ12RzQjftqsOQFT4CwNDPgxqtB/KhU
	 M65CSIgmyErHw==
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
Subject: [PATCH 17/33] cpuset: Propagate cpuset isolation update to workqueue through housekeeping
Date: Mon, 13 Oct 2025 22:31:30 +0200
Message-ID: <20251013203146.10162-18-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D9D7E2000E
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 8rbfxx97mo1fwf3753w91w6syb5bj7i9
X-HE-Tag: 1760387652-577859
X-HE-Meta: U2FsdGVkX19mDRfCy34qnLtehoWcGRMpNCE4jbMZoMnuxqjH+pLDEGQXNbgB/cuju/6P4mx6tsvYCbOUvUO2in1YEAb0F0xHvJ5pmXzRRVop0vdiEu8mIIwQcqaLFWswAdqObVOnNGmYt23GwaKVGjji6YNWyD5DgIxJM5b01RzKcDpGNfE1f5K6rTDUfGnHG7XwO7llrQJPttMCxQYkrSUEWJ2wIhoRyFDOWFR5n7H/EGsS/pmyzAre+gbN55SgmIXOzpAch6Zyp6sPjYYnmmmFXW3sJcLGD7q1Mi7F12bdmEzaOVftA3pnVDuW6mBg7KPb9uLkBPUUWw+ckw3uRYi5Ok5A+qO8Vgcn7fw8floY4GWf3zLNAIsi4eMfU6CcLtX1/xBtocG0FKafE6lqrzzuIBSZAj24bwQQvfWaxuiRy4VdcL5Rhno/3H3LYzHQ7EN58X5nAbzGs+fc+8vwW3u4+CeJqAve881BalJ4cAI2YCEb1YxyIrqLG6QlK5ofufJqdigKdJiZqV6gYK09d72gbDSSeFyFgumIPkQXdzOGP7uCoHkBR+u5G/FWLItaHHUEDiKt6pNES+jojVA8bi7MVQHcKh7veexLBRqTAtuftsSPau9ipfRyOr/37T5gj5tbszblJeueV47kCbDkw3UgmAFOnpwQgaijP5lltQ4XNLJjFg9GVqOOJ9Ba5u9dw/4+zEO2FbpaWPDWeRMGSHNBj6oHrSfNg+DbCXT2WiotFtO0YBVk5q1mEtrhZPKL/s3sp0rmXP5i35+rxYNRu55dlDt0JeVsvZ7DjyfGkPP/bg+CTr4GmgoZ4k75ONz60loUBn8mg5/VLWDdB9ygOZsdkF3a/AAtApftMajSIhkWTP5JyL3xGJZyt3A82nHQkQKGLfE+ny9HfMYQgPgaC2/eg889EJhIUBmHToHHRt/vm90c3B4NwSSjER6XTbg/iYSEcMguZUY9WrInpAl
 MO6W7AM7
 ue1lxEVNCzd/NVuO7eHOQ7K+eIl1YkvArm0ByoVu+ylgHdy3aJBgqjwYhivcQV8qujDl+65MViAqorIeznE45/ee0C250f5Tvi8KepP4co7HlQpD2kYJp6f8h+aJBHIwCQ0G7LsKMrcYDRyrzY+a2ALJiyecShkMZq0a9EXRMcdtICJ4S/yrcamE7d7ODSWmTGg1pJV50+5/ZI7jODieAQRlNc7/iXFh8cQCR8tHJjhuAFgyZ6EFaiW02M95SJ43yH5wGEKda6VSxhYZwJE0PWNm0XZ3yWaaCh4bBlz3NwMOmZmo=
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
index b1eea5440484..691f045ab758 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -120,6 +120,7 @@ EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
 int housekeeping_update(struct cpumask *mask, enum hk_type type)
 {
 	struct cpumask *trial, *old = NULL;
+	int err;
 
 	if (type != HK_TYPE_DOMAIN)
 		return -ENOTSUPP;
@@ -148,10 +149,11 @@ int housekeeping_update(struct cpumask *mask, enum hk_type type)
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


