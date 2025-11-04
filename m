Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E65CCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 08:38:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CB068E00FD; Tue,  4 Nov 2025 03:38:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67B968E00E7; Tue,  4 Nov 2025 03:38:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56ACA8E00FD; Tue,  4 Nov 2025 03:38:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4529A8E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 03:38:11 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DF8B0C0115
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:38:10 +0000 (UTC)
X-FDA: 84072272340.30.B7CF03B
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id 106D91C000F
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:38:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MHl6TfRF;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762245489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRtVZ54NgaByJ1hpzJJgSPSChT5LIqbswrNem3/z+P0=;
	b=Msg3vniw6gitVnkDhEZPtW/Cb48HP4ZzTlXrup6QIIi6DUS9AYV45qd/7mA0s/GbMoLQmJ
	Szztd8I+im5ZOiNhIO8e+OdxtZ9vMB84hk+OfX0Qh/rM1k5GJSxrx/85Kr8GeF4cDRvLhb
	aJHCSG/2ITlG4cDS3LRIIblDdVFkONQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762245489; a=rsa-sha256;
	cv=none;
	b=fWNKRrqbl6U2ra8H/FUnOOc1xCP7VlW77MD0j2Hfixh1nWfR79rXBxda5/NAsZM7SoAJkX
	WxjuX7IV+2ZvHP9sdIUBXcx6a2q8l1wW3wRRNOH7APsE0UJWJKFMEByc8VMaF3j+WP7gBv
	ocKvw1OQi/34ekokCcz8/UU3UER0B+g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MHl6TfRF;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762245487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jRtVZ54NgaByJ1hpzJJgSPSChT5LIqbswrNem3/z+P0=;
	b=MHl6TfRFlA2ezL0+YUtlIYn/cXwg+3ly4L3W7al9/+N4KXEEVRiM28Y1WHAJMfSpFrLG0J
	fOT3sQtn6NI5ocwq9K0fL10+b7rKR5eBUGfeU283/1HPPGFEIBqHCip2kZokIhj/ZDLAAe
	RvdmfCpe6R0YMn3XyYhWfk7lvkMHT6I=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	Geliang Tang <geliang@kernel.org>
Subject: [PATCH v3 2/2] mm/hugetlb: extract sysctl into hugetlb_sysctl.c
Date: Tue,  4 Nov 2025 16:37:43 +0800
Message-ID: <8176f89d16f601ab460c9fb4c9c9af7dd9ef4a0e.1762245158.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1762245157.git.zhuhui@kylinos.cn>
References: <cover.1762245157.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 106D91C000F
X-Stat-Signature: 5fgz13whd3kq9ox5g44q3imhp3nda548
X-Rspam-User: 
X-HE-Tag: 1762245488-113710
X-HE-Meta: U2FsdGVkX19D9c2bGZDCVZvpuwDDKCl60m1BUdagLX48fzPdY5gz5vT7QpCJBGDUtk+b1PxxZjJ6Vu/3HobWDAR/0p0RJqJ6DapNJpaZE1KaeLvriu2ZBu4uxTx618QYFbFeW9VBJVeyvttbaGl+E+/b0p4YNR9gZpm3qvDF8a+CunRPSEo9TCYgMDbnYlhcnRdBeBIrwqICM6AdClF9aCsZfLoVkxQNRc1jLA9mySOJIHuNnR76zVL8Ag6U577prSV2uTTqY5Ltu7nKZ60wFi4aOgaY7/cpIc1xLaBnMhW95NvHpJbPINQqVW6DQmKuVW83taPzpNFFx2LdpXdb3Kx09YdMck1iEkTabxuXGRq8ps/1SPqOp3xicYVgfGEnmnH5E+8wgFAbpqWPpMGtsN9RhcPR4X7QLYjstwJb6bGJx+szPlMi52DKZCtlCicDtrZ4/swNDQvxJT/YE5gnZWdwOzyee+A5q+yxHHnfCobEi1Ls0liCf8g33F1vlv4Tq0Xre4rYPqOeJ/Dc1a/g0WsUWuiR5PiX0sMrSpxSkPrqjVhpNqiHYNpNlagR3ekCF4HkkXv4rW+kB7HbuC1J2n/YDS4+RETcCscGr/6EXYmU7KQWIB8A+tNXMg/d1Vzp815LOwnlRWxFY1qlSGj0RVYMFcKQASOhojl28zgIySzxxMpVUGPMRXlQMHNDHh4lVgqBHoZEBI7C3E1dcNzm6SUqeyvZ1+lD7R/YH++5MUEPLMrsUncatuw0arv5FdJhju/kO6bp9C3y2LuImtW4QwMbA91JLzzXYKs6aWqST4dESP5ghsn2r/DyUUUGw3gHHfH9qtTM5FcLo3bHAqi/11FVsDXEnfe6DgrZp1RFYTlcFOlvk/+yP5J9K6xyXijWMUkwpV/pml3MhYc/2GU4jf78RDWf39V9k/riSoAQY+ktSLflS6In3ZrtE7JE2YUL4lUsB1lIKfq7ukaQExp
 kUO6JEkQ
 Qq2ZdL15evpSFUGH1O3Mec79MY0Xv9jNtN2hbi0yTdseOK5U1a6gYVtp/jrHjQkjRb+sOwDfeRU8uPqRfP3DfchPVRC4lB1ZLjr7a8eWErdekLOxc3YFDEy9ywcz65a3bDRjTy2fwTMlvWYS7hiq5T6Y/7D4JN72rY9MBGzeF5rRi8h8dzCOYeo4sUX5T/41QZA8AF5TO4pWApBDUpGx+bqQyTGpTcTZrsPLD7iZtqccgYXhXs4NLAomNZyMQ10/90M5dmfOh5QQPiGI=
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
 mm/hugetlb_sysctl.c   | 133 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 141 insertions(+), 133 deletions(-)
 create mode 100644 mm/hugetlb_sysctl.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 1232eaf3dafe..a062cb3cb4cb 100644
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
index 03934bfe29ce..45620cc6c97d 100644
--- a/mm/hugetlb_internal.h
+++ b/mm/hugetlb_internal.h
@@ -104,4 +104,10 @@ extern ssize_t __nr_hugepages_store_common(bool obey_mempolicy,
 
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


