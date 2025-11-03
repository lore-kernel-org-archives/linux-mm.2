Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AD91CCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 08:22:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4D8D8E003F; Mon,  3 Nov 2025 03:22:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD68F8E002A; Mon,  3 Nov 2025 03:22:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9ED18E003F; Mon,  3 Nov 2025 03:22:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B916D8E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 03:22:43 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4D4D3B904A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:22:43 +0000 (UTC)
X-FDA: 84068604606.06.CD50E67
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id 873D74000E
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:22:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b4usn0Tz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762158161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qAgJmmX9kqSQOQCJBNLih34NjSmmsMEQFF7uxUU1bQM=;
	b=EccPapathPkxeWr8gR+3YZMYFTDSssRm5X1XRVeOVF6L5fbWGgLMNtPxK2LhhHAhRsVeQ5
	aUi4702nENj6SeVXwH7j3LRPd/dANjk+7c+96NYr14qXpYvjzcZhtNkEfaMAwSHXAxJgon
	GfFhT45Ve1ZKJkiT/nKYF3wa6AtVVQc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762158161; a=rsa-sha256;
	cv=none;
	b=jH+oJ318xpxq1E6ETe9q7aecbbDXmUKdwFsnoAIsghspF0vnaZn3RPaShaisc5PoE9/d+l
	TATunCFnTJ0Wuj6BhHyCfc2RkbouX6B+Edrj1PwaD48GlF7Aqs763uBqUmfGUcknX6q7ty
	LXQYkcE3tPm/Hgvyjkd03tiEPrhU90U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b4usn0Tz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762158160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qAgJmmX9kqSQOQCJBNLih34NjSmmsMEQFF7uxUU1bQM=;
	b=b4usn0TzAMr90gWDWe7P0Xyp5L/Whs+TIye0e4Ii/G/UFW/5x7unHs411+bFq61eYmG30X
	bG7asdlbKxrgge/TJHKHc+mzf2T+Pahn3TEx8KDFjBnu7TdsiSwO1XZL0XQE2Q3HeIauab
	4JdnGU7SO4hgMikKkfaWT9oIzsRaenE=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	Geliang Tang <geliang@kernel.org>
Subject: [PATCH 2/2] mm/hugetlb: extract sysctl into hugetlb_sysctl.c
Date: Mon,  3 Nov 2025 16:22:09 +0800
Message-ID: <5bc739c804e0dbdae66d5b0fb9dd802515c250db.1762156954.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1762156954.git.zhuhui@kylinos.cn>
References: <cover.1762156954.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: d1mywosuiaxyrzy99u31c4owmko375cp
X-Rspam-User: 
X-Rspamd-Queue-Id: 873D74000E
X-HE-Tag: 1762158161-85527
X-HE-Meta: U2FsdGVkX186l/oD734H5+yPUrgd0MlMl7OHj3++c07SAMgPeIKETESRqm3Lmdbtt4HGGS7wSZzS1rCEe13kqUW99ta5VSsTfLCP8jHzt6b/pbk++9rtA6+dndv11gIjHbohbfSPlyftOZodns3gTDDVsknrqXpoCdKWGc5ZWtySk8/5FpSx3Sy5tl9nsPkhFdrH2d+M6gCCXCFm+UIbqUPoxeNlPzkwejJSr5r5jCC/ziHIhEPCzbJDGv70MyeJ7+FUHT4tksNNsQGlKlYAyw4NaE3QrArg0QTg9tzSC+21aDaFMbOQIQwVzzhmHZlDTfCgdjz2088wp/5D2xNR7API0MmtBi920LwzM7d//6LviQMtWX2JGV1IcK9WyfGMBDXgtOpzcjiZrAQl43Fq8Hk/sWtDtOSgrq+dZrMlOR8kT6tGit/GLmIHCzmhGOKpoywQepJaamh7sbXra4pF0MlR3bM6Cg3uVf6DGZfvUiys4RRBwqMFJw/QRWb4/W9iEdwjuC0SXKq4GRl0KYi7UJRKnJIL/kFxO+QlB5UilIvrw2oFygq0edQr7OAGeocvONuRvQKkQUiiNv3oAxB0LZMMxyFLavH3A+ZE9rm+Dd+jasF1IpFPfj5CL60hUAFS6y637eqBGdA+kDSDnDMgOahm2MIC8uPSCy/iHKpQzUPOlVRPIaYWuxBs74fiHH2JcgBmJVTCv1mNWCKenChvEWX/8BBsr0fCG4KosygQIGbGVUZkX+CGhfIYDi48hVNt+drcaxrz++zHsPd8xsWMc61gfh77Pxkq45Q/4lHYhd16Kj79/Cc8ya0V71nBtIqmw3C5d0oclVFk6Mue3lDeljrOEwax6A+c2dxW90ugLMloomrO1PMp+ORvf6ivjmcQxE3PUyEfGyaWN6XCjvXZsJGpzH/TbHKmhCZW4XBr1I+nqVeKsxdHHo2pSHQ9XAgsYTNFGBcap1rmc3h/9r/
 X8CRe7uf
 0cbksy62ZfEkqPdbhTaySZwsy7x79QkDOWaGHULX9DdhcxgW5DGg/Y80C/45mzT6RBTH+5mP9Y299MDsrcDamcH/QmIJC+O0HGgsVRszKvIgdEgvHmgXgbG2L6QP3WEOmKAcH1gi+BL0TcXJoH2Nm6lvwBiDciTrnj5CrPPjcZ3Gn+wm0wBtNrLT8UJzpgnmgdQ+mL0vvx4N3CGJziZvY5VypZMuyf7IGc434
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
 mm/hugetlb.c          | 132 ----------------------------------------
 mm/hugetlb_internal.h |   6 ++
 mm/hugetlb_sysctl.c   | 136 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 143 insertions(+), 133 deletions(-)
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
index 000000000000..53443bb4f0bc
--- /dev/null
+++ b/mm/hugetlb_sysctl.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * HugeTLB sysfs interfaces.
+ *
+ * Copyright (C) 2025 KylinSoft Corporation.
+ * Author: Hui Zhu <zhuhui@kylinos.cn>
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


