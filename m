Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59540CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FE258E0046; Wed, 20 Aug 2025 05:07:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 987C18E003E; Wed, 20 Aug 2025 05:07:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DA468E0046; Wed, 20 Aug 2025 05:07:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 615DD8E003E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:07:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1281213874C
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:07:53 +0000 (UTC)
X-FDA: 83796558468.24.3276133
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf11.hostedemail.com (Postfix) with ESMTP id BC4614000F
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:07:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YCzId0ms;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755680872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GLHMQ2aL75uW7dMd2UVF2Rmlbf3qVWCe706KFetc4TE=;
	b=emyRJJI5Crwq1gaTfPfJrAxaBX0+1K206hrSjeQEXIJ1SeXVAmLUEYdWOeG2CxuDCeA63x
	zCYiGC6DZOCIvBM2P+5Dro0rX8s9zzyqMcm24a8H1a61SiQhEhzuKWLGGreb1q1Er5eXAD
	tXKYeXItq5rAjV5w7GTgoPsZwD2VUUc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YCzId0ms;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755680872; a=rsa-sha256;
	cv=none;
	b=0EKC1ypj4Bjr6dxW90ZUYIkxyK9LdnC/kByM5VkZehvbvC6iEZvVms8QcMCPQRWFnKos0q
	EVXVLaFSVyAQ8XumRVVg+RP9r8vuaQHlYd0iaZZsszMYTsoLgt/fN44tJCusANOUP6TSHt
	2h1Tr4o0EluGvvJWaEmJi5q0DWCTEo4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755680866; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=GLHMQ2aL75uW7dMd2UVF2Rmlbf3qVWCe706KFetc4TE=;
	b=YCzId0msWwdxbMB9XFj5Xbx1oZagtc4lDjiDos8G4YwSTb06MgFX9DFXTrGv+Z07GQhbV3Pjf4Yu4lDFgNIDzoIMXKl4utyCgGkd/q7HDzAoDZhirUOfA/pmYFU3sjGu7M6pxYns+oRdhP0FvexkSJQI8p7VDka2A7scBjPmiGA=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WmBY58f_1755680865 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 20 Aug 2025 17:07:46 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 09/11] selftests: mm: move gather_after_split_folio_orders() into vm_util.c file
Date: Wed, 20 Aug 2025 17:07:20 +0800
Message-ID: <955e0b9682b1746c528a043f0ca530b54ee22536.1755677674.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1755677674.git.baolin.wang@linux.alibaba.com>
References: <cover.1755677674.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 36mzds85z1qamhq7a9wh9df1kr66xemj
X-Rspam-User: 
X-Rspamd-Queue-Id: BC4614000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1755680870-944849
X-HE-Meta: U2FsdGVkX18STW8eb9EitT0bplUEC2kpDs/e6iBiTeoXeiqxnH1hMXACXz2oZ7wdV9KThx2UqR9tIItRVmuaTSlxvgV+NaKy4S5Ajigtjhtg+BfEtZSqSHiwgWOjPH+fisLp6jfFCJ48GJJYg9iEKQ3ZIs5QXs3G2DrCU2PnAa/bBnTeSGREAas2BEotarW+RbdudTMsvSFnU6EG/7ayBsFSiega8ddCS93UjZhEqUwqgo5UTK+yb8l9YsHaKpxTkRwQ6df8wzd2EULY23qxg6TOHQwxneGkfK14SGBJidrZktU6JMoW6JnFIO0asURaBbIBy/ss7C/Qs7gAtAShRBHIO6x1eotG4QGFndO/vnz7x3x43ClWDZoOI7YXLdZnXmliBxwia6gsEEClgTAie/t0BWC/ukpCOxsJof3Z7/KGG9EQtU1yH8fInZQbM26b66s9t7pQtN6FXUcqnRNf8NMs+YimXI43iloMnwCA3XXY/khjL0EbctnJ1NUnRgO90xnGkT1HR4wgpgByjhQtaZh7H1FmgCpsw/qCfBoBUBrGo4ZBYBDawIrH+KGDKYP7CjZ238dUry+WBAOKo9NxGEtMihzReRk5TuWxrCf5VKuWoC0AC1p8nfSx1R3r6TOyFZQL3ReTj02QxLFtCFkPIRTyHgWFJw2dh0aCKsLirpZeiUPBXVvw8j4AlWr0C9Qg5C5GJmnEN7kk3yEKgHnL0aXcoU2JQH6q+XoYgnAGvFTk/Sb8R7b6xH4tFZSkJDBrgVT5QUesJSJyS8Y0Petiv4Kta7tTTEDtE7DcicxNX3T4YSMgr42zbEc0h6/Kh6S+dH+9ed7HjMGMQhu5xQLddF1AQIgif0eUH/QwpyxNIX86TIKiJlyYu/txCU6iX4ErO67pmfHLEdHZuZ9LEEsgtdeaEgEQqrL/qoql6dr8veS0mK4D22fftgZySCA7Ltb0WwhAeZ+WWtAMT+5ScVl
 Q23SFmNe
 jrToR7z+NVKl/67JF/EYpdbCrz+9UryRGs6k4Lxv5NihtGIkClssunriO3RM7RbOcYo4qHmfpljD6c2G3iG9JwqfzktY08/DPJq4BCSmjR1sFehnBiWqc0WdbskaPgLTnRUsMwu9PSzGKLhDkEPDv177Bj0G4Yb6QhoTkjBwtfL4hvAk/VXY2pk0JlA09IyjKSPmwG35sJ+LRRQU+0D29UukWLDhLwXutyaqfrlnTL4WHCht7JfvRI4Brehca9vLYAez0ZYs4+0pm8OA5VhhNJPPQVz1xKvUW64SzAhrdqlG1h7A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index cbf190598988..77cf510f18e0 100644
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
index 6058d80c63ef..853c8a4caa1d 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -195,6 +195,129 @@ unsigned long rss_anon(void)
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
index a1cd446e5140..197a9b69cbba 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -89,6 +89,8 @@ int64_t allocate_transhuge(void *ptr, int pagemap_fd);
 unsigned long default_huge_page_size(void);
 int detect_hugetlb_page_sizes(size_t sizes[], int max);
 int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
+int gather_folio_orders(char *vaddr_start, size_t len,
+		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders);
 
 int uffd_register(int uffd, void *addr, uint64_t len,
 		  bool miss, bool wp, bool minor);
-- 
2.43.5


