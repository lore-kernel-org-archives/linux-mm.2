Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA703CD6E60
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:56:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43CDA6B0096; Wed,  3 Jun 2026 08:56:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 415DD6B0099; Wed,  3 Jun 2026 08:56:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DBB66B0096; Wed,  3 Jun 2026 08:56:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 169EE6B0095
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:56:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CDEB9C1842
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:56:15 +0000 (UTC)
X-FDA: 84838599510.22.2E23657
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id B9C9020013
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:56:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=ChDwrPeE;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf13.hostedemail.com: domain of "prvs=46141c1cd1=mnissler@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=46141c1cd1=mnissler@meta.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780491373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kCmTY4djn40iYIvGLI5YejagOdsndfr8559CPvhcRLA=;
	b=EGC8Gj0pq9QUpn2V09z+O0nDm0dIk1HHJI9F+3O3bNfisdKdEk/C7WsBuZAkdEaREjwo/d
	SGMD30qUllJ+vLx8C78jYKo7JU7vsdiNDQG9Debm5cVSUe1Z9rdMoez6PsUJ+FT1zOUxel
	kgyQaLDBlVNfKwIwCQj4IZCx5CSuC1E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=ChDwrPeE;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf13.hostedemail.com: domain of "prvs=46141c1cd1=mnissler@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=46141c1cd1=mnissler@meta.com"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780491373;
	b=Y1fmVeRvQrPlTeG08mqnUx3fmALOS8NHZo0aMERuwis7F4xjiUg5vPQ6CN40RmZB/DVEVx
	Z5BUK2TzGIeMSafxhQmPeQT+gLPho7kg4+XsmbAHVUGiWlFkdzPwlF3SHkbtUfL2ZMXKio
	CeW1gk9hPPnT5DvumN1Gl4mtYfcqtRc=
Received: from pps.filterd (m0528008.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 652MSd5a3100189;
	Wed, 3 Jun 2026 05:56:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=kCmTY4djn40iYIvGLI5YejagOdsndfr8559CPvhcRLA=; b=ChDwrPeESYvG
	L9g0B4m6jMfF0VyHJMSRfXDYqmopugRsOAr8CS4Qq3j8eVZRYLMnfwJz+ZRyV/Nu
	5ig6lXsculJH1LvvWi/FdLMSj517G8Nw3SVU2Bwj/LR15kDgrhrs/0E6abclSgbZ
	ALrC0CK3VE4trXvyWdvJswb39sgueYDe+G7zLtxhnyEwUNS88FgUy4Ngcz2B6MeO
	pU36nlut9tKuAb1BiyfHt/eimuvxPwjUad/LlJKNb0iuJZCWlJ46tL7+9Hzhq0+M
	6rfktIw2G0Eg/oXS/3wEr6A5saxCga/q5HgvLpZN0welTV1KW+bJzDj4Y9uuxLog
	EmpgRit3ZQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4ej20wpgxr-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 03 Jun 2026 05:56:10 -0700 (PDT)
Received: from localhost (2620:10d:c0a8:1b::2d) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.41; Wed, 3 Jun
 2026 12:55:54 +0000
From: Mattias Nissler <mnissler@meta.com>
To: <linux-mm@kvack.org>
CC: Hugh Dickins <hughd@google.com>,
        Baolin Wang
	<baolin.wang@linux.alibaba.com>, <mnissler@meta.com>,
        <mattias.nissler@gmail.com>
Subject: [RFC PATCH 1/2] mm: `memfd_tripwire` proof-of-concept
Date: Wed, 3 Jun 2026 05:55:20 -0700
Message-ID: <20260603125521.1468362-2-mnissler@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260603125521.1468362-1-mnissler@meta.com>
References: <20260603125521.1468362-1-mnissler@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::2d]
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAzMDEyNCBTYWx0ZWRfX0m2Rr/+z/Q5b
 MlTiwSQ+5laqHnAffM8alJunayqbozVO/iDiX/Rx2rxcDFqal4XFXkq2RJKdVYY7eeD4t5C323z
 Yr9QzUIi2yF89N2698FiCVf+yM17Mc9ghY1dXclJ/33GuGh5EaQj1TDZ3w2XPneoyaxQykYlOsO
 LaoKZZh6QM8yDzqV0jy39AV0ki3n4Ljo9AEUbbLtkx/G0Om5I4CUifBMDuSuE7xRWvYD+YQxK6H
 tcWEeyqOvo0w3zcpVKzPsZIapMmDJUsmVySmxRYrebLdM7pbotIVgwRZaIeXCzfRfxbj8AHfDXv
 6hTh4XPfjS58FN1cBpGWU0muhax4wRgJP3e9WlPaLLYLh/Ckk+Glkbxb3FjTSzofjykvScpNHvs
 DoGDAuOdhBygwa5cZ9d6kjxmCBN4xRCmANN7195YVdWOz/4HTPL5dKRGwAFckg9u54oMZ6TYaFB
 j0VN/LeZqqxvD67+2gw==
X-Authority-Analysis: v=2.4 cv=HI7z0Itv c=1 sm=1 tr=0 ts=6a20246a cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=_1IyUuN4QrATX339ibzo:22 a=VabnemYjAAAA:8 a=LK_kJtONrx4oGZ8rtFgA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: sl8wTOMIz8_P-m5qQ2xxbSmoXhOBh-iq
X-Proofpoint-GUID: sl8wTOMIz8_P-m5qQ2xxbSmoXhOBh-iq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-03_04,2026-05-28_03,2025-10-01_01
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: hzhfftfw377jq3zzpsb4s7zp8i8hwoir
X-Rspamd-Queue-Id: B9C9020013
X-HE-Tag: 1780491373-810494
X-HE-Meta: U2FsdGVkX19aoWABguqwx6RuOsDW+HMwABN94YHlKV4Zcxy+qHOzJLwHQOljlK3x+VpMZL0COKiqgnwWpySQzIK29PkqyUYAMrq1lwglMOTX4i0+Z7mPlyoEjFqEEvbGFxnoVZkD0o8QhlbDWBFoH2/Yn/W7/dggea5+TkgcpBiNAlVU9eBk4485qZGMTN3Wnmn3mFwcE0cQlfvFZx9slpaZ1TjbbMJjMlJrbqcuk9ToMzZ6BftVEA5Vdzl+YKSLGIGyp/zOl4PnOkyXT2oIb1IjDoYCfEwgTW0HYADysbz5coxS2F4v8UO+F3nzE9BHfQI6SJAW4UhWAUwvnmtusjMhBBE8K0UNAnL6JbTPkeIJUBc/wVcfHSvdHiIYiuJlhUJRAThQLNbjiRtt/r2Z2vzs7UFv/al0Kc8vtYM4+PApubrE+EP+11X0ydBRMgn+40sL4HZR7oYOLQnirGq2oS5Z8gdv3VSsrSjeUvERZa1dNS2gwHPJaHm1fApewtie6nRRjOhZDVu18yrgMrRJwjnbvLrdn/43Y2uzdbRmW+/H/aFdj+PdkTUDt9frajJEkwVxVk94+NM6+iGmt5w9/LV25EjWwUM/qMqY7Sy0Z2yJLiZaU+08kM7TnmBdNdlgnM1dP5IM1PjLjIbU7dEcK7y5gAuhuwc1aRaO5UXqJtz3iypA1qgXSNnbQo54YjXh8KMJtV/pHfG2Gj+1fdd70y1O+8JLHyI6MhWoHvltTMpfpmRW1LIxvYN9mT4x0TtZ1rGsgvRKRLFNuEZ0pSmUuy1NZyD1okyn8GzSotjbh3nsFMNy3gZm/nGjV+A/Sc7rVbBQC5I+qOpNx7WimHjkPVf9eFepJ7+ZnSGgvO17dtLb6B5z/+U3VGSP1uFa6PHCB7IrqlERbtjC13wrO09wkCUqU0ZznBMwQedNZkwaeUXc5SnPaCf+FjyuBaNtA+G45AaTGSOM5ESz+7JULj7
 ZQWL8Uy1
 h34jIl5nLbyUGDXDY9QEHIYyzmr/NZSBe8FTcRFzgrJoy81Dp+zkk2hglwuP1VK69IeSm8QB6e/TxYVQGK/1Y64CNLI7ASZddygWLE4m0hATiGqTOOnzoq8Uw9H3GqsFSJq+WkwJvEFNe69P6J76cGdUItbrM4pL92AkaXKqgahIm6NQtX5S+1zW/fGruz4XEE4wdt+4CsE5uDhlAIYYoGS+GjeM9xsdGs1qTJ69b7FpNVRwZXhvC1CvTHxXxrsqsczRpfoFQkpUmQsijljT0jn3Fc6bTEsXUEOwLPlET5qKuLEA/6r/zEyDfc5/SpXMBaxgH2XZKYYoVyS6cO+H+Ry26ttWWoARirfnHYeIRJbJFe9iCuYVV3L78vLmMPSZ2UHK93EJk/7CfWDuTwzxHTqrwJgirAYKQdFTIcn3GXfQlpe5DSTtrGBYs4nt7zNTkYyIcWLcKWbh6q7yA8bZtJs9tDki9cjFO3NcD7j+V2Ph6l2ja9NStnf0Sf6U8y9v+Sn6v6izVtWv+AFbq9eNNmJtX06y3F+NZwnSAc8+5WB9CqapM9niZDrZh06Nf4zblctPTZoh3wvvXil42n83MFlsovMBf3sk/Dr5aVKSWE72/v2g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

`memfd_tripwire()` creates a file descriptor referring to a memory
region that generates poll notifications when it is written. This works
by installing read-only mappings. Write accesses then trigger a fault
and invoke the `page_mkwrite()` handler, which queues a POLLIN event and
allows the PTE to be made writable. After observing the POLLIN, the
consumer is expected to invoke the `MEMFD_TRIPWIRE_ACK` ioctl, which
write-protects the mappings again to re-arm the mechanism. It also
guarantees that previous writes are visible to the consumer.

Signed-off-by: Mattias Nissler <mnissler@meta.com>
Assisted-by: Claude:claude-opus-4-6
---
 arch/x86/entry/syscalls/syscall_64.tbl |   1 +
 include/linux/syscalls.h               |   1 +
 include/uapi/asm-generic/unistd.h      |   5 +-
 include/uapi/linux/memfd_tripwire.h    |  19 ++
 kernel/sys_ni.c                        |   3 +
 mm/Kconfig                             |   9 +
 mm/Makefile                            |   1 +
 mm/memfd_tripwire.c                    | 246 +++++++++++++++++++++++++
 scripts/syscall.tbl                    |   1 +
 9 files changed, 285 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/linux/memfd_tripwire.h
 create mode 100644 mm/memfd_tripwire.c

diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 524155d655da1..d93ace9385fd0 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -396,6 +396,7 @@
 469	common	file_setattr		sys_file_setattr
 470	common	listns			sys_listns
 471	common	rseq_slice_yield	sys_rseq_slice_yield
+472	common	memfd_tripwire		sys_memfd_tripwire
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 4fb7291f54b62..52ea6d808f96d 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -940,6 +940,7 @@ asmlinkage long sys_seccomp(unsigned int op, unsigned int flags,
 asmlinkage long sys_getrandom(char __user *buf, size_t count,
 			      unsigned int flags);
 asmlinkage long sys_memfd_create(const char __user *uname_ptr, unsigned int flags);
+asmlinkage long sys_memfd_tripwire(unsigned int flags);
 asmlinkage long sys_bpf(int cmd, union bpf_attr __user *attr, unsigned int size);
 asmlinkage long sys_execveat(int dfd, const char __user *filename,
 			const char __user *const __user *argv,
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index a627acc8fb5fe..38825b1c59cef 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -863,8 +863,11 @@ __SYSCALL(__NR_listns, sys_listns)
 #define __NR_rseq_slice_yield 471
 __SYSCALL(__NR_rseq_slice_yield, sys_rseq_slice_yield)
 
+#define __NR_memfd_tripwire 472
+__SYSCALL(__NR_memfd_tripwire, sys_memfd_tripwire)
+
 #undef __NR_syscalls
-#define __NR_syscalls 472
+#define __NR_syscalls 473
 
 /*
  * 32 bit systems traditionally used different
diff --git a/include/uapi/linux/memfd_tripwire.h b/include/uapi/linux/memfd_tripwire.h
new file mode 100644
index 0000000000000..478599ba2f813
--- /dev/null
+++ b/include/uapi/linux/memfd_tripwire.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_MEMFD_TRIPWIRE_H
+#define _UAPI_LINUX_MEMFD_TRIPWIRE_H
+
+#include <linux/ioctl.h>
+
+#define MEMFD_TRIPWIRE_IOC		0xDA
+
+/*
+ * MEMFD_TRIPWIRE_ACK serves two purpose: First, it re-arms the mechanism to
+ * make sure future write activity triggers a POLLIN notification. Second, it
+ * makes sure that all writes up to the ACK are visible to the calling process.
+ * It is also guaranteed that no writes can sneak through unnoticed, i.e. after
+ * ACK concurrent writes have either taken place and are visible to the
+ * consumer, or will generate subsequent POLLIN events.
+ */
+#define MEMFD_TRIPWIRE_ACK		_IO(MEMFD_TRIPWIRE_IOC, 0x00)
+
+#endif /* _UAPI_LINUX_MEMFD_TRIPWIRE_H */
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index add3032da16f5..6bcf8658b4ff5 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -270,6 +270,9 @@ COND_SYSCALL(pkey_free);
 /* memfd_secret */
 COND_SYSCALL(memfd_secret);
 
+/* memfd_tripwire */
+COND_SYSCALL(memfd_tripwire);
+
 /*
  * Architecture specific weak syscall entries.
  */
diff --git a/mm/Kconfig b/mm/Kconfig
index e8bf1e9e6ad90..c7c1c2e69d37b 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1323,6 +1323,15 @@ config SECRETMEM
 	  memory areas visible only in the context of the owning process and
 	  not mapped to other processes and other kernel page tables.
 
+config MEMFD_TRIPWIRE
+	bool "Enable memfd_tripwire() system call"
+	depends on MMU
+	help
+	  Enable the memfd_tripwire() system call, which creates an anonymous
+	  shared memory region with built-in write notification support. The
+	  returned file descriptor supports poll() for detecting writes to the
+	  mapped memory and an ioctl for re-arming notifications.
+
 config ANON_VMA_NAME
 	bool "Anonymous VMA name support"
 	depends on PROC_FS && ADVISE_SYSCALLS && MMU
diff --git a/mm/Makefile b/mm/Makefile
index 8ad2ab08244eb..658443dbcb28d 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -141,6 +141,7 @@ obj-$(CONFIG_PERCPU_STATS) += percpu-stats.o
 obj-$(CONFIG_ZONE_DEVICE) += memremap.o
 obj-$(CONFIG_HMM_MIRROR) += hmm.o
 obj-$(CONFIG_MEMFD_CREATE) += memfd.o
+obj-$(CONFIG_MEMFD_TRIPWIRE) += memfd_tripwire.o
 obj-$(CONFIG_MAPPING_DIRTY_HELPERS) += mapping_dirty_helpers.o
 obj-$(CONFIG_PTDUMP) += ptdump.o
 obj-$(CONFIG_PAGE_REPORTING) += page_reporting.o
diff --git a/mm/memfd_tripwire.c b/mm/memfd_tripwire.c
new file mode 100644
index 0000000000000..52a27507b2d39
--- /dev/null
+++ b/mm/memfd_tripwire.c
@@ -0,0 +1,246 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * memfd_tripwire - Memory file descriptor with write notification support.
+ *
+ * Creates an anonymous memory-backed file descriptor that supports polling for
+ * detecting writes to its mappings.
+ *
+ * Theory of operation:
+ *  1.  memfd_tripwire() to create a new instance
+ *  2.  Pass the fd / mapping to the (possibly out-of-process) producer
+ *  3a. The producer uses the memory region as normal memory. Writes stick, but
+ *      generate a notification as a side effect.
+ *  3b. The consumer polls the file descriptor:
+ *       a. POLLIN is observed when the memory region gets written
+ *       b. Call ioctl(MEMFD_TRIPWIRE_ACK) to restore write protection
+ *       c. Inspect memory contents and react as appropriate
+ */
+
+#include <linux/anon_inodes.h>
+#include <linux/file.h>
+#include <linux/folio_batch.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/mount.h>
+#include <linux/pagemap.h>
+#include <linux/poll.h>
+#include <linux/pseudo_fs.h>
+#include <linux/rmap.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+
+#include <uapi/linux/magic.h>
+#include <uapi/linux/memfd_tripwire.h>
+
+struct tripwire_info {
+	atomic_t dirty;
+	wait_queue_head_t wqh;
+};
+
+static struct tripwire_info *to_tripwire_info(struct file *file)
+{
+	return file->private_data;
+}
+
+static vm_fault_t tripwire_fault(struct vm_fault *vmf)
+{
+	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
+	struct inode *inode = file_inode(vmf->vma->vm_file);
+	pgoff_t offset = vmf->pgoff;
+	gfp_t gfp = vmf->gfp_mask;
+	struct folio *folio;
+	int err;
+
+	if (((loff_t)offset << PAGE_SHIFT) >= i_size_read(inode))
+		return vmf_error(-EINVAL);
+
+retry:
+	folio = filemap_lock_folio(mapping, offset);
+	if (IS_ERR(folio)) {
+		folio = folio_alloc(gfp | __GFP_ZERO, 0);
+		if (!folio)
+			return VM_FAULT_OOM;
+
+		__folio_mark_uptodate(folio);
+		err = filemap_add_folio(mapping, folio, offset, gfp);
+		if (unlikely(err)) {
+			folio_put(folio);
+			if (err == -EEXIST)
+				goto retry;
+			return vmf_error(err);
+		}
+	}
+
+	vmf->page = folio_file_page(folio, offset);
+	return VM_FAULT_LOCKED;
+}
+
+static vm_fault_t tripwire_page_mkwrite(struct vm_fault *vmf)
+{
+	struct tripwire_info *info = to_tripwire_info(vmf->vma->vm_file);
+	struct folio *folio = page_folio(vmf->page);
+
+	/*
+	 * Note that this might be racing with a concurrent ACK. We need to
+	 * guarantee that the dirty flag and page protection state remains
+	 * consistent and that no notifications are lost.
+	 *
+	 * The actual update to mark the PTE writable only happens after this
+	 * function completes, so the window between here and PTE update must
+	 * be protected against concurrent modifications by the ACK code path.
+	 * Taking the folio lock before notifying consumers conveniently
+	 * makes sure that ACKs can only complete after our PTE updates go
+	 * through, preventing a situation where an interleaved ACK clears the
+	 * dirty flag but we're still going ahead to mark the PTE writable.
+	 */
+	folio_lock(folio);
+
+	if (atomic_cmpxchg(&info->dirty, 0, 1) == 0)
+		wake_up_poll(&info->wqh, EPOLLIN);
+
+	if (folio->mapping != vmf->vma->vm_file->f_mapping) {
+		folio_unlock(folio);
+		return VM_FAULT_NOPAGE;
+	}
+
+	return VM_FAULT_LOCKED;
+}
+
+static const struct vm_operations_struct tripwire_vm_ops = {
+	.fault = tripwire_fault,
+	.page_mkwrite = tripwire_page_mkwrite,
+};
+
+static int tripwire_mmap_prepare(struct vm_area_desc *desc)
+{
+	file_accessed(desc->file);
+	desc->vm_ops = &tripwire_vm_ops;
+	return 0;
+}
+
+static __poll_t tripwire_poll(struct file *file, poll_table *wait)
+{
+	struct tripwire_info *info = to_tripwire_info(file);
+	__poll_t mask = 0;
+
+	poll_wait(file, &info->wqh, wait);
+
+	if (atomic_read(&info->dirty))
+		mask |= EPOLLIN | EPOLLRDNORM;
+
+	return mask;
+}
+
+static void tripwire_ack(struct file *file)
+{
+	struct tripwire_info *info = to_tripwire_info(file);
+	struct address_space *mapping = file->f_mapping;
+	struct folio_batch fbatch;
+	pgoff_t index = 0;
+	int i;
+
+	/*
+	 * Note that this flag update is not protected by the folio locks taken
+	 * below. Hence a concurrent writer might sneak in and switch back to
+	 * dirty state. That's OK though, since it merely results in a spurious
+	 * notification.
+	 */
+	atomic_set(&info->dirty, 0);
+
+	folio_batch_init(&fbatch);
+	while (filemap_get_folios(mapping, &index, ~0UL, &fbatch)) {
+		for (i = 0; i < folio_batch_count(&fbatch); i++) {
+			folio_lock(fbatch.folios[i]);
+			folio_mkclean(fbatch.folios[i]);
+			folio_unlock(fbatch.folios[i]);
+		}
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+}
+
+static long tripwire_ioctl(struct file *file, unsigned int cmd,
+			   unsigned long arg)
+{
+	switch (cmd) {
+	case MEMFD_TRIPWIRE_ACK:
+		if (arg != 0)
+			return -EINVAL;
+		tripwire_ack(file);
+		return 0;
+	default:
+		return -ENOTTY;
+	}
+}
+
+static int tripwire_release(struct inode *inode, struct file *file)
+{
+	kfree(to_tripwire_info(file));
+	return 0;
+}
+
+static const struct file_operations tripwire_fops = {
+	.release = tripwire_release,
+	.mmap_prepare = tripwire_mmap_prepare,
+	.poll = tripwire_poll,
+	.unlocked_ioctl = tripwire_ioctl,
+};
+
+static const struct address_space_operations tripwire_aops = {
+	.dirty_folio = noop_dirty_folio,
+};
+
+static int tripwire_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
+			    struct iattr *iattr)
+{
+	struct inode *inode = d_inode(dentry);
+	unsigned int ia_valid = iattr->ia_valid;
+	int ret;
+
+	filemap_invalidate_lock(inode->i_mapping);
+
+	/* Allowing size to change only once avoids the need to unmap here. */
+	if ((ia_valid & ATTR_SIZE) && inode->i_size)
+		ret = -EINVAL;
+	else
+		ret = simple_setattr(idmap, dentry, iattr);
+
+	filemap_invalidate_unlock(inode->i_mapping);
+
+	return ret;
+}
+
+static const struct inode_operations tripwire_iops = {
+	.setattr = tripwire_setattr,
+};
+
+SYSCALL_DEFINE1(memfd_tripwire, unsigned int, flags)
+{
+	struct tripwire_info *info;
+	struct inode *inode;
+	struct file *file;
+
+	if (flags != 0)
+		return -EINVAL;
+
+	info = kzalloc_obj(struct tripwire_info);
+	if (!info)
+		return -ENOMEM;
+
+	init_waitqueue_head(&info->wqh);
+
+	file = anon_inode_create_getfile("memfd_tripwire", &tripwire_fops, info,
+					 O_RDWR, NULL);
+	if (IS_ERR(file)) {
+		kfree(info);
+		return PTR_ERR(file);
+	}
+
+	inode = file_inode(file);
+	inode->i_op = &tripwire_iops;
+	inode->i_mapping->a_ops = &tripwire_aops;
+	inode->i_mode |= S_IFREG;
+	inode->i_size = 0;
+
+	return FD_ADD(O_CLOEXEC, file);
+}
diff --git a/scripts/syscall.tbl b/scripts/syscall.tbl
index 7a42b32b65776..a2bd8cd809ee8 100644
--- a/scripts/syscall.tbl
+++ b/scripts/syscall.tbl
@@ -412,3 +412,4 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	memfd_tripwire			sys_memfd_tripwire
-- 
2.52.0


