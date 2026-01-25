Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBD61D7237B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:48:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F3676B00B2; Sun, 25 Jan 2026 17:48:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B4126B00B4; Sun, 25 Jan 2026 17:48:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D4356B00B5; Sun, 25 Jan 2026 17:48:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0AA126B00B2
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:48:21 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C4FA0140118
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:48:20 +0000 (UTC)
X-FDA: 84371976360.21.7BBF82C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2E9F71C0004
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:48:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FXVJDGvG;
	spf=pass (imf21.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=plMeJ+ZstLgo5vQB6Msqpj9xcQgRBq/kQ3jmm3RwUaY=;
	b=eOeRQVqVRUBu56GNTm7VmWnA6Tx0Wsf1C1FC72dHDryG0jR3ZaKJs8VMs89NxMTMl+qq1l
	Rd7Bi3383I3VAxlc0ITDq+Skcnn0WqoGBTyOC9lSNNhBu1LkfnodLXhxZxj+AI22PjLhvA
	PPxZEjK3m++Yp+7TIZ8zQQQyS/ILK8M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FXVJDGvG;
	spf=pass (imf21.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381299; a=rsa-sha256;
	cv=none;
	b=YJO+c7/+DbV5/xSuvRXmGIivvB/ZofnLIztqztsOGMUb+aqYN7fgWbkula1cJuHS1hcT5v
	UXoNVoMVO760AftWP+4hRtLngFmoUH8n7g5U/bVGLBCL+JThaKQu+wNG9VeLZbIBjTGMMG
	J6szHTD3ja/LvuzGlqzq4c0W149jpiE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F6FC6012A;
	Sun, 25 Jan 2026 22:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E931C16AAE;
	Sun, 25 Jan 2026 22:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381298;
	bh=PDoIYHuuiQUu4y1J8hgAkjDfFBft4fHDXLhrlxOrw90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXVJDGvGd90ljUIRHA3Gq+xSNAPYbf5Of7csvzmr6nei4zcJ7mhopJ1z1alkU6Dfp
	 l0WYTDe1bqdAbAwqxkXWftB2h/QrmGaK47ERIpLMpl/XGWMaVeG01EE3V1cO3TJGhS
	 ycvJwK2yTD/h3Z7SN6aPzoayLR27DlQfuE/tsJutjBLeXZcEUkuJsyXWSUknHlc7ng
	 /RWRUd8FUCncSiL1IgasD696UCodzN9XukraV+QyWa2mKQaYlHjfSGb22+eWrZBBZs
	 piSO+onX1DUhkVV3zHKe6dKz2I61vJKBFw27FSgvAUZM0cDrmVaXHWYmGpF86sls9f
	 xf7nNq6/T22aQ==
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
Date: Sun, 25 Jan 2026 23:45:25 +0100
Message-ID: <20260125224541.50226-19-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zpja44o7ci79hbczh31bjq4tipq15fcz
X-Rspamd-Queue-Id: 2E9F71C0004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769381298-595838
X-HE-Meta: U2FsdGVkX188IkdG/i9bOwjTkOgAruozGFaDD1YAorWOz1/Jf93nVSpDYiYUxg1AzHh4xsKlMzB/CdZQuXBzA8a67HuUuZzfMW9S014sQhjuJ+0PdkL9Y1wVopnUkzkfftGH8iqHQxUPPXqjfMH0WXOfK2Aw9N9u2dWASKsQy+FzAB3GDbzfayQEcQy0wLRIw3xA9T/DeqJH6vqc+YYJaHw84X8zty5SelrXwM47A39DcfFO+KLZCW+2YtmQMiI3FCae6XuSh01rFcboOnMALQmz36n0Aa4oBtBt9GsQNxN0MCsNuDGnL2O4WTOgRaxLpHFWDze4+uIjdQR0Q5nG4B8vs6UgN0gZqtbof/qLPJwc1JwKxBFq9O3S1eq0xLC6hqmKGmOBoW8FJIds4GpJ5/YFMH/wS3FQYkEniCjcoo70C7JvQ1Rtx6Wj/fsL/iO43FZNn75prIXNbuGmUpijW/6wnO9f94qA8pjJks6Mp/JNAmVs5JbFN9w3pJFZDm/lVXEPK9vL9wRRoUk2E5KDDFxja8rv49aomPVIZA+qyv7OxNjlcOkKLiD90eqa2uwT0/IWUcCdaLiwrn/+4k00l/2fygAYReTHoMobF4LTdyrauOwdoTIW/b1+wmoZSm7ldTqSPKwWySgugit1LrT2ImH2vCczacPLPt1gRNSPC41z05CXXUD9TYiZVOovTEOfWtWXsKVCO8U9cRnuvn3PoFSYC4Z0iTLYX5DnO1vmDd6rMRnkR40Q3Jcc5BSXrUcVzIQq58SaFoBVXeLZJuBYKnWZX9AMPFtlApcEaO7Nuq1d/Bob3+riftXkz0yFFoCpFT4wQGzo5GHNSqve+D4WqAGXWViwDaEJL+34WDDxVXng2qlatvg4b1iVNU5l3VYvdFJT0xuxyqqMhXDuQVqlUv6dbX4zixZhfWTrykJHe1BOtUjr77AG15G6NLqmpQQxJXb4pHPt/i2pii04afU
 XWyX0knd
 BV9xlPTuFAFgKGAoPiQ6IwaQ4o6Mreq+llhF/OgYlpQhVuBi8/F8hSFQAs1uQ8ey1aYizRKDO/+nrvqqlzU4PiveRUDTgxin9t/eFPMQBR61op1DSjwQmaVfNSTVbOpy0jwua6CsXOeT3k+hrULYx7Dz0ZJgegQPzpMwjSvqE+CSCr0ERzYVam8wmEXH3uYRt6R+jdv7pMtml4IWw4bYXJKZsuBdk67FhWJ47rnR0w7/5Ylg6sI5F1tqEqk4UnXaHuSEp3CBBpAyG8HxJ2ve1ZrL6JwVef67hFCCM1EvTPoyJIVym8eT70ZbC8c1HAedWU2BeLMOTpOZGbWo=
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
index e146e1f34bf9..6309ec5d7b2a 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1482,15 +1482,12 @@ static void update_isolation_cpumasks(void)
 	if (!isolated_cpus_updating)
 		return;
 
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
index 1e4c3154b0a4..5bcb6d760f20 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -121,6 +121,7 @@ EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
 int housekeeping_update(struct cpumask *isol_mask)
 {
 	struct cpumask *trial, *old = NULL;
+	int err;
 
 	lockdep_assert_cpus_held();
 
@@ -148,6 +149,8 @@ int housekeeping_update(struct cpumask *isol_mask)
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


