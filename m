Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09C49CCD18C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69A3A8E0086; Mon, 13 Oct 2025 16:35:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 672508E0036; Mon, 13 Oct 2025 16:35:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 588028E0086; Mon, 13 Oct 2025 16:35:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45FD88E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:35:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0FD994709B
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:35:29 +0000 (UTC)
X-FDA: 83994246378.14.8E3CB7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5A219180013
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:35:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=puNf58eH;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BBGFraA2r18snrtykXuSXO9gIBJ9e1axYh5bPV7np4Y=;
	b=CiHDbhVp412xUbhNW20lurzsqAkHC96jHTQLzoovndTap0NOO295Y8XilTEEIeLR2WDDRb
	v+73IHO5oMTde4jpusZCJMIuJOm/6BxS2O/uED5dR6ztONJZfqobSBOnLgDXkvtwqXCoWO
	OpoVV47ptcDXmLg3cLpWLTxrRQnm1Xw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=puNf58eH;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387727; a=rsa-sha256;
	cv=none;
	b=x8oEAMAa/1NQtPme+2MeD4KPgrBCQj19DZXCDTs6RapGrV02AY91jxaq2jt5CW5efI91Cd
	kwX2Wrn/tkL61HFVTxpB+8loCiFBbL8OC2LJPNsS7+jEjTMPh0cF5EpL/KzzQgsomeWZc7
	oPf9bmdCwPGwGQF1ycKVI44BEP7r/Qc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B4B64079F;
	Mon, 13 Oct 2025 20:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F449C4CEF8;
	Mon, 13 Oct 2025 20:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387726;
	bh=TCF8MVyq430j5XDUVoolby9dsM0WVQ59dd/A7DweIIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=puNf58eHX8iqWcX4jZvJoV0HGrBTDxCWE15XDARtObLpMMvPRy+y0OstVhXwHQ7fV
	 smjRbaQwXlOhyGu62k0J3ZKNFF8Z9wmsPYW5kXmhDQvYC6sF1F5JdQb7XTbwVZW5S0
	 Zt/yHfXLXhsTxeaN8S+H+auqeS8oizw+IOarobKVOzujEmr1QjfvzUs0BqICIIDDXL
	 pGvdPObIsHFEAiS3kgMyvjdXl9zFRMAvkyTmw2EpLDOqyH3d8mqgV/XdWCkmoKbBmu
	 a6Rg6jsQfpUS08mwcwK0iUDhWGkLgDfnbwngzO3gEWxXv25X+lXS95VuIpVGAFcigO
	 Xo9mEZeO/fQ/Q==
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
Subject: [PATCH 27/33] sched/arm64: Move fallback task cpumask to HK_TYPE_DOMAIN
Date: Mon, 13 Oct 2025 22:31:40 +0200
Message-ID: <20251013203146.10162-28-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5A219180013
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: tnouqhq8zq9hb3cgxi5zeds7hhom6ctr
X-HE-Tag: 1760387727-870319
X-HE-Meta: U2FsdGVkX1/V8K+Fl5708i9DhBzP5ECjcK6XqxsRjTxp/BG192L8UtIq1+ehVTwtScqcd/XZAjbbEkenEWGePMZB25rqfN+ckMvRTzqOgW4dr8RlYhJ7h/5Ma+Q6YjErikwT7ElIkqX4tI8nglnOotAzaGwwEiQmN6bLNhUmBXCd3CSdW5LhZi19rpj8V4JFWdV8H46xDdC7z6NGP6TUsQwjQ7I4RHF9DPad+GunDR6Qc48LV2cDARRjaaWngGW2Xci1nz/Ec0DYcJqgo816HuhppexLqI/Xdj+NRZY/j80kG8DJgJAfU+uhJtVJQt4A+3MLRCxzmOa06lQPQH0Zxi+4kc8Bkyvrpv0ziBoPCrN0BVkPl8UzQ6PvCalfxnFHLUZfXlHjA2zpZFHe7i2vMwpaNeq5rICwny6JDdBWgxN+DxGuq4gV0w5CLKnXy+JYhBy/VMryrPuk0xpjvfVUO68kMtcF3zhLN8nsvwt/r6KYNqoSxFETkYuuio3IEh0fYNH2MNRHPnMnF0mEgk6bZakQwaiKcIJN05CpAnWTqlbIZVdD5tVBJOMqAMGLs4Qtb/3aHeT9iYI6CoAEKRJjvFnklS5upfFFV06PvLLkLkk0JfWbVnTdH8yFNhZqPsIrIh/OGJ9fAsxIZ5Z57g61OFyMhxk0ymdhuj1OrAOWYGN0ar7FlwNUIS90lWaSzKyCrm+bc13IcInMu1DRKeK6cbq0WiASRPp2Kx4D2ihhd3Q9e2zvO9N2BNkfoXbnurt3RMOQnZtGmCwum8fJlks0Ycnt97IhGwG4jk+YajDLtL3j5MG+OzyIuZmeWAN0E4zSOd6evTwqBc8jj3iNfrurGVP6UXAFp+VQXH1hGjbEf/eSYsKBIVyF8g8tu29oAPNte4qFh+/VmkMVhXPyQJJtUtMrgiJZgoZ8PstyxQ4/l/fxi1bCFjkK4Ir0tbNUb1PjkOSguuZCVkx4t+z6TZq
 pxpTYhfQ
 vFu4hIE5406rIZqDF7Epv4VvPdqBdQ6HOfsFR5Q9txvAY6ED1fA8SS6uBDDieVzJtKyPTVQVEkQ/rNW3ZH+XQRtcmB0u13oSYB4EHDJGwDASEkgHEu++RM6o8/CACoTYAz+d9jKTAtGt6UuunanSNzt+KM0KklHvu1qWiiA1+YNjwthX4m/D19sTreXqgGKKOehsP9SQRysnbBrN+KLEjN85czVOD4ZYemGMOtlgvk0T2+TYFCvrCi1R2bUN4ohWMzqxGHbQ+s6bBZ9gPUOTyl1binEv4vYTg3erXKLSIa/73Xh0o6ZAI/dICSJKmhAGMTpc+SbBU/STl7T8=
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


