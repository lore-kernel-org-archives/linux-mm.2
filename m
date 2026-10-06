Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F28DCA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:26:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 980B06B00B7; Tue,  6 Oct 2026 05:26:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 930D16B00B8; Tue,  6 Oct 2026 05:26:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F8136B00B9; Tue,  6 Oct 2026 05:26:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C1996B00B7
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:26:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA74C1402D5
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:26:20 +0000 (UTC)
X-FDA: 85291670520.26.3D117C5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2601120003
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:26:19 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=R5mntki4;
	spf=pass (imf31.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278779;
	b=gLWtEne0tYO2Lh5oHIKHvsBjwX+T/9xHr1aF3+Wr/d7btth0wViE3E3ciEoDFK4L3LTcp8
	sjjCKhEnOf5YxUz3rDhXbpPJ6kDSDTEJhHblLoyZnwyFTNnS/UO7A5evpQn0e7vC53VV++
	oQIR9jQAZjOSCAXprsUCJcREM5gzwN8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=R5mntki4;
	spf=pass (imf31.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rPV4IZm2Vmpf0qZrqYQyXGOvzPKBca1w6HK5G1HZJ2Q=;
	b=PJXjfOvblexeiXpl4hIZLz3MqBGJxmsxVBV0P0Ldfsk0sy9mOC7FeBNgn8ZO3pAl2j6l+x
	CBBkNHngTmPA1ZEMZI49DGEIv/mLxKGjH6VTZ7Xh6mRMkjWmzAF5tUGnk+XEsjZNtvwKRI
	M5PFXaaic106R9HIG6WOc7s5n8poWj4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1410E1477;
	Tue,  6 Oct 2026 02:26:15 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 310F93F763;
	Tue,  6 Oct 2026 02:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791278778; bh=pJ+209TiQQiiNctq0TEMZ94BSTkJsl6Vbrf/EOnTlSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5mntki4h3x+80JT2BSPURxECf2YX1XFQfBVqYrmGgTFwr11MsaSfm4bPvbxlFmis
	 cVTbQo8iYiomF4hqr3wr7JyENT7Gdpn9heyPkahTfOq3AWwQy9reFlEW5tlz75jYtw
	 pvrU7000Wbg5UZxUP2meXPzasowvLKxMZxW5LvXI=
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
Subject: [PATCH v2 11/12] selftests/mm: mremap_test: replace random data with deterministic pattern
Date: Tue,  6 Oct 2026 14:55:10 +0530
Message-ID: <20261006092511.145776-12-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261006092511.145776-1-sarthak.sharma@arm.com>
References: <20261006092511.145776-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2601120003
X-Stat-Signature: 7gbr7qdo7k8jyonc9rthwjnkswyp74kc
X-HE-Tag: 1791278779-209018
X-HE-Meta: U2FsdGVkX19l16ak6EUVqXJsGTqW81i/Fj4TCkDCkf2rwMpi/GiaKfpk23dcxE8+8loyTgqlZS0E+6AjI40Pb9mP/qAHc6xyxgsXWPr2EhB9EQ/FRydkAK6ZbL2l0FUZda9RRnS/XLEkx+/PcH9sW7rfRkUvNn0CA7qBYY+AeOzRrcNgw4eVVB2Ls4iDvkhfaf6clJG5Mz+JU/bkul4B6wPeYUoa03mWKM/ivc2R7s4B/rq0x92BreSgxxfZ5PnAD7Hrv08B629SEUkjnKr5DQZm4aN28Pli4NnlYZeQ441QkqHXulOO6gpVDe9HgyBLMgRSFn0aReZm15HInAK5RZ0pAvs8tn1TFDbp/XhryshEYB6i63k2hsrkkVlRaqNyxZ7uxO0ltkJPl870nu6hu7iOFeabkVq81WmBLDTrdsqQKaWcL2SO9C3Z6U/wI/QpSqo2GbQX0Ebpx3lFP4E6F3wMnbli+QtOB7i4h1KG2qyGoHN0i7AfA4N8B+xSFVpJKO6AM44VeVe+jR6cfHuessGdqCYiTOcnMriIs0x85fQwowult56IRp07WA63f+weEpecJe86ZltuoHm3JOaJbAeqTO85PeSl1OA8emVcga+tAj9P0qgIrzRZXrwFWXMTV4ky95QRBwIv8bvyS+MGOhrgJEEDq+SDFOlJr+fGsgjJfz1W4CoInZghkigLgOlzFCjhjsvnkikq0/0PUmmzgZvCFDBrZCrMj20oOne+Lo9Ub/Q/N/cnA+BSnNCHGeymMA117FmCFqiO1ZfckpXFedsCzPdufhRrUp9MBKASL5PTN9aG09GYpt8IMns9TnISXsPwKD8QfsG53xubNBdUa3XRkrzqybZDLJlS6nZIXz8C1HDsqfeDN2IQ2k0GCc6JMnzjkfRiFysEXbTGy8s9t8FKDPKSMd9WQQHkmu/iWYwBCR26gUtZatbkChZs+D3bTwV8kX2iiIqucJIsB7w
 9YAA5w41
 WnxGWu0zscUF/7KQuhjlc4fevwBXO4ZK2i2OHWRqtW/12ayKJd1plU56Dk9+zWZ95yNkHgQdOyiPToxqDyZ1e3VR0JcVSzPd/uerWKYP5Yr/EgbrqMQY9UzD41p8FGPeCpCtWo/HtZ377gL5D1puY0MiQauDVNHR7RqXsxqwr+OrN94GhwRtp1sRmulFe0HHCsHkKCagpB6ohcLZasah0+1R2mjaoycnVvG+/K0Kc8yL3L/jhv04b34NI/ljv+2VFh4xSPILc9iD7Ks1gDYg6Al7f8nC7MYVvEzLRqKHyx3xoK1uBxDyhcJ+adVNFrgrsxlpb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mremap_test uses a random data stream to detect corruption after remap
operations. This requires seed handling and byte by byte validation,
which is inefficient.

Replace it with a deterministic pattern where every word in a page
contains its one-based page index. Use memcpy() and memcmp() to
initialize and validate the mappings. Remove the pattern seed and
update the comment diagrams to reflect the new deterministic pattern.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 220 +++++++++--------------
 1 file changed, 85 insertions(+), 135 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 955727607d4f..92ffcbe547b5 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -13,8 +13,8 @@
 #include <sys/ioctl.h>
 #include <sys/mman.h>
 #include <syscall.h>
-#include <time.h>
 #include <stdbool.h>
+#include <stdint.h>
 
 #include "kselftest.h"
 
@@ -304,11 +304,11 @@ static void mremap_expand_merge_offset(FILE *maps_fp, unsigned long page_size)
  *
  * |DDDDddddSSSSssss|
  */
-static void mremap_move_within_range(unsigned int pattern_seed, char *rand_addr)
+static void mremap_move_within_range(char *pattern_addr)
 {
 	char *test_name = "mremap move within range";
 	void *src, *dest;
-	unsigned int i, success = 1;
+	unsigned int success = 1;
 
 	size_t size = SIZE_MB(20);
 	void *ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
@@ -324,7 +324,7 @@ static void mremap_move_within_range(unsigned int pattern_seed, char *rand_addr)
 	src = (void *)((unsigned long)src & ~(SIZE_MB(2) - 1));
 
 	/* Set byte pattern for source block. */
-	memcpy(src, rand_addr, SIZE_MB(2));
+	memcpy(src, pattern_addr + SIZE_MB(2), SIZE_MB(2));
 
 	dest = src - SIZE_MB(2);
 
@@ -337,17 +337,9 @@ static void mremap_move_within_range(unsigned int pattern_seed, char *rand_addr)
 	}
 
 	/* Verify byte pattern after remapping */
-	srand(pattern_seed);
-	for (i = 0; i < SIZE_MB(1); i++) {
-		char c = (char) rand();
-
-		if (((char *)src)[i] != c) {
-			ksft_print_msg("Data at src at %d got corrupted due to unrelated mremap\n",
-				       i);
-			ksft_print_msg("Expected: %#x\t Got: %#x\n", c & 0xff,
-					((char *) src)[i] & 0xff);
-			success = 0;
-		}
+	if (memcmp(src, pattern_addr + SIZE_MB(2), SIZE_MB(1))) {
+		ksft_print_msg("Source data was corrupted\n");
+		success = 0;
 	}
 
 out_unmap:
@@ -356,32 +348,24 @@ static void mremap_move_within_range(unsigned int pattern_seed, char *rand_addr)
 	ksft_test_result(success, "%s\n", test_name);
 }
 
-static bool is_multiple_vma_range_ok(unsigned int pattern_seed,
-				     char *ptr, unsigned long page_size)
+static bool is_multiple_vma_range_ok(char *pattern_addr, char *ptr,
+				     unsigned long page_size)
 {
-	int i;
-
-	srand(pattern_seed);
-	for (i = 0; i <= 10; i += 2) {
-		int j;
-		char *buf = &ptr[i * page_size];
+	for (int i = 0; i <= 10; i += 2) {
 		size_t size = i == 4 ? 2 * page_size : page_size;
 
-		for (j = 0; j < size; j++) {
-			char chr = rand();
-
-			if (chr != buf[j]) {
-				ksft_print_msg("page %d offset %d corrupted, expected %d got %d\n",
-					       i, j, chr, buf[j]);
-				return false;
-			}
+		if (memcmp(ptr + i * page_size, pattern_addr + i * page_size,
+			   size)) {
+			ksft_print_msg("Data in VMA starting at page %d got corrupted\n",
+				       i);
+			return false;
 		}
 	}
 
 	return true;
 }
 
-static void mremap_move_multiple_vmas(unsigned int pattern_seed,
+static void mremap_move_multiple_vmas(char *pattern_addr,
 				      unsigned long page_size,
 				      bool dont_unmap)
 {
@@ -416,13 +400,15 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
 		goto out_unmap;
 	}
 
+	memcpy(ptr, pattern_addr, size);
+
 	/*
 	 * Unmap so we end up with:
 	 *
 	 *  0   2   4 5 6   8   10 offset in buffer
 	 * |*| |*| |*****| |*| |*|
 	 * |*| |*| |*****| |*| |*|
-	 *  0   1   2 3 4   5   6  pattern offset
+	 *  0   2   4 5 6   8   10  pattern offset
 	 */
 	for (i = 1; i < 10; i += 2) {
 		if (i == 5)
@@ -435,18 +421,6 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
 		}
 	}
 
-	srand(pattern_seed);
-
-	/* Set up random patterns. */
-	for (i = 0; i <= 10; i += 2) {
-		int j;
-		size_t size = i == 4 ? 2 * page_size : page_size;
-		char *buf = &ptr[i * page_size];
-
-		for (j = 0; j < size; j++)
-			buf[j] = rand();
-	}
-
 	/* First, just move the whole thing. */
 	if (mremap(ptr, size, size, mremap_flags, tgt_ptr) == MAP_FAILED) {
 		ksft_perror("mremap");
@@ -454,7 +428,7 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
 		goto out_unmap;
 	}
 	/* Check move was ok. */
-	if (!is_multiple_vma_range_ok(pattern_seed, tgt_ptr, page_size)) {
+	if (!is_multiple_vma_range_ok(pattern_addr, tgt_ptr, page_size)) {
 		success = false;
 		goto out_unmap;
 	}
@@ -467,7 +441,7 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
 		goto out_unmap;
 	}
 	/* Check that the move is ok. */
-	if (!is_multiple_vma_range_ok(pattern_seed, &tgt_ptr[size], page_size)) {
+	if (!is_multiple_vma_range_ok(pattern_addr, &tgt_ptr[size], page_size)) {
 		success = false;
 		goto out_unmap;
 	}
@@ -487,7 +461,7 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
 		goto out_unmap;
 	}
 	/* Check that the move is ok. */
-	if (!is_multiple_vma_range_ok(pattern_seed, tgt_ptr, page_size)) {
+	if (!is_multiple_vma_range_ok(pattern_addr, tgt_ptr, page_size)) {
 		success = false;
 		goto out_unmap;
 	}
@@ -573,7 +547,7 @@ static void mremap_shrink_multiple_vmas(unsigned long page_size,
 	ksft_test_result(success, "%s%s\n", test_name, inplace ? " [inplace]" : "");
 }
 
-static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
+static void mremap_move_multiple_vmas_split(char *pattern_addr,
 					    unsigned long page_size,
 					    bool dont_unmap)
 {
@@ -608,13 +582,15 @@ static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
 		goto out_unmap;
 	}
 
+	memcpy(ptr, pattern_addr, size);
+
 	/*
 	 * Unmap so we end up with:
 	 *
 	 *  0 1 2 3 4 5 6 7 8 9 10 offset in buffer
 	 * |**********| |*******|
 	 * |**********| |*******|
-	 *  0 1 2 3 4   5 6 7 8 9  pattern offset
+	 *  0 1 2 3 4 5 6 7 8 9 10 pattern offset
 	 */
 	if (munmap(&ptr[5 * page_size], page_size)) {
 		ksft_perror("munmap");
@@ -622,19 +598,6 @@ static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
 		goto out_unmap;
 	}
 
-	/* Set up random patterns. */
-	srand(pattern_seed);
-	for (i = 0; i < 10; i++) {
-		int j;
-		char *buf = &ptr[i * page_size];
-
-		if (i == 5)
-			continue;
-
-		for (j = 0; j < page_size; j++)
-			buf[j] = rand();
-	}
-
 	/*
 	 * Move the below:
 	 *
@@ -642,14 +605,14 @@ static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
 	 *  0 1 2 3 4 5 6 7 8 9 10 offset in buffer
 	 * |**********| |*******|
 	 * |**********| |*******|
-	 *  0 1 2 3 4   5 6 7 8 9  pattern offset
+	 *  0 1 2 3 4 5 6 7 8 9 10  pattern offset
 	 *
 	 * Into:
 	 *
 	 * 0 1 2 3 4 5 6 7 offset in buffer
 	 * |*****| |*****|
 	 * |*****| |*****|
-	 * 2 3 4   5 6 7   pattern offset
+	 * 2 3 4 5 6 7 8 9 pattern offset
 	 */
 	if (mremap(&ptr[2 * page_size], size - 3 * page_size, size - 3 * page_size,
 		   mremap_flags, tgt_ptr) == MAP_FAILED) {
@@ -658,28 +621,16 @@ static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
 		goto out_unmap;
 	}
 
-	/* Offset into random pattern. */
-	srand(pattern_seed);
-	for (i = 0; i < 2 * page_size; i++)
-		rand();
-
 	/* Check pattern. */
 	for (i = 0; i < 7; i++) {
-		int j;
-		char *buf = &tgt_ptr[i * page_size];
-
 		if (i == 3)
 			continue;
 
-		for (j = 0; j < page_size; j++) {
-			char chr = rand();
-
-			if (chr != buf[j]) {
-				ksft_print_msg("page %d offset %d corrupted, expected %d got %d\n",
-					       i, j, chr, buf[j]);
-				success = false;
-				goto out_unmap;
-			}
+		if (memcmp(tgt_ptr + i * page_size,
+			   pattern_addr + (i + 2) * page_size, page_size)) {
+			ksft_print_msg("Data in page %d got corrupted\n", i + 2);
+			success = false;
+			goto out_unmap;
 		}
 	}
 
@@ -958,11 +909,12 @@ static bool validate_test_data(char *addr, size_t size, char *pattern_addr,
 	       !memcmp(addr + end, pattern_addr + 2 * len, len);
 }
 
-static int remap_region(struct config c, char *rand_addr, size_t rand_size,
+static int remap_region(struct config c, char *pattern_addr, size_t pattern_size,
 		size_t page_size)
 {
 	void *addr, *tmp_addr, *src_addr, *dest_addr, *dest_preamble_addr = NULL;
 	long long align_mask, offset;
+	char *preamble_pattern = NULL;
 	int ret = 0;
 
 	src_addr = get_source_mapping(c);
@@ -972,7 +924,8 @@ static int remap_region(struct config c, char *rand_addr, size_t rand_size,
 	}
 
 	/* Set byte pattern for source block. */
-	populate_test_data(src_addr, c.region_size, rand_addr, rand_size, page_size);
+	populate_test_data(src_addr, c.region_size, pattern_addr,
+			   pattern_size, page_size);
 
 	/* Mask to zero out lower bits of address for alignment */
 	align_mask = ~(c.dest_alignment - 1);
@@ -1012,8 +965,9 @@ static int remap_region(struct config c, char *rand_addr, size_t rand_size,
 			goto clean_up_src;
 		}
 
+		preamble_pattern = pattern_addr + pattern_size - c.dest_preamble_size;
 		/* Set byte pattern for the dest preamble block. */
-		memcpy(dest_preamble_addr, rand_addr, c.dest_preamble_size);
+		memcpy(dest_preamble_addr, preamble_pattern, c.dest_preamble_size);
 	}
 
 	dest_addr = mremap(src_addr, c.region_size, c.region_size,
@@ -1026,8 +980,8 @@ static int remap_region(struct config c, char *rand_addr, size_t rand_size,
 	}
 
 	/* Verify byte pattern after remapping */
-	if (!validate_test_data(dest_addr, c.region_size, rand_addr,
-				rand_size, page_size)) {
+	if (!validate_test_data(dest_addr, c.region_size, pattern_addr,
+				pattern_size, page_size)) {
 		ksft_print_msg("Data after remap doesn't match\n");
 		ret = -1;
 		goto clean_up_dest;
@@ -1035,7 +989,7 @@ static int remap_region(struct config c, char *rand_addr, size_t rand_size,
 
 	/* Verify the dest preamble byte pattern after remapping */
 	if (c.dest_preamble_size &&
-	    memcmp(dest_preamble_addr, rand_addr, c.dest_preamble_size)) {
+	    memcmp(dest_preamble_addr, preamble_pattern, c.dest_preamble_size)) {
 		ksft_print_msg("Preamble data after remap doesn't match\n");
 		ret = -1;
 		goto clean_up_dest;
@@ -1057,12 +1011,11 @@ static int remap_region(struct config c, char *rand_addr, size_t rand_size,
  * the beginning of the mapping just because the aligned
  * down address landed on a mapping that maybe does not exist.
  */
-static void mremap_move_1mb_from_start(unsigned int pattern_seed,
-				       char *rand_addr)
+static void mremap_move_1mb_from_start(char *pattern_addr)
 {
 	char *test_name = "mremap move 1mb from start at 1MB+256KB aligned src";
 	void *src = NULL, *dest = NULL;
-	unsigned int i, success = 1;
+	unsigned int success = 1;
 
 	/* Config to reuse get_source_mapping() to do an aligned mmap. */
 	struct config c = {
@@ -1084,7 +1037,7 @@ static void mremap_move_1mb_from_start(unsigned int pattern_seed,
 	}
 
 	/* Set byte pattern for source block. */
-	memcpy(src, rand_addr, SIZE_MB(2));
+	memcpy(src, pattern_addr, SIZE_MB(2));
 
 	/*
 	 * Unmap the beginning of dest so that the aligned address
@@ -1101,17 +1054,9 @@ static void mremap_move_1mb_from_start(unsigned int pattern_seed,
 	}
 
 	/* Verify byte pattern after remapping */
-	srand(pattern_seed);
-	for (i = 0; i < SIZE_MB(1); i++) {
-		char c = (char) rand();
-
-		if (((char *)src)[i] != c) {
-			ksft_print_msg("Data at src at %d got corrupted due to unrelated mremap\n",
-				       i);
-			ksft_print_msg("Expected: %#x\t Got: %#x\n", c & 0xff,
-					((char *) src)[i] & 0xff);
-			success = 0;
-		}
+	if (memcmp(src, pattern_addr, SIZE_MB(1))) {
+		ksft_print_msg("Data before the remapped range was corrupted\n");
+		success = 0;
 	}
 
 out:
@@ -1125,11 +1070,11 @@ static void mremap_move_1mb_from_start(unsigned int pattern_seed,
 }
 
 static void run_mremap_test_case(struct test test_case,
-				 char *rand_addr,
-				 size_t rand_size,
+				 char *pattern_addr,
+				 size_t pattern_size,
 				 size_t page_size)
 {
-	int ret = remap_region(test_case.config, rand_addr, rand_size, page_size);
+	int ret = remap_region(test_case.config, pattern_addr, pattern_size, page_size);
 
 	if (ret < 0) {
 		if (test_case.expect_failure)
@@ -1146,47 +1091,52 @@ static void run_mremap_test_case(struct test test_case,
 	}
 }
 
+static void fill_pattern(char *pattern_addr, size_t pattern_size, size_t page_size)
+{
+	size_t nr_pages = pattern_size / page_size;
+	size_t words_per_page = page_size / sizeof(uint32_t);
+	size_t page, word;
+
+	for (page = 0; page < nr_pages; page++) {
+		uint32_t *page_addr = (uint32_t *)pattern_addr + page * words_per_page;
+		uint32_t val = page + 1;
+
+		for (word = 0; word < words_per_page; word++)
+			page_addr[word] = val;
+	}
+}
+
 #define MAX_TEST 15
 int main(void)
 {
 	unsigned int i;
 
-	unsigned int pattern_seed;
-	char *rand_addr;
-	size_t rand_size;
+	char *pattern_addr;
+	size_t pattern_size;
 	int num_expand_tests = 2;
 	int num_misc_tests = 9;
 	struct test test_cases[MAX_TEST] = {};
 	int page_size;
-	time_t t;
 	FILE *maps_fp;
 
 	ksft_print_header();
 
 	get_mmap_min_addr();
 
-	pattern_seed = (unsigned int) time(&t);
-
-	ksft_print_msg("Test configs:\n");
-	ksft_print_msg("pattern_seed=%u\n", pattern_seed);
-
 	/*
-	 * The 40MB destination preamble determines the random buffer size
+	 * The 40MB destination preamble determines the pattern buffer size
 	 */
-	rand_size = 10 * _4MB;
+	pattern_size = 10 * _4MB;
 
-	rand_addr = (char *)mmap(NULL, rand_size, PROT_READ | PROT_WRITE,
-				 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-	if (rand_addr == MAP_FAILED)
-		ksft_exit_fail_perror("cannot mmap rand_addr");
-
-	/* fill stream of random bytes */
-	srand(pattern_seed);
-	for (unsigned long i = 0; i < rand_size; ++i)
-		rand_addr[i] = (char) rand();
+	pattern_addr = (char *)mmap(NULL, pattern_size, PROT_READ | PROT_WRITE,
+				    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (pattern_addr == MAP_FAILED)
+		ksft_exit_fail_perror("cannot mmap pattern_addr");
 
 	page_size = sysconf(_SC_PAGESIZE);
 
+	fill_pattern(pattern_addr, pattern_size, page_size);
+
 	/* Expected mremap failures */
 	test_cases[0] =	MAKE_TEST(page_size, page_size, page_size,
 				  OVERLAPPING, EXPECT_FAILURE,
@@ -1240,31 +1190,31 @@ int main(void)
 	ksft_set_plan(ARRAY_SIZE(test_cases) + num_expand_tests + num_misc_tests);
 
 	for (i = 0; i < ARRAY_SIZE(test_cases); i++)
-		run_mremap_test_case(test_cases[i], rand_addr, rand_size, page_size);
+		run_mremap_test_case(test_cases[i], pattern_addr, pattern_size, page_size);
 
 	maps_fp = fopen("/proc/self/maps", "r");
 
 	if (maps_fp == NULL) {
-		munmap(rand_addr, rand_size);
+		munmap(pattern_addr, pattern_size);
 		ksft_exit_fail_msg("Failed to read /proc/self/maps: %s\n", strerror(errno));
 	}
 
 	mremap_expand_merge(maps_fp, page_size);
 	mremap_expand_merge_offset(maps_fp, page_size);
 
-	mremap_move_within_range(pattern_seed, rand_addr);
-	mremap_move_1mb_from_start(pattern_seed, rand_addr);
+	mremap_move_within_range(pattern_addr);
+	mremap_move_1mb_from_start(pattern_addr);
 	mremap_shrink_multiple_vmas(page_size, /* inplace= */true);
 	mremap_shrink_multiple_vmas(page_size, /* inplace= */false);
-	mremap_move_multiple_vmas(pattern_seed, page_size, /* dontunmap= */ false);
-	mremap_move_multiple_vmas(pattern_seed, page_size, /* dontunmap= */ true);
-	mremap_move_multiple_vmas_split(pattern_seed, page_size, /* dontunmap= */ false);
-	mremap_move_multiple_vmas_split(pattern_seed, page_size, /* dontunmap= */ true);
+	mremap_move_multiple_vmas(pattern_addr, page_size, /* dontunmap= */ false);
+	mremap_move_multiple_vmas(pattern_addr, page_size, /* dontunmap= */ true);
+	mremap_move_multiple_vmas_split(pattern_addr, page_size, /* dontunmap= */ false);
+	mremap_move_multiple_vmas_split(pattern_addr, page_size, /* dontunmap= */ true);
 	mremap_move_multi_invalid_vmas(maps_fp, page_size);
 
 	fclose(maps_fp);
 
-	munmap(rand_addr, rand_size);
+	munmap(pattern_addr, pattern_size);
 
 	ksft_finished();
 }
-- 
2.53.0


