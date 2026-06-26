Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86732CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 10:14:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70A7F6B00F2; Fri, 26 Jun 2026 06:14:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BB2B6B00F3; Fri, 26 Jun 2026 06:14:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55BD46B00F4; Fri, 26 Jun 2026 06:14:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 190CB6B00F2
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:14:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 78E03A0408
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:14:12 +0000 (UTC)
X-FDA: 84921653544.13.155AFCD
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8AB52C0002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:14:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782468850;
	b=dwXX1/bqhiM1LQM2tjAjZ7yETqsEKF5dhpPztxmxiMXSF2l8O2mywaQHj2HAgA0rYF/W5R
	O2Sjq2jQzFzW84wpoW3ckBC3TO4miHzuUorQWGSCEuqqrgrCsiOn/3Fhx5RsYl0ciJRFr2
	188npNHKvb+xmC1ULo8l7BP9+JZ3ALw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782468850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fyz0RWSZiTi875iKvkz8V7VYwlIaJVCqudDRppgfpFU=;
	b=NYT+lqPvIPrWwe2/RpfZxTVVmAGvokqDZialiHIM441ymxS0nSp+VIP3CGa3tWTJ7827Vm
	XCAVPwZeaRcL84Dee3RCcxkkx6xoHW7bs+kmoIlIHxHPSUUOWHqoZWOYv3LzPEAW4Ux+IG
	AHnM1XPHI/W4bDjo3CLAOlhnYYts5gM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id C185F20CC8;
	Fri, 26 Jun 2026 10:14:04 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	cgroups@vger.kernel.org,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Hildenbrand <david@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kairui Song <kasong@tencent.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [RFC PATCH v2 1/9] memcg: convert task->objcg to a per-node objcgs array
Date: Fri, 26 Jun 2026 12:09:28 +0200
Message-ID: <20260626101356.1599643-2-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626101356.1599643-1-alex@ghiti.fr>
References: <20260626101356.1599643-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTEBI1JGbXlpiiDp14fkAsKfAN5fPZBM2Ab7MYJnFM3+SveTMVF6Fpqo1pIn6X+1iOtVOzIUV5Y0lYysvg8wUhEu6iechcA9ZS1suPyZBWm40kuX54tSMCypoKaVvhov2zRyofq7gzsMmi381Aww594HETMja5HFS74ld7NppEkUPFcpepMRwyMI5cA7mkGe/vhPQABef+NqYfMk9kxiJ6/r8++B4sCphBOA9I/gZUpooOC/H1BTNf8jBjGO3awTrxngcQpM8nhCbLDXRzq4VxFUibvIrp2s4IHqQiAqPfb6IAcP9PvJXxAvxWk/3kLhKU6wNMf25eg1lrylx+omoElrhSAurNqMRzJhAGy76aZLznwfEJuIHFNQSDA6ZXGDmzpMZdiW8f0JcqMWgDabLs9A7wbuiEuhhBet6MPQU9w2PKD8B8MpI9U5VN5T7hBxCJKQ1pQUK3tcUax9n1JtaNB5ns5DHsvlUhrHSB+8KQ6/6sEsn98B6hZtACbojfmA3XWIm1TjhLUw/zjRoMLPha+c0H9a563PA9Buv8Czy4vVOXPLYBTzlw4PpDbvHX138y61H64ZVDs6wLh/mYW2n0+Rq+QeivbWHUJAtmCXarZSmIyf/ebtV/S5MtVMROjK416DDsbtRhp2XHWRTWPJegUeTLeGF3t0Bk5m35Wvxg52QA
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8AB52C0002
X-Rspam-User: 
X-Stat-Signature: 8hs8ey578w9kqxdfddjyye5ifzatw6x6
X-HE-Tag: 1782468850-913658
X-HE-Meta: U2FsdGVkX1/JgpMMRgsbNWhycPFZnTIPlHFMM0s9WteUQtB8GgJU5E3ySkQYbnA5bfW1r52/ieuTVMPu89ViG03vv4QIfaWwRpnid3SLyNn8A60DMRP3YsrexKx/ld22Xa3mKqpuV2pVosJfrWhIH4BOkQKaCuGnuPZk3alnf50P+IRAG22+K6ZvKOQHDfWXlM82EHFi37fXiLyHqB2U2JEWx5rhILOlnIBwnK+ABebaXS6SAYpwvSe0vClOQ29J67kr4WgPsoLLGORhoTp1yaswSzz5QmtfqpZzqUngClIXd7JhlR7Eonn4zF6LtoEm+KCNBAy11g+bAQ2S3CpWUWd3Q7ih+duhPnekRXNmDZTANoL86KEF/jt7Um8z63x0VvQh/wWYeFhT5gnFMWvv52qYq6UGQUGdkhpOBCsUh6XHidszV1/A/bb8ngoF86G+OLApZU24Dd1LhbBg3d9G0XKH4radQ/yS+WnnSq9o3/wzDYf9d2/4Pb0UCwEStk5c0b9mw7f+EMXMKWYCkku9yu8/WJoC0C6SdCLH+0kRr1dMi0qvOBdiykIOxG12GCfnIfiVu+tgy4uEf1UU0orRs6dbujfLWPntlXwI2hfLZcTw2mcdGs1i6lVMoY8hHv/5YlAVel/qe8qumfUKAxnd2AreXUoRcWDhq1ZrHlS6+f0SYEGpAjoTdtQFL3cvvZhXdQ7opmB2mP3A2NRAXfPHTQhbfPbhUZyoE8930EL3LXd/lpdi7iEZxmqTEXEqdpDyVIFbYFC5aghTN/K15KuGvolYoVbb7AK6ebzZFnp4iKLqNhZRYdTjz5uF3uj+fcMjabyXhtwvw+fDvmXbDCJYRbabPbLM8EqIEgDiuwIKQhloOiFREemeTGZ02HO87AnBPeFRcOlRSJWfOWvBF2n2B99hPvnNXA2l9HiE6Z1gr4Ch5VdlLvzIPHo19WzDb7XjDizL91tUaVNPIbUlyK1
 kNToscx/
 AJgfM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shakeel Butt <shakeel.butt@linux.dev>

Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
per-node type") split a memcg's single obj_cgroup into one per NUMA
node, but task_struct still cached only one objcg. On every cross-node
allocation current_obj_cgroup() returned an objcg whose nid did not
match the current CPU's node, so the stock's per-node vmstat batching
and (separately) the per-node accounting hierarchy were defeated for
multi-node workloads.

Replace task->objcg with task->objcgs: a tagged pointer to an
nr_node_ids-sized array of per-node obj_cgroup pointers. Bit 0 keeps
its meaning as CURRENT_OBJCG_UPDATE_FLAG so mem_cgroup_kmem_attach()
can still atomically mark the cache stale from another task's context
with a single set_bit().

current_obj_cgroup() now indexes the array by numa_node_id() and falls
back to root_mem_cgroup on a NULL array (kthread or fork-time alloc
failure) or NULL entry (transient drain window).

current_objcg_update() refreshes every entry under one rcu_read_lock,
xchg'ing fresh per-node objcgs in and dropping the stale references.
The outer cmpxchg loop on the tagged array pointer preserves the
existing race-with-kmem_attach semantics: if the update bit is re-set
mid-refresh, the whole refresh is retried.

The array is eagerly allocated in mem_cgroup_fork() for non-kthread
tasks. This keeps current_objcg_update() off the allocation path, which
matters because it runs from kmem allocation contexts that may be
atomic. Kthreads and tasks whose fork-time kcalloc() fails simply leave
task->objcgs as NULL and route kmem allocations to root_mem_cgroup, as
before. The array is freed in mem_cgroup_exit() after dropping the
per-node references.

__get_obj_cgroup_from_memcg() takes nid as an explicit parameter so it
can be reused for both folio charging (numa_node_id()) and the per-node
refresh loop.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 include/linux/sched.h |   7 +-
 mm/memcontrol.c       | 148 +++++++++++++++++++++++++-----------------
 2 files changed, 95 insertions(+), 60 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ee06cba5c6f5..d7ea9fe38d01 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1538,8 +1538,11 @@ struct task_struct {
 	/* Used by memcontrol for targeted memcg charge: */
 	struct mem_cgroup		*active_memcg;
 
-	/* Cache for current->cgroups->memcg->nodeinfo[nid]->objcg lookups: */
-	struct obj_cgroup		*objcg;
+	/*
+	 * Per-node cache for current->cgroups->memcg->nodeinfo[nid]->objcg
+	 * lookups. Tagged pointer: bit 0 = CURRENT_OBJCG_UPDATE_FLAG.
+	 */
+	struct obj_cgroup		**objcgs;
 #endif
 
 #ifdef CONFIG_BLK_CGROUP
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 56cd4af08232..ee47427de9e2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2907,10 +2907,9 @@ struct mem_cgroup *mem_cgroup_from_virt(void *p)
 	return folio_memcg_check(virt_to_folio(p));
 }
 
-static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
+static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg,
+						      int nid)
 {
-	int nid = numa_node_id();
-
 	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
 		struct obj_cgroup *objcg = rcu_dereference(memcg->nodeinfo[nid]->objcg);
 
@@ -2926,67 +2925,73 @@ static inline struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *me
 	struct obj_cgroup *objcg;
 
 	rcu_read_lock();
-	objcg = __get_obj_cgroup_from_memcg(memcg);
+	objcg = __get_obj_cgroup_from_memcg(memcg, numa_node_id());
 	rcu_read_unlock();
 
 	return objcg;
 }
 
-static struct obj_cgroup *current_objcg_update(void)
+static struct obj_cgroup **current_objcg_update(void)
 {
 	struct mem_cgroup *memcg;
-	struct obj_cgroup *old, *objcg = NULL;
+	struct obj_cgroup **objcgs;
+	unsigned long old_tagged;
+	int nid;
 
 	do {
-		/* Atomically drop the update bit. */
-		old = xchg(&current->objcg, NULL);
-		if (old) {
-			old = (struct obj_cgroup *)
-				((unsigned long)old & ~CURRENT_OBJCG_UPDATE_FLAG);
-			obj_cgroup_put(old);
-
-			old = NULL;
-		}
-
-		/* If new objcg is NULL, no reason for the second atomic update. */
-		if (!current->mm || (current->flags & PF_KTHREAD))
-			return NULL;
+		old_tagged = (unsigned long)READ_ONCE(current->objcgs);
+		objcgs = (struct obj_cgroup **)
+			(old_tagged & ~CURRENT_OBJCG_UPDATE_FLAG);
 
 		/*
-		 * Release the objcg pointer from the previous iteration,
-		 * if try_cmpxcg() below fails.
+		 * If there is no per-node cache (kthread or fork-time
+		 * allocation failure), there is nothing to refresh. The
+		 * cmpxchg below still clears the update bit so we do not
+		 * keep re-entering this slow path.
 		 */
-		if (unlikely(objcg)) {
-			obj_cgroup_put(objcg);
-			objcg = NULL;
+		if (objcgs) {
+			if (!current->mm || (current->flags & PF_KTHREAD)) {
+				/*
+				 * The task lost its mm: drop the cached
+				 * per-node references; future allocations will
+				 * fall back to root_mem_cgroup.
+				 */
+				for_each_node(nid)
+					obj_cgroup_put(xchg(&objcgs[nid], NULL));
+			} else {
+				/*
+				 * Re-read the memcg under rcu since the task
+				 * may have been asynchronously moved and the
+				 * previous memcg can be offlined.
+				 */
+				rcu_read_lock();
+				memcg = mem_cgroup_from_task(current);
+				for_each_node(nid) {
+					struct obj_cgroup *fresh, *stale;
+
+					fresh = __get_obj_cgroup_from_memcg(memcg, nid);
+					stale = xchg(&objcgs[nid], fresh);
+					obj_cgroup_put(stale);
+				}
+				rcu_read_unlock();
+			}
 		}
 
 		/*
-		 * Obtain the new objcg pointer. The current task can be
-		 * asynchronously moved to another memcg and the previous
-		 * memcg can be offlined. So let's get the memcg pointer
-		 * and try get a reference to objcg under a rcu read lock.
-		 */
-
-		rcu_read_lock();
-		memcg = mem_cgroup_from_task(current);
-		objcg = __get_obj_cgroup_from_memcg(memcg);
-		rcu_read_unlock();
-
-		/*
-		 * Try set up a new objcg pointer atomically. If it
-		 * fails, it means the update flag was set concurrently, so
-		 * the whole procedure should be repeated.
+		 * Publish the cleared-flag pointer. If kmem_attach raced and
+		 * re-set the update bit, retry the whole refresh.
 		 */
-	} while (!try_cmpxchg(&current->objcg, &old, objcg));
+	} while (!try_cmpxchg((unsigned long *)&current->objcgs,
+			      &old_tagged, (unsigned long)objcgs));
 
-	return objcg;
+	return objcgs;
 }
 
 __always_inline struct obj_cgroup *current_obj_cgroup(void)
 {
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
+	struct obj_cgroup **objcgs;
 	int nid = numa_node_id();
 
 	if (IS_ENABLED(CONFIG_MEMCG_NMI_UNSAFE) && in_nmi())
@@ -2997,14 +3002,16 @@ __always_inline struct obj_cgroup *current_obj_cgroup(void)
 		if (unlikely(memcg))
 			goto from_memcg;
 
-		objcg = READ_ONCE(current->objcg);
-		if (unlikely((unsigned long)objcg & CURRENT_OBJCG_UPDATE_FLAG))
-			objcg = current_objcg_update();
+		objcgs = READ_ONCE(current->objcgs);
+		if (unlikely((unsigned long)objcgs & CURRENT_OBJCG_UPDATE_FLAG))
+			objcgs = current_objcg_update();
 		/*
-		 * Objcg reference is kept by the task, so it's safe
-		 * to use the objcg by the current task.
+		 * Per-node objcg references are kept by the task, so it's
+		 * safe to use them by the current task.
 		 */
-		return objcg ? : rcu_dereference_check(root_mem_cgroup->nodeinfo[nid]->objcg, 1);
+		if (objcgs && (objcg = objcgs[nid]))
+			return objcg;
+		return rcu_dereference_check(root_mem_cgroup->nodeinfo[nid]->objcg, 1);
 	}
 
 	memcg = this_cpu_read(int_active_memcg);
@@ -4544,22 +4551,47 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 
 static void mem_cgroup_fork(struct task_struct *task)
 {
+	struct obj_cgroup **objcgs;
+
 	/*
-	 * Set the update flag to cause task->objcg to be initialized lazily
-	 * on the first allocation. It can be done without any synchronization
-	 * because it's always performed on the current task, so does
-	 * current_objcg_update().
+	 * Kthreads do not need a per-node cache; their kmem allocations fall
+	 * back to root_mem_cgroup via current_obj_cgroup().
 	 */
-	task->objcg = (struct obj_cgroup *)CURRENT_OBJCG_UPDATE_FLAG;
+	if (task->flags & PF_KTHREAD) {
+		task->objcgs = NULL;
+		return;
+	}
+
+	/*
+	 * Eagerly allocate the per-node cache so that current_objcg_update()
+	 * never has to allocate from potentially-atomic kmem allocation
+	 * paths. On allocation failure this task will use root_mem_cgroup
+	 * for kmem accounting.
+	 *
+	 * Tag with the update flag so the first kmem allocation populates
+	 * the entries via current_objcg_update().
+	 */
+	objcgs = kcalloc(nr_node_ids, sizeof(*objcgs), GFP_KERNEL);
+	if (objcgs)
+		task->objcgs = (struct obj_cgroup **)
+			((unsigned long)objcgs | CURRENT_OBJCG_UPDATE_FLAG);
+	else
+		task->objcgs = NULL;
 }
 
 static void mem_cgroup_exit(struct task_struct *task)
 {
-	struct obj_cgroup *objcg = task->objcg;
+	struct obj_cgroup **objcgs;
+	int nid;
 
-	objcg = (struct obj_cgroup *)
-		((unsigned long)objcg & ~CURRENT_OBJCG_UPDATE_FLAG);
-	obj_cgroup_put(objcg);
+	objcgs = (struct obj_cgroup **)
+		((unsigned long)task->objcgs & ~CURRENT_OBJCG_UPDATE_FLAG);
+
+	if (objcgs) {
+		for_each_node(nid)
+			obj_cgroup_put(objcgs[nid]);
+		kfree(objcgs);
+	}
 
 	/*
 	 * Some kernel allocations can happen after this point,
@@ -4567,7 +4599,7 @@ static void mem_cgroup_exit(struct task_struct *task)
 	 * because it's always performed on the current task, so does
 	 * current_objcg_update().
 	 */
-	task->objcg = NULL;
+	task->objcgs = NULL;
 }
 
 #ifdef CONFIG_LRU_GEN
@@ -4599,7 +4631,7 @@ static void mem_cgroup_kmem_attach(struct cgroup_taskset *tset)
 
 	cgroup_taskset_for_each(task, css, tset) {
 		/* atomically set the update bit */
-		set_bit(CURRENT_OBJCG_UPDATE_BIT, (unsigned long *)&task->objcg);
+		set_bit(CURRENT_OBJCG_UPDATE_BIT, (unsigned long *)&task->objcgs);
 	}
 }
 
-- 
2.54.0


