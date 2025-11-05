Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E37EECCF9E3
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 02:43:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 507F38E000C; Tue,  4 Nov 2025 21:43:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B9208E0002; Tue,  4 Nov 2025 21:43:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CEA58E000C; Tue,  4 Nov 2025 21:43:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 310E08E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 21:43:12 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E87F5B363D
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 02:43:11 +0000 (UTC)
X-FDA: 84075006582.10.F1159BB
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1863B1C000A
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 02:43:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jSyo9SFU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762310590; a=rsa-sha256;
	cv=none;
	b=gpg70EiENrXAd86vUm80h14qwGd176My9+Z8kQ2xtl6o17s8Llp419SKAjMOvRhpoxG/+1
	pL1gQ0jO08gXg7a8Jtmk8p5LRJcNH8gq2IsWOZTQz2mbaO45AprgTDzsv77xoNFD4emPtb
	kwRLjaei2xkzPWBvNCaLihPQXU/eZL4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jSyo9SFU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762310590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vkc5Ewd2xrQK+NHTdzKpoLGQuxTK8qbsSefExMKhLTA=;
	b=sxec6ggzUbjQbCdC23YLkI+Etlzq3DlBXZZrIurh0BQgc61VrUcQJffHNKaC6jLxiGh3Kq
	zt2YnbbOoHQUppwk2mOLbahinr9dTzCB6AE3OcSF5OfaxHuWrLw/8LIzfD7yLotabYum6j
	Lyx3lucA+hxFHLg4x5n02qzhCrAPZmI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762310588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vkc5Ewd2xrQK+NHTdzKpoLGQuxTK8qbsSefExMKhLTA=;
	b=jSyo9SFUD8RonEN7d/d5aMXETvEB0rxgU3F4xZPrlqqgJy+CbwxU951cwrDLuIFmgAvnns
	MRK49sERNCV/0R24rCK0WTi0MF93ZpJBLgGZx+a4TlnTaILFy3/lgZtWt0Zy0ro10ZRhqV
	z+ubB1Nl9brFrw5TsinfoFia+d040cI=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	Geliang Tang <geliang@kernel.org>
Subject: [PATCH v4 2/2] mm/hugetlb: extract sysctl into hugetlb_sysctl.c
Date: Wed,  5 Nov 2025 10:42:44 +0800
Message-ID: <daeddee284f717704039f3db8bfbf92027167b51.1762310125.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1762310125.git.zhuhui@kylinos.cn>
References: <cover.1762310125.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1863B1C000A
X-Stat-Signature: 6fswafbk75dn47u6x7fae8fwhpw3mnj4
X-HE-Tag: 1762310589-118796
X-HE-Meta: U2FsdGVkX18yMiqf1CIr6nwzSimTacKjnERSxCRrPxT/3JtNMetUxRDjDtP/nXFdZpyFTZjUZC8Qzwp48cxYZsRmrKg15ISa1hIgj4yeFieZk0iCzvo3u3WyAp8OUmAHkpqChhjd6W4tZRL9c6L29xcMqhexNm2dZTFW0eDdR3ukqJuwQUWsy4y8VFAEI7Xzu1M6Lq3Qqd6yMC1a66HPEzvhovzVKtw1JnJl6oVRYNlUVUVLRU0LZ5kv3ZYXmIzDpvRXqDzlCoLf1Zn7OKwmiO62VgPCAhNmTxjSvoF+x8xvfrjvfEEotuakxo0ac8FnZ/Wo5B6PdL8l4MscP/DiLuq63iJ8RLLcUUOsL6yw2Nsb/o95ksEzdBkl5mqVmofdt3y5LXNwLwCgNL9w6/zajKQ+K9kHLrjz9rq0EvCPa1yjCQFJipYV2DEF5z5fY3rwpKTXYNa4pdT3+A5v8bjOMGDEcmkPBq7wE6wanLSNz/tPDb4dovwfcZLicg1tSXWN4//lGuM6GWMCCQWUF0+YudRExdWz4hBcVgsLOfHB7AueHn0bE1oIKFIkrJ0QNNSSgq7x8ALRx9C4wONL4DmxfdFsnFLUbl/iUkObHdrl4m0SftrU7c+z4lZjwfup2wOcN3CwwkifENVrju/66JGrWTChMtq8gKp23TC0LsPKxWeZ9yLQ80RF+7brPUEAxZRo8baEkz21yUwrmfYzWgaGCTxDV8xI69nuI4WlO1sSzX8dvzjWto/xCtMzS9nuwPxFObqeofSGltnzla3iGFZLjGTlJkVhEmdNQssQ71I44KtyKiP4D2ar95QOz1yQ0JV0x4jf2uqpSVXyslCOQ2inq/C46vhGsCePzH39mIRcBe19OAxcwpZiyZ1x87eZwOl4Jcw7e9WdMxpvl079FH5CJxVT6XLkk+NdP459Uwew2YJmLTvpt1Z1UWSvbx35vzdFPRJNkidVRjsLqyYaQfe
 zZ16dAS+
 qEOYlGWZonvGyEFirn3IXlcJBvm7IYgC4UcER0ALS55KR8VSmQlry8ysk+UZeWYSUosDeft8hW5pDTNPA2qpyaY0yeW6KHXDjSr0JC57BFmg2BRmX3GLw9QzG1uRE22BMFLuXhh4B+ZtuEeo7upzWYUM1roV4fYkJimCXemN1WMgrYlMj1ZVw1LMFpy6/Kz6TDxNQerInk246H7RqcjIqTmRhxH7BoDKGpps9uZ9RmM9FudOuxX4todaf1FRA/uqvbC9QPtZksWVzDUg=
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

MAINTAINERS is updated to add new file hugetlb_sysctl.c.

No functional changes are introduced; all code is moved as-is from
hugetlb.c with consistent formatting.

Signed-off-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 MAINTAINERS           |   1 +
 mm/Makefile           |   2 +-
 mm/hugetlb.c          | 132 -----------------------------------------
 mm/hugetlb_internal.h |   6 ++
 mm/hugetlb_sysctl.c   | 134 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 142 insertions(+), 133 deletions(-)
 create mode 100644 mm/hugetlb_sysctl.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 36d5e025ff68..fa21836c15ae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11539,6 +11539,7 @@ F:	mm/hugetlb.c
 F:	mm/hugetlb_cgroup.c
 F:	mm/hugetlb_cma.c
 F:	mm/hugetlb_cma.h
+F:	mm/hugetlb_sysctl.c
 F:	mm/hugetlb_sysfs.c
 F:	mm/hugetlb_vmemmap.c
 F:	mm/hugetlb_vmemmap.h
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
index cb4d4f86f7f9..a5c9061c6813 100644
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
index 5343448ed145..4a90fdadcd4c 100644
--- a/mm/hugetlb_internal.h
+++ b/mm/hugetlb_internal.h
@@ -105,4 +105,10 @@ extern ssize_t __nr_hugepages_store_common(bool obey_mempolicy,
 
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
index 000000000000..bd3077150542
--- /dev/null
+++ b/mm/hugetlb_sysctl.c
@@ -0,0 +1,134 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * HugeTLB sysfs interfaces.
+ * (C) Nadia Yvette Chambers, April 2004
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


