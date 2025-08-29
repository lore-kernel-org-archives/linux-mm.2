Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29AC4CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 15:49:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 705718E001A; Fri, 29 Aug 2025 11:49:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DD098E0017; Fri, 29 Aug 2025 11:49:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F36E8E001A; Fri, 29 Aug 2025 11:49:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4B7FB8E0017
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:49:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C39B81DE8CE
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:49:05 +0000 (UTC)
X-FDA: 83830228650.23.D8CCE6C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4180218000E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:49:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C8AXhZl+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756482544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lgf/nXTOC12CQdegemFo8z5mT5AATTJvAmmLZWB2UhQ=;
	b=dx6FKnbxm4DFVZ4/c88gQwSTwHku2hRHTSPRrV85JDATioPQQwNCm34DIwjJ60ECPddFiq
	URQihUxYLxivPD9aJT3Z2wik3brmHu9DZJzIrmJNAnvPm3lpd09LKhqR4MOmcE71d1jFEb
	WY8M6yOoeSNJ2cSd+2782ShoWeVxJPs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C8AXhZl+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756482544; a=rsa-sha256;
	cv=none;
	b=fDPUwZvgl6mycD7MrOY6XQRoNc/E5mUmCpqsbI3xn8zIhQB3b9iLJjv2SAc7H8/x5bfvPE
	JIW1EPGMN12mKWsKB605csYEK+//TFZLji2eDvmNkGpUiUAyNKKaa1dYJGBkNcUM474Rk1
	9O96BHKju6WJzAHCKQRdCAT7M9C599g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C17CC6013F;
	Fri, 29 Aug 2025 15:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5F7C4CEF0;
	Fri, 29 Aug 2025 15:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756482543;
	bh=/fRsHmLrTF09mQZ2vEOSlW4cMULF+WniR3U+xY0TsLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C8AXhZl+gXT7Wn4j0WTzrl75mnwgtlWombLUDLZsESBSf1B1sbjpjnwfsvn+zVGE4
	 1k31OZAdZNpqkhpeMU6kbL3YO//pWMNEdGM8v6qGjRlUGQZPtmhefUAyVD4Lgo9eBo
	 SUAto569iRvjZecY1rEQI8w4bgovBDYW2mx70TPBAXYobui3Ew/e+7B2uWGQfU7BaW
	 8g2hpGYcq0tOuirdQu+z+nu0gLWlISIEIXTakrbzjAWze60tmue26KzabRJhD0F5eR
	 7yHNlS+5eup2c/DeXHLgHzG510t+Bj7V1AqmDMon7edVCGP2bG18HSD5dICpyTBGCg
	 XLCm26U0+Wz+A==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 15/33] sched/isolation: Flush memcg workqueues on cpuset isolated partition change
Date: Fri, 29 Aug 2025 17:47:56 +0200
Message-ID: <20250829154814.47015-16-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829154814.47015-1-frederic@kernel.org>
References: <20250829154814.47015-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4180218000E
X-Stat-Signature: 48fzosrh5bqjxam6n481moi9wmpu6ahh
X-Rspam-User: 
X-HE-Tag: 1756482544-258756
X-HE-Meta: U2FsdGVkX1/UWydKWhzuPcEArX/aMd5vK9FFoiwy1T4U+/EGceF5rIXByH85wJOwHJ4h/cGlT5G+9qp1H5Hvpg4owgq69Q92+En4FwgfuLPfyFkVCxqDZL0IyhIFwj9d6xjMEvGrzj8qLkUk6KQDm6uAoKWH4kYB4C88TWVEx7xreY2KC2BS9GQekOwMN/Ih0xLfph44JMhbjfsOJiB4Y3rX/SJXQElKLskkCpWx3PLRZF1eYu9anCiggNXi6FrCnuacTqAKj0APiJqzfbS9itDio0DvdLIDHUYuQ1aqShUnmOveohlZSNjUHtk7574JJZRnahpcOujoCkbpje0hOAGBKTwGUqbnpEz5pggBfVdGIQGwBuqmJkNQ9GrTsuaXr5amT7dD0wXn9iFg0bTK56Bi6GwF+owfVjK2FkyFTSiyMeIHeDEhg1Pk8ZEDJ7sR0C88IMYyL8+ILePl/QQkXY/jpUPpduOs5joMFtHVyryV0Ms8NtxH1Im23cJK6Mm3kagZVx84wI9k5NQsGka8l2Ojjtpe3zx9tV911RM6vQ0TIz6Q3O/vJahIML5M3kyD4gNX5Q49/6AI8ndYEBXMT4Vdxh8SFhwEO+UNaz5u/0wSEXFLxD6yjCLNKlJS04Q7z0hkVObj7cPSh4UE5niNzuNb5ERrOVtI49Oz/q88YGVFsFEf7pZxU0w7KzMhQX0dTp9uBRgtQQc+fvW6lnqnnB4eMpfO94CFH6JXE7hx5CCqihka0iNvhCScCbX++fcnrPkyewlzQvFvXz2XRn4hTfSa/MBm11Zp+p8s/+PXJFFQPZgX6qqsou8+7W5PZ0UBWKyEG9as0eKplsUETdnOgnIj8y3tY10V8vvrjchu5XJ5k7VjrrTcfBGhiI85QNN/bRG5xI6rcL4n7sk08pM/A74iosM9+qwyveN6sK0MTlzrPH5+KkMCQ+8YP86KUL/2yr0QZYE1dRSYWHRcYEK
 gg/IxKhx
 NCYTOlVUG85eI5XRjUC0GamN0kK0atwz8Lza8DzYSThPkfxO/ztqT6Dj5B1Q2Tw9i0VRHRxWNJivOUIGLrvw/EPVjQsxcT3KhsKAlFKC42FyGfiBwo8d80WmFNZlB8i5DgXB/ZnwyUs/HZyJUBaZro9bO5Bd3rlKghHguKHiB+6Ua+unsGliWz8vcc2dVSxRKMz73MnvZP8tPTRWLM0X3zNTPSt7QFkSZCTkh8O0ORMcaUgkS5hOKwxcsQlhfPHm3kio5AW83ET3mstQ44GK2bbrOmYcNuKD0999PQ87i7DK8Mgc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HK_TYPE_DOMAIN housekeeping cpumask is now modifyable at runtime. In
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
index 785173aa0739..8b23ff000473 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1048,6 +1048,8 @@ static inline u64 cgroup_id_from_mm(struct mm_struct *mm)
 	return id;
 }
 
+void mem_cgroup_flush_workqueue(void);
+
 extern int mem_cgroup_init(void);
 #else /* CONFIG_MEMCG */
 
@@ -1453,6 +1455,8 @@ static inline u64 cgroup_id_from_mm(struct mm_struct *mm)
 	return 0;
 }
 
+static inline void mem_cgroup_flush_workqueue(void) { }
+
 static inline int mem_cgroup_init(void) { return 0; }
 #endif /* CONFIG_MEMCG */
 
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 48f3b6b20604..e85f402b103a 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -124,6 +124,8 @@ int housekeeping_update(struct cpumask *mask, enum hk_type type)
 
 	synchronize_rcu();
 
+	mem_cgroup_flush_workqueue();
+
 	kfree(old);
 
 	return 0;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d3512138027b..1dad1ac7fc61 100644
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
index 2649d6c09160..1aa2dfa32ccd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -95,6 +95,8 @@ static bool cgroup_memory_nokmem __ro_after_init;
 /* BPF memory accounting disabled? */
 static bool cgroup_memory_nobpf __ro_after_init;
 
+static struct workqueue_struct *memcg_wq __ro_after_init;
+
 static struct kmem_cache *memcg_cachep;
 static struct kmem_cache *memcg_pn_cachep;
 
@@ -1974,7 +1976,7 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
 {
 	guard(rcu)();
 	if (!cpu_is_isolated(cpu))
-		schedule_work_on(cpu, work);
+		queue_work_on(cpu, memcg_wq, work);
 }
 
 /*
@@ -5071,6 +5073,11 @@ void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
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
@@ -5113,6 +5120,9 @@ int __init mem_cgroup_init(void)
 	cpuhp_setup_state_nocalls(CPUHP_MM_MEMCQ_DEAD, "mm/memctrl:dead", NULL,
 				  memcg_hotplug_cpu_dead);
 
+	memcg_wq = alloc_workqueue("memcg", 0, 0);
+	WARN_ON(!memcg_wq);
+
 	for_each_possible_cpu(cpu) {
 		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
 			  drain_local_memcg_stock);
-- 
2.51.0


