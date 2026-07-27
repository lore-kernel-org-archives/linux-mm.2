Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25FCBC531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:06:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 171A46B00A0; Mon, 27 Jul 2026 10:06:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1486B6B00A1; Mon, 27 Jul 2026 10:06:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 086426B00A2; Mon, 27 Jul 2026 10:06:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D5A1D6B00A0
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:05:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4F6DE120736
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:05:59 +0000 (UTC)
X-FDA: 85034730438.03.9DD48F1
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id 913A040012
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:05:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gzl4GgGR;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785161157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YIy7Qx8bWx3spNRm9c+a9lBeger9sWyHhg8HX/HO6dc=;
	b=zhnkPqVwvmLhiB0c4FMkwCeRsmDqriRz/FrRTn1DFj6kGjZ8RGSa7ZEKNt0UeqK3DcPfMo
	ypu3NOb+arWwrPcImcaUt54WY6qpT7jgobY+PL2a+OZ3X+I9G/6Y8t1CC9pF1bQIm0z4Zw
	9gisLallaiRaUW0tGCcpIkmV5U6h2Cg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785161157;
	b=dNjtLDv1A81GYLsDnS6KBDkMPDp8asMbUFwaT0Gy6d21UtEgJ0FUwS9y7Ul2Z9edtC6daW
	iGAxCdXFMNDEnDrLvSqwLMB+6uqAGvio7KUFbk3JqjUbOntjgoOX34YtqJwS1ElmrqBaSV
	Zu6cQhWLuSOvSP10LsW/3dIogi/U028=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gzl4GgGR;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785161156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YIy7Qx8bWx3spNRm9c+a9lBeger9sWyHhg8HX/HO6dc=;
	b=gzl4GgGR4lMlT4GFvFX0H4fZvvSa2NxagVAz1kmeIT9am0LuT7+OuZjYu3dudnRZvFhOky
	AAXBCpsw1zqmvShsQCx76V1b5GncmImu0UdfcGWXCAA9GT6PdytI6yEHWCYGVore2Fxhf4
	heog055s99I5etWPF+qIlajFLDAtnPM=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	kasong@tencent.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	david@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH 06/11] mm, swap: free backing pages in xswap_unmap_clusters
Date: Mon, 27 Jul 2026 22:04:57 +0800
Message-ID: <20260727140503.1060918-5-baoquan.he@linux.dev>
In-Reply-To: <20260727140503.1060918-1-baoquan.he@linux.dev>
References: <20260727135029.1059441-1-baoquan.he@linux.dev>
 <20260727140503.1060918-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 913A040012
X-Stat-Signature: 563fddi8j5d4gdft17mq355ig89fxgzi
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785161157-258645
X-HE-Meta: U2FsdGVkX1/8VKRzqPu+0D6U6iJcuWy/j2A/XyQCTWb7sX6ib3GCqnG5ZS5f6IzNZDZJ0nJED260fArYdbcs+3vkTOB7gS8uT61xn58GxU7aNpQhf8Chs//tABi9zZM0J9llfYCriWnoYxcnn040DaadNN3IDQngsZ5j0f84T1dljBaeWQ5sOiUnxE5PWrWq56OgPAYiOm6C6OOKuuR4UgNIL5olgF4tsZl2pwWIlHDSDDkLcGkOyGlpANrAmPPeZQn05Fye9lxxcJVDyv7ax3J/eJlApSBqch5WkTt/U6Sd8LGf1OyxWlMeZY8IWrPXidgB1zlGSmKLANBYR+FDtQczP4hbNm0GSB42MV9tYtOAcaxI+Y7hoPe3WDMrAXoRkQRrWeCj5YmjEY9FkCUvq39NylC5EqeMFGnsVWkuVet00kd7+Kbf0Y9ExEiSfTThoeDvtrXffMqgHp1hr23W7VzQIZwJltGmWHsNf9Fr7XRRxXtrlqMekpoKgE0XiwUc/hFMHenZ++lXmiMj4XilBqMQcfPYKbewTSgB4P+t0cZdsIqyZJUsshC51f9nGsklKSfWU3iz1957p/Y8nWbBFLGvEehkK7UWa+vWknp4V/QpQi1tjrk1lZy7hYt7HJyqKxFL2PK1NDCtSSDkqqOEqVVYO+vhpcHG/9PnJRRrqZ2MqFmGLOiX09VIjQHCCYfCun09SXrND5Z2SJMsAQOhukx1xk/1clbar7ic/B9yM3mu8STLVuXctkJL4XcitkwT91yijpari9huVO1ex5CGx2Id9OfoSgX3dxUgxYBRoKCcjPRR4p5+kXh3udFTyKBMSqW7+qXBE9kdnPzrnbJUp6KHTcBq8Lqi34lo7vC3hCynGJEEgMIfGYDdkvkKeB3AM3bTPkpNn7kUHMymCBO2ZkP04lr8D77HdOw1rLamNjLXuaEII/GAZtRRzCWXBDCUubOKA3YnSuLNvejxtRt
 e/+DheOg
 5fYL40Cb5jDznDEgri54ORxiic8FlkAySC9Jdr+nFFBPLHdVofEVMFtoytjIaInK99LWZgN+pW9JAqPeUv7P+ddYlt1MtoaIsEyrIkTrcuLThYikUXZKBNuj8b7GoOpHIrJoFzqSShf05XfjdAgwko4LBAc4oJcTGTrUmtI8sxGh9nRoBoKVR/nC7ubBAoSWTziwh6VV1q+FVuN3AAII75zQWh+cs3+eNSTtznUrygkGjMvPvGTBD/C16YgFsQUBFsqUxylo5qMANmWzwGmUjXvBT86wodVjtqFLPm5voJuC78v5v92CzgPN8K2I/gjj4JoGeiylD78UwHsf9NROnK1OP3Q==
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

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/swapfile.c | 51 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 6 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index e0f5fe64de2a..7613ce231d70 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3776,6 +3776,23 @@ static int xswap_map_clusters(struct swap_info_struct *si,
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
@@ -3785,21 +3802,43 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 	/*
 	 * Round to page boundaries: start up (skip partial page that may
 	 * contain clusters still in use before start_idx), end up so the
-	 * entire range is covered.  vm_area_unmap_pages() operates on
-	 * whole pages.
+	 * entire range is covered.  vm_area_unmap_pages() and
+	 * apply_to_existing_page_range() operate on whole pages.
 	 */
 	unsigned long vm_start = PAGE_ALIGN(start_addr);
 	unsigned long vm_end = PAGE_ALIGN(end_addr);
+	unsigned long size;
+	unsigned long npages;
+	struct xswap_page_data xpd;
+	int i;
 
 	if (vm_start >= vm_end)
 		goto out;
 
-	vm_area_unmap_pages(si->cluster_vm, vm_start, vm_end);
+	size = vm_end - vm_start;
+	npages = size >> PAGE_SHIFT;
+
 	/*
-	 * vm_area_unmap_pages() only clears PTEs; it does not free the
-	 * physical pages.  Walk the page table to find and free them.
+	 * Walk the page table to collect physical pages before unmapping.
+	 * vm_area_unmap_pages() only clears PTEs and frees intermediate
+	 * page table pages — it does not free backing pages.
 	 */
-	/* TODO: free backing pages via page table walk or tracking bitmap */
+	xpd.pages = kmalloc_array(npages, sizeof(*xpd.pages), GFP_KERNEL);
+	if (xpd.pages) {
+		xpd.nr = 0;
+		xpd.max = npages;
+		apply_to_existing_page_range(&init_mm, vm_start, size,
+					     xswap_collect_page, &xpd);
+	}
+
+	vm_area_unmap_pages(si->cluster_vm, vm_start, vm_end);
+
+	/* Free the collected backing pages */
+	if (xpd.pages) {
+		for (i = 0; i < xpd.nr; i++)
+			__free_page(xpd.pages[i]);
+		kfree(xpd.pages);
+	}
 	/*
 	 * Pairs with READ_ONCE() in shrink/grow paths.
 	 */
-- 
2.54.0


