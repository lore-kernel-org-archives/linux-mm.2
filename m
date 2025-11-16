Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B131CEB2F1
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 01:32:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CD308E002C; Sat, 15 Nov 2025 20:32:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97C9B8E0005; Sat, 15 Nov 2025 20:32:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 845198E002C; Sat, 15 Nov 2025 20:32:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6BD2D8E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 20:32:33 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 200A6BBC84
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 01:32:33 +0000 (UTC)
X-FDA: 84114745386.28.A8923AE
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 50EAB10000B
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 01:32:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cJOmvrdI;
	spf=pass (imf05.hostedemail.com: domain of 3rikZaQgKCLUedVldtVibjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jiaqiyan.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3rikZaQgKCLUedVldtVibjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763256751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8sO0/av5qDx17FrXuykncGViP/btoc/Aka3BNjQeG4g=;
	b=oxBun6RhuMZYPpTOFq1jDyk8qHmMJU/NyMIWZwZGsxlMSpl0NXyd2TF8sz2Wu9Wq12hBGV
	uQkDpmRwJxCWMEVlVFMRA7znzuilyd1BTD18aDG/fVTx+js6bHp7JZez6nXTYJZe7Xyna0
	Ypb14fj8HmslGEGXvNs1IhpqRD30obg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763256751; a=rsa-sha256;
	cv=none;
	b=QIBaYENS6A+lsPd1Cq2HXaKvZrUf0Yy6KjKjdByjRc67hjqyUXdJidAvz9fScfpJFHYEjb
	oTq5rbNrxCtOfrcrVI5RxhB68FOUsSwliJl/iryLojlqZwnk++/gvAwFycS212LtY2Ntts
	OINMoMydm0ijm27hAjkgM9q+JZKHV60=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cJOmvrdI;
	spf=pass (imf05.hostedemail.com: domain of 3rikZaQgKCLUedVldtVibjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jiaqiyan.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3rikZaQgKCLUedVldtVibjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-340c07119bfso8666249a91.2
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 17:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763256750; x=1763861550; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8sO0/av5qDx17FrXuykncGViP/btoc/Aka3BNjQeG4g=;
        b=cJOmvrdIpeT2S5N9jLELv+5aWLMI362XjMRIebODhOfkg68gXcI/+GKqwYzMLlVzKJ
         c8nGVYuRuV4dwkOj3rHn/JsPffJ5r8BDngma82l+YV7nhhmTToT6NTgVDLTTHUaBDiI3
         6ZC9Zcg6ubpE0Uf4V662bxa+CIoJJwxKG6e4BVWZHFR8j72k3ttYY/EsRKEruwmmoelw
         Z4fw0dHBQM1DKqhWFRsv/CE7chsCzPFT3FgjGRSdiX0AjG7ZrT/8Q8jCP8/r0CJcIjvO
         rNhfW8Y3113ffCYPkI7dM497o6S7z8ruWqgN0FrlVS9cgkJu32deJt12mJYkIrvtoEee
         EzVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763256750; x=1763861550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8sO0/av5qDx17FrXuykncGViP/btoc/Aka3BNjQeG4g=;
        b=nfH4SACMGSvXPz6uv4PtR9fn1k9Wx0jNfjW8kRf4T8p4fadPkieAt93WdEuQZKH8eh
         5hqqB4qbpN8I2JT9+FRJTP2BSH9rG+mY9k4c2rbIIfgvl7IrVD+EmQlcG7MzEGAnF53O
         wBwFdKbd6S2nqwty7iQdlnfirPsDFjml4wj/JCbxmQKS4ktdKyzl80mkaBne+HNcbi+Q
         PyDKfUAMhk6/ymipka8aWMiSjUe+wnXBtFlkpXbIcogc08fSsZcemT3eYGTzr6XTYikH
         LbRwfkLBu05TRm7iBDPwEcVJLigNJUF2gA/Edsq/UdJviDk1oaN75PMGFc1HYbH6g6z2
         Eh5A==
X-Forwarded-Encrypted: i=1; AJvYcCUe/E/1xkppb19bKtL1rd1BA7KwO5eONdgr1s3WzJCJgi36CuX+G93d1GI7cDsuoHJx/8JAgyT63A==@kvack.org
X-Gm-Message-State: AOJu0Yz6BD6nheG42REh3F0qYwcSI2MXMqOPZRYV7yGvkaMfNDwVTCH1
	9hxzVTvWcU3MJf35VzvbW7cW6o7hqOQWdbvLQ5oNMF5X6ZChtiECQu3VfhSAEaPCij9Sa78Xf7Z
	nSowYze1I/yLI6g==
X-Google-Smtp-Source: AGHT+IGPrzGeVqoTqtqjEJcCybfsqm0+GqgGVKnc5pKCVupFwE43PRD/+9yP6BR0ldp/cqiEfhQ5DucGRrs7yA==
X-Received: from pjbbr14.prod.google.com ([2002:a17:90b:f0e:b0:33b:52d6:e13e])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3501:b0:341:88c9:6eb2 with SMTP id 98e67ed59e1d1-343f9e94895mr7528629a91.1.1763256750116;
 Sat, 15 Nov 2025 17:32:30 -0800 (PST)
Date: Sun, 16 Nov 2025 01:32:22 +0000
In-Reply-To: <20251116013223.1557158-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20251116013223.1557158-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251116013223.1557158-3-jiaqiyan@google.com>
Subject: [PATCH v2 2/3] selftests/mm: test userspace MFR for HugeTLB hugepage
From: Jiaqi Yan <jiaqiyan@google.com>
To: nao.horiguchi@gmail.com, linmiaohe@huawei.com, william.roche@oracle.com, 
	harry.yoo@oracle.com
Cc: tony.luck@intel.com, wangkefeng.wang@huawei.com, willy@infradead.org, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com, 
	sidhartha.kumar@oracle.com, ziy@nvidia.com, david@redhat.com, 
	dave.hansen@linux.intel.com, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 50EAB10000B
X-Stat-Signature: jeak9jigrzwzqpghu5ozbghfi94779se
X-HE-Tag: 1763256751-809537
X-HE-Meta: U2FsdGVkX1/OEQBYQ9KZJOiE5vgDo3m4l0tbXTQZav8kBch86NqNEgWGVMqlQUzndnVWVCCJAZSO48ySJMVLLaP/6A4sXiDWWTrP1LGQkcvHmZjswYpi//YAyhtMGyw6zK4Zq0oIUjvVNWQrxuAV0Zqg8w4hxAQtNGTa63vsVf1KsbxuXV3gs8i3qmGLhKUDGBnMm/XCEv4YMGpyppIBYI7PUSygDsn1c6Fo1uSyn2CkW7Q/rc+rone3ac5bQ/k7TADKU8C94TdmQ5oy/pyWKxum5mMX+N4gx4CuNqTYAVQG9fgz2+7YkfwETV7sJS3bL7G8za3mIa4h16SIWNV6zCyGUrTdewLgQ0jV8rz8hDMYCKzMYZSV3PaSX1DLbrzOZhK8GzoCqZbU1aHxsz1bYZ2+Uj2ZT+FhRET3BprSvQqp7XKTbYswpS5rUnVLyxDqUhse+71YW16kLwpkCUFL8M00k1Zb51TMe+3r+8lvLvN6mrRomnQOOKk1xRUqob/tl8cslDxGHcULTmd8c5kmJNfltF/Tyc1O0zw1B1S79k+pU2Bg8U4WLO/0NO3KCrlDayASLLpwuOZNu6bRZHm2koePpeDWzZV76FiwcXIR8aYu57Mfi7p4shnQeXpTzwvFiI8VL29+L8ZJ/pbGIft9tULurD0V+EBFOpYB968EMf1VdAIVhF+BsA102Oj0GoV9IU4nxsiDIvroPu89IBaE0hx+WCaww+DuRvDOFUx3jlYS+/f5WvR3NdluyK9oyZzlKL4pjEh5g6FoPoz4npIjgXh6bte9RrtaB1xX16qytbh+FVy7KCJlSBjHo5Et6MsbL8LCUJVcTvLPfCfsQFVyEXw1edUbRX2VamEVbnri676hcRak773u56wYcCvHn+255QG5jF6VikMVOi/tFtQtSiBO1PzDAH5nVhPyHfnsuj1k2EnAuKv1MpKE6WcfTSRRtVk14lPNzYtdx4cdhD0
 Ik9Ar54t
 ueGf+M/7qKfXl6hPpM7L5KW8geqUk1FdRzs8/XLKAg0K2f2DuvSuAPCnSXQN3JAikKoGjwnQCi0IgubLgn/8Y14OnbTtCeJCf1qAFsnysPuRbwDfAC8BiX/WYenfmRBEitwAXySvkq7KgXH5Pt7TJ7C8KdF/4B2Igt8KC5nPJCR9nxzocbrjynkoFFX77EIHzezUjkiu3XCl/Ho6Ph32nsrg0iW/0jX/3aQKgy9RGGmzbMFJzLEvi8LwBQsHTugBCoEgFHQF/z2uttRcVdvoeA9DGI23wRT+NvuEp+3eE8sLAQBNyEXbbKBPWjmhYuhwJz/XpOsLIEQCgw6+/wTwR+Dh31stJKxL3fm8gCJwZbVkK2FQMWdLRsBGOkVLtwbmxAHDfPnTi7F0+4U1cCVUHpQcI+v7iG1Nlnc88nWlkWeQBglz0TB2eprFy11c445QRDYawA+pj7tIvlozPpPV84yGyH6+u2ynXD6bnpwQMC8ZuNLvs8nF2Dd/csmSJ9673uEshUn+EQDtB0X75bdn8iY/FuKxbh9MLGex2C+Hw9QxZkHObCRaaPefHFeOGQlObFfU/jOCNre5ZQzT+5I2RBX7jGvUA8mDebfph5P7ALBioW7mAtQ0xi8OLu4WgP91cG+5u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Test the userspace memory failure recovery (MFR) policy for HugeTLB
1G or 2M hugepage case:
1. Create a memfd backed by HugeTLB and had MFD_MF_KEEP_UE_MAPPED set.
2. Allocate and map 4 hugepages to the process.
3. Create sub-threads to MADV_HWPOISON inner addresses of one hugepage.
4. Check if the process gets correct SIGBUS for each poisoned raw page.
5. Check if all memory are still accessible and content valid.
6. Check if the poisoned hugepage is dealt with after memfd released.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 tools/testing/selftests/mm/.gitignore    |   1 +
 tools/testing/selftests/mm/Makefile      |   1 +
 tools/testing/selftests/mm/hugetlb-mfr.c | 327 +++++++++++++++++++++++
 3 files changed, 329 insertions(+)
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
index eaf9312097f7b..de3bdcf7914cd 100644
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
diff --git a/tools/testing/selftests/mm/hugetlb-mfr.c b/tools/testing/selftests/mm/hugetlb-mfr.c
new file mode 100644
index 0000000000000..30939b2194188
--- /dev/null
+++ b/tools/testing/selftests/mm/hugetlb-mfr.c
@@ -0,0 +1,327 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Test the userspace memory failure recovery (MFR) policy for HugeTLB
+ * hugepage case:
+ * 1. Create a memfd backed by HugeTLB and MFD_MF_KEEP_UE_MAPPED bit set.
+ * 2. Allocate and map 4 hugepages.
+ * 3. Create sub-threads to MADV_HWPOISON inner addresses of one hugepage.
+ * 4. Check if each sub-thread get correct SIGBUS for the poisoned raw page.
+ * 5. Check if all memory are still accessible and content still valid.
+ * 6. Check if the poisoned hugepage is dealt with after memfd released.
+ *
+ * Two ways to run the test:
+ *   ./hugetlb-mfr 2M
+ * or
+ *   ./hugetlb-mfr 1G
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
+#define EPREFIX			" !!! "
+#define BYTE_LENTH_IN_1G	0x40000000UL
+#define BYTE_LENTH_IN_2M	0x200000UL
+#define HUGETLB_1GB_STR		"1G"
+#define HUGETLB_2MB_STR		"2M"
+#define HUGETLB_FILL		0xab
+
+static const unsigned long offsets_1g[] = {0x200000, 0x400000, 0x800000};
+static const unsigned long offsets_2m[] = {0x020000, 0x040000, 0x080000};
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
+	size_t offsets_count;
+	size_t i;
+
+	if (hugepage_size == BYTE_LENTH_IN_2M) {
+		offsets = offsets_2m;
+		offsets_count = ARRAY_SIZE(offsets_2m);
+	} else {
+		offsets = offsets_1g;
+		offsets_count = ARRAY_SIZE(offsets_1g);
+	}
+
+	for (i = 0; i < offsets_count; ++i) {
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
+int main(int argc, char **argv)
+{
+	int fd;
+	struct statfs file_stat;
+	unsigned long hugepage_size;
+
+	if (argc != 2) {
+		ksft_print_msg("Usage: %s <hugepage_size=1G|2M>\n", argv[0]);
+		return -EINVAL;
+	}
+
+	ksft_print_header();
+	ksft_set_plan(1);
+
+	hugepage_size = parse_hugepage_size(argv[1]);
+	fd = create_hugetlbfs_file(&file_stat, hugepage_size);
+	test_main(fd, hugepage_size);
+
+	ksft_finished();
+}
-- 
2.52.0.rc1.455.g30608eb744-goog


