Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67C1CC9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 19:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9241A6B0093; Thu, 24 Sep 2026 15:11:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 886C86B0095; Thu, 24 Sep 2026 15:11:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79C2D6B0096; Thu, 24 Sep 2026 15:11:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4AA366B0093
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:11:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE7AFA046A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:11:40 +0000 (UTC)
X-FDA: 85249599960.17.9F6F5A1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id D07BA8000F
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:11:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PTmpeLUu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790277099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dC4O5F6Ddj9BzaYbMt0Zr1XCoPLQOwaXv20g1TyzGlc=;
	b=52cyZUIbj9333Ut/zHiOg/p7n5glIax32vHdz5WVHZufCZ/1ApmPayHIAw7Q4bOZvL2H01
	u3iLhyPguxBy95j8YNbQ1DcIKFuFa7Fbkng88dvSMCm6MljKKoGYkKtuenHdm0iViuf0HT
	Sw/e1dpRqjPM2ODwRb6om0kAQRDGalk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PTmpeLUu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790277099;
	b=UZTWhOYChkE7Y8Dt5a0lt/t194fgMmC+OVM7/APY5gRcgeVvsPXuR0MQcIJvwB61EMaa6o
	D99NEkckI2Gn8AWbgWwkibsiz+RBwJp/16WcLIFrCLEb1LJv2jteW/5Al+rUKF/NDL/dTb
	KZT2mYUV8X3PjsYbWYROZiI3JEs//2E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 723ED1E5E;
	Thu, 24 Sep 2026 12:11:33 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 90C143F86F;
	Thu, 24 Sep 2026 12:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790277096; bh=NJ9TsBzPv0Oz4pphqp12ZqEYe9odIvfqK7qCBWhEW7c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=PTmpeLUu4wyIj1VaQQTuEqD6nqge3tOzbX7ZJEZqdDH2SUBv0TNPzoNuP4aFLj8ws
	 NuixyaR/Zh+VrabD50dyp6o5Nde9QnXJq+506g0M4rcRVtyl7BJVoVKo81cD40gWX8
	 RRNePOKqfC+x7r/TLFVFmUk+xTXjnvFXg/U/swmc=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Thu, 24 Sep 2026 20:11:17 +0100
Subject: [PATCH v8 2/4] kselftest: mm: replace usage of /proc/self/smaps
 for __check_pmd_huge()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260924-fix_split-v8-2-cba7359d882a@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5190; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=NJ9TsBzPv0Oz4pphqp12ZqEYe9odIvfqK7qCBWhEW7c=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqtXXc8ibPfv6vH/GOhPDJPfprZtHargXZrqKwL
 CAek8ul5gqJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarV13AAKCRBt1cPRWsUx
 M6qoC/49e4gLA4pQqDOKPjaqBhxn+g5q+qvt/d44hJ9I+Arzn03Yuoe6sCrJEOTDTbis86jDTIN
 qn6AUEmWUsmnamdtCWPy/9lc9ZDc87rKcOi8I1hBazFT4QncxIK7i3pO0VGvKLv2StKRyQRKjlo
 +PUp59Aq2TYvcVTM6k4nqyL1xq1k2vK/DjTBf7d8gArMI57xLzWyTDKDRWs0Ar41NmpqadNnSpU
 7BNPwRWlBMINyTIPnjc50oeVpAlYgZ6O+Ty66x/w/cOWSe5yLsEGWRsRijwqzEUvkzuCPUU0t4u
 F+Ri6/qv/xX2MhniPrP8edl86i2EgOyk8uj4P75mPF1vnUpwbIO4xErnIdVasc0WSjK04Ul8CM7
 k6c+fYYwe+QMDfjjrZb68gnTcdHdw/cnCkxFSBSR626PSNXGpvtfPtuPIHhHoLjrAMuYpnJxA0a
 Ci/nxP4ViurmzAsPs13TohS6XB4nAmN/xONoNXe3ZtUjW6wWIsq+8ql0dLO+uZOlLCi0U=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Stat-Signature: 5k4tz6a6kshcmzeygfyixueyxwb5xws3
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D07BA8000F
X-HE-Tag: 1790277098-620872
X-HE-Meta: U2FsdGVkX1/r3hydjazWj4vAB+bmAMNTXIiT36uCgbqLvcD4xzmbhEmz464ku8NQJDuMiJPgyRznmvG15ff/ap9/9yPnLpW8a87xKVd7B+7dT3LjIhOMu7H9s0gYOome7FHSj6r2vdrLGGYEX+n+Xlfew+WMnJL+qgjgKI1LhPVSmcMkglFRceRZXGHI3rgi9thV8yOX4MzgC2bceMHE7swZxP1oIZBDjsFgZldlmqNTENu2aifY7A+mCR3fK7RKV+V4ufi18pjP0lxPtVad7tr8hDUajXFO+Tli+sOrDC7/G3PTyvDQrgPGU47Dmvw9+XZjTAljlLEeJaPqlt0gbzecxzUV44mOmQibZN8yKbocnZAPyh9S+/uEkQEKE0z9EbpMl8tpgYuyKwBKtTR3kOnlilCHI++h9IzJ7hDJA1+KXUeJ8WBWLnrfnJtzENlzUz3L3K/jSUsf9AfOT7qGjGKfSYu2dahOALrb36EirBlAmeo2ssnjEcTvma1OlQuvEPv5ziZS2TolJtc5zAjaUgAGep8HVADSJc9ijivisLCPs59hkXsJcTFemfvE7zUqD+lA6yoa8DCmcicZYTrC8ozftjaJOKNy/V8pO4ydFzkd6g5hsgHHK4GZumTqgx4xzFwMcH+pfnHZrJpq6n52SztncgA7pXkZ7K/oH1N1UlLz1xTiXiejbldOpT4LODukq215BV7ScRfJL+oHDYcfK7I3daWKnHCux3W8QBXf8HlsDUkMyVnyUNjsssvDCol4AC0QX3eVNqjtQST6OlpwmCMGi+b2TBBFGag8ZIT+o73WQYq3rU9T6Z+owpcvahox/cflwL7dwZC7Y4JyhAqhnp9pT4rb8Oxs+RFCtVnlvO4YDQZZtc/6jQTt4aVByMXtv6T7Jww21ls1Pzqi9XtNdxNSTOEa26w5c7u+HsTSCtg+lJLG51a9nKj26TqUvooAmqZNpn3UJFmwRAh0Nks
 l+LvgCv3
 7HLqrr+Z5eSAoAqOLJg5jL2pHTvVX1L78LSArmXgFg67AHN0arSs3p/WBbaMXFILqkdJ0YV3mdEAPIoZxg3Iu4ezs+aG1u1xSr+esL3TOCuItz4KWTna2Q//iqEdQPxOUPTRcuvOW66IZpg5cUb+3VLa+0LIYwk3W2RdUPsmMqx+OLKXrfRgXJaUtLgvY39L/rC6dTJwvxF+P7hvyC8cBMZLIvZirilrotzNpwxMG2/sPouP/H7snEoBIYOh7HAtpKQ+tVIR4ldgeASUJnEc+rv579+ER/G+DwFmQvlnYVFkPyJVxzLw0g4rhrGsZzpbzu9VSaICMckBwelHsg1dEdXVonBGVoMcZJ31a
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

This causes split_huge_page_test to fail because the check_pmd_huge()
helpers incorrectly require the address returned by memalign() to
match the VMA start address reported in /proc/self/smaps.

Instead of relying on /proc/self/smaps, use /proc/self/pagemap and
/proc/kpageflags to detect huge-page mappings checking PAGE_IS_HUGE
and PAGE_IS_FILE accroding to type of huge page.

Since shmem pages are also file-backed, simply check whether the page
is file-backed.

Fixes: 642bc52aed9 ("selftests: vm: bring common functions to a new file")
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/vm_util.c | 78 ++++++++++++++++++++++--------------
 1 file changed, 49 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index a0ab78ceedb1..969d7202500c 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -351,24 +351,6 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
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
 static bool check_large_folios(void *addr, size_t len, int nr_hpages,
 		uint64_t hpage_size)
 {
@@ -410,20 +392,51 @@ static bool check_large_folios(void *addr, size_t len, int nr_hpages,
 	return ret;
 }
 
-bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
+enum check_huge_type {
+	CHECK_HUGE_ANON,
+	CHECK_HUGE_FILE,
+};
+
+static bool check_huge_type(uint64_t categories, enum check_huge_type type)
 {
-	uint64_t pmd_pagesize = read_pmd_pagesize();
+	const bool file = categories & PAGE_IS_FILE;
 
-	if (!pmd_pagesize)
-		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+	switch (type) {
+	case CHECK_HUGE_ANON:
+		return !file;
+	case CHECK_HUGE_FILE:
+		return file;
+	}
 
-	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
+	return false;
+}
 
-	return check_large_folios(addr, len, nr_hpages, hpage_size);
+static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
+		  uint64_t hpage_size, enum check_huge_type type)
+{
+	int pagemap_fd;
+	int nr_pmd_mappings = 0;
+	uint64_t categories;
+	char *start = addr;
+	char *end = start + len;
+
+	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_msg("open pagemap fail\n");
+
+	for (; start < end; start += hpage_size) {
+		categories = pagemap_scan_get_categories(pagemap_fd, start);
+		if (!(categories & PAGE_IS_HUGE))
+			continue;
+		if (check_huge_type(categories, type))
+			nr_pmd_mappings++;
+	}
+	close(pagemap_fd);
+
+	return nr_hpages == nr_pmd_mappings;
 }
 
-bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
+bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
 	uint64_t pmd_pagesize = read_pmd_pagesize();
 
@@ -431,12 +444,13 @@ bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 		ksft_exit_fail_msg("reading PMD pagesize failed\n");
 
 	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
+		return __check_pmd_huge(addr, len, nr_hpages, hpage_size,
+					CHECK_HUGE_ANON);
 
 	return check_large_folios(addr, len, nr_hpages, hpage_size);
 }
 
-bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
+bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
 	uint64_t pmd_pagesize = read_pmd_pagesize();
 
@@ -444,11 +458,17 @@ bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size
 		ksft_exit_fail_msg("reading PMD pagesize failed\n");
 
 	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
+		return __check_pmd_huge(addr, len, nr_hpages, hpage_size,
+					CHECK_HUGE_FILE);
 
 	return check_large_folios(addr, len, nr_hpages, hpage_size);
 }
 
+bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
+{
+	return check_huge_file(addr, len, nr_hpages, hpage_size);
+}
+
 int64_t allocate_transhuge(void *ptr, int pagemap_fd)
 {
 	uint64_t ent[2];

-- 
2.43.0


