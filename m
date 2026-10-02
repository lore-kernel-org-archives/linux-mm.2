Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8BB4CA5FE0
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:56:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EDBF6B00B0; Fri,  2 Oct 2026 05:56:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 277886B00B1; Fri,  2 Oct 2026 05:56:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A3A16B00B2; Fri,  2 Oct 2026 05:56:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D0A256B00B0
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:56:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6181FC06C9
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:52 +0000 (UTC)
X-FDA: 85277232264.07.FFCAA11
Received: from mta1.migadu.com (out-42.mta1.migadu.com [95.215.58.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id 726DF40004
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hT7ZBoeB;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.42 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790935010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qneZs9MCZ4XkU/M09N2Zijn2Sy/9ALPU83jcYPuLBnc=;
	b=kKyDXLoQqOyzMnVGVkY5IQKi1F2dLxQgDLW0f7cz1U5bKYhgEZ1n4mQE6V9NXoynqMtSpo
	2nBvf94RBRzRLapcfeyP2F21j2gEh+oz0vKT8L7VbeKipTXExFFC1a1ESPx/OyPwy1T4+u
	VjWkHcqvVWcNEUy5RZQlsxCFftCMS6c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hT7ZBoeB;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.42 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790935010;
	b=C3pDoepfGXj4JYc2mvM4AgulH9hRbC7cj3EliJnzZOm62pDZlTVH8R0YSUtsddvtzKSuE+
	/ZieabvjUHt72TFlkq3Lk//dQxlru6EeBftyASuV3h1k8PXAOFWCKWrVc25umFUaLBGRWg
	fAuE3bskNBtMnu1bbEO5OLjPh4VEC68=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gQpqzqvH+WoJJUAO2d/0PD0oFz7Cyx7fYSRyoCuO5m8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790935009; v=1; x=1791539809;
 b=hT7ZBoeBkmehWhPkafR/QcmGwTklDjIlRZdJuEunTAP8LNAYoGJLklix5Udm4tQDcVJUjk3D
 R/IO0sNlgN5jGmEMWRD8CEMTSkRYRlb94bKn9e8jS6x+6YsWNPYFccg9vfEc56vtxjAwOfSwczP
 NIkgg+ckghuIDDI15CIipL1Q=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 02f13886deba9360;
	Fri, 02 Oct 2026 09:56:49 +0000
X-Mizu-Trace-ID: 02f13886deba9360
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v8 14/30] mm: zswap: reject high-order swap cache allocations backed by zswap
Date: Fri,  2 Oct 2026 02:52:28 -0700
Message-ID: <20261002095503.3585565-15-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 726DF40004
X-Stat-Signature: 7nfm4nm6n55g6mmdtn7c7xxqdt19pfj8
X-Rspam-User: 
X-HE-Tag: 1790935010-285340
X-HE-Meta: U2FsdGVkX18iXxvtFNU37uMeNT2wThZ99lWOp3xcLL5uPdDq4VmFTsuVZgb9pttSwtPldq/JCqVLpZ3wm/Vsn/kx2QnqQmNBK9zGK75/uKwfCYSU7givor3gwFjcPvd/hkIXx4fQFzJrjlxF9a5U2S5kyNfXrU+uYCPoffE4eIqOqWR7P2UvBCy4RO+4J5K26vWyi/+lcJVDxPktvm5KqFm9FygaCS2YeQIxCrENV/tQCl4ZLsmJS3ovZ1W6+VOscgG+DyDEfti4Ea+DtqMJaTxYkwiiwRR9W32lh+fm9tuFxZcr5WvTCQuWe0adqDDELsjoQ/R594pKDX5PbwA9phPstpxuAFfli5WKp5afqeMsb9gWP9McieOpYRZKOh8cvhTaQpRiGjZmFmzM8jxY1lQRgYpKUYyX1V0HetHVjwHyNFD3zKppB41ChZqaTnyXto9WFtbcjZT+FX7Qere3wKuaOR/6j6NufCbr5xbHcxpdJbUUuhoyjCtaoB9wSB4O0ntPzPRYu5y40NMvXI8o6lyGYNld65jUvtdq1KGfZyCkl2EvmK2wLftOmFdBQT7HjfmaIflblby47oFyEE5Heuh+z6kIpC4SuX1mAKZB+qdverzYRWOHC3y4GfWDs817xQ3c4odYHtMENIb2E1jpzggQNQI4pywZSmVxejCffVS6ExxeGhv6DPl9Qg/8krLuGDfmQZQdcKuWE8qqA2bEu1pz7iPAZ1T4DJ8hfgo1AjHBAf57OxxaPR/Tu+CmAe4mWY1BI1hE47SEtiOZqBlGtmGNOt2uyuqybgAlB+pAVURemp0r5U0mWaC/M9PrJXuIxSCdVEObAuSbSmepBpymhKn+rXWuYAe+lQzoM5ITI4vjcWVw7u72VqYlhW9Ov3FIgrIILT3rmYetahB/+geJpCt1hPQnjMdGTefaQE3ksXB1pCTQu6OGAANqYESEyq2dvUYPrM35QLQdiCJ958q
 8rj33ENz
 SD0Zwms4NVRl748R5WpDUi6NScsq1K1IXRqUcqgI3EVJlCp+LqbF0Xj0/b2JuhpsyCNs4/gek71iCt10JIYTOgds/vVWf418Jy4STyi6YY+ss+vmT+y9EY/YHPHNaoZIP9DtqCVkwMD39yiKAJdnfls29s0C23ZQT2uqprAHy4Cbv5nR32057p3XV9IlnJedjnD7uyim3ndARRAtw55GMCe7JcRuS1wUhE341vELNUxLEQD4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap stores swapped-out pages one at a time, so a range of swap slots can
be split between zswap entries and the backing device. A high-order
swap-cache folio over such a range cannot be read back in one go: the disk
read would return stale or zero data for every slot zswap owns.

Reject that in __swap_cache_alloc(). Do the check after the folio is in the
swap cache: from that point zswap can neither start storing nor start
writing back any slot in the range, so the answer is stable. Callers
already fall back to order-0, which zswap_load() handles per page.

Export zswap_is_present() for the PMD-order swap-in users added later.

Co-developed-by: Alexandre Ghiti <alex@ghiti.fr>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/zswap.h |  6 ++++++
 mm/swap_state.c       | 39 +++++++++++++++++++++++++--------------
 mm/zswap.c            | 12 +++++++++---
 3 files changed, 40 insertions(+), 17 deletions(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index df6cafbe95dc0..94746fb71bb65 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
 bool zswap_is_enabled(void);
 bool zswap_never_enabled(void);
+bool zswap_is_present(swp_entry_t entry, unsigned int nr);
 #else
 
 struct zswap_lruvec_state {};
@@ -73,6 +74,11 @@ static inline bool zswap_never_enabled(void)
 	return true;
 }
 
+static inline bool zswap_is_present(swp_entry_t entry, unsigned int nr)
+{
+	return false;
+}
+
 #endif
 
 #endif /* _LINUX_ZSWAP_H */
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 625c185a1ca4d..251b48b2c60e1 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -12,6 +12,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/mempolicy.h>
 #include <linux/swap.h>
+#include <linux/zswap.h>
 #include <linux/leafops.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
@@ -466,26 +467,27 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 	__swap_cache_do_add_folio(ci, folio, entry);
 	spin_unlock(&ci->lock);
 
+	/*
+	 * Now that the folio is in the swap cache, zswap can no longer start
+	 * storing or writing back any slot in the range, so this is a stable
+	 * answer. Reject a high-order allocation over a range that already
+	 * has per-page zswap entries.
+	 */
+	if (order && zswap_is_present(entry, nr_pages)) {
+		err = -EBUSY;
+		goto delete_folio;
+	}
+
 	if (mem_cgroup_swapin_charge_folio(folio, memcg_id,
 					   vmf ? vmf->vma->vm_mm : NULL, gfp)) {
-		spin_lock(&ci->lock);
-		__swap_cache_do_del_folio(ci, folio, entry, shadow);
-		spin_unlock(&ci->lock);
-		folio_unlock(folio);
-		/* nr_pages refs from swap cache, 1 from allocation */
-		folio_put_refs(folio, nr_pages + 1);
+		err = -ENOMEM;
 		count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK_CHARGE);
-		return ERR_PTR(-ENOMEM);
+		goto delete_folio;
 	}
 
 	if (order > 1 && folio_memcg_alloc_deferred(folio)) {
-		spin_lock(&ci->lock);
-		__swap_cache_do_del_folio(ci, folio, entry, shadow);
-		spin_unlock(&ci->lock);
-		folio_unlock(folio);
-		/* nr_pages refs from swap cache, 1 from allocation */
-		folio_put_refs(folio, nr_pages + 1);
-		return ERR_PTR(-ENOMEM);
+		err = -ENOMEM;
+		goto delete_folio;
 	}
 
 	/* memsw uncharges swap when folio is added to swap cache */
@@ -499,6 +501,15 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 	/* Caller will initiate read into locked new_folio */
 	folio_add_lru(folio);
 	return folio;
+
+delete_folio:
+	spin_lock(&ci->lock);
+	__swap_cache_do_del_folio(ci, folio, entry, shadow);
+	spin_unlock(&ci->lock);
+	folio_unlock(folio);
+	/* nr_pages refs from swap cache, 1 from allocation */
+	folio_put_refs(folio, nr_pages + 1);
+	return ERR_PTR(err);
 }
 
 /**
diff --git a/mm/zswap.c b/mm/zswap.c
index 507f2d19fd2a4..f5b5827d30084 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1587,11 +1587,14 @@ bool zswap_store(struct folio *folio)
  * @entry: base swap entry of the range
  * @nr: number of contiguous slots to check
  *
- * Context: The caller must keep the range pinned, otherwise the answer can
- * change under it.
+ * Context: Unless the caller keeps the range pinned, the answer is only a
+ * hint: zswap can store or write back a slot right after this returns. A
+ * caller that needs a stable answer must pin the range first, as
+ * __swap_cache_alloc() does by inserting the folio into the swap cache before
+ * asking.
  * Return: true if at least one slot in the range is in zswap.
  */
-static bool zswap_is_present(swp_entry_t entry, unsigned int nr)
+bool zswap_is_present(swp_entry_t entry, unsigned int nr)
 {
 	pgoff_t offset = swp_offset(entry);
 	struct xarray *tree = swap_zswap_tree(entry);
@@ -1605,6 +1608,9 @@ static bool zswap_is_present(swp_entry_t entry, unsigned int nr)
 	 */
 	BUILD_BUG_ON(SWAPFILE_CLUSTER > ZSWAP_ADDRESS_SPACE_PAGES);
 
+	if (zswap_never_enabled())
+		return false;
+
 	return xa_find(tree, &index, offset + nr - 1, XA_PRESENT);
 }
 
-- 
2.53.0-Meta


