Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F307C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 12:37:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60C326B00A0; Fri,  4 Sep 2026 08:37:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3C36B00A1; Fri,  4 Sep 2026 08:37:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D37C6B00A2; Fri,  4 Sep 2026 08:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 23BE96B00A0
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:37:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A33431C3567
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:37:36 +0000 (UTC)
X-FDA: 85176030912.11.CA4E1CB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id EAE8D20003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:37:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=n7JCvEhN;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788525455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Xd009nMFyF0S7L/c4jzCzRgdMGcYfkRWLC6WFn2y4o=;
	b=gDDyRd36Ws0/ZADdMRMGxI99dEp2Seqy5sVEh6PO+3dLPuKfViEhj2TDkDAgfIbWYYm4s0
	qUulKNvs9HajffIk3kCI6Wjn3nDHRYv7g8Libzsa4YzLSBnCwreLFzF0VR4dqk+yuOtveA
	hqJn1py7Lb2G5tZC1Jae17ZD/MS6hMI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=n7JCvEhN;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788525455;
	b=kxAY/eMtFEWrkNtLtiCJzVa4WcjLu9ka/fNZC3xp5O0RPsJsQcWZi2Cicbi6uh0hJDr/lO
	9fspSp5dPdfu/JzRfhbz6wfH1TQsI+utn0Suhf9ZigE/v6cpG8LlPxxAf4TGkcQJIZ8CBl
	DDBnsXS7mIKAS2+7sATghZk2qfvPpfk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 572CA153B;
	Fri,  4 Sep 2026 05:37:30 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6D8EF3F673;
	Fri,  4 Sep 2026 05:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788525454; bh=r+JWSjJAT1fqdxTkYFXC3Z2CcMa3Z4KrLaVw0tw7b+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n7JCvEhNnTytRWE4CVZZjXVHRGzXMrHxayjQQYeqI0qzwVWZFI0pY2ZhyyFCWuIIF
	 J2rY0yGrp5lFNbzEZKKubKwsFdzN629SDat/52/kp2uQ3AC0NvSMZbVnMkc/kC4AVi
	 0wZRFcG3ndHd9lOSkUA5zH+6gWLgo4TRg+0qdlPo=
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
Subject: [PATCH v9 6/6] selftests/mm: add a GUP selftest
Date: Fri,  4 Sep 2026 18:06:31 +0530
Message-ID: <20260904123631.198697-7-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260904123631.198697-1-sarthak.sharma@arm.com>
References: <20260904123631.198697-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: fqzt5rpq7uwj4wwd7mpt59wrp4c6gk68
X-Rspamd-Queue-Id: EAE8D20003
X-HE-Tag: 1788525454-573932
X-HE-Meta: U2FsdGVkX1/PkEUbQ62+w8Ui8NHdZfxAXDh3RbUcE6UhEOoDYwdpZARPzWOWW/PhVpOMn9tW0bT4UlUG6LLKmpqC2W7CHS4sa6MeHVWcezxlvy09Fje3z6DxqnMAY8HlJiZm13pT9pxjQ8OC2PT6mcw4lI/JFS2ZWuTAM/0kLatMpKJjpkZfnan0AP0RqM3ltQ/XUqfsIUcTGKokVIXZKOqxNzDP8q1Dq617UdIzQNnKxjCpoWO2Vvz3k0oQk45JA36ngNRsis7mDfpI8YjH821Ud/ysfz9pMBuGn0/x7Oi+skxLk07tDPWp7xrcGbTdZB24OPWOM/2zxCwjv50IW4xKlcHuX8VhDZTHeypqTOdEEViVzmYkxuW//kcmckm13LMZwzi9/mtDUEVBUq7a8TtKYTWX/WrXnNRUCWwWRmJZiJPvCCS4gDB7fKD2O7ER7S6KA3t2Icpg/BD+Di3eWGrmmPOLDNstk9kh8Q/jyIiZv4eHitzxlm4Qx9d66Jp/XOs4qukmLD5aI0Q+E4tixTg6lZ6QV10dB8KygQbD82CcPC5ymOtnLJOBBc0U96w/HYbJyt43ahCNEE5a0b3Gd6hHYGM6AaXzPlRiEMR0/fulbIn66cFxWm0zjhdzykX04XQRRHg+mU1p/Fq8CbUahbZNaWzxa5emuRSqgRWIoo2QOGP5Ea7s2RPe3Ev8VKncV3qQ0JLatheN50PAK9aHYe5mQEIlsq1eFXcNukO1GUapCCvMoMg4TtKHECasnAPEgzxfhvvFv94aOnSdVIhW4LFfQncBcpyBJp85JSrZHRleWj94cRyzUDcaa2c3bokRTq1jQ97o/kthPXMAxsGbZrlpfeq8rr5uQL+xkbGDAjnhujvZV2Reet3VilxZqE6hT/Vcke71f+7L9b7dUQ8wXT09KNxyVTSbYUlNAjb05HOME6yYIvx/LHKPAOnWfRDVY92qQPvjXJmHLMm3JGD
 2/K/FnKR
 JIpbWSLc0cnbNvWJEDKnZbJG+ZFFD4DwLOjgoTWQx4BHwuJVJyyo72COAlnyFR+HoP9SMDA1e6ciL8umjlrFEMpGaW1/5ddZPW/dzrlWb/V8uiT1B/M9G3mWF8OOQCFRB7asxa3mK9+F8jp35Ei69M7zRuHJUjcVCfUv1iFJ+708P7YfwFsCREI3xZ+LorjXVBuHNGR95L9FLXJGGVh/G6ovOi3biQ6UR4Nq8pLpW1DLzDum5xGhpjuK4mhGjgUIkNBltP+H/z11E9Mk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new GUP selftest which uses kselftest_harness.h. Cover
12 mapping configurations: THP enabled, THP disabled and
HugeTLB, each across private/shared mappings and with/without
FOLL_WRITE. Run 5 test cases for every variant: get_user_pages,
get_user_pages_fast, pin_user_pages, pin_user_pages_fast and
pin_user_pages_longterm.

Choose the number of default hugeTLB pages using a 256 MiB target,
with a minimum of 1 page and derive the mapping size from that
number. This avoids reserving excess memory when the hugeTLB page
size is too large and retains 128 pages for the most common case
of 2MiB hugeTLB pages.

Sweep four nr_pages_per_call values for each test: 1, 512, 123 and
all pages. This preserves the coverage previously provided by
run_gup_matrix(): 12 mapping combinations x 5 GUP/PUP operations x 4
batch sizes. In total the selftest reports 60 TAP cases and issues
240 ioctls.

Do not carry DUMP_USER_PAGES_TEST into the new selftest because its
output is written to the kernel log and the selftest does not verify
that output.

Add the new gup binary to the selftests/mm build, run_vmtests.sh and
MAINTAINERS. Update mm/Kconfig to describe the benchmark and
selftest split.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 MAINTAINERS                               |   1 +
 mm/Kconfig                                |  21 +-
 tools/testing/selftests/mm/Makefile       |   1 +
 tools/testing/selftests/mm/gup.c          | 287 ++++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh |   1 +
 5 files changed, 300 insertions(+), 11 deletions(-)
 create mode 100644 tools/testing/selftests/mm/gup.c

diff --git a/MAINTAINERS b/MAINTAINERS
index d7a146b093de..1ca7de3e440e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17189,6 +17189,7 @@ F:	mm/gup.c
 F:	mm/gup_test.c
 F:	mm/gup_test.h
 F:	tools/mm/gup_bench.c
+F:	tools/testing/selftests/mm/gup.c
 F:	tools/testing/selftests/mm/gup_longterm.c
 
 MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
diff --git a/mm/Kconfig b/mm/Kconfig
index c1ddf59c0d71..79163b7d795a 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1287,24 +1287,23 @@ config PERCPU_STATS
 	  be used to help understand percpu memory usage.
 
 config GUP_TEST
-	bool "Enable infrastructure for get_user_pages()-related unit tests"
+	bool "Enable infrastructure for get_user_pages()-related unit tests and benchmarks"
 	depends on DEBUG_FS
 	help
 	  Provides /sys/kernel/debug/gup_test, which in turn provides a way
-	  to make ioctl calls that can launch kernel-based unit tests for
-	  the get_user_pages*() and pin_user_pages*() family of API calls.
+	  to make ioctl calls that can launch kernel-based unit tests and
+	  benchmarks for the get_user_pages*() and pin_user_pages*() families
+	  of API calls.
 
-	  These tests include benchmark testing of the _fast variants of
-	  get_user_pages*() and pin_user_pages*(), as well as smoke tests of
+	  These include benchmark testing of the _fast variants of
+	  get_user_pages*() and pin_user_pages*(), as well as tests of
 	  the non-_fast variants.
 
-	  There is also a sub-test that allows running dump_page() on any
-	  of up to eight pages (selected by command line args) within the
-	  range of user-space addresses. These pages are either pinned via
-	  pin_user_pages*(), or pinned via get_user_pages*(), as specified
-	  by other command line arguments.
+	  There is also a test that allows running dump_page() on any of up
+	  to eight pages within the range of user-space addresses. These
+	  pages are either acquired via pin_user_pages*() or get_user_pages*().
 
-	  See tools/testing/selftests/mm/gup_test.c
+	  See tools/testing/selftests/mm/gup.c and tools/mm/gup_bench.c.
 
 comment "GUP_TEST needs to have DEBUG_FS enabled"
 	depends on !GUP_TEST && !DEBUG_FS
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 11ca9b11fef1..9c03624fd293 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -58,6 +58,7 @@ endif
 
 TEST_GEN_FILES = cow
 TEST_GEN_FILES += compaction_test
+TEST_GEN_FILES += gup
 TEST_GEN_FILES += gup_longterm
 TEST_GEN_FILES += hmm-tests
 TEST_GEN_FILES += hugetlb-madvise
diff --git a/tools/testing/selftests/mm/gup.c b/tools/testing/selftests/mm/gup.c
new file mode 100644
index 000000000000..6a0dd415fb9a
--- /dev/null
+++ b/tools/testing/selftests/mm/gup.c
@@ -0,0 +1,287 @@
+// SPDX-License-Identifier: GPL-2.0
+#define __SANE_USERSPACE_TYPES__ // Use ll64
+#include <fcntl.h>
+#include <errno.h>
+#include <stdbool.h>
+#include <string.h>
+#include <unistd.h>
+#include <dirent.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <mm/gup_test.h>
+#include "vm_util.h"
+#include "kselftest_harness.h"
+
+#define MB (1UL << 20)
+
+/* Just the flags we need, copied from the kernel internals. */
+#define FOLL_WRITE	0x01	/* check pte is writable */
+
+/* Page counts exercising single, THP-batch, partial, and full-mapping GUP. */
+static const int nr_pages_list[] = { 1, 512, 123, -1 };
+
+#define GUP_TEST_FILE "/sys/kernel/debug/gup_test"
+#define HUGETLB_TARGET_SIZE (256 * MB)
+
+static unsigned long nr_huge_pages, hp_size;
+static bool hugetlb_setup_succeeded;
+
+FIXTURE(gup_test)
+{
+	int gup_fd;
+	char *addr;
+	unsigned long size;
+};
+
+FIXTURE_VARIANT(gup_test)
+{
+	bool thp;
+	bool hugetlb;
+	bool write;
+	bool shared;
+};
+
+FIXTURE_VARIANT_ADD(gup_test, private_write)
+{
+	.thp = false,
+	.hugetlb = false,
+	.write = true,
+	.shared = false,
+};
+
+FIXTURE_VARIANT_ADD(gup_test, private_read)
+{
+	.thp = false,
+	.hugetlb = false,
+	.write = false,
+	.shared = false,
+};
+
+FIXTURE_VARIANT_ADD(gup_test, private_write_thp)
+{
+	.thp = true,
+	.hugetlb = false,
+	.write = true,
+	.shared = false,
+};
+
+FIXTURE_VARIANT_ADD(gup_test, private_read_thp)
+{
+	.thp = true,
+	.hugetlb = false,
+	.write = false,
+	.shared = false,
+};
+
+FIXTURE_VARIANT_ADD(gup_test, private_write_hugetlb)
+{
+	.thp = false,
+	.hugetlb = true,
+	.write = true,
+	.shared = false,
+};
+
+FIXTURE_VARIANT_ADD(gup_test, private_read_hugetlb)
+{
+	.thp = false,
+	.hugetlb = true,
+	.write = false,
+	.shared = false,
+};
+
+FIXTURE_VARIANT_ADD(gup_test, shared_write)
+{
+	.thp = false,
+	.hugetlb = false,
+	.write = true,
+	.shared = true,
+};
+
+FIXTURE_VARIANT_ADD(gup_test, shared_read)
+{
+	.thp = false,
+	.hugetlb = false,
+	.write = false,
+	.shared = true,
+};
+
+FIXTURE_VARIANT_ADD(gup_test, shared_write_thp)
+{
+	.thp = true,
+	.hugetlb = false,
+	.write = true,
+	.shared = true,
+};
+
+FIXTURE_VARIANT_ADD(gup_test, shared_read_thp)
+{
+	.thp = true,
+	.hugetlb = false,
+	.write = false,
+	.shared = true,
+};
+
+FIXTURE_VARIANT_ADD(gup_test, shared_write_hugetlb)
+{
+	.thp = false,
+	.hugetlb = true,
+	.write = true,
+	.shared = true,
+};
+
+FIXTURE_VARIANT_ADD(gup_test, shared_read_hugetlb)
+{
+	.thp = false,
+	.hugetlb = true,
+	.write = false,
+	.shared = true,
+};
+
+FIXTURE_SETUP(gup_test)
+{
+	int mmap_flags = MAP_PRIVATE;
+	int zero_fd;
+	char *p;
+
+	self->size = 128 * MB;
+
+	if (variant->hugetlb) {
+		if (!hp_size)
+			SKIP(return, "HugeTLB not available\n");
+
+		if (!hugetlb_setup_succeeded ||
+		    hugetlb_free_default_pages() < nr_huge_pages)
+			SKIP(return, "Not enough huge pages\n");
+
+		self->size = nr_huge_pages * hp_size;
+		mmap_flags |= (MAP_HUGETLB | MAP_ANONYMOUS);
+	}
+
+	if (variant->shared)
+		mmap_flags = (mmap_flags & ~MAP_PRIVATE) | MAP_SHARED;
+
+	/* zero_fd has to be >= 0. Already checked in main() */
+	zero_fd = open("/dev/zero", O_RDWR);
+	ASSERT_GE(zero_fd, 0);
+
+	/* gup_fd has to be >= 0. Already checked in main() */
+	self->gup_fd = open(GUP_TEST_FILE, O_RDWR);
+	ASSERT_GE(self->gup_fd, 0);
+
+	self->addr = mmap(NULL, self->size, PROT_READ | PROT_WRITE,
+			  mmap_flags, zero_fd, 0);
+
+	ASSERT_NE(self->addr, MAP_FAILED) {
+		int err = errno;
+
+		close(zero_fd);
+		close(self->gup_fd);
+		TH_LOG("mmap failed: %s", strerror(err));
+	}
+	close(zero_fd);
+
+	if (variant->thp)
+		madvise(self->addr, self->size, MADV_HUGEPAGE);
+	else if (!variant->hugetlb)
+		madvise(self->addr, self->size, MADV_NOHUGEPAGE);
+
+	for (p = self->addr; (unsigned long)p < (unsigned long)self->addr
+			+ self->size; p += psize())
+		p[0] = 0;
+}
+
+FIXTURE_TEARDOWN(gup_test)
+{
+	munmap(self->addr, self->size);
+	close(self->gup_fd);
+}
+
+static void run_gup_cmd(struct __test_metadata *_metadata,
+			 FIXTURE_DATA(gup_test) *self,
+			 const FIXTURE_VARIANT(gup_test) *variant,
+			 unsigned long command)
+{
+	int i;
+
+	for (i = 0; i < (int)ARRAY_SIZE(nr_pages_list); i++) {
+		struct gup_test gup = {
+			.addr = (unsigned long)self->addr,
+			.size = self->size,
+			.nr_pages_per_call = nr_pages_list[i] < 0 ?
+				self->size / psize() : nr_pages_list[i],
+			.gup_flags = variant->write ? FOLL_WRITE : 0,
+		};
+
+		TH_LOG("nr_pages_per_call=%u", gup.nr_pages_per_call);
+		ASSERT_EQ(ioctl(self->gup_fd, command, &gup), 0);
+		ASSERT_EQ(gup.size, self->size);
+	}
+}
+
+TEST_F(gup_test, get_user_pages)
+{
+	run_gup_cmd(_metadata, self, variant, GUP_BASIC_TEST);
+}
+
+TEST_F(gup_test, pin_user_pages)
+{
+	run_gup_cmd(_metadata, self, variant, PIN_BASIC_TEST);
+}
+
+TEST_F(gup_test, get_user_pages_fast)
+{
+	run_gup_cmd(_metadata, self, variant, GUP_FAST_BENCHMARK);
+}
+
+TEST_F(gup_test, pin_user_pages_fast)
+{
+	run_gup_cmd(_metadata, self, variant, PIN_FAST_BENCHMARK);
+}
+
+TEST_F(gup_test, pin_user_pages_longterm)
+{
+	run_gup_cmd(_metadata, self, variant, PIN_LONGTERM_BENCHMARK);
+}
+
+int main(int argc, char **argv)
+{
+	char *file = "/dev/zero";
+	int fd;
+
+	fd = open(file, O_RDWR);
+	if (fd < 0) {
+		ksft_print_header();
+		ksft_exit_fail_msg("Unable to open %s: %s\n", file, strerror(errno));
+	}
+	close(fd);
+
+	fd = open(GUP_TEST_FILE, O_RDWR);
+	if (fd == -1) {
+		ksft_print_header();
+		if (errno == EACCES)
+			ksft_exit_skip("Please run this test as root\n");
+		if (errno == ENOENT) {
+			DIR *debugfs = opendir("/sys/kernel/debug");
+
+			if (!debugfs) {
+				ksft_exit_skip("Mount debugfs at /sys/kernel/debug\n");
+			} else {
+				closedir(debugfs);
+				ksft_exit_skip("Check CONFIG_GUP_TEST in kernel config\n");
+			}
+		}
+		ksft_exit_fail_msg("Failed to open %s: %s\n", GUP_TEST_FILE, strerror(errno));
+	}
+	close(fd);
+
+	hp_size = default_huge_page_size();
+	if (hp_size) {
+		nr_huge_pages = HUGETLB_TARGET_SIZE / hp_size;
+		if (!nr_huge_pages)
+			nr_huge_pages = 1;
+
+		hugetlb_setup_succeeded = hugetlb_setup_default(nr_huge_pages);
+	}
+
+	return test_harness_run(argc, argv);
+}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 8f1e828e4f39..ae0ab5efabae 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -251,6 +251,7 @@ fi
 
 CATEGORY="mmap" run_test ./map_fixed_noreplace
 
+CATEGORY="gup_test" run_test ./gup
 CATEGORY="gup_test" run_test ./gup_longterm
 
 CATEGORY="userfaultfd" run_test ./uffd-unit-tests
-- 
2.53.0


