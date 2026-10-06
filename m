Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3144CA5FFF
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:26:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B061D6B00B5; Tue,  6 Oct 2026 05:26:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6976B00B6; Tue,  6 Oct 2026 05:26:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CCD46B00B7; Tue,  6 Oct 2026 05:26:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 676C66B00B5
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:26:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EEF958059E
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:26:15 +0000 (UTC)
X-FDA: 85291670310.16.29ACFBC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 480631A0008
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:26:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OsSUmiTW;
	spf=pass (imf19.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278774;
	b=SAGTauv7OHWxFs4MqwtYKSoYmvYByrB0fM/a2JJ5HrE72EL7e+s2EgEsh+w47yxnjTIN4q
	SMD3u4e8xslWZFrhjkf6EcYPWQy/2XiOP0fmnLjXAPrW8JNv2E2zCiEHtBhsYCanwuxgGo
	NMgwQoz55koak1S70+VCbQFh02Xry+E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OsSUmiTW;
	spf=pass (imf19.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ihwr8kpD8cWWHWEwyiz2ACmgGU8R+vR1Q+hnxctAx0k=;
	b=u7BydXyQ8DydNAMcysNhivWSVWpTPQQszCiUi5tryyC/0LZOdpEv8nxcRw3Go8AHmKQqqw
	bRlEmv5vuLUrLgAUogrUS7qr7+6/zdQiIezJ890lSwIvIm/CLQOQCMep3ANQ6EXM45DaqB
	izXJjz99lWXLj+rU9C56A2YD+XQQtWY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44F1F1516;
	Tue,  6 Oct 2026 02:26:10 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 61CDC3F763;
	Tue,  6 Oct 2026 02:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791278773; bh=rtU2KV+C2LJM94PpPVfMUATGPARc0j4tBVn8FCLi9sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OsSUmiTWYDfihVuU14mK0sLXi4q3ABzwXK3CWDKWHH4vntIQIljzoIWfOUi5LZPlI
	 xFBC3Jg/3Vo9XBSgBDXhXHjauNJTNCs5SGukw/U8QAvfItC4XIRO45gb+AGHZxLCcf
	 4AP2H9Tr8FaXosh5QxocOPDDDPGBzh9riUCgr6YM=
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
Subject: [PATCH v2 10/12] selftests/mm: mremap_test: replace validation threshold with sampled checks
Date: Tue,  6 Oct 2026 14:55:09 +0530
Message-ID: <20261006092511.145776-11-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261006092511.145776-1-sarthak.sharma@arm.com>
References: <20261006092511.145776-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 480631A0008
X-Rspam-User: 
X-Stat-Signature: 8trq1oywebjz68c5hceifyw74z6gs458
X-HE-Tag: 1791278774-613494
X-HE-Meta: U2FsdGVkX18N62g/U0wN3cXCqjiTQhWZYkSEXZYtHRhCXidqknoSjJ3mTgzStuRLVONZNKIU2gGouupcyNxXMksYPJiObC/0DblDK9Gr09N01m5qtsMy8RQWrgzJ1gYXMt75Sw9fc/0gsrhH0uEAxpMiuHadpKA6eB4Qf1g2wQ8glPUnDexAXxvTY4jcupRvRD3gAd2YgRm3PkOEJt7o3FSn6Js9K1Lxb3omrR4j7sQScjnCV0BwyvAfwYBkGeeQog0Agb8lP1kx6x0Y5OTBBSvx3ZOq28wGuYn0dhf5kIZVcRRRjXlruv7vqc0/39HFyD2vfiAN4cok4j9xHROfEiyuiu4y3uGfjysWcdKOUPtcUqCcYvgSs7NTdw5KA5wSROmysslRKo9dkHfNPc0UI+dJqijh7wpwQi0qlqC4LiufXr26+9mqS4hdAyu1eueyhiQquELbCnYo5W52dBwE18hiOvDi3RQVyMLNNewNc4A15lOdybbBB1JFVqlAsP1UnTE+Ncv5vB+kF0vbukN8qfH/ShWIuSW/dOjNhrFbiaF7hZhe5/fuumFBeN4r/mjjNzCPxY5ouqVg5N66r5NbLVdX/MyTDytE/7BIel+i5IJI9MPlOiiN3UU9PDYyVA4paG2EsTYLyfRQHg23XOzFLBlyG2jO0IJEaQKL4tMel6EQRvwRwg0iNWdG1ea8+E9AzQu/BzNO5Y+DzuQoW5isTQpirhkyGRBa47WKfxSw8TXecgJqpFpeGLwk869ovcwpswDrteEMqDxJQHoSDyaXL7W4u8hbVZfxMe1yQ4shLquzWVCWRga08Cqy9QGwZx4vVTRfay/nGo5on1R2xXmOzD2LXyM4w0IHDYCGOfZG/d2ygjvtA82B8o5gopWhLejKCeHVBa4NXc28isTjZifbCFXm02iKQAXiv8Hs8INrqAjG2shc/m16GzBtJXOWs2n3G1V/arpzh0LoTuX0ZNI
 aVFQHbMG
 tzKTe9qNKU3KjDKuDkoq/PuZiXyX5GWAx9gnbv9zJUyY82HW7eyHkbrDP0cVqEb7mfVeLCoH0hYOXdSw/++VO/cy7kZjK4LaMQm/fqHDBuWbOtSYBa9iYI+n+uZ8GIN9X6JCFK63QdPqIR32sPu7wo0EI2WYylmGkSCVOxkOAsfx4iPdQ4uJ0Pfrtb7vnhA/3NGuHTn09weVV02djuqMHEt5lr+1qGKRALcp0SolXIPPBgyzyNC0mipc2r5wHD+lGnER6NMCvaWgbmesMzeVxEGfvOmzAMbPHCLMgkG+zvjm4o+ETv85sX1Ygbzx+P+aIzxZj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index 403c5495e160..955727607d4f 100644
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
@@ -1002,7 +1026,8 @@ static int remap_region(struct config c, unsigned int threshold_mb,
 	}
 
 	/* Verify byte pattern after remapping */
-	if (memcmp(dest_addr, rand_addr, threshold)) {
+	if (!validate_test_data(dest_addr, c.region_size, rand_addr,
+				rand_size, page_size)) {
 		ksft_print_msg("Data after remap doesn't match\n");
 		ret = -1;
 		goto clean_up_dest;
@@ -1100,10 +1125,11 @@ static void mremap_move_1mb_from_start(unsigned int pattern_seed,
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
@@ -1124,12 +1150,6 @@ static void run_mremap_test_case(struct test test_case,
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
@@ -1148,21 +1168,12 @@ int main(void)
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
@@ -1229,7 +1240,7 @@ int main(void)
 	ksft_set_plan(ARRAY_SIZE(test_cases) + num_expand_tests + num_misc_tests);
 
 	for (i = 0; i < ARRAY_SIZE(test_cases); i++)
-		run_mremap_test_case(test_cases[i], threshold_mb, rand_addr);
+		run_mremap_test_case(test_cases[i], rand_addr, rand_size, page_size);
 
 	maps_fp = fopen("/proc/self/maps", "r");
 
-- 
2.53.0


