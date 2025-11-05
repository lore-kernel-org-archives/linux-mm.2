Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 870AACCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E23198E001D; Wed,  5 Nov 2025 16:05:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD3D48E0002; Wed,  5 Nov 2025 16:05:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC2108E001D; Wed,  5 Nov 2025 16:05:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B91648E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:05:47 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F701B7B57
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:05:47 +0000 (UTC)
X-FDA: 84077785134.21.BE0AFB2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id DC2FBC0012
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:05:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LWMPtEAp;
	spf=pass (imf22.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GLbzlk2vSKFadx/mTTqavVXj1BWc2J/3cZTE3s4nGpY=;
	b=fRccJaXn84zMPRQhX3oJtlt0tbgiQKZo1f9GMkhGotsKYGYfL3OH3ObZWsD2QeAUXzv9hf
	xe0/Tm6odeFF8OkZoEUIhZ2u1qcscpeu/XJQNcXthErRNQaOaxcgcM27ojkwDifkACbDiV
	BLB+1bqQFrowlZmTskSgMyy53z0/cc0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376745; a=rsa-sha256;
	cv=none;
	b=INdiFo2PkgdFjom7PnrGwHjPR+hZahOmWRfl2FRhgBdfm2Mxm/YJNVtNNniCAxF5YUIEln
	XpEdNMQ5XXOM7le2J2t/uUAg0DbwVCC8N3iLCLsvCPjqnYTGblnOw6/RkLzaRI7MRfD/6r
	Se2RXA6MQT3IQRLYdxeCAM7/HKiCd90=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LWMPtEAp;
	spf=pass (imf22.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 45EF060226;
	Wed,  5 Nov 2025 21:05:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A86C116B1;
	Wed,  5 Nov 2025 21:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376744;
	bh=NSCbW1jqRDXNXOPN1q+JI6ONLqfc5mcXxsKSGojX9XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWMPtEAp/SsLSnIk4m9A51hGP5hc8yyJBfe6xKhxmY+YrwzM32WL807kODsfESVMz
	 fF20ZBdm8d/ym9V3Zmx4xpDAk9A6WPScqbcRTBISSmofkLCz3/o2qRSxceU3mk65Lb
	 PMiOQVFgTZ/Ybf229Gsbmwo83ZPVdYeyNiPR7BNF5Sqw6xo4kNThz+82IRPGtzf1+C
	 cKmE2pjXhT/2gMis1KSX4NCGdARFqBpIKATDnY37g1s7cOHae3a8oqWNQFjzCX5uj/
	 I3/SJvSHJ0AboZHGXpc9Bs80RhWWAN6f5aKr/xGZEGmmsNG1i/DG43cD41sYayUrc7
	 czbmTyBk5vpaQ==
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
Subject: [PATCH 13/31] cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset
Date: Wed,  5 Nov 2025 22:03:29 +0100
Message-ID: <20251105210348.35256-14-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: DC2FBC0012
X-Stat-Signature: mza61ngkw3ozchrjwdtyu6i7zoc5uern
X-HE-Tag: 1762376745-247489
X-HE-Meta: U2FsdGVkX1+2T+TRaPfvPoKjeNAu0mK2PR1m6oib6PeybiW0MRAtdlft50RrfssT1Bq6IC9Ml61SVVbC/J0sX2CO4nENudf+9BmEhYn1j0lRbwy5BUHaPhYJ5PhITiVz9rJARllYQz6UN4UFj+bv4dGiFwU49BDSQSdJITYyLM8RDTxCayXcrT0u4xHOO3yIG1L4z2iQcXcvE/H/yuJxzRmflJFt6Vt0walJdptaFb7iQpRAreV1AzNCj+yKIuvJ8wY+RKIAcJuG323UydhByPKyatjFmqz5wxZ4TSyt4pRfcNYzqILPZiEOI/WVZvyHh/KGlMfqMDr2kVTUAeSstXv7CsBRXaj/KqcJh1J8XEkhx+nB7hh7PMchf82B8g5EPXAo7XorWvZxNC+kfX2rtGueRX7gJ1pvcLjYgENWMXyQzIqcW903bWeP3RZlqUu6IJseHQXz7blBc+vPN4Eg2EVcElDKFMtgYuBLr+Fq36T25BhTf9WVZ5w5EiBBUgIOdXLoF1dENVcUWnuJmqG9uifMWhvqoRbGX2fba6xoeZp+q0H7PgAXj+2Ebb5kAx85zZQ7z8Hz1UkQ9N6bdb5Lmyhgm9+WbD81k1DPOuZrtYmRhZwhnMLfUaJhdUfEoQMQ5xmuYAUOn3w1MSs33r35r1gPauZy4guN6qJIHaaIAC2uYVFuX4MR3TyIb3iqOp/2YhG6aqI1WAUJKkk/kTFaGA7ILKrq/MpyYfV8SyJihuLwZSvATv0uweyRRM1bJRMwjYIZXqFTE7qPZKr2P6PK1SOzpqMoZnRM/6vM+mYsMMXJEBgshvM2xv3XTe28KyZUSvHl/nf8UbQUMF+AJd2178aNrQ6VC3r4Tx1rJUBMJw4ECQorSJJ49keoejQo7zQRY6C6asWs5TIh+P+NT5+jfTTW9Qx8IUX9Ee3OyuvDXBj2jP31ATz3iQg/EC+WERDmmoWdICO2YzjVF+wK6kh
 4dtdKmRr
 xq41ucIaB7Rt86kpQDgEjLYBgnVDSoOLhlCwZpHEu74vNsYkCMRc6ubkb5Idmluxj5zANmUJPdJCDLn+7nb5NQUvV4JujB+ObFsMHfESm+ES+QMJ32f2a57bMHM/6/aqtXT5uXgtvqxaDfpYLZtcRfWqy/vY9k8aonJFzlx0KEjsubOKl3RPN5M+K5Lh5eIErCzk8wsinwGO9TNqhbYXsVYJgX6X7wwnFkTU/RzdaKx7ndGLnYncv/q2S4SIyGq+2ikL/UCir2kRgG5znesZP+f4OC0c8sUsWIo4lpwMUUkshgOOM71zwxGWPe0U/5K8dYK+EfQzwD4P38l8=
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

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/linux/sched/isolation.h |  7 +++
 kernel/cgroup/cpuset.c          |  2 +
 kernel/sched/isolation.c        | 76 ++++++++++++++++++++++++++++++---
 kernel/sched/sched.h            |  1 +
 4 files changed, 80 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index 109a2149e21a..aaf2a672f8dc 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -9,6 +9,11 @@
 enum hk_type {
 	/* Revert of boot-time isolcpus= argument */
 	HK_TYPE_DOMAIN_BOOT,
+	/*
+	 * Same as HK_TYPE_DOMAIN_BOOT but also includes the
+	 * revert of cpuset isolated partitions. As such it
+	 * is always a subset of HK_TYPE_DOMAIN_BOOT.
+	 */
 	HK_TYPE_DOMAIN,
 	/* Revert of boot-time isolcpus=managed_irq argument */
 	HK_TYPE_MANAGED_IRQ,
@@ -35,6 +40,7 @@ extern const struct cpumask *housekeeping_cpumask(enum hk_type type);
 extern bool housekeeping_enabled(enum hk_type type);
 extern void housekeeping_affine(struct task_struct *t, enum hk_type type);
 extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
+extern int housekeeping_update(struct cpumask *mask, enum hk_type type);
 extern void __init housekeeping_init(void);
 
 #else
@@ -62,6 +68,7 @@ static inline bool housekeeping_test_cpu(int cpu, enum hk_type type)
 	return true;
 }
 
+static inline int housekeeping_update(struct cpumask *mask, enum hk_type type) { return 0; }
 static inline void housekeeping_init(void) { }
 #endif /* CONFIG_CPU_ISOLATION */
 
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index aa1ac7bcf2ea..b04a4242f2fa 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1403,6 +1403,8 @@ static void update_unbound_workqueue_cpumask(bool isolcpus_updated)
 
 	ret = workqueue_unbound_exclude_cpumask(isolated_cpus);
 	WARN_ON_ONCE(ret < 0);
+	ret = housekeeping_update(isolated_cpus, HK_TYPE_DOMAIN);
+	WARN_ON_ONCE(ret < 0);
 }
 
 /**
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index bee6c04be103..80a5b7c6400c 100644
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
 
@@ -80,12 +110,46 @@ EXPORT_SYMBOL_GPL(housekeeping_affine);
 
 bool housekeeping_test_cpu(int cpu, enum hk_type type)
 {
-	if (static_branch_unlikely(&housekeeping_overridden) && housekeeping.flags & BIT(type))
+	if (static_branch_unlikely(&housekeeping_overridden) &&
+	    READ_ONCE(housekeeping.flags) & BIT(type))
 		return cpumask_test_cpu(cpu, housekeeping_cpumask(type));
 	return true;
 }
 EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
 
+int housekeeping_update(struct cpumask *mask, enum hk_type type)
+{
+	struct cpumask *trial, *old = NULL;
+
+	if (type != HK_TYPE_DOMAIN)
+		return -ENOTSUPP;
+
+	trial = kmalloc(cpumask_size(), GFP_KERNEL);
+	if (!trial)
+		return -ENOMEM;
+
+	cpumask_andnot(trial, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT), mask);
+	if (!cpumask_intersects(trial, cpu_online_mask)) {
+		kfree(trial);
+		return -EINVAL;
+	}
+
+	if (!housekeeping.flags)
+		static_branch_enable(&housekeeping_overridden);
+
+	if (housekeeping.flags & BIT(type))
+		old = housekeeping_cpumask_dereference(type);
+	else
+		WRITE_ONCE(housekeeping.flags, housekeeping.flags | BIT(type));
+	rcu_assign_pointer(housekeeping.cpumasks[type], trial);
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
index 2fc1ddde3120..5a44e85d4864 100644
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
2.51.0


