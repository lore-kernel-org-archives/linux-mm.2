Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 062C8F46C45
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:19:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D6C26B00BD; Mon,  6 Apr 2026 10:19:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AECA6B00BF; Mon,  6 Apr 2026 10:19:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EBF06B00C0; Mon,  6 Apr 2026 10:19:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4EFC16B00BD
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:19:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 227141A0481
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:19:51 +0000 (UTC)
X-FDA: 84628339782.19.F41A915
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 17D661A000F
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:19:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lllvUId4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485189; a=rsa-sha256;
	cv=none;
	b=bxqAEPfV6wDTD/0KkXgCEASGzNCXP/mlPFYUUCZ3X85Bb0Ey5gxdxWx2LncfV2Ovwmhps0
	c4q9SjIWaMnbohr4/mXKATcHv3BcuSoYgVgG53s2ilaG0hRYcNrMC1PHdR90uvh3ogxZYA
	oXeP95hbqDbCH2glIWrdoterIBS5ArI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lllvUId4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NqKa7pbgItMh16SmPBJkepwXtAujQeZWauE3TwFbaEI=;
	b=YrWiNuKssy6Zg/mY5KSY+7ijnrUBjPrLeAdCz5gWclAhz+TnotQUxTTPoJwfdTAaga7gdy
	Jd+GzqjUfTHrWsfTfYJ+v/dcirlUJKClSTp1sSMZnzJioluiL3pIWnU+iuiO71FDtLlflp
	zqzXNn73rO+lY7Nd1Rx/e9iSzd5d9QA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4AB9E40B10;
	Mon,  6 Apr 2026 14:19:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA00C2BCB0;
	Mon,  6 Apr 2026 14:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485188;
	bh=AHkzH3mQAlKfDcQRvRcQ6AqEgxWN7sYnNjSvNtUulcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lllvUId4Bi3hfTmW7ghuDK/RsXw5dolByczZMQX/GnD6G2FQO6bs9f/C4s0Li9ay2
	 A9+Pr63Ri3kPYZiJFfM+06YZDEo4Gw5OJzo8K8JcYv0FtAGeQkXIwaJldvlZSn20E+
	 faqh5d7Z9ZTYs/TlmO9jtUQyegei1/AaKup5doc/KR1tP527gBXvfdcEUbYRcfeFjg
	 MTW+YFDi/h6VoPUe4WAEbHPBtR+X42+glu9OYhXahEU5AVKPv+7utmzzrFZV80V2TG
	 FOzCWZLWcDl25AceoldmddyxDJ9clx6EnE12/u0hJ6QyYC66xdBnH5eD6UrEWyp4Pw
	 UUu4khFST20qA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
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
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 21/53] selftests/mm: rename thp_settings.[ch] to  hugepage_settings.[ch]
Date: Mon,  6 Apr 2026 17:17:03 +0300
Message-ID: <20260406141735.2179309-22-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6mthbr8j51kxyjybrxi47gzxmk7szsho
X-Rspamd-Queue-Id: 17D661A000F
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775485188-192855
X-HE-Meta: U2FsdGVkX1+ZC+w6b4qe8djbaILd4jgf90XpMQn0k5vkjOqZOHnpOxn5agIMGeRvO4UC0vFVEB0w7YGnPTA3qGDdyW9+14PMhnmxAS4Wtiqj4E369EsFqUsAvSt0eyQSHCyzJF0DAWPMoR3z4mAI1VHfKZwPumAkDTUXS/C+/0ltwOJ2Ydm+5JQDStaMWwf54fevkVZk1aRao5twiw6CqmIM1Qz56L21dgcOl1/BqnCu4BEpZKWsOgwl0jOsuvQ6yLFFpaCmlMUS4Gn7+O8tygNRKjhz2NnyTCCbxOZKnUchVlRv6b40WQzT6QN5wZr3iGeeqhg5bwClN2b3xgdu/dWmW99/GU6aj4Fx1NQOGJyAE2Nd/sOqk2Zu/Hbgbqs4xRaKmHnHTcCTAg/paZpmLbI9ECO5SsAk81dZfWiGiTOQgQISMlKZVfWRI2PBQ/YUVpBnME+AaPXOn29hd2b0tC7jZXSRzxBKnGO2ZHJ4gjkF29tBizZ76KqYFwoilW8ItmfXzJzoZis0igDPJRl0GQKciB7pVTi+eYnYNMrMrUD6RQgMgCzMTX8mUIyNMMopjIdLXb6+m83UV5p1Ki6kcJ79F0BENOv2sYGjmq8gnKbmx+Em5YWEmOsgx+5fGVu2gCgXCV1p35CC+XEJird5VbtgSRVCULxV65oAJT4hSmxE1ii5RHbbGRsHSO8D0eJtZE1gGa0JUjCTsNxI1WgJu1r2DH/Vm7O8lXOF8sdWdvVnixy/gqrBkIjRuRQfsD0enVLMp+tlGEXJEKURa7hPsRg7Mak7aWvABCNiOHxuskEJhqbfG/QLf4QPyHugQPqkan3gQKKFLj19uH7CKdOaknh/w14EDP2TbFANiUPc2Z1ads3w6OEsgzKZTb8ywMCP6Ad3qirx1/rfe4zJtIO5eE1h7LzoqR+ZY6gEsbPLO8+JSl9XxkFaUZQSuJlyMF1QaK6yWe25C2uPZNDBjGu
 frhk4VR2
 LWpSgCxX1SBD98QwOij371RpPCSBjFj9/kicaV0VRyWxmC7zd/9DYyD3HiEgXWs2P/r65vD9IUjeWTszzJN8yBVA9SFu3xF44rWThpkVrwjpCZjH20Mxuqy2ULs70YkTDj49r2pESPJ6RyQW/MGpE+Ad6NFU2Pk8kczJTuVGAKLC01GzIfWZCpwhzMwXS52f6BIKKhxoULnUpTazfzeXDKxczkGnQZTeRcUMnFG6CPx119/lGF27ZLQNnzoe/pWxI62QSV/25Afcjfoe6b1zcCO5QzI4ZeQlTiHfG
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
index fac11b7e7443..df7ecd683c26 100644
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
index e3c2f831e15a..ccf42002ce86 100644
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


