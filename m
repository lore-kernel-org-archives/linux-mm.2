Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 459D3C88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:10:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DE586B009E; Fri, 11 Sep 2026 07:10:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B5FB6B009F; Fri, 11 Sep 2026 07:10:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BC3F6B00A0; Fri, 11 Sep 2026 07:10:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2B01B6B009E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:10:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6164C01E8
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:10:42 +0000 (UTC)
X-FDA: 85201213524.11.DFD7C2A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 01926C0007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:10:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Wa+hUqhQ;
	spf=pass (imf28.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789125041;
	b=Ewng1I/uTnC3uzVIeWex72TdwUlc6k3n51K7H7a2m89WPVbbd0LWs1aXF1j+OkkQAkK6rH
	2af/YZqSv1HmI2zy5oN4TZeRLMKgoNXGv+ljpj9K9F6GTKhSM/oMOP4IR3CLqNwtD8cOLX
	zUt8tiHTkm0FYeZUG8zOIbgZBiU18JI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Wa+hUqhQ;
	spf=pass (imf28.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789125041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fxiK5EXuCLLpA333kMql9SivndlUqUnmBveGXEfmgxc=;
	b=UAq3P+0YAXmTFiYiEYRmNIaoQmZ1Pwq74NCq1+ojYxFg+WBMEaXlPEnNAzNHerBLeUeYoO
	1WKCv74fo+2TMwkkiSHGusyFUhQwd6DlnYkRZytsEjwLuifXvHG6VaU/1zPFaiDGW7KTcW
	Cqo/U0fSROyiuJI00bj3R3ef5QnFqCI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 797CC16F2;
	Fri, 11 Sep 2026 04:10:36 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 809CB3F59E;
	Fri, 11 Sep 2026 04:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789125040; bh=S4NDN/vWEtDNDxtlj2MR1Wvgbm9uPPczj9YQF4sMOig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wa+hUqhQnVC86b2vxe5cYtHQWz2saEaQBQiLdhUFknHKk+Gev2OP0IxctevpmUvsO
	 blHZJWS+IqFmAc/V1vEAb9inokkhQt2eo8RM0YFLJUpJPiIpj+qJlL8RRx2K2D5amg
	 QzrxIKHS5DZ9yPsWcU5ERPgRDE8O607masK3JMCQ=
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
Subject: [PATCH v10 4/6] tools/mm: move gup_test from selftests/mm to tools/mm
Date: Fri, 11 Sep 2026 16:39:48 +0530
Message-ID: <20260911110950.200240-5-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260911110950.200240-1-sarthak.sharma@arm.com>
References: <20260911110950.200240-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 01926C0007
X-Stat-Signature: kmxh7s5acty4d34o9bbeicrstxorrjkj
X-Rspam-User: 
X-HE-Tag: 1789125040-423424
X-HE-Meta: U2FsdGVkX1907tCIonq1seRF7uiF5xmOC/yW6HMrw6lv2A1jkbQE7xvgdo2Y+JvUk6fT2medGTSvQbm4mfGiTK8SKdNNscNcuqlgy5hoQRW+uZCCzxgS5EOwsQMr1A7/YS6sBtRzPSE3WVm4R64S0wE5w6s8SVup7XOKAAs3bqeBV49rL1//TUc86Spxm9fPptHWnYOv0VeRKsDIMyMWoL1BJAthWJbKzmnDK4vUYKaQ0FPRgeTigwgbhsvuKI60rX3g7D38xkHWxHnSmDV4ZCRmmFk0TpMj/nUbcZg8rFaQOklA5i51L0IKG03L81zOULdyqD3L1l5JYnvvUrYHZtvLlVPheZdJpZR3vn2zByIouClY6+YDZtRfVRuS+khp7h8iod++MpXtEJmi8tkFkUaxMwlV+h3vyfl3SLCULCA6MTqrXycUPOZiHI+wRzPpIU4jTB2Q/Jds3X0dsBXuqgBzoAtNUzJzZl5nz4FPb/UFlLRijSZdqxXDiffj+fJKM6l/Cs5f6lCmMlleh+F3t5rC7rv6RW2sQsOIeM7F+XuoB8heeT5XBZv/YBrOPyzS35FkrprewJG8i74bQx7YrboE+boACCt3C/KVrZzKJq31mX8wUL6ms6a6SKYqCcXsYsUwzJ05XpkQQObrjfcgSq5z6mDnjoP/3pz/XNy1sLpfKk0jVVVMbGD8+T8ts4eM7zjGuASfju6Q6UNaBLeIFRwTjzJ2QPLxMtNyXUAFcqQHRacJI379/uQNOPQe/BSzFBWa+rEBPU8yISl7weVtrsT800RWB3eJs3+yilQmI1t0bPuYRDIppBA9fb0Td9vV4UYC/Su9bKHrPulx73OEChYMRevv5FJQxT8ijblSoxPVK+fDPYfDY04HqtEISzoniMoB3OY8vcK/0ZSq2VHl+PfmKMH99o/riNJ5iWwNB1FwL3EXA/FTwjJN1EnPtk6WjD5g+sEfzO2rMOnzXkh
 bcuxjxkT
 tATfy1RGIWLTi5Q0oNKzIe7n1SuEV820ZxPC7C0l4wMItZ3HLTVPwUEfUL/xsN494qMa6KjF4yVCl7UEonzLbXBlxPTnVJmvKUwsVCarGlUojcgP3mG3syZImkjDwTmQXynAP9n9Bh7xk3bxyxw6eIo2TXEBgCQoDKcHJm7oku6nDMld1BtCjwmn5jHDwkBbIdBCRYpQsHCbPpR/ozJ3KWMWIzKGnHKr7VKmk0OtN/AzFdTLCbvoH9KqCPnWQQMkLAtO7PShA6q08Eabtm13mArKt8dRLNYPb5WWPFJj2P/Em289HrV+du5N+NFtg1Bj7MNySvLtS40HRfBxdlTSIMP9qMXLW3BVVuBPyEg98qSLhbhcf+E2qR1RQJQ==
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
index dd5374a1a3c2..cae3af861a7c 100644
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


