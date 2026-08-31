Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 020FAC61DF0
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 04:22:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE9516B0098; Mon, 31 Aug 2026 00:22:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9A016B0099; Mon, 31 Aug 2026 00:22:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B62166B009B; Mon, 31 Aug 2026 00:22:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8CE716B0098
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:22:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07B23C03EA
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:22:03 +0000 (UTC)
X-FDA: 85160266926.26.997A0E6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 43F3A180005
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:22:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=u5a6JY8T;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788150121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ca/4MgN8etS0AyWFHV5x/h/T7I5Njp6tQDRGY2co340=;
	b=LzDIT8kmJuHCOF3NuvKf+X1D9t9mzR3+ZYQZL84QwENVNl0qNc1qB+s7Fb5I2Q07F5+Tt5
	2tY3lMhiMECPR261Oy1Xk7bLkdz5ZG0d2ywJI+30vGRBxF0QVFCz6bR/fZQxk28DF1AxaV
	JBWfkY+RPHCdmwnBfBMRWyjyXxmHiuM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=u5a6JY8T;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788150121;
	b=6TMdm3g5Fcy+38eNJUOnkB2LfzwWylwtpBNcpXHK3F5ho+LAmCg16E9KFhiplmCcv5iNOL
	+wmhxfMX1flGXB5Z+R5ZRtvphxc8aVWpJtSZ2iPmMwzJD1niKZN0jIjiAb1LjXXJYVTBCn
	Uy8FA5zk6jvEf/vfsNDGJ/DKgAS87Wo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A8F6A1762;
	Sun, 30 Aug 2026 21:21:56 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CA4093F8C6;
	Sun, 30 Aug 2026 21:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788150120; bh=LTZSC3Z6+sHOREkDXV4hQKW2S4w0XZcM9Uk6dek1N6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5a6JY8TM8J+VWJ1ccSTUiHgPxxy07Herfn+yFdVTHmSYxeVZ3ZwOsK7luJbCylXs
	 vAnySMzqbwVuHeA9p/rUiqOWrV1J3QW1nZ37F/wekrOQtEuCkdPXMzvPOaChAG1QGO
	 qm7utdqoXpa6K9pp94GdDdq1ihu3ymiOgu8pEjUY=
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
Subject: [PATCH v8 5/6] tools/mm: make gup_bench a benchmark only tool
Date: Mon, 31 Aug 2026 09:51:00 +0530
Message-ID: <20260831042101.18085-6-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831042101.18085-1-sarthak.sharma@arm.com>
References: <20260831042101.18085-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 43F3A180005
X-Stat-Signature: zhx8an3pfzmaj96drumsykdm9375xia3
X-Rspam-User: 
X-HE-Tag: 1788150121-962128
X-HE-Meta: U2FsdGVkX19Wl/Kc4RUlg/8rHCYfUkVIQwAzr8Qwtkg6L9ILFRIH1VLyUqnOdT/uh5YUxqUECZAzpn6Nsz/nHKfBZ7zf37/t+s0+wUAY4kyCU9VetaSvHuchRnKcZPaI2gNnmL4ydu1fdybQXGAzpXon0EITnRzdvNiKNf2HR1dNg+ihc4dpqZy+t4ti+6VSxvihy8gZymnGQXc+6bj9JSygd2CRQZH4ttgSqOxBdNu6Al11wPNzZV/+b8XumKqgzWUjRIfjqQUKdm63NHYH8td0MZNNinSOvVPwwWxD19O2XmA9+2T1M+K5JDieGqJJgZb7OoWD4P02D+hkQ2Z6ilUBG1iRQ01C96d4V6Z+ZZMbESp8Yer7yfudIxfSyr4wNfcMRql8kwoZFwXkozW3BdtUBepJbjCb+DdRp3yjLXy3ZSqkISmpU6rAb6j56WlMcrqbZaXqGfkv7P9KgRYwh6kuuDJ7dU9rRXxVZngDJjQy7rwLxxqusletsyXKRLdFiuLVkQBbzEEHYbZ/xVyd+ktoHVwpZ9uTR7BLgMNTY+7agqbHRlY462U/7hz7M8qZ2x84wzG3R22vIRYDI5i43KVlkQ7YgWuw5jPRVFzGO7Y8se8LzJNj/F7zCInWBGpFbRELqwy3s+S/R5VYLNnrNvWts/JSg7PSnp2+XqSfmSaWwnJeuoFVkVY9Bqzjf0r+j0kcHfPGJnldr8wY/GezM8kIyeSmW2HqyXbz96dEkbL4cSbW2U03kMWPHpXMdGIKwYJN0Dz5fg1zmCzCscBAKpyS6PeK9lR5hURcq4Ss6U44yl8khzJaCZm7VAfltGbYBFCLziT5WMMKbApfDhdTQPevftqFL9MlgxCQaZ+09M6GBzPMz0kiNPoSUrBBXUkxlq/coKUcgS6/psw+b9k6ZSxvQVpCY+BgFiH+WjnCqCw4D5OsNfKTiZiYcjJfI3Gar9YTtj8k+rKgtgzfBf9
 LnXpP67a
 zkPWgA+UhYXmf8Zu14MFbruY+uguisK0UGrNjMiHUv7wGwgprxh7emB1l2tOEUF8E5QcX4znJuODxpnnrTRwphBg/49jBltpomv1PsTaxY4Oy/fEE0sj+4jbrk3iLH23/HRhKugLX21WWyBdWjEPUkF5/23LkNCC+c6ZDNk2lGW7Gr607avCJCh0wjR5BTyAEwvu/rZJjTbRjBQZvHo7x3unOxnvMzkCHVSHe2PPI2Ob6yMYw+cOTOAhPrae11buz6CnoCLQVv+/A3F9r5JmM6ozSIikh0ONzG2zC4QYuAlWMxpveb8ZcTT5LJA7ys9IDVqjn
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


