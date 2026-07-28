Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 605A6C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 08:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEC056B008A; Tue, 28 Jul 2026 04:13:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9CC26B008C; Tue, 28 Jul 2026 04:13:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD8F16B0093; Tue, 28 Jul 2026 04:13:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0A4F6B008A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:13:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DAFE080308
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:13:51 +0000 (UTC)
X-FDA: 85037471862.01.33F92C6
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0EA7A40002
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:13:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vT4ijt5K;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785226430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lqDFCl7DalCEy9x0Yw1QNkF+tSzwo+I6FMPaEYjO+Uc=;
	b=loZmo++SMfhIxU4l+luf+oGhO87YnRyeTvbZiGzPpcjn9CYKbWJIfeeasM87mEfLBSeLji
	zYS7/AGPKwqmXzPIfkb9T2rNCRt7ei6ddgOWr8/VriVDZ08P6/ve6nIJrBMCZuVTE1PAKs
	+GfeXp1HMqLE98UJJkEXHZUCSIbWzAY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vT4ijt5K;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785226430;
	b=htu6zOXcVoejtD9UtIh2l+X7zXu9JKFY6RkDPUZXVfqDGjNv4dqnraSW2qDxdU043ihhZW
	OL8pDZOzpEkkzktGtFGyaD3ncqRXI2e1FseNoABh6e99QIv1f2VzUhAhuIXxNX6I27FqJ+
	SH+7IDr9fUH+DlGf2VwwN9jQy+AH3vE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785226426; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=lqDFCl7DalCEy9x0Yw1QNkF+tSzwo+I6FMPaEYjO+Uc=;
	b=vT4ijt5KBNixJ967lMTAbOuSRicZQ8/d2ke4m+WmboMZlFSTLuHqRQ/3yxVo961u7lcQOzQTLT/iRFRhZpDn6ebMky7A4DYFL8V9mnJdoG/vDM6E80BkV+zaZm1nhZfNRiMxsdqlkPCiKzDel4pUbROOusIY7h0hFKrcp1XDHzQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X8-ElbU_1785226424;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8-ElbU_1785226424 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 28 Jul 2026 16:13:44 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] selftests: mm: implement the mTHP-sized hugepage check helpers
Date: Tue, 28 Jul 2026 16:13:35 +0800
Message-ID: <8fd04f8c2f11390bf00058f9cd3d98d73544c75f.1785224928.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1785224928.git.baolin.wang@linux.alibaba.com>
References: <cover.1785224928.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0EA7A40002
X-Rspam-User: 
X-Stat-Signature: zjqheordgey67p5uikme76i5zptiuj4e
X-HE-Tag: 1785226428-763265
X-HE-Meta: U2FsdGVkX19GwR+tZRaXGIQssu7UUzudAB2hHIOsoa6XJmTZLdLMQ88b9VZNWfBmsEJWErxbiHKx1dNHkEoeSpsI3MsOY1lu7U399Vk4sfaINypISjDpWxIGDPDk4RmDju60CYAeuCogk6N36U0qxq2w34ROGStQEW2PFP/Um/OHyyVgEp3EFeuxeUOE0EUSuF5Y7zI/YLak8pE8DXwUWdfPI3xnchj8DMzzk0juCJFaBiDfCuHM2MZfI877iB7qJxwIDMsmHUBOjWJL8QoFRD4mZSlIjJ3EL0wAqcxxYUKv1+fDQOdF+yTl4miM1BNbEqQwjRI6GeDBtS30brF15RFKpAaESYIViJ3dVIEUAKM6tONjmfH1G7eblldDYg/PzoiZ3xoJHjnrU4rFY+HfjS9EeGJrhly6DyeckG/m0MG7VZdBbU+8JtbQ7fNRHBapHgZsxUSmUncvIZzbCeZ2C8D5WSeORPFdMDDTSF0h3jaUvEr1z55+s9dY5OIkOTPpsC7FSNa+TE4JKNxH8RwMRc9F9pm0JTJH0hCVHY0Vy/1aCpGw3wPyOEjtV0JdDsI+pOXTYojWz6ti+pp28hm+9HIg/PIo2lAju7OJHlO5RdP6koE4PA6ZkxZy7viFMf+jRbla/yTd+sngIUypZVrre+r2Qeq0rBfbSOZtQ5L2eGvkleh63buGU+0eNYXNci3Z1ZjeahMAuLjL2acj7aE8VjEg2IFmgB/PzQgbMIYRZp15Dlraif0Bef5kj5YSwqj25FQtWUNnmEpQXpQ4PatCC9C9ao1Hqm6sZ9wn8+3eNd5/mN4EVR0IWUKz9rzlTMZGMlIuYSN/lPOW4FvumoB/dlsXmG02521KLlYFNPSAwwlKQ7jcLi83nXKeK0+40rNLyIRs5Xp0rC/MOY+lo25gayJppVPSN4YohuVY5p8M4se7xemeIxm+mIMrHhoMPTK7rvnRPOr0ytUT8+S4y7K
 5ya/MaDF
 NMdUk4ct3gGMhRKu+IbHT3dbk3D+6dsnA3v+yLPEeVGNIslvCwCYp2VzW9U0y+yfqaxfZCN1KIrXHHTGY+4ToH0DiXW211+YznZyUI8WPnXTbZK2n3i0k7Fcj10swJzV++mx+5Qr/2IvFMzKgNeSHnpvKqNxx+I6lWhRvq5+v2A1dH+lQxPDwVkeFuGlNGpQCsaed7r4HcjTVN2czWbZUQYsTWwaq2V9DzIeFNDrkFYTNemt3YNG1aHL8wQ659pg8fK5q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement mTHP-sized hugepage checking helpers using gather_folio_orders().
Also rename the existing PMD-sized huge page check function to
__check_pmd_huge() for clarity.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 tools/testing/selftests/mm/vm_util.c | 55 ++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 09e5d5cabe21..a4ffaa0ca6fa 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -15,6 +15,10 @@
 #define SMAP_FILE_PATH "/proc/self/smaps"
 #define STATUS_FILE_PATH "/proc/self/status"
 #define MAX_LINE_LENGTH 500
+#define PAGEMAP_PATH "/proc/self/pagemap"
+#define KPAGEFLAGS_PATH "/proc/kpageflags"
+#define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))
+#define NR_ORDERS 20
 
 unsigned int __page_size;
 unsigned int __page_shift;
@@ -348,7 +352,7 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
 	return entry;
 }
 
-bool __check_huge(void *addr, char *pattern, int nr_hpages,
+static bool __check_pmd_huge(void *addr, char *pattern, int nr_hpages,
 		  uint64_t hpage_size)
 {
 	char buffer[MAX_LINE_LENGTH];
@@ -366,19 +370,62 @@ bool __check_huge(void *addr, char *pattern, int nr_hpages,
 	return thp == (nr_hpages * (hpage_size >> 10));
 }
 
+static bool check_large_folios(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)
+{
+	int pagesize = getpagesize();
+	int order = GET_ORDER(hpage_size / pagesize);
+	int pagemap_fd, kpageflags_fd;
+	int orders[NR_ORDERS], status;
+	bool ret = false;
+
+	memset(orders, 0, sizeof(int) * NR_ORDERS);
+
+	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
+	if (pagemap_fd == -1)
+		ksft_exit_fail_msg("read pagemap fail\n");
+
+	kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
+	if (kpageflags_fd == -1) {
+		close(pagemap_fd);
+		ksft_exit_fail_msg("read kpageflags fail\n");
+	}
+
+	status = gather_folio_orders(addr, size, pagemap_fd,
+			kpageflags_fd, orders, NR_ORDERS);
+	if (status)
+		goto out;
+
+	if (orders[order] == nr_hpages)
+		ret = true;
+
+out:
+	close(pagemap_fd);
+	close(kpageflags_fd);
+	return ret;
+}
+
 bool check_huge_anon(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)
 {
-	return __check_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
+	if (hpage_size == read_pmd_pagesize())
+		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
+
+	return check_large_folios(addr, size, nr_hpages, hpage_size);
 }
 
 bool check_huge_file(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)
 {
-	return __check_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
+	if (hpage_size == read_pmd_pagesize())
+		return __check_pmd_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
+
+	return check_large_folios(addr, size, nr_hpages, hpage_size);
 }
 
 bool check_huge_shmem(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)
 {
-	return __check_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
+	if (hpage_size == read_pmd_pagesize())
+		return __check_pmd_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
+
+	return check_large_folios(addr, size, nr_hpages, hpage_size);
 }
 
 int64_t allocate_transhuge(void *ptr, int pagemap_fd)
-- 
2.47.3


