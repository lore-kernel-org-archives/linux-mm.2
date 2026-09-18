Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8470BC982DC
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 11:23:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CC036B009B; Fri, 18 Sep 2026 07:23:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A35D6B009D; Fri, 18 Sep 2026 07:23:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B91B6B009E; Fri, 18 Sep 2026 07:23:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4FBE76B009B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:23:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 85D58140615
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:23:40 +0000 (UTC)
X-FDA: 85226647800.14.9D6117B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id AAFE820003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:23:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="D2cHoCq/";
	spf=pass (imf13.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789730618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKCujTBVlmlw4M1ObfBd5+S83SdHTb1IDXGgLpKKXoY=;
	b=lwyzKjib9FhULfvAwzHNxKiIZ3KiCtjeX2vVwNOzrIYWXrBjezCOgJP00+scicIZXfUPtn
	TuONSbcJIc9sLs2pcSdAHtpPtn5VN/OfiqdliNcMnbGFX3eMsqOhNQho0TBz9b7W+BT6X8
	WakaPRFhiKrHheFhabUhstYXmpC1dGE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="D2cHoCq/";
	spf=pass (imf13.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789730618;
	b=fUo7FhDbagFafG6J8QkfRlNLQMhHsy/MG12STNt6eY2nxDtCVXXPytgAzsz0nNRvuSy7Rz
	u2nT2VbpCr0pNn8qaoJJuDwz+IVOjYsMoqIoWwyx+9OGsL9jbfL0fqsB000NECfRouDQoP
	DXkoGY2cCGePVRsH4DLKGS0zHhBfu1Q=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4CE6D1BF7;
	Fri, 18 Sep 2026 04:23:34 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3FCAC3F882;
	Fri, 18 Sep 2026 04:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789730617; bh=Eiy/pRfgLh1eAlmrlllYweUczsrrEbMKedfGiTrN5OI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D2cHoCq/arcUgYS+vPa2Qz8y8e50cVzVS1tkIg3HadRsJ0tDKWglDbvqGm36PfwrX
	 QketPuOb41x3kVzKlUlxGsd2HrV/0S595fJpZZAkIPHheiKe6kn6rStCEYQ1gYDYap
	 83TgmDUZPrzWjAy+N01Ldis4UmzvgdU7JMbIBAcc=
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
Subject: [PATCH v11 6/6] selftests/mm: add a GUP selftest
Date: Fri, 18 Sep 2026 16:52:34 +0530
Message-ID: <20260918112234.195857-7-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260918112234.195857-1-sarthak.sharma@arm.com>
References: <20260918112234.195857-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zr7cdrtbtwf1zpgj1mnjc37r8ic3fuam
X-Rspamd-Queue-Id: AAFE820003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789730618-395363
X-HE-Meta: U2FsdGVkX1/x26ssHdQk+PuONgmsCvx1njKDCdgh+xzj7PffBEjgr4sRBnamOO9Bw1cEqSRFzIfPFx4Hc1RXHjPqef0b8RW/SFDT2E9s6t5UTRKu0TRjWsofL+fVhO9GDcKc9qjPHh96h0DYJOnBfPkK0KsbrEeZEm9dQpBHeqL8a5sZZyf4hVIuZz9YtedmyA8BbOhBZ4uh4KorVnpvI9ep1MDEoo5DVjLNvLFiZzEpVix+aoVJ+I8gZaTSskaUZbtpK4uYwojyixhtIOmffk/BypvaBiC8LxU9JOea8JtCNNiEVOUFR1fht5Zfo++ET6Zjy25Eqv21WDHYftp5DORBswnKNHaxIsja0m6OFk3WwSeZozmUKM/OdogXuPE11/B7xtCPNtKi3T3JfeCGO1XSRJClYSuC04mbGLYkhuf5+TXZCAS8edpSroWTxh/L5Xjj2WEX2yTgWzzv/yrsUtymDCK5J08cb1Sk9T0DeojLGXhRQHbJLXnq/3X3kVmFZ1PIzFjU5hWdruKJydaHh6ap7HCS4dgm4e3WV3E8p4NoZ0n369BwavrhhQa0WANOcKqxpWeYOSw2RL6MJ+jYiXRjt8b//B+op8m3mZU+N4MXbXLTE+TWdk8XjnrFAgeEgbT1uhbVfoEFEEE1GSL9IOa7jZshxKRPeUxKe10KfHJheiuQYuG0maqLZ4HTekuU4C4zFKZvG05lXsp9rQuc9IyuP0hEVKfUyPd1ZvVmf5CKulVlYzM3QzZOFL+rziKtUXkuaHiSgPvmwtoZObupGYGoV1Bxu/HUFcx+BqslqoA4ASDa99biBHOs4gGubwe8wtr1c4iZBxS5S3ijxN38hcSunoF2TbFJ5FSYQKj/GbW5cuIzUB+Gf5GilA85bKFUk/yQ3wUzJ95IoeIcS1lbKQf8t3+XYFxcx+a8wYYH3GDusZyakR2uZ/d4jDRNSC20VrUoEM73BddNUKq2jAT
 RKiIbi8+
 lIU9dIH/hJ4MuFLj+FOlBeWMtXBZbSxTjctAY9tTvD++Lm/fgy9p+F+iAyLu7bWnuKVZVW/Fe3uXE2DRKk7er+L8X/3ehGk07ImnAY1g2q3pyQUigvJpB+FxZIN7VOpuTHWBnRiehuNUKcpb18bKubEcyddo+ECwhELFfjxAAY6hFLogJUvXJaP5pdX1hSI5oVGQ9wxepTmXAFondvQKzC4tEo+VanuGL9LMDnu9bf3dGMCuzdqYyOVPFYM6rP2heFYgA/+X9XZmIWmk=
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

Use two default hugeTLB pages and derive the mapping size from
their size. This exercises GUP both within a single HugeTLB page
and across a HugeTLB boundary, without reserving an excessive
number of pages.

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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 MAINTAINERS                               |   1 +
 mm/Kconfig                                |  19 +-
 tools/testing/selftests/mm/Makefile       |   1 +
 tools/testing/selftests/mm/gup.c          | 262 ++++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh |   1 +
 5 files changed, 272 insertions(+), 12 deletions(-)
 create mode 100644 tools/testing/selftests/mm/gup.c

diff --git a/MAINTAINERS b/MAINTAINERS
index b6104b7d8054..a3aca56a4a30 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17188,6 +17188,7 @@ F:	mm/gup.c
 F:	mm/gup_test.c
 F:	mm/gup_test.h
 F:	tools/mm/gup_bench.c
+F:	tools/testing/selftests/mm/gup.c
 F:	tools/testing/selftests/mm/gup_longterm.c
 
 MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
diff --git a/mm/Kconfig b/mm/Kconfig
index 30170a936f1f..edb4a6c0a870 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1292,24 +1292,19 @@ config PERCPU_STATS
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
-
-	  See tools/testing/selftests/mm/gup_test.c
+	  See tools/testing/selftests/mm/gup.c and tools/mm/gup_bench.c.
 
 comment "GUP_TEST needs to have DEBUG_FS enabled"
 	depends on !GUP_TEST && !DEBUG_FS
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index d6337156111a..7d69baeb93f4 100644
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
index 000000000000..a6a8ca47d12e
--- /dev/null
+++ b/tools/testing/selftests/mm/gup.c
@@ -0,0 +1,262 @@
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
+#define NR_HUGETLB_PAGES 2
+
+static unsigned long hp_size;
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
+	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS;
+	char *p;
+
+	self->size = 128 * MB;
+
+	if (variant->hugetlb) {
+		if (!hp_size)
+			SKIP(return, "HugeTLB not available\n");
+
+		if (hugetlb_free_default_pages() < NR_HUGETLB_PAGES)
+			SKIP(return, "Not enough huge pages\n");
+
+		self->size = NR_HUGETLB_PAGES * hp_size;
+		mmap_flags |= MAP_HUGETLB;
+	}
+
+	if (variant->shared)
+		mmap_flags = (mmap_flags & ~MAP_PRIVATE) | MAP_SHARED;
+
+	/* gup_fd has to be >= 0. Already checked in main() */
+	self->gup_fd = open(GUP_TEST_FILE, O_RDWR);
+	ASSERT_GE(self->gup_fd, 0);
+
+	self->addr = mmap(NULL, self->size, PROT_READ | PROT_WRITE,
+			  mmap_flags, -1, 0);
+
+	ASSERT_NE(self->addr, MAP_FAILED) {
+		int err = errno;
+
+		close(self->gup_fd);
+		TH_LOG("mmap failed: %s", strerror(err));
+	}
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
+		FIXTURE_DATA(gup_test) *self,
+		const FIXTURE_VARIANT(gup_test) *variant,
+		unsigned long command)
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
+	const int fd = open(GUP_TEST_FILE, O_RDWR);
+
+	if (fd == -1) {
+		ksft_print_header();
+		if (errno == EACCES)
+			ksft_exit_skip("Please run this test as root\n");
+		if (errno == ENOENT) {
+			DIR *debugfs = opendir("/sys/kernel/debug");
+
+			if (!debugfs)
+				ksft_exit_skip("Mount debugfs at /sys/kernel/debug\n");
+			closedir(debugfs);
+			ksft_exit_skip("Check CONFIG_GUP_TEST in kernel config\n");
+		}
+		ksft_exit_fail_msg("Failed to open %s: %s\n", GUP_TEST_FILE, strerror(errno));
+	}
+	close(fd);
+
+	hp_size = default_huge_page_size();
+	if (hp_size)
+		hugetlb_setup_default(NR_HUGETLB_PAGES);
+
+	return test_harness_run(argc, argv);
+}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index cea59dc5707d..4cc1d1a55ebf 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -269,6 +269,7 @@ fi
 
 CATEGORY="mmap" run_test ./map_fixed_noreplace
 
+CATEGORY="gup_test" run_test ./gup
 CATEGORY="gup_test" run_test ./gup_longterm
 
 CATEGORY="userfaultfd" run_test ./uffd-unit-tests
-- 
2.53.0


