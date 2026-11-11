Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E706606A89F
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 20:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=WX4/2Cpm
Received: by kanga.kvack.org (Postfix)
	id 1EB7B6B05B7; Wed, 11 Nov 2026 15:36:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C2086B05B6; Wed, 11 Nov 2026 15:36:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B1A16B05BA; Wed, 11 Nov 2026 15:36:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA1FC6B05B6
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:36:50 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD9AC803F0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:36:49 +0000 (UTC)
X-FDA: 85423996938.07.6B519F9
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf09.hostedemail.com (Postfix) with ESMTP id 46AFA140006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:36:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="WX4/2Cpm";
	spf=pass (imf09.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794429408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z3dEdxOCU8nAuYzSvkj6TU4es90N0pl4D5gWfspNko4=;
	b=tEviQKuwM8xEb5kaIH6pf0MG1wZEktcAClQ6q4ElNC5pcmIGo8vWCRhw1GFTQDOeLszBpY
	LFktrLEtIrPNPb8aBUrkiBiJAcj5NalBNqpr4k4xBUX28UTGCRL56d1GlwJIS0c6f6Fq11
	zkbJ5tvwtAhFWJVyTdz/EsB8tv66JJk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794429408;
	b=5QQoiI2yCCjFcq2yKYTLZTKU4os8AP0K9oF28Awb8F5Ani08vz2QnaGf6KsR5SB4PAZD96
	F7Z7RUfK//iHJ9H6+EM45o5GMRaJ7Fz1FYCZDhV/nSSCI/eF/Wneg1wIoA8uiTF74F1uuT
	hYCUVyT5o3HBC1zwUuAbxBbsQnUsV7s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="WX4/2Cpm";
	spf=pass (imf09.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794429406;
	bh=Z3dEdxOCU8nAuYzSvkj6TU4es90N0pl4D5gWfspNko4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WX4/2CpmsyeknRMizxcafFMF+yp2DSEjulJry4Q7txYEaCedX7FNclABPdu3CZArQ
	 4EC2SUSp8A8uXalLDeZdkGk/sgFrPMK0CILE/N4+nScfNeXk9kVaCnzZnGAOZTJZUd
	 8E4q3cKCnAJM4NqNX/jg/j4wl/dWw/7fxulQXVXURXY+JEPhGKNRVvYd4/NX/YUI87
	 Xm3afTjWE1ovgYx0bYQKWzH8JjrazSnR+wv+5L9aZciJT3oJpZCDzTuvn5wIaoRhGZ
	 QM1AuIRBMiNTJ5Y/qWjg+5uvvTsatpg/79dWVPdkEFMjjk8CxdUq68quBZeL+YVDHF
	 Bb/Ja/WQTgwFw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jPwKp1HMszNZX;
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
Subject: [RFC PATCH v25 08/14] lib: percpu_counter_tree: add limit counters
Date: Wed, 11 Nov 2026 15:36:20 -0500
Message-Id: <20261111203626.95838-9-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261111203626.95838-1-mathieu.desnoyers@efficios.com>
References: <20261111203626.95838-1-mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: zo1ghumbjkei6cqzq9zg71ru57g6em7j
X-Rspamd-Queue-Id: 46AFA140006
X-Rspam-User: 
X-HE-Tag: 1794429408-718521
X-HE-Meta: U2FsdGVkX19lttKs30p5G0SeDJYeXTelDkrCILO4HyASeuubSnsVWB1Qp+rXjAD/cZfSSjTjwcNIS+2BlEIBAquIKLm6HMGUH/4vuT0w+8OIv26YIzgiop+SsFM/LxEHCKLsz+scqPIqqauqJMYy44GhistdmfyUW5yqUBP8nuVeb3batv4uiOAxoLonrZHbephmmeOq2YGIKWNYMTMyKpyICJN2NFH/nK9RrkZHw6PXaC97K0cxFCQMnJC+0TkAzUOK6QEQbazRvk8Ns1XzSvJUkKmNzeC1XhNiOiap6S4nEuWpGxsXy9EDoSwkrTymaN0walMl8G2lGc/b6cY2bGFLx7Nqb7ed4RT0Bod7DJUfQrIOl+e8Bc63TyadSXGfQOHomue+6EbSz8gvzgdb+lpxmKaCJItQbrAr+k7O9GB7MUNLitjsIdisH7Q3xSuSAVQ72/aaJffKLy68h4Q0iLnSmyPPSt1i2O2F7oE1mBhJ0Xh7ueSTfvtARxetfwxx4R6pXU7M5OZSWIJtxK6Vi7eoPzvQcEVhgXl6kuqWLRClPwLtbux2wKI2PrlfMMbPr9b6ni+FVqIwSsLMwzIh5mRuky4fjgR4lyqqzD6yFN1wxTNowuJgz+IPrxtro+FfvO5shSA+O6OG81keTbmiA85N+HqXkVUEQygbZFml7ojMLyxEifSBR/vSJgBT9vaU5nOAfiSFsXyry6x1J/ClgQXJDsl/bG9vw3Z3J7g8BvbYJK738bjSxcHCl9QczgBJvBU8HTljB2xdjSg8G0+8cD9+o/Otg9VY43gnvoLk7shPieyNBYBfWZ7bP+b4Wc9fvdhdfr89WpZx0MmmHRnhlo1X1FCLljbwH7g3ME7JXp3VEpKSJIaAwU6NssKCfvJA/BRXjp7NYdK091BSeXICC5XcNfIhMlZxE8BAHYamTSvMR51u7Bv0+CG6AvWK5p5iclx5IZ8zVWh7ZwjELu3
 0LH848b2
 FJQg0RAZawajbbb4eD1Ta6XHi3eRLKrNQkQKvlmo2ZDvbGvGXvDju5EDjJJCN/OhCDKeYKz4BLAU5UJYLJb5scl+mPxIjH4YsjqKbXi3DchNFK+Bdas7g3nfMNS2Wtey5fMK0OI0wIfrhI+It0Up34e4KwRD+qsWGp0xhYmOnDoyqIX12lhrg8Aji/wA/BhcEpGf6A9EWSV3aikfgdicebKdwZ0tfiZ9URouj6ll+7qPjW2A0HrTbUwkQXMizpVAkuKHdUO3WXI2PWzc24eSih2KYKbRFCnlVGzyLGSvH1il7CP423E8e9pcqOgdEgMW6Ip0b1A+qr+Nifi6arTvCiiuz05VU0AyYLxJds7vZW8tIwAd8L5I66hIBeknWEm//ghRVy8qn7i3lG3iMRDoFdbEyuPMr6833GGPVXW77LL2RdUc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A limit counter keeps a value below a limit. An addition fails rather
than take the value above it. The tmpfs size limit uses
percpu_counter_limited_add() for this. It takes no lock while the value
is more than batch * nr_cpus below the limit. With the default batch
size, this range grows as nr_cpus^2: 1.1 GB of pages at 384 CPUs.
Closer to the limit, each addition takes the counter spinlock and sums
all CPUs.

A tree counter has a smaller error bound. But its carries break a
strict check. A carry leaves a level before it arrives at the next one.
A sum taken in between misses it. A carry which arrives first can be
counted twice instead. This is as bad for a negative carry.

So split the value by sign, into two counters which only grow: the
additions and the subtractions. Each one errs in one direction only:

- The additions carry to the next level before they leave the level
  below. A sum read from level 0 up never misses a carry.
- The subtractions carry as usual. A sum read from the root down never
  counts a carry twice.

A carry about to leave an item takes what earlier additions left there.
Until it reaches the root, the check does not see that part. So an item
holding such a carry takes no new arrival. The next carries go straight
to the root. The value is then at most:

  root(additions) + accuracy - root(subtractions)

An addition first adds, then checks after a full barrier. If this bound
is within the limit, it succeeds without a sum or a lock. Within the
accuracy of the limit, the precise sums decide. An addition which does
not fit is undone. The last addition checked sees all the others, so
the limit is never exceeded. Additions must not be made from interrupt
context, and percpu_counter_tree_limit_add() warns if they are.

An addition about to be undone can make a concurrent one fail,
although that one fits. So an amount larger than the batch size is
checked before it is added. If it cannot fit, it fails without being
added. A smaller failed addition retries once if the value leaves room
for it.

The API is percpu_counter_tree_limit_init(), _destroy(), _add(), _sub()
and _precise_sum(). percpu_counter_tree_batch_for_accuracy() chooses
the batch size from the limit.

The shim of the userspace test gains the primitives which the library
now uses.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/percpu_counter_tree.h    |  73 ++++++
 lib/percpu_counter_tree.c              | 322 +++++++++++++++++++++++++
 tools/testing/hpcc/include/hpcc_shim.h |  18 +-
 3 files changed, 411 insertions(+), 2 deletions(-)

diff --git a/include/linux/percpu_counter_tree.h b/include/linux/percpu_counter_tree.h
index 2c27350ce836..dcdb91660bc0 100644
--- a/include/linux/percpu_counter_tree.h
+++ b/include/linux/percpu_counter_tree.h
@@ -130,6 +130,28 @@ long percpu_counter_tree_approximate_sum(struct percpu_counter_tree *counter)
 }
 
 unsigned long percpu_counter_tree_approximate_accuracy(struct percpu_counter_tree *counter);
+unsigned long percpu_counter_tree_batch_for_accuracy(unsigned long accuracy);
+
+/*
+ * A value kept below a limit, such as the blocks used by a file system
+ * with a size limit. It is split by sign into two counters which only
+ * grow: the additions and the subtractions. Each one carries in the
+ * direction that keeps the limit check strict. See "Limit counters" in
+ * lib/percpu_counter_tree.c.
+ */
+struct percpu_counter_tree_limit {
+	/* [0]: the additions, [1]: the subtractions. */
+	struct percpu_counter_tree counters[2];
+};
+
+int percpu_counter_tree_limit_init(struct percpu_counter_tree_limit *limit,
+				   unsigned long batch_size, gfp_t gfp_flags);
+void percpu_counter_tree_limit_destroy(struct percpu_counter_tree_limit *limit);
+bool percpu_counter_tree_limit_add(struct percpu_counter_tree_limit *limit,
+				   unsigned long max, unsigned long amount);
+void percpu_counter_tree_limit_sub(struct percpu_counter_tree_limit *limit,
+				   unsigned long amount);
+unsigned long percpu_counter_tree_limit_precise_sum(struct percpu_counter_tree_limit *limit);
 
 #if IS_ENABLED(CONFIG_KUNIT)
 unsigned int percpu_counter_tree_check_config(void);
@@ -284,6 +306,57 @@ int percpu_counter_tree_subsystem_init(void)
 	return 0;
 }
 
+static inline
+unsigned long percpu_counter_tree_batch_for_accuracy(unsigned long accuracy)
+{
+	return PERCPU_COUNTER_TREE_MAX_BATCH;
+}
+
+/* On UP, the value is a single atomic: the first counter. The second is unused. */
+struct percpu_counter_tree_limit {
+	struct percpu_counter_tree counters[2];
+};
+
+static inline
+int percpu_counter_tree_limit_init(struct percpu_counter_tree_limit *limit,
+				   unsigned long batch_size, gfp_t gfp_flags)
+{
+	return percpu_counter_tree_init(&limit->counters[0], batch_size, gfp_flags);
+}
+
+static inline
+void percpu_counter_tree_limit_destroy(struct percpu_counter_tree_limit *limit)
+{
+}
+
+static inline
+bool percpu_counter_tree_limit_add(struct percpu_counter_tree_limit *limit,
+				   unsigned long max, unsigned long amount)
+{
+	atomic_long_t *count = &limit->counters[0].count;
+	long old = atomic_long_read(count);
+
+	/* Add only an amount which fits. */
+	do {
+		if ((unsigned long)old + amount > max)
+			return false;
+	} while (!atomic_long_try_cmpxchg(count, &old, old + amount));
+	return true;
+}
+
+static inline
+void percpu_counter_tree_limit_sub(struct percpu_counter_tree_limit *limit,
+				   unsigned long amount)
+{
+	atomic_long_sub(amount, &limit->counters[0].count);
+}
+
+static inline
+unsigned long percpu_counter_tree_limit_precise_sum(struct percpu_counter_tree_limit *limit)
+{
+	return atomic_long_read(&limit->counters[0].count);
+}
+
 #endif	/* CONFIG_SMP */
 
 /**
diff --git a/lib/percpu_counter_tree.c b/lib/percpu_counter_tree.c
index 32c4f05d7d7d..9c172fc3e4d7 100644
--- a/lib/percpu_counter_tree.c
+++ b/lib/percpu_counter_tree.c
@@ -157,6 +157,7 @@
 #include <linux/atomic.h>
 #include <linux/export.h>
 #include <linux/percpu.h>
+#include <linux/preempt.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/math.h>
@@ -551,6 +552,7 @@ EXPORT_SYMBOL_GPL(percpu_counter_tree_init_many_lazy);
  * The read barriers between the levels of the precise sum are unrelated
  * to the publication: they order carries, see
  * percpu_counter_tree_precise_sum_unbiased().
+
  */
 
 /**
@@ -1189,6 +1191,326 @@ unsigned long percpu_counter_tree_approximate_accuracy(struct percpu_counter_tre
 }
 EXPORT_SYMBOL_GPL(percpu_counter_tree_approximate_accuracy);
 
+/**
+ * percpu_counter_tree_batch_for_accuracy() - Largest batch size within an accuracy.
+ * @accuracy: The largest accuracy wanted.
+ *
+ * Return: The largest batch size whose accuracy is at most @accuracy. If
+ * even batch size 2 is above it, return 2.
+ */
+unsigned long percpu_counter_tree_batch_for_accuracy(unsigned long accuracy)
+{
+	unsigned long batch_size;
+
+	for (batch_size = PERCPU_COUNTER_TREE_MAX_BATCH; batch_size > 2; batch_size >>= 1) {
+		if (batch_size * tree_topology.accuracy_multiplier - nr_cpu_ids <= accuracy)
+			break;
+	}
+	return batch_size;
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_batch_for_accuracy);
+
+/*
+ * * Limit counters
+ *
+ * A limit counter keeps a value below a limit: an addition fails rather
+ * than take the value above it. The check must be strict, and fast while
+ * the value is far from the limit.
+ *
+ * A carry in flight breaks a strict check. A carry leaves a level before
+ * it arrives at the next one. A sum taken in between misses it. An
+ * addition could then pass the check while the value is above the limit.
+ * A carry could arrive before it leaves instead, but then a sum could
+ * count it twice, which is as bad for a negative carry.
+ *
+ * The value is therefore split by sign into two counters which only grow:
+ * the additions and the subtractions. Each one only carries positive
+ * amounts, so each one can err in one direction only:
+ *
+ * - The additions carry to the next level before they leave the level
+ *   below. A sum may count a carry twice but never misses it, so it is
+ *   never below the precise value.
+ * - The subtractions carry like any other counter, leaving before they
+ *   arrive. A sum may miss a carry but never counts it twice, so it is
+ *   never above the precise value, and neither is the root.
+ *
+ * A carry about to leave an item above level 0 takes with it what earlier
+ * additions left there. Until it reaches the root, that part is neither in
+ * the root nor within the range of the item. An item holding such a carry
+ * therefore takes no new arrival: the next carries go straight to the
+ * root. Each item holds at most one carry on its way up, and what the
+ * completed additions left in it stays within its range. Their residuals
+ * are never negative, so the completed additions are at most
+ * root + accuracy.
+ *
+ * The value is at most root(additions) + accuracy - root(subtractions).
+ * An addition which keeps this bound within the limit fits without any
+ * sum. Within the accuracy of the limit, the sums of both counters
+ * decide.
+ *
+ * Each addition is added first, then checked after a full barrier, and
+ * undone by a subtraction when it does not fit. Of the additions which
+ * passed their check, the one checked last sees all of them, so their
+ * total never exceeds the limit. This holds if additions are not made from
+ * interrupt context, and only amounts added are subtracted.
+ *
+ * An addition about to be undone can make a concurrent one fail although
+ * it would fit. So an amount larger than the batch size is checked before
+ * it is added. When it cannot fit, it is not added at all. A smaller
+ * amount can still be part of the value briefly. So a failed addition
+ * retries once when the value leaves room for it.
+ *
+ * Both counters wrap around: all the arithmetic is modular.
+
+ */
+
+/*
+ * Add @inc to a counter of additions, with carries which arrive at the
+ * next level before they leave the level below. The level 0 counter of
+ * this CPU must stay stable from its read to its store, because its carry
+ * propagates in between. Preemption is disabled, and the counter must not
+ * be updated from interrupt context. This CPU is then the only writer of
+ * that counter, so a plain store is enough.
+ */
+static
+void percpu_counter_tree_add_arrive_first(struct percpu_counter_tree *counter,
+					  unsigned long inc)
+{
+	unsigned int nr_levels = tree_topology.config->nr_levels, level, level_items,
+		     n_arity_order, stride = counter->items_stride, nr_pending = 0, cpu;
+	unsigned long batch_size = percpu_counter_tree_batch_size(counter);
+	struct {
+		atomic_long_t *count;
+		unsigned long carry;
+	} pending[MAX_NR_LEVELS];
+	unsigned long v, carry0, carry, bit_mask;
+	atomic_long_t *item;
+
+	preempt_disable();
+	cpu = smp_processor_id();
+	/* The residuals of a counter of additions are never negative. */
+	v = (unsigned long)READ_ONCE(*this_cpu_ptr(counter->level0)) + inc;
+	carry0 = v & ~(batch_size - 1);
+	carry = carry0;
+	if (!carry)
+		goto out;
+	item = percpu_counter_tree_items(counter);
+	n_arity_order = tree_topology.config->n_arity_order[0];
+	bit_mask = batch_size << n_arity_order;
+	level_items = 1U << (tree_topology.nr_cpus_order - n_arity_order);
+	for (level = 1; level < nr_levels; level++) {
+		/* A multiple of bit_mask goes through this level unchanged. */
+		if (carry & (bit_mask - 1)) {
+			atomic_long_t *count = &item[(cpu & (level_items - 1)) * stride];
+			long old = atomic_long_read(count);
+
+			/*
+			 * An item at or above bit_mask holds a carry on its
+			 * way up: send this one straight to the root, see
+			 * "Limit counters". Otherwise arrive here, and carry
+			 * the multiples of bit_mask the residual now holds.
+			 * The fully ordered cmpxchg orders the arrival before
+			 * the departures below.
+			 */
+			do {
+				if ((unsigned long)old >= bit_mask)
+					goto root;
+			} while (!atomic_long_try_cmpxchg(count, &old, old + carry));
+			carry = ((unsigned long)old + carry) & ~(bit_mask - 1);
+			if (!carry)
+				goto depart;
+			pending[nr_pending].count = count;
+			pending[nr_pending].carry = carry;
+			nr_pending++;
+		}
+		item += level_items * stride;
+		n_arity_order = tree_topology.config->n_arity_order[level];
+		level_items >>= n_arity_order;
+		bit_mask <<= n_arity_order;
+	}
+root:
+	/*
+	 * Unlike atomic_long_add(), this is fully ordered: the carry arrives
+	 * at the root before it leaves the levels below. Its return value is
+	 * not needed.
+	 */
+	atomic_long_add_return(carry, counter->approx_sum);
+depart:
+	/* Leave each level once the carry arrived at all the levels above. */
+	while (nr_pending--)
+		atomic_long_sub(pending[nr_pending].carry, pending[nr_pending].count);
+out:
+	/* The precise sums read it concurrently. */
+	WRITE_ONCE(*this_cpu_ptr(counter->level0), (s8)(v - carry0));
+	preempt_enable();
+}
+
+/*
+ * Sum a counter of additions from level 0 up to the root. A carry arrives
+ * at the next level before it leaves the level below. So the sum may count
+ * a carry twice. It never misses one, so it is never below the precise
+ * value.
+ */
+static
+unsigned long percpu_counter_tree_precise_sum_upper(struct percpu_counter_tree *counter)
+{
+	unsigned int nr_levels = tree_topology.config->nr_levels, level, level_items, i,
+		     stride = counter->items_stride;
+	atomic_long_t *item = percpu_counter_tree_items(counter);
+	unsigned long sum = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		sum += (unsigned long)READ_ONCE(*per_cpu_ptr(counter->level0, cpu));
+	level_items = 1U << tree_topology.nr_cpus_order;
+	for (level = 1; level < nr_levels; level++) {
+		smp_rmb();	/* Read the level below before this one. */
+		level_items >>= tree_topology.config->n_arity_order[level - 1];
+		for (i = 0; i < level_items; i++)
+			sum += (unsigned long)atomic_long_read(&item[i * stride]);
+		item += level_items * stride;
+	}
+	smp_rmb();	/* Read the levels below before the root. */
+	return sum + (unsigned long)atomic_long_read(counter->approx_sum);
+}
+
+/**
+ * percpu_counter_tree_limit_init() - Initialize a limit counter.
+ * @limit: The limit counter to initialize. Its memory is provided by the caller.
+ * @batch_size: The batch size of both counters, see percpu_counter_tree_init().
+ * @gfp_flags: gfp flags for the per-CPU counters and tree items.
+ *
+ * The two counters share their per-CPU counters and tree item cache lines.
+ * See percpu_counter_tree_batch_for_accuracy() to choose the batch size
+ * from the limit.
+ *
+ * Return: 0 on success, -EINVAL for an invalid @batch_size, -ENOMEM when
+ * out of memory.
+ */
+int percpu_counter_tree_limit_init(struct percpu_counter_tree_limit *limit,
+				   unsigned long batch_size, gfp_t gfp_flags)
+{
+	return percpu_counter_tree_init_many(limit->counters, ARRAY_SIZE(limit->counters),
+					     batch_size, gfp_flags);
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_limit_init);
+
+/**
+ * percpu_counter_tree_limit_destroy() - Destroy a limit counter.
+ * @limit: The limit counter to destroy.
+ *
+ * A zeroed limit counter was never initialized and is left as is. Error
+ * paths can thus destroy it unconditionally.
+ */
+void percpu_counter_tree_limit_destroy(struct percpu_counter_tree_limit *limit)
+{
+	if (!limit->counters[0].level0)
+		return;
+	percpu_counter_tree_destroy_many(limit->counters, ARRAY_SIZE(limit->counters));
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_limit_destroy);
+
+/**
+ * percpu_counter_tree_limit_precise_sum() - Return the precise value of a limit counter.
+ * @limit: The limit counter.
+ *
+ * Exact when no update runs concurrently. With concurrent updates, it can
+ * be above the precise value. It can count a carry in flight twice. It
+ * also counts the additions which failed and are not undone yet.
+ *
+ * Return: The value: the additions minus the subtractions.
+ */
+unsigned long percpu_counter_tree_limit_precise_sum(struct percpu_counter_tree_limit *limit)
+{
+	/* Subtractions first, see percpu_counter_tree_limit_add(). */
+	unsigned long subtracted = percpu_counter_tree_precise_sum_unbiased(&limit->counters[1]);
+
+	smp_rmb();	/* Read the subtractions before the additions. */
+	return percpu_counter_tree_precise_sum_upper(&limit->counters[0]) - subtracted;
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_limit_precise_sum);
+
+/**
+ * percpu_counter_tree_limit_add() - Add to a limit counter, unless it exceeds a limit.
+ * @limit: The limit counter.
+ * @max: The limit: the value never exceeds it.
+ * @amount: The amount to add.
+ *
+ * Far from @max, the check reads the roots of the two counters. Within
+ * the accuracy of @max, it sums them, and retries once when concurrent
+ * failed additions may have made it fail. Must not be called from
+ * interrupt context. See "Limit counters" above
+ * percpu_counter_tree_add_arrive_first().
+ *
+ * Concurrent additions which do not fit can make it fail although
+ * @amount fits. An addition of at most the batch size is part of the
+ * value until it is undone.
+ *
+ * Return: true if @amount was added. false if the value would exceed
+ * @max, or seemed to as above. The value is then unchanged.
+ */
+bool percpu_counter_tree_limit_add(struct percpu_counter_tree_limit *limit,
+				   unsigned long max, unsigned long amount)
+{
+	struct percpu_counter_tree *add = &limit->counters[0], *sub = &limit->counters[1];
+	unsigned long subtracted;
+	bool retried = false;
+
+	WARN_ON_ONCE(!in_task());
+	/*
+	 * Check a large amount before adding it: once added, it makes the
+	 * concurrent additions fail until it is undone. Failing early never
+	 * exceeds the limit.
+	 */
+	if (amount > percpu_counter_tree_batch_size(add)) {
+		/* Acquire: read the subtractions before the additions. */
+		subtracted = (unsigned long)atomic_long_read_acquire(sub->approx_sum);
+		if ((unsigned long)atomic_long_read(add->approx_sum) +
+		    percpu_counter_tree_accuracy(add) - subtracted + amount > max &&
+		    percpu_counter_tree_limit_precise_sum(limit) + amount > max)
+			return false;
+	}
+retry:
+	percpu_counter_tree_add_arrive_first(add, amount);
+	/* Order this addition before the check. Pairs with the other additions. */
+	smp_mb();
+	/*
+	 * Read the subtractions before the additions, with an acquire. An
+	 * amount subtracted was added before. So the additions read after it
+	 * include it, and the difference is not below the value. This is why
+	 * the root of the additions is read again here: the addition rarely
+	 * reaches it, and would read it before the subtractions.
+	 */
+	subtracted = (unsigned long)atomic_long_read_acquire(sub->approx_sum);
+	if ((unsigned long)atomic_long_read(add->approx_sum) +
+	    percpu_counter_tree_accuracy(add) - subtracted <= max)
+		return true;
+	if (percpu_counter_tree_limit_precise_sum(limit) <= max)
+		return true;
+	percpu_counter_tree_add(sub, amount);
+	/* Concurrent additions about to be undone may have made this one fail. */
+	if (!retried && percpu_counter_tree_limit_precise_sum(limit) + amount <= max) {
+		retried = true;
+		goto retry;
+	}
+	return false;
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_limit_add);
+
+/**
+ * percpu_counter_tree_limit_sub() - Subtract from a limit counter.
+ * @limit: The limit counter.
+ * @amount: The amount to subtract, previously added.
+ *
+ * Unlike percpu_counter_tree_limit_add(), it can be called from any context.
+ */
+void percpu_counter_tree_limit_sub(struct percpu_counter_tree_limit *limit,
+				   unsigned long amount)
+{
+	percpu_counter_tree_add(&limit->counters[1], amount);
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_limit_sub);
+
 /* Calculate the number of tree items and the accuracy multiplier. */
 static
 void __init calculate_topology(void)
diff --git a/tools/testing/hpcc/include/hpcc_shim.h b/tools/testing/hpcc/include/hpcc_shim.h
index d321c8363b0b..a455e6432b5c 100644
--- a/tools/testing/hpcc/include/hpcc_shim.h
+++ b/tools/testing/hpcc/include/hpcc_shim.h
@@ -63,12 +63,16 @@ static inline int get_count_order(unsigned int count)
 }
 
 #define atomic_long_read(v)			READ_ONCE((v)->counter)
+#define atomic_long_read_acquire(v)		READ_ONCE((v)->counter)
 #define atomic_long_set(v, i)			WRITE_ONCE((v)->counter, (i))
 #define atomic_long_add(i, v)			((void)((v)->counter += (i)))
 #define atomic_long_add_return_relaxed(i, v)	((v)->counter += (i))
-#define atomic_long_add_return_release(i, v)	((v)->counter += (i))
-#define smp_rmb()				barrier()
+#define atomic_long_sub(i, v)			((void)((v)->counter -= (i)))
 /* The harness runs on one thread: ordering primitives are plain accesses. */
+#define smp_rmb()				barrier()
+#define smp_mb()				barrier()	/* One thread: no reordering. */
+#define preempt_disable()			barrier()
+#define preempt_enable()			barrier()
 #define smp_load_acquire(p)			READ_ONCE(*(p))
 #define smp_store_release(p, v)			WRITE_ONCE(*(p), (v))
 
@@ -82,11 +86,17 @@ static inline bool atomic_long_try_cmpxchg_relaxed(atomic_long_t *v, long *old,
 	return false;
 }
 
+#define atomic_long_add_return(i, v)		((v)->counter += (i))
+#define atomic_long_add_return_release(i, v)	((v)->counter += (i))
+#define atomic_long_try_cmpxchg(v, old, new)	atomic_long_try_cmpxchg_relaxed(v, old, new)
+
 /* Simulated topology, and CPU on which the current code runs. */
 extern unsigned int nr_cpu_ids;
 extern unsigned int hpcc_current_cpu;
 
 #define raw_smp_processor_id()		hpcc_current_cpu
+#define smp_processor_id()		hpcc_current_cpu
+#define in_task()			true
 #define for_each_possible_cpu(cpu)	for ((cpu) = 0; (cpu) < (int)nr_cpu_ids; (cpu)++)
 
 /*
@@ -193,6 +203,10 @@ static inline bool __hpcc_this_cpu_try_cmpxchg(s8 *pcp, s8 *old, s8 new)
 }
 
 #define this_cpu_read(pcp)	(*per_cpu_ptr(&(pcp), hpcc_current_cpu))
+#define this_cpu_write(pcp, v)	((void)(*per_cpu_ptr(&(pcp), hpcc_current_cpu) = (v)))
+#define this_cpu_ptr(ptr)	per_cpu_ptr(ptr, hpcc_current_cpu)
+#define __this_cpu_read(pcp)	this_cpu_read(pcp)
+#define __this_cpu_write(pcp, v)	this_cpu_write(pcp, v)
 #define this_cpu_try_cmpxchg(pcp, ovalp, nval)	\
 	__hpcc_this_cpu_try_cmpxchg(&(pcp), (ovalp), (nval))
 
-- 
2.47.3


