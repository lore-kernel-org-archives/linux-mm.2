Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B79B1F99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D8C16B025A; Sat, 18 Apr 2026 06:58:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 289446B025C; Sat, 18 Apr 2026 06:58:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 178C96B025D; Sat, 18 Apr 2026 06:58:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 012776B025A
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:58:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8CF9B8939
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:58:06 +0000 (UTC)
X-FDA: 84671376972.26.3545599
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id E7E381A0006
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:58:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="It/k6KBM";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509885; a=rsa-sha256;
	cv=none;
	b=Jq07LvqQCKGBMuVmxhUwlfzCfM15eFi6VJs0AcTtCuhmSU0fOby5gIyrjoZq8TvKCU32k6
	cRRmrD2d2wlfrhbnAPi83QKmAZJ/NyvGApLhBN2+Il8n1z3xUBPCjZjigkizZlkfY1OKhn
	VJTNMCYLxDZxMnY3A/fPPco2rJXjES4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="It/k6KBM";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=trxrsZczV60dAn0Z1D7wD3Y9dkZHSEG05wz/AmCpicw=;
	b=s0PFloSXvFwSLrzeyFSPkdYZxYqjCwpqnGipbtb+zUk1kZyJN4Y2xRZYudizByj4AMn7Vl
	fO7tRYlkSM1Oq0K7n3bf8wsSxIeiLHVoeqOQ9gHU6vE9aeqGx5V1iJFg1QS4sr9/D4Igkt
	1fbgJgxs7Wpn4fBxTVLwBAJwIcJC+d8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 203D340ACB;
	Sat, 18 Apr 2026 10:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D878C2BCB5;
	Sat, 18 Apr 2026 10:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509884;
	bh=UeJw5ciKoR1oIfNgQJJUHN9saCFEfYq++5G6eaf5ttw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=It/k6KBMT4cETTUI0wzvUq1BZ9VwyJSZMyW67/XFayZYfOZ4MbLvwGENxyUXoWHEa
	 Jbjgf2OgGNJEZ5XXQSRTfytJuzJUcezrryfhpVPfLwWL7eu4Ev4O/7o4nuDXmVDKBW
	 EYExD0r20lu5TFjGpETWBmrpL1Vnvhxaqbo5KsFxweDGYwIxn9h5rR15kXOPTiyP88
	 9x3WvefrFbu0Z0NmIIEiu9ZoYNoCYc2j23sBvxCfFpReJsahMnRhetaWH/8IZ6qaqK
	 aGgxStW61lr3vsrzlQ7q46yr5pqsxqOutyEQaBdCrg+17sSbIgofCueb2ZJEvHMutV
	 m3/cVBVw0ticw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 22/53] selftests/mm: move HugeTLB helpers to hugepage_settings
Date: Sat, 18 Apr 2026 13:55:07 +0300
Message-ID: <20260418105539.1261536-23-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: jbo167thbbicqzckjxkdg9bzj5tacrwr
X-Rspam-User: 
X-Rspamd-Queue-Id: E7E381A0006
X-HE-Tag: 1776509884-659867
X-HE-Meta: U2FsdGVkX182Z8FjL3zn37/RLSPReDbHzgtzCgVQSO7l4Cbyr0+2eMIBhAAgxjyZUrba4KDKBEX6qM1XNOWvHOJoveniW69ZrZ3sagBChDEKPAWX+EJoRqfHnQgwBncL/OElH4uXoo5VkQ5EnvIrNgO0V4ZVOZ5zeypitU+E/2pkSrZRdrTnNaIcOsYzojT+TNw2RGid1iVONlsGBe8NSi34SCqvLUnGk2KqdR0X59MTHP2zD2Hu2EF/Ddq9C99S7lmdjgpBruf333jmfDhu6HyGlfX1ktgyu3QxnxnIyU1vlT6Em/TbVhHbjsXVZXL8YlSSXi0hJByRh9tJN9nhLULl++vDt0QXOKCnUP9eBlogc7EEOg9IJD2cA8Tex7NYWk8p97UN1X42P9DHRixJt9dw+fAjtHhJRVlHqnGPOHnyY1HD894VFUpDgUXzVRd45wAvCQ6o4tudH4qUS7WuAGWNID2KdfWbO8u+bn37yDhtG7jqTJ20Sntr06cB5LGhSeX8N/osWukqwq/T3CXzpg50KbUFLLh+eYMDo0eViS29d+vFwZG9YbQZW70jJcRTsWI1W4+vtANm8tN3TULc0hZsGAylqTihAQCXWUBNehCcTiIoiVe8de1NTEOoPZ+D6dwAPmtmLskGSUpT2D222LMOCSNqqdeGZDiNrmntal7X2NzOw6zERjJKFDjhUKK7mqFPfhWIpoDOlIPGiMydRiYrj15OudQBUAeflZ20TB8yxCUwMdSbsAKtYl28qM5fDKRWUKA9s1SK7+R2kwN0bPT6DXTW45eqk4/s+zuYe0rkAbZGdWdsxq7NgahoBBSTnwJaX/iRoxQMX/sp0ud821mqt6lgK64g66zHBZdJKcNkFMuMIEUYVm7u84O8u96r4T7FDaGQO8ST95Z6v9EWETWX6hla5lWHk1UDQioacfz2NNpguPMJ71EARQtB7oC29+7Z9eCghmvowN1d4m7
 mljWVODn
 8ZFxu90HqDNBpRTdmlEy249SI/YMgt6ajnzEcy9cf4pq1x4GUFjie6IX1tq98RXDNoDBElkkFBgDUkPq1m7fE/75DC27hMgvI49tOToHrTiCDTjE7mp+sZ1SoOhI5pjAboHH7+HdQ1E12MyDa6lQqQeJkGtrRDljsVY5nQ71QweKvz4fn5bknJUY/Q6zNdj09QMEohJtdwvm30EhPLvKivAQgMcB7k51D7dDd3ctvrQSwwrUtOi8sxKFILJa/VXC6eVvW9RjAtElXPl5I6s97DTpuIh8c+7EhHPFJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Move library functions that abstract HugeTLB /proc and /sysfs access
from vm_util to hugepage_settings.

This will help creating common helpers that save and restore HugeTLB and
THP settings.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/gup_longterm.c     |  1 +
 tools/testing/selftests/mm/hmm-tests.c        |  2 +-
 .../testing/selftests/mm/hugepage_settings.c  | 68 +++++++++++++++++++
 .../testing/selftests/mm/hugepage_settings.h  |  8 +++
 tools/testing/selftests/mm/hugetlb-madvise.c  |  1 +
 tools/testing/selftests/mm/hugetlb-mmap.c     |  1 +
 tools/testing/selftests/mm/hugetlb-vmemmap.c  |  1 +
 tools/testing/selftests/mm/hugetlb_dio.c      |  1 +
 .../selftests/mm/hugetlb_fault_after_madv.c   |  1 +
 .../selftests/mm/hugetlb_madv_vs_map.c        |  1 +
 tools/testing/selftests/mm/thuge-gen.c        |  1 +
 tools/testing/selftests/mm/uffd-common.h      |  1 +
 .../selftests/mm/va_high_addr_switch.c        |  1 +
 tools/testing/selftests/mm/vm_util.c          | 66 ------------------
 tools/testing/selftests/mm/vm_util.h          |  3 -
 15 files changed, 87 insertions(+), 70 deletions(-)

diff --git a/tools/testing/selftests/mm/gup_longterm.c b/tools/testing/selftests/mm/gup_longterm.c
index f61150d28eb2..ab4eaf4feb7c 100644
--- a/tools/testing/selftests/mm/gup_longterm.c
+++ b/tools/testing/selftests/mm/gup_longterm.c
@@ -29,6 +29,7 @@
 #include "../../../../mm/gup_test.h"
 #include "kselftest.h"
 #include "vm_util.h"
+#include "hugepage_settings.h"
 
 static size_t pagesize;
 static int nr_hugetlbsizes;
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 788689497e92..409b11cad4bc 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -11,6 +11,7 @@
  */
 
 #include "kselftest_harness.h"
+#include "hugepage_settings.h"
 
 #include <errno.h>
 #include <fcntl.h>
@@ -27,7 +28,6 @@
 #include <sys/ioctl.h>
 #include <sys/time.h>
 
-
 /*
  * This is a private UAPI to the kernel test module so it isn't exported
  * in the usual include/uapi/... directory.
diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index 87ecb309b430..ebaa621c45c6 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -1,7 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <dirent.h>
 #include <fcntl.h>
 #include <limits.h>
 #include <signal.h>
+#include <stddef.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -396,3 +398,69 @@ bool thp_is_enabled(void)
 	/* THP is considered enabled if it's either "always" or "madvise" */
 	return mode == 1 || mode == 3;
 }
+
+int detect_hugetlb_page_sizes(size_t sizes[], int max)
+{
+	DIR *dir = opendir("/sys/kernel/mm/hugepages/");
+	int count = 0;
+
+	if (!dir)
+		return 0;
+
+	while (count < max) {
+		struct dirent *entry = readdir(dir);
+		size_t kb;
+
+		if (!entry)
+			break;
+		if (entry->d_type != DT_DIR)
+			continue;
+		if (sscanf(entry->d_name, "hugepages-%zukB", &kb) != 1)
+			continue;
+		sizes[count++] = kb * 1024;
+		ksft_print_msg("[INFO] detected hugetlb page size: %zu KiB\n",
+			       kb);
+	}
+	closedir(dir);
+	return count;
+}
+
+unsigned long default_huge_page_size(void)
+{
+	unsigned long hps = 0;
+	char *line = NULL;
+	size_t linelen = 0;
+	FILE *f = fopen("/proc/meminfo", "r");
+
+	if (!f)
+		return 0;
+	while (getline(&line, &linelen, f) > 0) {
+		if (sscanf(line, "Hugepagesize:       %lu kB", &hps) == 1) {
+			hps <<= 10;
+			break;
+		}
+	}
+
+	free(line);
+	fclose(f);
+	return hps;
+}
+
+unsigned long get_free_hugepages(void)
+{
+	unsigned long fhp = 0;
+	char *line = NULL;
+	size_t linelen = 0;
+	FILE *f = fopen("/proc/meminfo", "r");
+
+	if (!f)
+		return fhp;
+	while (getline(&line, &linelen, f) > 0) {
+		if (sscanf(line, "HugePages_Free:      %lu", &fhp) == 1)
+			break;
+	}
+
+	free(line);
+	fclose(f);
+	return fhp;
+}
diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
index 7748a9009191..320b97e768e8 100644
--- a/tools/testing/selftests/mm/hugepage_settings.h
+++ b/tools/testing/selftests/mm/hugepage_settings.h
@@ -6,6 +6,8 @@
 #include <stddef.h>
 #include <stdint.h>
 
+/* Transparent Huge Pages (THP) */
+
 enum thp_enabled {
 	THP_NEVER,
 	THP_ALWAYS,
@@ -86,4 +88,10 @@ unsigned long thp_shmem_supported_orders(void);
 bool thp_available(void);
 bool thp_is_enabled(void);
 
+/* HugeTLB */
+
+int detect_hugetlb_page_sizes(size_t sizes[], int max);
+unsigned long default_huge_page_size(void);
+unsigned long get_free_hugepages(void);
+
 #endif /* __THP_SETTINGS_H__ */
diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
index 4c6c346a3af5..316384d919db 100644
--- a/tools/testing/selftests/mm/hugetlb-madvise.c
+++ b/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -20,6 +20,7 @@
 #include <fcntl.h>
 #include "vm_util.h"
 #include "kselftest.h"
+#include "hugepage_settings.h"
 
 #define MIN_FREE_PAGES	20
 #define NR_HUGE_PAGES	10	/* common number of pages to map/allocate */
diff --git a/tools/testing/selftests/mm/hugetlb-mmap.c b/tools/testing/selftests/mm/hugetlb-mmap.c
index c0d58dd7cbf6..3a7dd630f425 100644
--- a/tools/testing/selftests/mm/hugetlb-mmap.c
+++ b/tools/testing/selftests/mm/hugetlb-mmap.c
@@ -17,6 +17,7 @@
 #include <fcntl.h>
 #include "vm_util.h"
 #include "kselftest.h"
+#include "hugepage_settings.h"
 
 #define LENGTH (256UL*1024*1024)
 #define PROTECTION (PROT_READ | PROT_WRITE)
diff --git a/tools/testing/selftests/mm/hugetlb-vmemmap.c b/tools/testing/selftests/mm/hugetlb-vmemmap.c
index 485a6978b40f..af5786bebfd1 100644
--- a/tools/testing/selftests/mm/hugetlb-vmemmap.c
+++ b/tools/testing/selftests/mm/hugetlb-vmemmap.c
@@ -11,6 +11,7 @@
 #include <sys/mman.h>
 #include <fcntl.h>
 #include "vm_util.h"
+#include "hugepage_settings.h"
 
 #define PAGE_COMPOUND_HEAD	(1UL << 15)
 #define PAGE_COMPOUND_TAIL	(1UL << 16)
diff --git a/tools/testing/selftests/mm/hugetlb_dio.c b/tools/testing/selftests/mm/hugetlb_dio.c
index 31a054fa8134..81e3f7bc8e76 100644
--- a/tools/testing/selftests/mm/hugetlb_dio.c
+++ b/tools/testing/selftests/mm/hugetlb_dio.c
@@ -20,6 +20,7 @@
 #include <sys/syscall.h>
 #include "vm_util.h"
 #include "kselftest.h"
+#include "hugepage_settings.h"
 
 #ifndef STATX_DIOALIGN
 #define STATX_DIOALIGN		0x00002000U
diff --git a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
index b4b257775b74..abc3904c5268 100644
--- a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
+++ b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
@@ -10,6 +10,7 @@
 
 #include "vm_util.h"
 #include "kselftest.h"
+#include "hugepage_settings.h"
 
 #define INLOOP_ITER 100
 
diff --git a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
index c7105c6d319b..ac60b4f18784 100644
--- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
+++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -25,6 +25,7 @@
 #include <unistd.h>
 
 #include "vm_util.h"
+#include "hugepage_settings.h"
 
 #define INLOOP_ITER 100
 
diff --git a/tools/testing/selftests/mm/thuge-gen.c b/tools/testing/selftests/mm/thuge-gen.c
index 77813d34dcc2..1007bc8aa57c 100644
--- a/tools/testing/selftests/mm/thuge-gen.c
+++ b/tools/testing/selftests/mm/thuge-gen.c
@@ -28,6 +28,7 @@
 #include <string.h>
 #include "vm_util.h"
 #include "kselftest.h"
+#include "hugepage_settings.h"
 
 #if !defined(MAP_HUGETLB)
 #define MAP_HUGETLB	0x40000
diff --git a/tools/testing/selftests/mm/uffd-common.h b/tools/testing/selftests/mm/uffd-common.h
index 844a85ab31eb..6c5aca9cb63e 100644
--- a/tools/testing/selftests/mm/uffd-common.h
+++ b/tools/testing/selftests/mm/uffd-common.h
@@ -37,6 +37,7 @@
 
 #include "kselftest.h"
 #include "vm_util.h"
+#include "hugepage_settings.h"
 
 #define UFFD_FLAGS	(O_CLOEXEC | O_NONBLOCK | UFFD_USER_MODE_ONLY)
 
diff --git a/tools/testing/selftests/mm/va_high_addr_switch.c b/tools/testing/selftests/mm/va_high_addr_switch.c
index 5741fd057640..d42ad50eb2d3 100644
--- a/tools/testing/selftests/mm/va_high_addr_switch.c
+++ b/tools/testing/selftests/mm/va_high_addr_switch.c
@@ -11,6 +11,7 @@
 
 #include "vm_util.h"
 #include "kselftest.h"
+#include "hugepage_settings.h"
 
 /*
  * The hint addr value is used to allocate addresses
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index db94564f4431..e62e2a473123 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -291,53 +291,6 @@ int64_t allocate_transhuge(void *ptr, int pagemap_fd)
 	return -1;
 }
 
-unsigned long default_huge_page_size(void)
-{
-	unsigned long hps = 0;
-	char *line = NULL;
-	size_t linelen = 0;
-	FILE *f = fopen("/proc/meminfo", "r");
-
-	if (!f)
-		return 0;
-	while (getline(&line, &linelen, f) > 0) {
-		if (sscanf(line, "Hugepagesize:       %lu kB", &hps) == 1) {
-			hps <<= 10;
-			break;
-		}
-	}
-
-	free(line);
-	fclose(f);
-	return hps;
-}
-
-int detect_hugetlb_page_sizes(size_t sizes[], int max)
-{
-	DIR *dir = opendir("/sys/kernel/mm/hugepages/");
-	int count = 0;
-
-	if (!dir)
-		return 0;
-
-	while (count < max) {
-		struct dirent *entry = readdir(dir);
-		size_t kb;
-
-		if (!entry)
-			break;
-		if (entry->d_type != DT_DIR)
-			continue;
-		if (sscanf(entry->d_name, "hugepages-%zukB", &kb) != 1)
-			continue;
-		sizes[count++] = kb * 1024;
-		ksft_print_msg("[INFO] detected hugetlb page size: %zu KiB\n",
-			       kb);
-	}
-	closedir(dir);
-	return count;
-}
-
 int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags)
 {
 	size_t count;
@@ -396,25 +349,6 @@ int uffd_unregister(int uffd, void *addr, uint64_t len)
 	return ret;
 }
 
-unsigned long get_free_hugepages(void)
-{
-	unsigned long fhp = 0;
-	char *line = NULL;
-	size_t linelen = 0;
-	FILE *f = fopen("/proc/meminfo", "r");
-
-	if (!f)
-		return fhp;
-	while (getline(&line, &linelen, f) > 0) {
-		if (sscanf(line, "HugePages_Free:      %lu", &fhp) == 1)
-			break;
-	}
-
-	free(line);
-	fclose(f);
-	return fhp;
-}
-
 static bool check_vmflag(void *addr, const char *flag)
 {
 	char buffer[MAX_LINE_LENGTH];
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 1a07305ceff4..195bf2e26792 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -94,8 +94,6 @@ bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size);
 bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size);
 bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size);
 int64_t allocate_transhuge(void *ptr, int pagemap_fd);
-unsigned long default_huge_page_size(void);
-int detect_hugetlb_page_sizes(size_t sizes[], int max);
 int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
 
 int uffd_register(int uffd, void *addr, uint64_t len,
@@ -103,7 +101,6 @@ int uffd_register(int uffd, void *addr, uint64_t len,
 int uffd_unregister(int uffd, void *addr, uint64_t len);
 int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
 			      bool miss, bool wp, bool minor, uint64_t *ioctls);
-unsigned long get_free_hugepages(void);
 bool check_vmflag_io(void *addr);
 bool check_vmflag_pfnmap(void *addr);
 bool check_vmflag_guard(void *addr);
-- 
2.53.0


