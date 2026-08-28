Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB5B0C61DC6
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 08:11:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B5496B0095; Fri, 28 Aug 2026 04:11:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C076B0096; Fri, 28 Aug 2026 04:11:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77AED6B0098; Fri, 28 Aug 2026 04:11:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 527516B0095
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 04:11:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9ECF2C029D
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 08:11:51 +0000 (UTC)
X-FDA: 85149959622.28.FD9D3BD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 93A3980003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 08:11:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QKNXE3rS;
	spf=pass (imf30.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787904709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5phG3W+ao4orhb0hjpeoITLoy3BupCgxOnTtG9mdvdU=;
	b=GmovhDgvtBFHQT0D0zXMwSCqdEuvA11Yh6WNBALFCk+Fd6ctWIFM9zdAHdxmdIkYxwzlg3
	AnolznU5xZYAu6qtChK87CnyWWd78VDbNgxvLfIS61ZN+upLqnoBxqSu8d32Opoj9g7OsV
	5L9e5S1zX9iQvJ6yIh7TuqoK3KtX/c0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QKNXE3rS;
	spf=pass (imf30.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787904709;
	b=mvHWhJm8SfqQbIs+k8dXmDvU1Yy3S1EqE2d67vxfEIHBJu4NyAOp5tkgRN9mKeRDLn1w24
	2L4dMdmKxLJaVNWxSJMGDG/RPKmTghLEYuorYV/0+4LT6n7RtiLJ4zWlHuolK6C7XKELbf
	SGIAVwzt1H2xcMnLraqHTdpLb7nkb5I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E387D1691;
	Fri, 28 Aug 2026 01:11:44 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3DDBD3F85F;
	Fri, 28 Aug 2026 01:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787904708; bh=SSZ/dke2eJqfQi3JNnjQcCUtyxBe9Q8ye26urwOBivc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=QKNXE3rSlEJLWjgVn9jXYmfrGtwqgbLV9BDcA38DBoUbf4O/mWaAWUCxX8Aj0SdGc
	 DXNSLE0tQ0U77BshnvGgRqhXQnqABJeBkhul4ouBkDyz3L66aZOqlKt2/YNESj1QwZ
	 qED/p6Lk1GR+nwmJ01dMPLopS5m02kWBqlcwBiHM=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Fri, 28 Aug 2026 09:11:34 +0100
Subject: [PATCH v3 2/2] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260828-fix_split-v3-2-374022586a4b@arm.com>
References: <20260828-fix_split-v3-0-374022586a4b@arm.com>
In-Reply-To: <20260828-fix_split-v3-0-374022586a4b@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7740; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=SSZ/dke2eJqfQi3JNnjQcCUtyxBe9Q8ye26urwOBivc=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqkUK8H67Y8gy30FCcQx8m4fmdEselt1VQNJGTO
 oZ2eswZCdCJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapFCvAAKCRBt1cPRWsUx
 Mz2zDACjGmQpaW0+V1pmvHkE8DRj8W2cZg83EQgDjxm+EJXc+uB0as+VUb2fzEOpNYWVUymB787
 jgOkNW72mFoEBfc670zw/yXmdpXZ9HHnQyrcUyKNPqA04jYiFeBk5yBUzVTRzfAwcxhhQfsq1dK
 Gy0WLQ2RRR5S/xHBjGAwg2tnA/D3k41ZWXntMxUdOybOFC4ytG9HmZyzI+CxhZXbkP+QHmI/P6l
 AF2ef7WUuLGtNSY9dVjR4I6te/pHue0++BPWlyG8vf1tR/cEsTUS26ZP3isl2nM8yHROzWMVREk
 zPH2RzxL+O0x8N1miL9R5LehjLvWBRHqV3Fd7LpT+CDH8iuOzR7YEqkKCop+3ZP0CfTyEwvj/I4
 R1P0g6yPXUrRvJX3G9mWzdhn9PQEfLpkqyPSewBk0Li+W/mcpEhhs/GvzrM6qaD7dCYQGJcrOg7
 f6cZZmcDZTHi+dRODhfBPgpxverQQ8BOP3AIcw5CYX34NQvXUbRoC5/6ZQIdRXGg/adRk=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: 3gh6ctorrgbo7ch776ajyx88gbowff7t
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 93A3980003
X-Rspam-User: 
X-HE-Tag: 1787904709-658813
X-HE-Meta: U2FsdGVkX18Wd2jy1VkpBCUl/s3s4JWOi1/EI27L9hp8KXtK/UC0rmtf1JNsFqOtwpZbuc9TZ1rIddAuLp+yt6GrGryZ7Fdz+GejXsfNMQE5ISVVLXZfGa4WwxSfH5RuOTN5V7Hc/FaWToHpMCnFEhcBDdPUaTT69bkToSwUct2FdytMIK6vtg/uxhDiULc5YGd47+I9vZObBVqnqysQMJSHRoGIlXzotaVwbN5hjE1F6umJrDEbsmicHWiubjdGNbD2zyUSTjQJRguFZqE85qJMdJOdVVvoYccW+cjxews1CwSxsggGuPkkI1luhLKMIoVx7YJpaFOz/S5DevUdyf3X9NEUH1ZYKHMEwmz5v7ROm+3ywbzOTdlz/LSEKteCq7LQbQ4zGqnf2V+cE7XAuwuLzoLi3leUSef1Jm7m1IhPoDAGeG+DW5HLW4BiJXetdPKYS+RnuL85CYiXPByX1uCn7ACbW6nQFgbvdMV6RALwqR2aY+/kjnEoHb1Fe/jwjKvDTvhtymn8mX3HLwf5tTYkhcBVIYWLvP4zu2tzH6Jme7in69RDWZ0M41yZ0piSmfNVHTJYnGzfvXFnoOD/nLjZJXtw/LwD8xG6HIEBAqwRCwObYrltR3HegO3Kyx0eEgFCi9f735wsABpdPbjH1VT+yL3Qj0aZ6qrMWkQNMR1dQtU7PQCRI/qfgz+3rGpo8U03A5eJv8+9HTROoPdrnAvqN4cQrcEnr9eHsNxEyxpGr4O0qanIPP6FrMXbPgC3quvUd+W+2rQAgFfAROAV6GMLPH0BaKpoymF1IQtrX6Zx3fcb/+by6Iwgd4YNFsZQhir9+O+WeoODphRtGiyexnmu7DHG2S+ujvkM2KSkbKI/mzTcvwT6NECz4uX5UkuR7T2Vv5pheJ+MVS+O4F9PdQrX3rbHP6tuVSZ5O6B4w+bIi6GoAC5rDhmXTQKoF/MmechUaTlpXs2bLQmMEna
 LR36oUTG
 5ZJg+/3kQ7q9B0qEY+UGRdcfmVqgnDfOqxN4LterghU8UA1chVw6UbG0ZWboQ9wu0NCsk4Gpl+p5kS4LhoHlRyXoYlZNbrGPf+QJeF6lhgTv5appYiwUPTqArDgAgoU0g0ELI1bgIuTzeVv8P6cS6gQC/oNcf/Xlyc7HP3hq78mQWn5zYhG6pbkXwoh4hook6fM3h+YfyX2wBxwqULSqP8VqRu2dKmmuxWvBn9cQtjnWXILimYjrPefZ8yKs7HYHhF7Usd+2czcuW61/ZDMX2cnXqaT+LzUVxsGZi0heUiLTP9Gu2xxSztkeYcbavgE1ePySMJUupPX9tLsenJcMQJ+54sMrxXMvTGSCgBOeTRd2KF/97Fl8fZH/Wxw==
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
/proc/self/smaps to detect huge pages.

Reported-by: David Hildenbrand (Arm) <david@kernel.org>
Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/vm_util.c | 145 ++++++++++++++++++++++-------------
 tools/testing/selftests/mm/vm_util.h |   1 +
 2 files changed, 92 insertions(+), 54 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 4821a3563036..083b72d92b14 100644
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
+	bool file = categories & PAGE_IS_FILE;
+	bool swapbacked = kpageflags & KPF_SWAPBACKED;
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


