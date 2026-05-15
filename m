Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4F84CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 08:49:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B3966B008A; Fri, 15 May 2026 04:49:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28B296B008C; Fri, 15 May 2026 04:49:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C7C06B0092; Fri, 15 May 2026 04:49:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F34B6B008A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 04:49:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B1C2940809
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:49:13 +0000 (UTC)
X-FDA: 84769029786.23.20F4E20
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id B11E0140010
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:49:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GpCVi47f;
	spf=pass (imf26.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778834952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7fViFKZ5hzS2zuCsD817nbqgQX5IpI/v9YWEjeEkB+E=;
	b=BG9B8qBQZ2F+JqwFmoYhezTA0vYPm6m/VmWDdLD6BTLSVtvuIzDXMtI9Q1T/p93RZuV1uO
	cdqJ/+fNWo01F/kzS5C5z5CaNHAhSKRAF++bXdqVJj4U8TDE1Hi0Q3zSfjWTErL4M+3TFp
	RQn+Fr+6tJ4wwGea1q0PVj7tO10hBL0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778834952; a=rsa-sha256;
	cv=none;
	b=NZlN/gBADZNPF3A92F5izrUMRQZd7zuHt+vWtrOQdAqBh854OjB5KK00vs1G5Ki2SL3J2y
	q+D2fZr2g5yIZQYBRNCgGK+UPbA/gQ0NOBUsXkMXs1wk0PiPQ0PR2/As0Cbh8psPhwZMIS
	AI6K/Lx41aRJMRLfKulPBezIfPIa7vY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GpCVi47f;
	spf=pass (imf26.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AB31F26A4;
	Fri, 15 May 2026 01:49:04 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.82])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 154A83F7B4;
	Fri, 15 May 2026 01:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778834949; bh=oCtq2AZBnQJJnWw16nvThl6m2oj4VBTv7iHzzpyZ8iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GpCVi47fPt4AopC6BsmPj104ka1yJKkMcgsQqV/KO0PqkCnuIaGJ2K4zfRkhvR+m+
	 sqQXMVbSbUkiRVnwbUF47NyifwXBXEWlKRNgI4mndPVPwMZiHybsHKzY0KAQBaAYoj
	 M0D+k21mKQ7qE1RGIMbIc4O2m4DMReGjQ3m8S4rs=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
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
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH 2/2] selftests/mm: rewrite gup_test as a standalone harness-based selftest
Date: Fri, 15 May 2026 14:18:40 +0530
Message-ID: <20260515084840.174652-3-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260515084840.174652-1-sarthak.sharma@arm.com>
References: <20260515084840.174652-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B11E0140010
X-Rspam-User: 
X-Stat-Signature: qqs9yuony83qxsfktu7sufbcy7oj7pyr
X-HE-Tag: 1778834951-679808
X-HE-Meta: U2FsdGVkX18XTVGHKy9YqdVFewTK6Neo4Yao5nkK+5/CI7cV2jIuCfbA7U5vi30oivVOtyCIql9hUNEdrNh6jTNtv5TPwKfS9tXKXuadbah1e7oTQys5ZeSsdoJ36qrWR19QSMHc0TTjUj8vqb/qCE6BbsAxnUYrco7h4XGqn9kcf/3J/nrDIIx1Log2kORUW9KEgFIHJ+RO9qynlH3/tCQuWbikFzBzSNsmfr3/8I+GjKPLIimrjr9ZN93S8czK2dzYDmS12Z0gwW21xgT2m+GE/w4eHjMcfcK1CgJ42Hy8vnpuPFtBNHXLg4aQq5MXGw4poK0oGNMo+SfWAg2ZiU8JmNb/0DnD9v2pD8vyX3Ov2fHfIm/GjY/BtWzWFFdrDPOEykT/8ixbmSG4kWyoyUf4z18Wcwx4ItaKYqM+Vmn/6ouPLjSRLhR78LNSIhKkgYwG/xO7FnAmit6pAYYrAtNc59rkqL2zLe7ISkFf13VOcLlA1C/AInxugCtpPa+tCB03w1jv0IhUUgOjReniykHVK4rq4Cx5j5qEQZf8J61RQOqfgNdVoORfxm9BbRZURE4RvPyLETAlU1V7yGkHdOh7BgjjhqDLxyf34+zg/IcgazlWFCUBBssp6DZdW809vz2wQgiSYGf53t46ZMCqrUdyWtQNtrerkwvuFw2gcZGLNtrNJYzwxIMA0X5/W5AX3eQEMaGJvl2ZAnH9BlHIZADjT8ZLSfMd0GJcWLxQcbGfHzSw3pK2+V3o+P1Sc6IPs0iHGa4tdtSw36eCBxT1C/Oh1hdK1dE/zjmBRwi/I1Pi5xcZFyp3mu3UriC4+j0kGKIxa8vYwsWH6DxtnIIVpXz53vnlKgdRQ2j1INDgICtZrKbj+K1JOJBw7pk8+WNo5pGTBTSM9esO7LX2P0Z1tXZzVDQsgvy/EjsW0VnlTvPKfN4XRp7eXe5CXdOKwCZHbpfSdylr9FSuJnWB9oc
 nktB1LjB
 V35n5w4u2eKlwPrSNlRbJkcTLSMFY2x82kehQCOlZX8bkA9SE9Us5T6ZV3Q5MTUq/8IPmI5RwgOJltI/9LKPRpa3A2LlqIyWvYs25leEoDz+FiPpoLBtRcJlIRodLI5iwK1ib0Llahj5tXIg84sRav15yRC/3xMHuy49Edf3c0nuQZumSNSo78/aF1uLW8onTIIK524B8cgntXxKXTk3ciUVn73pYnzxw5anNWCIexinW0Hs4KmX6e/FnR9IuFf8m5HpRnYKJaGzX9e2jnHvzcpebuN2irKSEKZEhi2WSkCoZPZoL+kJpUYH2z8pYoQeuxK3x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rewrite gup_test.c using kselftest_harness.h. The new test uses
FIXTURE_VARIANT to cover seven configurations (private/shared,
read/write, THP, hugetlb) and runs four test cases per variant
(GUP_BASIC_TEST, PIN_BASIC_TEST, DUMP_USER_PAGES_TEST with get and
pin), giving 28 TAP-reported cases in total without requiring any
command-line arguments.

Update run_vmtests.sh: remove run_gup_matrix() and the multiple flagged
invocations of gup_test, replacing them with a single unconditional
invocation. Benchmark functionality is handled by tools/mm/gup_bench
introduced in the previous patch.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/gup_test.c     | 404 ++++++++++------------
 tools/testing/selftests/mm/run_vmtests.sh |  37 +-
 2 files changed, 182 insertions(+), 259 deletions(-)

diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/selftests/mm/gup_test.c
index 3f841a96f870..c0e5e88d89ed 100644
--- a/tools/testing/selftests/mm/gup_test.c
+++ b/tools/testing/selftests/mm/gup_test.c
@@ -9,12 +9,11 @@
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
 
@@ -23,253 +22,212 @@
 
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
 
-static char *cmd_to_str(unsigned long cmd)
+FIXTURE_VARIANT(gup_test) {
+	bool thp;
+	bool hugetlb;
+	bool write;
+	bool shared;
+};
+
+FIXTURE_VARIANT_ADD(gup_test, private_write)
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
-	}
-	return "Unknown command";
-}
+	.thp = false,
+	.hugetlb = false,
+	.write = true,
+	.shared = false,
+};
 
-void *gup_thread(void *data)
+FIXTURE_VARIANT_ADD(gup_test, private_readonly)
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
-	}
+	.thp = false,
+	.hugetlb = false,
+	.write = false,
+	.shared = false,
+};
 
-return_:
-	ksft_test_result(!status, "ioctl status %d\n", status);
-	return NULL;
-}
+FIXTURE_VARIANT_ADD(gup_test, private_write_thp)
+{
+	.thp = true,
+	.hugetlb = false,
+	.write = true,
+	.shared = false,
+};
 
-int main(int argc, char **argv)
+FIXTURE_VARIANT_ADD(gup_test, private_readonly_thp)
 {
-	struct gup_test gup = { 0 };
-	int filed, i, opt, nr_pages = 1, thp = -1, write = 1, nthreads = 1, ret;
-	int flags = MAP_PRIVATE;
-	char *file = "/dev/zero";
-	bool hugetlb = false;
-	pthread_t *tid;
-	char *p;
+	.thp = true,
+	.hugetlb = false,
+	.write = false,
+	.shared = false,
+};
 
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
-	}
+FIXTURE_VARIANT_ADD(gup_test, private_write_hugetlb)
+{
+	.thp = false,
+	.hugetlb = true,
+	.write = true,
+	.shared = false,
+};
 
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
-	}
+FIXTURE_VARIANT_ADD(gup_test, private_readonly_hugetlb)
+{
+	.thp = false,
+	.hugetlb = true,
+	.write = false,
+	.shared = false,
+};
 
-	ksft_print_header();
+FIXTURE_VARIANT_ADD(gup_test, shared_write)
+{
+	.thp = false,
+	.hugetlb = false,
+	.write = true,
+	.shared = true,
+};
+
+FIXTURE_SETUP(gup_test) {
+	int mmap_flags = MAP_PRIVATE;
+	int zero_fd;
+	char *p;
 
-	if (hugetlb) {
+	self->size = 128 * MB;
+
+	/* Check for hugetlb */
+	if (variant->hugetlb) {
 		unsigned long hp_size = default_huge_page_size();
 
 		if (!hp_size)
-			ksft_exit_skip("HugeTLB is unavailable\n");
+			SKIP(return, "HugeTLB not available\n");
+
+		self->size = (self->size + hp_size - 1) & ~(hp_size - 1);
+		if (!hugetlb_setup_default(self->size / hp_size))
+			SKIP(return, "Not enough huge pages\n");
 
-		size = (size + hp_size - 1) & ~(hp_size - 1);
-		if (!hugetlb_setup_default(size / hp_size))
-			ksft_exit_skip("Not enough huge pages\n");
+		mmap_flags |= (MAP_HUGETLB | MAP_ANONYMOUS);
 	}
 
-	ksft_set_plan(nthreads);
+	/* zero_fd has to be >=0. Already checked in main() */
+	zero_fd = open("/dev/zero", O_RDWR);
+	ASSERT_GE(zero_fd, 0);
 
-	filed = open(file, O_RDWR|O_CREAT, 0664);
-	if (filed < 0)
-		ksft_exit_fail_msg("Unable to open %s: %s\n", file, strerror(errno));
+	/* gup_fd has to be >=0. Already checked in main() */
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
+
+	for (p = self->addr; (unsigned long)p < (unsigned long)self->addr
+			+ self->size; p += psize())
+		p[0] = 0;
+}
+
+FIXTURE_TEARDOWN(gup_test) {
+	munmap(self->addr, self->size);
+	close(self->gup_fd);
+}
+
+TEST_F(gup_test, get_user_pages) {
+	/* tests get_user_pages */
+	struct gup_test gup = { 0 };
+
+	gup.addr = (unsigned long)self->addr;
+	gup.size = self->size;
+	gup.nr_pages_per_call = 1;
 
-	gup.nr_pages_per_call = nr_pages;
-	if (write)
+	if (variant->write)
 		gup.gup_flags |= FOLL_WRITE;
 
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
-	}
+	ASSERT_EQ(ioctl(self->gup_fd, GUP_BASIC_TEST, &gup), 0);
+}
 
-	p = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, filed, 0);
-	if (p == MAP_FAILED)
-		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
-	gup.addr = (unsigned long)p;
+TEST_F(gup_test, pin_user_pages) {
+	/* tests pin_user_pages */
+	struct gup_test gup = { 0 };
 
-	if (thp == 1)
-		madvise(p, size, MADV_HUGEPAGE);
-	else if (thp == 0)
-		madvise(p, size, MADV_NOHUGEPAGE);
+	gup.addr = (unsigned long)self->addr;
+	gup.size = self->size;
+	gup.nr_pages_per_call = 1;
 
-	/* Fault them in here, from user space. */
-	for (; (unsigned long)p < gup.addr + size; p += psize())
-		p[0] = 0;
+	if (variant->write)
+		gup.gup_flags |= FOLL_WRITE;
+
+	ASSERT_EQ(ioctl(self->gup_fd, PIN_BASIC_TEST, &gup), 0);
+}
+
+TEST_F(gup_test, dump_user_pages_with_get) {
+	/* tests DUMP_USER_PAGES_TEST using get_user_pages */
+	struct gup_test gup = { 0 };
+
+	gup.addr = (unsigned long)self->addr;
+	gup.size = self->size;
+	gup.nr_pages_per_call = 1;
+
+	if (variant->write)
+		gup.gup_flags |= FOLL_WRITE;
+
+	gup.which_pages[0] = 1;
+
+	ASSERT_EQ(ioctl(self->gup_fd, DUMP_USER_PAGES_TEST, &gup), 0);
+}
 
-	tid = malloc(sizeof(pthread_t) * nthreads);
-	assert(tid);
-	for (i = 0; i < nthreads; i++) {
-		ret = pthread_create(&tid[i], NULL, gup_thread, &gup);
-		assert(ret == 0);
+TEST_F(gup_test, dump_user_pages_with_pin) {
+	/* tests DUMP_USER_PAGES_TEST using pin_user_pages */
+	struct gup_test gup = { 0 };
+
+	gup.addr = (unsigned long)self->addr;
+	gup.size = self->size;
+	gup.nr_pages_per_call = 1;
+
+	if (variant->write)
+		gup.gup_flags |= FOLL_WRITE;
+
+	gup.which_pages[0] = 1;
+	gup.test_flags |= GUP_TEST_FLAG_DUMP_PAGES_USE_PIN;
+
+	ASSERT_EQ(ioctl(self->gup_fd, DUMP_USER_PAGES_TEST, &gup), 0);
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
-	for (i = 0; i < nthreads; i++) {
-		ret = pthread_join(tid[i], NULL);
-		assert(ret == 0);
+	close(fd);
+
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
 	}
+	close(fd);
 
-	free(tid);
-
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


