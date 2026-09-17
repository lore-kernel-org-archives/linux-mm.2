Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF5B9C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 11:20:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEF1D6B00A0; Thu, 17 Sep 2026 07:20:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9FBA6B00A1; Thu, 17 Sep 2026 07:20:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F4A26B00A2; Thu, 17 Sep 2026 07:20:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 182196B00A0
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:20:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8FC461402DD
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:20:50 +0000 (UTC)
X-FDA: 85223011860.13.C0C28C1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id E65078000D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:20:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pm547Zxf;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789644049;
	b=TSxgm8FSJLC/mAcmfMbqafDAm/kBWONbdcH59JuE6NI5Y1zStfPrNycIh3wtoiYv3eYE+Y
	NgDiCQQgj6FA+ie9e9Zf3KQsy7Nlt+lxuek+hjN8F0JtTzgC/R3abtTBsxQmd42psW9c8p
	mclBRSpcMhKOb8gqNYUO2u6i/gWb5CI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pm547Zxf;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789644049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k5aECR1Gq19DBV9SV+ao/nTzMJSrdfp4WRgjh1mJj6g=;
	b=Pt051ikNJkm8R6NscmKVX7N3LCFQm2p17JgVRTrMf7E31/L3wvuoB2CcikZKDLCoAoKicg
	y2YjuATrWbQLyr+Gto7yOdB1UUQZYToXBqadJAHx62MU0jksaQ7iU/gWzFgV/HhB1lOowG
	H7P5yTWt3awBjCFt9DXsK5OSHj72E64=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9FA3C1F91;
	Thu, 17 Sep 2026 04:20:44 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EC4803F7B4;
	Thu, 17 Sep 2026 04:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789644048; bh=W0Ngv2ll7TrUzP/N5jQ6K1WGV1ebWdj2UDxJ7GFJJf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pm547ZxfYZIkiIpWwlVIarGX0nbQ7cZqDeaR/2f6iyKtipwzm5A3QBrYXQBedJe8p
	 oFSyAe6zl1THhv94YHzwNb8eZUQ+WJrat39oFnsIbP51IKoA7OIZc5nTvxqTFPj3t+
	 foZtCSAcHw67UYSz0rBu+gebqE99ZPyDPmLHfsBo=
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
Subject: [PATCH 9/9] selftests/mm: mremap_test: strengthen multi VMA validation
Date: Thu, 17 Sep 2026 16:49:51 +0530
Message-ID: <20260917111951.188266-10-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260917111951.188266-1-sarthak.sharma@arm.com>
References: <20260917111951.188266-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E65078000D
X-Stat-Signature: 895bzmnnj6aqbmzs55bynaz8s6xx64r1
X-HE-Tag: 1789644048-117145
X-HE-Meta: U2FsdGVkX1+tUhjAzvAfM44692e85NDdDNxZOrV1MMcqGCMdpckiNJ4H5rVlk4B1mo7tQDC6r7AIK5KsmuEQt0N1SX+s3zEiShU4mgXKDTmjJhYYib1eSkrjAp8ZG6idqlWT0oYWLoA5q0e9f4SkBoimd4/1PFVjjyA22eyu6/PaeRJ/+w6GaDMNcXBbTL6jqtQ03vzzH0ktk8psBNb3BMGAj4V9fFnaW5im9tQ4eHxyhC9HVydydS3fLXAf7PyLBz0ZYtbJUAApOT6UhhsTGM9avvcud/RAxZNCsQ2ZVeYT+7ieLXtmzpYvn8KC7kLVINKSk2+UMboqVzi2ZYNzsPxwiN8uA8rPKTq2OLbnEQgq5dwxuKC/pUFfMyKqpRlDIQtuKPF3qvk9sOTZwQm4PDH0/6SZob2Q9D5EnuOCv+cxWmAUQhxPaz7q7n87Fa56q69aXSSvypkkwZvs/P8oZ7K99DAsvTIpuo99EaHAjh65Kpp5n0eXQeq1U+RiWJnSa0fRoLryGa03Y8CAEhVHcVrsWp4UaGeDLLMPYtSTQ6wgR97WcirwrF1asOxn0163pl2RpOwO/SsFNZM8dxvpX7oTj9rgcYogym9Gd1OytFxnqRAZT1MlunULMuEjH1kQkjhE6kncYw6riyI1xjIMMax8JNss9CyDIV4vEoSSgGaBINubqhO13xxr8h4Ygq9LDG1JTKi6LD/eabDNCzaKxqyyhyknHzkYooip3lDnXczBcwgMwSvOAiK/NozSFfe5TKkYOpIWfMurewxfEvt8aDsaaZH5HRjWwq+WLwFyz5AE0iKBG11OHbSPmLO5XOs7HBAkYG/wX42hipSVzQFL9nAmHtQZb5TYnwiCHKeN9/Sn17coCURvdPZsoovEmAHfYonqXh4R8AjZWubNOWvroqRNPBHHMJ83tQ+tVRLxsJLkz13Ux21Ic7x17xaRU5lc7+rq7QOvhYt1H8bH4f6
 Fw9THYIu
 SZN3gAh0IAtqt20bSHRh66OK/aiQZftjLrDx2ryQfNGUIb7IQOH2a6qvFKg4gTuWuU7Weby9BknrM23w58zELohQNZHCPbky7RiqChyNu12avQ4uKPj5hnEQIwL00lwnUzccejt1rpamIZPd6Y0E6UXZ9k1EjEvC/2CeBMf163IxHViC/pMxqcXzduzWWc4UGV2vCKZJkBGqlywMV5WqtkDrOqKLFIU0J7e41ZQfovG8ZSOxwyoXB8PSUz/M0dZpm6Kh9EiLVYHeZrGsy2lkSSTkJ6r1bfGX5YPNo7m4qfYZB5Fs=
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


