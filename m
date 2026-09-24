Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94FBAC9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 19:11:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A96B6B0095; Thu, 24 Sep 2026 15:11:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 182026B0096; Thu, 24 Sep 2026 15:11:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 049156B0098; Thu, 24 Sep 2026 15:11:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D07526B0095
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:11:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B0B01404AF
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:11:43 +0000 (UTC)
X-FDA: 85249600086.05.786DA1D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8CBEF2000A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:11:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GPAlFBAt;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790277101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oSpaGOgRlFaEX6Djx0U9Wf8iqz6mTgAhJ7wWma2xQvU=;
	b=YoEulrws675mntOGCYaSRgrfiB116SwuSw4JrXiqb+vLmlsqN13ox3DdVeGF7GDraGxLw8
	2PsTg1A8bgfS9me2c7txSYz+nhfACQLFzlZ8Aqme4mGJDXWopRr+uhKuGbSD3N86I8K8Z0
	jiQFlXci53h0+eE9KKusGsKXo48qNFk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GPAlFBAt;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790277101;
	b=rFXAWoDhW5tpblwwCK7Rur+ITLLPYmVCqiWOmGmw/fkfSEPKbPttiIiokmSNegNoZ73zJc
	336IWeWCowiJHipXS/zW2VGdZ0bDGeeui/51yi3UmHFTzT/l2lbHcyXn4OVFbqKZNGGW9a
	UJSVvfJnusmsDOaZd6M5Msw/Bi1ssio=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 20B191E8D;
	Thu, 24 Sep 2026 12:11:37 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4A3FD3F86F;
	Thu, 24 Sep 2026 12:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790277100; bh=fDkgRwO1bSLmE20FjTBQYz0rSMBZdZYYVM8/o1IT0V4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=GPAlFBAtX8ns+cMS2XIw5tZow6WHg72k4VFEyV6SkkghzKJFEdeA4MwPWujeARwwX
	 WHTSoYp31utUWywI4YXgdM92JadbgT5/3flyNZll9HugogFacVdYI6YSYagDNKcDJR
	 NgGXNwDMLiXBih0iLFB3vjRRZEjR7V86oRFlDw7I=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Thu, 24 Sep 2026 20:11:18 +0100
Subject: [PATCH v8 3/4] kselftest: mm: integrate huge page checks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260924-fix_split-v8-3-cba7359d882a@arm.com>
References: <20260924-fix_split-v8-0-cba7359d882a@arm.com>
In-Reply-To: <20260924-fix_split-v8-0-cba7359d882a@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5654; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=fDkgRwO1bSLmE20FjTBQYz0rSMBZdZYYVM8/o1IT0V4=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqtXXdGx79YGZps9yF/7wwsZToJptGpYy5CgrtL
 IzLraqJp8OJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarV13QAKCRBt1cPRWsUx
 MxmeDACqgTanCs17S883JUW3jGlxbmdTTM/Q/vfT2y70PDaDDj6zs2IIJge5avkyEHFkFRzjjhl
 lrZs18knmquEo7LScoOxvCtD/k/4GC2dgLE+zii+8zQVq/i22heDazpK5cEn9akOYYEGa5pqgfG
 rvUUujhX3CZyp+255kwmohH49zdRBwjAJ0+pwdepOYEc20ec8mLaHYmjVCxK5Jqf6kdxDP5B+Zs
 D+hthXo/gwSpie9UCbQlBEWV67Gbax8c4Rr8lLi17MkCaqlR4x+9FJE8+Cm6OsTuGCdYhM6/TRW
 oz4draSDkVDIdT/5d7/ZAMtVKrtVx/lvu6f4ORS4ebdD3CB+ke0vXpCPJiZbjHVqTMqDqrFa0Bd
 ORy4/fjuBSZgO8qggOzcuXTzHCSpa2SRESBJ/agHV/hMlRKEoT2C6djkje817gCmk++tGxCMipQ
 jLLh4QSRcjr2eNVFFHF+nI+mTKfu4H2MPtouU2JYK7U+I7PQnp5asZDhQvzizbBKNhOIY=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Stat-Signature: stjajhuhp5jff9dm6k7ke4xu38pqfzns
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8CBEF2000A
X-HE-Tag: 1790277101-675654
X-HE-Meta: U2FsdGVkX1/SFLHIZGR+UqpCo6VvVXkcCQO3Q2Wz5iCFB4crAJisGSOmB0QTt5zhmsojs0fQKgCt3FDdlIT1KKEFRoPN4XFR3KBbVUsPq3TYxEExZca+0IV0GNhR+zqsNg4XPOpWKH1/9S8ItVYmf1AeipI5cWY5ImCXjRigxaxM9XiohJBSB/9rwUz4aRxhySEpLu8oXnayz2RnbEjZwZMi4vuJopR6JacBnuyJDyLMZFrN5hmu2LsXIyAha+xUn1+lly3RASYzvmQiXccMEpSfn6OowLvTbiSnQqymHEYU7AxMriwsmBnx3h1124a9L6OSmXeJvoUNq6SIyhtf/9sKSAO80ulm6w4xN5QMfwuF42jIOcEnReTGcFj9rmvmJ3s3fJuJZfQwMYkcy0diUvihcrwkFErT69c6K6n0Ysg4CClnOAFMJnqccsEyIi/zaquamb5xenDU1iOsyLOb1Aa+M57w6+cDh7liCenA4+hN8cxtiR1io2sCfmZKAPNAcIrL3DdmdBsJb/mZwd48+wOniD5zJkS6ZNETutyDL4+O3grjODjsnEHPwzta3sNpTSnnupCOyDq7+A3vdA2yomYAmeQqMghLE0tKxuZOz2uJs/vJ4KrWRCzLJh6M705qnlJO2csGGySiDMVLMaTw9me4sWPLjqEpo1AZdg9N1g7EXvafDHVAYZJ1U8hkW/tIcZf13XivzSXZ/nCfL3Nglo8F7Y1LaEoH/7eUTG8K/dTqistGVcN167z5p2kCWQBAHDCgammwUYm5w8gUOGJMBLKC11oBW5wHNd0egLxkVZq9bu/5zTsTrzYaTfvWqC5Nfxj2WzkFDh8ev1rgA/1+SSi/UbekRxPRUfcI8Q2R3qcN7cfycj5puB6ZH2vEZuz4dsthWFzfLMWULPGSNJKQ+IhzM3RcVPNd6AXXH4qsD05olZQSGgA57xOXJRotzg8IjHbMCYXgt5Xvvuk/CAa
 0cJvyP2/
 El7n5T3j2pqiGYMJ45Fimz65yDCozY9X9nsyEIA0t11q2Iy3WkOG/C62Q/z690P5hvcEjCCDFI/u75z+lbBptIO7L+qiPvjnn1EzJuLx15Ybxp9fAoYufFUr9ozJNKrgF5P2PoFgqBSczi5nI4TgO4q15K8Thme3rvC3LGvA4Ajxge3kAbalMzvWhEYgplILbXoTEjgHpGf8e8oZqDRpEYJq+h4WsvMLjUa68Q6txfEq1jWOYh89LZqn9jUqR9wmvcRhrMAe/RmSiOKMcgy54G6/A7ZY2SleYXzUvrNEqFph5c4xdZIce6rPxxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

check_large_folios() only checks for large folios without distinguishing
between anonymous and file-backed huge pages.

To add huge page type checking, integrate the huge page checks into
__check_huge():

  1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of using
     check_large_folios(), since only the mapping type matters. This
     identifies PMD-mapped huge pages.

  2. Otherwise, use check_large_folios() to detect large folios. This
     covers mTHP cases.

  3. Check the folio flags according to the huge page type.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/vm_util.c | 90 +++++++++++++++++++-----------------
 1 file changed, 48 insertions(+), 42 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 969d7202500c..7d23038af1df 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -351,13 +351,13 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
 	return entry;
 }
 
-static bool check_large_folios(void *addr, size_t len, int nr_hpages,
+static bool check_large_folios(int pagemap_fd, int kpageflags_fd,
+		void *addr, size_t len, int nr_hpages,
 		uint64_t hpage_size)
 {
 	int order = 0, pagesize = getpagesize();
 	unsigned int nr_pages = hpage_size / pagesize;
 	int orders[MAX_NR_ORDERS], status;
-	int pagemap_fd, kpageflags_fd;
 	bool ret = false;
 
 	if (!nr_pages)
@@ -368,15 +368,6 @@ static bool check_large_folios(void *addr, size_t len, int nr_hpages,
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
@@ -387,8 +378,6 @@ static bool check_large_folios(void *addr, size_t len, int nr_hpages,
 		ret = true;
 
 out:
-	close(pagemap_fd);
-	close(kpageflags_fd);
 	return ret;
 }
 
@@ -411,57 +400,74 @@ static bool check_huge_type(uint64_t categories, enum check_huge_type type)
 	return false;
 }
 
-static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
-		  uint64_t hpage_size, enum check_huge_type type)
+static bool __check_huge(void *addr, size_t len, int nr_hpages,
+		uint64_t hpage_size, enum check_huge_type type)
 {
-	int pagemap_fd;
+	bool ret = false;
+	int pagemap_fd, kpageflags_fd;
 	int nr_pmd_mappings = 0;
+	uint64_t pmd_pagesize, scan_mapping_size;
 	uint64_t categories;
+	unsigned long pfn;
+	bool check_pmd_mapping, allow_nonpresent;
 	char *start = addr;
 	char *end = start + len;
 
+	pmd_pagesize = read_pmd_pagesize();
+	if (!pmd_pagesize)
+		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+
+	check_pmd_mapping = hpage_size == pmd_pagesize;
+	scan_mapping_size = (nr_hpages > 0) ? hpage_size : psize();
+	/* Some mTHP tests check a partially populated PMD-sized range. */
+	allow_nonpresent = (uint64_t)nr_hpages * hpage_size < len;
+
 	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_msg("open pagemap fail\n");
 
-	for (; start < end; start += hpage_size) {
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
 		categories = pagemap_scan_get_categories(pagemap_fd, start);
-		if (!(categories & PAGE_IS_HUGE))
-			continue;
-		if (check_huge_type(categories, type))
+		pfn = pagemap_get_pfn(pagemap_fd, start);
+		if (pfn == -1UL) {
+			if (!allow_nonpresent)
+				goto out;
+			else
+				continue;
+		}
+		if (check_pmd_mapping && (categories & PAGE_IS_HUGE))
 			nr_pmd_mappings++;
+		if (!check_huge_type(categories, type))
+			goto out;
 	}
-	close(pagemap_fd);
 
-	return nr_hpages == nr_pmd_mappings;
+	if (check_pmd_mapping && (nr_pmd_mappings != nr_hpages))
+		goto out;
+	ret = true;
+
+out:
+	close(pagemap_fd);
+	close(kpageflags_fd);
+	return ret;
 }
 
 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-	uint64_t pmd_pagesize = read_pmd_pagesize();
-
-	if (!pmd_pagesize)
-		ksft_exit_fail_msg("reading PMD pagesize failed\n");
-
-	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, len, nr_hpages, hpage_size,
-					CHECK_HUGE_ANON);
-
-	return check_large_folios(addr, len, nr_hpages, hpage_size);
+	return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_ANON);
 }
 
 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-	uint64_t pmd_pagesize = read_pmd_pagesize();
-
-	if (!pmd_pagesize)
-		ksft_exit_fail_msg("reading PMD pagesize failed\n");
-
-	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, len, nr_hpages, hpage_size,
-					CHECK_HUGE_FILE);
-
-	return check_large_folios(addr, len, nr_hpages, hpage_size);
+	return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_FILE);
 }
 
 bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)

-- 
2.43.0


