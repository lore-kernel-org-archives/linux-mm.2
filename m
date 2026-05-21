Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81450CD5BA4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 11:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E88D56B0096; Thu, 21 May 2026 07:20:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E39036B0098; Thu, 21 May 2026 07:20:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDA096B0099; Thu, 21 May 2026 07:20:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B46F86B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:20:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 78CC71C19BE
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:20:19 +0000 (UTC)
X-FDA: 84791183358.22.6FB05F9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id B067A16000A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:20:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sDaxSKbT;
	spf=pass (imf08.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779362417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ZUmaO91PSisBNnEhfymeF1v708U6hZnBFYr8ZbovzE=;
	b=Pi9TNQZT8WpsQmHcncPC1CgZ+03PLgP+SlalN4v3/EHpPyoxpsh0nJmPHrDqHO01/4GUK8
	WxQM9EMY0OsV98r3XeUfa/NnOXWSEsS6BZKdmUHrh5ULk3hdl8Kbzx669u7cp7BXGH5n7Z
	bajjKJ3qm7vrvX9k/3ZlParnZwICLOw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sDaxSKbT;
	spf=pass (imf08.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779362417; a=rsa-sha256;
	cv=none;
	b=8bGyO9nRxrj57sYgiZrU2zC+zZ0JPNjFOFAVQoqSkqEI75LopxUAN7U16jtqtJzFrSscqB
	vTszuRLYSSEh5vtxeZwKlzpTbBHdd/hSYyeXb68fGUXl/SDz+sA9H6NN3rjIJ1xFn3Ek+f
	w8I1uD4MI9apyuXn+abiEgZT8R3IB2w=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 59A1949F7;
	Thu, 21 May 2026 04:20:11 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.82])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A691C3F7B4;
	Thu, 21 May 2026 04:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779362416; bh=/nXUUmR9S6busIGFbfa9gy5/mN3/X+ZuR6o0xBMPHd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDaxSKbT6bWHJROIUqQ05/HvC5W2FxcQ4eu/0VD3Iweg+yYBDRlaafD2ZgXTfj8Gr
	 ve9jlwqszHINmQw8MS1yrcFBA/LSe/qzpl59oEMo+X9pcRtzkvAAVGognZ2Nx1ODAv
	 EYlfrtD6qZNuOrZaFSOSs1RLdLNDjUjRKMFfgL7k=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
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
	Mark Brown <broonie@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v3 2/4] tools/lib/mm: move hugepage_settings out of selftests
Date: Thu, 21 May 2026 16:47:59 +0530
Message-ID: <20260521111801.173019-3-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260521111801.173019-1-sarthak.sharma@arm.com>
References: <20260521111801.173019-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B067A16000A
X-Stat-Signature: e1ntj9rus5x4dr14uht7us59m897ex7b
X-HE-Tag: 1779362417-698403
X-HE-Meta: U2FsdGVkX1/rvdVnp6aYIOdDNVmMuW++fTzeuZ7gWztW27hdqqbviyu8Wpr5qitImv8D7OMIODTIWHKSzSCiQuvJW0vYF75Vrf+zWRQtydhskXzV17hzfJiCN6tLg9FHkXZyDT12OyCS6tiKB+O3vfRyZqBibpdcAtffRs6VRHRAkYTxzFmrQUCOloPiHiTun0GO4/YZgDKrn4UwDV8AaOXhQJyykxpP/mUNyUwkLuQU/UNrCQCTbDpBhcVcgp0qQKlL64VURTqCFwNERMyDHyWw9frxNG1qeuC/f1v5Wet6iRF6Vn7MzJqdgn/1MS3QB1YvPXVYjCkY3jUQ0uGgdk7TwXHFN8oKaglgax4tEUtKneMqIrcQlOYeh2DGCwLSRTD/DP5HE7pi9/WcMN6kderSpHqy93C/ATAzQz5P/+cwgPSpSqN9v/dSIW7bIYimHuY5qL29fmgnfcTvXIKDMhz5/i9AZbldrcpz0SxW5+hTfNTftz6zTHImSV7M1yCvD2gQpPJKL37eP2CutNdkzmLczP2Dr2cincTlBQ+SaivE8JaZ+Sgura2ry+KGIeb+fRRlI81WiuxhMDsa1QCWrtdQ1hudcP1oae1CApRZ8unJOntSNCZXc/lgfDRZwQCVoZ+L+9PM5QQ3sykU412IrBfhW9WA1zvnqA9b3wnGLTp25gV0sGcL5J0XJTVYBB0YsubkLjg1cIeqJ7su36xzrQ3TykW49+aHzmJAQFqZXP7IU6fGn/yY+Ah4tfG7WLZvmhAsbJTp5mBgseuFoJ9Ct5fIIbl2zGAC1uPtr+n45XHf3yvV+0RBuaNewNaMX7/eexptdpkRnjuHEufJB6R4FARui00fZB449A36pV0JaybcVCVmeR98EKtoxick9edWY2YeuF+eNJuTvgADfCkOl/1fKV2Id3rJKrFsYO7VzKmZ8EimN/7sZ2JRP3siB4P45NVab+O6uwc1LwzzJyf
 SVzX908Q
 SKGHi4d9s9NbyHZPGZr62LpCz+YIjHUu+SKNA2MsIDdCkZ/IRaHI32wrakVfzGGn5FjgQRLTgnPA392Kva5ZiYEuQgN5yayVkPK70rpmHJbhXOHp+hKhjp57Ee/DyKD+AFlkk6R5Zzr7OIMzOFxP9NxA/We6FH6NNlXzrgFZzAVuEOxAPwH9VffHrEvrSgEFJcnY4a9Q0pIN9zblCXXxiUfQTCJn6s2C2ZU7TBfTxuusIpa1l6DFmQPQYiCUa1amEc7Lc6BfGOAG/vMDG6r7TxfV0hX1GSo5pvJNZXULUHtGVqCo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move hugepage_settings.[ch] from tools/testing/selftests/mm/ to
tools/lib/mm/ so the THP and HugeTLB helpers can be shared more easily
between selftests and other tools.

Update the mm selftest users to include the header from tools/lib/mm/
and adjust the selftests/mm build to compile the moved implementation
from its new location.

Remove the remaining kselftest dependency from hugepage_settings.c by
replacing ksft_print_msg() calls with plain fprintf() calls. Drop the
non-fatal hugetlb informational prints from the shared helper, so it
does not emit unwanted output during selftest runs.

Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 .../selftests => lib}/mm/hugepage_settings.c      | 15 +++++++++------
 .../selftests => lib}/mm/hugepage_settings.h      |  0
 tools/testing/selftests/mm/Makefile               |  6 ++++--
 tools/testing/selftests/mm/compaction_test.c      |  2 +-
 tools/testing/selftests/mm/cow.c                  |  2 +-
 .../testing/selftests/mm/folio_split_race_test.c  |  3 ++-
 tools/testing/selftests/mm/guard-regions.c        |  3 ++-
 tools/testing/selftests/mm/gup_longterm.c         |  2 +-
 tools/testing/selftests/mm/gup_test.c             |  3 ++-
 tools/testing/selftests/mm/hmm-tests.c            |  6 +++---
 tools/testing/selftests/mm/hugetlb-madvise.c      |  3 ++-
 tools/testing/selftests/mm/hugetlb-mmap.c         |  3 ++-
 tools/testing/selftests/mm/hugetlb-mremap.c       |  3 ++-
 tools/testing/selftests/mm/hugetlb-shm.c          |  2 +-
 tools/testing/selftests/mm/hugetlb-soft-offline.c |  2 +-
 tools/testing/selftests/mm/hugetlb-vmemmap.c      |  3 ++-
 tools/testing/selftests/mm/hugetlb_dio.c          |  3 ++-
 .../selftests/mm/hugetlb_fault_after_madv.c       |  2 +-
 tools/testing/selftests/mm/hugetlb_madv_vs_map.c  |  2 +-
 tools/testing/selftests/mm/khugepaged.c           |  2 +-
 tools/testing/selftests/mm/ksm_tests.c            |  2 +-
 tools/testing/selftests/mm/migration.c            |  6 +++---
 tools/testing/selftests/mm/pagemap_ioctl.c        |  2 +-
 tools/testing/selftests/mm/prctl_thp_disable.c    |  2 +-
 tools/testing/selftests/mm/protection_keys.c      |  2 +-
 tools/testing/selftests/mm/soft-dirty.c           |  2 +-
 tools/testing/selftests/mm/split_huge_page_test.c |  2 +-
 tools/testing/selftests/mm/thuge-gen.c            |  3 ++-
 tools/testing/selftests/mm/transhuge-stress.c     |  3 ++-
 tools/testing/selftests/mm/uffd-common.h          |  2 +-
 tools/testing/selftests/mm/uffd-wp-mremap.c       |  3 ++-
 tools/testing/selftests/mm/va_high_addr_switch.c  |  2 +-
 32 files changed, 57 insertions(+), 41 deletions(-)
 rename tools/{testing/selftests => lib}/mm/hugepage_settings.c (98%)
 rename tools/{testing/selftests => lib}/mm/hugepage_settings.h (100%)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/lib/mm/hugepage_settings.c
similarity index 98%
rename from tools/testing/selftests/mm/hugepage_settings.c
rename to tools/lib/mm/hugepage_settings.c
index 5e947abb7425..b08b27776fc5 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/lib/mm/hugepage_settings.c
@@ -8,13 +8,17 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
-#include <mm/file_utils.h>
 
-#include "kselftest.h"
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
@@ -383,8 +387,6 @@ int detect_hugetlb_page_sizes(unsigned long sizes[], int max)
 		if (sscanf(entry->d_name, "hugepages-%zukB", &kb) != 1)
 			continue;
 		sizes[count++] = kb * 1024;
-		ksft_print_msg("[INFO] detected hugetlb page size: %zu KiB\n",
-			       kb);
 	}
 	closedir(dir);
 	return count;
@@ -503,7 +505,6 @@ unsigned long hugetlb_setup(unsigned long nr, unsigned long sizes[],
 		return 0;
 
 	if (nr_enabled > max) {
-		ksft_print_msg("detected %d huge page sizes, will only test %d\n", nr_enabled, max);
 		nr_enabled = max;
 	}
 
@@ -575,8 +576,10 @@ static void hugepage_restore_settings_atexit(void)
 
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
index b5fb4b6ab31b..8a307b777630 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -187,8 +187,10 @@ TEST_FILES += write_hugetlb_memory.sh
 
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
index de0633f9a7e5..7c58506c0aa7 100644
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
index 0c627ea89ff7..7c29d3d2d887 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -20,6 +20,7 @@
 #include <sys/ioctl.h>
 #include <sys/wait.h>
 #include <linux/memfd.h>
+#include <mm/hugepage_settings.h>
 
 #include "local_config.h"
 #ifdef LOCAL_CONFIG_HAVE_LIBURING
@@ -29,7 +30,6 @@
 #include "../../../../mm/gup_test.h"
 #include "kselftest.h"
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 static size_t pagesize;
 static int pagemap_fd;
diff --git a/tools/testing/selftests/mm/folio_split_race_test.c b/tools/testing/selftests/mm/folio_split_race_test.c
index 6329e37fff4c..ca9b95c39c16 100644
--- a/tools/testing/selftests/mm/folio_split_race_test.c
+++ b/tools/testing/selftests/mm/folio_split_race_test.c
@@ -23,9 +23,10 @@
 #include <sys/mman.h>
 #include <signal.h>
 #include <unistd.h>
+#include <mm/hugepage_settings.h>
+
 #include "vm_util.h"
 #include "kselftest.h"
-#include "hugepage_settings.h"
 
 uint64_t page_size;
 uint64_t pmd_pagesize;
diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index b21df3040b1c..ccca432c8802 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -20,8 +20,9 @@
 #include <sys/syscall.h>
 #include <sys/uio.h>
 #include <unistd.h>
+#include <mm/hugepage_settings.h>
+
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 #include "../pidfd/pidfd.h"
 
diff --git a/tools/testing/selftests/mm/gup_longterm.c b/tools/testing/selftests/mm/gup_longterm.c
index eb8963e9d98f..0cfc67fc5c8f 100644
--- a/tools/testing/selftests/mm/gup_longterm.c
+++ b/tools/testing/selftests/mm/gup_longterm.c
@@ -20,6 +20,7 @@
 #include <sys/vfs.h>
 #include <linux/magic.h>
 #include <linux/memfd.h>
+#include <mm/hugepage_settings.h>
 
 #include "local_config.h"
 #ifdef LOCAL_CONFIG_HAVE_LIBURING
@@ -29,7 +30,6 @@
 #include "../../../../mm/gup_test.h"
 #include "kselftest.h"
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 static size_t pagesize;
 static int nr_hugetlbsizes;
diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/selftests/mm/gup_test.c
index 3f841a96f870..803ab829a841 100644
--- a/tools/testing/selftests/mm/gup_test.c
+++ b/tools/testing/selftests/mm/gup_test.c
@@ -12,9 +12,10 @@
 #include <pthread.h>
 #include <assert.h>
 #include <mm/gup_test.h>
+#include <mm/hugepage_settings.h>
+
 #include "kselftest.h"
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 #define MB (1UL << 20)
 
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index e1c8a679a4cf..b7f85a144f03 100644
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
@@ -27,6 +24,9 @@
 #include <sys/mman.h>
 #include <sys/ioctl.h>
 #include <sys/time.h>
+#include <mm/hugepage_settings.h>
+
+#include "kselftest_harness.h"
 
 /*
  * This is a private UAPI to the kernel test module so it isn't exported
diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
index 555b4b3d1430..8e18b5027904 100644
--- a/tools/testing/selftests/mm/hugetlb-madvise.c
+++ b/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -12,9 +12,10 @@
 #include <unistd.h>
 #include <sys/mman.h>
 #include <fcntl.h>
+#include <mm/hugepage_settings.h>
+
 #include "vm_util.h"
 #include "kselftest.h"
-#include "hugepage_settings.h"
 
 #define MIN_FREE_PAGES	20
 #define NR_HUGE_PAGES	10	/* common number of pages to map/allocate */
diff --git a/tools/testing/selftests/mm/hugetlb-mmap.c b/tools/testing/selftests/mm/hugetlb-mmap.c
index 0f2aad1b7dbd..12184c1889ad 100644
--- a/tools/testing/selftests/mm/hugetlb-mmap.c
+++ b/tools/testing/selftests/mm/hugetlb-mmap.c
@@ -16,9 +16,10 @@
 #include <sys/mman.h>
 #include <fcntl.h>
 #include <linux/memfd.h>
+#include <mm/hugepage_settings.h>
+
 #include "vm_util.h"
 #include "kselftest.h"
-#include "hugepage_settings.h"
 
 #define LENGTH (256UL*1024*1024)
 #define PROTECTION (PROT_READ | PROT_WRITE)
diff --git a/tools/testing/selftests/mm/hugetlb-mremap.c b/tools/testing/selftests/mm/hugetlb-mremap.c
index d239905790dd..0b1a1fc9e766 100644
--- a/tools/testing/selftests/mm/hugetlb-mremap.c
+++ b/tools/testing/selftests/mm/hugetlb-mremap.c
@@ -24,9 +24,10 @@
 #include <sys/ioctl.h>
 #include <string.h>
 #include <stdbool.h>
+#include <mm/hugepage_settings.h>
+
 #include "kselftest.h"
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 #define DEFAULT_LENGTH_MB 10UL
 #define MB_TO_BYTES(x) (x * 1024 * 1024)
diff --git a/tools/testing/selftests/mm/hugetlb-shm.c b/tools/testing/selftests/mm/hugetlb-shm.c
index 3ff7f062b7eb..25988f97057a 100644
--- a/tools/testing/selftests/mm/hugetlb-shm.c
+++ b/tools/testing/selftests/mm/hugetlb-shm.c
@@ -27,9 +27,9 @@
 #include <sys/ipc.h>
 #include <sys/shm.h>
 #include <sys/mman.h>
+#include <mm/hugepage_settings.h>
 
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
index 507df78a158d..ffecea89ffa1 100644
--- a/tools/testing/selftests/mm/hugetlb-vmemmap.c
+++ b/tools/testing/selftests/mm/hugetlb-vmemmap.c
@@ -10,8 +10,9 @@
 #include <unistd.h>
 #include <sys/mman.h>
 #include <fcntl.h>
+#include <mm/hugepage_settings.h>
+
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 #define PAGE_COMPOUND_HEAD	(1UL << 15)
 #define PAGE_COMPOUND_TAIL	(1UL << 16)
diff --git a/tools/testing/selftests/mm/hugetlb_dio.c b/tools/testing/selftests/mm/hugetlb_dio.c
index fb4600570e13..896c6e3c09da 100644
--- a/tools/testing/selftests/mm/hugetlb_dio.c
+++ b/tools/testing/selftests/mm/hugetlb_dio.c
@@ -18,9 +18,10 @@
 #include <string.h>
 #include <sys/mman.h>
 #include <sys/syscall.h>
+#include <mm/hugepage_settings.h>
+
 #include "vm_util.h"
 #include "kselftest.h"
-#include "hugepage_settings.h"
 
 #ifndef STATX_DIOALIGN
 #define STATX_DIOALIGN		0x00002000U
diff --git a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
index 2dc158054f66..70e685f0b510 100644
--- a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
+++ b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
@@ -7,10 +7,10 @@
 #include <unistd.h>
 #include <setjmp.h>
 #include <signal.h>
+#include <mm/hugepage_settings.h>
 
 #include "vm_util.h"
 #include "kselftest.h"
-#include "hugepage_settings.h"
 
 #define INLOOP_ITER 100
 
diff --git a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
index f94549efcc6f..c8f6414e8a77 100644
--- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
+++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -23,9 +23,9 @@
 #include <sys/mman.h>
 #include <sys/types.h>
 #include <unistd.h>
+#include <mm/hugepage_settings.h>
 
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 #define INLOOP_ITER 100
 
diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index ae5945e2bfac..9bf1f8744431 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -19,11 +19,11 @@
 #include <sys/sysmacros.h>
 #include <sys/vfs.h>
 #include <mm/file_utils.h>
+#include <mm/hugepage_settings.h>
 
 #include "linux/magic.h"
 
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 #define BASE_ADDR ((void *)(1UL << 30))
 static unsigned long hpage_pmd_size;
diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
index a050f4840cfa..4fda799a148d 100644
--- a/tools/testing/selftests/mm/ksm_tests.c
+++ b/tools/testing/selftests/mm/ksm_tests.c
@@ -11,11 +11,11 @@
 #include <fcntl.h>
 #include <stdint.h>
 #include <err.h>
+#include <mm/hugepage_settings.h>
 
 #include "kselftest.h"
 #include <include/vdso/time64.h>
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 #define KSM_SYSFS_PATH "/sys/kernel/mm/ksm/"
 #define KSM_FP(s) (KSM_SYSFS_PATH s)
diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index 29f7492453d4..c3e60ddcefa7 100644
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
@@ -16,6 +13,9 @@
 #include <sys/types.h>
 #include <signal.h>
 #include <time.h>
+#include <mm/hugepage_settings.h>
+
+#include "kselftest_harness.h"
 #include "vm_util.h"
 
 #define TWOMEG		(2<<20)
diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 762306177ad8..924308ead037 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -20,10 +20,10 @@
 #include <assert.h>
 #include <sys/ipc.h>
 #include <sys/shm.h>
+#include <mm/hugepage_settings.h>
 
 #include "vm_util.h"
 #include "kselftest.h"
-#include "hugepage_settings.h"
 
 #define PAGEMAP_BITS_ALL		(PAGE_IS_WPALLOWED | PAGE_IS_WRITTEN |	\
 					 PAGE_IS_FILE | PAGE_IS_PRESENT |	\
diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
index d8d9d1de57b8..db1807adf72e 100644
--- a/tools/testing/selftests/mm/prctl_thp_disable.c
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -12,9 +12,9 @@
 #include <linux/mman.h>
 #include <sys/prctl.h>
 #include <sys/wait.h>
+#include <mm/hugepage_settings.h>
 
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
index fb1864a68e1c..852cc0a9743f 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -6,10 +6,10 @@
 #include <stdint.h>
 #include <malloc.h>
 #include <sys/mman.h>
+#include <mm/hugepage_settings.h>
 
 #include "kselftest.h"
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 #define PAGEMAP_FILE_PATH "/proc/self/pagemap"
 #define TEST_ITERATIONS 10000
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 4a2ccc055c8b..b4ff8ed0b446 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -20,10 +20,10 @@
 #include <stdbool.h>
 #include <time.h>
 #include <mm/file_utils.h>
+#include <mm/hugepage_settings.h>
 
 #include "vm_util.h"
 #include "kselftest.h"
-#include "hugepage_settings.h"
 
 uint64_t pagesize;
 unsigned int pageshift;
diff --git a/tools/testing/selftests/mm/thuge-gen.c b/tools/testing/selftests/mm/thuge-gen.c
index 22b9c2f1c35d..5556a1b89393 100644
--- a/tools/testing/selftests/mm/thuge-gen.c
+++ b/tools/testing/selftests/mm/thuge-gen.c
@@ -12,9 +12,10 @@
 #include <unistd.h>
 #include <stdarg.h>
 #include <string.h>
+#include <mm/hugepage_settings.h>
+
 #include "vm_util.h"
 #include "kselftest.h"
-#include "hugepage_settings.h"
 
 #if !defined(MAP_HUGETLB)
 #define MAP_HUGETLB	0x40000
diff --git a/tools/testing/selftests/mm/transhuge-stress.c b/tools/testing/selftests/mm/transhuge-stress.c
index 8eb0c5630e7e..ed78b2142ac1 100644
--- a/tools/testing/selftests/mm/transhuge-stress.c
+++ b/tools/testing/selftests/mm/transhuge-stress.c
@@ -15,9 +15,10 @@
 #include <fcntl.h>
 #include <string.h>
 #include <sys/mman.h>
+#include <mm/hugepage_settings.h>
+
 #include "vm_util.h"
 #include "kselftest.h"
-#include "hugepage_settings.h"
 
 int backing_fd = -1;
 int mmap_flags = MAP_ANONYMOUS | MAP_NORESERVE | MAP_PRIVATE;
diff --git a/tools/testing/selftests/mm/uffd-common.h b/tools/testing/selftests/mm/uffd-common.h
index 92a21b97f745..b8e25a96381d 100644
--- a/tools/testing/selftests/mm/uffd-common.h
+++ b/tools/testing/selftests/mm/uffd-common.h
@@ -34,10 +34,10 @@
 #include <stdint.h>
 #include <sys/random.h>
 #include <stdatomic.h>
+#include <mm/hugepage_settings.h>
 
 #include "kselftest.h"
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 #define UFFD_FLAGS	(O_CLOEXEC | O_NONBLOCK | UFFD_USER_MODE_ONLY)
 
diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
index 90ac410c6c6f..dcd7ac35deba 100644
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c
+++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -7,8 +7,9 @@
 #include <assert.h>
 #include <linux/mman.h>
 #include <sys/mman.h>
+#include <mm/hugepage_settings.h>
+
 #include "kselftest.h"
-#include "hugepage_settings.h"
 #include "uffd-common.h"
 
 static int pagemap_fd;
diff --git a/tools/testing/selftests/mm/va_high_addr_switch.c b/tools/testing/selftests/mm/va_high_addr_switch.c
index e24d7ba00b44..07fcb03316cc 100644
--- a/tools/testing/selftests/mm/va_high_addr_switch.c
+++ b/tools/testing/selftests/mm/va_high_addr_switch.c
@@ -8,10 +8,10 @@
 #include <stdio.h>
 #include <sys/mman.h>
 #include <string.h>
+#include <mm/hugepage_settings.h>
 
 #include "vm_util.h"
 #include "kselftest.h"
-#include "hugepage_settings.h"
 
 /*
  * The hint addr value is used to allocate addresses
-- 
2.39.5


