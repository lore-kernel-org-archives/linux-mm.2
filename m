Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8695BEEB57B
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:16:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECA166B00A9; Thu,  1 Jan 2026 17:16:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E88486B00AB; Thu,  1 Jan 2026 17:16:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D84236B00AC; Thu,  1 Jan 2026 17:16:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C77F76B00A9
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:16:03 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D5CA13CCD2
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:16:03 +0000 (UTC)
X-FDA: 84284803806.13.ABB77DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0CD7E180010
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:16:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=muHvVB3a;
	spf=pass (imf24.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=srr2Rd/TEcy3A2JJQDPXH1+aXxFy3yljG6lcR/gP5CI=;
	b=IBoX++gZKfioSl4CAjvSHCG1rQKKL+toFzfcbBhBEYIiNQLZ59RKJpDzMDIKn0BLklfUvp
	qrxOCvBLkgnCOCyATfwEuJ5E9eOLzgveX1msk+vI9Z5ANLxD2LzUPp6Pa6+lgPyFX3YmU7
	QLz7zJBG32gRRIMiERRw3grWNrqhdf8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=muHvVB3a;
	spf=pass (imf24.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305762; a=rsa-sha256;
	cv=none;
	b=Xsybq2P9rIkxTKcKJIIOFcFf3FQxmBgf4qJaLQ1Pit7SUZIQ3PXv2zfqOyta7rnTFTi0+y
	p2JD2eP5Q5gaWwFDcgxMbtKU4JQKp9MCr9TiFPJWcI8kGHplDl0Pdm56NWIZ09kwDLOA05
	1bJik/6SU9A9Q2PtS2AB/CysN/7rNUs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E76260054;
	Thu,  1 Jan 2026 22:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2894CC4CEF7;
	Thu,  1 Jan 2026 22:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305761;
	bh=iE5HNXxcf5Yij69saaDAoVPz7iPaTsBAd7fg0JUxZYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=muHvVB3a10Akl60W77jSSqSOLSGnLSzt0LX9ziUqhp8Su9a3CdhYAPDfiUBa8doE1
	 r2Uad3NKMWcSZCcgNPa9ukJd+x1X/iyvE6FcC0ciaQ48TMVcUN4ydVTs45NjRjDQOP
	 ZNNBLqnW+1U3ELu0rDwrTFpZXz6tzS358v0g/cnSG4YYRsQ0dkTLH49M5MXv5F4aMs
	 0o48Y4d8UZFG/chECMx8CaKk+tLHp/fsT2Gc+3UJWOkH2OvtaGfXgZIUa0xoSh7sTh
	 zPYWTnu9hq3WwMWJ3hibzDCEkzgcW2+xU7Xi8XbeAlobi16xrWr1aOHydKIAcItS3f
	 OYx8qbidzQB9w==
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
Subject: [PATCH 13/33] sched/isolation: Convert housekeeping cpumasks to rcu pointers
Date: Thu,  1 Jan 2026 23:13:38 +0100
Message-ID: <20260101221359.22298-14-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 65e3id94ygbd9aa8jf5wgeugdysacycs
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0CD7E180010
X-HE-Tag: 1767305761-757985
X-HE-Meta: U2FsdGVkX19Y2YZa18/1crlJrXwI6shDRVJdNxMS+buSVzu1oJZD5sd2/Nq2hNezozCgXTCZ4Mgv1cfgNVu06FGRReAhnU9+eeBzcOmuTLBZJLcxvzHlHPRSmO7JCd1MkThrRnUHk1JXLSR1FhSNFknNX++OBMJiAB95tZIEHitHI13Ca3XOVqpKwLF49hiVC1T9A4ne6bIYoCqE+KOM+7Llsv/fjKWKiyPfSqaJMLKVika+m1JlJ1C8dJIq9dWejIMBfNUcC+j7Rtdr1vARIG29w5hOH0szn8XKALT7DAirgcl8x8cNRMKIaATkE2D3H4BnqP4k2V4LGo+qbmyGglmsVgcWMaVV4GF3g+BpiNN4RB3QgIXpAZMOuEJZXNiSryhBVv2BX7ab1cuC+xQ4pznIu8GGzJa9D2MYE+15DPWXKWtksd4NKiOUnFEZGJenQ3CXqbD5AosgmxPsL4tFiroQVCEa2/yGksM8fOGy3DOyPVepi2B73PBXCRhPllo+EjxVbw32HuFQwaIM/1WdkhacY/rvHF+HZEP61/gzPnOL08asRyN+Y7COaylr/jP7tW+tagpm3+To4xI8WR7ModJiv8UOr8IfULze8jX6IwmnJlciTmIzEAYPiixmnmjd8PcK2WpNg673BvhV5pQaGbFuKemdwsGhrfIMD26h7NO2CBbai1mgc6Ge2M8VVqgXFU4GydZwhqg+r3nA3AohK67b3YbWZ84M0qvjKnvV5LlgBMXI2LW38Gq2iuj7lpk3xEwFbZ+zxPhZnhKY/FtSXm8TX2sGKMRYHrA2Vfa15AUtIKj5cAtkj1KGKzcDtqQZgviMqVoxizQIExS8wFp+Iwc4iAMJAZjYWQvjIT0x52iSbTA4FEcCs2R6F8sKJ1BBGyqresgAn9MBKAI2HL2wQraxGGX6ZD93zUnL8Vdpt7P7Z/SQm/oyMmcJbQFu+949fhsfETl+ApP7iG/suDF
 ofli1Zkp
 4UI8eOEJkbsxedX6M9JWhGqmM5FlqkBs3Vm7iWBS/BqdCfTphtmsgFfgjjkG1cb+LuO78ow/g5ocXrN1WKcwnln7MNFDgWmIH1pIu7u1hpyZx6wHE3E4mr/A3guv4Vn5dKKxjrClHhT3V9RhftV9UV/+qyVAn158XiwFDN4nZDvAg+phYnGHfSb5clv8l02DKF+yF+r7JkdEzozJsb4fm7SCiduX1PZLhkm8YzJI+8TckaYpjNSeC/0vs4FJkHbWlMz9/rpr/hsvfwdU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HK_TYPE_DOMAIN's cpumask will soon be made modifiable by cpuset.
A synchronization mechanism is then needed to synchronize the updates
with the housekeeping cpumask readers.

Turn the housekeeping cpumasks into RCU pointers. Once a housekeeping
cpumask will be modified, the update side will wait for an RCU grace
period and propagate the change to interested subsystem when deemed
necessary.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/sched/isolation.c | 58 +++++++++++++++++++++++++---------------
 kernel/sched/sched.h     |  1 +
 2 files changed, 37 insertions(+), 22 deletions(-)

diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 11a623fa6320..83be49ec2b06 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -21,7 +21,7 @@ DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
 EXPORT_SYMBOL_GPL(housekeeping_overridden);
 
 struct housekeeping {
-	cpumask_var_t cpumasks[HK_TYPE_MAX];
+	struct cpumask __rcu *cpumasks[HK_TYPE_MAX];
 	unsigned long flags;
 };
 
@@ -33,17 +33,28 @@ bool housekeeping_enabled(enum hk_type type)
 }
 EXPORT_SYMBOL_GPL(housekeeping_enabled);
 
+const struct cpumask *housekeeping_cpumask(enum hk_type type)
+{
+	if (static_branch_unlikely(&housekeeping_overridden)) {
+		if (housekeeping.flags & BIT(type)) {
+			return rcu_dereference_check(housekeeping.cpumasks[type], 1);
+		}
+	}
+	return cpu_possible_mask;
+}
+EXPORT_SYMBOL_GPL(housekeeping_cpumask);
+
 int housekeeping_any_cpu(enum hk_type type)
 {
 	int cpu;
 
 	if (static_branch_unlikely(&housekeeping_overridden)) {
 		if (housekeeping.flags & BIT(type)) {
-			cpu = sched_numa_find_closest(housekeeping.cpumasks[type], smp_processor_id());
+			cpu = sched_numa_find_closest(housekeeping_cpumask(type), smp_processor_id());
 			if (cpu < nr_cpu_ids)
 				return cpu;
 
-			cpu = cpumask_any_and_distribute(housekeeping.cpumasks[type], cpu_online_mask);
+			cpu = cpumask_any_and_distribute(housekeeping_cpumask(type), cpu_online_mask);
 			if (likely(cpu < nr_cpu_ids))
 				return cpu;
 			/*
@@ -59,28 +70,18 @@ int housekeeping_any_cpu(enum hk_type type)
 }
 EXPORT_SYMBOL_GPL(housekeeping_any_cpu);
 
-const struct cpumask *housekeeping_cpumask(enum hk_type type)
-{
-	if (static_branch_unlikely(&housekeeping_overridden))
-		if (housekeeping.flags & BIT(type))
-			return housekeeping.cpumasks[type];
-	return cpu_possible_mask;
-}
-EXPORT_SYMBOL_GPL(housekeeping_cpumask);
-
 void housekeeping_affine(struct task_struct *t, enum hk_type type)
 {
 	if (static_branch_unlikely(&housekeeping_overridden))
 		if (housekeeping.flags & BIT(type))
-			set_cpus_allowed_ptr(t, housekeeping.cpumasks[type]);
+			set_cpus_allowed_ptr(t, housekeeping_cpumask(type));
 }
 EXPORT_SYMBOL_GPL(housekeeping_affine);
 
 bool housekeeping_test_cpu(int cpu, enum hk_type type)
 {
-	if (static_branch_unlikely(&housekeeping_overridden))
-		if (housekeeping.flags & BIT(type))
-			return cpumask_test_cpu(cpu, housekeeping.cpumasks[type]);
+	if (static_branch_unlikely(&housekeeping_overridden) && housekeeping.flags & BIT(type))
+		return cpumask_test_cpu(cpu, housekeeping_cpumask(type));
 	return true;
 }
 EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
@@ -96,20 +97,33 @@ void __init housekeeping_init(void)
 
 	if (housekeeping.flags & HK_FLAG_KERNEL_NOISE)
 		sched_tick_offload_init();
-
+	/*
+	 * Realloc with a proper allocator so that any cpumask update
+	 * can indifferently free the old version with kfree().
+	 */
 	for_each_set_bit(type, &housekeeping.flags, HK_TYPE_MAX) {
+		struct cpumask *omask, *nmask = kmalloc(cpumask_size(), GFP_KERNEL);
+
+		if (WARN_ON_ONCE(!nmask))
+			return;
+
+		omask = rcu_dereference(housekeeping.cpumasks[type]);
+
 		/* We need at least one CPU to handle housekeeping work */
-		WARN_ON_ONCE(cpumask_empty(housekeeping.cpumasks[type]));
+		WARN_ON_ONCE(cpumask_empty(omask));
+		cpumask_copy(nmask, omask);
+		RCU_INIT_POINTER(housekeeping.cpumasks[type], nmask);
+		memblock_free(omask, cpumask_size());
 	}
 }
 
 static void __init housekeeping_setup_type(enum hk_type type,
 					   cpumask_var_t housekeeping_staging)
 {
+	struct cpumask *mask = memblock_alloc_or_panic(cpumask_size(), SMP_CACHE_BYTES);
 
-	alloc_bootmem_cpumask_var(&housekeeping.cpumasks[type]);
-	cpumask_copy(housekeeping.cpumasks[type],
-		     housekeeping_staging);
+	cpumask_copy(mask, housekeeping_staging);
+	RCU_INIT_POINTER(housekeeping.cpumasks[type], mask);
 }
 
 static int __init housekeeping_setup(char *str, unsigned long flags)
@@ -162,7 +176,7 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
 
 		for_each_set_bit(type, &iter_flags, HK_TYPE_MAX) {
 			if (!cpumask_equal(housekeeping_staging,
-					   housekeeping.cpumasks[type])) {
+					   housekeeping_cpumask(type))) {
 				pr_warn("Housekeeping: nohz_full= must match isolcpus=\n");
 				goto free_housekeeping_staging;
 			}
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d30cca6870f5..475bdab3b8db 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -42,6 +42,7 @@
 #include <linux/ktime_api.h>
 #include <linux/lockdep_api.h>
 #include <linux/lockdep.h>
+#include <linux/memblock.h>
 #include <linux/minmax.h>
 #include <linux/mm.h>
 #include <linux/module.h>
-- 
2.51.1


