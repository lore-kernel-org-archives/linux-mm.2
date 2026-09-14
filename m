Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2518C88E66
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:31:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C9E96B00A9; Mon, 14 Sep 2026 08:31:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 653B86B00AB; Mon, 14 Sep 2026 08:31:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 569066B00AC; Mon, 14 Sep 2026 08:31:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 25ABA6B00A9
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:31:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5443BC02A3
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:34 +0000 (UTC)
X-FDA: 85212303708.15.3EF4EAE
Received: from mta0.migadu.com (out-78.mta0.migadu.com [91.218.175.78])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3E193180018
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CXJ6kh+S;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.78 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qneZs9MCZ4XkU/M09N2Zijn2Sy/9ALPU83jcYPuLBnc=;
	b=3agjG3qo8Tsiu/XFSBKnwExCmXU52F6gNky6fGdInaiXLh2IcX18WoD8ONFMvFpx/a5J6h
	y6MA+ONrTRYbmUlv0+YVwRIZqFflw7r6ZFJ+dTLuGhSxueyNNgNxC9vtDp4XMWTd+eH4d/
	xkc/0WTT02hTEgx2ANXOBmG4M0Ej4Ks=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CXJ6kh+S;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.78 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389092;
	b=hDnIi7XptIXIZ2m1lGrtQA/gLy+JKganOdTeZpqX1G9YOPDlViKrA4ODKRgVxkh4fZASuU
	9pif4zuWQPjxdTN16jFx4FW7AAfBeO5zHixjLdskqntcigUJEIsesMWxo7j2jM+xWFt713
	HO3eGYrs7YojXJ0dr9AUT7dgGImy2os=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gQpqzqvH+WoJJUAO2d/0PD0oFz7Cyx7fYSRyoCuO5m8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389090; v=1; x=1789993890;
 b=CXJ6kh+SZJvkpwQn6i7ieDitU2n1xp6MAEW0sTmVCasjhBE2dAXy5a4FnEG93/5v4529QCs/
 i4zTFAjqAmVpmhYW+xcG2uduI8Y86I5uUh00XmxGaG/x+gsXh6of6eJHMKeCArmvWu7KrCep62E
 K/W+8c1viQVSm3Qkq40ekYUE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id c310bfb2d63ccb74;
	Mon, 14 Sep 2026 12:31:30 +0000
X-Mizu-Trace-ID: c310bfb2d63ccb74
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
Subject: [RESEND v7 13/29] mm: zswap: reject high-order swap cache allocations backed by zswap
Date: Mon, 14 Sep 2026 05:28:03 -0700
Message-ID: <20260914122950.3283997-14-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3E193180018
X-Stat-Signature: cpeksodi9aw7etogzad6usyhxo8jsc48
X-Rspam-User: 
X-HE-Tag: 1789389091-189545
X-HE-Meta: U2FsdGVkX18oszhVAJz5tAZZ0Kol0LNTFTx9HfNH56vsjLfnBVn/HwYZbci0yU+EJU5rnezEoiuIJlUnPJaMAfvC85GSc5mLH7LOHIexXBwmPCRdXpf+dkdEiPUcn9eQnMIYDsS7g1Y1y4qflL3SObnjnjpmpNDLrzX18bng216BsHNXE4t2cVRfkV3aSQDoMG62JWc/mUS/h1A5bcQFt2xfxd7wBfGzSUaq3k/jyNQ5d39L6Xojl5+tDTpeBRb8aiMrjTA3u66hEWiKzAWkviPpYslxnDyiMb+NsW3AKqmNd4Y14AyEv6sJnYfDVqmqljXkYA0Rx+rRa036JjnoGDGDKvT1WNn6a58Pj0Xzv/rQzI1qVcRKVvc1IZlPvnqPDBUs2slAXdXFMOqy6ngXwuYtwnjj5mnuiAPw798UppJQxBayHdc1wovgDYtNsajlJiqwYJ7127iHXb+wqvWUZ9Z0F7janIH4mBKCg0yVJeKI5sJpi/EnXioftlqsewhosQvJVEMdinCC5Eo4KKaVVQBNgkTvJxmo2jemdSCbJN7oxQr/18GmbSSjH+P0AiZChmho85WhjTMtbI1DWc1iokqbhFVSCoFS2Y7C3t6R69oHPBCeTaS0LAJqM0p/cxBp1I777EXNYDetXNYkCKeZAzzFnDtmRjmlpwnPFy7u8upxih09sOCqDq5G7SxCH5xFeo68iZG2M5o+ckZfYFiK0uc3JMvzwiAUfijCDuKjP51RaWW0Y/F8gjQ2Iic8s2/9SADMjkDE36sHKXWk0dr44zvEVJJfd9TmLdArV3fEf1fwVFchBA2Gs6ae/MD8/Lq1v7oh46jrkTwlSIRB5A/yfAk5fRUhjbJyo/RAMALMilxSKDkm7oPpSxJ4oe/SEpE2wBewZ0clcAwExaxv41rzWiO/JYuHtIpWQv0ZkDIVllBnS3LvZiwSs5DyRgo5rAMGU+R5ppbA0XDVjPAdiKC
 dNBmE3Z9
 10TFKkawBEGqKW6RIgjogoDtHcu3Dsooid5Lj9vcnE5vFRzvMdLv8N44GeeaZRMB2t+6qBJI9Cp7JxRombvzhzOMeDRJok2a+toyQoPiSwCR7ot7Pw8shQiPJSwZoaFZldabL0tZJd7CvjxcOF0EPQ2VUFNFKv59eSeEnXL0wF/Tl1uIGIJiP3ZSh1Edqp74eiQuitKpIUVaGL95qODR1tpPQTCOaa1VoYJKYXAvTOR5rZyg=
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


