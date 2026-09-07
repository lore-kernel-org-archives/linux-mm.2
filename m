Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AE95C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:19:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 269ED6B00AE; Mon,  7 Sep 2026 04:19:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F3E96B00AF; Mon,  7 Sep 2026 04:19:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BBD76B00B0; Mon,  7 Sep 2026 04:19:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC9026B00AE
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:19:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 82602160411
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:19:42 +0000 (UTC)
X-FDA: 85186267404.19.C07BC38
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id BC5DE40005
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:19:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="bAu/6Pjb";
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788769180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tlm7T7RrmL526UlmD/NglT3/FkX5zQLQaNa3BEmvmpI=;
	b=qCkuTiTUsGBTmW/SnztPl7w/x/sxRH7MmTZM//slWxzhOBGPoeFtpA2xqOImLvn9AAKsjt
	x+IfBGOjy98jFANIotFl+IqddZ+uVOLtlFxR8l102i6Z+0bA3UZRqpnYXjzSLJ8BXwrxOn
	tegTjQsxIvZ5sIJPnHOuUO18CRjdD6Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788769180;
	b=oSghhgc2931am943WjL+iJS0Aw+mGW2kCQ+tsvst0WHpmBSvj/UHjfNmRXDh9TevHIUdlQ
	PaU6daPLggpiYD2l2FaumyPOTwDoDe2ivWt3NUbsuljzWW3qlBQ2vjzxoGsFl6y+FjTy+E
	vKq6gHEHumJ01auJuP5p7OlJuIjZvCU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="bAu/6Pjb";
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 299E31BC0;
	Mon,  7 Sep 2026 01:19:36 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4EE303F7D8;
	Mon,  7 Sep 2026 01:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788769179; bh=SjfNrQGkpA3X9nEyXuOHe2XZDuXDkedMucJlksznh2E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=bAu/6PjbW9ALf91ta8wJmhk3g660rz7Ozpe0rpq2uBw27iM9DaMdj6WiDYeV7WTdN
	 VIvNlnUtuSlkT3ulwgshWrP0KeFq4w3EW56acxuHMHfp98CTMbMmMcpFGnWiYS9+LL
	 mXJsjpPwtSOYaaUjSHmIj8Jl3VH2Q/3+Xv35bVUQ=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 07 Sep 2026 09:19:27 +0100
Subject: [PATCH v5 2/3] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260907-fix_split-v5-2-822b810458bc@arm.com>
References: <20260907-fix_split-v5-0-822b810458bc@arm.com>
In-Reply-To: <20260907-fix_split-v5-0-822b810458bc@arm.com>
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
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqnnOSrrO8r4u0lwlhzbc5sbDfmb3crAVMoC0LW
 w1Rz9+7iyyJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCap5zkgAKCRBt1cPRWsUx
 M1iGC/9aqtzlyiVBGXMV7eOFM3Ufjmp5uB5Lx3l5hbpoN/RbQsCPM6UTYEJ+ZpBbK3vQUS5vhQo
 9XaPaJCCyAimQhTUW43IO3mZEk9i67HQISn3LK/y41xM1yoaBg9TJIlmN0b25Mbp4pi/+MFRY2Y
 3ujsvnxmqtbYaO694weKWn1jcxa129dfJ5dRYyjFOVd3fFqKHtmk57Jl0GdZUv+wdC0gB8V+Xmr
 NFEL7+PHkO5uQNEA3znn98HSMJPyZ5j7PvFG6HUtLAzqmVMFOvK+ANdaAxCwQW8Oy4c3wQP1xfH
 a3cc2wTBKJtG3fOn4LYN/t688Urpd4+JzWjTgUmAhXRKw1NX5NeU9JB6IxL7wqjqfWIHA2+H3+q
 VzL4iZfkGRtNU1CxLldVr2T5R4X1o923yD35n21X/kXVxleWcYg4nWfT2niCgh62HQteyo93qqS
 kG4A3Ivxi7zozpss1d9q6AkOTMI8gGfo8yWrYlXtOPh2WKBayEDInobUB8paF0YEE2Pqg=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BC5DE40005
X-Stat-Signature: 1dt9bnrof9eh3sda54hr751jfpboc8kq
X-HE-Tag: 1788769180-891618
X-HE-Meta: U2FsdGVkX1/TqD1cj2qSHvZ5E7Mvg4azx8cme4H4m2i5L6y084x0wA1+aNdGepGsicpHd1/F++8y5I+ujZ7k9Wwn64TPjNRxntWGVZIFBy7GaoLgpoiW7d9e2TJcVc+jt0aWIdtSFm46gyFoGyCHas9SPtp+kz3672HD7P4/9YCzj2664xLzG+OOadfyJvJYkJ7t5ngLnsDA7XHj1jfRcIU5iDFL+7WsWDUBrpxtyoSsx7idpTTCVDvhBneQEJJ4qYiSshC8FEszQ6AfTwrs2OqPX0RizOVY5GBQZSxYyATn/U1b5o2alWVVcZu6Xb3UXnu7ZPV4DbCQVpJBKErplV4+kOoaD1grUaRnRVUn3AmgXRTOqM4GCoX4qv3IZGtrT9z1z+zzUdcFfpgIMK1tq85JiwCiqPTgqoij5Xkg1PcfJ1tcrWmDmcCZGI/JZx77pX4J3yv4b61wAL1xQ6w8Acc0g8ALehk4ygh8iDaesqXA6Luh4PqdJol/zF5/YZXpe5ZVa+ojPki1MiBFsK4gi3/3J8FF+2d2vLxK0EQMBWW9FUzrxfDzjFsFBZ38i92WcL5MhJz7mEuu8a0Wq1cmnyrK/iB3HFzO8BtvD4lCmTXQdTfpdoJ/a8onWL4Statrm74WPYNmodLveHbq9i9yjyOuBC1RIe6H+/zBdzah0+tYbWZmDHNYDBBgHzdSiaTJ/iPMTFZpkzqLGEVsGd+RK0FlJUILRcOjFkahPvrvilS7CtpPtu0LU8NoDCwm+2iJlKLbBYD+iSsUluoDIOjSqSXEhnG5XsnPiCz8VMvAXVx05CnXeYCw3hzDJSrWE2ZwAn4+9I7xSlmshal6QuP7Awn33vQU9L8rmuwKhk+mw5T4VL4h+0/QUctOcGQS70MsQ07VdKQf69gnyWnGT5G9u8+ks1WBEjfpc5Z81J9aFJ065fjQRWXiPNOhOJ3PBiCUjJXtJV4+loWOqzj+Cid
 1eGnBPlT
 9F5V77FvlFEDtMZOeKwMXu+UeUCIedtk4C7BLHQWYQ8Es5fAHIrx5fbkgW6YL8OyG66fKXkE/ODMzv2XcXkFwAWSDLCRHSXfXRaUdn4mP1H89JFiQx0c56Zq5W+BsjhAEEOmCd2YXfx5XcQ6lBWxUes19+UmKw3BLirGHskZsjOebXVtFxvU2T6ZIjKCdBpkccEB4nY9h7GzyqCgbeZou1xhVaCWJ1AoLtqSrbMPv/xovCet6sjrY3N/S2/PHTelxfjR8H4GhzmZV1iKYSvFXFkhlhuGJ559pevISrLWjzwjF6ow/LB7sSTRbECe73E5w0XkjCyKz3ZYOMRkNUrEE9IdArFBPAy+3CrfHNrZTfOy0jW4ce4zpKCWkJv6Ii10FupcKE6UA+OcCij4=
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


