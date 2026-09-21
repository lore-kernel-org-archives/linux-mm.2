Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CE60C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:40:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7CC6B00F0; Mon, 21 Sep 2026 06:40:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98796B00F1; Mon, 21 Sep 2026 06:40:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A124D6B00F2; Mon, 21 Sep 2026 06:40:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 739CB6B00F0
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:40:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B608A140123
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:40:26 +0000 (UTC)
X-FDA: 85237425252.23.BED416E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id DA5C9180009
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:40:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JmnlIL+m;
	spf=pass (imf24.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789987225;
	b=utPR7Ayn8mTX4VSUULHfbDb9CEmtn4P3CAKomeo4NcDtBEVxXTX9pB3o4wv3OsfQ3nXsrm
	2RiuSvrNKCuP9KMVJCD1JSOYMX16vpCN29JhHbHKRXltaAJSJ9nK7gRqqyc1jCGRNhh3Co
	YH+dVCiT7e1DuGVp8T9dBvl9c5YM/XA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JmnlIL+m;
	spf=pass (imf24.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789987225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1kSqVU6OsQf/jitxqbngHUzg0nwYWDdefoKN+bcay4I=;
	b=KiChKpZ3dsX68Bcsg+ONzFwM5J5tHexnkMT35GbNW21sNOOYJ5sB16P2nZJqlxJpqpfU5q
	PHPll1ZFARLPi7ao5TE27ZGEtqcdGVvfCYI0uLJRAROl4bgM9ctasXRAaZf19Q++TitPX9
	z4fLag1F/pe35063661nWvNbnUy5xHA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 924111D13;
	Mon, 21 Sep 2026 03:40:20 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18FF53F86C;
	Mon, 21 Sep 2026 03:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789987224; bh=vNyGx9dWLGfndZvGwi3n6mprkCkP24UQCpKsoclyTK0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=JmnlIL+mnXS1cE2ebOZ6S8vEUxpG5ggfpnFAM7XevhVZpwxPVqdKFcP+w8GH6AAJw
	 TZNFyXHUd78aAnwv+Je01e3ayo4o7ccX5CGjcPwxpuQTh7T6mykQgmfMqlG5ds+1du
	 zGp+Bj2tIbGctVVRVflnnIalHca1DR8YgP7dhIGA=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:40:09 +0100
Subject: [PATCH v7 3/3] kselftest: mm: remove check_huge_shmem()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260921-fix_split-v7-3-d25ec991159f@arm.com>
References: <20260921-fix_split-v7-0-d25ec991159f@arm.com>
In-Reply-To: <20260921-fix_split-v7-0-d25ec991159f@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7237; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=vNyGx9dWLGfndZvGwi3n6mprkCkP24UQCpKsoclyTK0=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQmKJ2J7KWDEU19n5jwKF20S9WkGF4nlx76mN
 03QJZsJXguJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarEJigAKCRBt1cPRWsUx
 MzovDAC0XHwhw0B7epbkr2rl9Z2mlMCavJWdhf5vb8iwQiM+ePshFqmUKE8OcJbILg3kQRkwQ2n
 rSLo2HIbt2QAxwbDcMMlo9EFz2Z3H7sXFb/sEWhTKJX7//ipnPlfhhy66aNqFTF5dmhQ9ipo0nG
 gOesvqQsiRUYrQtxps33FVcgUSb0p2pwl/UymGwKg2MlRgV8txOKQ9u/Gv1W2h5UrIMrlFUTd8q
 g94fq5fTmqBxT4UYl/bcJbi750YrJSURY/3A9LkhaWmHvjOVFke6VdBTEpMols2BdfzYoHxI17C
 TspGFYVPDOHCB8mXvIDmBV7Qgh34Y/xM+bOEGRKwrwevJgaAkeaV3wMGoCvukV1XWQVs3qZ5OfS
 DE/8w2QrSURlYSGZ0juNW/ikvbo2tTLd88jwEZb6KZB5m58bosJ0RfQvIeZuoUDaxv338zs26d+
 Lkc8dND4Z8rVvJR1xBazj3lMBCh/8UaY4iIzk2xRqsTSW6SwWI5MIFANWtMa099pqf77I=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DA5C9180009
X-Stat-Signature: s1engaizjpdx7brbwbn4hbfi8os5qb1e
X-HE-Tag: 1789987224-865827
X-HE-Meta: U2FsdGVkX1/za45gJ8IfG5sJuVFZNMPGpvTlUQ1U8iMgMmgPxJbHHpMsVVoo16E8bvTT6ZVGTL4Mg3RPit8KhGd4gVdU2k83dE5JaOlzSy6hdApKD7//whalJv43N33cFvN/P0uhjbEIqFBgHMxAn14Yz4CbWf20C1N6PXOI5TG1aELx3nP/RX53+01Gl4q2qck75cdqQy7Ucze0/EceNq0O1S4+M8t8/JyzFOILrV9Z5HX6lmClUOvGPjZXb0AltVj4GEa7vbK8OGynXhSAOneJe5TG/6nRlNy1JCDYUzDxg6SlT4VoPChFM2EO6Co8ttziqTAP6F3rpGp7wTYpRsrFIbSNIzLk9TbzTe0UztZ2p+VH5hFkSQJ+FgKwQATMxzscr8pDiTJ4Dh/3eEWUWRxL8dLEDnFBdLeKnsP11Z+G28MBxxgCrcIZ9fg9rfgQjc3zTE7yhC0d4TO+3Rk1h3xDLprkoBwjqH3AtZj7XLIubB8yA/5W6iOmPKBKOnIdjumO5njyxR42j7tspT4JYW6l1sbDcxySaSAzXRXSGffbIZjT71K10dpEmgZsJzSNQC/FOjGM5ryNdpWOoLM4gG3xrsrRkaP8rE3bJBRwE/7QKoJjPD1YBCqvdzfJ2D91xjAXgtJqfHmb1BeyJ6j2dZAVkjScFGZGE+O3/0Pv9SUC4hoYhwzO5X96Xenu0zL44jYdYp1bsacJoerUFP9jjK2F3BbVHd5HMvLKDs0M207R/6+MnABFW3iHzY/CmFVhrj86DkHYowxnwidAbnPxWSLn6YbzkEqIYR3pd2cf8vhvZ6BOJTZDhkwB8GCM8+wskY/b/nmj6VtuwZO+g7LlP8g1djIHsra+qbAYYF3kDJaN2Npej2KbGJDT6LXgm4Q1h2ZLpjXykWTsKw0evR2C+9qaifJ7Ux+IuM0g47pcSJknC2VFKjKNUam7hGQ9HWJ7IQ1F5CHVNrf80bTPmkc
 lrk29/wU
 Z+gEkuwSHkLfBB3HcDnBKFW6J+m7x9ZEHeA28G/8PDbKO2DNJpRQKBgy5AXKMCoSTXLmzdd5dARMz3JOlppv7UDqta5SZvHRakMSBMXmSWGAFKsdEIOqBDhKxlvYjkEyg+V06qA/kR7dHlPgy0jc9fUDT6r66i1T8zD05cuHiIAn0SQJIEQfGllywkARgwjXIaXCHGpcgr5qjObeoTioLY3XnD9+ruYXMVMtv1LEgm3mLLEjZbQbWoMvDvH96zbVvJqDYpJyyJ/25/uPdAqo/G05YcllCTizk73j9WKQnQEkUDluJ1HlHjgwydXzO7loBfU18waPq50LJEV5YrpDCn1SmamNL89W654S0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

check_huge_shmem() was required to distinguish shmem huge pages because
/proc/self/smaps reports them using a dedicated “ShmemPmdMapped” entry,
as opposed to “FilePmdMapped” for file-backed huge pages.

Now that /proc/self/smaps is no longer used to detect huge pages and
/proc/kpageflags is used instead, it is sufficient to distinguish
between file-backed and anonymous pages since the ShmemPmdMapped is also
kind of file-backed.

Therefore, remove check_huge_shmem() and use check_huge_file() instead
and cleanup khugepaged's check_huge operation in mem_ops.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/folio_split_race_test.c |  2 +-
 tools/testing/selftests/mm/khugepaged.c            | 38 ++++------------------
 tools/testing/selftests/mm/uffd-common.c           |  4 +--
 tools/testing/selftests/mm/vm_util.c               |  5 ---
 tools/testing/selftests/mm/vm_util.h               |  1 -
 5 files changed, 9 insertions(+), 41 deletions(-)

diff --git a/tools/testing/selftests/mm/folio_split_race_test.c b/tools/testing/selftests/mm/folio_split_race_test.c
index 1960635a953eb..4c0d3b6a411b8 100644
--- a/tools/testing/selftests/mm/folio_split_race_test.c
+++ b/tools/testing/selftests/mm/folio_split_race_test.c
@@ -182,7 +182,7 @@ static uint64_t run_iteration(void)
 	for (i = 0; i < TOTAL_PAGES; i++)
 		fill_page(mmap_base, i);
 
-	if (!check_huge_shmem(mmap_base, FILE_SIZE, NR_PMD_PAGE, pmd_pagesize))
+	if (!check_huge_file(mmap_base, FILE_SIZE, NR_PMD_PAGE, pmd_pagesize))
 		ksft_exit_fail_msg("No shmem THP is allocated\n");
 
 	if (pthread_barrier_init(&ctl.barrier, NULL, NUM_READER_THREADS + 1) != 0)
diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index f82673f5f6b47..f448278823678 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -53,7 +53,7 @@ struct mem_ops {
 	void *(*setup_area)(int nr_hpages);
 	void (*cleanup_area)(void *p, unsigned long size);
 	void (*fault)(void *p, unsigned long start, unsigned long end);
-	bool (*check_huge)(void *addr, size_t len, int nr_hpages, unsigned long hpage_size);
+	bool (*check_huge)(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 	const char *name;
 };
 
@@ -314,12 +314,6 @@ static void anon_fault(void *p, unsigned long start, unsigned long end)
 	fill_memory(p, start, end);
 }
 
-static bool anon_check_huge(void *addr, size_t len, int nr_hpages,
-		unsigned long hpage_size)
-{
-	return check_huge_anon(addr, len, nr_hpages, hpage_size);
-}
-
 static void *file_setup_area_common(int nr_hpages, enum file_setup_ops setup)
 {
 	const int open_opt = setup == FILE_SETUP_READ_ONLY_FS ? O_RDONLY : O_RDWR;
@@ -411,20 +405,6 @@ static void file_fault_write(void *p, unsigned long start, unsigned long end)
 		ksft_exit_fail_perror("madvise(MADV_POPULATE_WRITE)");
 }
 
-static bool file_check_huge(void *addr, size_t len, int nr_hpages,
-		unsigned long hpage_size)
-{
-	switch (finfo.type) {
-	case VMA_FILE:
-		return check_huge_file(addr, len, nr_hpages, hpage_size);
-	case VMA_SHMEM:
-		return check_huge_shmem(addr, len, nr_hpages, hpage_size);
-	default:
-		ksft_exit_fail_msg("Unknown VMA type\n");
-		return false;
-	}
-}
-
 static void *shmem_setup_area(int nr_hpages)
 {
 	void *p;
@@ -448,17 +428,11 @@ static void shmem_cleanup_area(void *p, unsigned long size)
 	close(finfo.fd);
 }
 
-static bool shmem_check_huge(void *addr, size_t len, int nr_hpages,
-		unsigned long hpage_size)
-{
-	return check_huge_shmem(addr, len, nr_hpages, hpage_size);
-}
-
 static struct mem_ops __anon_ops = {
 	.setup_area = &anon_setup_area,
 	.cleanup_area = &anon_cleanup_area,
 	.fault = &anon_fault,
-	.check_huge = &anon_check_huge,
+	.check_huge = &check_huge_anon,
 	.name = "anon",
 };
 
@@ -466,7 +440,7 @@ static struct mem_ops __read_only_file_ops = {
 	.setup_area = &file_setup_read_only_area,
 	.cleanup_area = &file_cleanup_area,
 	.fault = &file_fault_read,
-	.check_huge = &file_check_huge,
+	.check_huge = &check_huge_file,
 	.name = "file",
 };
 
@@ -474,7 +448,7 @@ static struct mem_ops __read_write_file_read_ops = {
 	.setup_area = &file_setup_read_write_fs_read_area,
 	.cleanup_area = &file_cleanup_area,
 	.fault = &file_fault_read_and_flush,
-	.check_huge = &file_check_huge,
+	.check_huge = &check_huge_file,
 	.name = "file",
 };
 
@@ -482,7 +456,7 @@ static struct mem_ops __read_write_file_write_ops = {
 	.setup_area = &file_setup_read_write_fs_write_area,
 	.cleanup_area = &file_cleanup_area,
 	.fault = &file_fault_write,
-	.check_huge = &file_check_huge,
+	.check_huge = &check_huge_file,
 	.name = "file",
 };
 
@@ -490,7 +464,7 @@ static struct mem_ops __shmem_ops = {
 	.setup_area = &shmem_setup_area,
 	.cleanup_area = &shmem_cleanup_area,
 	.fault = &anon_fault,
-	.check_huge = &shmem_check_huge,
+	.check_huge = &check_huge_file,
 	.name = "shmem",
 };
 
diff --git a/tools/testing/selftests/mm/uffd-common.c b/tools/testing/selftests/mm/uffd-common.c
index 1fb967ef49854..a76851aced4d0 100644
--- a/tools/testing/selftests/mm/uffd-common.c
+++ b/tools/testing/selftests/mm/uffd-common.c
@@ -196,8 +196,8 @@ static void shmem_check_pmd_mapping(uffd_global_test_opts_t *gopts, void *p, int
 {
 	size_t len = expect_nr_hpages * read_pmd_pagesize();
 
-	if (!check_huge_shmem(gopts->area_dst_alias, len, expect_nr_hpages,
-			      read_pmd_pagesize()))
+	if (!check_huge_file(gopts->area_dst_alias, len, expect_nr_hpages,
+			     read_pmd_pagesize()))
 		err("Did not find expected %d number of hugepages",
 		    expect_nr_hpages);
 }
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index a7c5caf6925e0..e31e88d5af76d 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -475,11 +475,6 @@ bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 	return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_FILE);
 }
 
-bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
-{
-	return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_FILE);
-}
-
 int64_t allocate_transhuge(void *ptr, int pagemap_fd)
 {
 	uint64_t ent[2];
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 9a49af88702e4..fc9c93235f6fa 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -92,7 +92,6 @@ uint64_t read_pmd_pagesize(void);
 unsigned long rss_anon(void);
 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
-bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 int64_t allocate_transhuge(void *ptr, int pagemap_fd);
 int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
 int gather_folio_orders(char *vaddr_start, size_t len,

-- 
2.43.0


