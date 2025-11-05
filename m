Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BEC7CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:07:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA4D88E002B; Wed,  5 Nov 2025 16:07:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7C828E0002; Wed,  5 Nov 2025 16:07:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96B158E002B; Wed,  5 Nov 2025 16:07:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8062A8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:07:38 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3EA7213B070
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:07:38 +0000 (UTC)
X-FDA: 84077789796.03.768091C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7C01FC0012
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:07:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o0fFnugQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BBGFraA2r18snrtykXuSXO9gIBJ9e1axYh5bPV7np4Y=;
	b=Pk2GU3q4P1zQtBvXkiCn9ZsIAePHQiLXfpUZutoCbE2rlxmLINH4MAb8nzbiFzozsGTkR+
	2aBQH9vHU3T1JB+OGaUMLIHtlaDlisZzO4+7iNxZsNnxyHpRRJkxAQ+3EfEgWv8ekjidjN
	kST9JwCo1aaadbqXSXZiVXP/OpKd40I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376856; a=rsa-sha256;
	cv=none;
	b=YXzBDdWbwzJR0hiFgBTxhpuUAE+jO/oIgBc9xxVkkE49X11REoORsckp0heOn7s0/daTYr
	u9QZtzooiQX9teQpQDdGri4nIQgRpiRbB+caHrThg9/hkQYBnW5wrasxY8EXH4/WEBFLxa
	G+PpOvqGAje8y+95slGlL+1cJJjtraA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o0fFnugQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AC73A41ABE;
	Wed,  5 Nov 2025 21:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414CEC4CEF5;
	Wed,  5 Nov 2025 21:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376855;
	bh=TCF8MVyq430j5XDUVoolby9dsM0WVQ59dd/A7DweIIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o0fFnugQTFG/RXlQvZAg0LmxL1rabmJvLKEI4i8jnG6+49xPoRoH26kAR0uHunR+2
	 ZBcBQWJjRgJdZGXcxSSDAWoKhlJLOYizJICcLoAqcUpNI65ySZq1Jx9WH1trZF4POQ
	 7WuQTmc+rMjo52wqF1ZQ+MRo9RAQslGBt7JQA6Q7TMwtF/Og5JisgtD9+q2KrhYdLQ
	 Lhos2xSI9YbHGL1zN40m/fuIC2OLXxkzUGebXsoL/50URqNzfH3kG4I44qL5FQ5nrn
	 AlYgoiUzof7XSK2JcGXomAMMMDNb6wHnnXpW1qgjj7vWMjH7YnJPJD5jl9XRQVdHKg
	 n2LaM+LJdYrnQ==
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
Subject: [PATCH 27/31] sched/arm64: Move fallback task cpumask to HK_TYPE_DOMAIN
Date: Wed,  5 Nov 2025 22:03:43 +0100
Message-ID: <20251105210348.35256-28-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7uwig4du9e3sxidwhkx9jpimd1cdxatd
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C01FC0012
X-Rspamd-Server: rspam10
X-HE-Tag: 1762376856-158898
X-HE-Meta: U2FsdGVkX19+m8TcRyq5PLrtCWJdQF1K6i7AUhFv2OXe69aQT7OIjvmqMAc6xDzu7wDw/YwvBKL+KezgKpqU22P9Apw4WJjMWuG0qjPdI8hcz85fOxVop3vK4o2b+rABbXUSGpW8stwgPtm1jQEvcgdl4zWvSSUQl7xOp3wABOLfBFPL1mDkD3yqEvf8qs+ZPShtw/dahnwdKVCwInojlZf+8dW1nuVJt5RPg5NdZv/WKF7vT3FEKAACo9dbBz1GWvnSWr5v5+u+7d6kdS/kMX7YPApVrb/QHmqqg7IIniAqwDBXzT3X3xOqTDGfsFyOwkEJYLS62gTKiRrgSXkaedShP0c2v5JXDfJoX9n0fyPMeEDaOeQCS/yrbGq4J0JdRW8npzWfPBDjUpmsyG3okreFkJ9TJ0pgD9hSwGobXZc0KmycnP1GvaLIeIFBD1bLJTvwvPXHIF0oVQMS0rnqDDOe9T8G47VigTJ8ai9bxnzwPq364AfHkN8lm/ztYQz4e4ErSyPKHxZaLznUPDn2MbL90mIwXL/zJspR3i/lrvDfpSq1rH9NuD+hlQEYB+yQsAVCMG0HPRIKKiV3AFRrBBH9uSLgu8dTa6Q82Fr7b/Avpsi5kAvDiLPCtSRc6LUtp2pLKls8cjHLrqI/o99pkufKWqVYBDMJE6K8YeO1wBEWC+2r1+kC8q6Bu7JLw0FLKoJaIZnKwUz7+EBV0m2uJ059Yt7CPTevlgs8ebycNdJZW9OoR8sUbCgBTD9XUDXgsqpMoyU9ZWf0RMeXP2oyNL/n+OYYkupQ8D1P8qFEp/GWwRO9nEbMOCc1OeYolW1pTb9cuO5+xYYyAgejC9cbzlQpK8nMhsIvABgtHI3wRYYg7C0dRNBwkpaEElpduYCZoNlST45fVIkM4KQQukOeQLaw2AKHoyXIkv3/FgLUKmSG/DMIgcmGWC3/sGwFaV+nY2BsdI0+TG8d9yqI4TB
 0zceiQ9/
 Z2dmqUBys7Z85IAoSf60cbyl+9kiGLichVJiDzs+uJd124TW8P3gn4us0sNNjotJ82226+MEg3Wthl4jxiss1wZSEir9rDMx4jbwuzKnGuAdGUsmU4dS88qVjLWZMN3/03pZRseu7zaW0HNpNgrLt+6Tk4FEWhpDz3SE5vtRJSbhosMiT1IiKdUVilR03oHDdxOOz2MzJFfp9wUCd8LQ+vuoa8v8Pw1Rrep0F4M/+LpVn3PZnD+BKGIT+6mpi/13r1MEQ+SNSDq1EcjhJqtHH4Wo9BSMV/3vNqrHLRhdY2/QC4KMseDlh75DPrM+432pu+m/qeUmVO/Aq5sI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When none of the allowed CPUs of a task are online, it gets migrated
to the fallback cpumask which is all the non nohz_full CPUs.

However just like nohz_full CPUs, domain isolated CPUs don't want to be
disturbed by tasks that have lost their CPU affinities.

And since nohz_full rely on domain isolation to work correctly, the
housekeeping mask of domain isolated CPUs should always be a superset of
the housekeeping mask of nohz_full CPUs (there can be CPUs that are
domain isolated but not nohz_full, OTOH there shouldn't be nohz_full
CPUs that are not domain isolated):

	HK_TYPE_DOMAIN | HK_TYPE_KERNEL_NOISE == HK_TYPE_DOMAIN

Therefore use HK_TYPE_DOMAIN as the appropriate fallback target for
tasks and since this cpumask can be modified at runtime, make sure
that 32 bits support CPUs on ARM64 mismatched systems are not isolated
by cpusets.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 18 +++++++++++++++---
 include/linux/cpu.h            |  4 ++++
 kernel/cgroup/cpuset.c         | 17 ++++++++++++++---
 3 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 5ed401ff79e3..4296b149ccf0 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1655,6 +1655,18 @@ has_cpuid_feature(const struct arm64_cpu_capabilities *entry, int scope)
 	return feature_matches(val, entry);
 }
 
+/*
+ * 32 bits support CPUs can't be isolated because tasks may be
+ * arbitrarily affine to them, defeating the purpose of isolation.
+ */
+bool arch_isolated_cpus_can_update(struct cpumask *new_cpus)
+{
+	if (static_branch_unlikely(&arm64_mismatched_32bit_el0))
+		return !cpumask_intersects(cpu_32bit_el0_mask, new_cpus);
+	else
+		return true;
+}
+
 const struct cpumask *system_32bit_el0_cpumask(void)
 {
 	if (!system_supports_32bit_el0())
@@ -1668,7 +1680,7 @@ const struct cpumask *system_32bit_el0_cpumask(void)
 
 const struct cpumask *task_cpu_fallback_mask(struct task_struct *p)
 {
-	return __task_cpu_possible_mask(p, housekeeping_cpumask(HK_TYPE_TICK));
+	return __task_cpu_possible_mask(p, housekeeping_cpumask(HK_TYPE_DOMAIN));
 }
 
 static int __init parse_32bit_el0_param(char *str)
@@ -3922,8 +3934,8 @@ static int enable_mismatched_32bit_el0(unsigned int cpu)
 	bool cpu_32bit = false;
 
 	if (id_aa64pfr0_32bit_el0(info->reg_id_aa64pfr0)) {
-		if (!housekeeping_cpu(cpu, HK_TYPE_TICK))
-			pr_info("Treating adaptive-ticks CPU %u as 64-bit only\n", cpu);
+		if (!housekeeping_cpu(cpu, HK_TYPE_DOMAIN))
+			pr_info("Treating domain isolated CPU %u as 64-bit only\n", cpu);
 		else
 			cpu_32bit = true;
 	}
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 487b3bf2e1ea..0b48af25ab5c 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -229,4 +229,8 @@ static inline bool cpu_attack_vector_mitigated(enum cpu_attack_vectors v)
 #define smt_mitigations SMT_MITIGATIONS_OFF
 #endif
 
+struct cpumask;
+
+bool arch_isolated_cpus_can_update(struct cpumask *new_cpus);
+
 #endif /* _LINUX_CPU_H_ */
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index d1a799e361c3..817c07a7a1b4 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1404,14 +1404,22 @@ static bool partition_xcpus_del(int old_prs, struct cpuset *parent,
 	return isolcpus_updated;
 }
 
+bool __weak arch_isolated_cpus_can_update(struct cpumask *new_cpus)
+{
+	return true;
+}
+
 /*
- * isolated_cpus_can_update - check for isolated & nohz_full conflicts
+ * isolated_cpus_can_update - check for conflicts against housekeeping and
+ *                            CPUs capabilities.
  * @add_cpus: cpu mask for cpus that are going to be isolated
  * @del_cpus: cpu mask for cpus that are no longer isolated, can be NULL
  * Return: false if there is conflict, true otherwise
  *
- * If nohz_full is enabled and we have isolated CPUs, their combination must
- * still leave housekeeping CPUs.
+ * Check for conflicts:
+ * - If nohz_full is enabled and there are isolated CPUs, their combination must
+ *   still leave housekeeping CPUs.
+ * - Architecture has CPU capabilities incompatible with being isolated
  */
 static bool isolated_cpus_can_update(struct cpumask *add_cpus,
 				     struct cpumask *del_cpus)
@@ -1419,6 +1427,9 @@ static bool isolated_cpus_can_update(struct cpumask *add_cpus,
 	cpumask_var_t full_hk_cpus;
 	int res = true;
 
+	if (!arch_isolated_cpus_can_update(add_cpus))
+		return false;
+
 	if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE))
 		return true;
 
-- 
2.51.0


