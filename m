Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04A07C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 11:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 166EB6B009F; Thu, 17 Sep 2026 07:20:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 118DD6B00A0; Thu, 17 Sep 2026 07:20:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAE1B6B00A1; Thu, 17 Sep 2026 07:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BDB316B009F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:20:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A89A0A0303
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:20:45 +0000 (UTC)
X-FDA: 85223011650.07.E632E88
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1270220003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:20:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=X2OnUuNB;
	spf=pass (imf03.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789644044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RVvpZmWn6GQPjYrWqsuFc5neOBd7W9r6p8UaTJUtQu0=;
	b=mhzu/WjV2cK4uUGBQE12HBSCrmAKJxhuMCHP7iNLOT5LZePCa3Ow5Orlm0eAcOyYHs+sbw
	CFXf1UJaclb5WDxBoO/UWTYrOG9S9kF8859fStsvPdiNxPVzkWMgeyOndMbHFBIq6Pt8v5
	hHOxYv6q5/bWJEs5eFXsNq31EEj9nv0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789644044;
	b=5d/bsC/rqysQMOB4mJucfHjaqqvUJl2oaA8y/A3fKFgbrAJlIlthjrrv+XY0nKggqk6xog
	kHd4o9zhzkEC5xMcKJ4EZt4Pb40uTOQsUSSYN445jpZR4Gf795Eo6lkLkjHruan68Y6XFT
	CF0K15+Ze0AHSKTY1H9P8rKu9wfQEgs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=X2OnUuNB;
	spf=pass (imf03.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C970B1476;
	Thu, 17 Sep 2026 04:20:39 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1E1653F7B4;
	Thu, 17 Sep 2026 04:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789644043; bh=HzYZit0ASTHY27nDidq+FbliWDAzksUkPY3TJYFzc8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X2OnUuNB37KLHCl9IEyeImr3pvGMVbDnS3MvfXZESs+cribw4VruV/d57SekSp/7u
	 jW9VjG9SvsIy6YDNNBw6GPK6T5Mj2xOUkrUZbGpz+efWv41ZhbWi/YweMJc9v6yocG
	 OXPN+YK3rqgtScDvbCwZ6X7LWQiJlUrBYBdn6rTU=
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
Subject: [PATCH 8/9] selftests/mm: mremap_test: remove validation threshold
Date: Thu, 17 Sep 2026 16:49:50 +0530
Message-ID: <20260917111951.188266-9-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260917111951.188266-1-sarthak.sharma@arm.com>
References: <20260917111951.188266-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 8s3n4mty1ncimij1ib8mczoa4swqbzsx
X-Rspamd-Queue-Id: 1270220003
X-HE-Tag: 1789644043-147047
X-HE-Meta: U2FsdGVkX1+qQn2x5ppR3n9u+L5hAyhH93248JAlgSGP3NafrfWa9NDexh/YNj5gWE8fa882wMVx+84Nj5rVaM4tFfqIT7v/bHBdwjYlXzFLUXzbvebPN0IKzOgdtBvP84IKsirl8bHzJ6L5lGsx7d3hYycThMaP9zz79iK+mpqa7bRDIIBpcnj6mAXbabqwzamxNkYMkuT9ZRwmdgH+9a6lLmiDVx0Q6gTe97hjvXmpDETwwSS14Y4Pb+PNDgMYK8UhH/kMVuDWm1q2Jj4Nsh+SvYAXZsQ1OELGQxW4Lv1yTatc9s9wxezSMWI+LcGcWby6q60f79aLIqSYv7qgwwTfzasaUzAHuExizq84upQj57wob+dn2MnxWHU5MzXj+ZWhW7xpoaKEuJY+WezMMr+OyHsiZjAcU/wPyiN5EutRdc/BREF0YAU/Mjbfa6oNe9RXyXwYDu50Gh9oD4nGFE89r4qy+LvT+j5AXpxxgZISMQGoXiPdR/0eoG2CoZIpJ6jtW/tmss0j/P/gR9PZDpgNR9D77jXQ7+La2okLopYgZD6JpxyRPqHXe91zLZmHpKo4wrJ8NGwbq3OHdmAJ98ZgUCXQmUNK3UWUZl26sIXCuzY9pi0fD0xE75k+gU3E4E8rzQUSrOVUJxKgm5OP0tinporUo3BG1DcQyfL6t//SajRDRh5TuQtz8DJrK2ElOBFCRvNnRJ94mLZFuE1icsMI2pNkB6FOlm/wRUNB2OgKf8OVf64Afe/GgP0t3DiX5biWmdksJnzW3EckInn9tjayCTcM5N/jNEeT2wJ/SEGxv5jSbNIL22xiRroqpQba5XcQeVOf/8brQeVuFhnli0J/AvKtOtWRo9u2RWadh7YUMtqeHfwuNeYyvfibrWnGsHTDLRboz3o3dUQofjvTjya3nbJBLjUNOHoFuKehVt07u+L9xtIbaFvxImFF6oafG3xRiHRPzxNAgjWuz12
 cufqKjkn
 d28axBvFtljwfCZtFEjeg1hruLiT9sMZLIsGv3yBs3QsPnbuPMu8GoIcrAjkQAcznDa98yymWdua+uPwDKb7e3FMmRLCfcyT+Qakgan6vwd5njmTFr+Hf6OFZIggjMxeVU04feEFTwFsxkd4B9C+oPg5QI38UP4sCthZ3G+yh88WWhAaY1YY4cAUjrrVUCZVOuzxwZhTeqT50Ll917mIbauxQ5lyJUhxjjFZUy76C7840KxxJ1JQh9bHipcrHNvP5xaFlBmGF9i7yz+A1T2B1S9kAALHq1XVIw9XKNBkmRfUEHvoi+D0htUWQNtyWpVY1Q2MH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mremap_test validates only the first 4MB of large mappings by default.
The amount of data validated can be changed using the -t command line
option, with zero selecting the complete region.

Remove the validation threshold and its command line option. Always
initialize and validate the complete remapped region.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 84 +++---------------------
 1 file changed, 8 insertions(+), 76 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 04ea072f8cd1..77e952556be1 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -22,13 +22,6 @@
 #define EXPECT_FAILURE 1
 #define NON_OVERLAPPING 0
 #define OVERLAPPING 1
-#define VALIDATION_DEFAULT_THRESHOLD 4	/* 4MB */
-#define VALIDATION_NO_THRESHOLD 0	/* Verify the entire region */
-
-#ifndef MIN
-#define MIN(X, Y) ((X) < (Y) ? (X) : (Y))
-#define MAX(X, Y) ((X) > (Y) ? (X) : (Y))
-#endif
 #define SIZE_MB(m) ((size_t)m * (1024 * 1024))
 #define SIZE_KB(k) ((size_t)k * 1024)
 
@@ -61,7 +54,7 @@ enum {
 };
 
 static uint32_t *pattern;
-static size_t pattern_size;
+static const size_t pattern_size = _2GB;
 
 #define PTE page_size
 
@@ -895,19 +888,13 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp, unsigned long page_siz
 }
 #endif /* __NR_userfaultfd */
 
-static int remap_region(struct config c, unsigned int threshold_mb)
+static int remap_region(struct config c)
 {
 	void *addr, *tmp_addr, *src_addr, *dest_addr, *dest_preamble_addr = NULL;
 	long long align_mask, offset;
 	int ret = 0;
-	unsigned long long threshold;
 	char *preamble_pattern;
 
-	if (threshold_mb == VALIDATION_NO_THRESHOLD)
-		threshold = c.region_size;
-	else
-		threshold = MIN(threshold_mb * _1MB, c.region_size);
-
 	src_addr = get_source_mapping(c);
 	if (!src_addr) {
 		ret = -1;
@@ -915,7 +902,7 @@ static int remap_region(struct config c, unsigned int threshold_mb)
 	}
 
 	/* Set byte pattern for source block. */
-	memcpy(src_addr, pattern, threshold);
+	memcpy(src_addr, pattern, c.region_size);
 
 	/* Mask to zero out lower bits of address for alignment */
 	align_mask = ~(c.dest_alignment - 1);
@@ -970,7 +957,7 @@ static int remap_region(struct config c, unsigned int threshold_mb)
 	}
 
 	/* Verify byte pattern after remapping */
-	if (memcmp(dest_addr, pattern, threshold)) {
+	if (memcmp(dest_addr, pattern, c.region_size)) {
 		ksft_print_msg("Data after remap doesn't match\n");
 		ret = -1;
 		goto clean_up_dest;
@@ -1059,10 +1046,9 @@ static void mremap_move_1mb_from_start(void)
 	ksft_test_result(success, "%s\n", test_name);
 }
 
-static void run_mremap_test_case(struct test test_case,
-				 unsigned int threshold_mb)
+static void run_mremap_test_case(struct test test_case)
 {
-	int ret = remap_region(test_case.config, threshold_mb);
+	int ret = remap_region(test_case.config);
 
 	if (ret < 0) {
 		if (test_case.expect_failure)
@@ -1079,38 +1065,6 @@ static void run_mremap_test_case(struct test test_case,
 	}
 }
 
-static void usage(const char *cmd)
-{
-	ksft_print_msg("Usage: %s [-t <threshold_mb>]\n", cmd);
-	ksft_print_msg("-t\t only validate threshold_mb of the remapped region\n");
-	ksft_print_msg("  \t if 0 is supplied no threshold is used; all tests\n");
-	ksft_print_msg("  \t are run and remapped regions validated fully.\n");
-	ksft_print_msg("  \t The default threshold used is 4MB.\n");
-}
-
-static int parse_args(int argc, char **argv, unsigned int *threshold_mb)
-{
-	int opt;
-
-	while ((opt = getopt(argc, argv, "t:")) != -1) {
-		switch (opt) {
-		case 't':
-			*threshold_mb = atoi(optarg);
-			break;
-		default:
-			usage(argv[0]);
-			return -1;
-		}
-	}
-
-	if (optind < argc) {
-		usage(argv[0]);
-		return -1;
-	}
-
-	return 0;
-}
-
 static void fill_pattern(uint32_t *pattern, size_t pattern_size, size_t page_size)
 {
 	size_t nr_pages = pattern_size / page_size;
@@ -1127,16 +1081,9 @@ static void fill_pattern(uint32_t *pattern, size_t pattern_size, size_t page_siz
 }
 
 #define MAX_TEST 15
-int main(int argc, char **argv)
+int main(void)
 {
 	unsigned int i;
-	unsigned int threshold_mb = VALIDATION_DEFAULT_THRESHOLD;
-
-	/* hard-coded test configs */
-	size_t max_test_variable_region_size = _2GB;
-	size_t max_test_constant_region_size = _2MB;
-	size_t dest_preamble_size = 10 * _4MB;
-
 	int num_expand_tests = 2;
 	int num_misc_tests = 9;
 	struct test test_cases[MAX_TEST] = {};
@@ -1147,24 +1094,9 @@ int main(int argc, char **argv)
 
 	get_mmap_min_addr();
 
-	if (parse_args(argc, argv, &threshold_mb) < 0)
-		ksft_exit_fail_msg("Invalid arguments\n");
-
-	ksft_print_msg("Test configs:\n");
-	ksft_print_msg("threshold_mb=%u\n", threshold_mb);
-
 	/*
 	 * Set a preallocated array where page[i] contains i+1
 	 */
-	if (!threshold_mb)
-		pattern_size = MAX(max_test_variable_region_size,
-				   max_test_constant_region_size);
-	else
-		pattern_size = MAX(MIN(threshold_mb * _1MB,
-				       max_test_variable_region_size),
-				   max_test_constant_region_size);
-	pattern_size = MAX(dest_preamble_size, pattern_size);
-
 	pattern = mmap(NULL, pattern_size, PROT_READ | PROT_WRITE,
 		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	if (pattern == MAP_FAILED) {
@@ -1229,7 +1161,7 @@ int main(int argc, char **argv)
 	ksft_set_plan(ARRAY_SIZE(test_cases) + num_expand_tests + num_misc_tests);
 
 	for (i = 0; i < ARRAY_SIZE(test_cases); i++)
-		run_mremap_test_case(test_cases[i], threshold_mb);
+		run_mremap_test_case(test_cases[i]);
 
 	maps_fp = fopen("/proc/self/maps", "r");
 
-- 
2.53.0


