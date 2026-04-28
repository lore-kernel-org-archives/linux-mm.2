Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33A5CFF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:45:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CB946B00BE; Tue, 28 Apr 2026 16:45:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A31E6B00C0; Tue, 28 Apr 2026 16:45:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B9F86B00C1; Tue, 28 Apr 2026 16:45:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B62D6B00BE
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:45:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1A1F4A03E6
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:45:19 +0000 (UTC)
X-FDA: 84709144758.03.F88AB04
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 452621C0014
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:45:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FIabE277;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJtpkvGLgpby5UP16H02CV/wWR2YNcPhcSEIbP8un/A=;
	b=ucBZLi/RYJ/0H5xmgw/zletmultPUC/c+Ns+oCiZzLEakzPTDhLxYGHL3942YfFNzqF/fq
	OD262EWdE392A9I7e75f24lcqXaoCLSuSBO2IZTgiFM3b7ZL7/jyi9RT/7xquivw9Acmpy
	w/gavqvmh5R+IfF69BkcY06k/5rodYA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409117; a=rsa-sha256;
	cv=none;
	b=vs1YUN7VwsO86xx+Gqr4+mJI+UWvl8TdG1pjw8WejENIOdOc9Ydr0x3VIIKZWd4XB8UB70
	CGM+epC+cDYm/05NdNdFRjsxrLiycA6GqyPA96/G4n2sFYKhQwIquQfFzRHKYFAZsYfNJc
	W2fHfWsx5eULAirmMnW8h846jHt9TcA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FIabE277;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F559402EA;
	Tue, 28 Apr 2026 20:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E26C2BCAF;
	Tue, 28 Apr 2026 20:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409116;
	bh=yl3DcYUkZRaQ+ub527Rq2rXetVK21fIqVTn3MxdOY9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FIabE277dGFIjWcvHSAVIpZbuctjYJFAbzAIaEigMZxuR3ljO7MZoCjpMjhS1g7EQ
	 SV3Sm+KvI6HooC/VafcbPTWNRzpRkyLosLeOi5pXjbWJIwv5sbZxkKXlouIDTCvF6x
	 4vNz5GYHJIBMYWvIuoVJCGzqb0k9yjuc+UEFTPZwGIDCHLg1U6X4p9bihlgABpvLvM
	 TsmU5nv2hfgRXyeMd6Do4BA3JPJ3deD2A7EexpcnYjLHbmXVQtmYJHQmPbcmFovwJq
	 5XgEKo6VZBYmffm2rKJePrVLD561D13IdFLAboj5lcCyxZdBsdpCBH0XfvWINjAYVz
	 hdRM/w3fxxodg==
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
Subject: [PATCH v3 22/54] selftests/mm: rename thp_settings.[ch] to hugepage_settings.[ch]
Date: Tue, 28 Apr 2026 23:42:08 +0300
Message-ID: <20260428204240.1924129-23-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 452621C0014
X-Stat-Signature: aqqjwjuk9js6nypwfdmioab7fy5rhpxs
X-Rspam-User: 
X-HE-Tag: 1777409117-688812
X-HE-Meta: U2FsdGVkX192cGvyxB01eIMBJIyFviil27g7JmnmM6UaNRR0NeY+UkoxqR+1A+pT7xrwVpueU8wedDyRu62cii6T/ep99/sudCTpumbVempoOwlgiQXDNOWjUSGU5A/R7os86GCI0ceHSlwqVb4WmZ5ppsnw6hL5MAjzH5e/Os65BXP8fBjBXHjgKEIqHyvvv+/AV0onM3LPlNYWLjk+t+qKYf7JHyh91IbaFzDWSQfh4L1ZXJW3F4F9T+PG1Wlhwd5RQG0Y7Wzi3kUbdyaNJ1qJB1UGsWKuiIDmSzfBklMHfuv2Rld03DJtijySuknlwdQtdVGQGrsS5b4NGfv30e8+b+2SJrGgfjRCwUoHtBA75UtX8LLXR24GEeX9nE/CwN/k5XYDCkR3hfAykymoMPlYioNLnFJYFCBcXuEEGDaAdopNaEoB3tdAebzTMzhHXXpYt332QKB0aRuhjGTroENb+8OG4Ulu54g84N4HyL/v9HNdr1p50kM6JntCNSqYZY0Acj1aYzmhfbs9KQK+oYgi25lo0nFYdEqKbkIm7X4XyItOlhQNkehIOHPnmg5SOSOItS4kGHIAj1FGSzVz0sH9aubcqGnyaHw62F4W9YTgE/BD1ykwxq8HOlGOC2gSHgcMrxjUVabJZHtwWk6qDlgi1IwYqwO+u+cxnFH6kv+/z7lxON2khiRjV5x/Q7LZHFGJoBCuXl+o/bYY2er66oEazbGGJoqssdN0xx5rPkpp+Rsht0oN9uI2pdlyFG/zQJdgBHvYgTK6y1azdOOhX7QMsGIQwH3YnUAb42Ecv74RvT91JVD6KWXs/c4XyNmB9ZjWL/Sayv3nviL4h7MLHBsvHmB1Y9DKzrnqh9Q0fIMYeJktZfKj1a2w0yb0a67heVxh0DoiRtFYfuHPc5Ruib2mSV/vQPfYN5MIX5j14ecN9IFC55lbzfWjYsKl6A65RkWu6tUo/Ri4DPQOlmG
 tdcu3oyd
 OLORTOJGi1rRFTphEIbyFMe4aEbiCBZhPtUNPx43rShE+hEDVRqKyd9adViDEZbvIMp4c5Z153aBxjtt/j8o5pvT4OXDl9nYsxQ/tNCz5u09No5qqNJVwWLgVAEh/s3Vw2PJZkKPG1m0gBnCFTPmT3w9vk/xjRORquR8c6IBfY/URIH1KoxRNl6ITFcy5xN8c4QquzrGd+l3qATHSbYIIWafVR18gB1JenaPX5D3A5ka8uKr/GXAvbG2qiozVqCG+IySL3GzmVbJkfEGCpylivpgr5o7CNhJOiKM3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

... for upcoming addition of HugeTLB helpers.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/Makefile                           | 4 ++--
 tools/testing/selftests/mm/cow.c                              | 2 +-
 tools/testing/selftests/mm/folio_split_race_test.c            | 2 +-
 tools/testing/selftests/mm/guard-regions.c                    | 2 +-
 .../selftests/mm/{thp_settings.c => hugepage_settings.c}      | 2 +-
 .../selftests/mm/{thp_settings.h => hugepage_settings.h}      | 0
 tools/testing/selftests/mm/khugepaged.c                       | 2 +-
 tools/testing/selftests/mm/ksm_tests.c                        | 2 +-
 tools/testing/selftests/mm/migration.c                        | 2 +-
 tools/testing/selftests/mm/prctl_thp_disable.c                | 2 +-
 tools/testing/selftests/mm/soft-dirty.c                       | 2 +-
 tools/testing/selftests/mm/split_huge_page_test.c             | 2 +-
 tools/testing/selftests/mm/transhuge-stress.c                 | 2 +-
 tools/testing/selftests/mm/uffd-wp-mremap.c                   | 2 +-
 14 files changed, 14 insertions(+), 14 deletions(-)
 rename tools/testing/selftests/mm/{thp_settings.c => hugepage_settings.c} (99%)
 rename tools/testing/selftests/mm/{thp_settings.h => hugepage_settings.h} (100%)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index a6955660a806..a1d103b38485 100644
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
index ff026f183ac7..7ede4793c778 100644
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
index f38ba8a27b30..87ecb309b430 100644
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
similarity index 100%
rename from tools/testing/selftests/mm/thp_settings.h
rename to tools/testing/selftests/mm/hugepage_settings.h
diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index ef3b6464ff3f..7563d7600ce7 100644
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
index 752a2c0d06ab..fb355f869401 100644
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
index 76e380b74658..0212cd5bde6e 100644
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


