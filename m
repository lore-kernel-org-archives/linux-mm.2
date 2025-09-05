Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D596CA1002
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 03:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9471B8E0002; Thu,  4 Sep 2025 23:24:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6168E0001; Thu,  4 Sep 2025 23:24:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BE408E0002; Thu,  4 Sep 2025 23:24:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 635C78E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 23:24:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16AA1B9CCC
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 03:24:41 +0000 (UTC)
X-FDA: 83853754362.17.D8F94AE
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf15.hostedemail.com (Postfix) with ESMTP id 581A0A000A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 03:24:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gJg2wjUd;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757042679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=y5hzaTMrp5ml0eZFuOPJb0IFdSE0eJU5kUu/t1q/83g=;
	b=KGtDkxUJCK2t7s7yBLGwiiBePXy0WoGHV57FW9cGoYpWvVmY8TkXHjp1aEOYumKaAnw3b+
	FeCRq5HqiI+XVaVfSvwERmWc8+QpMon7U+m2g/SxszX6qquQ+oXJRgOonUZVQ0rC0AaTJG
	EPd32QVXewSUxVFLHdj+rF+YQC3g3ao=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gJg2wjUd;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757042679; a=rsa-sha256;
	cv=none;
	b=H9/Lk11kfAXGZPFFGQ7ApcJXOIU9h8ErqFlk+9qhjvmcRZfnsI3J7fYgJt0BSNKri9UEVA
	YmaBdd2xuu0ZpH5wFipngwDgHDDXuQZeYBS9OnHDWrm/FnzQKV2gPqodnEWhAiDzTx0ctn
	TrcobIKDgwhLUtnf3aD/KT2c9aRk5WA=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b0472bd218bso300217066b.1
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 20:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757042678; x=1757647478; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y5hzaTMrp5ml0eZFuOPJb0IFdSE0eJU5kUu/t1q/83g=;
        b=gJg2wjUd8bK6/UplLbecuH/pvK250okGcBUb/QZE/JGr76W/+RTbBSSmqdsSAizASO
         SiShpzyjWJAnVVQleIUFijBWhuoF43O5RuS37otRI1fjKiLlCwuItCNxv826b1mKDWgQ
         +A2piJ6Y5AMosKfZbHmBStdnhJRmGWQjQ5UaW8aULzzqtOkLgFPn/CZqXH9IRUbOMmc1
         wR8zBWrydiI4PbyibvMeJn++d7L/LlS9e/y9cHOTs9viiaZtQWLKaEBxnCg9bMPI4y/Y
         e9rAvFq8vlGXD0jKu/1y+DiQj2ydjIl82XcxbcgNPSUX3ofYs/htFMwsUC+CW0rtJBob
         TZug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757042678; x=1757647478;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y5hzaTMrp5ml0eZFuOPJb0IFdSE0eJU5kUu/t1q/83g=;
        b=h8wUIpqdnK0zMLa6IdWoGeKywhkwiPJDwY7Cv4NCm3ck/HM1yiC0NJ2eTsee/wYK2L
         hbMUZuMek590TDd7oDk6/fUcx2wH5UFNgwS+Vs4aL7A+TAbsvEOg+JN0vnfBNf2JbQCZ
         C6YeF06yyNMNPax7/CL8QyjwlPX7mOJvj11zxULZwq0607aJ5rXrDP4jk6acwS0uhVcZ
         p47ZarXpUXVuW0ApP7wj56sxbdMH2K8e62khv90VKYLybz5MTwNAnAz+Yl7jZuKEkbs3
         8cZHSw5Gidm7k+Nb0cTt9B6P5XlCH+cjeVC35isL3dgnM7F0z/wIA5sn4GJdRiqADZ7k
         8FGA==
X-Gm-Message-State: AOJu0YxVKkXAhBK0c4ZEjZQoToQFvVVzC9RpCpYv/KaPaLcKDxffE2it
	Y0a4K5YaXjQ895uLo9Fi7T9gBxzCtM8hgKT1L/sO3cbqvFAO1w6j1TcXJvLktw==
X-Gm-Gg: ASbGncvhRlA3a3LRAAqY3VflX6bmCh0uVqePOI5KWH6MOMr2/3Rz+sOk5LKsgu/eEyB
	Zges0Ij7uXT98WPFLbzEcfjNJinhwn70APcByaOTD3ZfltWWMUnOUUflW3JrkpseZDB0N+v9L0i
	XN2awjHUDAvyP59Rz4/wwjJUke10ct1PXJxLx5VlrLKd4bjlWUJukeXzZXKS7zpJvIBC92ILbMY
	j8IVCm5gMKY9HOTxaUh4OvGMwUUXsTiIsKkOZba9HEXWgzrASRrYT7dr3tG66by93Vd+1nXP+Qu
	0SWT4P6CvFV4+syl3qPBhRiqKP5N38sQraIEesV+/RBkT06Ty7CDIVFDkEceQiFD/ltlF7GsTUf
	KIrAxiTv+wW7zX0CRg9UpCZTYLkvr25GunRsW
X-Google-Smtp-Source: AGHT+IGUZLDiw33/JusWKJMjCB0GaShc0TUfUDE9gcjWDTEOHG0oVAPEGOSLIPAriDt/zwEe39ntOg==
X-Received: by 2002:a17:907:7250:b0:b04:35c3:40b3 with SMTP id a640c23a62f3a-b0435c3438amr1567507866b.15.1757042677580;
        Thu, 04 Sep 2025 20:24:37 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b0423ed35e4sm1176915466b.25.2025.09.04.20.24.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Sep 2025 20:24:37 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH] selftests/mm: refactore split_huge_page_test with kselftest_harness
Date: Fri,  5 Sep 2025 03:24:31 +0000
Message-Id: <20250905032431.22179-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 581A0A000A
X-Stat-Signature: n6dbmagpm3ep8rcynrkabor4ggaynhzs
X-Rspam-User: 
X-HE-Tag: 1757042679-985187
X-HE-Meta: U2FsdGVkX1/gu3CAs5wnZHaCokvVWi7qDlCSPUhy96v3P9Lar0yXQhnqlDiL7g9aK2w/Yf/liHY3M/S2liklTCMLC3TJV0J+K1qSaTu19QLN3FNV4xNorS5XwJ3KhkpYY99sShx1/CR97hvM7BbKeirhJ0ICeRdsnOLWBgZJmx1dZXayBne4thKLjOv4+rGC8FZwfYjJDdFdgL8h5kklwGqIQd82R8rsbhZw/Gr8zTsK3dD3bykCEJBqQVeLp/PSfTRUT84l7JIkNyEcyhzgEfveY01cTQZYysO5jBE3zT9jM0Ja+vMfBZKRvO6QuIdX2arNbeX8SicszYnafRxhY1Nv9045lVHJmv1NSz/5lIi/1nCDu/WI7OLTwGeEtqaqipjACcbn/g69xvOOFXIR0I10t6NEFe0giMuHMIXTdb7js+++h9f1lFWiZ0pva1ZmdoeQypxDZVvpMg+/Z5mGrnmSlqEudLUODqQKrS0O/3Iw7nZ7y0xZP/na4Cn0qiX69T/u3GQ30Gsbs3QRkeO43aZ97WK5fShjWoU5MPyi4VXhQX9X9xwH98v2e5XZlcT+AtEn5sMq6Jlacop6HBSFdFarBbsctLpBwksUU0wGAwo/dQ8pWRQ+H1AZKGH/NHrCPBvKHBkh4zcJp+xag1fM9121EjSyVINRf8hdxJRLAYT8ZiBCdGtNXoHTXTRh8/RdNZe1cH2vVMlyxd3ylbP0gfkgUg7qunffSkETw+kUezct+/gdnmau7lioY6M1ofkmx08umEqzkhZvOmpb7Z/LdSrzT6MgKvVmDAzfxs9T/F6BxZ0P+IGzOF03NLSxGHvVkWUFcF1dPiQ8A9FeWOb80ecDPaaYsWbZmdVRMJbZKl6583z7vAShdNXn/P5za5xhrfhKKvHWPkPUQe23dewlKOLJ6bCO77gp00Dt0WdeNFItgbnyorZEzjaXLkZjl5Jn5fgPV65vAoI1xsKkLQM
 13qgdR5o
 JFOi5ZWv/UhrzhT/AV/vu/vcIPkPkShPb9phpN9k0qjHAsoa33PVHeITjBUF7oJviU+7RQImorz80jwI/y3N5RyYZM/XQ7QSfw211me8IgM1+4bgO0juSKxhT+rwE7w/a2nbTmYHy0IexI8LGnA4wq1UXdqU/ucn0Lt79d4V3Jkjcrlrj/fL2CsMAzRLGfZtFI5AjlYIKSEQQy8ASCagj4KuAm2Ot4MCEpVpoFTQR9W14bGhLG+bv3bsRehOimb7J3SW2RcqzDP6KyQEdmXOUS5MD93Dr1z97FBNy1BWU60Ou+cGi1fwFa2cWeGYM+kFiQJZNYAXstGNith86pyYzNGCFtVFY/ZZPDM1/S7r+khSZXotfpKrUTdH3qkN0ZwTqbKet0poimOdQPv1qIk1jdpQ5mN6c2+jPEyWSTlyYJIgBX9DkWJmYAzJxxXumVj0qg0U1ReL6gROoKThknUG6mXYK53IXqdEXvXYWJ+G9MLJkuq1h3iWp6QMwb4G8yUdTmj9BkIL+TwD5PB4RFCl+W9ltUBupkdEmsOC70g2VuPCGEY22qH1UOTqQahAOS2ejnMuHJB9kJxWR4J3d5UjUCt5QskX1F+xbjmitegGNqL3OvUCX2rK5sisebp8+LWKjnvxIGBli9x++r7A/VQhgIya2D920KGycrKDall0+pEQ7D54zbCf/Rzj/1VC9B2N2g2IACwYQVnBxRyJNdxAI3uKyXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor split_huge_page_test with kselftest_harness, since there is a
magic counting about valid tests.

The idea is simple:

For standalone test, put it into TEST().

For tests iterating order/offset, define fixture and variant with
order and offset. And skip it if order/offset is not valid.

No functional change is expected.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 .../selftests/mm/split_huge_page_test.c       | 308 ++++++++++++++----
 1 file changed, 238 insertions(+), 70 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 7731191cc8e9..2376c3530b26 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -20,14 +20,16 @@
 #include <stdbool.h>
 #include <time.h>
 #include "vm_util.h"
-#include "../kselftest.h"
+#include "../kselftest_harness.h"
 
 uint64_t pagesize;
-unsigned int pageshift;
 uint64_t pmd_pagesize;
 unsigned int pmd_order;
 int *expected_orders;
 
+char *optional_xfs_path;
+char fs_loc_template[] = "/tmp/thp_fs_XXXXXX";
+
 #define SPLIT_DEBUGFS "/sys/kernel/debug/split_huge_pages"
 #define SMAP_PATH "/proc/self/smaps"
 #define INPUT_MAX 80
@@ -41,6 +43,20 @@ const char *kpageflags_proc = "/proc/kpageflags";
 int pagemap_fd;
 int kpageflags_fd;
 
+#define ADD_VARIANT_ORDER(fixture_name, ord)			\
+	FIXTURE_VARIANT_ADD(fixture_name, order_##ord)		\
+	{							\
+		.order = ord,					\
+	}
+
+#define ADD_VARIANT_ORDER_OFFSET(fixture_name, ord, stp)		\
+	FIXTURE_VARIANT_ADD(fixture_name, order_##ord##_stp_##stp)	\
+	{								\
+		.order = ord,						\
+		.step = stp,						\
+	}
+
+
 static bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 		int kpageflags_fd)
 {
@@ -255,6 +271,26 @@ static int check_after_split_folio_orders(char *vaddr_start, size_t len,
 	return status;
 }
 
+void prepare_proc_fd(void)
+{
+	pagemap_fd = open(pagemap_proc, O_RDONLY);
+	if (pagemap_fd == -1)
+		ksft_exit_fail_msg("read pagemap: %s\n", strerror(errno));
+
+	kpageflags_fd = open(kpageflags_proc, O_RDONLY);
+	if (kpageflags_fd == -1)
+		ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
+}
+
+void cleanup_proc_fd(void)
+{
+	if (pagemap_fd != -1)
+		close(pagemap_fd);
+
+	if (kpageflags_fd != -1)
+		close(kpageflags_fd);
+}
+
 static void write_file(const char *path, const char *buf, size_t buflen)
 {
 	int fd;
@@ -292,10 +328,8 @@ static char *allocate_zero_filled_hugepage(size_t len)
 	size_t i;
 
 	result = memalign(pmd_pagesize, len);
-	if (!result) {
-		printf("Fail to allocate memory\n");
-		exit(EXIT_FAILURE);
-	}
+	if (!result)
+		ksft_exit_fail_msg("Fail to allocate memory: %s\n", strerror(errno));
 
 	madvise(result, len, MADV_HUGEPAGE);
 
@@ -334,16 +368,19 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
 		       rss_anon_before, rss_anon_after);
 }
 
-static void split_pmd_zero_pages(void)
+TEST(split_pmd_zero_pages)
 {
 	char *one_page;
 	int nr_hpages = 4;
 	size_t len = nr_hpages * pmd_pagesize;
 
+	prepare_proc_fd();
+
 	one_page = allocate_zero_filled_hugepage(len);
 	verify_rss_anon_split_huge_page_all_zeroes(one_page, nr_hpages, len);
-	ksft_test_result_pass("Split zero filled huge pages successful\n");
 	free(one_page);
+
+	cleanup_proc_fd();
 }
 
 static void split_pmd_thp_to_order(int order)
@@ -383,11 +420,10 @@ static void split_pmd_thp_to_order(int order)
 	if (!check_huge_anon(one_page, 0, pmd_pagesize))
 		ksft_exit_fail_msg("Still AnonHugePages not split\n");
 
-	ksft_test_result_pass("Split huge pages to order %d successful\n", order);
 	free(one_page);
 }
 
-static void split_pte_mapped_thp(void)
+TEST(split_pte_mapped_thp)
 {
 	const size_t nr_thps = 4;
 	const size_t thp_area_size = nr_thps * pmd_pagesize;
@@ -395,6 +431,8 @@ static void split_pte_mapped_thp(void)
 	char *thp_area, *tmp, *page_area = MAP_FAILED;
 	size_t i;
 
+	prepare_proc_fd();
+
 	thp_area = mmap((void *)(1UL << 30), thp_area_size, PROT_READ | PROT_WRITE,
 			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
 	if (thp_area == MAP_FAILED) {
@@ -470,14 +508,43 @@ static void split_pte_mapped_thp(void)
 		ksft_test_result_fail("THP %zu not split\n", i);
 	}
 
-	ksft_test_result_pass("Split PTE-mapped huge pages successful\n");
 out:
 	munmap(thp_area, thp_area_size);
 	if (page_area != MAP_FAILED)
 		munmap(page_area, page_area_size);
+	cleanup_proc_fd();
+}
+
+FIXTURE(split_file_backed_thp) {
+};
+
+FIXTURE_VARIANT(split_file_backed_thp) {
+	int order;
+};
+
+FIXTURE_SETUP(split_file_backed_thp)
+{
+	if (variant->order >= pmd_order)
+		SKIP(return, "order %d is not supported", variant->order);
+	prepare_proc_fd();
+}
+
+FIXTURE_TEARDOWN(split_file_backed_thp)
+{
+	cleanup_proc_fd();
 }
 
-static void split_file_backed_thp(int order)
+ADD_VARIANT_ORDER(split_file_backed_thp, 0);
+ADD_VARIANT_ORDER(split_file_backed_thp, 1);
+ADD_VARIANT_ORDER(split_file_backed_thp, 2);
+ADD_VARIANT_ORDER(split_file_backed_thp, 3);
+ADD_VARIANT_ORDER(split_file_backed_thp, 4);
+ADD_VARIANT_ORDER(split_file_backed_thp, 5);
+ADD_VARIANT_ORDER(split_file_backed_thp, 6);
+ADD_VARIANT_ORDER(split_file_backed_thp, 7);
+ADD_VARIANT_ORDER(split_file_backed_thp, 8);
+
+TEST_F(split_file_backed_thp, orders)
 {
 	int status;
 	int fd;
@@ -487,7 +554,7 @@ static void split_file_backed_thp(int order)
 	ssize_t num_written, num_read;
 	char *file_buf1, *file_buf2;
 	uint64_t pgoff_start = 0, pgoff_end = 1024;
-	int i;
+	int i, order = variant->order;
 
 	ksft_print_msg("Please enable pr_debug in split_huge_pages_in_file() for more info.\n");
 
@@ -567,7 +634,6 @@ static void split_file_backed_thp(int order)
 		ksft_exit_fail_msg("cannot remove tmp dir: %s\n", strerror(errno));
 
 	ksft_print_msg("Please check dmesg for more information\n");
-	ksft_test_result_pass("File-backed THP split to order %d test done\n", order);
 	return;
 
 close_file:
@@ -579,6 +645,45 @@ static void split_file_backed_thp(int order)
 	ksft_exit_fail_msg("Error occurred\n");
 }
 
+FIXTURE(split_pmd_thp_to_order) {
+};
+
+FIXTURE_VARIANT(split_pmd_thp_to_order) {
+	int order;
+};
+
+FIXTURE_SETUP(split_pmd_thp_to_order)
+{
+	if (variant->order >= pmd_order)
+		SKIP(return, "order %d is not supported", variant->order);
+
+	expected_orders = (int *)malloc(sizeof(int) * (pmd_order + 1));
+	if (!expected_orders)
+		ksft_exit_fail_msg("Fail to allocate memory: %s\n", strerror(errno));
+
+	prepare_proc_fd();
+}
+
+FIXTURE_TEARDOWN(split_pmd_thp_to_order)
+{
+	free(expected_orders);
+	cleanup_proc_fd();
+}
+
+ADD_VARIANT_ORDER(split_pmd_thp_to_order, 0);
+ADD_VARIANT_ORDER(split_pmd_thp_to_order, 2);
+ADD_VARIANT_ORDER(split_pmd_thp_to_order, 3);
+ADD_VARIANT_ORDER(split_pmd_thp_to_order, 4);
+ADD_VARIANT_ORDER(split_pmd_thp_to_order, 5);
+ADD_VARIANT_ORDER(split_pmd_thp_to_order, 6);
+ADD_VARIANT_ORDER(split_pmd_thp_to_order, 7);
+ADD_VARIANT_ORDER(split_pmd_thp_to_order, 8);
+
+TEST_F(split_pmd_thp_to_order, order)
+{
+	split_pmd_thp_to_order(variant->order);
+}
+
 static bool prepare_thp_fs(const char *xfs_path, char *thp_fs_template,
 		const char **thp_fs_loc)
 {
@@ -757,81 +862,144 @@ static void split_thp_in_pagecache_to_order_at(size_t fd_size,
 	}
 }
 
-int main(int argc, char **argv)
-{
-	int i;
-	size_t fd_size;
-	char *optional_xfs_path = NULL;
-	char fs_loc_template[] = "/tmp/thp_fs_XXXXXX";
+FIXTURE(split_thp_in_pagecache_to_order) {
+	bool created_tmp;
 	const char *fs_loc;
+};
+
+FIXTURE_VARIANT(split_thp_in_pagecache_to_order) {
+	int order;
+};
+
+FIXTURE_SETUP(split_thp_in_pagecache_to_order)
+{
+	/* limit order to less than pmd_order */
+	if (variant->order >= pmd_order)
+		SKIP(return, "order %d is not supported", variant->order);
+	expected_orders = (int *)malloc(sizeof(int) * (pmd_order + 1));
+	if (!expected_orders)
+		ksft_exit_fail_msg("Fail to allocate memory: %s\n", strerror(errno));
+
+	self->created_tmp = prepare_thp_fs(optional_xfs_path, fs_loc_template,
+					&self->fs_loc);
+	prepare_proc_fd();
+}
+
+FIXTURE_TEARDOWN(split_thp_in_pagecache_to_order)
+{
+	cleanup_proc_fd();
+	cleanup_thp_fs(self->fs_loc, self->created_tmp);
+	free(expected_orders);
+}
+
+ADD_VARIANT_ORDER(split_thp_in_pagecache_to_order, 8);
+ADD_VARIANT_ORDER(split_thp_in_pagecache_to_order, 7);
+ADD_VARIANT_ORDER(split_thp_in_pagecache_to_order, 6);
+ADD_VARIANT_ORDER(split_thp_in_pagecache_to_order, 5);
+ADD_VARIANT_ORDER(split_thp_in_pagecache_to_order, 4);
+ADD_VARIANT_ORDER(split_thp_in_pagecache_to_order, 3);
+ADD_VARIANT_ORDER(split_thp_in_pagecache_to_order, 2);
+ADD_VARIANT_ORDER(split_thp_in_pagecache_to_order, 1);
+ADD_VARIANT_ORDER(split_thp_in_pagecache_to_order, 0);
+
+TEST_F(split_thp_in_pagecache_to_order, order)
+{
+	size_t fd_size = 2 * pmd_pagesize;
+
+	split_thp_in_pagecache_to_order_at(fd_size, self->fs_loc, variant->order, -1);
+}
+
+FIXTURE(split_thp_in_pagecache_to_order_offset) {
 	bool created_tmp;
+	const char *fs_loc;
 	int offset;
-	unsigned int nr_pages;
-	unsigned int tests;
+};
 
-	ksft_print_header();
+FIXTURE_VARIANT(split_thp_in_pagecache_to_order_offset) {
+	int order;
+	int step;
+};
 
-	if (geteuid() != 0) {
-		ksft_print_msg("Please run the benchmark as root\n");
-		ksft_finished();
-	}
-
-	if (argc > 1)
-		optional_xfs_path = argv[1];
+FIXTURE_SETUP(split_thp_in_pagecache_to_order_offset)
+{
+	int nr_pages = pmd_pagesize / pagesize;
+	int offset = variant->step * MAX(nr_pages / 4, 1 << variant->order);
 
-	pagesize = getpagesize();
-	pageshift = ffs(pagesize) - 1;
-	pmd_pagesize = read_pmd_pagesize();
-	if (!pmd_pagesize)
-		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
+	/* limit order to less than pmd_order */
+	if (variant->order >= pmd_order)
+		SKIP(return, "order %d is not supported", variant->order);
 
-	nr_pages = pmd_pagesize / pagesize;
-	pmd_order = sz2ord(pmd_pagesize, pagesize);
+	if (offset < nr_pages)
+		self->offset = offset;
+	else
+		SKIP(return, "offset out of thp range");
 
 	expected_orders = (int *)malloc(sizeof(int) * (pmd_order + 1));
 	if (!expected_orders)
 		ksft_exit_fail_msg("Fail to allocate memory: %s\n", strerror(errno));
 
-	tests = 2 + (pmd_order - 1) + (2 * pmd_order) + (pmd_order - 1) * 4 + 2;
-	ksft_set_plan(tests);
-
-	pagemap_fd = open(pagemap_proc, O_RDONLY);
-	if (pagemap_fd == -1)
-		ksft_exit_fail_msg("read pagemap: %s\n", strerror(errno));
-
-	kpageflags_fd = open(kpageflags_proc, O_RDONLY);
-	if (kpageflags_fd == -1)
-		ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
+	self->created_tmp = prepare_thp_fs(optional_xfs_path, fs_loc_template,
+					&self->fs_loc);
+	prepare_proc_fd();
+}
 
-	fd_size = 2 * pmd_pagesize;
+FIXTURE_TEARDOWN(split_thp_in_pagecache_to_order_offset)
+{
+	cleanup_proc_fd();
+	cleanup_thp_fs(self->fs_loc, self->created_tmp);
+	free(expected_orders);
+}
 
-	split_pmd_zero_pages();
+#define SPLIT_IN_PAGECACHE_ORDER_OFFSETS(ord)					 \
+	ADD_VARIANT_ORDER_OFFSET(split_thp_in_pagecache_to_order_offset, ord, 0);\
+	ADD_VARIANT_ORDER_OFFSET(split_thp_in_pagecache_to_order_offset, ord, 1);\
+	ADD_VARIANT_ORDER_OFFSET(split_thp_in_pagecache_to_order_offset, ord, 2);\
+	ADD_VARIANT_ORDER_OFFSET(split_thp_in_pagecache_to_order_offset, ord, 3)\
+
+SPLIT_IN_PAGECACHE_ORDER_OFFSETS(0);
+SPLIT_IN_PAGECACHE_ORDER_OFFSETS(1);
+SPLIT_IN_PAGECACHE_ORDER_OFFSETS(2);
+SPLIT_IN_PAGECACHE_ORDER_OFFSETS(3);
+SPLIT_IN_PAGECACHE_ORDER_OFFSETS(4);
+SPLIT_IN_PAGECACHE_ORDER_OFFSETS(5);
+SPLIT_IN_PAGECACHE_ORDER_OFFSETS(6);
+SPLIT_IN_PAGECACHE_ORDER_OFFSETS(7);
+SPLIT_IN_PAGECACHE_ORDER_OFFSETS(8);
+
+TEST_F(split_thp_in_pagecache_to_order_offset, order_offset)
+{
+	size_t fd_size = 2 * pmd_pagesize;
 
-	for (i = 0; i < pmd_order; i++)
-		if (i != 1)
-			split_pmd_thp_to_order(i);
+	split_thp_in_pagecache_to_order_at(fd_size, self->fs_loc,
+			variant->order, self->offset);
+}
 
-	split_pte_mapped_thp();
-	for (i = 0; i < pmd_order; i++)
-		split_file_backed_thp(i);
+int main(int argc, char **argv)
+{
+	int i;
 
-	created_tmp = prepare_thp_fs(optional_xfs_path, fs_loc_template,
-			&fs_loc);
-	for (i = pmd_order - 1; i >= 0; i--)
-		split_thp_in_pagecache_to_order_at(fd_size, fs_loc, i, -1);
+	if (geteuid() != 0) {
+		ksft_print_msg("Please run the benchmark as root\n");
+		ksft_finished();
+	}
 
-	for (i = 0; i < pmd_order; i++)
-		for (offset = 0;
-		     offset < nr_pages;
-		     offset += MAX(nr_pages / 4, 1 << i))
-			split_thp_in_pagecache_to_order_at(fd_size, fs_loc, i, offset);
-	cleanup_thp_fs(fs_loc, created_tmp);
+	for (i = 1; i < argc; i++) {
+		/* only one parameter supported */
+		if (*argv[i] != '-') {
+			optional_xfs_path = argv[i];
+			break;
+		}
 
-	close(pagemap_fd);
-	close(kpageflags_fd);
-	free(expected_orders);
+		/* option -l/-h has no parameter */
+		if (*(argv[i] + 1) != 'l' && *(argv[i] + 1) != 'h')
+			i++;
+	}
 
-	ksft_finished();
+	pagesize = getpagesize();
+	pmd_pagesize = read_pmd_pagesize();
+	if (!pmd_pagesize)
+		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
+	pmd_order = sz2ord(pmd_pagesize, pagesize);
 
-	return 0;
+	return test_harness_run(argc, argv);
 }
-- 
2.34.1


