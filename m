Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 488BDCA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:08:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40A688E0044; Wed, 20 Aug 2025 05:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BACD8E003E; Wed, 20 Aug 2025 05:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2354E8E0044; Wed, 20 Aug 2025 05:07:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 087428E003E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:07:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C0A9F58EB7
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:07:52 +0000 (UTC)
X-FDA: 83796558384.25.3BFEF64
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0DCFA1C0005
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:07:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XGp0a9JD;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755680871; a=rsa-sha256;
	cv=none;
	b=57wSZ+lCg1dN6j4zxHVXlJ2A3uMcW2zoDcwkZmBkHUDMTT+YvLMjujRxNxM/kxBE+7cWfu
	Za0abSRQQOIsARv8tP3foTyFdCwIP/dRbll6miBbkqsrg+1rNUDVD9PSu5zSZpuw0OcbPt
	pY2T1w+ul/fWXFdMpl4nrJCQh0JOFmM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XGp0a9JD;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755680871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JXLebxa72w6she1oq4EUJPJVyU6GJQQByANwGkThcak=;
	b=F2PVZw6LjiAiQytuGYBZ8jw5c9sOwcPxPTpA1wkIdHRpev+wB187uC/Ky7TbwoQf3ugV/a
	CdeRplD6RIscFlwYmOE4YAQUwBveeU7AfZrQQrLUoOtplboV1oxegY2ff+eFq1qa47TnED
	YG/D1JMw74Q3lBMtceAJ7S+8eacSZIA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755680865; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=JXLebxa72w6she1oq4EUJPJVyU6GJQQByANwGkThcak=;
	b=XGp0a9JDx4SR+Bvw+ctlP+hNP6yB+kWFYE8GTUF3Vxs75I6svJdCeGR++WH8UGZM3UX28Inybhsl6gLrSr8oKRZgUptaZ8KC9DdCB5qEM986S5DkRlGqt/pBRx9bzezo4pE8audDkgkNVPdKxQ4Gc5V4h8oNEAYHpXWDJxE2UGI=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WmBXj7x_1755680863 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 20 Aug 2025 17:07:44 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 08/11] selftests:mm: extend the check_huge() to support mTHP check
Date: Wed, 20 Aug 2025 17:07:19 +0800
Message-ID: <54919436962dc50b77e89ec142cf114f1186fa2a.1755677674.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1755677674.git.baolin.wang@linux.alibaba.com>
References: <cover.1755677674.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0DCFA1C0005
X-Stat-Signature: ibwyu4edpunqkg6p3r5kiye6duy4twhu
X-Rspam-User: 
X-HE-Tag: 1755680869-146715
X-HE-Meta: U2FsdGVkX1/6W40PJD8wyBuR5XdiJfmp29/icCXm3RqG9b8/XkjQICsk+8ZqITavcZD2K5szVvIdp+RpkGf3vyJazZehc3Be6XI5OE/euYuAS7I/OT4kbJJ/0N6kmejw9IJeMjKyJ4hpyLDyZ1flIVR/4njW9fTTlGMq0jXxOun7B0A3A2h5r1JGhnWVcavgLxZJm+wBtHWpJ9ZDeZmlEx0n/32CZBVVVZ48hwstw2l9WtSZI5yTf/dLJD7zeutIrtftaYJHnPs+xhNObJ3agIGdBhyZZJvIN2NF87a0I+rcAUBLTfwmN5Gp+CQ5064uJNazYX5PEEqHtjziJ7AFU7uUmcbLpAd3W0EdalgaFpeDzRV6JAq2WOu+Bw5OXIj+j+BeeetnnopmHlk2LThMI2IEkAhv0uiZczXPd5LKKRyhH08JnGaVpyTVxnCHsqJmp59LyYSLPetOEgjoXjta4X79seSETI9VZNG/LDxN9BUzZHnWx7XVcpT7omzfWUEbPNn/gFiKHNCRcSn6Ud6olOc5rAamaECE1x4Z9EPkjy73XqZUL6yXONrndgs2rrPVSKfk8NsAyjOYJbZ6f71bWliipJJb96l7xCc0lq9wOkOwMK9F0kLacTOvE4xaa5/ELI21FiJfoQjLl5vBJ+Dm44iarPnrBRllivbD6IS7fG3zcxi60ebUXXisAQlhHH7AGGg+LN/0gcqhK8z9Km/MpVciY+WSL+nZvsXOokaM3pJj3K2snESJ3G6PST1r3qWL5UoGNR2NdoHrA0x5DyxfMyBdX6ddyJ3urjlBrvxfKFS0mCxWSCjTcam2VBvJK0i4Fs9P0WuJY1ZL4D7PernKnL6EuO6hnEbvS5jDQiuQGN3/OnMiXWWfB1i340vZZupb5VUW+aRygXzxFsMUcezPgUGQ0yBJ/wUQWijuHuVvZ3nMXkHzzb2q2EY7D/RqGSVJ7FiJYn+fX74rZlZ2I1/
 C/+LR4bE
 KUz9vGcHYYQDPEQ3nbkJPyePJeysI4ck0Z2Wq0VHkUgOyF6bgjJcH4HQ5bA2LvJatv3JZpoAJYRSr4c/8WemObmSLkZOnI7cLRJkWO7AnBLGdtFpQMMFQZFOXddmWJ0ARYlCeWH9xt/SPrOfpXP4681C+ZTWj1DE6I2pbdb/13Nb2cmgpzpFDV16tdUfzEKWuDL6+vs+UfJpqyfttGQew1EonYeq4C/RTt/RMTlHy7cUQOrrbQOUnqrSbms4J2Uh+eoKg1qWJvj82iSDHjLV6Q5B4XybibYEXh4dKklcw1jin1TE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To support checking for various sized mTHPs during mTHP collapse, it is
necessary to extend the check_huge() function prototype in preparation
for the following patches.

No functional changes.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 tools/testing/selftests/mm/khugepaged.c       | 66 ++++++++++---------
 .../selftests/mm/split_huge_page_test.c       | 10 +--
 tools/testing/selftests/mm/uffd-common.c      |  4 +-
 tools/testing/selftests/mm/vm_util.c          |  4 +-
 tools/testing/selftests/mm/vm_util.h          |  4 +-
 5 files changed, 48 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index a18c50d51141..e529074a1fdf 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -45,7 +45,7 @@ struct mem_ops {
 	void *(*setup_area)(int nr_hpages);
 	void (*cleanup_area)(void *p, unsigned long size);
 	void (*fault)(void *p, unsigned long start, unsigned long end);
-	bool (*check_huge)(void *addr, int nr_hpages);
+	bool (*check_huge)(void *addr, unsigned long size, int nr_hpages, unsigned long hpage_size);
 	const char *name;
 };
 
@@ -319,7 +319,7 @@ static void *alloc_hpage(struct mem_ops *ops)
 		perror("madvise(MADV_COLLAPSE)");
 		exit(EXIT_FAILURE);
 	}
-	if (!ops->check_huge(p, 1)) {
+	if (!ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size)) {
 		perror("madvise(MADV_COLLAPSE)");
 		exit(EXIT_FAILURE);
 	}
@@ -359,9 +359,10 @@ static void anon_fault(void *p, unsigned long start, unsigned long end)
 	fill_memory(p, start, end);
 }
 
-static bool anon_check_huge(void *addr, int nr_hpages)
+static bool anon_check_huge(void *addr, unsigned long size,
+			int nr_hpages, unsigned long hpage_size)
 {
-	return check_huge_anon(addr, nr_hpages, hpage_pmd_size);
+	return check_huge_anon(addr, size, nr_hpages, hpage_size);
 }
 
 static void *file_setup_area(int nr_hpages)
@@ -422,13 +423,14 @@ static void file_fault(void *p, unsigned long start, unsigned long end)
 	}
 }
 
-static bool file_check_huge(void *addr, int nr_hpages)
+static bool file_check_huge(void *addr, unsigned long size,
+			int nr_hpages, unsigned long hpage_size)
 {
 	switch (finfo.type) {
 	case VMA_FILE:
-		return check_huge_file(addr, nr_hpages, hpage_pmd_size);
+		return check_huge_file(addr, nr_hpages, hpage_size);
 	case VMA_SHMEM:
-		return check_huge_shmem(addr, nr_hpages, hpage_pmd_size);
+		return check_huge_shmem(addr, size, nr_hpages, hpage_size);
 	default:
 		exit(EXIT_FAILURE);
 		return false;
@@ -464,9 +466,10 @@ static void shmem_cleanup_area(void *p, unsigned long size)
 	close(finfo.fd);
 }
 
-static bool shmem_check_huge(void *addr, int nr_hpages)
+static bool shmem_check_huge(void *addr, unsigned long size,
+			int nr_hpages, unsigned long hpage_size)
 {
-	return check_huge_shmem(addr, nr_hpages, hpage_pmd_size);
+	return check_huge_shmem(addr, size, nr_hpages, hpage_size);
 }
 
 static struct mem_ops __anon_ops = {
@@ -514,7 +517,7 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
 	ret = madvise_collapse_retry(p, nr_hpages * hpage_pmd_size);
 	if (((bool)ret) == expect)
 		fail("Fail: Bad return value");
-	else if (!ops->check_huge(p, expect ? nr_hpages : 0))
+	else if (!ops->check_huge(p, nr_hpages * hpage_pmd_size, expect ? nr_hpages : 0, hpage_pmd_size))
 		fail("Fail: check_huge()");
 	else
 		success("OK");
@@ -526,7 +529,7 @@ static void madvise_collapse(const char *msg, char *p, int nr_hpages,
 			     struct mem_ops *ops, bool expect)
 {
 	/* Sanity check */
-	if (!ops->check_huge(p, 0)) {
+	if (!ops->check_huge(p, nr_hpages * hpage_pmd_size, 0, hpage_pmd_size)) {
 		printf("Unexpected huge page\n");
 		exit(EXIT_FAILURE);
 	}
@@ -537,11 +540,12 @@ static void madvise_collapse(const char *msg, char *p, int nr_hpages,
 static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
 			  struct mem_ops *ops)
 {
+	unsigned long size = nr_hpages * hpage_pmd_size;
 	int full_scans;
 	int timeout = 6; /* 3 seconds */
 
 	/* Sanity check */
-	if (!ops->check_huge(p, 0)) {
+	if (!ops->check_huge(p, size, 0, hpage_pmd_size)) {
 		printf("Unexpected huge page\n");
 		exit(EXIT_FAILURE);
 	}
@@ -553,7 +557,7 @@ static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
 
 	printf("%s...", msg);
 	while (timeout--) {
-		if (ops->check_huge(p, nr_hpages))
+		if (ops->check_huge(p, size, nr_hpages, hpage_pmd_size))
 			break;
 		if (thp_read_num("khugepaged/full_scans") >= full_scans)
 			break;
@@ -567,6 +571,8 @@ static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
 static void khugepaged_collapse(const char *msg, char *p, int nr_hpages,
 				struct mem_ops *ops, bool expect)
 {
+	unsigned long size = nr_hpages * hpage_pmd_size;
+
 	if (wait_for_scan(msg, p, nr_hpages, ops)) {
 		if (expect)
 			fail("Timeout");
@@ -583,7 +589,7 @@ static void khugepaged_collapse(const char *msg, char *p, int nr_hpages,
 	if (ops != &__anon_ops)
 		ops->fault(p, 0, nr_hpages * hpage_pmd_size);
 
-	if (ops->check_huge(p, expect ? nr_hpages : 0))
+	if (ops->check_huge(p, size, expect ? nr_hpages : 0, hpage_pmd_size))
 		success("OK");
 	else
 		fail("Fail");
@@ -622,7 +628,7 @@ static void alloc_at_fault(void)
 	p = alloc_mapping(1);
 	*p = 1;
 	printf("Allocate huge page on fault...");
-	if (check_huge_anon(p, 1, hpage_pmd_size))
+	if (check_huge_anon(p, hpage_pmd_size, 1, hpage_pmd_size))
 		success("OK");
 	else
 		fail("Fail");
@@ -631,7 +637,7 @@ static void alloc_at_fault(void)
 
 	madvise(p, page_size, MADV_DONTNEED);
 	printf("Split huge PMD on MADV_DONTNEED...");
-	if (check_huge_anon(p, 0, hpage_pmd_size))
+	if (check_huge_anon(p, hpage_pmd_size, 0, hpage_pmd_size))
 		success("OK");
 	else
 		fail("Fail");
@@ -797,7 +803,7 @@ static void collapse_single_pte_entry_compound(struct collapse_context *c, struc
 	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
 	printf("Split huge page leaving single PTE mapping compound page...");
 	madvise(p + page_size, hpage_pmd_size - page_size, MADV_DONTNEED);
-	if (ops->check_huge(p, 0))
+	if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
 		success("OK");
 	else
 		fail("Fail");
@@ -817,7 +823,7 @@ static void collapse_full_of_compound(struct collapse_context *c, struct mem_ops
 	printf("Split huge page leaving single PTE page table full of compound pages...");
 	madvise(p, page_size, MADV_NOHUGEPAGE);
 	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
-	if (ops->check_huge(p, 0))
+	if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
 		success("OK");
 	else
 		fail("Fail");
@@ -840,7 +846,7 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
 
 		madvise(BASE_ADDR, hpage_pmd_size, MADV_HUGEPAGE);
 		ops->fault(BASE_ADDR, 0, hpage_pmd_size);
-		if (!ops->check_huge(BASE_ADDR, 1)) {
+		if (!ops->check_huge(BASE_ADDR, hpage_pmd_size, 1, hpage_pmd_size)) {
 			printf("Failed to allocate huge page\n");
 			exit(EXIT_FAILURE);
 		}
@@ -869,7 +875,7 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
 
 	ops->cleanup_area(BASE_ADDR, hpage_pmd_size);
 	ops->fault(p, 0, hpage_pmd_size);
-	if (!ops->check_huge(p, 1))
+	if (!ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
 		success("OK");
 	else
 		fail("Fail");
@@ -890,7 +896,7 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 
 	printf("Allocate small page...");
 	ops->fault(p, 0, page_size);
-	if (ops->check_huge(p, 0))
+	if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
 		success("OK");
 	else
 		fail("Fail");
@@ -901,7 +907,7 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 		skip_settings_restore = true;
 		exit_status = 0;
 
-		if (ops->check_huge(p, 0))
+		if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
 			success("OK");
 		else
 			fail("Fail");
@@ -919,7 +925,7 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 	exit_status += WEXITSTATUS(wstatus);
 
 	printf("Check if parent still has small page...");
-	if (ops->check_huge(p, 0))
+	if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
 		success("OK");
 	else
 		fail("Fail");
@@ -939,7 +945,7 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
 		skip_settings_restore = true;
 		exit_status = 0;
 
-		if (ops->check_huge(p, 1))
+		if (ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
 			success("OK");
 		else
 			fail("Fail");
@@ -947,7 +953,7 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
 		printf("Split huge page PMD in child process...");
 		madvise(p, page_size, MADV_NOHUGEPAGE);
 		madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
-		if (ops->check_huge(p, 0))
+		if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
 			success("OK");
 		else
 			fail("Fail");
@@ -968,7 +974,7 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
 	exit_status += WEXITSTATUS(wstatus);
 
 	printf("Check if parent still has huge page...");
-	if (ops->check_huge(p, 1))
+	if (ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
 		success("OK");
 	else
 		fail("Fail");
@@ -989,7 +995,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 		skip_settings_restore = true;
 		exit_status = 0;
 
-		if (ops->check_huge(p, 1))
+		if (ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
 			success("OK");
 		else
 			fail("Fail");
@@ -997,7 +1003,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 		printf("Trigger CoW on page %d of %d...",
 				hpage_pmd_nr - max_ptes_shared - 1, hpage_pmd_nr);
 		ops->fault(p, 0, (hpage_pmd_nr - max_ptes_shared - 1) * page_size);
-		if (ops->check_huge(p, 0))
+		if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
 			success("OK");
 		else
 			fail("Fail");
@@ -1010,7 +1016,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 			       hpage_pmd_nr - max_ptes_shared, hpage_pmd_nr);
 			ops->fault(p, 0, (hpage_pmd_nr - max_ptes_shared) *
 				    page_size);
-			if (ops->check_huge(p, 0))
+			if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
 				success("OK");
 			else
 				fail("Fail");
@@ -1028,7 +1034,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 	exit_status += WEXITSTATUS(wstatus);
 
 	printf("Check if parent still has huge page...");
-	if (ops->check_huge(p, 1))
+	if (ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
 		success("OK");
 	else
 		fail("Fail");
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 80eb1f91261e..cbf190598988 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -311,7 +311,7 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
 	unsigned long rss_anon_before, rss_anon_after;
 	size_t i;
 
-	if (!check_huge_anon(one_page, nr_hpages, pmd_pagesize))
+	if (!check_huge_anon(one_page, nr_hpages * pmd_pagesize, nr_hpages, pmd_pagesize))
 		ksft_exit_fail_msg("No THP is allocated\n");
 
 	rss_anon_before = rss_anon();
@@ -326,7 +326,7 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
 		if (one_page[i] != (char)0)
 			ksft_exit_fail_msg("%ld byte corrupted\n", i);
 
-	if (!check_huge_anon(one_page, 0, pmd_pagesize))
+	if (!check_huge_anon(one_page, nr_hpages * pmd_pagesize, 0, pmd_pagesize))
 		ksft_exit_fail_msg("Still AnonHugePages not split\n");
 
 	rss_anon_after = rss_anon();
@@ -362,7 +362,7 @@ static void split_pmd_thp_to_order(int order)
 	for (i = 0; i < len; i++)
 		one_page[i] = (char)i;
 
-	if (!check_huge_anon(one_page, 4, pmd_pagesize))
+	if (!check_huge_anon(one_page, 4 * pmd_pagesize, 4, pmd_pagesize))
 		ksft_exit_fail_msg("No THP is allocated\n");
 
 	/* split all THPs */
@@ -381,7 +381,7 @@ static void split_pmd_thp_to_order(int order)
 					   (pmd_order + 1)))
 		ksft_exit_fail_msg("Unexpected THP split\n");
 
-	if (!check_huge_anon(one_page, 0, pmd_pagesize))
+	if (!check_huge_anon(one_page, 4 * pmd_pagesize, 0, pmd_pagesize))
 		ksft_exit_fail_msg("Still AnonHugePages not split\n");
 
 	ksft_test_result_pass("Split huge pages to order %d successful\n", order);
@@ -405,7 +405,7 @@ static void split_pte_mapped_thp(void)
 	for (i = 0; i < len; i++)
 		one_page[i] = (char)i;
 
-	if (!check_huge_anon(one_page, 4, pmd_pagesize))
+	if (!check_huge_anon(one_page, 4 * pmd_pagesize, 4, pmd_pagesize))
 		ksft_exit_fail_msg("No THP is allocated\n");
 
 	/* remap the first pagesize of first THP */
diff --git a/tools/testing/selftests/mm/uffd-common.c b/tools/testing/selftests/mm/uffd-common.c
index f4e9a5f43e24..b6cfcc6950e1 100644
--- a/tools/testing/selftests/mm/uffd-common.c
+++ b/tools/testing/selftests/mm/uffd-common.c
@@ -191,7 +191,9 @@ static void shmem_alias_mapping(uffd_global_test_opts_t *gopts, __u64 *start,
 static void shmem_check_pmd_mapping(uffd_global_test_opts_t *gopts, void __unused *p,
 				    int expect_nr_hpages)
 {
-	if (!check_huge_shmem(gopts->area_dst_alias, expect_nr_hpages,
+	unsigned long size = expect_nr_hpages * read_pmd_pagesize();
+
+	if (!check_huge_shmem(gopts->area_dst_alias, size, expect_nr_hpages,
 			      read_pmd_pagesize()))
 		err("Did not find expected %d number of hugepages",
 		    expect_nr_hpages);
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 56e9bd541edd..6058d80c63ef 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -248,7 +248,7 @@ bool __check_huge(void *addr, char *pattern, int nr_hpages,
 	return thp == (nr_hpages * (hpage_size >> 10));
 }
 
-bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size)
+bool check_huge_anon(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)
 {
 	return __check_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
 }
@@ -258,7 +258,7 @@ bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size)
 	return __check_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
 }
 
-bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size)
+bool check_huge_shmem(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)
 {
 	return __check_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
 }
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 07c4acfd84b6..a1cd446e5140 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -82,9 +82,9 @@ void clear_softdirty(void);
 bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
 uint64_t read_pmd_pagesize(void);
 unsigned long rss_anon(void);
-bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size);
+bool check_huge_anon(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size);
 bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size);
-bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size);
+bool check_huge_shmem(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size);
 int64_t allocate_transhuge(void *ptr, int pagemap_fd);
 unsigned long default_huge_page_size(void);
 int detect_hugetlb_page_sizes(size_t sizes[], int max);
-- 
2.43.5


