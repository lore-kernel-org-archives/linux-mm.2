Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 113E2C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 11:23:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AFBB6B0096; Fri, 18 Sep 2026 07:23:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 287876B0098; Fri, 18 Sep 2026 07:23:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19E0E6B0099; Fri, 18 Sep 2026 07:23:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E70406B0096
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:23:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A45440661
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:23:24 +0000 (UTC)
X-FDA: 85226647128.02.B8F08A5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6436A180010
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:23:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ux7SQeid;
	spf=pass (imf16.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789730602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n2u8kJhIS99uhHkn7mQEMStzuU8wqOm04RlmcPHvm0w=;
	b=PGOUaw5DykUENMZ2ZL4tj9dLpVSGNZzWZPsQMTcOWGqD6Q0DHPYMf9IcPEWJ6q7IyUI3Hd
	hu8pdwBZlG69B0kwC1XgrHkqv6I1Hzy/hUZ3h1WimGdG7LhRDe8Bjf7OSE6ROCYDwtH+LD
	xPEyru8ExqOvxwtuY0vTxogay/J8VT4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789730602;
	b=ap8bBY5FIWLGDHjuzEloiE0Slihqe+4ycIv/V28ws+U6eG0xQyUogU80kGXmKR82V2jqi4
	QjlqJzQdgwg93yArxy0haNxfzdI4SRfTr/nNLGEIcg4kkhCfdFzpop9m9rQ90znCFBWpr9
	1RbdsdE8tkWHvSmJ8jwFZFRQ7U2twDA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ux7SQeid;
	spf=pass (imf16.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 002B11596;
	Fri, 18 Sep 2026 04:23:18 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E65CC3F882;
	Fri, 18 Sep 2026 04:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789730601; bh=ljPjjqRMMUURUiMJuppRVtMq0MGpf+iTP6VLw+3eBQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ux7SQeidTxEsfbH+e6zTPCtkzoa+p/qWkTKBk+NEirRq3oA7whFtpgZqMLaCnrzAh
	 CvD7cMiCpAkYQSRTN1gkpstVGxv1J89s9lO6p/QqCi0fOYsEMAZwc8oZ2225KB9tKH
	 7uyq3i9PRqN06Rnz4uentqJ9+F2+ofAK2wj3OoqQ=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@suse.com>,
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
Subject: [PATCH v11 4/6] tools/mm: move gup_test from selftests/mm to tools/mm
Date: Fri, 18 Sep 2026 16:52:32 +0530
Message-ID: <20260918112234.195857-5-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260918112234.195857-1-sarthak.sharma@arm.com>
References: <20260918112234.195857-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 8b9efrz1x441ecfapgfeg3w8oreotckd
X-Rspamd-Queue-Id: 6436A180010
X-HE-Tag: 1789730602-469216
X-HE-Meta: U2FsdGVkX19pbUmyHkZzy5WZ9jP9fFukAWmSnTDryPqRGsiWnOPFB8oXS6ZaiSpz4BfK+3l/kHlJUX7eDa6aWKgFXX6mwLbH7L2RQdwaKU+jpwCgYhxGXsygKyTqtLcuJ3nRZses+5T22PvCqVmWp1ilpyPoaWy464BYkU+Ph02N0DZYm5wC/hOeLUIsSVQXGv2wn39L0YSC7hFdsPu9Kh/U0FNcvNFnpRaO9cNAWtr7wII1yzvuOt6s09PMavHgUWXGV2+HPEcqksW0gXmdz3r/RKQv8VsEXLs5R+An0vegzeR+g1RLvBCZIU9pYKgNA3ips4TP5OU1yqTQ35LxDqNFMN3WO1yOTHXf7jpdfYIDof3x+4G7f/P/CjLEPlwOVXltGcZk8pP4dLdAPV1iWXE/KcSTsdGtBhvwBWB8Ag5qUtB2qP3AV5Ksq5gGZUGfDsMN1WK6jMd4tomRArWMS7y2zXGP5n5nRdZQ7jl+fP+zdNXjZ/w4cfnzK8K/gz6W5DmkinFCCVzQZjSH6bIrsKyK50uGpxob60pr6h1r3/8XZzicnVVSCB+uHnJiBNJ8X0CX5715S4sD0WL4JRItAZZUfNzevz9mhnmi2pPB+BlF6dz8Iz8pH7G4DvmLMhEclqhAk4HEmm4NXQOk+w7no1mjF0zoQNilIE+bh4ldlYM3BQRLxHJij/KDjHAzIrj/olvPYD3zDBdZc0HF1C2nHtwGPpyfqnKEvQaCr0+WcqmN7ZH2PF78lwChJV9uYXLscpnvyUttd2UoWRoKwPCEHwpoliio+ZnnG1dnD+RWen52XT8CLV66nSFH8O4hqXz4B2YhO8cbjyGrizx46eMaB6EVC4L7YLtnxzqbLQJMYlmMtQNfk7AQRSZdyB6/eELPHrHr7R1mtgkVIchv9SUG0XODvK3g3dfKHntO6p/5PiTyAgkO2DT4Krw5esjsVTamirErCNehJM5qbNaKhDm
 xdTH5J59
 UAbmnQ6vkTDnkdqQ/hOX8k9caO2ZB+JoySGgQE7G3N2L+KPK5viI066r8ClXK7a6l2JCIm6Xs7J0zd5knPOudP+cJgNRbiSBLQ9OWNfJNjZewyNVAyN+jtkiTnrOU9wM79sd0sO5dPOVq5SiSwvr+B5mFUCqw81muniUPN5hWPMfDzConwuq3+5t6dWz9Oex9r4U/VPMEyePRVNcNZx5ouN89cXAgdha3t7axj9AzMVX86w3URG7yG1bXFhe8u5oecihO2VRusfVJ4n2Tw1CTIHaG3T5mXJ1RECKAt3aSpXfRWN3Tzc97jp49Mx/wgtxpP6a0VScJBsvJPM8dWRHWbfdKCEJoDE5fhu684wAMFSxkT5LcZYhxDY+5oQ==
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
index 34f30d072499..b6104b7d8054 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17187,8 +17187,8 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
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
index 67882e52d4ff..d6337156111a 100644
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
index 19755fb4edb9..cea59dc5707d 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -148,30 +148,6 @@ test_selected() {
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
@@ -293,18 +269,6 @@ fi
 
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


