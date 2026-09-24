Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 461F8C982FD
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 05:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CD436B009F; Thu, 24 Sep 2026 01:01:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52FA56B00A1; Thu, 24 Sep 2026 01:01:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F75B6B00A2; Thu, 24 Sep 2026 01:01:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 193EA6B009F
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 01:01:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2E53F40212
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:01:06 +0000 (UTC)
X-FDA: 85247456532.12.ECC453C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 35E98A000A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:01:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CG74ej4k;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790226064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RVvpZmWn6GQPjYrWqsuFc5neOBd7W9r6p8UaTJUtQu0=;
	b=MRsObc3e76ek9TVXYBbRRMSouKopLPJ10XdMDSmBOMBSp3oxGbL/DGn8jCOGQH1FS0SE4J
	YMAtXgmQ+iZF6d15hG9y/wUY5AzaqwMGFfsxSffTawt4ol9mVYj3YyZUrK59OaC3EZnmei
	Rhn8odBIBLXhBWWeetKymk4W5Fjw0CM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CG74ej4k;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790226064;
	b=KuK3PtS3CbLV8c+ZlcVz/42XB7mkLGTL0Ov5OrNw0haJdalEeeNRVwmpGir8QY5e5JX+Nc
	NMpJJq6fS/pL9yHdn9++GxKtps2oOqRBqsWqLLxAXU/RMwSOgK7ZkcRFzfXy1mZu45JujG
	Kgj57j2+LYHVWJivTlU5LWIrhtJ/zWc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 770BB1682;
	Wed, 23 Sep 2026 22:00:59 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 59C403F86C;
	Wed, 23 Sep 2026 22:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790226062; bh=HzYZit0ASTHY27nDidq+FbliWDAzksUkPY3TJYFzc8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CG74ej4kY84i60SFaf5y1GlGswZwFBPBJ6SmoImPZtM5mqWvD6CJmlCVei9haE7UD
	 jG3rMEx8kz7HrwGVGb0dTEjgqVJXAr7MBe29ush6E75/G6JuZjUTThaHW82VeqHMPC
	 b8T5boDrJGPpzMEt6AR2vdxbtixl4knR7ho4+Wjc=
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
	Park Tae-sun <ts930@dgu.ac.kr>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH RESEND 8/9] selftests/mm: mremap_test: remove validation threshold
Date: Thu, 24 Sep 2026 10:30:08 +0530
Message-ID: <20260924050009.19974-9-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924050009.19974-1-sarthak.sharma@arm.com>
References: <20260924050009.19974-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 35E98A000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: dpsj6614tzqhq66aaqrirjszgr4padqx
X-HE-Tag: 1790226063-359694
X-HE-Meta: U2FsdGVkX1++EbMzS1LidtGQiQqAEpiEKtC4kMICMJ+krHXmlMpjlVLC6Z76vzvblyNj9Z2q0V9tpefVGhLRVhpjSicIJaGuMEl/Hc0kywCPkW5KfcHWFv6GdVtk081+trpeOYjWBAxdNz9fxZoHj9vJZrGkdcqBuQKZ74iNgVDLTtGu22y71lirqEhLIzROB2N6Fu66Xd8yoj0M/WzUbm1of4qWf669MC7xK3vOsFl74QBx+uw5JLMOS3L3AGUYG00ZGDJu9jd7CuYWHuTGDC8fGiozFXgyFvrggAUt5QgWwyVsFJcpp4k7os+ly+H/u7FFRtfZ4fOTuReTqwTYB21w1BY6d12AqO29EpKubxMaIvjec389T6I0M9jyiM2D7mnwdvkQY9gFFSEq/+Xa0Ho5dPL3tX2A6P0iH313PFG+hfQ7KUo8D0XvnWBHesSbzqTSO+eWRlSmoKzIR5BivIV4fMhFlfFje/1GO6PoYbS68KMHNtaqrq+f7OVZh3HRnj/jjqfb6rgIYHzLUSJXpMIC5RnQecGmDv0QIgTkNEtfVcNfRthjYaw46L01OGOyYA1AD4KCGh2rr3lw1d500Y9Sn+lUmJiYvpzE59IuNvMytvtLXksTc+TYOliSmP5KU7QlazpUfXFTx8JQYiPp3w06sa0YX20oazupGi026r9Z7RtKK5K/TOmajA2QVOPO6957H9+z331gAfvKX+0v82T//lE5Fmrg0M6keBn5E7eJlloS1y+KIeqyJdoe4RV6oQ9FZH2DWRBT5+kjOJZQMQERQbp9tttMRt83Zw6KPMsARAZ6c+VXNhen4M/bVRPghQNkr4SUd52Enacc3eOZf4z36OeMuwDbVE1DOO72uolHDeZ7dWKxpdtYMAuuAlgT7tf+4E/YMnXhwvzstuMKu43sqxNDFXLKqflbRXJkN2x2EDIu+7GWVkklwwC2XEoZ7sf4+QQWFql+UxK+qRB
 wUrl7LXR
 zmTzfA8uFBbZd0dndsWMI0p4aDzY+jJcfvuh7J7pYx9wN//wkkdmhlCW2LY8jdXsl2Borrsvg1MlpoAgFTUeyjvS40HjlKRk/VWBCq4O4BuCd1i6JCrNNNRKnN4pJ+0CkpYGdALFUJNqaUB2qUpeCEzrRZs9YkxPdS1wc5muZiQNIptOKtLFHA3YahDmKRTGW5M5v3mzRiP/Klq3gi/C1o2Y8IVD7vnW03AI8pAuG/kmrv6TLCTFJ30fWIMTpftEo76mQeyAMT18T34vR9s4mInD7Shr6mULBqr2AEQkfxeEz2I/+Qjmg7snQG+/DLgU5wS2Z
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


