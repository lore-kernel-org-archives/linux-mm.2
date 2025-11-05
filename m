Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CF51CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:05:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 068FC8E001E; Wed,  5 Nov 2025 16:05:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03F378E0002; Wed,  5 Nov 2025 16:05:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E98938E001E; Wed,  5 Nov 2025 16:05:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D92CA8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:05:54 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A01374ADE4
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:05:54 +0000 (UTC)
X-FDA: 84077785428.30.A76D2F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1388340007
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:05:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Knp5BQSS;
	spf=pass (imf01.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cTldLbnIn6jrSFHfrurRw6ltQwizAuMYeEEXXJIaHqA=;
	b=L1UIa1s91mkwGtpruEOA/0QGWb5K0eISFoouK6J36tQ63QYJtXa2jMq/wf7+hCJFhmgLKk
	LD3xFAa242TktHQ738gTLYJmV0crJjcNhJg3A6v4j0/hv5CWLYUuHwpbsV/TJl8JWf3gKO
	j3I2V5yUjusF/0XUQBNeRAPx9yXLfi4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376753; a=rsa-sha256;
	cv=none;
	b=W/5ipTP5hYxh1hdOvN7zgf+laJqPyzrueNBgxVVYnmOOGVbzxweGsnO9iNUkLb/0jHg/D4
	iIpKP+Y2BtkQeOfSivd+sHOm43KOk24/KaGQkYj5CPJMhFQlCfrzieoPaAXRPRhmui9TjE
	E4ndbVawNLCGgCFqyAei9bnqLA7vOIQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Knp5BQSS;
	spf=pass (imf01.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7C39B60224;
	Wed,  5 Nov 2025 21:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B768C116C6;
	Wed,  5 Nov 2025 21:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376752;
	bh=F8RS6HxMEwD+CdqqVcGXcs4QntwP/aQ69bm2ypLXfL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Knp5BQSSwU501i5GIxnOcbJwTVtyFd53ptT/lFssQbFaYhKGEBfKTkv46MZZ5eSe1
	 qxuJjt66g7Sq6NeQA6NaWjGbi56uDFYVJbvkh8/lprQJWhDZFDxww7qnbY7RQvWEfY
	 Z55jySVJI3FlCGLh99LtrKlkWqidLK9czXsitcbTscRVs7X079FoC9rzCZ0GfbpRMe
	 XaOAMs+/PWPGsjQXVydlFUcSk0jAgQIS8NvlcbuFOG8eu84588igVhduPlmyPu9p/v
	 UTgVFquC2M3nQSL8WmvFgWOMy0XwEQlYhFjT5Fker0h+UYE/olRnCJKAsljLmgJGLu
	 Zyqg0u8oNPkQw==
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
Subject: [PATCH 14/31] sched/isolation: Flush memcg workqueues on cpuset isolated partition change
Date: Wed,  5 Nov 2025 22:03:30 +0100
Message-ID: <20251105210348.35256-15-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1388340007
X-Stat-Signature: 7xi9e8mtxkm4q4sk7ebozhgrkqqajr7g
X-Rspam-User: 
X-HE-Tag: 1762376752-104666
X-HE-Meta: U2FsdGVkX1+7QkYT+KLvyEUzAFbi+SnLm1jFoYwwYiuom9anQcKuGZpHTu2XuPVsLaj+7+0ZalncOf8tPNnJ0/gdpegLbu1vtMJkpL/y/yDbARMwyFjoPwTDG40sAGiWTJO8RmmTtD2woXJ+KqziheZYANALl9x6HZoyS6V/E9St8UD9oXVS+yT4xYsrE3NQ1U04Olv579FScu0/nn5ZOAA9B1QEGZWSE7AVVC4/nT4pyW7hFkBF97XM1OOgNx2pRxYiTn5Zc5f4lvAhzFUifvcNJKXC2dpFyqUwpcI+tyE8mgxU5ffDg391QbF4pf3I1o1agARngGKAEokbqgOgsFcSSAw7noivveDYjlXi09DWAfGcLivDXawHm0uBEIwJToc+APRV0LsYy/f+Z0E6aaL7uf3eOLOV8HTbodsJI3tQyxXLeXJbTyVwNu4xKcZkAerHf3VAiMOMRMMAdLtbtf3ve4FDuPisyzgaVgh682as2o9KjMXq04NrbLb+GOO1qygQRiKHFb4bYhXCp4K+owb9qHNxCF99ZQHds7nmEXgL0LgI1gUDyh8ZtnKzN7P2rt2/LZxIL/6WrmkW9BU5dhU4zqk7eEXANxuydyH05+3vg/JsDGzRCZ+Hx8PCvaLHqsiFtyVYu/DLbOvXvCD+l/QrYKTQEwM9rgPWijO6+r18dR+Dl8dQ4pAtpvbwplkbtYnB4BziixKqEGX4AWh+RdeAUZ8tTym970QEkpc9bbSVsbYXFkUAk+pJOOJP1PlCAhY4J8bk65sbRdkXw8laDOkRvbFYvVRSHoZ7cIcPghO7sLR9k6JiPn3Oj4ifhKqztnTFtCtlHozffc35uVoqQQau5BpAPmeeg3GjY2msO5Rl6EQkb/AWeg/envoj99B3XlsdSEHpjW0ECW00Jgg4D09d4s2q4DjkbA9Z8hQoWDq0nKSikzR+98r0wW9+OnK/mkz6iLTVxZ2/ThXbHKB
 GC6ELcrK
 bw5+ge8ZveZb9M0w39oHiQ3dcS3yR4JhrsrYFGok+z8YNvNQOiBpp0RyVAs2uk3Jb0gTXzF5NSU7WuFSqEO0lBy2dHc5OK/t5LLIUhgwC5FncHr+dYDxmxQc8DNEQNmtdz3jdkldG3ArZ5gt+jBY/S+7kq9Vsg2EjL+yPXDRGw6ccFJ0D9uXXlG3pcLawmcV1KF57LxPvBZIcJwH4LC05YXurVaFjc9+eyHZNTaluBuSgurRu2Pf4mISeIe7MsafVzwV3xyLDmEGuB8+sXsc7yU7B+UyoInUl/DMNlqI7OO6buJ4=
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
index 873e510d6f8d..001200df63cf 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1074,6 +1074,8 @@ static inline u64 cgroup_id_from_mm(struct mm_struct *mm)
 	return id;
 }
 
+void mem_cgroup_flush_workqueue(void);
+
 extern int mem_cgroup_init(void);
 #else /* CONFIG_MEMCG */
 
@@ -1481,6 +1483,8 @@ static inline u64 cgroup_id_from_mm(struct mm_struct *mm)
 	return 0;
 }
 
+static inline void mem_cgroup_flush_workqueue(void) { }
+
 static inline int mem_cgroup_init(void) { return 0; }
 #endif /* CONFIG_MEMCG */
 
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 80a5b7c6400c..16c912dd91d2 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -145,6 +145,8 @@ int housekeeping_update(struct cpumask *mask, enum hk_type type)
 
 	synchronize_rcu();
 
+	mem_cgroup_flush_workqueue();
+
 	kfree(old);
 
 	return 0;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 5a44e85d4864..77034d20b4e8 100644
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
index 1033e52ab6cf..4d1f680a4bb0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -95,6 +95,8 @@ static bool cgroup_memory_nokmem __ro_after_init;
 /* BPF memory accounting disabled? */
 static bool cgroup_memory_nobpf __ro_after_init;
 
+static struct workqueue_struct *memcg_wq __ro_after_init;
+
 static struct kmem_cache *memcg_cachep;
 static struct kmem_cache *memcg_pn_cachep;
 
@@ -1975,7 +1977,7 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
 {
 	guard(rcu)();
 	if (!cpu_is_isolated(cpu))
-		schedule_work_on(cpu, work);
+		queue_work_on(cpu, memcg_wq, work);
 }
 
 /*
@@ -5092,6 +5094,11 @@ void mem_cgroup_sk_uncharge(const struct sock *sk, unsigned int nr_pages)
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
@@ -5134,6 +5141,9 @@ int __init mem_cgroup_init(void)
 	cpuhp_setup_state_nocalls(CPUHP_MM_MEMCQ_DEAD, "mm/memctrl:dead", NULL,
 				  memcg_hotplug_cpu_dead);
 
+	memcg_wq = alloc_workqueue("memcg", WQ_PERCPU, 0);
+	WARN_ON(!memcg_wq);
+
 	for_each_possible_cpu(cpu) {
 		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
 			  drain_local_memcg_stock);
-- 
2.51.0


