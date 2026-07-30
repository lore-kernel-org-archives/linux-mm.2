Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8032DC55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:09:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E8BD6B00AB; Thu, 30 Jul 2026 10:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7990F6B00AD; Thu, 30 Jul 2026 10:09:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6887D6B00AE; Thu, 30 Jul 2026 10:09:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 398636B00AB
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:09:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E07A40181
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:09:21 +0000 (UTC)
X-FDA: 85045625322.14.D74A073
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id D142320007
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:09:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Snp7Cx7Q;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785420559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HnnBE6S8p/8IYMYj208cCjtnrZvXY2jXUF3flV/QeOE=;
	b=rXhtFYoReEveSUDVTygwHJbeQ5015iBmNbb6cOsR5e/tjZY7nCs9otOFIcPHS9pJEvBAQT
	SuuydzMd1tsdT6hy8uLBQrb+0ZDt7/gQ/AMiO3zsbd01OCEpn0ArGGbfE1qRwmf9/VgVXC
	yqUhXfkIARk7izkeyVLwug7di9U6Vws=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Snp7Cx7Q;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785420559;
	b=NK9AVCWY4ti5a5VgTaM+fw5hdGZ4LDLwagi62QlZpzfW9On5PTZo3ounIJZGbPwUxK4TWX
	OyJa4klQswRR0U7J03yTJPLuMmq9kbzJCDB1qva68UA3R2hoa8KMmhwMEu89H0+VmI0TLr
	dA7qhEKtdZhUswDJYlqzMuRuHnZL3tQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 16F091688;
	Thu, 30 Jul 2026 07:09:15 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BB70B3F86F;
	Thu, 30 Jul 2026 07:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785420559; bh=ovZYWZXcLCfbzmoxoVs8dmAB6uPLX3R+KH1zoN0/cjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Snp7Cx7Q4d/0IjlA8Ar8sF34T3SHiYhh7xlFykcHL8Y4YnruRmztJTT7UROZWDh6F
	 KuQzsNIHD2Pt98xiPfFt5hgrmraZj+K3Qdgxi0n2g9T1Cm03LubV4+QW3Yx/vqjIXD
	 pyTVhxvlOqDRtjR3ShpLSRlHxf3ifA03I7Wn/9MA=
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
Subject: [PATCH v6 5/6] tools/mm: make gup_bench a benchmark only tool
Date: Thu, 30 Jul 2026 19:38:24 +0530
Message-ID: <20260730140825.238130-6-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260730140825.238130-1-sarthak.sharma@arm.com>
References: <20260730140825.238130-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D142320007
X-Rspam-User: 
X-Stat-Signature: 1rzimudpkoo1jk4i8b179upxbzaqnu49
X-HE-Tag: 1785420559-476622
X-HE-Meta: U2FsdGVkX18FCCIbW5dM4sSL2OelAxHssCEoCo83h/q7js4lbjtw8cGObrjhtqCJATrUYUWYMGQ6hCb77RLpYw65QBYvop5i5JJcOYBELdHoO8DRqAzrAnstP5OV3uobCvius94KPXkpEWI/wHCOm0qkjw0l7xQ4pVZoia3Za7zKEODb3AHLov0nKtmEWR6dQhwHIewoh1sN4wuP9JMIjYNAzfsZWVq6wt6i2BGHYtM7mhs0c3xgBFv5qiDWuKiYMZARYAqfei7m2gZoanSMy4b5Le086XZktl7beA3yq/CuOSDc3jkIdr7wOtogfCUox6II0o73gdY30CdrFibp9J8BlhlcQhwrkSCMCUufCHYkUaGmGYrO+lyrkASPyorO+TlcyQ7v1eFduZsvrd3ZU+XSkLE+Bk8ey2/iipxeDEDDEhIstA2/HP8rzrCx+N0rsLRGNLRuDaeG/L3kelblmebfkWBZGvQFzJMAhy6yTEBo7eZquAYdy1glEKQv+ruIGtl19nRvLW5NVTR5J9SMVtMSgAyG56QRxjzw+P4sYwJXpz78BRAGEa6N/5HrNTowMwmNo/Vu/GLM16ZpGgRMWjGOI769xfaID5R8ciTikzAXuheSRWCOVlNpJSEFAuq4zGznvjf3jSi/+RoCZjKX0yQzoCud+YS4aDGGRjuqW3Kh6znkgBT59Gi4H7AAgiFfUru/4qBCVbpTB+bnmezFxe3YTE9JdYRTStU7Vi8PXqpaVotiy8ZVoZjPWKY5cuKcKHl2vRpvemjbe95Yo6m4w0TvcQ3M3KzD6JXVJNqqmKAr8uYzhteHL5kARZ1EjVYoY5w0dM3b60q5djo21vvk2K/I7klarEWHGqbPq7fYrikD3IioqfctU6h/mR1w9oMt5lNV3I8fvlggoDMS7QHRUcDRdBq/vtGxeTHNAbZepF0sbL5zcBkfpoP065tjQ36O/9aG1lbJO8LaUHD+/tq
 q/wvOMNF
 +Krcv9NuOb7p73UnI9xKNN7Tw1G83cS2HU2fsoiG94sOB2pAjl/rQU8Up0F+PkowlIAHSvDpkv2r8n7OJ8DxOWKRFU1QrGnEXy+wCWPYmmpxUzCgUHYsd3hKx4mp0nHDV/FuMguXQh7lqVndDwdM18wDtQaD4puCkZ02XwqdPaO3GxmFc9ijFSiHyanN4mW2V6MuOIryR6Z7y3R3t707TN0VsN+lL1P07FS2aXhdfOb1QkqSTgABZOYUEV9zQ25eatrlFd52LTgKYvD0kKBQ0MkoXefeLSAUDHFOv7kKBSRcj3NOcPMBocD//NSXLVv0G2FUj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the functional modes (GUP_BASIC_TEST, PIN_BASIC_TEST and
DUMP_USER_PAGES_TEST) from gup_bench. Drop kselftest dependency
and use normal diagnostics and exit statuses.

When no arguments are supplied, run a single GUP_FAST_BENCHMARK
with existing default values. Let users select other configs
through command line options. Also validate numeric arguments
and reject positional arguments.

Restore hugeTLB settings on failure and after every run. Also
handle failures without relying on assert() calls.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/mm/gup_bench.c | 329 ++++++++++++++++++++++++++-----------------
 1 file changed, 201 insertions(+), 128 deletions(-)

diff --git a/tools/mm/gup_bench.c b/tools/mm/gup_bench.c
index da56aa5324d3..966a5bf5aac0 100644
--- a/tools/mm/gup_bench.c
+++ b/tools/mm/gup_bench.c
@@ -10,10 +10,13 @@
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <pthread.h>
-#include <assert.h>
+#include <stdbool.h>
+#include <stdatomic.h>
+#include <stdint.h>
+#include <limits.h>
+#include <string.h>
 #include <mm/gup_test.h>
 #include <mm/hugepage_settings.h>
-#include "../testing/selftests/kselftest.h"
 
 #define MB (1UL << 20)
 
@@ -25,6 +28,7 @@
 static unsigned long cmd = GUP_FAST_BENCHMARK;
 static int gup_fd, repeats = 1;
 static unsigned long size = 128 * MB;
+static atomic_int bench_error;
 /* Serialize prints */
 static pthread_mutex_t print_mutex = PTHREAD_MUTEX_INITIALIZER;
 
@@ -37,120 +41,155 @@ static char *cmd_to_str(unsigned long cmd)
 		return "PIN_FAST_BENCHMARK";
 	case PIN_LONGTERM_BENCHMARK:
 		return "PIN_LONGTERM_BENCHMARK";
-	case GUP_BASIC_TEST:
-		return "GUP_BASIC_TEST";
-	case PIN_BASIC_TEST:
-		return "PIN_BASIC_TEST";
-	case DUMP_USER_PAGES_TEST:
-		return "DUMP_USER_PAGES_TEST";
 	}
 	return "Unknown command";
 }
 
+static long parse_long_arg_base(const char *arg, const char *name, int base)
+{
+	char *end;
+	long val;
+
+	errno = 0;
+	val = strtol(arg, &end, base);
+	if (errno || end == arg || *end != '\0') {
+		fprintf(stderr, "Invalid %s '%s'\n", name, arg);
+		exit(1);
+	}
+	return val;
+}
+
+static long parse_long_arg(const char *arg, const char *name)
+{
+	return parse_long_arg_base(arg, name, 10);
+}
+
+static long parse_positive_long_arg(const char *arg, const char *name)
+{
+	long val = parse_long_arg(arg, name);
+
+	if (val < 1) {
+		fprintf(stderr, "Invalid %s '%s'\n", name, arg);
+		exit(1);
+	}
+
+	return val;
+}
+
 void *gup_thread(void *data)
 {
 	struct gup_test gup = *(struct gup_test *)data;
 	int i, status;
 
-	/* Only report timing information on the *_BENCHMARK commands: */
-	if ((cmd == PIN_FAST_BENCHMARK) || (cmd == GUP_FAST_BENCHMARK) ||
-	     (cmd == PIN_LONGTERM_BENCHMARK)) {
-		for (i = 0; i < repeats; i++) {
-			gup.size = size;
-			status = ioctl(gup_fd, cmd, &gup);
-			if (status)
-				break;
+	for (i = 0; i < repeats; i++) {
+		gup.size = size;
+		status = ioctl(gup_fd, cmd, &gup);
+		if (status) {
+			int err = errno;
 
+			bench_error = 1;
 			pthread_mutex_lock(&print_mutex);
-			ksft_print_msg("%s: Time: get:%lld put:%lld us",
-				       cmd_to_str(cmd), gup.get_delta_usec,
-				       gup.put_delta_usec);
-			if (gup.size != size)
-				ksft_print_msg(", truncated (size: %lld)", gup.size);
-			ksft_print_msg("\n");
+			fprintf(stderr, "%s ioctl failed: %s\n", cmd_to_str(cmd),
+				strerror(err));
 			pthread_mutex_unlock(&print_mutex);
+			break;
 		}
-	} else {
-		gup.size = size;
-		status = ioctl(gup_fd, cmd, &gup);
-		if (status)
-			goto return_;
 
 		pthread_mutex_lock(&print_mutex);
-		ksft_print_msg("%s: done\n", cmd_to_str(cmd));
-		if (gup.size != size)
-			ksft_print_msg("Truncated (size: %lld)\n", gup.size);
+		if (gup.size == size)
+			printf("%s time: get:%lld us put:%lld us\n",
+			       cmd_to_str(cmd), gup.get_delta_usec,
+			       gup.put_delta_usec);
+		else
+			printf("%s time: get:%lld put:%lld us, truncated (size: %lld)\n",
+			       cmd_to_str(cmd), gup.get_delta_usec,
+			       gup.put_delta_usec, gup.size);
 		pthread_mutex_unlock(&print_mutex);
 	}
 
-return_:
-	ksft_test_result(!status, "ioctl status %d\n", status);
 	return NULL;
 }
 
 int main(int argc, char **argv)
 {
 	struct gup_test gup = { 0 };
-	int filed, i, opt, nr_pages = 1, thp = -1, write = 1, nthreads = 1, ret;
+	int filed, i, opt, nr_pages = 1, thp = -1, write = 1;
+	int nthreads = 1, ret, started_threads = 0;
 	int flags = MAP_PRIVATE;
-	char *file = "/dev/zero";
-	bool hugetlb = false;
+	const char *file = "/dev/zero";
+	bool hugetlb = false, restore_hugetlb = false;
+	unsigned long nr_pages_per_call;
 	pthread_t *tid;
 	char *p;
 
-	while ((opt = getopt(argc, argv, "m:r:n:F:f:abcj:tTLUuwWSHpz")) != -1) {
+	while ((opt = getopt(argc, argv, "m:r:n:F:f:aj:tTLuwWSH")) != -1) {
 		switch (opt) {
 		case 'a':
 			cmd = PIN_FAST_BENCHMARK;
 			break;
-		case 'b':
-			cmd = PIN_BASIC_TEST;
-			break;
 		case 'L':
 			cmd = PIN_LONGTERM_BENCHMARK;
 			break;
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
+		case 'F': {
+			long val;
+
+			val = parse_long_arg_base(optarg, "GUP flags", 0);
+			if (val < 0 || val > UINT_MAX) {
+				fprintf(stderr, "Invalid GUP flags '%s'\n", optarg);
+				exit(1);
+			}
+
+			gup.gup_flags = val;
 			break;
-		case 'j':
-			nthreads = atoi(optarg);
+		}
+		case 'j': {
+			long val;
+
+			val = parse_positive_long_arg(optarg, "thread count");
+			if (val > INT_MAX ||
+			    (size_t)val > SIZE_MAX / sizeof(pthread_t)) {
+				fprintf(stderr, "Invalid thread count '%s'\n", optarg);
+				exit(1);
+			}
+			nthreads = val;
 			break;
+		}
 		case 'm':
-			size = atoi(optarg) * MB;
+			size = parse_positive_long_arg(optarg, "size");
+			if (size > ULONG_MAX / MB) {
+				fprintf(stderr, "Invalid size '%s'\n", optarg);
+				exit(1);
+			}
+			size *= MB;
 			break;
-		case 'r':
-			repeats = atoi(optarg);
+		case 'r': {
+			long val;
+
+			val = parse_positive_long_arg(optarg, "repeat count");
+			if (val > INT_MAX) {
+				fprintf(stderr, "Invalid repeat count '%s'\n", optarg);
+				exit(1);
+			}
+			repeats = val;
 			break;
-		case 'n':
-			nr_pages = atoi(optarg);
-			if (nr_pages < 0)
-				nr_pages = size / getpagesize();
+		}
+		case 'n': {
+			long val;
+
+			val = parse_long_arg(optarg, "page count");
+			if (val != -1 && (val < 1 || val > INT_MAX)) {
+				fprintf(stderr, "Invalid page count '%s'\n", optarg);
+				exit(1);
+			}
+			nr_pages = val;
 			break;
+		}
 		case 't':
 			thp = 1;
 			break;
 		case 'T':
 			thp = 0;
 			break;
-		case 'U':
-			cmd = GUP_BASIC_TEST;
-			break;
 		case 'u':
 			cmd = GUP_FAST_BENCHMARK;
 			break;
@@ -172,80 +211,93 @@ int main(int argc, char **argv)
 			hugetlb = true;
 			break;
 		default:
-			ksft_exit_fail_msg("Wrong argument\n");
+			fprintf(stderr, "Wrong argument\n");
+			exit(1);
 		}
 	}
 
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
+	if (optind != argc) {
+		fprintf(stderr, "Unexpected argument '%s'\n", argv[optind]);
+		exit(1);
 	}
 
-	ksft_print_header();
-
 	if (hugetlb) {
 		unsigned long hp_size = default_huge_page_size();
 
-		if (!hp_size)
-			ksft_exit_skip("HugeTLB is unavailable\n");
+		if (!hp_size) {
+			fprintf(stderr, "Could not determine huge page size\n");
+			return 1;
+		}
+
+		if (size > ULONG_MAX - (hp_size - 1)) {
+			fprintf(stderr, "HugeTLB mapping size is too large\n");
+			return 1;
+		}
 
 		size = (size + hp_size - 1) & ~(hp_size - 1);
-		if (!hugetlb_setup_default(size / hp_size))
-			ksft_exit_skip("Not enough huge pages\n");
+		if (!hugetlb_setup_default(size / hp_size)) {
+			fprintf(stderr, "Not enough huge pages\n");
+			hugetlb_restore_settings();
+			return 1;
+		}
+		restore_hugetlb = true;
 	}
 
-	ksft_set_plan(nthreads);
-
-	filed = open(file, O_RDWR|O_CREAT, 0664);
-	if (filed < 0)
-		ksft_exit_fail_msg("Unable to open %s: %s\n", file, strerror(errno));
-
-	gup.nr_pages_per_call = nr_pages;
+	nr_pages_per_call = nr_pages < 0 ? size / getpagesize() :
+		(unsigned long)nr_pages;
+	if (nr_pages_per_call > UINT_MAX) {
+		fprintf(stderr, "Page count is too large\n");
+		if (restore_hugetlb)
+			hugetlb_restore_settings();
+		return 1;
+	}
+	gup.nr_pages_per_call = nr_pages_per_call;
 	if (write)
 		gup.gup_flags |= FOLL_WRITE;
 
+	filed = open(file, O_RDWR | O_CREAT, 0664);
+	if (filed < 0) {
+		fprintf(stderr, "Unable to open %s: %s\n", file, strerror(errno));
+		if (restore_hugetlb)
+			hugetlb_restore_settings();
+		return 1;
+	}
+
 	gup_fd = open(GUP_TEST_FILE, O_RDWR);
 	if (gup_fd == -1) {
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
+		int err = errno;
+
+		close(filed);
+		if (err == EACCES)
+			fprintf(stderr, "Please run as root\n");
+		else if (err == ENOENT) {
+			DIR *debugfs = opendir("/sys/kernel/debug");
+
+			if (!debugfs)
+				fprintf(stderr, "Mount debugfs at /sys/kernel/debug\n");
+			else {
+				closedir(debugfs);
+				fprintf(stderr, "Check CONFIG_GUP_TEST in kernel config\n");
+			}
+		} else
+			fprintf(stderr, "Failed to open %s: %s\n", GUP_TEST_FILE,
+				strerror(err));
+		if (restore_hugetlb)
+			hugetlb_restore_settings();
+		return 1;
 	}
 
 	p = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, filed, 0);
-	if (p == MAP_FAILED)
-		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
+	if (p == MAP_FAILED) {
+		fprintf(stderr, "mmap: %s\n", strerror(errno));
+		close(filed);
+		close(gup_fd);
+
+		if (restore_hugetlb)
+			hugetlb_restore_settings();
+		return 1;
+	}
+	close(filed);
 	gup.addr = (unsigned long)p;
 
 	if (thp == 1)
@@ -258,17 +310,38 @@ int main(int argc, char **argv)
 		p[0] = 0;
 
 	tid = malloc(sizeof(pthread_t) * nthreads);
-	assert(tid);
+	if (!tid) {
+		fprintf(stderr, "Failed to allocate %d threads: %s\n",
+			nthreads, strerror(errno));
+		munmap((void *)gup.addr, size);
+		close(gup_fd);
+		if (restore_hugetlb)
+			hugetlb_restore_settings();
+		return 1;
+	}
+
 	for (i = 0; i < nthreads; i++) {
 		ret = pthread_create(&tid[i], NULL, gup_thread, &gup);
-		assert(ret == 0);
+		if (ret) {
+			fprintf(stderr, "pthread_create failed: %s\n", strerror(ret));
+			bench_error = 1;
+			break;
+		}
+		started_threads++;
 	}
-	for (i = 0; i < nthreads; i++) {
+	for (i = 0; i < started_threads; i++) {
 		ret = pthread_join(tid[i], NULL);
-		assert(ret == 0);
+		if (ret) {
+			fprintf(stderr, "pthread_join failed: %s\n", strerror(ret));
+			bench_error = 1;
+		}
 	}
 
 	free(tid);
+	munmap((void *)gup.addr, size);
+	close(gup_fd);
+	if (restore_hugetlb)
+		hugetlb_restore_settings();
 
-	ksft_exit_pass();
+	return bench_error ? 1 : 0;
 }
-- 
2.39.5


