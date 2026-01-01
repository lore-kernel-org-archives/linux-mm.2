Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D342FA3722
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:16:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B326E6B00AB; Thu,  1 Jan 2026 17:16:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF29C6B00AD; Thu,  1 Jan 2026 17:16:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1C086B00AE; Thu,  1 Jan 2026 17:16:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 890A56B00AB
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:16:12 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62007D099D
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:16:12 +0000 (UTC)
X-FDA: 84284804184.12.7F96FC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9B2FDA000A
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:16:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Or8D/OE3";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305770; a=rsa-sha256;
	cv=none;
	b=uKeBC4wykghei04QFQtwPuR5e+3vKN4fVTBylyI5gHaN6FxcWvHqe3uZK+kUe1BC1AKSYZ
	BaGx8LtGLnerCdCtYDsxMk+c4/eMsp6lh0Z+P+twR6F8Lv4MSsBXS5vXK9Sbj3NvE55aWn
	V6AZ01WiKE53xe1WxlSQiOqnkZvO2Eg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Or8D/OE3";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ttMomK3m5ZfNWUQ9iUaUUD3mG3b+KoHZttiXKirGg+U=;
	b=Uts76dgZVhe+D/B6LbgTLrKykYtiwlGd61KO1QgYXDXWC9/eHN4dEnjzPryIURb+iI2U4y
	Qy2MPiRUc1RD7h2cgKDR5Z7tIacV8Heco6ZgNEqBbVBsL1T+ssV19gsztAHC2clYik7aQE
	IEYZiNndY9WMe3oyPBwxn0WIyNFnNRI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D5C164030A;
	Thu,  1 Jan 2026 22:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F599C116D0;
	Thu,  1 Jan 2026 22:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305769;
	bh=VAVvGGk/hiYe7kjBfHlKrxagm/s+WZiujWOCUr5/KMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Or8D/OE3F2iQfSIvSaoXDKbg9oFgW+rpKcnzQGY+gFnOYUZtRGV7UtWFFP4izlopy
	 4CK5PEd5uY8upkFN/kQtdH9NOegBYBZZ8SfOUzzakWo1O3NkV+T0hwu8HrFu4q9Oxb
	 rwXkJmmLrN7Ge64/Ly858e+xoEkjVByZxPUipVCsr5RC3qsPe+tf7JJphMS/wGTvu8
	 XNqcBnyDOlLj336DWBL66IwkB09N3yCqTVSbH6QpElPuD7lQnLPkjpsL6jynORQMzM
	 wKesaDtmsEvmS26yYyguSew9HsU1mX++gy2/wObf6BqsrRbV6/eW9m/euUQgjzDQsz
	 J60SHWUw5RlRA==
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
Subject: [PATCH 14/33] cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset
Date: Thu,  1 Jan 2026 23:13:39 +0100
Message-ID: <20260101221359.22298-15-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9B2FDA000A
X-Rspamd-Server: rspam03
X-Stat-Signature: 1brgu4n5rradkxr7wpaoyh5i8oiom7jg
X-Rspam-User: 
X-HE-Tag: 1767305770-314703
X-HE-Meta: U2FsdGVkX18c1yO47uorBJg1oRo99/Dhj4uoTL8qylzjqgJB7XZAaltFFI6VSAbmlhw6drwpO/kwznK9g020f1e1G0R9dkSWk2o1kc0waPPQbi1t2lRPfC5Mt/cgFyy9hYYJWKnQ8V8d6WNRer1RJYkNurwuhYVz5TKCMwSuu5RMKpqyqdBGGnrsXlMrYXozP619V+hgtkYnOopvQuGzaeDhZ7XgO5gzX59wgkConMnfFQASpyXCAu1isCU7icXXr9ZRZA7wP2DIDD2t+ewhZaoqZ7Aa4CV3ImN1yu8N2ZOroO+aeTGMEyzDgu4gq96bYwLWnK0HAi516E7TSpoqZJskIAiN0iNvWl/Ev8DTZUH69+emKMBXVM2/N6chySCagoNXnOPllz0IZM6SIx0a3cDAmcHIgigeZGXqocnfnDIlt2z/15nYyku8i815XKgWFwjzANLfyCYij6yFHBrD7pk1ddyVqXDHRqNRNM8D56kyU78JncJkx35Njg9FRGt6+7hw2k+rr7ovfX+ccIyUW+T8OWrAjGgPloCZCFxvViDHrshmB5DYig0IvpaWhlh3SvNt4PFvVX8IvxjK5zwaeH4Wepk8PCYetziOXOVLetbPsi/8zi0nyWpZq602cQTeacZ8WdZ6BitrYIX1sTycYfJHIPRL8/YutVL3ph/qtHzFvgoI+90U1fER685suAevkn5BEqO6HWs3eJgHMsgNdykRnj4UZrxZHkV2hrRB2jKhVi0Jcly/8aLmRHpDQDmp/QJ4vfCGWzqGtK3Gt/FcTXwuxrGJLLhcey30G8wzGe2DySmJ64Skeo/i2Lo/A02h+lXuHOItC8ZqC5nXd79LTQccbW9cbCaUvAvPui1x3xzq2V6PsLCHPy043di0QrOaC9JRDTuZ0STrw/7Few+GIEq25binq7nxTI17a35SB2t+GWRT+NpUVMzqGIeevqx6+1zhJR1gyLdxaT/lsCq
 Q7ermOHo
 aqd69KIV3NkN9PqIekHq0CJR9uuunZa8Y/UcmGyFAbnSJEkxp5xpG8ejvky5l/sMeB+EFCYt/hlJt4UjuGe4tJoCRMRoEfSWOf4kIT2VuTpAZUxKohWmoq4oPiZWSwlDjYaA4ussdXx0gTGp8afvYXAwfIkVrmSW4KJ+vOykpUf+oAzvNyFWsUwjYyFS4SJeusnxDQeypAJ/sehqrreTRrrIdVbtv6m1ObMWXlSfKO9Y2JJ+NgIitZp1DmPBgWzI9uYjhUJEPu3fQceDy+dPT1LYTXQQlFgDSKfBWxGV3Ao7ZzB+k4AeyQWBrevK2u8pQyYWtpRPdx4SQFd49XzFtAZLNbcmvZqdS8Zb61EKxZexNI7ni1go2Ie6ZEQ==
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
Reviewed-by: Waiman Long <longman@redhat.com>
Reviewed-by: Chen Ridong <chenridong@huawei.com>
---
 include/linux/sched/isolation.h |  7 ++++
 kernel/cgroup/cpuset.c          |  3 ++
 kernel/sched/isolation.c        | 73 ++++++++++++++++++++++++++++++---
 kernel/sched/sched.h            |  1 +
 4 files changed, 78 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index c7cf6934489c..d8d9baf44516 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -9,6 +9,11 @@
 enum hk_type {
 	/* Inverse of boot-time isolcpus= argument */
 	HK_TYPE_DOMAIN_BOOT,
+	/*
+	 * Same as HK_TYPE_DOMAIN_BOOT but also includes the
+	 * inverse of cpuset isolated partitions. As such it
+	 * is always a subset of HK_TYPE_DOMAIN_BOOT.
+	 */
 	HK_TYPE_DOMAIN,
 	/* Inverse of boot-time isolcpus=managed_irq argument */
 	HK_TYPE_MANAGED_IRQ,
@@ -35,6 +40,7 @@ extern const struct cpumask *housekeeping_cpumask(enum hk_type type);
 extern bool housekeeping_enabled(enum hk_type type);
 extern void housekeeping_affine(struct task_struct *t, enum hk_type type);
 extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
+extern int housekeeping_update(struct cpumask *isol_mask);
 extern void __init housekeeping_init(void);
 
 #else
@@ -62,6 +68,7 @@ static inline bool housekeeping_test_cpu(int cpu, enum hk_type type)
 	return true;
 }
 
+static inline int housekeeping_update(struct cpumask *isol_mask) { return 0; }
 static inline void housekeeping_init(void) { }
 #endif /* CONFIG_CPU_ISOLATION */
 
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 5e2e3514c22e..1c0475e384dc 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1490,6 +1490,9 @@ static void update_isolation_cpumasks(void)
 	ret = tmigr_isolated_exclude_cpumask(isolated_cpus);
 	WARN_ON_ONCE(ret < 0);
 
+	ret = housekeeping_update(isolated_cpus);
+	WARN_ON_ONCE(ret < 0);
+
 	isolated_cpus_updating = false;
 }
 
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 83be49ec2b06..c61b7ef3e98e 100644
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
 
@@ -80,12 +110,43 @@ EXPORT_SYMBOL_GPL(housekeeping_affine);
 
 bool housekeeping_test_cpu(int cpu, enum hk_type type)
 {
-	if (static_branch_unlikely(&housekeeping_overridden) && housekeeping.flags & BIT(type))
+	if (static_branch_unlikely(&housekeeping_overridden) &&
+	    READ_ONCE(housekeeping.flags) & BIT(type))
 		return cpumask_test_cpu(cpu, housekeeping_cpumask(type));
 	return true;
 }
 EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
 
+int housekeeping_update(struct cpumask *isol_mask)
+{
+	struct cpumask *trial, *old = NULL;
+
+	trial = kmalloc(cpumask_size(), GFP_KERNEL);
+	if (!trial)
+		return -ENOMEM;
+
+	cpumask_andnot(trial, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT), isol_mask);
+	if (!cpumask_intersects(trial, cpu_online_mask)) {
+		kfree(trial);
+		return -EINVAL;
+	}
+
+	if (!housekeeping.flags)
+		static_branch_enable(&housekeeping_overridden);
+
+	if (housekeeping.flags & HK_FLAG_DOMAIN)
+		old = housekeeping_cpumask_dereference(HK_TYPE_DOMAIN);
+	else
+		WRITE_ONCE(housekeeping.flags, housekeeping.flags | HK_FLAG_DOMAIN);
+	rcu_assign_pointer(housekeeping.cpumasks[HK_TYPE_DOMAIN], trial);
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
index 475bdab3b8db..653e898a996a 100644
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
2.51.1


