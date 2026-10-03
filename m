Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45909CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:32:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CDF46B00B0; Fri,  2 Oct 2026 20:32:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37DCC6B00B1; Fri,  2 Oct 2026 20:32:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26D256B00BC; Fri,  2 Oct 2026 20:32:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 04AAC6B00B0
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:32:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7EF541A088A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:32:38 +0000 (UTC)
X-FDA: 85279439196.11.5F42BC5
Received: from mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf16.hostedemail.com (Postfix) with ESMTP id 92217180006
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:32:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790987556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dFHdCIFpR6eiBZ/6Q8EUAiqmG7qqRbnCqbo8usyasfU=;
	b=Bud+0BEWEOaJJXNS1aMkjpZOJfblXhVG5t+zJH6zKBXcvW/gSzKEJWyFBbZQ0IEsugf8i0
	REg9eqBrE7LmvBkkkVg+wOfPWJ+afsgfYHdBZIKMJZ9oFqTi8l3ic6vGbeD+651AOvLWu5
	fD6mUgzAnDakOMddl0MITXtGBHId8MI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790987556;
	b=5F4jjNqtiCi3kX19KrtIDBaMVpMZOltTrXXJYNzsSlBYbmZPTZ51PbzGj2A/ZkOLUiu3W7
	AybUvWba748C+ZfYFrfN08roEvlst+ER1hiVHyNULNsg9Kfv75/JIqNi0SGYKbDxZPBcqs
	VgBLJzAmkaESauEMFZOfny2PVpx7HbQ=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 5c89744b9029ea2d;
	Sat, 03 Oct 2026 00:32:35 +0000
X-Mizu-Trace-ID: 5c89744b9029ea2d
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v4 07/14] mm, swap: free backing pages in xswap_unmap_clusters
Date: Sat,  3 Oct 2026 08:31:29 +0800
Message-ID: <20261003003136.750633-8-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003003136.750633-1-hebaoquan@kylinos.cn>
References: <20261003003136.750633-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: bhhh7xfejy67b6aw9k7hndfhtbq4xfnm
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 92217180006
X-HE-Tag: 1790987556-20842
X-HE-Meta: U2FsdGVkX1/Na0ZHucdGfgppjrO+sq0KmJLtJjDAccylwLrpibT7zLhNRB1eAfLxfTqv+MbsbgMPJq7tB9fljo/LKrP1nPIosOXRNrdvggZzwxJgc1rxPjjEbjx4iyAsUzw1JDtktINLxCTLVZibCMONhsABRndLy+h/UOtlwiRKDpY/8QXkDPVjG2UdG1suPmrVvde+mchDsvybGD4RX89nnUGnDUXfcToMbHsl9ZzTrM8C41+4ZlYYS+cVLEhCxsAdzQnly8/ngiZFqVzxhW5gSg/TitYZgsswUWLGjh65p7Z7W8YHx3T7wEqbpf+3FIoi/CpXxtpS+ifvZiSBKOSPPJypO3boT/t8C7ARPeZ+npQ0hganQhAlYXi9245Xnlo0qMz8oEy4C+Mx63wP39yfSpIOxY9Je5r/nBuDSyqEJByYvXorDgoCXzAbBoc5JbQo/Vl+itc0IIk3eMRvXycKLPMwmbR/qYc3fJw7mPTqeSedaqR1knRiIvdGwTzmzkvFACGcI6SCn2Nl32ynM/5sZWaeGh5GKrliyhnyGqKmYl1vo/3dffvINU/4T/yBL09DwmyVQfnyagRCbx7Ih9g5MaUBUc4gwG3vZJGPX0nSMeR5cAfndyuS+PE/RJY6jv1XBBZYLYYWrJ0zUgmImK32RTc/WBBeD9X0kkzs3jB3ZX5GgZ0xhkgNcR2z5oxFBRKeHLUPwCp1VtU7vxEOd8oWpcKywo3hPOZYV3M503uQ4OvwG/bcCuftkJORH3ePIsSCbrZZdIfzOEAhva7dtrTjiGAKA7ujlIaJx3kPmrDFc+O/EMVvOPqDe3n5qbRz1afyejSIOXZNq+fKA8ohFSbh09B4kq01Rg0phsvq91t+pEXSv12sm7mKa9qhtt1Cj9wxAw4jvoq14i8f5R5Lc8CDVrkk76hnqwDHP9mHuAFQPE+lajROCddq9Nmk3W31g1PTu4TPDqWBzRCXs2o
 QGDm17fC
 kTG8V471t+AyZdbpYYRXcPUIrEB8LLNXIZ9z6NuT8v9Af82r28iKimQMVIMqkjJqrywwqlB0tKT/w1ltHpwhjeN4hZmCSWSoyzek3c0+d9nt2Vrq+xwFLK0dgPh1Aws9VRcHyTJncqIEpRlKhH++y7rbGDJtYW8qkgdaPPvEZsQNd2Lf1vzUU5UrGt5xcBOy2XRVQb1cIpO17tcn0PcqgFSnfiDf8nHG8YYbcVqLTLfg1e4uTSdOx/Oj/Nv0YzCqEWaAFBd4el2X0Xsk3qCJEbmNU4fymy3kLyqIuG0izT+cif4iYqWKQsFWZ1Zqom7RTwW5urO0wF4HR54J2/I0IstYW+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vm_area_unmap_pages() does not free the backing pages that
xswap_map_clusters() allocated, so they leaked on every unmap.

Collect the backing pages from the PTEs before unmapping and free them
after the PTEs are cleared.  The collection array is allocated with
kvmalloc_array(GFP_KERNEL), which falls back to vmalloc() and may
reclaim; if it still fails, unmap in bounded batches with a stack array
instead.  The unmap therefore cannot fail and the callers do not need a
retry loop.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 95 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 86 insertions(+), 9 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index b8572f301d31..7c062e772f5b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -84,6 +84,14 @@
 
 static bool xswap_should_grow(struct swap_info_struct *si);
 static unsigned long xswap_grow(struct swap_info_struct *si);
+
+/* Batch size for the fallback unmap; keeps the stack array small. */
+#define XSWAP_UNMAP_BATCH_PAGES		16
+#define XSWAP_UNMAP_BATCH_CLUSTERS					\
+	max_t(unsigned long,						\
+	      ((XSWAP_UNMAP_BATCH_PAGES * PAGE_SIZE) /		\
+	       sizeof(struct swap_cluster_info)), 16)
+
 static int xswap_map_clusters(struct swap_info_struct *si,
 			      unsigned long start_idx, unsigned long nr);
 static void xswap_unmap_clusters(struct swap_info_struct *si,
@@ -3341,9 +3349,8 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
 			}
 			spin_unlock(&ci->lock);
 		}
-		/* Unmap all mapped clusters and free the VM_SPARSE area */
-		if (si->nr_clusters_mapped > 0)
-			xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
+		/* free_vm_area() drops the mapping without freeing the pages. */
+		xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
 		free_vm_area(si->cluster_vm);
 		si->cluster_vm = NULL;
 		si->cluster_info = NULL;
@@ -4026,21 +4033,65 @@ static unsigned long xswap_grow(struct swap_info_struct *si)
 	return nr_new;
 }
 
+struct xswap_page_data {
+	struct page **pages;
+	unsigned long nr;
+	unsigned long max;
+};
+
+static int xswap_collect_page(pte_t *pte, unsigned long addr, void *data)
+{
+	struct xswap_page_data *xpd = data;
+	pte_t pteval = ptep_get(pte);
+
+	if (!pte_present(pteval))
+		return 0;
+	if (WARN_ON_ONCE(xpd->nr >= xpd->max))
+		return 0;
+	xpd->pages[xpd->nr++] = pte_page(pteval);
+	return 0;
+}
+
+/*
+ * Free the backing pages mapped in [vm_start, vm_end) and clear the PTEs.
+ * @pages must have room for @max pointers.
+ */
+static void xswap_unmap_range(struct swap_info_struct *si,
+			      unsigned long vm_start, unsigned long vm_end,
+			      struct page **pages, unsigned long max)
+{
+	struct xswap_page_data xpd = {
+		.pages	= pages,
+		.max	= max,
+	};
+	unsigned long i;
+
+	apply_to_existing_page_range(&init_mm, vm_start, vm_end - vm_start,
+				     xswap_collect_page, &xpd);
+	vm_area_unmap_pages(si->cluster_vm, vm_start, vm_end);
+
+	for (i = 0; i < xpd.nr; i++)
+		__free_page(pages[i]);
+}
+
 static void xswap_unmap_clusters(struct swap_info_struct *si,
 				 unsigned long start_idx, unsigned long nr)
 {
 	unsigned long start_addr = (unsigned long)si->cluster_info +
 				   (size_t)start_idx * sizeof(struct swap_cluster_info);
-	unsigned long end_addr = start_addr + (size_t)nr * sizeof(struct swap_cluster_info);
+	unsigned long end_addr = start_addr +
+				 (size_t)nr * sizeof(struct swap_cluster_info);
 	unsigned long vm_start = PAGE_ALIGN(start_addr);
 	unsigned long vm_end = PAGE_ALIGN(end_addr);
+	struct page **pages;
+	unsigned int noreclaim_flags;
+	unsigned long npages, idx;
 
 	mutex_lock(&si->xswap_lock);
 
 	if (vm_start >= vm_end) {
 		WRITE_ONCE(si->nr_clusters_mapped, start_idx);
-		mutex_unlock(&si->xswap_lock);
-		return;
+		goto out_unlock;
 	}
 
 	/*
@@ -4052,11 +4103,37 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 	flush_percpu_swap_cluster(si);
 	synchronize_rcu();
 
-	vm_area_unmap_pages(si->cluster_vm, vm_start, vm_end);
-	/* vm_area_unmap_pages() clears PTEs but does not free pages. */
-	/* TODO: free backing pages via page table walk or tracking bitmap */
+	npages = (vm_end - vm_start) >> PAGE_SHIFT;
+
+	/* Reclaim here would re-enter xswap_map_clusters() and its lock. */
+	noreclaim_flags = memalloc_noreclaim_save();
+	pages = kvmalloc_array(npages, sizeof(*pages), GFP_KERNEL);
+	memalloc_noreclaim_restore(noreclaim_flags);
+	if (pages) {
+		xswap_unmap_range(si, vm_start, vm_end, pages, npages);
+		kvfree(pages);
+		WRITE_ONCE(si->nr_clusters_mapped, start_idx);
+		goto out_unlock;
+	}
+
+	/* No memory for the array: unmap in bounded batches instead. */
+	for (idx = start_idx; idx < start_idx + nr; idx += XSWAP_UNMAP_BATCH_CLUSTERS) {
+		unsigned long batch = min(start_idx + nr - idx,
+					  XSWAP_UNMAP_BATCH_CLUSTERS);
+		unsigned long addr = (unsigned long)si->cluster_info +
+				     (size_t)idx * sizeof(struct swap_cluster_info);
+		unsigned long bstart = PAGE_ALIGN(addr);
+		unsigned long bend = PAGE_ALIGN(addr + (size_t)batch *
+					       sizeof(struct swap_cluster_info));
+		struct page *batch_pages[XSWAP_UNMAP_BATCH_PAGES + 1];
+
+		if (bstart < bend)
+			xswap_unmap_range(si, bstart, bend, batch_pages,
+					  ARRAY_SIZE(batch_pages));
+	}
 
 	WRITE_ONCE(si->nr_clusters_mapped, start_idx);
+out_unlock:
 	mutex_unlock(&si->xswap_lock);
 }
 
-- 
2.54.0


