Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15290C982FD
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 05:01:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7346B00A1; Thu, 24 Sep 2026 01:01:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70D56B00A2; Thu, 24 Sep 2026 01:01:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C3486B00A4; Thu, 24 Sep 2026 01:01:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 674A06B00A1
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 01:01:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F02901A021D
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:01:10 +0000 (UTC)
X-FDA: 85247456700.16.B3D114F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3CCAF140003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:01:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="ldEN6qM/";
	spf=pass (imf26.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790226069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k5aECR1Gq19DBV9SV+ao/nTzMJSrdfp4WRgjh1mJj6g=;
	b=WasRoAwfD2Ntd1C+clsJnmzDMIH9HzaR1GUE9XLwIDfdzq3o/F5I7Y+nkWlluDpf5zV9Vg
	qGIaH03JV5bi3hYxgMGTSE/wOyes36htjbJTKapBFDfkitECsL5+Dz2waXhWCot9gXSlWq
	ICh+gHIfMAstl+kBqyh1nDhmX2Q/cXs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790226069;
	b=uwcrLu7H0nsQxLwR9aMFL88JsjUOQN/Z8IRgbPmflo8jwXFhfrwYNFV54Vec9lMluItPLZ
	6Q/7BEQ6zeavx2Atf7z25oXtABvgOul/sGve9hNhqxltjBpEaN/HaaETQMOREtIVy1UbmA
	MMDcvgmF1EXOPm+Pfr4iQqsB6hRSEtQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="ldEN6qM/";
	spf=pass (imf26.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7EDB61650;
	Wed, 23 Sep 2026 22:01:04 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6E2F53F86C;
	Wed, 23 Sep 2026 22:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790226068; bh=W0Ngv2ll7TrUzP/N5jQ6K1WGV1ebWdj2UDxJ7GFJJf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ldEN6qM/TEuJ+Ne6s9cE+AFLwyVgBplZwRpdhzAZH1uLLAvIIhItmnSTg/j4gUiNF
	 IPwQzKMFnISlFzH0BsbH6VthJMwJh7efL/3aSAijSxXuPYlbKOq+CwIYHSRP7sRF+z
	 sy9325g6rY2yhR6r8b5hoIVmEU0zJGdff7OdxGU0=
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
Subject: [PATCH RESEND 9/9] selftests/mm: mremap_test: strengthen multi VMA validation
Date: Thu, 24 Sep 2026 10:30:09 +0530
Message-ID: <20260924050009.19974-10-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924050009.19974-1-sarthak.sharma@arm.com>
References: <20260924050009.19974-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3CCAF140003
X-Stat-Signature: 7dj3fn8ftix3bxjjfckpk1uzd8sn8fxz
X-HE-Tag: 1790226069-458044
X-HE-Meta: U2FsdGVkX18wYSeR3p0pt96ATAOnIz3sR8Dg6ABK4h3kcKvxfzaaIHHJDc5J3WTGM+knxm07SgQRF3DrmKyMMj94UClxqAHxzjOjuB7YwgBg1/Ngj1I3zmmUeLwH7h2ch59TWqpBC3tUSGmc4gBFFBMurYZ6LiP2ipODxdgDyKJAEXwuku2IlSTkJnMWXzIQDczT8GUzpy8IiAg+k9omdPAzNR7XEJIPqqW1nAtDu58O5Mc36aKzAwcuzKrYAyDoEoXTa7ZUdrgk78uj0z8kA3jvDD5KexniRbMXB4Nm7mDXk2BUfJ8zNSR1Xli8UN0ZnNX9qPdIa6tpQTAc5ZW4qIguqXkQoQY6QIw3I1zTBEJK5jrYiLJREfmYdXuEdbU8Wo1YWpPx5YD4oVI6oQkdtYL85pWD2/5dG9bbq8iZ1MnIujhqxnQZ8ub3pIr4cvFvw9db+3Vv0OlGZdTgVqDekvcUy/CAXCEq09c+ulRUH7uqm7XtS9vflZbmyOT/xW5vplNMQ5pShOifR+oykYsMBSzaL+1W3D8XerVbsAHNaJY1CU635zS7rhSRYhTU5pqe4yQRS3lc5S7d0AxkT/yVNUY75mcasBsLmQ9bS/+lOeJkU3HOMxlXZBgeWESrV81YkqMEt5V+NrbtnYFQczK8cckAjaRNtAXNM8r8sjsB5f0siQU0Gcze9eEO/IfoTz+MXlQbUBcHP5s527QrmWt1R67WMSrcG9uwa7eacRVBbb9NVNIdrMsF/CJHvN9W6IQOIdBZZElfPNWuPwFushBKxm9HP4geGMiAHEhOsGy9RanOfHOos631jjhiduzRpvhJGxPMOIACOa2SivEPKQkkfP4R3alzCLmWM75zJPqhn3SqYnMzts6x4A8zxW/gbeLSCp0MVzQHHp1rIFI4c+gqUDYaZgPGxZ7SxxI1CtGfgZcPCgVcUAY4MI7x0xbEy8AKNmd8r3qzHJaWjSSKRnn
 ERvkacSN
 88fa0k20hxjNsQwnjAyTV6o0iCnpdtsJ68+UtXq2hmgH1FNlFdSD7ZeVftZwgJIej3dRAEyBTqLqDDcHl+l+MwalDE5ygPicJVGNlbvPDQEf/VCZMva80NDIgdl6N3DOEjBK3KkEIg3mXOKwUptc2YSoks49X19SiWgoHrfgzq+cMhKlNXITLkqFT5HruC59SqJ95QPfkQgOreCL5jzjuKtHmhFXDtKztxT54zURIYQEVSzo+kcp9qZVcZsDrveOjYe/RD8SNBbNMb4B5MTKhbmYhfyO8hkxdE/c8LbV/dHSjoPU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tests in mremap_test.c where a multi VMA range is involved only
check if the data remains consistent across mapped pages after
remap. They do not verify the mapping state of gaps in the
remapped range.

Add helpers to check whether a range is mapped with the
expected permissions using /proc/self/maps. Use them to
verify that gaps remain unmapped after regular remaps and
retain PROT_NONE permissions when remapping over an
existing mapping with PROT_NONE permissions.

Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 91 +++++++++++++++++++-----
 1 file changed, 72 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 77e952556be1..1d9934b9a60b 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -124,13 +124,15 @@ static unsigned long long get_mmap_min_addr(void)
 }
 
 /*
- * Using /proc/self/maps, assert that the specified address range is contained
- * within a single mapping.
+ * Using /proc/self/maps, check whether the specified address range is contained
+ * within a single mapping with the expected permissions, if supplied.
  */
-static bool is_range_mapped(FILE *maps_fp, unsigned long start,
-			    unsigned long end)
+static bool is_range_mapped_with_perms(FILE *maps_fp, unsigned long start,
+				       unsigned long end,
+				       const char *expected_perms)
 {
 	char *line = NULL;
+	char perms[5];
 	size_t len = 0;
 	bool success = false;
 	unsigned long first_val, second_val;
@@ -138,12 +140,13 @@ static bool is_range_mapped(FILE *maps_fp, unsigned long start,
 	rewind(maps_fp);
 
 	while (getline(&line, &len, maps_fp) != -1) {
-		if (sscanf(line, "%lx-%lx", &first_val, &second_val) != 2) {
+		if (sscanf(line, "%lx-%lx %4s", &first_val, &second_val, perms) != 3) {
 			ksft_exit_fail_msg("cannot parse /proc/self/maps\n");
 			break;
 		}
 
-		if (first_val <= start && second_val >= end) {
+		if (first_val <= start && second_val >= end &&
+		    (!expected_perms || !strcmp(perms, expected_perms))) {
 			success = true;
 			fflush(maps_fp);
 			break;
@@ -154,6 +157,12 @@ static bool is_range_mapped(FILE *maps_fp, unsigned long start,
 	return success;
 }
 
+static bool is_range_mapped(FILE *maps_fp, unsigned long start,
+			    unsigned long end)
+{
+	return is_range_mapped_with_perms(maps_fp, start, end, NULL);
+}
+
 /* Check if [ptr, ptr + size) mapped in /proc/self/maps. */
 static bool is_ptr_mapped(FILE *maps_fp, void *ptr, unsigned long size)
 {
@@ -163,6 +172,20 @@ static bool is_ptr_mapped(FILE *maps_fp, void *ptr, unsigned long size)
 	return is_range_mapped(maps_fp, start, end);
 }
 
+/*
+ * Check if [ptr, ptr + size) is mapped with the required permissions in
+ * /proc/self/maps.
+ */
+static bool is_ptr_mapped_with_perms(FILE *maps_fp, void *ptr,
+				     unsigned long size,
+				     const char *expected_perms)
+{
+	unsigned long start = (unsigned long)ptr;
+	unsigned long end = start + size;
+
+	return is_range_mapped_with_perms(maps_fp, start, end, expected_perms);
+}
+
 /*
  * Returns the start address of the mapping on success, else returns
  * NULL on failure.
@@ -351,16 +374,37 @@ static void mremap_move_within_range(void)
 	ksft_test_result(success, "%s\n", test_name);
 }
 
-static bool is_multiple_vma_range_ok(char *ptr, unsigned long page_size)
+static bool is_multiple_vma_range_ok(FILE *maps_fp, char *ptr,
+				     unsigned long page_size, bool expect_gaps_mapped)
 {
 	int i;
 
-	for (i = 0; i <= 10; i += 2) {
+	for (i = 0; i <= 10; i++) {
 		size_t size = i == 4 ? 3 * page_size : page_size;
 
-		if (i == 6)
+		/* Pages 4, 5 and 6 are part of the same VMA. */
+		if (i == 5 || i == 6)
 			continue;
 
+		/* Odd pages correspond to gaps between the source VMAs. */
+		if (i & 1) {
+			if (expect_gaps_mapped) {
+				if (!is_ptr_mapped_with_perms(maps_fp,
+							      ptr + i * page_size,
+							      page_size, "---p")) {
+					ksft_print_msg("Page %d PROT_NONE mapping overwritten\n",
+						       i);
+					return false;
+				}
+			} else if (is_ptr_mapped(maps_fp, ptr + i * page_size,
+						 page_size)) {
+				ksft_print_msg("Page %d is unexpectedly mapped\n", i);
+				return false;
+			}
+
+			continue;
+		}
+
 		if (memcmp(ptr + i * page_size, (char *)pattern + i * page_size,
 			   size)) {
 			ksft_print_msg("Data in VMA starting at page %d got corrupted\n",
@@ -371,7 +415,8 @@ static bool is_multiple_vma_range_ok(char *ptr, unsigned long page_size)
 	return true;
 }
 
-static void mremap_move_multiple_vmas(unsigned long page_size, bool dont_unmap)
+static void mremap_move_multiple_vmas(FILE *maps_fp, unsigned long page_size,
+				      bool dont_unmap)
 {
 	int mremap_flags = MREMAP_FIXED | MREMAP_MAYMOVE;
 	char *test_name = "mremap move multiple vmas";
@@ -432,7 +477,7 @@ static void mremap_move_multiple_vmas(unsigned long page_size, bool dont_unmap)
 		goto out_unmap;
 	}
 	/* Check move was ok. */
-	if (!is_multiple_vma_range_ok(tgt_ptr, page_size)) {
+	if (!is_multiple_vma_range_ok(maps_fp, tgt_ptr, page_size, false)) {
 		success = false;
 		goto out_unmap;
 	}
@@ -445,7 +490,7 @@ static void mremap_move_multiple_vmas(unsigned long page_size, bool dont_unmap)
 		goto out_unmap;
 	}
 	/* Check that the move is ok. */
-	if (!is_multiple_vma_range_ok(&tgt_ptr[size], page_size)) {
+	if (!is_multiple_vma_range_ok(maps_fp, &tgt_ptr[size], page_size, false)) {
 		success = false;
 		goto out_unmap;
 	}
@@ -465,7 +510,7 @@ static void mremap_move_multiple_vmas(unsigned long page_size, bool dont_unmap)
 		goto out_unmap;
 	}
 	/* Check that the move is ok. */
-	if (!is_multiple_vma_range_ok(tgt_ptr, page_size)) {
+	if (!is_multiple_vma_range_ok(maps_fp, tgt_ptr, page_size, true)) {
 		success = false;
 		goto out_unmap;
 	}
@@ -554,7 +599,8 @@ static void mremap_shrink_multiple_vmas(unsigned long page_size,
 	ksft_test_result(success, "%s%s\n", test_name, inplace ? " [inplace]" : "");
 }
 
-static void mremap_move_multiple_vmas_split(unsigned long page_size,
+static void mremap_move_multiple_vmas_split(FILE *maps_fp,
+					    unsigned long page_size,
 					    bool dont_unmap)
 {
 	char *test_name = "mremap move multiple vmas split";
@@ -629,8 +675,15 @@ static void mremap_move_multiple_vmas_split(unsigned long page_size,
 
 	/* Check pattern. */
 	for (i = 0; i < 7; i++) {
-		if (i == 3)
+		if (i == 3) {
+			if (is_ptr_mapped(maps_fp, tgt_ptr + i * page_size,
+					  page_size)) {
+				ksft_print_msg("Page %d is unexpectedly mapped\n", i);
+				success = false;
+				goto out_unmap;
+			}
 			continue;
+		}
 
 		if (memcmp(tgt_ptr + i * page_size,
 			   (char *)pattern + (i + 2) * page_size, page_size)) {
@@ -1177,10 +1230,10 @@ int main(void)
 	mremap_move_1mb_from_start();
 	mremap_shrink_multiple_vmas(page_size, /* inplace= */true);
 	mremap_shrink_multiple_vmas(page_size, /* inplace= */false);
-	mremap_move_multiple_vmas(page_size, /* dontunmap= */ false);
-	mremap_move_multiple_vmas(page_size, /* dontunmap= */ true);
-	mremap_move_multiple_vmas_split(page_size, /* dontunmap= */ false);
-	mremap_move_multiple_vmas_split(page_size, /* dontunmap= */ true);
+	mremap_move_multiple_vmas(maps_fp, page_size, /* dontunmap= */ false);
+	mremap_move_multiple_vmas(maps_fp, page_size, /* dontunmap= */ true);
+	mremap_move_multiple_vmas_split(maps_fp, page_size, /* dontunmap= */ false);
+	mremap_move_multiple_vmas_split(maps_fp, page_size, /* dontunmap= */ true);
 	mremap_move_multi_invalid_vmas(maps_fp, page_size);
 
 	fclose(maps_fp);
-- 
2.53.0


