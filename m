Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C20A6C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 12:10:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D757A6B0099; Wed,  2 Sep 2026 08:10:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D26E66B00A0; Wed,  2 Sep 2026 08:10:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C63286B00A2; Wed,  2 Sep 2026 08:10:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CE6D6B0099
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:10:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1EDE88018A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:09:56 +0000 (UTC)
X-FDA: 85168703592.29.46D5E8A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3CF82140011
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:09:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cEIY3ZEQ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tlm7T7RrmL526UlmD/NglT3/FkX5zQLQaNa3BEmvmpI=;
	b=MOeim0rp7Zq0t+iDc5RgKbi1E9ai8kH7YHRPZDdAob++/Cr9uuj4b5Y6E82XhSBtHasgIe
	WW5pTrSeZ4Pj6EzEqGbeXX8NILLWvMQnNuj+Y+3RaPCgkNw9KtD9g1hN79Y+X8Ux3YbmOT
	3h30IGJBHfHNQrZbI0Hm2kcWUBTcRbE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cEIY3ZEQ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350994;
	b=QRjxYzXBnGb/P1lWpwlsuC+BpXcFts7Qm9HW2Kj0TLRCU4Pj/PrGJb1zh8toXLPAhxhgDp
	4FBKMcMct6LvQnp0AXoSd5n+OF03KE6/UQ4xCaixmXizUME6DvPyJMPgKkCDHpeMqYYMZz
	xrUFYCrzDhWYID8L4YLLR6rCi0HYF14=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ADC001684;
	Wed,  2 Sep 2026 05:09:49 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6EBB93F8C6;
	Wed,  2 Sep 2026 05:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350993; bh=SjfNrQGkpA3X9nEyXuOHe2XZDuXDkedMucJlksznh2E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=cEIY3ZEQzPndMqZGE68WnJeWiFO21+8K0n+WqFQ73fBq3A6q/mhRdYUDCPlZ5vx3u
	 sahoLhvj79mb8YbKBGmiLOsQdS3R+775Og3Cw2oaD2ZSY7XNMMHrFJjAudImdwoZ0L
	 cRUuuDr2VsT2MPNqwrrQWn2o1AWjsTyBVCZh4qk8=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 02 Sep 2026 13:09:36 +0100
Subject: [PATCH v4 2/3] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260902-fix_split-v4-2-85f03905f7b1@arm.com>
References: <20260902-fix_split-v4-0-85f03905f7b1@arm.com>
In-Reply-To: <20260902-fix_split-v4-0-85f03905f7b1@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8322; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=SjfNrQGkpA3X9nEyXuOHe2XZDuXDkedMucJlksznh2E=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqmBIGChN4Z/69/a8p/NDwEvJkPUxXNn52hUppN
 56OwlIXil2JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapgSBgAKCRBt1cPRWsUx
 MwckDACsk24Kt5Y9WNpyRadANFyOgMdwdOg1bJ2L7UYNeHQBnB98PQvTfy6CyJi2Vfbt5/ekH6U
 rxHRkn1wWDRj7MVRHYY8nIuDbJXtDw4rFRaeRlsx4YB6NnrQ6ldbLtD8/Zp3ryBAATb8S3t8t3O
 DBOKxQZfyVhjFNC9Dvulm38uonad/iNkoj9exikuxDbTYj3aMwA02oyxntPBsR4pfcM8f2Yl/sY
 arTg5AeamU2PgV4ZwBKny79p0Cx4w8EXKrrgUmn9DeVI2v+H0xrQ8s2i3kOvrpXM9E/oGZZiBSV
 pDC2QtuVUPgwIeH4A1eia+kH56Cvj3f6he2wwfgvk0v44SS23uVvS0dzL7r3YmRzHLa3Z1NwmkZ
 UHo1z/VSKAhv4iYVmxpigtH/gFcqw6cJ9NbGuh9AGLkW35ryQ74AeBz/d0veKddFM+bW9zwwRBH
 kyYBqLyghJG6+jiPf9wCTyA2P+Rr2ShrqqZbmMkJWAmdp4/Z6Zew3R+MnJFR/gn1jaIF0=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ug7eunrqejihacyp3cc3kh4kp9fiycaq
X-Rspamd-Queue-Id: 3CF82140011
X-HE-Tag: 1788350994-124951
X-HE-Meta: U2FsdGVkX1+pSEbjryWdPxs0e28L5zEAvzuOMTkVQCAAqsUZMkdsru1GR6vGm4kwhmrvl4eEZOdQdGuOSIXbZk0adNZKL9DWQa/1ChkDP6ppHpfqXCwdoI9tnm4MXTqy3MSYgOCMfkdJ1eZFfj7rAwcmlWU/5s/bq1ZINJ15TweqdIhCDGQyRP3RopxuQrYig+fawnLbHyrTReHiHhSb/1nGkVdWI0dq1xzWb+5cRF02u8p/lF4UfVymOBiVbCkcq9ZLPDgzfBgXLGqTXs76FacWo03o7ofWkcssuq80iLJ4mAGVpdLlQErcpO0+0S18aJfkUdzWEWzMC+lBF5o9et4fpZhpy2ZPPDH4IUfzr/wGWgP0pewq/yulCl8YVIUV6W4ifcBC92xstlquQd1p6r3ZZou6DAoGu88WtMbDcUTETAuCtEfk+g+DLADY2qOqEQTAy6/xD5XZtotcRuT4r0yaT+VrxzdNhtq2tHfWG9xUuxM8HgLmoIzyqc2n2ogjeAmxUn5kT1wvl15ot0pTdv8mxpeBIrJgIex0+SQTkfnKB7Ee/MyuFXH6DQ+aGM9oJRRmITrrT5FhUIVNizVwa3lTM8OV65zrvvn4CWgD+XhMN9LK2XWXMs6mcnkZX+6pUyA3NHRIKvmvFv0SK/Mu1x8W164m41I6/+gBpQmIPA1Hr+iVCrqrniQi9cZeosSrk6jGPdhWoc5LJO/KCp5KluSH+dLrHZL+AZQWnTqlqow49LI4X9zY+r+Z2Yo5hc/sMMhOmvQMzACT9Nizv8iBYxlIS1v33ucQGW+X4zpDruKHt1iWSIflTOIjGbtHgUpMhDr05qIlqsvVYF8YVpeHUvCiN+KTqRRqDI3CA0Qq/Uqqdb/p4u8X7vXvsy1rxJ1ymzvccrMO1O/w9x7iz//Z7ECuLH2MffKJK5lT71q/L4e0nvfnzbv6q8t779vbQLgLI65E1TOYM4KgUk4hmw0
 UAIwHA8E
 heFq6fXJChG4LdRECccHQE5bZvFBppNTexkB7nPg5nRxCAM0eURXXKAEkQnx06iB+aq/zzhnuxCde9S7q0oxuzZF1W/FnBC3rJjM2O6GnjyeH5tr3F8gYq4R1LRoRijz/6zIuuZXTwYkrUKadZXnvMfJpDC0tlxBPMufCLTcW4vsJ+8dmQDdZrMGfEWhrpkQIqzZvpW6K9Dei/svtRfY7iHfixJMZFTPLS2EO17ikbbVP8CRz5ThD/xacEaQFVivlvObFJX0fnrerXaS4op4X5olydXRn/zlPKdJlOi/aosd2CiGPwUKlub1weqcll9lf99aQBTCnAM69USGwVp/+Vu8UVlYBS3yjVoQSv4MM2arK7/LfTeyEwsbeFsG3lwqPzVgzU0mbNHllVTY=
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

Instead of relying on /proc/self/smaps, use /proc/self/pagemap and
/proc/kpageflags to detect huge-page mappings and large folios:

  1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of
     using check_large_folios(), since only the mapping type matters.
     This identifies PMD-mapped huge pages.
  2. Otherwise, use check_large_folios() to detect large folios. This
     covers mTHP cases.
  3. Check the folio flags according to the type of huge page.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Suggested-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/vm_util.c | 145 ++++++++++++++++++++++-------------
 tools/testing/selftests/mm/vm_util.h |   1 +
 2 files changed, 92 insertions(+), 54 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 4821a3563036..dc62ce84e143 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -351,31 +351,13 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
 	return entry;
 }
 
-static bool __check_pmd_huge(void *addr, char *pattern, int nr_hpages,
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
-static bool check_large_folios(void *addr, size_t len, int nr_hpages,
-		uint64_t hpage_size)
+static bool check_large_folios(int pagemap_fd, int kpageflags_fd,
+			       void *addr, size_t len, int nr_hpages,
+			       uint64_t hpage_size)
 {
 	int order = 0, pagesize = getpagesize();
 	unsigned int nr_pages = hpage_size / pagesize;
 	int orders[MAX_NR_ORDERS], status;
-	int pagemap_fd, kpageflags_fd;
 	bool ret = false;
 
 	if (!nr_pages)
@@ -386,15 +368,6 @@ static bool check_large_folios(void *addr, size_t len, int nr_hpages,
 		ksft_exit_fail_msg("invalid order\n");
 
 	memset(orders, 0, sizeof(int) * MAX_NR_ORDERS);
-	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
-	if (pagemap_fd == -1)
-		ksft_exit_fail_msg("read pagemap fail\n");
-
-	kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
-	if (kpageflags_fd == -1) {
-		close(pagemap_fd);
-		ksft_exit_fail_msg("read kpageflags fail\n");
-	}
 
 	status = gather_folio_orders(addr, len, pagemap_fd,
 			kpageflags_fd, orders, MAX_NR_ORDERS);
@@ -405,48 +378,112 @@ static bool check_large_folios(void *addr, size_t len, int nr_hpages,
 		ret = true;
 
 out:
-	close(pagemap_fd);
-	close(kpageflags_fd);
 	return ret;
 }
 
-bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
-{
-	uint64_t pmd_pagesize = read_pmd_pagesize();
-
-	if (!pmd_pagesize)
-		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+enum check_huge_type {
+	CHECK_HUGE_ANON,
+	CHECK_HUGE_FILE,
+	CHECK_HUGE_SHMEM,
+};
 
-	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
+static bool check_huge_type(uint64_t categories, uint64_t kpageflags,
+			    enum check_huge_type type)
+{
+	const bool file = categories & PAGE_IS_FILE;
+	const bool swapbacked = kpageflags & KPF_SWAPBACKED;
+
+	switch (type) {
+	case CHECK_HUGE_ANON:
+		return !file;
+	case CHECK_HUGE_FILE:
+		return file && !swapbacked;
+	case CHECK_HUGE_SHMEM:
+		return file & swapbacked;
+	}
 
-	return check_large_folios(addr, len, nr_hpages, hpage_size);
+	return false;
 }
 
-bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
+static bool __check_huge(void *addr, size_t len, int nr_hpages,
+			 uint64_t hpage_size, enum check_huge_type type)
 {
-	uint64_t pmd_pagesize = read_pmd_pagesize();
+	bool ret = false;
+	int pagemap_fd, kpageflags_fd;
+	int nr_pmd_mappings = 0;
+	uint64_t pmd_pagesize, scan_mapping_size;
+	uint64_t categories, kpf;
+	unsigned long pfn;
+	bool check_pmd_mapping, allow_nonpresent;
+	char *start = addr;
+	char *end = start + len;
 
+	pmd_pagesize = read_pmd_pagesize();
 	if (!pmd_pagesize)
 		ksft_exit_fail_msg("reading PMD pagesize failed\n");
 
-	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
+	check_pmd_mapping = (hpage_size == pmd_pagesize);
+	scan_mapping_size = (nr_hpages > 0) ? hpage_size : psize();
+	/* Some mTHP tests check a partially populated PMD-sized range. */
+	allow_nonpresent = (uint64_t)nr_hpages * hpage_size < len;
 
-	return check_large_folios(addr, len, nr_hpages, hpage_size);
+	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_msg("open pagemap fail\n");
+
+	kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
+	if (kpageflags_fd < 0) {
+		close(pagemap_fd);
+		ksft_exit_fail_msg("open kpageflags fail\n");
+	}
+
+	if (!check_pmd_mapping &&
+	    !check_large_folios(pagemap_fd, kpageflags_fd,
+				addr, len, nr_hpages, hpage_size))
+		goto out;
+
+	for (; start < end; start += scan_mapping_size) {
+		categories = pagemap_scan_get_categories(pagemap_fd, start);
+		pfn = pagemap_get_pfn(pagemap_fd, start);
+		if (pfn == -1UL) {
+			if (!allow_nonpresent)
+				goto out;
+			else
+				continue;
+		}
+		if (pageflags_get(pfn, kpageflags_fd, &kpf))
+			ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
+		if (check_pmd_mapping && (categories & PAGE_IS_HUGE))
+			nr_pmd_mappings++;
+		if (kpf & KPF_COMPOUND_TAIL)
+			continue;
+		if (!check_huge_type(categories, kpf, type))
+			goto out;
+	}
+
+	if (check_pmd_mapping && (nr_pmd_mappings != nr_hpages))
+		goto out;
+	ret = true;
+
+out:
+	close(pagemap_fd);
+	close(kpageflags_fd);
+	return ret;
 }
 
-bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
+bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-	uint64_t pmd_pagesize = read_pmd_pagesize();
-
-	if (!pmd_pagesize)
-		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+	return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_ANON);
+}
 
-	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
+bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
+{
+	return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_FILE);
+}
 
-	return check_large_folios(addr, len, nr_hpages, hpage_size);
+bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
+{
+	return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_SHMEM);
 }
 
 int64_t allocate_transhuge(void *ptr, int pagemap_fd)
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 9a49af88702e..f19bd17817e5 100644
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


