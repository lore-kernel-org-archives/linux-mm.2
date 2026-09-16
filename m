Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC78EC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 10:20:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC2CF6B00A0; Wed, 16 Sep 2026 06:20:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9BDB6B00A1; Wed, 16 Sep 2026 06:20:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8A0B6B00A2; Wed, 16 Sep 2026 06:20:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D1606B00A0
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:20:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2CAEBA06A1
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:20:57 +0000 (UTC)
X-FDA: 85219232154.07.E7C72DD
Received: from mta0.migadu.com (out-37.mta0.migadu.com [91.218.175.37])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4515AA0004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:20:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.37 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789554055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wl12UwdksHO6VKkr4N1yqJYdOqSJmjH2BtpoHB/+n7c=;
	b=cCMnT1OFFD4CxQQhrTtWybGbQUNzO7vmL57Ck/F3t+RyzuieIv/c5Y8yXfIARHGZVkd1J2
	ExmZ8+xvZQDurBrnCQIM85nAPawy9uLwBiTqC9z5TAxGYmiB0k/zt0kvElDSxGXMsRGQ80
	DKMhh53o8vy+akY9u3ANQ5zpqAvpO+c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789554055;
	b=WbQlThHXDVzZEahByA4RG4aOU6G+7cQt/MuWNeA/HqcJPnLdcBcBN58IjwfyLN+7iPDJpx
	DjvBbuu5+GZFQtdHJ6WiAmim3fpbUYykvQzbb6fno82f/EhzoArm2mQU1Cx68p5kKzp2RX
	GQTTXIAG/rl8K9/8UWw0oJVRfdpLB5k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.37 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 3cf0af0f25f6a445;
	Wed, 16 Sep 2026 10:20:54 +0000
X-Mizu-Trace-ID: 3cf0af0f25f6a445
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
	kunwu.chan@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v3 08/14] mm, swap: free backing pages in xswap_unmap_clusters
Date: Wed, 16 Sep 2026 18:19:15 +0800
Message-ID: <20260916101929.149106-9-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916101929.149106-1-hebaoquan@kylinos.cn>
References: <20260916101929.149106-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: c56sra7is1ofr51ubwrgh39yes887444
X-Rspam-User: 
X-Rspamd-Queue-Id: 4515AA0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789554055-138136
X-HE-Meta: U2FsdGVkX18kdkvx5kRe700qIIFzhhq0jxtKqZ5VMJmQvp0Ec1ZfUp+MhQ55uVgxH1NnFY8tgn5aR4Gcqkd+K9HacLm7jlpKfO8Inq/U+pJS8osdtv7bjdOM2mIuuxfNOfGeZ37EZtF1ECfnyD8YqwRmYOA/dMH+E6c2svk/hlXCPmd/ajfhEkcOivmTdntRYWzk+12ODhdD8hUj70FRzryf/DEbc4WCtxmBA7UmYbJJIQh6nFsM0n2SWuu+WyaOSSR5gvlzJgRIncNty7PfDlzpm7cMhSVytkBi+tc1Ru9B35WyyvXSqPKKA0VDPZD8xfW1EaG8rnDI3eA/LuzneqmWs2c1ikuPE39m7nlrZ2Zu0a7qrTuE6TfMEtsFAv/+Dys+deR34rSBhsL5j7qCSrChxbG8YooLtR4C/q1bCEXpzgRlxJcwNAuSl+/fcGSnDH07uybYhW7OjVWyOu8pXCyku4/C7iihd2wHnMxQTHaVthmyPwIYIzwSQLTN5j7sRCPYmzjcbkFmngaQ9qdT9A0G9EqyWbzv6ZND/R8UUtaT5tgxScGO51R6xw/83fu236tGvWp3Hm2MjVtI4mHuNew+IZJ2O6QSP8UDRM93wR9cdzTKIH8P1Sa5N0VpgT5BjR7MRQe3f9q/slZqasGX0KqaRpfI3djlDc/qiiqNZn1y+hHoyqxBg3wRrHWqGcyGn2whslPxHs/k31QOZai7rqwtvXp2kCnK4ncKdk3mIxyCzSmhEY8JGkcwvcxyWNg4FDMeTut1agSQ/Z4SiGLgNw0P7Z0YiBZzFusx/B4q/adV/hsR6tjX4blAfqBnzRt7n6SXrGyqhYR2vRijPerPTc+YPiOuzCSs0x0sxIK+UJjhjGf+kgFIuAcLE2UFj9isCQ/R6C4JfmvkFXxJtcue0FwC7xs0PEDjobf6kd000VfWQvKPHL2Is/MKorNsDyI/eMLZj+fctAvUjfqGwOo
 oYhrbIej
 6/K55vh0g4J0ih1c3cRWIPuVtq4ypct1bQlPkzmxYW6mJ40ctPrFkcC3GK7IzErf1lW1XuTj4+0doeSmcO5dhccVaUJmgw4MaF7zhps3jHUhhrA3ySdZzag9EScXBWadO48O7ORJnnoBKY6I32+C7dAb1It7+Rut1ocYFDhwIBZrAkFiCMDhEytzAk6nqmpE6/2NdGlISXZ8LMtPEihbExdn8rcAuXpHfhunUubDUQBE6BO7b+DqFw/uZdalqBL/QmfYNIWwHeCXou9j92oQGyY80ErsokkJtk5jadJDOMU0QJlvPvtJXe0OVjJJS2S0Our0g7ygVJxy258XL7gArYYAcDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vm_area_unmap_pages() does not free the backing pages that
xswap_map_clusters() allocated, so they leaked on every unmap.

Collect the backing pages from the PTEs before unmapping and free them
after the PTEs are cleared. The collection array is allocated under
memalloc_noreclaim_save(); on failure, return -ENOMEM without unmapping.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 76 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 65 insertions(+), 11 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 2a03b13c0ed2..5b31aacb3ec5 100644
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
 
@@ -3343,9 +3343,14 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
 			}
 			spin_unlock(&ci->lock);
 		}
-		/* Unmap all mapped clusters and free the VM_SPARSE area */
-		if (si->nr_clusters_mapped > 0)
-			xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
+		/*
+		 * free_vm_area() drops the mapping without freeing the pages,
+		 * so the unmap has to succeed first.  Retry; its only failure
+		 * is a transient -ENOMEM while collecting the backing pages.
+		 */
+		while (si->nr_clusters_mapped > 0 &&
+		       xswap_unmap_clusters(si, 0, si->nr_clusters_mapped))
+			cond_resched();
 		free_vm_area(si->cluster_vm);
 		si->cluster_vm = NULL;
 		si->cluster_info = NULL;
@@ -3988,21 +3993,44 @@ static int xswap_map_clusters(struct swap_info_struct *si,
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
 	unsigned long end_addr = start_addr + (size_t)nr * sizeof(struct swap_cluster_info);
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
@@ -4014,12 +4042,32 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
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
 
 	WRITE_ONCE(si->nr_clusters_mapped, start_idx);
 	mutex_unlock(&si->xswap_lock);
+	return 0;
 }
 
 /* Track the end of the run of pages that is already mapped. */
@@ -4152,7 +4200,13 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 		return 0;
 
 err_unmap:
-		xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
+		/*
+		 * Retry until the unmap succeeds.  Its only failure is a transient
+		 * -ENOMEM while collecting the backing pages.
+		 */
+		while (si->nr_clusters_mapped > 0 &&
+		       xswap_unmap_clusters(si, 0, si->nr_clusters_mapped))
+			cond_resched();
 err_free_vm:
 		free_vm_area(si->cluster_vm);
 		si->cluster_vm = NULL;
-- 
2.54.0


