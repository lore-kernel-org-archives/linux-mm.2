Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31586CA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:26:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C8256B00B3; Tue,  6 Oct 2026 05:26:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 278D36B00B4; Tue,  6 Oct 2026 05:26:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B6136B00B5; Tue,  6 Oct 2026 05:26:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DAA096B00B3
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:26:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5A1281A0377
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:26:11 +0000 (UTC)
X-FDA: 85291670142.29.0C7C222
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id A341E140004
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:26:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=F4zY6T2J;
	spf=pass (imf26.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278769;
	b=8FL6tFpg1UFqvfwMjJysVB507p+yHXUQnGIcKQQBn1/yux5WztbEzfxcAzvgObZF7NE0jZ
	nxr6cIyPtsEvx28VxbXkmxu1O9+Rai4YvMIp5zRSxvjXSQeUrQJV9uxv/Wx/HMScsKaMAX
	GmUQZxwFiFRsnm9FZf+pdagn4kdPmL8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=F4zY6T2J;
	spf=pass (imf26.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cIJCpyMTcaIaC0X/Y21iDSc/EjiPPAZeYf9CAjlyyOg=;
	b=LvFBpjgI/tfas1+dY+oU70cPKoH7S0bBIooGcEmsaaJYXpSeMzUdXgmgi2CIir6tnkI3md
	ACdZWwThsxX8OVXvgMXaSEOu3pinuWNAKlmjsV2Ewwc2+2s1SDHky+rBChmKpNsNXXp7MD
	xPgZ95hV0MKzTMReZlIu6RZvjdjqz1w=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 75A561477;
	Tue,  6 Oct 2026 02:26:05 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9186F3F763;
	Tue,  6 Oct 2026 02:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791278768; bh=rXnkgoWZpqTDKBHoUCO6679dXjhgavjkj33aFGmM2oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F4zY6T2JV0ZzIuz3xaTJnjRp5wF9fq+jctyfDmntuxpPlv4rc2IlbXyO3gDJiS1A9
	 JeOufxNs78XS2FQ0/fv9JdslgcTAHI8i1G3Tj/uNw6bHPP9pQlAG6fncNyH544pFIn
	 boDadFJIPyOjA9XVhg5fEh3jJJcfDE33NnRb3TQc=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ljs@kernel.org,
	liam@infradead.org,
	vbabka@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	jhubbard@nvidia.com,
	kaleshsingh@google.com,
	anshuman.khandual@arm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v2 09/12] selftests/mm: mremap_test: remove perf tests and timing
Date: Tue,  6 Oct 2026 14:55:08 +0530
Message-ID: <20261006092511.145776-10-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261006092511.145776-1-sarthak.sharma@arm.com>
References: <20261006092511.145776-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A341E140004
X-Rspam-User: 
X-Stat-Signature: acfeep1ugpu8bxw4k5pn7tspw5bcwqxj
X-HE-Tag: 1791278769-348373
X-HE-Meta: U2FsdGVkX18SkFIlkcBMPue6hKaKZFFMrjmyYHKgnZd5hPEIGCHwhA3vUUJhLvfrXoxcyb3K8lqpTrYzYUyh5SZOyFgR39Y2iAR4bC9qKSwzgYzqGdZoIRPYKsFUt33NOxz4u6kVaUYDJQjQW+Q1oZL/YbSYZ0no6zFOn4Jjr27YcmgtF2Wum6yAA5WdqVl0sbzB2U5A5yloZviBozIgUPgZWLpjmluqUmfZYKtyctAI4sCiDtzLjTGNGwNhNKpZY66v6dMp1ByJLSr3rP8BB/673AbfXrr6EukDF9oWqt1M9iS6lOmvBji9vT7Hm2WsEB/js5tpUeFnDiPCd1U5XzZhr8sIidVREgHRDh3QKTGNjSgBVtwFtZBM+byZQ95t5Q7hn8fDX7ZSuCJG0R4Iifv4bNe0UDT6+jkp8XUK2ADrKXwhohIGntJZ5rO2hutt0hOGNFHbrbR+67hJ1ahBpEguEU7Oz86uMrJq+ek9qovKgW9XNPY8+NP2gDXvR0CubRHLUDRGGsUHYKbp6K3lYMp/bPU/U/PBONqajT7Zs4V+lRY0AWxmQE+b/orhxTbbuxpuAbW3lS2b02IFTKmIwEin83QKjlgodXAV9Q43iAhytQstRTXctjGQdNCzlyD8BvFGRSrSKdooutpidLT/gkDTA7dktlpim2KMIvI/kZSrddSWluzUN/SRDGjf0Ri8IpWRG7GhTzuRDFs+JQngmG5iIkUKA566SVMlofiDbOr6K/rMuhv44Ae5avC+4fGvJUOCUXIBoeyk1ATTcxKBDHph0rnwtwivDpf3LkaSzjmpwLvO2H0k7eXJHURcFFDKo9E+JiH4xp65cvUdIRuM/ZeFUpubWixYa4oFy9DV49ImIUuZFIxeFZ+oZH+BL87f8Wn2o/Kf8/XDb1hZS2S8+E/kc9Xeq9PPGfUc4KALJKLSr+Jm5IwfnXoVEagAr71w66jwvL/dIS1mBCsKRjf
 SOmbJu2t
 bpGgZRjiAE6fKuf+U6OB4KFOA8ul2e0xBZOO7kMSFGCLe0PJsa9pN6isLqLO6Zd7zkYU9kuIoFfUb3pq+sIHIyLnPhfpWPZy5e2fu76ilx1r3w63kq8fPTCWbzcIGwtBqxIFDLytIhmH/9oDPVLmq91sSSqQzSIbfT9IvuXauyP05YirZpBBrCkHnWAsTSVwCUxTXJ6w/trPM3+nQjo5EVox45rbZgDpOWBCjCxMjeN/4f8DGIKUW7tyNiA7ALQ44l0i5u0Gn74gX3vdld/y1DU/LWbbB4xHMLL4dxo5T7A/HBCfDOLPWdwcwnnQMNgvQXnK+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mremap_test contains three perf tests that report the time
taken to move 1GB mappings with different page table level
alignments. Although they validate the remapped data,
their main purpose is to report timing information. The
recorded time also does not affect the test result. Also,
they are not run with the default validation threshold.

Remove these tests and the timing infrastructure from
mremap_test.c. The regular tests continue to cover PUD
and PMD aligned remaps.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 64 +++---------------------
 1 file changed, 7 insertions(+), 57 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 37bba5049ecc..403c5495e160 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -22,7 +22,6 @@
 #define EXPECT_FAILURE 1
 #define NON_OVERLAPPING 0
 #define OVERLAPPING 1
-#define NS_PER_SEC 1000000000ULL
 #define VALIDATION_DEFAULT_THRESHOLD 4	/* 4MB */
 #define VALIDATION_NO_THRESHOLD 0	/* Verify the entire region */
 
@@ -929,14 +928,13 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp, unsigned long page_siz
 }
 #endif /* __NR_userfaultfd */
 
-/* Returns the time taken for the remap on success else returns -1. */
-static long long remap_region(struct config c, unsigned int threshold_mb,
-			      char *rand_addr)
+static int remap_region(struct config c, unsigned int threshold_mb,
+			char *rand_addr)
 {
 	void *addr, *tmp_addr, *src_addr, *dest_addr, *dest_preamble_addr = NULL;
-	struct timespec t_start = {0, 0}, t_end = {0, 0};
-	long long  start_ns, end_ns, align_mask, ret, offset;
+	long long align_mask, offset;
 	unsigned long long threshold;
+	int ret = 0;
 
 	if (threshold_mb == VALIDATION_NO_THRESHOLD)
 		threshold = c.region_size;
@@ -994,10 +992,8 @@ static long long remap_region(struct config c, unsigned int threshold_mb,
 		memcpy(dest_preamble_addr, rand_addr, c.dest_preamble_size);
 	}
 
-	clock_gettime(CLOCK_MONOTONIC, &t_start);
 	dest_addr = mremap(src_addr, c.region_size, c.region_size,
 			   MREMAP_MAYMOVE | MREMAP_FIXED, (char *)addr);
-	clock_gettime(CLOCK_MONOTONIC, &t_end);
 
 	if (dest_addr == MAP_FAILED) {
 		ksft_print_msg("mremap failed: %s\n", strerror(errno));
@@ -1020,16 +1016,6 @@ static long long remap_region(struct config c, unsigned int threshold_mb,
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
 clean_up_dest:
 	munmap(dest_addr, c.region_size);
 clean_up_dest_preamble:
@@ -1117,10 +1103,9 @@ static void run_mremap_test_case(struct test test_case,
 				 unsigned int threshold_mb,
 				 char *rand_addr)
 {
-	long long remap_time = remap_region(test_case.config, threshold_mb,
-					    rand_addr);
+	int ret = remap_region(test_case.config, threshold_mb, rand_addr);
 
-	if (remap_time < 0) {
+	if (ret < 0) {
 		if (test_case.expect_failure)
 			ksft_test_result_xfail("%s: expected mremap failure\n",
 					       test_case.name);
@@ -1130,25 +1115,15 @@ static void run_mremap_test_case(struct test test_case,
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
 }
 
 #define MAX_TEST 15
-#define MAX_PERF_TEST 3
 int main(void)
 {
 	unsigned int i;
-	int run_perf_tests;
 	unsigned int threshold_mb = VALIDATION_DEFAULT_THRESHOLD;
 
 	/* hard-coded test configs */
@@ -1162,7 +1137,6 @@ int main(void)
 	int num_expand_tests = 2;
 	int num_misc_tests = 9;
 	struct test test_cases[MAX_TEST] = {};
-	struct test perf_test_cases[MAX_PERF_TEST];
 	int page_size;
 	time_t t;
 	FILE *maps_fp;
@@ -1252,22 +1226,7 @@ int main(void)
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
 		run_mremap_test_case(test_cases[i], threshold_mb, rand_addr);
@@ -1294,15 +1253,6 @@ int main(void)
 
 	fclose(maps_fp);
 
-	if (run_perf_tests) {
-		ksft_print_msg("%s\n",
-		 "mremap HAVE_MOVE_PMD/PUD optimization time comparison for 1GB region:");
-		for (i = 0; i < ARRAY_SIZE(perf_test_cases); i++)
-			run_mremap_test_case(perf_test_cases[i],
-					     threshold_mb,
-					     rand_addr);
-	}
-
 	munmap(rand_addr, rand_size);
 
 	ksft_finished();
-- 
2.53.0


