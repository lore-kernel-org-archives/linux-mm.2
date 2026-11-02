Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6EC0606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=HxtUQgez
Received: by kanga.kvack.org (Postfix)
	id 026806B05C3; Mon,  2 Nov 2026 05:03:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F197F6B05C4; Mon,  2 Nov 2026 05:03:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E576F6B05C5; Mon,  2 Nov 2026 05:03:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA29D6B05C3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:03:54 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE4F840C75
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:03:53 +0000 (UTC)
X-FDA: 85389742746.30.DFF474E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 02C91A0005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:03:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HxtUQgez;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793613832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EZFI/lghrWCtHux+dgu45SkP6jtwsu8V0UM4c/Ac4uw=;
	b=nplehFoOZdJbxa+0eazo4Y7pAAx2YSHci+kKZVFL1s6A6jaSgWn7aZTxWkajUeE9E2mSJL
	5qyNyYe7fhVmfe2igWDOYcMWvhytMjA5bmsS3dICKTyCbye06Pwn9WHwmWYwWk+NyYSEdf
	E22zSDlug8aMtIORhLegkJAEwgUacKs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HxtUQgez;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793613832;
	b=egPnnU3khqoYBp41Xh34HYytQHkoH/QOt42xc6Kdd8VTi/D+eMkZaawGfy2kNNLrChIkBV
	Prrw3ePQ3oYY/iGEwSkyuXlRegCfzwV4QK1H6P8t0WSdwWGIaq8jIxXwbF1hcnE8V3AoJ9
	WHbZUMwczHipLjGN6zL/PQj6CTdfoFk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EAD901595;
	Mon,  2 Nov 2026 02:03:47 -0800 (PST)
Received: from a081061.arm.com (unknown [10.163.156.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B7BDA3F59E;
	Mon,  2 Nov 2026 02:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793613831; bh=JeVzv9NQz+Y+oK0TojJCh1R9phHXpiaYLkfzxvD34FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HxtUQgezyM6AXpWKLe/S0ihuJXrVR0dJIceYhT5wnWp0yPZ7+jdpbAH18eN9cxpsu
	 RHWrF9LhtPohzlyi5M+2aPkIl6RnTGTrRAwp+zKtYX7QE0sGk1phBcjmhbJoUJXIpF
	 TogNqFGV/PpSUdlQ9UpxwkO5UP7Y7p0HeIm2B8f8=
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
Subject: [PATCH RESEND v2 10/12] selftests/mm: mremap_test: replace validation threshold with sampled checks
Date: Mon,  2 Nov 2026 15:32:09 +0530
Message-ID: <20261102100211.141831-11-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261102100211.141831-1-sarthak.sharma@arm.com>
References: <20261102100211.141831-1-sarthak.sharma@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 02C91A0005
X-Stat-Signature: 7smcdshmgqxbj3u1tmsbrz4maqoyisaw
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793613831-732266
X-HE-Meta: U2FsdGVkX1/tCETpmiWqVs2VwRSGq0oZ1svIvjKM+ce7q82IjVJvK1RzvoFiILgeoxeis9pqcHDihPW8K2BIKYXrdbOMXdjNVubNfvYhGnzFlZj+GDJFup0fFgTyqiElrumqeKa5mUCMdkkVSL0avZa32tAyzbA5txNQCOOiQUFZuwNSnhwjST59nXPi2LC/CuRJ4KRFMlFztI3J+kSSlcWgOV4tM0gUOLE2cFGoyRVEGxwxgofCItQSFXcOwm1X05z9xFw+lY+K7npQIojnktGxsJ7eZLknYadp1D2UaAkbSkUhPQUnUswzEOlmNb1h6FXBbBGiWlbY8jZ2XAtn6W9ezVpUNnBpMEHuVRRuUAiqiiMo5p69k6cnJ89bwsOOecwAlPIj9afLdXXJjJEk2AAbu2VoPCss2UEfrlZ4IRvbQ3rzi88uYxXKYSxwXq1qk3r7UOxU1s67ZvFd/x9o5vyyVv12X6hnca3x6WOoc3KsZk2PQTDa9PWCVBo3cGDfnbWWjW7+GwJBdojq/SgiB34dFXh0ANY2aWhAW8SKUjZQPbNMD6ZaaFJ0F1zHcJ0eWftMxLTF1u/sjyBjBTAi37VqD5kF6yM4jTxBzFVWmgRvkm/pjF5U4fkDmY+bw7uCUsHHNxp35rpKx7BjGiFgoSw3xJNHdecn+XrmZ1gjKaYHNLQgxmzODqGGIstCyyOUc77RNwMFzWFcdlMduD6TPREpHUzuDIxxf5WuCmGS268yoyevZJ35KLd14KE/ejkc5KFjNSt25e++Xg4vlv/qi/uHQVLDQ0GaygDWdmj4+yrVup3oJsGaMRS78N+uZgwFy0u93cUFh/dlQ9YpjqB/WJ9QGxZVGjQlEt1QpfNiyyvcqutdqVJVgCEUntn/mo67KoRGC8UYzpv/n7nKyFerlykj3Exo5Uz5ZxDWTbdoD4rbEdCYQOe4O+kQhzjgJEHoqULFcwDvKWRGLFaGi9s
 CRhmb2bk
 R4wLHyHbn2i/bqC3+RY7RWKrJwzJQMwVuTAqV0e2+sazkZMGHODZxQbgUqoIEDxOvdvwPzKz0L1WMrrRUgNypeYPnazbk8r9iqMtQJwR3DHXmC54ncsuE4XJl3/983t9oPaxspjJuV6FjDExgnKpVlwqdR3LNlFXueSaY5ATsI+Msv8Ayh2+HdMBjQDs9pPFBBfKbJAXNKmAzL35sIDtZ0rwsdEAWUaXEfruy6PF9k7ogNIC2IQNH7CYazrWKDav8OyPE9Y6XkABfhQShazKKLHo6JKrS3ooqUVXYbQti3RyzcfgqGlzsxQv2yu3riU14vT4M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

mremap_test validates only the first 4MB of large mappings by
default. Now since the command line option has been removed,
this threshold is fixed and covers only the beginning of
each mapping.

Remove validation threshold and fully validate mappings that
fit within the 40MB random pattern buffer. For larger mappings,
initialize and validate 10 pages each at the start, middle
and end. This increases coverage without significantly
increasing the test's RSS.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 85 +++++++++++++-----------
 1 file changed, 48 insertions(+), 37 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index bf825ffa29f6..572e4d9e9f00 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -22,13 +22,7 @@
 #define EXPECT_FAILURE 1
 #define NON_OVERLAPPING 0
 #define OVERLAPPING 1
-#define VALIDATION_DEFAULT_THRESHOLD 4	/* 4MB */
-#define VALIDATION_NO_THRESHOLD 0	/* Verify the entire region */
 
-#ifndef MIN
-#define MIN(X, Y) ((X) < (Y) ? (X) : (Y))
-#define MAX(X, Y) ((X) > (Y) ? (X) : (Y))
-#endif
 #define SIZE_MB(m) ((size_t)m * (1024 * 1024))
 #define SIZE_KB(k) ((size_t)k * 1024)
 
@@ -928,19 +922,49 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp, unsigned long page_siz
 }
 #endif /* __NR_userfaultfd */
 
-static int remap_region(struct config c, unsigned int threshold_mb,
-			char *rand_addr)
+static void populate_test_data(char *addr, size_t size, char *pattern_addr,
+		size_t pattern_size, size_t page_size)
+{
+	size_t mid, end;
+	size_t len = 10 * page_size;
+
+	if (size <= pattern_size) {
+		memcpy(addr, pattern_addr, size);
+		return;
+	}
+
+	end = size - len;
+	mid = end / 2;
+
+	memcpy(addr, pattern_addr, len);
+	memcpy(addr + mid, pattern_addr + len, len);
+	memcpy(addr + end, pattern_addr + 2 * len, len);
+}
+
+static bool validate_test_data(char *addr, size_t size, char *pattern_addr,
+		size_t pattern_size, size_t page_size)
+{
+	size_t mid, end;
+	size_t len = 10 * page_size;
+
+	if (size <= pattern_size)
+		return !memcmp(addr, pattern_addr, size);
+
+	end = size - len;
+	mid = end / 2;
+
+	return !memcmp(addr, pattern_addr, len) &&
+	       !memcmp(addr + mid, pattern_addr + len, len) &&
+	       !memcmp(addr + end, pattern_addr + 2 * len, len);
+}
+
+static int remap_region(struct config c, char *rand_addr, size_t rand_size,
+		size_t page_size)
 {
 	void *addr, *tmp_addr, *src_addr, *dest_addr, *dest_preamble_addr = NULL;
 	long long align_mask, offset;
-	unsigned long long threshold;
 	int ret = 0;
 
-	if (threshold_mb == VALIDATION_NO_THRESHOLD)
-		threshold = c.region_size;
-	else
-		threshold = MIN(threshold_mb * _1MB, c.region_size);
-
 	src_addr = get_source_mapping(c);
 	if (!src_addr) {
 		ret = -1;
@@ -948,7 +972,7 @@ static int remap_region(struct config c, unsigned int threshold_mb,
 	}
 
 	/* Set byte pattern for source block. */
-	memcpy(src_addr, rand_addr, threshold);
+	populate_test_data(src_addr, c.region_size, rand_addr, rand_size, page_size);
 
 	/* Mask to zero out lower bits of address for alignment */
 	align_mask = ~(c.dest_alignment - 1);
@@ -1004,7 +1028,8 @@ static int remap_region(struct config c, unsigned int threshold_mb,
 	}
 
 	/* Verify byte pattern after remapping */
-	if (memcmp(dest_addr, rand_addr, threshold)) {
+	if (!validate_test_data(dest_addr, c.region_size, rand_addr,
+				rand_size, page_size)) {
 		ksft_print_msg("Data after remap doesn't match\n");
 		ret = -1;
 		goto clean_up_dest;
@@ -1102,10 +1127,11 @@ static void mremap_move_1mb_from_start(unsigned int pattern_seed,
 }
 
 static void run_mremap_test_case(struct test test_case,
-				 unsigned int threshold_mb,
-				 char *rand_addr)
+				 char *rand_addr,
+				 size_t rand_size,
+				 size_t page_size)
 {
-	int ret = remap_region(test_case.config, threshold_mb, rand_addr);
+	int ret = remap_region(test_case.config, rand_addr, rand_size, page_size);
 
 	if (ret < 0) {
 		if (test_case.expect_failure)
@@ -1126,12 +1152,6 @@ static void run_mremap_test_case(struct test test_case,
 int main(void)
 {
 	unsigned int i;
-	unsigned int threshold_mb = VALIDATION_DEFAULT_THRESHOLD;
-
-	/* hard-coded test configs */
-	size_t max_test_variable_region_size = _2GB;
-	size_t max_test_constant_region_size = _2MB;
-	size_t dest_preamble_size = 10 * _4MB;
 
 	unsigned int pattern_seed;
 	char *rand_addr;
@@ -1150,21 +1170,12 @@ int main(void)
 	pattern_seed = (unsigned int) time(&t);
 
 	ksft_print_msg("Test configs:\n");
-	ksft_print_msg("threshold_mb=%u\n", threshold_mb);
 	ksft_print_msg("pattern_seed=%u\n", pattern_seed);
 
 	/*
-	 * set preallocated random array according to test configs; see the
-	 * functions for the logic of setting the size
+	 * The 40MB destination preamble determines the random buffer size
 	 */
-	if (!threshold_mb)
-		rand_size = MAX(max_test_variable_region_size,
-				max_test_constant_region_size);
-	else
-		rand_size = MAX(MIN(threshold_mb * _1MB,
-				    max_test_variable_region_size),
-				max_test_constant_region_size);
-	rand_size = MAX(dest_preamble_size, rand_size);
+	rand_size = 10 * _4MB;
 
 	rand_addr = (char *)mmap(NULL, rand_size, PROT_READ | PROT_WRITE,
 				 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
@@ -1231,7 +1242,7 @@ int main(void)
 	ksft_set_plan(ARRAY_SIZE(test_cases) + num_expand_tests + num_misc_tests);
 
 	for (i = 0; i < ARRAY_SIZE(test_cases); i++)
-		run_mremap_test_case(test_cases[i], threshold_mb, rand_addr);
+		run_mremap_test_case(test_cases[i], rand_addr, rand_size, page_size);
 
 	maps_fp = fopen("/proc/self/maps", "r");
 
-- 
2.53.0


