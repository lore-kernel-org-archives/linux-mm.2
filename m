Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA15CE75453
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:47:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F81E6B00AB; Wed, 24 Dec 2025 08:47:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BFC86B00AD; Wed, 24 Dec 2025 08:47:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40D4C6B00AE; Wed, 24 Dec 2025 08:47:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D4956B00AB
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:47:26 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E8D481A0225
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:47:25 +0000 (UTC)
X-FDA: 84254491650.08.08E0F36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6583F2000F
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:47:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j+0kp3PX;
	spf=pass (imf13.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=srr2Rd/TEcy3A2JJQDPXH1+aXxFy3yljG6lcR/gP5CI=;
	b=AuItgPs2KLxxzREyP60HC+eZPxue4aL8OLdxYMgXx9uGrAcThZ3sUo0wi+vcRVF8EiQVvz
	pf9qXOd9zealrGFSum9bW4TK9GHOHy8Iom8vPtThuTydIZzkKXpOlUMcuIx6trXM8CQLEe
	netxZL+qXZzY8AgIkrZNkqTSPqrBQVI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j+0kp3PX;
	spf=pass (imf13.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584044; a=rsa-sha256;
	cv=none;
	b=fJf3tExAV5ObD2Vq8ZJdDCewZpz8/S45hwx0dioYc0MTmsCyqT1ITJLwabRe/LZ9i5UIqv
	Q4pUdARsx8x5v7+udOwyK217aSkoVFPuPAEtzV0++/9amTQMhPjwLju8LCLlm7SWf9l1NI
	m7bYSr47udiEz31PpOIr7/poNQEyiM4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E4DD2600AD;
	Wed, 24 Dec 2025 13:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E31C4CEFB;
	Wed, 24 Dec 2025 13:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584043;
	bh=iE5HNXxcf5Yij69saaDAoVPz7iPaTsBAd7fg0JUxZYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+0kp3PXfL4fMYcXOUj1cc8tgE/z4aLg9deR40O8qj6JA02pU1GO35D4RicLAQ4z3
	 Vi9PPvhh57/Lw2GRBZcFeGl6IV0ToE4ficV44TIIEwSp+mjuaydtEFv/h2+AAbVdrk
	 kMaRwxNZeysgzFLOLMU01Wq1dtqjTuYmFpM4UJn69PqDttAd8b20oJBt/n5Ywj760a
	 Fh6r1Am3qgVxLfg7p3yhlJL9sJ0zhrSJcjJoKArtbDYKpaQIVpJ5pjLF1JufFcHOU5
	 jVbkTQGj1Kc0Ru0HHGaTgzOGYFwdNnRQnX7VIU7ZUtdL3fGLYyTljBCJ8Xn2auSZuA
	 xjPvv5BqhpJDw==
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
Date: Wed, 24 Dec 2025 14:45:00 +0100
Message-ID: <20251224134520.33231-14-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: h8rkxt7t5o1iq79jja6nk5tp14nqepab
X-Rspam-User: 
X-Rspamd-Queue-Id: 6583F2000F
X-HE-Tag: 1766584044-134586
X-HE-Meta: U2FsdGVkX1+4T0vSznN8IrR9dn0MPtv44VzNsRyYUAs4DzuXSvSOOyyYtWEAVSt3hlikJAk/WfkMm3r1sfTMyi1bJqZBV2OkeQ1X9sevKblMx2+XrHxOo7b4tZrmYf1kFw77SxFdyWT1ZYbveU/I936DtzD+NEfs32dvMRNCaHJnVHVJfepT0432TijISjFeKg84O9nDRGDlhcTYmTJRUV3jEWyaSK+TXYE5pM1O2Yy5ov4VAaqZOsg7Hmg/Cbzqk7ZCjGDqWY2uWLOGdRo7FMd0aRu+k2+jH+q8ciz1yaXry+sf+RnLWbUctKe/4NxvgIkQh2usmZmD/Cn8YiiUWn+DSpL8VAod6Vx+3nKN7DzhieQYRf3aPOIXpXohG3zwgKVQeYK0aZe2Z0uauWdyXfGX7zmszrQwIdA0od7p1raJcV6rKQ01RbmtJzSXQev3+a2AGQUNPN5h9KfRcJG7DUlLm8B01lhB1eyMVsQ/++VZfhAJWtuBn6QZL8N3CIL8pbXLQR6Hfodq0CtR5ExJtmeiqtmwf58+S6jWNlwQmAV17MCCvVZUdQAIU6p48L1IJqc7e4qAIkgI+9Z0fDyDb5nT7YBFtvWnZkgQOrJGA69Ndk0r9XAKBM9F0REKlgXqLkqnZqJGKhSO4RFkZoLuvw553iSGA8XWcJEOppwC9v7oqg6b4ALhct30Jej53nNPJMjF2+m2VHwtUqJATHgqwiYomhFfH22Q2wOUY7nd0fSkc2S/qACaVsJV218HvvoSwx7/1lB4e/69yPYVhcUlk1ITTLfPkV2ks0CcvBZ+96+rJCjCMvha6zEl7Q0yGE1DATxQqwIfKxCgIsSqYtIuAypn4dDovKUBAeSbOPGCy/kqm9xuOxEGvh+5Fm38S9UVzVxBIogQkWIlT6qUCL6pYcOftfaH1Aw/uiAK2PhzZ1T1lXp9ylvc49EbaK00mxKgpQAnPeJe9OEZGoEK7iP
 5hRa2LiF
 U5HsO+zR3zkmJ+b6NtOfr4nhYEqgW5i1RHtQ8wcyZt2Ar6Moh3NkUCMvNuDsaVuprKu1EfqXQ91W1ZOrZrTaocjwu/si7HjUratocPSvRvT2DRJQ4cHIYwO/5QfaSSbauoKxH+ZgnAdN40093iuDMcF1gHDpW5SEqr5ynQsZwFTaoo8snfNYiAm2K8BbteKh2Sn2PtBt0NkS9/Tbl3u3KGXQp1C31Oo6Y6efVi7Cmp90+y0Dpc9JCUGpBfsQOpRDG2BbPyLVQ/0bnwFo=
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


