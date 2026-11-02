Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11ACD606A32D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=MbiEQKPA
Received: by kanga.kvack.org (Postfix)
	id 297E56B05C1; Mon,  2 Nov 2026 05:03:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 248016B05C2; Mon,  2 Nov 2026 05:03:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 184CD6B05C3; Mon,  2 Nov 2026 05:03:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E17DE6B05C1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:03:46 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6BE8AA0BEB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:03:45 +0000 (UTC)
X-FDA: 85389742410.19.FFAA5E8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id B403CC000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:03:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MbiEQKPA;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793613823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q0mRcK2bKQo+q66MkLAlKH/V2mp0o6C8AmD4irh5/SQ=;
	b=elb+ry3zJMMniD4wfVv4p8KAyVXU5ERaihOBgn3CXpKug/Xj7uI6VpxSH6FD5zYZgk6+EC
	R0k24MNQWde1EY6rUtgdg6cdKSV6S4odE4WTYI3CxXjlN40VAKiU99FnoJpU8z0cUHqB6x
	6t75GJ5NRQ/eM1KQ8qfLnOgnShNA0wU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MbiEQKPA;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793613823;
	b=ML0fSWCUjAL0ncQ9CKni45j8JSu33RTzSdQeV87xp+NVvQnS923w0GF5v3NTSZvpxdVGQ3
	b8snWOmRAiBxAJw7YSoZClkFlKoRNrqhyNYexb2/dalyKvxKgOSp9ji6IfPMGqKMvvaOFa
	DqF9SWxlUbDYjRLAmKvVNhZ8ndFI9kQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB9D51595;
	Mon,  2 Nov 2026 02:03:39 -0800 (PST)
Received: from a081061.arm.com (unknown [10.163.156.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6657D3F59E;
	Mon,  2 Nov 2026 02:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793613822; bh=XoWrK/XFPSHrKoCJr1hb8lpBF7nrUDVvP6yJJO84omg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MbiEQKPAwioHsY+oTq9XEBh9wl6T/SXLEbkOp0d1rHU3X0r6FnGj4M0e6q6SrIuV5
	 8CNaAhOdahyRRYqjLg/E712Rr1XZIJUQpu1Li1F8DkLIxLWlI4jXaO5xjj0H7jBA8e
	 2aZADk44Lbi6xCgAQJwt2Es++wvqtA7MKLbxfLNw=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Park Tae-sun <ts930@dgu.ac.kr>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH RESEND v2 09/12] selftests/mm: mremap_test: remove perf tests and timing
Date: Mon,  2 Nov 2026 15:32:08 +0530
Message-ID: <20261102100211.141831-10-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261102100211.141831-1-sarthak.sharma@arm.com>
References: <20261102100211.141831-1-sarthak.sharma@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B403CC000A
X-Stat-Signature: yjsiy4zc5p6hmfpf1o7ttwbhfuw8k89c
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793613823-906091
X-HE-Meta: U2FsdGVkX19OuR36svyRwpn4TcM7/5J1fc+AwQDFx/mLoAiaz2rMKsKTLsDqFOL3MT2UzpFsYotBKBe833g6ZWmm0jNt5qwfEZydBFACz0Uqh3h4cHP7/seJ1BVl86xfSOR9KI6KwhPgAx5P3rl1EQ4H0Sse9YRJjpBHWZvdErwyxFt5Wcfwvqnh5LNB3+sJR/Ig5A8uYMt96Hq1kDzhGw8aPtKuDD7EDEFYvIGfKWOq/nsu2h9uW24R1wz9Cf8iylabRFk+XPLvAVT5l+Je9GmlvtwHNxP8kWzxyrd6oEnW1susq9t3etCp8g6XPwFF7uKf0KY3JOW0sSVmweIUActs/uCkXlDoDoiRvV6ic1SHJz0vvlMHu7ao0OumtunHgGyK+sQzstXjy4jBjkWmRBL/7ultJ/oC/GedAjoCevVuUqMGCKS4tO6DSbSQMw1ZtZdhPefN+3AOjUDWMfgftD5Z+wGe1Bh3ijBTfCbWHXYbpcrY/Aj53IYnarea3FXClatNMZgmN6DotDgMyqZFW27cdr8UkzatT/mV6PQbrxx7yYfNkYhhwKAMZgxCRj3qe8nj8kHlFqE52rsDYPHYb5O5us3/5E349Z30bIElWcbG4k8b4x+7EiiBX3NRoGeLD8Q2C6AEXD85eonBq56d2DzQalwEd3GSTBIzTff/UOHMEne08x+esMpouvK2sVg0xcKCJZ0Uubl1hivQYfvTndNolCFd2wdjGiXwCP5/C6adjS/38wkFYsi0cS4fs98Y2GcysyfeipauzFwWanrGtWtWcHoGAxKRJM95SurYQExr5mInNTz6FwRjJfXwHQuuceZDbfrw8aFs55mGYvU6fQyJpwox4uvR05NIs71qgTnaZlwkSYGBus7Lu3TB8ZZ4jqT7RiVfnT3v1R2WRItwjRHrTDSkoU7NnVUJtDE+31rlWYGWXtK+yVFxQCLdtnt1zDqVOz1boxEF6T5qx7M
 aw98cPua
 RFcslh2/MhbJIiW5dtONxe1+6r9Po4fyxQC5Ol5SZ/O7gFHEDl6rOGjwdo+a3VU8kfUhcgO8T4RJXJhXVtFk/JaDZ0TJ/toUYaF633PXrVKoSt6YwE68CE4Kkd2JWHGh/sEGaQhxef6QIfsy8AOsyIMo0TKjz7JWCp1S1dXLs7w/Kov+eUUS1lRJD1ia3qfL/s4s/KAY8Jq3AyBPCU3+y774FzCd1LANWKQXnlnAFYJSoQJlRwKuzPGWBXCWkiPz0Eju0LCoqm3xtYl5F3AjRFTiixihmDS+7O7SAPnA/BbofVVaRcifu+NyMoeq/7U933LSB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index 63bf8a475fe6..bf825ffa29f6 100644
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
@@ -996,10 +994,8 @@ static long long remap_region(struct config c, unsigned int threshold_mb,
 		memcpy(dest_preamble_addr, rand_addr, c.dest_preamble_size);
 	}
 
-	clock_gettime(CLOCK_MONOTONIC, &t_start);
 	dest_addr = mremap(src_addr, c.region_size, c.region_size,
 			   MREMAP_MAYMOVE | MREMAP_FIXED, (char *)addr);
-	clock_gettime(CLOCK_MONOTONIC, &t_end);
 
 	if (dest_addr == MAP_FAILED) {
 		ksft_print_msg("mremap failed: %s\n", strerror(errno));
@@ -1022,16 +1018,6 @@ static long long remap_region(struct config c, unsigned int threshold_mb,
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
@@ -1119,10 +1105,9 @@ static void run_mremap_test_case(struct test test_case,
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
@@ -1132,25 +1117,15 @@ static void run_mremap_test_case(struct test test_case,
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
@@ -1164,7 +1139,6 @@ int main(void)
 	int num_expand_tests = 2;
 	int num_misc_tests = 9;
 	struct test test_cases[MAX_TEST] = {};
-	struct test perf_test_cases[MAX_PERF_TEST];
 	int page_size;
 	time_t t;
 	FILE *maps_fp;
@@ -1254,22 +1228,7 @@ int main(void)
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
@@ -1296,15 +1255,6 @@ int main(void)
 
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


