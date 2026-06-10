Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79577CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 10:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 364C46B009D; Wed, 10 Jun 2026 06:29:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27A7A6B009F; Wed, 10 Jun 2026 06:29:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18F2E6B009E; Wed, 10 Jun 2026 06:29:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F017D6B009F
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 06:29:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C75D81C288B
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:29:44 +0000 (UTC)
X-FDA: 84863631888.21.4810700
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7A607C0007
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:29:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gq78nX6R;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781087383;
	b=NoGAqvjb4Fpi2jpVwx6+1Gaf0rbP72rZBJaOic8KYKrLL7wPl+jEErfJX0H0OvrOeEeC+C
	UEy/0vyPvc0C/Th0FgRGWLLtf+qYbRqrwYR1fpzkjf8LjlCLA5NdinbkTm5uW3K3cnhjQa
	iKvBfu/G1pIGzOrL2TBI/tAab90KneI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gq78nX6R;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781087383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uH2kHOlqaXzUSXC626PClBD0HY2gB+0EeBu4k4Dn1Fs=;
	b=MQqKZTkkctNX8FWujEUJ3zYIeVw5EO6TJmeGPb5L0SDRCAfOxeHsY5hpALlWC4rmg0Omiz
	CR5T1BbGbuTiNNmhiWjb+xDrjccNiApNLoHSrbKf6urRdrlzsy2einlVPIX+dSY4KRA+nq
	ozBn1hjexGCGYT3wRMFPolq+n9LgnWY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781087379; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=uH2kHOlqaXzUSXC626PClBD0HY2gB+0EeBu4k4Dn1Fs=;
	b=gq78nX6RJyQP8BsK5Fq7IBPu42DAF2CV7nX3/+tzNLhlmtAVuSswZWT7PKLYW0HCbPYtUpq4nWBtzfIN3gwxO+9Cp/y/LHy9hvZnQnylrj87bzoV/vSJqhjt6RwI0x8Ii3qzQZTpSxiDN+OAi/g93dK73q76Ax629anIvguhQgo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X4aHmjA_1781087376;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4aHmjA_1781087376 cluster:ay36)
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
Subject: [RFC PATCH v2 09/11] selftests: mm: move gather_after_split_folio_orders() into vm_util.c file
Date: Wed, 10 Jun 2026 18:29:17 +0800
Message-ID: <b415d4e8f3456f49817e94a182d1e5ed832de16e.1781083630.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
References: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7A607C0007
X-Stat-Signature: uzg4q3ofecykqwj86gjkemx8xrxkspj5
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781087382-47191
X-HE-Meta: U2FsdGVkX1+qa99YXd4Pxc/mUlH0Jj9YaNwE6/VYu/6K0/tsBUdQ0zjRn/Z5PzvfgrxiitAobm/i0TzPTimD24V49wUcGS8Y9U350p6RH02+cXAls4lTL/unyHYkLRR+zcMu7rSl9K7mhbc4vWdrdM0T19nLwGvDrd0+M/JJNtg3W+nQ9SeSfZxWGB5/mTu3eM+FNX/ymzPlvaNhE05ZE+uGBxOoubOzE9HGiSL0iL6vqy7I5+w/3RjWPAlaoeaspA1SdNoXcjGRK5Lv0DhoGvG+ckdeApM6AnA45PWWGAtMZAIZEsEQo7iteZO+lvbzHEDJAxrBJ+FJ/GYKyLKDFIPAD7V9P7JvrZvW3fAxLvitwh3m7K1ps/DzgL4csTZYqyn7La2XqqyvUUHxnu3wB3mSECeDR/3jHSK0RilO3XsgvLRmdsc+Voop7+7an5P1Tlj/P/jQcuFWO+Oiw1ZViTrQ5JMUDjFNMynJs4JjqPanRgTMivMzLOtLt2NHAFsC1TlHJBHL+2HRcySJYLulFTHM73jgUOL8zabZWTxdKRi1UJg+L/x6te2glM9bt7RVX0qST1Lx5Ez/NWZTxopKHNIfhESqQiYrnDuBn5tt+/+rKmZx6oRMuRhpnFqcQvZ69m/0BdUMNBZDkaUkDwRKbjbOesmlkEvVymPJft7h33zBLrWUk9FFugAqv1usQD/RG30f/XjXR61yBnii1Rv+Jtgo0xgzUPWT9uGtv9Z9CyZPG+PeDixq9tvYwhDJTsSgHtFFh9YH2Fe611Bxceb9YPUh3j1JqqYk0xdLEvUmegPoCk+O5xhwNxLBFlC7ApLfMR7ITxeQf8SyO8t2Rc26IJk8Aa8aISudP71uufyThtBIfqyM794QniN8IH91eIop9scI1Hcw5942Qz0H5/yjyHueca+bYsjPYGrjG3U1Wnh5gJEXKujSI8RdPR+7uZdl+jMMDzH38k+r+TQZqnm
 qmvm6X05
 RrqvgQqAlAZERKLUUdNA+NaVB/1yHqABk94rgMKkF35ESB3ncviZsZYBzguaTy5nJqpkJaY8xIfkjH8DpeDHhIcKpWTQrV5Q3aLuo/BeGp5XK2nB02Juc2PmcQWvHyxDzH85Hy7Tufcroo1iWhFmLLqXKU9P39r7WYwY6tlubBwxa+D8wrmikD3JeB5voprachXBW6PWrhcr/Im9Wyh1ITbPOKecodTz3WB/kmECGDFmM3zo7cgqOZP3GCTdISMKGgC9vUTZv/32YzPOPxl8732vhq3bI6LkWJK4jCX6bN1MFgi8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move gather_after_split_folio_orders() to vm_util.c as a helper function
in preparation for implementing checks for mTHP collapse. While we are
at it, rename this function to indicate that it is not only used for
large folio splits.

No functional changes.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 .../selftests/mm/split_huge_page_test.c       | 125 +-----------------
 tools/testing/selftests/mm/vm_util.c          | 123 +++++++++++++++++
 tools/testing/selftests/mm/vm_util.h          |   2 +
 3 files changed, 126 insertions(+), 124 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 4cc70873a674..86a603692826 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -104,129 +104,6 @@ static bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 	return false;
 }
 
-static int vaddr_pageflags_get(char *vaddr, int pagemap_fd, int kpageflags_fd,
-		uint64_t *flags)
-{
-	unsigned long pfn;
-
-	pfn = pagemap_get_pfn(pagemap_fd, vaddr);
-
-	/* non-present PFN */
-	if (pfn == -1UL)
-		return 1;
-
-	if (pageflags_get(pfn, kpageflags_fd, flags))
-		return -1;
-
-	return 0;
-}
-
-/*
- * gather_after_split_folio_orders - scan through [vaddr_start, len) and record
- * folio orders
- *
- * @vaddr_start: start vaddr
- * @len: range length
- * @pagemap_fd: file descriptor to /proc/<pid>/pagemap
- * @kpageflags_fd: file descriptor to /proc/kpageflags
- * @orders: output folio order array
- * @nr_orders: folio order array size
- *
- * gather_after_split_folio_orders() scan through [vaddr_start, len) and check
- * all folios within the range and record their orders. All order-0 pages will
- * be recorded. Non-present vaddr is skipped.
- *
- * NOTE: the function is used to check folio orders after a split is performed,
- * so it assumes [vaddr_start, len) fully maps to after-split folios within that
- * range.
- *
- * Return: 0 - no error, -1 - unhandled cases
- */
-static int gather_after_split_folio_orders(char *vaddr_start, size_t len,
-		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders)
-{
-	uint64_t page_flags = 0;
-	int cur_order = -1;
-	char *vaddr;
-
-	if (pagemap_fd == -1 || kpageflags_fd == -1)
-		return -1;
-	if (!orders)
-		return -1;
-	if (nr_orders <= 0)
-		return -1;
-
-	for (vaddr = vaddr_start; vaddr < vaddr_start + len;) {
-		char *next_folio_vaddr;
-		int status;
-
-		status = vaddr_pageflags_get(vaddr, pagemap_fd, kpageflags_fd,
-					&page_flags);
-		if (status < 0)
-			return -1;
-
-		/* skip non present vaddr */
-		if (status == 1) {
-			vaddr += psize();
-			continue;
-		}
-
-		/* all order-0 pages with possible false postive (non folio) */
-		if (!(page_flags & (KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))) {
-			orders[0]++;
-			vaddr += psize();
-			continue;
-		}
-
-		/* skip non thp compound pages */
-		if (!(page_flags & KPF_THP)) {
-			vaddr += psize();
-			continue;
-		}
-
-		/* vpn points to part of a THP at this point */
-		if (page_flags & KPF_COMPOUND_HEAD)
-			cur_order = 1;
-		else {
-			vaddr += psize();
-			continue;
-		}
-
-		next_folio_vaddr = vaddr + (1UL << (cur_order + pshift()));
-
-		if (next_folio_vaddr >= vaddr_start + len)
-			break;
-
-		while ((status = vaddr_pageflags_get(next_folio_vaddr,
-						     pagemap_fd, kpageflags_fd,
-						     &page_flags)) >= 0) {
-			/*
-			 * non present vaddr, next compound head page, or
-			 * order-0 page
-			 */
-			if (status == 1 ||
-			    (page_flags & KPF_COMPOUND_HEAD) ||
-			    !(page_flags & (KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))) {
-				if (cur_order < nr_orders) {
-					orders[cur_order]++;
-					cur_order = -1;
-					vaddr = next_folio_vaddr;
-				}
-				break;
-			}
-
-			cur_order++;
-			next_folio_vaddr = vaddr + (1UL << (cur_order + pshift()));
-		}
-
-		if (status < 0)
-			return status;
-	}
-	if (cur_order > 0 && cur_order < nr_orders)
-		orders[cur_order]++;
-	return 0;
-}
-
 static int check_after_split_folio_orders(char *vaddr_start, size_t len,
 		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders)
 {
@@ -240,7 +117,7 @@ static int check_after_split_folio_orders(char *vaddr_start, size_t len,
 		ksft_exit_fail_msg("Cannot allocate memory for vaddr_orders");
 
 	memset(vaddr_orders, 0, sizeof(int) * nr_orders);
-	status = gather_after_split_folio_orders(vaddr_start, len, pagemap_fd,
+	status = gather_folio_orders(vaddr_start, len, pagemap_fd,
 				     kpageflags_fd, vaddr_orders, nr_orders);
 	if (status)
 		ksft_exit_fail_msg("gather folio info failed\n");
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index b43adfa92116..b08bf655ab23 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -194,6 +194,129 @@ unsigned long rss_anon(void)
 	return rss_anon;
 }
 
+static int vaddr_pageflags_get(char *vaddr, int pagemap_fd, int kpageflags_fd,
+		uint64_t *flags)
+{
+	unsigned long pfn;
+
+	pfn = pagemap_get_pfn(pagemap_fd, vaddr);
+
+	/* non-present PFN */
+	if (pfn == -1UL)
+		return 1;
+
+	if (pageflags_get(pfn, kpageflags_fd, flags))
+		return -1;
+
+	return 0;
+}
+
+/*
+ * gather_folio_orders - scan through [vaddr_start, len) and record
+ * folio orders
+ *
+ * @vaddr_start: start vaddr
+ * @len: range length
+ * @pagemap_fd: file descriptor to /proc/<pid>/pagemap
+ * @kpageflags_fd: file descriptor to /proc/kpageflags
+ * @orders: output folio order array
+ * @nr_orders: folio order array size
+ *
+ * gather_after_split_folio_orders() scan through [vaddr_start, len) and check
+ * all folios within the range and record their orders. All order-0 pages will
+ * be recorded. Non-present vaddr is skipped.
+ *
+ * NOTE: the function is used to check folio orders after a split is performed,
+ * so it assumes [vaddr_start, len) fully maps to after-split folios within that
+ * range.
+ *
+ * Return: 0 - no error, -1 - unhandled cases
+ */
+int gather_folio_orders(char *vaddr_start, size_t len,
+		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders)
+{
+	uint64_t page_flags = 0;
+	int cur_order = -1;
+	char *vaddr;
+
+	if (pagemap_fd == -1 || kpageflags_fd == -1)
+		return -1;
+	if (!orders)
+		return -1;
+	if (nr_orders <= 0)
+		return -1;
+
+	for (vaddr = vaddr_start; vaddr < vaddr_start + len;) {
+		char *next_folio_vaddr;
+		int status;
+
+		status = vaddr_pageflags_get(vaddr, pagemap_fd, kpageflags_fd,
+				&page_flags);
+		if (status < 0)
+			return -1;
+
+		/* skip non present vaddr */
+		if (status == 1) {
+			vaddr += psize();
+			continue;
+		}
+
+		/* all order-0 pages with possible false postive (non folio) */
+		if (!(page_flags & (KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))) {
+			orders[0]++;
+			vaddr += psize();
+			continue;
+		}
+
+		/* skip non thp compound pages */
+		if (!(page_flags & KPF_THP)) {
+			vaddr += psize();
+			continue;
+		}
+
+		/* vpn points to part of a THP at this point */
+		if (page_flags & KPF_COMPOUND_HEAD)
+			cur_order = 1;
+		else {
+			vaddr += psize();
+			continue;
+		}
+
+		next_folio_vaddr = vaddr + (1UL << (cur_order + pshift()));
+
+		if (next_folio_vaddr >= vaddr_start + len)
+			break;
+
+		while ((status = vaddr_pageflags_get(next_folio_vaddr,
+						     pagemap_fd, kpageflags_fd,
+						     &page_flags)) >= 0) {
+			/*
+			 * non present vaddr, next compound head page, or
+			 * order-0 page
+			 */
+			if (status == 1 ||
+			    (page_flags & KPF_COMPOUND_HEAD) ||
+			    !(page_flags & (KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))) {
+				if (cur_order < nr_orders) {
+					orders[cur_order]++;
+					cur_order = -1;
+					vaddr = next_folio_vaddr;
+				}
+				break;
+			}
+
+			cur_order++;
+			next_folio_vaddr = vaddr + (1UL << (cur_order + pshift()));
+		}
+
+		if (status < 0)
+			return status;
+	}
+	if (cur_order > 0 && cur_order < nr_orders)
+		orders[cur_order]++;
+	return 0;
+}
+
 char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
 {
 	int ret;
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 40c6d8c4f1b8..19d8568a8553 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -95,6 +95,8 @@ bool check_huge_file(void *addr, unsigned long size, int nr_hpages, uint64_t hpa
 bool check_huge_shmem(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size);
 int64_t allocate_transhuge(void *ptr, int pagemap_fd);
 int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
+int gather_folio_orders(char *vaddr_start, size_t len,
+		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders);
 
 int uffd_register(int uffd, void *addr, uint64_t len,
 		  bool miss, bool wp, bool minor);
-- 
2.47.3


