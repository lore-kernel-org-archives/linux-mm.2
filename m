Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBD58CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 499BA8E0077; Mon, 13 Oct 2025 16:33:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44A638E0036; Mon, 13 Oct 2025 16:33:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3129E8E0077; Mon, 13 Oct 2025 16:33:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B4958E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:33:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D01A8C05B3
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:33:35 +0000 (UTC)
X-FDA: 83994241590.16.14DB49D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 49126A0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:33:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bBvKYKbP;
	spf=pass (imf15.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OaepTOn4arR0l7L7HZ3JL4krXNOR+d6ze4E+sVKshWg=;
	b=NPMwOsxeVaPZs/qmRCpqUqDE1JfBKW3h05shmXIbgDKl2Anj8wkq2cI0aw3Sc1fhZ6RUg5
	XIIXLVtWmG7C8P18ydZuR8JxINYKhnm+EiH1LdJWdGiSiciy4xSSy7K6Qck9ttnI9t/3/g
	TphvJbDp877eWJoCAojMfhX3mfSBrao=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387614; a=rsa-sha256;
	cv=none;
	b=IuciTYqPlUQwmGPFjQ7821Z0nwBT2+0rCx+atjmJAFwvBXmcXS2fcUq/3FpzNb2gsaLlHB
	a0ohQpWg4LV0aV3HYeJx6RRkt/OfyF9de/v9klS/17Qpwgz8ZDTWjY0Hmw6eWqjO8cMAfl
	b37K/Bo96Jyczuix4oqUC/HLldAkfFY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bBvKYKbP;
	spf=pass (imf15.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C049161DF0;
	Mon, 13 Oct 2025 20:33:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB425C4CEFE;
	Mon, 13 Oct 2025 20:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387613;
	bh=kjiTGiJ7XGj13DphZPg8K9+3Qbvo5MsVAvIN7OOetmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bBvKYKbPljoS1rgueIakosC0OagPw2HPBcDldFxRvd9+bbrCox6vaQGbxcOL6m9tG
	 xoyBrjm/Nh0FFnjAd7i3etJtf/ZLEbsGLAeDDBUOqNXJqSmkrPSZlLkxY9bIf4JPL9
	 U+VaQbIi4dXiNCOvoTArYDoidezcJd9fqRHXgp5j0ooNZDsR4wO/FE5QvQip3XO04j
	 ewTO/wLoozPAAMnUeC5wGg3ZfnpU7aUW+tYLL3wEuJEpJtQXMu6ZxWPuyFeCOphPBw
	 b9MMLoew4tYeDVqV+8VVBAXKTyX8++POG+steTSFM6GLRWtT257YOcjP8qM2Z4tl6y
	 3wageBOrrScxA==
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
Subject: [PATCH 12/33] sched/isolation: Convert housekeeping cpumasks to rcu pointers
Date: Mon, 13 Oct 2025 22:31:25 +0200
Message-ID: <20251013203146.10162-13-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: tbbkbxxbqfxooz1wst6jz8cf3udrng6m
X-Rspam-User: 
X-Rspamd-Queue-Id: 49126A0007
X-HE-Tag: 1760387614-706940
X-HE-Meta: U2FsdGVkX1/5mDxWgVEhKxoOiOpGxGfLCPxliYl+PpL5hkna/SK2kJlQ5ZRuezZt2WMSVRalUUqgLWjtjQvHyGBNU5pt9MperCIwAEO+KAQQZZMyUKo+bsg3Xq6/kw372yP3nrE3yAXU81SDiK6JJtjlnKVi488H4jzyKkHZFZt11sjgrW03RtQivfJbPcfWkhXqa4qJAxVuiMnonKN5TkN1cc87bSmi8lbgD54rV0pVz/q1/FfJ6u5TdLXRZEh69c6mZV0VwxFpuLrUj9c9HojR7SuuWUoIUsrtdycn9bPih1HjrbVvw8xV8aRm4sGGZF1NMUBPJky8aRb69jXP0pWHuctu+E1U5BF3HRi9WVQ9248Iq65Lt9yM7f8ERnbE7GQ3R9g8rblDm+3aqLj6mtmHN3GZj+sHsXUUjUkC9xD1LiCLZ38UG3e7hwkuHVXtXiLJv0BHHluTi+2eLEWPL0Q4isZPs344xezvusO1ml4cSxyzrvKmmzCMMXweevxUoKV9kruyCl0rMe0nzbTsHZa+0mDEzxKATyHxdhdgAdyfNjS/TyXqW0/uPDm3E1prUDX1stQmGS1hlDyj3pQS9hc5w8RFYLKqPbFGJdYDY0n/xe3IWHch/FFt8Yktmamp3LIFg5kvV+kKeH7lDMQ1suv5x52baVxSN/90v/4fTg17Yp8a9RMV5qE1cWNQ4v8DIeUASop8BYWKDcUX48PNHo1K7oHxOUl4mbvLBTy7nwk4Bt4zVs4sll8YuqzczXzRbytxabmvZMACvaKjmNaryl3pRiLDNdWZClNaRRu3qkzQdkx9ZRPMd4nrNljDyFhOtKFQ4k9K10NigcP1ZNjfJE+vH829O/JwGT1wY/nbwrbH5e7ZyySZVxdLkbxb0amwOZQCmFent/NtHq01odDqcxmPNYL7jsbAZEIrkI4HkMsiBJ5aU5keGRYVaYl2zol3UdVBpB5pSWWpiyFJQJd
 i+/Hw1fR
 7M1+3zNpvMj4kkoMZaISLsj8NceAbolIsUgNPIKJIJTGeZOionRxoyO3ulQOpqGxcxXaKGb2XxsMV2n68Uc4dRCsQxWSlvk1vhsBO+rYGRKVigPp5j3ZUCPuIxgjS6z9spVsIVH+shMNJ85vwL38u4fqJSffIs15Ulyv0pa64GguGm4bJi7taWY1QOY4AZe+X26sezTHdC9FPtuG4Rla+f4fOq+PBWemK4CJj8gD04vtKU2IxrMImZQrU9rhuOXeJyzWAlw+HfGunOgM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HK_TYPE_DOMAIN's cpumask will soon be made modifyable by cpuset.
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
index 8690fb705089..b46c20b5437f 100644
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
+	if (housekeeping.flags & BIT(type))
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
index 1f5d07067f60..0c0ef8999fd6 100644
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


