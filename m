Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C819C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 07:30:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7B676B0098; Mon, 14 Sep 2026 03:30:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E09886B0099; Mon, 14 Sep 2026 03:30:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D20046B009B; Mon, 14 Sep 2026 03:30:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0AC6B0098
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:30:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C79EFA63FF
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:30:26 +0000 (UTC)
X-FDA: 85211544852.30.6C6CB86
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id E426E40004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:30:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=enKKDepr;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789371025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nk4tvrfxk8BOvI5A6IwO1O3FDxk4HEgJgZEknuqXP7M=;
	b=1ijUdXgWNoX+CNMvowHM9Wi0V3RNhr8D9hYBb+CPL7iNaOunkag2LP+ld72L9w0QLTiLxV
	f6X4eEYsggBcWNH/Sbl3dgzKMjuDF0PRQkQ7sTYB1Nc1Qpz5dlKcVFkou2VNMS62F7yExy
	wOCcdkhfPcN4J9MYZZXMIcQp+iwFY8g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=enKKDepr;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789371025;
	b=yyfs9/YATCdo3vzNAhlTIDQKJhU2Tbjn0HUtroskSQ+iTM4aZ60qfA2nvqunXf1UmIA+R7
	R1ekXDaRkDiC33CwYbH8+qcG6A4aXWgl0jsPF5bIIRr4QunUp83DrXVsetYvagLojEV3Ee
	qVW4v+oPOg8F1LRVu2GP98eaIfDN9vA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B4BA143D;
	Mon, 14 Sep 2026 00:30:20 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 155003F59E;
	Mon, 14 Sep 2026 00:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789371024; bh=psBRrjsPYCPSu2tJEDRB3gqzN+yAJ2X+dvQbQmhBcA8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=enKKDeprlnK7CvhjVpIQPtx6Sf4EDDszYb1y5zlzb0EKM44M1/+/o0EPdUsQknlZo
	 t5qOpwGirwAk/N2kHOTifnyZTs7xj1uQ3K8MMb6N3isWzse0aSsqIrknrI+yo7g/xE
	 ukQVmaiFSroC7KcdfL6yrZcGcaQdKvRAZ2tIBCgY=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 14 Sep 2026 08:30:11 +0100
Subject: [PATCH v6 2/3] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260914-fix_split-v6-2-16ed7123800b@arm.com>
References: <20260914-fix_split-v6-0-16ed7123800b@arm.com>
In-Reply-To: <20260914-fix_split-v6-0-16ed7123800b@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8293; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=psBRrjsPYCPSu2tJEDRB3gqzN+yAJ2X+dvQbQmhBcA8=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqp6KFvQ0pjSfmUCROiwZbCfsd+W2h1LsFCxAsp
 CFCJWyPuvSJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCaqeihQAKCRBt1cPRWsUx
 Mw01C/0T+NmhZYs82D7yU5QvwupWDcg8177MCf9NgqwnggUdNsLUOXawl7wKsWeLy4neZuu6H0K
 AbtJBezh2vYhHucyC5EfUFBUTILp1VNt/qxcz/1gR/1xy2gWaIu5eTrRX+vLJn7dR0v9gGh3pVj
 J+FuoRMeJwgK+nLv9XByZpL9fQE770VcuK5vckLLPYETF2+/gk8pS260Z3NtQt95ijYnmQaNu/t
 Ih9cqeCNfaQeh25oxCtEsMMsVub8yPDO8TKhrXj2ahDaKmcFsgLQImoEuepGP/by2OhiuAsmjZa
 1X+e1K8wPmN04wY95mLgGkHpcHzdVPxwBuQUAYW5zvdVpQU0QznVWmRV0UEHn9DLGkL0RbbD5Y4
 VPubEW+4R+pYez3BW3H4QxVWrAe6cYH7X7tqSvwZPaxPoSMcz49Q83vwll0EiSu5KryjXUbC/YZ
 YhyydOAxsloI8eIw2LLBp65gBoio9HmMK6zwctIEetNDmPALSakI7t3GfO4vKLGTY2NJo=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E426E40004
X-Stat-Signature: c39jq8x8idzg8e7f6j7htcdd1j5mnc7s
X-Rspam-User: 
X-HE-Tag: 1789371024-342203
X-HE-Meta: U2FsdGVkX199J805jGY/MQYkiNNB9xre61a0JVC/Jh1tQ8lxmKZd2ldEGvdX72gDjG7AbFg6T3n3DCDwskyb39v147HH/2B3yFbcCvIM4Z2Hb5Esq6E8qcdTYEHe2rBkVVH1H2wNlBzpjkE9EwvzHkLdz8f6qYS/M5nJuX3z4CTLLV7XcBLHwWLsZE5ONv0olbG/sc/6cQABjITx2H8eMWQrdTBDiND5T5beN4Djlj7SNW9W45QuWf5JRgwkFlaMDs+xkSZtgucuI5nRnm6/Cum6ihlG0pGd4LCvv20nmlu7MPDEJji97WuEJIw9tC3i1Y6HhPDIXH+Pegn/aQ6Roup1yYChyq2405v9/NVIcQZK9YYvBXom4EElv7tNGO1lrjvn3W4T2KjbXJMW7H7JAR3aMx0fOi1O9GGREmR+/ijfEwZtXDsru7iAcHK5Mce1ORX/+l4tlZJT4gbzdlzNsaSikUYIqeoYBRhhF/aPWZATohlm3CF6TnJt7cMBm3GFJy0L38WiSuLm2iAfxIF/y2YdhqdOEOrNWMVtukKE9GjwgUTopOlpMDNnj/RDcg+vggMfMXbvZgg8Ha2IUb0H3jQHMW4qjHQu2Vn07zaio4wJIE7McLo9QERpG0eXedicU2n9HciEGbQw+mV1YlskU1AdBp0yT8YjiblThdMIoZ20iGoEdLKXlcwVEc7NEcL7uSu4Ic/o5lBQs5c2pBoP3qtspzxSFs/CPNOE5cbkYaiDqMqt4JPUM8fdyQM7bYVHjizk6OfToGdHNhzw6ynUyOoDPpon0/dPBH6ci02aIV1ggqGMcqNHyaiWhvwwuqgX6qqqLkUcv+HBzCeJN0mnHUM8ygaM+lzPmzsxJmnKYgBCWTY0T/du3NOStqafrWKfU8gvmXhUtJonQ2HyTKR4/740d9GL29fr22g5mvVEW69f/r9z7LTbpdVEa4zkVbrlrl7xYO+xXeeCUxvPx+K
 fjxyPev8
 F1rpTjRNMS0KHoD9b/OBnXbFaowSp9aMOH1wN+Wu84ygx98tNokIjl5qcBwvuyDQas544oAnJG7tEKH9udfebT/feH443HJ67jhU6f0nroKvdz5Ly2Bnfm6WLJwvp342KgEDebLAhWOUB1rpD9mm4iNuLoPnAj0ivtvaAx9YT+4KPtJs68whRspRrTtrNR5ORyU2xZ21P44YPYA6NghPgt0adLphcwd0ZKd8pZ98uOUygZ8D1fDfrkjboTJUq9s5fOoq8jiL97pnoIGun9aVGt0tgWJrsODvbwQRzC0WtJSJdmLxrUVbyrT8BRZuLeQFtHy+4VSTf2Zt1ZEVHSXvAeaNOoIYneOvXSukuoNwLbjeLjTtlcTD0giybT6ecS4i2hy9BuUC6TTMqX+Y=
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
 tools/testing/selftests/mm/vm_util.c | 143 ++++++++++++++++++++++-------------
 tools/testing/selftests/mm/vm_util.h |   1 +
 2 files changed, 90 insertions(+), 54 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 4821a3563036..98f110098179 100644
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
@@ -405,48 +378,110 @@ static bool check_large_folios(void *addr, size_t len, int nr_hpages,
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
+		return file && swapbacked;
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


