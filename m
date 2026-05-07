Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC980CD3442
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 07:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 405D16B008C; Thu,  7 May 2026 03:06:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DD1E6B0092; Thu,  7 May 2026 03:06:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CC0A6B0093; Thu,  7 May 2026 03:06:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1E0486B008C
	for <linux-mm@kvack.org>; Thu,  7 May 2026 03:06:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C296C1C0E65
	for <linux-mm@kvack.org>; Thu,  7 May 2026 07:06:17 +0000 (UTC)
X-FDA: 84739739994.19.3DAE4DB
Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com [209.85.215.195])
	by imf08.hostedemail.com (Postfix) with ESMTP id D802D160010
	for <linux-mm@kvack.org>; Thu,  7 May 2026 07:06:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fVk2fDje;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.215.195 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778137575; a=rsa-sha256;
	cv=none;
	b=viQ1mypZ7wF9fs4CPBghfBJN39F6G7x2peLK5/YuRI7TTa8c6D15dxqJn8azcrwKz5c3Iy
	bxBhxZX1ablKou1LBAe0lIBJEyCs1uxu2yzBLOVHCys+yYCeNdrwtL6BGLtGbFEEVGwTCl
	g+MdyPMuZVZ1ecj9eUt3/Vcj8S/Iz8Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fVk2fDje;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.215.195 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778137575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dgv2EkYfGFbvZ1PGx8KpTzNURorGBePyogLOLYsqDZY=;
	b=QXFQPqe191kF7gWsAZjAjIpTXcRe9JmPE/mF6kmO1HzsAJrMq8S2HB/BTg4DTUom3P6Z9w
	40sVzPKFZNpTayXjMyRctoaWUXIV9hWxXLyWQviEy9dGiIzORhtkLrruuOfi2iU8ayVQap
	ghwtnoXZErNH2xTz5g37TYr/7JTbS0c=
Received: by mail-pg1-f195.google.com with SMTP id 41be03b00d2f7-c70e27e2b74so156924a12.0
        for <linux-mm@kvack.org>; Thu, 07 May 2026 00:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778137575; x=1778742375; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dgv2EkYfGFbvZ1PGx8KpTzNURorGBePyogLOLYsqDZY=;
        b=fVk2fDjeZCEaBuNla8HAw8SeObW5UcMJrVijNUcD1HyaD85Wv3RJqsmmW09RPT6mHE
         RwpHyHawsWb2aium0j9Wq+H6uABzKimAVPqQft+524lL/Nc2zoV1KzK1Upd4o8odzSm+
         44UR84gz3ByeGVJ4A0YFOqcE3x40AydI+uLq6WxJNqPwyE605lwphIfhHHcFfSbBZHsX
         ZhIVK2Vv0VeIQb/zZQs2BJeDxh00uPjyVsWL7bxBbY1MsGZwp5wqsJVDdS8qvl3Si1ww
         vqf3U+jJWTvuKRLiSZYCruQP2K3yR62tNRZRlNgiCgnIoW2G+CEugxJXW1fg7kkKoOr3
         5qkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778137575; x=1778742375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Dgv2EkYfGFbvZ1PGx8KpTzNURorGBePyogLOLYsqDZY=;
        b=CQCpfXlvvqQJQq8uk+spxqvOOWjByHgErZHdS6njvWr9Cs9CGiR8tg5dN+xblX3oEl
         EszkGPSq9Y1jHo3BhMYpJPLOA47e6tEqSr0xd/W2c3ICmV3fGkcNgj84YVEPMKGuXUYQ
         XJ75ear6Vaa0MAT7GBR0IBtmz3PLgyAZhkOTDy9Yd4MWtHzdff8Ftatn7s20dfWNSMOD
         nj3kpqz+xb9N2XE1TD7MbJhHYl58PPbZ3IM4felR+APZt0Nqo3vyhUs9+a0gCmiJPpVF
         My9wuiXZQLZ3XLBiEFsaXJ3QfFuGfd8mmWfmui7vY3OSGIqzgVUglvm/jrW1LmLYcK4c
         hIZw==
X-Forwarded-Encrypted: i=1; AFNElJ88WbvtDr5T9FMv2s6HsBBmNuZmf2Dcg764ExLpuZc7YXvw+QFI/sfmQWi9Iq2ya2N+mD2qlfyIDw==@kvack.org
X-Gm-Message-State: AOJu0YxWTsrCLb8HhB4ku0fWrCEl7yy7dx3ipYuT1t7cIcsak5AOMajL
	6zdYDDNw8GtrWBLHrY0IBiJsukNlbp640vN2Ak/a2ZnD1AqGdJc0+90x
X-Gm-Gg: AeBDietZ+ifC2ukYdTHPlQNCYf8DATVu84FO4mVqlziutyPT7pHGrv5bzeCgyTNHB6w
	jAjax3gpsiLthJ7dNJaKosRQZje9iRERysBCs3svGvsI6w/5k7seTb+6m+ERYesDUPXBYELK5sg
	FjgagXzqq+dyvDVhSWWVborwy8zbieFjxLS0KxiIovLvHI7r9CFU+f0sy3Xj4wuh8kILDs0QODT
	4u/j4EuElvb/lHplYd1OKmG7YB+3yoA66jyU2Fnk7/0jr1VH78weZGegtjvbO4hU8HcbVx96Quv
	2n9WwA9vcBS3JmUFdFrTR/4kA398GgscyWucGY6Mxm55hVE+169nAMDFCF9beu5znUGd+V96ImE
	QowvR1hyNhuAYBEDWwGthVbj2OG/u+kFoY3YvK+mnI6N2pjCbJJzmGnDR09NQPs0Eiuc7DAu7FU
	tsBnjT+kz87I+QQpIsWwA4so1+ex3XRMTWxnMTOYzc+3eZY+qu
X-Received: by 2002:a05:6a20:258c:b0:3a8:9dd:75c6 with SMTP id adf61e73a8af0-3aa5ac5fca1mr7408664637.51.1778137574565;
        Thu, 07 May 2026 00:06:14 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c825379099bsm1200164a12.14.2026.05.07.00.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 00:06:14 -0700 (PDT)
From: Chen Wandun <chenwandun1@gmail.com>
X-Google-Original-From: Chen Wandun <chenwandun@lixiang.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	shuah@kernel.org,
	zokeefe@google.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 2/2] selftests/mm: add MADV_COLLAPSE sub-PMD range tests
Date: Thu,  7 May 2026 15:05:58 +0800
Message-ID: <20260507070558.3064142-3-chenwandun@lixiang.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260507070558.3064142-1-chenwandun@lixiang.com>
References: <20260507070558.3064142-1-chenwandun@lixiang.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4tbixmfynk7eqpezhwj1ypbfqq8e3c4h
X-Rspam-User: 
X-Rspamd-Queue-Id: D802D160010
X-Rspamd-Server: rspam07
X-HE-Tag: 1778137575-132992
X-HE-Meta: U2FsdGVkX19xsyBKhqDLiiddzPHkRYzgj0pdcXN/DIFgcFmgcPiU7/jlY62amEBRzUHJhEnydLAg3CSAMpm/vl1N4DHsiQRU8wSFPf/PCQrs4p9PCDD5S2rm/daURS3a1anNGgZtpuB4kfwUfYofY98GH42kwcgF9BrA0S0wiL2AbcDPAr205xzNXPwzN4CNVUCQnJh0FdwI3J0b1PsK+wKjZybPL8xORhc/0rZ+ck4vfBNokgk2bB4XZY1IRIrkjoFE30weim87dhocy0pM6Bg4ggPIJZurg/N5AqA4FgoWw+lCzp8z7K4ouvhetTgeJPzktGTPjqoc90uWEkYNKMZ5mAXilI1ETmICA+Wh/h9n2cUKNG/JCH6vcMcJUxOfRmRqZCeY/unPzJvqSdms9I3IFb2EET5CX5qqavKBr6Wob2fpqkanhnPVHzoxXbTcatHEPs9bU6MbtmxNp9tIwOVyxEbenEwKOcVSFvjWFUQYddcZQukAPNSXyLxTXS+Q1CUWFSLGSr7x0iZopu6urz89FYikb3ZVkejw6blOzLO9FWcYX4sSJ5nx0xOHfBkbGvHX29M/jCDHWFEVpamkzUsEZq+misMKMsqYDAzt9mma6/U0vxc5EZb0W/INCw5kgljuca7sG/i0QN0e7O9hTxU2UBKLtn8ikE6kftd9aMhlyIWT+KmGqK+rqSVtm4gl+FPUD4CtAHkU2ZF9hBm+4mo+oBTcE61JE2AwXhgyRTW8P85KFaxM0iXtS4XJxsvCneNqsdR66IiPifnlvNR5mnawaAwMqCbLa68FtrlyULOJ22A5Wy3g5FnYoK7QrLEP/YZx3u/0ED9WzvX9jRa5QWSfCnB9+Zp3RnK2VmLXXHhDutlqtrEzYlG5NgnmDe03S41H6M1KXFn2+nLVCGrSvbIyRobWOr7w5FJlF3mhTaS/u9DMuODoV4po46CmtKuU2TUx6ToCKoZjk5CamRi
 dRUUet+Z
 n6CCyiNp7l0+osKMl3V/jiIwyky2sGkqeoTftC2O1WBKX2J3zCEhxHnm8H3Ylwxjl9oU9fRZiBmBfhpxbXVNzLSEnAnM0PO4m4VD4QPoxXmG1f0Pj86bwWruMyFAxX+e/lvC17zU+r0Gt+N0sSWxft6/PyiWIdj5SEkoJkof2BxVxpL6iAQ8Fqw4nRv4UH0KRZZT1LVKvJi5rSAIwZcxBOroCdLmYzQPMSCzjJ/2iCS8oNadReCS3kIrnU9+j5lzsSCPYg8nBIIv+xsp/qBi+GJfFa/sTPk6qDkW/ka73wGBC1MYZ+Ww9zTw5TT6AFwWTrDz5E5VgWkfoAr547VG3buAcRh061nONNhtX1nVWUMB9CbcLLMuCQVUR3SgRtbTyri7ulgg+/5TkUcGX9EqLhKiR5gqRABt7WRmhqfUyDSmIIDPI4b1z45csRscb93gXl2MgMO5Li3ph5Smrlk/v4mIfuOxZBYriWNGMp4oFg0m5QTZSq+f2HoV0DMDHfbhXoLbHczoEw37fWUAVe4ineqjDPJkgYnwShKO2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add madv_collapse_range to verify the fix for the spurious -EINVAL
returned by madvise_collapse() when the madvised range contains no
complete PMD-aligned window.

madvise_collapse() rounds the caller range inward to PMD boundaries:

  hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK  // round up
  hend   =  end   &  HPAGE_PMD_MASK                    // round down

When hstart >= hend there is no PMD window to collapse.  Previously
the final expression computed (hend - hstart) without guarding against
hstart > hend, causing unsigned wrap-around and a spurious -EINVAL.
Both tests expect 0: "no PMD window to collapse" is a successful no-op.

  Test 1 - aligned start (hstart == hend):
    start = 2MiB-aligned, len = PAGE_SIZE
    Both hstart and hend round to the same 2MiB boundary.
    Was already correct; included as a regression reference.

  Test 2 - unaligned start (hstart > hend):
    start = aligned + PAGE_SIZE, len = PAGE_SIZE
    hstart rounds up past the next 2MiB boundary while hend rounds
    down below start.  (hend - hstart) wrapped unsigned, causing the
    final comparison to fail and return -EINVAL instead of 0.

Signed-off-by: Chen Wandun <chenwandun@lixiang.com>
---
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   2 +
 .../selftests/mm/ksft_madv_collapse.sh        |   4 +
 .../selftests/mm/madv_collapse_range.c        | 141 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   5 +
 5 files changed, 153 insertions(+)
 create mode 100755 tools/testing/selftests/mm/ksft_madv_collapse.sh
 create mode 100644 tools/testing/selftests/mm/madv_collapse_range.c

diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index b0c30c5ee9e3..a24f8c3cf3dc 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -28,6 +28,7 @@ protection_keys
 protection_keys_32
 protection_keys_64
 madv_populate
+madv_collapse_range
 uffd-stress
 uffd-unit-tests
 uffd-wp-mremap
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index cd24596cdd27..758639f8ae8e 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -68,6 +68,7 @@ TEST_GEN_FILES += hugepage-mremap
 TEST_GEN_FILES += hugepage-shm
 TEST_GEN_FILES += hugepage-vmemmap
 TEST_GEN_FILES += khugepaged
+TEST_GEN_FILES += madv_collapse_range
 TEST_GEN_FILES += madv_populate
 TEST_GEN_FILES += map_fixed_noreplace
 TEST_GEN_FILES += map_hugetlb
@@ -153,6 +154,7 @@ TEST_PROGS += ksft_hugetlb.sh
 TEST_PROGS += ksft_hugevm.sh
 TEST_PROGS += ksft_ksm.sh
 TEST_PROGS += ksft_ksm_numa.sh
+TEST_PROGS += ksft_madv_collapse.sh
 TEST_PROGS += ksft_madv_guard.sh
 TEST_PROGS += ksft_madv_populate.sh
 TEST_PROGS += ksft_memfd_secret.sh
diff --git a/tools/testing/selftests/mm/ksft_madv_collapse.sh b/tools/testing/selftests/mm/ksft_madv_collapse.sh
new file mode 100755
index 000000000000..0d0b0356cbd0
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_madv_collapse.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t madv_collapse
diff --git a/tools/testing/selftests/mm/madv_collapse_range.c b/tools/testing/selftests/mm/madv_collapse_range.c
new file mode 100644
index 000000000000..11850be80dd8
--- /dev/null
+++ b/tools/testing/selftests/mm/madv_collapse_range.c
@@ -0,0 +1,141 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Tests for MADV_COLLAPSE behavior when the madvise range contains no
+ * complete PMD-aligned window (range smaller than 2 MiB).
+ *
+ * madvise_collapse() rounds the caller range inward to PMD boundaries:
+ *
+ *   hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK  // round up
+ *   hend   =  end   &  HPAGE_PMD_MASK                    // round down
+ *
+ * When hstart >= hend the collapsing loop is not entered.  Previously,
+ * the final return expression computed (hend - hstart) without guarding
+ * against hstart > hend, causing unsigned wrap-around and a spurious
+ * -EINVAL.  Both tests expect 0: "no PMD window to collapse" is a
+ * successful no-op, not an error.
+ *
+ * Test 1: aligned start (hstart == hend):
+ *   start = 2MiB-aligned, len = PAGE_SIZE
+ *   hstart = aligned, hend = aligned  ->  0 == 0  ->  0  (was already correct)
+ *
+ * Test 2: unaligned start (hstart > hend):
+ *   start = aligned + PAGE_SIZE, len = PAGE_SIZE
+ *   hstart = aligned + 2MiB, hend = aligned
+ *   (hend - hstart) wraps unsigned  ->  was -EINVAL, fixed to 0
+ */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <linux/mman.h>
+
+#include "kselftest.h"
+#include "vm_util.h"
+
+#ifndef MADV_COLLAPSE
+#define MADV_COLLAPSE	25
+#endif
+
+static unsigned long	page_size;
+static unsigned long	hpage_size;
+
+/*
+ * Test 1: 2MiB-aligned start, len = PAGE_SIZE.
+ *   hstart == hend  ->  0
+ */
+static void test_subpmd_aligned(char *aligned)
+{
+	int ret;
+
+	ksft_print_msg("[RUN] sub-PMD: 2MiB-aligned start, len=PAGE_SIZE\n");
+	ret = madvise(aligned, page_size, MADV_COLLAPSE);
+	ksft_test_result(ret == 0,
+			 "sub-PMD aligned start returns 0 (ret=%d errno=%d)\n",
+			 ret, ret ? errno : 0);
+}
+
+/*
+ * Test 2: start = aligned + PAGE_SIZE, len = PAGE_SIZE.
+ *   hstart = aligned + hpage_size  >  hend = aligned
+ *   unsigned wrap was -EINVAL; correct answer is 0.
+ */
+static void test_subpmd_unaligned(char *aligned)
+{
+	int ret;
+
+	ksft_print_msg("[RUN] sub-PMD: unaligned start (aligned+PAGE), len=PAGE_SIZE\n");
+	ksft_print_msg("      hstart=%p > hend=%p\n",
+		       (void *)(aligned + hpage_size), (void *)aligned);
+
+	ret = madvise(aligned + page_size, page_size, MADV_COLLAPSE);
+	if (ret && errno == EINVAL)
+		ksft_print_msg("      got -EINVAL: unsigned-wrap bug not fixed\n");
+	ksft_test_result(ret == 0,
+			 "sub-PMD unaligned start returns 0 (ret=%d errno=%d)\n",
+			 ret, ret ? errno : 0);
+}
+
+int main(void)
+{
+	char *base, *aligned;
+	unsigned long map_size;
+	int probe_ret;
+
+	ksft_print_header();
+	ksft_set_plan(2);
+
+	page_size  = (unsigned long)getpagesize();
+	hpage_size = (unsigned long)read_pmd_pagesize();
+	if (!hpage_size)
+		ksft_exit_skip("transparent hugepages not available\n");
+
+	/*
+	 * Probe: map one hpage-sized region, touch all pages, and attempt a
+	 * real collapse to confirm MADV_COLLAPSE is supported.  EAGAIN is a
+	 * transient resource failure and still counts as "available".
+	 */
+	map_size = 2 * hpage_size;
+	base = mmap(NULL, map_size, PROT_READ | PROT_WRITE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (base == MAP_FAILED)
+		ksft_exit_fail_msg("probe mmap failed: %s\n", strerror(errno));
+
+	aligned = (char *)(((unsigned long)base + hpage_size - 1)
+			   & ~(hpage_size - 1));
+
+	for (unsigned long i = 0; i < hpage_size; i += page_size)
+		aligned[i] = 0;
+
+	probe_ret = madvise(aligned, hpage_size, MADV_COLLAPSE);
+	munmap(base, map_size);
+	if (probe_ret && errno != EAGAIN)
+		ksft_exit_skip("MADV_COLLAPSE not available: %s\n",
+			       strerror(errno));
+
+	/*
+	 * Both sub-PMD tests share a single 2 * hpage mapping so that
+	 * every test range falls within the same VMA.
+	 */
+	map_size = 2 * hpage_size;
+	base = mmap(NULL, map_size, PROT_READ | PROT_WRITE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (base == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed: %s\n", strerror(errno));
+
+	for (unsigned long i = 0; i < map_size; i += page_size)
+		base[i] = 0;
+
+	aligned = (char *)(((unsigned long)base + hpage_size - 1)
+			   & ~(hpage_size - 1));
+
+	test_subpmd_aligned(aligned);
+	test_subpmd_unaligned(aligned);
+
+	munmap(base, map_size);
+
+	if (ksft_get_fail_cnt())
+		ksft_exit_fail_msg("%d out of %d tests failed\n",
+				   ksft_get_fail_cnt(), ksft_test_num());
+	ksft_exit_pass();
+}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d8468451b3a3..58402f8261e0 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -53,6 +53,8 @@ separated by spaces:
 	test madvise(2) MADV_GUARD_INSTALL and MADV_GUARD_REMOVE options
 - madv_populate
 	test memadvise(2) MADV_POPULATE_{READ,WRITE} options
+- madv_collapse
+	test madvise(2) MADV_COLLAPSE sub-PMD range handling
 - memfd_secret
 	test memfd_secret(2)
 - process_mrelease
@@ -422,6 +424,9 @@ CATEGORY="madv_guard" run_test ./guard-regions
 # MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
 CATEGORY="madv_populate" run_test ./madv_populate
 
+# MADV_COLLAPSE sub-PMD range tests
+CATEGORY="madv_collapse" run_test ./madv_collapse_range
+
 # PROCESS_MADV test
 CATEGORY="process_madv" run_test ./process_madv
 
-- 
2.43.0


