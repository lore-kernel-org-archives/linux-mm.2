Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6060606EE87
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 20:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=HWPOoBAO
Received: by kanga.kvack.org (Postfix)
	id 2AD6B6B05B9; Thu,  5 Nov 2026 15:36:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 238716B05BB; Thu,  5 Nov 2026 15:36:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8A26B05BA; Thu,  5 Nov 2026 15:36:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF8CC6B05BB
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:36:52 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 381C5A0C21
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:36:52 +0000 (UTC)
X-FDA: 85402224264.02.F2688FF
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf22.hostedemail.com (Postfix) with ESMTP id A66C1C000E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:36:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=HWPOoBAO;
	spf=pass (imf22.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793911010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u4szUUbd/kkYsYLlulDhD6NrSpjR5pa/uSMGvjF+Y58=;
	b=VegSpDjGmC+J/56Rbk1Khf/7nMmpqfWNp68Kk9C6QMSQb5gqG40Sok1mvK559bgxEwH5Na
	CKx33GsZSBDuVAOhS/uKyllq7UdtcruX5M1t8ykbAsTzVreWhkGs239KvWno6+WQunfpCf
	34uKQpibVDqVXQ0TD2a5NDv1LSO+N7I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=HWPOoBAO;
	spf=pass (imf22.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793911010;
	b=4fy6/+N9MR93LNoX7sJfVdJosumPd60v35zKEXeU1bzGWTierHaxwMUca6Wvpv/GUMmx/x
	MhSl0vbtMIZD3pH0d30MR0d8YMzqd3mTcBL1zBecHdcUbm1HhaEVXu2RknvPilEpBELrY3
	n3jDmJIYUJXa9TEWZiAIGT9yfn1KRzE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793911009;
	bh=u4szUUbd/kkYsYLlulDhD6NrSpjR5pa/uSMGvjF+Y58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWPOoBAONOHGoH9GlpHdY9hLYCkK4t4XE1dFbOmYvnY8GEN9HOqN6uLhc+GcR744R
	 yASYBTzLPMSfUi1kkwHhGDm1prCWTZhC5uafR5EtIYdFlKv0oR/oA5rwZl+ISsrrm0
	 30tOpuVmZ6ULFMa1hhr7bzjUMFCsWXWVFy+qxhHLCj5erzOCBDHTT7rtmlwCpyjKEA
	 xxQGhPB1b4kRzTgNciLVXY76L6xxnJQjUZSyVWuc/C6ihTBqkSF0Z2L4XnPrmey6G4
	 Fr7vqrVBFylVc9tDyFoxxHfCx9YDT9V6YFZnNqdJ0WTyTuD3WhoAYRYyywgB47SQ6d
	 8vXPiZd9oT/PA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLDcc6bz1zLcy;
	Thu, 05 Nov 2026 15:36:48 -0500 (EST)
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
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>,
	linux-trace-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Oleg Nesterov <oleg@redhat.com>
Subject: [RFC PATCH v24 08/10] lib: percpu_counter_tree: add the arity boot parameter
Date: Thu,  5 Nov 2026 15:36:37 -0500
Message-Id: <20261105203639.1459524-9-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261105203639.1459524-1-mathieu.desnoyers@efficios.com>
References: <20261105203639.1459524-1-mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a97z8ppnfotmeu4txg3mig6joso5b55a
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A66C1C000E
X-HE-Tag: 1793911010-130829
X-HE-Meta: U2FsdGVkX1/mxc5tN5ojgzvTNteG7Eo0t/JMZFivMRG9t8ffPClalTMgmNlRyGgOuJU08tJuh+ckdNz3a4MEZHXMUgWAW26GxWnMxTi6G9W0Fbzqlny9w+xKkHdg/SV6BOq4D8LXdahDJPaNjtKisus6+e/y10pJPd4xFj5vb9775rP4BnTnny4HEOP3Twq/7wEkHtbsqM26xGdujY/mIOuQYskD5GODY8jaS2h3ZQNP2x5KfzcNT4D+DSNCkxfGH14B1cfSETm7APGZzW5X+cRQc+PwL9x8IVCOELAcDB0SsoJrl7+BQ9J3EiuKwcvbcaes3SqMANNaYOKxPtfVyRumii6FXQKuUfv5hvsoqbpcriPOL5rLaD0UURsIihoAd0/0T48qxxONOvQxAejws/Zwc2QkWZnsa1vICrQ4nt2sFPrLIbJbgflHZboc2YISI7ja0koesELFDbCcP4/cTJ+F4qHpgorz1PyliNyjFQ21JOSowPIrH5xJY4zimN0WGstg/XLxXwEXybuoAQF+CVMoxL7tcNyhFnrI7zuPiZ3dDHgfh6HDqpBgSXhUiGQvKLghua8u81eC+X4D3iwMNaPiRFFqCYYUta9JpS/vWfdyYvIkwZ6cA8ewsjTc+DbaEgdVr3X4H50HIWWyviWTmxyH9MM4PGV/ltecIMg9WvbzuZKcd29QcNJzvTQN6QZ974TIQemPBDO6BdwNXgvO2HX9uizScABt+6Sh59ybPDMg/dKFTROi+pauhdvzBV+LFbGcNCZDDpqDbaCoMf3AroX8BhU+dtFiGYZAuLQBIXdYPoZm8aRENPYlF/F+L9AjFWafkfzgzYCyWuTp6/nfWsUXw5oVM8m3I54g8LnBpkAoK6MDObc9QKa41H54j2uvneOB45jpjxoF4DX0AORs96U6gBy883L6rpZpwsRgB2RxR6/r01rDvjPXvC9WF24WxRufyBQSAavE9LTp8oa
 WZIm8Qcf
 KmyHUiOFEW8p2hLGV8eYPeIKMkTR3v5h9yvbpzCaChFVcbA3xg4JE1b0mkCdAVnTNL5gAz7XPWyzwmsj3nfrljPAlmf9mO9Y2iQwQ0Xb6qSzWmYVURgCsmJySXFM7fknE7wDhOINJ2V/LKxGYL11qWT4jqADL5QHvZdPdSwF9NCiWNsuk3ISjrPV2hE2gYXbRKOEUdXvzhwviitkzrUEHtH+BJbXc3Z8Vabeo+7fDLpkOrKuCGuUpvXf959ZCBnQO/CPa72f5+Fq+GTsqk6SDrlPh+QnXfMHXYlPl2bDpqRNvaa3bTSWAxJQS86WaVnZcQ7xBEpYfv6eBvi6TUDWFlE7VBPxDv0r0eWm4f5c6DCZmrgx+nOAaVYt/fc+gSTXDNBspRR+JRO/mG1o8OVXxomlDxCMIIosRyra+mSC1+XLt17s=
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
index 32c4f05d7d7d..491675897e41 100644
--- a/lib/percpu_counter_tree.c
+++ b/lib/percpu_counter_tree.c
@@ -151,6 +151,7 @@
 #define pr_fmt(fmt) "percpu_counter_tree: " fmt
 
 #include <linux/percpu_counter_tree.h>
+#include <linux/moduleparam.h>
 #include <linux/align.h>
 #include <linux/cache.h>
 #include <linux/cpumask.h>
@@ -162,6 +163,7 @@
 #include <linux/math.h>
 #include <linux/log2.h>
 #include <linux/args.h>
+#include <linux/string.h>
 #include <kunit/visibility.h>
 
 #define MAX_NR_LEVELS 7
@@ -254,6 +256,8 @@ static_assert(ARRAY_SIZE(per_nr_cpu_order_config) == MAX_NR_CPUS_ORDER + 1);
 static struct {
 	/* Hierarchical counter configuration for the hardware topology. */
 	const struct counter_config *config;
+	/* Tree shape selected with the "arity" boot parameter. */
+	struct counter_config boot_config;
 	/* Order of nr_cpu_ids. */
 	unsigned int nr_cpus_order;
 	/*
@@ -272,6 +276,9 @@ static struct {
 	.nr_items = UINT_MAX,
 };
 
+/* Value of the "arity" boot parameter, parsed at subsystem initialization. */
+static const char *arity_param;
+
 /*
  * Size of the items of one tree position for the counters initialized
  * together by percpu_counter_tree_init_many(), packed in cache lines which
@@ -1326,7 +1333,10 @@ void percpu_counter_tree_copy_state(struct percpu_counter_tree *dst,
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
@@ -1339,9 +1349,78 @@ int format_shape(char *buf, size_t size, const struct counter_config *config)
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
@@ -1349,14 +1428,23 @@ int __init percpu_counter_tree_subsystem_init(void)
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
index d321c8363b0b..eaac72eab2d1 100644
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
index 1b86fea543e5..e263a932c30f 100644
--- a/tools/testing/hpcc/main.c
+++ b/tools/testing/hpcc/main.c
@@ -81,6 +81,27 @@ int scnprintf(char *buf, size_t size, const char *fmt, ...)
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
@@ -428,6 +449,58 @@ static int run_case(unsigned int nr_cpus, unsigned long batch_size)
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
@@ -455,12 +528,15 @@ int main(int argc, char **argv)
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


