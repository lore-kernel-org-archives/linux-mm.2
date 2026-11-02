Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16140606EE94
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 19:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=HlOY4F6A
Received: by kanga.kvack.org (Postfix)
	id C0CDF6B05B6; Mon,  2 Nov 2026 14:07:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70066B05B9; Mon,  2 Nov 2026 14:07:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E9A76B05BD; Mon,  2 Nov 2026 14:07:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5545B6B05B9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:07:37 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27F26C0218
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:07:36 +0000 (UTC)
X-FDA: 85391112912.15.EC17220
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf13.hostedemail.com (Postfix) with ESMTP id 73EDB20009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:07:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=HlOY4F6A;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf13.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793646454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ec1L3fOkUw96fmBt7XeQgMFxmxwUUekyLxlS3pXawYU=;
	b=fKqebPn0m3E2CoeELalpLKPZEsxWRjhEvMT2QReB/+Q55zJnJlgW9I52ru+JzNRwHqYVr2
	Ba86uRUrRcesRHqADKPSzLsm8KPExy3A80nKKeP+bMlviXUIQsjY5XhBMXFCumFP0u3ttg
	s5fcs7TKCOuGX1/5As3DWgmPdSAaBeM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793646454;
	b=EGvBbIJ3ei2eZDQVsGKS87jWBIHIzgmSvVHruzG0y6X+3leElUX/kvntaghVhEfcEtz34Z
	EEpisrkHP8e3V+omTBQf/kPOLsqxk7u+NtQ46sQ9KtEyOgB1iepItEuMkW7dyIAx6429GJ
	c/nJfPBtHsQXlibPE18tSvjn/4hl+pQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=HlOY4F6A;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf13.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793646453;
	bh=ec1L3fOkUw96fmBt7XeQgMFxmxwUUekyLxlS3pXawYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HlOY4F6AwvMpIVf6uziYZAeVwQDAJeR5P6z1PpbE8bS5DrE6VU/wH94MIcPWXGiWu
	 h/EYNOU6I9rIyfhgWu6d163DB4D5H14Y1WM7DNLPivNnc9cjsr7XQkO5meDNQF5rzG
	 ddbGOBZZSi4fC2PEB0kuNIxwGPz2cg1Dhovsempnh/82evzEzgzJDnhqONXeWZjJ3J
	 Widn7SzYenSJVS97N/tHVgKp6hLXdZ9n2rWugY/J6IJ5itOIcuXrOiqCFSmNfyJNA1
	 4wA5eEKCrLzhqZgw2OMHby1pjV2+H01oEKLHrWkjeL6i75/kwZyvZOFOOJaBPor5n7
	 GhJ+sRq6gSDww==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jJLn06f1SzKGR;
	Mon, 02 Nov 2026 14:07:32 -0500 (EST)
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
	Josh Law <objecting@objecting.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-doc@vger.kernel.org,
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
	Oleg Nesterov <oleg@redhat.com>
Subject: [RFC PATCH v23 06/10] lib: percpu_counter_tree: add lazy tree activation
Date: Mon,  2 Nov 2026 14:07:04 -0500
Message-Id: <20261102190708.1287100-7-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261102190708.1287100-1-mathieu.desnoyers@efficios.com>
References: <20261102190708.1287100-1-mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zcciyuota6c75akh74ee7mhtnc6s6u18
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 73EDB20009
X-HE-Tag: 1793646454-196934
X-HE-Meta: U2FsdGVkX1+0daSfleWPdxstE91jYX/P9cnRJdBvwleeKocN/Hdnr6pO+R3EPvlmM1zM1nUzwZUe5yi0iIEpMiRMjA7YWhnqV28MffecKPVA6rVuzvOKdqTtPYG+IWpUaowMKrEDNzN8FydzH8x5kG8Is3eWCYe0VT0gU5jMfCvcjhHCp15UeLgMH9PcGpRfVJa8MQo8OH4hQbLzFF+H3Ubgp+dwx1AKcT9sm41u3fNe3RDbHomNvAyVRqEPmRvuQ7/hI9dk+NOg3wT49m3eRWPSolKh4VNnmvsJPScZ3t8mkgySvzeUjvYGkyPckyOgvxCsgfNfb+3hqD0yZEojsAw0IsnzvppEBoXglg/aplkNdmKQ5Ue6UgXR85In1JR5Js55KKdFjlrK9vh77OMYs6PRO1ApsJ4A3O4we67mvSF4zbTeLwCSYuMWPQwn1DvRk1yaUlOw0k1kHXNZnMDbdFN2s9K7eWgwi658xShphTTLiwLRkSoVM0LqA+LFS4od9DORGGxonDUq6iTOw48+xX+F2fDqboUbAkeJbhbCn+nvz029pTds6/ow/6xhodb73XSQP8L6pfmjAwqBFnZAruXouTvl7vnvOM3dAThcPnkFQlKqLud0CcdbNqxrBfbWnFUtmyA6yQuazayQt2HvAlwXgL1FLMeL/peCM8QKI/Cios9v7xtV3GvtuafUC36fhHltj93Jkq1vLRYfY9DkAo856kzaBlvIuqH63TZOV4TvAI/KaJ4viqolK4YB5rzEz6AqqPnqQwgtypvzIgQ2jLbbpN/0yNwQquuGAny+Buzqky5OeWM3F31sh1Nx7768mUVAFs3JqTRotY6VohkPIb6czgjPV0pqvMEokLHpvMZj5IYaZ02uXHWqNIm74iSXhKaYH6h9RrtxXCEXVDRO8HnK+B6YGqT15feXUR8JMXyqdU3RXXGCMPu5VSwMaLdasyHElts3XeIvs1TEznl
 0hDMGUHl
 zv8Px2UJm4l1NKVhvWEuPVa+Bem2v2//icYrlXIQ6d5iiIi7IZC+iouXY31RL5drkDTwfZdlxELdfl3VilnsFCv2QnkDCQN2hC1m4x7sLVBVE2bwhiM2qCUFUjwnR7mUtS7hRQ4Dx+RjwdOirMOqiRE7UVy+uRPvcSMhbgUauOv4Wx0h1jMc8Onh2Vmu6yR3+qz3jRdRX48CZ+5nxH/+MnHeydfcXg26DLIr3pKAV6RJtuw9JDm0Hbj2XwtgYkvOJFOv8/BEhmcVZF0IOC6T+b6P4CAXs1GUFsjoGQzxMLfxV8EsYsooZFYafYT84s1LjSN4Kw0IE8lfYxho0cVdAzDcihwntBaHGw5MTav09OWLXQjOJvF5jr6I1SoKZa0tHsdToPUy4WxCjCYJpokQPDksAlYvd4bKX8Yc7JmjCVGzvf4A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add counters which start without their tree, for counters which may
never need its scalability, such as the RSS counters of a
single-threaded process.

percpu_counter_tree_init_many_lazy() initializes counters without
allocating their per-cpu counters and tree items.  Until
percpu_counter_tree_activate_many() allocates and publishes them, the
counters are exact:

- percpu_counter_tree_add_owner() adds to the bias of the counter,
  without atomic instruction.  Its calls for a given counter must not
  run concurrently with each other: they come from a single context,
  the owner chosen by the user of the counters, such as a task.
- percpu_counter_tree_add() adds atomically to a new atomic bias of the
  counter, for any other updater.

The precise and approximate sums read both biases, in O(1).  The
activation does not move these values: the sums keep reading them along
with the tree, so updates racing with the activation are not lost,
whichever side of it they land on.  The bias only has the owner as
writer, and the atomic bias only receives atomic additions, before and
after the activation.  After the activation, both update functions add
to the tree, and percpu_counter_tree_active() reports it, so a user can
skip selecting between them.  The accuracy range of a lazily initialized
counter is the range of its tree, even before activation, which keeps
the comparison functions correct across an activation.

The activations of the same counters must be serialized by the caller,
for instance with a mutex: a concurrent activation would publish a
second tree.  The activation publishes the root, then the per-cpu
counters, of each counter in order, with release ordering.  Once the
last counter is active, the activation is complete, so a caller which
sees it active can skip the activation and its serialization; it may not
observe the other counters active yet, which only delays their updates
going to the tree.  The update functions only reach the per-cpu counters
through their published pointer, which orders their initialization
before their use by address dependency, as for rcu_dereference(),
without an acquire on the fast path.  The approximate sum reaches the
root the same way.  The carry path reads the root pointer after the
per-cpu counters pointer with a read barrier between them, and the
precise sum reads the per-cpu counters pointer with an acquire.

struct percpu_counter_tree grows from 32 to 40 bytes with the atomic
bias, the size of struct percpu_counter.

Test the lazy counters:

- KUnit: exact sums before activation with owner and atomic updates,
  set(), idempotent activation, destruction without activation, and an
  activation racing with an owner and remote updaters on other CPUs,
  which also activate the tree when released, serialized by a mutex,
  checking that the counter is exact while they pause, that the tree is
  active once an activation returns, and that no update is lost across
  the activations.
- Userspace test: random owner and atomic updates from random CPUs,
  exact before the tree is activated halfway, with the accuracy and
  comparison checks after each update.  The test checks that the
  activation allocates one tree, that activating again allocates
  nothing, and that destroying the counter frees the tree.  The shim
  provides the ordering primitives as plain accesses.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 .../core-api/percpu-counter-tree.rst          |  28 ++
 include/linux/percpu_counter_tree.h           |  81 ++++-
 lib/percpu_counter_tree.c                     | 315 ++++++++++++++++--
 lib/tests/percpu_counter_tree_kunit.c         | 218 ++++++++++++
 tools/testing/hpcc/include/hpcc_shim.h        |  28 +-
 tools/testing/hpcc/main.c                     |  47 +++
 6 files changed, 674 insertions(+), 43 deletions(-)

diff --git a/Documentation/core-api/percpu-counter-tree.rst b/Documentation/core-api/percpu-counter-tree.rst
index 6b381deacd83..138e9b74b0c8 100644
--- a/Documentation/core-api/percpu-counter-tree.rst
+++ b/Documentation/core-api/percpu-counter-tree.rst
@@ -74,6 +74,34 @@ takes no lock: an update which carries from the per-cpu counter to the
 upper levels can be counted in part, the residual it left below read and
 its carry missed on the way up.
 
+Lazy Tree Activation
+====================
+
+Counters initialized with percpu_counter_tree_init_many_lazy() start
+without their per-cpu counters and tree items, for counters which may
+never need the scalability of the tree. Until
+percpu_counter_tree_activate_many() allocates and publishes the tree,
+the counters are exact:
+
+ * percpu_counter_tree_add_owner() adds to the bias of the counter,
+   written only by its owner, a single context chosen by the user of the
+   counters, such as a task, without atomic instruction.
+
+ * percpu_counter_tree_add() adds to the atomic bias of the counter, for
+   any other updater.
+
+The precise and approximate sums read both, in O(1), and count each
+update whole. The activation does not move these values: the sums keep
+reading them along with the tree, so updates racing with the activation
+are not lost, whichever side of it they land on. The bias only has the
+owner as writer, and the atomic bias only receives atomic additions,
+before and after the activation. After activation, both update functions
+add to the tree, and the approximation has the accuracy of the tree.
+
+The activations of the same counters must be serialized by the caller:
+a concurrent activation would publish a second tree and lose the
+updates made to the first.
+
 Use Cases
 =========
 
diff --git a/include/linux/percpu_counter_tree.h b/include/linux/percpu_counter_tree.h
index 741a6877aa99..60ef1da22bd3 100644
--- a/include/linux/percpu_counter_tree.h
+++ b/include/linux/percpu_counter_tree.h
@@ -32,10 +32,22 @@ struct percpu_counter_tree {
 	unsigned int items_stride;	/* Distance between this counter's consecutive items. */
 	/*
 	 * Approximate sum: this counter's item of the root, in the tree
-	 * items allocated with the per-CPU counters.
+	 * items allocated with the per-CPU counters. NULL until the tree of a
+	 * counter initialized by percpu_counter_tree_init_many_lazy() is
+	 * activated.
 	 */
 	atomic_long_t *approx_sum;
-	long bias;	/* Bias to apply to counter precise and approximate values. */
+	/*
+	 * Bias to apply to counter precise and approximate values. Before the
+	 * tree is activated, it also accumulates the updates of
+	 * percpu_counter_tree_add_owner(), written only by the owner.
+	 */
+	long bias;
+	/*
+	 * Updates of percpu_counter_tree_add() made before the tree is
+	 * activated, also applied to the precise and approximate values.
+	 */
+	atomic_long_t atomic_bias;
 };
 
 int percpu_counter_tree_init_many(struct percpu_counter_tree *counters,
@@ -43,10 +55,15 @@ int percpu_counter_tree_init_many(struct percpu_counter_tree *counters,
 				  gfp_t gfp_flags);
 int percpu_counter_tree_init(struct percpu_counter_tree *counter,
 			     unsigned long batch_size, gfp_t gfp_flags);
+int percpu_counter_tree_init_many_lazy(struct percpu_counter_tree *counters,
+				       unsigned int nr_counters, unsigned long batch_size);
+int percpu_counter_tree_activate_many(struct percpu_counter_tree *counters,
+				      unsigned int nr_counters, gfp_t gfp_flags);
 void percpu_counter_tree_destroy_many(struct percpu_counter_tree *counters,
 				      unsigned int nr_counters);
 void percpu_counter_tree_destroy(struct percpu_counter_tree *counter);
 void percpu_counter_tree_add(struct percpu_counter_tree *counter, long inc);
+void percpu_counter_tree_add_owner(struct percpu_counter_tree *counter, long inc);
 long percpu_counter_tree_precise_sum(struct percpu_counter_tree *counter);
 int percpu_counter_tree_approximate_compare(struct percpu_counter_tree *a,
 					    struct percpu_counter_tree *b);
@@ -57,6 +74,26 @@ int percpu_counter_tree_precise_compare_value(struct percpu_counter_tree *counte
 void percpu_counter_tree_set(struct percpu_counter_tree *counter, long v);
 int percpu_counter_tree_subsystem_init(void);
 
+/**
+ * percpu_counter_tree_active() - Query whether the tree of a counter is active.
+ * @counter: The counter to query.
+ *
+ * A counter initialized by percpu_counter_tree_init_many() is active. A
+ * counter initialized by percpu_counter_tree_init_many_lazy() becomes
+ * active when percpu_counter_tree_activate_many() publishes its tree, and
+ * stays active. Once active, percpu_counter_tree_add() and
+ * percpu_counter_tree_add_owner() both add to the tree, so a user can skip
+ * selecting between them.
+ *
+ * Return: true if the updates of @counter go to its tree.
+ */
+static inline
+bool percpu_counter_tree_active(struct percpu_counter_tree *counter)
+{
+	/* No ordering: the update functions and the sums read level0 again. */
+	return !!READ_ONCE(counter->level0);
+}
+
 /**
  * percpu_counter_tree_approximate_sum() - Return approximate counter sum.
  * @counter: The counter to sum.
@@ -70,9 +107,19 @@ int percpu_counter_tree_subsystem_init(void);
 static inline
 long percpu_counter_tree_approximate_sum(struct percpu_counter_tree *counter)
 {
-	unsigned long v = atomic_long_read(counter->approx_sum);
+	/*
+	 * Pairs with the release of approx_sum in
+	 * percpu_counter_tree_activate_many(): the root is zeroed before its
+	 * pointer, and the address dependency orders the read of the root
+	 * after it, as for rcu_dereference().
+	 */
+	atomic_long_t *approx_sum = READ_ONCE(counter->approx_sum);
+	unsigned long v = (unsigned long)READ_ONCE(counter->bias) +
+			  (unsigned long)atomic_long_read(&counter->atomic_bias);
 
-	return (long)(v + (unsigned long)READ_ONCE(counter->bias));
+	if (approx_sum)
+		v += (unsigned long)atomic_long_read(approx_sum);
+	return (long)v;
 }
 
 unsigned long percpu_counter_tree_approximate_accuracy(struct percpu_counter_tree *counter);
@@ -115,6 +162,26 @@ int percpu_counter_tree_init(struct percpu_counter_tree *counter,
 	return percpu_counter_tree_init_many(counter, 1, batch_size, gfp_flags);
 }
 
+static inline
+int percpu_counter_tree_init_many_lazy(struct percpu_counter_tree *counters,
+				       unsigned int nr_counters, unsigned long batch_size)
+{
+	return percpu_counter_tree_init_many(counters, nr_counters, batch_size, 0);
+}
+
+static inline
+int percpu_counter_tree_activate_many(struct percpu_counter_tree *counters,
+				      unsigned int nr_counters, gfp_t gfp_flags)
+{
+	return 0;
+}
+
+static inline
+bool percpu_counter_tree_active(struct percpu_counter_tree *counter)
+{
+	return true;
+}
+
 static inline
 void percpu_counter_tree_destroy_many(struct percpu_counter_tree *counters,
 				      unsigned int nr_counters)
@@ -192,6 +259,12 @@ void percpu_counter_tree_add(struct percpu_counter_tree *counter, long inc)
 	atomic_long_add(inc, &counter->count);
 }
 
+static inline
+void percpu_counter_tree_add_owner(struct percpu_counter_tree *counter, long inc)
+{
+	percpu_counter_tree_add(counter, inc);
+}
+
 static inline
 long percpu_counter_tree_approximate_sum(struct percpu_counter_tree *counter)
 {
diff --git a/lib/percpu_counter_tree.c b/lib/percpu_counter_tree.c
index 67cdb22c3786..32c4f05d7d7d 100644
--- a/lib/percpu_counter_tree.c
+++ b/lib/percpu_counter_tree.c
@@ -328,10 +328,12 @@ int __percpu_counter_tree_init(struct percpu_counter_tree *counter,
 		return -EINVAL;
 	counter->batch_order = ilog2(batch_size);
 	counter->bias = 0;
+	atomic_long_set(&counter->atomic_bias, 0);
 	counter->level0 = level0;
 	counter->items_stride = items_stride;
-	/* The root is the last item. */
-	counter->approx_sum = &items[(tree_topology.nr_items - 1) * items_stride];
+	/* The root is the last item, allocated by the activation if lazy. */
+	counter->approx_sum = items ?
+		&items[(tree_topology.nr_items - 1) * items_stride] : NULL;
 	return 0;
 }
 
@@ -364,6 +366,26 @@ unsigned long percpu_counter_tree_accuracy(struct percpu_counter_tree *counter)
 	return batch_size * tree_topology.accuracy_multiplier - nr_cpu_ids;
 }
 
+/* Initialize @nr_counters counters, with their per-CPU counters and tree items, or NULL if lazy. */
+static
+int __percpu_counter_tree_init_many(struct percpu_counter_tree *counters,
+				    unsigned int nr_counters, unsigned long batch_size,
+				    s8 __percpu *level0, atomic_long_t *items)
+{
+	unsigned int items_stride = percpu_counter_tree_items_stride(nr_counters);
+	unsigned int i;
+	int ret;
+
+	for (i = 0; i < nr_counters; i++) {
+		ret = __percpu_counter_tree_init(&counters[i], batch_size,
+						 level0 ? level0 + i : NULL,
+						 items ? items + i : NULL, items_stride);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
 /**
  * percpu_counter_tree_init_many() - Initialize many per-CPU counter trees.
  * @counters: An array of @nr_counters counters to initialize.
@@ -392,10 +414,8 @@ int percpu_counter_tree_init_many(struct percpu_counter_tree *counters,
 				  unsigned int nr_counters, unsigned long batch_size,
 				  gfp_t gfp_flags)
 {
-	unsigned int items_stride = percpu_counter_tree_items_stride(nr_counters);
 	s8 __percpu *level0;
 	atomic_long_t *items;
-	unsigned int i;
 	int ret;
 
 	/* The tree shape is selected by percpu_counter_tree_subsystem_init() at boot. */
@@ -410,15 +430,9 @@ int percpu_counter_tree_init_many(struct percpu_counter_tree *counters,
 		ret = -ENOMEM;
 		goto free_level0;
 	}
-	for (i = 0; i < nr_counters; i++) {
-		ret = __percpu_counter_tree_init(&counters[i], batch_size, level0 + i,
-						 items + i, items_stride);
-		if (ret)
-			goto free_items;
-	}
-	return 0;
-
-free_items:
+	ret = __percpu_counter_tree_init_many(counters, nr_counters, batch_size, level0, items);
+	if (!ret)
+		return 0;
 	percpu_counter_tree_free_items(items, nr_counters);
 free_level0:
 	free_percpu(level0);
@@ -450,6 +464,163 @@ int percpu_counter_tree_init(struct percpu_counter_tree *counter,
 }
 EXPORT_SYMBOL_GPL(percpu_counter_tree_init);
 
+/**
+ * percpu_counter_tree_init_many_lazy() - Initialize many counters, without their tree.
+ * @counters: An array of @nr_counters counters to initialize.
+ *	      Their memory is provided by the caller.
+ * @nr_counters: The number of counter trees to initialize
+ * @batch_size: The batch size, as for percpu_counter_tree_init_many().
+ *
+ * Initialize counters without allocating their per-CPU counters and tree
+ * items, for counters which may never need the scalability of the tree,
+ * such as the RSS counters of a single-threaded process. Until
+ * percpu_counter_tree_activate_many() allocates the tree, the counters
+ * are exact: percpu_counter_tree_add_owner() adds to the bias, written
+ * only by the owner, percpu_counter_tree_add() adds to the atomic bias,
+ * and the precise and approximate sums read both in O(1).
+ * percpu_counter_tree_destroy_many() and percpu_counter_tree_set() work on
+ * counters which were never activated. The accuracy range of a lazily
+ * initialized counter is the range of its tree, even before activation,
+ * which keeps the comparison functions correct across an activation.
+ * The batch size is fixed here: the activation only publishes the per-CPU
+ * counters and the tree, so updaters read the batch size without ordering.
+ *
+ * Return:
+ * * %0: Success
+ * * %-EINVAL:		- Invalid @batch_size argument
+ */
+int percpu_counter_tree_init_many_lazy(struct percpu_counter_tree *counters,
+				       unsigned int nr_counters, unsigned long batch_size)
+{
+	/* The tree shape is selected by percpu_counter_tree_subsystem_init() at boot. */
+	if (WARN_ON_ONCE(tree_topology.nr_items == UINT_MAX))
+		return -EINVAL;
+	return __percpu_counter_tree_init_many(counters, nr_counters, batch_size, NULL, NULL);
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_init_many_lazy);
+
+/*
+ * Publication of the tree
+ *
+ * The updaters and the readers of a counter take no lock, and may run
+ * while percpu_counter_tree_activate_many() publishes its tree. The
+ * activation allocates the per-CPU counters and the tree items zeroed,
+ * then publishes two pointers per counter, each with a store-release:
+ *
+ * - the release of approx_sum: the root is zeroed before its pointer,
+ * - the release of level0, after it: the per-CPU counters, the tree items
+ *   and approx_sum are set before level0.
+ *
+ * level0 opens the tree to updates: until it is published, the tree is
+ * empty. Each load of a published pointer pairs with one of the releases:
+ *
+ * - Update fast path, percpu_counter_tree_add() and
+ *   percpu_counter_tree_add_owner(): READ_ONCE(level0), then the per-CPU
+ *   counters through it. The address dependency pairs with the release of
+ *   level0, as for rcu_dereference().
+ * - Carry slow path: smp_rmb() after the read of level0, then
+ *   READ_ONCE(approx_sum). Pairs with the release of level0, which
+ *   follows the store of approx_sum.
+ * - Precise sum: smp_load_acquire(level0), then approx_sum, the tree items
+ *   and the per-CPU counters. Pairs with the release of level0.
+ * - Approximate sum: READ_ONCE(approx_sum), then the root through it. The
+ *   address dependency pairs with the release of approx_sum.
+ * - percpu_counter_tree_active(): READ_ONCE(level0), without ordering. It
+ *   only selects the update function, which reads level0 again, or lets
+ *   the caller skip an activation which is complete.
+ * - Activations: serialized by the caller, for instance with a mutex,
+ *   which orders a complete activation before the check of level0 at the
+ *   start of the next one.
+ *
+ * The update fast path has no acquire. smp_load_acquire() is free on
+ * strongly ordered architectures such as x86, but on weakly ordered ones,
+ * such as arm64, powerpc and RISC-V, it costs an ordering load or a barrier
+ * on every update, to order a publication which happens at most once in
+ * the life of a counter. The address dependency orders the per-CPU
+ * counters, reached through level0, at no cost. It does not order
+ * approx_sum, a separate field: the carry slow path, taken only when an
+ * update carries, pays an smp_rmb() to read it, and the precise sum, which
+ * reads the whole tree, reads level0 with an acquire.
+ *
+ * Missing the publication is harmless. An updater which reads level0 as
+ * NULL adds to the bias (owner) or to the atomic bias (others), and a
+ * reader which reads a NULL pointer sums the bias and the atomic bias:
+ * the sums keep reading both after the activation, and the tree receives
+ * no update before level0 is published.
+ *
+ * The read barriers between the levels of the precise sum are unrelated
+ * to the publication: they order carries, see
+ * percpu_counter_tree_precise_sum_unbiased().
+ */
+
+/**
+ * percpu_counter_tree_activate_many() - Activate the tree of lazily initialized counters.
+ * @counters: The array of @nr_counters counters passed to
+ *	      percpu_counter_tree_init_many_lazy().
+ * @nr_counters: The number of counters.
+ * @gfp_flags: gfp flags to pass to the per-CPU and tree item allocators.
+ *
+ * Allocate the per-CPU counters and the tree items, and publish them:
+ * later updates go to the tree, and the approximation then has the
+ * accuracy of the tree. The updates made before activation stay in the
+ * bias and the atomic bias, which the sums keep reading, so updates racing
+ * with the activation are not lost: the bias only has the owner as writer,
+ * and the atomic bias only receives atomic additions. Activating active
+ * counters does nothing. @counters and @nr_counters must be those passed
+ * to percpu_counter_tree_init_many_lazy().
+ *
+ * The activations of the same counters must be serialized by the caller,
+ * for instance with a mutex: a concurrent activation would publish a second
+ * tree and lose the updates made to the first. The counters are published
+ * in order: once percpu_counter_tree_active() reports the last one active,
+ * the activation is complete, and a caller can skip it and its
+ * serialization. The caller may not observe the other counters active yet,
+ * which only delays their updates going to the tree.
+ *
+ * Return:
+ * * %0: Success
+ * * %-EINVAL:		- @nr_counters differs from percpu_counter_tree_init_many_lazy()
+ * * %-ENOMEM:		- Out of memory
+ */
+int percpu_counter_tree_activate_many(struct percpu_counter_tree *counters,
+				      unsigned int nr_counters, gfp_t gfp_flags)
+{
+	s8 __percpu *level0;
+	atomic_long_t *items, *root;
+	unsigned int i;
+
+	/* Serialized by the caller: a previous activation is complete. */
+	if (counters[0].level0)
+		return 0;
+	/* The tree items are sized for @nr_counters, at the stride set by the initialization. */
+	if (WARN_ON_ONCE(counters[0].items_stride !=
+			 percpu_counter_tree_items_stride(nr_counters)))
+		return -EINVAL;
+	level0 = __alloc_percpu_gfp(nr_counters * sizeof(*level0),
+				    __alignof__(*counters->level0), gfp_flags);
+	if (!level0)
+		return -ENOMEM;
+	items = percpu_counter_tree_alloc_items(nr_counters, gfp_flags);
+	if (!items) {
+		free_percpu(level0);
+		return -ENOMEM;
+	}
+	root = &items[(tree_topology.nr_items - 1) * counters[0].items_stride];
+	/* See "Publication of the tree" above. */
+	for (i = 0; i < nr_counters; i++) {
+		/* Release of approx_sum: the root is zeroed before its pointer. */
+		smp_store_release(&counters[i].approx_sum, root + i);
+		/*
+		 * Release of level0: the per-CPU counters, the tree items and
+		 * approx_sum are set before level0, which opens the tree to
+		 * updates.
+		 */
+		smp_store_release(&counters[i].level0, level0 + i);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_activate_many);
+
 /**
  * percpu_counter_tree_destroy_many() - Destroy many per-CPU counter trees.
  * @counters: Array of counters trees to destroy.
@@ -457,7 +628,7 @@ EXPORT_SYMBOL_GPL(percpu_counter_tree_init);
  *
  * Release internal resources allocated for @nr_counters per-CPU counter trees.
  * @counters and @nr_counters must be those passed to
- * percpu_counter_tree_init_many().
+ * percpu_counter_tree_init_many() or percpu_counter_tree_init_many_lazy().
  */
 void percpu_counter_tree_destroy_many(struct percpu_counter_tree *counters,
 				      unsigned int nr_counters)
@@ -470,8 +641,9 @@ void percpu_counter_tree_destroy_many(struct percpu_counter_tree *counters,
 	if (WARN_ON_ONCE(counters->items_stride !=
 			 percpu_counter_tree_items_stride(nr_counters)))
 		return;
-	/* The first item of the first counter is the base of the tree items. */
-	percpu_counter_tree_free_items(percpu_counter_tree_items(counters), nr_counters);
+	/* The first item of the first counter is the base of the tree items, if allocated. */
+	if (counters->approx_sum)
+		percpu_counter_tree_free_items(percpu_counter_tree_items(counters), nr_counters);
 }
 EXPORT_SYMBOL_GPL(percpu_counter_tree_destroy_many);
 
@@ -511,9 +683,19 @@ void percpu_counter_tree_add_slowpath(struct percpu_counter_tree *counter, long
 		     level, n_arity_order;
 	unsigned long bit_mask;
 	unsigned int stride = counter->items_stride;
-	atomic_long_t *item = percpu_counter_tree_items(counter);
 	unsigned int cpu = raw_smp_processor_id();
+	atomic_long_t *root, *item;
 
+	/*
+	 * Pairs with the release of level0 in
+	 * percpu_counter_tree_activate_many(), which follows the store of
+	 * approx_sum. The caller read level0, but approx_sum is a separate
+	 * field, which the address dependency of that read does not order:
+	 * read it after level0.
+	 */
+	smp_rmb();
+	root = READ_ONCE(counter->approx_sum);
+	item = root - (tree_topology.nr_items - 1) * stride;
 	n_arity_order = tree_topology.config->n_arity_order[0];
 	bit_mask = percpu_counter_tree_batch_size(counter) << n_arity_order;
 	level_items = 1U << (tree_topology.nr_cpus_order - n_arity_order);
@@ -571,19 +753,14 @@ void percpu_counter_tree_add_slowpath(struct percpu_counter_tree *counter, long
 		level_items >>= n_arity_order;
 		bit_mask <<= n_arity_order;
 	}
-	atomic_long_add_return_release(inc, counter->approx_sum);
+	/* The atomic API has no add with release ordering without a return value. */
+	atomic_long_add_return_release(inc, root);
 }
 
-/**
- * percpu_counter_tree_add() - Add to a per-CPU counter tree.
- * @counter: Counter added to.
- * @inc: Increment value (either positive or negative).
- *
- * Add @inc to a per-CPU counter tree. This is a fast-path which will
- * typically increment per-CPU counters as long as there is no carry
- * greater or equal to the counter tree batch size.
- */
-void percpu_counter_tree_add(struct percpu_counter_tree *counter, long inc)
+/* Add @inc to the per-CPU counters @level0 of an activated tree. */
+static inline
+void percpu_counter_tree_add_tree(struct percpu_counter_tree *counter,
+				  s8 __percpu *level0, long inc)
 {
 	unsigned long bit_mask = percpu_counter_tree_batch_size(counter);
 	s8 old, new;
@@ -605,18 +782,69 @@ void percpu_counter_tree_add(struct percpu_counter_tree *counter, long inc)
 	 * interrupts, and the carry may propagate from any CPU, see
 	 * percpu_counter_tree_add_slowpath().
 	 */
-	old = this_cpu_read(*counter->level0);
+	old = this_cpu_read(*level0);
 	do {
 		v = old + inc;
 		carry = percpu_counter_tree_item_carry(v, bit_mask);
 		new = (s8)(v - carry);
-	} while (!this_cpu_try_cmpxchg(*counter->level0, &old, new));
+	} while (!this_cpu_try_cmpxchg(*level0, &old, new));
 	if (likely(!carry))
 		return;
 	percpu_counter_tree_add_slowpath(counter, carry);
 }
+
+/**
+ * percpu_counter_tree_add() - Add to a per-CPU counter tree.
+ * @counter: Counter added to.
+ * @inc: Increment value (either positive or negative).
+ *
+ * Add @inc to a per-CPU counter tree. This is a fast-path which will
+ * typically increment per-CPU counters as long as there is no carry
+ * greater or equal to the counter tree batch size. Before the tree is
+ * activated, add to the atomic bias.
+ */
+void percpu_counter_tree_add(struct percpu_counter_tree *counter, long inc)
+{
+	/*
+	 * Pairs with the release of level0 in
+	 * percpu_counter_tree_activate_many(): the per-CPU counters are only
+	 * reached through this pointer, and the address dependency orders
+	 * their initialization before their use, as for rcu_dereference().
+	 * No acquire, see "Publication of the tree".
+	 */
+	s8 __percpu *level0 = READ_ONCE(counter->level0);
+
+	if (!level0) {
+		atomic_long_add(inc, &counter->atomic_bias);
+		return;
+	}
+	percpu_counter_tree_add_tree(counter, level0, inc);
+}
 EXPORT_SYMBOL_GPL(percpu_counter_tree_add);
 
+/**
+ * percpu_counter_tree_add_owner() - Add to a per-CPU counter tree as its owner.
+ * @counter: Counter added to.
+ * @inc: Increment value (either positive or negative).
+ *
+ * Like percpu_counter_tree_add(), but before the tree is activated, add
+ * to the bias without atomic instruction. The calls for a given counter
+ * must not run concurrently with each other: they come from a single
+ * context, the owner chosen by the user of the counter, such as a task.
+ */
+void percpu_counter_tree_add_owner(struct percpu_counter_tree *counter, long inc)
+{
+	/* Address dependency, as in percpu_counter_tree_add(). */
+	s8 __percpu *level0 = READ_ONCE(counter->level0);
+
+	if (!level0) {
+		WRITE_ONCE(counter->bias, (long)((unsigned long)READ_ONCE(counter->bias) + inc));
+		return;
+	}
+	percpu_counter_tree_add_tree(counter, level0, inc);
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_add_owner);
+
 /*
  * The precise sum is the sum of the residuals of all tree levels. A carry
  * leaves a level before reaching a higher level, and the release ordering
@@ -630,19 +858,29 @@ long percpu_counter_tree_precise_sum_unbiased(struct percpu_counter_tree *counte
 {
 	unsigned int nr_levels = tree_topology.config->nr_levels, i,
 		     level_items[MAX_NR_LEVELS], stride = counter->items_stride;
+	/*
+	 * Pairs with the release of level0 in
+	 * percpu_counter_tree_activate_many(): approx_sum, the tree items and
+	 * the per-CPU counters read below are set before level0.
+	 */
+	s8 __percpu *level0 = smp_load_acquire(&counter->level0);
+	unsigned long sum = atomic_long_read(&counter->atomic_bias);
 	atomic_long_t *item;
-	unsigned long sum;
 	int level, cpu;
 
+	/* Before activation, the atomic bias holds the whole unbiased sum. */
+	if (!level0)
+		return (long)sum;
 	/* Number of items of each level above level 0. */
 	level_items[0] = 1U << tree_topology.nr_cpus_order;
 	for (level = 1; level < (int)nr_levels; level++)
 		level_items[level] = level_items[level - 1] >>
 				     tree_topology.config->n_arity_order[level - 1];
-	sum = atomic_long_read(counter->approx_sum);
+	/* Published before level0, so ordered by its acquire. */
+	item = READ_ONCE(counter->approx_sum);
+	sum += atomic_long_read(item);
 	smp_rmb();	/* Read each level before the level below it. */
 	/* The items of each level precede those of the level above it. */
-	item = counter->approx_sum;
 	for (level = (int)nr_levels - 1; level >= 1; level--) {
 		item -= level_items[level] * stride;
 		for (i = 0; i < level_items[level]; i++)
@@ -650,7 +888,7 @@ long percpu_counter_tree_precise_sum_unbiased(struct percpu_counter_tree *counte
 		smp_rmb();	/* Read this level before the level below it. */
 	}
 	for_each_possible_cpu(cpu)
-		sum += (long)READ_ONCE(*per_cpu_ptr(counter->level0, cpu));
+		sum += (long)READ_ONCE(*per_cpu_ptr(level0, cpu));
 	return (long)sum;
 }
 
@@ -1013,6 +1251,7 @@ EXPORT_SYMBOL_IF_KUNIT(percpu_counter_tree_check_config);
  * - a counter at level N, above level 0, holds a multiple of
  *   BATCH(level N - 1) within (-BATCH(level N), +BATCH(level N)),
  * - the root holds a multiple of the batch of the last level.
+ * Before activation, a lazily initialized counter has no tree to check.
  *
  * Return: The number of violated invariants.
  */
@@ -1020,11 +1259,14 @@ unsigned int percpu_counter_tree_check_residuals(struct percpu_counter_tree *cou
 {
 	unsigned int nr_levels = tree_topology.config->nr_levels, level, level_items,
 		     nr_errors = 0, stride = counter->items_stride;
-	atomic_long_t *item = percpu_counter_tree_items(counter);
 	unsigned long lo = percpu_counter_tree_batch_size(counter);
+	atomic_long_t *item;
 	long root;
 	int cpu;
 
+	if (!counter->level0)
+		return 0;
+	item = percpu_counter_tree_items(counter);
 	for_each_possible_cpu(cpu) {
 		long v = READ_ONCE(*per_cpu_ptr(counter->level0, cpu));
 
@@ -1063,7 +1305,7 @@ EXPORT_SYMBOL_IF_KUNIT(percpu_counter_tree_check_residuals);
 /*
  * Copy the state of counter @src into counter @dst, initialized with the
  * same batch size and without concurrent updates: their per-CPU counters,
- * tree items and bias.
+ * tree items and biases. Both trees are active.
  */
 void percpu_counter_tree_copy_state(struct percpu_counter_tree *dst,
 				    struct percpu_counter_tree *src)
@@ -1079,6 +1321,7 @@ void percpu_counter_tree_copy_state(struct percpu_counter_tree *dst,
 		atomic_long_set(&dst_items[pos * dst->items_stride],
 				atomic_long_read(&src_items[pos * src->items_stride]));
 	dst->bias = src->bias;
+	atomic_long_set(&dst->atomic_bias, atomic_long_read(&src->atomic_bias));
 }
 EXPORT_SYMBOL_IF_KUNIT(percpu_counter_tree_copy_state);
 #endif
diff --git a/lib/tests/percpu_counter_tree_kunit.c b/lib/tests/percpu_counter_tree_kunit.c
index 58b2e488e3c6..2f5852b1f521 100644
--- a/lib/tests/percpu_counter_tree_kunit.c
+++ b/lib/tests/percpu_counter_tree_kunit.c
@@ -2,6 +2,8 @@
 // SPDX-FileCopyrightText: 2026 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
 
 #include <kunit/test.h>
+#include <linux/delay.h>
+#include <linux/mutex.h>
 #include <linux/percpu_counter_tree.h>
 #include <linux/kthread.h>
 #include <linux/wait.h>
@@ -783,6 +785,220 @@ static void hpcc_test_saturated_compare(struct kunit *test)
 	}
 }
 
+/* Check a counter against its expected sum: exact before activation, within range after. */
+static void check_lazy_counter(struct kunit *test, struct percpu_counter_tree *c, long v)
+{
+	long approx_sum = percpu_counter_tree_approximate_sum(c);
+	unsigned long accuracy;
+
+	KUNIT_EXPECT_EQ(test, percpu_counter_tree_precise_sum(c), v);
+	KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_precise_compare_value(c, v));
+	KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_approximate_compare_value(c, v));
+	check_residuals(test, c);
+#ifdef CONFIG_SMP
+	if (!READ_ONCE(c->level0)) {
+		KUNIT_EXPECT_EQ(test, approx_sum, v);
+		return;
+	}
+#endif
+	accuracy = percpu_counter_tree_approximate_accuracy(c);
+	KUNIT_EXPECT_GE(test, (long)(approx_sum - (v - accuracy)), 0);
+	KUNIT_EXPECT_LE(test, (long)(approx_sum - (v + accuracy)), 0);
+}
+
+/*
+ * Lazily initialized counters: exact sums before the tree is activated,
+ * with owner and atomic updates, set(), idempotent activation, updates
+ * after activation, and destruction of counters never activated.
+ */
+static void hpcc_test_lazy(struct kunit *test)
+{
+	struct percpu_counter_tree pct[2];
+	long expect[2] = { 0, 0 };
+	int i, j;
+
+	KUNIT_ASSERT_EQ(test, 0, percpu_counter_tree_init_many_lazy(pct, 2, 32));
+#ifdef CONFIG_SMP
+	KUNIT_EXPECT_FALSE(test, percpu_counter_tree_active(&pct[0]));
+	KUNIT_EXPECT_FALSE(test, percpu_counter_tree_active(&pct[1]));
+	/* The level 0 counters are __percpu pointers: compare them as booleans. */
+	KUNIT_EXPECT_TRUE(test, !pct[0].level0);
+	KUNIT_EXPECT_TRUE(test, !pct[1].level0);
+	KUNIT_EXPECT_NULL(test, pct[0].approx_sum);
+	KUNIT_EXPECT_NULL(test, pct[1].approx_sum);
+#endif
+	for (j = 0; j < 2; j++) {
+		/* j == 0: before activation; j == 1: after activation. */
+		for (i = 0; i < 10000; i++) {
+			long inc = (long)(get_random_u32() % 1025) - 512;
+
+			if (get_random_u32() & 1)
+				percpu_counter_tree_add_owner(&pct[0], inc);
+			else
+				percpu_counter_tree_add(&pct[0], inc);
+			expect[0] += inc;
+			percpu_counter_tree_add(&pct[1], -inc);
+			expect[1] -= inc;
+		}
+		check_lazy_counter(test, &pct[0], expect[0]);
+		check_lazy_counter(test, &pct[1], expect[1]);
+		percpu_counter_tree_set(&pct[1], 12345);
+		expect[1] = 12345;
+		check_lazy_counter(test, &pct[1], expect[1]);
+		if (j)
+			break;
+		KUNIT_ASSERT_EQ(test, 0, percpu_counter_tree_activate_many(pct, 2, GFP_KERNEL));
+		KUNIT_EXPECT_TRUE(test, percpu_counter_tree_active(&pct[0]));
+		KUNIT_EXPECT_TRUE(test, percpu_counter_tree_active(&pct[1]));
+#ifdef CONFIG_SMP
+		{
+			s8 __percpu *level0 = pct[0].level0;
+
+			KUNIT_EXPECT_TRUE(test, level0);
+			KUNIT_EXPECT_TRUE(test, pct[1].level0 == level0 + 1);
+			KUNIT_EXPECT_NOT_NULL(test, pct[0].approx_sum);
+			KUNIT_EXPECT_PTR_EQ(test, pct[1].approx_sum, pct[0].approx_sum + 1);
+			KUNIT_EXPECT_EQ(test, 0,
+					percpu_counter_tree_activate_many(pct, 2, GFP_KERNEL));
+			KUNIT_EXPECT_TRUE(test, pct[0].level0 == level0);
+		}
+#endif
+		/* The sums carry the updates made before activation. */
+		check_lazy_counter(test, &pct[0], expect[0]);
+		check_lazy_counter(test, &pct[1], expect[1]);
+	}
+	percpu_counter_tree_destroy_many(pct, 2);
+
+	/* Destroy counters which were never activated. */
+	KUNIT_ASSERT_EQ(test, 0, percpu_counter_tree_init_many_lazy(pct, 2, 32));
+	percpu_counter_tree_add_owner(&pct[0], 7);
+	percpu_counter_tree_add(&pct[1], -7);
+	check_lazy_counter(test, &pct[0], 7);
+	check_lazy_counter(test, &pct[1], -7);
+	percpu_counter_tree_destroy_many(pct, 2);
+}
+
+/*
+ * Activation racing with updates: one owner and updaters on other CPUs add
+ * to a lazily initialized counter. Each worker makes a first part of its
+ * updates, reports their sum and waits. The test checks that the counter
+ * is exact, then releases the workers and activates the tree while they
+ * make the rest of their updates. The remote updaters also activate the
+ * tree when released, serialized with the test and with each other by a
+ * mutex, and check that the tree is active once their activation returns.
+ * No update may be lost, whichever side of the activation it lands on.
+ */
+#define LAZY_RACE_NR_INC	200000
+#define LAZY_RACE_NR_FIRST	(LAZY_RACE_NR_INC / 8)
+#define LAZY_RACE_MAX_REMOTE	8
+
+struct lazy_race_shared {
+	struct percpu_counter_tree *c;
+	atomic_long_t first_sum;	/* Sum of the updates made before the release. */
+	atomic_long_t expect;		/* Sum of all updates. */
+	struct mutex activate_lock;	/* Serializes the activations. */
+	atomic_t paused;		/* Workers waiting for the release. */
+	atomic_t activate_errors;	/* Failed activations of the workers. */
+	bool go;			/* Releases the workers. */
+};
+
+struct lazy_race_work {
+	struct work_struct work;
+	struct lazy_race_shared *sh;
+	bool owner;
+};
+
+static void lazy_race_fn(struct work_struct *work)
+{
+	struct lazy_race_work *w = container_of(work, struct lazy_race_work, work);
+	struct lazy_race_shared *sh = w->sh;
+	long sum = 0;
+	int i;
+
+	for (i = 0; i < LAZY_RACE_NR_INC; i++) {
+		long inc = (long)(get_random_u32() % 65) - 32;
+
+		if (i == LAZY_RACE_NR_FIRST) {
+			/* Fully ordered: the first updates are visible before the pause. */
+			atomic_long_add_return(sum, &sh->first_sum);
+			atomic_inc_return(&sh->paused);
+			while (!READ_ONCE(sh->go))
+				cond_resched();
+			if (!w->owner) {
+				mutex_lock(&sh->activate_lock);
+				if (percpu_counter_tree_activate_many(sh->c, 1, GFP_KERNEL) ||
+				    !percpu_counter_tree_active(sh->c))
+					atomic_inc(&sh->activate_errors);
+				mutex_unlock(&sh->activate_lock);
+			}
+		}
+		if (w->owner)
+			percpu_counter_tree_add_owner(sh->c, inc);
+		else
+			percpu_counter_tree_add(sh->c, inc);
+		sum += inc;
+		if (!(i & 1023))
+			cond_resched();
+	}
+	atomic_long_add(sum, &sh->expect);
+	kfree(w);
+	complete_work();
+}
+
+static void hpcc_test_lazy_activation_race(struct kunit *test)
+{
+	struct percpu_counter_tree pct;
+	int round;
+
+	if (num_online_cpus() < 2)
+		kunit_skip(test, "needs at least 2 online CPUs");
+	for (round = 0; round < 4; round++) {
+		struct lazy_race_shared sh = { .c = &pct };
+		unsigned long timeout = jiffies + 10 * HZ;
+		int cpu, nr_workers = 0;
+
+		KUNIT_ASSERT_EQ(test, 0, percpu_counter_tree_init_many_lazy(&pct, 1, 32));
+		mutex_init(&sh.activate_lock);
+		init_kthreads();
+		cpus_read_lock();
+		for_each_online_cpu(cpu) {
+			struct lazy_race_work *w;
+
+			if (nr_workers > LAZY_RACE_MAX_REMOTE)
+				break;
+			w = kzalloc_obj(*w);
+			KUNIT_EXPECT_NOT_NULL(test, w);
+			if (!w)
+				break;
+			INIT_WORK(&w->work, lazy_race_fn);
+			w->sh = &sh;
+			/* The first worker is the owner, the others update remotely. */
+			w->owner = !nr_workers;
+			atomic_inc(&kernel_threads_to_run);
+			queue_work_on(cpu, hpcc_test_wq, &w->work);
+			nr_workers++;
+		}
+		cpus_read_unlock();
+		while (atomic_read(&sh.paused) < nr_workers && time_before(jiffies, timeout))
+			usleep_range(100, 200);
+		smp_mb();	/* Read the counter after the first updates of the workers. */
+		/* Every worker, the owner included, has updates left for after the activation. */
+		KUNIT_EXPECT_EQ(test, atomic_read(&sh.paused), nr_workers);
+		/* Before activation, the owner and atomic updates are exact. */
+		check_lazy_counter(test, &pct, atomic_long_read(&sh.first_sum));
+		WRITE_ONCE(sh.go, true);
+		mutex_lock(&sh.activate_lock);
+		KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_activate_many(&pct, 1, GFP_KERNEL));
+		KUNIT_EXPECT_TRUE(test, percpu_counter_tree_active(&pct));
+		mutex_unlock(&sh.activate_lock);
+		fini_kthreads();
+		mutex_destroy(&sh.activate_lock);
+		KUNIT_EXPECT_EQ(test, 0, atomic_read(&sh.activate_errors));
+		check_lazy_counter(test, &pct, atomic_long_read(&sh.expect));
+		percpu_counter_tree_destroy_many(&pct, 1);
+	}
+}
+
 static void hpcc_test_check_config(struct kunit *test)
 {
 #ifdef CONFIG_SMP
@@ -804,6 +1020,8 @@ static struct kunit_case hpcc_test_cases[] = {
 	KUNIT_CASE(hpcc_test_set),
 	KUNIT_CASE(hpcc_test_saturated_compare),
 	KUNIT_CASE(hpcc_test_contended_carries),
+	KUNIT_CASE(hpcc_test_lazy),
+	KUNIT_CASE(hpcc_test_lazy_activation_race),
 	{}
 };
 
diff --git a/tools/testing/hpcc/include/hpcc_shim.h b/tools/testing/hpcc/include/hpcc_shim.h
index 7e268de984c6..d321c8363b0b 100644
--- a/tools/testing/hpcc/include/hpcc_shim.h
+++ b/tools/testing/hpcc/include/hpcc_shim.h
@@ -68,6 +68,9 @@ static inline int get_count_order(unsigned int count)
 #define atomic_long_add_return_relaxed(i, v)	((v)->counter += (i))
 #define atomic_long_add_return_release(i, v)	((v)->counter += (i))
 #define smp_rmb()				barrier()
+/* The harness runs on one thread: ordering primitives are plain accesses. */
+#define smp_load_acquire(p)			READ_ONCE(*(p))
+#define smp_store_release(p, v)			WRITE_ONCE(*(p), (v))
 
 static inline bool atomic_long_try_cmpxchg_relaxed(atomic_long_t *v, long *old, long new)
 {
@@ -92,15 +95,32 @@ extern unsigned int hpcc_current_cpu;
  */
 #define HPCC_PCPU_UNIT	64
 
+/* Outstanding allocations, to check for leaks. */
+extern long hpcc_nr_allocs;
+
+static inline void *hpcc_alloc_account(void *p)
+{
+	if (p)
+		hpcc_nr_allocs++;
+	return p;
+}
+
+static inline void hpcc_free_account(void *p)
+{
+	if (p)
+		hpcc_nr_allocs--;
+}
+
 static inline void *__alloc_percpu_gfp(size_t size, size_t align, gfp_t gfp)
 {
 	if (size > HPCC_PCPU_UNIT || align > HPCC_PCPU_UNIT)
 		return NULL;
-	return calloc(nr_cpu_ids, HPCC_PCPU_UNIT);
+	return hpcc_alloc_account(calloc(nr_cpu_ids, HPCC_PCPU_UNIT));
 }
 
 static inline void free_percpu(void *ptr)
 {
+	hpcc_free_account(ptr);
 	free(ptr);
 }
 
@@ -136,21 +156,23 @@ static inline void *kmem_cache_zalloc(struct kmem_cache *s, gfp_t gfp)
 
 	if (p)
 		memset(p, 0, s->size);
-	return p;
+	return hpcc_alloc_account(p);
 }
 
 static inline void kmem_cache_free(struct kmem_cache *s, void *p)
 {
+	hpcc_free_account(p);
 	free(p);
 }
 
 static inline void *kzalloc(size_t size, gfp_t gfp)
 {
-	return calloc(1, size);
+	return hpcc_alloc_account(calloc(1, size));
 }
 
 static inline void kfree(void *p)
 {
+	hpcc_free_account(p);
 	free(p);
 }
 
diff --git a/tools/testing/hpcc/main.c b/tools/testing/hpcc/main.c
index b707754aab0a..c3583a287cdd 100644
--- a/tools/testing/hpcc/main.c
+++ b/tools/testing/hpcc/main.c
@@ -19,6 +19,10 @@
  *   and check the accuracy range contract and the comparison functions
  *   against shadow sums after each increment.
  *
+ * - Lazy counter: random owner and atomic updates of a lazily initialized
+ *   counter, exact before its tree is activated halfway, with the same
+ *   checks after each increment.
+ *
  * The test is single-threaded, so it only covers settled counters.
  */
 
@@ -28,6 +32,7 @@
 unsigned int nr_cpu_ids;
 unsigned int hpcc_current_cpu;
 unsigned long hpcc_nr_warnings;
+long hpcc_nr_allocs;
 
 #include "../../../lib/percpu_counter_tree.c"
 
@@ -329,6 +334,47 @@ static void test_random_walk(unsigned long batch_size, unsigned long nr_steps)
 	test_counter_destroy(&c[1]);
 }
 
+static void test_lazy(unsigned long batch_size, unsigned long nr_steps)
+{
+	long nr_allocs = hpcc_nr_allocs;
+	struct test_counter c;
+	unsigned long step;
+
+	if (percpu_counter_tree_init_many_lazy(&c.tree, 1, batch_size)) {
+		CHECK(0);
+		return;
+	}
+	c.shadow = 0;
+	CHECK(!c.tree.level0);
+	CHECK(!c.tree.approx_sum);
+	CHECK(!percpu_counter_tree_active(&c.tree));
+	for (step = 0; step < nr_steps; step++) {
+		long inc = random_increment(batch_size);
+
+		hpcc_current_cpu = rnd() % nr_cpu_ids;
+		if (rnd() & 1)
+			percpu_counter_tree_add_owner(&c.tree, inc);
+		else
+			percpu_counter_tree_add(&c.tree, inc);
+		c.shadow += inc;
+		if (!c.tree.level0)
+			CHECK(percpu_counter_tree_approximate_sum(&c.tree) == c.shadow);
+		check_counter(&c);
+		if (step == nr_steps / 2) {
+			CHECK(!percpu_counter_tree_activate_many(&c.tree, 1, GFP_KERNEL));
+			CHECK(c.tree.level0);
+			CHECK(c.tree.approx_sum);
+			CHECK(percpu_counter_tree_active(&c.tree));
+			/* One tree: its per-CPU counters and its tree items. */
+			CHECK(hpcc_nr_allocs == nr_allocs + 2);
+			CHECK(!percpu_counter_tree_activate_many(&c.tree, 1, GFP_KERNEL));
+			CHECK(hpcc_nr_allocs == nr_allocs + 2);
+		}
+	}
+	test_counter_destroy(&c);
+	CHECK(hpcc_nr_allocs == nr_allocs);
+}
+
 static const unsigned int test_nr_cpus[] = {
 	1, 2, 3, 4, 5, 8, 9, 16, 17, 32, 33, 64, 65, 100, 128, 256, 512,
 	1000, 1024, 2048, 4096, 8192, 16384, 32768, 65536,
@@ -359,6 +405,7 @@ static int run_case(unsigned int nr_cpus, unsigned long batch_size)
 	test_saturated(batch_size, 1);
 	test_saturated(batch_size, -1);
 	test_random_walk(batch_size, nr_steps);
+	test_lazy(batch_size, nr_steps / 2);
 	CHECK(!hpcc_nr_warnings);
 	printf("%sok %d - nr_cpus=%u batch_size=%lu\n", nr_case_failures ? "not " : "",
 	       ++test_num, nr_cpus, batch_size);
-- 
2.47.3


