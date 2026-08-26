Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56DCEC61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 12:25:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 664F56B0098; Wed, 26 Aug 2026 08:25:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63C1C6B0099; Wed, 26 Aug 2026 08:25:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52B4A6B009B; Wed, 26 Aug 2026 08:25:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 290DD6B0098
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:25:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4B62F1A038D
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:25:14 +0000 (UTC)
X-FDA: 85143340548.07.334778C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 510001A000A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:25:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gLcxi1GC;
	spf=pass (imf19.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787747112;
	b=QtIGMJZxviACH2s1pGIcaDOrF1zlg5m7sts+HjA4m1as1WVMp1iD3KmlAoj1RFVhb90HfI
	e1ltjudfQ4l86BRwHrYiy6slipRzo1NbOKWwBPKJtWUOtnbcfG58c/ZhxWULu78TGAzpAy
	TbExrEm9geXXAaw2hNmR8R0LV38j7VY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gLcxi1GC;
	spf=pass (imf19.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787747112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZX2QvCpfLQmrYqwGrOUxWa9f+V+fnIhzTSYpAgP17jc=;
	b=q8+VBrhC3CqLp8QdkWZQT4ZCiUMULLmAaD90D3CG8/UmigSO9/u8qb/lJs+tLrL6X5IMB3
	B1f709D5ref4WzCGJCuMTIrZCPCy9TImesHsenPephBrDRAvFDwgW3qub0ajAfiCzAACiW
	U3GPzqPQzbCwtSNuVYfaY9BWNdpV86A=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 96DE41713;
	Wed, 26 Aug 2026 05:25:06 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 73DA93F7D8;
	Wed, 26 Aug 2026 05:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787747110; bh=j7yzn2+ip7gaDbogI2HF7uGqF+si9ui1mIt3+JN8ZOo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=gLcxi1GCoNWa/KSQheBTpWMJnIXEejun7+7KuWg4y2JktPJW5wDFYyP2OSk5yzsI2
	 geDvUhCW+qtcSlo21nDzy6QssLvr+yVHB0zozWBIeYtrir+W1zVTZUrXurz/1FN/fv
	 wS3PtMHvgpU3Y6BCLoc5N1mUxq9Z6AWw9/SZbjnY=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 26 Aug 2026 13:24:40 +0100
Subject: [PATCH v2 2/2] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260826-fix_split-v2-2-71153c7f579a@arm.com>
References: <20260826-fix_split-v2-0-71153c7f579a@arm.com>
In-Reply-To: <20260826-fix_split-v2-0-71153c7f579a@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7240; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=j7yzn2+ip7gaDbogI2HF7uGqF+si9ui1mIt3+JN8ZOo=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqjtscnI2PSSpeC1NV+a49cQWW7aq4gHufdTP8r
 IT22MsqHWeJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCao7bHAAKCRBt1cPRWsUx
 M3fwC/4wN69ja0RsRNlDZHSVZ1KLLaJerixhWSAn2QGJky3iQYr7Nmr/KfCO9EO2p+5BMPHtsNM
 5bFtLeY4VLCTTva5wuqXN55dxhzXvUptRLTdqRuYArp6hYS+1YfV5+Fk1PFWeGo0swETkD+NobW
 HiwGc7Xl6//VzPS37TkZmGcNs70QSGTz0RdyoNO3ieDMWSaBKY4IA4u7LqmHiIcCjtuzhceuL0V
 beVaDwYrJ+pHKOruVf9lAw9xrp0OBFeHSsZsPAeICLDPb3YF4ymk/Ymbn8sXCCOahTu+lO+yHIq
 NGzRKiKKdcn7lEOKIRxu0MXwysRSOIqrvKHpLQBFRN6XeduwqgfN5Q2004vVy2taCvqyLWlJvdh
 Q+pcnpcC0DsN18ah425OdQgNrLGQZuicKuHtbkN/vyA9S3Ek5IA4DR8kC3A1K86GNP5tYoqSKqR
 peOwxfk74qa27301wE0rSYMMtNFqErfapa3P6IrRbDE3ipRlB4wNA4KsBm83Vd0FwuZUg=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Stat-Signature: huomfnpnn4a8t11z4ywobx3cntnq7i11
X-Rspamd-Queue-Id: 510001A000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1787747112-951368
X-HE-Meta: U2FsdGVkX1/M4jeiUtToTD5Ok3TfOISTO+QyO/GKKQGyOPAtNQgK70vi+fjiP7XdnMIDsHRKa5DRSAU//hAtrdjp2ZK7jzxKY1v4JQfjhZcvwr85h1C+PICa0j+qpi9rtvGVcypVOWwPsmP/U7WhODJF4z2GW7YcA2g1ssOArkwj3z7vOwHmxoSgaI/CdId/62WHHMnOclbL4mK73WfBSvjoRWA88yrjFep27SAxM892GhoFncUkMJQuD0MMZLhLV9wIEVonkxLBlAakksyQ7ljAmlX77ppxXyoasWwHcpFF8YiY4rtRzAVNfyHownlFUVIS9ZPnXSvt6+KJgMGRzB5B2k7AO9Z/RVXg+NH98BUpsuhQGK090mGuQhWLdj6tr8dxyGXLZmP3m/6nv7yiDz97k1kGhOw4K0Ckx+bkEjujCm3JvZokQyTluYdm9u87Y2tYRfmqohJu2lLa3e1jo9YvQRYLHUBPQx6GBCM/zgeyVk2m9c1txN4M/3PAXWGkvO8c9zRn0uoWL58uAjZW0gHB21Oe8GRYuwtZwqUAOJ7ZSwc6ArCkTL+iKFQq9+neioA5MeEAqgG4qLrnXMw/NvYiTZo8WXe9LFaiW/l7dkhmWCQP146vy/Mhe8g5hBOBNcjmnHDJ+BNzSyryjAZ3pdn5sqPB/ZmkqYVqoZcPGKSxQJv/Ve/2Y+Y+/87Y+EiqfmDiKt7VnNy5LgcK/XfPYEu1UYbLZD9xkEf5ghOgsiegvbSYu56NK1XO5rT5va6mripFzNuAsxGF/a6TiyUh46KhXttl9xS8lYlys6XEr+8kc0zcwDj3ZzxPkW2X77tJvMToVJPVs1Hbq+p5llaGsnvIQO1OQc6dV5oG3g6OyIEs7LFWVbSlQQCNl07wGtSpYz47w/0OQ6f+80huvdUvo2ph/ZGDO2ri4csbT8JuBvScbmHI7XGatXko/I/lspuUS/ZUvR3kyJN+BxRKdn4
 Xp9o/bDG
 JIUZB8MuPxG5XeOqnb1q63bNP+6EnG5MHXMz+DtezYFWtIRus/U5H8xuSmC/DuyryyLdA4QFTHUFIy2gDGMhNxJN0EFCOOV7a11yS8uoolASFMcQt/LVwPhXawBV2oQUuLB9ASJXf3CoE15At1Fx3Igv2Uskbcge9eNNkimIL3vEGHAFEl3UpUG/+CuF+KCd9pw0OQ6trYnHd5j/1q18tGYoYmf6TGj0G1kT01pvDzUG/yMtUAw7aQLWnbOe2WMi8xtphpcqdlm+95wq9TphwWgR45EGzJKCZfpeiGAj0FpmGotnTJKlSoIF3M2pBykLJLv9b72p+pxetr9exmK46EXE0OzE9d368Mm99
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
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/vm_util.c | 130 ++++++++++++++++++++---------------
 tools/testing/selftests/mm/vm_util.h |   1 +
 2 files changed, 77 insertions(+), 54 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 4821a3563036..1d0959b3b9e8 100644
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
@@ -405,48 +378,97 @@ static bool check_large_folios(void *addr, size_t len, int nr_hpages,
 		ret = true;
 
 out:
-	close(pagemap_fd);
-	close(kpageflags_fd);
 	return ret;
 }
 
-bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
+enum check_huge_type {
+	CHECK_HUGE_ANON,
+	CHECK_HUGE_FILE,
+	CHECK_HUGE_SHMEM,
+};
+
+static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
+			     uint64_t hpage_size, enum check_huge_type type)
 {
-	uint64_t pmd_pagesize = read_pmd_pagesize();
+	int pagemap_fd, kpageflags_fd;
+	uint64_t pmd_pagesize, granule;
+	uint64_t categories, kpf;
+	unsigned long pfn;
+	bool check_large, huge_mapped;
+	char *start = addr;
+	char *end = start + len;
 
+	pmd_pagesize = read_pmd_pagesize();
 	if (!pmd_pagesize)
 		ksft_exit_fail_msg("reading PMD pagesize failed\n");
 
-	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
+	if (nr_hpages > 0) {
+		check_large = true;
+		granule = hpage_size;
+	} else {
+		check_large = false;
+		granule = psize();
+	}
 
-	return check_large_folios(addr, len, nr_hpages, hpage_size);
-}
+	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_msg("open pagemap fail\n");
 
-bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
-{
-	uint64_t pmd_pagesize = read_pmd_pagesize();
+	kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
+	if (kpageflags_fd < 0) {
+		close(pagemap_fd);
+		ksft_exit_fail_msg("open kpageflags fail\n");
+	}
 
-	if (!pmd_pagesize)
-		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+	if (check_large && !check_large_folios(pagemap_fd, kpageflags_fd,
+					       addr, len, nr_hpages, hpage_size))
+		goto out;
 
-	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
+	for (; start < end; start += granule) {
+		categories = pagemap_scan_get_categories(pagemap_fd, start);
+		pfn = pagemap_get_pfn(pagemap_fd, start);
+		if (pfn == -1UL) {
+			if (check_large)
+				goto out;
+			else
+				continue;
+		}
+		if (pageflags_get(pfn, kpageflags_fd, &kpf))
+			ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
+		huge_mapped = categories & PAGE_IS_HUGE;
+		if (check_large != huge_mapped) {
+			if (!check_large || granule == pmd_pagesize)
+				goto out;
+		}
+		if (kpf & KPF_COMPOUND_TAIL)
+			continue;
+		if (!!(categories & PAGE_IS_FILE) != (type != CHECK_HUGE_ANON))
+			goto out;
+		if (type == CHECK_HUGE_ANON)
+			continue;
+		if (!!(kpf & KPF_SWAPBACKED) != (type != CHECK_HUGE_FILE))
+			goto out;
+	}
 
-	return check_large_folios(addr, len, nr_hpages, hpage_size);
+out:
+	close(pagemap_fd);
+	close(kpageflags_fd);
+	return start >= end;
 }
 
-bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
+bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-	uint64_t pmd_pagesize = read_pmd_pagesize();
-
-	if (!pmd_pagesize)
-		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+	return __check_pmd_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_ANON);
+}
 
-	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
+bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
+{
+	return __check_pmd_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_FILE);
+}
 
-	return check_large_folios(addr, len, nr_hpages, hpage_size);
+bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
+{
+	return __check_pmd_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_SHMEM);
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


