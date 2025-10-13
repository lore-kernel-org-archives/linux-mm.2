Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B919CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:33:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B517B8E0079; Mon, 13 Oct 2025 16:33:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B01FF8E0036; Mon, 13 Oct 2025 16:33:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F1658E0079; Mon, 13 Oct 2025 16:33:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B8B78E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:33:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4BF068829E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:33:52 +0000 (UTC)
X-FDA: 83994242304.30.6630799
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8C2E140012
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:33:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lcJiOQax;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387630; a=rsa-sha256;
	cv=none;
	b=nndNicAm30avgBY7Phkrfjh1t7YFYdwMOTdPmbldfKP51w3aMVQSvwXeAn2yOAEofru6Eg
	7AoL5Id6RFTxSj9KBO4jLMhQFy6/B36jQkIZeayPUYIVGcokZs2iewxKQc+6rvG+QisPD/
	b/Fui05eW57jacB73ogI0JgQvP9xvZ4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lcJiOQax;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0VelxAYQGPxzFRKppVbzVPDcRe9JLicWTRb3EEwT2w4=;
	b=ycd4UBbCSHD041JoWgl/KsKQClJSXClcnnsmwRZhDra0peEeJ5fm2dFdGXOcaU7fYpCmrZ
	9cENjAep/PSvJ854wZn9WZdwR26Pau2lK7iP61BOYEwHMo6YbjwBf5BorWQ/4GZqovFfN7
	4ZHlBYpo2H4yy5yJhyCHUJAes9g6KgE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F77948BCA;
	Mon, 13 Oct 2025 20:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11E6C116C6;
	Mon, 13 Oct 2025 20:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387629;
	bh=9oNpqgYjTcFMTbPZgxvfSlFc0ojQ77K/A/hD7MumAUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lcJiOQaxzRbm/vnW/7YplQp1SHR/EYlMBi81fjw8+ud9d0xJzG/M5ydBd35kgDQby
	 MGqZa1++jHkG6de3/IShSXu/VPNz255mdDROulIq+v6Msd8lxXjl5Zb0UU1z8IA47e
	 u6UfgSZdJL9zfVNfvzwCazayfzsHaagNZ8IfWgHaJNYwwnscuTLrgjDyCNihTr+akx
	 w+H3pKN0hhDNQa+5kpthY11CkItIJJx8FHnkJgmoyYikqWxZnes+oPl9WfT239ZviD
	 2FAqBS3l3+R+gy+jLzqrv5oDUAFlF0mcRVnV6DrqPx+70lF5/NxORiMhMXicUM8yH1
	 LMYrBX6aQoFiw==
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
Subject: [PATCH 14/33] sched/isolation: Flush memcg workqueues on cpuset isolated partition change
Date: Mon, 13 Oct 2025 22:31:27 +0200
Message-ID: <20251013203146.10162-15-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8C2E140012
X-Stat-Signature: b1z64ppknaffcy7ksq66uaj8ie9bkuco
X-HE-Tag: 1760387630-841170
X-HE-Meta: U2FsdGVkX1+ynY4B2f2b8ouf/jYKy/ykbIL4ldNsRI5T/PacBQjxqZYpVCmjTfC3oQeY0SGGthghL/oxDd3SZSotdsWNyEo0x+5VezRJht3R1pmf/1TlfltKdI1OVeEX6KKj4RdzSnp8hyPUcvl8O32s7qXgKnbkl88h2S5QCHUxZI2hewLMRwvJd7K7UJ3rF9StiSmm1drqWafwQhilJ4nAcJEY6NM4oo7YX5ZdGYpwrrvKhftfMqDz6gOyAH4JD/ef2y1hdwSAn2qJmWwlkFSyNlmJ+CT1VyBmtXBZAsqRbPY3xf/LAzMaZwlzfIwDStltufwAYBr+dv2FBBNvDT0AXsI4OiDcPb6z7jzh2h1ubN76Z1fAKzofL0tmhxhvQpdLkOSAiA69Y3NkFXVxPyePbSZVt1lNDKLY+UPnmA8m6+23YjSrhnlit5bLnNEebJPa1k4iN3ImsiEWW/Q4Y+Ql/qZLURgfqsvZdZBd4KgzIzLrHMAJcVXMKZ8oxLEaMN+eohrf97H2thm0Li2Vq17z7c1hlBSp6yw8gsVgCfF7jR1o0VCodM0nyIv3bG20W892yG5UeFwCc23R1O9MOmpSUnJbELi+V19TFRadnts1j/zAKImXqdu3asuAzVqfeBs+bIc7itI1AVc6r3fDudA1zyR6j8e3xoRlDJB7m+Ch82o7STA5hp9rZ7yUmL0eVDBEIaOp2BIhRPK09Kyx8MmNmN9YG9vKvof+g43LyaaqB/asmi/sawokR4voYbzpvPApv6VPeRbTgEqMyVbWcVaiaEnWNKOw4zPkzfQYdhnyKJJo7wSJe0gHCTq0nmhvBM993Ddl8+099sAHrGwplmAjA9bh37TK3ldrIgFrIJ+jeqr/YghZjgStKo4S6v8iMXzQZxKY0dxvLKwKx5AdczS0pWUxKlIZeIttUv+XCMM0kA9JnMOKNXX36WEFW3e4mQl0KBrAQomByj8AOzR
 WnyoOQoM
 dVqOPfJMVikQVroNUHWsxdktg/8l2QSJsKYdlHlgdpSUzT7yKuovw9SYhkRAVpO7BYEyrzslwZcDtiI54TKsRzfeTaCPPSubUHMuBqnNTErNKXFHOCV1ulCrdJNgiZD+nJir0BHLMjulLZIELce4XE8A9oeFL3MY3PW1SmwaVFs/gJGh70UguGtbWYiChaEbQTkcnPSjbZEpg5BwR8zlPnOon2He1IIuumfqjVer2UMROafsWKp6QpSyiub6shMifsdxTf4ALjVJn5B1YAEInjumyKlb80wwl99qpHaxMN2t2as4=
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
index 95d69c2102f6..9ec365dea921 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -144,6 +144,8 @@ int housekeeping_update(struct cpumask *mask, enum hk_type type)
 
 	synchronize_rcu();
 
+	mem_cgroup_flush_workqueue();
+
 	kfree(old);
 
 	return 0;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 8fac8aa451c6..8bfc0b4b133f 100644
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
index 1033e52ab6cf..1aa14e543f35 100644
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
 
+	memcg_wq = alloc_workqueue("memcg", 0, 0);
+	WARN_ON(!memcg_wq);
+
 	for_each_possible_cpu(cpu) {
 		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
 			  drain_local_memcg_stock);
-- 
2.51.0


