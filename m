Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 746AFEEEC1C
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:16:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB4DB6B00B3; Thu,  1 Jan 2026 17:16:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D88926B00B5; Thu,  1 Jan 2026 17:16:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C19CB6B00B6; Thu,  1 Jan 2026 17:16:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B0D116B00B3
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:16:44 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 78ED413CCD0
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:16:44 +0000 (UTC)
X-FDA: 84284805528.19.833B711
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id B3406180013
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:16:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RlhVF70R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305802; a=rsa-sha256;
	cv=none;
	b=1Q1sW9LG5EziIm1ypSvZ2myp/P5mwYpvXaBvd/1HCD8vKtbaZcYHgLFqqHuxQ0jl6IQWSa
	pK+Eu5n51ACAz1pdbvBE4GV2s3ma0hgt8a/V6GjAht0OVzES5UXVwN3nUP5N0IxDZBWpPc
	Dxgr25rQKS035eDSuc9wZ+zKov7rWqg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RlhVF70R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZmHTkLAl+4L+IIrew62ITGYy9Ta39yFIFvI2Pf8igDo=;
	b=MvY9JIO5L7L2//7FDKvbJwEuxu+Xsdl+9elNeCU9F82WmNSpyiqKwRXgfgmdTzlUUMyClG
	HqdXKWb28Xu3p/e2X0lXpU4q0hWrgWuWE3tVazbg3lMroEM+M8dmuUJeJ4+HKSVgkaY471
	6HlsFhWkSSrUNRi69LPfOUgqy9MQM/Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AEFE440600;
	Thu,  1 Jan 2026 22:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2E4C4CEF7;
	Thu,  1 Jan 2026 22:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305801;
	bh=tu0Lky1m6SezXDNrHXq/nqZLGO2PMXmZz7CmrPNyvdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RlhVF70R2AS65IRO8RII+UUUzNJvMlGQuAXpStDftU6+lQxMvG6CvCo0T4ebR1GHD
	 KlemMADSBO0tvUv0JMxOQi7RwC2e5e9qOd+wDiuvFMg/edsouocn8bnuJoESu1XhRh
	 QuXEEBx8UVESHmdRJLs0dX2OXFAV2XWAoFGqHwHDWsKOJg9aibmeBgVYXX0v6lMSvB
	 +HPmgBG6Gck9OZ7A0k1ClGdpKiq0hYFF4Y8QBbkBJBvCp9I5cerain9DStAsMVmlPT
	 rd7kxh18ZUP43Z72fmFx+NnjMAUkUDL3bNYP7U4ceR5rMhiU1AMUNbQkirgphi0P3e
	 XtpkPNO/7faLQ==
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
Subject: [PATCH 18/33] cpuset: Propagate cpuset isolation update to workqueue through housekeeping
Date: Thu,  1 Jan 2026 23:13:43 +0100
Message-ID: <20260101221359.22298-19-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B3406180013
X-Stat-Signature: 1k9om88cqj6e9iqmwsfmk4zgcna16qz8
X-Rspam-User: 
X-HE-Tag: 1767305802-933564
X-HE-Meta: U2FsdGVkX1/JnRrlNu0R7gE0G62yxAza99oT47r9rXcsbC2C7fmL2Xw6Xl2sGrjA6Q3lWxToIVUBw65TGlz+S0El6RLBNVaQLHkxu2HyPgUqYe05FPVAMkr17JvLzg3mvqaXhIhqqnF4AxN/Q93PAePEhcoD/k2ISOhnCeu2wlcEud4OLNtr2oMfEntbODa9vVimymcEf+mepj+s/uvXLUFsN2PcmIzdj4dbJSzT/WHpXkZMDuNN1OIS7KLQLgLd9JaeWkessEwT1KWdMzbB2VdzdupsJW48kE2RnZJHUbtR1Rup9OvvsRi2eh+XjVQ1cm0BgNTFAFG98oJ8g0xYuPusVEy/S+Sh0zWjLS/e8gQ645oYZHFXTHK5o8gOiUe69qKaHeWWMSzEPjMQ2zlA/71n0qOdLs9+fYv357pcJcL2/lSp2zx11tSA4dEUwhSA8xRXe0vMdGMbvrt5ZbIkBK18fcmsNPG7aeqtEPLUySXt5V3RsyM8HxUJ+QfiQu8ATHhlcp9G96n80rjyWBG81NM/Kq+0Qq9eXYryE6L0FPdQQQS3HU6IYm/ox0bkMbInRpw/GlVktuUV/xRJKNSM/rxv15Wpb62YKHyTUkLgQ7DsdBCbtEZRoUEkLpKYD1ASyMcbidXVvCSQMzRUj0l79tik9boQEFs5WmeDwry3+WlgEtKOt1w9NPgb/zilvvnvrSkoCjE3+eEl/6hSHk6YVEaodN5EC4ATR7Z+ltEAl9R3AkIzbUxIfgdWW7g5B4n0eGT45AxrSH7jxehi5pfp/r9X4GiqhP8+CDnheCAHLJ1x5Fisbx8mPUzRsIBOQRcKF0SHjoGpfNQajjkFipnoPhVf4QTgH2xT2zMIMI9k2kD8qAckqs0AkJ49eJPRMdPBVDYgjIm2JaNioXARJrZ5sxRBR4Gwoj6iDMu81iJLT+/GK8jrWzD8X3eaiuK8UCExuWHGKZEXJnMRgWm/BGt
 vc/7KUBL
 CkNLhFS6WeJyrsW5vbFIMHbkBX9AyM5cqD0a7uvfm4mAJzaQnSc2P5rvEl3HJxfdv/7eJbonG7x9RTrWha0kroecnV2vu9LgBGwSO6q82KmxUrp4yM7untWYJ8sUMUbrkdcrKwKT8H2UQowCY73AEjxMRGwqbZh6UnPpcOMTykXMU63Nzblb0D7ldTog+9DHN74AmMTCHfmU87x5eRMn8+jH4cRbm1e3qAENixLOhnn2bqKG2o4SLHOWOkPnYEOSuqh8GFUiyB1QmzHw4CzyBlhwC6By+bkd9xuCj
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
Reviewed-by: Waiman Long <longman@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |  2 +-
 init/Kconfig              |  1 +
 kernel/cgroup/cpuset.c    |  9 +++------
 kernel/sched/isolation.c  |  3 +++
 kernel/workqueue.c        | 17 ++++++++++-------
 5 files changed, 18 insertions(+), 14 deletions(-)

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
index fa79feb8fe57..518830fb812f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1254,6 +1254,7 @@ config CPUSETS
 	bool "Cpuset controller"
 	depends on SMP
 	select UNION_FIND
+	select CPU_ISOLATION
 	help
 	  This option will let you create and manage CPUSETs which
 	  allow dynamically partitioning a system into sets of CPUs and
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 1c0475e384dc..ea9925652d99 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1484,15 +1484,12 @@ static void update_isolation_cpumasks(void)
 
 	lockdep_assert_cpus_held();
 
-	ret = workqueue_unbound_exclude_cpumask(isolated_cpus);
-	WARN_ON_ONCE(ret < 0);
-
-	ret = tmigr_isolated_exclude_cpumask(isolated_cpus);
-	WARN_ON_ONCE(ret < 0);
-
 	ret = housekeeping_update(isolated_cpus);
 	WARN_ON_ONCE(ret < 0);
 
+	ret = tmigr_isolated_exclude_cpumask(isolated_cpus);
+	WARN_ON_ONCE(ret < 0);
+
 	isolated_cpus_updating = false;
 }
 
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 5239f556745d..2f4f184cef2b 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -121,6 +121,7 @@ EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
 int housekeeping_update(struct cpumask *isol_mask)
 {
 	struct cpumask *trial, *old = NULL;
+	int err;
 
 	trial = kmalloc(cpumask_size(), GFP_KERNEL);
 	if (!trial)
@@ -146,6 +147,8 @@ int housekeeping_update(struct cpumask *isol_mask)
 	pci_probe_flush_workqueue();
 	mem_cgroup_flush_workqueue();
 	vmstat_flush_workqueue();
+	err = workqueue_unbound_housekeeping_update(housekeeping_cpumask(HK_TYPE_DOMAIN));
+	WARN_ON_ONCE(err < 0);
 
 	kfree(old);
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 253311af47c6..eb5660013222 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -6959,13 +6959,16 @@ static int workqueue_apply_unbound_cpumask(const cpumask_var_t unbound_cpumask)
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
@@ -6981,14 +6984,14 @@ int workqueue_unbound_exclude_cpumask(cpumask_var_t exclude_cpumask)
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
2.51.1


