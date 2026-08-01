Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70949C54FCD
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 06:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB65B6B0092; Sat,  1 Aug 2026 02:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E60206B0093; Sat,  1 Aug 2026 02:27:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD9CF6B0095; Sat,  1 Aug 2026 02:27:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9106D6B0092
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 02:27:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 08AB4A0273
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 06:27:01 +0000 (UTC)
X-FDA: 85051717842.30.3885711
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf28.hostedemail.com (Postfix) with ESMTP id 611C9C0003
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 06:26:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=UyFuxlIE;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785565618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PB3rmpgw9H0XxiAUvpBD648Jdd5NiwEYnJ6cr6ny1fE=;
	b=WVsW9nii/yyRJD2DwCPAtEl86VU/DxHJvYb6ZMzOkYouX2YKCG8tb41HkdT4doKzmrn5Uu
	C9JWhy2h44K8NBubx2Pwi9SuHBjIRUNx0BjGjI9bl2hZWIUVGpYpxbAkebrg9Q38lIfbl3
	y9NqSOR+VaWM5C08Y4OoX8UX9/cAmd8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785565618;
	b=19v+QIDZjyfkCYBfzebHGb/k9FASRyPX1lRWVYmU4CwIB9M4GrNB4j6Tuyrscl5d8gmvG6
	CnRryAvD704ZrZBNx4AAvqsNMNg8lyNfMw9jY+Qo3nj7vuqxly1+6sZN8jitcajb+hdYwe
	3ICPU6jIQL2Sl6sBJFfXM5bAoSu1iT8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=UyFuxlIE;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785565613; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=PB3rmpgw9H0XxiAUvpBD648Jdd5NiwEYnJ6cr6ny1fE=;
	b=UyFuxlIEqWU45rDpdNsiPI6Uc8TuCHoRvKlXp+wEBhLSrDa/1tr0JGT9PD9BRpqalPo/L5nXdBRC2L9PLIbthoWys1LSh7vZtgPkE8pz39SSkuwyWtv1LtVfr8PzGQukIY7mOtgvIq5npmWVU0UbsxJ8Oa21kHbIyGa7gKEj+C0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X89c9e5_1785565610;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X89c9e5_1785565610 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 01 Aug 2026 14:26:50 +0800
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
Subject: [PATCH v2 2/4] selftests: mm: move gather_after_split_folio_orders() into vm_util.c file
Date: Sat,  1 Aug 2026 14:26:36 +0800
Message-ID: <cb0697506337320d438bce15cdd3c4caccb914a1.1785564857.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
References: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 611C9C0003
X-Stat-Signature: kx7h4nceeeh48gqr7y44ow8s6qxzeow4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785565616-595219
X-HE-Meta: U2FsdGVkX1+2StMfjLUuDx23hT9ngh2ZyqwSA5CnruDoinlIofPqLtn0nQXaljUKTi5rrSHdDhaRpQ/S3RxLzgAUD9nnHhbMSdGwo/K5kXHvfcZLmb8Di5pm8fk2JM+gs7Lt7juJ3DRPM/oZhI6xpEoCE9+ejubwZJV8Su4ClMBsvY6IahKM9nndfG/4f8t5q3EbPlHGsXC8fc5SHAJbO8kPQdC+PNSgGyBjpeTHo4QnW514aUu4paoUHtM7/WubG7ue1CESytSFxb+3dS4/Ur5QRVsbSMN/nXD7ET8hSC3NrHoyoblRMJQ3S62orvsMPsUzwAUpAjgw1QHuQKLwfPBTKpS+p1lFP9CaI5yOT5ywwGpzx47HQJVlYjnU4a6BVFO+aeIWZ0/MIAZDpanXprxmKpgc6F/oXbuMzLDD+EavyOZnifnB6A4g6MJub/56Th4QTUQsrrf5Nv9UlG578DG6HOE/q8wwVcul4vLaKWYEq3m8GPoP3U5el8vUtntIR3IcYIo+45XtqYDp9FnVTQ8F0r+zenKebGm6lBXO0DG2LfrLq6IjFw+uu7MbZRE7E5poSN9FdiUtoFgYzumbJLv3ZK0hNC2Bo0PgzkXOH8+MJ4TDAiP8HaA1s4lmVmKLFojFAjhZZZ4BrPUMLisPSs63Bp4E+TEyxxPGJPkEVon4ud1o00nXMvG/6dnpluJH2SebhaCNiVDwDSIWWNEjI6EdqqHa6LR+dlhTwcA3SzKT2cZRXdq+XuOPCx9sFKC0h9eSJzINdXYP3yb5xMDwfk9r2kv2L+TPptuOpTgGQNKKXhY8retdh9yhPV6MZYPC/V6Jbs5nc601IKcq7mLV3pbYSf9wEoiApd2YKav86iT+fuo7gEUYERD+tYHTBM9qTe3/vZPkI+ay8LyZo1dNlgfOT1cN6kRZVpPXUiHyJsB3tX6zW7h+ehqvPxws02R+pryLn1D51qBZPoEWrcq
 dBFOyrvF
 H/iZYr8QWJfJpLg6/2nFkmI//fHclFqJg+pMrIU+CjkSMc7DOuKZAbYJCPpzbrK4asWux7AtEDgrlzRquvpT/T44OWHVlb55n0ukYI6fuc1zXtVKugmc8sMP9wDIPkNuBIN/C8HnulcVaxQ4Tl3qUoaOGjbYgKbWKfuhzZs+hy2fnCut4JNGI8R6moSN+z6s15XI5ttNpxmQD/x3wJZnO6wfI2T8UdwUpuUR/YR3WCgSmu5dba9/zC8a8012AAG4ZMWlX1mnRjIxenMozCNpjhDkEioJ5UyG5RBiaQTE8A4UuVno=
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


