Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37442D7237B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 988756B00AA; Sun, 25 Jan 2026 17:47:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 952C06B00AC; Sun, 25 Jan 2026 17:47:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85F326B00AD; Sun, 25 Jan 2026 17:47:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 74D746B00AA
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:47:49 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 197A4D32AC
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:47:49 +0000 (UTC)
X-FDA: 84371975058.02.4A92945
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5665920006
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:47:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VFdZRXOu;
	spf=pass (imf03.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Egipe/84fGrjMg016pml32GM9/3YzVVYBny5TS7wn1c=;
	b=KOg/4Q+q57HqAarPR5t+rpsB9PPJRXVSZNS5AMk9p0n9pHrvraJfWE5JpOYjmsHCFJ91Td
	8t0Z6uNUgweQ+CYc7Odjla6J9LJ14as3H9VzJeltJj3qNK889j2EJn9RN+LK6wKGuX7V9M
	LXVQ4k8A3p21nAoACZBvmQGdk8uwoi0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VFdZRXOu;
	spf=pass (imf03.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381267; a=rsa-sha256;
	cv=none;
	b=S05wvlt4JM+SfnnZUpzHU6WMp9Q1q3Sa0Gvv0bnKTxpYJ5ocQa6kcE+Gyg6YwH2GaPRNo0
	1EpJPFzjieSNer3i/vjk+WUjtZBW1jBtMx2ZBisEL9L9FcASMWr5QjS8d9I0RMtSQLabkH
	U+PIjBO/YTQor3M2VYZKCh3Y+nqFOUQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 859CE40222;
	Sun, 25 Jan 2026 22:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEEFFC4CEF1;
	Sun, 25 Jan 2026 22:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381266;
	bh=Qqaq4aoHo6a9PFuRdP+ZSEkR7bC/Dwwr9j36rrRCXWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VFdZRXOuNskCqzkyJTn9woxy8lPuAJFb1axhe5T+7oO0PrH9tmfL11t1II0sm4SiO
	 w5kUjkol7puwqNVbEmhXa26wvAAIi5Wvm4VYVF4ABPSjoCdfU6hGPkETjQQABXdKnk
	 7xkvXnpEFm0t/VtWXyVrWNtEIE29ZAWNjDNhh4zBpDIIe22sNVyjbFTTBJtjbYKBZk
	 aXt+8mBfwP/0eTEeFGuyIhW3aSIK0wepa7mPCpWka8aDMUZEkFU+csINUz3q0/URFN
	 N6KnuMomNJJbveTeQQADosEjw+jau46beFuYAV/XBbzpvDrwxhLUcP+zjVJq85SxXr
	 Is+LWJ4pH0Hpw==
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
Subject: [PATCH 14/33] cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset
Date: Sun, 25 Jan 2026 23:45:21 +0100
Message-ID: <20260125224541.50226-15-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fhd3wtf976mtkoge4ezzrbahux1wctxd
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5665920006
X-HE-Tag: 1769381267-850725
X-HE-Meta: U2FsdGVkX1+dxI6eqsc/UMQGHvCEvg1ok+W7VSt17u80FQAH4mgaJFp1tZMvd3pDH17mWbcntj5yLnhM4P1PCKqB5tpkqWupp7i4lrcjV/cTXN7xtjYvHXncGJQM6KztDB1IC3Y+kwDoByIL3G5pkvRWZmQnoPHaiPKAkkBjv8xQVhxqNakogB+ePjwrDqQetluQGTPwTVh/GaO7AXfaubnT/PGURLHhbHzwTFwyno1aYi7Fr1oDexBu8Clv5WLf0qBY8SHFTLEOU2Td3jx+szDj6SSd/gk7G2c5Y0fmuagOwbj+2j8vnHCNs0W6PybtOSFELRN1mEdypquC2J/KjIExVLFrUdmIxmTlNPHzuc/3UdZ3wBI3+WfJkC90wGc46dGSm+7bLKSpDigUOo8MIq86lwPmB35+g03MqD3eO3eJA1LCbPdktrhy28NbZEDcqTHAE+XXw30gdqu/RRvzJkYnaNrVoH0HinNue7sfgCu2BCd346B5T2fHUMv6aVm1EpttV1/P/BNX9/+h2O5qOMITPdUTFiRZfF/r7Id62mF5hLnpiHWiJi93zlHloZKOh8aqr7jR+HsH2xud9rZGwRVjNW8V2jPcil+NBRZ3+Dcs1BNGZ50aAP2PxVBkVIEkHnu/GqgOpS1gbJDkUTDmkybmw7IX6ZIsjNR/lZ4s+HH+46+fqynhh5tq90I+cMwebpA179P8jkrtpnfu8my2v7pjepRXlHKhr/oXEalyZM4q8IgnogwttiYm04iaw7N2JFBY0Z5LmiYglsDFgMrf8A33jJaAEDsrtMkxJs+B+7KGvpbRItNyVprAMMHvBi4o+yZdEhISfqZvvB0VjR6Q2s+kYr/AL/GaRNllKJ6gv2pmtAmJCqbhaiP6Muj6kTTBGPiUwURKcd8L4fq8GDtHoYJ7UB+Jqyb96cjvJaXoXHE37112FNMAQCb2ks4qij/OrhsJHBuHDlEH7Ax32G5
 NYH0Sdah
 2o9DXeoPHfK1wYs4T9U81iKxq4NkxesuPEbS1SLkm5XfPgYEbhie1InynFtTlWr31a+Iavkr9RjN0dPiYlGAQDOh7jcXrekKp0aPnUsHo+6Cvz6P/kBxV9LIhnGTvzONcL7R/iocXIriDfxnouL7qXGoSrIHwzxDNqpBwQdYEZ8qmgz2tNz+VCFkEPq1dXVpgyMwqyUNzMoEXZRN1i5pS5DNhWtMIsvMCNk89Q5h+KY9SOKiVKBIfsFAYqmzZjXVQKZMuRfSk72phv8TOSh2t9t8blIqN/FPCZ0SwCSNNelczQHUitNU23hTwUeg8LR6n4I9/AE8eGRnpTSLwwQChXhyn+ToUalY6qSL36yQUNe84VOF6SJdzcLEFpg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Until now, HK_TYPE_DOMAIN used to only include boot defined isolated
CPUs passed through isolcpus= boot option. Users interested in also
knowing the runtime defined isolated CPUs through cpuset must use
different APIs: cpuset_cpu_is_isolated(), cpu_is_isolated(), etc...

There are many drawbacks to that approach:

1) Most interested subsystems want to know about all isolated CPUs, not
  just those defined on boot time.

2) cpuset_cpu_is_isolated() / cpu_is_isolated() are not synchronized with
  concurrent cpuset changes.

3) Further cpuset modifications are not propagated to subsystems

Solve 1) and 2) and centralize all isolated CPUs within the
HK_TYPE_DOMAIN housekeeping cpumask.

Subsystems can rely on RCU to synchronize against concurrent changes.

The propagation mentioned in 3) will be handled in further patches.

[Chen Ridong: Fix cpu_hotplug_lock deadlock and use correct static
branch API]

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Waiman Long <longman@redhat.com>
Reviewed-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 include/linux/sched/isolation.h |  7 +++
 kernel/cgroup/cpuset.c          |  5 ++-
 kernel/sched/isolation.c        | 75 ++++++++++++++++++++++++++++++---
 kernel/sched/sched.h            |  1 +
 4 files changed, 80 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index c7cf6934489c..d8d9baf44516 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -9,6 +9,11 @@
 enum hk_type {
 	/* Inverse of boot-time isolcpus= argument */
 	HK_TYPE_DOMAIN_BOOT,
+	/*
+	 * Same as HK_TYPE_DOMAIN_BOOT but also includes the
+	 * inverse of cpuset isolated partitions. As such it
+	 * is always a subset of HK_TYPE_DOMAIN_BOOT.
+	 */
 	HK_TYPE_DOMAIN,
 	/* Inverse of boot-time isolcpus=managed_irq argument */
 	HK_TYPE_MANAGED_IRQ,
@@ -35,6 +40,7 @@ extern const struct cpumask *housekeeping_cpumask(enum hk_type type);
 extern bool housekeeping_enabled(enum hk_type type);
 extern void housekeeping_affine(struct task_struct *t, enum hk_type type);
 extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
+extern int housekeeping_update(struct cpumask *isol_mask);
 extern void __init housekeeping_init(void);
 
 #else
@@ -62,6 +68,7 @@ static inline bool housekeeping_test_cpu(int cpu, enum hk_type type)
 	return true;
 }
 
+static inline int housekeeping_update(struct cpumask *isol_mask) { return 0; }
 static inline void housekeeping_init(void) { }
 #endif /* CONFIG_CPU_ISOLATION */
 
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 5e2e3514c22e..e146e1f34bf9 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1482,14 +1482,15 @@ static void update_isolation_cpumasks(void)
 	if (!isolated_cpus_updating)
 		return;
 
-	lockdep_assert_cpus_held();
-
 	ret = workqueue_unbound_exclude_cpumask(isolated_cpus);
 	WARN_ON_ONCE(ret < 0);
 
 	ret = tmigr_isolated_exclude_cpumask(isolated_cpus);
 	WARN_ON_ONCE(ret < 0);
 
+	ret = housekeeping_update(isolated_cpus);
+	WARN_ON_ONCE(ret < 0);
+
 	isolated_cpus_updating = false;
 }
 
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 6f77289c14c3..674a02891b38 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -29,18 +29,48 @@ static struct housekeeping housekeeping;
 
 bool housekeeping_enabled(enum hk_type type)
 {
-	return !!(housekeeping.flags & BIT(type));
+	return !!(READ_ONCE(housekeeping.flags) & BIT(type));
 }
 EXPORT_SYMBOL_GPL(housekeeping_enabled);
 
+static bool housekeeping_dereference_check(enum hk_type type)
+{
+	if (IS_ENABLED(CONFIG_LOCKDEP) && type == HK_TYPE_DOMAIN) {
+		/* Cpuset isn't even writable yet? */
+		if (system_state <= SYSTEM_SCHEDULING)
+			return true;
+
+		/* CPU hotplug write locked, so cpuset partition can't be overwritten */
+		if (IS_ENABLED(CONFIG_HOTPLUG_CPU) && lockdep_is_cpus_write_held())
+			return true;
+
+		/* Cpuset lock held, partitions not writable */
+		if (IS_ENABLED(CONFIG_CPUSETS) && lockdep_is_cpuset_held())
+			return true;
+
+		return false;
+	}
+
+	return true;
+}
+
+static inline struct cpumask *housekeeping_cpumask_dereference(enum hk_type type)
+{
+	return rcu_dereference_all_check(housekeeping.cpumasks[type],
+					 housekeeping_dereference_check(type));
+}
+
 const struct cpumask *housekeeping_cpumask(enum hk_type type)
 {
+	const struct cpumask *mask = NULL;
+
 	if (static_branch_unlikely(&housekeeping_overridden)) {
-		if (housekeeping.flags & BIT(type)) {
-			return rcu_dereference_check(housekeeping.cpumasks[type], 1);
-		}
+		if (READ_ONCE(housekeeping.flags) & BIT(type))
+			mask = housekeeping_cpumask_dereference(type);
 	}
-	return cpu_possible_mask;
+	if (!mask)
+		mask = cpu_possible_mask;
+	return mask;
 }
 EXPORT_SYMBOL_GPL(housekeeping_cpumask);
 
@@ -80,12 +110,45 @@ EXPORT_SYMBOL_GPL(housekeeping_affine);
 
 bool housekeeping_test_cpu(int cpu, enum hk_type type)
 {
-	if (static_branch_unlikely(&housekeeping_overridden) && housekeeping.flags & BIT(type))
+	if (static_branch_unlikely(&housekeeping_overridden) &&
+	    READ_ONCE(housekeeping.flags) & BIT(type))
 		return cpumask_test_cpu(cpu, housekeeping_cpumask(type));
 	return true;
 }
 EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
 
+int housekeeping_update(struct cpumask *isol_mask)
+{
+	struct cpumask *trial, *old = NULL;
+
+	lockdep_assert_cpus_held();
+
+	trial = kmalloc(cpumask_size(), GFP_KERNEL);
+	if (!trial)
+		return -ENOMEM;
+
+	cpumask_andnot(trial, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT), isol_mask);
+	if (!cpumask_intersects(trial, cpu_online_mask)) {
+		kfree(trial);
+		return -EINVAL;
+	}
+
+	if (!housekeeping.flags)
+		static_branch_enable_cpuslocked(&housekeeping_overridden);
+
+	if (housekeeping.flags & HK_FLAG_DOMAIN)
+		old = housekeeping_cpumask_dereference(HK_TYPE_DOMAIN);
+	else
+		WRITE_ONCE(housekeeping.flags, housekeeping.flags | HK_FLAG_DOMAIN);
+	rcu_assign_pointer(housekeeping.cpumasks[HK_TYPE_DOMAIN], trial);
+
+	synchronize_rcu();
+
+	kfree(old);
+
+	return 0;
+}
+
 void __init housekeeping_init(void)
 {
 	enum hk_type type;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 475bdab3b8db..653e898a996a 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -30,6 +30,7 @@
 #include <linux/context_tracking.h>
 #include <linux/cpufreq.h>
 #include <linux/cpumask_api.h>
+#include <linux/cpuset.h>
 #include <linux/ctype.h>
 #include <linux/file.h>
 #include <linux/fs_api.h>
-- 
2.51.1


