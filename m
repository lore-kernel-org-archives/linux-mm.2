Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D41BCD4F57
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 12:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A21766B008C; Tue, 19 May 2026 08:05:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D2086B0092; Tue, 19 May 2026 08:05:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E8476B0093; Tue, 19 May 2026 08:05:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CDA36B008C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:05:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21E901C01FE
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:05:39 +0000 (UTC)
X-FDA: 84784039998.03.3671703
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4FE5DC000D
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:05:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VhpmnhQ0;
	spf=pass (imf28.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779192337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sOLUTD9bjwIj7EQgMgcfgWdDKm//93vlMC1A6YO+OaA=;
	b=bwVDX9MJkuuabtLfMNOtnmRx/8rXxdH6bXG4Mmd91Excb1HmC86wKDVwJczENB6yTNFrty
	Mv4UCo/mClgbRzKfrwsE2VAQzUxqUofavETk6/b7lHMgvxqchsiGzpkM50hSZeJUwy9pnn
	vU3aSH8NAxmNq1NCEitaX+0DkFwLsas=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779192337; a=rsa-sha256;
	cv=none;
	b=sX6XQnXc1GGfWt6cmc5LEx6kztewxpP6WD9nr3j7CnWwiKUpBbXrjqiCX43p5jvx4vb8V8
	0z+ZMWp6EKGg5jOV1Bo5ZvWV3G2ODwB6w2llJ484qRHXcvDvrcrZIucpyFkIbLckouY/Bu
	EwOwkuVBjWa4SlBx44n4EX3mjGFMsGA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VhpmnhQ0;
	spf=pass (imf28.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 57A5A22FA;
	Tue, 19 May 2026 05:05:31 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.82])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8D6653F85F;
	Tue, 19 May 2026 05:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779192336; bh=yzDH1fe6pPEveZCHQQ7TQ4gFssEnayPY5KiUXGNb6qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VhpmnhQ0GRfyKMGVvfArpYPMi0SzXF78+iEt3YorseGqcwYxa/sLAW3vFhaw3ZeDq
	 QgEGeZqEul4UCzdPf23qqtwhKMgQYlQdX+93EaTIf5fqDvTFbejSmEm2at0UomFQ8s
	 e7+tPkqa7hWo8GYdgFDoom0rJ82oG3T00h9z7wQE=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v2 2/2] selftests/mm: rewrite gup_test as a standalone harness-based selftest
Date: Tue, 19 May 2026 17:35:06 +0530
Message-ID: <20260519120506.184512-3-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260519120506.184512-1-sarthak.sharma@arm.com>
References: <20260519120506.184512-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4FE5DC000D
X-Stat-Signature: 75ym6whm7aj45r9btrd3bo6mnnttza1b
X-Rspam-User: 
X-HE-Tag: 1779192337-880045
X-HE-Meta: U2FsdGVkX19jF8/X+2Jsv30rpAxxAd/P7pfGCQuoX2omKOAPgMr/bWn2LQLAjYUn9NvZyiiIS+doPgMsvD/1mjpyhDnO5urWWdnTuo1PSmrPyxYjTckiGKw337JRoWcmptdNK2cW9A0RcGvz+Upzlq3loDy7KHgwRsA6hWancfbZGV+MaOzeoaDOep50ulGtjUgWwzVFo8f1wKiXe8MDWQemz5pdLXlMj/+Em4NuA0QhjAr8YAR9DEgFaJUxY8uyZ8ViEQTjIbJIU4DTK0LawGHO/DTtNW6ZzPC9LlfyIhinv2im26S5GJi4atfVZ/IB/3zmMW+IDE5exbqUWRqFuq9b2yRYIO5gAEqCgXxUV1zWlvbpdvxoutUMTcSucqgjoTf3XINnN0wleAL8rm5scotQZ4FTSGHDDNGXBxkDqzLmZrcToIaYRzukARi07T7Dqu5fKE2Eg/yeqNI47MF+BIrdbDw77EBZv7ViQrGJHHPgFFei+86RTzpx/fXWuT8dMgr0WEK1vlFBV4TMKgv9gb3fxptYv1+EpWW1crQc9VbL+1gqg333LZhJdbrAYp/8rKilSP3ebVFbN3sHDVsdN/xtSls3djdmCUMqAOFrVlxrJBm6aaR9wGSjZvgKGFpkRScn4LwRqs57f9+aJ1LMxNwTvpjzJdVAjb3Fvd/i7OGlEd1KZZHS6bPScAM8EoZf1P2/CoXltLjd07rjAIK0cbmRbytXclD8s4b0px7JQET2F7NtFPFIBDGazzsjJtpmlTcJQIVWTEdgKA1XJCuWCgusN2q3+VzwSkwIOt4cFLBAs9SmA/XQoPVgrEgDTN7xTf631glepI2djoccxgWeAmSUrTYT8LYv25yKMheuBhbhbBZurgNYvXegHLE9e3FPrZHcHZe6Q1ImWX+xQ3HFriwb0Xg7jTtqHU5OAPWl4o/07hu+MtgcVsMpB1okVXtMazhGy92WT0FoSewgWec
 GxtzBTg6
 Bmv2QY7LR7uoCeH6SzqV9Z4AaTCK4K6U0WVLjsC6OT3qFF74qyQhkgtdZFVCDjP/h4eOgukrMPhxVOujAqxZOP8jGpglqLo2alMc7V/AKL4UrAuY1B0dqIteFpU6e/jjDaYPn9QT7j0oBkZ7GxAEEIzqYlvaLr2kV5pl1oBk5LdM9E3YB9zzrVkG9zxRlvYcqB0wsgL5fBXBRzBxEzb3vR2B6A8BDy2tqHNlX54N9uZj8FyelvOCmPomWTxMAPrJ7baPcmbkPO5ZouV2F8nIMvm+w4NZb4ROStwfh+3ZBXTIAfOMBpnrs6yJ8qWIIMtbireuV
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
additional sweeps, for 336 total ioctl sweeps and 84 TAP-reported cases.

On a Radxa Orion O6 board, ./gup_test completes in 5.07s on average
over 10 runs (range: 4.94s - 5.18s).

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
 tools/testing/selftests/mm/gup_test.c     | 536 +++++++++++++---------
 tools/testing/selftests/mm/run_vmtests.sh |  37 +-
 3 files changed, 325 insertions(+), 260 deletions(-)

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
index 3f841a96f870..d60d48bb9126 100644
--- a/tools/testing/selftests/mm/gup_test.c
+++ b/tools/testing/selftests/mm/gup_test.c
@@ -9,267 +9,361 @@
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/types.h>
-#include <pthread.h>
-#include <assert.h>
 #include <mm/gup_test.h>
 #include "kselftest.h"
 #include "vm_util.h"
 #include "hugepage_settings.h"
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
+FIXTURE(gup_test) {
+	int gup_fd;
+	char *addr;
+	unsigned long size;
+};
+
+FIXTURE_VARIANT(gup_test) {
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
+
+FIXTURE_VARIANT_ADD(gup_test, shared_readonly_thp)
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
 
-static char *cmd_to_str(unsigned long cmd)
+FIXTURE_VARIANT_ADD(gup_test, shared_readonly_hugetlb)
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
+	.thp = false,
+	.hugetlb = true,
+	.write = false,
+	.shared = true,
+};
+
+FIXTURE_SETUP(gup_test) {
+	int mmap_flags = MAP_PRIVATE;
+	int zero_fd;
+	char *p;
+
+	self->size = variant->hugetlb ? 256 * MB : 128 * MB;
+
+	/* Check for hugetlb */
+	if (variant->hugetlb) {
+		unsigned long hp_size = default_huge_page_size();
+
+		if (!hp_size)
+			SKIP(return, "HugeTLB not available\n");
+
+		self->size = (self->size + hp_size - 1) & ~(hp_size - 1);
+		if (!hugetlb_setup_default(self->size / hp_size))
+			SKIP(return, "Not enough huge pages\n");
+
+		mmap_flags |= (MAP_HUGETLB | MAP_ANONYMOUS);
 	}
-	return "Unknown command";
+
+	/* zero_fd has to be >= 0. Already checked in main() */
+	zero_fd = open("/dev/zero", O_RDWR);
+	ASSERT_GE(zero_fd, 0);
+
+	/* gup_fd has to be >= 0. Already checked in main() */
+	self->gup_fd = open(GUP_TEST_FILE, O_RDWR);
+	ASSERT_GE(self->gup_fd, 0);
+
+	if (variant->shared)
+		mmap_flags = (mmap_flags & ~MAP_PRIVATE) | MAP_SHARED;
+
+	self->addr = mmap(NULL, self->size, PROT_READ | PROT_WRITE,
+					mmap_flags, zero_fd, 0);
+	close(zero_fd);
+	ASSERT_NE(self->addr, MAP_FAILED);
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
-{
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
+FIXTURE_TEARDOWN(gup_test) {
+	munmap(self->addr, self->size);
+	close(self->gup_fd);
+
+	if (variant->hugetlb)
+		hugetlb_restore_settings();
+}
+
+TEST_F(gup_test, get_user_pages) {
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
 	}
+}
+
+TEST_F(gup_test, pin_user_pages) {
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
 
-return_:
-	ksft_test_result(!status, "ioctl status %d\n", status);
-	return NULL;
+		if (variant->write)
+			gup.gup_flags |= FOLL_WRITE;
+
+		TH_LOG("nr_pages_per_call=%u", gup.nr_pages_per_call);
+		ASSERT_EQ(ioctl(self->gup_fd, PIN_BASIC_TEST, &gup), 0);
+	}
 }
 
-int main(int argc, char **argv)
-{
-	struct gup_test gup = { 0 };
-	int filed, i, opt, nr_pages = 1, thp = -1, write = 1, nthreads = 1, ret;
-	int flags = MAP_PRIVATE;
-	char *file = "/dev/zero";
-	bool hugetlb = false;
-	pthread_t *tid;
-	char *p;
+TEST_F(gup_test, dump_user_pages_with_get) {
+	/* Tests DUMP_USER_PAGES_TEST using get_user_pages */
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
+TEST_F(gup_test, dump_user_pages_with_pin) {
+	/* Tests DUMP_USER_PAGES_TEST using pin_user_pages */
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
+		gup.test_flags |= GUP_TEST_FLAG_DUMP_PAGES_USE_PIN;
+
+		TH_LOG("nr_pages_per_call=%u", gup.nr_pages_per_call);
+		ASSERT_EQ(ioctl(self->gup_fd, DUMP_USER_PAGES_TEST, &gup), 0);
 	}
+}
 
-	ksft_print_header();
+TEST_F(gup_test, get_user_pages_fast) {
+	/* Tests the lockless get_user_pages_fast() path */
+	int i;
 
-	if (hugetlb) {
-		unsigned long hp_size = default_huge_page_size();
+	for (i = 0; i < (int)ARRAY_SIZE(nr_pages_list); i++) {
+		struct gup_test gup = { 0 };
 
-		if (!hp_size)
-			ksft_exit_skip("HugeTLB is unavailable\n");
+		gup.addr = (unsigned long)self->addr;
+		gup.size = self->size;
+		gup.nr_pages_per_call = nr_pages_list[i] < 0 ?
+			self->size / psize() : nr_pages_list[i];
 
-		size = (size + hp_size - 1) & ~(hp_size - 1);
-		if (!hugetlb_setup_default(size / hp_size))
-			ksft_exit_skip("Not enough huge pages\n");
+		if (variant->write)
+			gup.gup_flags |= FOLL_WRITE;
+
+		TH_LOG("nr_pages_per_call=%u", gup.nr_pages_per_call);
+		ASSERT_EQ(ioctl(self->gup_fd, GUP_FAST_BENCHMARK, &gup), 0);
 	}
+}
 
-	ksft_set_plan(nthreads);
+TEST_F(gup_test, pin_user_pages_fast) {
+	/* Tests the lockless pin_user_pages_fast() path */
+	int i;
 
-	filed = open(file, O_RDWR|O_CREAT, 0664);
-	if (filed < 0)
-		ksft_exit_fail_msg("Unable to open %s: %s\n", file, strerror(errno));
+	for (i = 0; i < (int)ARRAY_SIZE(nr_pages_list); i++) {
+		struct gup_test gup = { 0 };
 
-	gup.nr_pages_per_call = nr_pages;
-	if (write)
-		gup.gup_flags |= FOLL_WRITE;
-
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
+		gup.addr = (unsigned long)self->addr;
+		gup.size = self->size;
+		gup.nr_pages_per_call = nr_pages_list[i] < 0 ?
+			self->size / psize() : nr_pages_list[i];
+
+		if (variant->write)
+			gup.gup_flags |= FOLL_WRITE;
+
+		TH_LOG("nr_pages_per_call=%u", gup.nr_pages_per_call);
+		ASSERT_EQ(ioctl(self->gup_fd, PIN_FAST_BENCHMARK, &gup), 0);
 	}
+}
 
-	p = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, filed, 0);
-	if (p == MAP_FAILED)
-		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
-	gup.addr = (unsigned long)p;
+TEST_F(gup_test, pin_user_pages_longterm) {
+	/* Tests pin_user_pages() with FOLL_LONGTERM */
+	int i;
 
-	if (thp == 1)
-		madvise(p, size, MADV_HUGEPAGE);
-	else if (thp == 0)
-		madvise(p, size, MADV_NOHUGEPAGE);
+	for (i = 0; i < (int)ARRAY_SIZE(nr_pages_list); i++) {
+		struct gup_test gup = { 0 };
 
-	/* Fault them in here, from user space. */
-	for (; (unsigned long)p < gup.addr + size; p += psize())
-		p[0] = 0;
+		gup.addr = (unsigned long)self->addr;
+		gup.size = self->size;
+		gup.nr_pages_per_call = nr_pages_list[i] < 0 ?
+			self->size / psize() : nr_pages_list[i];
 
-	tid = malloc(sizeof(pthread_t) * nthreads);
-	assert(tid);
-	for (i = 0; i < nthreads; i++) {
-		ret = pthread_create(&tid[i], NULL, gup_thread, &gup);
-		assert(ret == 0);
+		if (variant->write)
+			gup.gup_flags |= FOLL_WRITE;
+
+		TH_LOG("nr_pages_per_call=%u", gup.nr_pages_per_call);
+		ASSERT_EQ(ioctl(self->gup_fd, PIN_LONGTERM_BENCHMARK, &gup), 0);
 	}
-	for (i = 0; i < nthreads; i++) {
-		ret = pthread_join(tid[i], NULL);
-		assert(ret == 0);
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
+			if (opendir("/sys/kernel/debug") == NULL)
+				ksft_exit_skip("Mount debugfs at /sys/kernel/debug\n");
+			else
+				ksft_exit_skip("Check CONFIG_GUP_TEST in kernel config\n");
+		}
+		ksft_exit_skip("failed to open %s: %s\n", GUP_TEST_FILE, strerror(errno));
+	}
+	close(fd);
 
-	ksft_exit_pass();
+	return test_harness_run(argc, argv);
 }
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 043aa3ed2596..65a4ef0f3748 100755
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
@@ -239,18 +215,7 @@ fi
 
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


