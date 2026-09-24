Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11FFEC98304
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 05:00:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B99806B009D; Thu, 24 Sep 2026 01:00:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B231A6B009E; Thu, 24 Sep 2026 01:00:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C38B6B009F; Thu, 24 Sep 2026 01:00:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A0086B009D
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 01:00:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E56651A0217
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:00:55 +0000 (UTC)
X-FDA: 85247456070.18.95C0BB9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 020D2A000A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:00:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="h/TrDPNj";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790226054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KpZN6dfuk3XUkno2/1EActcxQguzJewdHf2HB01Bodw=;
	b=jJyMvfd7Cr3UEOoZNApxO14fkpwK6HRtsNlzksgxDRI8Lnn0MEqBj6n/m1C8gQahfbRjDb
	vAShj19x/79dwS61lt6ANC4euzVcOyI+Fw9vJeJ235iTi7ANI/0dFTmDfg4AdhQ8DjqeX5
	JnzuhocmX1B2Rw9XSKNROuueiWjC3qw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="h/TrDPNj";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790226054;
	b=5gMyqrUoUTBaaLz/x9QF/8vSGcTAtwhMXKAcc5KjhTP2M5gSOiMK2KNv/nDUFmUckQTrR4
	R4e1BJABX5OIFlmRCoLQw44itGnxlwswlF7IgD6YIGmFyV3uUvvixWWa1bsjo0Cwzr8R5p
	iqW/gdfy01jCOpihkc/4NsDYDPRhsgk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4BB52152B;
	Wed, 23 Sep 2026 22:00:49 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DFCE33F86C;
	Wed, 23 Sep 2026 22:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790226052; bh=2cBUq/RyqEl4FzDlVIUl5oTNJJOUqwf4dolbxhXqgjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/TrDPNj0hljjPhrR4BnFfBuYIzT73Til+wVHNZKASNH+lHFqQr0AUXkqdSRCNxPY
	 9+0vDMnwT5O3/h34o7HfHqO8x591fMXT9Rb7tN8VhwRsz7thZhtSKhhsiT4xbSPHZG
	 oye8UFPY279A+1mwKzIRTYef1htfqW/gkhN2KZTE=
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
Subject: [PATCH RESEND 6/9] selftests/mm: mremap_test: replace random data with deterministic pattern
Date: Thu, 24 Sep 2026 10:30:06 +0530
Message-ID: <20260924050009.19974-7-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924050009.19974-1-sarthak.sharma@arm.com>
References: <20260924050009.19974-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 020D2A000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: km51p3c7r7t97476zizfa8mzmipnkbsh
X-HE-Tag: 1790226053-48808
X-HE-Meta: U2FsdGVkX19hjPNaiQYgzsNjaxeWqkFi+UyfApYPiKGVKYsEncm0pwKki/c8Vr9O8X4HM8jDkgeOUbdzuYE/geV5zdrZkgBIyOjm0RWvUcWNI3NjrSwVFhdV4UQoZZBg/QdKNu6RL1DcGHnBX2dy/WqDmoyoIhc/MCISwwcxkmoaWXui8OYgu17DJO71gws77NhwA6Jz90/GRW/YURpJF/VXW5ZSbhog6WbQeCTsxusSEscN3QNOkTPmGmpaAd/TDC+1npMbaGUp0g3WB4lcZALtbjWygecBddej26AwUvpV60afTh+2FH51T3n7XarWVh6PbfWN3qTdLcF1ENtrp+yN5ll+UMI/F15Brm6zK1Ae1ueN0WmQiE8TqFjfNXUUKmFUNI0IhRGD4HxDL5DIpYz8h8R36+HYGWe806A37R6xuWf044qSkRJ24OnYCbyL4FdspiTkd8TisLzC9wqkJ2uFteGDBwBbK9bsZRM+keRZ9TkpZfQYwO7IKLL8Ynaw0sbmz8GhBqHhI11awkiGPKIyP5HkeCuf5r3jjW0VAKh5iHVqbaccuVQP4SQV0CsDNxn8KCYh7WqrBlrznBQGHkdqtJHZnqShT+SxERX6vwF6AKTUK/feIq98mj+XwiBu9oNBmGr94cbjFlpDGmZpSorOIAhN4wSPI51kXpXYHVQsBxhWKDRVlNU2TkOYrBoYUpu+ByDyelLRBRBWcXHzZ4V9OnPVnAUz/q/YPOCBTnmbwGB3MeXLkucp6kQFYgrbQ6WFLcVDX2oebHFBwdcfeA4N+0TQHwRWwyriYA5YHW5ay8DR/+1+SiEq/K1s45MfjekkE0mjS4J0YixaBP/kJBYPsoA81+fQ6LCdJBjUO10BzA3cGlbx5qz5i7MojGiWhjy4+F3ABGZSGSvB4nzkrWfArpnY1I6xqs0diFsdstRMui5SeEg2QnDPMV7tmLC7+GmWLsL2QwGvZMUeAAJ
 Y5Se3oRm
 1Y7PJSc+iq/fV6MF5Ym3teyTT9c+XLsuXbjnk6dOpqbfDG9xu6L0F41DtPNfoYxkXXxfmGkrxkudMqotQJkvQSSlHIUImus0CALgyxx0GMX7xkhw+uJolrusQ9kQ5Ev5hd/3yxJzAqgWbQYNmADMH5wLAebZnmm2gnl84uOzjWT8jw5qSr9N4EU/h0pbEHlAVIQ9+YM/agoElLXCsJCDwaWcp7VZGprOU+ZMCCCVx62rD3gfxYB9XvbMdavMhuMrbI5JrrG2DK6PVHpHGWQeU2MbiAi+J6kSfDPryzl1L7X3ffIEfo0lXzarHt+TXVeGEe32T
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
its command line option. Also update the comment diagrams to
reflect the new deterministic pattern.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 251 +++++++++--------------
 1 file changed, 95 insertions(+), 156 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 3b42c4f2473c..7b4c9ab3bf14 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -15,6 +15,7 @@
 #include <syscall.h>
 #include <time.h>
 #include <stdbool.h>
+#include <stdint.h>
 
 #include "kselftest.h"
 
@@ -61,6 +62,9 @@ enum {
 	PUD = _1GB,
 };
 
+static uint32_t *pattern;
+static size_t pattern_size;
+
 #define PTE page_size
 
 #define MAKE_TEST(source_align, destination_align, size,	\
@@ -311,11 +315,11 @@ static void mremap_expand_merge_offset(FILE *maps_fp, unsigned long page_size)
  *
  * |DDDDddddSSSSssss|
  */
-static void mremap_move_within_range(unsigned int pattern_seed, char *rand_addr)
+static void mremap_move_within_range(void)
 {
 	char *test_name = "mremap move within range";
 	void *src, *dest;
-	unsigned int i, success = 1;
+	unsigned int success = 1;
 
 	size_t size = SIZE_MB(20);
 	void *ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
@@ -331,12 +335,12 @@ static void mremap_move_within_range(unsigned int pattern_seed, char *rand_addr)
 	src = (void *)((unsigned long)src & ~(SIZE_MB(2) - 1));
 
 	/* Set byte pattern for source block. */
-	memcpy(src, rand_addr, SIZE_MB(2));
+	memcpy(src, (char *)pattern + SIZE_MB(2), SIZE_MB(2));
 
 	dest = src - SIZE_MB(2);
 
 	void *new_ptr = mremap(src + SIZE_MB(1), SIZE_MB(1), SIZE_MB(1),
-						   MREMAP_MAYMOVE | MREMAP_FIXED, dest + SIZE_MB(1));
+			       MREMAP_MAYMOVE | MREMAP_FIXED, dest + SIZE_MB(1));
 	if (new_ptr == MAP_FAILED) {
 		ksft_perror("mremap");
 		success = 0;
@@ -344,17 +348,9 @@ static void mremap_move_within_range(unsigned int pattern_seed, char *rand_addr)
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
+	if (memcmp(src, (char *)pattern + SIZE_MB(2), SIZE_MB(1))) {
+		ksft_print_msg("Source data was corrupted\n");
+		success = 0;
 	}
 
 out:
@@ -364,37 +360,27 @@ static void mremap_move_within_range(unsigned int pattern_seed, char *rand_addr)
 	ksft_test_result(success, "%s\n", test_name);
 }
 
-static bool is_multiple_vma_range_ok(unsigned int pattern_seed,
-				     char *ptr, unsigned long page_size)
+static bool is_multiple_vma_range_ok(char *ptr, unsigned long page_size)
 {
 	int i;
 
-	srand(pattern_seed);
 	for (i = 0; i <= 10; i += 2) {
-		int j;
-		char *buf = &ptr[i * page_size];
 		size_t size = i == 4 ? 3 * page_size : page_size;
 
 		if (i == 6)
 			continue;
 
-		for (j = 0; j < size; j++) {
-			char chr = rand();
-
-			if (chr != buf[j]) {
-				ksft_print_msg("page %d offset %d corrupted, expected %d got %d\n",
-					       i, j, chr, buf[j]);
-				return false;
-			}
+		if (memcmp(ptr + i * page_size, (char *)pattern + i * page_size,
+			   size)) {
+			ksft_print_msg("Data in VMA starting at page %d got corrupted\n",
+				       i);
+			return false;
 		}
 	}
-
 	return true;
 }
 
-static void mremap_move_multiple_vmas(unsigned int pattern_seed,
-				      unsigned long page_size,
-				      bool dont_unmap)
+static void mremap_move_multiple_vmas(unsigned long page_size, bool dont_unmap)
 {
 	int mremap_flags = MREMAP_FIXED | MREMAP_MAYMOVE;
 	char *test_name = "mremap move multiple vmas";
@@ -427,13 +413,15 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
 		goto out_unmap;
 	}
 
+	memcpy(ptr, pattern, size);
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
@@ -446,18 +434,6 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
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
@@ -465,7 +441,7 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
 		goto out_unmap;
 	}
 	/* Check move was ok. */
-	if (!is_multiple_vma_range_ok(pattern_seed, tgt_ptr, page_size)) {
+	if (!is_multiple_vma_range_ok(tgt_ptr, page_size)) {
 		success = false;
 		goto out_unmap;
 	}
@@ -478,7 +454,7 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
 		goto out_unmap;
 	}
 	/* Check that the move is ok. */
-	if (!is_multiple_vma_range_ok(pattern_seed, &tgt_ptr[size], page_size)) {
+	if (!is_multiple_vma_range_ok(&tgt_ptr[size], page_size)) {
 		success = false;
 		goto out_unmap;
 	}
@@ -498,7 +474,7 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
 		goto out_unmap;
 	}
 	/* Check that the move is ok. */
-	if (!is_multiple_vma_range_ok(pattern_seed, tgt_ptr, page_size)) {
+	if (!is_multiple_vma_range_ok(tgt_ptr, page_size)) {
 		success = false;
 		goto out_unmap;
 	}
@@ -587,8 +563,7 @@ static void mremap_shrink_multiple_vmas(unsigned long page_size,
 	ksft_test_result(success, "%s%s\n", test_name, inplace ? " [inplace]" : "");
 }
 
-static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
-					    unsigned long page_size,
+static void mremap_move_multiple_vmas_split(unsigned long page_size,
 					    bool dont_unmap)
 {
 	char *test_name = "mremap move multiple vmas split";
@@ -622,13 +597,15 @@ static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
 		goto out_unmap;
 	}
 
+	memcpy(ptr, pattern, size);
+
 	/*
 	 * Unmap so we end up with:
 	 *
 	 *  0 1 2 3 4 5 6 7 8 9 10 offset in buffer
 	 * |**********| |*******|
 	 * |**********| |*******|
-	 *  0 1 2 3 4   5 6 7 8 9  pattern offset
+	 *  0 1 2 3 4 5 6 7 8 9 10  pattern offset
 	 */
 	if (munmap(&ptr[5 * page_size], page_size)) {
 		ksft_perror("munmap");
@@ -636,19 +613,6 @@ static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
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
@@ -656,14 +620,14 @@ static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
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
@@ -672,28 +636,16 @@ static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
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
+			   (char *)pattern + (i + 2) * page_size, page_size)) {
+			ksft_print_msg("Data in page %d got corrupted\n", i + 2);
+			success = false;
+			goto out_unmap;
 		}
 	}
 
@@ -946,13 +898,13 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp, unsigned long page_siz
 #endif /* __NR_userfaultfd */
 
 /* Returns the time taken for the remap on success else returns -1. */
-static long long remap_region(struct config c, unsigned int threshold_mb,
-			      char *rand_addr)
+static long long remap_region(struct config c, unsigned int threshold_mb)
 {
 	void *addr, *tmp_addr, *src_addr, *dest_addr, *dest_preamble_addr = NULL;
 	struct timespec t_start = {0, 0}, t_end = {0, 0};
 	long long  start_ns, end_ns, align_mask, ret, offset;
 	unsigned long long threshold;
+	char *preamble_pattern;
 
 	if (threshold_mb == VALIDATION_NO_THRESHOLD)
 		threshold = c.region_size;
@@ -966,7 +918,7 @@ static long long remap_region(struct config c, unsigned int threshold_mb,
 	}
 
 	/* Set byte pattern for source block. */
-	memcpy(src_addr, rand_addr, threshold);
+	memcpy(src_addr, pattern, threshold);
 
 	/* Mask to zero out lower bits of address for alignment */
 	align_mask = ~(c.dest_alignment - 1);
@@ -1006,8 +958,9 @@ static long long remap_region(struct config c, unsigned int threshold_mb,
 			goto clean_up_src;
 		}
 
+		preamble_pattern = (char *)pattern + pattern_size - c.dest_preamble_size;
 		/* Set byte pattern for the dest preamble block. */
-		memcpy(dest_preamble_addr, rand_addr, c.dest_preamble_size);
+		memcpy(dest_preamble_addr, preamble_pattern, c.dest_preamble_size);
 	}
 
 	clock_gettime(CLOCK_MONOTONIC, &t_start);
@@ -1022,7 +975,7 @@ static long long remap_region(struct config c, unsigned int threshold_mb,
 	}
 
 	/* Verify byte pattern after remapping */
-	if (memcmp(dest_addr, rand_addr, threshold)) {
+	if (memcmp(dest_addr, pattern, threshold)) {
 		ksft_print_msg("Data after remap doesn't match\n");
 		ret = -1;
 		goto clean_up_dest;
@@ -1030,7 +983,7 @@ static long long remap_region(struct config c, unsigned int threshold_mb,
 
 	/* Verify the dest preamble byte pattern after remapping */
 	if (c.dest_preamble_size &&
-	    memcmp(dest_preamble_addr, rand_addr, c.dest_preamble_size)) {
+	    memcmp(dest_preamble_addr, preamble_pattern, c.dest_preamble_size)) {
 		ksft_print_msg("Preamble data after remap doesn't match\n");
 		ret = -1;
 		goto clean_up_dest;
@@ -1062,12 +1015,11 @@ static long long remap_region(struct config c, unsigned int threshold_mb,
  * the beginning of the mapping just because the aligned
  * down address landed on a mapping that maybe does not exist.
  */
-static void mremap_move_1mb_from_start(unsigned int pattern_seed,
-				       char *rand_addr)
+static void mremap_move_1mb_from_start(void)
 {
 	char *test_name = "mremap move 1mb from start at 1MB+256KB aligned src";
 	void *src = NULL, *dest = NULL;
-	unsigned int i, success = 1;
+	unsigned int success = 1;
 
 	/* Config to reuse get_source_mapping() to do an aligned mmap. */
 	struct config c = {
@@ -1089,7 +1041,7 @@ static void mremap_move_1mb_from_start(unsigned int pattern_seed,
 	}
 
 	/* Set byte pattern for source block. */
-	memcpy(src, rand_addr, SIZE_MB(2));
+	memcpy(src, pattern, SIZE_MB(2));
 
 	/*
 	 * Unmap the beginning of dest so that the aligned address
@@ -1098,7 +1050,7 @@ static void mremap_move_1mb_from_start(unsigned int pattern_seed,
 	munmap(dest, SIZE_MB(1));
 
 	void *new_ptr = mremap(src + SIZE_MB(1), SIZE_MB(1), SIZE_MB(1),
-						   MREMAP_MAYMOVE | MREMAP_FIXED, dest + SIZE_MB(1));
+			       MREMAP_MAYMOVE | MREMAP_FIXED, dest + SIZE_MB(1));
 	if (new_ptr == MAP_FAILED) {
 		ksft_perror("mremap");
 		success = 0;
@@ -1106,17 +1058,9 @@ static void mremap_move_1mb_from_start(unsigned int pattern_seed,
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
+	if (memcmp(src, pattern, SIZE_MB(1))) {
+		ksft_print_msg("Data before the remapped range was corrupted\n");
+		success = 0;
 	}
 
 out:
@@ -1129,11 +1073,10 @@ static void mremap_move_1mb_from_start(unsigned int pattern_seed,
 	ksft_test_result(success, "%s\n", test_name);
 }
 
-static void run_mremap_test_case(struct test test_case, unsigned int threshold_mb,
-				 char *rand_addr)
+static void run_mremap_test_case(struct test test_case,
+				 unsigned int threshold_mb)
 {
-	long long remap_time = remap_region(test_case.config, threshold_mb,
-					    rand_addr);
+	long long remap_time = remap_region(test_case.config, threshold_mb);
 
 	if (remap_time < 0) {
 		if (test_case.expect_failure)
@@ -1160,29 +1103,22 @@ static void run_mremap_test_case(struct test test_case, unsigned int threshold_m
 
 static void usage(const char *cmd)
 {
-	ksft_print_msg("Usage: %s [[-t <threshold_mb>] [-p <pattern_seed>]]\n", cmd);
+	ksft_print_msg("Usage: %s [-t <threshold_mb>]\n", cmd);
 	ksft_print_msg("-t\t only validate threshold_mb of the remapped region\n");
 	ksft_print_msg("  \t if 0 is supplied no threshold is used; all tests\n");
 	ksft_print_msg("  \t are run and remapped regions validated fully.\n");
 	ksft_print_msg("  \t The default threshold used is 4MB.\n");
-	ksft_print_msg("-p\t provide a seed to generate the random pattern for\n");
-	ksft_print_msg("  \t validating the remapped region.\n");
 }
 
-static int parse_args(int argc, char **argv, unsigned int *threshold_mb,
-		      unsigned int *pattern_seed)
+static int parse_args(int argc, char **argv, unsigned int *threshold_mb)
 {
-	const char *optstr = "t:p:";
 	int opt;
 
-	while ((opt = getopt(argc, argv, optstr)) != -1) {
+	while ((opt = getopt(argc, argv, "t:")) != -1) {
 		switch (opt) {
 		case 't':
 			*threshold_mb = atoi(optarg);
 			break;
-		case 'p':
-			*pattern_seed = atoi(optarg);
-			break;
 		default:
 			usage(argv[0]);
 			return -1;
@@ -1197,6 +1133,21 @@ static int parse_args(int argc, char **argv, unsigned int *threshold_mb,
 	return 0;
 }
 
+static void fill_pattern(uint32_t *pattern, size_t pattern_size, size_t page_size)
+{
+	size_t nr_pages = pattern_size / page_size;
+	size_t words_per_page = page_size / sizeof(uint32_t);
+	size_t page, word;
+
+	for (page = 0; page < nr_pages; page++) {
+		uint32_t *page_addr = pattern + page * words_per_page;
+		uint32_t val = page + 1;
+
+		for (word = 0; word < words_per_page; word++)
+			page_addr[word] = val;
+	}
+}
+
 #define MAX_TEST 15
 #define MAX_PERF_TEST 3
 int main(int argc, char **argv)
@@ -1210,57 +1161,46 @@ int main(int argc, char **argv)
 	size_t max_test_constant_region_size = _2MB;
 	size_t dest_preamble_size = 10 * _4MB;
 
-	unsigned int pattern_seed;
-	char *rand_addr;
-	size_t rand_size;
 	int num_expand_tests = 2;
 	int num_misc_tests = 9;
 	struct test test_cases[MAX_TEST] = {};
 	struct test perf_test_cases[MAX_PERF_TEST];
 	int page_size;
-	time_t t;
 	FILE *maps_fp;
 
 	ksft_print_header();
 
 	get_mmap_min_addr();
 
-	pattern_seed = (unsigned int) time(&t);
-
-	if (parse_args(argc, argv, &threshold_mb, &pattern_seed) < 0)
+	if (parse_args(argc, argv, &threshold_mb) < 0)
 		ksft_exit_fail_msg("Invalid arguments\n");
 
 	ksft_print_msg("Test configs:\n");
 	ksft_print_msg("threshold_mb=%u\n", threshold_mb);
-	ksft_print_msg("pattern_seed=%u\n", pattern_seed);
 
 	/*
-	 * set preallocated random array according to test configs; see the
-	 * functions for the logic of setting the size
+	 * Set a preallocated array where page[i] contains i+1
 	 */
 	if (!threshold_mb)
-		rand_size = MAX(max_test_variable_region_size,
-				max_test_constant_region_size);
+		pattern_size = MAX(max_test_variable_region_size,
+				   max_test_constant_region_size);
 	else
-		rand_size = MAX(MIN(threshold_mb * _1MB,
-				    max_test_variable_region_size),
-				max_test_constant_region_size);
-	rand_size = MAX(dest_preamble_size, rand_size);
-
-	rand_addr = (char *)mmap(NULL, rand_size, PROT_READ | PROT_WRITE,
-				 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-	if (rand_addr == MAP_FAILED) {
+		pattern_size = MAX(MIN(threshold_mb * _1MB,
+				       max_test_variable_region_size),
+				   max_test_constant_region_size);
+	pattern_size = MAX(dest_preamble_size, pattern_size);
+
+	pattern = mmap(NULL, pattern_size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (pattern == MAP_FAILED) {
 		ksft_perror("mmap");
-		ksft_exit_fail_msg("cannot mmap rand_addr\n");
+		ksft_exit_fail_msg("cannot mmap pattern\n");
 	}
 
-	/* fill stream of random bytes */
-	srand(pattern_seed);
-	for (unsigned long i = 0; i < rand_size; ++i)
-		rand_addr[i] = (char) rand();
-
 	page_size = sysconf(_SC_PAGESIZE);
 
+	fill_pattern(pattern, pattern_size, page_size);
+
 	/* Expected mremap failures */
 	test_cases[0] =	MAKE_TEST(page_size, page_size, page_size,
 				  OVERLAPPING, EXPECT_FAILURE,
@@ -1329,26 +1269,26 @@ int main(int argc, char **argv)
 		      ARRAY_SIZE(perf_test_cases) : 0) + num_expand_tests + num_misc_tests);
 
 	for (i = 0; i < ARRAY_SIZE(test_cases); i++)
-		run_mremap_test_case(test_cases[i], threshold_mb, rand_addr);
+		run_mremap_test_case(test_cases[i], threshold_mb);
 
 	maps_fp = fopen("/proc/self/maps", "r");
 
 	if (maps_fp == NULL) {
-		munmap(rand_addr, rand_size);
+		munmap(pattern, pattern_size);
 		ksft_exit_fail_msg("Failed to read /proc/self/maps: %s\n", strerror(errno));
 	}
 
 	mremap_expand_merge(maps_fp, page_size);
 	mremap_expand_merge_offset(maps_fp, page_size);
 
-	mremap_move_within_range(pattern_seed, rand_addr);
-	mremap_move_1mb_from_start(pattern_seed, rand_addr);
+	mremap_move_within_range();
+	mremap_move_1mb_from_start();
 	mremap_shrink_multiple_vmas(page_size, /* inplace= */true);
 	mremap_shrink_multiple_vmas(page_size, /* inplace= */false);
-	mremap_move_multiple_vmas(pattern_seed, page_size, /* dontunmap= */ false);
-	mremap_move_multiple_vmas(pattern_seed, page_size, /* dontunmap= */ true);
-	mremap_move_multiple_vmas_split(pattern_seed, page_size, /* dontunmap= */ false);
-	mremap_move_multiple_vmas_split(pattern_seed, page_size, /* dontunmap= */ true);
+	mremap_move_multiple_vmas(page_size, /* dontunmap= */ false);
+	mremap_move_multiple_vmas(page_size, /* dontunmap= */ true);
+	mremap_move_multiple_vmas_split(page_size, /* dontunmap= */ false);
+	mremap_move_multiple_vmas_split(page_size, /* dontunmap= */ true);
 	mremap_move_multi_invalid_vmas(maps_fp, page_size);
 
 	fclose(maps_fp);
@@ -1357,11 +1297,10 @@ int main(int argc, char **argv)
 		ksft_print_msg("%s\n",
 			       "mremap HAVE_MOVE_PMD/PUD optimization time comparison for 1GB region:");
 		for (i = 0; i < ARRAY_SIZE(perf_test_cases); i++)
-			run_mremap_test_case(perf_test_cases[i], threshold_mb,
-					     rand_addr);
+			run_mremap_test_case(perf_test_cases[i], threshold_mb);
 	}
 
-	munmap(rand_addr, rand_size);
+	munmap(pattern, pattern_size);
 
 	ksft_finished();
 }
-- 
2.53.0


