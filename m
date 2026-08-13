Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B0A6C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:50:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F4B36B027D; Thu, 13 Aug 2026 06:50:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A5936B027E; Thu, 13 Aug 2026 06:50:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BBA86B027F; Thu, 13 Aug 2026 06:50:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37DEB6B027D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:50:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E536805B0
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:50:19 +0000 (UTC)
X-FDA: 85095926958.22.41E4EA8
Received: from mta0.migadu.com (out-86.mta0.migadu.com [91.218.175.86])
	by imf19.hostedemail.com (Postfix) with ESMTP id 324F81A000C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:50:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.86 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786618217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WoVR7I9OkgwGElOgT9ybqEMd4fjDi9rmixxWbYfdD2I=;
	b=D3lGMoBQvB9hl3Xs8SSkgstSKMrs4dPfdG+eA87pSImTpLzkvTiu9i5FZV8usnvkvTtIcD
	cvmpqrXHyCN4rUmI9daPAva9ajwKcxRBwbjvm5PnXDQar+pC5CzMvgYC9CdO671i7C1pjL
	YFbeRJosny3EyxhF74f+FZNegyhV89A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786618217;
	b=N0LqcNqnSvNf8wLNogkoGDsv4prg0nCE4zSHaCOy74sk2eY8XeDq+mM0hbFQ1nVOJFRX69
	RF9up9HuRQQtDdDhgE1P5Ttd1Pi+DHoUaIH2qRsCHjD3yN2NfmgbA7G7qvwuuCM3JF2IEl
	lKEhZPQyatC2BYOMXKvzn8bEVkREgG0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.86 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta10.migadu.com with ESMTPS id cac1573cb6c30560;
	Thu, 13 Aug 2026 10:50:15 +0000
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: chrisl@kernel.org,
	nphamcs@gmail.com,
	kasong@tencent.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC v3 09/15] mm, swap: free backing pages in xswap_unmap_clusters
Date: Thu, 13 Aug 2026 18:48:48 +0800
Message-ID: <20260813104857.3450386-10-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
References: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: fpu1qya68aejcwed1r7q73feduy9xeza
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 324F81A000C
X-HE-Tag: 1786618216-61753
X-HE-Meta: U2FsdGVkX1+NqZEo1yS6xW8pVixzt8vVWzL5AJfpCmg+yvQB0+hTN8+4bimR3H548IiLtmfFO/Ci1IVNyNqs+IUFZ2ILs6EDsEGu4lwM2tgWIn6AElChGnw8RcF22Xhm4zHoq380eARm4VsOxxaQyWTlaAhiiwUakMbFjrhuHiqgZW2XxNDAcA0kcENfU9GbSMD0jyhzCn8lIpqeWWuI0had8G6BqskTqztVsuR2Y07KPm91KlkZvO/VoiLF5TFCBL1vexmmvzZjiqKJaCjF5dZ0hK5+4gNXkjPqwd3e3t/yPCuPobWvYivpUnyc8HKf7qaQCtEGUOXE0lHOAh3WdxN8OX/zrVj1c5KHvEDkzWx9Rn0OhiW34HWZry8ubhC8Jk0t9RJJNpyUz6W7WPYaWhLxBwsdHKUkuXJss0CEjhdrECjYmHB4wg+1/6A5mlWSso00Tj/j/UD0UJ15qovSjqM2TZkseVa7A8jUCeFE3x2LzwV1/tdDeiOrb8R3E7EphjnSeh0vuOBs4q4oAVUVqnkh1MoRc7k90h6Z9uaUvSvSopGGXURNB9557zoZhRRGmGzmp98I29WeNSah0w+IjRWuOeKv4xA+bjHTBMbcXlGIV/xpT6ilXQau+Q9cy4+55p7AgDgu6VtcWwxEqIKag+NvE6YJUvs/KUMEim4eklKQYDXinFYkktS+4LekXQBgf8jHVpVFGCs0+8Z0duY9CyszdYK1T86DZzTQZntbGsWS6t1S9H6oRMljwMYNw5F55oM621DSycVnMKW6q36slGbf9j4GVQdSdRm0rNqM9YKUGLF/E15qOD+PP6LtlETRGC1TPzBDeQFml0+erCvKonSV6PK2J0CC61bw+DSHObc6w1k6XGrRqGwB/n6qCaf8vY8PcKXjc3lmQWQMJlsTc28UjLenqegMz5aceDhNF90SVjnqo/2qYYI0sboNsHDF6b74LWO0z1vT2a+wQoO
 V1erDoEO
 bQry18tFvife0CjqncY6VnUT4uY1vCWwpEElRKQ+nlGxUCcKFiETYHrs6e9CIJmHKPORs47Q0t3X4Z3/0odlGbOeGod6x7LhK7DWJ+W/Ub+kX5vkHYi8TGWrAWZJj6VErLtFPb7EgGNEt5X97EQCsrx8Sey7zAopRp9sONvsU2lv95nScHi9YMUqpvoZYPy998Gij9jglfnnrW6lEx3bfaIaALyVqUNSOQTs4kb2+r6WszOEi7lhlI5aN/O2hNbrQe3ngJmR+mL/Cz6hzwyRu6cVO3lmJ8e2IcQr+RUi83X85sdkKzxmMYekffgO21LtOYRO8RP8qJItERq84O2c2KN0TZAl32KFz0qtz5odjBfm5lBrqxjGx1ZPwkbcRK16d/3hf+Ak0Yv9Y5k6fJQYPGqnqZFQdi2MItApAPJcX2q25Az3efOYEuSB5KkcpVvz/Kh3YKa7uW1x2o7Opfj5HVaVRIpafjfaJ4xyCxGukI+vRvZhBwFCndK9SKp/8N6NMRcJ/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vm_area_unmap_pages() only clears PTEs and frees intermediate page
table pages — it does not free the backing physical pages allocated
by xswap_map_clusters().

Fix this by walking the page table with apply_to_existing_page_range()
before the unmap to collect all struct pages in the range. After
vunmap_range() clears the PTEs, free the collected pages via
__free_page().

Use a simple xswap_page_data collector callback: for each present PTE,
collect pte_page() into a dynamically allocated array. The array is
freed after the pages are released.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index a3ba3496ed18..c954313bbf75 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3840,6 +3840,23 @@ static int xswap_map_clusters(struct swap_info_struct *si,
 	return -ENOMEM;
 }
 
+struct xswap_page_data {
+	struct page **pages;
+	int nr;
+	int max;
+};
+
+static int xswap_collect_page(pte_t *pte, unsigned long addr, void *data)
+{
+	struct xswap_page_data *xpd = data;
+
+	if (!pte_present(*pte))
+		return 0;
+	if (xpd->nr < xpd->max)
+		xpd->pages[xpd->nr++] = pte_page(*pte);
+	return 0;
+}
+
 static void xswap_unmap_clusters(struct swap_info_struct *si,
 				 unsigned long start_idx, unsigned long nr)
 {
@@ -3849,6 +3866,10 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 	/* Round to page boundaries for vm_area_unmap_pages(). */
 	unsigned long vm_start = PAGE_ALIGN(start_addr);
 	unsigned long vm_end = PAGE_ALIGN(end_addr);
+	unsigned long size;
+	unsigned long npages;
+	struct xswap_page_data xpd;
+	int i;
 
 	mutex_lock(&si->xswap_lock);
 
@@ -3858,9 +3879,25 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 		return;
 	}
 
+	size = vm_end - vm_start;
+	npages = size >> PAGE_SHIFT;
+
+	xpd.pages = kmalloc_array(npages, sizeof(*xpd.pages), GFP_KERNEL);
+	if (xpd.pages) {
+		xpd.nr = 0;
+		xpd.max = npages;
+		apply_to_existing_page_range(&init_mm, vm_start, size,
+					     xswap_collect_page, &xpd);
+	}
+
 	vm_area_unmap_pages(si->cluster_vm, vm_start, vm_end);
-	/* vm_area_unmap_pages() clears PTEs but does not free pages. */
-	/* TODO: free backing pages via page table walk or tracking bitmap */
+
+	/* Free the collected backing pages */
+	if (xpd.pages) {
+		for (i = 0; i < xpd.nr; i++)
+			__free_page(xpd.pages[i]);
+		kfree(xpd.pages);
+	}
 
 	/* Pairs with READ_ONCE() in shrink/grow paths. */
 	WRITE_ONCE(si->nr_clusters_mapped, start_idx);
-- 
2.54.0


