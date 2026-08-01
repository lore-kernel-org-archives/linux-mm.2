Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1AA7C55174
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 06:27:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB4616B0088; Sat,  1 Aug 2026 02:26:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C64AE6B008A; Sat,  1 Aug 2026 02:26:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2CB26B0092; Sat,  1 Aug 2026 02:26:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 767A46B0088
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 02:26:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3FEE7C024E
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 06:26:57 +0000 (UTC)
X-FDA: 85051717674.25.D003E6D
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2EB2B20006
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 06:26:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mNXh93VX;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785565615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pHqBnqUX4SkeXEZFjh12UVw6qYOSznOPPAAYenFC/Eg=;
	b=R54/gXsrpNRe74cyL1ZmGpUSLu+4TgPhJaI+8pi2NR3ZfqHR+YzSilwZRuENAZDtY2XWj4
	pThEBt66iaXyu+dHQXZfrai9sqnQ/y6amt91PJCFZRTA+HpYBAo5zENBMJvhd6t5/oZdae
	ftJHjwiw1HbPE4CHLPCOUcjK9IPniYE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mNXh93VX;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785565615;
	b=xLeGJK9CjVOVG24odshRnqaGkPcVpSW1kVbyZqSc4wlr2w8qFBs6kwcgNnwo83/CloHvVR
	jCg9SFf7teC/vxgAOhY609SW0LKT/vlvIEJ7+UrUFGes0oI78OpIqMFXe2zz5bo0axBhvw
	hy+tsRSll6mPhniYieHMW+F6hgE3wTU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785565610; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=pHqBnqUX4SkeXEZFjh12UVw6qYOSznOPPAAYenFC/Eg=;
	b=mNXh93VXz1P5toscQacdu52FeERYFgZqxSK7Pems1L3iOCe5eYzXuzJYZxX/4cwylo8p1J+NmtL4W94SSwybmda8EPeoX4q+POAbvMEcx+5Ok3zBVmVc+xPVeJSSJ7yt4bI+Q4achA70Zf7IkRrelXqvJg2In3I6nSlR58mlXCM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X89g2M._1785565609;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X89g2M._1785565609 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 01 Aug 2026 14:26:50 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] selftests: mm: extend the check_huge() to support mTHP check
Date: Sat,  1 Aug 2026 14:26:35 +0800
Message-ID: <f2ad5bbe868dc7ed8642842ad2f9751a1ce79f70.1785564857.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
References: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2EB2B20006
X-Rspam-User: 
X-Stat-Signature: za4tb56pdghnrx4b3aqxg4yxp1way959
X-Rspamd-Server: rspam04
X-HE-Tag: 1785565613-847296
X-HE-Meta: U2FsdGVkX19UGOO8IUD+3FPYPFaW5t+8ErgB00o9o73RH/baqSIz43LuYWZH7UxTnBXAlg1nZ6vhOpJ8suuES1r+Ds2oyYizXtL34nXM6eoNUD/JPR1V6EWDTZNYBVKcNXSyD72maBTfs0/YZysVW65f3qiwxyGWWSt1jXTsbUaz7B2f0OENAC1gT9Vsunk0/ktv4rMJOmUVVICcWT9UvUXN0mcB7XjtceTwKPMgy2cC6qQrOGuq81zWDTqeqN+E9XAY+MXgRKhC5lSychW43oVmgZOGJprH5c9w05VazPdIot3Q+uXGaAhpRlA7fiGQli0kPmgCXK6mdZZWm39NCJOV0Efknma41Ic0mZmkATQWWlWPaQhtVgc2ZY75UgmS/fuzAN37PwpT8DEPOWCEDV7GPjk/V0y7iB3kgQNmwXI+pqaxoYcXxqh/6vEvE2wSu00sdPWvWjJu25PDkXf7bhS2ExJH9YsUIYglQm2SFqkqA+HZb7yWumoBK3lXMuCVS+jYX1SW6cDNKEdGfKow9e7QeTD5yWd9HrC+2o2WZg7sVfoNq/6Pbjmerl9tLmm8M8e30sgfMNGf6cBmxPm9DeWcToqV14VV0+mcUskekqmhTVOJXNara8lDyn160QX6AoT0fIJmWLuF6P/nd/Qyz0YEEmXnfVeTowpaeA0vXYyBEBHtCoCrisJDdgLQQEGmDUSSHB3fCpZt/mRKnsRcR3R3ypw8p3cX2In7irbbuMU/uRV+yqAoSZHf+DXoKMq3XjTOGQ3O25G4/0Fpr5BAmKaaoFbBS5vqq7nUU7QVGxBTlnWueA3ncp4wwBT9HbQlno4739ap8DFDi2nY44R9ZPkicNEBtiuWqy21EEvZPUENcHmkBeYkUcTns4o501115dCL2FAHFNDWQsLcU4jF0nbFlz6AtR49nHbAMCEsmb07uih3aCp2Q3G9f3zvDPE5WAW8Iww/+Ry+rSQLgCN
 dK9lgvJ0
 YJCw2my2JRFEpJdaZnldkUWbUpIntYDT3FK+uOm/LuBi0sOypaKqKCYFRTLYxZs9jZ0c8lcQibDZJngNw5M26yOfPHeDZiX0uKnK18yxTGr4SBpakT312OaFdHH5Q+K0BiE+uFr2qyvJrzTHstApOM1b625creNdkKZiKtU/IxtDPXsWmSNxaZrx7huNyNpVU7GHmOpoW0zOGo+vq7tfsUJrOYwxqzYrBhYa4ZJ1RRXUF9QuLl06rioAT3ioZkagwjODrWrTQK93ltfYfRR3l3QDGlRqTn9YY6i6taPqBCHg8uf8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To support checking for various sized mTHPs during mTHP collapse, extend the
check_huge() function prototype to accept two new parameters specifying the
address range and mTHP size, in preparation for the following patches.

No functional changes.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 .../selftests/mm/folio_split_race_test.c      |  2 +-
 tools/testing/selftests/mm/khugepaged.c       | 66 ++++++++++---------
 tools/testing/selftests/mm/pagemap_ioctl.c    |  2 +-
 .../testing/selftests/mm/prctl_thp_disable.c  |  2 +-
 tools/testing/selftests/mm/soft-dirty.c       |  2 +-
 .../selftests/mm/split_huge_page_test.c       | 14 ++--
 tools/testing/selftests/mm/uffd-common.c      |  4 +-
 tools/testing/selftests/mm/vm_util.c          |  6 +-
 tools/testing/selftests/mm/vm_util.h          |  6 +-
 9 files changed, 56 insertions(+), 48 deletions(-)

diff --git a/tools/testing/selftests/mm/folio_split_race_test.c b/tools/testing/selftests/mm/folio_split_race_test.c
index 6329e37fff4c..45b84f7b364e 100644
--- a/tools/testing/selftests/mm/folio_split_race_test.c
+++ b/tools/testing/selftests/mm/folio_split_race_test.c
@@ -182,7 +182,7 @@ static uint64_t run_iteration(void)
 	for (i = 0; i < TOTAL_PAGES; i++)
 		fill_page(mmap_base, i);
 
-	if (!check_huge_shmem(mmap_base, NR_PMD_PAGE, pmd_pagesize))
+	if (!check_huge_shmem(mmap_base, FILE_SIZE, NR_PMD_PAGE, pmd_pagesize))
 		ksft_exit_fail_msg("No shmem THP is allocated\n");
 
 	if (pthread_barrier_init(&ctl.barrier, NULL, NUM_READER_THREADS + 1) != 0)
diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 10e8dedcb087..f69be6be0ecd 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -51,7 +51,7 @@ struct mem_ops {
 	void *(*setup_area)(int nr_hpages);
 	void (*cleanup_area)(void *p, unsigned long size);
 	void (*fault)(void *p, unsigned long start, unsigned long end);
-	bool (*check_huge)(void *addr, int nr_hpages);
+	bool (*check_huge)(void *addr, unsigned long size, int nr_hpages, unsigned long hpage_size);
 	const char *name;
 };
 
@@ -276,7 +276,7 @@ static void *alloc_hpage(struct mem_ops *ops)
 	ksft_print_msg("Allocate huge page...");
 	if (madvise_collapse_retry(p, hpage_pmd_size))
 		ksft_exit_fail_perror("madvise(MADV_COLLAPSE)");
-	if (!ops->check_huge(p, 1))
+	if (!ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
 		ksft_exit_fail_perror("madvise(MADV_COLLAPSE)");
 	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
 		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
@@ -310,9 +310,10 @@ static void anon_fault(void *p, unsigned long start, unsigned long end)
 	fill_memory(p, start, end);
 }
 
-static bool anon_check_huge(void *addr, int nr_hpages)
+static bool anon_check_huge(void *addr, unsigned long size,
+		int nr_hpages, unsigned long hpage_size)
 {
-	return check_huge_anon(addr, nr_hpages, hpage_pmd_size);
+	return check_huge_anon(addr, size, nr_hpages, hpage_size);
 }
 
 static void *file_setup_area_common(int nr_hpages, enum file_setup_ops setup)
@@ -412,13 +413,14 @@ static void file_fault_write(void *p, unsigned long start, unsigned long end)
 		ksft_exit_fail_perror("madvise(MADV_POPULATE_WRITE)");
 }
 
-static bool file_check_huge(void *addr, int nr_hpages)
+static bool file_check_huge(void *addr, unsigned long size,
+		int nr_hpages, unsigned long hpage_size)
 {
 	switch (finfo.type) {
 	case VMA_FILE:
-		return check_huge_file(addr, nr_hpages, hpage_pmd_size);
+		return check_huge_file(addr, size, nr_hpages, hpage_size);
 	case VMA_SHMEM:
-		return check_huge_shmem(addr, nr_hpages, hpage_pmd_size);
+		return check_huge_shmem(addr, size, nr_hpages, hpage_size);
 	default:
 		exit(EXIT_FAILURE);
 		return false;
@@ -448,9 +450,10 @@ static void shmem_cleanup_area(void *p, unsigned long size)
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
@@ -533,7 +536,7 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
 	ret = madvise_collapse_retry(p, nr_hpages * hpage_pmd_size);
 	if (((bool)ret) == expect)
 		fail("Fail: Bad return value");
-	else if (!ops->check_huge(p, expect ? nr_hpages : 0))
+	else if (!ops->check_huge(p, nr_hpages * hpage_pmd_size, expect ? nr_hpages : 0, hpage_pmd_size))
 		fail("Fail: check_huge()");
 	else
 		success("OK");
@@ -545,7 +548,7 @@ static void madvise_collapse(const char *msg, char *p, int nr_hpages,
 			     struct mem_ops *ops, bool expect)
 {
 	/* Sanity check */
-	if (!ops->check_huge(p, 0))
+	if (!ops->check_huge(p, nr_hpages * hpage_pmd_size, 0, hpage_pmd_size))
 		ksft_exit_fail_msg("Unexpected huge page\n");
 	__madvise_collapse(msg, p, nr_hpages, ops, expect);
 }
@@ -554,11 +557,12 @@ static void madvise_collapse(const char *msg, char *p, int nr_hpages,
 static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
 			  struct mem_ops *ops)
 {
+	unsigned long size = nr_hpages * hpage_pmd_size;
 	int full_scans;
 	int timeout = 6; /* 3 seconds */
 
 	/* Sanity check */
-	if (!ops->check_huge(p, 0))
+	if (!ops->check_huge(p, size, 0, hpage_pmd_size))
 		ksft_exit_fail_msg("Unexpected huge page\n");
 
 	madvise(p, nr_hpages * hpage_pmd_size, MADV_HUGEPAGE);
@@ -568,7 +572,7 @@ static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
 
 	ksft_print_msg("%s...", msg);
 	while (timeout--) {
-		if (ops->check_huge(p, nr_hpages))
+		if (ops->check_huge(p, size, nr_hpages, hpage_pmd_size))
 			break;
 		if (thp_read_num("khugepaged/full_scans") >= full_scans)
 			break;
@@ -582,6 +586,8 @@ static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
 static void khugepaged_collapse(const char *msg, char *p, int nr_hpages,
 				struct mem_ops *ops, bool expect)
 {
+	unsigned long size = nr_hpages * hpage_pmd_size;
+
 	/*
 	 * read&write file collapse fails since khugepaged does not flush
 	 * the target dirty folios
@@ -605,7 +611,7 @@ static void khugepaged_collapse(const char *msg, char *p, int nr_hpages,
 	if (ops != &__anon_ops)
 		ops->fault(p, 0, nr_hpages * hpage_pmd_size);
 
-	if (ops->check_huge(p, expect ? nr_hpages : 0))
+	if (ops->check_huge(p, size, expect ? nr_hpages : 0, hpage_pmd_size))
 		success("OK");
 	else
 		fail("Fail");
@@ -634,7 +640,7 @@ static void alloc_at_fault(void)
 	p = alloc_mapping(1);
 	*p = 1;
 	ksft_print_msg("Allocate huge page on fault...");
-	if (check_huge_anon(p, 1, hpage_pmd_size))
+	if (check_huge_anon(p, hpage_pmd_size, 1, hpage_pmd_size))
 		success("OK");
 	else
 		fail("Fail");
@@ -643,7 +649,7 @@ static void alloc_at_fault(void)
 
 	madvise(p, page_size, MADV_DONTNEED);
 	ksft_print_msg("Split huge PMD on MADV_DONTNEED...");
-	if (check_huge_anon(p, 0, hpage_pmd_size))
+	if (check_huge_anon(p, hpage_pmd_size, 0, hpage_pmd_size))
 		success("OK");
 	else
 		fail("Fail");
@@ -815,7 +821,7 @@ static void collapse_single_pte_entry_compound(struct collapse_context *c, struc
 	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
 	ksft_print_msg("Split huge page leaving single PTE mapping compound page...");
 	madvise(p + page_size, hpage_pmd_size - page_size, MADV_DONTNEED);
-	if (ops->check_huge(p, 0))
+	if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
 		success("OK");
 	else
 		fail("Fail");
@@ -836,7 +842,7 @@ static void collapse_full_of_compound(struct collapse_context *c, struct mem_ops
 	ksft_print_msg("Split huge page leaving single PTE page table full of compound pages...");
 	madvise(p, page_size, MADV_NOHUGEPAGE);
 	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
-	if (ops->check_huge(p, 0))
+	if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
 		success("OK");
 	else
 		fail("Fail");
@@ -858,7 +864,7 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
 	for (i = 0; i < hpage_pmd_nr; i++) {
 		madvise(BASE_ADDR, hpage_pmd_size, MADV_HUGEPAGE);
 		ops->fault(BASE_ADDR, 0, hpage_pmd_size);
-		if (!ops->check_huge(BASE_ADDR, 1))
+		if (!ops->check_huge(BASE_ADDR, hpage_pmd_size, 1, hpage_pmd_size))
 			ksft_exit_fail_msg("Failed to allocate huge page\n");
 		madvise(BASE_ADDR, hpage_pmd_size, MADV_NOHUGEPAGE);
 
@@ -881,7 +887,7 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
 
 	ops->cleanup_area(BASE_ADDR, hpage_pmd_size);
 	ops->fault(p, 0, hpage_pmd_size);
-	if (!ops->check_huge(p, 1))
+	if (!ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
 		success("OK");
 	else
 		fail("Fail");
@@ -903,7 +909,7 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 
 	ksft_print_msg("Allocate small page...");
 	ops->fault(p, 0, page_size);
-	if (ops->check_huge(p, 0))
+	if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
 		success("OK");
 	else
 		fail("Fail");
@@ -911,7 +917,7 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 	ksft_print_msg("Share small page over fork()...");
 	if (!fork()) {
 		/* Do not touch settings on child exit */
-		if (ops->check_huge(p, 0))
+		if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
 			success("OK");
 		else
 			fail("Fail");
@@ -929,7 +935,7 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 	exit_status = WEXITSTATUS(wstatus);
 
 	ksft_print_msg("Check if parent still has small page...");
-	if (ops->check_huge(p, 0))
+	if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
 		success("OK");
 	else
 		fail("Fail");
@@ -947,7 +953,7 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
 	ksft_print_msg("Share huge page over fork()...");
 	if (!fork()) {
 		/* Do not touch settings on child exit */
-		if (ops->check_huge(p, 1))
+		if (ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
 			success("OK");
 		else
 			fail("Fail");
@@ -955,7 +961,7 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
 		ksft_print_msg("Split huge page PMD in child process...");
 		madvise(p, page_size, MADV_NOHUGEPAGE);
 		madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
-		if (ops->check_huge(p, 0))
+		if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
 			success("OK");
 		else
 			fail("Fail");
@@ -976,7 +982,7 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
 	exit_status = WEXITSTATUS(wstatus);
 
 	ksft_print_msg("Check if parent still has huge page...");
-	if (ops->check_huge(p, 1))
+	if (ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
 		success("OK");
 	else
 		fail("Fail");
@@ -995,7 +1001,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 	ksft_print_msg("Share huge page over fork()...");
 	if (!fork()) {
 		/* Do not touch settings on child exit */
-		if (ops->check_huge(p, 1))
+		if (ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
 			success("OK");
 		else
 			fail("Fail");
@@ -1003,7 +1009,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 		ksft_print_msg("Trigger CoW on page %d of %d...",
 				hpage_pmd_nr - max_ptes_shared - 1, hpage_pmd_nr);
 		ops->fault(p, 0, (hpage_pmd_nr - max_ptes_shared - 1) * page_size);
-		if (ops->check_huge(p, 0))
+		if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
 			success("OK");
 		else
 			fail("Fail");
@@ -1016,7 +1022,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 			       hpage_pmd_nr - max_ptes_shared, hpage_pmd_nr);
 			ops->fault(p, 0, (hpage_pmd_nr - max_ptes_shared) *
 				    page_size);
-			if (ops->check_huge(p, 0))
+			if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
 				success("OK");
 			else
 				fail("Fail");
@@ -1034,7 +1040,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 	exit_status = WEXITSTATUS(wstatus);
 
 	ksft_print_msg("Check if parent still has huge page...");
-	if (ops->check_huge(p, 1))
+	if (ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
 		success("OK");
 	else
 		fail("Fail");
diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 1b2dffcc999b..cfd1987339c1 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1085,7 +1085,7 @@ static void unpopulated_written_test(const char *name, char *mem, long size,
 	memset(mem, 1, size);
 	if (use_thp &&
 	    (madvise(mem, size, MADV_COLLAPSE) ||
-	     !check_huge_anon(mem, size / hpage_size, hpage_size))) {
+	     !check_huge_anon(mem, size, size / hpage_size, hpage_size))) {
 		ksft_test_result_skip("%s could not form a THP\n", name);
 		goto out;
 	}
diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
index d8d9d1de57b8..82c6e96ea6eb 100644
--- a/tools/testing/selftests/mm/prctl_thp_disable.c
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -67,7 +67,7 @@ static int test_mmap_thp(enum thp_collapse_type madvise_buf, size_t pmdsize)
 	/* HACK: make sure we have a separate VMA that we can check reliably. */
 	mprotect(mem, pmdsize, PROT_READ);
 
-	ret = check_huge_anon(mem, 1, pmdsize);
+	ret = check_huge_anon(mem, pmdsize, 1, pmdsize);
 	munmap(mmap_mem, mmap_size);
 	return ret;
 }
diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index fb1864a68e1c..e198facf78bb 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -103,7 +103,7 @@ static void test_hugepage(int pagemap_fd, int pagesize)
 	for (i = 0; i < hpage_len; i++)
 		map[i] = (char)i;
 
-	if (check_huge_anon(map, 1, hpage_len)) {
+	if (check_huge_anon(map, hpage_len, 1, hpage_len)) {
 		ksft_test_result_pass("Test %s huge page allocation\n", __func__);
 
 		clear_softdirty();
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 32b991472f74..4cc70873a674 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -296,7 +296,7 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
 	unsigned long rss_anon_before, rss_anon_after;
 	size_t i;
 
-	if (!check_huge_anon(one_page, nr_hpages, pmd_pagesize))
+	if (!check_huge_anon(one_page, nr_hpages * pmd_pagesize, nr_hpages, pmd_pagesize))
 		ksft_exit_fail_msg("No THP is allocated\n");
 
 	rss_anon_before = rss_anon();
@@ -311,7 +311,7 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
 		if (one_page[i] != (char)0)
 			ksft_exit_fail_msg("%ld byte corrupted\n", i);
 
-	if (!check_huge_anon(one_page, 0, pmd_pagesize))
+	if (!check_huge_anon(one_page, nr_hpages * pmd_pagesize, 0, pmd_pagesize))
 		ksft_exit_fail_msg("Still AnonHugePages not split\n");
 
 	rss_anon_after = rss_anon();
@@ -347,7 +347,7 @@ static void split_pmd_thp_to_order(int order)
 	for (i = 0; i < len; i++)
 		one_page[i] = (char)i;
 
-	if (!check_huge_anon(one_page, 4, pmd_pagesize))
+	if (!check_huge_anon(one_page, 4 * pmd_pagesize, 4, pmd_pagesize))
 		ksft_exit_fail_msg("No THP is allocated\n");
 
 	/* split all THPs */
@@ -366,7 +366,7 @@ static void split_pmd_thp_to_order(int order)
 					   (pmd_order + 1)))
 		ksft_exit_fail_msg("Unexpected THP split\n");
 
-	if (!check_huge_anon(one_page, 0, pmd_pagesize))
+	if (!check_huge_anon(one_page, 4 * pmd_pagesize, 0, pmd_pagesize))
 		ksft_exit_fail_msg("Still AnonHugePages not split\n");
 
 	ksft_test_result_pass("Split huge pages to order %d successful\n", order);
@@ -393,7 +393,7 @@ static void split_pte_mapped_thp(void)
 	for (i = 0; i < thp_area_size; i++)
 		thp_area[i] = (char)i;
 
-	if (!check_huge_anon(thp_area, nr_thps, pmd_pagesize)) {
+	if (!check_huge_anon(thp_area, nr_thps * pmd_pagesize, nr_thps, pmd_pagesize)) {
 		ksft_test_result_skip("Not all THPs allocated\n");
 		goto out;
 	}
@@ -657,7 +657,7 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
 
 	force_read_pages(*addr, fd_size / pmd_pagesize, pmd_pagesize);
 
-	if (!check_huge_file(*addr, fd_size / pmd_pagesize, pmd_pagesize)) {
+	if (!check_huge_file(*addr, fd_size, fd_size / pmd_pagesize, pmd_pagesize)) {
 		ksft_print_msg("No large pagecache folio generated, please provide a filesystem supporting large folio\n");
 		munmap(*addr, fd_size);
 		close(*fd);
@@ -735,7 +735,7 @@ static void split_thp_in_pagecache_to_order_at(size_t fd_size,
 		goto out;
 	}
 
-	if (!check_huge_file(addr, 0, pmd_pagesize)) {
+	if (!check_huge_file(addr, fd_size, 0, pmd_pagesize)) {
 		ksft_print_msg("Still FilePmdMapped not split\n");
 		err = EXIT_FAILURE;
 		goto out;
diff --git a/tools/testing/selftests/mm/uffd-common.c b/tools/testing/selftests/mm/uffd-common.c
index f48f5d4594ab..fa46c8c3a434 100644
--- a/tools/testing/selftests/mm/uffd-common.c
+++ b/tools/testing/selftests/mm/uffd-common.c
@@ -194,7 +194,9 @@ static void shmem_alias_mapping(uffd_global_test_opts_t *gopts, __u64 *start,
 
 static void shmem_check_pmd_mapping(uffd_global_test_opts_t *gopts, void *p, int expect_nr_hpages)
 {
-	if (!check_huge_shmem(gopts->area_dst_alias, expect_nr_hpages,
+	unsigned long size = expect_nr_hpages * read_pmd_pagesize();
+
+	if (!check_huge_shmem(gopts->area_dst_alias, size, expect_nr_hpages,
 			      read_pmd_pagesize()))
 		err("Did not find expected %d number of hugepages",
 		    expect_nr_hpages);
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index ef1ea11981a7..d92c819f3717 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -247,17 +247,17 @@ bool __check_huge(void *addr, char *pattern, int nr_hpages,
 	return thp == (nr_hpages * (hpage_size >> 10));
 }
 
-bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size)
+bool check_huge_anon(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)
 {
 	return __check_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
 }
 
-bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size)
+bool check_huge_file(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)
 {
 	return __check_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
 }
 
-bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size)
+bool check_huge_shmem(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)
 {
 	return __check_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
 }
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 7799154b67ee..c7ae28dfda63 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -90,9 +90,9 @@ void clear_softdirty(void);
 bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
 uint64_t read_pmd_pagesize(void);
 unsigned long rss_anon(void);
-bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size);
-bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size);
-bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size);
+bool check_huge_anon(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size);
+bool check_huge_file(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size);
+bool check_huge_shmem(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size);
 int64_t allocate_transhuge(void *ptr, int pagemap_fd);
 int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
 
-- 
2.47.3


