Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B9A3C4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:59:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3A1F6B010D; Thu, 16 Jul 2026 10:59:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEA366B0110; Thu, 16 Jul 2026 10:59:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8AF46B0111; Thu, 16 Jul 2026 10:59:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A0A736B010D
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:59:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E22BC160160
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:33:36 +0000 (UTC)
X-FDA: 84994580832.26.19F6ED8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 240DF40012
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:33:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Xxb5lGmo;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784205215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vhuB/E+0248mFbuT4Rth7Hn5PwnswomFm6RV0DmVfhM=;
	b=eNquzlmkwaKxX1aYD6bBzGsB2io77T9NwiTzK94H2bosDUCqFKyeBVxufoqQYudOoEQQ4E
	o0yuqiSs1tyHb4WZtupVebhXbMphCxzTOPBs4yt5uXMGbM9jHBHk0fTayByn8GlKCVT11J
	g37YuI7NwqsDuDTo3Ju7UJPezTffkYw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Xxb5lGmo;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784205215;
	b=JV9r2ledhy62xfnmdmLbQ8B7UYtJutexCBmpejxKOy2uekRCjefr27oiiiAUMcA+UhQCCu
	rEMbIhGI4X3YdLEqpYthLBs1kNQUYpM+zePkaGCPB7qqjcWbZAfNKBtJFarJFKRPIlI8p6
	ZoQJvh7mabcIfIspbXR81+86bovVLWM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DBE4116A3;
	Thu, 16 Jul 2026 05:33:29 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A193D3F7B4;
	Thu, 16 Jul 2026 05:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784205214; bh=ZNruc30giO4HvCBCFbu5TtIBl+Mz/3g0dev7XA1hM2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xxb5lGmonmK2NyqMXbVPUOaKsMBH6qjXFqK7OFOPgoSu30J2JQqntqi0M+/uySpta
	 0sX37ZjcFswxXOsG/dhmjxV7IoENr7UdcgtwpP26HyayQjZlHIdbphntj/qqD+YatV
	 zx1SgQlIxuz8CO1Q59LtoBE+8FS+hmJ1V7MCuM7E=
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
	Jonathan Corbet <corbet@lwn.net>,
	Mark Brown <broonie@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v5 5/5] selftests/mm: rewrite gup_test as a standalone harness-based selftest
Date: Thu, 16 Jul 2026 18:02:26 +0530
Message-ID: <20260716123226.197736-6-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260716123226.197736-1-sarthak.sharma@arm.com>
References: <20260716123226.197736-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 240DF40012
X-Stat-Signature: zjz5m6syfnq8einqrcpxc8drbd3dk3nf
X-Rspam-User: 
X-HE-Tag: 1784205214-771282
X-HE-Meta: U2FsdGVkX19PWh/ivHWy0GXAkyQQzH4r5dx3LSEfEfGcbW30qXESpyO1RBe11SEdPvirJoEvu2QSJNSRG9MPHapRlmftTq59CaroQG5IZH7XZgNKPkRp3GLndlvkokqQhEsnD+utahs5UPNHJGdkQLBZOwAvmS8OG+EQ7YBQfO7bs70b3EFxApX6YzAyqUQkn4eF/hfJntDKn5P4Ac5u+fmZXYeAN8iFJAkqIyx55JNtl9bLPe3MIEk++EkJSI6+6ApZqX6ZEyN8JnP+6tF/DLlpmw9PAyhF2wXCLtKzMayHE99nDiPqRG1CZPkFJylv0kSQ4wk3m6xiN60Ih8YKv4a4Rx2wxgC/lrhwQF9nQnqVFOEWVi/U7nP+gh0Pah6dyLRd9rNk14QxMUIVPHbMmh7d3e1BZk9zfNbsVgjKJhGMgcxguk8LsCRJ7/zGl4tW2BdFmbMvTkIG4Xuk6U3ThjRdDNYY7O4WT2BPLZZH/DMtnTQ7sSIAl4p7P4g985GpMzv66aR4Vz+3DNY49razWhLYSRYdMZXlAGZwpSEyfh6PzYre7f08lpoeuu4rpTVoL49yyxNO2k4Z3dJrTHBmr9leRbvdeG5pzwEC39cpxR3/SNBeGWi+HmR7ZaP96CtkyzrQPJfYBmJ8j4Ek/84ypBdxvCPGzeZrntvQIkBOHzFXrXHBl8EhQPooNA+eqPABZ5hAEc8viCid9JnXNRXEFZ/Dac0J9mkwcdZHJepxhgnnPBSwX0I/P8mDTF+FjZPalwY1KauOUWlZ6n+vXC5VLVGFcQnF+mb4mB0pw3NhpWgk3NCAl2h1C0zmO/rK49gDDokEnYVwf9r/5HuSQ3r3JAXlAc8NEbqA5j9uKJM1P/yJ3T2KHmeLuarSud+6OkrPXS0Hq95mPnQKStsKCuyftF3z7mNo2w+g23CkV7GF6aRxBTfbmz1CXZ1vKbKMJvSHg3j1S6y0au0sG4PuyIt
 gxgzQh/T
 7YDD8NHcW+1CDMjy+iUj9ptspytizhThcXo6i6YTaGNXCUtBdacP/pVhFSIfA8kT7NrhYKcV2q5UpJn+cuDMAEoOSlhPoAOlztiB4jJ2bQ10RiY/Pg7ZBFxNbCdcBERVyZVq4yxAqlDCgDdOfhGWA7ikNGvQLmMi6Q3YUEw7U/QxazC4qwhj7cRl5/ajOGRUCma0BysqBP0N1osGEiHbuxB9AUXCTdYNj8u75TdVHXxNP1ItMTwSTTgBVrSBm6qm9RKswDnVFVslt3s/u4/fR2AyWOXp+JxfTF/YPjobKLYkwC3ZFmBMyRPjlofc5yamkosNE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rewrite gup_test.c using kselftest_harness.h. The new test covers 12
mapping configurations: THP on, THP off and hugetlb, each across
private/shared and read/write variants. It runs seven test cases per
variant: get_user_pages, get_user_pages_fast, pin_user_pages,
pin_user_pages_fast, pin_user_pages_longterm, and DUMP_USER_PAGES_TEST
via both get and pin.

Each test case sweeps four nr_pages_per_call values: 1, 512, 123, and
all pages. This preserves the old run_gup_matrix() sweep: 12 mapping
combinations x 5 GUP/PUP operations x 4 batch sizes = 240 ioctl sweeps.
It also expands DUMP_USER_PAGES_TEST coverage from one standalone
invocation to 12 variants x 2 dump modes x 4 batch sizes = 96
additional sweeps.

Preserve the old sparse dump coverage from run_vmtests.sh with one
standalone test that exercises DUMP_USER_PAGES_TEST with page indices
0, 19 and 0x1000, fetching the full mapping in one ioctl call. This
brings the total to 85 TAP-reported cases (12 x 7 + 1) and 337 ioctl
sweeps (240 + 96 + 1).

On a Radxa Orion O6 board, ./gup_test completes in 5.39s on average
over 10 runs (range: 5.33s - 5.48s).

Update run_vmtests.sh: remove run_gup_matrix() and the multiple flagged
invocations of gup_test, replacing them with a single unconditional
invocation. Benchmark functionality is handled by tools/mm/gup_bench
introduced in the previous patch.

Update Documentation/core-api/pin_user_pages.rst to reflect the new
harness-based gup_test interface rather than command-line flag
invocations.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 Documentation/core-api/pin_user_pages.rst |  12 +-
 tools/testing/selftests/mm/gup_test.c     | 605 ++++++++++++++--------
 tools/testing/selftests/mm/run_vmtests.sh |  37 +-
 3 files changed, 397 insertions(+), 257 deletions(-)

diff --git a/Documentation/core-api/pin_user_pages.rst b/Documentation/core-api/pin_user_pages.rst
index c16ca163b55e..ea722adf22cc 100644
--- a/Documentation/core-api/pin_user_pages.rst
+++ b/Documentation/core-api/pin_user_pages.rst
@@ -230,10 +230,16 @@ This file::
 
  tools/testing/selftests/mm/gup_test.c
 
-has the following new calls to exercise the new pin*() wrapper functions:
+contains the following test cases to exercise pin_user_pages*():
 
-* PIN_FAST_BENCHMARK (./gup_test -a)
-* PIN_BASIC_TEST (./gup_test -b)
+* pin_user_pages via PIN_BASIC_TEST
+* pin_user_pages_fast via PIN_FAST_BENCHMARK
+* pin_user_pages_longterm via PIN_LONGTERM_BENCHMARK
+
+Run with::
+
+  make -C tools/testing/selftests/mm
+  ./tools/testing/selftests/mm/gup_test
 
 You can monitor how many total dma-pinned pages have been acquired and released
 since the system was booted, via two new /proc/vmstat entries: ::
diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/selftests/mm/gup_test.c
index 5f44761dbec0..d9caa9fb8b78 100644
--- a/tools/testing/selftests/mm/gup_test.c
+++ b/tools/testing/selftests/mm/gup_test.c
@@ -1,274 +1,443 @@
 #define __SANE_USERSPACE_TYPES__ // Use ll64
 #include <fcntl.h>
 #include <errno.h>
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <unistd.h>
 #include <dirent.h>
 #include <sys/ioctl.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/types.h>
-#include <pthread.h>
-#include <assert.h>
 #include <mm/gup_test.h>
 #include "kselftest.h"
 #include "vm_util.h"
+#include "kselftest_harness.h"
 
 #define MB (1UL << 20)
 
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+#endif
+
 /* Just the flags we need, copied from the kernel internals. */
 #define FOLL_WRITE	0x01	/* check pte is writable */
 
+/* Page counts exercising single, THP-batch, partial, and full-mapping GUP. */
+static const int nr_pages_list[] = { 1, 512, 123, -1 };
+
 #define GUP_TEST_FILE "/sys/kernel/debug/gup_test"
 
-static unsigned long cmd = GUP_FAST_BENCHMARK;
-static int gup_fd, repeats = 1;
-static unsigned long size = 128 * MB;
-/* Serialize prints */
-static pthread_mutex_t print_mutex = PTHREAD_MUTEX_INITIALIZER;
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
+FIXTURE_VARIANT_ADD(gup_test, private_readonly)
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
+FIXTURE_VARIANT_ADD(gup_test, private_readonly_thp)
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
+FIXTURE_VARIANT_ADD(gup_test, private_readonly_hugetlb)
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
+FIXTURE_VARIANT_ADD(gup_test, shared_readonly)
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
 
-static char *cmd_to_str(unsigned long cmd)
+FIXTURE_VARIANT_ADD(gup_test, shared_readonly_thp)
 {
-	switch (cmd) {
-	case GUP_FAST_BENCHMARK:
-		return "GUP_FAST_BENCHMARK";
-	case PIN_FAST_BENCHMARK:
-		return "PIN_FAST_BENCHMARK";
-	case PIN_LONGTERM_BENCHMARK:
-		return "PIN_LONGTERM_BENCHMARK";
-	case GUP_BASIC_TEST:
-		return "GUP_BASIC_TEST";
-	case PIN_BASIC_TEST:
-		return "PIN_BASIC_TEST";
-	case DUMP_USER_PAGES_TEST:
-		return "DUMP_USER_PAGES_TEST";
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
+FIXTURE_VARIANT_ADD(gup_test, shared_readonly_hugetlb)
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
+	/* zero_fd has to be >= 0. Already checked in main() */
+	zero_fd = open("/dev/zero", O_RDWR);
+	ASSERT_GE(zero_fd, 0);
+
+	/* gup_fd has to be >= 0. Already checked in main() */
+	self->gup_fd = open(GUP_TEST_FILE, O_RDWR);
+	ASSERT_GE(self->gup_fd, 0);
+
+	self->size = variant->hugetlb ? 256 * MB : 128 * MB;
+
+	/* Check for hugetlb */
+	if (variant->hugetlb) {
+		unsigned long hp_size = default_huge_page_size();
+
+		if (!hp_size) {
+			close(zero_fd);
+			close(self->gup_fd);
+			SKIP(return, "HugeTLB not available\n");
+		}
+
+		self->size = (self->size + hp_size - 1) & ~(hp_size - 1);
+		if (!hugetlb_setup_default(self->size / hp_size)) {
+			hugetlb_restore_settings();
+			close(zero_fd);
+			close(self->gup_fd);
+			SKIP(return, "Not enough huge pages\n");
+		}
+
+		mmap_flags |= (MAP_HUGETLB | MAP_ANONYMOUS);
+	}
+
+	if (variant->shared)
+		mmap_flags = (mmap_flags & ~MAP_PRIVATE) | MAP_SHARED;
+
+	self->addr = mmap(NULL, self->size, PROT_READ | PROT_WRITE,
+			  mmap_flags, zero_fd, 0);
+
+	close(zero_fd);
+
+	ASSERT_NE(self->addr, MAP_FAILED) {
+		int err = errno;
+
+		close(self->gup_fd);
+		if (variant->hugetlb)
+			hugetlb_restore_settings();
+		TH_LOG("mmap failed: %s", strerror(err));
 	}
-	return "Unknown command";
+
+	if (variant->thp)
+		madvise(self->addr, self->size, MADV_HUGEPAGE);
+	else
+		madvise(self->addr, self->size, MADV_NOHUGEPAGE);
+
+	for (p = self->addr; (unsigned long)p < (unsigned long)self->addr
+			+ self->size; p += psize())
+		p[0] = 0;
 }
 
-void *gup_thread(void *data)
+FIXTURE_TEARDOWN(gup_test)
 {
-	struct gup_test gup = *(struct gup_test *)data;
-	int i, status;
-
-	/* Only report timing information on the *_BENCHMARK commands: */
-	if ((cmd == PIN_FAST_BENCHMARK) || (cmd == GUP_FAST_BENCHMARK) ||
-	     (cmd == PIN_LONGTERM_BENCHMARK)) {
-		for (i = 0; i < repeats; i++) {
-			gup.size = size;
-			status = ioctl(gup_fd, cmd, &gup);
-			if (status)
-				break;
-
-			pthread_mutex_lock(&print_mutex);
-			ksft_print_msg("%s: Time: get:%lld put:%lld us",
-				       cmd_to_str(cmd), gup.get_delta_usec,
-				       gup.put_delta_usec);
-			if (gup.size != size)
-				ksft_print_msg(", truncated (size: %lld)", gup.size);
-			ksft_print_msg("\n");
-			pthread_mutex_unlock(&print_mutex);
-		}
-	} else {
-		gup.size = size;
-		status = ioctl(gup_fd, cmd, &gup);
-		if (status)
-			goto return_;
-
-		pthread_mutex_lock(&print_mutex);
-		ksft_print_msg("%s: done\n", cmd_to_str(cmd));
-		if (gup.size != size)
-			ksft_print_msg("Truncated (size: %lld)\n", gup.size);
-		pthread_mutex_unlock(&print_mutex);
+	munmap(self->addr, self->size);
+	close(self->gup_fd);
+
+	if (variant->hugetlb)
+		hugetlb_restore_settings();
+}
+
+TEST_F(gup_test, get_user_pages)
+{
+	/* Tests the get_user_pages path */
+	int i;
+
+	for (i = 0; i < (int)ARRAY_SIZE(nr_pages_list); i++) {
+		struct gup_test gup = { 0 };
+
+		gup.addr = (unsigned long)self->addr;
+		gup.size = self->size;
+		gup.nr_pages_per_call = nr_pages_list[i] < 0 ?
+			self->size / psize() : nr_pages_list[i];
+
+		if (variant->write)
+			gup.gup_flags |= FOLL_WRITE;
+
+		TH_LOG("nr_pages_per_call=%u", gup.nr_pages_per_call);
+		ASSERT_EQ(ioctl(self->gup_fd, GUP_BASIC_TEST, &gup), 0);
+	}
+}
+
+TEST_F(gup_test, pin_user_pages)
+{
+	/* Tests the pin_user_pages path */
+	int i;
+
+	for (i = 0; i < (int)ARRAY_SIZE(nr_pages_list); i++) {
+		struct gup_test gup = { 0 };
+
+		gup.addr = (unsigned long)self->addr;
+		gup.size = self->size;
+		gup.nr_pages_per_call = nr_pages_list[i] < 0 ?
+			self->size / psize() : nr_pages_list[i];
+
+		if (variant->write)
+			gup.gup_flags |= FOLL_WRITE;
+
+		TH_LOG("nr_pages_per_call=%u", gup.nr_pages_per_call);
+		ASSERT_EQ(ioctl(self->gup_fd, PIN_BASIC_TEST, &gup), 0);
 	}
+}
 
-return_:
-	ksft_test_result(!status, "ioctl status %d\n", status);
-	return NULL;
+TEST_F(gup_test, dump_user_pages_with_get)
+{
+	/* Tests DUMP_USER_PAGES_TEST using get_user_pages */
+	int i;
+
+	for (i = 0; i < (int)ARRAY_SIZE(nr_pages_list); i++) {
+		struct gup_test gup = { 0 };
+
+		gup.addr = (unsigned long)self->addr;
+		gup.size = self->size;
+		gup.nr_pages_per_call = nr_pages_list[i] < 0 ?
+			self->size / psize() : nr_pages_list[i];
+
+		if (variant->write)
+			gup.gup_flags |= FOLL_WRITE;
+
+		gup.which_pages[0] = 1;
+
+		TH_LOG("nr_pages_per_call=%u", gup.nr_pages_per_call);
+		ASSERT_EQ(ioctl(self->gup_fd, DUMP_USER_PAGES_TEST, &gup), 0);
+	}
 }
 
-int main(int argc, char **argv)
+TEST_F(gup_test, dump_user_pages_with_pin)
 {
-	struct gup_test gup = { 0 };
-	int filed, i, opt, nr_pages = 1, thp = -1, write = 1, nthreads = 1, ret;
-	int flags = MAP_PRIVATE;
-	char *file = "/dev/zero";
-	bool hugetlb = false;
-	pthread_t *tid;
-	char *p;
+	/* Tests DUMP_USER_PAGES_TEST using pin_user_pages */
+	int i;
 
-	while ((opt = getopt(argc, argv, "m:r:n:F:f:abcj:tTLUuwWSHpz")) != -1) {
-		switch (opt) {
-		case 'a':
-			cmd = PIN_FAST_BENCHMARK;
-			break;
-		case 'b':
-			cmd = PIN_BASIC_TEST;
-			break;
-		case 'L':
-			cmd = PIN_LONGTERM_BENCHMARK;
-			break;
-		case 'c':
-			cmd = DUMP_USER_PAGES_TEST;
-			/*
-			 * Dump page 0 (index 1). May be overridden later, by
-			 * user's non-option arguments.
-			 *
-			 * .which_pages is zero-based, so that zero can mean "do
-			 * nothing".
-			 */
-			gup.which_pages[0] = 1;
-			break;
-		case 'p':
-			/* works only with DUMP_USER_PAGES_TEST */
-			gup.test_flags |= GUP_TEST_FLAG_DUMP_PAGES_USE_PIN;
-			break;
-		case 'F':
-			/* strtol, so you can pass flags in hex form */
-			gup.gup_flags = strtol(optarg, 0, 0);
-			break;
-		case 'j':
-			nthreads = atoi(optarg);
-			break;
-		case 'm':
-			size = atoi(optarg) * MB;
-			break;
-		case 'r':
-			repeats = atoi(optarg);
-			break;
-		case 'n':
-			nr_pages = atoi(optarg);
-			if (nr_pages < 0)
-				nr_pages = size / psize();
-			break;
-		case 't':
-			thp = 1;
-			break;
-		case 'T':
-			thp = 0;
-			break;
-		case 'U':
-			cmd = GUP_BASIC_TEST;
-			break;
-		case 'u':
-			cmd = GUP_FAST_BENCHMARK;
-			break;
-		case 'w':
-			write = 1;
-			break;
-		case 'W':
-			write = 0;
-			break;
-		case 'f':
-			file = optarg;
-			break;
-		case 'S':
-			flags &= ~MAP_PRIVATE;
-			flags |= MAP_SHARED;
-			break;
-		case 'H':
-			flags |= (MAP_HUGETLB | MAP_ANONYMOUS);
-			hugetlb = true;
-			break;
-		default:
-			ksft_exit_fail_msg("Wrong argument\n");
-		}
+	for (i = 0; i < (int)ARRAY_SIZE(nr_pages_list); i++) {
+		struct gup_test gup = { 0 };
+
+		gup.addr = (unsigned long)self->addr;
+		gup.size = self->size;
+		gup.nr_pages_per_call = nr_pages_list[i] < 0 ?
+			self->size / psize() : nr_pages_list[i];
+
+		if (variant->write)
+			gup.gup_flags |= FOLL_WRITE;
+
+		gup.which_pages[0] = 1;
+		gup.test_flags |= GUP_TEST_FLAG_DUMP_PAGES_USE_PIN;
+
+		TH_LOG("nr_pages_per_call=%u", gup.nr_pages_per_call);
+		ASSERT_EQ(ioctl(self->gup_fd, DUMP_USER_PAGES_TEST, &gup), 0);
 	}
+}
 
-	if (optind < argc) {
-		int extra_arg_count = 0;
-		/*
-		 * For example:
-		 *
-		 *   ./gup_test -c 0 1 0x1001
-		 *
-		 * ...to dump pages 0, 1, and 4097
-		 */
-
-		while ((optind < argc) &&
-		       (extra_arg_count < GUP_TEST_MAX_PAGES_TO_DUMP)) {
-			/*
-			 * Do the 1-based indexing here, so that the user can
-			 * use normal 0-based indexing on the command line.
-			 */
-			long page_index = strtol(argv[optind], 0, 0) + 1;
-
-			gup.which_pages[extra_arg_count] = page_index;
-			extra_arg_count++;
-			optind++;
-		}
+TEST_F(gup_test, get_user_pages_fast)
+{
+	/* Tests the lockless get_user_pages_fast() path */
+	int i;
+
+	for (i = 0; i < (int)ARRAY_SIZE(nr_pages_list); i++) {
+		struct gup_test gup = { 0 };
+
+		gup.addr = (unsigned long)self->addr;
+		gup.size = self->size;
+		gup.nr_pages_per_call = nr_pages_list[i] < 0 ?
+			self->size / psize() : nr_pages_list[i];
+
+		if (variant->write)
+			gup.gup_flags |= FOLL_WRITE;
+
+		TH_LOG("nr_pages_per_call=%u", gup.nr_pages_per_call);
+		ASSERT_EQ(ioctl(self->gup_fd, GUP_FAST_BENCHMARK, &gup), 0);
 	}
+}
+
+TEST_F(gup_test, pin_user_pages_fast)
+{
+	/* Tests the lockless pin_user_pages_fast() path */
+	int i;
 
-	ksft_print_header();
+	for (i = 0; i < (int)ARRAY_SIZE(nr_pages_list); i++) {
+		struct gup_test gup = { 0 };
 
-	if (hugetlb) {
-		unsigned long hp_size = default_huge_page_size();
+		gup.addr = (unsigned long)self->addr;
+		gup.size = self->size;
+		gup.nr_pages_per_call = nr_pages_list[i] < 0 ?
+			self->size / psize() : nr_pages_list[i];
 
-		if (!hp_size)
-			ksft_exit_skip("HugeTLB is unavailable\n");
+		if (variant->write)
+			gup.gup_flags |= FOLL_WRITE;
 
-		size = (size + hp_size - 1) & ~(hp_size - 1);
-		if (!hugetlb_setup_default(size / hp_size))
-			ksft_exit_skip("Not enough huge pages\n");
+		TH_LOG("nr_pages_per_call=%u", gup.nr_pages_per_call);
+		ASSERT_EQ(ioctl(self->gup_fd, PIN_FAST_BENCHMARK, &gup), 0);
 	}
+}
 
-	ksft_set_plan(nthreads);
+TEST_F(gup_test, pin_user_pages_longterm)
+{
+	/* Tests pin_user_pages() with FOLL_LONGTERM */
+	int i;
 
-	filed = open(file, O_RDWR|O_CREAT, 0664);
-	if (filed < 0)
-		ksft_exit_fail_msg("Unable to open %s: %s\n", file, strerror(errno));
+	for (i = 0; i < (int)ARRAY_SIZE(nr_pages_list); i++) {
+		struct gup_test gup = { 0 };
 
-	gup.nr_pages_per_call = nr_pages;
-	if (write)
-		gup.gup_flags |= FOLL_WRITE;
+		gup.addr = (unsigned long)self->addr;
+		gup.size = self->size;
+		gup.nr_pages_per_call = nr_pages_list[i] < 0 ?
+			self->size / psize() : nr_pages_list[i];
 
-	gup_fd = open(GUP_TEST_FILE, O_RDWR);
-	if (gup_fd == -1) {
-		switch (errno) {
-		case EACCES:
-			if (getuid())
-				ksft_print_msg("Please run this test as root\n");
-			break;
-		case ENOENT:
-			if (opendir("/sys/kernel/debug") == NULL)
-				ksft_print_msg("mount debugfs at /sys/kernel/debug\n");
-			ksft_print_msg("check if CONFIG_GUP_TEST is enabled in kernel config\n");
-			break;
-		default:
-			ksft_print_msg("failed to open %s: %s\n", GUP_TEST_FILE, strerror(errno));
-			break;
-		}
-		ksft_test_result_skip("Please run this test as root\n");
-		ksft_exit_pass();
+		if (variant->write)
+			gup.gup_flags |= FOLL_WRITE;
+
+		TH_LOG("nr_pages_per_call=%u", gup.nr_pages_per_call);
+		ASSERT_EQ(ioctl(self->gup_fd, PIN_LONGTERM_BENCHMARK, &gup), 0);
 	}
+}
+
+TEST(dump_user_pages_sparse_indices)
+{
+	/* Tests sparse multi-index which_pages[] inputs. */
+	struct gup_test gup = { 0 };
+	unsigned long size = 128 * MB;
+	int zero_fd, gup_fd;
+	char *addr, *p;
+
+	zero_fd = open("/dev/zero", O_RDWR);
+	ASSERT_GE(zero_fd, 0);
 
-	p = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, filed, 0);
-	if (p == MAP_FAILED)
-		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
-	gup.addr = (unsigned long)p;
+	gup_fd = open(GUP_TEST_FILE, O_RDWR);
+	ASSERT_GE(gup_fd, 0);
+
+	addr = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE, zero_fd, 0);
+	close(zero_fd);
+	ASSERT_NE(addr, MAP_FAILED);
 
-	if (thp == 1)
-		madvise(p, size, MADV_HUGEPAGE);
-	else if (thp == 0)
-		madvise(p, size, MADV_NOHUGEPAGE);
+	madvise(addr, size, MADV_HUGEPAGE);
 
-	/* Fault them in here, from user space. */
-	for (; (unsigned long)p < gup.addr + size; p += psize())
+	for (p = addr; (unsigned long)p < (unsigned long)addr + size;
+	     p += psize())
 		p[0] = 0;
 
-	tid = malloc(sizeof(pthread_t) * nthreads);
-	assert(tid);
-	for (i = 0; i < nthreads; i++) {
-		ret = pthread_create(&tid[i], NULL, gup_thread, &gup);
-		assert(ret == 0);
-	}
-	for (i = 0; i < nthreads; i++) {
-		ret = pthread_join(tid[i], NULL);
-		assert(ret == 0);
+	gup.addr = (unsigned long)addr;
+	gup.size = size;
+	gup.nr_pages_per_call = size / psize();
+	gup.gup_flags = FOLL_WRITE;
+	gup.which_pages[0] = 1;
+	gup.which_pages[1] = 20;
+	gup.which_pages[2] = 0x1001;
+
+	/*
+	 * Preserve the old "./gup_test -ct -F 0x1 0 19 0x1000" sparse dump
+	 * coverage after removing command-line parsing from this binary.
+	 */
+	ASSERT_EQ(ioctl(gup_fd, DUMP_USER_PAGES_TEST, &gup), 0);
+
+	munmap(addr, size);
+	close(gup_fd);
+}
+
+int main(int argc, char **argv)
+{
+	int fd;
+	char *file = "/dev/zero";
+
+	fd = open(file, O_RDWR);
+	if (fd < 0) {
+		ksft_print_header();
+		ksft_exit_fail_msg("Unable to open %s: %s\n", file, strerror(errno));
 	}
+	close(fd);
 
-	free(tid);
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
+		ksft_exit_skip("failed to open %s: %s\n", GUP_TEST_FILE, strerror(errno));
+	}
+	close(fd);
 
-	ksft_exit_pass();
+	return test_harness_run(argc, argv);
 }
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 8c296dedf047..56df0dcc9640 100755
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
@@ -276,18 +252,7 @@ fi
 
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
+CATEGORY="gup_test" run_test ./gup_test
 CATEGORY="gup_test" run_test ./gup_longterm
 
 CATEGORY="userfaultfd" run_test ./uffd-unit-tests
-- 
2.39.5


