Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D500F99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 918506B0248; Sat, 18 Apr 2026 06:57:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A2036B024A; Sat, 18 Apr 2026 06:57:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 769EA6B024B; Sat, 18 Apr 2026 06:57:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5EA5F6B0248
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:57:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 248AC1404AE
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:57:11 +0000 (UTC)
X-FDA: 84671374662.28.14DDB87
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7ED3AA0004
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:57:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jEwkpIT5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f8kj2WheYaNOYm0scklSzoH9SgmoU6GRb69+k0vZcPs=;
	b=jA5c2C2uNCL6r7sGnXqDWeXfSWryVTTGtI5RDjuqvYh8/1PF2aWvw/aOTJUP7mzqrl+s7h
	inlqbnCtmQDRcmznT6WUc8n0f2Caf75V3fAbBuIwnm+kjhVneeRhAbKqOatF4CbL/Yl/Mw
	D06PbcNbf2xwI7BJsYGjJjW5Uw4uNVc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jEwkpIT5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509829; a=rsa-sha256;
	cv=none;
	b=quS/DGcI8Qy8LvtJwP4kcJ/OyQS2mwjj+gUCzagTEo5TZbQT/3HPTYfGoi38SAUzLtHUHu
	8hKG/ZTJSFg1Mm4wq5dCz9Se0uG3rrrgAPhFNpncwQ0Slt/j3leWz+5AW/E3yCtt7LRDyR
	62j2yPw7K5efVbj6GJz7eI1/cnwZ0kY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CF7D260138;
	Sat, 18 Apr 2026 10:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB666C2BCB3;
	Sat, 18 Apr 2026 10:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509828;
	bh=HbTWbA3dw9lID/2V/r3cdCW0uqUWmhWp7xxfoo5Zqmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jEwkpIT5Yh7LQ+HSC/mleM1f5e68yi8AyBSPYaIeAbUIl7+ZVHIzDkLJzEHAqedA8
	 rPG5VDHepo+FhKrRM5Yg+0gb68MlxUQzVyhiF51QISOa8viPhYtIGdW571Iwvosotx
	 JKyey8qTGkUrHzMyaSwG+dT7ggfzULnp/exSuzPb9BaI5hjPE3rYksszHRNx2lmDTs
	 8FrCKtxW0/UGnWHYhbkzlbqlgtQrLHWtqi9dQNj8M4wtGvimub9VVzVg82FiRf8iPF
	 KReGhWKaAhYX6ru/6oqo64piverFjEiQs/OjwEPijM4+NGplwwXyijoyJNl15y3rfI
	 pD283keSn9UaQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 13/53] selftests/mm: khugepaged: use ksefltest framework
Date: Sat, 18 Apr 2026 13:54:58 +0300
Message-ID: <20260418105539.1261536-14-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7ED3AA0004
X-Stat-Signature: pksmdnrpg1unwu5mdtgfpxmu6no1im9q
X-HE-Tag: 1776509829-615157
X-HE-Meta: U2FsdGVkX1+vMXdvf3eREp2p5RmNQLD5yamcvYkclPrXesuWDiKwrbpweu7qAGzNXRqAyPq3SvgdA9XMhLmEb2Ydjbiyo9aulbX6DUc1gohMFoH6J0Y4ICePTRycJEWeJAo1qdf7Eanj65onDftFX19j/JUTNs+XdIotLgz/8Sv/nguOr0Sg38vtZq39tWCsesifCks/ENjLNrGgreoVL4jjcHXAwM5wPpUSoOnWIeDvA5lA+NKX7aOBYQWOX50592tNXcKLyAla70W6p3ZEz53KjiwO6tXjwwpUb8C1NJb3sAWM6tGlaWmguBBjmBfkjE0qzkfK1lkEBhpd/qiuE8O0cHCly+iCnsLBVzAiXQCy4FaMsSn452Ubp4E8Zvn87rVg3r/wu4cSrqaYyjFQ9clMPjWPnFR2OiVTT4FFUd0AgYWYhSAG39Iq67MbQVAeHAcAJWknxYZ0RgfLxyGSwygj0DLuierllJYJKCdCVC8dXxYiU0pgS7AlrPpwTV/riOBe22YLhQ+MaNM8wxoZE0XprOzsz2L+MoIHkLqGHXgv4VV4l/qusz0Ayu+pcioeqCCtsy4Ilkii7jkb35zL2bNeHHqQmsAF8VdeYde0AINERM0lV6E2kaCsBk9KqAWn2DatzMhEA1LBTrCMV6WgOcugxL0QWkudc093PUAbXbxr0fmBpaNIIj/e9oNzIPh3wjHGW+1D125MuzX/44FO+7f/BDZV5PNuR1vcs4E7KJ1QSxSjs2671R0Q1G9xxkMBS6y4m8pvBWzAjpB+wxfPQDWSEPyQ47YUuBZT76jIqe2Vi132a2zRgqJPPlwh9GYZroP80b8FyPclL29AcHNqDNhIfVbCZgnlp5GJd31fWfdqSw/VpeoPegXFwMZhHoqEX6LNYGqiQwyULDPa59zuioeEZCI3YYMw1WhRSRhsi8t4YmSzTWtiUPChzEFQR/M0omzd30LdOlA5pWes7Fp
 0QxCP8UH
 Ww4HvkiiLjSodx3POK8gP3/njAuuEqqNtRN44LLzHEtz1nh3rSlEW9Q25qzSAcPARcZfys+jHher29P3GVAyHLlL/j8cUs8faRT/pmotC/fC297SrZ10GC8DfDzJMR0JGjE3eWj/mePzmCS1rH2o6iV9VVwu3RmQs0Vk8t0LKAl7i/P+jwiHA7qLQ88IXbFExudHNDMmYNipx1Dje0h/IOb70AHlLWlatG+EVzVxHqsAsqJo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert khugepaged tests to use kselftest framework for reporting and
tracking successful and failing runs.

The conversion is mostly about replacing printf()/perror() + exit() pairs
with their ksft_ counterparts.

The nice colored success and failure indications are left intact.

Replace the progress report in collapse_compound_extreme() with a single
ksft_print_msg() to avoid headache with formatting and make the test output
more concise.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 311 ++++++++++--------------
 1 file changed, 128 insertions(+), 183 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 56494eea5ab3..da365f850365 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -83,12 +83,13 @@ static void success(const char *msg)
 static void fail(const char *msg)
 {
 	printf(" \e[31m%s\e[0m\n", msg);
-	exit_status++;
+	exit_status = KSFT_FAIL;
 }
 
 static void skip(const char *msg)
 {
 	printf(" \e[33m%s\e[0m\n", msg);
+	exit_status = KSFT_SKIP;
 }
 
 static void restore_settings_atexit(void)
@@ -96,22 +97,23 @@ static void restore_settings_atexit(void)
 	if (skip_settings_restore)
 		return;
 
-	printf("Restore THP and khugepaged settings...");
+	ksft_print_msg("Restore THP and khugepaged settings...");
 	thp_restore_settings();
 	success("OK");
 
 	skip_settings_restore = true;
+	ksft_finished();
 }
 
 static void restore_settings(int sig)
 {
 	/* exit() will invoke the restore_settings_atexit handler. */
-	exit(sig ? EXIT_FAILURE : exit_status);
+	exit(sig ? KSFT_FAIL : exit_status);
 }
 
 static void save_settings(void)
 {
-	printf("Save THP and khugepaged settings...");
+	ksft_print_msg("Save THP and khugepaged settings...");
 	if (file_ops && finfo.type == VMA_FILE)
 		thp_set_read_ahead_path(finfo.dev_queue_read_ahead_path);
 	thp_save_settings();
@@ -135,19 +137,13 @@ static void get_finfo(const char *dir)
 
 	finfo.dir = dir;
 	stat(finfo.dir, &path_stat);
-	if (!S_ISDIR(path_stat.st_mode)) {
-		printf("%s: Not a directory (%s)\n", __func__, finfo.dir);
-		exit(EXIT_FAILURE);
-	}
+	if (!S_ISDIR(path_stat.st_mode))
+		ksft_exit_fail_msg("%s: Not a directory (%s)\n", __func__, finfo.dir);
 	if (snprintf(finfo.path, sizeof(finfo.path), "%s/" TEST_FILE,
-		     finfo.dir) >= sizeof(finfo.path)) {
-		printf("%s: Pathname is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
-	if (statfs(finfo.dir, &fs)) {
-		perror("statfs()");
-		exit(EXIT_FAILURE);
-	}
+		     finfo.dir) >= sizeof(finfo.path))
+		ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
+	if (statfs(finfo.dir, &fs))
+		ksft_exit_fail_perror("statfs()");
 	finfo.type = fs.f_type == TMPFS_MAGIC ? VMA_SHMEM : VMA_FILE;
 	if (finfo.type == VMA_SHMEM)
 		return;
@@ -155,40 +151,30 @@ static void get_finfo(const char *dir)
 	/* Find owning device's queue/read_ahead_kb control */
 	if (snprintf(path, sizeof(path), "/sys/dev/block/%d:%d/uevent",
 		     major(path_stat.st_dev), minor(path_stat.st_dev))
-	    >= sizeof(path)) {
-		printf("%s: Pathname is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
-	if (read_file(path, buf, sizeof(buf)) < 0) {
-		perror("read_file(read_num)");
-		exit(EXIT_FAILURE);
-	}
+	    >= sizeof(path))
+		ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
+	if (read_file(path, buf, sizeof(buf)) < 0)
+		ksft_exit_fail_perror("read_file(read_num)");
 	if (strstr(buf, "DEVTYPE=disk")) {
 		/* Found it */
 		if (snprintf(finfo.dev_queue_read_ahead_path,
 			     sizeof(finfo.dev_queue_read_ahead_path),
 			     "/sys/dev/block/%d:%d/queue/read_ahead_kb",
 			     major(path_stat.st_dev), minor(path_stat.st_dev))
-		    >= sizeof(finfo.dev_queue_read_ahead_path)) {
-			printf("%s: Pathname is too long\n", __func__);
-			exit(EXIT_FAILURE);
-		}
+		    >= sizeof(finfo.dev_queue_read_ahead_path))
+			ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
 		return;
 	}
-	if (!strstr(buf, "DEVTYPE=partition")) {
-		printf("%s: Unknown device type: %s\n", __func__, path);
-		exit(EXIT_FAILURE);
-	}
+	if (!strstr(buf, "DEVTYPE=partition"))
+		ksft_exit_fail_msg("%s: Unknown device type: %s\n", __func__, path);
 	/*
 	 * Partition of block device - need to find actual device.
 	 * Using naming convention that devnameN is partition of
 	 * device devname.
 	 */
 	str = strstr(buf, "DEVNAME=");
-	if (!str) {
-		printf("%s: Could not read: %s", __func__, path);
-		exit(EXIT_FAILURE);
-	}
+	if (!str)
+		ksft_exit_fail_msg("%s: Could not read: %s", __func__, path);
 	str += 8;
 	end = str;
 	while (*end) {
@@ -197,16 +183,13 @@ static void get_finfo(const char *dir)
 			if (snprintf(finfo.dev_queue_read_ahead_path,
 				     sizeof(finfo.dev_queue_read_ahead_path),
 				     "/sys/block/%s/queue/read_ahead_kb",
-				     str) >= sizeof(finfo.dev_queue_read_ahead_path)) {
-				printf("%s: Pathname is too long\n", __func__);
-				exit(EXIT_FAILURE);
-			}
+				     str) >= sizeof(finfo.dev_queue_read_ahead_path))
+				ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
 			return;
 		}
 		++end;
 	}
-	printf("%s: Could not read: %s\n", __func__, path);
-	exit(EXIT_FAILURE);
+	ksft_exit_fail_msg("%s: Could not read: %s\n", __func__, path);
 }
 
 static bool check_swap(void *addr, unsigned long size)
@@ -219,26 +202,19 @@ static bool check_swap(void *addr, unsigned long size)
 
 	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "%08lx-",
 		       (unsigned long) addr);
-	if (ret >= MAX_LINE_LENGTH) {
-		printf("%s: Pattern is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
-
+	if (ret >= MAX_LINE_LENGTH)
+		ksft_exit_fail_msg("%s: Pattern is too long\n", __func__);
 
 	fp = fopen(PID_SMAPS, "r");
-	if (!fp) {
-		printf("%s: Failed to open file %s\n", __func__, PID_SMAPS);
-		exit(EXIT_FAILURE);
-	}
+	if (!fp)
+		ksft_exit_fail_msg("%s: Failed to open file %s\n", __func__, PID_SMAPS);
 	if (!check_for_pattern(fp, addr_pattern, buffer, sizeof(buffer)))
 		goto err_out;
 
 	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "Swap:%19ld kB",
 		       size >> 10);
-	if (ret >= MAX_LINE_LENGTH) {
-		printf("%s: Pattern is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
+	if (ret >= MAX_LINE_LENGTH)
+		ksft_exit_fail_msg("%s: Pattern is too long\n", __func__);
 	/*
 	 * Fetch the Swap: in the same block and check whether it got
 	 * the expected number of hugeepages next.
@@ -261,10 +237,8 @@ static void *alloc_mapping(int nr)
 
 	p = mmap(BASE_ADDR, nr * hpage_pmd_size, PROT_READ | PROT_WRITE,
 		 MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
-	if (p != BASE_ADDR) {
-		printf("Failed to allocate VMA at %p\n", BASE_ADDR);
-		exit(EXIT_FAILURE);
-	}
+	if (p != BASE_ADDR)
+		ksft_exit_fail_msg("Failed to allocate VMA at %p\n", BASE_ADDR);
 
 	return p;
 }
@@ -314,19 +288,13 @@ static void *alloc_hpage(struct mem_ops *ops)
 	 * khugepaged on low-load system (like a test machine), which
 	 * would cause MADV_COLLAPSE to fail with EAGAIN.
 	 */
-	printf("Allocate huge page...");
-	if (madvise_collapse_retry(p, hpage_pmd_size)) {
-		perror("madvise(MADV_COLLAPSE)");
-		exit(EXIT_FAILURE);
-	}
-	if (!ops->check_huge(p, 1)) {
-		perror("madvise(MADV_COLLAPSE)");
-		exit(EXIT_FAILURE);
-	}
-	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE)) {
-		perror("madvise(MADV_HUGEPAGE)");
-		exit(EXIT_FAILURE);
-	}
+	ksft_print_msg("Allocate huge page...");
+	if (madvise_collapse_retry(p, hpage_pmd_size))
+		ksft_exit_fail_perror("madvise(MADV_COLLAPSE)");
+	if (!ops->check_huge(p, 1))
+		ksft_exit_fail_perror("madvise(MADV_COLLAPSE)");
+	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
+		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
 	success("OK");
 	return p;
 }
@@ -336,11 +304,9 @@ static void validate_memory(int *p, unsigned long start, unsigned long end)
 	int i;
 
 	for (i = start / page_size; i < end / page_size; i++) {
-		if (p[i * page_size / sizeof(*p)] != i + 0xdead0000) {
-			printf("Page %d is corrupted: %#x\n",
-					i, p[i * page_size / sizeof(*p)]);
-			exit(EXIT_FAILURE);
-		}
+		if (p[i * page_size / sizeof(*p)] != i + 0xdead0000)
+			ksft_exit_fail_msg("Page %d is corrupted: %#x\n",
+					   i, p[i * page_size / sizeof(*p)]);
 	}
 }
 
@@ -371,14 +337,12 @@ static void *file_setup_area(int nr_hpages)
 	unsigned long size;
 
 	unlink(finfo.path);  /* Cleanup from previous failed tests */
-	printf("Creating %s for collapse%s...", finfo.path,
-	       finfo.type == VMA_SHMEM ? " (tmpfs)" : "");
+	ksft_print_msg("Creating %s for collapse%s...", finfo.path,
+		       finfo.type == VMA_SHMEM ? " (tmpfs)" : "");
 	fd = open(finfo.path, O_DSYNC | O_CREAT | O_RDWR | O_TRUNC | O_EXCL,
 		  777);
-	if (fd < 0) {
-		perror("open()");
-		exit(EXIT_FAILURE);
-	}
+	if (fd < 0)
+		ksft_exit_fail_perror("open()");
 
 	size = nr_hpages * hpage_pmd_size;
 	p = alloc_mapping(nr_hpages);
@@ -388,18 +352,14 @@ static void *file_setup_area(int nr_hpages)
 	munmap(p, size);
 	success("OK");
 
-	printf("Opening %s read only for collapse...", finfo.path);
+	ksft_print_msg("Opening %s read only for collapse...", finfo.path);
 	finfo.fd = open(finfo.path, O_RDONLY, 777);
-	if (finfo.fd < 0) {
-		perror("open()");
-		exit(EXIT_FAILURE);
-	}
+	if (finfo.fd < 0)
+		ksft_exit_fail_perror("open()");
 	p = mmap(BASE_ADDR, size, PROT_READ,
 		 MAP_PRIVATE, finfo.fd, 0);
-	if (p == MAP_FAILED || p != BASE_ADDR) {
-		perror("mmap()");
-		exit(EXIT_FAILURE);
-	}
+	if (p == MAP_FAILED || p != BASE_ADDR)
+		ksft_exit_fail_perror("mmap()");
 
 	/* Drop page cache */
 	write_file("/proc/sys/vm/drop_caches", "3", 2);
@@ -416,10 +376,8 @@ static void file_cleanup_area(void *p, unsigned long size)
 
 static void file_fault(void *p, unsigned long start, unsigned long end)
 {
-	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_READ)) {
-		perror("madvise(MADV_POPULATE_READ");
-		exit(EXIT_FAILURE);
-	}
+	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_READ))
+		ksft_exit_fail_perror("madvise(MADV_POPULATE_READ");
 }
 
 static bool file_check_huge(void *addr, int nr_hpages)
@@ -441,20 +399,14 @@ static void *shmem_setup_area(int nr_hpages)
 	unsigned long size = nr_hpages * hpage_pmd_size;
 
 	finfo.fd = memfd_create("khugepaged-selftest-collapse-shmem", 0);
-	if (finfo.fd < 0)  {
-		perror("memfd_create()");
-		exit(EXIT_FAILURE);
-	}
-	if (ftruncate(finfo.fd, size)) {
-		perror("ftruncate()");
-		exit(EXIT_FAILURE);
-	}
+	if (finfo.fd < 0)
+		ksft_exit_fail_perror("memfd_create()");
+	if (ftruncate(finfo.fd, size))
+		ksft_exit_fail_perror("ftruncate()");
 	p = mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE, MAP_SHARED, finfo.fd,
 		 0);
-	if (p != BASE_ADDR) {
-		perror("mmap()");
-		exit(EXIT_FAILURE);
-	}
+	if (p != BASE_ADDR)
+		ksft_exit_fail_perror("mmap()");
 	return p;
 }
 
@@ -499,7 +451,7 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
 	int ret;
 	struct thp_settings settings = *thp_current_settings();
 
-	printf("%s...", msg);
+	ksft_print_msg("%s...", msg);
 
 	/*
 	 * Prevent khugepaged interference and tests that MADV_COLLAPSE
@@ -526,10 +478,8 @@ static void madvise_collapse(const char *msg, char *p, int nr_hpages,
 			     struct mem_ops *ops, bool expect)
 {
 	/* Sanity check */
-	if (!ops->check_huge(p, 0)) {
-		printf("Unexpected huge page\n");
-		exit(EXIT_FAILURE);
-	}
+	if (!ops->check_huge(p, 0))
+		ksft_exit_fail_msg("Unexpected huge page\n");
 	__madvise_collapse(msg, p, nr_hpages, ops, expect);
 }
 
@@ -541,17 +491,15 @@ static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
 	int timeout = 6; /* 3 seconds */
 
 	/* Sanity check */
-	if (!ops->check_huge(p, 0)) {
-		printf("Unexpected huge page\n");
-		exit(EXIT_FAILURE);
-	}
+	if (!ops->check_huge(p, 0))
+		ksft_exit_fail_msg("Unexpected huge page\n");
 
 	madvise(p, nr_hpages * hpage_pmd_size, MADV_HUGEPAGE);
 
 	/* Wait until the second full_scan completed */
 	full_scans = thp_read_num("khugepaged/full_scans") + 2;
 
-	printf("%s...", msg);
+	ksft_print_msg("%s...", msg);
 	while (timeout--) {
 		if (ops->check_huge(p, nr_hpages))
 			break;
@@ -621,7 +569,7 @@ static void alloc_at_fault(void)
 
 	p = alloc_mapping(1);
 	*p = 1;
-	printf("Allocate huge page on fault...");
+	ksft_print_msg("Allocate huge page on fault...");
 	if (check_huge_anon(p, 1, hpage_pmd_size))
 		success("OK");
 	else
@@ -630,12 +578,14 @@ static void alloc_at_fault(void)
 	thp_pop_settings();
 
 	madvise(p, page_size, MADV_DONTNEED);
-	printf("Split huge PMD on MADV_DONTNEED...");
+	ksft_print_msg("Split huge PMD on MADV_DONTNEED...");
 	if (check_huge_anon(p, 0, hpage_pmd_size))
 		success("OK");
 	else
 		fail("Fail");
 	munmap(p, hpage_pmd_size);
+
+	ksft_test_result_report(exit_status, "allocate on fault and split\n");
 }
 
 static void collapse_full(struct collapse_context *c, struct mem_ops *ops)
@@ -650,6 +600,8 @@ static void collapse_full(struct collapse_context *c, struct mem_ops *ops)
 		    ops, true);
 	validate_memory(p, 0, size);
 	ops->cleanup_area(p, size);
+
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_empty(struct collapse_context *c, struct mem_ops *ops)
@@ -659,6 +611,7 @@ static void collapse_empty(struct collapse_context *c, struct mem_ops *ops)
 	p = ops->setup_area(1);
 	c->collapse("Do not collapse empty PTE table", p, 1, ops, false);
 	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_single_pte_entry(struct collapse_context *c, struct mem_ops *ops)
@@ -670,6 +623,7 @@ static void collapse_single_pte_entry(struct collapse_context *c, struct mem_ops
 	c->collapse("Collapse PTE table with single PTE entry present", p,
 		    1, ops, true);
 	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_max_ptes_none(struct collapse_context *c, struct mem_ops *ops)
@@ -706,6 +660,7 @@ static void collapse_max_ptes_none(struct collapse_context *c, struct mem_ops *o
 skip:
 	ops->cleanup_area(p, hpage_pmd_size);
 	thp_pop_settings();
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_ops *ops)
@@ -715,11 +670,9 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
 	p = ops->setup_area(1);
 	ops->fault(p, 0, hpage_pmd_size);
 
-	printf("Swapout one page...");
-	if (madvise(p, page_size, MADV_PAGEOUT)) {
-		perror("madvise(MADV_PAGEOUT)");
-		exit(EXIT_FAILURE);
-	}
+	ksft_print_msg("Swapout one page...");
+	if (madvise(p, page_size, MADV_PAGEOUT))
+		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
 	if (check_swap(p, page_size)) {
 		success("OK");
 	} else {
@@ -732,6 +685,7 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
 	validate_memory(p, 0, hpage_pmd_size);
 out:
 	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *ops)
@@ -742,11 +696,9 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
 	p = ops->setup_area(1);
 	ops->fault(p, 0, hpage_pmd_size);
 
-	printf("Swapout %d of %d pages...", max_ptes_swap + 1, hpage_pmd_nr);
-	if (madvise(p, (max_ptes_swap + 1) * page_size, MADV_PAGEOUT)) {
-		perror("madvise(MADV_PAGEOUT)");
-		exit(EXIT_FAILURE);
-	}
+	ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap + 1, hpage_pmd_nr);
+	if (madvise(p, (max_ptes_swap + 1) * page_size, MADV_PAGEOUT))
+		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
 	if (check_swap(p, (max_ptes_swap + 1) * page_size)) {
 		success("OK");
 	} else {
@@ -760,12 +712,10 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
 
 	if (c->enforce_pte_scan_limits) {
 		ops->fault(p, 0, hpage_pmd_size);
-		printf("Swapout %d of %d pages...", max_ptes_swap,
+		ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap,
 		       hpage_pmd_nr);
-		if (madvise(p, max_ptes_swap * page_size, MADV_PAGEOUT)) {
-			perror("madvise(MADV_PAGEOUT)");
-			exit(EXIT_FAILURE);
-		}
+		if (madvise(p, max_ptes_swap * page_size, MADV_PAGEOUT))
+			ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
 		if (check_swap(p, max_ptes_swap * page_size)) {
 			success("OK");
 		} else {
@@ -779,6 +729,7 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
 	}
 out:
 	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_single_pte_entry_compound(struct collapse_context *c, struct mem_ops *ops)
@@ -792,7 +743,7 @@ static void collapse_single_pte_entry_compound(struct collapse_context *c, struc
 		advise = MADV_REMOVE;
 
 	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
-	printf("Split huge page leaving single PTE mapping compound page...");
+	ksft_print_msg("Split huge page leaving single PTE mapping compound page...");
 	madvise(p + page_size, hpage_pmd_size - page_size, advise);
 	if (ops->check_huge(p, 0))
 		success("OK");
@@ -803,6 +754,7 @@ static void collapse_single_pte_entry_compound(struct collapse_context *c, struc
 		    p, 1, ops, true);
 	validate_memory(p, 0, page_size);
 	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_full_of_compound(struct collapse_context *c, struct mem_ops *ops)
@@ -810,7 +762,7 @@ static void collapse_full_of_compound(struct collapse_context *c, struct mem_ops
 	void *p;
 
 	p = alloc_hpage(ops);
-	printf("Split huge page leaving single PTE page table full of compound pages...");
+	ksft_print_msg("Split huge page leaving single PTE page table full of compound pages...");
 	madvise(p, page_size, MADV_NOHUGEPAGE);
 	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
 	if (ops->check_huge(p, 0))
@@ -822,6 +774,7 @@ static void collapse_full_of_compound(struct collapse_context *c, struct mem_ops
 		    true);
 	validate_memory(p, 0, hpage_pmd_size);
 	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops *ops)
@@ -830,16 +783,12 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
 	int i;
 
 	p = ops->setup_area(1);
+	ksft_print_msg("Construct PTE page table full of different PTE-mapped compound pagesd\n");
 	for (i = 0; i < hpage_pmd_nr; i++) {
-		printf("\rConstruct PTE page table full of different PTE-mapped compound pages %3d/%d...",
-				i + 1, hpage_pmd_nr);
-
 		madvise(BASE_ADDR, hpage_pmd_size, MADV_HUGEPAGE);
 		ops->fault(BASE_ADDR, 0, hpage_pmd_size);
-		if (!ops->check_huge(BASE_ADDR, 1)) {
-			printf("Failed to allocate huge page\n");
-			exit(EXIT_FAILURE);
-		}
+		if (!ops->check_huge(BASE_ADDR, 1))
+			ksft_exit_fail_msg("Failed to allocate huge page\n");
 		madvise(BASE_ADDR, hpage_pmd_size, MADV_NOHUGEPAGE);
 
 		p = mremap(BASE_ADDR - i * page_size,
@@ -847,20 +796,16 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
 				(i + 1) * page_size,
 				MREMAP_MAYMOVE | MREMAP_FIXED,
 				BASE_ADDR + 2 * hpage_pmd_size);
-		if (p == MAP_FAILED) {
-			perror("mremap+unmap");
-			exit(EXIT_FAILURE);
-		}
+		if (p == MAP_FAILED)
+			ksft_exit_fail_perror("mremap+unmap");
 
 		p = mremap(BASE_ADDR + 2 * hpage_pmd_size,
 				(i + 1) * page_size,
 				(i + 1) * page_size + hpage_pmd_size,
 				MREMAP_MAYMOVE | MREMAP_FIXED,
 				BASE_ADDR - (i + 1) * page_size);
-		if (p == MAP_FAILED) {
-			perror("mremap+alloc");
-			exit(EXIT_FAILURE);
-		}
+		if (p == MAP_FAILED)
+			ksft_exit_fail_perror("mremap+alloc");
 	}
 
 	ops->cleanup_area(BASE_ADDR, hpage_pmd_size);
@@ -875,6 +820,7 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
 
 	validate_memory(p, 0, hpage_pmd_size);
 	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
@@ -884,18 +830,17 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 
 	p = ops->setup_area(1);
 
-	printf("Allocate small page...");
+	ksft_print_msg("Allocate small page...");
 	ops->fault(p, 0, page_size);
 	if (ops->check_huge(p, 0))
 		success("OK");
 	else
 		fail("Fail");
 
-	printf("Share small page over fork()...");
+	ksft_print_msg("Share small page over fork()...");
 	if (!fork()) {
 		/* Do not touch settings on child exit */
 		skip_settings_restore = true;
-		exit_status = 0;
 
 		if (ops->check_huge(p, 0))
 			success("OK");
@@ -912,15 +857,16 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 	}
 
 	wait(&wstatus);
-	exit_status += WEXITSTATUS(wstatus);
+	exit_status = WEXITSTATUS(wstatus);
 
-	printf("Check if parent still has small page...");
+	ksft_print_msg("Check if parent still has small page...");
 	if (ops->check_huge(p, 0))
 		success("OK");
 	else
 		fail("Fail");
 	validate_memory(p, 0, page_size);
 	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *ops)
@@ -929,18 +875,17 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
 	void *p;
 
 	p = alloc_hpage(ops);
-	printf("Share huge page over fork()...");
+	ksft_print_msg("Share huge page over fork()...");
 	if (!fork()) {
 		/* Do not touch settings on child exit */
 		skip_settings_restore = true;
-		exit_status = 0;
 
 		if (ops->check_huge(p, 1))
 			success("OK");
 		else
 			fail("Fail");
 
-		printf("Split huge page PMD in child process...");
+		ksft_print_msg("Split huge page PMD in child process...");
 		madvise(p, page_size, MADV_NOHUGEPAGE);
 		madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
 		if (ops->check_huge(p, 0))
@@ -961,15 +906,16 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
 	}
 
 	wait(&wstatus);
-	exit_status += WEXITSTATUS(wstatus);
+	exit_status = WEXITSTATUS(wstatus);
 
-	printf("Check if parent still has huge page...");
+	ksft_print_msg("Check if parent still has huge page...");
 	if (ops->check_huge(p, 1))
 		success("OK");
 	else
 		fail("Fail");
 	validate_memory(p, 0, hpage_pmd_size);
 	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops *ops)
@@ -979,18 +925,17 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 	void *p;
 
 	p = alloc_hpage(ops);
-	printf("Share huge page over fork()...");
+	ksft_print_msg("Share huge page over fork()...");
 	if (!fork()) {
 		/* Do not touch settings on child exit */
 		skip_settings_restore = true;
-		exit_status = 0;
 
 		if (ops->check_huge(p, 1))
 			success("OK");
 		else
 			fail("Fail");
 
-		printf("Trigger CoW on page %d of %d...",
+		ksft_print_msg("Trigger CoW on page %d of %d...",
 				hpage_pmd_nr - max_ptes_shared - 1, hpage_pmd_nr);
 		ops->fault(p, 0, (hpage_pmd_nr - max_ptes_shared - 1) * page_size);
 		if (ops->check_huge(p, 0))
@@ -1002,7 +947,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 			    1, ops, !c->enforce_pte_scan_limits);
 
 		if (c->enforce_pte_scan_limits) {
-			printf("Trigger CoW on page %d of %d...",
+			ksft_print_msg("Trigger CoW on page %d of %d...",
 			       hpage_pmd_nr - max_ptes_shared, hpage_pmd_nr);
 			ops->fault(p, 0, (hpage_pmd_nr - max_ptes_shared) *
 				    page_size);
@@ -1021,15 +966,16 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 	}
 
 	wait(&wstatus);
-	exit_status += WEXITSTATUS(wstatus);
+	exit_status = WEXITSTATUS(wstatus);
 
-	printf("Check if parent still has huge page...");
+	ksft_print_msg("Check if parent still has huge page...");
 	if (ops->check_huge(p, 1))
 		success("OK");
 	else
 		fail("Fail");
 	validate_memory(p, 0, hpage_pmd_size);
 	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void madvise_collapse_existing_thps(struct collapse_context *c,
@@ -1046,6 +992,7 @@ static void madvise_collapse_existing_thps(struct collapse_context *c,
 	__madvise_collapse("Re-collapse PMD-mapped hugepage", p, 1, ops, true);
 	validate_memory(p, 0, hpage_pmd_size);
 	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 /*
@@ -1073,6 +1020,7 @@ static void madvise_retracted_page_tables(struct collapse_context *c,
 		    true);
 	validate_memory(p, 0, size);
 	ops->cleanup_area(p, size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void usage(void)
@@ -1176,10 +1124,8 @@ static int nr_test_cases;
 
 #define TEST(t, c, o) do {						\
 	if (c && o) {							\
-		if (nr_test_cases >= MAX_TEST_CASES) {			\
-			printf("MAX_ADD_CASES is too small\n");		\
-			exit(EXIT_FAILURE);				\
-		}							\
+		if (nr_test_cases >= MAX_TEST_CASES)			\
+			ksft_exit_fail_msg("MAX_ADD_CASES is too small\n"); \
 		test_cases[nr_test_cases++] = (struct test_case){	\
 			.ctx	= c,					\
 			.ops	= o,					\
@@ -1212,10 +1158,10 @@ int main(int argc, char **argv)
 		.read_ahead_kb = 0,
 	};
 
-	if (!thp_is_enabled()) {
-		printf("Transparent Hugepages not available\n");
-		return KSFT_SKIP;
-	}
+	ksft_print_header();
+
+	if (!thp_is_enabled())
+		ksft_exit_skip("Transparent Hugepages not available\n");
 
 	parse_test_type(argc, argv);
 
@@ -1223,10 +1169,8 @@ int main(int argc, char **argv)
 
 	page_size = getpagesize();
 	hpage_pmd_size = read_pmd_pagesize();
-	if (!hpage_pmd_size) {
-		printf("Reading PMD pagesize failed");
-		exit(EXIT_FAILURE);
-	}
+	if (!hpage_pmd_size)
+		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
 	hpage_pmd_nr = hpage_pmd_size / page_size;
 	hpage_pmd_order = __builtin_ctz(hpage_pmd_nr);
 
@@ -1242,8 +1186,6 @@ int main(int argc, char **argv)
 	save_settings();
 	thp_push_settings(&default_settings);
 
-	alloc_at_fault();
-
 	TEST(collapse_full, khugepaged_context, anon_ops);
 	TEST(collapse_full, khugepaged_context, file_ops);
 	TEST(collapse_full, khugepaged_context, shmem_ops);
@@ -1305,11 +1247,14 @@ int main(int argc, char **argv)
 	TEST(madvise_retracted_page_tables, madvise_context, file_ops);
 	TEST(madvise_retracted_page_tables, madvise_context, shmem_ops);
 
+	ksft_set_plan(nr_test_cases + 1);
+
+	alloc_at_fault();
 	for (int i = 0; i < nr_test_cases; i++) {
 		struct test_case *t = &test_cases[i];
 
 		exit_status = KSFT_PASS;
-		printf("\nRun test: %s: (%s:%s)\n", t->desc, t->ctx->name, t->ops->name);
+		ksft_print_msg("\nRun test: %s: (%s:%s)\n", t->desc, t->ctx->name, t->ops->name);
 		t->fn(t->ctx, t->ops);
 	}
 
-- 
2.53.0


