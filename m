Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 001FFCA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:25:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 168596B00AB; Tue,  6 Oct 2026 05:25:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13FD86B00AC; Tue,  6 Oct 2026 05:25:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFC2C6B00AD; Tue,  6 Oct 2026 05:25:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C133F6B00AB
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:25:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 48B44A677A
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:25:47 +0000 (UTC)
X-FDA: 85291669134.12.F7D4A03
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8110A180002
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:25:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UTfUe9+t;
	spf=pass (imf16.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gATc2EK/Azf03jAa8/ZBpimegjNqHQJpHopE67jga3c=;
	b=QSKjd7ViLMhe38fshxoqZOTQExkoC5DslKoiHuY5S7jqBfa58MZzVZEIUiLMeUrQaDbJcl
	ctPBbjTEPej4McWaHEpD8WsSBMYVUxga35JOSlNRLzHO5v/YwT5ZMevqDpD4+3wNqOwiDM
	mQlW6+25r+UuuarGba/47fVgBPkZjto=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278745;
	b=2xOnYrDdOHNcWqvvzfODmMnw7XIL1xTc14no98oHr9XABLS9NQrLbYGw4TlAlRWS1dsC/s
	CelGsZIe3MipBVrM1+taFDM3oxA5lI1VHi5fJC8mLpPkki0sKP9lXTdpS9kx3xfjsej3MY
	yR4FfOhgTxF9yBIuxqeR7OwbP/lVY2I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UTfUe9+t;
	spf=pass (imf16.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 631501516;
	Tue,  6 Oct 2026 02:25:41 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7CF7C3F763;
	Tue,  6 Oct 2026 02:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791278744; bh=biNTYta7nMi5UAy+JT5hp31UwnSuy52Sh6P4+Rz2EW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTfUe9+tCZoWaSipBevqAZ9ZEKlMudSqGCsInnUKeQrMvdOV3DEv1SdaYGefOGWJ0
	 l0yYt5d7U8lUEgpUp+0R0oDIQ4WuK6nJgy/OtGv3wRvAV8BylYEKZnBk7+js0G8qlY
	 /Q6/4X/3R0HRXWQ8qMy4i/gXucM3INwvhXdNf7Ng=
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
Subject: [PATCH v2 04/12] selftests/mm: mremap_test: use kselftest helpers
Date: Tue,  6 Oct 2026 14:55:03 +0530
Message-ID: <20261006092511.145776-5-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261006092511.145776-1-sarthak.sharma@arm.com>
References: <20261006092511.145776-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8110A180002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: hrx1ie77m8a4beay15g3kiep1hpzhk71
X-HE-Tag: 1791278745-433445
X-HE-Meta: U2FsdGVkX19g9pN75cf9tDcSoq2ZWlk0cppXcMGzDzinfHBc/BVtGXskDc6aixMllZD9yU/ZVIc9779iv1ibAhC2wwBCRYXYdlHWC8bBJYlslKcYRhjyPRdtzNuN0i4AIw3gVW1+OlnPPpnvlo9Gw7mqHhcb8JoPwuZPPZRJmfaRsWbm0AyMssqTnLKlHBJd46VhSRCwWBz7bbiDOoFfjlUeojQmt7gc2cg+vLImqifPALESFXmbHdWTOjhFAfssrs3w3fSSZoJmg8mc1hRAlyBGsL6ZstngHrphjatuAaeN7k5jCR/pCmZNByUgD3lvKd5tEK9AiXmEl4EQngThV9qo0T9MfS2z4wrpTJHnV8LH/6ezgnCMceBhTY9ZcptnsCfW1KU+rYG4/khwkdc3Kq6SOjJLj2XRw7Gp4jDgiNnG7HzXJ8faBIKtICGggTfkvx+y60UKX3I6JeSq+NY03PE24FEeLoHxvPZPNSS1zHCE4RvH9oC8ecjO9YSx/fYCBQV7F3x6XadR6+16SgnhSVMdPI7b9datzENPavPl5b7G9isck8qRN18bVyig/YNwVNzoBEvBfaCO/GEK4rqXNfe3kHBqMmlHsvaPJvusxfXmLVMny8yS6tOVL89tJ5l6YfbKl/kSA8MffPWXumE1YcXnnBndUNiTmrUGpKKpZHvs0B1cx6T2se0Izj0LY63rgSjF9JdIFgzVsk0SawxwC3Rw+0kyCjShnMQU2/uihV5F7Y6JwCOILzRzzpIY0nhZ0PcgpHHsu4QOeZsy1Ab1Hj6Kj+EhJMHZTAGmxPUTsxFQXn0PFdiwqqTAF+fq9gTV8fc8Y+tVbAXQrwgyLUnLgxNjkkgX2onQnxUuQs+XMGWB11nuP6zgGEwhgPkex4i45yYlLs0cXaiVfsA82iU66KPAjDFGv3brVueHrMdAb2rQCap1BG0+R91nNMUi9+swQU1DsZE0GmoXSdcqrPr
 DBx6ij+W
 k9PTF5rMMX+gwM5w2+Z/p8T4RuQ2M96JzSkCGCfniDYtRBKPnt0Q8PYtl/UygvdCiWNQPQUgvibj+pHv1MKRKmhPQG1D8t2s86OPngtxquHINJgYdRZjC5wUgRgzafQaCEGZICpCISX5s7ut3wef4lH1O8h/FS6VC+mu/h9Z3FOPSh9YL456Dc6xq6MMB2vqxwe6MKMZ0P51RqXWMjTvIdPHq7pPnBfk0HECj4lLzPKdBF8zkl4Wi4cmu62GBecSURX01fglSxMhDmDfh/yJd0+OUV6fFFZ4lBfGy//tYoHM5150=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mremap_test currently uses a lot of fprintf() and perror()
calls. It also uses a variable "failures" to track the number
of failed table driven tests.

Use ksft_print_msg() and ksft_perror() for diagnostics.
Remove the variable "failures" and let kselftest counters
handle the final exit status. Use ksft_finished() at
the end instead of manually checking if failures > 0. Replace

if (success)
	ksft_test_result_pass(...);
else
	ksft_test_result_fail(...);

calls with ksft_test_result(success, ...);

Also correct the duplicated "mremap" in "mremap move within
range" and the spelling of "dontunmap".

Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 190 +++++++++--------------
 1 file changed, 73 insertions(+), 117 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 7cf1d235f309..e17edbc23325 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -257,10 +257,7 @@ static void mremap_expand_merge(FILE *maps_fp, unsigned long page_size)
 	munmap(start, 3 * page_size);
 
 out:
-	if (success)
-		ksft_test_result_pass("%s\n", test_name);
-	else
-		ksft_test_result_fail("%s\n", test_name);
+	ksft_test_result(success, "%s\n", test_name);
 }
 
 /*
@@ -297,10 +294,7 @@ static void mremap_expand_merge_offset(FILE *maps_fp, unsigned long page_size)
 	munmap(start, 3 * page_size);
 
 out:
-	if (success)
-		ksft_test_result_pass("%s\n", test_name);
-	else
-		ksft_test_result_fail("%s\n", test_name);
+	ksft_test_result(success, "%s\n", test_name);
 }
 
 /*
@@ -319,7 +313,7 @@ static void mremap_expand_merge_offset(FILE *maps_fp, unsigned long page_size)
  */
 static void mremap_move_within_range(unsigned int pattern_seed, char *rand_addr)
 {
-	char *test_name = "mremap mremap move within range";
+	char *test_name = "mremap move within range";
 	void *src, *dest;
 	unsigned int i, success = 1;
 
@@ -327,7 +321,7 @@ static void mremap_move_within_range(unsigned int pattern_seed, char *rand_addr)
 	void *ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
 			 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	if (ptr == MAP_FAILED) {
-		perror("mmap");
+		ksft_perror("mmap");
 		success = 0;
 		goto out;
 	}
@@ -342,9 +336,9 @@ static void mremap_move_within_range(unsigned int pattern_seed, char *rand_addr)
 	dest = src - SIZE_MB(2);
 
 	void *new_ptr = mremap(src + SIZE_MB(1), SIZE_MB(1), SIZE_MB(1),
-						   MREMAP_MAYMOVE | MREMAP_FIXED, dest + SIZE_MB(1));
+			       MREMAP_MAYMOVE | MREMAP_FIXED, dest + SIZE_MB(1));
 	if (new_ptr == MAP_FAILED) {
-		perror("mremap");
+		ksft_perror("mremap");
 		success = 0;
 		goto out;
 	}
@@ -366,10 +360,7 @@ static void mremap_move_within_range(unsigned int pattern_seed, char *rand_addr)
 out:
 	munmap(ptr, size);
 
-	if (success)
-		ksft_test_result_pass("%s\n", test_name);
-	else
-		ksft_test_result_fail("%s\n", test_name);
+	ksft_test_result(success, "%s\n", test_name);
 }
 
 static bool is_multiple_vma_range_ok(unsigned int pattern_seed,
@@ -414,7 +405,7 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
 	ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
 		   MAP_PRIVATE | MAP_ANON, -1, 0);
 	if (ptr == MAP_FAILED) {
-		perror("mmap");
+		ksft_perror("mmap");
 		success = false;
 		goto out;
 	}
@@ -422,12 +413,12 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
 	tgt_ptr = mmap(NULL, 2 * size, PROT_READ | PROT_WRITE,
 		       MAP_PRIVATE | MAP_ANON, -1, 0);
 	if (tgt_ptr == MAP_FAILED) {
-		perror("mmap");
+		ksft_perror("mmap");
 		success = false;
 		goto out;
 	}
 	if (munmap(tgt_ptr, 2 * size)) {
-		perror("munmap");
+		ksft_perror("munmap");
 		success = false;
 		goto out_unmap;
 	}
@@ -445,7 +436,7 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
 			continue;
 
 		if (munmap(&ptr[i * page_size], page_size)) {
-			perror("munmap");
+			ksft_perror("munmap");
 			success = false;
 			goto out_unmap;
 		}
@@ -465,7 +456,7 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
 
 	/* First, just move the whole thing. */
 	if (mremap(ptr, size, size, mremap_flags, tgt_ptr) == MAP_FAILED) {
-		perror("mremap");
+		ksft_perror("mremap");
 		success = false;
 		goto out_unmap;
 	}
@@ -478,7 +469,7 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
 	/* Move next to itself. */
 	if (mremap(tgt_ptr, size, size, mremap_flags,
 		   &tgt_ptr[size]) == MAP_FAILED) {
-		perror("mremap");
+		ksft_perror("mremap");
 		success = false;
 		goto out_unmap;
 	}
@@ -491,14 +482,14 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
 	/* Map a range to overwrite. */
 	if (mmap(tgt_ptr, size, PROT_NONE,
 		 MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0) == MAP_FAILED) {
-		perror("mmap tgt");
+		ksft_perror("mmap tgt");
 		success = false;
 		goto out_unmap;
 	}
 	/* Move and overwrite. */
 	if (mremap(&tgt_ptr[size], size, size,
 		   mremap_flags, tgt_ptr) == MAP_FAILED) {
-		perror("mremap");
+		ksft_perror("mremap");
 		success = false;
 		goto out_unmap;
 	}
@@ -511,14 +502,8 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
 out_unmap:
 	munmap(tgt_ptr, 2 * size);
 	munmap(ptr, size);
-
 out:
-	if (success)
-		ksft_test_result_pass("%s%s\n", test_name,
-				      dont_unmap ? " [dontunnmap]" : "");
-	else
-		ksft_test_result_fail("%s%s\n", test_name,
-				      dont_unmap ? " [dontunnmap]" : "");
+	ksft_test_result(success, "%s%s\n", test_name, dont_unmap ? " [dontunmap]" : "");
 }
 
 static void mremap_shrink_multiple_vmas(unsigned long page_size,
@@ -534,7 +519,7 @@ static void mremap_shrink_multiple_vmas(unsigned long page_size,
 	ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
 		   MAP_PRIVATE | MAP_ANON, -1, 0);
 	if (ptr == MAP_FAILED) {
-		perror("mmap");
+		ksft_perror("mmap");
 		success = false;
 		goto out;
 	}
@@ -542,12 +527,12 @@ static void mremap_shrink_multiple_vmas(unsigned long page_size,
 	tgt_ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
 		       MAP_PRIVATE | MAP_ANON, -1, 0);
 	if (tgt_ptr == MAP_FAILED) {
-		perror("mmap");
+		ksft_perror("mmap");
 		success = false;
 		goto out;
 	}
 	if (munmap(tgt_ptr, size)) {
-		perror("munmap");
+		ksft_perror("munmap");
 		success = false;
 		goto out_unmap;
 	}
@@ -561,7 +546,7 @@ static void mremap_shrink_multiple_vmas(unsigned long page_size,
 	 */
 	for (i = 1; i < 10; i += 2) {
 		if (munmap(&ptr[i * page_size], page_size)) {
-			perror("munmap");
+			ksft_perror("munmap");
 			success = false;
 			goto out_unmap;
 		}
@@ -581,7 +566,7 @@ static void mremap_shrink_multiple_vmas(unsigned long page_size,
 			     tgt_ptr);
 
 	if (res == MAP_FAILED) {
-		perror("mremap");
+		ksft_perror("mremap");
 		success = false;
 		goto out_unmap;
 	}
@@ -590,12 +575,7 @@ static void mremap_shrink_multiple_vmas(unsigned long page_size,
 	munmap(tgt_ptr, size);
 	munmap(ptr, size);
 out:
-	if (success)
-		ksft_test_result_pass("%s%s\n", test_name,
-				      inplace ? " [inplace]" : "");
-	else
-		ksft_test_result_fail("%s%s\n", test_name,
-				      inplace ? " [inplace]" : "");
+	ksft_test_result(success, "%s%s\n", test_name, inplace ? " [inplace]" : "");
 }
 
 static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
@@ -615,7 +595,7 @@ static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
 	ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
 		   MAP_PRIVATE | MAP_ANON, -1, 0);
 	if (ptr == MAP_FAILED) {
-		perror("mmap");
+		ksft_perror("mmap");
 		success = false;
 		goto out;
 	}
@@ -623,12 +603,12 @@ static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
 	tgt_ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
 		       MAP_PRIVATE | MAP_ANON, -1, 0);
 	if (tgt_ptr == MAP_FAILED) {
-		perror("mmap");
+		ksft_perror("mmap");
 		success = false;
 		goto out;
 	}
 	if (munmap(tgt_ptr, size)) {
-		perror("munmap");
+		ksft_perror("munmap");
 		success = false;
 		goto out_unmap;
 	}
@@ -642,7 +622,7 @@ static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
 	 *  0 1 2 3 4   5 6 7 8 9  pattern offset
 	 */
 	if (munmap(&ptr[5 * page_size], page_size)) {
-		perror("munmap");
+		ksft_perror("munmap");
 		success = false;
 		goto out_unmap;
 	}
@@ -678,7 +658,7 @@ static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
 	 */
 	if (mremap(&ptr[2 * page_size], size - 3 * page_size, size - 3 * page_size,
 		   mremap_flags, tgt_ptr) == MAP_FAILED) {
-		perror("mremap");
+		ksft_perror("mremap");
 		success = false;
 		goto out_unmap;
 	}
@@ -711,12 +691,7 @@ static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
 	munmap(tgt_ptr, size);
 	munmap(ptr, size);
 out:
-	if (success)
-		ksft_test_result_pass("%s%s\n", test_name,
-				      dont_unmap ? " [dontunnmap]" : "");
-	else
-		ksft_test_result_fail("%s%s\n", test_name,
-				      dont_unmap ? " [dontunnmap]" : "");
+	ksft_test_result(success, "%s%s\n", test_name, dont_unmap ? " [dontunmap]" : "");
 }
 
 #ifdef __NR_userfaultfd
@@ -737,15 +712,15 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 	uffd = syscall(__NR_userfaultfd, O_NONBLOCK);
 	if (uffd == -1) {
 		if (errno == EPERM) {
-			ksft_test_result_skip("%s - missing uffd", test_name);
+			ksft_test_result_skip("%s - missing uffd\n", test_name);
 			return;
 		}
-		perror("userfaultfd");
+		ksft_perror("userfaultfd");
 		success = false;
 		goto out;
 	}
 	if (ioctl(uffd, UFFDIO_API, &api)) {
-		perror("ioctl UFFDIO_API");
+		ksft_perror("ioctl UFFDIO_API");
 		success = false;
 		goto out_close_uffd;
 	}
@@ -753,19 +728,19 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 	ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
 		   MAP_PRIVATE | MAP_ANON, -1, 0);
 	if (ptr == MAP_FAILED) {
-		perror("mmap");
+		ksft_perror("mmap");
 		success = false;
 		goto out_close_uffd;
 	}
 
 	tgt_ptr = mmap(NULL, size, PROT_NONE, MAP_PRIVATE | MAP_ANON, -1, 0);
 	if (tgt_ptr == MAP_FAILED) {
-		perror("mmap");
+		ksft_perror("mmap");
 		success = false;
 		goto out_close_uffd;
 	}
 	if (munmap(tgt_ptr, size)) {
-		perror("munmap");
+		ksft_perror("munmap");
 		success = false;
 		goto out_unmap;
 	}
@@ -791,12 +766,12 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 		};
 
 		if (ioctl(uffd, UFFDIO_REGISTER, &reg) == -1) {
-			perror("ioctl UFFDIO_REGISTER");
+			ksft_perror("ioctl UFFDIO_REGISTER");
 			success = false;
 			goto out_unmap;
 		}
 		if (munmap(unmap_ptr, page_size)) {
-			perror("munmap");
+			ksft_perror("munmap");
 			success = false;
 			goto out_unmap;
 		}
@@ -810,18 +785,17 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 	 */
 	res = mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_FIXED, tgt_ptr);
 	if (res != MAP_FAILED) {
-		fprintf(stderr, "mremap() succeeded for multi VMA uffd armed\n");
+		ksft_print_msg("mremap() succeeded for multi VMA uffd armed\n");
 		success = false;
 		goto out_unmap;
 	}
 	if (errno != EFAULT) {
-		perror("mremap() unexpected error");
+		ksft_perror("mremap() unexpected error");
 		success = false;
 		goto out_unmap;
 	}
 	if (is_ptr_mapped(maps_fp, tgt_ptr, page_size)) {
-		fprintf(stderr,
-			"Invalid uffd-armed VMA at start of multi range moved\n");
+		ksft_print_msg("Invalid uffd-armed VMA at start of multi range moved\n");
 		success = false;
 		goto out_unmap;
 	}
@@ -833,7 +807,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 	res = mremap(ptr, page_size, page_size,
 		     MREMAP_MAYMOVE | MREMAP_FIXED, tgt_ptr);
 	if (res == MAP_FAILED) {
-		perror("mremap single invalid-multi VMA");
+		ksft_perror("mremap single invalid-multi VMA");
 		success = false;
 		goto out_unmap;
 	}
@@ -843,14 +817,14 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 	 * move valid) VMA at the start of ptr range.
 	 */
 	if (munmap(tgt_ptr, page_size)) {
-		perror("munmap");
+		ksft_perror("munmap");
 		success = false;
 		goto out_unmap;
 	}
 	res = mmap(ptr, page_size, PROT_READ | PROT_WRITE,
 		   MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
 	if (res == MAP_FAILED) {
-		perror("mmap");
+		ksft_perror("mmap");
 		success = false;
 		goto out_unmap;
 	}
@@ -861,17 +835,17 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 	 */
 	res = mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_FIXED, tgt_ptr);
 	if (res != MAP_FAILED) {
-		fprintf(stderr, "mremap() succeeded for multi VMA uffd armed\n");
+		ksft_print_msg("mremap() succeeded for multi VMA uffd armed\n");
 		success = false;
 		goto out_unmap;
 	}
 	if (errno != EFAULT) {
-		perror("mremap() unexpected error");
+		ksft_perror("mremap() unexpected error");
 		success = false;
 		goto out_unmap;
 	}
 	if (!is_ptr_mapped(maps_fp, tgt_ptr, page_size)) {
-		fprintf(stderr, "Valid VMA not moved\n");
+		ksft_print_msg("Valid VMA not moved\n");
 		success = false;
 		goto out_unmap;
 	}
@@ -882,12 +856,12 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 	 * multi-move VMAs.
 	 */
 	if (munmap(tgt_ptr, page_size)) {
-		perror("munmap");
+		ksft_perror("munmap");
 		success = false;
 		goto out_unmap;
 	}
 	if (munmap(ptr, size - 2 * page_size)) {
-		perror("munmap");
+		ksft_perror("munmap");
 		success = false;
 		goto out_unmap;
 	}
@@ -896,7 +870,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 			   PROT_READ | PROT_WRITE,
 			   MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
 		if (res == MAP_FAILED) {
-			perror("mmap");
+			ksft_perror("mmap");
 			success = false;
 			goto out_unmap;
 		}
@@ -908,12 +882,12 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 	 */
 	res = mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_FIXED, tgt_ptr);
 	if (res != MAP_FAILED) {
-		fprintf(stderr, "mremap() succeeded for multi VMA uffd armed\n");
+		ksft_print_msg("mremap() succeeded for multi VMA uffd armed\n");
 		success = false;
 		goto out_unmap;
 	}
 	if (errno != EFAULT) {
-		perror("mremap() unexpected error");
+		ksft_perror("mremap() unexpected error");
 		success = false;
 		goto out_unmap;
 	}
@@ -923,11 +897,11 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 				&tgt_ptr[i * page_size], page_size);
 
 		if (i < 8 && !is_mapped) {
-			fprintf(stderr, "Valid VMA not moved at %d\n", i);
+			ksft_print_msg("Valid VMA not moved at %d\n", i);
 			success = false;
 			goto out_unmap;
 		} else if (i == 8 && is_mapped) {
-			fprintf(stderr, "Invalid VMA moved at %d\n", i);
+			ksft_print_msg("Invalid VMA moved at %d\n", i);
 			success = false;
 			goto out_unmap;
 		}
@@ -939,17 +913,14 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 out_close_uffd:
 	close(uffd);
 out:
-	if (success)
-		ksft_test_result_pass("%s\n", test_name);
-	else
-		ksft_test_result_fail("%s\n", test_name);
+	ksft_test_result(success, "%s\n", test_name);
 }
 #else
 static void mremap_move_multi_invalid_vmas(FILE *maps_fp, unsigned long page_size)
 {
 	char *test_name = "mremap move multiple invalid vmas";
 
-	ksft_test_result_skip("%s - missing uffd", test_name);
+	ksft_test_result_skip("%s - missing uffd\n", test_name);
 }
 #endif /* __NR_userfaultfd */
 
@@ -1020,7 +991,7 @@ static long long remap_region(struct config c, unsigned int threshold_mb,
 
 	clock_gettime(CLOCK_MONOTONIC, &t_start);
 	dest_addr = mremap(src_addr, c.region_size, c.region_size,
-					  MREMAP_MAYMOVE|MREMAP_FIXED, (char *) addr);
+			   MREMAP_MAYMOVE | MREMAP_FIXED, (char *)addr);
 	clock_gettime(CLOCK_MONOTONIC, &t_end);
 
 	if (dest_addr == MAP_FAILED) {
@@ -1106,9 +1077,9 @@ static void mremap_move_1mb_from_start(unsigned int pattern_seed,
 	munmap(dest, SIZE_MB(1));
 
 	void *new_ptr = mremap(src + SIZE_MB(1), SIZE_MB(1), SIZE_MB(1),
-						   MREMAP_MAYMOVE | MREMAP_FIXED, dest + SIZE_MB(1));
+			       MREMAP_MAYMOVE | MREMAP_FIXED, dest + SIZE_MB(1));
 	if (new_ptr == MAP_FAILED) {
-		perror("mremap");
+		ksft_perror("mremap");
 		success = 0;
 		goto out;
 	}
@@ -1134,13 +1105,10 @@ static void mremap_move_1mb_from_start(unsigned int pattern_seed,
 	if (dest)
 		munmap(dest, c.region_size);
 
-	if (success)
-		ksft_test_result_pass("%s\n", test_name);
-	else
-		ksft_test_result_fail("%s\n", test_name);
+	ksft_test_result(success, "%s\n", test_name);
 }
 
-static void run_mremap_test_case(struct test test_case, int *failures,
+static void run_mremap_test_case(struct test test_case,
 				 unsigned int threshold_mb,
 				 char *rand_addr)
 {
@@ -1148,27 +1116,22 @@ static void run_mremap_test_case(struct test test_case, int *failures,
 					    rand_addr);
 
 	if (remap_time < 0) {
-		if (test_case.expect_failure) {
-			ksft_print_msg("%s: expected mremap failure\n",
-				       test_case.name);
-			ksft_test_result_xfail("%s\n", test_case.name);
-		} else {
+		if (test_case.expect_failure)
+			ksft_test_result_xfail("%s: expected mremap failure\n",
+					       test_case.name);
+		else
 			ksft_test_result_fail("%s\n", test_case.name);
-			*failures += 1;
-		}
 	} else {
 		/*
 		 * Comparing mremap time is only applicable if entire region
 		 * was faulted in.
 		 */
 		if (threshold_mb == VALIDATION_NO_THRESHOLD ||
-		    test_case.config.region_size <= threshold_mb * _1MB) {
-			ksft_print_msg("%s: mremap time: %12lldns\n",
-				       test_case.name, remap_time);
-			ksft_test_result_pass("%s\n", test_case.name);
-		} else {
+		    test_case.config.region_size <= threshold_mb * _1MB)
+			ksft_test_result_pass("%s: mremap time: %12lldns\n",
+					      test_case.name, remap_time);
+		else
 			ksft_test_result_pass("%s\n", test_case.name);
-		}
 	}
 }
 
@@ -1176,7 +1139,6 @@ static void run_mremap_test_case(struct test test_case, int *failures,
 #define MAX_PERF_TEST 3
 int main(void)
 {
-	int failures = 0;
 	unsigned int i;
 	int run_perf_tests;
 	unsigned int threshold_mb = VALIDATION_DEFAULT_THRESHOLD;
@@ -1222,10 +1184,8 @@ int main(void)
 
 	rand_addr = (char *)mmap(NULL, rand_size, PROT_READ | PROT_WRITE,
 				 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-	if (rand_addr == MAP_FAILED) {
-		perror("mmap");
-		ksft_exit_fail_msg("cannot mmap rand_addr\n");
-	}
+	if (rand_addr == MAP_FAILED)
+		ksft_exit_fail_perror("cannot mmap rand_addr");
 
 	/* fill stream of random bytes */
 	srand(pattern_seed);
@@ -1302,8 +1262,7 @@ int main(void)
 		      ARRAY_SIZE(perf_test_cases) : 0) + num_expand_tests + num_misc_tests);
 
 	for (i = 0; i < ARRAY_SIZE(test_cases); i++)
-		run_mremap_test_case(test_cases[i], &failures, threshold_mb,
-				     rand_addr);
+		run_mremap_test_case(test_cases[i], threshold_mb, rand_addr);
 
 	maps_fp = fopen("/proc/self/maps", "r");
 
@@ -1328,18 +1287,15 @@ int main(void)
 	fclose(maps_fp);
 
 	if (run_perf_tests) {
-		ksft_print_msg("\n%s\n",
+		ksft_print_msg("%s\n",
 		 "mremap HAVE_MOVE_PMD/PUD optimization time comparison for 1GB region:");
 		for (i = 0; i < ARRAY_SIZE(perf_test_cases); i++)
-			run_mremap_test_case(perf_test_cases[i], &failures,
+			run_mremap_test_case(perf_test_cases[i],
 					     threshold_mb,
 					     rand_addr);
 	}
 
 	munmap(rand_addr, rand_size);
 
-	if (failures > 0)
-		ksft_exit_fail();
-	else
-		ksft_exit_pass();
+	ksft_finished();
 }
-- 
2.53.0


