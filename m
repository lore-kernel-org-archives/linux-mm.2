Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CB42E7545D
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D339C6B00AF; Wed, 24 Dec 2025 08:47:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFE576B00B1; Wed, 24 Dec 2025 08:47:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C52F96B00B2; Wed, 24 Dec 2025 08:47:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0A7B6B00AF
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:47:43 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 71DDF89650
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:47:43 +0000 (UTC)
X-FDA: 84254492406.10.91223C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id BA766140008
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:47:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kE4lmyVY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584061; a=rsa-sha256;
	cv=none;
	b=Ltqly12vOFDnc/eCE5eOwGu3GyinOBlRL0n8BWZWYFzdrS9Gy2PlEw38I7VvyDrkHhtOSl
	nXtbRiH+OkQt9WA656n/CIk4qojfyG/yrrsyR1zpIicp8fXljioiSBnMjOQxYMHTT4W/ZD
	2tTVQCRD60yPi3rrahPI3dAQG8RnHxU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kE4lmyVY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3yuKIsaECszcJvm7sEcUsVB8NU09WdxsHDWVT6WZlXY=;
	b=Yl39DfTD8QS2c6nVHAhkS3rLWFnMSf1fCC9dOKy2FKn7DklNa+hEftczoY/Jm8FXWWg9EN
	2k8HfwqdgKVG57zIfSn7s8c9CaI8lKw6Bjkov5pDx32SmHKMs99m/zg4V6+EFv0e2q5NMw
	JlUNBcw7I8FKFXB1eB/H3wtmntsqPZg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E6E5242B00;
	Wed, 24 Dec 2025 13:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F251BC4CEFB;
	Wed, 24 Dec 2025 13:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584060;
	bh=xO6EwhUZh8OcDIryDj7Wm/j7fSsdSfUbDLBqDZdL1Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kE4lmyVY9L7SUV+YO6U6zrFhuuc+nJunhNNyns5z3QEPme4MkwloUl1uWfJJZhFCE
	 14yBX8qKYdhhjBk4awDDQ84foJYyWO055ytUAypzr6qRdgdTp6JMBX5SHJgyPpTHmf
	 MZNjjGM5gppBcP7Hyko2vjFgBZueQi4ad9pjul8so/5XvZ7lqhkttcW5AeiXyI7XXa
	 FTLICigGKI8g6jzt5LTqcHSYsUxHPTrLhc9oS2oD9hISoczLpLx2+ckmtqWtY9MZkm
	 CDeH3KzfbDrqG2uf3x4OFxZhxicYZPbLZbenrNwW1GKOEwciVwUJ9kHg5OLoVS4Kyc
	 NY/rx9lg1+BeQ==
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
Date: Wed, 24 Dec 2025 14:45:02 +0100
Message-ID: <20251224134520.33231-16-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BA766140008
X-Stat-Signature: 5g1ssor7pnrj9j6amqibgwrde7asbijq
X-Rspam-User: 
X-HE-Tag: 1766584061-775235
X-HE-Meta: U2FsdGVkX18WYo4utIJz5Wb56erGrZzeygri0FJM70Bs7UfMbZVd9hsF7cSOFnaPbTU7WEbfb4YmwOhnyvJABkKwFy2iPJQI56AL+9eVzrdVt261oV3fXYP46x4m/1TrSTD3/pkxGjYJUYQmRXtA+QrxGv6KbE/Dht+eusoA073hBjTkmtuBEuKwzf6zE3Xhb79+7TiDptA9Eik/Sgfp7+xsgHKahIpo8EHy0DHGSYK8OTkYiis3tU+9QIym4J9hJySHQTlZVB1FAW6CknJkL4XXNP+ew8cxYfP2lqjkvn19KUZz3M0jf/FCN3FcEbNE+l+jzvEtI9wWZA78s5Ke69qSULaye2bQNff2ov9iSDd1Y6DqIrNSpcq+VY77qj5STK6OXgLFtfp/mMbY4caRMX9qpzPyfKSFf5yfSQ631ARyWE0O6axir2+zXpTpygf/d1tJuzNggCd6TA7Uvp9pMqBm+WajOVPY37xaodxxWj4n0isIHEyDvfAHgMEcbQEu8BgFBavSQA4QUfbyA2LrMIFPcC1YYOzEM+3hx00fhIitpbMU0BFJKUrfYJBVEkhH4VwLMIBksj7uuczCA1GcSmxX+daEAPlJ1/qOQpTDT5AmKtRQ+G9Llm45OLG/emXLQfbS1ZXM2zbuyp/b+pAP7IH7RSJQ0DisJnrhViyn9x3W4Qfrgq8qdc0MVkuesobKpJTKV8HodC2U2W+VQPqa58ufAyF23e+YnFkrvsZgcORqU03ifnat6ioqa5LMCJKydszIOoAFnD2a+cx+d8Y5lGzFVEgtlcy5GVa6Ku8pBIXvNOuSVeFaThdRyXzCuhGq3RMtCqhD80fsxd5RHYr0iBlUdmuQ0B6yOfjnkruvp5dg2uBRcvrrymh43oDHsD1NUZkiwaGcVYzqREbk8V3KKFjTmsqA7t13s+zZHXaINYTn7fboJrNa1COykUs5fzPXjNa0AdeXl3o1OVXXLnI
 N6ONwFdg
 TLeVAQi5yfD9Xrw12KjtMNOQOawRDBNbFYWF3kku1Odc+P5E/F7eaMKrtxVZJA6f4YsBWPlAgUBsX4ukr5IuXXfYV2FCu5cXGmWhxMVVxAJnD3gE5xYMkU1JttuHVC4bq1WNxxs+3aTMN2htVvI6ovbETaKg920Gy/NLqvncn17E4cinOLjlS3YSEFU/ifwzTXQc7XXD8oF3gcjNbDDOK2RzO0ULTqQzMWjr/W8tw/HaC650fVffVy4beQY6eoHhly+F1pYuWJKt1XcSa+A9UgYvmPuVFOGp+x7tllgjt2To9Q2A=
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
index a124f1119f2e..bb6c36d2b97b 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -145,6 +145,8 @@ int housekeeping_update(struct cpumask *isol_mask, enum hk_type type)
 
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
index c3c473c3dfca..89bf93cf97b9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -96,6 +96,8 @@ static bool cgroup_memory_nokmem __ro_after_init;
 /* BPF memory accounting disabled? */
 static bool cgroup_memory_nobpf __ro_after_init;
 
+static struct workqueue_struct *memcg_wq __ro_after_init;
+
 static struct kmem_cache *memcg_cachep;
 static struct kmem_cache *memcg_pn_cachep;
 
@@ -2007,7 +2009,7 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
 {
 	guard(rcu)();
 	if (!cpu_is_isolated(cpu))
-		schedule_work_on(cpu, work);
+		queue_work_on(cpu, memcg_wq, work);
 }
 
 /*
@@ -5119,6 +5121,11 @@ void mem_cgroup_sk_uncharge(const struct sock *sk, unsigned int nr_pages)
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
@@ -5161,6 +5168,9 @@ int __init mem_cgroup_init(void)
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


