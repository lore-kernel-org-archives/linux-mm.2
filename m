Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FFBDE7FDCF
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 19:24:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A24E6B008A; Tue,  3 Feb 2026 14:24:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8594B6B0092; Tue,  3 Feb 2026 14:24:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7724E6B0095; Tue,  3 Feb 2026 14:24:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5233C6B008A
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 14:24:02 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B095DC2253
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 19:24:01 +0000 (UTC)
X-FDA: 84404120682.25.FF81CF0
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf07.hostedemail.com (Postfix) with ESMTP id DCF5840009
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 19:23:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FiCotp0a;
	spf=pass (imf07.hostedemail.com: domain of 3TkuCaQgKCEEmldtl1dqjrrjoh.frpolqx0-ppnydfn.ruj@flex--jiaqiyan.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3TkuCaQgKCEEmldtl1dqjrrjoh.frpolqx0-ppnydfn.ruj@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770146640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/tlxC7jV4F7Lz2K5ysVxinzelO7YC4ddlq8CWE746MQ=;
	b=Z5igmBhYDLEASjcG3XSZQLAPopbIeS6L6mnrcLrISfVFeL/cU1YNRhgNf2inON3MGocAap
	EV1CVd7GFKG3C81T3cDwJS2/r6/3b6Fm9U3hrkOqJo0K8iAyZjG2hgkyWUL7pblcRoGS9H
	eFYEK46pr0DEKd8msRTT/ozH71G+qH4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FiCotp0a;
	spf=pass (imf07.hostedemail.com: domain of 3TkuCaQgKCEEmldtl1dqjrrjoh.frpolqx0-ppnydfn.ruj@flex--jiaqiyan.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3TkuCaQgKCEEmldtl1dqjrrjoh.frpolqx0-ppnydfn.ruj@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770146640; a=rsa-sha256;
	cv=none;
	b=03kyQrQcy+nd3jIZsJjn62QGxKILAdxKSr/nWM7Jk55edVHK3BEMcpm47wsJl5Jyx73B6l
	HW2L8cIJ3iduVpgebl7jx8JJ6rrzEMC4un4mbpzeylsJH8ePlXeXI6NLCMx0ZM5cRKFwMo
	POs/8/QJklN4R2afm+Cckl8nelK7sRM=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8216fece04cso104411b3a.0
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 11:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770146639; x=1770751439; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/tlxC7jV4F7Lz2K5ysVxinzelO7YC4ddlq8CWE746MQ=;
        b=FiCotp0aQm/rWuysZnQhWk3x2sjeZ1i4fMHkA1g5/gVmu67Wq3ytEzejsct0eS2/gk
         sS0SppgMkhmyBggyq8dHfKTblpWdpBcWD0/zztA5AcjVQ8bVpamJ1VpB19FxPrjYYp8f
         GZ/EDEujrQsaZPSqOEWo80gNMJbKsM9dK+yyMMSb939HcRuEFweoF5alKZqLw+UpIsbX
         PmUpdxC4BvJoYO/c2JTEgXT3yyJRElxATdtWFL9Oy9PatFcJG7WbDrQAfcrUwseWDb4v
         bDgeHC8x0Ng2Xd50g68rt2NvPWmINATJ0zmUJNliy74BSANFyCEq115iZJZ1lzPM9+tj
         Y87w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770146639; x=1770751439;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/tlxC7jV4F7Lz2K5ysVxinzelO7YC4ddlq8CWE746MQ=;
        b=vk9nkzWTYCnfkAo13cxeYlHbSW+a6P+uu+CSlv1ZInxsxto9iQQ0KjDo+JuiJMrJQL
         kvN0dhYlO1xSFWe3jMXjBZvD2MUSfTJU1U1q4xpKg1S0Kg4FBkAxkdwHxgrF0zvSNTUG
         m3dydhmtBHXtJyHUmRrrIuN48zLFyF/ydTWNvqmjpzttUNR9UIx1BbTFTzjF4sNlJK6Z
         dR+vSFqK01y1xW9RDaMRhqsnn5Qawn+grwuMyDUkaj4LUHTvQmOjbkqTKWfWHdKvdZhm
         toVVMMp3WlvREueGpcramRg3BqNECHIbFvHWBXH0t+gL8RG9o+Y3HIPYBFkGnfOVGWzW
         WVjA==
X-Forwarded-Encrypted: i=1; AJvYcCX3UueitT1JfkZJDSwZms4wf6Md1wEDhk0ohQi4IN8xxtGtd20f3R4PXPwBbt1KUHAehcsQSV7Tgg==@kvack.org
X-Gm-Message-State: AOJu0YywI5cVBZCX3lxwrz08K6mHO6meLz9uiAj2f+d7ZO5Fong1pZin
	vpSFJhzdhPReTiYfenC3q+YFhAaIZKx0i9CcMVPJzanLr0TNjsePfa97j+vt4e9Tfp0qbcePAnQ
	nhEDiydjZklPKgQ==
X-Received: from pfh34.prod.google.com ([2002:a05:6a00:12e2:b0:7dd:8bba:639b])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2171:b0:824:1c29:f1c3 with SMTP id d2e1a72fcca58-8241c29f7dfmr368201b3a.21.1770146638563;
 Tue, 03 Feb 2026 11:23:58 -0800 (PST)
Date: Tue,  3 Feb 2026 19:23:51 +0000
In-Reply-To: <20260203192352.2674184-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20260203192352.2674184-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260203192352.2674184-3-jiaqiyan@google.com>
Subject: [PATCH v3 2/3] selftests/mm: test userspace MFR for HugeTLB hugepage
From: Jiaqi Yan <jiaqiyan@google.com>
To: linmiaohe@huawei.com, william.roche@oracle.com, harry.yoo@oracle.com, 
	jane.chu@oracle.com
Cc: nao.horiguchi@gmail.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	willy@infradead.org, akpm@linux-foundation.org, osalvador@suse.de, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com, 
	sidhartha.kumar@oracle.com, ziy@nvidia.com, david@redhat.com, 
	dave.hansen@linux.intel.com, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: 1hfwny8xd7c5618auzdch1wd4hty3nro
X-Rspamd-Queue-Id: DCF5840009
X-Rspam-User: 
X-HE-Tag: 1770146639-933223
X-HE-Meta: U2FsdGVkX18LbTP7rOZPlDNSbnS69qPyRoa8SiRCTcyaIVXEaZuz7Ti7+UgeTeIGgnU1galHWNS7rHm/WQOmKF+iLqGfoJmFaKnPwfW4Hmx9l12MQ3KQhui8ywtxL2GbyU+h6EWBon0nyqiqpR3HFFRWknD9JwDLKP+wRcQgn0Q/Dr0pCOEBGweqRiP8rhSekto2s7bZ1xBkUDauCGSFEKIG85BvHkIjTvyM+R0n2qsHb4q1ibrIbgXZYTTtytpxmQYwbzg1JxubSWTezgq0U4TN1w8grlc2brJ94aD2AUqJX0g5nrF3ANmF2x8mb0VKgOomMv1dh/tfuRhoh165Q2rBmeTcO+6n1ktYd7DBbRHYaUBP5ctdE3Y9Rov4xt3TcNy5Tr2na79jZs7iNC9SQBt0Q7XmbvKMXylgMry8vqYyUhRoWuu1OUwlxB2eCfaZsVj9a3lLZmSS0iv6R3kwY0fC/7YJc7RWi2Tt/Rn6TH3f/tueDtOM8LRzTv1/jumDdtmUG+6+sQBqcAEOObImxabp/v95ptbp5esyIxuwrYkddLc7p+A5H5w0snhm+eL9E2YvGJt9Bzj1AzCMF31kWjTgwiRgYL6lakPyirOLQo3SrhjBCyvZP54EO/ae6iP+mxBfeyl03GAwI4kO9AbyO19L07qo2cbDs4OavcZIzt8krx1mbDLT6BuA+LuW/Kcqn3PkPEY/KFO5tP+/2TgcIx92dQWaAT9lWs84rjA/UBy2mvHC0b0iTDalBG4a9liKgQVS4aNxebJvoGOdEKRb09cqumti0uhqNpKc35ii6pjiceF4BDmGA4rrOrssSn8WFa/SYUNlk4XszRJozBA5N07SDscLBfF6rIX/hfyQfjUJqVXsvB0aKgf+u2riRE5tmR6eLJXsacc9J5u5yvQ5dg5ZO1idASgjW9xJaHlj0UbeXMO9hdVsThXV3hmCEBgnDcRhcwB9zx8W/NcACfn
 9Z0TyhdB
 exkCowzjA+fpyd4MSU/qs1ujUZyZ9TqRZrBrPsSaC66QSmAjCrX+17ZxmfrhWZqXyUzykE+5nUP6Q4O/9SF6nv+ZDDI38ZySZ/2ImSH3UeJe8ePiLRCQfwUw6YI0TLYEoEYS27zEP1wWG6NLlovp+GiOYIo4dkUwp6mhJv8XCGiO6ss0uRRNIuD1YWurQAHMh+pCNjioiS/3591vMau+mcTacvTvm//9bMBr5QpTEIuQG2AMJjQCkKD/YxPn26zAdz7HTAcmD2jINTbXNq4dP7Gr60b6C4bLAJQLXNpdIuUmxhfbxxo3goNquswcEKG078Dc3oEn5wUFX8dv1uRE9CAbXxF/cLAFxoWFA76J0eIns4FREqTqCbEpmJq9nQTsBHJ/ZDuZoayo5G+Ebsw8MUA9liFclZpLhF2b4KObGIjhZUN2tnC2/QXx4zyXfmAO2dZmSdl73eXnXpRuk/ghJ405wmrwoNRmkO+EMsLWR3Eve4chan8G3+xpGysrrF8NQ6SiRexlmT/0mfdw2T+UjjBThX1ihLBIWkb9kt2COPfMUr8IQMAuGmfBn2PND+cNIMKhKJ27lGMXuCy5nNgdUPevQFAGI0s/Q1JVl7IIkNatgwh7dZNrSUk1VtVQ8c3vPBITaI7TN0BrquovY7heZJumco4WAcgQVn1rMPygySTHdNMZCJ/P6z5XVLEYdjI6OX7Tnp7JAq4xrZc1jNTNhylB5NSXzg+f92YHZixGYGuzF8I0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Test the userspace memory failure recovery (MFR) policy for HugeTLB:

1. Create a memfd backed by HugeTLB and had MFD_MF_KEEP_UE_MAPPED set.

2. Allocate and map 4 hugepages to the process.

3. Create sub-threads to MADV_HWPOISON inner addresses of the 1st hugepage.

4. Check if the process gets correct SIGBUS for each poisoned raw page.

5. Check if all memory are still accessible and content valid.

6. Check if the poisoned hugepage is dealt with after memfd released.

Two configurables in the test:

- hugepage_size: size of the hugepage, 1G or 2M.

- nr_hwp_pages: number of pages within the 1st hugepage to MADV_HWPOISON.

Reviewed-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 tools/testing/selftests/mm/.gitignore    |   1 +
 tools/testing/selftests/mm/Makefile      |   3 +
 tools/testing/selftests/mm/hugetlb-mfr.c | 369 +++++++++++++++++++++++
 3 files changed, 373 insertions(+)
 create mode 100644 tools/testing/selftests/mm/hugetlb-mfr.c

diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index c2a8586e51a1f..11664d20935db 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -5,6 +5,7 @@ hugepage-mremap
 hugepage-shm
 hugepage-vmemmap
 hugetlb-madvise
+hugetlb-mfr
 hugetlb-read-hwpoison
 hugetlb-soft-offline
 khugepaged
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index eaf9312097f7b..7469142a87dcc 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -63,6 +63,7 @@ TEST_GEN_FILES += hmm-tests
 TEST_GEN_FILES += hugetlb-madvise
 TEST_GEN_FILES += hugetlb-read-hwpoison
 TEST_GEN_FILES += hugetlb-soft-offline
+TEST_GEN_FILES += hugetlb-mfr
 TEST_GEN_FILES += hugepage-mmap
 TEST_GEN_FILES += hugepage-mremap
 TEST_GEN_FILES += hugepage-shm
@@ -233,6 +234,8 @@ $(OUTPUT)/migration: LDLIBS += -lnuma
 
 $(OUTPUT)/rmap: LDLIBS += -lnuma
 
+$(OUTPUT)/hugetlb-mfr: LDLIBS += -lnuma
+
 local_config.mk local_config.h: check_config.sh
 	/bin/sh ./check_config.sh $(CC)
 
diff --git a/tools/testing/selftests/mm/hugetlb-mfr.c b/tools/testing/selftests/mm/hugetlb-mfr.c
new file mode 100644
index 0000000000000..6de59efdb101f
--- /dev/null
+++ b/tools/testing/selftests/mm/hugetlb-mfr.c
@@ -0,0 +1,369 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Test the userspace memory failure recovery (MFR) policy for HugeTLB
+ * hugepage case:
+ * 1. Create a memfd backed by HugeTLB and MFD_MF_KEEP_UE_MAPPED bit set.
+ * 2. Allocate and map 4 hugepages.
+ * 3. Create sub-threads to MADV_HWPOISON inner addresses of the 1st hugepage.
+ * 4. Check if each sub-thread get correct SIGBUS for the poisoned raw pages.
+ * 5. Check if all memory are still accessible and content still valid.
+ * 6. Check if the poisoned hugepage is dealt with after memfd released.
+ *
+ * Test takes two arguments:
+ * - hugepage_size: size of the hugepage, 1G or 2M.
+ * - nr_hwp_pages: number of pages within the 1st hugepage to MADV_HWPOISON.
+ *
+ * Example ways to run the test:
+ *   ./hugetlb-mfr 2M 3
+ * or
+ *   ./hugetlb-mfr 1G 1
+ * assuming /sys/kernel/mm/hugepages/hugepages-${xxx}kB/nr_hugepages > 4
+ */
+
+#define _GNU_SOURCE
+#include <assert.h>
+#include <errno.h>
+#include <numaif.h>
+#include <numa.h>
+#include <pthread.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+
+#include <linux/magic.h>
+#include <linux/memfd.h>
+#include <sys/mman.h>
+#include <sys/prctl.h>
+#include <sys/statfs.h>
+#include <sys/types.h>
+
+#include "../kselftest.h"
+#include "vm_util.h"
+
+#define min(a, b) ((a) < (b) ? (a) : (b))
+
+#define EPREFIX			" !!! "
+#define BYTE_LENTH_IN_1G	0x40000000UL
+#define BYTE_LENTH_IN_2M	0x200000UL
+#define HUGETLB_1GB_STR		"1G"
+#define HUGETLB_2MB_STR		"2M"
+#define HUGETLB_FILL		0xab
+
+static const unsigned long offsets_1g[] = {
+	0x200000, 0x3ff000, 0x801000, 0x2000000,
+	0x3fff000, 0x4001000, 0x7fff000, 0x8011000
+};
+static const unsigned long offsets_2m[] = {
+	0x020000, 0x041000, 0x07f000, 0x120000,
+	0x13f000, 0x141000, 0x17f000, 0x18f000
+};
+static size_t nr_hwp_pages;
+
+static void *sigbus_addr;
+static int sigbus_addr_lsb;
+static bool expecting_sigbus;
+static bool got_sigbus;
+static bool was_mceerr;
+
+static int create_hugetlbfs_file(struct statfs *file_stat,
+				 unsigned long hugepage_size)
+{
+	int fd;
+	int flags = MFD_HUGETLB | MFD_MF_KEEP_UE_MAPPED;
+
+	if (hugepage_size == BYTE_LENTH_IN_2M)
+		flags |= MFD_HUGE_2MB;
+	else
+		flags |= MFD_HUGE_1GB;
+
+	fd = memfd_create("hugetlb_tmp", flags);
+	if (fd < 0)
+		ksft_exit_fail_perror("Failed to memfd_create");
+
+	memset(file_stat, 0, sizeof(*file_stat));
+	if (fstatfs(fd, file_stat)) {
+		close(fd);
+		ksft_exit_fail_perror("Failed to fstatfs");
+	}
+	if (file_stat->f_type != HUGETLBFS_MAGIC) {
+		close(fd);
+		ksft_exit_fail_msg("Not hugetlbfs file");
+	}
+
+	ksft_print_msg("Created hugetlb_tmp file\n");
+	ksft_print_msg("hugepagesize=%#lx\n", file_stat->f_bsize);
+	if (file_stat->f_bsize != hugepage_size)
+		ksft_exit_fail_msg("Hugepage size is not %#lx", hugepage_size);
+
+	return fd;
+}
+
+/*
+ * SIGBUS handler for "do_hwpoison" thread that mapped and MADV_HWPOISON
+ */
+static void sigbus_handler(int signo, siginfo_t *info, void *context)
+{
+	if (!expecting_sigbus)
+		ksft_exit_fail_msg("unexpected sigbus with addr=%p",
+				   info->si_addr);
+
+	got_sigbus = true;
+	was_mceerr = (info->si_code == BUS_MCEERR_AO ||
+		      info->si_code == BUS_MCEERR_AR);
+	sigbus_addr = info->si_addr;
+	sigbus_addr_lsb = info->si_addr_lsb;
+}
+
+static void *do_hwpoison(void *hwpoison_addr)
+{
+	int hwpoison_size = getpagesize();
+
+	ksft_print_msg("MADV_HWPOISON hwpoison_addr=%p, len=%d\n",
+		       hwpoison_addr, hwpoison_size);
+	if (madvise(hwpoison_addr, hwpoison_size, MADV_HWPOISON) < 0)
+		ksft_exit_fail_perror("Failed to MADV_HWPOISON");
+
+	pthread_exit(NULL);
+}
+
+static void test_hwpoison_multiple_pages(unsigned char *start_addr,
+					 unsigned long hugepage_size)
+{
+	pthread_t pthread;
+	int ret;
+	unsigned char *hwpoison_addr;
+	const unsigned long *offsets;
+	size_t i;
+
+	if (hugepage_size == BYTE_LENTH_IN_2M)
+		offsets = offsets_2m;
+	else
+		offsets = offsets_1g;
+
+	for (i = 0; i < nr_hwp_pages; ++i) {
+		sigbus_addr = (void *)0xBADBADBAD;
+		sigbus_addr_lsb = 0;
+		was_mceerr = false;
+		got_sigbus = false;
+		expecting_sigbus = true;
+		hwpoison_addr = start_addr + offsets[i];
+
+		ret = pthread_create(&pthread, NULL, &do_hwpoison, hwpoison_addr);
+		if (ret)
+			ksft_exit_fail_perror("Failed to create hwpoison thread");
+
+		ksft_print_msg("Created thread to hwpoison and access hwpoison_addr=%p\n",
+			       hwpoison_addr);
+
+		pthread_join(pthread, NULL);
+
+		if (!got_sigbus)
+			ksft_test_result_fail("Didn't get a SIGBUS\n");
+		if (!was_mceerr)
+			ksft_test_result_fail("Didn't get a BUS_MCEERR_A(R|O)\n");
+		if (sigbus_addr != hwpoison_addr)
+			ksft_test_result_fail("Incorrect address: got=%p, expected=%p\n",
+					      sigbus_addr, hwpoison_addr);
+		if (sigbus_addr_lsb != pshift())
+			ksft_test_result_fail("Incorrect address LSB: got=%d, expected=%d\n",
+					      sigbus_addr_lsb, pshift());
+
+		ksft_print_msg("Received expected and correct SIGBUS\n");
+	}
+}
+
+static int read_nr_hugepages(unsigned long hugepage_size,
+			     unsigned long *nr_hugepages)
+{
+	char buffer[256] = {0};
+	char cmd[256] = {0};
+
+	sprintf(cmd, "cat /sys/kernel/mm/hugepages/hugepages-%ldkB/nr_hugepages",
+		hugepage_size);
+	FILE *cmdfile = popen(cmd, "r");
+
+	if (cmdfile == NULL) {
+		ksft_perror(EPREFIX "failed to popen nr_hugepages");
+		return -1;
+	}
+
+	if (!fgets(buffer, sizeof(buffer), cmdfile)) {
+		ksft_perror(EPREFIX "failed to read nr_hugepages");
+		pclose(cmdfile);
+		return -1;
+	}
+
+	*nr_hugepages = atoll(buffer);
+	pclose(cmdfile);
+	return 0;
+}
+
+/*
+ * Main thread that drives the test.
+ */
+static void test_main(int fd, unsigned long hugepage_size)
+{
+	unsigned char *map, *iter;
+	struct sigaction new, old;
+	const unsigned long hugepagesize_kb = hugepage_size / 1024;
+	unsigned long nr_hugepages_before = 0;
+	unsigned long nr_hugepages_after = 0;
+	unsigned long nodemask = 1UL << 0;
+	unsigned long len = hugepage_size * 4;
+	int ret;
+
+	if (read_nr_hugepages(hugepagesize_kb, &nr_hugepages_before) != 0) {
+		close(fd);
+		ksft_exit_fail_msg("Failed to read nr_hugepages\n");
+	}
+	ksft_print_msg("NR hugepages before MADV_HWPOISON is %ld\n", nr_hugepages_before);
+
+	if (ftruncate(fd, len) < 0)
+		ksft_exit_fail_perror("Failed to ftruncate");
+
+	ksft_print_msg("Allocated %#lx bytes to HugeTLB file\n", len);
+
+	map = mmap(NULL, len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("Failed to mmap");
+
+	ksft_print_msg("Created HugeTLB mapping: %p\n", map);
+
+	ret = mbind(map, len, MPOL_BIND, &nodemask, sizeof(nodemask) * 8,
+		    MPOL_MF_STRICT | MPOL_MF_MOVE);
+	if (ret < 0) {
+		perror("mbind");
+		ksft_exit_fail_msg("Failed to bind to node\n");
+	}
+
+	memset(map, HUGETLB_FILL, len);
+	ksft_print_msg("Memset every byte to 0xab\n");
+
+	new.sa_sigaction = &sigbus_handler;
+	new.sa_flags = SA_SIGINFO;
+	if (sigaction(SIGBUS, &new, &old) < 0)
+		ksft_exit_fail_msg("Failed to setup SIGBUS handler");
+
+	ksft_print_msg("Setup SIGBUS handler successfully\n");
+
+	test_hwpoison_multiple_pages(map, hugepage_size);
+
+	/*
+	 * Since MADV_HWPOISON doesn't corrupt the memory in hardware, and
+	 * MFD_MF_KEEP_UE_MAPPED keeps the hugepage mapped, every byte should
+	 * remain accessible and hold original data.
+	 */
+	expecting_sigbus = false;
+	for (iter = map; iter < map + len; ++iter) {
+		if (*iter != HUGETLB_FILL) {
+			ksft_print_msg("At addr=%p: got=%#x, expected=%#x\n",
+				       iter, *iter, HUGETLB_FILL);
+			ksft_test_result_fail("Memory content corrupted\n");
+			break;
+		}
+	}
+	ksft_print_msg("Memory content all valid\n");
+
+	if (read_nr_hugepages(hugepagesize_kb, &nr_hugepages_after) != 0) {
+		close(fd);
+		ksft_exit_fail_msg("Failed to read nr_hugepages\n");
+	}
+
+	/*
+	 * After MADV_HWPOISON, hugepage should still be in HugeTLB pool.
+	 */
+	ksft_print_msg("NR hugepages after MADV_HWPOISON is %ld\n", nr_hugepages_after);
+	if (nr_hugepages_before != nr_hugepages_after)
+		ksft_test_result_fail("NR hugepages reduced by %ld after MADV_HWPOISON\n",
+				      nr_hugepages_before - nr_hugepages_after);
+
+	/* End of the lifetime of the created HugeTLB memfd. */
+	if (ftruncate(fd, 0) < 0)
+		ksft_exit_fail_perror("Failed to ftruncate to 0");
+	munmap(map, len);
+	close(fd);
+
+	/*
+	 * After freed by userspace, MADV_HWPOISON-ed hugepage should be
+	 * dissolved into raw pages and removed from HugeTLB pool.
+	 */
+	if (read_nr_hugepages(hugepagesize_kb, &nr_hugepages_after) != 0) {
+		close(fd);
+		ksft_exit_fail_msg("Failed to read nr_hugepages\n");
+	}
+	ksft_print_msg("NR hugepages after closure is %ld\n", nr_hugepages_after);
+	if (nr_hugepages_before != nr_hugepages_after + 1)
+		ksft_test_result_fail("NR hugepages is not reduced after memfd closure\n");
+
+	ksft_test_result_pass("All done\n");
+}
+
+static unsigned long parse_hugepage_size(char *argv)
+{
+	if (strncasecmp(argv, HUGETLB_1GB_STR, strlen(HUGETLB_1GB_STR)) == 0)
+		return BYTE_LENTH_IN_1G;
+
+	if (strncasecmp(argv, HUGETLB_2MB_STR, strlen(HUGETLB_2MB_STR)) == 0)
+		return BYTE_LENTH_IN_2M;
+
+	ksft_print_msg("Please provide valid hugepage_size: 1G or 2M\n");
+	assert(false);
+}
+
+static size_t parse_nr_hwp_pages(char *argv)
+{
+	unsigned long val;
+	char *endptr;
+	size_t limit = min(ARRAY_SIZE(offsets_1g), ARRAY_SIZE(offsets_2m));
+
+	if (strlen(argv) < 1) {
+		ksft_print_msg("Please provide valid nr_hwpoison: 1-8\n");
+		assert(false);
+	}
+
+	errno = 0;
+	val = strtoul(argv, &endptr, 10);
+
+	if (*endptr != '\0') {
+		ksft_print_msg("Found invalid chars: '%s", endptr);
+		assert(false);
+	}
+
+	if (errno == ERANGE) {
+		ksft_print_msg("Value '%s' out of range for size_t\n", argv);
+		assert(false);
+	}
+
+	if (val > limit) {
+		ksft_print_msg("Value '%s' must < %lu\n", argv, limit);
+		assert(false);
+	}
+
+	return val;
+}
+
+int main(int argc, char **argv)
+{
+	int fd;
+	struct statfs file_stat;
+	unsigned long hugepage_size;
+
+	if (argc != 3) {
+		ksft_print_msg("Usage: %s <hugepage_size=1G|2M> <nr_hwp_pages>\n", argv[0]);
+		return -EINVAL;
+	}
+
+	ksft_print_header();
+	ksft_set_plan(1);
+
+	hugepage_size = parse_hugepage_size(argv[1]);
+	nr_hwp_pages = parse_nr_hwp_pages(argv[2]);
+	fd = create_hugetlbfs_file(&file_stat, hugepage_size);
+	test_main(fd, hugepage_size);
+
+	ksft_finished();
+}
-- 
2.53.0.rc2.204.g2597b5adb4-goog


