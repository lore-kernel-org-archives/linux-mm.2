Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0938CC55838
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 03:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108306B00A6; Wed,  5 Aug 2026 23:34:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DF4B6B00A7; Wed,  5 Aug 2026 23:34:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F36EE6B00A9; Wed,  5 Aug 2026 23:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 960C46B00A6
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:34:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9567BA2292
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:34:40 +0000 (UTC)
X-FDA: 85069427520.22.26CE230
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3D5AB40004
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:34:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=moIM2jce;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785987278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6LrUd86Cka2Fg/6CzJjG2iZT3DCfqjLks/rpZbSOQ0w=;
	b=IjI1fUE7NtWcGscfpavWEoV2c6pIDXcs1ZG1z4oVc8RkTxIt5iFxS4qSBA01RsMnObx+SY
	UNexolRUPQELIFdov3I783UNtJTq9Ivox8MgeBX+CGWhjYepsmzXUgYGuPOHSSk6uuw2IA
	28Ll93lUg1A6rtC3Gss17wuZefSggCY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=moIM2jce;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785987278;
	b=zsgfCYsrd7YUrwK3Z78IacnJjP3FUq5cotU/OsAAEhvV7gLtaMypGJSpIepPifgo9WVhBC
	2IDyzUbWmMCphwxjau38UyeHhFGmCWnRLWybp3ZolRi9ejvpHAKj82aZF/FkVKUfmObqcp
	NSLrHGweWBRFHxe/SAAj3CuqFB9V+KM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785987275; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=6LrUd86Cka2Fg/6CzJjG2iZT3DCfqjLks/rpZbSOQ0w=;
	b=moIM2jcesurHPVKZ6FHsoPApRNl84ZhhAl6UtF9IdL2qnLk6nyABhFX3Fe7xJDqnkExu9foqw38rhSRpmO7JzC232eq98yBoC8G5Ez3IWLL0edLTPrYgXOFT15j8yqUIpVhkYFYfZlXueLwKU4yv2SSie3oEldPFxAPQJkI9nBM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X8SfgDs_1785987273;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8SfgDs_1785987273 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 06 Aug 2026 11:34:33 +0800
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
	kas@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] selftests: mm: implement the mTHP-sized hugepage check helpers
Date: Thu,  6 Aug 2026 11:34:14 +0800
Message-ID: <56b16691f605426b33b5cf47319233de6127a6b3.1785985999.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1785985999.git.baolin.wang@linux.alibaba.com>
References: <cover.1785985999.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3D5AB40004
X-Stat-Signature: a5b1uxqs71ynau5ae7wgob4qwr97ytmu
X-Rspam-User: 
X-HE-Tag: 1785987277-634967
X-HE-Meta: U2FsdGVkX1+GV+zrPfoN4b3F8sUNLQqLrqViJ0zlUr3gN/Bb9MhxhrCYguHwmGwwdbOxmuCWcu2tYInldmjiI6UpHydJTDFVxGIKOIOMv8j6Ibri/CXdRt2hxEEp5fpu8It/QT4gN7wBkgol39HT7vql4uHHBpRBNDBCafI3PMzYdqTQFhxX8ZjTsd/trCJCEY4w/6JygBIsCHbTteRJID4KA5DA8ubIj9zTPtIs3qKt56tctlp0UP1HzVE+XlWgtwDzP3szYODmS2xu+2wXGOZCgkaUh7MmbQepZeXEqQaOa0kKPae7rOv2gmStWFLavcApZqwQ0UQwHih+qY0SvZoBUdvmXouzTzH037/5ioE69M2Vp2Ted5RJyBW0lIopBVEBNJvI1WRH5OGYmpdRjSQIwOe+vls1OhTQc4BTOUpJfSFRIS+TfidM6gKM7rCHaNXKgCv5gmXoaLSMEfvMzKklg5xo4Bii5uaUw+24Upn3hxWoz8pFrdfgLoyMERKaaC0Wz0aj9cOM6A5FSNtC8w8M/oBeN4VvROXip34IiXVOTLTlwT2KnERqkquK7uYgPov+hDcA2AN1ib/6WUyA3Qi55UYd5bECKkqoZtRLstzu6/uhao1ZO62Bb1u2B4AWDIvkfuEl5Wk48HDW7T+cG8zfuyq9DKLtrLlDDVhpfxgtJEDvhYauI2A/wpMZCVW7pFfrGB8M4xFpHZiYfwbxE7rcfg4qpaPemusPc0/u16B7dwxVFdZsqooVmUL/MlEqDZkbkQK3OS9FyPQMJF7qmTVTpsfOyKr59Jtw9qbmkOhuE31KeZSbZiK9BXNk3Q1c6UftAI8LGCj5oZURyqObnEGOjJ8cebsyyhVvl+Xv9P6kgMe8o1DKH+tbmNoyFxz+xIpTXu5u7BHRh2hHHVH2V9MzRjhbu5q6+LAhljtsuL0Ge4NiVNVj6r6u5+PF6ISs/4aPUPz5DWTvJ0hbKVe
 ZReqMp9W
 SQyzaXTjKyU2E5jIAPmw9Ct1E3iYwwmNOg/JGHRcmY2qCno7a79wh82oj+kgXItIMnLYiOSZhktkJT6QDfFoUaknn0rPOMgq/q8IvIIvfylJ+O+G+FaRaNT898CnB1u4UxqSfEepmabeNQigyYk7kztevRWKuO/uoU/j2+aOZ51hdF5iU0u1kRWu7OD1DZ/whii4ZWmKr1kjT5CcgMoAcyzXZ4Hwixf8auaKJgvCX6D2HUiiHhWWsOD75wWp4mKRSQh9War6gC97TQlsga3nB6FDd8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement mTHP-sized hugepage checking helpers using gather_folio_orders().
Also rename the existing PMD-sized huge page check function to
__check_pmd_huge() for clarity.

Reviewed-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Tested-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 tools/testing/selftests/mm/vm_util.c | 76 ++++++++++++++++++++++++++--
 1 file changed, 72 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 5a427f494cd8..13b5cff7dfe3 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -15,6 +15,9 @@
 #define SMAP_FILE_PATH "/proc/self/smaps"
 #define STATUS_FILE_PATH "/proc/self/status"
 #define MAX_LINE_LENGTH 500
+#define PAGEMAP_PATH "/proc/self/pagemap"
+#define KPAGEFLAGS_PATH "/proc/kpageflags"
+#define MAX_NR_ORDERS 20
 
 unsigned int __page_size;
 unsigned int __page_shift;
@@ -348,7 +351,7 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
 	return entry;
 }
 
-bool __check_huge(void *addr, char *pattern, int nr_hpages,
+static bool __check_pmd_huge(void *addr, char *pattern, int nr_hpages,
 		  uint64_t hpage_size)
 {
 	char buffer[MAX_LINE_LENGTH];
@@ -366,19 +369,84 @@ bool __check_huge(void *addr, char *pattern, int nr_hpages,
 	return thp == (nr_hpages * (hpage_size >> 10));
 }
 
+static bool check_large_folios(void *addr, size_t len, int nr_hpages,
+		uint64_t hpage_size)
+{
+	int order = 0, pagesize = getpagesize();
+	unsigned int nr_pages = hpage_size / pagesize;
+	int orders[MAX_NR_ORDERS], status;
+	int pagemap_fd, kpageflags_fd;
+	bool ret = false;
+
+	if (!nr_pages)
+		ksft_exit_fail_msg("invalid hugepage size\n");
+
+	order = 31 - __builtin_clz(nr_pages);
+	if (!order || order >= MAX_NR_ORDERS)
+		ksft_exit_fail_msg("invalid order\n");
+
+	memset(orders, 0, sizeof(int) * MAX_NR_ORDERS);
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
+	status = gather_folio_orders(addr, len, pagemap_fd,
+			kpageflags_fd, orders, MAX_NR_ORDERS);
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
 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-	return __check_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
+	uint64_t pmd_pagesize = read_pmd_pagesize();
+
+	if (!pmd_pagesize)
+		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+
+	if (hpage_size == pmd_pagesize)
+		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
+
+	return check_large_folios(addr, len, nr_hpages, hpage_size);
 }
 
 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-	return __check_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
+	uint64_t pmd_pagesize = read_pmd_pagesize();
+
+	if (!pmd_pagesize)
+		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+
+	if (hpage_size == pmd_pagesize)
+		return __check_pmd_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
+
+	return check_large_folios(addr, len, nr_hpages, hpage_size);
 }
 
 bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-	return __check_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
+	uint64_t pmd_pagesize = read_pmd_pagesize();
+
+	if (!pmd_pagesize)
+		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+
+	if (hpage_size == pmd_pagesize)
+		return __check_pmd_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
+
+	return check_large_folios(addr, len, nr_hpages, hpage_size);
 }
 
 int64_t allocate_transhuge(void *ptr, int pagemap_fd)
-- 
2.47.3


