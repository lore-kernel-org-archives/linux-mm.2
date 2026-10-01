Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 889F3CA5FCE
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 21:18:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFAC46B0092; Thu,  1 Oct 2026 17:18:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD4D26B0093; Thu,  1 Oct 2026 17:18:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C97A66B0095; Thu,  1 Oct 2026 17:18:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 982B56B0092
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 17:18:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1173E40557
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:18:16 +0000 (UTC)
X-FDA: 85275320592.05.A3A1B9C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 36D89140003
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:18:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Auk2Sz0w;
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790889494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+TzoD8LpRLpQwd9Mk9OBiE8g0UyKf6NY/hHboB5VlnI=;
	b=vd1Y1PDQOkS/U315UqsaXJTfqY53aGH38uVFHLtjjLhJZIg58nfpgBARuN+BPGisSoy1Cm
	X38tnoqiWhY82ECQqYk5zJW3Oidm9ICSZ+A12S5vewjK0GZ9e+ZBkvWyGgqyaLYlFZWqjK
	LjKf9sUWTe4Y2Mo4U6Y4jMIKgPIkPYA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790889494;
	b=cugy99yUbWHm1Teh+zsPWDmzZdEjgVpZ02C9OYY3e4Pd54PyF9ZR2dQOTR97qOs133GgqJ
	vO37/ZQS/XLy+mLK6xJmXiA9RjeAWIpuq4xYdkbQ5lXsz3azMtVAx2+YFzDDz4MX6hQtIk
	XnpTKb+YktT5xZj/H+61JEUNY/UQPb4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Auk2Sz0w;
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA94816F8;
	Thu,  1 Oct 2026 14:18:09 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 32B523F86F;
	Thu,  1 Oct 2026 14:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790889493; bh=0FkiYTXFXeX4ri5wwdo8r1zDswEVykTKGJ/AokRyxDI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Auk2Sz0wlnW2YUzEY0seFkGbJtuNi1gVERWfk1nWrvIGwydkd0ze+4yC7No5n9Hrs
	 YcfmL9hJPAycP3USSkPccQsJgnPppfjoZm9ogF5zCfZgS8GluLWQW+1KG795zQxUf/
	 W++hd50w9IDH1vTSsjde/uqUjF+jVWV3s7aVCm18=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Thu, 01 Oct 2026 22:17:52 +0100
Subject: [PATCH v9 2/4] kselftest: mm: replace usage of /proc/self/smaps
 for __check_pmd_huge()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261001-fix_split-v9-2-0f4ba8bbdbdf@arm.com>
References: <20261001-fix_split-v9-0-0f4ba8bbdbdf@arm.com>
In-Reply-To: <20261001-fix_split-v9-0-0f4ba8bbdbdf@arm.com>
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
 linux-kernel@vger.kernel.org, Sarthak Sharma <sarthak.sharma@arm.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5409; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=0FkiYTXFXeX4ri5wwdo8r1zDswEVykTKGJ/AokRyxDI=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqvs4KSeP0+3vmIoY7ipzOig2DXg9K5T69uM/ce
 ct6vjHjeXmJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCar7OCgAKCRBt1cPRWsUx
 M+JSDACCs32nf3pXyJRxfH9fUKZQ/1LzPeB55JxBVFBp76w2DM2vT/dT+1ThPa11jqosHEDplOQ
 MCS73R5MY6W3PS4MlSJgGigd5WeOH2+JP9+Irq8E5lh4jwBicNIb8qMtSfvsxMKRIM/KVZfXDIW
 hCnpPtMfwt1CFySYkVsXZ6SNvun9hbpBJuEtreAAK+TQVMKUZveZMXtSyTC6542Rm8lls5EidLx
 F03Zh+sRXnnk8rJ+xCZh594Zm7WrXgzZnrRFKBpi5JARwnQQQxJvsSU1kk/eLh578xF0aWuNCp6
 4fGtlWE9YPBFEHBM+hNk1bZH4iBimqCKy7+PCxpNBKp8U91/QY1yE3noAkn2x+AwDTml08z4wcs
 ok1MWeX5zlnM+s4+fJh/xkLtBcLdEiCie/rpPCEdRW91dgmbQ5/gfE2Sf+jr42oNhz0+9BtYOwh
 ou2LXpKXyeW283K8m6aQ1FZU4rNLRossrMztqx2+XTQGz22DdrOwHaGAf0Kiopoda4APM=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Stat-Signature: 5cx75o44w4m1yzikibyropw5r8edb8zx
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 36D89140003
X-HE-Tag: 1790889494-689025
X-HE-Meta: U2FsdGVkX1+L6LtmndmYqaslfpjB12OcFKxzVskw/jDzZz6sDvxS9QMO5oqijFi6L7IWfwHBtxM+McpwfqHDvlBFwF+EpZBDmxyIhhODQ1n7qVGIQIkxdm0cieRdHRLMTDi2FMnIVidSmLPyx7+fis7Lhx4eIpU/Y92VaXFpnkaHIwp0rRwBFK6Dvm4e5uXTUTnfHCOZO09nxFDkuh/xO6Moma1WLOEJxfMqBqGzjS/uiDnfC/CW25mDI1cTqX1Afgr6VnsbyMCegBNMq6dXZGG+wcioBZyGbno056tKljLIjopBszHjZKf1ucr7aAdmvKnQTVbkCamCAOlEuytYm2BZQiTViMojKuYGgw8L9lIs844LF1Jr1Odw9+lcs7zlYEEc38EQTMUKasRL7bb+PUukCSqjnXhDmeHi4OnrS6jRQDD33en5tzghcPcgB8Z/RPbiuTdcYbAakn62w0ilTUeS5zWZTOLfmvakUOM52lGBiqZZTPtnqBRaJhqci5iP9AGq9HgT7G5ab9Lxzl8tcbBMoXaHhsLnMuul8Rlzz809rQpKJiEIM1Eq4169f4hjKLiZ4sFq8wJ+NLpUA0p3Am6OpjlEWxBweklXPVTEXJxB/14Fsq8vFaK/om8CyN1E5nueHUACutppCyhwkmyW0cqu1ca8m9144OM7tuJ6xCDElUWFiEcy6CvmqmBn1dEkY2IED3gMlExq8gvy6F8D468UwU5UzsAZHLkD510JZfXjcJKnER1JuzDb6XOegoB8xbIS6aZt2VbshtfkBYDYNCdUTSjo5tqUOa9MSZjVT/TthM3XDanQ29KAb1yIaHvFGdCU4yBe3tfiWh5i7ReVZBAEMpWRc8Xj+7GYZ1eCMr2s6C+qIq6FIPSqBmbrfaloVrjgCaiAvlJVUuBxmLxMUwLU1pYQ9TdeggTpjQNSw8s2rWu7+kbidYOKL5jb9usXijU8/SOpfFgV0r07vNv
 VMQQ4W/r
 oG8Qbc6/d8xY3RzFW2AET4nWku6J5YET7RudKbiMnp/X542ljRPyqvERtG6e3jqpf1AEdukBfCb+/AMXoC6YbPZowHGnVqPRUaSUjHuIG7//GPl5ky6uDL9bcSIpYcZeXbRdlazDhq1Rm9//hnnF2diVDFbodA7dz0ea7cKFW9ffWwSuhEU+deU2S1cG3hVPPCRZsaqwMUzNApSkDq777p3MdToA1+7OPiNLp2jiUulFheV+dWGT1rGWR8IJOWcZGlIruW2lKzl8wkXSJ7pEXiogQzq3Og3HIKDUltbWSvWzTyKZnHHUU5Dq+8PMchxJRxGuZ6AgnY2iAnlHSK816Oe8CmNQ38PD7gbr6LEVb6B2XaAKkQnWmtMTgIA==
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
and PAGE_IS_FILE according to type of huge page.

Since shmem pages are also file-backed, simply check whether the page
is file-backed.

Fixes: 642bc52aed9c ("selftests: vm: bring common functions to a new file")
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/vm_util.c | 78 ++++++++++++++++++++++--------------
 1 file changed, 49 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index a0ab78ceedb1..a3c3a2706c22 100644
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
+		ksft_exit_fail_perror("open pagemap");
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


