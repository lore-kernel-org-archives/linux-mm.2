Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C68F1C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B18436B0096; Wed, 16 Sep 2026 08:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC90C6B0098; Wed, 16 Sep 2026 08:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BB9D6B0099; Wed, 16 Sep 2026 08:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6DCA66B0096
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:58:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D9232A06D5
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:58:08 +0000 (UTC)
X-FDA: 85219628256.26.E8AD016
Received: from mta0.migadu.com (out-34.mta0.migadu.com [91.218.175.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id E18EE40004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:58:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CMoZcZZZ;
	spf=pass (imf11.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.34 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789563487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IREDM6qRMMXMMHjfNA1245rYOUvUnvgSFoBaR8Lc8FE=;
	b=eFHToCqPGKCUpAvL9V+VgSAohghpVA+yp3bvBWT4/3LwFoUNbeKJuyI+xLiTedmQoGZFVh
	YMCq/4bDtkua9H7G0P5VTFT+4RZDCVwV3umzZy2npQbKs2JpPBw0I+i65J3SE9yXTgBuL9
	4fvSsMNTNWKcpzTStx7hfAIJXTfv0gQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789563487;
	b=O+toLf2h/TXY4QJgbdhzeA7eo7vL8/jVvf6YluBwO+M8EhE1kEMDCQz4N1gEPfV8zo+mSF
	OzCO0gbu3yiaWIOMIRHqQh1oAxynbEVSyQL/W4fZ3gSETFPQRXpBjPpq4x68WXTpMvgXEu
	0LWf36QN6nEC9TM/qGUzaFUJokxWN4A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CMoZcZZZ;
	spf=pass (imf11.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.34 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=x4G8CKQzqFbSE2ziAjJFZkO1uwTfl21515t8rXdAgE4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789563485; v=1; x=1790168285;
 b=CMoZcZZZscnn7zqlq8VQ+UvWzD82W0Cbi9kmXy+T9dWumreOtBe1QhDlCHnKpv9CBWs3H5lj
 fU1whUiUT++1N836VfqTzc1wjv1rFj9SeGiy2zIsuc6sVJZOchmVvB/pGSlmYGrJDeKpcELLsg+
 0NQrW8s2dxT44ubMVNCTbzAg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c2437b5b5a0fcfbf;
	Wed, 16 Sep 2026 12:58:05 +0000
X-Mizu-Trace-ID: c2437b5b5a0fcfbf
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: hannes@cmpxchg.org,
	mhocko@kernel.org
Cc: roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH 2/3] mm, memcg: move v1-only members into mem_cgroup_v1
Date: Wed, 16 Sep 2026 20:57:36 +0800
Message-ID: <20260916125737.1095414-3-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260916125737.1095414-1-cui.tao@linux.dev>
References: <20260916125737.1095414-1-cui.tao@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E18EE40004
X-Stat-Signature: a8xbbmqtku3347anez4k67ufzcjf8w54
X-Rspam-User: 
X-HE-Tag: 1789563486-525096
X-HE-Meta: U2FsdGVkX186Fj8JkqOhLt38vRx+xLZpEqMM9PuGFPw/2vhjdM61KZu5QKQzvmbM5URlUgWlIrE+WWvElYlQs5SQ1Fe/Q27tyCKDJO7g+4Q1vgHZbvYzrHx5WDzjhkDKRJsjyJ4x57nPH8H5JLefwqv4/yEp6pdHlf+WCowNt3r5lju6KRLvlQKWNyEIaUfcEW+xUMWro+Cg0WBnDsqzrbZat3JXbr74cAkJ1s9MV3FxUf2JtfEmbHFnnkBZU7dNL4eLSux/ZbSq9T8j7J1L/PJENwqrbh+wxrwK8Hqy1vNWG14q0R0OWieIPNHwYBVJgqv17Nv0YeiV1caOnJEgrmMS2vXGyPdab55IH0h1bh0MptvcMRhAS8a+pojdkPMkFp460XpkS/lBk7fPOdRowJ0CeH8htkyzdxF/eXjhSvkgW/A8qVn0rcJh/U2V9uZgHN+87/UU4RX4OT43a/FrtnVt+tRwOfyW0RbZfCaVTPsM2Zb5WG+REsf6DFs261xLRAlnRMCLuuOaVh17IHlPvF6GM893i6iz8nENML7D3uKQ5LUvSRp9Xf/t4ZLtBLE8NHlkOoAPmPg45Pg5aVomPdNL9CuN4iNEW/zpgvXDWc1OJP6QnuBnxb3u1agbXzoOC/i0xGNj3GWSj1KMEfC11CghyhEClK9oOLp86q++IqzH/XK546uFfYNHNpfYn7ZcY2ul4rzNHwebwChEk3Ps6LG6LUcmWVjVqsErsQaHKReoIqPoyBCQDfWv+z1Cll5CLCS6kV3vr+HvXqoAPOCuczM1DWn/VLZdea2nn0+ZCK0r6bip4Dn0DDwb87dofH1LklWHPhywEdX4YP8vYNHj4EMM0+prRCVj7impUCFQ4CnUG/+r6sZcL2zn/gDBFjXQp6FjC/sUYGxLHvbvg//VrYX9fSSjOWJpUtnga5RWJqvzjhQQtOT5Ehq8waoQXtht/GlB6Qzn8oRQgRFaWZr
 YIjKsWVS
 VDdHOQ87J6ssAE1RWzkDwJpqGV8UIMAg2X3+wOE48SiTTys0vMrF9OCuUg4xHUoWFrxnad2xeFYJj8HpLCsUPuOmhbQqFok1EXEIR1u+NcJf5uOZcThCOCX0kJ2zADxS1CgPrOTcbbsMED4kIaKRqitWNyiwuuEYWu+Z2qwjFJECxlPc5kp9fNhfDLWmIJmYgYrowD536wwNZO3UQ3uEoUGnHvGV7goxR1qc1JlKmNzNpl/sXtH8PBmOvA9kQ85MSGEd1z7tNLvdXsMc8DYT+tnjN0fIh+ELk7gzwNmxp6E/MBlU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Tao Cui <cuitao@kylinos.cn>

Convert all access sites of the v1-only members to go through the new
mem_cgroup_v1 substruct (memcg->v1.X) and drop the transitional
anonymous union side introduced by the previous patch.

The member order inside struct mem_cgroup_v1 is identical to the
historical order of these members inside struct mem_cgroup, so the
shared layout does not change: offsetof(struct mem_cgroup, v1.swappiness)
and the total size of struct mem_cgroup are unchanged, and the generated
code in the hot paths (e.g. mem_cgroup_swappiness) is the same.

No functional change.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 include/linux/memcontrol.h |  45 +-------------
 include/net/sock.h         |   2 +-
 mm/memcontrol-v1.c         | 122 ++++++++++++++++++-------------------
 mm/memcontrol-v1.h         |   4 +-
 mm/memcontrol.c            |  22 +++----
 mm/swap.h                  |   2 +-
 6 files changed, 77 insertions(+), 120 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index beb68f39c321..4c113a260878 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -308,50 +308,7 @@ struct mem_cgroup {
 	__cacheline_group_end_aligned(memcg_cold);
 
 #ifdef CONFIG_MEMCG_V1
-	/*
-	 * Transitional: the anonymous struct reproduces the historical layout
-	 * so existing memcg->X accesses keep compiling; it is removed once the
-	 * access sites are converted to memcg->v1.X.
-	 */
-	union {
-		struct mem_cgroup_v1 v1;
-		struct {
-			/* Legacy consumer-oriented counters */
-			struct page_counter kmem;		/* v1 only */
-			struct page_counter tcpmem;		/* v1 only */
-
-			struct memcg1_events_percpu __percpu *events_percpu;
-
-			/* protected by memcg_oom_lock */
-			bool oom_lock;
-			int under_oom;
-
-			/* OOM-Killer disable */
-			int oom_kill_disable;
-
-			/* protect arrays of thresholds */
-			struct mutex thresholds_lock;
-
-			/* thresholds for memory usage. RCU-protected */
-			struct mem_cgroup_thresholds thresholds;
-
-			/* thresholds for mem+swap usage. RCU-protected */
-			struct mem_cgroup_thresholds memsw_thresholds;
-
-			/* For oom notifier event fd */
-			struct list_head oom_notify;
-
-			/* Legacy tcp memory accounting */
-			bool tcpmem_active;
-			int tcpmem_pressure;
-
-			/* List of events which userspace want to receive */
-			struct list_head event_list;
-			spinlock_t event_list_lock;
-
-			int swappiness;
-		};
-	};
+	struct mem_cgroup_v1 v1;
 #endif /* CONFIG_MEMCG_V1 */
 
 	/*
diff --git a/include/net/sock.h b/include/net/sock.h
index 67b743bab220..c3f6775f6942 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2707,7 +2707,7 @@ static inline bool mem_cgroup_sk_under_memory_pressure(const struct sock *sk)
 
 #ifdef CONFIG_MEMCG_V1
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return !!memcg->tcpmem_pressure;
+		return !!memcg->v1.tcpmem_pressure;
 #endif /* CONFIG_MEMCG_V1 */
 
 	do {
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index bf2c7d53b01b..486df2d6a6f1 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -138,9 +138,9 @@ static void __mem_cgroup_threshold(struct mem_cgroup *memcg, bool swap)
 
 	rcu_read_lock();
 	if (!swap)
-		t = rcu_dereference(memcg->thresholds.primary);
+		t = rcu_dereference(memcg->v1.thresholds.primary);
 	else
-		t = rcu_dereference(memcg->memsw_thresholds.primary);
+		t = rcu_dereference(memcg->v1.memsw_thresholds.primary);
 
 	if (!t)
 		goto unlock;
@@ -215,7 +215,7 @@ static void memcg1_charge_statistics(struct mem_cgroup *memcg, int nr_pages)
 		nr_pages = -nr_pages; /* for event */
 	}
 
-	__this_cpu_add(memcg->events_percpu->nr_page_events, nr_pages);
+	__this_cpu_add(memcg->v1.events_percpu->nr_page_events, nr_pages);
 }
 
 #define THRESHOLDS_EVENTS_TARGET 128
@@ -224,11 +224,11 @@ static bool memcg1_event_ratelimit(struct mem_cgroup *memcg)
 {
 	unsigned long val, next;
 
-	val = __this_cpu_read(memcg->events_percpu->nr_page_events);
-	next = __this_cpu_read(memcg->events_percpu->threshold_target);
+	val = __this_cpu_read(memcg->v1.events_percpu->nr_page_events);
+	next = __this_cpu_read(memcg->v1.events_percpu->threshold_target);
 	/* from time_after() in jiffies.h */
 	if ((long)(next - val) < 0) {
-		__this_cpu_write(memcg->events_percpu->threshold_target,
+		__this_cpu_write(memcg->v1.events_percpu->threshold_target,
 				 val + THRESHOLDS_EVENTS_TARGET);
 		return true;
 	}
@@ -383,7 +383,7 @@ void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
 
 	local_irq_save(flags);
 	count_memcg_events(memcg, PGPGOUT, pgpgout);
-	__this_cpu_add(memcg->events_percpu->nr_page_events, nr_memory);
+	__this_cpu_add(memcg->v1.events_percpu->nr_page_events, nr_memory);
 	memcg1_check_events(memcg);
 	local_irq_restore(flags);
 }
@@ -408,7 +408,7 @@ static void mem_cgroup_oom_notify_cb(struct mem_cgroup *memcg)
 
 	spin_lock(&memcg_oom_lock);
 
-	list_for_each_entry(ev, &memcg->oom_notify, list)
+	list_for_each_entry(ev, &memcg->v1.oom_notify, list)
 		eventfd_signal(ev->eventfd);
 
 	spin_unlock(&memcg_oom_lock);
@@ -435,13 +435,13 @@ static int __mem_cgroup_usage_register_event(struct mem_cgroup *memcg,
 	if (ret)
 		return ret;
 
-	mutex_lock(&memcg->thresholds_lock);
+	mutex_lock(&memcg->v1.thresholds_lock);
 
 	if (type == _MEM) {
-		thresholds = &memcg->thresholds;
+		thresholds = &memcg->v1.thresholds;
 		usage = mem_cgroup_usage(memcg, false);
 	} else if (type == _MEMSWAP) {
-		thresholds = &memcg->memsw_thresholds;
+		thresholds = &memcg->v1.memsw_thresholds;
 		usage = mem_cgroup_usage(memcg, true);
 	} else
 		BUG();
@@ -497,7 +497,7 @@ static int __mem_cgroup_usage_register_event(struct mem_cgroup *memcg,
 	synchronize_rcu();
 
 unlock:
-	mutex_unlock(&memcg->thresholds_lock);
+	mutex_unlock(&memcg->v1.thresholds_lock);
 
 	return ret;
 }
@@ -522,13 +522,13 @@ static void __mem_cgroup_usage_unregister_event(struct mem_cgroup *memcg,
 	unsigned long usage;
 	int i, j, size, entries;
 
-	mutex_lock(&memcg->thresholds_lock);
+	mutex_lock(&memcg->v1.thresholds_lock);
 
 	if (type == _MEM) {
-		thresholds = &memcg->thresholds;
+		thresholds = &memcg->v1.thresholds;
 		usage = mem_cgroup_usage(memcg, false);
 	} else if (type == _MEMSWAP) {
-		thresholds = &memcg->memsw_thresholds;
+		thresholds = &memcg->v1.memsw_thresholds;
 		usage = mem_cgroup_usage(memcg, true);
 	} else
 		BUG();
@@ -596,7 +596,7 @@ static void __mem_cgroup_usage_unregister_event(struct mem_cgroup *memcg,
 		thresholds->spare = NULL;
 	}
 unlock:
-	mutex_unlock(&memcg->thresholds_lock);
+	mutex_unlock(&memcg->v1.thresholds_lock);
 }
 
 static void mem_cgroup_usage_unregister_event(struct mem_cgroup *memcg,
@@ -623,10 +623,10 @@ static int mem_cgroup_oom_register_event(struct mem_cgroup *memcg,
 	spin_lock(&memcg_oom_lock);
 
 	event->eventfd = eventfd;
-	list_add(&event->list, &memcg->oom_notify);
+	list_add(&event->list, &memcg->v1.oom_notify);
 
 	/* already in OOM ? */
-	if (memcg->under_oom)
+	if (memcg->v1.under_oom)
 		eventfd_signal(eventfd);
 	spin_unlock(&memcg_oom_lock);
 
@@ -640,7 +640,7 @@ static void mem_cgroup_oom_unregister_event(struct mem_cgroup *memcg,
 
 	spin_lock(&memcg_oom_lock);
 
-	list_for_each_entry_safe(ev, tmp, &memcg->oom_notify, list) {
+	list_for_each_entry_safe(ev, tmp, &memcg->v1.oom_notify, list) {
 		if (ev->eventfd == eventfd) {
 			list_del(&ev->list);
 			kfree(ev);
@@ -709,7 +709,7 @@ static int memcg_event_wake(wait_queue_entry_t *wait, unsigned int mode,
 		 * side will require wqh->lock via remove_wait_queue(),
 		 * which we hold.
 		 */
-		spin_lock(&memcg->event_list_lock);
+		spin_lock(&memcg->v1.event_list_lock);
 		if (!list_empty(&event->list)) {
 			list_del_init(&event->list);
 			/*
@@ -718,7 +718,7 @@ static int memcg_event_wake(wait_queue_entry_t *wait, unsigned int mode,
 			 */
 			schedule_work(&event->remove);
 		}
-		spin_unlock(&memcg->event_list_lock);
+		spin_unlock(&memcg->v1.event_list_lock);
 	}
 
 	return 0;
@@ -868,9 +868,9 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 
 	vfs_poll(fd_file(efile), &event->pt);
 
-	spin_lock_irq(&memcg->event_list_lock);
-	list_add(&event->list, &memcg->event_list);
-	spin_unlock_irq(&memcg->event_list_lock);
+	spin_lock_irq(&memcg->v1.event_list_lock);
+	list_add(&event->list, &memcg->v1.event_list);
+	spin_unlock_irq(&memcg->v1.event_list_lock);
 	return nbytes;
 
 out_put_css:
@@ -884,10 +884,10 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 
 void memcg1_memcg_init(struct mem_cgroup *memcg)
 {
-	INIT_LIST_HEAD(&memcg->oom_notify);
-	mutex_init(&memcg->thresholds_lock);
-	INIT_LIST_HEAD(&memcg->event_list);
-	spin_lock_init(&memcg->event_list_lock);
+	INIT_LIST_HEAD(&memcg->v1.oom_notify);
+	mutex_init(&memcg->v1.thresholds_lock);
+	INIT_LIST_HEAD(&memcg->v1.event_list);
+	spin_lock_init(&memcg->v1.event_list_lock);
 }
 
 void memcg1_css_offline(struct mem_cgroup *memcg)
@@ -899,12 +899,12 @@ void memcg1_css_offline(struct mem_cgroup *memcg)
 	 * Notify userspace about cgroup removing only after rmdir of cgroup
 	 * directory to avoid race between userspace and kernelspace.
 	 */
-	spin_lock_irq(&memcg->event_list_lock);
-	list_for_each_entry_safe(event, tmp, &memcg->event_list, list) {
+	spin_lock_irq(&memcg->v1.event_list_lock);
+	list_for_each_entry_safe(event, tmp, &memcg->v1.event_list, list) {
 		list_del_init(&event->list);
 		schedule_work(&event->remove);
 	}
-	spin_unlock_irq(&memcg->event_list_lock);
+	spin_unlock_irq(&memcg->v1.event_list_lock);
 }
 
 /*
@@ -918,7 +918,7 @@ static bool mem_cgroup_oom_trylock(struct mem_cgroup *memcg)
 	spin_lock(&memcg_oom_lock);
 
 	for_each_mem_cgroup_tree(iter, memcg) {
-		if (iter->oom_lock) {
+		if (iter->v1.oom_lock) {
 			/*
 			 * this subtree of our hierarchy is already locked
 			 * so we cannot give a lock.
@@ -927,7 +927,7 @@ static bool mem_cgroup_oom_trylock(struct mem_cgroup *memcg)
 			mem_cgroup_iter_break(memcg, iter);
 			break;
 		}
-		iter->oom_lock = true;
+		iter->v1.oom_lock = true;
 	}
 
 	if (failed) {
@@ -940,7 +940,7 @@ static bool mem_cgroup_oom_trylock(struct mem_cgroup *memcg)
 				mem_cgroup_iter_break(memcg, iter);
 				break;
 			}
-			iter->oom_lock = false;
+			iter->v1.oom_lock = false;
 		}
 	} else
 		mutex_acquire(&memcg_oom_lock_dep_map, 0, 1, _RET_IP_);
@@ -957,7 +957,7 @@ static void mem_cgroup_oom_unlock(struct mem_cgroup *memcg)
 	spin_lock(&memcg_oom_lock);
 	mutex_release(&memcg_oom_lock_dep_map, _RET_IP_);
 	for_each_mem_cgroup_tree(iter, memcg)
-		iter->oom_lock = false;
+		iter->v1.oom_lock = false;
 	spin_unlock(&memcg_oom_lock);
 }
 
@@ -967,7 +967,7 @@ static void mem_cgroup_mark_under_oom(struct mem_cgroup *memcg)
 
 	spin_lock(&memcg_oom_lock);
 	for_each_mem_cgroup_tree(iter, memcg)
-		iter->under_oom++;
+		iter->v1.under_oom++;
 	spin_unlock(&memcg_oom_lock);
 }
 
@@ -981,8 +981,8 @@ static void mem_cgroup_unmark_under_oom(struct mem_cgroup *memcg)
 	 */
 	spin_lock(&memcg_oom_lock);
 	for_each_mem_cgroup_tree(iter, memcg)
-		if (iter->under_oom > 0)
-			iter->under_oom--;
+		if (iter->v1.under_oom > 0)
+			iter->v1.under_oom--;
 	spin_unlock(&memcg_oom_lock);
 }
 
@@ -1012,14 +1012,14 @@ static int memcg_oom_wake_function(wait_queue_entry_t *wait,
 void memcg1_oom_recover(struct mem_cgroup *memcg)
 {
 	/*
-	 * For the following lockless ->under_oom test, the only required
+	 * For the following lockless ->v1.under_oom test, the only required
 	 * guarantee is that it must see the state asserted by an OOM when
 	 * this function is called as a result of userland actions
 	 * triggered by the notification of the OOM.  This is trivially
 	 * achieved by invoking mem_cgroup_mark_under_oom() before
 	 * triggering notification.
 	 */
-	if (memcg && memcg->under_oom)
+	if (memcg && memcg->v1.under_oom)
 		__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
 }
 
@@ -1100,7 +1100,7 @@ bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked)
 	 * Please note that mem_cgroup_out_of_memory might fail to find a
 	 * victim and then we have to bail out from the charge path.
 	 */
-	if (READ_ONCE(memcg->oom_kill_disable)) {
+	if (READ_ONCE(memcg->v1.oom_kill_disable)) {
 		if (current->in_user_fault) {
 			css_get(&memcg->css);
 			current->memcg_in_oom = memcg;
@@ -1576,10 +1576,10 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 		counter = &memcg->memsw;
 		break;
 	case _KMEM:
-		counter = &memcg->kmem;
+		counter = &memcg->v1.kmem;
 		break;
 	case _TCP:
-		counter = &memcg->tcpmem;
+		counter = &memcg->v1.tcpmem;
 		break;
 	default:
 		BUG();
@@ -1619,11 +1619,11 @@ static int memcg_update_tcp_max(struct mem_cgroup *memcg, unsigned long max)
 
 	mutex_lock(&memcg_max_mutex);
 
-	ret = page_counter_set_max(&memcg->tcpmem, max);
+	ret = page_counter_set_max(&memcg->v1.tcpmem, max);
 	if (ret)
 		goto out;
 
-	if (!memcg->tcpmem_active) {
+	if (!memcg->v1.tcpmem_active) {
 		/*
 		 * The active flag needs to be written after the static_key
 		 * update. This is what guarantees that the socket activation
@@ -1641,7 +1641,7 @@ static int memcg_update_tcp_max(struct mem_cgroup *memcg, unsigned long max)
 		 * patched in yet.
 		 */
 		static_branch_inc(&memcg_sockets_enabled_key);
-		memcg->tcpmem_active = true;
+		memcg->v1.tcpmem_active = true;
 	}
 out:
 	mutex_unlock(&memcg_max_mutex);
@@ -1710,10 +1710,10 @@ static ssize_t mem_cgroup_reset(struct kernfs_open_file *of, char *buf,
 		counter = &memcg->memsw;
 		break;
 	case _KMEM:
-		counter = &memcg->kmem;
+		counter = &memcg->v1.kmem;
 		break;
 	case _TCP:
-		counter = &memcg->tcpmem;
+		counter = &memcg->v1.tcpmem;
 		break;
 	default:
 		BUG();
@@ -1976,7 +1976,7 @@ static int mem_cgroup_swappiness_write(struct cgroup_subsys_state *css,
 	if (!mem_cgroup_is_root(memcg)) {
 		pr_info_once("Per memcg swappiness does not exist in cgroup v2. "
 			     "See memory.reclaim or memory.swap.max there\n ");
-		WRITE_ONCE(memcg->swappiness, val);
+		WRITE_ONCE(memcg->v1.swappiness, val);
 	} else
 		WRITE_ONCE(vm_swappiness, val);
 
@@ -1987,8 +1987,8 @@ static int mem_cgroup_oom_control_read(struct seq_file *sf, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(sf);
 
-	seq_printf(sf, "oom_kill_disable %d\n", READ_ONCE(memcg->oom_kill_disable));
-	seq_printf(sf, "under_oom %d\n", (bool)memcg->under_oom);
+	seq_printf(sf, "oom_kill_disable %d\n", READ_ONCE(memcg->v1.oom_kill_disable));
+	seq_printf(sf, "under_oom %d\n", (bool)memcg->v1.under_oom);
 	seq_printf(sf, "oom_kill %lu\n",
 		   atomic_long_read(&memcg->memory_events[MEMCG_OOM_KILL]));
 	return 0;
@@ -2007,7 +2007,7 @@ static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
 	if (mem_cgroup_is_root(memcg) || !((val == 0) || (val == 1)))
 		return -EINVAL;
 
-	WRITE_ONCE(memcg->oom_kill_disable, val);
+	WRITE_ONCE(memcg->v1.oom_kill_disable, val);
 	if (!val)
 		memcg1_oom_recover(memcg);
 
@@ -2183,9 +2183,9 @@ void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages)
 {
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
 		if (nr_pages > 0)
-			page_counter_charge(&memcg->kmem, nr_pages);
+			page_counter_charge(&memcg->v1.kmem, nr_pages);
 		else
-			page_counter_uncharge(&memcg->kmem, -nr_pages);
+			page_counter_uncharge(&memcg->v1.kmem, -nr_pages);
 	}
 }
 
@@ -2194,13 +2194,13 @@ bool memcg1_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
 {
 	struct page_counter *fail;
 
-	if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
-		memcg->tcpmem_pressure = 0;
+	if (page_counter_try_charge(&memcg->v1.tcpmem, nr_pages, &fail)) {
+		memcg->v1.tcpmem_pressure = 0;
 		return true;
 	}
-	memcg->tcpmem_pressure = 1;
+	memcg->v1.tcpmem_pressure = 1;
 	if (gfp_mask & __GFP_NOFAIL) {
-		page_counter_charge(&memcg->tcpmem, nr_pages);
+		page_counter_charge(&memcg->v1.tcpmem, nr_pages);
 		return true;
 	}
 	return false;
@@ -2208,12 +2208,12 @@ bool memcg1_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
 
 bool memcg1_alloc_events(struct mem_cgroup *memcg)
 {
-	memcg->events_percpu = alloc_percpu_gfp(struct memcg1_events_percpu,
+	memcg->v1.events_percpu = alloc_percpu_gfp(struct memcg1_events_percpu,
 						GFP_KERNEL_ACCOUNT);
-	return !!memcg->events_percpu;
+	return !!memcg->v1.events_percpu;
 }
 
 void memcg1_free_events(struct mem_cgroup *memcg)
 {
-	free_percpu(memcg->events_percpu);
+	free_percpu(memcg->v1.events_percpu);
 }
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index b9a21f0fd2c3..5a71a7aae099 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -73,13 +73,13 @@ void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
 void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages);
 static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg)
 {
-	return memcg->tcpmem_active;
+	return memcg->v1.tcpmem_active;
 }
 bool memcg1_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
 			 gfp_t gfp_mask);
 static inline void memcg1_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
-	page_counter_uncharge(&memcg->tcpmem, nr_pages);
+	page_counter_uncharge(&memcg->v1.tcpmem, nr_pages);
 }
 
 extern struct cftype memsw_files[];
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1460cba53588..d68d497c8fce 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1867,8 +1867,8 @@ void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg)
 			K((u64)page_counter_read(&memcg->memsw)),
 			K((u64)memcg->memsw.max), memcg->memsw.failcnt);
 		pr_info("kmem: usage %llukB, limit %llukB, failcnt %lu\n",
-			K((u64)page_counter_read(&memcg->kmem)),
-			K((u64)memcg->kmem.max), memcg->kmem.failcnt);
+			K((u64)page_counter_read(&memcg->v1.kmem)),
+			K((u64)memcg->v1.kmem.max), memcg->v1.kmem.failcnt);
 	}
 #endif
 
@@ -4285,13 +4285,13 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 		page_counter_init(&memcg->memory, &parent->memory, memcg_on_dfl);
 		page_counter_init(&memcg->swap, &parent->swap, false);
 #ifdef CONFIG_MEMCG_V1
-		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
+		WRITE_ONCE(memcg->v1.swappiness, mem_cgroup_swappiness(parent));
 		memcg->memory.track_failcnt = !memcg_on_dfl;
 		memcg->memsw.track_failcnt = !memcg_on_dfl;
-		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
-		page_counter_init(&memcg->kmem, &parent->kmem, false);
-		page_counter_init(&memcg->tcpmem, &parent->tcpmem, false);
-		memcg->tcpmem.track_failcnt = !memcg_on_dfl;
+		WRITE_ONCE(memcg->v1.oom_kill_disable, READ_ONCE(parent->v1.oom_kill_disable));
+		page_counter_init(&memcg->v1.kmem, &parent->v1.kmem, false);
+		page_counter_init(&memcg->v1.tcpmem, &parent->v1.tcpmem, false);
+		memcg->v1.tcpmem.track_failcnt = !memcg_on_dfl;
 #endif
 	} else {
 		init_memcg_stats();
@@ -4299,8 +4299,8 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 		page_counter_init(&memcg->memory, NULL, true);
 		page_counter_init(&memcg->swap, NULL, false);
 #ifdef CONFIG_MEMCG_V1
-		page_counter_init(&memcg->kmem, NULL, false);
-		page_counter_init(&memcg->tcpmem, NULL, false);
+		page_counter_init(&memcg->v1.kmem, NULL, false);
+		page_counter_init(&memcg->v1.tcpmem, NULL, false);
 #endif
 		root_mem_cgroup = memcg;
 		return &memcg->css;
@@ -4477,8 +4477,8 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 	WRITE_ONCE(memcg->zswap_writeback, true);
 #endif
 #ifdef CONFIG_MEMCG_V1
-	page_counter_set_max(&memcg->kmem, PAGE_COUNTER_MAX);
-	page_counter_set_max(&memcg->tcpmem, PAGE_COUNTER_MAX);
+	page_counter_set_max(&memcg->v1.kmem, PAGE_COUNTER_MAX);
+	page_counter_set_max(&memcg->v1.tcpmem, PAGE_COUNTER_MAX);
 #endif
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
diff --git a/mm/swap.h b/mm/swap.h
index b3b54c28929a..d8f306c5152b 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -87,7 +87,7 @@ static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 #ifdef CONFIG_MEMCG_V1
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
 	    !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg))
-		return READ_ONCE(memcg->swappiness);
+		return READ_ONCE(memcg->v1.swappiness);
 #endif
 	return READ_ONCE(vm_swappiness);
 }
-- 
2.43.0


