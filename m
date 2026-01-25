Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54048E63CA4
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:48:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7E0C6B00B8; Sun, 25 Jan 2026 17:48:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B31516B00BA; Sun, 25 Jan 2026 17:48:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3D1D6B00BB; Sun, 25 Jan 2026 17:48:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9191D6B00B8
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:48:45 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 526EC8B610
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:48:45 +0000 (UTC)
X-FDA: 84371977410.09.8C447CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id BA441140002
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:48:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TzUio1oM;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RmqV6DRp1QA2gmq5uhvwAQxWafpDMOvqeDM0pwX4tYI=;
	b=U9qbZwsSnG0vLSwXHee5ZAVkga9bZVjNbA7Gc5vbVaykP5CBufe2IrFAF/9htpro0vfB1z
	Ive+UDWeU8IgWwfcbv4/Cm5p6fKmr4INlFS441AqzeLCbBUSXkhbi4gsWtfcPtxPEZ6osl
	rm7P6aHFPZ0ZebvVZ7B5azq+MszW6nQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381323; a=rsa-sha256;
	cv=none;
	b=TSq+7OIbQkAtSTM8VJn6gbH+RBmkjRg6rIzPFUyZV4VR1zF/gQkNQ7Ih9ltYB+VI4DPRAs
	cc2fvD0Y+abaGToy+ERgdiwTtEJ4DsHABvJWVLR6U2/jU8x+MytGEOcaTSigAcINAT/spL
	K3+NHENq30vAj0yOiuhi6m1HeOqXjqE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TzUio1oM;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 384676012B;
	Sun, 25 Jan 2026 22:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB11C4CEF1;
	Sun, 25 Jan 2026 22:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381322;
	bh=WKTkyJ8jkqGGb+tOllqXp0QcpTGdBE5V0vkm6c4cf8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TzUio1oMCuWVOr/hvPqMiqsDEXur3veTOeSjzKH5SJhpSu5gLojrq6uxIO5tlclaO
	 SiCD96gaiU92TkqXwpFUv3RRAkq4eBlkKX5uKBjCFDVi1cm1unbUjGTZ+9kU2Wfjtd
	 KDrYmqsLx8C7XLXXkauZj37AwwS31nm+n/bRg9u/Nk4m76hFcKf37mLb6dmzjk7Ppl
	 pmylxpjeNlfbUB5EOPOp5lXuGjklgvtZV0OO6PQX3kuNdvbY6qOY79Hk4O3YYJgzuJ
	 mgm+qdkybu70yYD4RucYWWjlWCGeSlwRbZp4yhSr/eMyxELihqv92ku8xePYJ2JTss
	 lNqziVulJBoxw==
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
Subject: [PATCH 21/33] cpuset: Remove cpuset_cpu_is_isolated()
Date: Sun, 25 Jan 2026 23:45:28 +0100
Message-ID: <20260125224541.50226-22-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BA441140002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: sg1dgdopd5w98bin6rd6c7s1jrtz8t53
X-HE-Tag: 1769381323-195861
X-HE-Meta: U2FsdGVkX18lczvrKOlNArS7S4aOQYD9O7fMm0U6aj3yHRvs2CHw9mob/TfkyficYLYWzjDigWorfHGU7Rn7BJMdphNYgeoaWxB2giECSAXhml5C+QjKFwv2nf9i5JnckKlVSxA2nKBGACld2Gx9Nk6lVzhAsvj2X1IMYjugJTlwm3XtteiXPdudkDJqY6ljlJZDi6JpJtRJiKNz4b2IeD5vGFxLs9GGb8N6GfrT8Nx5xoEVLxP5bTDCjaVFZ0YTRFZ9x96fByF2smoqgy+EqIdWoU5ler5zVqzx0bpVDcr1AGIu4M3IsIhKcuEpfyJ+U61MYpMctM5GJxJ32wf2bKim3JjBgtqon15Z4BaQlnpLZGM5F0c3FDzSlbh+d+Hax/k5UMzBDL2UO0771K6mzMhcZgcy3lCiOcmt07ot+4EbshkGr5Kf0CMgRw/FayLyjnWLsXcA4PnoMAM0TEIsy/4GnVoH9EPQr9q5OQ+HCJbw3vMKwc6t9IZvVQm42CrPZXMOSzP9ia2Bz8oLvhoo/ToFBb1ZuxK2yDe+tScg8eU9aQim7b5VPa6P8SsMxopaBTiICs69R+TjdCw1cjfStnICrtBSVvyDhMbHnIwQ+wls5pGwN1/jeyz05Ns4vGEhvVukvYArW4z6PA4VQJ8Ogfb/4yKfU4QcRb9esSMUypdS1gBwEnsLKKtaxyY4cEw4vQ80Qu5RliKwxqePhZnud+8o/P1dV1T7dn0yno3omFDVx88CVAigXxAnlfkBhhUslTq2zUxtB+Ys45Kh64uzpIhCpJwH+ZPrTxdaZRsVtx+zPct40dB+jU6yMMtNl5k1sAtrcbCpe3idVRLQytVSs1Ftq3n35tMEQ6lP6qWOmv3v+mIfsf1KvrKcjW/021oyWAtFkTihmCZoNqR9kqJMJc3C2I2b9AjmRCCBTYz1e+JYV7RwpHYOIjvC+iVpx7u0LFxx5KkTDrsSasxeaY2
 c3c1QHiq
 n3+5dERqv0TQsxu+8g7/tTtnigQjFu+J5R/xXyYmi2+MxxgrhdkgxWJDutIPgciUWRgBJArGabGodLsoh9In3KXw5U8GKj2RiG0279heeTtXOj5AYx7lNhwWp9fINGJBjjkHEAjm9NyqNBT+rFluEFGasNcgPdd1cFVJxdHMx61uRS7pjutA9t7n1dnf/5Dyg3y4bk0dyMvOExnZxzDDcmFvBTWa801dnrJY/W/rfwDSJ7E+W7HhCXNNiz+2nEtEhH5On+knYBaRHU6ZFSk0zgLfNu9X1tYwyRqZ32tiGhnFVRlSB6rdutlxWrRJKqAGigDvDFHluQ7OHqk0P1+0d0x7gOaoaGKXtYvW/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The set of cpuset isolated CPUs is now included in HK_TYPE_DOMAIN
housekeeping cpumask. There is no usecase left interested in just
checking what is isolated by cpuset and not by the isolcpus= kernel
boot parameter.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Waiman Long <longman@redhat.com>
---
 include/linux/cpuset.h          |  6 ------
 include/linux/sched/isolation.h |  4 +---
 kernel/cgroup/cpuset.c          | 12 ------------
 3 files changed, 1 insertion(+), 21 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 1c49ffd2ca9b..a4aa2f1767d0 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -79,7 +79,6 @@ extern void cpuset_unlock(void);
 extern void cpuset_cpus_allowed_locked(struct task_struct *p, struct cpumask *mask);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
 extern bool cpuset_cpus_allowed_fallback(struct task_struct *p);
-extern bool cpuset_cpu_is_isolated(int cpu);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
@@ -215,11 +214,6 @@ static inline bool cpuset_cpus_allowed_fallback(struct task_struct *p)
 	return false;
 }
 
-static inline bool cpuset_cpu_is_isolated(int cpu)
-{
-	return false;
-}
-
 static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
 {
 	return node_possible_map;
diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index d8d9baf44516..d0fb0f647318 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -2,7 +2,6 @@
 #define _LINUX_SCHED_ISOLATION_H
 
 #include <linux/cpumask.h>
-#include <linux/cpuset.h>
 #include <linux/init.h>
 #include <linux/tick.h>
 
@@ -84,8 +83,7 @@ static inline bool housekeeping_cpu(int cpu, enum hk_type type)
 static inline bool cpu_is_isolated(int cpu)
 {
 	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN) ||
-	       !housekeeping_test_cpu(cpu, HK_TYPE_TICK) ||
-	       cpuset_cpu_is_isolated(cpu);
+	       !housekeeping_test_cpu(cpu, HK_TYPE_TICK);
 }
 
 #endif /* _LINUX_SCHED_ISOLATION_H */
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 080fa2fb10c7..801694de82a3 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -29,7 +29,6 @@
 #include <linux/mempolicy.h>
 #include <linux/mm.h>
 #include <linux/memory.h>
-#include <linux/export.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/sched/deadline.h>
@@ -1488,17 +1487,6 @@ static void update_isolation_cpumasks(void)
 	isolated_cpus_updating = false;
 }
 
-/**
- * cpuset_cpu_is_isolated - Check if the given CPU is isolated
- * @cpu: the CPU number to be checked
- * Return: true if CPU is used in an isolated partition, false otherwise
- */
-bool cpuset_cpu_is_isolated(int cpu)
-{
-	return cpumask_test_cpu(cpu, isolated_cpus);
-}
-EXPORT_SYMBOL_GPL(cpuset_cpu_is_isolated);
-
 /**
  * rm_siblings_excl_cpus - Remove exclusive CPUs that are used by sibling cpusets
  * @parent: Parent cpuset containing all siblings
-- 
2.51.1


