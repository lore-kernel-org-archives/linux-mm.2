Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7651E75458
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41C396B00B5; Wed, 24 Dec 2025 08:48:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D0596B00B7; Wed, 24 Dec 2025 08:48:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DCFC6B00B8; Wed, 24 Dec 2025 08:48:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A69D6B00B5
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:48:09 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D0720578A6
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:48:08 +0000 (UTC)
X-FDA: 84254493456.11.A3137CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3BE4718000D
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:48:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pr5HuSZo;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584087; a=rsa-sha256;
	cv=none;
	b=YZatCNQI15z9rMYrJkfnXsuqzvGPtAv22aK7ZQfiGaZ5HEkePMkTg+nQ+Vk+uxXLx6W+qM
	3pfafqlicAhLShKObPilAcdZDDymiKWxcl3n95fZYc7juNPxrqzcF00Twt9u6dR3CTA+XC
	/zhowQzbaWoArmwKIkJYSw4lhwxAv5w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pr5HuSZo;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SvnqVmavG5/RikmrNMgBr8VUTA1+YXwnGLYvwZ+ysL8=;
	b=plWXcsS+MGYEaqzWDtIejJ20aixcB864ZXTCHgn1GX8Jb1xcZDdGZ6DrfSYC3vgV8QTqP5
	LD2rQViFXu88AdT2XD31Pa6Wm4SMlBVR3/MckAHP9RvZem0+M5lLACjQvOqELw0YMoasnT
	GwMcnhVbFMBwLDTls2aWRMuY7/wrQC8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9277B600AD;
	Wed, 24 Dec 2025 13:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AE3C116D0;
	Wed, 24 Dec 2025 13:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584086;
	bh=jRCoFlzyfuayI8vSy1m9CD6aytBJoPvIXpyfG/mhfAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pr5HuSZoG4USHnZLUx/JbPQALrUvUK8KLMlPNf3RNPQYBvUJyXuFWCvoeAdFUmGpk
	 onTs1ggtsk7Hr7pWy0UvYqkDHALzxswmO/L9npavYTPzNxSRKxvVoJU50FP8347aId
	 TuQAnWWA/lyLwjkVP7Cb3KHK87AXK8XdzT+fw7RAK1ldpSZloT0yfgXXX6wu1PAxnH
	 jlplLKYFcQvjUXzRIrk3OXA7JoOF1BG0lv98MLCIU7CGkqU1mzB4cx276Zebo49kYx
	 7ZWe6czGA1zxX+kT3mZb37CAW9O4zg9Ny44j7Sd4YWc7N7PiERQoabpsgMpty4Uvs3
	 Ted2C+CATIKCg==
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
Date: Wed, 24 Dec 2025 14:45:05 +0100
Message-ID: <20251224134520.33231-19-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3BE4718000D
X-Rspamd-Server: rspam04
X-Stat-Signature: nsau4papkfeych76nmtexzr9kku1n1d1
X-HE-Tag: 1766584087-216280
X-HE-Meta: U2FsdGVkX1/EguMdKdRep3ptZaoDmdJZ5eemq+HD2rWhdutVNjEs3DJTNBpsXkxbQpROjTAiPX9zAscZ1mEhEHMLMDwNUoqZeVCyFXkl683XyvR2PC80qI5vuNM/+z+lL3UxWP8iW82nofU95Df+U8OQkw1OI/dO3cptWxS4g0Nm7ep2omG8sUe2pPOYPVIvnebSEjugcM3plhWpqOgZxGkRHTIiYHr5dXegBW9Xb/GO79jLDrvmFzfMJPTt+7XDnnh6ZlNeikb8vMMaHUyuPMjMBfBu8CdC/OIOFoZrbEyfbliZiykqbb/F6KUJTvg0mYh2NXV7eWOA+lYMETS/FOIG7oeVx+R9MbjgGrmSht5G1BzIsWNqkwUbVqC0DRbvQuVkJZltIHsINz4lguplC0UztHaE7/KyeFBzjikrF9GNGGEZxHsyudyKX8K1tZmykS3yPpMzPNxcVX7GfTlFEyvA7Ym/S0PwbDZ1/eLlP/3SezR6CNt8GotiLznNVklInLrCKhBTsVnwzLClVwBSGzoxVhq4N0PQTLDFNv196qODX8BPLcvwvjJDKgrT5162j22YTlfWS+rkgCAuYDpI1v9vqEbxKDt5oQlgpMdaNLq1wzq33IDhO0qPhqZMoZdBO5zjLYYF0S8t4vAeWKnS3eyAMFijixZFTX6Q6gElUGwW64lGBzsG2IT3oUy73i0FRvKWChTHZmWinj8rlyfYNhT0ZcH14ZgMLF4rARYqxYc2dMYwvcAc9y1jiSxAp8iJJiTNgL+W9q4AVLbohcZcKlMQ06orlSJKSqkkLMjVuzpdBzV2aV8bjFLaOtldT1Y9sRKIoJnNBVu8cBSfEpuPC4zCoQRTWwKAQsimYDWMaH/hHfhIce6oNuM6BHbommKSHbn12wiDT/5iSx7mDS5Z11EL1qRRyyoJ/yA1eN4r+CaAnC6jBXcO40zqsmqv19VgZB836j/i4mLbZg2AkYd
 NtcPm8YZ
 07sou6sqWVK5upEuqaXmgKvpD+o2A1a+d0WZIaULKJEDZVutZ7I9mWuTaPifpY2tEAA5dyTm674k6Lfsc3t4xa0mSHaWjxcjWpZJYKVSVMi2Hkja7jRdD60TD93b8KK+TGDrl87hqYXVpxgyt0CA2mE5ZCYDZvbb3Aa9gKta2GRxceq/qb3BUkLYKVEyfNIxr+tmjguEpaxdoI3pQWXEfxgFJlcTXIWbed0t57VVMm6KgV7WcB916u3FJ7vUxeoaU2b8ZG/fVnCc6f44=
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
 kernel/cgroup/cpuset.c    |  9 +++------
 kernel/sched/isolation.c  |  4 +++-
 kernel/workqueue.c        | 17 ++++++++++-------
 5 files changed, 18 insertions(+), 15 deletions(-)

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
index e13e32491ebf..a492d23dd622 100644
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
 	ret = housekeeping_update(isolated_cpus, HK_TYPE_DOMAIN);
 	WARN_ON_ONCE(ret < 0);
 
+	ret = tmigr_isolated_exclude_cpumask(isolated_cpus);
+	WARN_ON_ONCE(ret < 0);
+
 	isolated_cpus_updating = false;
 }
 
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 7dbe037ea8df..d224bca299ed 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -121,6 +121,7 @@ EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
 int housekeeping_update(struct cpumask *isol_mask, enum hk_type type)
 {
 	struct cpumask *trial, *old = NULL;
+	int err;
 
 	if (type != HK_TYPE_DOMAIN)
 		return -ENOTSUPP;
@@ -149,10 +150,11 @@ int housekeeping_update(struct cpumask *isol_mask, enum hk_type type)
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


