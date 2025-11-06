Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00E0FCCFA0D
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 03:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58C478E000C; Wed,  5 Nov 2025 22:08:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53C978E0002; Wed,  5 Nov 2025 22:08:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42BFB8E000C; Wed,  5 Nov 2025 22:08:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 302348E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 22:08:51 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0755313B2D6
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 03:08:51 +0000 (UTC)
X-FDA: 84078700062.10.A33FDA5
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2C17C4000A
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 03:08:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KN/DJGkd";
	spf=pass (imf07.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762398529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wIsyAMNnw7nslxKPfpA6a4ZVLouJ1SMZOTovHQ+bzJ0=;
	b=7SDgBOrWI01cBqR0hYaBziSAYPCppibGaia41JylHpRLWELU6vjK6ugndvhqZfI0lFRCcb
	OyKSL2Cf16gsyQdpDclhxyiLYSJlzsgv3xqftCAUIeXAYUYtmZoMb6fNWJfeBQDfGRGXEZ
	MhgHjtxTE45Ng0rF7K0qqf+fJwkolno=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KN/DJGkd";
	spf=pass (imf07.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762398529; a=rsa-sha256;
	cv=none;
	b=gK+S2SMt/s2AQ6hMCkvvVxh/+5vyMj8Y2B3rAl/UlQ0EZaT69Fyy1an2U38wv8SVuXMCGF
	s2WHOdRfk1HE2XVePg/g6ijik7GExTFs+/HNhLdHsqIKVasaP1mU/e6hpv840FEbVdCj6n
	mBV5s7BmvPeATQ9fInVmREmAAZ7vHr0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762398527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wIsyAMNnw7nslxKPfpA6a4ZVLouJ1SMZOTovHQ+bzJ0=;
	b=KN/DJGkdMsctyHJn594+XHfEP/bSV8oEPMMTfJygIB8wfLZ0a00sk7c9nwEQxSutmlUxt2
	QrlghSS38XCMU27DR9zFDAoaPL36rFYJboViE3aVp6JAOcnZNd5OZZVpxLNjgdiIsM290f
	ei6kcJWkvDkD/N3bJElJY2kppZJ2BSA=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	SeongJae Park <sj@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	Geliang Tang <geliang@kernel.org>
Subject: [PATCH v5 2/2] mm/hugetlb: extract sysctl into hugetlb_sysctl.c
Date: Thu,  6 Nov 2025 11:08:23 +0800
Message-ID: <5bbee7ab5be71d0bb1aebec38642d7e83526bb7a.1762398359.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1762398359.git.zhuhui@kylinos.cn>
References: <cover.1762398359.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2C17C4000A
X-Stat-Signature: c9s87n6nqdet3fi5di6cisoh4saznmx8
X-Rspam-User: 
X-HE-Tag: 1762398528-948791
X-HE-Meta: U2FsdGVkX1/ZH1lWNqsLuTEeGxBk4NWIXPKYX4Yc5I3LTh5U2k830K9xomVFYYHzVbXAF5lmu7GAQs0G/+wLLA5VSEYj/RMuVX4ztVS7xtbicq+JoYSFwakqv1vc5ZiKdhaJVsQXC2SDLxz7PNP3+oEaA8gxRYrKJi24No6Y1cxtJxjyFE75AFDUXZPZgPV/OdB3NuC4FDJAC4kYnoIgjF9QvCsIeIpHYUbCsYqKkKXqrNyEXoCsf+7boVP0vGp7EzYFIFVex//bqzO3S0YPkiLYTzESr3D0M96WEUM5SGOou8gAJdkYOi99efjhN/cPXQJOY9KSRiyiOJoeF+/Li7BTQXRNgAvYYitOLZJccmGPgCUwIxOTofCEe8mreD31/uN/rXVASQCBr+sL3fdxoqYg3KDLzkaxTeCwosx4j1Z0FU7oZciWPmudc/kd+VY5BFz7XfuEhQHr8hbYOJJryzxGkzsviM0ZkP8ebzJQ3UiRIJHGAqi7vo7EFfRCju5uge+Uz7naNnhd3XWECAVaRCad9EWPfwSZFdIUrPw0vS4ycq+doCNVHjvj1ScisU4cZk/Ha6KOS3BL9FeMpndyK2Y97+kCuQsXCl9+IRFBX4h4tanz/AwRZwpphKvzwjB4mW9ARNS1U0gu4O6y5OhxKRLb8cwV8bQw5jng+28gErkKOsUBkNKy3hY/MYb0AFx3l3rMPQn0NxzO3ikzZsNT0nFA3lhfBFVashJxKKNusD4EhTMkdJKN6eB0Et0zfDBCADPEqyk1Mrv6dTD9C1yMieo1SVbfYS1Xplks8cwbLx+lwgmi5YoGLT4YHDjyVhXOuo0851de/FKkx2D7f+opKVD7PboJFB0+X8/SOl52jtVJXTqXhaIRi0mP6Aa7VA/tfBmf5cstLdcb3jimzgS8KrDaNA4RM27FjdoYk9cUQRiEOQTuoYAv7eYPff2cQnuH9LCGIpucW64r47zg4j1
 qGANPu/8
 TLnpTD3y3jxIOP+G3O7BogiV+RQAi4xf+HdpsSKkcMbAqfHE7+qAjqZJGLGv+eLyXQ2pZZ5qLxdSyN9n1yQkTEw/OaH/dM2pxf0sA2K0rPlTr48ffI3BC4XaOJj089MapIjnZbOmwejjxQV3s+iMdU9uJXM3mgGhJbZ+27SDLQjrNEDzpMJiCW8NRaizzi6VRyi1Vq4MrJ8klf3HLAsuD1Q1UyBL/fHLWX50tVkNERA2ihU9fP6xvI42ukJZ78JPIb1wa3urRNDmDDvg=
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
index f318e9bec566..fa519cbc4b88 100644
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
index 4d6242adbc17..d7ebf7a91b9a 100644
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
@@ -4111,12 +4110,6 @@ ssize_t __nr_hugepages_store_common(bool obey_mempolicy,
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
@@ -4549,131 +4542,6 @@ static unsigned int allowed_mems_nr(struct hstate *h)
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
index 5ea372500de7..1d2f870deccf 100644
--- a/mm/hugetlb_internal.h
+++ b/mm/hugetlb_internal.h
@@ -108,4 +108,10 @@ extern ssize_t __nr_hugepages_store_common(bool obey_mempolicy,
 
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


