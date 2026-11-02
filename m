Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 713F5606A327
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=oxbcq5ES
Received: by kanga.kvack.org (Postfix)
	id 99C196B05C7; Mon,  2 Nov 2026 05:04:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94CD36B05C8; Mon,  2 Nov 2026 05:04:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83C336B05C9; Mon,  2 Nov 2026 05:04:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A2AA6B05C7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:04:12 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ED1E51A0C9F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:04:11 +0000 (UTC)
X-FDA: 85389743502.20.A928F49
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 554D0100003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:04:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oxbcq5ES;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793613850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y8MIrwrxZZBXR4U1tlZDUC+Iooupo8bVDyTYl7iwQ+Q=;
	b=QGunPl1S+FpOBIeu2I4jWlyl45/PyMgTZxQeUcLcJYPEZkVeqWfgGZQSsAgihX4CBBisVI
	toDzBEwso6qvAPsZ/kVsKgQaYa2CZPpj0CeDPnbrY+ZgBU6A1KvS+pq5Bh+fF9U99Fx72g
	NBGdiajAefH2JNC+LDt3yv9YQj6oz3s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oxbcq5ES;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793613850;
	b=oLj1PsWBc3k41X8RE4cAITT4qBAq6di5sQb8QQaZJXUVMQfNUS3B6UYFzkbWdlB3haFRBw
	xLHdtV6EM/f5Qac6y+hbjRRd908hQJkfO5pej1fVSAWnLx5FgNo2/FH0acUfu2NMmEh0SP
	7HQG5c00gtY568fuOF7yDJ1OWQIsMhA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 93FBC1595;
	Mon,  2 Nov 2026 02:04:06 -0800 (PST)
Received: from a081061.arm.com (unknown [10.163.156.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 52C663F59E;
	Mon,  2 Nov 2026 02:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793613849; bh=Vl3ojrGKhQ4pEt8ey4N/OpGEcmtPIkRQd8WiP7k/B/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxbcq5ES1uFxcvGr3iCpN5o9yV5gFISnJHlauxh6ZuP+UY3+4tvL+NVZV1ReaYWaB
	 FCfG9VF7yKYLh6Ypp0f232lbvym0PSPYncoe/ses5mqB+r0Ok7NDuBX+WQ7YT4bRh7
	 rJbrhiwnoReTByr0xUDDN4lmmui2IrtJq2ZyMVG0=
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
Subject: [PATCH RESEND v2 12/12] selftests/mm: mremap_test: strengthen multi VMA validation
Date: Mon,  2 Nov 2026 15:32:11 +0530
Message-ID: <20261102100211.141831-13-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261102100211.141831-1-sarthak.sharma@arm.com>
References: <20261102100211.141831-1-sarthak.sharma@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 554D0100003
X-Stat-Signature: 7u7zei18fpo84zos9rq8g9ip8y873qau
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793613850-803869
X-HE-Meta: U2FsdGVkX19tlN8uaPLOAFJtTSfCQ3257Wlv6cGqPZGz3ir6Fm0yU/Xff4F9ViAwAMPCwMt8uzdMCtePq0LaiFsPxVy86/05XTK5sKBK0T+20BMCUQ9QGRsfM8N9jhG9dXVsj/wqUYsPdZrLsH42PdenF7AO0OM47mAyO0Wy4iRylTfhqN4kV89B8Ylw2NKHDMUQXXw0pCs2r3IbJlBgG+ckxyvfl2UNJ/nSXXKNpddFotpBt6Md/pQENgNYtT4+LHf0YLTHily/6Ti2mY6HRRAkDjOVboOr/Ou6T1D43kgqEyGP8//H7m0gG6yKL4MbBI3G1SBGm9VGLKLiHjK/7JbCfLAWf+PYg2hr8fa7IlDtOoadLj9IbHILUw7fBWoNye60TiC+PmLyBmkGDceCuA57qwcCWAktnnP4B+tsKR35C7qLVm9YVsullfEOforJkDlB5KbD5BmmRU+PREpgHFLxV8la4WUqsm7Q2oywp1LDrEhYsNQYadRfHjZkly1G91HnhvFCu/CBkbkySYD9nS9Gs8WGWaftBbhAjUyvoTshNU7FAuMyH+hHpEA05A2hDwVVNHyTBLtWq0FWuYD08cQrCGAripNE/+Q7uAiUHkrYAUQMvdxJylxz/mY57/fT/SHuMVJ3GulFb0On3s20RHa/maOhlkFn524r5Gbq3LEe36ktlQZjbgn8/WoqgHBheABTECRQgd49u/Iqq9UlVh6gTzzp3mvTGYyGHnhxeIegRlg3tIiAHTZh0m83lUv4fTqVIKg9fZtA1SCZ/hAdm/S6WgORxFDkSVjGG+OBTbKqszUEXVtu8owvuqehtntUU/tQya9KWVCV6KCXkjLKfDAmGDJLN/sLlO6SraAUenwEUp8NCDnlDLrTjVvNKE+vSHOmmMxud4IaD50zXsKqcXOzXGJ+nxBO+PDc5Fu2oqwMjhO5OcSpr2iwhV4v9+qdabnVHx8LAHhSv1SsuHO
 6pYvoIxJ
 7gzbp2WA56J7QYtm6Ih5/fOHIidjSLqWKtdEP5p1Rh5krgA5GCWKY9KOZf+1k3eFuD9ePndaWQRLuDTlADvbVit05ImTeXH9bszT2NjVXGLwW7mtppqrFn2/+7bt9/UzDxtrZiVj6UMG3BuPQz3RdCehWqVnLW8FeewxPAIdS+tv3jZE0gY4SSQoSPzQ1QQpaetgVEZV+F7w23MWpK3JXf21dIBmflFZq9drEEDZY/Q8+0o1+QGkgnnOyjuXgzk6Z/9/DYHF7upkoHcBy0n6zPGE6+ZH5aDd68iamA1utrJH/QcQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index 084f5d4c7b5e..b83c5797a2d8 100644
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
@@ -1208,10 +1273,10 @@ int main(void)
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


