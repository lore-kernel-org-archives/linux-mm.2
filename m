Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D92E4606A32E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Es9ITffG
Received: by kanga.kvack.org (Postfix)
	id EE0A56B05DB; Fri, 13 Nov 2026 16:36:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E90356B05DC; Fri, 13 Nov 2026 16:36:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D59326B05DD; Fri, 13 Nov 2026 16:36:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACC496B05DB
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:36:38 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3DE071C27EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:36:38 +0000 (UTC)
X-FDA: 85431405276.09.24DE36D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6BB7D80009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:36:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Es9ITffG;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794605796;
	b=oU8k2XKEh0To4DgnPzA1aZMRbGUdI158bA7Qw34L6hOpfKSPjbpxVrOqW3a30g+Y7Xt1yE
	8zGlz6V8PYex1DqGDkkyRLgVJNV0ZC1fQH1ne1FzoO7pAEDPzmd6B7eXt+Yhtf5DFMPjU1
	ToWxT067RTLuZllX7BS/+WTmUV2oCFc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Es9ITffG;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794605796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gPnwUEYSLzTZbVkXhySPm5pvIGF62+NCNEQU3h43Vfs=;
	b=BfghtcP8oRIr8kWk6P0RvBNQRrcR+RYVoWJgEuVd6+3mQL4QUKqVUZ5xhRekY9IArBfWrR
	eFJxW3cw2nk9f5XU51wJ5/w5jYxpEdiTB2ZBYPjChuJX3CddwsARgapoK1fQQq7z5bjRfD
	XhupsN+pWpwu+ud85HAaIebveHlFTws=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA0CE43580;
	Fri, 13 Nov 2026 21:36:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D687C1F000C4;
	Fri, 13 Nov 2026 21:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794605795;
	bh=gPnwUEYSLzTZbVkXhySPm5pvIGF62+NCNEQU3h43Vfs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Es9ITffGVAtood3TqPcxQb1Vt3coZJAUP7xQjoHCBAEfyAThAoU0esJYGe47Jb8lx
	 tAhr/oVOul1Hf6Gmf4ODeEYDIF3S1NyQP6SMomSmSGLMiEyZvW2hLAmO37IQRfj1fo
	 vUdmwrF3zE+lDdWBHX59HlHjVfkN8SZDNBZ8d3/bySQJ8m4vrTZim1fkIrAhv4Go8J
	 vmZ8HgDsThTDePpMqBj0Bsx5U8GvejEJ/LxReRNdJHxxrrtbaMy24Tjsm0oYszvyHT
	 Qa5QwI2NDCDywZzOH5DkLnbhgvhhdmurooxo5uaCpHLjeuUZ69010Zs2aWkkj+jo6C
	 +thSbPlFDdcBA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 13 Nov 2026 22:36:13 +0100
Subject: [PATCH 2/2] mm/mempolicy: limit shared policy ranges per inode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-mempolicy_limit-v1-2-16688b2644dc@kernel.org>
References: <20261113-mempolicy_limit-v1-0-16688b2644dc@kernel.org>
In-Reply-To: <20261113-mempolicy_limit-v1-0-16688b2644dc@kernel.org>
To: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6032; i=david@kernel.org;
 h=from:subject:message-id; bh=VjKpybYOrwS3f0sP0BeGTTuXV1Yff60dPS1hB88MhLw=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLK+N13YsvDL674K780d32W+yIv/dE38qfWT82bVHZkQo
 xDe6g9rO0pZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZiInSsjwyfJys8f5DS+Pe1d
 Yug8d7FjHKfW9v0eFhvvHzl5JjRgvwUjw7Lj7MdN9H8eMi1aH/Lk0bszX4Lb/zavXMpVcnXHOg+
 Tj3wA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: gsuper9jxgp3ig978ekndpfnhzphde9a
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6BB7D80009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794605796-851490
X-HE-Meta: U2FsdGVkX19zN83IGCsaWCnRPWAKvMF8Myr+BxfHBVcepx4Ugu+FGL2V/k7Z0iQPgyqvhg4PS2RqS+7QHWhoz3yXZsD2Kwbuc4uzfiq0iXO/ff3i9+5Oj8T1FFsIHb5hNrwTqjfP1pBS1BaUzckxiRLVfFOqTMzmfqYM6o7BQMUno1Ye54BR5/IPo7JFGtH8j6Eb/lzIuu6fsZ21v8YHE/mR4O2V6q/vQEl4RSgsFmlY8xNbOQdwmDxV0EWTdM+PL1vD6vPzgJVT2ChoxqqaACyvJUOr0pZ/xljt+sE/rKsxKvN21PfkTdCC4k1d5Jmrx/lYO6UzZYlQ56G6fsQIJPxzr89hL6HXpsegwG2FmnYIc1c5Wf5QuemaKbKlCSSnUEWi9Rod97n/S5GmUBCpRe/fHfjq+KLV29AVM4OMHJj5glQuC8vb+6Wd7hK8fy0Qrav4zxBr1ENcOjHf+HnADlyZJgM5xM7rT5JEgXp3DoyEIdZe4EUSWmCSlJhRtkU6xFd86grBeYBFq4O0UUcje5AFcV9rmqAqwBIni4tpuncF5h/42JSBTjerFFQhR0sExL4HXBVEj+g1xHttTu+wTvcH309gbwFjashjW3VPVeK6hkDqYP8lxF4gzmqv/8ErRokwm8yu+UpaHKWHginAPSaDTQ8xRw33PUCCiT7w7A6R6YkrVMXL+1SGYChxBRDW3VqEQ41eRQDvK6F/viK5IqwUaD7r2Kl2LQD+QZliL1vFF1iTY82G83VYVJiGap4gpAhIOjUUqGi1Df2j8YjgWxgRk5a1zZKN5qhAcE1ujqXEkfipUUjtbvqGC+hhxqQtf1sW45zHQQB47JVjtzLAHk4gcE8yv9IvDh3R4cayBI8bU3USfi6IZcuHsEUQXQtoRN38KdzW2yQ7clfOtRVOxGKo52vzk52VCKL6pi09/uoJ/Up5ZCOOCkUBgF6qatcWUoD/Q7TfreVDmk+Ml4n
 si+EG6rq
 waW5/12+qqbopA3C4DZSQsb/BLuhR61HMlI7yufqnd8itLXVyPnYEl0UxRcgWEiDtEHY0SCvYz3eIwQjcb+I88zuIpIFCgxsvi6QT3osUnz6vCTZyyu9YIbKd6uUEkqM2x//aXCdqc48Odgm98CfwiCvVcAJaoLd1W3DHV9lB72Nv3JsmvfDZyQX5PgvmqMWIQhLnl1F2XLrrA8TKs6xVCgnYZClanhYvk8EtB87EdZQA0Yqw5cRWljBjScKgTCeB8bvNVq2rbsFGHUkpFpRuCMo9pNQjAnQZkv+0cJw4POm4WPa0NEmFPNOBxUNBuAmoZyjI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Shared NUMA policy ranges can accumulate on an inode after its mappings
are removed. Currently, these nodes are effectively unbounded (even though
the allcoations are charged).

An unbounded tree can cause long rwlock hold times when replacing or
freeing policies. Instead of trying to fix that, it sounds more like
having many nodes is actually only a scenario for processes trying to
cause trouble. Most use cases will probably only use a handful of them,
not millions.

Add vm.max_shared_policy_count (inspired by vm.max_map_count), defaulting
to 1024 ranges per inode. Reject updates with -ENOMEM if they would
increase the count beyond the limit, taking merging, splitting etc.
into account.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 Documentation/admin-guide/sysctl/vm.rst | 18 +++++++++++
 include/linux/mempolicy.h               |  1 +
 mm/mempolicy.c                          | 57 +++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 3cb0138e850c1..8ef63d933821b 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -41,6 +41,7 @@ Currently, these files are in /proc/sys/vm:
 - legacy_va_layout
 - lowmem_reserve_ratio
 - max_map_count
+- max_shared_policy_count
 - mem_profiling         (only if CONFIG_MEM_ALLOC_PROFILING=y)
 - memory_failure_early_kill
 - memory_failure_recovery
@@ -473,6 +474,23 @@ e.g., up to one or two maps per allocation.
 The default value is 65530.
 
 
+max_shared_policy_count
+=======================
+
+The maximum number of shared NUMA policy ranges stored on a single inode.
+This applies to tmpfs files, shared anonymous mappings, shmem-backed memfds
+and System V shared memory segments, and guest_memfds. The policies are
+shared by all mappings of the same inode and remain after all mappings are
+removed.
+
+An update that would increase the number of ranges beyond this limit fails
+with -ENOMEM; this includes splitting of existing ranges. Lowering the
+limit will not remove existing policies. Updates that preserve or reduce
+the count remain allowed even if it exceeds the limit.
+
+The default value is 1024. The minimum value is 1.
+
+
 mem_profiling
 ==============
 
diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index cd8f944209ca4..828e7de6dee73 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -113,6 +113,7 @@ static inline bool mpol_equal(struct mempolicy *a, struct mempolicy *b)
 struct shared_policy {
 	struct rb_root root;
 	rwlock_t lock;
+	unsigned int nr_nodes;
 };
 struct sp_node {
 	struct rb_node nd;
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 183bc3bd077cd..a54c6423faeaa 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -106,6 +106,7 @@
 #include <linux/rmap.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
+#include <linux/sysctl.h>
 #include <linux/ctype.h>
 #include <linux/mm_inline.h>
 #include <linux/mmu_notifier.h>
@@ -130,6 +131,28 @@
 static struct kmem_cache *policy_cache;
 static struct kmem_cache *sn_cache;
 
+static int sysctl_max_shared_policy_count __read_mostly = 1024;
+
+#ifdef CONFIG_SYSCTL
+static const struct ctl_table mempolicy_sysctls[] = {
+	{
+		.procname	= "max_shared_policy_count",
+		.data		= &sysctl_max_shared_policy_count,
+		.maxlen		= sizeof(sysctl_max_shared_policy_count),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ONE,
+	},
+};
+
+static int __init mempolicy_sysctl_init(void)
+{
+	register_sysctl_init("vm", mempolicy_sysctls);
+	return 0;
+}
+subsys_initcall(mempolicy_sysctl_init);
+#endif
+
 /* Highest zone. An specific allocation for a zone below that is not
    policied. */
 enum zone_type policy_zone = 0;
@@ -3006,6 +3029,7 @@ static void sp_insert(struct shared_policy *sp, struct sp_node *new)
 	}
 	rb_link_node(&new->nd, parent, p);
 	rb_insert_color(&new->nd, &sp->root);
+	sp->nr_nodes++;
 }
 
 /* Find shared policy intersecting idx */
@@ -3165,6 +3189,7 @@ void mpol_put_task_policy(struct task_struct *task)
 static void sp_delete(struct shared_policy *sp, struct sp_node *n)
 {
 	rb_erase(&n->nd, &sp->root);
+	sp->nr_nodes--;
 	sp_free(n);
 }
 
@@ -3197,6 +3222,30 @@ static struct sp_node *sp_alloc(unsigned long start, unsigned long end,
 	return n;
 }
 
+static int sp_check_node_limit(struct shared_policy *sp, struct sp_node *n,
+			       pgoff_t start, pgoff_t end, bool new)
+{
+	unsigned long new_nodes = new ? 1 : 0;
+
+	if (n && n->start < start) {
+		/*
+		 * Splitting adds one node for the old policy. Otherwise,
+		 * check the successor.
+		 */
+		if (n->end > end)
+			new_nodes++;
+		else
+			n = rb_entry_safe(rb_next(&n->nd), struct sp_node, nd);
+	}
+	/* Without a new node, or with a whole node removed, the count cannot grow. */
+	if (!new_nodes || (n && n->end <= end))
+		return 0;
+
+	if (sp->nr_nodes + new_nodes > READ_ONCE(sysctl_max_shared_policy_count))
+		return -ENOMEM;
+	return 0;
+}
+
 /* Replace a policy range. */
 static int shared_policy_replace(struct shared_policy *sp, pgoff_t start,
 				 pgoff_t end, struct sp_node *new)
@@ -3226,6 +3275,13 @@ static int shared_policy_replace(struct shared_policy *sp, pgoff_t start,
 		}
 	}
 	n = sp_lookup(sp, start, end);
+
+	ret = sp_check_node_limit(sp, n, start, end, new);
+	if (ret) {
+		write_unlock(&sp->lock);
+		goto err_out;
+	}
+
 	/* Take care of old policies in the same range. */
 	while (n && n->start < end) {
 		struct rb_node *next = rb_next(&n->nd);
@@ -3297,6 +3353,7 @@ void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol)
 
 	sp->root = RB_ROOT;		/* empty tree == default mempolicy */
 	rwlock_init(&sp->lock);
+	sp->nr_nodes = 0;
 
 	if (mpol) {
 		struct sp_node *sn;

-- 
2.43.0


