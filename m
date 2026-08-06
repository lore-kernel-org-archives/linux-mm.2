Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F08D1C55ABA
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 03:34:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F6376B00A2; Wed,  5 Aug 2026 23:34:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A7196B00A3; Wed,  5 Aug 2026 23:34:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796166B00A6; Wed,  5 Aug 2026 23:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A1426B00A3
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:34:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0A41F1A064C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:34:40 +0000 (UTC)
X-FDA: 85069427520.19.AC3A6E1
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4CFC14000E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:34:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Bd7DFNbt;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785987278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxRaadKXN4Ai3RCtqQEpFhbfnc0O8QqgkTWBzjyv1Sw=;
	b=qXs15xvJN92hTWNz4bI/WMnmCWR20AmAD422XjJwT4gd6bwsK2hIAmIQhLmLRnKcr0McG7
	VdhCOdyHGQOcGXUvKUMnpSuKd0BAS57lq1TYHoHlNJLYFWHkaqk1b6MuDUlKB4Xkc4OrMH
	KEOF986DkJn/cn8wrjWBQhzuJLRq0mk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Bd7DFNbt;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785987278;
	b=2gq9oP5IGVuPp/EpLNk0LgALQhDjCHDzdVmdPjdmlUTNJZDsP7EBgIfHAYEe0VFEhvr8AE
	mrQYFVE9yuldjJaZvnoXeNzwb0A2QBorqTkbHJoK4mnPcVvWQMUhNeTUe7bSUc9S86akYg
	4OQHnKO8oGZLdvB/+f0AM8j58XYomFo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785987274; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=SxRaadKXN4Ai3RCtqQEpFhbfnc0O8QqgkTWBzjyv1Sw=;
	b=Bd7DFNbtw/Bgx1N8KSdvfISXDhtXOK6k/+ugNlESpI4DOE0Ir5YnsFdgSnPmIeVI9I/dZy30VsQc5u0wUd5aDNfGC7sGlGSjAI+Kt2tpXa5Ev1K2pHhLEgjkIqjCp1sP6PIMK8TfNZ6B4eJmRgl51YtoEzAcHJbDZZDq1HeYknI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X8SlEK3_1785987272;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8SlEK3_1785987272 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 06 Aug 2026 11:34:32 +0800
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
Subject: [PATCH v3 2/4] selftests: mm: move gather_after_split_folio_orders() into vm_util.c file
Date: Thu,  6 Aug 2026 11:34:13 +0800
Message-ID: <30a0a99556adf11c2bf97aa08d6da4830bb43f6f.1785985999.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1785985999.git.baolin.wang@linux.alibaba.com>
References: <cover.1785985999.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: 14pbc9oo3urctnwnd49t4qmns7egpap6
X-Rspamd-Queue-Id: 4CFC14000E
X-HE-Tag: 1785987276-241686
X-HE-Meta: U2FsdGVkX19JbLeA/gh7703S1KsgWLlFrvrIaxlkURcUlEi6NlznBaoA981SUVfQULa5ZRLe+F7nbxiQp1xtrS02AAsnMWAfJu46maGbJb7HZK6hXBTtOIHo0Ogs6n3oFO9mwYPitivAeXyeTLdX89wQu9kjcOwpJ53XK0S7dN3yOIKdd79t+vdncs82pUtfl+nw21MeqI2bikCZ/9Dq5fyktJEK4q6JG6haLs7Eg43CubclKio4O6gOwvS4KiHkB7jNjng+8bsu4HtxziynODz9kPuPLYD/Gk0QTBzczjNOni/CBLJvINHmDuGdtBoT6Bt5i3zz+8UJ5Aivgi8pL3wh0b3HTIbvpyq2MkFpuDXptKswWVy2Y4czlkm+LDNzGwtPUjZqYa+YiUF6qhuwUr/l65BEvT6bs88JF9Uqbqfey+OsYkwFkIh9hzgIx6TBWKK+et4MUr0zFrd7rzW5w6OXmBmJfZcS0zay1aQyZZNBt+KKz/8Sc2QU163weHwS5XbHwqOhWzMvj5gtmm74hoHjRS+cpHluUlzz9psh/glMTftrBC9hRVr5ZV6fRyt/mlUQ9XGb+ItRCqg3Krq5LOobOYX/O91aOtxqSiRMqCJzy9iszYB/bzXztjEXX/HOwXGxd1IHQ0rMWd8+g1SRzMSfUF9p9vRUpoYLy+J9UjhKzpxPOyDYozAZbCcMhgL37/8ODyrCqJBi8HCb3oUYO/zM+ykIPwO0JANadeknCNg7YKvqQc/SysH16YCptsPiVTOaq1tRRfctlbDtnHyO2DtnhnhzNhh52hCdpmkb2e7iAf7CEEvKBNXrJ+LuAiCU0YqIDMXL0KLbQW1R7OYGKgXRsf1tL2phQS3xNIevMx8gSKSEAvNmale84yXfS57ZsGKzUy3qsGSED35dNHY4DybJ6ZN/0kCpLyizHb/LZuAhPG8Hcy0ZE0EOWCZUGyVeDlzdX6VIZf39JFcg3U3
 VKzdYMJz
 zEAMGA05EK6jQmvQsK1U9pIsfYd9ECaRB/xDK4xU8r76OYMDI/lTqZg1CagBQNIPxn04qD8rGLl1WWC5+TlBTjGNX/ZpTeVvw3r+sra3fvHOMqzT5TcC4NQZzkCIMfj2Wa2MGhrd+XJ1lsIURKQPjBNT3RAwYH+YDUOSXo+derWYrfTw2BD9GIwi/G/JMkUMEYyiZwBMsgLmZ/w37a5w2e5Gx4+nIZCWnAcQH3txk2MRYfhGKfkXsqptAOlvtc6b+7udb6eBQvz7q3r2ahw7UAQXTBVHGBx1Nsl6E/0vvCoESEzmMDevsVvX7lQGCZVREZgJUlvjdUi6WVKC7BXJOLzYchMU93zymslf3
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

Reviewed-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Tested-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
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
index ed7b4eae3f3c..5a427f494cd8 100644
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
index 565570b2cf8b..9a49af88702e 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -95,6 +95,8 @@ bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 int64_t allocate_transhuge(void *ptr, int pagemap_fd);
 int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
+int gather_folio_orders(char *vaddr_start, size_t len,
+		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders);
 
 int uffd_register(int uffd, void *addr, uint64_t len,
 		  bool miss, bool wp, bool minor);
-- 
2.47.3


