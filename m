Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BE5BC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 12:37:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 306746B009F; Fri,  4 Sep 2026 08:37:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AFAC6B00A0; Fri,  4 Sep 2026 08:37:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C5626B00A1; Fri,  4 Sep 2026 08:37:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EB0596B009F
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:37:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7EBEDA0F2B
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:37:28 +0000 (UTC)
X-FDA: 85176030576.12.704FA84
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id B192B8000E
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:37:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=B7GSZZ9q;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788525446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ca/4MgN8etS0AyWFHV5x/h/T7I5Njp6tQDRGY2co340=;
	b=OBduZgpHH7HF6A/j6ekY6RRd6zYfJMRw+bK1MaLBJoI+8S6+blgL8bDKCuYleo5gMX4G7k
	MZwxuzLyqB9Vmq12DMAhXMZmguEoRTYlMJdoMl7l4/P0hGfB+KdPMHI4P+OQ4aBOW+5TGD
	4y7PYJ6VZVxnjRYHBDBkOuIMjbwz1w0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788525446;
	b=2EgqfsVrF0ik2Cvvf3DWIz9b/DnLCmU2BQhIOkMvVgrzqqKCDcmKcUqppLb9BlALPMMr34
	k5XU1FDMel1voMxeW64uGj+Pz1zPv+Ep/4dcqYEKrGz6DU8FXx3WSk7N479KRxsZUr9qcz
	/+zKpPrLodHe2cWOoDFVZABIIUPSscg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=B7GSZZ9q;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F82B153B;
	Fri,  4 Sep 2026 05:37:22 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 453483F673;
	Fri,  4 Sep 2026 05:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788525445; bh=LTZSC3Z6+sHOREkDXV4hQKW2S4w0XZcM9Uk6dek1N6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B7GSZZ9qTmnA7ASvID2uEXQnmm6eKNHhYbR+RKImLnavilIs6xGJX4FU3Ittwck9s
	 ts/K/bueoX59d1+y5MUI1QC0Yz0iIcwDrxuwu0gC90dBasWxXe1nVYJ3JLGmbCAHrC
	 WSFqS3I2S2lB9NaVFaOYUjXRK+m8gNuffgXwhkwQ=
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
Subject: [PATCH v9 5/6] tools/mm: make gup_bench a benchmark only tool
Date: Fri,  4 Sep 2026 18:06:30 +0530
Message-ID: <20260904123631.198697-6-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260904123631.198697-1-sarthak.sharma@arm.com>
References: <20260904123631.198697-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B192B8000E
X-Stat-Signature: w4qytaq6nztpxmrtacfwhrzrd3t9oxcm
X-Rspam-User: 
X-HE-Tag: 1788525446-607097
X-HE-Meta: U2FsdGVkX19ZZzIJkoin6YkYHzdaueH6PGsI26DLEZk6ssgC6/GfwAbnV85offQMD02sbILZ3vTGxteUbXu/oYtSt9T4c+iR5S5sWcQZfojk0vH5p4jcz5/ROskIYdMOjbIfg7fb+QufNLYZLXfV5k1eGvorprtctWA/NrxYkwjSZmbgjfgatmlivVkyqqubTEJpXCY3IfPu7Gkri2HD9cF1PbdeDO8EBNhe0AQ9y05GJ7Ldj74DuDgt7iOxaJ1kb8YjufgOa+6fqWQ9c+m5NDX4FTueJ7P0DOQQ6u6EJrk0u82QIDWQ4DZilZtJKiBrAzWvTNVh2e8ILQjrxhM5/pXRTKf6ezVjFaTXlEuv+eWzLxQO96RoroJ5oYm9Cer4u36Jn3RnP4l6rgRH7yxExO4qn6bg5lRmXedY0rDXpFj22NG+J6s4qwJxnMKxpeYStyCfR0i/ilGdRld4u8/cfDEvinEi48OFeTF5UNMXU3KvApTv0yoRaEhpd7M8bK4yHAUWkQjAlRtp2TzVd3ScyYoa9aU+atMpgNuoHt0N8wDaBw6xDDWglMFJrKK8u8mj9AImIsn9qw/b1w+GzI8duLuwsHXizQtTUH3/QkvUbtAKWxYh6ZFtgY8tYRdnCqsIw/i889GoHQWgxhRl5rzQQEwHcB0WgXpP0SJQSdR4v0T+pqa85/61dv7C6XyXoeY/esY4lZEdAgMcpZWlFi/xPegXMVm2hc3f1GciIYEgqqujXIYZ2zO3xySkGCN8dhaFYV65xrZOLtMHPh7pMwD2f1YBHKEoPmtub5HnRTE5gXBvsSBQyIiW3uEmtq7r7OxrIHQVUPll5xsY0fd2lluiUdTYLl/4AAeVCokvBqBx6bxXXo+hrFBUPXqz1UC4iBc/Ib1rfvgiZlNEogtHYTLp3Ygs2A/SJlm9qaLRJjZW+Jbx/YhvI1BDxmD1436JOS/pVOWJXori8hAsHkongTS
 5IqDoanD
 xzM+szS1jlBzBdQvx9PkvQLvZRKl5zlvf49EKyyRyyD+cFtjFrf0PYAYCSA1i2ho8xM4Qgl2OeygJjFBnbJfAcx96FtfvN/PXl+szjOI2h0LBdQp2q89H0MbCvb9kD3DUyfHhOjUjICKQtl6W0N+TelqmuC9wZLjLG+2waXB8uHRbxLTTAzoA7RIHEtcc4fvj1vUck2BTOGYqsJOPX6N+G5ASX3pk2QgT2kcm1QrxwnhnjMcIMws+Xdh4/h2Mzgw/QKxjDjgmKuuof0/PLfEwE1qYC9LbiL9hGeKkcEAs1pywbArAKYCr0gieUoQB1fn0UPPT
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
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/mm/gup_bench.c | 184 +++++++++++++++++++------------------------
 1 file changed, 79 insertions(+), 105 deletions(-)

diff --git a/tools/mm/gup_bench.c b/tools/mm/gup_bench.c
index da56aa5324d3..e6a80ba5195a 100644
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
+	int flags = MAP_PRIVATE, started_threads = 0, exit_status = 1;
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
@@ -258,17 +209,40 @@ int main(int argc, char **argv)
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
-
-	ksft_exit_pass();
+	if (thread_error)
+		goto err_unmap;
+	exit_status = 0;
+
+err_unmap:
+	munmap((void *)gup.addr, size);
+err_close_gup_fd:
+	close(gup_fd);
+err_close_filed:
+	close(filed);
+	return exit_status;
 }
-- 
2.53.0


