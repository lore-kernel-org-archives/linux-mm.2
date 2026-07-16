Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58620C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:59:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21B7D6B0107; Thu, 16 Jul 2026 10:59:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F28B6B0108; Thu, 16 Jul 2026 10:59:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BA836B0109; Thu, 16 Jul 2026 10:59:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1C7B6B0108
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:59:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D51AEA00C1
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:33:20 +0000 (UTC)
X-FDA: 84994580160.01.372A3E2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0D7D6100003
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:33:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=m0SrIZQI;
	spf=pass (imf14.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784205199;
	b=urfYfr6Xs1kbLCp5dx9lvPQb/G+qutvReV5DgCn6WmxmPnyE7oKuahmXi+pdbVJNx3Nxoj
	0mVdQq2TJ79WCyAymOMRmGXkx9CpzsYrg5z5wXg//6enqGJZWqZ34uxTVEgj6qG/xjnprP
	pjfOrg258WtvL9wz6pmqaNPhYGFKihg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=m0SrIZQI;
	spf=pass (imf14.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784205199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EQPm+kdVyZgPfxh8wdJFPs8aVUOO7usEgUuh2ctJfVs=;
	b=T3AXpopS/VBoQ9oLKEEOKqLV065otZojH753g+5gOCGDaw6df6JHZ0CcYqclrJTYqZu4pr
	zRuNBqbQdSJH6K78AntKscbnZLuK0NuopZJxdeXgZH5BDf0RCKH4tzMtDIVO6qGKmy6lyd
	tbxV0HIKwvnRIdSLPKcuhtYFGTDZkF8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E8AD81692;
	Thu, 16 Jul 2026 05:33:13 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 81BB33F7B4;
	Thu, 16 Jul 2026 05:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784205198; bh=X/Zrpx0x5j7vRtWU6bIcEFkLSIIChKR2jfh3+vF5C78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0SrIZQIKdhBR8zP16m0aSLRZtln/WjqZ0vRJ9roWwZnfkJoOZjbNVCAvNj1rjakV
	 VmT0I+67OEEKNB9wMpUAkqhPc4J8vr3e00lercJGJVLU8NE4uRU8hRlMmUaLJ5eDnt
	 2VHcTyg18vyQ5kGuykhiEb850yCFSXMh+GLsf1yE=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Mark Brown <broonie@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v5 3/5] tools/lib/mm: move hugepage_settings out of selftests
Date: Thu, 16 Jul 2026 18:02:24 +0530
Message-ID: <20260716123226.197736-4-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260716123226.197736-1-sarthak.sharma@arm.com>
References: <20260716123226.197736-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0D7D6100003
X-Stat-Signature: ibzpgixg3gyaibikdxxq7dn4cgxa14ug
X-HE-Tag: 1784205198-844958
X-HE-Meta: U2FsdGVkX18/T4clYY22fNRdhltvqYZ/XOzwLvfNoFEBMGotAp/yLNkn4zTnbo9Ck+3uxjDlYfr3xdj/ORHg0153DzwclZaRgFnIEM5N4wuN9u9SO0URqydVZxdbsL4JaREdyWaEEmixbhRBN8MzOcvJ4WK2RPkm2zYp3ja4meS8OdPj/BjelwOBq6RTwrILm1q+7i1i/8NmjKtbaE0mrgStSS7koqv7pTKA+DgF+ws8bDkA2gouygcPqDk/M2RT7SyVEYTuPSTr0WINA++aNkWm81S7AUibzYlU6k9t52VmBNN831uP3MH65U6ylw60J3PD1wmEhFgwMQWajXP+bawBfp3vWuDedFBsDAE9O6NiqfjpRAznrqirfsBwdkS0kORdsXxqj31hQKxzq6WQ/0jANUxiSM0EeXC2wKbCD8dcW2MqZgXYFTrm638e14/8YXnLusxbM3c1KYVjmj6Kb+kgKtBwzDdFQErQqJsexBIrhNkMtTMOq0fJbticjMCRq2EfglEkSDWKFt2WtZehyZoW7ZOcM2PYnAIOHSfLBMmDzF3DSFIIgUEF256aIJMGjRApL95Mg8ZKLRaLIrNnCbhRNaYw+cag7FGnSUfeJAh3/NPV2tks2ha+0kj4fN/QCom9gCeUzdN12mWkYzgO2MZh8STmzunK1j/k/yJpz9hQ7P5PxeVrhMi7zLNU6r4LyA+ce5YMTSIQh/9URtBgLIqxEnA6vevDMX6WSCUhSZUy6QzhN11Rj0qtiY0L2C+Fv5428Iff2FSU5IevYmjAQsBv2udlbgm2Ek6+0eEhXDSrchA4otJWsljoGzsezDsDLr86xs2CmoasLANIqv8Me1UCSOTrF/t0blovP+Lm7sHLsGrThKGQlcHtaOJYnCMzJCf7b7ljPGqxit180cpeTBkG97Hif0ygJ35KbYUTyK7vi/49HpBaLA8IW72ShL6EAhfphB2k1xRLZGThYhi
 2MPG1tbi
 FJrp8T4umAdgUhqdtgE+YTbE8aflwrhXJx+KoE127TpSBT7PRRrplbCQ9kYrZ1RriZogFmi8+248cJFgva9iHT4XJ9FAvfbwXxsJkGHU8mea3OK+qSCx916i9p785aPWbnbWCfSpU65QcHvsWk0T4FPa3NvT7MOPWVY4c8IuiceOZYM4csT5wmRN4t3Oi+PfB/OwHRZ4JItBWOatXiR9rxBWkNrR/XKVgSIFjSK7HSa8mCCbyh1UvTlwY2z6B+Umj5j1wVbnxcV3aFmQeRnQLfyA4SK7yGOTZZR9/E92mkmelFoc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move hugepage_settings.[ch] from tools/testing/selftests/mm/ to
tools/lib/mm/ so the THP and HugeTLB helpers can be shared more easily
between selftests and other tools.

Keep the helpers exposed to mm selftests through vm_util.h where possible,
and use direct <mm/hugepage_settings.h> includes for users that do not
include vm_util.h. Adjust the selftests/mm build to compile the moved
implementation from its new location.

Remove the remaining kselftest dependency from hugepage_settings.c by
replacing ksft_print_msg() calls with TAP comment style printf()
diagnostics.

Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 .../selftests => lib}/mm/hugepage_settings.c    | 17 ++++++++++++-----
 .../selftests => lib}/mm/hugepage_settings.h    |  0
 tools/testing/selftests/mm/Makefile             |  6 ++++--
 tools/testing/selftests/mm/compaction_test.c    |  2 +-
 tools/testing/selftests/mm/cow.c                |  1 -
 .../selftests/mm/folio_split_race_test.c        |  1 -
 tools/testing/selftests/mm/guard-regions.c      |  1 -
 tools/testing/selftests/mm/gup_longterm.c       |  1 -
 tools/testing/selftests/mm/gup_test.c           |  1 -
 tools/testing/selftests/mm/hmm-tests.c          |  6 +++---
 tools/testing/selftests/mm/hugetlb-madvise.c    |  1 -
 tools/testing/selftests/mm/hugetlb-mmap.c       |  1 -
 tools/testing/selftests/mm/hugetlb-mremap.c     |  1 -
 tools/testing/selftests/mm/hugetlb-shm.c        |  1 -
 .../testing/selftests/mm/hugetlb-soft-offline.c |  2 +-
 tools/testing/selftests/mm/hugetlb-vmemmap.c    |  1 -
 tools/testing/selftests/mm/hugetlb_dio.c        |  1 -
 .../selftests/mm/hugetlb_fault_after_madv.c     |  1 -
 .../testing/selftests/mm/hugetlb_madv_vs_map.c  |  1 -
 tools/testing/selftests/mm/khugepaged.c         |  1 -
 tools/testing/selftests/mm/ksm_tests.c          |  1 -
 tools/testing/selftests/mm/migration.c          |  5 ++---
 tools/testing/selftests/mm/pagemap_ioctl.c      |  1 -
 tools/testing/selftests/mm/prctl_thp_disable.c  |  1 -
 tools/testing/selftests/mm/protection_keys.c    |  2 +-
 tools/testing/selftests/mm/soft-dirty.c         |  1 -
 .../testing/selftests/mm/split_huge_page_test.c |  1 -
 tools/testing/selftests/mm/thuge-gen.c          |  1 -
 tools/testing/selftests/mm/transhuge-stress.c   |  1 -
 tools/testing/selftests/mm/uffd-common.h        |  1 -
 tools/testing/selftests/mm/uffd-wp-mremap.c     |  2 +-
 .../testing/selftests/mm/va_high_addr_switch.c  |  1 -
 tools/testing/selftests/mm/vm_util.h            |  1 +
 33 files changed, 26 insertions(+), 40 deletions(-)
 rename tools/{testing/selftests => lib}/mm/hugepage_settings.c (97%)
 rename tools/{testing/selftests => lib}/mm/hugepage_settings.h (100%)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/lib/mm/hugepage_settings.c
similarity index 97%
rename from tools/testing/selftests/mm/hugepage_settings.c
rename to tools/lib/mm/hugepage_settings.c
index 202c8e6b0246..8d9e44727edb 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/lib/mm/hugepage_settings.c
@@ -9,11 +9,16 @@
 #include <string.h>
 #include <unistd.h>
 
-#include "vm_util.h"
+#include "file_utils.h"
 #include "hugepage_settings.h"
 
 #define THP_SYSFS "/sys/kernel/mm/transparent_hugepage/"
 #define MAX_SETTINGS_DEPTH 4
+
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+#endif
+
 static struct thp_settings settings_stack[MAX_SETTINGS_DEPTH];
 static int settings_index;
 static struct thp_settings saved_settings;
@@ -403,8 +408,7 @@ int detect_hugetlb_page_sizes(unsigned long sizes[], int max)
 		if (sscanf(entry->d_name, "hugepages-%zukB", &kb) != 1)
 			continue;
 		sizes[count++] = kb * 1024;
-		ksft_print_msg("[INFO] detected hugetlb page size: %zu KiB\n",
-			       kb);
+		printf("# [INFO] detected hugetlb page size: %zu KiB\n", kb);
 	}
 	closedir(dir);
 	return count;
@@ -538,7 +542,8 @@ unsigned long hugetlb_setup(unsigned long nr, unsigned long sizes[],
 		return 0;
 
 	if (nr_enabled > max) {
-		ksft_print_msg("detected %d huge page sizes, will only test %d\n", nr_enabled, max);
+		printf("# detected %d huge page sizes, will only test %d\n",
+		       nr_enabled, max);
 		nr_enabled = max;
 	}
 
@@ -610,8 +615,10 @@ static void hugepage_restore_settings_atexit(void)
 
 static void hugepage_restore_settings_sighandler(int sig)
 {
+	(void)sig;
+
 	/* exit() will invoke the hugepage_restore_settings_atexit handler. */
-	exit(KSFT_FAIL);
+	exit(EXIT_FAILURE);
 }
 
 void hugepage_save_settings(bool thp, bool hugetlb)
diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/lib/mm/hugepage_settings.h
similarity index 100%
rename from tools/testing/selftests/mm/hugepage_settings.h
rename to tools/lib/mm/hugepage_settings.h
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 70d6a9ccf9c9..e77c4cc41b47 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -188,8 +188,10 @@ TEST_FILES += write_hugetlb_memory.sh
 
 include ../lib.mk
 
-$(TEST_GEN_PROGS): vm_util.c hugepage_settings.c $(top_srcdir)/tools/lib/mm/file_utils.c
-$(TEST_GEN_FILES): vm_util.c hugepage_settings.c $(top_srcdir)/tools/lib/mm/file_utils.c
+$(TEST_GEN_PROGS): vm_util.c $(top_srcdir)/tools/lib/mm/hugepage_settings.c \
+		   $(top_srcdir)/tools/lib/mm/file_utils.c
+$(TEST_GEN_FILES): vm_util.c $(top_srcdir)/tools/lib/mm/hugepage_settings.c \
+		   $(top_srcdir)/tools/lib/mm/file_utils.c
 
 $(OUTPUT)/uffd-stress: uffd-common.c
 $(OUTPUT)/uffd-unit-tests: uffd-common.c
diff --git a/tools/testing/selftests/mm/compaction_test.c b/tools/testing/selftests/mm/compaction_test.c
index 5b582588e015..b2eaa490e7c2 100644
--- a/tools/testing/selftests/mm/compaction_test.c
+++ b/tools/testing/selftests/mm/compaction_test.c
@@ -15,9 +15,9 @@
 #include <errno.h>
 #include <unistd.h>
 #include <string.h>
+#include <mm/hugepage_settings.h>
 
 #include "kselftest.h"
-#include "hugepage_settings.h"
 
 #define MAP_SIZE_MB	100
 #define MAP_SIZE	(MAP_SIZE_MB * 1024 * 1024)
diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index 0c627ea89ff7..3c3d129c91b2 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -29,7 +29,6 @@
 #include "../../../../mm/gup_test.h"
 #include "kselftest.h"
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 static size_t pagesize;
 static int pagemap_fd;
diff --git a/tools/testing/selftests/mm/folio_split_race_test.c b/tools/testing/selftests/mm/folio_split_race_test.c
index 6329e37fff4c..496b74b37476 100644
--- a/tools/testing/selftests/mm/folio_split_race_test.c
+++ b/tools/testing/selftests/mm/folio_split_race_test.c
@@ -25,7 +25,6 @@
 #include <unistd.h>
 #include "vm_util.h"
 #include "kselftest.h"
-#include "hugepage_settings.h"
 
 uint64_t page_size;
 uint64_t pmd_pagesize;
diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index b21df3040b1c..ed967b3c7f37 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -21,7 +21,6 @@
 #include <sys/uio.h>
 #include <unistd.h>
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 #include "../pidfd/pidfd.h"
 
diff --git a/tools/testing/selftests/mm/gup_longterm.c b/tools/testing/selftests/mm/gup_longterm.c
index eb8963e9d98f..68c840bae082 100644
--- a/tools/testing/selftests/mm/gup_longterm.c
+++ b/tools/testing/selftests/mm/gup_longterm.c
@@ -29,7 +29,6 @@
 #include "../../../../mm/gup_test.h"
 #include "kselftest.h"
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 static size_t pagesize;
 static int nr_hugetlbsizes;
diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/selftests/mm/gup_test.c
index 3f841a96f870..5f44761dbec0 100644
--- a/tools/testing/selftests/mm/gup_test.c
+++ b/tools/testing/selftests/mm/gup_test.c
@@ -14,7 +14,6 @@
 #include <mm/gup_test.h>
 #include "kselftest.h"
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 #define MB (1UL << 20)
 
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 2f2b9879d100..e1bb031019f2 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -10,9 +10,6 @@
  * bugs.
  */
 
-#include "kselftest_harness.h"
-#include "hugepage_settings.h"
-
 #include <errno.h>
 #include <fcntl.h>
 #include <stdio.h>
@@ -29,6 +26,9 @@
 #include <sys/mman.h>
 #include <sys/ioctl.h>
 #include <sys/time.h>
+#include <mm/hugepage_settings.h>
+
+#include "kselftest_harness.h"
 
 /*
  * This is a private UAPI to the kernel test module so it isn't exported
diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
index 555b4b3d1430..57cf790ca478 100644
--- a/tools/testing/selftests/mm/hugetlb-madvise.c
+++ b/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -14,7 +14,6 @@
 #include <fcntl.h>
 #include "vm_util.h"
 #include "kselftest.h"
-#include "hugepage_settings.h"
 
 #define MIN_FREE_PAGES	20
 #define NR_HUGE_PAGES	10	/* common number of pages to map/allocate */
diff --git a/tools/testing/selftests/mm/hugetlb-mmap.c b/tools/testing/selftests/mm/hugetlb-mmap.c
index 0f2aad1b7dbd..a458becf5832 100644
--- a/tools/testing/selftests/mm/hugetlb-mmap.c
+++ b/tools/testing/selftests/mm/hugetlb-mmap.c
@@ -18,7 +18,6 @@
 #include <linux/memfd.h>
 #include "vm_util.h"
 #include "kselftest.h"
-#include "hugepage_settings.h"
 
 #define LENGTH (256UL*1024*1024)
 #define PROTECTION (PROT_READ | PROT_WRITE)
diff --git a/tools/testing/selftests/mm/hugetlb-mremap.c b/tools/testing/selftests/mm/hugetlb-mremap.c
index ed3d92e862d8..9b724af66e93 100644
--- a/tools/testing/selftests/mm/hugetlb-mremap.c
+++ b/tools/testing/selftests/mm/hugetlb-mremap.c
@@ -26,7 +26,6 @@
 #include <stdbool.h>
 #include "kselftest.h"
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 #define DEFAULT_LENGTH_MB 10UL
 #define MB_TO_BYTES(x) (x * 1024 * 1024)
diff --git a/tools/testing/selftests/mm/hugetlb-shm.c b/tools/testing/selftests/mm/hugetlb-shm.c
index 3ff7f062b7eb..f4514da49e1d 100644
--- a/tools/testing/selftests/mm/hugetlb-shm.c
+++ b/tools/testing/selftests/mm/hugetlb-shm.c
@@ -29,7 +29,6 @@
 #include <sys/mman.h>
 
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 #define LENGTH (256UL*1024*1024)
 
diff --git a/tools/testing/selftests/mm/hugetlb-soft-offline.c b/tools/testing/selftests/mm/hugetlb-soft-offline.c
index bc202e4ed2bd..20864e7d4e0c 100644
--- a/tools/testing/selftests/mm/hugetlb-soft-offline.c
+++ b/tools/testing/selftests/mm/hugetlb-soft-offline.c
@@ -21,9 +21,9 @@
 #include <sys/mman.h>
 #include <sys/statfs.h>
 #include <sys/types.h>
+#include <mm/hugepage_settings.h>
 
 #include "kselftest.h"
-#include "hugepage_settings.h"
 
 #ifndef MADV_SOFT_OFFLINE
 #define MADV_SOFT_OFFLINE 101
diff --git a/tools/testing/selftests/mm/hugetlb-vmemmap.c b/tools/testing/selftests/mm/hugetlb-vmemmap.c
index 507df78a158d..c46a656c25a0 100644
--- a/tools/testing/selftests/mm/hugetlb-vmemmap.c
+++ b/tools/testing/selftests/mm/hugetlb-vmemmap.c
@@ -11,7 +11,6 @@
 #include <sys/mman.h>
 #include <fcntl.h>
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 #define PAGE_COMPOUND_HEAD	(1UL << 15)
 #define PAGE_COMPOUND_TAIL	(1UL << 16)
diff --git a/tools/testing/selftests/mm/hugetlb_dio.c b/tools/testing/selftests/mm/hugetlb_dio.c
index fb4600570e13..9495974eccbe 100644
--- a/tools/testing/selftests/mm/hugetlb_dio.c
+++ b/tools/testing/selftests/mm/hugetlb_dio.c
@@ -20,7 +20,6 @@
 #include <sys/syscall.h>
 #include "vm_util.h"
 #include "kselftest.h"
-#include "hugepage_settings.h"
 
 #ifndef STATX_DIOALIGN
 #define STATX_DIOALIGN		0x00002000U
diff --git a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
index 2dc158054f66..56c5a8533e9d 100644
--- a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
+++ b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
@@ -10,7 +10,6 @@
 
 #include "vm_util.h"
 #include "kselftest.h"
-#include "hugepage_settings.h"
 
 #define INLOOP_ITER 100
 
diff --git a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
index f94549efcc6f..2532a42b98df 100644
--- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
+++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -25,7 +25,6 @@
 #include <unistd.h>
 
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 #define INLOOP_ITER 100
 
diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 5eac27dd9683..2382973b2f55 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -22,7 +22,6 @@
 #include "linux/magic.h"
 
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 #define BASE_ADDR ((void *)(1UL << 30))
 static unsigned long hpage_pmd_size;
diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
index a050f4840cfa..cc37492cf32c 100644
--- a/tools/testing/selftests/mm/ksm_tests.c
+++ b/tools/testing/selftests/mm/ksm_tests.c
@@ -15,7 +15,6 @@
 #include "kselftest.h"
 #include <include/vdso/time64.h>
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 #define KSM_SYSFS_PATH "/sys/kernel/mm/ksm/"
 #define KSM_FP(s) (KSM_SYSFS_PATH s)
diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index 29f7492453d4..4fe97c033261 100644
--- a/tools/testing/selftests/mm/migration.c
+++ b/tools/testing/selftests/mm/migration.c
@@ -4,9 +4,6 @@
  * paths in the kernel.
  */
 
-#include "kselftest_harness.h"
-#include "hugepage_settings.h"
-
 #include <strings.h>
 #include <pthread.h>
 #include <numa.h>
@@ -16,6 +13,8 @@
 #include <sys/types.h>
 #include <signal.h>
 #include <time.h>
+
+#include "kselftest_harness.h"
 #include "vm_util.h"
 
 #define TWOMEG		(2<<20)
diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 6f8971d5b3ce..804372803080 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -23,7 +23,6 @@
 
 #include "vm_util.h"
 #include "kselftest.h"
-#include "hugepage_settings.h"
 
 #define PAGEMAP_BITS_ALL		(PAGE_IS_WPALLOWED | PAGE_IS_WRITTEN |	\
 					 PAGE_IS_FILE | PAGE_IS_PRESENT |	\
diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
index d8d9d1de57b8..a4f8451791cb 100644
--- a/tools/testing/selftests/mm/prctl_thp_disable.c
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -14,7 +14,6 @@
 #include <sys/wait.h>
 
 #include "kselftest_harness.h"
-#include "hugepage_settings.h"
 #include "vm_util.h"
 
 #ifndef PR_THP_DISABLE_EXCEPT_ADVISED
diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
index 9a6d954ee371..5ba2033e8a09 100644
--- a/tools/testing/selftests/mm/protection_keys.c
+++ b/tools/testing/selftests/mm/protection_keys.c
@@ -45,8 +45,8 @@
 #include <unistd.h>
 #include <sys/ptrace.h>
 #include <setjmp.h>
+#include <mm/hugepage_settings.h>
 
-#include "hugepage_settings.h"
 #include "pkey-helpers.h"
 
 int iteration_nr = 1;
diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index fb1864a68e1c..6c22ac9e93db 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -9,7 +9,6 @@
 
 #include "kselftest.h"
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 #define PAGEMAP_FILE_PATH "/proc/self/pagemap"
 #define TEST_ITERATIONS 10000
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 83a75001518b..e744c9434e7d 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -21,7 +21,6 @@
 #include <time.h>
 #include "vm_util.h"
 #include "kselftest.h"
-#include "hugepage_settings.h"
 
 uint64_t pagesize;
 unsigned int pageshift;
diff --git a/tools/testing/selftests/mm/thuge-gen.c b/tools/testing/selftests/mm/thuge-gen.c
index 22b9c2f1c35d..0da15d530a1f 100644
--- a/tools/testing/selftests/mm/thuge-gen.c
+++ b/tools/testing/selftests/mm/thuge-gen.c
@@ -14,7 +14,6 @@
 #include <string.h>
 #include "vm_util.h"
 #include "kselftest.h"
-#include "hugepage_settings.h"
 
 #if !defined(MAP_HUGETLB)
 #define MAP_HUGETLB	0x40000
diff --git a/tools/testing/selftests/mm/transhuge-stress.c b/tools/testing/selftests/mm/transhuge-stress.c
index 8eb0c5630e7e..96f72898ebe0 100644
--- a/tools/testing/selftests/mm/transhuge-stress.c
+++ b/tools/testing/selftests/mm/transhuge-stress.c
@@ -17,7 +17,6 @@
 #include <sys/mman.h>
 #include "vm_util.h"
 #include "kselftest.h"
-#include "hugepage_settings.h"
 
 int backing_fd = -1;
 int mmap_flags = MAP_ANONYMOUS | MAP_NORESERVE | MAP_PRIVATE;
diff --git a/tools/testing/selftests/mm/uffd-common.h b/tools/testing/selftests/mm/uffd-common.h
index 92a21b97f745..0723843a7626 100644
--- a/tools/testing/selftests/mm/uffd-common.h
+++ b/tools/testing/selftests/mm/uffd-common.h
@@ -37,7 +37,6 @@
 
 #include "kselftest.h"
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 #define UFFD_FLAGS	(O_CLOEXEC | O_NONBLOCK | UFFD_USER_MODE_ONLY)
 
diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
index c973d6722720..eb4b2433b00e 100644
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c
+++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -7,8 +7,8 @@
 #include <assert.h>
 #include <linux/mman.h>
 #include <sys/mman.h>
+#include <mm/hugepage_settings.h>
 #include "kselftest.h"
-#include "hugepage_settings.h"
 #include "uffd-common.h"
 
 static int pagemap_fd;
diff --git a/tools/testing/selftests/mm/va_high_addr_switch.c b/tools/testing/selftests/mm/va_high_addr_switch.c
index e24d7ba00b44..5a354a664d1f 100644
--- a/tools/testing/selftests/mm/va_high_addr_switch.c
+++ b/tools/testing/selftests/mm/va_high_addr_switch.c
@@ -11,7 +11,6 @@
 
 #include "vm_util.h"
 #include "kselftest.h"
-#include "hugepage_settings.h"
 
 /*
  * The hint addr value is used to allocate addresses
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index d45135283732..aa856f0d32d6 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -9,6 +9,7 @@
 #include "kselftest.h"
 #include <linux/fs.h>
 #include <mm/file_utils.h>
+#include <mm/hugepage_settings.h>
 
 #define BIT_ULL(nr)                   (1ULL << (nr))
 #define PM_SOFT_DIRTY                 BIT_ULL(55)
-- 
2.39.5


