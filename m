Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CBC2C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 19:40:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A94D6B00B1; Thu, 20 Aug 2026 15:40:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55B6D6B00B2; Thu, 20 Aug 2026 15:40:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44A096B00B3; Thu, 20 Aug 2026 15:40:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 16A386B00B1
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:40:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C5B812028A
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:40:45 +0000 (UTC)
X-FDA: 85122665250.16.7BC1BEC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5D56CC000D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:40:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DXxSfq84;
	spf=pass (imf22.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787254843;
	b=wl3JGpn+4yFljPiobFmkZ9r4O8jWich9wIs85tMzQYXcCFWtqkAd/KnJhCrb1li0Y1Uh++
	Q6SZrBn3lRBZut1Z3dsNVOn56luPVuaUZCTQtrrtWFudAx32iFk4oD/WPxYlh98LaJcyEa
	M7wrZn7GyRrJzTDy5ImCAc3a2JZ8SVU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DXxSfq84;
	spf=pass (imf22.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787254843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OIRGJ2sLQhQUCbAKIHgSrsFXG283VsHM9/QKecnMylQ=;
	b=lUGdGowHTUjsbsoXg1Ng5kcbYEGDwzZ3NlMO1Nh4PXGcNhD+p2anP6p4w/OMvoCyihhmxO
	G1cTcfdK6+BcumqjYdthVh4QwC7Kz0Fb/GtLhm3vUZfySPYmOLlkx5Zhddhioqg4K+tMQp
	7Eyxw2XLzx5RTrvf4oq8JodjyMmwl0Y=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6DE9F22C8;
	Thu, 20 Aug 2026 12:40:38 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C8AD3F763;
	Thu, 20 Aug 2026 12:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787254842; bh=66C/a55+gwJIeJTegKzc2g0TeOnqZZAzUaPIYUlZ6aA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=DXxSfq84ABz4KqtaG9YLGN2pKXBbELzHeBQFy/hXWTgR6qFoijACVxeyJR+ZYVsAt
	 DeB3e//SUF2TcsUXFPkGjQDkutPBR2/c+x2cHSCEwZBwekdDMwEu8sqlr36ofC7hr2
	 lgNzMKVMec/2yD2dNWXFG4nThfG0KtGD0fh2KUiY=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Thu, 20 Aug 2026 20:40:16 +0100
Subject: [PATCH 2/2] kselftest: mm: replace usage of /proc/self/smaps for
 check_huge_xxx() helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260820-fix_split-v1-2-ab430c58c7cf@arm.com>
References: <20260820-fix_split-v1-0-ab430c58c7cf@arm.com>
In-Reply-To: <20260820-fix_split-v1-0-ab430c58c7cf@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=12762; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=66C/a55+gwJIeJTegKzc2g0TeOnqZZAzUaPIYUlZ6aA=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqh1gxOjElV19xnw1S818hjExNDBk+EzWyoJrB1
 z482zpJ7kKJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCaodYMQAKCRBt1cPRWsUx
 MxXzC/9HuWTSBnj0rlc+RMmOGlrMM3af1g+jlluW1tUpkMPyaFox9sqh85zR4VVqrDJBSNJT+F6
 kqigAgkLlNc61nCPz4MABIqlwEu8LZq5Az9tHuzAZNgA/IKAZbb2uXkRNKy+G1jtQWj0JwvhA+9
 yKO9wYIFD1EfvkdaSSzfj4FjwDHops2mzcic/HdMT5Fhs8Sx0MY8DT848qo7jTmZvlpTulIoKSz
 k9ge5iXubjPtIQDNsWoMA7zdhLPm49vaffKgMu96UjUiSuGOFPoH7xIlY4FxQp0bOquTqGUCqXI
 +KVi2FM78vOj4zXnu/JcpfpWqxVq3IpOJ85W5gskCRjFyel0gD49hr/jdVBRguXFLYvuGrENaCL
 eNWWSYXdjLJRgFofc1fSXB0GkyjghiATcwr+PalefWrQEpH6OO/lNTF8sonwicD36UcV/bInpDg
 yGErrfo3hml2+ygzDnU9uUswOixs1v+FdBm+eA3fi6Zuj3KGprMU1NpoATKQEg3MiKE3M=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5D56CC000D
X-Stat-Signature: bjy5u63ybsdt3qhhz7bf8wb6t488e7k8
X-HE-Tag: 1787254843-871597
X-HE-Meta: U2FsdGVkX18GFxRnRyGs4uH1i3Pi++NDlhlePMjAn3NDlnarIbhSUvZ4Z0C0ZQHieP6yO+OM4kuWswPI7J9FN/uKIka48ysaexTlv8AEAVa47QKKHGS+B8d1HSFjg9YYKPhWjPD76uhPtcVwXpp9doCBSLzwDQ9msNPQW7VwE8CaG6+tXex/lMWciREkbY74Drm/sThom7nbUUZiKScy6GBA8wJX/nVpHMey9viedTmYTjdzd7WDFQtwIon9rYOxjTy9mtfCYNSrRG5hofuCEw0JFkH6zqT9mDdnWeL2x8CtAUZhFj8zoPaLaUjmfohpHHRCnX9O+j1yIAWMWppwikeVZcD3+HbEQwXWP2UetNxQy4RjuvJseXpie412HRBLNLgXymYGu56YrgmuhBe4TcrlBjYmd5PWHQLwfa/oSQXxJe+9y8OhTYNIcW99IGsoegFarpPKtLBs2DlQ2Cxw63JUX9LUw9EEce946yVT3p+vFkgAJvfV/0hvzTxNfyPtI/OGTLo+jX3Wrqwa6+YnmPsuCxqbrcha1ZWgVLnSw9hXQ3M6q/8i9Ha+tX7ZEhDMiOGzhyfP8hZ9kYGWuMQTci19b1WHJDnXD6Iza8VtHkPFOJNlwTFXEXpH9nwlnPysyYxGZ+jp3iKEmjTGs58KQSXDDjlu/nkQ3yk0JpZNpeDu3Bp7l63TU1zBIjAHEhLL6g0a6qNaBnPaSyaHOvH8R8NZIaYGoP+QzW8fzeKhRFh6e8sYXui/nhhWW08LAn1TSB6wQD9ZKGDRYE3MBuiS6F8fuCwegbe2M2wDxTjgOZ31SkkvimA2Wt6pxwZ5xUokmUR49CZPQKYM2h52+BQjg/ZQeuNYED73ZlB5PC4RHINzL9brSegJpu56KrezzOo8vjdevgLL8xPRoGYoFA8gpVdNoslJPOTIh4E+IWP52Xf7K6xl7tG/X+NQj4UsTV3v+nNI3d+x3oJwAEWNWRv
 7vOts+Kg
 5SwcyxAaRVT4tu5+QfMDsH3wkS7S5k1Ym7PZjlUNDbxEYzfLngPtTpZpf2LZICAF+0xUvs1hknCBCUoGhGdOPsxNO10cbkvwlX2daGW64pGCXgW6qniCTDr+WGgmA4khFnGeKcaUO9yLoH8kLCu02gjIPVA4Xz1lCjOS2MrcD0kDsRFTvi3AC0CHNfbOQPXdn64CtwybcRYJ5bGFbATVqADiwg2ISae0xWepJ5SSfJCaX7IZRexEbyBtMHVvcmMsPnhIMVVWv6A+L6gthTuPCgAVMwzdfVI3BSTDtx5nII6/MbSffbbv4qWQfjEkP9tkLVeZFfk45wRDVlPRJdg83qRa3npI/kaZUovrT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
made by memalign().

The underlying VMA may start at a different address from the aligned
address returned by memalign(). Furthermore, a subsequent
madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
already set.

This causes split_huge_page_test to fail because the check_huge_xxx()
helpers incorrectly require the address returned by memalign() to
match the VMA start address reported in /proc/self/smaps.

Fix this by using /proc/self/pagemap and /proc/kpageflags instead of
/proc/self/smaps to detect huge pages and change the meaning of
check_huge_xxx()'s nr_hpages argument:

  - nr_hpages > 0: check all of pages in the range are huge page.
  - nr_hpages < 0: check all of pages in the range are not huge page.
  - nr_hpages == 0: invalid.

Reported-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/khugepaged.c           |  26 ++---
 tools/testing/selftests/mm/split_huge_page_test.c |   6 +-
 tools/testing/selftests/mm/vm_util.c              | 135 ++++++++++++++++++----
 tools/testing/selftests/mm/vm_util.h              |   1 +
 4 files changed, 131 insertions(+), 37 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 10e8dedcb087d..2e4665e6d5852 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -533,7 +533,7 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
 	ret = madvise_collapse_retry(p, nr_hpages * hpage_pmd_size);
 	if (((bool)ret) == expect)
 		fail("Fail: Bad return value");
-	else if (!ops->check_huge(p, expect ? nr_hpages : 0))
+	else if (!ops->check_huge(p, expect ? nr_hpages : -nr_hpages))
 		fail("Fail: check_huge()");
 	else
 		success("OK");
@@ -545,7 +545,7 @@ static void madvise_collapse(const char *msg, char *p, int nr_hpages,
 			     struct mem_ops *ops, bool expect)
 {
 	/* Sanity check */
-	if (!ops->check_huge(p, 0))
+	if (!ops->check_huge(p, -nr_hpages))
 		ksft_exit_fail_msg("Unexpected huge page\n");
 	__madvise_collapse(msg, p, nr_hpages, ops, expect);
 }
@@ -558,7 +558,7 @@ static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
 	int timeout = 6; /* 3 seconds */
 
 	/* Sanity check */
-	if (!ops->check_huge(p, 0))
+	if (!ops->check_huge(p, -nr_hpages))
 		ksft_exit_fail_msg("Unexpected huge page\n");
 
 	madvise(p, nr_hpages * hpage_pmd_size, MADV_HUGEPAGE);
@@ -605,7 +605,7 @@ static void khugepaged_collapse(const char *msg, char *p, int nr_hpages,
 	if (ops != &__anon_ops)
 		ops->fault(p, 0, nr_hpages * hpage_pmd_size);
 
-	if (ops->check_huge(p, expect ? nr_hpages : 0))
+	if (ops->check_huge(p, expect ? nr_hpages : -nr_hpages))
 		success("OK");
 	else
 		fail("Fail");
@@ -643,7 +643,7 @@ static void alloc_at_fault(void)
 
 	madvise(p, page_size, MADV_DONTNEED);
 	ksft_print_msg("Split huge PMD on MADV_DONTNEED...");
-	if (check_huge_anon(p, 0, hpage_pmd_size))
+	if (check_huge_anon(p, -1, hpage_pmd_size))
 		success("OK");
 	else
 		fail("Fail");
@@ -815,7 +815,7 @@ static void collapse_single_pte_entry_compound(struct collapse_context *c, struc
 	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
 	ksft_print_msg("Split huge page leaving single PTE mapping compound page...");
 	madvise(p + page_size, hpage_pmd_size - page_size, MADV_DONTNEED);
-	if (ops->check_huge(p, 0))
+	if (ops->check_huge(p, -1))
 		success("OK");
 	else
 		fail("Fail");
@@ -836,7 +836,7 @@ static void collapse_full_of_compound(struct collapse_context *c, struct mem_ops
 	ksft_print_msg("Split huge page leaving single PTE page table full of compound pages...");
 	madvise(p, page_size, MADV_NOHUGEPAGE);
 	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
-	if (ops->check_huge(p, 0))
+	if (ops->check_huge(p, -1))
 		success("OK");
 	else
 		fail("Fail");
@@ -903,7 +903,7 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 
 	ksft_print_msg("Allocate small page...");
 	ops->fault(p, 0, page_size);
-	if (ops->check_huge(p, 0))
+	if (ops->check_huge(p, -1))
 		success("OK");
 	else
 		fail("Fail");
@@ -911,7 +911,7 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 	ksft_print_msg("Share small page over fork()...");
 	if (!fork()) {
 		/* Do not touch settings on child exit */
-		if (ops->check_huge(p, 0))
+		if (ops->check_huge(p, -1))
 			success("OK");
 		else
 			fail("Fail");
@@ -929,7 +929,7 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 	exit_status = WEXITSTATUS(wstatus);
 
 	ksft_print_msg("Check if parent still has small page...");
-	if (ops->check_huge(p, 0))
+	if (ops->check_huge(p, -1))
 		success("OK");
 	else
 		fail("Fail");
@@ -955,7 +955,7 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
 		ksft_print_msg("Split huge page PMD in child process...");
 		madvise(p, page_size, MADV_NOHUGEPAGE);
 		madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
-		if (ops->check_huge(p, 0))
+		if (ops->check_huge(p, -1))
 			success("OK");
 		else
 			fail("Fail");
@@ -1003,7 +1003,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 		ksft_print_msg("Trigger CoW on page %d of %d...",
 				hpage_pmd_nr - max_ptes_shared - 1, hpage_pmd_nr);
 		ops->fault(p, 0, (hpage_pmd_nr - max_ptes_shared - 1) * page_size);
-		if (ops->check_huge(p, 0))
+		if (ops->check_huge(p, -1))
 			success("OK");
 		else
 			fail("Fail");
@@ -1016,7 +1016,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 			       hpage_pmd_nr - max_ptes_shared, hpage_pmd_nr);
 			ops->fault(p, 0, (hpage_pmd_nr - max_ptes_shared) *
 				    page_size);
-			if (ops->check_huge(p, 0))
+			if (ops->check_huge(p, -1))
 				success("OK");
 			else
 				fail("Fail");
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 99b45e5518199..4fcd330cf0726 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -314,7 +314,7 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
 		if (one_page[i] != (char)0)
 			ksft_exit_fail_msg("%ld byte corrupted\n", i);
 
-	if (!check_huge_anon(one_page, 0, pmd_pagesize))
+	if (!check_huge_anon(one_page, -nr_hpages, pmd_pagesize))
 		ksft_exit_fail_msg("Still AnonHugePages not split\n");
 
 	rss_anon_after = rss_anon();
@@ -372,7 +372,7 @@ static void split_pmd_thp_to_order(int order)
 					   (pmd_order + 1)))
 		ksft_exit_fail_msg("Unexpected THP split\n");
 
-	if (!check_huge_anon(one_page, 0, pmd_pagesize))
+	if (!check_huge_anon(one_page, -4, pmd_pagesize))
 		ksft_exit_fail_msg("Still AnonHugePages not split\n");
 
 	ksft_test_result_pass("Split huge pages to order %d successful\n", order);
@@ -746,7 +746,7 @@ static void split_thp_in_pagecache_to_order_at(size_t fd_size,
 		goto out;
 	}
 
-	if (!check_huge_file(addr, 0, pmd_pagesize)) {
+	if (!check_huge_file(addr, -(fd_size / pmd_pagesize), pmd_pagesize)) {
 		ksft_print_msg("Still FilePmdMapped not split\n");
 		err = EXIT_FAILURE;
 		goto out;
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 311fc5b4513eb..166d5d79289f3 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -14,6 +14,8 @@
 #define PMD_SIZE_FILE_PATH "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size"
 #define SMAP_FILE_PATH "/proc/self/smaps"
 #define STATUS_FILE_PATH "/proc/self/status"
+#define PAGEMAP_FILE_PATH "/proc/self/pagemap"
+#define KPAGEFLAGS_FILE_PATH "/proc/kpageflags"
 #define MAX_LINE_LENGTH 500
 
 unsigned int __page_size;
@@ -229,37 +231,128 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
 	return entry;
 }
 
-bool __check_huge(void *addr, char *pattern, int nr_hpages,
-		  uint64_t hpage_size)
-{
-	char buffer[MAX_LINE_LENGTH];
-	uint64_t thp = -1;
-	char *entry;
-
-	entry = __get_smap_entry(addr, pattern, buffer, sizeof(buffer));
-	if (!entry)
-		goto err_out;
-
-	if (sscanf(entry, "%9" SCNu64 " kB", &thp) != 1)
-		ksft_exit_fail_msg("Reading smap error\n");
-
-err_out:
-	return thp == (nr_hpages * (hpage_size >> 10));
-}
-
 bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size)
 {
-	return __check_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
+	int i, pagemap_fd, nr = 0;
+	uint64_t categories;
+	bool expect_huge;
+
+	if (nr_hpages == 0 || hpage_size == 0)
+		return false;
+
+	if (nr_hpages < 0) {
+		nr_hpages = -nr_hpages;
+		expect_huge = false;
+	} else
+		expect_huge = true;
+
+	pagemap_fd = open(PAGEMAP_FILE_PATH, O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_msg("open pagemap: %s\n", strerror(errno));
+
+	for (i = 0; i < nr_hpages; i++, addr += hpage_size) {
+		categories = pagemap_scan_get_categories(pagemap_fd, addr);
+		if (!(categories & PAGE_IS_HUGE))
+			continue;
+		if (categories & PAGE_IS_FILE)
+			continue;
+		nr++;
+	}
+
+	close(pagemap_fd);
+	return expect_huge ? nr == nr_hpages : nr == 0;
 }
 
 bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size)
 {
-	return __check_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
+	int i, pagemap_fd, kpf_fd, nr = 0;
+	unsigned long pfn;
+	uint64_t categories, kpf;
+	bool expect_huge;
+
+	if (nr_hpages == 0 || hpage_size == 0)
+		return false;
+
+	if (nr_hpages < 0) {
+		nr_hpages = -nr_hpages;
+		expect_huge = false;
+	} else
+		expect_huge = true;
+
+	pagemap_fd = open(PAGEMAP_FILE_PATH, O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_msg("open pagemap: %s\n", strerror(errno));
+
+	kpf_fd = open(KPAGEFLAGS_FILE_PATH, O_RDONLY);
+	if (kpf_fd < 0)
+		ksft_exit_fail_msg("open kpageflags: %s\n", strerror(errno));
+
+	for (i = 0; i < nr_hpages; i++, addr += hpage_size) {
+		categories = pagemap_scan_get_categories(pagemap_fd, addr);
+		pfn = pagemap_get_pfn(pagemap_fd, addr);
+		if (pfn == -1UL)
+			continue;
+		if (pageflags_get(pfn, kpf_fd, &kpf))
+			ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
+		if (!(categories & PAGE_IS_HUGE))
+			continue;
+		if (!(categories & PAGE_IS_FILE))
+			continue;
+		if (kpf & KPF_SWAPBACKED)
+			continue;
+		nr++;
+	}
+
+	close(pagemap_fd);
+	close(kpf_fd);
+
+	return expect_huge ? nr == nr_hpages : nr == 0;
 }
 
 bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size)
 {
-	return __check_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
+	int i, pagemap_fd, kpf_fd, nr = 0;
+	unsigned long pfn;
+	uint64_t categories, kpf;
+	bool expect_huge;
+
+	if (nr_hpages == 0 || hpage_size == 0)
+		return false;
+
+	if (nr_hpages < 0) {
+		nr_hpages = -nr_hpages;
+		expect_huge = true;
+	} else
+		expect_huge = false;
+
+	pagemap_fd = open(PAGEMAP_FILE_PATH, O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_msg("open pagemap: %s\n", strerror(errno));
+
+	kpf_fd = open(KPAGEFLAGS_FILE_PATH, O_RDONLY);
+	if (kpf_fd < 0)
+		ksft_exit_fail_msg("open kpageflags: %s\n", strerror(errno));
+
+	for (i = 0; i < nr_hpages; i++, addr += hpage_size) {
+		categories = pagemap_scan_get_categories(pagemap_fd, addr);
+		pfn = pagemap_get_pfn(pagemap_fd, addr);
+		if (pfn == -1UL)
+			continue;
+		if (pageflags_get(pfn, kpf_fd, &kpf))
+			ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
+		if (!(categories & PAGE_IS_HUGE))
+			continue;
+		if (!(categories & PAGE_IS_FILE))
+			continue;
+		if (!(kpf & KPF_SWAPBACKED))
+			continue;
+		nr++;
+	}
+
+	close(pagemap_fd);
+	close(kpf_fd);
+
+	return expect_huge ? nr == nr_hpages : nr == 0;
 }
 
 int64_t allocate_transhuge(void *ptr, int pagemap_fd)
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index ea8fc8fdf0eb0..0a1627f36efc3 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -18,6 +18,7 @@
 #define PM_SWAP                       BIT_ULL(62)
 #define PM_PRESENT                    BIT_ULL(63)
 
+#define KPF_SWAPBACKED                BIT_ULL(14)
 #define KPF_COMPOUND_HEAD             BIT_ULL(15)
 #define KPF_COMPOUND_TAIL             BIT_ULL(16)
 #define KPF_HWPOISON                  BIT_ULL(19)

-- 
2.43.0


