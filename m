Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DB38CA5FFF
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:26:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 699D16B00B8; Tue,  6 Oct 2026 05:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 623786B00B9; Tue,  6 Oct 2026 05:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 539D76B00BA; Tue,  6 Oct 2026 05:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 263576B00B8
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:26:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A7AC380185
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:26:25 +0000 (UTC)
X-FDA: 85291670730.30.0B7F9BB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0696B100003
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:26:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=J0j0u8sN;
	spf=pass (imf14.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IAZ6AS84Tzyrh6VZe6MJZNOnFdsPSUC5zPjKe7ltBbg=;
	b=pu4Xc/pEvmcOOpuMezK4HmN0l8nmIBGo5a45uPpRQBCYNCjTtbj/sIqAVSMIujz+dPHEgg
	zpri4ZhFLQEgxVRhOUG/QuuLbF2Z2LIJXwZBm24HvHJSVpoapP7EIzqqRNan+tIGxvS+e0
	UMY1R9Cdc9EWG9e3IeSkiewFt7HAxjE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=J0j0u8sN;
	spf=pass (imf14.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278784;
	b=qz6etVBIHM+k834Jznkyv7w5wloLMdEwLXqaYp3OdCTCKYsNJ6nievXsElVNEujlTM9iyK
	86JvQm9gereJhjzCXJcATWYkPtMFMbUFwOWdQOncxe17iG1mxwvMqL/+7AUSoT7H5d0Uen
	8bFOE6ewSdvhPgVbhNJT/58os990Ibo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D79F31516;
	Tue,  6 Oct 2026 02:26:19 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F3FB83F763;
	Tue,  6 Oct 2026 02:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791278783; bh=H8dDI8wjnT2CtVhs3Y+DumFIFSl6+a23n2IQoHaKW6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0j0u8sNdBQm7q1DFGi2QLeZKKd801B6Dc7pw7QcTqLHd1wi04/2p9sVDDK09x+pP
	 C6lvnbjT1pr5nI++rNYVyAwyRnhQ8xV3DogaxwsUlxJMYOBlMQQ+41lB7xaPOVD/TD
	 9uK1CHT51cpSr0z5WyNCfpVbOcm035ObrnnBr1cE=
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
Subject: [PATCH v2 12/12] selftests/mm: mremap_test: strengthen multi VMA validation
Date: Tue,  6 Oct 2026 14:55:11 +0530
Message-ID: <20261006092511.145776-13-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261006092511.145776-1-sarthak.sharma@arm.com>
References: <20261006092511.145776-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0696B100003
X-Rspam-User: 
X-Stat-Signature: 4pd96e9bkey4e77gxxpbap3thp3ukfp1
X-HE-Tag: 1791278783-618957
X-HE-Meta: U2FsdGVkX18ReQbmREBzqXVjrGQhS1WcVr5+ZA8CG9KkJRJZqeTMVeT6iytZuCIcdq5t6mej+4pQTXjtzWV/QC87MkgUF6x5QMFbpsZ19Ru4uymBtM+Q7OtUm1lW+k2r/jLiua6YuP546+28kPtmhcw+BgaGjyZJD/pYzGZGJbeUX0rg3DxdMuBTryH70N6LpVEOFe0CgfCj6xftADuOLLcQewtYkHbZgWOWMP2wYjVQU9C7my3jo2nbz9EiHd92NukPWZOw6KNsv7vb4OjLk5sf/UvgQCzkLQffnjTgPeCFE2fGay125OnDMVrYDyjQGxV2j8oZU1rsiYfKkUH11E6hm6UIsC0t3mchvnoREWf1b138rKY5EwwzGiLJRj4Bps80caWHNuxO9GTAgD0rbnJpyxBZRrILABQ+OEaPH7QVrAdTXRUQBsv4Pas/nsvqq+iM76ldOk/UM6i1SjW+YBVpoVwj+wuE74KpZLb51nc37b4Z8FHqi8CWyCDyp9IploQETwDO64YVCNh0gzkxkSmbme9488kIWZy6RAHv18tXyvKVTq3M/zjFqdtuQN+7LpZMVOrbZKs95rL/mu54yJaigqJM959bGmV8JSyaJwDzGw4eO0+VUyQ6vcQmGsqC8b8y0ojNV3E1Z++rP4uueMbj8eZjjgRglKLbQs4Mm2BVbBwamzjd6uxCHgjuKKC+Rh6dZv6eFD638nXdFlQ7qeLqJxywRawgWPcTnh+SmboKcSDA8CagxepIdDYkF+PjyrLQoMk9oSb4KFDMKpRLsoeiz/UNafC36jBpUs3d7eFyohtVbRHc+7mAPGWcNq6E8UFAT9fgD7QSCeew5DAwB3UXlPk02WJjLlsqDN0vDVf6yKykEbwUJoCMkqoaKV7+/MKVBpgKgcemik/ktaDbtH/iWwH9CNGdTiYa2IgV+9YlPyMibedluLuw74yAQvAJI6uvF3Oi6WduR4uWRbe
 2ieLG/eS
 29TypbWnNaeNi7QCFOXzhEeIUcf/xKiVExipYFjIXq0ulNy4kayhOvsaGz9Kr8ip0TUu2EvZFHWNzeJvhRuOB0/gcBhJExF6hMErhKA+ebUwlUObDyT+xzioasQeqpYbDac2CFay9Cb/xt8ix0sCQXVac8LXTwWng2pAFBAUhLdJbDcY5lvEwiITyyPFkoNdbuOV0Q3gYGwK3UEBhOxiS9jlp9fkY9bZNmnrPyJNQpdhqB+jpaVVcV2HFS3G1PAEJF5mnT4IkgyjhIpAoMLigNJiTlSzuYsSItWnCL64HWETB8Us=
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
verify that gaps remain unmapped after regular multi VMA
moves and after the partial move in the userfaultfd
multi VMA test. Also verify that gaps retain PROT_NONE
permissions when remapping over an existing mapping
with PROT_NONE permissions.

Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 105 ++++++++++++++++++-----
 1 file changed, 85 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 92ffcbe547b5..2a349b967695 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -122,13 +122,14 @@ static unsigned long long get_mmap_min_addr(void)
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
+		unsigned long end, const char *expected_perms)
 {
 	char *line = NULL;
+	char perms[5];
 	size_t len = 0;
 	bool success = false;
 	unsigned long first_val, second_val;
@@ -136,12 +137,13 @@ static bool is_range_mapped(FILE *maps_fp, unsigned long start,
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
@@ -152,6 +154,12 @@ static bool is_range_mapped(FILE *maps_fp, unsigned long start,
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
@@ -161,6 +169,20 @@ static bool is_ptr_mapped(FILE *maps_fp, void *ptr, unsigned long size)
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
@@ -348,10 +370,33 @@ static void mremap_move_within_range(char *pattern_addr)
 	ksft_test_result(success, "%s\n", test_name);
 }
 
-static bool is_multiple_vma_range_ok(char *pattern_addr, char *ptr,
-				     unsigned long page_size)
+static bool is_multiple_vma_range_ok(FILE *maps_fp, char *pattern_addr,
+				     char *ptr, unsigned long page_size,
+				     bool expect_gaps_mapped)
 {
-	for (int i = 0; i <= 10; i += 2) {
+	for (int i = 0; i <= 10; i++) {
+
+		if (i == 5)
+			continue;
+
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
+			continue;
+		}
+
 		size_t size = i == 4 ? 2 * page_size : page_size;
 
 		if (memcmp(ptr + i * page_size, pattern_addr + i * page_size,
@@ -365,7 +410,7 @@ static bool is_multiple_vma_range_ok(char *pattern_addr, char *ptr,
 	return true;
 }
 
-static void mremap_move_multiple_vmas(char *pattern_addr,
+static void mremap_move_multiple_vmas(FILE *maps_fp, char *pattern_addr,
 				      unsigned long page_size,
 				      bool dont_unmap)
 {
@@ -428,7 +473,8 @@ static void mremap_move_multiple_vmas(char *pattern_addr,
 		goto out_unmap;
 	}
 	/* Check move was ok. */
-	if (!is_multiple_vma_range_ok(pattern_addr, tgt_ptr, page_size)) {
+	if (!is_multiple_vma_range_ok(maps_fp, pattern_addr, tgt_ptr,
+				      page_size, false)) {
 		success = false;
 		goto out_unmap;
 	}
@@ -441,7 +487,8 @@ static void mremap_move_multiple_vmas(char *pattern_addr,
 		goto out_unmap;
 	}
 	/* Check that the move is ok. */
-	if (!is_multiple_vma_range_ok(pattern_addr, &tgt_ptr[size], page_size)) {
+	if (!is_multiple_vma_range_ok(maps_fp, pattern_addr, &tgt_ptr[size],
+				      page_size, false)) {
 		success = false;
 		goto out_unmap;
 	}
@@ -461,7 +508,8 @@ static void mremap_move_multiple_vmas(char *pattern_addr,
 		goto out_unmap;
 	}
 	/* Check that the move is ok. */
-	if (!is_multiple_vma_range_ok(pattern_addr, tgt_ptr, page_size)) {
+	if (!is_multiple_vma_range_ok(maps_fp, pattern_addr, tgt_ptr,
+				      page_size, true)) {
 		success = false;
 		goto out_unmap;
 	}
@@ -547,7 +595,8 @@ static void mremap_shrink_multiple_vmas(unsigned long page_size,
 	ksft_test_result(success, "%s%s\n", test_name, inplace ? " [inplace]" : "");
 }
 
-static void mremap_move_multiple_vmas_split(char *pattern_addr,
+static void mremap_move_multiple_vmas_split(FILE *maps_fp,
+					    char *pattern_addr,
 					    unsigned long page_size,
 					    bool dont_unmap)
 {
@@ -623,8 +672,15 @@ static void mremap_move_multiple_vmas_split(char *pattern_addr,
 
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
 			   pattern_addr + (i + 2) * page_size, page_size)) {
@@ -840,10 +896,19 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 		goto out_unmap;
 	}
 
-	for (i = 0; i < 10; i += 2) {
+	for (i = 0; i < 10; i++) {
 		bool is_mapped = is_ptr_mapped(maps_fp,
 				&tgt_ptr[i * page_size], page_size);
 
+		if (i & 1) {
+			if (is_mapped) {
+				ksft_print_msg("Gap unexpectedly mapped at %d\n", i);
+				success = false;
+				goto out_unmap;
+			}
+			continue;
+		}
+
 		if (i < 8 && !is_mapped) {
 			ksft_print_msg("Valid VMA not moved at %d\n", i);
 			success = false;
@@ -1206,10 +1271,10 @@ int main(void)
 	mremap_move_1mb_from_start(pattern_addr);
 	mremap_shrink_multiple_vmas(page_size, /* inplace= */true);
 	mremap_shrink_multiple_vmas(page_size, /* inplace= */false);
-	mremap_move_multiple_vmas(pattern_addr, page_size, /* dontunmap= */ false);
-	mremap_move_multiple_vmas(pattern_addr, page_size, /* dontunmap= */ true);
-	mremap_move_multiple_vmas_split(pattern_addr, page_size, /* dontunmap= */ false);
-	mremap_move_multiple_vmas_split(pattern_addr, page_size, /* dontunmap= */ true);
+	mremap_move_multiple_vmas(maps_fp, pattern_addr, page_size, /* dontunmap= */ false);
+	mremap_move_multiple_vmas(maps_fp, pattern_addr, page_size, /* dontunmap= */ true);
+	mremap_move_multiple_vmas_split(maps_fp, pattern_addr, page_size, /* dontunmap= */ false);
+	mremap_move_multiple_vmas_split(maps_fp, pattern_addr, page_size, /* dontunmap= */ true);
 	mremap_move_multi_invalid_vmas(maps_fp, page_size);
 
 	fclose(maps_fp);
-- 
2.53.0


