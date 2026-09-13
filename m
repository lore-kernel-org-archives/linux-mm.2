Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D281C88E40
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 07:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CB036B00A1; Sun, 13 Sep 2026 03:51:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99E566B00A2; Sun, 13 Sep 2026 03:51:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CE3A6B00A3; Sun, 13 Sep 2026 03:51:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C3916B00A1
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 03:51:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8DD7F160612
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:51:05 +0000 (UTC)
X-FDA: 85207968090.17.5641578
Received: from mta0.migadu.com (out-117.mta0.migadu.com [91.218.175.117])
	by imf29.hostedemail.com (Postfix) with ESMTP id A15AC120008
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:51:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.117 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789285863;
	b=Zo4hHxR/nj7pMDlcMA/KQLvJANINm2q5UNRaBiVRyh9oIeteB7I0pQABa3tQFINwOHFEnS
	zSmCJSJtrFHAzs3HV/EmEClxNgF+3kx6Vcw5A0HAGuyzxVVq/wTDrCUMvNijIN2DrIoHme
	0hU0VrgsWaMEFQ53ApzsRN2GhNzIjew=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.117 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789285863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z3v4DpxsPyOGJmfEpzOYGoUUceld4LddlDmI9OotmZE=;
	b=7nj4bFzWKJ0UNMYLvDgAs06oHLk3Y5cQbZT77hjCHOLQ2CUUxcZ7/SFaeQeC+KfvdcEFPX
	QPS6ucw13kcVpDXAVqSqepesQ7+LB0NbF+p+fRIw7aga3T+e3ATQEZvyMeOgt/J81SmDC8
	USsusDrgroHR6Xpl0WnwGJO1Ob9mY2I=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 6d94a1b0bd75a97d;
	Sun, 13 Sep 2026 07:51:02 +0000
X-Mizu-Trace-ID: 6d94a1b0bd75a97d
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
Subject: [PATCH v2 08/12] mm, swap: free backing pages in xswap_unmap_clusters
Date: Sun, 13 Sep 2026 15:50:10 +0800
Message-ID: <20260913075014.1732524-9-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913075014.1732524-1-hebaoquan@kylinos.cn>
References: <20260913075014.1732524-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A15AC120008
X-Stat-Signature: i3entqmgbf353qciesdktqc9d7g8jzgu
X-HE-Tag: 1789285863-247109
X-HE-Meta: U2FsdGVkX1+109xFNMP3EBgWLpaMyZb1EnovY1noUKZWgEuCCRrLeDdXQH4tVfnD7G3QttucutbRYArMW++7nUUfd5QV01BnGleRApqxOtaq5ciDt3N9g3QIu+rU+c4TMtLTfCwUJwV47CDF6eS8ZyOXoxNUh+JuZtdGbOC47wf2NQTABEjMdwGuMzF5OqrKdAkRHu5ze1PajCBPRGwixqw1zOW0CBUdU2qFJbjePFV7Y1v1DKzqaw5AaadWmCsQ5KXDblgkqPlg9kwP+HCxPegd5sfYi476dRAbfe26wAfI9+DrsGa7mAsyxbzmeczOBtzjon0yU3p864nqZI/B8zmVd0dmOmKIqUJzExdHVgpAkWHsJLPILVOjdBW0Pii4vqb04KCOvbu0kEOgyn1FpAD2nrJ0pDkZZSI9nyeLr667W1NXPIEzHcPNUny7M8/Wv+Pt+gn5v1VTx7FSVcxc3tPIeNl9DXmj9R6jqsqEUCbRkUjhLs8orRjVP1Zz2FfZHwB3wTF7bpZrOc/6OvhqCGnriF6GNbfQjTPoh9fMJdDbmh/5HAmEsWyQhAL+T76oV06FfF6ukysDdnlnQVhWPSsueWQtYgM7CSad7p8kDA1poAqjvFXs3tFf+1HlQyOCgqbkkXbwg1rfSaa3TzM6CSYi/0+wu+ExwUS0yZQ8S2r2Lm8d1YIFIsNpkqVpbxBu5SEn1Fdj5GcIelbqENIWkGRjbGj7mV55rQeJSYlvZTmZOQbAl3VPYEsby1vLJVabWeQBQpzSjlOFadq3pbk+6YU+2BQVoj4t2rmrexzUsMq9qcEoRD/lRerFhGzYw914GJMmnRhlZu2Ya/RCr/viFQeY8bq8Sd0lzskJPywtSxRGG7jyo5TPqQFksQu8648i1ly3tNwVVIdPE3VoKPSUZIwTPzvxt20+OlYECxzuYXhnunjscDgn2lQDpopZ489TJXWUT9CeNKBGAO/RskL
 jdcFLpyN
 P3u7nUJ4Km+FYSpthl5wo6XnwqfdCgO+7yfSbum10x2SxnccosxwUcmW8sMqG71OtAm519wFIccdFG3iJWfowvZqN17TPs1zrivxnVwrLByCP/8yYoF7pvo2bFEuZCUaCEaRgG/3Suawi5JLHMzHnjn2hl6RJyDJbi3V3kgRLi3hDxzZx9abW5xWDwW54/MRBpoHuABbhaYfFmuNreLcVAZHdXwLGgbVr2xOwXxmUejnx2lKZ4tvQez4gMn9ApSQbRdCw7PdArY7h/Lw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vm_area_unmap_pages() clears PTEs and frees intermediate page table
pages. It does not free the backing physical pages that
xswap_map_clusters() allocated. Those pages were leaked on every
unmap.

Collect the backing pages before the unmap. Walk the page table with
apply_to_existing_page_range() and a small callback that stores
pte_page() of every present PTE into a dynamically allocated array.
After vm_area_unmap_pages() clears the PTEs, free the collected pages
with __free_page().

The array allocation runs under memalloc_noreclaim_save(). Reclaim
must not recurse into the caller, which holds xswap_lock. If the
allocation fails, return -ENOMEM without unmapping, so that no backing
page is leaked.

xswap_unmap_clusters() now returns an error code.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 57 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 7 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index abe3d0ee5aba..e10bb6d245fe 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -67,8 +67,8 @@
 
 static int xswap_map_clusters(struct swap_info_struct *si,
 			      unsigned long start_idx, unsigned long nr);
-static void xswap_unmap_clusters(struct swap_info_struct *si,
-				 unsigned long start_idx, unsigned long nr);
+static int xswap_unmap_clusters(struct swap_info_struct *si,
+				unsigned long start_idx, unsigned long nr);
 static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data);
 static void xswap_try_shrink(struct swap_info_struct *si);
 
@@ -3889,8 +3889,26 @@ static int xswap_map_clusters(struct swap_info_struct *si,
 	return -ENOMEM;
 }
 
-static void xswap_unmap_clusters(struct swap_info_struct *si,
-				 unsigned long start_idx, unsigned long nr)
+struct xswap_page_data {
+	struct page **pages;
+	int nr;
+	int max;
+};
+
+static int xswap_collect_page(pte_t *pte, unsigned long addr, void *data)
+{
+	struct xswap_page_data *xpd = data;
+	pte_t pteval = ptep_get(pte);
+
+	if (!pte_present(pteval))
+		return 0;
+	if (xpd->nr < xpd->max)
+		xpd->pages[xpd->nr++] = pte_page(pteval);
+	return 0;
+}
+
+static int xswap_unmap_clusters(struct swap_info_struct *si,
+				unsigned long start_idx, unsigned long nr)
 {
 	unsigned long start_addr = (unsigned long)si->cluster_info +
 				   (size_t)start_idx * sizeof(struct swap_cluster_info);
@@ -3898,13 +3916,18 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 	/* Round to page boundaries for vm_area_unmap_pages(). */
 	unsigned long vm_start = PAGE_ALIGN(start_addr);
 	unsigned long vm_end = PAGE_ALIGN(end_addr);
+	unsigned long size;
+	unsigned long npages;
+	struct xswap_page_data xpd;
+	unsigned int noreclaim_flags;
+	int i;
 
 	mutex_lock(&si->xswap_lock);
 
 	if (vm_start >= vm_end) {
 		WRITE_ONCE(si->nr_clusters_mapped, start_idx);
 		mutex_unlock(&si->xswap_lock);
-		return;
+		return 0;
 	}
 
 	/*
@@ -3916,13 +3939,33 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 	flush_percpu_swap_cluster(si);
 	synchronize_rcu();
 
+	size = vm_end - vm_start;
+	npages = size >> PAGE_SHIFT;
+
+	noreclaim_flags = memalloc_noreclaim_save();
+	xpd.pages = kmalloc_array(npages, sizeof(*xpd.pages),
+				  __GFP_HIGH | __GFP_NOMEMALLOC | GFP_KERNEL);
+	memalloc_noreclaim_restore(noreclaim_flags);
+	if (!xpd.pages) {
+		mutex_unlock(&si->xswap_lock);
+		return -ENOMEM;
+	}
+
+	xpd.nr = 0;
+	xpd.max = npages;
+	apply_to_existing_page_range(&init_mm, vm_start, size,
+				     xswap_collect_page, &xpd);
+
 	vm_area_unmap_pages(si->cluster_vm, vm_start, vm_end);
-	/* vm_area_unmap_pages() clears PTEs but does not free pages. */
-	/* TODO: free backing pages via page table walk or tracking bitmap */
+
+	for (i = 0; i < xpd.nr; i++)
+		__free_page(xpd.pages[i]);
+	kfree(xpd.pages);
 
 	/* Pairs with READ_ONCE() in shrink/grow paths. */
 	WRITE_ONCE(si->nr_clusters_mapped, start_idx);
 	mutex_unlock(&si->xswap_lock);
+	return 0;
 }
 
 /* Track the end of the run of pages that is already mapped. */
-- 
2.54.0


