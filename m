Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B866C55182
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 07:54:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9A946B00AC; Wed,  5 Aug 2026 03:54:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B71176B00AD; Wed,  5 Aug 2026 03:54:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAE696B00AF; Wed,  5 Aug 2026 03:54:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 887C46B00AC
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:54:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 93563C03CC
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:54:56 +0000 (UTC)
X-FDA: 85066454592.18.5C43A7C
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf03.hostedemail.com (Postfix) with ESMTP id CB51A20007
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:54:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WTf6PIsg;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785916494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KQPF9NpoXms5JqUk+wWG0b5ssSUK6sTaQPnJLeO/Wgc=;
	b=6s782hxwWwTJRu88lwFs+uzxA/zXaeppbXZqZwpEiJ3Tfa5e9C273X1vvDnqRuyfQt3qWU
	y/yfkOCc37wxL87dmXwQwPRjWandNLij7d+Pw+l0MK5zRhPRNW+xo8Zgh7AWToRAjyuygT
	IRnetmuva1i9w7B5EG5zZihubGKETzY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WTf6PIsg;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785916494;
	b=3pBKp26sBTz6lJ/FSszd41aTUkrjdJ4hzSadpimcjI8wgGWb69amTW7rhCak+0zQvxJGFo
	J+HUPU0GFg+somqQGk5ybZSdXbpDyWzrzAOGHeePLRZ+QFKYBqcEIUG9kxsnAhdVJiCSxt
	MSSgCTvWObYjrYVc2Egaii7JWdXI0hw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785916493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KQPF9NpoXms5JqUk+wWG0b5ssSUK6sTaQPnJLeO/Wgc=;
	b=WTf6PIsgJKrF3nj0UfO/kXgdoFHWcAZIMMiQtM5TabV1fluZmpgG0uKdbdZKRSg62tLfXT
	sFrrnvfe5jPh5tVLZVdGvzdHlRyVVhmPUwQeLsbGawGSKzWB+6MVaKMxIW99TXl3MxwIJM
	ZnAaw97ElGJcefECReEWYaPZmZChrqU=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: chrisl@kernel.org,
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
Subject: [RFC PATCH v2 06/10] mm, swap: free backing pages in xswap_unmap_clusters
Date: Wed,  5 Aug 2026 15:53:29 +0800
Message-ID: <20260805075336.3579395-7-baoquan.he@linux.dev>
In-Reply-To: <20260805075336.3579395-1-baoquan.he@linux.dev>
References: <20260805075336.3579395-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: knosocqga4wdwdh58wi1wmr3bjjn4ub3
X-Rspamd-Queue-Id: CB51A20007
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785916494-33393
X-HE-Meta: U2FsdGVkX18gHtLeDy/9AjpI/w6gpx/szhQGjQs5nhg/oETCzfEXHBcbr09VAfqT5Cv/S/Kgiscbavb7KePKUMdooVLuI/wG22tQsUAtBMhX8wvRNp2xQ/nKKwBlKekoevnEEpqt+s7k2N5WDrEE5Vc46pQ1u8VpXCM3oT1hEoCLTRCAcQYnxOSV27Zk7n9HjV89pQHit7HkuBiUIa7kIBDm5gTNHJTr7/MaxaNlYn7aiZXeIjgiRd+UOMCIyO8vgWOrbiYt8JyZFSmdEiWRf9ccgSh3wdrIjd/2mxN33yOPSlg7V7F2c4okbixumW/m/zSx/CdW738ceskV6ao/GSDTL7WhVl9m5ygGB9Oq9MrQKHHlCgNkZb4t7UyBKtjVhR3WhO4URn+aLkhy35dkdosHG9X2FUCkPWV7Qm868wOKfA/azDv7aELtyYJVwQ1KEg6QiOmW+F0ZTDkjAE8fC3Fw5HjnMdZ2SPT+oRK+XzJJ1vZvuTtcPvLuic0ruIiegexFCBLkTGiGr576bvegfmeecL+dAYjxfohIqnWRtszpMR2kl8k3s/BecJYXzeXkjzzELTbEzcF1JWYRyG4XSqJ22QeE+bVD5m1rP7csb1FA32nKbygil55e1nbFtsSK8F+YC27SAPsSaU2pzvS1ZdHuPwtDJhEGMpmN3WlgpZBLPtd583Vj+6b8dIHnYnQyoBsYLmapkcZfN2++b+nHcp6MdP3LGvnDCOF5tnMZZr/bVGzPZQo6cW2uzLZFAK6A3fUyYrSFx7xv9i2TDmSM/C6+n3TIrqQt/Vs+DCGiq4X4Ol1HuVOOvaob5Z2Pe3Eg5Bt58U4Y9i6gEfBUgqHJXuXahaOKrHEvrCLhFewpxUgQQnRO0XbmyW54dAUgteJ4iuOs0wnQyou1AnUzmLKLqIPQIOjhMo7M6eUAQZOpAGEHHva7qmoV/To0efV+GK/umuEHxjzKTyj0d5rIPRl
 m+71sFWE
 sOP8cAnJUfQjufuIcC6MUHm0F4hp1h1noRUHtLImEyVMISkat7hyj17dcE9BXy/FL+YjPPctksntkaxkDWM79vF8QBnVdFMcmVlgdEfLhoB2bwNV/9TlIq07wCKeKTSpEKWlYJcGL+jvVe98jcDiAcrwCuOjXY0IC27xy1lboELxf3Vd2L81KngArv2Xl2A090rZS9o1KDDq3dRkjU2iUuPAUZilMfuL8s+mw170bRaTiZURHW/gZCuV+GmsqBcQ97lUyw0W++Q45pR+gSfGVPcnvxqTJkrrczDpM9UZZAAvZVSn7MZyRfQBS/qFfL7DOG7xDwcIiKe4dpGG/WA/82C1GYw==
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
 mm/swapfile.c | 52 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0d1d0c5e24c6..c43c8746378e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3796,6 +3796,23 @@ static int xswap_map_clusters(struct swap_info_struct *si,
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
@@ -3805,11 +3822,15 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
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
 
 	mutex_lock(&si->xswap_lock);
 
@@ -3818,12 +3839,31 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 		goto out;
 	}
 
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
+
 	mutex_unlock(&si->xswap_lock);
 
 out:
-- 
2.54.0


