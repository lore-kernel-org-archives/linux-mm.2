Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DD3CE75453
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 970EC6B00C5; Wed, 24 Dec 2025 08:49:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92E866B00C6; Wed, 24 Dec 2025 08:49:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8442F6B00C7; Wed, 24 Dec 2025 08:49:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7361A6B00C5
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:49:42 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36062898E2
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:49:42 +0000 (UTC)
X-FDA: 84254497404.05.477BCB9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9F782180008
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:49:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VrX2pmQO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584180; a=rsa-sha256;
	cv=none;
	b=egeaagJ4mUw2GMZBy+KOFP3uqcz8XfrAvCNk0C+q02wwjHrsTI0gxfXbHyjkr0vKMWK7Ue
	s3gLvMqQfDpkGidzUHhBvMkjwyASl5vqumaU2Pv1m+tQjCmB89E6wx8XJ5hep8UDE43Zps
	J5Rg6DDYoy/DOkKkf5zweC4jMDT+DdE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VrX2pmQO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J6ah9F19j8ar51YOj/i8aeqJcAZAEhWnxFfOmFAzpfM=;
	b=NoEMpCQJSHB6UCO+diw+CXEuNLIh2wSoeCpGbSpcb/odF0wEtvN+gMy+r5DV9tJi/vPMLf
	CWgqOaeYCwThQiXirPZCJkx4iVUQsPtgO/HS/XdIGIJVnueuKp7vHcO/Vb8q5FGOOWOc9F
	VgR9sDJzm2RVB5plLNhvpKTehcV3wYQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1CC06600AD;
	Wed, 24 Dec 2025 13:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E007AC4CEF7;
	Wed, 24 Dec 2025 13:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584179;
	bh=v+Hi/QvshgBMqvM0z0QGnJU2LBWwYE1HGBmu0KtZ+dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VrX2pmQOvVTzPFdB3trv/bRr1kHWY1gFXkJYQ9vAZchkg0TGKXjd0qLc21mcUqWBQ
	 c6IQdoV6joMojnXeJ0GWjCDorzjXRye4sPTIXpdQjNa3lwIMO/73WoGa1R3HbNiTwQ
	 /+LbH3XmQwQTKf+i+vFPJh3YGr2AR5VsiFJatDHTudJeiMKQO075P5q14/oJ++4YCG
	 JFAKVX76vsaQ4kn5snndsojVdOq8mGkjow4Fj17LIs5pxyljc747Uy+IMl1nXExaJp
	 EdSXIH1SPYJUDLbMGGKoI6XOWDMlHLT1up1k8ZzwlvpUPAG2G+yLFkAOu+TmXJPzBZ
	 4BV8kHQ8r8lsg==
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
Date: Wed, 24 Dec 2025 14:45:16 +0100
Message-ID: <20251224134520.33231-30-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9F782180008
X-Stat-Signature: dc19kqea44fwmcwmbnqhu1p43pwmyuhe
X-Rspam-User: 
X-HE-Tag: 1766584180-953997
X-HE-Meta: U2FsdGVkX1838sps727hxFv31WMbLsVW1nRowIJLPkjJD32VyS687wOYYi5Asb5rznvLKLsv0Gvg0qnjSW2DJu3gFBAQinqSN1yYBEm/62wu4xSxJYFbe2nFoDe/DzIkBVUyzcIR0LiU2Picp/GHEr3JFJeXggPk+VAXAECqBYIlUSsRGYAeDB7lwGKOqftb9qURiBVRKSsIOSzHHcA31x0rbudrqyuzK6+XLkjfGEI6K+Eq6a5KttN3vNWJRyF35pnmqYfdD2HAzMNUvGvbQBhkWe6vxW+dpTuqqN2Z2doRebaNMYGIXWyvrRNr3LPS/AihL0k1t1e8KK9X7u3uV0oK/z7wyOk9MeQnxeTtqJOCisZs1O910joOTiij7zLbigb2cchHy2ZWtyWuUBv3R5hhbDIKOaUeD5C6zScKTzpSbK2ksQlScPqth62wMaSuKXRNsL0TNxFN53VpkibX5l2ymlQaxcWoQpnITFqoPvhhdpRy1JnmUlDQI5tduSlaQ7VlrGaKjVx3KUTiiFNhiNNBH1UYbMGGKvwN/GVc2t4vcz9qujDw5ePGMuOe7BARSrCbZ2kxrx0GyUD1hBuoRjyPSouVxWY0eH3Y1INvms7Pe1sjzF2/TsFjUQlqNEgzVQDc6yJZQcoQ2JUWP7Ces/clQPePAyjpb+pKZNc41b82WbU96wDnG9eeX5DLK+A44JdD7MWx+UQUwV4HaiV0mWMpUK1pGOnAEc3D5NIuF6+H9bBM3L1OTNu+V6AqSJgYLrwrLQIDgfWfreyUGNT2rGowPkgXr8m5Oy/5Rlj2JWJ003F7SazCzstFUZjEnnX2p4QmFIIT9KfHpYTDNiTzRyWTDrgi3D19KMdhQOIfdOpu6CxMBKcNXEN19ZcymcoS5XWIMKRkQZQ4sdWoA9vIOy0vv2i+grXU6ixldDyQVvy6RxrD648xbPGDBxmdtbrqBvRKeyALyLSBteyMVAF
 jY+riNmq
 jyRI58kTSCxDp2CW7LsjRkBgynmkkKtklSa3V5xZwZ1lue67lRhgkwJ2QFSKyDOTwVN2TZ6mV8xpOiFdxzdQbAOPUOKqkpQ0Brxr/03ms0375qGkvvCm1FG/vX9SDe64o2Dd2CjFpqBDC2MP3hJ5h8c30ARa/bdQSamAVKlLkZqxIkBzgiZ0hsgPPlHO1Whg1uSE3J1TWO3PIbDutbQAkQmm+XZYRzKyh7Mw+effMHawDC5N/+SrkyToBJ3hHv9IpkSDOoIMbBk/dBhz8ZLjUp4Uk4jwAIvf4DMixu7YgG8+dk2M7eYv+mDTVzWJEUq0XpDmpxv/7D6LUbEQ=
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
index cd6119c02beb..1cc83a3c25f6 100644
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


