Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24D9ECCF9F8
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 02:38:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 770DE8E0058; Mon,  3 Nov 2025 21:38:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 747CD8E00DC; Mon,  3 Nov 2025 21:38:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65BBE8E0058; Mon,  3 Nov 2025 21:38:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4FD598E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 21:38:57 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 020FF86FF5
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:38:56 +0000 (UTC)
X-FDA: 84071367114.30.47DB3CB
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id 72F2780003
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:38:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gmect3fU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762223935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=df4S7Pov33oelXc5qG3OuAE7jT7hLdKeSl/8gItGAHE=;
	b=tbvGbSyoeCx09qSe0nVaB5FbD5T+i7EwrDI2N7cyLJwv5y21PxfT47/q4S6QOo37HeuJvG
	7VkTBDnxDQDbh9Z1gy0coWz+jFw1FhIsHkuw6zCshXd+qCtg2ltpFl1jHtXMdGg4wisoPR
	cdBdA2aF4mNtQzpYAArWmVm9k3FkBcY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762223935; a=rsa-sha256;
	cv=none;
	b=Yrw2KnMCxdP0F6bLnSA9Wfyh1ujcSU2j9LOyyku5q5i4FoPWf5RPCF976Yf8z7vmS2qiCy
	UPcriMDZACz1eVcaQmJLXXaJSgRSw19O33nRS5LHqP4QRSop/EmHxiX15K+T//ElIN4jAT
	2orfkuOtz3BJ1D6lqI/bXMpq7gD63RI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gmect3fU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762223933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=df4S7Pov33oelXc5qG3OuAE7jT7hLdKeSl/8gItGAHE=;
	b=gmect3fUQDka4qo9pGxSSVnG//H7bHZ/WwTFVs9+NQOJcSDizbUv8llA6IW7nWrz133s1f
	K5xVCm2Habr1jZJC7Kt8XchR/8U00w0sWNOu8UCY07p5IbuTqcZ8pB0dPScpo3QmwylqSI
	VWaSexo6FXcDL3Z7udYtlHquWvXKomk=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	Geliang Tang <geliang@kernel.org>
Subject: [PATCH v2 2/2] mm/hugetlb: extract sysctl into hugetlb_sysctl.c
Date: Tue,  4 Nov 2025 10:38:33 +0800
Message-ID: <51ab8a485c9b299e36384c2c5741d9cb6b9ebd75.1762221536.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1762221536.git.zhuhui@kylinos.cn>
References: <cover.1762221536.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: fb5bqt1ew7crkg9nr6qu47qy51ddhxar
X-Rspam-User: 
X-Rspamd-Queue-Id: 72F2780003
X-Rspamd-Server: rspam10
X-HE-Tag: 1762223935-496604
X-HE-Meta: U2FsdGVkX1+pQZQs8mD0yDNB0sHzcQNUNAvsaWjUyYqskCCI+o977XqrECU00orO5/0TI2wKAk0dn+o3A+giMIIO/JNicNI/4j15G/ikS7wMqASLRTDsPkMh4E7rQQ6GuYvPozlDqn4Dzyd3jtnwu9SNV/78XWqUeGhdo60UsWFLFSmy1Y4UOS2xGHBeoXCy22cMX1WjhMZDbbBsaI7HU6N74erCvZTEis5/l5lQFr4yeETxzzgHT1j86ZXUBDeSxqbXrHPsZrsqmoDYU6EP2+L30rGBBWYAy3f8xJhqP1E+IsHwCJ4ZzFvXhirCTLC7uTkaTKvMjhsWc1emYvAHftC7+XhR37BVTKl7hs11GALeo0ojHBMnUPJZZfRXjVE0d1tVRA+QtgzdgVKL8/hdDw1IdO88VuTqgTRXpUt/HZ3tLaXYNiA+smdcpZx1nUulR93o20q4/YCCMhvxw9IiaNO2Lb3aLL3LJIYCbSbXf0JRWORn7vbDfVD2OQyTnkwcMG3aJw/Rt4QpjucrWRAeOEZFiLZv/4iB1nHCYtN3m/kDbh8ebYvCSjB8wMfOEP8FtcsEzKO00RZc/yOgnFc82XWvZsozmh9GhyxmwX1ft0gMssT70G+30lqYAE39+2elYI9MJmIoPvtzZE8laPK9iqckPchMMCgrIDImnLl2Q2nLRW9cf2OPrKoLOvLGdPd9gHScUSd1bFnxyt55LkxIOboRdhMdlfttyhyXUy5YcPCneExGQakNN6n1x7AXXk427c4eeOeMn1YOTIj0DZ+r87ROBXiDjjb9b9by9EocjBqzveLaGnhe+S4nh25y7yM3NA2qV6bRodBQ4Rpqk/RBL7hBmkUyBOwAiiXnGJwRwGYJmFUmj1DXxPXe7A1JCJG9SrZsbuIFZGlXhe9Dx0/Sxr7+ZxmMiygL8WLE1yXHGYKOfBBwnhEYISJ6PaqrpWVe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Following the extraction of sysfs code, this patch moves the sysctl
interface implementation into a dedicated file to further improve code
organization and maintainability of the hugetlb subsystem.

The following components are moved to mm/hugetlb_sysctl.c:
- proc_hugetlb_doulongvec_minmax()
- hugetlb_sysctl_handler_common()
- hugetlb_sysctl_handler()
- hugetlb_mempolicy_sysctl_handler() (CONFIG_NUMA)
- hugetlb_overcommit_handler()
- hugetlb_table[] sysctl table definition
- hugetlb_sysctl_init()

The hugetlb_internal.h header file is updated to declare the sysctl
initialization function with proper #ifdef guards for configurations
without CONFIG_SYSCTL support.

The Makefile is updated to compile hugetlb_sysctl.o when CONFIG_HUGETLBFS
is enabled. This refactoring reduces the size of hugetlb.c and logically
separates the sysctl interface from core hugetlb management code.

No functional changes are introduced; all code is moved as-is from
hugetlb.c with consistent formatting.

Signed-off-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/Makefile           |   2 +-
 mm/hugetlb.c          | 132 -----------------------------------------
 mm/hugetlb_internal.h |   6 ++
 mm/hugetlb_sysctl.c   | 133 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 140 insertions(+), 133 deletions(-)
 create mode 100644 mm/hugetlb_sysctl.c

diff --git a/mm/Makefile b/mm/Makefile
index b9edfce6c202..00ceb2418b64 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -78,7 +78,7 @@ endif
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o
 obj-$(CONFIG_ZSWAP)	+= zswap.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
-obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o hugetlb_sysfs.o
+obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o hugetlb_sysfs.o hugetlb_sysctl.o
 ifdef CONFIG_CMA
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb_cma.o
 endif
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1fc24f7e63ac..ee2df563550e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7,7 +7,6 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/seq_file.h>
-#include <linux/sysctl.h>
 #include <linux/highmem.h>
 #include <linux/mmu_notifier.h>
 #include <linux/nodemask.h>
@@ -3983,12 +3982,6 @@ ssize_t __nr_hugepages_store_common(bool obey_mempolicy,
 	return err ? err : len;
 }
 
-#ifdef CONFIG_SYSCTL
-static void hugetlb_sysctl_init(void);
-#else
-static inline void hugetlb_sysctl_init(void) { }
-#endif
-
 static int __init hugetlb_init(void)
 {
 	int i;
@@ -4421,131 +4414,6 @@ static unsigned int allowed_mems_nr(struct hstate *h)
 	return nr;
 }
 
-#ifdef CONFIG_SYSCTL
-static int proc_hugetlb_doulongvec_minmax(const struct ctl_table *table, int write,
-					  void *buffer, size_t *length,
-					  loff_t *ppos, unsigned long *out)
-{
-	struct ctl_table dup_table;
-
-	/*
-	 * In order to avoid races with __do_proc_doulongvec_minmax(), we
-	 * can duplicate the @table and alter the duplicate of it.
-	 */
-	dup_table = *table;
-	dup_table.data = out;
-
-	return proc_doulongvec_minmax(&dup_table, write, buffer, length, ppos);
-}
-
-static int hugetlb_sysctl_handler_common(bool obey_mempolicy,
-			 const struct ctl_table *table, int write,
-			 void *buffer, size_t *length, loff_t *ppos)
-{
-	struct hstate *h = &default_hstate;
-	unsigned long tmp = h->max_huge_pages;
-	int ret;
-
-	if (!hugepages_supported())
-		return -EOPNOTSUPP;
-
-	ret = proc_hugetlb_doulongvec_minmax(table, write, buffer, length, ppos,
-					     &tmp);
-	if (ret)
-		goto out;
-
-	if (write)
-		ret = __nr_hugepages_store_common(obey_mempolicy, h,
-						  NUMA_NO_NODE, tmp, *length);
-out:
-	return ret;
-}
-
-static int hugetlb_sysctl_handler(const struct ctl_table *table, int write,
-			  void *buffer, size_t *length, loff_t *ppos)
-{
-
-	return hugetlb_sysctl_handler_common(false, table, write,
-							buffer, length, ppos);
-}
-
-#ifdef CONFIG_NUMA
-static int hugetlb_mempolicy_sysctl_handler(const struct ctl_table *table, int write,
-			  void *buffer, size_t *length, loff_t *ppos)
-{
-	return hugetlb_sysctl_handler_common(true, table, write,
-							buffer, length, ppos);
-}
-#endif /* CONFIG_NUMA */
-
-static int hugetlb_overcommit_handler(const struct ctl_table *table, int write,
-		void *buffer, size_t *length, loff_t *ppos)
-{
-	struct hstate *h = &default_hstate;
-	unsigned long tmp;
-	int ret;
-
-	if (!hugepages_supported())
-		return -EOPNOTSUPP;
-
-	tmp = h->nr_overcommit_huge_pages;
-
-	if (write && hstate_is_gigantic_no_runtime(h))
-		return -EINVAL;
-
-	ret = proc_hugetlb_doulongvec_minmax(table, write, buffer, length, ppos,
-					     &tmp);
-	if (ret)
-		goto out;
-
-	if (write) {
-		spin_lock_irq(&hugetlb_lock);
-		h->nr_overcommit_huge_pages = tmp;
-		spin_unlock_irq(&hugetlb_lock);
-	}
-out:
-	return ret;
-}
-
-static const struct ctl_table hugetlb_table[] = {
-	{
-		.procname	= "nr_hugepages",
-		.data		= NULL,
-		.maxlen		= sizeof(unsigned long),
-		.mode		= 0644,
-		.proc_handler	= hugetlb_sysctl_handler,
-	},
-#ifdef CONFIG_NUMA
-	{
-		.procname       = "nr_hugepages_mempolicy",
-		.data           = NULL,
-		.maxlen         = sizeof(unsigned long),
-		.mode           = 0644,
-		.proc_handler   = &hugetlb_mempolicy_sysctl_handler,
-	},
-#endif
-	{
-		.procname	= "hugetlb_shm_group",
-		.data		= &sysctl_hugetlb_shm_group,
-		.maxlen		= sizeof(gid_t),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "nr_overcommit_hugepages",
-		.data		= NULL,
-		.maxlen		= sizeof(unsigned long),
-		.mode		= 0644,
-		.proc_handler	= hugetlb_overcommit_handler,
-	},
-};
-
-static void __init hugetlb_sysctl_init(void)
-{
-	register_sysctl_init("vm", hugetlb_table);
-}
-#endif /* CONFIG_SYSCTL */
-
 void hugetlb_report_meminfo(struct seq_file *m)
 {
 	struct hstate *h;
diff --git a/mm/hugetlb_internal.h b/mm/hugetlb_internal.h
index 63ab13cfb072..8c303d666fd8 100644
--- a/mm/hugetlb_internal.h
+++ b/mm/hugetlb_internal.h
@@ -107,4 +107,10 @@ extern ssize_t __nr_hugepages_store_common(bool obey_mempolicy,
 
 extern void hugetlb_sysfs_init(void) __init;
 
+#ifdef CONFIG_SYSCTL
+extern void hugetlb_sysctl_init(void);
+#else
+static inline void hugetlb_sysctl_init(void) { }
+#endif
+
 #endif /* _LINUX_HUGETLB_INTERNAL_H */
diff --git a/mm/hugetlb_sysctl.c b/mm/hugetlb_sysctl.c
new file mode 100644
index 000000000000..590798376612
--- /dev/null
+++ b/mm/hugetlb_sysctl.c
@@ -0,0 +1,133 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * HugeTLB sysfs interfaces.
+ */
+
+#include <linux/sysctl.h>
+
+#include "hugetlb_internal.h"
+
+#ifdef CONFIG_SYSCTL
+static int proc_hugetlb_doulongvec_minmax(const struct ctl_table *table, int write,
+					  void *buffer, size_t *length,
+					  loff_t *ppos, unsigned long *out)
+{
+	struct ctl_table dup_table;
+
+	/*
+	 * In order to avoid races with __do_proc_doulongvec_minmax(), we
+	 * can duplicate the @table and alter the duplicate of it.
+	 */
+	dup_table = *table;
+	dup_table.data = out;
+
+	return proc_doulongvec_minmax(&dup_table, write, buffer, length, ppos);
+}
+
+static int hugetlb_sysctl_handler_common(bool obey_mempolicy,
+			 const struct ctl_table *table, int write,
+			 void *buffer, size_t *length, loff_t *ppos)
+{
+	struct hstate *h = &default_hstate;
+	unsigned long tmp = h->max_huge_pages;
+	int ret;
+
+	if (!hugepages_supported())
+		return -EOPNOTSUPP;
+
+	ret = proc_hugetlb_doulongvec_minmax(table, write, buffer, length, ppos,
+					     &tmp);
+	if (ret)
+		goto out;
+
+	if (write)
+		ret = __nr_hugepages_store_common(obey_mempolicy, h,
+						  NUMA_NO_NODE, tmp, *length);
+out:
+	return ret;
+}
+
+static int hugetlb_sysctl_handler(const struct ctl_table *table, int write,
+			  void *buffer, size_t *length, loff_t *ppos)
+{
+
+	return hugetlb_sysctl_handler_common(false, table, write,
+							buffer, length, ppos);
+}
+
+#ifdef CONFIG_NUMA
+static int hugetlb_mempolicy_sysctl_handler(const struct ctl_table *table, int write,
+			  void *buffer, size_t *length, loff_t *ppos)
+{
+	return hugetlb_sysctl_handler_common(true, table, write,
+							buffer, length, ppos);
+}
+#endif /* CONFIG_NUMA */
+
+static int hugetlb_overcommit_handler(const struct ctl_table *table, int write,
+		void *buffer, size_t *length, loff_t *ppos)
+{
+	struct hstate *h = &default_hstate;
+	unsigned long tmp;
+	int ret;
+
+	if (!hugepages_supported())
+		return -EOPNOTSUPP;
+
+	tmp = h->nr_overcommit_huge_pages;
+
+	if (write && hstate_is_gigantic_no_runtime(h))
+		return -EINVAL;
+
+	ret = proc_hugetlb_doulongvec_minmax(table, write, buffer, length, ppos,
+					     &tmp);
+	if (ret)
+		goto out;
+
+	if (write) {
+		spin_lock_irq(&hugetlb_lock);
+		h->nr_overcommit_huge_pages = tmp;
+		spin_unlock_irq(&hugetlb_lock);
+	}
+out:
+	return ret;
+}
+
+static const struct ctl_table hugetlb_table[] = {
+	{
+		.procname	= "nr_hugepages",
+		.data		= NULL,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= hugetlb_sysctl_handler,
+	},
+#ifdef CONFIG_NUMA
+	{
+		.procname       = "nr_hugepages_mempolicy",
+		.data           = NULL,
+		.maxlen         = sizeof(unsigned long),
+		.mode           = 0644,
+		.proc_handler   = &hugetlb_mempolicy_sysctl_handler,
+	},
+#endif
+	{
+		.procname	= "hugetlb_shm_group",
+		.data		= &sysctl_hugetlb_shm_group,
+		.maxlen		= sizeof(gid_t),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "nr_overcommit_hugepages",
+		.data		= NULL,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= hugetlb_overcommit_handler,
+	},
+};
+
+void __init hugetlb_sysctl_init(void)
+{
+	register_sysctl_init("vm", hugetlb_table);
+}
+#endif /* CONFIG_SYSCTL */
-- 
2.43.0


