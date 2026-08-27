Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43B6CC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:46:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D3806B00A4; Thu, 27 Aug 2026 05:46:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4841A6B00A5; Thu, 27 Aug 2026 05:46:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39AD56B00A6; Thu, 27 Aug 2026 05:46:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18C046B00A4
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:46:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A14E614039C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:46:09 +0000 (UTC)
X-FDA: 85146568458.01.F156DCD
Received: from mta1.migadu.com (out-143.mta1.migadu.com [95.215.58.143])
	by imf11.hostedemail.com (Postfix) with ESMTP id B67D340007
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:46:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.143 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787823967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TXmkw22YhDRAPRYl/gJ2AIjAX59fTDDTZHyNOZY+LhI=;
	b=yVMVb2U6FNtsmQtD5v8Is08tTUBbwSjOnRo+JHJFnf5u6lQRXnKF14dwdFvEIAkADV9Veu
	Qi/AfW7Kf5bgDnxkPWsrtFc4rqHVzPQZ/LVjJ/z+55FHazye6vLedOBTtlPDFv3vxeL5ih
	92oTVg12VQ4ZssrLa8YhQUxZvCWUDp8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787823967;
	b=2Z8akd2r6zXvz6hTjuCISzfuniHFzBLkjqwpCVeiCl5AGm27MZE8o2JaqxUskW6h0d1yoY
	U9ZOFWIekZWMX0Gt8tdGKZg1PLRXJHuLMQjG6UTsHi74aW9YYesZX4pOMFq0vs8XGgCXgG
	alM8HItS6ehbepjfa4ZJNmJMJGMmjhc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.143 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 24f83e8c77bff038;
	Thu, 27 Aug 2026 09:46:06 +0000
X-Mizu-Trace-ID: 24f83e8c77bff038
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 09/16] mm, swap: free backing pages in xswap_unmap_clusters
Date: Thu, 27 Aug 2026 17:44:59 +0800
Message-ID: <20260827094509.1016740-10-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9oh3e77mu47fym85k78zp3yystb1snom
X-Rspamd-Queue-Id: B67D340007
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787823967-593483
X-HE-Meta: U2FsdGVkX19ppouaLa1sJ5CCFGHBBOpfoecA2Ilx8ZTWxsYxQvmJVC0TbIpvO8PBekK5LqZuftf6BaqC+cTn/dnRajM9an09wAsacShAQRXtxJczNoLWU5mYap6xoEW2PP45f8+nO40Uyo5I5Tst5Kw2MuIQrAkhktKNK+/iu5hG6mI4TN1SS7iTYg/CqsisWNUof8kLF8BEJNZQdIY8jsNX36jyVb9HzKlu+NaFCcTQpGTIn/UF/3Onz3ej/cbppxhRZJ/E60BL8rLpKT3agHjVZj6mGSBmhNk6xI8XPku19p0pxGZNb+7TDSflDKeWGFpeoqDvkHqMOsgVaj17btezp6JQnyggkJXJVvx/9ZEJe3cOgPlBTV/c644nO4ufn6b6ubQ77UIMa18gRPvtDubhIP62l/hpQOmSNEyCUIdKVPoW4Y1kezYHc8eM8etrOe8F/wxA8VZ/Ss2jKc+HBDml5BNNtQk6PZ0Qv8TRxOP3havinMpOHi4qaU1w5WdCClXv5ENQrX4iA94UX6L2GEgxUkU++B3Y38o4uE5r+kEMjJMgDMFWKn/GRbnd781HFVb8/fuj4wUsoUfOmCrXAt3i1pDXWKzWfRiyYWXPcjVpQvaeaSumLVkKaREUE1GM4Rbx0wM988R1yIDATu46oYjh87xqRZsVAjRogy+U0J4n+/DhbHSp8MdoxFXwkQbJ6fSEoBy3XLN+HkY006NnbXQa4n6dsbDATFrM3MnNa1EP5b58+AUjuK1y0orwBezR/f58Pkhj9jmz2xG0yNxpSZr3sEYZDalPJTW7B6xGuWi8ZBlk8clU2nz7ZamAOhts7nhIvalEgSDChQl4QCRjelqcWX3gZqzsBxLRf6P0j5TEPaTX2+psuPR05o+XzfqSLQrJK2Juakd89jpJZiYLII8iEb0q09GU+mRXYVcEgHUTwI6VqRy5zgGzHGF2zl0wMfMxEIKi8pW4xvZWijy
 bT2P6Fkx
 t9wbEmJiqJaEJup2iTrvw/VhllCdyHaaqljRr6GzcIcX8bQ1+rXxTDiqzkSOr9LaSv7PlRq4KBgLou9YJOqVEl53UMNn5O8UumyJt0KrEQy/GJgZ+gFIULsoiyXMkQ2+Buhdzci1qZ31960EPfYTrvO7PI5hX/IzXljFG80K3hnwYbdmT8bdiz+NGoGIbxcL5/fKuX3rpHpFCTJRw+gPi31mlhZhRTilEUhv9Ln9qYJEakqm4JMg0dvU7NNlc3W2k1jNteRb70jdrZ/xfKMBZArBwR6+TrnvNHLIeBv5lGON8PMfznb+RdEQL7fLIxosMh51jNpZe6SdfbUODVC+EL9/KeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vm_area_unmap_pages() only clears PTEs and frees intermediate page
table pages - it does not free the backing physical pages allocated
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
index 6b18c1b21adc..0fe4834eadde 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3847,6 +3847,23 @@ static int xswap_map_clusters(struct swap_info_struct *si,
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
@@ -3856,6 +3873,10 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 	/* Round to page boundaries for vm_area_unmap_pages(). */
 	unsigned long vm_start = PAGE_ALIGN(start_addr);
 	unsigned long vm_end = PAGE_ALIGN(end_addr);
+	unsigned long size;
+	unsigned long npages;
+	struct xswap_page_data xpd;
+	int i;
 
 	mutex_lock(&si->xswap_lock);
 
@@ -3865,9 +3886,25 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
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


