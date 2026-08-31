Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B027C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 04:21:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D853A6B0092; Mon, 31 Aug 2026 00:21:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D39046B0095; Mon, 31 Aug 2026 00:21:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C27006B0096; Mon, 31 Aug 2026 00:21:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 91F7A6B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:21:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C524F1603F8
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:21:46 +0000 (UTC)
X-FDA: 85160266212.21.9A44D7D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id D63BE40005
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:21:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AtTTK3Kf;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788150105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tC9gayvEu68IXFRSCUm5pfdq0JE6/mfdRJLXq10fPjA=;
	b=ZmFzJWy3Cyp509Or8kBY87KrPfFZIMtEBf7u2eqNFQsPz3CyVufYSt/ZNIpTDE06bF41M+
	Nop8s2Rpve6tpw736U5Gz+TO6bLjMDG56p5ereZSd7ezyDFwwtFebyxZJGw/M2ZfHLgHkv
	Cat4AjfxbD7FxHCqFqIqnffdIe4HcZ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788150105;
	b=sHcYRk3q24ZCU5UVD9LYEtA10z3M5p990ztNGCulkpREnEANlRUijV+CFpZXysNRQv9cLk
	nITWsBQFGu/GNkkKBRt0mtW+nvA+Qn4qUmusrflEQI5+gA0HgsCTp6x/SzlabVdJCOO57Q
	IJ1Kkjl5cJ+iEe5idHD8GEXge4znzJM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AtTTK3Kf;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5737514BF;
	Sun, 30 Aug 2026 21:21:40 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3F9FE3F8C6;
	Sun, 30 Aug 2026 21:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788150104; bh=pxYTNAryRWFz6IJzog/5O3LrGAtemINdU7YD5qSXcjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AtTTK3Kfen9Ji1BYeXHqtuey15gPf8osVwsU9siBBzce32pKxqtWAN4c6Pp4THyhS
	 Mu/vs9a/QhwEkAM1a378dG/uxDnOFd8a6+XDJC1dsNuscYeX2RccLUnORsNLYdxAB5
	 poNGefIYNKZrzrJUnjH9qr44b0QRu7g+xenzFIr4=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
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
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v8 3/6] tools/lib/mm: move hugepage_settings out of selftests
Date: Mon, 31 Aug 2026 09:50:58 +0530
Message-ID: <20260831042101.18085-4-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831042101.18085-1-sarthak.sharma@arm.com>
References: <20260831042101.18085-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D63BE40005
X-Stat-Signature: otrswkhktfyfh97m6aqci7owsi4pnd5k
X-Rspam-User: 
X-HE-Tag: 1788150104-170587
X-HE-Meta: U2FsdGVkX1/NwyfBzUK/2jpgCnOkWqOYhdGn0e1LmFpHxiMIITBacy2SamY5G+1djLY8HaYl9ZfmQT5hBxmOs8HD6oFqQ+oixAnIzsRBXrhacrnY/nTBgnD0bLg2v6r1wMHLu2ePWO7R188FW/hIFB+oo7R91eV6vxoIzN4vJU+M8UvmrX1pmjCVriY8JSORjhA+83AgAGJC1LyaGvRJ4RZAz5D6n1vPJsk90nFNGPnIlwD+JepyW569RDI9zf37g8e9daYOOQ0l9w0dQ0JRHEqHvnLgvX62iz2H4P71QCzrieqKFU2ZmVpH2T9b7QOzRIZc4nH+iaqOoyjCe+O5OUM/TlMqy24kB7pYH4Jcn+gY9UFWsQAuWzGxQTZgok8z/6kz8COMkYxvHzVIqD5/evsRA6dqpiMpTZz2lufFu9uBEQEKVCXpX05D5cbdE0iIqAM+wSCyNd1FcuqpCc04+aPctJQnq/+TLdhMEweSK8CQvYf/6YWydYUT8Gsyu3pP9Yas7W2HLmKzUMW1cTohOOGZleL4HRnaHNuGy1qrv4ksxRDfuv8/tx8W2yZDxa5z6gwLTx7kxsPlE7VFAv0GJvEndv0X0QD0Ym2po4jia12d8Ou3NAMHzvXyGqJMLK08xdskqFpc7zaONtSII9k3EA4tbstKY6rDY4OlH5bbjqQa5W+SCYPhXlrDbmgsNoug+cmG735TluKsXN2VN2vqkbrR1tgkvGYJwG7/fXj4G6K8LZP/VX5+kFQT2YLS0OYp0Wm1BHUstsuHog3Ndway75Nt7mS+235SebWShfH7ErMOTlbFlpAJx8tIZdgjjG6+jDuGo6rqeXo8J61UkvCNnJXFS4Qls7T7EnNeoF2nzf2AEMRZVgSEv8qWL634YM6VQBYdGuEv7tzwVkEFY92KJfhIz6WccyOnEH5sJFlI1WfzIvn9UwfsA+sd3F2UTvtgZ+FcGM7aeSIsqfkO18t
 nCW8RcBy
 yTj3EkOLP7ayBJifRXUmWMF9FOOXe03/EnS9ENF/O+jKCha0PFjmvc6yKSprnczR4u0iZ/1M5/kWmeyM0tEbMtnmyeUZW0xlVDwTVfEDY/ePDQToVx6oCnz2d3dXHumnrzkXcxkB2W+sDfpr6xrXgbxZPAwQZ8fJLBQsPpr2VtsbEB3e74do2OxEXlKQaMKuoaPUD7d2tXFJ24tid4F7jia5Ox+XzaEEean1J29DX/MuhkdAVJILIFeEkWuN8nHACWH8F/lqKtn6LmnG3tON2zf3ZLlU/yVPcDw5GXvZbjNyOfKfER4NM40stY1mGYP/8Miwy
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
and use direct <mm/hugepage_settings.h> includes for files that do not
include vm_util.h. Adjust the selftests/mm build to compile the moved
implementation from its new location.

Remove the remaining kselftest dependency by including file_utils.h
directly and using EXIT_FAILURE in the signal handler.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 .../{testing/selftests => lib}/mm/hugepage_settings.c | 11 +++++++++--
 .../{testing/selftests => lib}/mm/hugepage_settings.h |  0
 tools/testing/selftests/mm/Makefile                   |  6 ++++--
 tools/testing/selftests/mm/compaction_test.c          |  2 +-
 tools/testing/selftests/mm/cow.c                      |  1 -
 tools/testing/selftests/mm/folio_split_race_test.c    |  1 -
 tools/testing/selftests/mm/guard-regions.c            |  1 -
 tools/testing/selftests/mm/gup_longterm.c             |  1 -
 tools/testing/selftests/mm/gup_test.c                 |  1 -
 tools/testing/selftests/mm/hmm-tests.c                |  6 +++---
 tools/testing/selftests/mm/hugetlb-madvise.c          |  1 -
 tools/testing/selftests/mm/hugetlb-mmap.c             |  1 -
 tools/testing/selftests/mm/hugetlb-mremap.c           |  1 -
 tools/testing/selftests/mm/hugetlb-shm.c              |  1 -
 tools/testing/selftests/mm/hugetlb-soft-offline.c     |  2 +-
 tools/testing/selftests/mm/hugetlb_dio.c              |  1 -
 tools/testing/selftests/mm/hugetlb_fault_after_madv.c |  1 -
 tools/testing/selftests/mm/hugetlb_madv_vs_map.c      |  1 -
 tools/testing/selftests/mm/khugepaged.c               |  1 -
 tools/testing/selftests/mm/ksm_tests.c                |  1 -
 tools/testing/selftests/mm/migration.c                |  2 +-
 tools/testing/selftests/mm/pagemap_ioctl.c            |  1 -
 tools/testing/selftests/mm/prctl_thp_disable.c        |  1 -
 tools/testing/selftests/mm/protection_keys.c          |  2 +-
 tools/testing/selftests/mm/soft-dirty.c               |  1 -
 tools/testing/selftests/mm/split_huge_page_test.c     |  1 -
 tools/testing/selftests/mm/thuge-gen.c                |  1 -
 tools/testing/selftests/mm/transhuge-stress.c         |  1 -
 tools/testing/selftests/mm/uffd-common.h              |  1 -
 tools/testing/selftests/mm/uffd-wp-mremap.c           |  2 +-
 tools/testing/selftests/mm/va_high_addr_switch.c      |  1 -
 tools/testing/selftests/mm/vm_util.h                  |  1 +
 32 files changed, 22 insertions(+), 34 deletions(-)
 rename tools/{testing/selftests => lib}/mm/hugepage_settings.c (99%)
 rename tools/{testing/selftests => lib}/mm/hugepage_settings.h (100%)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/lib/mm/hugepage_settings.c
similarity index 99%
rename from tools/testing/selftests/mm/hugepage_settings.c
rename to tools/lib/mm/hugepage_settings.c
index 5bcda01ac4f6..abd9f7182f88 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/lib/mm/hugepage_settings.c
@@ -10,11 +10,16 @@
 #include <unistd.h>
 #include <errno.h>
 
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
@@ -638,8 +643,10 @@ static void hugepage_restore_settings_atexit(void)
 
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
index 61d974d2cbae..7cea3228020d 100644
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
index 30d4ace7155a..b3f5377119cb 100644
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
index 8aa5249d9bef..3264a828575b 100644
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
index 45b84f7b364e..289aed2ebac0 100644
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
index 5c8ec3ca75d7..af5cd9b30339 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -21,7 +21,6 @@
 #include <sys/uio.h>
 #include <unistd.h>
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 #include "../pidfd/pidfd.h"
 
diff --git a/tools/testing/selftests/mm/gup_longterm.c b/tools/testing/selftests/mm/gup_longterm.c
index 510de93be681..c9d8b4491263 100644
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
index e2642eca0d02..fa1a651963fd 100644
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
@@ -33,6 +30,9 @@
 #include <sys/eventfd.h>
 #include <linux/userfaultfd.h>
 #include <poll.h>
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
index 4ba5692ec4be..ada11d30d388 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -22,7 +22,6 @@
 #include "linux/magic.h"
 
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 #define BASE_ADDR ((void *)(1UL << 30))
 static unsigned long hpage_pmd_size;
diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
index 5fd7792a0d47..6711f4c61371 100644
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
index f19d53c69576..a35e2b57e05b 100644
--- a/tools/testing/selftests/mm/migration.c
+++ b/tools/testing/selftests/mm/migration.c
@@ -5,7 +5,6 @@
  */
 
 #include "kselftest_harness.h"
-#include "hugepage_settings.h"
 
 #include <string.h>
 #include <pthread.h>
@@ -16,6 +15,7 @@
 #include <sys/types.h>
 #include <signal.h>
 #include <time.h>
+
 #include "vm_util.h"
 
 #define TWOMEG		(2<<20)
diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index eadc7159ca5b..0c5de6ec06c8 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -24,7 +24,6 @@
 
 #include "vm_util.h"
 #include "kselftest.h"
-#include "hugepage_settings.h"
 
 #define PAGEMAP_BITS_ALL		(PAGE_IS_WPALLOWED | PAGE_IS_WRITTEN |	\
 					 PAGE_IS_FILE | PAGE_IS_PRESENT |	\
diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
index 82c6e96ea6eb..f9ec1408a6e3 100644
--- a/tools/testing/selftests/mm/prctl_thp_disable.c
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -14,7 +14,6 @@
 #include <sys/wait.h>
 
 #include "kselftest_harness.h"
-#include "hugepage_settings.h"
 #include "vm_util.h"
 
 #ifndef PR_THP_DISABLE_EXCEPT_ADVISED
diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
index ae6e1530b354..b7882ab97683 100644
--- a/tools/testing/selftests/mm/protection_keys.c
+++ b/tools/testing/selftests/mm/protection_keys.c
@@ -45,8 +45,8 @@
 #include <unistd.h>
 #include <sys/ptrace.h>
 #include <setjmp.h>
+#include <mm/hugepage_settings.h>
 
-#include "hugepage_settings.h"
 #include "pkey-helpers.h"
 
 u64 shadow_pkey_reg;
diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index 5f278913c4d7..7f649b673355 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -9,7 +9,6 @@
 
 #include "kselftest.h"
 #include "vm_util.h"
-#include "hugepage_settings.h"
 
 #define PAGEMAP_FILE_PATH "/proc/self/pagemap"
 #define TEST_ITERATIONS 10000
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 5b0f77d12756..0e083ab71af6 100644
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
index 50d0805b65db..a04f588df780 100644
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
index fe0475f2bdf2..64a86e8a0c41 100644
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
2.53.0


