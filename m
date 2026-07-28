Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20AD3C54F4D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 08:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F8086B0088; Tue, 28 Jul 2026 04:13:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 882306B008A; Tue, 28 Jul 2026 04:13:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 722606B008C; Tue, 28 Jul 2026 04:13:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F13B6B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:13:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 783BC402E8
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:13:51 +0000 (UTC)
X-FDA: 85037471862.19.FFC108F
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1FB8520005
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:13:48 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dxzEZFiu;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785226430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PB3rmpgw9H0XxiAUvpBD648Jdd5NiwEYnJ6cr6ny1fE=;
	b=2zbZChMBGGif8GTgIjtNTZfRSBe1/27VNy7m6t4aXuCTn42sAiCQ6kzPSNaOmg29fPVZTi
	Lxw76I+JX9YOGlxHe7KOzm4CoWJMkcXFLOXRQxTDAfsMI9Uz/qB8Uwhw243lvTNPcaLzFR
	SQTBnyZnPjt1O494VCoeLfpLYWZtRpA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dxzEZFiu;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785226430;
	b=JhB7eUeIYjZ0CIEfJQbm6qriE99aDT+i2dPcCjmM0wBV+xBjYds2c9LfIciOR5xzfr5IA9
	Wmt9nzRNSpbKRnUAMlW4Ud151C83tflTP81pfcvZvfN5/CI3RLsV8c/bUf07w27NMFrYZO
	4Qur6GJZQm7kc6iJj+4b6i9p6UPYRXQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785226425; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=PB3rmpgw9H0XxiAUvpBD648Jdd5NiwEYnJ6cr6ny1fE=;
	b=dxzEZFiudXWCAomtERQ+8xX0PFPb4EX0Qbn8e5quWnrG/YHbkn620KFL5EkLLSLEd8/xtzZ4RBA1Gshe/mba5CaoYbnw7a0VIC08XcjLrySjYBFscWYZRlDjVHI9NA47Xlv4pMCwLap2XToEAvZHsFslIkgqPj1bVtzTHtqEtk8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X8-E0Kj_1785226423;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8-E0Kj_1785226423 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 28 Jul 2026 16:13:43 +0800
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
Subject: [PATCH 2/4] selftests: mm: move gather_after_split_folio_orders() into vm_util.c file
Date: Tue, 28 Jul 2026 16:13:34 +0800
Message-ID: <cb0697506337320d438bce15cdd3c4caccb914a1.1785224928.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1785224928.git.baolin.wang@linux.alibaba.com>
References: <cover.1785224928.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1FB8520005
X-Stat-Signature: yoxzkk5eiiqxk3igguqg8wnwqw3y7wp3
X-HE-Tag: 1785226428-866351
X-HE-Meta: U2FsdGVkX18e3+SuhSA1PvIWaCT3KissrCrQ5ryoIluA8YysZc+x1B8E7QAFBbDhb9NGe1JH4SzF1L3PGKLzoGqscE+nVhmyeOFXC+w//luAD2SImYKtJLQDiW9WECHB2dlgFw3r2Q/CVlhB/4u5Ux/uy7m685CjtHoxq20rlnYqIwkPYwx+jqiN4FwXAkeBkVZZUM7JyDbVSo1iDlkqLiKq2JIYJrjFj7j2bqhc9r8OMqvh5NCl7T8R6gorhZ6p3hYNBbkUX+JBM2DO4kxDAUX5Xd0JWWd8PplnoHLBBPOH/4ZlGpItiURg4W1sNfgmIaI1kUwA10pCPB0EAktm/i6jlbGhEiJ5dmhyT7vAA66048QdS3jw7pC5LmTPbkyytyTem8v4K9L9mKm0o0sBTb1jHykHbhwEQooX9c8fCuHkxBIdwlgd0h3DUPx4a7BCsY+0QipgWdHurnusibXLzrX/cj5KM4+yKEAbpt01z7UsH+/A8rpJA6UY60FGV5n1/bmT0cDiBb9VDqCfA/IBgON6F/m/Ie3W72TdaTZQ3/rM+xRoa6038iTOZxpei2yuZkXHOvh3xltor1vyz22KlZ5UF74/MVUqHJY1DokqYPn3P8eaX2ruRK3zbDvhP2m5TvilSZmcMQe7Y0Di55zEAAL8En/hDR4NMR9Hn2SgIWT1r/GOtUTLKwZYiUH2AJKbHpr0a8ucFI6dOj72k9FKbUSRFQ+jgjtrHpsvcnUMnmmtfRoENGpo2vupK1pL606OxqIEsU+nGglnj3QfNpiwJ6U8T9eu5Y7T8M9Jw3B+Gm++VEno/w9+I59rVP/YukW8YQejbs0dHvGCkpzsBNXO6sghr30F73ASdtwNBPEBij5mXBVe4TYpJ/3PTE9yvtuzW/KRnJRHQaf/YwaIGhJsCtVS1awQD7GYe8t9jNboq6pYursX07PixE2TtnilKLjcqrahpqpAmy3S3mlKsfb
 YqSw+6Nm
 gBNTNkYMmEj+jo07l3RLuyfkHDWL8DQ434Joh8hHyIh1ozY7oxVEQmCf0nr7Q8AmjdjIV3xSGWjZKfOY1JhpHQwWjyeNDfuxAOcatOKdQu70zKFd1weWtMRw50aMErjPjQGCZL47DD1dW708zHeHfh1F5GFIa+aUroTsZ06TL5YnYD1AM35RiYNZ54PSI/+UfonXRiWBtc4mit6KNx5qtwIYtNCvJZJIGDeenhqit4+i44FAHbj6R/NMN4a8wzzdaUsn2PbnCmSENQd6c2epcQm1jBtmT1FZ0j+ld9tEJ7580LQM=
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
 tools/testing/selftests/mm/vm_util.c          | 119 +++++++++++++++++
 tools/testing/selftests/mm/vm_util.h          |   2 +
 3 files changed, 122 insertions(+), 124 deletions(-)

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
index d92c819f3717..09e5d5cabe21 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -194,6 +194,125 @@ unsigned long rss_anon(void)
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
+ * gather_folio_orders() scan through [vaddr_start, len) and check
+ * all folios within the range and record their orders. All order-0 pages will
+ * be recorded. Non-present vaddr is skipped.
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
index c7ae28dfda63..20af3e574cd8 100644
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


