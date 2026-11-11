Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E212B606A8B2
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 20:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=thMALZNH
Received: by kanga.kvack.org (Postfix)
	id 98CBB6B05B9; Wed, 11 Nov 2026 15:36:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 964246B05BC; Wed, 11 Nov 2026 15:36:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8046A6B05BB; Wed, 11 Nov 2026 15:36:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3EB9D6B05BC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:36:51 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BEFEDA7EBD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:36:50 +0000 (UTC)
X-FDA: 85423996980.12.2B9DAAE
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2A1E9140008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:36:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=thMALZNH;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf26.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794429409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5GmfaraUSzG6I7apP/vydGSTWdg5q1e+3BsITKjagU=;
	b=Ps+v1BLTqp9hyly7az+r2EukFcsfapwDFuK8J6DmVjPtrSV09eYhNOZVFRh0IyS7OKvBzQ
	3Wmy3s+1/sj4Z3vQLPba4nCyqj2rNvmvr783ucxcBqSMuGMc3qhbCJpAoK9+zNafIz1NF4
	QreQl7AYcrObT2tGQcTvM3WnwgrlnJY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=thMALZNH;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf26.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794429409;
	b=y5kbn335U2RMQUAjWw3yXdgUfNszv5+OLApfoigXZXYGuA3vJedbvA8gaOZ2qPaacukETb
	kf/f/eNyWKnVKCT2ZqFj7hxy2sIe8YIiaAKUOcpyNcJ5X6TDhsCbcqByS7W9eG9imWR95r
	1hmMtpErZxsgwBwXe2d5rpKcTaNwBm0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794429406;
	bh=Y5GmfaraUSzG6I7apP/vydGSTWdg5q1e+3BsITKjagU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=thMALZNHU/78v+q0Qq3MjVgoqSRM8zhR31a+JUn/DSBtQkui37FCHGhJlq6NoUVN6
	 Yx9zpJJPMBPf+bZYYPLiBBArQhf2uDNDKPovGkKfXxQz4RxWDZNicSGwXezVsmu4+K
	 4945/NA8slfdp0feA97lU5B5xbE7QE10Bi0L6oJGTbYo5ZjNcHW1SV8lfrjtdUZa1y
	 3dmQM8+GjtfyeeyJ2QogQO34b/1kIqYhIjK1L3jgE0sLM5HdNu1Psgadm+4IA/cTfN
	 2N7BmG5rpmGsVBE/xLZYY3zOxhVM8T8SR0qaDlCUZdsbtQQI7PZZV093nvpC761ZMf
	 omcgOhY3/sFlQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jPwKp4lFBzNh1;
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
Subject: [RFC PATCH v25 10/14] tools/testing/hpcc: add litmus tests of the memory ordering
Date: Wed, 11 Nov 2026 15:36:22 -0500
Message-Id: <20261111203626.95838-11-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261111203626.95838-1-mathieu.desnoyers@efficios.com>
References: <20261111203626.95838-1-mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2A1E9140008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: frscize3ruh5tpr67damjo4igibhka57
X-HE-Tag: 1794429409-42813
X-HE-Meta: U2FsdGVkX1/20AOJyOx6fxbTiBjif+AqkLcfO761Lcw/wlTHKTcRQWTzOQOrTs3gEf6aq2VdYwvGS4o+rHzz3GY3iH3ZUtjc207Ncogca2F71E8URd0cc5BZOtopriSYtB9vI4Kx/kYWc1OI6EBEVBgipRLHqnxUiWxQfRtVNrWxTUcel0Co36+s8tnmhs8wIFaoag2q9O31kFZgxfk2BTM70rGElITk6qP477Wa+l+SRbaz2AB82TpBJRs9DrKBm8ksoaMDt3YSbWUUh+F+ze7wTrDcSZDd0yLE49wOF+cOdyI2IUdRhTaWEljTcF8fGBr0kRgngp9NVxVRXIVgjZliukAUOUor6QEtgdOkfWQON3qYzmLFnORrzjGrEUWnaDbHk6iHfJn/TEJNnSl7v+/NAiIgQ9zM72F/y1LB5OPm8ju5JQk3C69Qdm0dYkXg7vMqxZF5gfQhzwNwIjt27kO43MRuXPQVR+aZbnUAgEK4RCl6RfZxa4K5lfmtlHG3ReNFziy+/N1j1i+Yzq1TL9u+dZ1bWsZw+SihYOZrAxB7bT47m+F3LME5FOC2O8dWkmpH4OvtiXkAOPdSrZWCW3fNXUqNwiSFEFWYcjFDmXFSxDYJFWYGdhja6x2JV1bbLv+gxjJrwuFe7h+jA7fdhkY6ePnn1RYwpuKIe6CHmBLsfRk39xqSCrDOfvn4qDB0oEn1EjW3mdYb0YbC1fPJw4oBIlGDm2ytBh02H1NHnv0M6+ZsweFh11X868G6X2GNmyXQAVXb67hpCR/rn/nhojGdzmWL2xtHI6wCZHq3FAJwBzxTMIwCMG00s3q4uX+MU4itFyoggKAdBfHSsJgOAwAAETLgzWGn961wHckGt7CP78lQZCMJf7Am9f6tAKYxgLlK3n4N9Mx8lIez49OeNl9ZjFrLVUIfM2KwEqOfaQR9XTS5wwKk+Gmo6wLBUoCn9MceKtAP+Mxng7OCBjG
 N3VgyVBB
 a+Kn/VQCm0pUTa1DCCth3op1M94JTegsxYYYBiwmS2sHOCqIObwau+CDT1WUR0Zk8yKqggn+7eOBRRLcrJBnjAvTICAnEbyQ7eR7C+R9BvLG90Euv0ji0T/FwFBA0x4Ci/i/zy+ejz9CwinvQOicvx18Hr+gwyeTHeL8Odea9/aCaGSPrXE5xW5B83CHXZrjP9fy1hSeb7wLFTPFxCsKt45ULViIaGcyOscdugoURJBFhM6oy51K2Kdl0ZA+da9H5U78Iw+zaBAVV1kSWR3iG5RWZqQEABWxWt4LURBmkHJDfzCGKPlk2NO4BneK1KlUDrn3ARexrWQRHtGgqVJvvz9l5KWAQ/ZaMzvOLMjxH7K1LBEPpYFyelBP5Fexa8PwUhT+X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The limit counters rely on memory ordering. So do the carries and the
publication of the tree by lazy activation. A test on real hardware
cannot show that an ordering is needed: a missing barrier may never
fail in practice. The userspace test runs on one thread only.

Check each of these orderings with the Linux kernel memory model
instead. The litmus tests cover:

- The publication of the tree: the update fast path, the carry slow
  path, the precise sum and the approximate sum.
- The carries of percpu_counter_tree_add(), against the precise sum.
- The limit counters: the carries of the additions, an addition undone,
  an amount freed on another CPU, and two concurrent checks.

herd7 reports "Never" for the 12 tests of the code as it is. 9 variants
drop one ordering each, and herd7 reports "Sometimes" for them. This
shows that these orderings are needed. The README explains how to run
the tests, and the comments of the library now point at them.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 lib/percpu_counter_tree.c                     |  8 ++-
 tools/testing/hpcc/litmus/README              | 61 +++++++++++++++++++
 .../leave-first-precise-sum-relaxed.litmus    | 37 +++++++++++
 .../litmus/leave-first-precise-sum.litmus     | 41 +++++++++++++
 .../litmus/limit-arrive-first-acquire.litmus  | 38 ++++++++++++
 .../limit-arrive-first-unordered.litmus       | 37 +++++++++++
 .../hpcc/litmus/limit-arrive-first.litmus     | 41 +++++++++++++
 .../hpcc/litmus/limit-free-level0-nomb.litmus | 40 ++++++++++++
 .../hpcc/litmus/limit-free-level0.litmus      | 43 +++++++++++++
 .../hpcc/litmus/limit-free-root.litmus        | 42 +++++++++++++
 .../litmus/limit-last-checker-nomb.litmus     | 28 +++++++++
 .../hpcc/litmus/limit-last-checker.litmus     | 33 ++++++++++
 .../hpcc/litmus/limit-undo-level0.litmus      | 35 +++++++++++
 .../hpcc/litmus/limit-undo-root-rmb.litmus    | 30 +++++++++
 .../litmus/limit-undo-root-unordered.litmus   | 29 +++++++++
 .../hpcc/litmus/limit-undo-root.litmus        | 32 ++++++++++
 .../litmus/publish-approximate-sum.litmus     | 40 ++++++++++++
 .../hpcc/litmus/publish-carry-normb.litmus    | 36 +++++++++++
 .../testing/hpcc/litmus/publish-carry.litmus  | 43 +++++++++++++
 .../publish-precise-sum-noacquire.litmus      | 38 ++++++++++++
 .../hpcc/litmus/publish-precise-sum.litmus    | 44 +++++++++++++
 .../litmus/publish-update-norelease.litmus    | 34 +++++++++++
 .../testing/hpcc/litmus/publish-update.litmus | 40 ++++++++++++
 23 files changed, 848 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/hpcc/litmus/README
 create mode 100644 tools/testing/hpcc/litmus/leave-first-precise-sum-relaxed.litmus
 create mode 100644 tools/testing/hpcc/litmus/leave-first-precise-sum.litmus
 create mode 100644 tools/testing/hpcc/litmus/limit-arrive-first-acquire.litmus
 create mode 100644 tools/testing/hpcc/litmus/limit-arrive-first-unordered.litmus
 create mode 100644 tools/testing/hpcc/litmus/limit-arrive-first.litmus
 create mode 100644 tools/testing/hpcc/litmus/limit-free-level0-nomb.litmus
 create mode 100644 tools/testing/hpcc/litmus/limit-free-level0.litmus
 create mode 100644 tools/testing/hpcc/litmus/limit-free-root.litmus
 create mode 100644 tools/testing/hpcc/litmus/limit-last-checker-nomb.litmus
 create mode 100644 tools/testing/hpcc/litmus/limit-last-checker.litmus
 create mode 100644 tools/testing/hpcc/litmus/limit-undo-level0.litmus
 create mode 100644 tools/testing/hpcc/litmus/limit-undo-root-rmb.litmus
 create mode 100644 tools/testing/hpcc/litmus/limit-undo-root-unordered.litmus
 create mode 100644 tools/testing/hpcc/litmus/limit-undo-root.litmus
 create mode 100644 tools/testing/hpcc/litmus/publish-approximate-sum.litmus
 create mode 100644 tools/testing/hpcc/litmus/publish-carry-normb.litmus
 create mode 100644 tools/testing/hpcc/litmus/publish-carry.litmus
 create mode 100644 tools/testing/hpcc/litmus/publish-precise-sum-noacquire.litmus
 create mode 100644 tools/testing/hpcc/litmus/publish-precise-sum.litmus
 create mode 100644 tools/testing/hpcc/litmus/publish-update-norelease.litmus
 create mode 100644 tools/testing/hpcc/litmus/publish-update.litmus

diff --git a/lib/percpu_counter_tree.c b/lib/percpu_counter_tree.c
index 9c172fc3e4d7..fcffc3d073ca 100644
--- a/lib/percpu_counter_tree.c
+++ b/lib/percpu_counter_tree.c
@@ -552,7 +552,9 @@ EXPORT_SYMBOL_GPL(percpu_counter_tree_init_many_lazy);
  * The read barriers between the levels of the precise sum are unrelated
  * to the publication: they order carries, see
  * percpu_counter_tree_precise_sum_unbiased().
-
+ *
+ * The litmus tests in tools/testing/hpcc/litmus check these orderings
+ * with the Linux kernel memory model, and those of the carries.
  */
 
 /**
@@ -1261,7 +1263,9 @@ EXPORT_SYMBOL_GPL(percpu_counter_tree_batch_for_accuracy);
  * retries once when the value leaves room for it.
  *
  * Both counters wrap around: all the arithmetic is modular.
-
+ *
+ * The litmus tests in tools/testing/hpcc/litmus check these orderings
+ * with the Linux kernel memory model.
  */
 
 /*
diff --git a/tools/testing/hpcc/litmus/README b/tools/testing/hpcc/litmus/README
new file mode 100644
index 000000000000..16c234a76786
--- /dev/null
+++ b/tools/testing/hpcc/litmus/README
@@ -0,0 +1,61 @@
+Litmus tests of lib/percpu_counter_tree.c. They check its memory
+ordering arguments with the Linux kernel memory model. Each test models
+one argument. A test with the result "Sometimes" drops one ordering of
+the code, to show that the argument needs it.
+
+The model has no atomic_long_t: the tests use atomic_t, with the same
+ordering. The per-CPU counters are plain int.
+
+Run them from tools/memory-model, with herd7 installed:
+
+  cd tools/memory-model
+  for f in ../testing/hpcc/litmus/*.litmus; do
+	herd7 -conf linux-kernel.cfg $f | grep Observation
+  done
+
+Each observation must match the "Result" in the comment of its test.
+
+Publication of the tree, see "Publication of the tree":
+
+  publish-update.litmus, publish-update-norelease.litmus
+    The update fast path reads level0, then its per-CPU counter.
+
+  publish-carry.litmus, publish-carry-normb.litmus
+    The carry slow path reads approx_sum after a read barrier.
+
+  publish-precise-sum.litmus, publish-precise-sum-noacquire.litmus
+    The precise sum reads level0 with an acquire.
+
+  publish-approximate-sum.litmus
+    The approximate sum reads the root through approx_sum.
+
+Carries of percpu_counter_tree_add(), see
+percpu_counter_tree_precise_sum_unbiased():
+
+  leave-first-precise-sum.litmus, leave-first-precise-sum-relaxed.litmus
+    A carry leaves each level before it arrives at the next one. The
+    precise sum, read from the root down, never counts it twice.
+
+Limit counters, see "Limit counters":
+
+  limit-arrive-first.litmus, limit-arrive-first-acquire.litmus,
+  limit-arrive-first-unordered.litmus
+    A carry of the additions arrives at each level before it leaves the
+    level below. The precise sum, read from level 0 up, never misses it.
+    The root update must be fully ordered.
+
+  limit-undo-root.litmus, limit-undo-root-rmb.litmus,
+  limit-undo-root-unordered.litmus, limit-undo-level0.litmus
+    An addition undone on the same CPU. The check reads the
+    subtractions, then the additions. It never sees the subtraction
+    without the addition.
+
+  limit-free-root.litmus, limit-free-level0.litmus,
+  limit-free-level0-nomb.litmus
+    An amount added on one CPU and subtracted on another one, which
+    found it through a release and an acquire. The full barrier after
+    the addition orders it before a subtraction which stays in level 0.
+
+  limit-last-checker.litmus, limit-last-checker-nomb.litmus
+    Two concurrent additions, each checked after a full barrier. At
+    least one check sees the other addition.
diff --git a/tools/testing/hpcc/litmus/leave-first-precise-sum-relaxed.litmus b/tools/testing/hpcc/litmus/leave-first-precise-sum-relaxed.litmus
new file mode 100644
index 000000000000..951b7c39bbbc
--- /dev/null
+++ b/tools/testing/hpcc/litmus/leave-first-precise-sum-relaxed.litmus
@@ -0,0 +1,37 @@
+C leave-first-precise-sum-relaxed
+
+(*
+ * Result: Sometimes
+ *
+ * Like leave-first-precise-sum, with a relaxed arrival at the middle
+ * item. The precise sum can then count the carry twice.
+ *)
+
+{
+	l0=1;
+}
+
+P0(int *l0, atomic_t *item, atomic_t *root)
+{
+	int r;
+
+	r = cmpxchg_relaxed(l0, 1, 0);
+	r = atomic_add_return_relaxed(1, item);
+	r = atomic_cmpxchg_relaxed(item, 1, 0);
+	r = atomic_add_return_release(1, root);
+}
+
+P1(int *l0, atomic_t *item, atomic_t *root)
+{
+	int r0;
+	int r1;
+	int r2;
+
+	r2 = atomic_read(root);
+	smp_rmb();
+	r1 = atomic_read(item);
+	smp_rmb();
+	r0 = READ_ONCE(*l0);
+}
+
+exists ((1:r2=1 /\ 1:r1=1) \/ (1:r2=1 /\ 1:r0=1) \/ (1:r1=1 /\ 1:r0=1))
diff --git a/tools/testing/hpcc/litmus/leave-first-precise-sum.litmus b/tools/testing/hpcc/litmus/leave-first-precise-sum.litmus
new file mode 100644
index 000000000000..a80ddb605d4e
--- /dev/null
+++ b/tools/testing/hpcc/litmus/leave-first-precise-sum.litmus
@@ -0,0 +1,41 @@
+C leave-first-precise-sum
+
+(*
+ * Result: Never
+ *
+ * A carry of percpu_counter_tree_add(), from the level 0 counter l0 to
+ * the root through a middle item. It leaves each level before it
+ * arrives at the next one, with a release. The precise sum reads the
+ * root, the item and level 0, with read barriers. It never counts the
+ * carry twice. This also keeps the sum of the subtractions of a limit
+ * counter from being above their value.
+ *)
+
+{
+	l0=1;
+}
+
+P0(int *l0, atomic_t *item, atomic_t *root)
+{
+	int r;
+
+	r = cmpxchg_relaxed(l0, 1, 0);
+	r = atomic_add_return_release(1, item);
+	r = atomic_cmpxchg_relaxed(item, 1, 0);
+	r = atomic_add_return_release(1, root);
+}
+
+P1(int *l0, atomic_t *item, atomic_t *root)
+{
+	int r0;
+	int r1;
+	int r2;
+
+	r2 = atomic_read(root);
+	smp_rmb();
+	r1 = atomic_read(item);
+	smp_rmb();
+	r0 = READ_ONCE(*l0);
+}
+
+exists ((1:r2=1 /\ 1:r1=1) \/ (1:r2=1 /\ 1:r0=1) \/ (1:r1=1 /\ 1:r0=1))
diff --git a/tools/testing/hpcc/litmus/limit-arrive-first-acquire.litmus b/tools/testing/hpcc/litmus/limit-arrive-first-acquire.litmus
new file mode 100644
index 000000000000..f5f06dd0ff08
--- /dev/null
+++ b/tools/testing/hpcc/litmus/limit-arrive-first-acquire.litmus
@@ -0,0 +1,38 @@
+C limit-arrive-first-acquire
+
+(*
+ * Result: Sometimes
+ *
+ * Like limit-arrive-first, with an acquire add at the root. The acquire
+ * only orders the read of the add. The departures can then be seen
+ * before the arrival at the root, and the sum misses the carry.
+ *)
+
+{
+	l0 = 1;
+}
+
+P0(int *l0, atomic_t *item, atomic_t *root)
+{
+	int r;
+
+	r = atomic_cmpxchg(item, 0, 1);
+	r = atomic_add_return_acquire(1, root);
+	atomic_sub(1, item);
+	WRITE_ONCE(*l0, 0);
+}
+
+P1(int *l0, atomic_t *item, atomic_t *root)
+{
+	int r0;
+	int r1;
+	int r2;
+
+	r0 = READ_ONCE(*l0);
+	smp_rmb();
+	r1 = atomic_read(item);
+	smp_rmb();
+	r2 = atomic_read(root);
+}
+
+exists (1:r0=0 /\ 1:r1=0 /\ 1:r2=0)
diff --git a/tools/testing/hpcc/litmus/limit-arrive-first-unordered.litmus b/tools/testing/hpcc/litmus/limit-arrive-first-unordered.litmus
new file mode 100644
index 000000000000..9d870c2e0aa2
--- /dev/null
+++ b/tools/testing/hpcc/litmus/limit-arrive-first-unordered.litmus
@@ -0,0 +1,37 @@
+C limit-arrive-first-unordered
+
+(*
+ * Result: Sometimes
+ *
+ * Like limit-arrive-first, with an unordered add at the root. The sum
+ * can miss the carry.
+ *)
+
+{
+	l0 = 1;
+}
+
+P0(int *l0, atomic_t *item, atomic_t *root)
+{
+	int r;
+
+	r = atomic_cmpxchg(item, 0, 1);
+	atomic_add(1, root);
+	atomic_sub(1, item);
+	WRITE_ONCE(*l0, 0);
+}
+
+P1(int *l0, atomic_t *item, atomic_t *root)
+{
+	int r0;
+	int r1;
+	int r2;
+
+	r0 = READ_ONCE(*l0);
+	smp_rmb();
+	r1 = atomic_read(item);
+	smp_rmb();
+	r2 = atomic_read(root);
+}
+
+exists (1:r0=0 /\ 1:r1=0 /\ 1:r2=0)
diff --git a/tools/testing/hpcc/litmus/limit-arrive-first.litmus b/tools/testing/hpcc/litmus/limit-arrive-first.litmus
new file mode 100644
index 000000000000..9d9f6efdf0aa
--- /dev/null
+++ b/tools/testing/hpcc/litmus/limit-arrive-first.litmus
@@ -0,0 +1,41 @@
+C limit-arrive-first
+
+(*
+ * Result: Never
+ *
+ * A carry of the additions of a limit counter, from the level 0 counter
+ * l0 to the root through a middle item, as in
+ * percpu_counter_tree_add_arrive_first(). It arrives at the item with a
+ * fully ordered cmpxchg, and at the root with a fully ordered add. Then
+ * it leaves the item and level 0. The precise sum reads level 0, the
+ * item and the root, with read barriers. It never misses the carry.
+ *)
+
+{
+	l0 = 1;
+}
+
+P0(int *l0, atomic_t *item, atomic_t *root)
+{
+	int r;
+
+	r = atomic_cmpxchg(item, 0, 1);
+	r = atomic_add_return(1, root);
+	atomic_sub(1, item);
+	WRITE_ONCE(*l0, 0);
+}
+
+P1(int *l0, atomic_t *item, atomic_t *root)
+{
+	int r0;
+	int r1;
+	int r2;
+
+	r0 = READ_ONCE(*l0);
+	smp_rmb();
+	r1 = atomic_read(item);
+	smp_rmb();
+	r2 = atomic_read(root);
+}
+
+exists (1:r0=0 /\ 1:r1=0 /\ 1:r2=0)
diff --git a/tools/testing/hpcc/litmus/limit-free-level0-nomb.litmus b/tools/testing/hpcc/litmus/limit-free-level0-nomb.litmus
new file mode 100644
index 000000000000..d220bab401ac
--- /dev/null
+++ b/tools/testing/hpcc/litmus/limit-free-level0-nomb.litmus
@@ -0,0 +1,40 @@
+C limit-free-level0-nomb
+
+(*
+ * Result: Sometimes
+ *
+ * Like limit-free-level0, without the full barrier after the addition.
+ * The release of the page does not order the addition before the
+ * unordered subtraction of CPU 1, for CPU 2. The precise sum can then
+ * see the subtraction without the addition.
+ *)
+
+{}
+
+P0(int *l0p, int *page)
+{
+	WRITE_ONCE(*l0p, 1);
+	smp_store_release(page, 1);
+}
+
+P1(int *l0n, int *page)
+{
+	int r0;
+	int r;
+
+	r0 = smp_load_acquire(page);
+	if (r0 == 1)
+		r = cmpxchg_relaxed(l0n, 0, 1);
+}
+
+P2(int *l0p, int *l0n)
+{
+	int r0;
+	int r1;
+
+	r0 = READ_ONCE(*l0n);
+	smp_rmb();
+	r1 = READ_ONCE(*l0p);
+}
+
+exists (1:r0=1 /\ 2:r0=1 /\ 2:r1=0)
diff --git a/tools/testing/hpcc/litmus/limit-free-level0.litmus b/tools/testing/hpcc/litmus/limit-free-level0.litmus
new file mode 100644
index 000000000000..cb5d6b083ecf
--- /dev/null
+++ b/tools/testing/hpcc/litmus/limit-free-level0.litmus
@@ -0,0 +1,43 @@
+C limit-free-level0
+
+(*
+ * Result: Never
+ *
+ * CPU 0 adds to its level 0 counter of the additions l0p. The full
+ * barrier of percpu_counter_tree_limit_add() follows. Then CPU 0
+ * publishes the page it charged. CPU 1 finds the page and frees it: the
+ * subtraction stays in its level 0 counter of the subtractions l0n,
+ * without ordering. The precise sum of CPU 2 reads l0n, then l0p after a
+ * read barrier. It never sees the subtraction without the addition.
+ *)
+
+{}
+
+P0(int *l0p, int *page)
+{
+	WRITE_ONCE(*l0p, 1);
+	smp_mb();
+	smp_store_release(page, 1);
+}
+
+P1(int *l0n, int *page)
+{
+	int r0;
+	int r;
+
+	r0 = smp_load_acquire(page);
+	if (r0 == 1)
+		r = cmpxchg_relaxed(l0n, 0, 1);
+}
+
+P2(int *l0p, int *l0n)
+{
+	int r0;
+	int r1;
+
+	r0 = READ_ONCE(*l0n);
+	smp_rmb();
+	r1 = READ_ONCE(*l0p);
+}
+
+exists (1:r0=1 /\ 2:r0=1 /\ 2:r1=0)
diff --git a/tools/testing/hpcc/litmus/limit-free-root.litmus b/tools/testing/hpcc/litmus/limit-free-root.litmus
new file mode 100644
index 000000000000..d3f267311411
--- /dev/null
+++ b/tools/testing/hpcc/litmus/limit-free-root.litmus
@@ -0,0 +1,42 @@
+C limit-free-root
+
+(*
+ * Result: Never
+ *
+ * CPU 0 adds to the root of the additions p, then publishes the page it
+ * charged. CPU 1 finds the page and frees it: its carry reaches the root
+ * of the subtractions n with a release. CPU 2 checks: it reads n with an
+ * acquire, then p. It never sees the subtraction without the
+ * addition.
+ *)
+
+{}
+
+P0(atomic_t *p, int *page)
+{
+	int r;
+
+	r = atomic_add_return(1, p);
+	smp_store_release(page, 1);
+}
+
+P1(atomic_t *n, int *page)
+{
+	int r0;
+	int r;
+
+	r0 = smp_load_acquire(page);
+	if (r0 == 1)
+		r = atomic_add_return_release(1, n);
+}
+
+P2(atomic_t *p, atomic_t *n)
+{
+	int r0;
+	int r1;
+
+	r0 = atomic_read_acquire(n);
+	r1 = atomic_read(p);
+}
+
+exists (1:r0=1 /\ 2:r0=1 /\ 2:r1=0)
diff --git a/tools/testing/hpcc/litmus/limit-last-checker-nomb.litmus b/tools/testing/hpcc/litmus/limit-last-checker-nomb.litmus
new file mode 100644
index 000000000000..2690fdf6e868
--- /dev/null
+++ b/tools/testing/hpcc/litmus/limit-last-checker-nomb.litmus
@@ -0,0 +1,28 @@
+C limit-last-checker-nomb
+
+(*
+ * Result: Sometimes
+ *
+ * Like limit-last-checker, without the full barrier. Both checks can
+ * miss the other addition, and both pass.
+ *)
+
+{}
+
+P0(int *a, int *b)
+{
+	int r0;
+
+	WRITE_ONCE(*a, 1);
+	r0 = READ_ONCE(*b);
+}
+
+P1(int *a, int *b)
+{
+	int r0;
+
+	WRITE_ONCE(*b, 1);
+	r0 = READ_ONCE(*a);
+}
+
+exists (0:r0=0 /\ 1:r0=0)
diff --git a/tools/testing/hpcc/litmus/limit-last-checker.litmus b/tools/testing/hpcc/litmus/limit-last-checker.litmus
new file mode 100644
index 000000000000..891f20ec86a0
--- /dev/null
+++ b/tools/testing/hpcc/litmus/limit-last-checker.litmus
@@ -0,0 +1,33 @@
+C limit-last-checker
+
+(*
+ * Result: Never
+ *
+ * Two CPUs add to their level 0 counters a and b, then check with a
+ * precise sum, which reads the other counter. With a full barrier
+ * between the addition and the check, at least one of them sees the
+ * other addition. Of the additions which pass their check, the one
+ * checked last thus sees all of them.
+ *)
+
+{}
+
+P0(int *a, int *b)
+{
+	int r0;
+
+	WRITE_ONCE(*a, 1);
+	smp_mb();
+	r0 = READ_ONCE(*b);
+}
+
+P1(int *a, int *b)
+{
+	int r0;
+
+	WRITE_ONCE(*b, 1);
+	smp_mb();
+	r0 = READ_ONCE(*a);
+}
+
+exists (0:r0=0 /\ 1:r0=0)
diff --git a/tools/testing/hpcc/litmus/limit-undo-level0.litmus b/tools/testing/hpcc/litmus/limit-undo-level0.litmus
new file mode 100644
index 000000000000..1bda7b3835de
--- /dev/null
+++ b/tools/testing/hpcc/litmus/limit-undo-level0.litmus
@@ -0,0 +1,35 @@
+C limit-undo-level0
+
+(*
+ * Result: Never
+ *
+ * An addition which does not fit is undone on the same CPU. Both stay
+ * in the level 0 counters, l0p for the additions and l0n for the
+ * subtractions. The full barrier of percpu_counter_tree_limit_add()
+ * comes between them. The precise sum of the limit counter reads l0n,
+ * then l0p after a read barrier. It never sees the subtraction without
+ * the addition.
+ *)
+
+{}
+
+P0(int *l0p, int *l0n)
+{
+	int r;
+
+	WRITE_ONCE(*l0p, 1);
+	smp_mb();
+	r = cmpxchg_relaxed(l0n, 0, 1);
+}
+
+P1(int *l0p, int *l0n)
+{
+	int r0;
+	int r1;
+
+	r0 = READ_ONCE(*l0n);
+	smp_rmb();
+	r1 = READ_ONCE(*l0p);
+}
+
+exists (0:r=0 /\ 1:r0=1 /\ 1:r1=0)
diff --git a/tools/testing/hpcc/litmus/limit-undo-root-rmb.litmus b/tools/testing/hpcc/litmus/limit-undo-root-rmb.litmus
new file mode 100644
index 000000000000..3b43afbeb8e9
--- /dev/null
+++ b/tools/testing/hpcc/litmus/limit-undo-root-rmb.litmus
@@ -0,0 +1,30 @@
+C limit-undo-root-rmb
+
+(*
+ * Result: Never
+ *
+ * Like limit-undo-root, with a read barrier between the two reads
+ * instead of the acquire.
+ *)
+
+{}
+
+P0(atomic_t *p, atomic_t *n)
+{
+	int r;
+
+	r = atomic_add_return(1, p);
+	r = atomic_add_return_release(1, n);
+}
+
+P1(atomic_t *p, atomic_t *n)
+{
+	int r0;
+	int r1;
+
+	r0 = atomic_read(n);
+	smp_rmb();
+	r1 = atomic_read(p);
+}
+
+exists (1:r0=1 /\ 1:r1=0)
diff --git a/tools/testing/hpcc/litmus/limit-undo-root-unordered.litmus b/tools/testing/hpcc/litmus/limit-undo-root-unordered.litmus
new file mode 100644
index 000000000000..65bc0f2900b2
--- /dev/null
+++ b/tools/testing/hpcc/litmus/limit-undo-root-unordered.litmus
@@ -0,0 +1,29 @@
+C limit-undo-root-unordered
+
+(*
+ * Result: Sometimes
+ *
+ * Like limit-undo-root, without ordering between the two reads. The
+ * check can then see the subtraction without the addition.
+ *)
+
+{}
+
+P0(atomic_t *p, atomic_t *n)
+{
+	int r;
+
+	r = atomic_add_return(1, p);
+	r = atomic_add_return_release(1, n);
+}
+
+P1(atomic_t *p, atomic_t *n)
+{
+	int r0;
+	int r1;
+
+	r0 = atomic_read(n);
+	r1 = atomic_read(p);
+}
+
+exists (1:r0=1 /\ 1:r1=0)
diff --git a/tools/testing/hpcc/litmus/limit-undo-root.litmus b/tools/testing/hpcc/litmus/limit-undo-root.litmus
new file mode 100644
index 000000000000..72335ee2ee6c
--- /dev/null
+++ b/tools/testing/hpcc/litmus/limit-undo-root.litmus
@@ -0,0 +1,32 @@
+C limit-undo-root
+
+(*
+ * Result: Never
+ *
+ * An addition which does not fit is undone on the same CPU. Its carry
+ * reaches the root of the additions p. Then the undo reaches the root of
+ * the subtractions n, with a release. The check reads n with an acquire,
+ * then p. It never sees the subtraction without the addition, which
+ * would take the difference below the value.
+ *)
+
+{}
+
+P0(atomic_t *p, atomic_t *n)
+{
+	int r;
+
+	r = atomic_add_return(1, p);
+	r = atomic_add_return_release(1, n);
+}
+
+P1(atomic_t *p, atomic_t *n)
+{
+	int r0;
+	int r1;
+
+	r0 = atomic_read_acquire(n);
+	r1 = atomic_read(p);
+}
+
+exists (1:r0=1 /\ 1:r1=0)
diff --git a/tools/testing/hpcc/litmus/publish-approximate-sum.litmus b/tools/testing/hpcc/litmus/publish-approximate-sum.litmus
new file mode 100644
index 000000000000..be4396a96ebc
--- /dev/null
+++ b/tools/testing/hpcc/litmus/publish-approximate-sum.litmus
@@ -0,0 +1,40 @@
+C publish-approximate-sum
+
+(*
+ * Result: Never
+ *
+ * percpu_counter_tree_activate_many() zeroes the per-CPU counter l0mem
+ * and the root rootmem, which held stale values, then publishes approx_sum
+ * and level0 with releases. See "Publication of the tree" in
+ * lib/percpu_counter_tree.c.
+ *
+ * The approximate sum reads approx_sum, then the root through it. The
+ * address dependency orders the two reads. It never sees the stale
+ * root.
+ *)
+
+{
+	level0=nolevel0;
+	approx_sum=noroot;
+	l0mem=1;
+	rootmem=1;
+}
+
+P0(int **level0, int **approx_sum, int *l0mem, int *rootmem)
+{
+	WRITE_ONCE(*l0mem, 0);
+	WRITE_ONCE(*rootmem, 0);
+	smp_store_release(approx_sum, rootmem);
+	smp_store_release(level0, l0mem);
+}
+
+P1(int **level0, int **approx_sum)
+{
+	int *r0;
+	int r1;
+
+	r0 = READ_ONCE(*approx_sum);
+	r1 = READ_ONCE(*r0);
+}
+
+exists (1:r0=rootmem /\ 1:r1=1)
diff --git a/tools/testing/hpcc/litmus/publish-carry-normb.litmus b/tools/testing/hpcc/litmus/publish-carry-normb.litmus
new file mode 100644
index 000000000000..bc5fa4a6aaad
--- /dev/null
+++ b/tools/testing/hpcc/litmus/publish-carry-normb.litmus
@@ -0,0 +1,36 @@
+C publish-carry-normb
+
+(*
+ * Result: Sometimes
+ *
+ * Like publish-carry, without the read barrier. The carry slow path can
+ * then see approx_sum unpublished.
+ *)
+
+{
+	level0=nolevel0;
+	approx_sum=noroot;
+	l0mem=1;
+	rootmem=1;
+}
+
+P0(int **level0, int **approx_sum, int *l0mem, int *rootmem)
+{
+	WRITE_ONCE(*l0mem, 0);
+	WRITE_ONCE(*rootmem, 0);
+	smp_store_release(approx_sum, rootmem);
+	smp_store_release(level0, l0mem);
+}
+
+P1(int **level0, int **approx_sum)
+{
+	int *r0;
+	int *r1;
+	int r2;
+
+	r0 = READ_ONCE(*level0);
+	r1 = READ_ONCE(*approx_sum);
+	r2 = READ_ONCE(*r1);
+}
+
+exists (1:r0=l0mem /\ (1:r1=noroot \/ 1:r2=1))
diff --git a/tools/testing/hpcc/litmus/publish-carry.litmus b/tools/testing/hpcc/litmus/publish-carry.litmus
new file mode 100644
index 000000000000..b316ade6d647
--- /dev/null
+++ b/tools/testing/hpcc/litmus/publish-carry.litmus
@@ -0,0 +1,43 @@
+C publish-carry
+
+(*
+ * Result: Never
+ *
+ * percpu_counter_tree_activate_many() zeroes the per-CPU counter l0mem
+ * and the root rootmem, which held stale values, then publishes approx_sum
+ * and level0 with releases. See "Publication of the tree" in
+ * lib/percpu_counter_tree.c.
+ *
+ * The carry slow path has read level0. Then it reads approx_sum after a
+ * read barrier, and the root through it. It never sees approx_sum
+ * unpublished or the stale root.
+ *)
+
+{
+	level0=nolevel0;
+	approx_sum=noroot;
+	l0mem=1;
+	rootmem=1;
+}
+
+P0(int **level0, int **approx_sum, int *l0mem, int *rootmem)
+{
+	WRITE_ONCE(*l0mem, 0);
+	WRITE_ONCE(*rootmem, 0);
+	smp_store_release(approx_sum, rootmem);
+	smp_store_release(level0, l0mem);
+}
+
+P1(int **level0, int **approx_sum)
+{
+	int *r0;
+	int *r1;
+	int r2;
+
+	r0 = READ_ONCE(*level0);
+	smp_rmb();
+	r1 = READ_ONCE(*approx_sum);
+	r2 = READ_ONCE(*r1);
+}
+
+exists (1:r0=l0mem /\ (1:r1=noroot \/ 1:r2=1))
diff --git a/tools/testing/hpcc/litmus/publish-precise-sum-noacquire.litmus b/tools/testing/hpcc/litmus/publish-precise-sum-noacquire.litmus
new file mode 100644
index 000000000000..b3fcfad22a61
--- /dev/null
+++ b/tools/testing/hpcc/litmus/publish-precise-sum-noacquire.litmus
@@ -0,0 +1,38 @@
+C publish-precise-sum-noacquire
+
+(*
+ * Result: Sometimes
+ *
+ * Like publish-precise-sum, with a plain read of level0. The precise sum
+ * can then see approx_sum unpublished.
+ *)
+
+{
+	level0=nolevel0;
+	approx_sum=noroot;
+	l0mem=1;
+	rootmem=1;
+}
+
+P0(int **level0, int **approx_sum, int *l0mem, int *rootmem)
+{
+	WRITE_ONCE(*l0mem, 0);
+	WRITE_ONCE(*rootmem, 0);
+	smp_store_release(approx_sum, rootmem);
+	smp_store_release(level0, l0mem);
+}
+
+P1(int **level0, int **approx_sum)
+{
+	int *r0;
+	int *r1;
+	int r2;
+	int r3;
+
+	r0 = READ_ONCE(*level0);
+	r1 = READ_ONCE(*approx_sum);
+	r2 = READ_ONCE(*r1);
+	r3 = READ_ONCE(*r0);
+}
+
+exists (1:r0=l0mem /\ (1:r1=noroot \/ 1:r2=1 \/ 1:r3=1))
diff --git a/tools/testing/hpcc/litmus/publish-precise-sum.litmus b/tools/testing/hpcc/litmus/publish-precise-sum.litmus
new file mode 100644
index 000000000000..0649b75b0bdc
--- /dev/null
+++ b/tools/testing/hpcc/litmus/publish-precise-sum.litmus
@@ -0,0 +1,44 @@
+C publish-precise-sum
+
+(*
+ * Result: Never
+ *
+ * percpu_counter_tree_activate_many() zeroes the per-CPU counter l0mem
+ * and the root rootmem, which held stale values, then publishes approx_sum
+ * and level0 with releases. See "Publication of the tree" in
+ * lib/percpu_counter_tree.c.
+ *
+ * The precise sum reads level0 with an acquire, then approx_sum, the
+ * root and the per-CPU counter. It never sees approx_sum unpublished or
+ * a stale value.
+ *)
+
+{
+	level0=nolevel0;
+	approx_sum=noroot;
+	l0mem=1;
+	rootmem=1;
+}
+
+P0(int **level0, int **approx_sum, int *l0mem, int *rootmem)
+{
+	WRITE_ONCE(*l0mem, 0);
+	WRITE_ONCE(*rootmem, 0);
+	smp_store_release(approx_sum, rootmem);
+	smp_store_release(level0, l0mem);
+}
+
+P1(int **level0, int **approx_sum)
+{
+	int *r0;
+	int *r1;
+	int r2;
+	int r3;
+
+	r0 = smp_load_acquire(level0);
+	r1 = READ_ONCE(*approx_sum);
+	r2 = READ_ONCE(*r1);
+	r3 = READ_ONCE(*r0);
+}
+
+exists (1:r0=l0mem /\ (1:r1=noroot \/ 1:r2=1 \/ 1:r3=1))
diff --git a/tools/testing/hpcc/litmus/publish-update-norelease.litmus b/tools/testing/hpcc/litmus/publish-update-norelease.litmus
new file mode 100644
index 000000000000..44a3d387b760
--- /dev/null
+++ b/tools/testing/hpcc/litmus/publish-update-norelease.litmus
@@ -0,0 +1,34 @@
+C publish-update-norelease
+
+(*
+ * Result: Sometimes
+ *
+ * Like publish-update, with plain stores instead of the releases. The
+ * update fast path can then see the stale per-CPU counter.
+ *)
+
+{
+	level0=nolevel0;
+	approx_sum=noroot;
+	l0mem=1;
+	rootmem=1;
+}
+
+P0(int **level0, int **approx_sum, int *l0mem, int *rootmem)
+{
+	WRITE_ONCE(*l0mem, 0);
+	WRITE_ONCE(*rootmem, 0);
+	WRITE_ONCE(*approx_sum, rootmem);
+	WRITE_ONCE(*level0, l0mem);
+}
+
+P1(int **level0, int **approx_sum)
+{
+	int *r0;
+	int r1;
+
+	r0 = READ_ONCE(*level0);
+	r1 = READ_ONCE(*r0);
+}
+
+exists (1:r0=l0mem /\ 1:r1=1)
diff --git a/tools/testing/hpcc/litmus/publish-update.litmus b/tools/testing/hpcc/litmus/publish-update.litmus
new file mode 100644
index 000000000000..55603a274b28
--- /dev/null
+++ b/tools/testing/hpcc/litmus/publish-update.litmus
@@ -0,0 +1,40 @@
+C publish-update
+
+(*
+ * Result: Never
+ *
+ * percpu_counter_tree_activate_many() zeroes the per-CPU counter l0mem
+ * and the root rootmem, which held stale values, then publishes approx_sum
+ * and level0 with releases. See "Publication of the tree" in
+ * lib/percpu_counter_tree.c.
+ *
+ * The update fast path reads level0, then its per-CPU counter through
+ * it. The address dependency orders the two reads. It never sees the
+ * stale per-CPU counter.
+ *)
+
+{
+	level0=nolevel0;
+	approx_sum=noroot;
+	l0mem=1;
+	rootmem=1;
+}
+
+P0(int **level0, int **approx_sum, int *l0mem, int *rootmem)
+{
+	WRITE_ONCE(*l0mem, 0);
+	WRITE_ONCE(*rootmem, 0);
+	smp_store_release(approx_sum, rootmem);
+	smp_store_release(level0, l0mem);
+}
+
+P1(int **level0, int **approx_sum)
+{
+	int *r0;
+	int r1;
+
+	r0 = READ_ONCE(*level0);
+	r1 = READ_ONCE(*r0);
+}
+
+exists (1:r0=l0mem /\ 1:r1=1)
-- 
2.47.3


