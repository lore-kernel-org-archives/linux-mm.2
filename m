Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA7CFC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 18:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E76926B058F; Thu, 13 Aug 2026 14:14:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E26746B0591; Thu, 13 Aug 2026 14:14:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D17496B0592; Thu, 13 Aug 2026 14:14:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A52A86B058F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:14:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 308D54027A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:14:05 +0000 (UTC)
X-FDA: 85097045250.23.C2BE501
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2D7041A000D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:14:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=G4hci20J;
	spf=pass (imf19.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786644843;
	b=wJIIxbV75a1D0ZLnQlUuYnojCSIVXDrG41CSJWyX0ZgE1MUL4Rwx2d41b9LaN5bZq4kKpd
	EtWbfDqdXaMeCotHpm0jpAosjarwTB23QnS7AOjx4ii6e3rCh21kcmPYM/BvOyfeDFs81n
	8lD1tyNCENku65dgIUUn4qH1drSgzoA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=G4hci20J;
	spf=pass (imf19.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786644843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N0ewzdxiOTQ2Q1N5TeGhQZWj7FdB54mXEFhRi3oy+Wk=;
	b=S8EUkKWz2i9kUb1FJliubdbFFgjCfmJUxZ/0MOkxiLYaosIkV+0Pqti7orW/Om3wslUzMr
	i9+i+hQvnr/n+KAeNSL3mkZQyrfuz935w6AVfSnQ8Z/b4BWg7g8VmGB8FEKU9kAFo8lIIT
	uPJctLRdKNWk570xWZYMlv+5Ab/MCeQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 80D9A1AC1;
	Thu, 13 Aug 2026 11:13:58 -0700 (PDT)
Received: from a081061.arm.com (unknown [10.163.171.218])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8B9E23F66F;
	Thu, 13 Aug 2026 11:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786644842; bh=yssMLTgIsdoss4tuXrwqXHDJPlqnQh0vUZScCsyB34c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G4hci20JwmwrYie2jo2HuglhH4Dydrsl3T7MoBmuLw+IkomhsMEeGw1wZUSrJZFAn
	 b/p4g8hbtpM8x61hp5exJOwoTwrinsmPzwvTqb1V4uigD2KinBjF/O6/GmhjV30QHj
	 iybYFzk1C95099DwIWylDHND1djh0KjHK2JtABL8=
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
Subject: [PATCH v7 5/6] tools/mm: make gup_bench a benchmark only tool
Date: Thu, 13 Aug 2026 23:42:29 +0530
Message-ID: <20260813181230.483746-6-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813181230.483746-1-sarthak.sharma@arm.com>
References: <20260813181230.483746-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2D7041A000D
X-Stat-Signature: 8yjbepdbyerjhzxteh8yhgzfqixp4coq
X-HE-Tag: 1786644843-904971
X-HE-Meta: U2FsdGVkX19cQ0Biwc57wXSWPw6NK9/8zEu+HpRVbBxxipq4P4IgOzYyXtBRKJCm5DuWdf+t+A9RZzAu3yttXgfGpeOFXGRETYFT1f/TOspi2gbrRLiQFNTYu9h76M6E/h6VQOTD++Hw6TMGPCFR83ceknkcr4kxAwKcigE82gxichV6neBeChADUBRZSf+QnGYjJXsLLBqgP8Yc+0pxPJO8lMhMvru62UGl1rBc4BQgLv17xAsF9naEfRx0foOhUEvrHCDqX3PJr3HN3OgsDfxzJaOs8YZm6LhjeA7vCVYknt7XLLtozjUEpWoLjcA+OhwVJH7+34n7DPv9JwaydgkZ6JzyBnwuk4In+UFY/Y3rufN+ZCXn5NcwxuZdRPB9NkFGCH9ukfPHBWrg+IRhr8cF6TtVpogCaVThhdIGZXANykVAl8u+DeLg6YThNus1vTb9+CmUtZjSXP6I19QLH9xnT1PzN7siwcNXWQ7KoCJNOQde/xq7ZG4+DShNjs/2gDDax7IS5ztJHYvarqZDobEJHbvaQ9yHWqbXaSY1d8BJDH7hSqC6Lzw+sgd5c2ZpaDGZs3HoMiINztMtc/W12Mi0zZh5Xs4r1jxaBFpJEYStjyzueFxEALjPz0D57OV0urgNH3+P9gfOul+qTsElb0V1xScalb/onpZb9qMnF468MCT0CCF6GWsM75liBVxFHzCfK8d+nDO9a0X+TwiXJmv3Uk398paj3HVpchOQoMVb4oAdKExeR4ZQODe897uf/CvtVUUSLXZjZp5h1zUSwmhU8ogcRV4OO1s67S3R1YUrzfGA03CubPY2jcw7ke0P1HlUkH20D9iPZM6WzZarzTw+hP2R2b913NfdOjXfYOwUXOMpAO1hdrILjYoFvuOkEKARKbgapSLrwOAzLTt/IJnXFLiW5kfqk5d4u2+0GIl9eCst/1C8wTjuGMWTJkYp7Xqyv3K5gdkkpob3IKO
 dS5wS2ZK
 zmQknwRKVmRSNG4jhVYfddhKWGTOT6SnnbldJvxQDbTZmcaqdqdQce7UszPugUPREoyOUomnJBWFsgmkOl9PMPJpM25QT7zPCfbPGxfeTda50dUSDi58beegIs39sHnybsLCcpGgQ/KkX6QNHq39AN3MaGa1sJHH+ffzE/ss3Yb2rA/yn4JIilarwAS2nu5GDC5zjFAqyGGQtlH+Aa89sb9fHpgLyssKoPBTNraUI/thC+n2da7JUqALN575qNefpMt90BfhzfZ6k3YNZy2smV/v0hoGvDrOUZbIjLVy4jaYhV4FhMmEtTx+rbMMpnmuGK3ty
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the functional modes (GUP_BASIC_TEST, PIN_BASIC_TEST and
DUMP_USER_PAGES_TEST) from gup_bench. Drop the kselftest dependency
and use normal diagnostics and exit statuses.

When no arguments are supplied, run a single GUP_FAST_BENCHMARK
with the existing default values. Let users select other
configurations through command-line options. Report ioctl failures
and handle errors without relying on assert().

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/mm/gup_bench.c | 187 +++++++++++++++++++------------------------
 1 file changed, 83 insertions(+), 104 deletions(-)

diff --git a/tools/mm/gup_bench.c b/tools/mm/gup_bench.c
index da56aa5324d3..75369b2674a9 100644
--- a/tools/mm/gup_bench.c
+++ b/tools/mm/gup_bench.c
@@ -10,10 +10,10 @@
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <pthread.h>
-#include <assert.h>
+#include <stdbool.h>
+#include <string.h>
 #include <mm/gup_test.h>
 #include <mm/hugepage_settings.h>
-#include "../testing/selftests/kselftest.h"
 
 #define MB (1UL << 20)
 
@@ -37,12 +37,6 @@ static char *cmd_to_str(unsigned long cmd)
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
@@ -52,39 +46,29 @@ void *gup_thread(void *data)
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
+			return data;
 		}
-	} else {
-		gup.size = size;
-		status = ioctl(gup_fd, cmd, &gup);
-		if (status)
-			goto return_;
 
 		pthread_mutex_lock(&print_mutex);
-		ksft_print_msg("%s: done\n", cmd_to_str(cmd));
+		printf("%s: Time: get:%lld put:%lld us",
+			cmd_to_str(cmd), gup.get_delta_usec,
+			gup.put_delta_usec);
 		if (gup.size != size)
-			ksft_print_msg("Truncated (size: %lld)\n", gup.size);
+			printf(", truncated (size: %lld)", gup.size);
+		printf("\n");
 		pthread_mutex_unlock(&print_mutex);
 	}
 
-return_:
-	ksft_test_result(!status, "ioctl status %d\n", status);
 	return NULL;
 }
 
@@ -92,38 +76,21 @@ int main(int argc, char **argv)
 {
 	struct gup_test gup = { 0 };
 	int filed, i, opt, nr_pages = 1, thp = -1, write = 1, nthreads = 1, ret;
-	int flags = MAP_PRIVATE;
+	int flags = MAP_PRIVATE, started_threads = 0;
 	char *file = "/dev/zero";
-	bool hugetlb = false;
+	bool hugetlb = false, thread_error = false;
+	void *thread_result;
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
 		case 'F':
 			/* strtol, so you can pass flags in hex form */
 			gup.gup_flags = strtol(optarg, 0, 0);
@@ -148,9 +115,6 @@ int main(int argc, char **argv)
 		case 'T':
 			thp = 0;
 			break;
-		case 'U':
-			cmd = GUP_BASIC_TEST;
-			break;
 		case 'u':
 			cmd = GUP_FAST_BENCHMARK;
 			break;
@@ -172,52 +136,41 @@ int main(int argc, char **argv)
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
+	if (getuid()) {
+		fprintf(stderr, "Please run this test as root\n");
+		exit(1);
+	}
 
 	if (hugetlb) {
 		unsigned long hp_size = default_huge_page_size();
 
-		if (!hp_size)
-			ksft_exit_skip("HugeTLB is unavailable\n");
+		if (!hp_size) {
+			fprintf(stderr, "Could not determine huge page size\n");
+			return 1;
+		}
 
 		size = (size + hp_size - 1) & ~(hp_size - 1);
-		if (!hugetlb_setup_default(size / hp_size))
-			ksft_exit_skip("Not enough huge pages\n");
+		if (!hugetlb_setup_default(size / hp_size)) {
+			fprintf(stderr, "Not enough huge pages\n");
+			return 1;
+		}
 	}
 
-	ksft_set_plan(nthreads);
-
 	filed = open(file, O_RDWR|O_CREAT, 0664);
-	if (filed < 0)
-		ksft_exit_fail_msg("Unable to open %s: %s\n", file, strerror(errno));
+	if (filed < 0) {
+		fprintf(stderr, "Unable to open %s: %s\n", file, strerror(errno));
+		return 1;
+	}
 
 	gup.nr_pages_per_call = nr_pages;
 	if (write)
@@ -226,26 +179,24 @@ int main(int argc, char **argv)
 	gup_fd = open(GUP_TEST_FILE, O_RDWR);
 	if (gup_fd == -1) {
 		switch (errno) {
-		case EACCES:
-			if (getuid())
-				ksft_print_msg("Please run this test as root\n");
-			break;
 		case ENOENT:
 			if (opendir("/sys/kernel/debug") == NULL)
-				ksft_print_msg("mount debugfs at /sys/kernel/debug\n");
-			ksft_print_msg("check if CONFIG_GUP_TEST is enabled in kernel config\n");
+				fprintf(stderr, "mount debugfs at /sys/kernel/debug\n");
+			fprintf(stderr, "check if CONFIG_GUP_TEST is enabled in kernel config\n");
 			break;
 		default:
-			ksft_print_msg("failed to open %s: %s\n", GUP_TEST_FILE, strerror(errno));
+			fprintf(stderr, "failed to open %s: %s\n", GUP_TEST_FILE,
+				strerror(errno));
 			break;
 		}
-		ksft_test_result_skip("Please run this test as root\n");
-		ksft_exit_pass();
+		goto err_close_filed;
 	}
 
 	p = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, filed, 0);
-	if (p == MAP_FAILED)
-		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
+	if (p == MAP_FAILED) {
+		fprintf(stderr, "mmap: %s\n", strerror(errno));
+		goto err_close_gup_fd;
+	}
 	gup.addr = (unsigned long)p;
 
 	if (thp == 1)
@@ -258,17 +209,45 @@ int main(int argc, char **argv)
 		p[0] = 0;
 
 	tid = malloc(sizeof(pthread_t) * nthreads);
-	assert(tid);
+	if (!tid) {
+		fprintf(stderr, "Failed to allocate %d threads: %s\n",
+			nthreads, strerror(errno));
+		goto err_unmap;
+	}
+
 	for (i = 0; i < nthreads; i++) {
 		ret = pthread_create(&tid[i], NULL, gup_thread, &gup);
-		assert(ret == 0);
+		if (ret) {
+			fprintf(stderr, "pthread_create failed: %s\n", strerror(ret));
+			thread_error = true;
+			break;
+		}
+		started_threads++;
 	}
-	for (i = 0; i < nthreads; i++) {
-		ret = pthread_join(tid[i], NULL);
-		assert(ret == 0);
+	for (i = 0; i < started_threads; i++) {
+		ret = pthread_join(tid[i], &thread_result);
+		if (ret) {
+			fprintf(stderr, "pthread_join failed: %s\n", strerror(ret));
+			thread_error = true;
+		} else if (thread_result)
+			thread_error = true;
 	}
 
 	free(tid);
 
-	ksft_exit_pass();
+	if (thread_error)
+		goto err_unmap;
+
+	munmap((void *)gup.addr, size);
+	close(gup_fd);
+	close(filed);
+	return 0;
+
+err_unmap:
+	munmap((void *)gup.addr, size);
+err_close_gup_fd:
+	close(gup_fd);
+err_close_filed:
+	close(filed);
+	return 1;
 }
-- 
2.39.5


