Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 462DB606A334
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 20:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=so2DtaRs
Received: by kanga.kvack.org (Postfix)
	id 71BCF6B05BB; Wed, 11 Nov 2026 15:36:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CC3A6B05BC; Wed, 11 Nov 2026 15:36:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BB566B05BD; Wed, 11 Nov 2026 15:36:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2866D6B05BB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:36:52 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A6697C0424
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:36:51 +0000 (UTC)
X-FDA: 85423997022.29.F21EBE5
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf22.hostedemail.com (Postfix) with ESMTP id 12A4DC000A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:36:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=so2DtaRs;
	spf=pass (imf22.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794429410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dbm0VwL+IAH1JKHDOMy86I/B31ZxYskN+TpiCu+7uLU=;
	b=z5/7pgcHIi+lOf9ryNUTP7loj3M7zaE3yt/H1eLveQIpNNmv9RUh3GPIy5b3MWmj22QWLz
	qPsN4VGLlEItcrWDJTV7pd+N3e6TYlHYtgRjObhHLNK3kUUwuZNCIeOLOEa+yW+pEhlIXR
	rRWVY+DE52aqJh+C7M6Ig3pOO7TWvpI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794429410;
	b=aTmYBD8LPBwpuhCKyTzUd1HQa9rUJ38HBb9mGx/coHmoS2JQgfH5Co/PShoZTiEogFvN7S
	c7ad594k2zUhlC+Pk1Fnr5zGzyNY1Wzdh6zVSWXkZylDvxVqT/YuguQlxQJFuNYnFgdrZM
	xr3Onw7u/6Mano0uwafWWKWC50l5rmY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=so2DtaRs;
	spf=pass (imf22.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794429407;
	bh=Dbm0VwL+IAH1JKHDOMy86I/B31ZxYskN+TpiCu+7uLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=so2DtaRsE/AuKJbBfAeMAfyEFsV8dglB5hf5iA7/dlqU8H+jwfBZAnDDtlsnsK/EK
	 NVz44i5hP95Fhm98bDcODZsoPN/x5+V3/yGH9khatqA/fYGCrWA5DEEzMV1yheoaIA
	 AMz9209135DDL7o0key0OTxs5Pi/9EXQOC8qUDsyyMpN/iz0b18TMxF3qnPc/0+IR5
	 rZv2kt3HB4KC2Y1kw8c5xgV2csGEeC9ZFZfZAvOuxZPqs+1ktJVcbgN54j4isXKJNc
	 9VUGQsgEDZT642zS3NKZ1rQZeeNP4YL1Jo7SF0d4TVgKWyFBKFOLq+bSaX/gGHSZfN
	 nzlcLS5romcqQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jPwKq1cqFzN31;
	Wed, 11 Nov 2026 15:36:47 -0500 (EST)
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
Subject: [RFC PATCH v25 12/14] lib: percpu_counter_tree: add the arity boot parameter
Date: Wed, 11 Nov 2026 15:36:24 -0500
Message-Id: <20261111203626.95838-13-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261111203626.95838-1-mathieu.desnoyers@efficios.com>
References: <20261111203626.95838-1-mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 12A4DC000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3cjuirdbbzebgkdgwg1o7djjfsjhpxko
X-Rspam-User: 
X-HE-Tag: 1794429409-118022
X-HE-Meta: U2FsdGVkX1+sJRzaZZYSumT3GrDqtzbKhyS5PIk0KdWnnKcG4QjwS+f1q62QGNHAIVATIyghrN2G41D1MaGTG9xYC+ZhU0FSKf1Qh5RnCXRyha3kDFgfVs+aREKCndDKGcTJNo/zWPi+TCaANkljv7nm6xwKtVUZyfzn1GQKf7qipaGkYMIGZrAqscO8EJshVz4kFKC3GK38QxAheja969BsmUkDBxvGCTw2u7w63tLLsqhJVFqtAoQ4G/FrayTQu8+f1Zjh4d3BkxGt6ecVas2qI4yIVBS6FRDUrYCLK/p7ZIPVc+aQ+YujJ39rwd/LU0JiP52jmNVKDfr0Q3ZIJ9uMVeLRImtEqc89ymSkb9Z69WNoU799L5UcdRSkQRrfVyEBc/kzhVnlhWbTGtEo2BOmACMzKwaDMwqd0rEydYMYOu2nU4rhBSNnxcOvepghOgNcpNt+F8Z4Q/OIqToi38vJWY94PlPSKapvbrpewEYJPpD4gUQOgSLVFntH1eYiWKc5rajVLMVndlgUerPY1hibX76K/YbHg89ZpfyMf5bph3l/BMeWKJV9gaHtpT7RGtaRNXjxWCxjAQ8VQyArMsVt2VxWIMTO7eEhpIsNlMCA1LnrU4K+DB/tVJ4uGgP/GOPLLBC8kMdzGzx2Ccistgwr60d9GJczKdO0n06r3CNW2R2RzGJw4WiaauA5ZXJLPEo8uCQpJipwIF3+ehSbmibXfhOZXaHGBm3fbIzQmyWdFM0Cm/0tAAt0emVbzj5tYmIt1qRjDXvJODcNtZJ8/nf40LDQs039mkOfXq5FE3JfvNyXqmLbcrLtXF4nlY5oiLl6+ygdJN3vATNxm1N0x73scyFNonOa/HThOhSmB3CM9CsIt+t5H8y8a87k5XxIKoXMpy7L5fzLlbufdkXX0OUMqIeW0U/iKr8eT0i2Wdn+pfnPZ3WUS37WTiyQAxPhgQjEwh9x4WtcEASobSK
 s6/xqslZ
 1lOl7DWwaqE9yK8MPNOOPWn3LKJ/Zeyd6e2E1kLtd+wfqjyejhABRE92rFVZXbdTGWVXD2X1tFQMrbR0lLZS24U+oamaDBWV3dFoCl2uHidJjtbUaVe0dKyUjvG/VAxsYQIP+GQrWtP+ZXs9njCXig7SE+VVOHgg8ur319YN6gAyHG91LFLOgTKVlbA255DNca2cnRIBfFp794C/8PisMQJe5nCEzvcqSIkYhV343L30CYnhcaCUqTCu9VOIeN8ZZbOqNlDllVvOEcAD6AUnp1miEbnrycXfd7jz2ONDQM15BQQgJClwFgwOzJlHYNJDaze+vrmUgZUtAtXXrD7INZGBXdQvQm0/pZH4z8bF7A2Xz/hM9ScEMnFcBmIk/dVexXqBBMXfYT978bTIDHSRatTHdhTfg8Ti7WjK6g3+COv77Vig=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The fan-out of each tree level is selected at boot from nr_cpu_ids, the
highest possible CPU number plus one, using a table tuned for the RSS
counters on one machine, a 2-socket AMD EPYC 9654 with 192 cores and 384
logical CPUs.  The best shape depends on the cost of cache line
transfers on a given machine, which varies with the number of sockets,
the cache topology and SMT, so it may differ on other hardware.

Add the percpu_counter_tree.arity= boot parameter, which overrides the
tree shape with the fan-out of each level, from the per-cpu counters to
the root, so the shapes can be compared on other machines, to improve
the default table.  For example, when nr_cpu_ids is 16, "16" is a flat
tree and "4,4" a tree with 4 intermediate counters.  Each fan-out is a
power of 2, and their product must be nr_cpu_ids rounded up to a power
of 2.  An invalid shape is ignored with a warning.

The shape in use is printed at boot, and can be read from
/sys/module/percpu_counter_tree/parameters/arity.

Cover the parsing of the parameter in the userspace test, with valid and
invalid shapes, and run the counter tests on the valid ones.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 .../admin-guide/kernel-parameters.txt         | 14 +++
 .../core-api/percpu-counter-tree.rst          |  3 +-
 lib/percpu_counter_tree.c                     | 96 ++++++++++++++++++-
 tools/testing/hpcc/include/hpcc_shim.h        |  4 +
 .../testing/hpcc/include/linux/moduleparam.h  | 12 +++
 tools/testing/hpcc/main.c                     | 78 ++++++++++++++-
 6 files changed, 201 insertions(+), 6 deletions(-)
 create mode 100644 tools/testing/hpcc/include/linux/moduleparam.h

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0b3c140babd9..c368affa2115 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5342,6 +5342,20 @@ Kernel parameters
 			allocator.  This parameter is primarily	for debugging
 			and performance comparison.
 
+	percpu_counter_tree.arity=	[KNL,SMP]
+			Format: <fan-out>[,<fan-out>...]
+			Override the shape of the hierarchical per-cpu
+			counter trees (used for the RSS counters), listing
+			the fan-out of each tree level from the per-cpu
+			counters to the root. Each fan-out is a power of 2
+			and their product must be nr_cpu_ids (the highest
+			possible CPU number plus one) rounded up to a power
+			of 2, e.g. "16" (flat) or "4,4" when nr_cpu_ids
+			is 16. An invalid shape is ignored with a warning.
+			The shape in use is shown in
+			/sys/module/percpu_counter_tree/parameters/arity.
+			This parameter is meant for performance comparison.
+
 	pirq=		[SMP,APIC] Manual mp-table setup
 			See Documentation/arch/x86/i386/IO-APIC.rst.
 
diff --git a/Documentation/core-api/percpu-counter-tree.rst b/Documentation/core-api/percpu-counter-tree.rst
index 87babe2276c4..8aebf91aa133 100644
--- a/Documentation/core-api/percpu-counter-tree.rst
+++ b/Documentation/core-api/percpu-counter-tree.rst
@@ -63,7 +63,8 @@ possible CPU, and the tree items, whose number depends on nr_cpu_ids, so
 struct percpu_counter_tree has a fixed size.
 
 The fan-out of each tree level is selected at boot from nr_cpu_ids, the
-highest possible CPU number plus one.
+highest possible CPU number plus one. It can be overridden with the
+percpu_counter_tree.arity= boot parameter for performance comparison.
 
 The bounded accuracy is a property of the settled tree. While updates are
 in flight the transient error can exceed it, bounded by the number of
diff --git a/lib/percpu_counter_tree.c b/lib/percpu_counter_tree.c
index fcffc3d073ca..d1e4f01652d3 100644
--- a/lib/percpu_counter_tree.c
+++ b/lib/percpu_counter_tree.c
@@ -151,6 +151,7 @@
 #define pr_fmt(fmt) "percpu_counter_tree: " fmt
 
 #include <linux/percpu_counter_tree.h>
+#include <linux/moduleparam.h>
 #include <linux/align.h>
 #include <linux/cache.h>
 #include <linux/cpumask.h>
@@ -163,6 +164,7 @@
 #include <linux/math.h>
 #include <linux/log2.h>
 #include <linux/args.h>
+#include <linux/string.h>
 #include <kunit/visibility.h>
 
 #define MAX_NR_LEVELS 7
@@ -255,6 +257,8 @@ static_assert(ARRAY_SIZE(per_nr_cpu_order_config) == MAX_NR_CPUS_ORDER + 1);
 static struct {
 	/* Hierarchical counter configuration for the hardware topology. */
 	const struct counter_config *config;
+	/* Tree shape selected with the "arity" boot parameter. */
+	struct counter_config boot_config;
 	/* Order of nr_cpu_ids. */
 	unsigned int nr_cpus_order;
 	/*
@@ -273,6 +277,9 @@ static struct {
 	.nr_items = UINT_MAX,
 };
 
+/* Value of the "arity" boot parameter, parsed at subsystem initialization. */
+static const char *arity_param;
+
 /*
  * Size of the items of one tree position for the counters initialized
  * together by percpu_counter_tree_init_many(), packed in cache lines which
@@ -1652,7 +1659,10 @@ void percpu_counter_tree_copy_state(struct percpu_counter_tree *dst,
 EXPORT_SYMBOL_IF_KUNIT(percpu_counter_tree_copy_state);
 #endif
 
-/* Format the fan-out of each level, from level 0 to the root, e.g. "8,2,8". */
+/* Room for the fan-out of each level, up to 7 digits and a comma, and a NUL. */
+#define SHAPE_BUF_SIZE	(8 * MAX_NR_LEVELS + 1)
+
+/* Format the fan-out of each level, from level 0 to the root, e.g. "8,4,8". */
 static
 int format_shape(char *buf, size_t size, const struct counter_config *config)
 {
@@ -1665,9 +1675,78 @@ int format_shape(char *buf, size_t size, const struct counter_config *config)
 	return len;
 }
 
+static
+int arity_param_set(const char *val, const struct kernel_param *kp)
+{
+	/* Applied once by percpu_counter_tree_subsystem_init(). */
+	if (tree_topology.config)
+		return -EBUSY;
+	arity_param = val;
+	return 0;
+}
+
+static
+int arity_param_get(char *buffer, const struct kernel_param *kp)
+{
+	int len;
+
+	if (!tree_topology.config)
+		return sprintf(buffer, "%s\n", arity_param ? : "");
+	/* The buffer is a page, larger than any shape and its newline. */
+	len = format_shape(buffer, SHAPE_BUF_SIZE, tree_topology.config);
+	buffer[len++] = '\n';
+	return len;
+}
+
+static const struct kernel_param_ops arity_param_ops = {
+	.set = arity_param_set,
+	.get = arity_param_get,
+};
+
+/*
+ * percpu_counter_tree.arity=<fan-out>[,<fan-out>...] overrides the tree
+ * shape chosen for nr_cpu_ids, to compare shapes on a given machine.
+ * Reading the parameter shows the shape in use.
+ */
+module_param_cb(arity, &arity_param_ops, NULL, 0444);
+MODULE_PARM_DESC(arity, "Fan-out of each tree level from level 0 to the root, e.g. 8,4,8");
+
+/*
+ * Parse a list of fan-outs, from level 0 to the root, into @config. Each
+ * fan-out is a power of 2 of at least 2, and their product is nr_cpu_ids
+ * rounded up to a power of 2.
+ *
+ * Return: 0 on success, -EINVAL if the list does not describe a tree
+ * covering the CPU numbers below nr_cpu_ids.
+ */
+static
+int __init parse_arity(const char *str, struct counter_config *config)
+{
+	int ints[MAX_NR_LEVELS + 2];	/* Count, levels, and one extra to detect overflow. */
+	unsigned int level, order = 0;
+
+	if (*get_options(str, ARRAY_SIZE(ints), ints) || ints[0] > MAX_NR_LEVELS)
+		return -EINVAL;
+	config->nr_levels = ints[0];
+	for (level = 0; level < config->nr_levels; level++) {
+		int fan_out = ints[level + 1];
+
+		if (fan_out < 2 || !is_power_of_2(fan_out))
+			return -EINVAL;
+		config->n_arity_order[level] = ilog2(fan_out);
+		order += config->n_arity_order[level];
+		if (order > tree_topology.nr_cpus_order)
+			return -EINVAL;
+	}
+	if (order != tree_topology.nr_cpus_order)
+		return -EINVAL;
+	return 0;
+}
+
 int __init percpu_counter_tree_subsystem_init(void)
 {
-	char shape[8 * MAX_NR_LEVELS + 1] = "";
+	const char *origin = "default";
+	char shape[SHAPE_BUF_SIZE] = "";
 
 	tree_topology.nr_cpus_order = get_count_order(nr_cpu_ids);
 	if (tree_topology.nr_cpus_order >= ARRAY_SIZE(per_nr_cpu_order_config)) {
@@ -1675,14 +1754,23 @@ int __init percpu_counter_tree_subsystem_init(void)
 		return -EINVAL;
 	}
 	tree_topology.config = &per_nr_cpu_order_config[tree_topology.nr_cpus_order];
+	if (arity_param && *arity_param) {
+		if (parse_arity(arity_param, &tree_topology.boot_config)) {
+			pr_warn("Invalid arity \"%s\" for %u CPUs, using the default\n",
+				arity_param, nr_cpu_ids);
+		} else {
+			tree_topology.config = &tree_topology.boot_config;
+			origin = "boot parameter";
+		}
+	}
 	calculate_topology();
 	tree_topology.items_cachep =
 		kmem_cache_create("percpu_counter_tree_items",
 				  tree_topology.nr_items * SMP_CACHE_BYTES,
 				  SMP_CACHE_BYTES, SLAB_PANIC, NULL);
 	format_shape(shape, sizeof(shape), tree_topology.config);
-	pr_info("%u CPUs, fan-out %s, %u tree items\n",
-		nr_cpu_ids, tree_topology.nr_cpus_order ? shape : "none",
+	pr_info("%u CPUs, fan-out %s (%s), %u tree items\n",
+		nr_cpu_ids, tree_topology.nr_cpus_order ? shape : "none", origin,
 		tree_topology.nr_items);
 	return 0;
 }
diff --git a/tools/testing/hpcc/include/hpcc_shim.h b/tools/testing/hpcc/include/hpcc_shim.h
index 5d96d68f79bd..38407ac7cbbf 100644
--- a/tools/testing/hpcc/include/hpcc_shim.h
+++ b/tools/testing/hpcc/include/hpcc_shim.h
@@ -34,8 +34,12 @@
 #define abs(x) ({ typeof(x) __x = (x); __x < 0 ? -__x : __x; })
 
 #define pr_err(...)		fprintf(stderr, __VA_ARGS__)
+#define pr_warn(...)		fprintf(stderr, __VA_ARGS__)
 #define pr_info(...)		do { if (0) printf(__VA_ARGS__); } while (0)
 
+/* Implemented in main.c. */
+char *get_options(const char *str, int nints, int *ints);
+
 extern unsigned long hpcc_nr_warnings;
 
 #define WARN(cond, ...) ({						\
diff --git a/tools/testing/hpcc/include/linux/moduleparam.h b/tools/testing/hpcc/include/linux/moduleparam.h
new file mode 100644
index 000000000000..7e40df4295b2
--- /dev/null
+++ b/tools/testing/hpcc/include/linux/moduleparam.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+#include "../hpcc_shim.h"
+
+struct kernel_param;
+
+struct kernel_param_ops {
+	int (*set)(const char *val, const struct kernel_param *kp);
+	int (*get)(char *buffer, const struct kernel_param *kp);
+};
+
+#define module_param_cb(name, ops, arg, perm)
+#define MODULE_PARM_DESC(parm, desc)
diff --git a/tools/testing/hpcc/main.c b/tools/testing/hpcc/main.c
index 8046fb3a59eb..bd26dd467acb 100644
--- a/tools/testing/hpcc/main.c
+++ b/tools/testing/hpcc/main.c
@@ -89,6 +89,27 @@ int scnprintf(char *buf, size_t size, const char *fmt, ...)
 	return len < (int)size ? len : (int)size - 1;
 }
 
+/* Comma-separated integers, without the ranges of lib/cmdline.c. */
+char *get_options(const char *str, int nints, int *ints)
+{
+	char *end;
+	int i = 0;
+
+	while (i < nints - 1 && *str) {
+		long v = strtol(str, &end, 0);
+
+		if (end == str)
+			break;
+		ints[++i] = v;
+		str = end;
+		if (*str != ',')
+			break;
+		str++;
+	}
+	ints[0] = i;
+	return (char *)str;
+}
+
 static void hpcc_init_topology(unsigned int nr_cpus)
 {
 	nr_cpu_ids = nr_cpus;
@@ -770,6 +791,58 @@ static int run_case(unsigned int nr_cpus, unsigned long batch_size)
 	return nr_case_failures ? 1 : 0;
 }
 
+/* Tree shapes given with the arity boot parameter. */
+static const struct {
+	unsigned int nr_cpus;
+	const char *arity;
+	const char *shape;	/* Shape in use, NULL if the arity is invalid. */
+} test_arity[] = {
+	{ 16, "16", "16" },
+	{ 16, "4,4", "4,4" },
+	{ 16, "2,2,2,2", "2,2,2,2" },
+	{ 16, "4,2", NULL },		/* Covers 8 CPUs. */
+	{ 16, "4,8", NULL },		/* Covers 32 CPUs. */
+	{ 16, "4,4,1", NULL },		/* Fan-out of 1. */
+	{ 16, "4,3", NULL },		/* Not a power of 2. */
+	{ 16, "4,4x", NULL },		/* Trailing characters. */
+	{ 16, "-4,-4", NULL },
+	{ 17, "8,4", "8,4" },
+	{ 100, "128", "128" },
+	{ 192, "8,4,8", "8,4,8" },
+	{ 192, "2,2,2,2,2,2,2,2", NULL },	/* More than MAX_NR_LEVELS. */
+	{ 1024, "32,32", "32,32" },
+	{ 1, "2", NULL },
+};
+
+static int run_arity_case(unsigned int i)
+{
+	const char *expect = test_arity[i].shape;
+	char buf[SHAPE_BUF_SIZE];
+	int len;
+
+	nr_case_failures = 0;
+	hpcc_nr_warnings = 0;
+	tree_topology.config = NULL;
+	CHECK(!arity_param_set(test_arity[i].arity, NULL));
+	hpcc_init_topology(test_arity[i].nr_cpus);
+	arity_param = NULL;
+	CHECK(arity_param_set("16", NULL) == -EBUSY);
+	CHECK((tree_topology.config == &tree_topology.boot_config) == !!expect);
+	len = arity_param_get(buf, NULL);
+	CHECK(len > 0 && buf[len - 1] == '\n');
+	buf[len - 1] = '\0';
+	if (expect) {
+		CHECK(!strcmp(buf, expect));
+		test_saturated(2, 1);
+		test_saturated(32, -1);
+		test_random_walk(32, 20000);
+	}
+	CHECK(!hpcc_nr_warnings);
+	printf("%sok %d - arity nr_cpus=%u \"%s\" -> \"%s\"\n", nr_case_failures ? "not " : "",
+	       ++test_num, test_arity[i].nr_cpus, test_arity[i].arity, buf);
+	return nr_case_failures ? 1 : 0;
+}
+
 static int run_check_config(void)
 {
 	unsigned int nr_errors = percpu_counter_tree_check_config();
@@ -797,12 +870,15 @@ int main(int argc, char **argv)
 	if (argc == 2)
 		large = true;
 
-	nr_tests = 1 + ARRAY_SIZE(test_nr_cpus) * ARRAY_SIZE(test_batch_sizes);
+	nr_tests = 1 + ARRAY_SIZE(test_arity) +
+		   ARRAY_SIZE(test_nr_cpus) * ARRAY_SIZE(test_batch_sizes);
 	if (large)
 		nr_tests += ARRAY_SIZE(test_nr_cpus_large) * ARRAY_SIZE(test_batch_sizes);
 	printf("1..%u\n", nr_tests);
 
 	failed += run_check_config();
+	for (i = 0; i < ARRAY_SIZE(test_arity); i++)
+		failed += run_arity_case(i);
 	for (i = 0; i < ARRAY_SIZE(test_nr_cpus); i++)
 		for (j = 0; j < ARRAY_SIZE(test_batch_sizes); j++)
 			failed += run_case(test_nr_cpus[i], test_batch_sizes[j]);
-- 
2.47.3


