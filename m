Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E63CBC982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4478A6B00E7; Mon, 21 Sep 2026 06:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41E1A6B00EF; Mon, 21 Sep 2026 06:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 339A26B00F0; Mon, 21 Sep 2026 06:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F3E126B00E7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:40:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 628C6140123
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:40:23 +0000 (UTC)
X-FDA: 85237425126.02.0775A0F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9041E1C0002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:40:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=edH+WGXv;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789987221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWEQ5jh9bF3NbE6KHwISXlDlm5O0dpUO93ngVC+4Slc=;
	b=wC0maj/decm2cwtxRXaQ4AVVBymboybrZn4RPZdiGtnKleb3/nVZrtMEfJcbyb8aUzgKwq
	bU6kMk8QJIAa1Q0fCB0FkaYy3BN8IEwobwOBlzgZEkB6EeedrqRGUH9QvkuqMJzH0wAMq+
	zElUCay2JWhGNau9y+dzIee5nJZi8zM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789987221;
	b=ZMg9DKlh9hyPPCmYRTk6Sgfn/oeOaNPDX+0mM6R/ZJYnvjYEjI2j10XZE8x7zHM5iRxVsi
	K0HHVIXU26VOZaqNbOesjwdpPUsvfocvFMKhVXYCgiiHlaOTtZhVwtdrFpg/dvK1XRP/rU
	GyuRAXFzJPlqvfjfN0ala71nrfT5+mA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=edH+WGXv;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 38BED2F;
	Mon, 21 Sep 2026 03:40:17 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B72DD3F86C;
	Mon, 21 Sep 2026 03:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789987220; bh=EdKZk9/jwDQIH8zFOg73ZY28l1qbx+55/Tqq3ekXyzM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=edH+WGXvFOoqTmFzW/qAYeuRkSbYB6GoWYchgnXWGvg+ykyVLn72hrrdSESDJNbtg
	 SqvbwjgLAhzrP/wucnb1SJNssIUgMhCqFI6kvt7xa91iqxEvl6a9P42itW5mSsEcWt
	 KMinCG5BbLF0Jt7L9zI8coH2iDy5CZEbXUvOUYrE=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:40:08 +0100
Subject: [PATCH v7 2/3] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260921-fix_split-v7-2-d25ec991159f@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7429; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=EdKZk9/jwDQIH8zFOg73ZY28l1qbx+55/Tqq3ekXyzM=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQmJmsEaafXH26QPIpE3mc5C7ESbc2MlpKPoS
 c7L30rdhyKJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarEJiQAKCRBt1cPRWsUx
 MzXrC/0TBjJtiyR2c/wJJd55mqoYa7VS2P9VnxgPc6FtQX4KqIXS6rrQ9ffuNCJqGf2TJffEe3x
 6NnvLtDZcdMd4iPg6OUy5TZ59DQSlZdLMtiHfrsDi5TKjgqRzy0lFLXJiFYvFl4+Z9Wt0Vsur5i
 SMEWYViWoEvo/B+mNtThYRUYxReqj08ecc6cdO3pQy5SZ1/4MVVHjyGI5aMg96T1uxuEBHmUWrA
 MXPVICjJp9DVnCYs71frynxaS3TaZ84c/ooFFU3FUT0q+HPksl5msxvs7KdVGRCv7ZH0qjySf3S
 tyQmlgdWZUns2U1OVeRsKE3KiFdSd1xZq8LpeiP3OAboubkfBXXp8+HAHSQQ5Afks8R/1rlFyLr
 jBuRZaOq6PROy6ZPUGKuGyi4o7rsirU50HxLdzGUKQ6WY9xX9GzXwpGTec2HjU4NDkvxbqyFU80
 x4CZdTbOT40GThnn17nyNl+rU6L1/ay+tyJgsX8BtpgAMilEQeLn7BQYrMVwiF9NxPjrQ=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: by68m1sjzjk41ainqdfyih3xmdgy4pgd
X-Rspam-User: 
X-Rspamd-Queue-Id: 9041E1C0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1789987221-585537
X-HE-Meta: U2FsdGVkX1/zokDVBuwCUD2cOFWcY8YmXuqtLnIIN8Smr3lppvrwh22hrcC1DthgQVJteMqnaUQQ1szCVws50cAG9cj+qrZ63qZgZTO3lwtlmvL7dpSXCmB1JSguf4uvKnQPYMigco8gUOLOz3jUP96vklWVTgXHAd1GnuTZtDQOif0gZKmj8q7LrY52zxRksiH1+3y7d/n5QJh+XZywAYRFrBi1dfMbTLABAunKgqAC6BCpSz9sbrfY1bOHQ2hut8Hr9XyKykHBhiYk+0Dkl/Q3thg7eN4kT26MF1CjyWqYW+H+zRNr5UremJlqHmFsh1c2lsP92wN+Ez8UDrInMWsk7EWQiPpHAPD4DDo2JD1wiozeb+tOg2L+raDlOzXEIkip0JYHnE0ozW7UR1HKx3NF4FBGAEO9N6mJEbQP7sR6t7UdR3Gs9iR29FkMD+DyPk3HaMxzcVlA4hkxmBvfvdHv2wChj8qC3NiC+0Cx9J9PSZcLPSjzRAClA46+yll7/aws3VyzMcE3eyqAd0pBA0Yzg0ijlZdFDsMOhhMMaF/IrzZYcA/+Ru6Ef1jcDhGtJro1bX8qKo9TDeCiZyPIRif3BVLuSRkuw6da9r6ac8obEqje/4nb+7hU5fzPsmdr81BLVgZ5IaclKQ+5GLe7fTF/fulgtjq9xMKZL6WfC30ycrKhxafSEDFk5HSDRIX+0skIgVVC0hEiANjdXzweqsuJAs2QVPTBvfPXR6cdBDm2Rb8SM67B9bGfH6ryB3hxaYXn5Ltn+st7GWHVG3QZ29JRO5A+OZ0BEBG72f2KC06gcGhfcNmgcQpoz9eUV8xI8Ux3YZbLHcqqFtLi4RuACPKhUdqUIWQxtVfW1+/dxgbKTtPlOkAuj0TWv+GuwBTlc6hliNvhTlABwJE3w9t6IsUkU2XmYn6zQ6anu4mrceIr6JqB9OxeiBLmdHG8PNCtr1N0iZmkw/WlOYvrCIc
 6lAHOeoT
 cJpcSLOK//nJ2UWcjpzT7BtEc5VLbLQFYG6FC264ieLr594EBxHo28/XVuRBhQ/4IFfdCip+m4gff0ifKI1zB62OVNJsHCyIJuzYB2AMf0md9ljA6RJOqnA+8SIBCyTn98tG78hJNcvk2lfvZADKnKqFtNpEQiGtoG/FpNE+4prpovhSz7oafriFqje7CjnuabhR1CEJyyvTU7ela1gYQ71EayIzTaWNaG59wzwrenfCdjo9nUmdqCWvcuhjIOqNo21/L8BMfX43UPmunyPM/Jg2s/+MyBqkbn028SdlouLrtvFeoVMSJPO+UuRQmppya3jGk3GZt7KqRNvATWL+J7F5gccseAfDkbvISm19eyB9U/0TsdNev9YNcFA==
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

Since shmem pages are also file-backed, simply check whether the page
is file-backed.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/vm_util.c | 137 +++++++++++++++++++++--------------
 1 file changed, 84 insertions(+), 53 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 4821a35630363..a7c5caf6925e0 100644
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
@@ -405,48 +378,106 @@ static bool check_large_folios(void *addr, size_t len, int nr_hpages,
 		ret = true;
 
 out:
-	close(pagemap_fd);
-	close(kpageflags_fd);
 	return ret;
 }
 
-bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
-{
-	uint64_t pmd_pagesize = read_pmd_pagesize();
+enum check_huge_type {
+	CHECK_HUGE_ANON,
+	CHECK_HUGE_FILE,
+};
 
-	if (!pmd_pagesize)
-		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+static bool check_huge_type(uint64_t categories, uint64_t kpageflags,
+			    enum check_huge_type type)
+{
+	const bool file = categories & PAGE_IS_FILE;
 
-	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
+	switch (type) {
+	case CHECK_HUGE_ANON:
+		return !file;
+	case CHECK_HUGE_FILE:
+		return file;
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
+	if (kpageflags_fd < 0)
+		ksft_exit_fail_msg("open kpageflags fail\n");
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
+	return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_FILE);
 }
 
 int64_t allocate_transhuge(void *ptr, int pagemap_fd)

-- 
2.43.0


