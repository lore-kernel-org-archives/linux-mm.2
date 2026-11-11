Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF406606A89F
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 20:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=bHBzg8Vx
Received: by kanga.kvack.org (Postfix)
	id 5E3B06B05B8; Wed, 11 Nov 2026 15:36:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 593CA6B05B9; Wed, 11 Nov 2026 15:36:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E75B6B05BA; Wed, 11 Nov 2026 15:36:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 053246B05B9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:36:50 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1CD26A7B0F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:36:50 +0000 (UTC)
X-FDA: 85423996980.22.A65B868
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf16.hostedemail.com (Postfix) with ESMTP id 82BC9180006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:36:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=bHBzg8Vx;
	spf=pass (imf16.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794429408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uMBcwn1n2dpUHT/6uEIYq3oHlPCno4BFZR7u/G8+ALE=;
	b=cjlk0W3pn5jX0dl0HgKVNmXlOfaXfzbGG2qckZyAfNBfB82GURwUHLUp2jZWaifJyrS3ZL
	IakFYktzhWMedA4jYwOhyl7lfK4nF0UvwtOgsCm830kAoR6dO4Q2xGYG8KHaNEr0uWkjYk
	VMPTkeKldIkhC5oTqGFwoJcMplFTp4w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794429408;
	b=swF9HuN0pTb6qcopkDeZQv3Pq5IVmllTTaPlZLaf5Sg/dWVp6KFdu37NPOZSU8xwkvS5Dq
	UPEea5JSZ/jd/uw6nJ41W77il16s+Cu/LT8GMrcnEaTZtYlMvUCSDZZrXa7p2JeOBOQCMF
	opTv77TRU59ns3Fdnmd9GCzFmZ87uWk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=bHBzg8Vx;
	spf=pass (imf16.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794429406;
	bh=uMBcwn1n2dpUHT/6uEIYq3oHlPCno4BFZR7u/G8+ALE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bHBzg8Vxmh50pUZdQN5tXZZosoPErK4Ix+6o15lxqI6zCqT20Hy0ad5QfyjgSqjPV
	 bNpuQSHkxEQnAIF6EWk6kOirLBYbAinwVW6yWUJ6qNAGsOiEiQqw9pDfT4O1Hwi2cw
	 5uVyusc5KdTi/fk/81A2Hvk4r0B2ysFbRmFJs0GQvHCYj4GW06zSzorcgjULICkbEq
	 R6bJXUzGoxahC+ZVYSVFLRtJexHpXRDCIKu5s424ctMUD/elqyb0Y/+S7eJfxYzrir
	 WHZRIpt/3MRbbuyed6borILZDndv0ii+zYyOsqYYboixVj3RxouIlzRJlecs4qNuEo
	 8XZvnFRXtXTiQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jPwKp2wqvzNh0;
	Wed, 11 Nov 2026 15:36:46 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Hildenbrand <david@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>,
	christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	David Carlier <devnexen@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-doc@vger.kernel.org,
	Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Kees Cook <kees@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	linux-trace-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Oleg Nesterov <oleg@redhat.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Andrea Parri <parri.andrea@gmail.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Hugh Dickins <hughd@google.com>
Subject: [RFC PATCH v25 09/14] lib: percpu_counter_tree: test the limit counters
Date: Wed, 11 Nov 2026 15:36:21 -0500
Message-Id: <20261111203626.95838-10-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261111203626.95838-1-mathieu.desnoyers@efficios.com>
References: <20261111203626.95838-1-mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: t41tshwanea17xdbyjfgk41fpqnuyjta
X-Rspamd-Queue-Id: 82BC9180006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794429408-854121
X-HE-Meta: U2FsdGVkX180UQa1IFFcTQLF4iVSIetuO5sP8ksU4yKAwaXuoJ8kRZCogPTxJhFvv51DdEH4nrtoM286J/xLcU47OSuAkl3vWrqEEW/eowE/GRtxcnarsuux2FLOzZdNeW+9DB1XxxnDEwlg692k1CHxr58+RXr2FxqQTltzjd1+Jujl4SolO14ote/ftNMbHI+3jmdfllSlc9vO8G7V/DTNl2sHo4pQlVHkttKTDO9GoopVLcCqAliY0ya0DyBz2dKhkAo1av2dAuu5SVxZke8KY7Q3Jrat70LIuA8SefwOl431u4GJQEZQBUvpKjFs2wjcoQJk89iuqCfnoQNQqT1m+MjohNMmnVSJeHeVkTlhpcAsvg36DOihLyuHbNhmg+8NpZvlmllTWvdZT0AvRZocl3h/dzU9fRDW/3fMlZjTNVQ6lRCnWKJSyIVkHPSk1WjE8aV25y+oQsA50VYJzBAhyou0pV5agMdl9lbhdezPiPsMe01oMy4Aa8tT5BdbucXnsBDSnn9Kw0Yi3fX5H3V34qxiJ3Z++QN6+7KPsIm0Rkxb2opDAgqJdKo3mGSmJPLCT7fdzg8sPnTF2dR8EdhZ8aZa1kGJWIrOmolIb4zo8JsYerE8Dc0CHngeRgQPQWk6z53w+iZLNVR5Hc5QV6EfkDSszJGq7Dl2pie/DWcAatJrMBR/YQgjQuK8vsrnZoc9/HmFN54BU+p56f+JDagpvpvPDfKC7XhQGuP3OqChHijU05K6b+4OB0kh48ysjoikcQY3oaX37YVUVtz79TdVLEfSRksd/dzbb0U7ZuyJTtk4dBaMnIHovOg7OfadwxA/2RtuwRyzn2eIgAzArWa3xT+6xgez4Dssl54gQkORvJaAtCqJWnuf8sc+Npjgc4v0m6OhoNzslXJyABfMKBE/eLXnZu+7KpVWmo3zWLK1KCfg1NHnWrzYkolqXDAa2/TUtbU4mw7zdF7npmn
 0O4yxeSF
 fFBL+AFe4xQO9vRhLeWQ/QRH+vJQ0Xd7pPxlxSr42/lOVrYaKBtVQu7fQ63mon+0+Ay274HpaiaUQiP4DuZXH333n+CNkKYN90bRzJ/ozntEfVOh4D42XVTyrNaOsfCPL+cG/SCooeEYwr/u1JbfPMRVf73fhBbjFBaPg3LeMHHgOJXK3m8wPymR8S84T8CftBYQTV94jF+lDCIQmgb4iailFcIGheyhcPVncoIRy/Gj9dwDJ6zYyZv80t1fRsgTlVgLUEBR4Dbm0j0kFDmzxWOL2CXObri3YK1GYyNz/7R1AV77PZ30kg/RwU+8sTJUiUysFmbylh8toNVBtdCsK/6pdihLs6dfvpgR0SaVbjAAmQ2s9rIm5erYad9L9AqiNRpJ4B92o3XoUhzsxfUulxdNKdr0zGEefrv8lUJsLZ1yhqf8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Test the limit counters of the previous patch. These tests cover them:

- The userspace harness checks each decision and the bounds of each
  counter.
- The harness also stalls an addition right after its carry fills an
  item, at each level and at the root. Then the other CPUs of that item
  add near the limit. An item holding such a carry must take no new
  arrival. Without this rule, they exceed the limit in 105 of the 191
  configurations.
- A harness test makes an addition fail because of another one in
  flight, and checks that it retries and fits. Another one checks that
  a large amount which cannot fit is not added.
- The harness runs these tests again with both counters about to wrap,
  as unsigned and as signed values. It passes as a 32-bit build too.
- A KUnit test runs workers on all CPUs near the limit. An exact shadow
  of the successful additions never exceeds it.

For the stall test, the shim gains a stall hook. It runs a function
right after the next fully ordered or release update of a chosen item.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 lib/tests/percpu_counter_tree_kunit.c  | 172 +++++++++++++
 tools/testing/hpcc/include/hpcc_shim.h |  42 ++-
 tools/testing/hpcc/main.c              | 342 +++++++++++++++++++++++++
 3 files changed, 553 insertions(+), 3 deletions(-)

diff --git a/lib/tests/percpu_counter_tree_kunit.c b/lib/tests/percpu_counter_tree_kunit.c
index 12bd5a4bbb45..bd99ab7ca1c0 100644
--- a/lib/tests/percpu_counter_tree_kunit.c
+++ b/lib/tests/percpu_counter_tree_kunit.c
@@ -612,6 +612,177 @@ static void hpcc_test_contended_carries(struct kunit *test)
 		do_hpcc_test_contended_carries(test, 1UL << batch_size_order);
 }
 
+#define LIMIT_NR_OPS	100000
+
+struct limit_shared {
+	struct percpu_counter_tree_limit limit;
+	unsigned long max;
+	unsigned long target;		/* Amount each worker tries to hold. */
+	unsigned long batch_size;
+	atomic_long_t charged;		/* Exact total of the successful additions held. */
+	atomic_long_t nr_over;		/* Times charged exceeded max. */
+	atomic_long_t nr_added, nr_failed;
+	atomic_t nr_ready;
+	unsigned int nr_workers;
+	bool started;
+};
+
+struct limit_data {
+	struct limit_shared *sh;
+	unsigned long held;
+	u32 seed;
+} ____cacheline_aligned_in_smp;
+
+static DECLARE_WAIT_QUEUE_HEAD(limit_wq);
+
+static u32 limit_rnd(struct limit_data *ld)
+{
+	u32 x = ld->seed;
+
+	x ^= x << 13;
+	x ^= x >> 17;
+	x ^= x << 5;
+	ld->seed = x;
+	return x;
+}
+
+/*
+ * Each worker adds to the limit counter until it holds its target. Then
+ * it frees part of what it holds. Together, the workers hold about 1.5
+ * times the limit, so additions fail. A successful addition is added to
+ * charged after it succeeds. A free subtracts from charged before it
+ * reaches the limit counter. So charged is never above the value of the
+ * limit counter. Charged above max means the limit was exceeded.
+ */
+static int limit_worker_fn(void *data)
+{
+	struct limit_data *ld = data;
+	struct limit_shared *sh = ld->sh;
+	unsigned int i;
+
+	/* Pairs with the release of started: max, target and nr_workers are set. */
+	wait_event(limit_wq, smp_load_acquire(&sh->started));
+	/* Start together, so that the workers hold their amounts at the same time. */
+	atomic_inc(&sh->nr_ready);
+	while (atomic_read(&sh->nr_ready) < sh->nr_workers)
+		cpu_relax();
+	for (i = 0; i < LIMIT_NR_OPS; i++) {
+		u32 x = limit_rnd(ld);
+		unsigned long amount;
+
+		if (ld->held < sh->target) {
+			/* Mostly small amounts, and one in 16 of a huge page. */
+			if ((x >> 4) & 15)
+				amount = 1 + (x >> 8) % (4 * sh->batch_size);
+			else
+				amount = 512;
+			if (percpu_counter_tree_limit_add(&sh->limit, sh->max, amount)) {
+				unsigned long charged;
+
+				charged = atomic_long_add_return(amount, &sh->charged);
+				if (charged > sh->max)
+					atomic_long_inc(&sh->nr_over);
+				ld->held += amount;
+				atomic_long_inc(&sh->nr_added);
+			} else {
+				atomic_long_inc(&sh->nr_failed);
+			}
+		} else if (ld->held) {
+			amount = 1 + (x >> 8) % ld->held;
+			atomic_long_sub(amount, &sh->charged);
+			percpu_counter_tree_limit_sub(&sh->limit, amount);
+			ld->held -= amount;
+		}
+		if (!(i & 63))
+			cond_resched();
+	}
+	atomic_long_sub(ld->held, &sh->charged);
+	percpu_counter_tree_limit_sub(&sh->limit, ld->held);
+	ld->held = 0;
+	complete_work();
+	return 0;
+}
+
+static void do_hpcc_test_limit(struct kunit *test, unsigned long batch_size)
+{
+	struct limit_shared *sh;
+	struct limit_data *ld;
+	struct task_struct **task;
+	const struct cpumask *cpus;
+	unsigned int nr_workers = 0;
+	unsigned long accuracy;
+	int ret, cpu;
+
+	sh = kzalloc_obj(*sh);
+	ld = kvcalloc(nr_cpu_ids, sizeof(*ld), GFP_KERNEL);
+	task = kvcalloc(nr_cpu_ids, sizeof(*task), GFP_KERNEL);
+	KUNIT_EXPECT_NOT_NULL(test, sh);
+	KUNIT_EXPECT_NOT_NULL(test, ld);
+	KUNIT_EXPECT_NOT_NULL(test, task);
+	if (!sh || !ld || !task)
+		goto free;
+	ret = percpu_counter_tree_limit_init(&sh->limit, batch_size, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	if (ret)
+		goto free;
+	accuracy = percpu_counter_tree_approximate_accuracy(&sh->limit.counters[0]);
+	/* A limit of twice the accuracy, oversubscribed twice: mostly within its accuracy. */
+	sh->max = 2 * accuracy + 1;
+	sh->batch_size = batch_size;
+	init_kthreads();
+	cpus_read_lock();
+	cpus = select_worker_cpus();
+	sh->target = 2 * sh->max / cpumask_weight(cpus) + 512;
+	for_each_cpu(cpu, cpus) {
+		ld[cpu].sh = sh;
+		ld[cpu].seed = get_random_u32() | 1;
+		task[cpu] = kthread_create_on_cpu(limit_worker_fn, &ld[cpu], cpu,
+						  "kunit_hpcc_limit/%u");
+		KUNIT_EXPECT_FALSE(test, IS_ERR(task[cpu]));
+		if (IS_ERR(task[cpu]))
+			break;
+		atomic_inc(&kernel_threads_to_run);
+		get_task_struct(task[cpu]);
+		wake_up_process(task[cpu]);
+		nr_workers++;
+	}
+	sh->nr_workers = nr_workers;
+	/* Start the workers once their number is known, see limit_worker_fn(). */
+	smp_store_release(&sh->started, true);
+	wake_up_all(&limit_wq);
+	fini_kthreads();
+	for_each_cpu(cpu, cpus) {
+		if (!IS_ERR_OR_NULL(task[cpu]))
+			kthread_stop_put(task[cpu]);
+	}
+	cpus_read_unlock();
+
+	kunit_info(test, "batch_size=%lu workers=%u max=%lu added=%ld failed=%ld over=%ld\n",
+		   batch_size, nr_workers, sh->max, atomic_long_read(&sh->nr_added),
+		   atomic_long_read(&sh->nr_failed), atomic_long_read(&sh->nr_over));
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&sh->nr_over), 0);
+	KUNIT_EXPECT_GT(test, atomic_long_read(&sh->nr_failed), 0);
+	KUNIT_EXPECT_EQ(test, percpu_counter_tree_limit_precise_sum(&sh->limit), 0);
+	percpu_counter_tree_limit_destroy(&sh->limit);
+free:
+	kvfree(task);
+	kvfree(ld);
+	kfree(sh);
+}
+
+/*
+ * Workers on all the worker CPUs add to and subtract from a limit counter
+ * held near its limit. The limit is never exceeded, and the value is back
+ * to 0 once all the workers freed what they held.
+ */
+static void hpcc_test_limit(struct kunit *test)
+{
+	if (num_online_cpus() < 2)
+		kunit_skip(test, "needs at least 2 online CPUs");
+	do_hpcc_test_limit(test, 2);
+	do_hpcc_test_limit(test, 32);
+}
+
 static void hpcc_test_init_one(struct kunit *test)
 {
 	struct percpu_counter_tree pct, zeroed = {};
@@ -1038,6 +1209,7 @@ static struct kunit_case hpcc_test_cases[] = {
 	KUNIT_CASE(hpcc_test_set),
 	KUNIT_CASE(hpcc_test_saturated_compare),
 	KUNIT_CASE(hpcc_test_contended_carries),
+	KUNIT_CASE_SLOW(hpcc_test_limit),
 	KUNIT_CASE(hpcc_test_lazy),
 	KUNIT_CASE(hpcc_test_lazy_activation_race),
 	{}
diff --git a/tools/testing/hpcc/include/hpcc_shim.h b/tools/testing/hpcc/include/hpcc_shim.h
index a455e6432b5c..5d96d68f79bd 100644
--- a/tools/testing/hpcc/include/hpcc_shim.h
+++ b/tools/testing/hpcc/include/hpcc_shim.h
@@ -86,9 +86,45 @@ static inline bool atomic_long_try_cmpxchg_relaxed(atomic_long_t *v, long *old,
 	return false;
 }
 
-#define atomic_long_add_return(i, v)		((v)->counter += (i))
-#define atomic_long_add_return_release(i, v)	((v)->counter += (i))
-#define atomic_long_try_cmpxchg(v, old, new)	atomic_long_try_cmpxchg_relaxed(v, old, new)
+/*
+ * Stall hook. hpcc_stall_fn() runs once, right after the next ordered
+ * update of hpcc_stall_item. An ordered update is fully ordered or a
+ * release, not relaxed. This simulates an updater interrupted there while
+ * the other CPUs keep running.
+ */
+extern atomic_long_t *hpcc_stall_item;
+extern void (*hpcc_stall_fn)(void);
+
+static inline void hpcc_stall(atomic_long_t *v)
+{
+	void (*fn)(void) = hpcc_stall_fn;
+
+	if (fn && v == hpcc_stall_item) {
+		hpcc_stall_fn = NULL;
+		fn();
+	}
+}
+
+static inline long atomic_long_add_return(long i, atomic_long_t *v)
+{
+	long r = (v->counter += i);
+
+	hpcc_stall(v);
+	return r;
+}
+
+static inline long atomic_long_add_return_release(long i, atomic_long_t *v)
+{
+	return atomic_long_add_return(i, v);
+}
+
+static inline bool atomic_long_try_cmpxchg(atomic_long_t *v, long *old, long new)
+{
+	if (!atomic_long_try_cmpxchg_relaxed(v, old, new))
+		return false;
+	hpcc_stall(v);
+	return true;
+}
 
 /* Simulated topology, and CPU on which the current code runs. */
 extern unsigned int nr_cpu_ids;
diff --git a/tools/testing/hpcc/main.c b/tools/testing/hpcc/main.c
index 1b86fea543e5..8046fb3a59eb 100644
--- a/tools/testing/hpcc/main.c
+++ b/tools/testing/hpcc/main.c
@@ -23,6 +23,12 @@
  *   counter, exact before its tree is activated halfway, with the same
  *   checks after each increment.
  *
+ * - Limit counters: random additions and subtractions near the limit,
+ *   which must fit exactly when the value stays within it. Hooks stall an
+ *   addition in flight to check the cases where the sums race with it.
+ *   Each test runs again with both counters about to wrap, as unsigned and
+ *   as signed values.
+ *
  * The test is single-threaded, so it only covers settled counters.
  */
 
@@ -33,6 +39,8 @@ unsigned int nr_cpu_ids;
 unsigned int hpcc_current_cpu;
 unsigned long hpcc_nr_warnings;
 long hpcc_nr_allocs;
+atomic_long_t *hpcc_stall_item;
+void (*hpcc_stall_fn)(void);
 
 #include "../../../lib/percpu_counter_tree.c"
 
@@ -389,6 +397,320 @@ static void test_lazy(unsigned long batch_size, unsigned long nr_steps)
 	CHECK(hpcc_nr_allocs == nr_allocs);
 }
 
+/*
+ * Both counters of a limit counter only grow, so they wrap after enough
+ * updates. The limit tests start both roots at limit_base, which leaves
+ * the value at 0. When limit_wrap is set, the base is a random distance
+ * below the wrap point limit_wrap_at, within the range the tests cover.
+ * A check which compares the roots without taking their difference then
+ * fails while one side of the comparison has wrapped and the other has
+ * not.
+ */
+static bool limit_wrap;
+static unsigned long limit_wrap_at, limit_base;
+
+static int limit_init(struct percpu_counter_tree_limit *l, unsigned long batch_size)
+{
+	unsigned long accuracy;
+
+	if (percpu_counter_tree_limit_init(l, batch_size, GFP_KERNEL))
+		return -ENOMEM;
+	limit_base = 0;
+	if (limit_wrap) {
+		accuracy = percpu_counter_tree_approximate_accuracy(&l->counters[0]);
+		limit_base = limit_wrap_at - 1 - rnd() % (8 * accuracy);
+	}
+	atomic_long_set(l->counters[0].approx_sum, limit_base);
+	atomic_long_set(l->counters[1].approx_sum, limit_base);
+	return 0;
+}
+
+/* Each counter of a limit counter errs in one direction only. */
+static void check_limit(struct percpu_counter_tree_limit *l, unsigned long add_total,
+			unsigned long sub_total)
+{
+	struct percpu_counter_tree *add = &l->counters[0], *sub = &l->counters[1];
+	unsigned long accuracy = percpu_counter_tree_approximate_accuracy(add);
+	unsigned long root_add = atomic_long_read(add->approx_sum);
+	unsigned long root_sub = atomic_long_read(sub->approx_sum);
+
+	CHECK(percpu_counter_tree_precise_sum_upper(add) == add_total);
+	CHECK((unsigned long)percpu_counter_tree_precise_sum(sub) == sub_total);
+	/* Modulo the wrap: a root above its total gives a huge difference. */
+	CHECK(add_total - root_add <= accuracy);
+	CHECK(sub_total - root_sub <= accuracy);
+	CHECK(percpu_counter_tree_limit_precise_sum(l) == add_total - sub_total);
+}
+
+/*
+ * Without concurrency, an addition must fit exactly when the value stays
+ * within the limit. The limit is a few accuracies wide, so the walk often
+ * runs within the accuracy of the limit, where the precise sums decide.
+ */
+static void test_limit(unsigned long batch_size, unsigned long nr_steps)
+{
+	unsigned long value = 0, add_total, sub_total, accuracy, max, step, amount;
+	struct percpu_counter_tree_limit l;
+	bool added;
+
+	if (limit_init(&l, batch_size)) {
+		CHECK(0);
+		return;
+	}
+	add_total = limit_base;
+	sub_total = limit_base;
+	accuracy = percpu_counter_tree_approximate_accuracy(&l.counters[0]);
+	max = 3 * accuracy + rnd() % (accuracy + 1) + 1;
+	for (step = 0; step < nr_steps; step++) {
+		hpcc_current_cpu = rnd() % nr_cpu_ids;
+		if (value && !(rnd() % 3)) {
+			amount = 1 + rnd() % value;
+			percpu_counter_tree_limit_sub(&l, amount);
+			value -= amount;
+			sub_total += amount;
+		} else {
+			amount = 1 + rnd() % ((rnd() & 1) ? batch_size : 8 * batch_size);
+			added = percpu_counter_tree_limit_add(&l, max, amount);
+			CHECK(added == (value + amount <= max));
+			if (added) {
+				value += amount;
+				add_total += amount;
+			} else if (amount <= batch_size) {
+				/* Added, then undone by a subtraction. */
+				add_total += amount;
+				sub_total += amount;
+			}	/* A larger amount which cannot fit is not added. */
+		}
+		check_limit(&l, add_total, sub_total);
+	}
+	/* Fill up: the value stops exactly at the limit. */
+	while (value < max) {
+		hpcc_current_cpu = rnd() % nr_cpu_ids;
+		amount = (max - value + 1) / 2;
+		CHECK(percpu_counter_tree_limit_add(&l, max, amount));
+		value += amount;
+		add_total += amount;
+	}
+	CHECK(!percpu_counter_tree_limit_add(&l, max, 1));
+	add_total++;
+	sub_total++;
+	CHECK(value == max);
+	check_limit(&l, add_total, sub_total);
+	percpu_counter_tree_limit_destroy(&l);
+}
+
+/* State of test_limit_stall(), shared with its stall hook. */
+static struct {
+	struct percpu_counter_tree_limit l;
+	unsigned long max, value;
+	unsigned int stalled_cpu, share_mask;
+} stall;
+
+/*
+ * While one addition is stalled, the CPUs sharing its stalled item add.
+ * Their carries meet its pending items, and go straight to the root.
+ */
+static void stall_others_add(void)
+{
+	struct percpu_counter_tree *add = &stall.l.counters[0];
+	unsigned long batch_size = percpu_counter_tree_batch_size(add);
+	unsigned long root = atomic_long_read(add->approx_sum);
+	unsigned int saved = hpcc_current_cpu, cpu, i;
+	bool others = false;
+
+	for (cpu = 0; cpu < nr_cpu_ids; cpu++) {
+		if (cpu == stall.stalled_cpu ||
+		    (cpu & stall.share_mask) != (stall.stalled_cpu & stall.share_mask))
+			continue;
+		others = true;
+		hpcc_current_cpu = cpu;
+		for (i = 0; i < batch_size; i++) {
+			if (percpu_counter_tree_limit_add(&stall.l, stall.max, 1))
+				stall.value++;
+		}
+		CHECK(stall.value <= stall.max);
+		CHECK(percpu_counter_tree_limit_precise_sum(&stall.l) >= stall.value);
+	}
+	if (others)
+		CHECK((long)(atomic_long_read(add->approx_sum) - root) > 0);
+	hpcc_current_cpu = saved;
+}
+
+/*
+ * Fill each residual of the additions to its largest value. The value is
+ * then the accuracy, and the root is 0. The limit is set to the value.
+ * Then an addition on CPU 0 carries up to the root through all the
+ * levels. Stall it right after it arrives at its item of @stall_level,
+ * or at the root when @stall_level is nr_levels. Its items below the
+ * root then hold their carries on the way up. The CPUs sharing the
+ * stalled item add while it is stalled, and must fail.
+ */
+static void test_limit_stall(unsigned long batch_size, unsigned int stall_level)
+{
+	unsigned int nr_levels = tree_topology.config->nr_levels, level, level_items, i, cpu;
+	unsigned long step, bit_mask;
+	struct percpu_counter_tree *add;
+	atomic_long_t *item;
+
+	if (limit_init(&stall.l, batch_size)) {
+		CHECK(0);
+		return;
+	}
+	add = &stall.l.counters[0];
+	stall.max = percpu_counter_tree_approximate_accuracy(add);
+	stall.value = 0;
+	/*
+	 * An amount of bit_mask - step is a multiple of the batch sizes of the
+	 * levels below. It goes through them and stays in item i of this
+	 * level. CPU i updates that item.
+	 */
+	level_items = 1U << tree_topology.nr_cpus_order;
+	bit_mask = batch_size;
+	item = percpu_counter_tree_items(add);
+	stall.share_mask = 0;		/* At the root, all CPUs share it. */
+	for (level = 1; level < nr_levels; level++) {
+		step = bit_mask;
+		level_items >>= tree_topology.config->n_arity_order[level - 1];
+		bit_mask <<= tree_topology.config->n_arity_order[level - 1];
+		if (level == stall_level) {
+			hpcc_stall_item = item;		/* CPU 0's item. */
+			stall.share_mask = level_items - 1;
+		}
+		for (i = 0; i < level_items; i++) {
+			hpcc_current_cpu = i;
+			CHECK(percpu_counter_tree_limit_add(&stall.l, stall.max, bit_mask - step));
+			stall.value += bit_mask - step;
+		}
+		item += level_items * add->items_stride;
+	}
+	if (stall_level >= nr_levels)
+		hpcc_stall_item = add->approx_sum;
+	for (cpu = 0; cpu < nr_cpu_ids; cpu++) {
+		hpcc_current_cpu = cpu;
+		CHECK(percpu_counter_tree_limit_add(&stall.l, stall.max, batch_size - 1));
+		stall.value += batch_size - 1;
+	}
+	CHECK(stall.value == stall.max);
+	CHECK((unsigned long)atomic_long_read(add->approx_sum) == limit_base);
+
+	stall.stalled_cpu = 0;
+	hpcc_stall_fn = stall_others_add;
+	hpcc_current_cpu = stall.stalled_cpu;
+	if (percpu_counter_tree_limit_add(&stall.l, stall.max, 1))
+		stall.value++;
+	CHECK(!hpcc_stall_fn);	/* The stall happened. */
+	hpcc_stall_fn = NULL;
+	CHECK(stall.value <= stall.max);
+	CHECK(percpu_counter_tree_limit_precise_sum(&stall.l) == stall.value);
+	percpu_counter_tree_limit_destroy(&stall.l);
+}
+
+/* State of test_limit_retry(), shared with its stall hook. */
+static struct {
+	struct percpu_counter_tree_limit l;
+	unsigned long in_flight;
+	unsigned int in_flight_cpu;
+} retry;
+
+/* The concurrent addition in flight fails, and is undone. */
+static void retry_undo_in_flight(void)
+{
+	unsigned int saved = hpcc_current_cpu;
+
+	hpcc_current_cpu = retry.in_flight_cpu;
+	percpu_counter_tree_limit_sub(&retry.l, retry.in_flight);
+	hpcc_current_cpu = saved;
+}
+
+/*
+ * With one unit free, CPU 0 adds 1 while another addition of 1 is in
+ * flight, about to fail. CPU 0 fails, and that addition is undone while
+ * CPU 0 undoes its own. CPU 0 must then retry, and fit.
+ */
+static void test_limit_retry(unsigned long batch_size)
+{
+	struct percpu_counter_tree *add = &retry.l.counters[0], *sub = &retry.l.counters[1];
+	unsigned long max, value = 0, amount;
+
+	if (limit_init(&retry.l, batch_size)) {
+		CHECK(0);
+		return;
+	}
+	max = 2 * percpu_counter_tree_approximate_accuracy(add) + 1;
+	hpcc_current_cpu = 1 % nr_cpu_ids;
+	while (value < max - 1) {
+		amount = max - 1 - value < batch_size ? max - 1 - value : batch_size;
+		CHECK(percpu_counter_tree_limit_add(&retry.l, max, amount));
+		value += amount;
+	}
+	/* CPU 0's subtractions at batch_size - 1: its undo carries. */
+	hpcc_current_cpu = 0;
+	percpu_counter_tree_limit_sub(&retry.l, batch_size - 1);
+	hpcc_current_cpu = 1 % nr_cpu_ids;
+	CHECK(percpu_counter_tree_limit_add(&retry.l, max, batch_size - 1));
+	/* The addition in flight, from another CPU. */
+	retry.in_flight = 1;
+	retry.in_flight_cpu = 2 % nr_cpu_ids;
+	hpcc_current_cpu = retry.in_flight_cpu;
+	percpu_counter_tree_add_arrive_first(add, retry.in_flight);
+	/* CPU 0's undo carries to the first item of the subtractions. */
+	hpcc_stall_item = tree_topology.config->nr_levels > 1 ?
+			  percpu_counter_tree_items(sub) : sub->approx_sum;
+	hpcc_stall_fn = retry_undo_in_flight;
+	hpcc_current_cpu = 0;
+	CHECK(percpu_counter_tree_limit_add(&retry.l, max, 1));
+	CHECK(!hpcc_stall_fn);	/* The other addition was undone during the check. */
+	hpcc_stall_fn = NULL;
+	CHECK(percpu_counter_tree_limit_precise_sum(&retry.l) == max);
+	percpu_counter_tree_limit_destroy(&retry.l);
+}
+
+/*
+ * An amount larger than the batch size which cannot fit fails before it
+ * is added. The additions do not change, and a fitting amount still fits.
+ */
+static void test_limit_precheck(unsigned long batch_size)
+{
+	struct percpu_counter_tree_limit l;
+	unsigned long max, value = 0, amount, before;
+
+	if (limit_init(&l, batch_size)) {
+		CHECK(0);
+		return;
+	}
+	max = 2 * percpu_counter_tree_approximate_accuracy(&l.counters[0]) + 1;
+	hpcc_current_cpu = 1 % nr_cpu_ids;
+	while (value < max - batch_size) {
+		amount = max - batch_size - value;
+		if (amount > batch_size)
+			amount = batch_size;
+		CHECK(percpu_counter_tree_limit_add(&l, max, amount));
+		value += amount;
+	}
+	before = percpu_counter_tree_precise_sum_upper(&l.counters[0]);
+	hpcc_current_cpu = 0;
+	CHECK(!percpu_counter_tree_limit_add(&l, max, 2 * batch_size));
+	CHECK(percpu_counter_tree_precise_sum_upper(&l.counters[0]) == before);
+	CHECK(percpu_counter_tree_limit_add(&l, max, batch_size));
+	CHECK(percpu_counter_tree_limit_precise_sum(&l) == max);
+	percpu_counter_tree_limit_destroy(&l);
+}
+
+/* The batch size chosen for an accuracy is the largest within it. */
+static void test_batch_for_accuracy(void)
+{
+	unsigned long multiplier = tree_topology.accuracy_multiplier, accuracy, batch_size;
+
+	for (accuracy = 1; accuracy < 512 * multiplier; accuracy = accuracy * 3 + 1) {
+		batch_size = percpu_counter_tree_batch_for_accuracy(accuracy);
+		CHECK(batch_size >= 2 && batch_size <= PERCPU_COUNTER_TREE_MAX_BATCH);
+		if (batch_size > 2)
+			CHECK(batch_size * multiplier - nr_cpu_ids <= accuracy);
+		if (batch_size < PERCPU_COUNTER_TREE_MAX_BATCH)
+			CHECK(2 * batch_size * multiplier - nr_cpu_ids > accuracy);
+	}
+}
+
 static const unsigned int test_nr_cpus[] = {
 	1, 2, 3, 4, 5, 8, 9, 16, 17, 32, 33, 64, 65, 100, 128, 256, 512,
 	1000, 1024, 2048, 4096, 8192, 16384, 32768, 65536,
@@ -405,6 +727,12 @@ static int test_num;
 
 static int run_case(unsigned int nr_cpus, unsigned long batch_size)
 {
+	/* No wrap, then below the unsigned and the signed wrap points. */
+	const struct {
+		bool wrap;
+		unsigned long at;
+	} wraps[] = { { false, 0 }, { true, 0 }, { true, 1UL << (BITS_PER_LONG - 1) } };
+	unsigned int level, i;
 	/* Each check iterates over all CPUs: bound the random walk cost. */
 	unsigned long nr_steps = 10000000 / nr_cpus;
 
@@ -420,6 +748,20 @@ static int run_case(unsigned int nr_cpus, unsigned long batch_size)
 	test_saturated(batch_size, -1);
 	test_random_walk(batch_size, nr_steps);
 	test_lazy(batch_size, nr_steps / 2);
+	for (i = 0; i < ARRAY_SIZE(wraps); i++) {
+		limit_wrap = wraps[i].wrap;
+		limit_wrap_at = wraps[i].at;
+		test_limit(batch_size, nr_steps / 2);
+		/* These fill the tree near the limit, where each addition sums all CPUs. */
+		if (nr_cpus > 4096)
+			continue;
+		for (level = 1; level <= tree_topology.config->nr_levels; level++)
+			test_limit_stall(batch_size, level);
+		test_limit_retry(batch_size);
+		test_limit_precheck(batch_size);
+	}
+	limit_wrap = false;
+	test_batch_for_accuracy();
 	CHECK(!hpcc_nr_warnings);
 	printf("%sok %d - nr_cpus=%u batch_size=%lu\n", nr_case_failures ? "not " : "",
 	       ++test_num, nr_cpus, batch_size);
-- 
2.47.3


