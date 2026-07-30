Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE8B2C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:09:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C54E26B00A9; Thu, 30 Jul 2026 10:09:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDE066B00AB; Thu, 30 Jul 2026 10:09:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACDA56B00AC; Thu, 30 Jul 2026 10:09:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 731EC6B00A9
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:09:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 123FE4018D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:09:14 +0000 (UTC)
X-FDA: 85045625028.23.A206C60
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2439FA000F
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:09:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MCzpruMX;
	spf=pass (imf25.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785420552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XcUiImPDJ9C2QrTSTZKgaPbeSjWpe6GMh9MFaUfGC50=;
	b=STHBkNuE0K9+Fx7ULN5MSQO31OsKlwU8TYMnm0jRxcjVEOvjhgewnRp0FLviCBZuXrPElz
	3L59WovkJAVFEwafg6RlUR7QnDA/JPB7SWjEjMv1HrbG354Va7k6KYCqx8v9tTSHEarf65
	GuFeJ3FiWHC+gJ9gAnDo8tXBTlWGtT4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MCzpruMX;
	spf=pass (imf25.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785420552;
	b=4ciRhPfXhzF5A1v3Gj2lXVTkAdVylPtO4+LLUxJaRrliaIY3JyGeJXsJ5X+RdliCURoF/r
	ReFPqCIn1LzupVMrDvQ4CTkwbnkYOqeYJocBtB1WG1HalzfmIrB4tj2WiHcArqICOF+h0c
	ojXbJzzJakqqXCPwNCq6+LYxl3ZNQME=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 20A2A1688;
	Thu, 30 Jul 2026 07:09:07 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CA5183F86F;
	Thu, 30 Jul 2026 07:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785420551; bh=He3cI6dx5TgAcSvN8s2V8e67wOPsNXpyC0MHPB4aSCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCzpruMX9wiXMWXgZG4YfpxM9DEkC0S+MohLIgUKCVGzEEErZd6dwE7uroLmn4+A6
	 7wMN2tm+wdbbjeA5db5Ok6cHy3TeHJf91ZNwxlCwVrN1s5V1o+c8XEc5JVK3oaIeAc
	 y5MZEt1HE+EEMK12slOvIJoGrRf5zTkh2fiLRWn0=
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
Subject: [PATCH v6 4/6] tools/mm: move gup_test from selftests/mm to tools/mm
Date: Thu, 30 Jul 2026 19:38:23 +0530
Message-ID: <20260730140825.238130-5-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260730140825.238130-1-sarthak.sharma@arm.com>
References: <20260730140825.238130-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2439FA000F
X-Rspamd-Server: rspam01
X-Stat-Signature: jd9ifcbwbmxq5ad1ozrzg345f9ub3ucg
X-HE-Tag: 1785420551-478071
X-HE-Meta: U2FsdGVkX1/7buFT+h01RhaSt4Sz6q0c5daSj3gRIdebuedN6Mla+PjmNaFLUX+W++zKRVFeYw8ljvvi+cbaebMV7+tnu/Op7DAY5HSH6xX1+E5wj/Y8aE3TGefJGaRQ3KTMIaGtT2SyOfJfpu/0Tn6MOAdxhbJS0yCf62NoxpFcnkFh5Jg8eKMFbAX7LpAGLW5nQepw/+fRs6rZLdVkgvwBw2FAUyAQdTotkmHSop5cZxW1hqwfF1ItjPGoJudE+kHz3MkAm6eSTNxNUb8SGNqVXg77HZzVzcS4gw1MunjT+tDTKb4pnDJqgJKSBsBLHJRnM3GIFqtlKQssCQSnKjwhuOQLmvk2gNRTuNdpgKtxjC2jip5SOflU0m4ssJoOm5Cg8Jo04iS3A98S186PX2dT5wreX8tGiQKTHDiKJ0Is0W0MBD8RbqHeazJ0v/ngvJDYVLjW5Dm2zJ+7y2mWOSz7dw4wd87oDT05wiQGFATjodIILFo8FgoiSPNFr6rcEV8VPDlTdorDuS3ldqqR9LFq4mrRZQLgNlARt0XysnM8aBR6+2vgF1seSjYneAZZu4VhNgZF0tAPNKxKDYve5ZuDonuXBQqwOrX6Hm5CXv55IYDw+AUo5HwVUd3rFrjHyHljeyq+sR44kB2DJkR+3J8Mj0M6VImm+JeIZzqbmhhquyUuXHfBnY2G8xEjDmvw2fL+ooRs4WXxtXEi9SgBa7wnCduJyvxFKbuaQ0/HrgJWD6S1o6t5X0ILxscgruivDlYvj+kMMMA4OYtqLilBpm3YCJRfvkqv5WOF6HfYDJoYcXpE+5kW1hKdaquwxmzi3tpkY2oCZfNjHZPwsu7L+eJYVElZ4Q5dToWLE+DXc84AFPwAM9gTPWCaaQGwSYTaE9nEgmMpDPcZspm8C6IzyW1J8LaRDcYsIwRF2Leoi6tDNX9iRXnLsc9JhvD8TmoekYxTrKbp413gcRYvjIO
 iXWEb6Tw
 JleY/YBwqyU7VWQEZhyCAMwthyfQ587c1ICK1xI6LgzAYjdwxxmwzO0ojnT2AX/Q5NMO2s6ln4IA+M9VX+uvwCW7sZQxWK/i9QweG8ESc/kypTloLanM5KQh7muqFD4XTpIw6F6Ro9NVa4ZTqOOOypa0Fars1hif2+3d7yFdPBXA3PQpgUJkchYtVmH19IACYaCP1lbeBz3WQBr6Fw+uMc2pQl9qdtgxicXAEdxOOBgVTdqwP0lFi4IJN0N4rhiWn7cxXNdew8xa4YnqcObCMOrBGC+e4fBorUX2I77ZAxYZbWnVQDe12fxNFpbw1vdplMLMCPQERPDf7wS1lVvMHkFPoGJ1Bfip8oBqUZCo3A4WRCbPq0VASm2dRXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move tools/testing/selftests/mm/gup_test.c to tools/mm/gup_bench.c.
This is the first step in separating its benchmarking and
functional testing components. Later patches will make this a
purely benchmarking tool and a new functional testing selftest
will be introduced in selftests/mm.

Include hugepage_settings.h directly instead of vm_util.h and
use getpagesize() instead of psize().

Adjust the Makefiles and .gitignore files in both locations.
Remove the gup_test invocations from run_vmtests.sh and update
MAINTAINERS.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 MAINTAINERS                                   |  2 +-
 tools/mm/.gitignore                           |  1 +
 tools/mm/Makefile                             | 10 ++++--
 .../mm/gup_test.c => mm/gup_bench.c}          |  8 ++---
 tools/testing/selftests/mm/.gitignore         |  1 -
 tools/testing/selftests/mm/Makefile           |  1 -
 tools/testing/selftests/mm/run_vmtests.sh     | 36 -------------------
 7 files changed, 13 insertions(+), 46 deletions(-)
 rename tools/{testing/selftests/mm/gup_test.c => mm/gup_bench.c} (97%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 040a8e6664f4..5845fa74a5a0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17027,8 +17027,8 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	mm/gup.c
 F:	mm/gup_test.c
 F:	mm/gup_test.h
+F:	tools/mm/gup_bench.c
 F:	tools/testing/selftests/mm/gup_longterm.c
-F:	tools/testing/selftests/mm/gup_test.c
 
 MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
 M:	Andrew Morton <akpm@linux-foundation.org>
diff --git a/tools/mm/.gitignore b/tools/mm/.gitignore
index 922879f93fc8..2bfb295af498 100644
--- a/tools/mm/.gitignore
+++ b/tools/mm/.gitignore
@@ -2,3 +2,4 @@
 slabinfo
 page-types
 page_owner_sort
+gup_bench
diff --git a/tools/mm/Makefile b/tools/mm/Makefile
index f5725b5c23aa..d82cc8c43ee0 100644
--- a/tools/mm/Makefile
+++ b/tools/mm/Makefile
@@ -3,13 +3,14 @@
 #
 include ../scripts/Makefile.include
 
-BUILD_TARGETS=page-types slabinfo page_owner_sort thp_swap_allocator_test
+BUILD_TARGETS=page-types slabinfo page_owner_sort thp_swap_allocator_test gup_bench
 INSTALL_TARGETS = $(BUILD_TARGETS) thpmaps
 
 LIB_DIR = ../lib/api
 LIBS = $(LIB_DIR)/libapi.a
+GUP_BENCH_OBJS = gup_bench.c ../lib/mm/hugepage_settings.c ../lib/mm/file_utils.c
 
-CFLAGS += -Wall -Wextra -I../lib/ -pthread
+CFLAGS += -Wall -Wextra -I../lib/ -I../.. -pthread
 LDFLAGS += $(LIBS) -pthread
 
 all: $(BUILD_TARGETS)
@@ -22,8 +23,11 @@ $(LIBS):
 %: %.c
 	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
 
+gup_bench: $(GUP_BENCH_OBJS) $(LIBS)
+	$(CC) $(CFLAGS) -o $@ $(GUP_BENCH_OBJS) $(LDFLAGS)
+
 clean:
-	$(RM) page-types slabinfo page_owner_sort thp_swap_allocator_test
+	$(RM) page-types slabinfo page_owner_sort thp_swap_allocator_test gup_bench
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
diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index 9ccd9e1447e6..c30cd7ce635e 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -38,7 +38,6 @@ uffd-wp-mremap
 mlock-intersect-test
 mlock-random-test
 virtual_address_range
-gup_test
 va_128TBswitch
 map_fixed_noreplace
 write_to_hugetlbfs
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index e77c4cc41b47..44b16cbaee5b 100644
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
index 8c296dedf047..263e4940cc1d 100755
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
@@ -276,18 +252,6 @@ fi
 
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


