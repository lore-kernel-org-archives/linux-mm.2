Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5196CC5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 18:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 305476B058D; Thu, 13 Aug 2026 14:13:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B3D26B058F; Thu, 13 Aug 2026 14:13:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17DBA6B0590; Thu, 13 Aug 2026 14:13:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E0F266B058D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:13:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7DA7BC0264
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:13:55 +0000 (UTC)
X-FDA: 85097044830.22.160A164
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id B02A9140008
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:13:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nrE++Zfr;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786644833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OfxWQEeIiflFoDnW6+WVEDzB5YWYy4jIur4j0a55qSo=;
	b=0z+0L7b2Ndm8w8GRhiVVucr+n2ms/GGKvdMNHlHa+/IGVeStIP5C4a2J+w0U0LDokXurP1
	QffpJdMPW6NAxC1ODr0xcSjgZrXTLZjt0LeYNWnjsScXgMhzYfMXNHdNH7R7m1NUcC23U6
	NHC8nx89njv3E/NUkE1kCMapCCKZFDs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nrE++Zfr;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786644833;
	b=e5ZpYpeSXKDgelvQKrmVEPPap14gsJ+c+GFxgSWUlu/866TBjw1/68RNYshY//k42hFJEp
	oJqWOOhimAPzdjVuHHwzJpqYcVXjK4qmetRKLgn+3GOy0onAReydhOxp5Dw54qubJFnPAE
	ng8kqRlGexuY29HpJxpdHb8DOs5alF4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 000C51BD0;
	Thu, 13 Aug 2026 11:13:48 -0700 (PDT)
Received: from a081061.arm.com (unknown [10.163.171.218])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CE3563F66F;
	Thu, 13 Aug 2026 11:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786644832; bh=Mebmz9U8+i5LX4tbjFQujhv1HsEzq7ezHcBNRzXoKs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrE++ZfrRac/jDoI4vXJ9gSM2+PRr3LYrhk0Vacv5oDBsgvvSaFWhdc5HU59k//s1
	 PMIfaVdfjCz+Ff/R0pj0fJvtfQ2mEdPum2KDjG75hPuhyWtllcXzqzIdyEYsiVAxOX
	 U6wb+9PQ/4E3Tv70RjCIEOr7iD1SzrWPkBwz38Kg=
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
Subject: [PATCH v7 4/6] tools/mm: move gup_test from selftests/mm to tools/mm
Date: Thu, 13 Aug 2026 23:42:28 +0530
Message-ID: <20260813181230.483746-5-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813181230.483746-1-sarthak.sharma@arm.com>
References: <20260813181230.483746-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B02A9140008
X-Rspamd-Server: rspam07
X-Stat-Signature: 9mya1q1iz4mqonzs9z7uiuny1ewmu8nt
X-HE-Tag: 1786644833-628494
X-HE-Meta: U2FsdGVkX1+AGcV22dl+Ks4svvgRhbwKSrgazniVXFkeEa+LodF7xn4reroo2hez778dOtEzAWfaRF2FsUqqrIGpaS5nvF1YO/j1KXKXmB1xgF0lAYCor9p6CVKtMPZYIa24PC3Rd4eKeOSldd/eFvFRpybbG36Sk7JjhZ1+gN87JICgITFEJtQBamYG64uDN0V/KlH2kOMQgHgSrLHamcbL9fJRjIvLyh9hqrn0Gtt3VwHROLmGICtsFwDdBo4Myi0idsqfPa12WnBIBmWeBpdrzlJGAfnps/C/r85RC2tCzbR5u3lqr93DNJdXGucf+dge8mIuutExcmJpHAAVAcjqey1KfXTXPieKbmnPaeAeu9umk767PanxGZ60/fSm4DrIf0rN7EAIgdZDwXlB+5l55GohJEqFNBGo2xT18oemOBH+0Yr7I3CHww+znydIHBQ4Tdgi4XAVvAF0pCy2NPL3pRo9a5qn12OtMnFuJua4ooj0Qc/LJHY0uwt3NASwlN7BIsxlE1FXCmpRjg50a+MWeB9pYS2E+aSqRfKKqYiM3m9opOivrwaN2w4R51w/feWCHL5R+T+Wp+mRM3nozy0Om7YB/hiUemMv81iTyGWXNWQTdid5PLHjkupzxzezz1aVnWJaeTrbtvpk4OcBlhDMb0yczNypk6jXCn4lzAxkSSlQO0mgBgxE5B/BQEE1+K1WubBnfstV36h93kTZTMBaBQM6jBk6vayeAlYwycvYJZnikKOEDBC/kEjC/Gpm0DaUGtioJZQDOu4ses6IeeluPew6K698hYHBxxY0L8IBOGs64n+KqHf78LNKjmH8hYFoV1Tm/NiZnZNDmUB4ONR0FfGMbSpRxDXnD7i4vZRxV28rAAE7UXdRxw+3lxpNSPzxjfonMEv/a9Z1NabHxZelXiyKiVCDayo8F0nNOvvzFqok2Tx48CBFDVGsn3D12Ery7ZEvNiXIAGfx+Bh
 iKAE3kwI
 SdVW3NFUNrAwI2ibd99jfUHQHs68ELQEy+bKW8P3ACw5C3eLMlTtJod1ODYYWwRPy1trKXlreMIOS1K/iQ9SbybFFueO/WeIkHcZq0g3n5ZxVcmE5+bVhctgGrSOE1Bw/7ed3Z/cdfDpyDCGg7g0vcOlP8YAN4IQIr+0Y0WlCjv6kkrsjCLJwRQOwd70ZUECM1hUJLcYdnYsgDly+WmFG81wB5DdwSM+5B89MOmwJnMRGFKFu+y8OlCQBMOUbhpC+cLyq6A8hWqKVhVtbjffQ43kbwv95jfW2z3RCnhvVqKlW4eGv648qozmjD+GplZ7Yie25WxMk8VtDBQLi6EJ0DXTU//xIBAH2XEXOwephnjWCvnD5nUnELZ8G+w==
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

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 MAINTAINERS                                   |  2 +-
 tools/mm/.gitignore                           |  1 +
 tools/mm/Makefile                             | 11 ++++--
 .../mm/gup_test.c => mm/gup_bench.c}          |  8 ++---
 tools/testing/selftests/mm/Makefile           |  1 -
 tools/testing/selftests/mm/run_vmtests.sh     | 36 -------------------
 6 files changed, 14 insertions(+), 45 deletions(-)
 rename tools/{testing/selftests/mm/gup_test.c => mm/gup_bench.c} (97%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 952e04fcc046..ed9a8549ae31 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17031,8 +17031,8 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
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
2.39.5


