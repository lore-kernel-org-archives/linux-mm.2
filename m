Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 358C3EEEC1C
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:18:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A3216B00C9; Thu,  1 Jan 2026 17:18:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 985E06B00CA; Thu,  1 Jan 2026 17:18:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88DB56B00CB; Thu,  1 Jan 2026 17:18:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 764C06B00C9
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:18:14 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 34E2A5F9A2
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:18:14 +0000 (UTC)
X-FDA: 84284809308.11.952C08F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 818A2180002
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:18:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jFdsVBrD;
	spf=pass (imf16.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ldNYHY9h/5iU4eL0IhAJOvaoppJ6ZRgOHgithWCBDJY=;
	b=MbK8DyynlPRD1AoGiStBvEnkgbeSZxykcMDSfh+JZr/WD3Q/To7BnI1nQ6g0301gN/qN4A
	K5jHVtn9d0D1avvg6k2psfuJBrSKZaelBCC5P9/fabVVyfbGBd6sGD0q4+GGU0UIWcDXq7
	Xeaogz+bq2KFvH6+TcSU0e2s4HlmCzI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jFdsVBrD;
	spf=pass (imf16.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305892; a=rsa-sha256;
	cv=none;
	b=oKAQIJCvwWyTCMhG2rdFzsF0KgIUqVIRtCVzctsOVL13tS4k7yGmSW6jbvUqnhdLRRPkO8
	xNvUPzXufJ6NJY2rVwOWGYMc6I41qBJmHwiJJx9jMtGJG6r32+2PpZAlQpCFvo9LvAA/Nx
	y4IXW1LZ2d2gIqsZnvgd54G3R3oSA4k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AB85B40AF4;
	Thu,  1 Jan 2026 22:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B4FC4CEF7;
	Thu,  1 Jan 2026 22:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305891;
	bh=suQBEGrwM0H79w5KYcULPea1fuwcki7sYob2HhlcJeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFdsVBrD+gqPDbjB7hhYNrkRMOAcs9Ri6UytAJaZxIocRskZQJJHfHR1MuEbRLhXJ
	 NKXRKYXcJ+V5O4Xcjcupc84aKMc88nXfS+5H+7WcyeX+GUyaA5eteoY9YGwkt2nY9W
	 LBN6qDHveH8xYeclMA+Wt54gqUkaNeksJspA1oL0pb+E+BKUOfTUGTVF8lxrtd/ZRD
	 oQlOw903CI+WdYfANptIRGygIyCMxBqOKsbWGhhizVRblqUwY+8n16pvoU/5tJIica
	 OCKFL4VVgCvqqIbbJDcEkjRydRPCkbPMC9ZFsTbUvGdip07NmpIiHHvYF7Q+BkSqJb
	 nVViGU/r/4gPg==
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
Subject: [PATCH 29/33] sched/arm64: Move fallback task cpumask to HK_TYPE_DOMAIN
Date: Thu,  1 Jan 2026 23:13:54 +0100
Message-ID: <20260101221359.22298-30-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iqbzyhrfsr3edossh3zsqbc79ncg7zgu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 818A2180002
X-HE-Tag: 1767305892-11291
X-HE-Meta: U2FsdGVkX19h9mB8qWHLLVA4C6OgKUBL1nrLV53m+hzDDbmhe3OuUPT683I5/QDw48pfXviBjqrlaT17AV/PAIau7aokID7LdCIs6xRezLm3CNSENrSgk9k0AzRXiMKeuw2NMmx3Iicgpn7OAY0AjVOpE+/w1u+9SDDhuYdVKZCVKaMEBvm9sYFkEPAuw8YfkJESrlVc2JGbaVchs//QBdgEXrBqw1XUIE+J+dSRQL3ydst5DIavawAXr5D1JVnKUCszwdyAMNa85LsfBI5XsUDoTcZyZVtk+gLzposUzdHRXZDIqo+FyiCeYmoSXGjuyDDy4NmJsco5itlOJYPR9N4H+m5bIkPXVmlfubbBUIBO3RxhIEtDjZ7ywK8Gmv1ZaPLf4Tq3HyGG/jAgabzCL9I6iQi8NrJmYTbNjnC6ZJRV2XEtFwV2kBog1tsXodu0rrjCDV23RaYsFCnO4EXLztHEOLIz4/PhUTg4vzqN058vW9pu917IFRNBr+mIdx/aBrfZX6wWciE7WDEDAlfgs6ezkKh4ldXnLuN0u2DbozJICoXnoGIDNHWY5fCZbZYT5ZLbt8tChxNrirw/fBtse+2AkI23ADD28FH4/aSSISgAh2ex6x6czo0Iuqy2cq+WrHS+ZHQlx1oREppTdzwX/3DmrRqXamKJjZPXmXdtI5UtuOu/zDGYy+sH/tStoqGisf5+swBdlwz5UZr7sfDAR4BvZIAqpHrVt8oTS4NKBlyAHRAHLraO7hb2cJiLtOiBfeo2T86AkH4QNWO+OR2gzndXzby5pSPVwAqxwh4uCu0OiynJVgW0u4gPO2tVf/YWv0Me2XgDnwZYKodBxI8tmhXFm1Yl9VeNb+8GVD10dq8B+UkHEIkq1lYqf/+pbR5B+j16PO9FIXZgwvwRtGZM/hac+pl2aLpbR/XwChVQoC0dl4HkVbjl80O4uzR7TWEaM4tQqM3jXGLVL1sE2b/
 KF+06YXZ
 QuGMrtOLZgNrohCcqL8kbCE7IHZpljhO3na7ZEdoe7BGXhQUMTqE7ZAMq0xdAx4E8cRGaxYYhG6Weathfr2GSp+ImC2pS/+UZifAa2uUFbUNtpBidLsQYr2/8ifYnXYrjd8eoEt+yRMnxA6Hgdt6lf61pIWHB82NsJlCCJovt7tMO91Cmxz9Y2dvBkP0NutqVd5Jn0a3EYamO6uSh5Zp/m6J3mSjCSI30q06HnwgXCWpw88+pEPvgPE/GPqEuY8ywE68VKVzxrNV6MoKQ7RyK2EgR047G+AgOfcEFVlHG6NNx5nHPg1BhwqWV004bmQyAHhz47eAiwICPqF22rwNEFXodG1bPodtlk1lY
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
Reviewed-by: Waiman Long <longman@redhat.com>
---
 arch/arm64/kernel/cpufeature.c | 18 +++++++++++++++---
 include/linux/cpu.h            |  4 ++++
 kernel/cgroup/cpuset.c         | 17 ++++++++++++++---
 3 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c840a93b9ef9..70b0e45e299a 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1656,6 +1656,18 @@ has_cpuid_feature(const struct arm64_cpu_capabilities *entry, int scope)
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
@@ -1669,7 +1681,7 @@ const struct cpumask *system_32bit_el0_cpumask(void)
 
 const struct cpumask *task_cpu_fallback_mask(struct task_struct *p)
 {
-	return __task_cpu_possible_mask(p, housekeeping_cpumask(HK_TYPE_TICK));
+	return __task_cpu_possible_mask(p, housekeeping_cpumask(HK_TYPE_DOMAIN));
 }
 
 static int __init parse_32bit_el0_param(char *str)
@@ -3987,8 +3999,8 @@ static int enable_mismatched_32bit_el0(unsigned int cpu)
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
index de693acc9254..4c9aa3f80553 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1408,14 +1408,22 @@ static void partition_xcpus_del(int old_prs, struct cpuset *parent,
 	cpumask_or(parent->effective_cpus, parent->effective_cpus, xcpus);
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
  *
  * TBD: Should consider merging this function into
  *      prstate_housekeeping_conflict().
@@ -1426,6 +1434,9 @@ static bool isolated_cpus_can_update(struct cpumask *add_cpus,
 	cpumask_var_t full_hk_cpus;
 	int res = true;
 
+	if (!arch_isolated_cpus_can_update(add_cpus))
+		return false;
+
 	if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE))
 		return true;
 
-- 
2.51.1


