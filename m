Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA5BBC88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:11:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBCE46B00A2; Fri, 11 Sep 2026 07:10:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6DE66B00A3; Fri, 11 Sep 2026 07:10:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B62F26B00A4; Fri, 11 Sep 2026 07:10:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 989746B00A2
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:10:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 026FA1A01C2
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:10:58 +0000 (UTC)
X-FDA: 85201214238.15.731143A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4555818000C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:10:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WVKHKK2C;
	spf=pass (imf24.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789125057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rlK51J4lgYcPgtPYma34xtnIQV25Cde9P0kkrh9Kbf4=;
	b=OejZczkO1x7TmtkHmeg339/454l9YukU6zk1uB3AA3+qXsrn/aQ0AfrSRBxcSLJHxp7Jc8
	0+1QTyS1HKmBZdSDIshSD+5XnCB6pu5RhP74xMjwgp3tO6oHlaKqGUxou2ZsFuAtQUiViR
	AHBGyBuMlIEYA1/o3KuJfdFHB1D+4Do=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WVKHKK2C;
	spf=pass (imf24.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789125057;
	b=JCsC/2614XCRLkeZdiKiZ7ZX2rjFSqJsVdetKQSSOVnjNGk8dii/9FpSn8mLFEeUf/LoYW
	QrvCelcLI0hd8HN/fLE0XyOBXW5GkEZqiQZvFovxFs0xPSTJ3y9O9K+m+vNIjJ78aSEM//
	JDJ/sHPjGaucYLKUiDAOw++GFTtT24E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D1E1416F2;
	Fri, 11 Sep 2026 04:10:52 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DC3523F59E;
	Fri, 11 Sep 2026 04:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789125056; bh=9tmo7LnCa2gZ4wvu0gRKk4iwWl/CuwVoGBbOWdqP/EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVKHKK2CFRceqwP6ticU/SyBU/FGoDLRCcmtzTdsI2lPWtcXGHbIWX88nv7R0yBJA
	 scGnq6iw62DmXaezxSuhbRbvjeR+vbMnJBddDfuHJkUajBaiCTfFIK52bGgQY68vdZ
	 6SmcdkicYEKbBoyPttJuiYZxIhCO3JOArbrJ+CSo=
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
Subject: [PATCH v10 6/6] selftests/mm: add a GUP selftest
Date: Fri, 11 Sep 2026 16:39:50 +0530
Message-ID: <20260911110950.200240-7-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260911110950.200240-1-sarthak.sharma@arm.com>
References: <20260911110950.200240-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4555818000C
X-Stat-Signature: x71iidbhwx18f5pfp6z3bswcfihi8n4p
X-Rspam-User: 
X-HE-Tag: 1789125057-250516
X-HE-Meta: U2FsdGVkX19+Y5nJEmNsucqfttmkup44wGuo35ZCMQIfHQaiQx0YohiD625MF6d2ShXEpfL/TraAdxQzzX8qnCVSa1yipzgXv1sR06WWd909raz+m+ahRT+qPQujex1Ws4lb5GbRyG2p4vfDK/Di0ZZZ2S5FV6JqUKtTYY0X8Zbr81RMGJX1d4cieI/GHXgKe77Fz10hG0TILJW3NmiQKEopT7TVQzRvGCISNdDvZtR5VEo1owLQYEDdwGVpkB/9LeWymSRzgo8DDZTh4URvdRAXA9Z+XbmrDalgOpxmjHMqEnp4sIjgd0iXtd13Aszgp79r3QZ8JarJWnhPENl+LdTSdaAjaMqeORpC/j8f8OlaNBL70JKEQEmvfLsBHTi1utFzU8HhfEVFRpSJpdiinSAL7DhH+WwNEva0lPL0souIMN1ogudQrsLmELla7ybVSJ9nhLw/gbdY4V6IC+Ppq0OfOTjNBkXdSF2MceeM6YgFDmAiCBsnRCLoU7407aihQSEJnPqGjxZraIxaXCrqA4aUPutApGGIdsdY0VkZfy0r/Lf9BThRgS7ZX4KXFKB1V0AhDetzijr9Fne3QOsORUVqfh7ec7VfsE6wHEcGYf9sGZHhN7NwSSERvve79j3Rrfc0/c5l+adjJxjlBZy3OOqmgYropwuoJGVJW18HJr18Lk6DZU/p3L9Sa8/6qrpZY35KNOom7JtD6skhV38cZ5w0Ukfkxbxdm1FH6+Xo0BnVNvlBJ8WXoYooCOBhK5nXom1X75Cl5vvdXrQ+BdUhjjjHHo8c7LIIqP/ocr5TE+zrZ/izk2OCADjxTw1/HQKBSFj/XRhanM651dm5AON0E2wMQTJGLcf5ExwRie07OCTeXJIef6K/DSjhsuoMzYGssZlk4iqJCsnHFCEW5afLPgKuJd80hpwAk9xIbH+UhjPp9S5kLE4RCHhsRXLTcRI0zQfNf9G1wyksFf0Wn/5
 F+lBKqR5
 WaBmSazgVqXUh+yHjKqWCgxnGzer9l5J3FA1+g/dFpy7vU7xL6junGAT8v3GYiITESz58zHJrZrJxO2CBDimOcP+VrqSjglS4Dlq25TOrBK0ReMXoHAD23gKKbPxE9sFoxXhTXNYNBN42yiTAB3PeFr5MrbZU79SGj9k2UJ1EZE1cTyoFQ81MnyrrW09Dhc3KWccwTUvoL4mXk5qVsb9nlMMTsBY7X4wly2c+aC7Eo0+XyJcXJZULpOgt7xCtmCAu96rxULerswZhOyQ=
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
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 MAINTAINERS                               |   1 +
 mm/Kconfig                                |  19 +-
 tools/testing/selftests/mm/Makefile       |   1 +
 tools/testing/selftests/mm/gup.c          | 263 ++++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh |   1 +
 5 files changed, 273 insertions(+), 12 deletions(-)
 create mode 100644 tools/testing/selftests/mm/gup.c

diff --git a/MAINTAINERS b/MAINTAINERS
index cae3af861a7c..c47e655c4111 100644
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
index c180d40cd671..61ab1b8a2ebd 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1291,24 +1291,19 @@ config PERCPU_STATS
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
index 000000000000..31ae38e09136
--- /dev/null
+++ b/tools/testing/selftests/mm/gup.c
@@ -0,0 +1,263 @@
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
+#define NR_HUGE_PAGES 2
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
+		if (hugetlb_free_default_pages() < NR_HUGE_PAGES)
+			SKIP(return, "Not enough huge pages\n");
+
+		self->size = NR_HUGE_PAGES * hp_size;
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
+	int fd;
+
+	fd = open(GUP_TEST_FILE, O_RDWR);
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
+		hugetlb_setup_default(NR_HUGE_PAGES);
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


