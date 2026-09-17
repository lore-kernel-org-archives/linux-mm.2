Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5988C982CF
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 11:20:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E37FB6B009D; Thu, 17 Sep 2026 07:20:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE94F6B009F; Thu, 17 Sep 2026 07:20:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD92B6B00A0; Thu, 17 Sep 2026 07:20:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9BDBC6B009D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:20:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DF3671202D3
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:20:40 +0000 (UTC)
X-FDA: 85223011440.01.AEF7B73
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 55970120008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:20:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fteDMx2J;
	spf=pass (imf29.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789644039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjn5jZifyGpMLJlCdbyyD0ulyO8rhXLfHRcFBJTCd5Q=;
	b=DimfgwSFa9S1NS1X27p4GNe2jeB7GTQJ1I/DYE3cVEy5Ji65AsgSsP/EA8IPIZ7AD9W4cV
	o4vdq/rkUPEP/vH01lWZyEXNM8EbHHoWYhsvaZVCz+w/uPedzhcm+suQpEQ14ApNMbSero
	FW5SkRn4KNW9AM5ysRWyq1bWW9g83Rs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789644039;
	b=Vvlquk0unv9rDX1eqmvyWXxgN5Wb4w/aWsaEpg55uc4mKWX5E/8n4j5OenJDhXpK1OUIkV
	6foXna8afL89ijQgq+LlYpew3jfOH+w0Eh8eX8QJgNoWS/WVmckExmotkTKwFjv2H7saTl
	VkKZ/r4YDxtJJN63K5dIg+raMMRm5Qk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fteDMx2J;
	spf=pass (imf29.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F2EAA1A9A;
	Thu, 17 Sep 2026 04:20:34 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 44AD53F7B4;
	Thu, 17 Sep 2026 04:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789644038; bh=PEYyoFGukDb2bBQUvTSPCNCEuNRH1wR3RMvfZBD9GHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fteDMx2JXw2jO+b6+TfrQR0QyYetpxi0BpWpEmfKSfTVvXgJ1N1cszzrLmUpxfRpy
	 /PJehkPcYKqSHTq/2EDIBTW1hSyDLew+S94/g6RWeHHCEP/lBeOJlL6jgaNDtrJ3KG
	 Bb7fX8NJOz7NmJu9rtd2nEeULeEKyxIgRtJ/r5+o=
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
	John Hubbard <jhubbard@nvidia.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH 7/9] selftests/mm: mremap_test: remove perf tests and timing
Date: Thu, 17 Sep 2026 16:49:49 +0530
Message-ID: <20260917111951.188266-8-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260917111951.188266-1-sarthak.sharma@arm.com>
References: <20260917111951.188266-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 55970120008
X-Stat-Signature: 1c9144i4xrc5zqmytt9ey4uhi1xm5yjc
X-Rspam-User: 
X-HE-Tag: 1789644039-332237
X-HE-Meta: U2FsdGVkX19FGGkRSARUvM0Kb27ugvq2bsPVaXWzmFWLxD9tEB1ygPgzE5CPzYmbd2Qc/KgsTdf1WwWeI/Rar66dZWG/88I2Ek3VdlOkZHgOr5kxMlROQ1qqUD6D8pyxUuMJsEZMnS9R9Igbrxt6ZMPSyYxQOIGYC7VtnX2/pX6QCWxpgXMUVSoc31VvitNiAnFD8x9ljpSHGhDMXZZ1bDQR2Vuu9uylzF/r98yPvyzCWG8Kl9zWOtAjonz0o3MbcP1uw+naRzOSNZwswMDAlycz2LDCmXFRUBQLjy1vobDuNwIAkcttPCFbse6jDlHqm09TXfLqbdtCrycCIbO3Z7IG3wPcyNBKw7dg1ExLifio4wAnZPH77ynr3Vq9U7z7K8XSVzn8rb5x8fK4b+Pmgywbyh+vTGNBbUqZc7KDtTD/wg8TLsbHOdOOxzukZpA6flqEuYlb5eYO6g+0KRfgHpWQfwmuuEjfWJnUJCzs/n21kFjwxyrgd4or9Crbu49Yee1dHn5YpbLowCxgA2dRw0LbbgsmhQuwnP9O0dJHiWn0m7oL9V921oQJXrWjnAxrRnQhhgoYCofgpQesaVR/8O73EpZbbUg1LkUWm7vAHtzJKT7e9qCGw5ZGOqnv0xf9W+xpm0QhmoYccv3uuvL7c59MQMpWvafthEB+xQryeNSkbIG7u6I7ujzs3xNrQPj4ZTlpgevbn24XYLJjCgT1khzIyzaWP3vBGtHCqAtPywh61Eh3mKZ5uBG/HnGWZvcc1z8mjkj7tDFVcrOtBGaNXTvTGagYqKnoaD3fkG3xgeU89Fwz7yixWgjuOMzXZJXED4rhtJeLTLWfoTtIJwu6EqS3LXBRj3UBAxZr/l+RlVfJ12CAHlnUQgdQU5/JpqRYaanUtuvjS0Xtjg/T+A/A06vLfcE0coPCdCecps14TMEnka9LZdWqFZmcs94juMPWnO4Hxa/C1e5HZsbWTXB
 fEJUcUts
 dPXuOpyhWyITZCg66lgL5XlChgddH5PzDzbtRVZLtbD4kseLe6tWbbOQN0e8N7qVZ+dsVwPC3K4tdoXbxlLNAGkOq9IyiWpNNPU+ntNJpfEXzgkVyKnj7iHBWzEo3KK0HWd8901tAEbuHfhe+hEa11Y6jgHeLNMa/DZNL/iL6vZVw/qnS0XF/w2+9Ez+km7VtCSYhQP67UWitbmaKLqd7j5J2XmQEHEvibEQz7txnGUfA2MBcrynpzWL5Cw6P5lGcImOTFM8BUpnytoyv9dyD+GwXN8PG+pF8kNkwYhoXDcJToimMPKTiKPKcErJlXavIgca1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mremap_test contains three perf tests that report the time
taken to move 1GB mappings with different page table level
alignments. Although they validate the remapped data,
their main purpose it to report timing information. The
recorded time also does not affect the test result. Also,
they are skipped with the default validation threshold.

Remove these tests and the timing infrastructure from
mremap_test.c. The regular tests continue to cover PUD
and PMD aligned remaps.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 61 +++---------------------
 1 file changed, 7 insertions(+), 54 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 7b4c9ab3bf14..04ea072f8cd1 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -13,7 +13,6 @@
 #include <sys/ioctl.h>
 #include <sys/mman.h>
 #include <syscall.h>
-#include <time.h>
 #include <stdbool.h>
 #include <stdint.h>
 
@@ -23,7 +22,6 @@
 #define EXPECT_FAILURE 1
 #define NON_OVERLAPPING 0
 #define OVERLAPPING 1
-#define NS_PER_SEC 1000000000ULL
 #define VALIDATION_DEFAULT_THRESHOLD 4	/* 4MB */
 #define VALIDATION_NO_THRESHOLD 0	/* Verify the entire region */
 
@@ -897,12 +895,11 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp, unsigned long page_siz
 }
 #endif /* __NR_userfaultfd */
 
-/* Returns the time taken for the remap on success else returns -1. */
-static long long remap_region(struct config c, unsigned int threshold_mb)
+static int remap_region(struct config c, unsigned int threshold_mb)
 {
 	void *addr, *tmp_addr, *src_addr, *dest_addr, *dest_preamble_addr = NULL;
-	struct timespec t_start = {0, 0}, t_end = {0, 0};
-	long long  start_ns, end_ns, align_mask, ret, offset;
+	long long align_mask, offset;
+	int ret = 0;
 	unsigned long long threshold;
 	char *preamble_pattern;
 
@@ -963,10 +960,8 @@ static long long remap_region(struct config c, unsigned int threshold_mb)
 		memcpy(dest_preamble_addr, preamble_pattern, c.dest_preamble_size);
 	}
 
-	clock_gettime(CLOCK_MONOTONIC, &t_start);
 	dest_addr = mremap(src_addr, c.region_size, c.region_size,
 					  MREMAP_MAYMOVE|MREMAP_FIXED, (char *) addr);
-	clock_gettime(CLOCK_MONOTONIC, &t_end);
 
 	if (dest_addr == MAP_FAILED) {
 		ksft_print_msg("mremap failed: %s\n", strerror(errno));
@@ -989,16 +984,7 @@ static long long remap_region(struct config c, unsigned int threshold_mb)
 		goto clean_up_dest;
 	}
 
-	start_ns = t_start.tv_sec * NS_PER_SEC + t_start.tv_nsec;
-	end_ns = t_end.tv_sec * NS_PER_SEC + t_end.tv_nsec;
-	ret = end_ns - start_ns;
-
-/*
- * Since the destination address is specified using MREMAP_FIXED, subsequent
- * mremap will unmap any previous mapping at the address range specified by
- * dest_addr and region_size. This significantly affects the remap time of
- * subsequent tests. So we clean up mappings after each test.
- */
+/* Clean up mappings after each test. */
 clean_up_dest:
 	munmap(dest_addr, c.region_size);
 clean_up_dest_preamble:
@@ -1076,9 +1062,9 @@ static void mremap_move_1mb_from_start(void)
 static void run_mremap_test_case(struct test test_case,
 				 unsigned int threshold_mb)
 {
-	long long remap_time = remap_region(test_case.config, threshold_mb);
+	int ret = remap_region(test_case.config, threshold_mb);
 
-	if (remap_time < 0) {
+	if (ret < 0) {
 		if (test_case.expect_failure)
 			ksft_test_result_xfail("%s: expected mremap failure\n",
 					       test_case.name);
@@ -1088,14 +1074,6 @@ static void run_mremap_test_case(struct test test_case,
 		if (test_case.expect_failure)
 			ksft_test_result_fail("%s: unexpected mremap success\n",
 					      test_case.name);
-		/*
-		 * Comparing mremap time is only applicable if entire region
-		 * was faulted in.
-		 */
-		else if (threshold_mb == VALIDATION_NO_THRESHOLD ||
-			 test_case.config.region_size <= threshold_mb * _1MB)
-			ksft_test_result_pass("%s: mremap time: %12lldns\n",
-					      test_case.name, remap_time);
 		else
 			ksft_test_result_pass("%s\n", test_case.name);
 	}
@@ -1149,11 +1127,9 @@ static void fill_pattern(uint32_t *pattern, size_t pattern_size, size_t page_siz
 }
 
 #define MAX_TEST 15
-#define MAX_PERF_TEST 3
 int main(int argc, char **argv)
 {
 	unsigned int i;
-	int run_perf_tests;
 	unsigned int threshold_mb = VALIDATION_DEFAULT_THRESHOLD;
 
 	/* hard-coded test configs */
@@ -1164,7 +1140,6 @@ int main(int argc, char **argv)
 	int num_expand_tests = 2;
 	int num_misc_tests = 9;
 	struct test test_cases[MAX_TEST] = {};
-	struct test perf_test_cases[MAX_PERF_TEST];
 	int page_size;
 	FILE *maps_fp;
 
@@ -1251,22 +1226,7 @@ int main(int argc, char **argv)
 				  "5MB mremap - Source 1MB-aligned, Dest 1MB-aligned with 40MB Preamble");
 	test_cases[14].config.dest_preamble_size = 10 * _4MB;
 
-	perf_test_cases[0] =  MAKE_TEST(page_size, page_size, _1GB, NON_OVERLAPPING, EXPECT_SUCCESS,
-					"1GB mremap - Source PTE-aligned, Destination PTE-aligned");
-	/*
-	 * mremap 1GB region - Page table level aligned time
-	 * comparison.
-	 */
-	perf_test_cases[1] = MAKE_TEST(PMD, PMD, _1GB, NON_OVERLAPPING, EXPECT_SUCCESS,
-				       "1GB mremap - Source PMD-aligned, Destination PMD-aligned");
-	perf_test_cases[2] = MAKE_TEST(PUD, PUD, _1GB, NON_OVERLAPPING, EXPECT_SUCCESS,
-				       "1GB mremap - Source PUD-aligned, Destination PUD-aligned");
-
-	run_perf_tests =  (threshold_mb == VALIDATION_NO_THRESHOLD) ||
-				(threshold_mb * _1MB >= _1GB);
-
-	ksft_set_plan(ARRAY_SIZE(test_cases) + (run_perf_tests ?
-		      ARRAY_SIZE(perf_test_cases) : 0) + num_expand_tests + num_misc_tests);
+	ksft_set_plan(ARRAY_SIZE(test_cases) + num_expand_tests + num_misc_tests);
 
 	for (i = 0; i < ARRAY_SIZE(test_cases); i++)
 		run_mremap_test_case(test_cases[i], threshold_mb);
@@ -1293,13 +1253,6 @@ int main(int argc, char **argv)
 
 	fclose(maps_fp);
 
-	if (run_perf_tests) {
-		ksft_print_msg("%s\n",
-			       "mremap HAVE_MOVE_PMD/PUD optimization time comparison for 1GB region:");
-		for (i = 0; i < ARRAY_SIZE(perf_test_cases); i++)
-			run_mremap_test_case(perf_test_cases[i], threshold_mb);
-	}
-
 	munmap(pattern, pattern_size);
 
 	ksft_finished();
-- 
2.53.0


