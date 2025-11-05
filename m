Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CE44CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4A638E001C; Wed,  5 Nov 2025 16:05:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFA8F8E0002; Wed,  5 Nov 2025 16:05:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE9978E001C; Wed,  5 Nov 2025 16:05:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD4E38E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:05:39 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 924604B34B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:05:39 +0000 (UTC)
X-FDA: 84077784798.09.04019C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id E286C180010
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:05:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iz1hWSwd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376738; a=rsa-sha256;
	cv=none;
	b=EVN4f3lwlYIhvltZICJVb25cdn+vs3erL2J4L3t0YcVVRYtx70fsaxb3eOZRN+j37NfNtO
	cBz/s7Swzv6YMpNqk6DGv4J+5yz5KHuCVQ3LuO/53IrRY6dTzc2YE6ymHG3X9SPEZ8QiOP
	tOx3qDe7YRCkDFWQFcWlVGBx6WQVRks=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iz1hWSwd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JngCBVYahH+f3HbBVKxuSCIFfd0/MDlhC9ifcJOFVIU=;
	b=mDCNbiYFC3yLf7hLwA0TqKgJZ2wDQ68juIIyHReg4UEBVj72d9VKf2Impj31OCczhPwAv9
	xnEwnx0nEvk0hS7E4tw5iR3Fyl2WhC3JCWgejnP6zCMB65BZ2/jyMH6S4P6iuOUs1hZUdI
	3KkajfGe61GWXVStcFW2mXFq0l7/VgQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 11966409E3;
	Wed,  5 Nov 2025 21:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAC4C16AAE;
	Wed,  5 Nov 2025 21:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376736;
	bh=ZZ+yP0oE5nMuQO76ubRYWghmJmjtLp6J4+mGRrvjt9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iz1hWSwdNKtj6UL9xcFuZBN1Kztkumf9wbEcmW5UjeJ2+UdL5tz673c7YJbvnt7/W
	 c/EsY/6qjrORrgn3JfyeSAFSA6yfuYj5MTyOVvQkADRrio6BIJnZRu8YgpBrNgVOTQ
	 eB/pL0KTpvOBNIGNkXD26pikUAULqAaaEwLWkA8jIkjfsA7l7XWyC38MgQB4N6su+k
	 xJuzdIt/BEh9tFL8ETLq2lHz2UCG4Z9ajVxdFB5FH9oWQbaVglAAEfr62yb7elqNOG
	 NuaQirecRskVf5fcOpqOIlmu+m4oVCOMYMKsiFs1KZvDxh3o6NbGgk4qDg0Xqhox9y
	 ldKy71009PlQQ==
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
Subject: [PATCH 12/31] sched/isolation: Convert housekeeping cpumasks to rcu pointers
Date: Wed,  5 Nov 2025 22:03:28 +0100
Message-ID: <20251105210348.35256-13-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E286C180010
X-Rspamd-Server: rspam07
X-Stat-Signature: 4akeopjosx9tr6coraa63fk9qz4bqhx6
X-Rspam-User: 
X-HE-Tag: 1762376737-204544
X-HE-Meta: U2FsdGVkX18NCG9eR/JmyqU3eeCaTOPY2AlQ2NQt0gogd776o3GtsM6FvhHa1IsCKCBSFHsCvVDfo+qD7ywFX/VozVzE+VA85yaXfK5wUG5l/hZNxypFNqoQfKHvamoXrEmmYcAfvsInZE6kq1wm451JGlHGYWoxiCqp+157w3xehxNSFHLbltNW0gbDPwCtlXnqGdMpbbkdw0iE5SLfh4iWeMqXyvhAc8RH0N0wMp4+upY1CmIiP2L9kUzZ/9vroWC82/qB5CQcqH0goXuvVz59rb/IQCGLYBf4JSOvNzBdDwfwbl0NH37S34r14N45NSO35D+f92ILxnObBApTNMhXiBD3STKl/ykFn8e7JViJR3tAE+jXaWDTEg3fyQlJh8EqWcvVp2bMODJvRkK+iRxG8UBUEhfkblxCYgl7HrXqCJYNF1IHbEF1ZJeGD2nud5RlEHT6dOjK3Ryo1FqNz76vmeFW7E3O0xrZsTFA+2IKUTXotVi9s39WhYCM+y6EDpQSZNq7mhTaMGtbD3YB3tkZSFpccfp/aRM2+GCSnp1n0QqPEviVu/TYZZBVq+eN7NSdKyi6HPbpx1LqpRPEWkB4bgfcnJXGgJRIQ+789iaifd18wnb6hULFGTn4y7YF9jC+D+m9ANg3VZALAGwCuGrqlaPRWj3gxG+36kpqp3eZzq4BUO/oqLb+NEDrpjS1rN+HPec8X9pL9CrQia3p3EXK1dH0Fgxsx12Oqsur9CfhEihmyf5ZAHqCQsUTcZcyyzkqfS4q1t67rl0ZYzKcaASDAvBm3CIVTfGBKOYNsB5AkqdrwBse/cjXMcp2xKAta/Ou2J8GMFjmpXsOiWU9oe16CqYL6SxVEQea895S6ztIvQgNM2BkYRPhgYvcdurZtEyH3PcogIA5OYLXOdzNhPv9GxhtAWn0GCtNLnz/stMm/zYwBOgXIPb2r7exGQGbOLuS3OYtRbnQyvXMH/i
 IXhraoEt
 aFayenxMdEn6a+x/6QTH7d04rm1POLj00GSoCv8Fy/phWYmKQ6BJxUhcBiyv4z4Kmp0llqf67sHJKeDfYZAM+6kY1ct7LTxF1M771mDr1DqSHwMpa41mzb2/s+o/pmvQ9pAqTnzLKJCJab7yf1qCvVkSChW3z/gnBTgxIqsRUjUco/qEFH8dCNRtfw87IZKNwvkKb7K1W+hjKU9fjAgF6Nz/gloXxxm4TeE18unC9sHn7V/3WbBYXWOOTLBCL3mSnk3NWi2I1mwLAYc0=
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
index 8690fb705089..bee6c04be103 100644
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
index adfb6e3409d7..2fc1ddde3120 100644
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
2.51.0


