Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7125CCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 10:25:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EA646B00B8; Fri, 26 Jun 2026 06:25:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C1EF6B0102; Fri, 26 Jun 2026 06:25:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B4146B0104; Fri, 26 Jun 2026 06:25:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 234396B00B8
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:25:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A72791C2E45
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:25:21 +0000 (UTC)
X-FDA: 84921681642.12.328FB07
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by imf05.hostedemail.com (Postfix) with ESMTP id BB9FD100014
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:25:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782469520;
	b=7hY7aUcuZXGa28a7+fELb+RZx3it3I/ZhKcqr0por8f5kUC/opX9pNUfBdaEeel1HvsbbN
	euNOBbv5mkw+OPx7S+1M9WY3QSwBPSlHaX3l9eowv8vGAK7cL+JmwrfknaSjpZUt6Ssqdj
	4B6MS57un7rPD6e+OCYW/iJzv0W6m7c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782469520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fyz0RWSZiTi875iKvkz8V7VYwlIaJVCqudDRppgfpFU=;
	b=gZgUYyANfoElJcrAoWk5XIBjAie8MrdDqajNIRX84Nx8Vo+ggrujtTGsCXr4oMrz+MuVHr
	m67PTde8z2If4kdUJ3bYrxH7EQbjGym858pVc1saLEjqIifqX7V3qV4+4fsrq+4mLlvDHR
	IZyn9QGICADtPcXNWjQlTiy+dJ5HQuY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id B43E71F654;
	Fri, 26 Jun 2026 10:25:12 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: alexandre@ghiti.fr,
	Andrew Morton <akpm@linux-foundation.org>
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
Subject: [PATCH v2 1/9] memcg: convert task->objcg to a per-node objcgs array
Date: Fri, 26 Jun 2026 12:20:50 +0200
Message-ID: <20260626102358.1603618-2-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626102358.1603618-1-alex@ghiti.fr>
References: <20260626102358.1603618-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTGnYIDq9A11TftEatbke2wSLsM4U/RRnbCHpAUAIQBwHbVmowa+ke86M8Z6PPn5o7UKBvUMbr2gZWgcRiFc7ixLzqgLUvmoF1f6yq0GAxvM7ym0xa3n5f10aBqF/6aF0YuddnSkH5x50aCnRuJBlmRRybtyRnTHEtDjNABLsbF8/J37ko6Bm3zG+eW4NfAtWrkoIM0OVuVjH1i1R2t7kHuPQJtjQvB5ayDwVI8gcfE8wIDI8ctauyWpfQVDC9X4EX6LKQuBwn+BvrBeBO0dxg0WQvW3qtFakFlV8vs7Ehg02InoNEqwXY73y16xKIg4BKzVJqVRXZF2evXpKGHtjYSRlQMzxqWoYZh8SmozeBLEOJ1N7PlnJKommGvEBFVUvXF+NhgFfgmLXvwS+DR6qJv5JmzBkmPxMeCA6U/JlatjEXvMHeb33Fa1FeBZOZH5D5Mw/tLWSBmCm5nxBv0KYKQe+6j/zSh3zqN/c+1J+sHeLzu2hJCePgtRVrCkcxKFTo5HSPE8ZY/rqLtYoEn5XDZD1RX49og9scNZHde/aQUCOBcV4Eudt5advSOZjvKz2jPgeEEIZDdSR93jq2DxZPXGi4aobgdiiAure5qLx/8l+JVi/rQd9oQKuYlLMv8Rz1PiRCPbZrLBISfLVz5f8SKR0KxLIsoJzSxhlduvo+bvag
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BB9FD100014
X-Rspam-User: 
X-Stat-Signature: ctaghaqxzhi4bhtr9zhaswzsukmudaso
X-HE-Tag: 1782469519-875340
X-HE-Meta: U2FsdGVkX1/3snJp/MDbuovFhkwd2H8OpITJIpZPEcqifAAPXV8Jbd2rIR9npRJOcNNvcrFTx5jPLyjucrIUH7AvElwF58Tz+j+N8Hpc53HKB2fa6HuBsWmLqo7Ab6AGaVneWjo9d1Xw59BgLiOElUxb8M+zwH2s+P3B4TLBdqh7rPtYAz4gDh8X+PPOmo090vK8vp6YBpl/6DwWO2U4oFAHPPF2sz58I1iUtykoZ1soWPrmQCBn+kSf3P2S5sVDVOyLwaBRbJW/ZWE+zuv0blLNq3YSlQb8oZIxBliEH1L/ZoKMOuPIKvYXBh8/6r/UuNoyYv2MWM1iURG7SmDWj6DUTA2g9JS6XRiPpFnnE2dlIsJz31uR+lI2+nNlvc14LnArYpbs463JfX2Ap0EveFdLnvuWfJ33sYfUavFouFL5sAOgl1Tyw56YOnSmmfB1qvEqghKcoyigxQREgSpFPQZkUVzdqG5e1Fip0H6MAO5WoVbNyv4Cljc6M7UI/GRexvokgSL5FYyFcJKILtSKZ84V1t3GH33rvTMN964XLsSmbUVcbzcoT35T5XNtg8xuCTtMjfA443B1HqgYqYnkDwsN1YlnvtPwuWH02Zv2S7X6Trh2V9Pbc75+JY/6d85UtIim8TS5GcdSK+RgbtZKIq0zqV8mDwnW001KqZJI89RIOD1uahA61R1QzpyoKKfTOvqoed+3XyRGrMdYixDju/wkuuvegZxWZEHZO+rxKKw1eJzg9OuYB1xa1cW7mso07ZmzFY1+dXZPzwe8RvxwecaRuQB878ORan2WeHM9+krnLXta8QTq45wLspb2nZvXCcib60E020AE5//D8UTGewwA15LsJ5lqky1qaWK4XWkJMwgTIIylpgWJv/vuQMKpYJsPYTcU37Oy2TBzbAkyvjA4wZb6QAvG+z+2AFSn/tHJo1/ci/bXJKoLMuuEBSN5Lq0+m9XrtKsJVUkuMPH
 45pHpYIs
 fzdms
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


