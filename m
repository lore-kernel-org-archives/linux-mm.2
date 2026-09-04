Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB544C61DD6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 12:37:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 109146B009D; Fri,  4 Sep 2026 08:37:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DA386B009E; Fri,  4 Sep 2026 08:37:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0B2B6B009F; Fri,  4 Sep 2026 08:37:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D19FA6B009D
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:37:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 68658809C1
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:37:20 +0000 (UTC)
X-FDA: 85176030240.05.3004598
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 814AE1A000E
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:37:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=H+QTRfGv;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788525438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gx5svCkyzSWUSnqrJkt250xyLy3ELM5P26EI4TR9S/4=;
	b=YokQBElMLdLg1YTnprHwwfaNhAcrZLMFBbW6Kp1FYNd3gY9EAnXOWMtoJ9UyQeFl1MiVyh
	dAPhpoLGWgUhjV6GsbtD3bl+u775BZIfsQVIPKiZNYBYTzKW2E0Xv3Qqjbew94OzuWMDS9
	Kl0EN+x0SGxbpO//wCHYYRbSYD1rMJ4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=H+QTRfGv;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788525438;
	b=sedJi7hdoMGoscPVtnS7EwRqCXWotYvgVhctR4ZnIuVQp/IlCZKZyCf1ZFN0f+G74Kj9/K
	OZcOUdDf34mhfKEyVyZXEFn4wG4Uv2VBXh5OM6VnxUendvAXU8igT5amng/0BhQ4TmQ4FH
	axZtQFPt+Tx2yfOXXGT52hBP8UxO0Hk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 04ADA153B;
	Fri,  4 Sep 2026 05:37:14 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 24DD53F673;
	Fri,  4 Sep 2026 05:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788525437; bh=PaV4fKVEk3sHtTHeNAvSuLFmGL/ntvcoqe2PCAK0wto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+QTRfGvlDzBznPePbYINvERlylhva5YO0mFnBwrF8qWugD06eQljRsbs1PPfA/b6
	 1BYj+CI9+L3mqYTgmQsUSFqeVS6qukTvKjCVG4oayv9khY+ayroOY/1Jt4J50d2rvQ
	 T1IVSNEslSCFY6N7aoQSkvJWuMZZNjHR41E8ImbI=
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
Subject: [PATCH v9 4/6] tools/mm: move gup_test from selftests/mm to tools/mm
Date: Fri,  4 Sep 2026 18:06:29 +0530
Message-ID: <20260904123631.198697-5-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260904123631.198697-1-sarthak.sharma@arm.com>
References: <20260904123631.198697-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9zscqfbrbmok4ou1r3f38onawn7mmqxj
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 814AE1A000E
X-Rspam-User: 
X-HE-Tag: 1788525438-411836
X-HE-Meta: U2FsdGVkX1+XDD/zwT51Xt3O0pJzp93YKRodviamtCq8jx/Bva8vCH6XwZTn+RWFQB0wpMbPEYXuldzj4PdZ833D9FpU6ojW5AgMBbhgssUcx/cJPl79Cm/gzC87oGLL3FbQm2cHOMe+JtCbjpO1xO3sX7pp08ohoglKP+eq8FEwhEbAWNGXEaNj6ZvIVM8R2KG5nhK5Bv3Kb1y9NK1aW3kYULyEjP3NTDSfeJ7NMPTrVVyYl+qkKUsZK5rexjDATimMS4zI3FV68C/BFTRWXxRUE/6xPCXSo+JuNcQnajmFbgaj6SFJhIFpULUkSPLdkjSPKpblTl/Y8k8u4A0zotQWUpObp/ThnGrmuL878muTZtVnEZcOhCdIMUDe1yC8qJzlghXq46O8spfMrr6SXh8ogChdghOjpcwUOuMW6Xaznd4DUQxvi9+ZUQPMlH4XnfmKbBXiUNLU+/RRHwBo2mCJVRTG1Fk46Uru4ur9T2ox/2cPRmbuTQv3Z87PBP6GDoh22l5MlWihGyQBU8ChW2nFg6VTu7NFIYKjVFHcDmXlLI4io+7O8QFkAiMJwSO96fbF3KS6e3KwDiTQbHcv9KxTZ/vA1Qh20ssptudFRLsBzOXVxvKjB4uWaK0Vh/FhJMHRlBp5+DUpb/Ka3GRuoAwBiVScOZsHgB+EU23UMU7AymkChwt1DznJ+0hSYZ2x4KM4D7py/ENRUFPnLGb8I0I3DxpseqowNvlrJC+ymz/n2eCzEu9tHQIACaXM45rKwXzwtNp1sYvjGH1QV3jt3vS4wK0pGvhcgVbZcO3ZoMUd3uSg/A2h+zHIAD59Cc6R+Kt0FYpMzb0FV9sqXBjvj48khRIg4Q4TUPNtFI2flRdAIh3xtc66EKUJ9XNs/tw1xO+ezcEFf1qVQelbxrZjnYw0Eq8Uu5r+oDkpNnO0hdzha/0mzb9rxxsT+1Aujaqjs1Y7kSIigcNbtPgra4M
 eWE23a85
 hsIZ5yaYsMo1cCOroClhb+SY+81N6bVxHFag37GQE0DwG4pukSy5DJHTL456FQkXF773VHrI1iYZBxWz+tZuLXUnQK8mydDsZnJC+RDY9g7InjbsOx8AqFj7i1EfvLwb9jY1CZp30Kbdg9EVuqZtkxEnaCvMyXnkaxmjN++oEf0qYB52ww5ARDtH4cG5pC1wkD7/nwxihyOb4Iz5VWStmpOPkCuqI0eIBNbyHn9EvPJmWK1TZfMqka/ouN+B3yUWeKe8tZA3BiF8tjzfTD7frg5GFr6MUpl/wL70UOliWEy+ohVM/CoqTD7df6l6Bd6Gi2XOAaXvSvrggeQRRNJg1KmeSltr/qKxvNLNGU3iiHdUbR1P6k64e7BmP5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move tools/testing/selftests/mm/gup_test.c to tools/mm/gup_bench.c.
This is the first step in separating its benchmarking and
functional testing components. Later patches will make this a
purely benchmarking tool and introduce a new functional selftest
under selftests/mm.

Include hugepage_settings.h directly instead of vm_util.h and
use getpagesize() instead of psize().

Adjust the Makefiles in both locations and add gup_bench to
tools/mm/.gitignore. Remove the gup_test invocations from
run_vmtests.sh and update MAINTAINERS.

Also remove the gup_test reference from
Documentation/core-api/pin_user_pages.rst. The selftest
added later in the series is standalone and does not
need per command documentation here.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 Documentation/core-api/pin_user_pages.rst     |  9 -----
 MAINTAINERS                                   |  2 +-
 tools/mm/.gitignore                           |  1 +
 tools/mm/Makefile                             | 11 ++++--
 .../mm/gup_test.c => mm/gup_bench.c}          |  8 ++---
 tools/testing/selftests/mm/Makefile           |  1 -
 tools/testing/selftests/mm/run_vmtests.sh     | 36 -------------------
 7 files changed, 14 insertions(+), 54 deletions(-)
 rename tools/{testing/selftests/mm/gup_test.c => mm/gup_bench.c} (97%)

diff --git a/Documentation/core-api/pin_user_pages.rst b/Documentation/core-api/pin_user_pages.rst
index c16ca163b55e..e0acedbd1d48 100644
--- a/Documentation/core-api/pin_user_pages.rst
+++ b/Documentation/core-api/pin_user_pages.rst
@@ -226,15 +226,6 @@ will be pinned longterm, and whose data will be accessed.
 
 Unit testing
 ============
-This file::
-
- tools/testing/selftests/mm/gup_test.c
-
-has the following new calls to exercise the new pin*() wrapper functions:
-
-* PIN_FAST_BENCHMARK (./gup_test -a)
-* PIN_BASIC_TEST (./gup_test -b)
-
 You can monitor how many total dma-pinned pages have been acquired and released
 since the system was booted, via two new /proc/vmstat entries: ::
 
diff --git a/MAINTAINERS b/MAINTAINERS
index 285c6083ca79..d7a146b093de 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17188,8 +17188,8 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	mm/gup.c
 F:	mm/gup_test.c
 F:	mm/gup_test.h
+F:	tools/mm/gup_bench.c
 F:	tools/testing/selftests/mm/gup_longterm.c
-F:	tools/testing/selftests/mm/gup_test.c
 
 MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
 M:	Andrew Morton <akpm@linux-foundation.org>
diff --git a/tools/mm/.gitignore b/tools/mm/.gitignore
index 1446a659e540..154d740be02e 100644
--- a/tools/mm/.gitignore
+++ b/tools/mm/.gitignore
@@ -3,3 +3,4 @@ slabinfo
 page-types
 page_owner_sort
 thp_swap_allocator_test
+gup_bench
diff --git a/tools/mm/Makefile b/tools/mm/Makefile
index 858186a6eefd..f20a32d8cc22 100644
--- a/tools/mm/Makefile
+++ b/tools/mm/Makefile
@@ -3,13 +3,15 @@
 #
 include ../scripts/Makefile.include
 
-BUILD_TARGETS=page-types slabinfo page_owner_sort page_owner_filter thp_swap_allocator_test
+BUILD_TARGETS=page-types slabinfo page_owner_sort page_owner_filter
+BUILD_TARGETS += thp_swap_allocator_test gup_bench
 INSTALL_TARGETS = $(BUILD_TARGETS) thpmaps
 
 LIB_DIR = ../lib/api
 LIBS = $(LIB_DIR)/libapi.a
+GUP_BENCH_OBJS = gup_bench.c ../lib/mm/hugepage_settings.c ../lib/mm/file_utils.c
 
-CFLAGS += -Wall -Wextra -I../lib/ -pthread
+CFLAGS += -Wall -Wextra -I../lib/ -I../.. -pthread
 LDFLAGS += $(LIBS) -pthread
 
 all: $(BUILD_TARGETS)
@@ -22,8 +24,11 @@ $(LIBS):
 %: %.c
 	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
 
+gup_bench: $(GUP_BENCH_OBJS) $(LIBS)
+	$(CC) $(CFLAGS) -o $@ $(GUP_BENCH_OBJS) $(LDFLAGS)
+
 clean:
-	$(RM) page-types slabinfo page_owner_sort page_owner_filter thp_swap_allocator_test
+	$(RM) page-types slabinfo page_owner_sort page_owner_filter thp_swap_allocator_test gup_bench
 	make -C $(LIB_DIR) clean
 
 sbindir ?= /usr/sbin
diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/mm/gup_bench.c
similarity index 97%
rename from tools/testing/selftests/mm/gup_test.c
rename to tools/mm/gup_bench.c
index 5f44761dbec0..da56aa5324d3 100644
--- a/tools/testing/selftests/mm/gup_test.c
+++ b/tools/mm/gup_bench.c
@@ -12,8 +12,8 @@
 #include <pthread.h>
 #include <assert.h>
 #include <mm/gup_test.h>
-#include "kselftest.h"
-#include "vm_util.h"
+#include <mm/hugepage_settings.h>
+#include "../testing/selftests/kselftest.h"
 
 #define MB (1UL << 20)
 
@@ -140,7 +140,7 @@ int main(int argc, char **argv)
 		case 'n':
 			nr_pages = atoi(optarg);
 			if (nr_pages < 0)
-				nr_pages = size / psize();
+				nr_pages = size / getpagesize();
 			break;
 		case 't':
 			thp = 1;
@@ -254,7 +254,7 @@ int main(int argc, char **argv)
 		madvise(p, size, MADV_NOHUGEPAGE);
 
 	/* Fault them in here, from user space. */
-	for (; (unsigned long)p < gup.addr + size; p += psize())
+	for (; (unsigned long)p < gup.addr + size; p += getpagesize())
 		p[0] = 0;
 
 	tid = malloc(sizeof(pthread_t) * nthreads);
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 7cea3228020d..11ca9b11fef1 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -59,7 +59,6 @@ endif
 TEST_GEN_FILES = cow
 TEST_GEN_FILES += compaction_test
 TEST_GEN_FILES += gup_longterm
-TEST_GEN_FILES += gup_test
 TEST_GEN_FILES += hmm-tests
 TEST_GEN_FILES += hugetlb-madvise
 TEST_GEN_FILES += hugetlb-mmap
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d09f9f6a384e..8f1e828e4f39 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -130,30 +130,6 @@ test_selected() {
 	fi
 }
 
-run_gup_matrix() {
-    # -t: thp=on, -T: thp=off, -H: hugetlb=on
-    local hugetlb_mb=256
-
-    for huge in -t -T "-H -m $hugetlb_mb"; do
-        # -u: gup-fast, -U: gup-basic, -a: pin-fast, -b: pin-basic, -L: pin-longterm
-        for test_cmd in -u -U -a -b -L; do
-            # -w: write=1, -W: write=0
-            for write in -w -W; do
-                # -S: shared
-                for share in -S " "; do
-                    # -n: How many pages to fetch together?  512 is special
-                    # because it's default thp size (or 2M on x86), 123 to
-                    # just test partial gup when hit a huge in whatever form
-                    for num in "-n 1" "-n 512" "-n 123" "-n -1"; do
-                        CATEGORY="gup_test" run_test ./gup_test \
-                                $huge $test_cmd $write $share $num
-                    done
-                done
-            done
-        done
-    done
-}
-
 # filter 64bit architectures
 ARCH64STR="arm64 mips64 parisc64 ppc64 ppc64le riscv64 s390x sparc64 x86_64"
 if [ -z "$ARCH" ]; then
@@ -275,18 +251,6 @@ fi
 
 CATEGORY="mmap" run_test ./map_fixed_noreplace
 
-if $RUN_ALL; then
-    run_gup_matrix
-else
-    # get_user_pages_fast() benchmark
-    CATEGORY="gup_test" run_test ./gup_test -u -n 1
-    CATEGORY="gup_test" run_test ./gup_test -u -n -1
-    # pin_user_pages_fast() benchmark
-    CATEGORY="gup_test" run_test ./gup_test -a -n 1
-    CATEGORY="gup_test" run_test ./gup_test -a -n -1
-fi
-# Dump pages 0, 19, and 4096, using pin_user_pages:
-CATEGORY="gup_test" run_test ./gup_test -ct -F 0x1 0 19 0x1000
 CATEGORY="gup_test" run_test ./gup_longterm
 
 CATEGORY="userfaultfd" run_test ./uffd-unit-tests
-- 
2.53.0


