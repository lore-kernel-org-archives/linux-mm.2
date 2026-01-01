Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF27AEEB57B
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4578A6B00AD; Thu,  1 Jan 2026 17:16:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4189C6B00AF; Thu,  1 Jan 2026 17:16:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31AEF6B00B0; Thu,  1 Jan 2026 17:16:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 207CB6B00AD
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:16:20 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D7BDC5FA7F
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:16:19 +0000 (UTC)
X-FDA: 84284804478.06.0DC0085
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5508A1C000F
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:16:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tE9ASF2s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305778; a=rsa-sha256;
	cv=none;
	b=eE3BhpH9nkmxQUA7ttksPQWr7qeYX5x9xfReI+dXCXUtjdKRU1BqOdxD+mJpdvxMGoEyMt
	b5jt5OfDp/bSIKcLuEMgk0oRBppSnyzLm44GqtChSsvNvIMBmg+LQjIjrF0QUjassWdo7u
	OjnnBVQ2bv8FbE2Pj6OzxA/bty++9ws=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tE9ASF2s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hWyf8gs1utEyG6vS35w8SHr2v2ULDUam3ZRD0EIO8gY=;
	b=asEn84NIGFqD3nILLeFW7+/d/se4p8gjtUS1cTClqP+5UGfNt1MvmJ6wVEPk6BwNcw127P
	+gBOspyTiVb1aQDwSU01ZDIr7Sy68+qgRA+g3rrO++RNoplK84gTM80t7soze7lDOLddlc
	MbIYJu9WyJ3GdOIsAF4JXd2+hnQIUns=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D4A1760097;
	Thu,  1 Jan 2026 22:16:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D504C19422;
	Thu,  1 Jan 2026 22:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305777;
	bh=dl/Gl7INrr4v6VbmH2ZxbRJCGrPgSwdt0Po/w4pDxAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tE9ASF2sUjjhls9gA7k5g71gEtpYoRfUnZFPFHh3murIT3cAGCQrlbuYA3q7Vygaf
	 pUXdGKf8D/FpxTsH9vIINsIYaDEwekDRq1+dbT9B5ZKgPWrXm39XIVnHCQS2HdlrL/
	 B5tY4zv34wQKj3uOvnIxCNveQ5SIy8Pdzzz4UhJnfraBdfBnK2xCfB90p7LrRbch0q
	 p3AWNAk6UKrkLcFOT3mqiEdqmsdkyr9V/G/DP+c9e/ufCXoqliVrRjNS2Y+UCKdvYX
	 Ri88SSuI/C7wsddEehR5NWB5Zx76VDYmaM9jiJ/Usx2GOwCihgjnvf7CZ9jXjbKFrS
	 L7EjFh/Xthybw==
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
Subject: [PATCH 15/33] sched/isolation: Flush memcg workqueues on cpuset isolated partition change
Date: Thu,  1 Jan 2026 23:13:40 +0100
Message-ID: <20260101221359.22298-16-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5508A1C000F
X-Rspamd-Server: rspam10
X-Stat-Signature: 4xdz4ydgmz5ifejrtcqox1u8dexijqxc
X-HE-Tag: 1767305778-436536
X-HE-Meta: U2FsdGVkX18iJMfgUpz/2BTAP1jjztfsPVr99JdL20L/G3Hh3yzI8MxW4+YtIP0Z7Bniz2LDeLoKlq7F97OEuAwAa/3DhzjofP12odp7XRiIeiMl75doaZ7KN1/BEstTsOWcbDdFqW1MHZfzI+j7QO/H3oLSeztb9DMx0BJdZ/rlkfwgU9DtZstHMbaV2zN0ALlRdJ0XIAD8aERXwLyYjox5f3p4aVFuwh7zcfCl7Ikc1TvxjwSmwyFdm9jxlSETNZKCWyKaXEvJD9DY7SnbGkxvzCq6iN5OshQEqN9bT3xJ8WdvJoN43IXpTX5FahKZOr1KRZI7UrVcUu2FtiB8HAGO/CLqYQzLzmYu1p42Svn5XmJKrA2j8fGjLszblQU5JYuOwkSnQYsGv/QRmapDreaPJtHl3H9fVXcEBVSOWV83jAqUzlZBK+SWxtX8K8xh1VPxDQmdmzwQYtIbiap0O8nPsXcSLc7VkzJ3p95LmdKeRhRt8lf/jgW8P0+zJswXyZYpQKE//v83m103G6BsE5n6vk902x6aab8YmWv+2WZMg7csJBmByE9/ltjDWFgQQvDIOCYgZl72mup29T81/S3Z++y0VPpVhy81dcx7HJEJf60oINzmlJzWTq4eFm8nDVwVuyk9mXyGHflGz3iVlEHVVDtJvCRI8OZfsgJ7uSEROaVefOgbIdb7gDtobHHV+qalYifJLJseCX8ARwtfEcuJzZ2uzLAAjjcRzHCi0LUVcGHHE9e8ak/W3p6L/3lWcJyRCmVtJT5DLaJ1Ew1VcOdmNP+zMB1Dipg+qvygtlD6XYLu7AakZCLKYqai5ClzaBSY459koZC+xnFy3dvDxd11BUF/4Yhapz1cjfzns4A5mlbObhFAY60FmYYzZkmqdIrLvkwZt5Xgq7i4QIQFwXRMZqkp1g1+sA1jFvIpvGNPRHhxC21IX1/JVQcb8lF1GjEsyORJJZc+H6afxFE
 plBDJqqS
 C3C6kwsOTtUqzOW1sp1UKM/OTbgRu5MY+cXeicGoRV5dDt0MvcrZcOFKu+fGVusSWCvbbPPBP7EN9lbSQzNEFz+V4pv9smrKg3yavwl6KVjg1my0uOGfNM46D238l+7Rokyy/MWmtqHsTI/zAATRpbbQCKXm9zju/0QlbdvZoaJdyvgMxljL84qUKyOqlkMw05IuxKZiJukg6FPaBI9JlTz4CsS6h68iBVLT4HOOyMTp76cRNcM56maSTekySD1GkHK/7Gly99oas6/VaBpMWvdzPX4nWcALWUqf1rEFX0DdYt8tevURF3NIIVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HK_TYPE_DOMAIN housekeeping cpumask is now modifiable at runtime. In
order to synchronize against memcg workqueue to make sure that no
asynchronous draining is still pending or executing on a newly made
isolated CPU, the housekeeping susbsystem must flush the memcg
workqueues.

However the memcg workqueues can't be flushed easily since they are
queued to the main per-CPU workqueue pool.

Solve this with creating a memcg specific pool and provide and use the
appropriate flushing API.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/linux/memcontrol.h |  4 ++++
 kernel/sched/isolation.c   |  2 ++
 kernel/sched/sched.h       |  1 +
 mm/memcontrol.c            | 12 +++++++++++-
 4 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0651865a4564..5b004b95648b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1037,6 +1037,8 @@ static inline u64 cgroup_id_from_mm(struct mm_struct *mm)
 	return id;
 }
 
+void mem_cgroup_flush_workqueue(void);
+
 extern int mem_cgroup_init(void);
 #else /* CONFIG_MEMCG */
 
@@ -1436,6 +1438,8 @@ static inline u64 cgroup_id_from_mm(struct mm_struct *mm)
 	return 0;
 }
 
+static inline void mem_cgroup_flush_workqueue(void) { }
+
 static inline int mem_cgroup_init(void) { return 0; }
 #endif /* CONFIG_MEMCG */
 
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index c61b7ef3e98e..b5f9f974eac9 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -142,6 +142,8 @@ int housekeeping_update(struct cpumask *isol_mask)
 
 	synchronize_rcu();
 
+	mem_cgroup_flush_workqueue();
+
 	kfree(old);
 
 	return 0;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 653e898a996a..65dfa48e54b7 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -44,6 +44,7 @@
 #include <linux/lockdep_api.h>
 #include <linux/lockdep.h>
 #include <linux/memblock.h>
+#include <linux/memcontrol.h>
 #include <linux/minmax.h>
 #include <linux/mm.h>
 #include <linux/module.h>
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2289a0299331..b3ca241bb1d6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -96,6 +96,8 @@ static bool cgroup_memory_nokmem __ro_after_init;
 /* BPF memory accounting disabled? */
 static bool cgroup_memory_nobpf __ro_after_init;
 
+static struct workqueue_struct *memcg_wq __ro_after_init;
+
 static struct kmem_cache *memcg_cachep;
 static struct kmem_cache *memcg_pn_cachep;
 
@@ -2013,7 +2015,7 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
 	 */
 	guard(rcu)();
 	if (!cpu_is_isolated(cpu))
-		schedule_work_on(cpu, work);
+		queue_work_on(cpu, memcg_wq, work);
 }
 
 /*
@@ -5125,6 +5127,11 @@ void mem_cgroup_sk_uncharge(const struct sock *sk, unsigned int nr_pages)
 	refill_stock(memcg, nr_pages);
 }
 
+void mem_cgroup_flush_workqueue(void)
+{
+	flush_workqueue(memcg_wq);
+}
+
 static int __init cgroup_memory(char *s)
 {
 	char *token;
@@ -5167,6 +5174,9 @@ int __init mem_cgroup_init(void)
 	cpuhp_setup_state_nocalls(CPUHP_MM_MEMCQ_DEAD, "mm/memctrl:dead", NULL,
 				  memcg_hotplug_cpu_dead);
 
+	memcg_wq = alloc_workqueue("memcg", WQ_PERCPU, 0);
+	WARN_ON(!memcg_wq);
+
 	for_each_possible_cpu(cpu) {
 		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
 			  drain_local_memcg_stock);
-- 
2.51.1


