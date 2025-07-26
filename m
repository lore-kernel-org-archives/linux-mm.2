Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC915C87FCE
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 02:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDE926B0089; Fri, 25 Jul 2025 22:52:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E90696B008A; Fri, 25 Jul 2025 22:52:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7E1C6B008C; Fri, 25 Jul 2025 22:52:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C66516B0089
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 22:52:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8FFE21DBD3D
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 02:52:34 +0000 (UTC)
X-FDA: 83704892628.06.034B95F
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8D21C180008
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 02:52:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AHKI9jCv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753498352; a=rsa-sha256;
	cv=none;
	b=8dpzCCZsuQ92sl7hKhyjTzEKF+SfN178xWJho4EFGtnmzZLaLdAwaSJ6mIdUM4I0j7Ao9/
	EFbQcTh4fhGiJM2waIGye8lyR9dfSD2nONj/pEooAuXijkZaNosOO7Q5js1I3m0uVZArQT
	dcyxISsXXIolj18iFM20kmHKfdMmsPk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AHKI9jCv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753498352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=XA2DWUmJXxSVRhSFXKo1W9gaB6aCxJ1l0ygM6EclJyI=;
	b=m2BgGl8634Hl7G9fKC30bhPt/7Tm9BgvGjykXu3514W2BdgujJRyvY1orBISJT60wwzFOS
	4Nl35xZL8HjQ4GsMSIjy5j6QL3XEOjnU/pjH53qU4eaKmkZKyZ6Tkg3Sf3b/ObwM6LEiLC
	XyvqCd9DDYttMYJMYWEfPanb04hcrgE=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ae6f8d3bcd4so517748266b.1
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753498351; x=1754103151; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XA2DWUmJXxSVRhSFXKo1W9gaB6aCxJ1l0ygM6EclJyI=;
        b=AHKI9jCv3cN+qdBs7Hb94MUjl0eNXoyr8eTpEKHttYKS8CLCXmR7VJRReSF70oaw9Z
         38HEyRfyuZsm7eQU5RGo3ve8yfb5bmeBtHcEZOlwL/gUeASLZqPGqE0eaHpl6o53w2Lz
         WjFeN5YQ4gNhMki/lNTaF3VdZ+WhUbmrBF/rQBvohBh9TuDDampemDa/USawrCxUSlHX
         IjZufVdr+fiCWgdQHq0Zbgk6y+hHetruFBcGkCkFvaeQEtgbPM5AZ+sXUIIhAuC+TqQI
         vBvZxXcOp4YzIJf/eZ4lbve5tRaEDT9t9W83DX1zdr51xkg1JAFJUJPrVGPoWUCyLTSE
         xKKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753498351; x=1754103151;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XA2DWUmJXxSVRhSFXKo1W9gaB6aCxJ1l0ygM6EclJyI=;
        b=uOtNTAQ4V0WVmrNr1+CsVT4IwGMLxr9bU07loGDnPwBWqdHzaFanOD+vg1oOxJ6WSM
         fAR9ZgPBARurEKqhQvVmJTxIO2JhzdD4R9XNCMw7/TqAKmpoaU/FyFgxqIqg/hvchWzB
         P1xXD5zsNiGtyZXeF+btoMm+ZFhJhukGUiaHAVsRj1a2IZTKfDIBDDayJqQykRHQmPo3
         3cl7cXVTs570KCv9sYDEvfnMYe7+jrx3sDntfhPVjrZNxilN8jQ4RBQDdnLOvQeM1xPz
         Cg1Uphl/dMOej12RLVJBxWw7wBLKjGMvWQAy9SjBS04QBOsf8b7ciQPUFVGTfYtzDod1
         er7A==
X-Gm-Message-State: AOJu0YzPxpdX+KhVrltY3+Wxl5XinbqhuYRwzxHr8ShPG+Gtc9v2unrb
	O9t2oAAUC3S+9ND97p0OuoWiHrFE1g/lkrAGvprQfGy2EFYuZxP8uPQdZ7G2WP5K
X-Gm-Gg: ASbGncvuyp6xFM4huTte4T98oH+QZwDR6nahBxmNmhacO/rocpkVG5jJEQf5U7+vmgY
	sOWdOfbtBUXW8ZG4LNkEWfABV4mPdIIME1T4XRs359lmHchcLZ3sv7a/qY4e5vGA1EGdddAdsUz
	73i+paMBVuAg2cz8OQtwtP3y3Gkfoi8PP49app2QODbAirv9/p0VxCZ5T44aev4KAy9LnkbThfa
	vy4YC/hOL5y4/dScyLDZycFIIU7uDv2r/ij1Su3s7sTWKbsPsdR0z2uaokvpnd95DiplJ/BnNnh
	Li6MtwU+U330havRuM1BzOQakpTm1coedNW0uuTdksN+/+PAxuHXjmTCOxx3LOZnpKrhLFtX2ba
	vzY4L1j9FBo9yeIgWMAR4+A==
X-Google-Smtp-Source: AGHT+IF0fRUJ9SsEsR4E+H3Lsr+tw4jhvi+aRDYUt5tyQAVlRJfuxvVAT8TbHFsCLjdxVmBz7K0+Lg==
X-Received: by 2002:a17:907:3f16:b0:ade:7c6:498a with SMTP id a640c23a62f3a-af616efc035mr496577666b.10.1753498350756;
        Fri, 25 Jul 2025 19:52:30 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af6358a0933sm76664866b.54.2025.07.25.19.52.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 25 Jul 2025 19:52:30 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>
Subject: [Patch v2 1/2] selftests/mm: put general ksm operation into vm_util
Date: Sat, 26 Jul 2025 02:52:22 +0000
Message-Id: <20250726025223.350-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20250726025223.350-1-richard.weiyang@gmail.com>
References: <20250726025223.350-1-richard.weiyang@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8D21C180008
X-Stat-Signature: 193obabonxxoz9aefasrgzta1ohxtaoy
X-HE-Tag: 1753498352-573146
X-HE-Meta: U2FsdGVkX1/BE/d5PpLyBwitX2lJrT2R9jfscTdnkasFTkzX/CREkLm0xnDuMNwKV9xyzUM3yhM8fnui6NjjkOqRwPfhDhPZpXSkZyLrgRTdCFZ9V1knsWKi6JWD/eRM4Ul4BziRYbr64t4N8jf0jTFMrECEDkfgqovsYPKKNLFv1/O6crkMYOIZcCYHorkpemTAvygKLhPlgO2Fm2LJ2/vJdnZz41935/ptt2VYSLzglbbyjneoE4CoL7MxUzET5bgQesyvuSQGBSF8jIh7vfDWmGO261ELK7sUp4utdvgX5CxqWp4xif9el4GUWSdAWBX8pterQCNyFH7z8oyasXY2o7jDh6eDzJwnF1Lc35nnziefu/iE1HQb9+x0FSlCW5TiUe3dmyTsRoiNsAm7o///D9WYgixiMGKrQLFSBfwCiTQFIvIfAFGQ8GN1P+JVjqdZNTWkku3cHmN71glY/o8szmUJqK0qPm5/xuHYyw+xejB10VBfIyJwXPuJq8UG9ZiwjHyIYJg++q+51haCYrzjXx5J2GnMgDJ89jIQ+w4FM3gP+7nbGt4NN6gVTl3ZFHjM9ZyhtlsjhPk63XIuaLa2sQl4DBl+5xNmuMLZuRQK3Pssn8quw5uWQkhLJIYizX5MwZO2GV7ofw81KpYCVVCjnwdY6UBFojJeeF3qGGNNJuGqen9MtoYb6cu8J30Bb4P9OnADfnBszqcMgUpeV/9TaZ6gXOgAqxslzW7BAFOijrSYF9rkw9/+xw/zx4JI+hb7h49xYOcoVmUEIA2S8ME1qWb47sDQ67sD+uqKvqtDe9io2T0FwWQQnVvtl+wfEO8VUvCzDy0pzacanBzzkpqDOGnn3RrcVDU5Ydz1OP2dxSyZpUPio+zlbKeaxxJtq83ups6BtEH/rh376obfm9lBZL7IABrR+vamkyY6B2L200B/vlGeFf+vAd6asyhE0OOmll/NPHJRQmvN474
 yDPA6/ci
 Bb8UrHCKbOVdma30QwcwI2ZgBMeTJmhl4P9MzQMByTfQiEceapHGpUqS5EgX+83hfx/XTVY21jeIv9tu342Z7eoudGgV21cFI+VgpbfS93V7FpQ94gU0VffsJWQX9YaWdMlIqVzKxZWe4HkgAfaoRdNaQMynceCLZorSrNGSFNgg1fI884IQZzyqVZ1+PDaTVaz89w5MspS3Y5eY3IK3PS+s2IPPpDUhUe+cduZbHW2SW/s+LTqt4sEySKNffbmoKtyt5oSQ5ZlEHWAJpz9P4wNjSExMKu3zB+Q0yw/JJ6dCbeFQGV/0Gzfu4abCZWuTHAOaFBjHCUEzp+8RPPQaGofA+UxcclERoB/f4SoKurARRuHAVwzk6arlQiRUA7wQuobITWhPFAGVUS2LmrmP5o4yuTFnq065RhHW4nm5sfx9iQi/9zp5yOB/o88Tscy62p/oFawMMP1nswVT9g+ZPKlbr7+yNeVwyda7rSi8J1lPQjx3ctSRXv9py/X1O3cG5RdfdqZqEnYU5ZkfqKkDrmKc+vv8hnsYGXdrrDbeqBnaRVaEtwFwbSYdYkkkpvfCVRhBWe6yJXOMumXoZZO4Kj2KDu2AAXOhcpT1faT3nBE5Y5gFj0rHu2xphxtk6xzgXfOXOC/rckfBpFWAAa0acN/erCyTzLRvU5KZ6sMXPAjvbU80=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are some general ksm operations could be used by other related
test case. Put them into vm_util for common use.

This is a preparation patch for later use.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>

---
v2:
  * do check on file opening in init_global_file_handlers()
  * factor out ksm_merge() and ksm_unmerge() instead of partial of it
  * align the return value of helpers: 0 on success, -errno on error
v1: open/close fd in function itself instead of pass as parameter
---
 .../selftests/mm/ksm_functional_tests.c       | 128 +++---------------
 tools/testing/selftests/mm/vm_util.c          | 123 +++++++++++++++++
 tools/testing/selftests/mm/vm_util.h          |   7 +
 3 files changed, 147 insertions(+), 111 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index d8bd1911dfc0..bab74455d70b 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -38,11 +38,6 @@ enum ksm_merge_mode {
 };
 
 static int mem_fd;
-static int ksm_fd;
-static int ksm_full_scans_fd;
-static int proc_self_ksm_stat_fd;
-static int proc_self_ksm_merging_pages_fd;
-static int ksm_use_zero_pages_fd;
 static int pagemap_fd;
 static size_t pagesize;
 
@@ -73,88 +68,6 @@ static bool range_maps_duplicates(char *addr, unsigned long size)
 	return false;
 }
 
-static long get_my_ksm_zero_pages(void)
-{
-	char buf[200];
-	char *substr_ksm_zero;
-	size_t value_pos;
-	ssize_t read_size;
-	unsigned long my_ksm_zero_pages;
-
-	if (!proc_self_ksm_stat_fd)
-		return 0;
-
-	read_size = pread(proc_self_ksm_stat_fd, buf, sizeof(buf) - 1, 0);
-	if (read_size < 0)
-		return -errno;
-
-	buf[read_size] = 0;
-
-	substr_ksm_zero = strstr(buf, "ksm_zero_pages");
-	if (!substr_ksm_zero)
-		return 0;
-
-	value_pos = strcspn(substr_ksm_zero, "0123456789");
-	my_ksm_zero_pages = strtol(substr_ksm_zero + value_pos, NULL, 10);
-
-	return my_ksm_zero_pages;
-}
-
-static long get_my_merging_pages(void)
-{
-	char buf[10];
-	ssize_t ret;
-
-	if (proc_self_ksm_merging_pages_fd < 0)
-		return proc_self_ksm_merging_pages_fd;
-
-	ret = pread(proc_self_ksm_merging_pages_fd, buf, sizeof(buf) - 1, 0);
-	if (ret <= 0)
-		return -errno;
-	buf[ret] = 0;
-
-	return strtol(buf, NULL, 10);
-}
-
-static long ksm_get_full_scans(void)
-{
-	char buf[10];
-	ssize_t ret;
-
-	ret = pread(ksm_full_scans_fd, buf, sizeof(buf) - 1, 0);
-	if (ret <= 0)
-		return -errno;
-	buf[ret] = 0;
-
-	return strtol(buf, NULL, 10);
-}
-
-static int ksm_merge(void)
-{
-	long start_scans, end_scans;
-
-	/* Wait for two full scans such that any possible merging happened. */
-	start_scans = ksm_get_full_scans();
-	if (start_scans < 0)
-		return start_scans;
-	if (write(ksm_fd, "1", 1) != 1)
-		return -errno;
-	do {
-		end_scans = ksm_get_full_scans();
-		if (end_scans < 0)
-			return end_scans;
-	} while (end_scans < start_scans + 2);
-
-	return 0;
-}
-
-static int ksm_unmerge(void)
-{
-	if (write(ksm_fd, "2", 1) != 1)
-		return -errno;
-	return 0;
-}
-
 static char *__mmap_and_merge_range(char val, unsigned long size, int prot,
 				  enum ksm_merge_mode mode)
 {
@@ -163,12 +76,12 @@ static char *__mmap_and_merge_range(char val, unsigned long size, int prot,
 	int ret;
 
 	/* Stabilize accounting by disabling KSM completely. */
-	if (ksm_unmerge()) {
+	if (ksm_stop() < 0) {
 		ksft_print_msg("Disabling (unmerging) KSM failed\n");
 		return err_map;
 	}
 
-	if (get_my_merging_pages() > 0) {
+	if (ksm_get_self_merging_pages() > 0) {
 		ksft_print_msg("Still pages merged\n");
 		return err_map;
 	}
@@ -218,7 +131,7 @@ static char *__mmap_and_merge_range(char val, unsigned long size, int prot,
 	}
 
 	/* Run KSM to trigger merging and wait. */
-	if (ksm_merge()) {
+	if (ksm_start() < 0) {
 		ksft_print_msg("Running KSM failed\n");
 		goto unmap;
 	}
@@ -227,7 +140,7 @@ static char *__mmap_and_merge_range(char val, unsigned long size, int prot,
 	 * Check if anything was merged at all. Ignore the zero page that is
 	 * accounted differently (depending on kernel support).
 	 */
-	if (val && !get_my_merging_pages()) {
+	if (val && !ksm_get_self_merging_pages()) {
 		ksft_print_msg("No pages got merged\n");
 		goto unmap;
 	}
@@ -286,15 +199,12 @@ static void test_unmerge_zero_pages(void)
 
 	ksft_print_msg("[RUN] %s\n", __func__);
 
-	if (proc_self_ksm_stat_fd < 0) {
-		ksft_test_result_skip("open(\"/proc/self/ksm_stat\") failed\n");
-		return;
-	}
-	if (ksm_use_zero_pages_fd < 0) {
-		ksft_test_result_skip("open \"/sys/kernel/mm/ksm/use_zero_pages\" failed\n");
+	if (ksm_get_self_zero_pages() < 0) {
+		ksft_test_result_skip("accessing \"/proc/self/ksm_stat\" failed\n");
 		return;
 	}
-	if (write(ksm_use_zero_pages_fd, "1", 1) != 1) {
+
+	if (ksm_use_zero_pages() < 0) {
 		ksft_test_result_skip("write \"/sys/kernel/mm/ksm/use_zero_pages\" failed\n");
 		return;
 	}
@@ -306,7 +216,7 @@ static void test_unmerge_zero_pages(void)
 
 	/* Check if ksm_zero_pages is updated correctly after KSM merging */
 	pages_expected = size / pagesize;
-	if (pages_expected != get_my_ksm_zero_pages()) {
+	if (pages_expected != ksm_get_self_zero_pages()) {
 		ksft_test_result_fail("'ksm_zero_pages' updated after merging\n");
 		goto unmap;
 	}
@@ -319,7 +229,7 @@ static void test_unmerge_zero_pages(void)
 
 	/* Check if ksm_zero_pages is updated correctly after unmerging */
 	pages_expected /= 2;
-	if (pages_expected != get_my_ksm_zero_pages()) {
+	if (pages_expected != ksm_get_self_zero_pages()) {
 		ksft_test_result_fail("'ksm_zero_pages' updated after unmerging\n");
 		goto unmap;
 	}
@@ -329,7 +239,7 @@ static void test_unmerge_zero_pages(void)
 		*((unsigned int *)&map[offs]) = offs;
 
 	/* Now we should have no zeropages remaining. */
-	if (get_my_ksm_zero_pages()) {
+	if (ksm_get_self_zero_pages()) {
 		ksft_test_result_fail("'ksm_zero_pages' updated after write fault\n");
 		goto unmap;
 	}
@@ -685,19 +595,15 @@ static void init_global_file_handles(void)
 	mem_fd = open("/proc/self/mem", O_RDWR);
 	if (mem_fd < 0)
 		ksft_exit_fail_msg("opening /proc/self/mem failed\n");
-	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
-	if (ksm_fd < 0)
-		ksft_exit_skip("open(\"/sys/kernel/mm/ksm/run\") failed\n");
-	ksm_full_scans_fd = open("/sys/kernel/mm/ksm/full_scans", O_RDONLY);
-	if (ksm_full_scans_fd < 0)
-		ksft_exit_skip("open(\"/sys/kernel/mm/ksm/full_scans\") failed\n");
+	if (ksm_stop() < 0)
+		ksft_exit_skip("accessing \"/sys/kernel/mm/ksm/run\") failed\n");
+	if (ksm_get_full_scans() < 0)
+		ksft_exit_skip("accessing \"/sys/kernel/mm/ksm/full_scans\") failed\n");
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_skip("open(\"/proc/self/pagemap\") failed\n");
-	proc_self_ksm_stat_fd = open("/proc/self/ksm_stat", O_RDONLY);
-	proc_self_ksm_merging_pages_fd = open("/proc/self/ksm_merging_pages",
-						O_RDONLY);
-	ksm_use_zero_pages_fd = open("/sys/kernel/mm/ksm/use_zero_pages", O_RDWR);
+	if (ksm_get_self_merging_pages() < 0)
+		ksft_exit_skip("accessing \"/proc/self/ksm_merging_pages\") failed\n");
 }
 
 int main(int argc, char **argv)
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 9dafa7669ef9..c0b82e9eaa9f 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -555,3 +555,126 @@ bool detect_huge_zeropage(void)
 	close(fd);
 	return enabled;
 }
+
+long ksm_get_self_zero_pages(void)
+{
+	int proc_self_ksm_stat_fd;
+	char buf[200];
+	char *substr_ksm_zero;
+	size_t value_pos;
+	ssize_t read_size;
+
+	proc_self_ksm_stat_fd = open("/proc/self/ksm_stat", O_RDONLY);
+	if (proc_self_ksm_stat_fd < 0)
+		return -errno;
+
+	read_size = pread(proc_self_ksm_stat_fd, buf, sizeof(buf) - 1, 0);
+	close(proc_self_ksm_stat_fd);
+	if (read_size < 0)
+		return -errno;
+
+	buf[read_size] = 0;
+
+	substr_ksm_zero = strstr(buf, "ksm_zero_pages");
+	if (!substr_ksm_zero)
+		return 0;
+
+	value_pos = strcspn(substr_ksm_zero, "0123456789");
+	return strtol(substr_ksm_zero + value_pos, NULL, 10);
+}
+
+long ksm_get_self_merging_pages(void)
+{
+	int proc_self_ksm_merging_pages_fd;
+	char buf[10];
+	ssize_t ret;
+
+	proc_self_ksm_merging_pages_fd = open("/proc/self/ksm_merging_pages",
+						O_RDONLY);
+	if (proc_self_ksm_merging_pages_fd < 0)
+		return -errno;
+
+	ret = pread(proc_self_ksm_merging_pages_fd, buf, sizeof(buf) - 1, 0);
+	close(proc_self_ksm_merging_pages_fd);
+	if (ret <= 0)
+		return -errno;
+	buf[ret] = 0;
+
+	return strtol(buf, NULL, 10);
+}
+
+long ksm_get_full_scans(void)
+{
+	int ksm_full_scans_fd;
+	char buf[10];
+	ssize_t ret;
+
+	ksm_full_scans_fd = open("/sys/kernel/mm/ksm/full_scans", O_RDONLY);
+	if (ksm_full_scans_fd < 0)
+		return -errno;
+
+	ret = pread(ksm_full_scans_fd, buf, sizeof(buf) - 1, 0);
+	close(ksm_full_scans_fd);
+	if (ret <= 0)
+		return -errno;
+	buf[ret] = 0;
+
+	return strtol(buf, NULL, 10);
+}
+
+int ksm_use_zero_pages(void)
+{
+	int ksm_use_zero_pages_fd;
+	ssize_t ret;
+
+	ksm_use_zero_pages_fd = open("/sys/kernel/mm/ksm/use_zero_pages", O_RDWR);
+	if (ksm_use_zero_pages_fd < 0)
+		return -errno;
+
+	ret = write(ksm_use_zero_pages_fd, "1", 1);
+	close(ksm_use_zero_pages_fd);
+	return ret == 1 ? 0 : -errno;
+}
+
+int ksm_start(void)
+{
+	int ksm_fd;
+	ssize_t ret;
+	long start_scans, end_scans;
+
+	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
+	if (ksm_fd < 0)
+		return -errno;
+
+	/* Wait for two full scans such that any possible merging happened. */
+	start_scans = ksm_get_full_scans();
+	if (start_scans < 0) {
+		close(ksm_fd);
+		return start_scans;
+	}
+	ret = write(ksm_fd, "1", 1);
+	close(ksm_fd);
+	if (ret != 1)
+		return -errno;
+	do {
+		end_scans = ksm_get_full_scans();
+		if (end_scans < 0)
+			return end_scans;
+	} while (end_scans < start_scans + 2);
+
+	return 0;
+}
+
+int ksm_stop(void)
+{
+	int ksm_fd;
+	ssize_t ret;
+
+	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
+	if (ksm_fd < 0)
+		return -errno;
+
+	ret = write(ksm_fd, "2", 1);
+	close(ksm_fd);
+	return ret == 1 ? 0 : -errno;
+}
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index c20298ae98ea..ba84ec17d04a 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -129,6 +129,13 @@ static inline void log_test_result(int result)
 void *sys_mremap(void *old_address, unsigned long old_size,
 		 unsigned long new_size, int flags, void *new_address);
 
+long ksm_get_self_zero_pages(void);
+long ksm_get_self_merging_pages(void);
+long ksm_get_full_scans(void);
+int ksm_use_zero_pages(void);
+int ksm_start(void);
+int ksm_stop(void);
+
 /*
  * On ppc64 this will only work with radix 2M hugepage size
  */
-- 
2.34.1


