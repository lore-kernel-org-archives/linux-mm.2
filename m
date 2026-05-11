Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3F0DCD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29D3F6B00FE; Mon, 11 May 2026 12:31:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 274896B00FF; Mon, 11 May 2026 12:31:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B23B6B0100; Mon, 11 May 2026 12:31:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F5F96B00FE
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:31:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D78C11A01DC
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:31:22 +0000 (UTC)
X-FDA: 84755679204.28.30849A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4B8AA180018
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:31:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E94f5uFh;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pjzVFsgjOGe201u8p6/mYXx6vWJLUzWXnu9pXsk0gZQ=;
	b=r1WeTYHasf1HIII1FHmsNGaOsJaalAZJyO03OB3vx8IttWmu4H6Nnr0EobkdGh5xaZLEf7
	TR5vtZVy6MvechIX6GyC9GACui9TfzDZHF8Qi+ZGhY0ZN4kovr1zAJjBtKbECnoqDykirB
	YbfHSsER8PWCm9C2LkxmLyPe1OSNK1o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E94f5uFh;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517081; a=rsa-sha256;
	cv=none;
	b=qaZA2koz0xQSO3rmHBPwwDqrknL5aewwhzZhuyVyT+QY9EFAUOg+Km/Xt6kKdMx5Vwul9B
	RndB6tkxFGGFjD78/tghCHrTIhYzEw4Yt9sorWpNrjXoTE/o7ruHtEgzqAKcxA9pzVYpVO
	KmCV7z0wTbuAJJ8zHeocpMzicVsU6k8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C697C6012B;
	Mon, 11 May 2026 16:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C88DC2BCF6;
	Mon, 11 May 2026 16:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517080;
	bh=p8eqU8eKwOJXkOLI+ddAOxsnl9lAd/dLryEDy9x6bpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E94f5uFhCQvm4pzsP9IuQhpWBabdq7ATacJBs46Kejn8zr9DYGae08FJUvxb6ucuq
	 xXldCmrtvqu/TuCF0zgU08q+VJE/ArYfXTphDqWUvBe1rdob0DzvcKNKOUdAESqcl+
	 W7DQgfq+F0Vh2d/SN4UayStxhIK6vqmwTKL4taRuyeLjrIJs6o8Lkn6HsU2a5WdCnN
	 eHdOVi+JaiyYnDGLUP0P3Td76YPnBXcPS8s6a+OBouCgGRpMhNQ34HpqDey8+594RX
	 6AAZdswFr4x6wXIYDi/VN/i8NCDv/IK/LJv3EpoR/8UI4CMxdubC8/BbdXZ0D3LNoi
	 dTkszuW7tOcKg==
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
	Li Wang <li.wang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
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
Subject: [PATCH v4 23/55] selftests/mm: rename thp_settings.[ch] to hugepage_settings.[ch]
Date: Mon, 11 May 2026 19:28:07 +0300
Message-ID: <20260511162840.375890-24-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4B8AA180018
X-Rspam-User: 
X-Stat-Signature: rdhi3hbs856cuii1c687ddu6sugwnuti
X-HE-Tag: 1778517081-290273
X-HE-Meta: U2FsdGVkX18n1/8bNsNEqdoQ1rP/4vGe9lOzf346bMZZTnLeagQoDtbzf6lBuA/gGRdx1rezm0F5Y8qA+UxE8zRbhswulrZW8u9n8cPoN2/MsPncLuUoDfJGnZgyEkooDRrLVM7VPsoN7QprZHaA13cv0Ikqpv1BUWFlXHLpPlq50rtOAxm0iIxYNwic5rDRQcKjEyCFfa6YvaPcio0n4l+LktKxpJ4KvsUyPbavBXrfajqXv89F9vRIYDZjiXThwHQJQ+dw6+hVxTA8WUPkMh4EwGlWngwGAN6qPxRLoVIacQL49AwBz8uLUmUveKgpSiUgCXhhwhsOqukbqP+Z9NZnaFIr92v4cOlT3+qKzhDTE2M6MBbl03dcxjbcTqEroU+lDRvRaJMrnjqouu44eWqe3OO+WaHIT8kWRbWY2lYoYevETPSTqWq5QPKbPKIbtkn2QPlG2G4eZTEv7mdHEHvurv6auYpJMxAHlUKsWdUwlOrB4AwCMI+eRBQ8pkrw6kn+EWO5fQsSJeaFCujteHl4NvCiMue/EkQt6hBrejaifZi1XU7l/iSgQYJyYBViF8Ioc4p6FIgZSbixlRId+5iZPuYK5WnUOA/2AVRhIvxefaBP7DB5EMlErNoTtEJiCPrN+XpZ9C9fVEVGmps2akkY2hswN6mHa+wjafO6+Bt79NCOyteh5hobgppAFb7DZCQObBF459bjqVzgzfLhhsq9LeY3SpmY00Ijzy0YE9ZcHXr2wQXJnUw6jetdbAz0CxX/yBNBCKgswCrvjPwWUPfhlpoVjpJGkGKiWB7CuL4U8S6O8l5higtWfieuJpoMCAkzspiTohsY61cc6XfRBsMRQMme5x2IejQP6/aWunhCKkkSB+Los7y42YlPnwJSg8lu9sYlAW5XWAJRP5TN9zC1GsU9gNX2utbSGAT3q+tdxiL59tdaHtGUta3ySd9naDxA4puKNMOaWHbWHjF
 6ozK3I3N
 c/kLytiKNI7ZToJHALgszLMY2RhJeW8RpYhV1AHSiftRjOoBqX8T/aRhebU8kd/L6eXNMlkraqI6YudXJVYdIDj28vYSr7gmYmyiMAJ3qtSYrWPuTjXLcNwSA61kbRQZMuLUxc/oHBQ5UAsu1fYEI9MBKqkQPgYgMy6D8l3Y8Iy1jYQco6vzhgrWv2tauwgEMGCIFh3RQ3sLzdB3tPReakLUVepW/ArJknXXlGWk00I5RJsCORykbC3f09LOyhRZBuRwlxlBOUvby3rvCLjWuwOzI58NdCVGY1i86r6H+74l1+o8aP1zXbiUA/r6YyDSS2hKi+2O+fqJxc9jxU26VDstHCNWyesye3dET4tDg+ImmRAw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

... for upcoming addition of HugeTLB helpers.

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/Makefile                         | 4 ++--
 tools/testing/selftests/mm/cow.c                            | 2 +-
 tools/testing/selftests/mm/folio_split_race_test.c          | 2 +-
 tools/testing/selftests/mm/guard-regions.c                  | 2 +-
 .../selftests/mm/{thp_settings.c => hugepage_settings.c}    | 2 +-
 .../selftests/mm/{thp_settings.h => hugepage_settings.h}    | 6 +++---
 tools/testing/selftests/mm/khugepaged.c                     | 2 +-
 tools/testing/selftests/mm/ksm_tests.c                      | 2 +-
 tools/testing/selftests/mm/migration.c                      | 2 +-
 tools/testing/selftests/mm/prctl_thp_disable.c              | 2 +-
 tools/testing/selftests/mm/soft-dirty.c                     | 2 +-
 tools/testing/selftests/mm/split_huge_page_test.c           | 2 +-
 tools/testing/selftests/mm/transhuge-stress.c               | 2 +-
 tools/testing/selftests/mm/uffd-wp-mremap.c                 | 2 +-
 14 files changed, 17 insertions(+), 17 deletions(-)
 rename tools/testing/selftests/mm/{thp_settings.c => hugepage_settings.c} (99%)
 rename tools/testing/selftests/mm/{thp_settings.h => hugepage_settings.h} (95%)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index d9ecfb02e05c..5b98ce5d0d77 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -186,8 +186,8 @@ TEST_FILES += write_hugetlb_memory.sh
 
 include ../lib.mk
 
-$(TEST_GEN_PROGS): vm_util.c thp_settings.c
-$(TEST_GEN_FILES): vm_util.c thp_settings.c
+$(TEST_GEN_PROGS): vm_util.c hugepage_settings.c
+$(TEST_GEN_FILES): vm_util.c hugepage_settings.c
 
 $(OUTPUT)/uffd-stress: uffd-common.c
 $(OUTPUT)/uffd-unit-tests: uffd-common.c
diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index 6abdcb30aba8..4321f4208fe3 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -29,7 +29,7 @@
 #include "../../../../mm/gup_test.h"
 #include "kselftest.h"
 #include "vm_util.h"
-#include "thp_settings.h"
+#include "hugepage_settings.h"
 
 static size_t pagesize;
 static int pagemap_fd;
diff --git a/tools/testing/selftests/mm/folio_split_race_test.c b/tools/testing/selftests/mm/folio_split_race_test.c
index 390fd97c1bd9..6329e37fff4c 100644
--- a/tools/testing/selftests/mm/folio_split_race_test.c
+++ b/tools/testing/selftests/mm/folio_split_race_test.c
@@ -25,7 +25,7 @@
 #include <unistd.h>
 #include "vm_util.h"
 #include "kselftest.h"
-#include "thp_settings.h"
+#include "hugepage_settings.h"
 
 uint64_t page_size;
 uint64_t pmd_pagesize;
diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index 48e8b1539be3..feb50b415f52 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -21,7 +21,7 @@
 #include <sys/uio.h>
 #include <unistd.h>
 #include "vm_util.h"
-#include "thp_settings.h"
+#include "hugepage_settings.h"
 
 #include "../pidfd/pidfd.h"
 
diff --git a/tools/testing/selftests/mm/thp_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
similarity index 99%
rename from tools/testing/selftests/mm/thp_settings.c
rename to tools/testing/selftests/mm/hugepage_settings.c
index 9bfa5dc42624..9000864f8aa4 100644
--- a/tools/testing/selftests/mm/thp_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -8,7 +8,7 @@
 #include <unistd.h>
 
 #include "vm_util.h"
-#include "thp_settings.h"
+#include "hugepage_settings.h"
 
 #define THP_SYSFS "/sys/kernel/mm/transparent_hugepage/"
 #define MAX_SETTINGS_DEPTH 4
diff --git a/tools/testing/selftests/mm/thp_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
similarity index 95%
rename from tools/testing/selftests/mm/thp_settings.h
rename to tools/testing/selftests/mm/hugepage_settings.h
index 7748a9009191..d81e33e425c2 100644
--- a/tools/testing/selftests/mm/thp_settings.h
+++ b/tools/testing/selftests/mm/hugepage_settings.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __THP_SETTINGS_H__
-#define __THP_SETTINGS_H__
+#ifndef __HUGEPAGE_SETTINGS_H__
+#define __HUGEPAGE_SETTINGS_H__
 
 #include <stdbool.h>
 #include <stddef.h>
@@ -86,4 +86,4 @@ unsigned long thp_shmem_supported_orders(void);
 bool thp_available(void);
 bool thp_is_enabled(void);
 
-#endif /* __THP_SETTINGS_H__ */
+#endif /* __HUGEPAGE_SETTINGS_H__ */
diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 712e8f194b3d..0c4ecbe82cf0 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -22,7 +22,7 @@
 #include "linux/magic.h"
 
 #include "vm_util.h"
-#include "thp_settings.h"
+#include "hugepage_settings.h"
 
 #define BASE_ADDR ((void *)(1UL << 30))
 static unsigned long hpage_pmd_size;
diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
index 0a5b38d3281c..64d1c63ae8c0 100644
--- a/tools/testing/selftests/mm/ksm_tests.c
+++ b/tools/testing/selftests/mm/ksm_tests.c
@@ -15,7 +15,7 @@
 #include "kselftest.h"
 #include <include/vdso/time64.h>
 #include "vm_util.h"
-#include "thp_settings.h"
+#include "hugepage_settings.h"
 
 #define KSM_SYSFS_PATH "/sys/kernel/mm/ksm/"
 #define KSM_FP(s) (KSM_SYSFS_PATH s)
diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index e504829df6b6..7781a59bb9f8 100644
--- a/tools/testing/selftests/mm/migration.c
+++ b/tools/testing/selftests/mm/migration.c
@@ -5,7 +5,7 @@
  */
 
 #include "kselftest_harness.h"
-#include "thp_settings.h"
+#include "hugepage_settings.h"
 
 #include <strings.h>
 #include <pthread.h>
diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
index ca27200596a4..d8d9d1de57b8 100644
--- a/tools/testing/selftests/mm/prctl_thp_disable.c
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -14,7 +14,7 @@
 #include <sys/wait.h>
 
 #include "kselftest_harness.h"
-#include "thp_settings.h"
+#include "hugepage_settings.h"
 #include "vm_util.h"
 
 #ifndef PR_THP_DISABLE_EXCEPT_ADVISED
diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index bcfcac99b436..c426c4636ef5 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -9,7 +9,7 @@
 
 #include "kselftest.h"
 #include "vm_util.h"
-#include "thp_settings.h"
+#include "hugepage_settings.h"
 
 #define PAGEMAP_FILE_PATH "/proc/self/pagemap"
 #define TEST_ITERATIONS 10000
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 500d07c4938b..cc99294bdd5a 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -21,7 +21,7 @@
 #include <time.h>
 #include "vm_util.h"
 #include "kselftest.h"
-#include "thp_settings.h"
+#include "hugepage_settings.h"
 
 uint64_t pagesize;
 unsigned int pageshift;
diff --git a/tools/testing/selftests/mm/transhuge-stress.c b/tools/testing/selftests/mm/transhuge-stress.c
index 7a9f1035099b..8eb0c5630e7e 100644
--- a/tools/testing/selftests/mm/transhuge-stress.c
+++ b/tools/testing/selftests/mm/transhuge-stress.c
@@ -17,7 +17,7 @@
 #include <sys/mman.h>
 #include "vm_util.h"
 #include "kselftest.h"
-#include "thp_settings.h"
+#include "hugepage_settings.h"
 
 int backing_fd = -1;
 int mmap_flags = MAP_ANONYMOUS | MAP_NORESERVE | MAP_PRIVATE;
diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
index 516c35d236e1..9d67b11c2f28 100644
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c
+++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -8,7 +8,7 @@
 #include <linux/mman.h>
 #include <sys/mman.h>
 #include "kselftest.h"
-#include "thp_settings.h"
+#include "hugepage_settings.h"
 #include "uffd-common.h"
 
 static int pagemap_fd;
-- 
2.53.0


