Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CF85C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:09:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BDEB6B00A6; Thu, 30 Jul 2026 10:09:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9948A6B00A9; Thu, 30 Jul 2026 10:09:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A9DF6B00AA; Thu, 30 Jul 2026 10:09:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58F666B00A6
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:09:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DF9C1C0198
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:09:05 +0000 (UTC)
X-FDA: 85045624650.05.518A6CB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1507E180013
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:09:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=D9Yr2jk9;
	spf=pass (imf24.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785420544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tSRz4XKPkg/QcBPWBbJNLBsLTu34I1+f9E378yuF97M=;
	b=OAnK5od1t70cUSu8u9QO32+rFpXSXt0MTFGzqqJFLneGW8+yU00qFfJ3M3BdTvTPiEwoJD
	tlAwxHNlg7VO9yne2ovAqo1zRHl0bSUPyyEMQ6AR3lAMFo97PAedPl1+71n75r1fognEWl
	rg+v8+S5MJw6mKKQ/9BBvCK/tUk8uuI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=D9Yr2jk9;
	spf=pass (imf24.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785420544;
	b=5DuwlWqwNlSrtWO1b9NLuLyNFn9ZTq0sgEAvHPallTz9mGMNSnILZQuCmNJFX7losIvhgn
	kcjt90fom8bK7RsbzEdZfmiZxE9aUeaeRA48iQ26mA6nd5HS7VWfh2XFFVSmcNv4qMPmGy
	KfB9EGZInaY66KBlrz81wmAnS2G4Q28=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E1D81688;
	Thu, 30 Jul 2026 07:08:59 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9E3133F86F;
	Thu, 30 Jul 2026 07:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785420543; bh=UARmwYgKfFQCZqzYaX8pnrfhNtXlqghZyCEXLgSQcPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D9Yr2jk9UGX1Nz9qmWEBWiuJ2/0feiSg9CkEgWbHisoDfMZsMYurgu8VP3L5lb7MX
	 0NrIY80p+BGXoxtPnGdlfPHxFFyVGXfTO1c78BVgOcyVp1sa7M1NjwF+7tum7QIJWZ
	 xGafJd/eIfwLJMrl/Hc64zVr5vOKBHTDHxqxSBN8=
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
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Mark Brown <broonie@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v6 3/6] tools/lib/mm: move hugepage_settings out of selftests
Date: Thu, 30 Jul 2026 19:38:22 +0530
Message-ID: <20260730140825.238130-4-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260730140825.238130-1-sarthak.sharma@arm.com>
References: <20260730140825.238130-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1507E180013
X-Stat-Signature: dgg36fbysqerfz4bdx9mi65yw6o3391m
X-HE-Tag: 1785420543-647115
X-HE-Meta: U2FsdGVkX1917oXgYx/3ufLvqmzLMDza1v1rnkDvromZaIM7FampLgLl5LgSI23EyfQ83FKy359NQZ7DCQXRWx63Iagvb8csl1OwjIslJeEhWD8yj2Ahx2KnSz/JYjytfV9jhB1ryRciGsxcXf1WDV9SfnN8G2noOOf8Qo4owfvYZIFYuiMPpAhUQv49OtQHk3oq+6hOwIjmlec4MOL1zsp7i2CUI/obseOjuc0TrBtiTLvVu5TTQevlF2tiLLtBuGqKnS4BSIWq1wDrAghRYv3SXBYK8sWQyS+E0t3tEZ8r5dZVHFJwsKfgMmO2zfLKi/G5yME//QP9lYIG675hDmF6Gh9PLuDzQ1hbFE/OIVGzpJPgJaQ0pYi9cyOOsL7jqwxKL2Ihs1v9am4vu4xYVZe+wJq7kxCiNgtLJWhc0bnM8n2IwhXdcQHGNzJfNwDF3lXmE7BsJ+vMQPjDclu5xV3d0eMmMC4Uf5znaz3n4SqBU3f6wa9Sabe0/8xsSlHJyv7mnMazi5DiYJixnCsRRjTgN3g7vrTacHyQrgDTiWVoi3Ny+5AdhBRqXGVUqWWfDxNVbBZ2MDt7nSvre6spEKMYHB36VGqT/bzFDnVVq/ydbFqSiWRJ3k7oDDVnPC76yQPgBVFmAIOA6/O1Cnzmb/4JvyxYcbSt6FhxZk57BUQOGywhgQIAlv06zNoFmLouvD5zFEw/MUCaixQJREePAh24Qfq+cZfA1u+2IwJqACmXe1v7A6uwAy9bsbTeTYoqY/8XWW56/tBGmrkc1zHa4YANJ9YYprbRb+n/TARA/352ZzqWPnGcU2BJuK2lRaTRiYBD0cLgroTPEYDql66dsCjWekF0JKfSqt48P6JNwNdNF0+vypwcWHpf/GTnMogkL55ZpVIiv/EMSKpc/sqtK0oIOoti9dRxZEVnB5pj0D/y8EaHMhm2oVCTWPq5m6c8OYz1DBXrmSC25Az8swd
 BNLbU10k
 CGoakklRc60GLFtvOkh/LnPGk9nLCWyxjPjIEzOcEVJetUMuq7fZxQquVPQDfoT9n8Bt8GBR6IC3Gv+kH8NeUCzJqcGl/n0/Pl8LEOmrtuYfDII3xsgcTiAPu3xym3jAvsz6mGbrgjwaJ7OWdbj03QQqdAZS02oFX4EUH5cW6DHPFnzTiRqrh8Ja+Esk0WVQRPvvlpgI4KMMfmBco52HAsS8Z9K28BaGuhze3kuG8hW4V1dDYGPHk5i0niOR3s+7la6jmHGZIruiK4tKWa70YEkigbwwGWr9pfqz/Mxcz7qH2Tkw=
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

Remove the remaining kselftest dependency from hugepage_settings.c.
Replace ksft_perror() with a new print_file_error() helper and
ksft_print_msg() with printf(). Prefix both with a # to keep them
TAP compatible.

Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 .../selftests => lib}/mm/hugepage_settings.c  | 54 ++++++++++---------
 .../selftests => lib}/mm/hugepage_settings.h  |  0
 tools/testing/selftests/mm/Makefile           |  6 ++-
 tools/testing/selftests/mm/compaction_test.c  |  2 +-
 tools/testing/selftests/mm/cow.c              |  1 -
 .../selftests/mm/folio_split_race_test.c      |  1 -
 tools/testing/selftests/mm/guard-regions.c    |  1 -
 tools/testing/selftests/mm/gup_longterm.c     |  1 -
 tools/testing/selftests/mm/gup_test.c         |  1 -
 tools/testing/selftests/mm/hmm-tests.c        |  6 +--
 tools/testing/selftests/mm/hugetlb-madvise.c  |  1 -
 tools/testing/selftests/mm/hugetlb-mmap.c     |  1 -
 tools/testing/selftests/mm/hugetlb-mremap.c   |  1 -
 tools/testing/selftests/mm/hugetlb-shm.c      |  1 -
 .../selftests/mm/hugetlb-soft-offline.c       |  2 +-
 tools/testing/selftests/mm/hugetlb-vmemmap.c  |  1 -
 tools/testing/selftests/mm/hugetlb_dio.c      |  1 -
 .../selftests/mm/hugetlb_fault_after_madv.c   |  1 -
 .../selftests/mm/hugetlb_madv_vs_map.c        |  1 -
 tools/testing/selftests/mm/khugepaged.c       |  1 -
 tools/testing/selftests/mm/ksm_tests.c        |  1 -
 tools/testing/selftests/mm/migration.c        |  5 +-
 tools/testing/selftests/mm/pagemap_ioctl.c    |  1 -
 .../testing/selftests/mm/prctl_thp_disable.c  |  1 -
 tools/testing/selftests/mm/protection_keys.c  |  2 +-
 tools/testing/selftests/mm/soft-dirty.c       |  1 -
 .../selftests/mm/split_huge_page_test.c       |  1 -
 tools/testing/selftests/mm/thuge-gen.c        |  1 -
 tools/testing/selftests/mm/transhuge-stress.c |  1 -
 tools/testing/selftests/mm/uffd-common.h      |  1 -
 tools/testing/selftests/mm/uffd-wp-mremap.c   |  2 +-
 .../selftests/mm/va_high_addr_switch.c        |  1 -
 tools/testing/selftests/mm/vm_util.h          |  1 +
 33 files changed, 43 insertions(+), 60 deletions(-)
 rename tools/{testing/selftests => lib}/mm/hugepage_settings.c (94%)
 rename tools/{testing/selftests => lib}/mm/hugepage_settings.h (100%)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/lib/mm/hugepage_settings.c
similarity index 94%
rename from tools/testing/selftests/mm/hugepage_settings.c
rename to tools/lib/mm/hugepage_settings.c
index db0db8a3df7c..4471f4989dbb 100644
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
@@ -49,6 +54,13 @@ static const char * const shmem_enabled_strings[] = {
 	NULL
 };
 
+static void print_file_error(const char *path, int ret)
+{
+	int err = -ret;
+
+	printf("# %s: %s (%d)\n", path, strerror(err), err);
+}
+
 int thp_read_string(const char *name, const char * const strings[])
 {
 	char path[PATH_MAX];
@@ -64,8 +76,7 @@ int thp_read_string(const char *name, const char * const strings[])
 
 	ret = read_file(path, buf, sizeof(buf));
 	if (ret < 0) {
-		errno = -ret;
-		ksft_perror(path);
+		print_file_error(path, ret);
 		exit(EXIT_FAILURE);
 	}
 
@@ -108,8 +119,7 @@ void thp_write_string(const char *name, const char *val)
 	}
 	ret = write_file(path, val, strlen(val) + 1);
 	if (ret < 0) {
-		errno = -ret;
-		ksft_perror(path);
+		print_file_error(path, ret);
 		exit(EXIT_FAILURE);
 	}
 }
@@ -127,8 +137,7 @@ unsigned long thp_read_num(const char *name)
 	}
 	ret = read_num(path, &num);
 	if (ret < 0) {
-		errno = -ret;
-		ksft_perror(path);
+		print_file_error(path, ret);
 		exit(EXIT_FAILURE);
 	}
 
@@ -147,8 +156,7 @@ void thp_write_num(const char *name, unsigned long num)
 	}
 	ret = write_num(path, num);
 	if (ret < 0) {
-		errno = -ret;
-		ksft_perror(path);
+		print_file_error(path, ret);
 		exit(EXIT_FAILURE);
 	}
 }
@@ -183,8 +191,7 @@ void thp_read_settings(struct thp_settings *settings)
 				   &settings->read_ahead_kb);
 
 		if (ret < 0) {
-			errno = -ret;
-			ksft_perror(dev_queue_read_ahead_path);
+			print_file_error(dev_queue_read_ahead_path, ret);
 			exit(EXIT_FAILURE);
 		}
 	}
@@ -242,8 +249,7 @@ void thp_write_settings(struct thp_settings *settings)
 				    settings->read_ahead_kb);
 
 		if (ret < 0) {
-			errno = -ret;
-			ksft_perror(dev_queue_read_ahead_path);
+			print_file_error(dev_queue_read_ahead_path, ret);
 			exit(EXIT_FAILURE);
 		}
 	}
@@ -346,8 +352,7 @@ static unsigned long __thp_supported_orders(bool is_shmem)
 		ret = read_file(path, buf, sizeof(buf));
 		if (ret < 0) {
 			if (ret != -ENOENT) {
-				errno = -ret;
-				ksft_perror(path);
+				print_file_error(path, ret);
 				exit(EXIT_FAILURE);
 			}
 			continue;
@@ -427,8 +432,7 @@ int detect_hugetlb_page_sizes(unsigned long sizes[], int max)
 		if (sscanf(entry->d_name, "hugepages-%zukB", &kb) != 1)
 			continue;
 		sizes[count++] = kb * 1024;
-		ksft_print_msg("[INFO] detected hugetlb page size: %zu KiB\n",
-			       kb);
+		printf("# [INFO] detected hugetlb page size: %zu KiB\n", kb);
 	}
 	closedir(dir);
 	return count;
@@ -477,8 +481,7 @@ unsigned long hugetlb_nr_pages(unsigned long size)
 
 	ret = read_num(path, &nr);
 	if (ret < 0) {
-		errno = -ret;
-		ksft_perror(path);
+		print_file_error(path, ret);
 		exit(EXIT_FAILURE);
 	}
 
@@ -494,8 +497,7 @@ void hugetlb_set_nr_pages(unsigned long size, unsigned long nr)
 
 	ret = write_num(path, nr);
 	if (ret < 0) {
-		errno = -ret;
-		ksft_perror(path);
+		print_file_error(path, ret);
 		exit(EXIT_FAILURE);
 	}
 }
@@ -510,8 +512,7 @@ unsigned long hugetlb_free_pages(unsigned long size)
 
 	ret = read_num(path, &nr);
 	if (ret < 0) {
-		errno = -ret;
-		ksft_perror(path);
+		print_file_error(path, ret);
 		exit(EXIT_FAILURE);
 	}
 
@@ -571,7 +572,8 @@ unsigned long hugetlb_setup(unsigned long nr, unsigned long sizes[],
 		return 0;
 
 	if (nr_enabled > max) {
-		ksft_print_msg("detected %d huge page sizes, will only test %d\n", nr_enabled, max);
+		printf("# detected %d huge page sizes, will only test %d\n",
+		       nr_enabled, max);
 		nr_enabled = max;
 	}
 
@@ -643,8 +645,10 @@ static void hugepage_restore_settings_atexit(void)
 
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
index 6a656bc6b266..b16d1a3d960f 100644
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
index ef5ab96adc7e..8ff983e264f4 100644
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


