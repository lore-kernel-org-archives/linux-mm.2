Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02C40CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 10:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E87986B009B; Wed, 10 Jun 2026 06:29:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E11096B0099; Wed, 10 Jun 2026 06:29:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFF0F6B009E; Wed, 10 Jun 2026 06:29:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B70876B0099
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 06:29:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7359712090F
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:29:44 +0000 (UTC)
X-FDA: 84863631888.30.FE89A92
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id EECD640002
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:29:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TDMe8O6G;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781087382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bh4A8aWubwzVF623+x5XXbydK4sCvs2okQ9F54Wtcac=;
	b=BCkKyjGzEfB/vvqff4m0PdzQqBKY5EEcM5wSEuBc6b+mjFnna8NPl8ROh6JwNPsD+meiMB
	hyrvXey8ivEyPboC6b7DkgwnS49/XAM+E1JsAD9hpGQEabA/QINAKBN8xnpurOtf9sCElA
	qceiwt2j07U4DwnE4E79UH/7xe33iIE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TDMe8O6G;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781087382;
	b=0qdi0ZNKvw44mMpr9Eoc046N9mbxUSKA4DzfIu4bvvVdSqQklwwCEtw/r99y0B4mN/F5ym
	Y0/wkG4Yjnln6/3DegFSy+FUFHht5FzV4YqmWIjW6TqF4NCmKLIOtgl4Vj7EWN8He+Lh+u
	S+erC2VtUdiliW2sV63ihwreBlo/YyI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781087379; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=bh4A8aWubwzVF623+x5XXbydK4sCvs2okQ9F54Wtcac=;
	b=TDMe8O6G1oe6F8WV1Xaed0cxTwbxdHF/lrD8SBejZXJgmQ4Gn7JsGziPJuLpbEaxR+tNBGfbewL0YGxa29nNt+sSVTlpFuRoAPHEPYAKN40jiPlXxOEHGD93c0NbZ6GGGzqkcjMuT+ryxjSGtFTFaoJUrUJJkBbTOfRCpm3nHUU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R651e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X4aI8Xd_1781087377;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4aI8Xd_1781087377 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 10 Jun 2026 18:29:37 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com
Cc: willy@infradead.org,
	ziy@nvidia.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 10/11] selftests: mm: implement the mTHP-sized hugepage check helpers
Date: Wed, 10 Jun 2026 18:29:18 +0800
Message-ID: <6f79e2194d5d4c5179fa954ea4968e8a76e931c2.1781083630.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
References: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: rfgtppqiwo953diiuu14emj87idgzson
X-Rspamd-Queue-Id: EECD640002
X-HE-Tag: 1781087381-590174
X-HE-Meta: U2FsdGVkX1/kZ1Nw+78HEeO6DkiDlPv+tG77B+yvSnCL50Ou5iRBWKGFC1LBOy5grsw8thWQcWiM3ehY9IH1Oi+i8tbYR725h2ch+HtUOwtebYHijUbRqCBF5Ms0WrB9W3X7LlbudbeC+P9GRA1HeLOEaa3/eZMtqUOEXK1D85fWXyMpOK82woKZgL5ZFxzRY3Vf0f3dCfGERhNAhYXlnlJgSznv2TeaYac2Hefuz2+BR95PiVL9ITbCkQejmT7b07iHKQ/uPletuyR6sjTOyYXdGToxz416egMnktbZtTtuer4MQmVxWqcANTriphgDhHDw5Nkmi7S+VE7oeigY1+F1gCp4BsAaElpwbRSzcjEc6fgKeGsqjg7jUUvFMiqbxtKRwilQ6CJbPDoFHQJjsqR0DkDQ4O02ohOZDBIYIldHXsGcjak9O4yndgxJFtOR1pZb/Hz/t3jgl6A/AEEgCOUcI1keWs2M6iu4Me9fVLf5wHV0M+6Zp8A3wrX2Vcke4GwdLJnF5v7opIsh0UF1ZXWtUmNu5y66SaSgARR4FwtSDRnXaxQolzmkafkIPZLDtG/inlVkNyF2P3K+3JzFw97T90DtX6xVn43dpPb6VH5qVWeVbigWV9yLodXiCXL9KymGDmmHEzwREBCJbKtfM8Y2amvjMxdJsDaLjnliLcVdk1uNs0Ure6MhFmVgagEoMTbd5HfCoU7L89vugkLVi3Wfw+f7l4cX3W6PQS+KPHOFc1rrv5YlwA1rxihlhQeWwdX/0S2bsp6jVDu9tTchYELCcV1i/NuGjqwV7ml6VOwsasGOGAOY9qgX2dysFRW4MDCf0XWz0Mn4Mfc8tNbQJ7jaXUSm2v7svsdEaFAsrj2GiwpEn/jx6wLbhejvN4rRtBFZC0f84haIlg7O0jRGt29GuRpZioi3WNRiPfszIe27Nb2dvCmc/USXg0T+iDpy7QpRoX4CNb98x3ufmHV
 1Gks2nNl
 MfHbcFv+Rr13t6TZfNxwxyGnL7+tURMMki68aKC+5raRnlfsqUhO/ZY7gIJdjHG/6XpCRHX6KFq74tT9lIcWcpflmF8RFByT4cUOtisgQXysBoBzon0mOcJq/h1oiM2BhfNEvHq+KPNX4HPKfcZNfn/DM6HRVPTl9ZDwTA+A3c6UI+tEFhbLE4BJ8dgcyJVcr5Qo+rX9j/khPbAh1yddXv36rxpnn5aIUVeMM3FMrF5A9sppmSWFGbpYVpjbLDSdrSFRh
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
index b08bf655ab23..6d464d49f164 100644
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
@@ -352,7 +356,7 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
 	return entry;
 }
 
-bool __check_huge(void *addr, char *pattern, int nr_hpages,
+static bool __check_pmd_huge(void *addr, char *pattern, int nr_hpages,
 		  uint64_t hpage_size)
 {
 	char buffer[MAX_LINE_LENGTH];
@@ -370,19 +374,62 @@ bool __check_huge(void *addr, char *pattern, int nr_hpages,
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


