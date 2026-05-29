Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1798BCD6E43
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 12:19:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CBE66B009D; Fri, 29 May 2026 08:19:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32ACB6B009E; Fri, 29 May 2026 08:19:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1308B6B009F; Fri, 29 May 2026 08:19:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE7646B009D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:19:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B1FBA1C1135
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:19:43 +0000 (UTC)
X-FDA: 84820363446.30.F244B0D
Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	by imf12.hostedemail.com (Postfix) with ESMTP id 35E9B4000B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:19:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=b2rQp72g;
	spf=pass (imf12.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.87 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780057181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nDsGZbWSvOF3obvNlWe9iRNaS8HxvEtyxSV9cL2PYxY=;
	b=2Ujg+0UmVzNesq23rNOxxGNrXq1kSsU5QC/lUSb/XyD1J3z0PwlPVZxYV8UCbqA/GlTLCG
	L5yiYeTU7YcmeOvq8PzJINB5iRR7Kx2KgUwpBNMSdkK1Fzb8VNIiBl1wSFLQzbH0+rnfmv
	1HD2FPm+oV+UN5CMElPAKlX2R3IlGRs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=b2rQp72g;
	spf=pass (imf12.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.87 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780057181; a=rsa-sha256;
	cv=none;
	b=4Y6vO03SyJgg5xTsuCw2K6R+m+UlEGMMQJF3CQKubtG4JQJ9tAgMp7dxru4wSpc9CunZFL
	sLRwFnTXQXNA4e0IuEu6u9zv+sZSy6dOxRTQHFTkNt8Brp9zlwBxv1KO+jr1XwsAjVBSoj
	BbEFDxy6ApuOG+24H/t0GCwVnJXBXc0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1780057177; bh=nDsGZbWSvOF3obvNlWe9iRNaS8HxvEtyxSV9cL2PYxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b2rQp72gSuGbPSzdH0Zpbp0BHKMYb9JNXAS64KX2g8gNpcybfkVjKIAC0F+q0KAqy
	 NLrSbRjhg3lvo31hcDCBFqC8BYYLiKoswF4hcv9xJnOPfRK95lz1coDJBIfjpke3rU
	 7aHMURWZ/FMJ8R9biYS5YiwvUjnzBy+recWfqQpU=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 4DC10017; Fri, 29 May 2026 20:19:28 +0800
X-QQ-mid: xmsmtpt1780057174txygo7p0f
Message-ID: <tencent_EB78848E34DC7858C873193D67286ECD4B0A@qq.com>
X-QQ-XMAILINFO: M2SvzgchpLqfOoNEbAiJkRB8duAu+hjJoUl9Si4GM4H2cgFZGLV6zbPHlxKEsa
	 6Llk5KmrboO8QkCi9+MjUpV4XtHw7OxB0j1dTCB2wROWoZcF0hUfsiLNZUXno/R/40OliDIRo6LR
	 ncP8tLRIARrkJEjo6U9A+lg97PVOwRDi7mAwBTUbglLI2hhXLezDN3vKDrGOoN9aRjBCQDJ7C0+7
	 OfIVszyzD7QKPBf2ScZiyGEiLtuE5X/DmHhxb8+999pYjhnkd4Q9MeYxcvweChIXROGDnloJEORd
	 ZXY4H5CirLavW87XX2zBRCKvUPCMvhQHEjiBmA7kcYCHyyx3nU0ZqxqQUJPhJ9IpjFZO8g/JhugO
	 5uxr0YTIfk0Y64FJ4paz85qwnDTpENDnfM5D5+4rp0u0xt48LuGUETujUfuwDjWUyb2TnHlQMmQu
	 cRjwZB7MdDgSWML5UnXxw9EmdVVKWP9ihfgG13MgUetZb7b/Eitu6iKm3jYfdcBJhmenYJwxzNZO
	 qhYHEzIA6FJ7o6Yn3hGtoGVCY1+a0hBWTiapwGCewo89htBbQuNgJr8MA7/61nW6zCj0Rl0x2YOA
	 0cAp+Ta6znmLxyLAleKSaFXXn1w/kmeLpjAanKcwzDao5vOLTLeevhbTDWP/uOZlcaEhqZcdFALd
	 dgXqwV+fnNn39KhmoskAJsO3yYOXmD//SVPtiYxkbTN0QPbRRaOYUfcshoiP+LgqlAXXKIavtIfT
	 aiVstxGOWk7cjlhD2F9Yhk53HNwFMU0RsNG4SThh0VmvE3FVkFnmziN174aZtaMT+wt+oF9/FeWO
	 YIqQihGNFIIeohCUUeeCaMq7UruOc//+HtxNe/gJyzipTsN2aVoUVDmL1J8MbbLYAMVkn3EYjD4j
	 nJKX4X+GqTlDdXz74lRqXDsqbpRhQikRehJp7S9UNm74hVwoUzXdpPUShqklrREExwAY6EBjjJua
	 nTE+iSEW0/rB/FJGCYyeuKl0ofpRGfnWOy+L2zzpkuiEoiaoUv0vOmWSNTVKwz0l/k4CSNKfdMbC
	 Em7Qh3Y4bWyGxh/SogHslxF5U/TzisZIeny5psaPupSq+A9F+IupHp+UK15aM=
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
From: fujunjie <fujunjie1@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Alexandre Ghiti <alexghiti@meta.com>,
	Kairui Song <kasong@tencent.com>,
	Usama Arif <usamaarif642@gmail.com>
Cc: Chris Li <chrisl@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 4/9] mm: admit large swapin by backend range in swapin_sync()
Date: Fri, 29 May 2026 12:19:23 +0000
X-OQ-MSGID: <20260529121928.4115683-4-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
References: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mn6jm9c9ekpmcts4tjjp8ufugsi67fr1
X-Rspamd-Queue-Id: 35E9B4000B
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780057180-253433
X-HE-Meta: U2FsdGVkX18UjL6zgDK1wn02uUJRrLMVNG/p1YM0oAeyEij0VcoDzOAEx1Igq1tWFU2DW0v+wLbjv0JgxBXg5bkb2VP5ajIQ5Qomw9GW/32ovWzGNRqS8D/v9WVPGm+xRX4Uo1V3lELgT3GNVEPKp7PGkkhRWEnuWPkbfHz4AR4uLu8oREBwyXLOkE9FHOkJsHQR/b/cmBhv4jQsPJhUP3kQ0+5iuY1LSujm0F1YgnD/m8jjYIGUW1hmrrEEhXo7FYt9YJOYeWFCJFUIUZSl1Ei46CgcR6pQouOvSF28gaz+oKu0W22oeVrseoyarEKU+c0PPzbAU3NJ/sHgtxjm1RbvP7Z+bX4gzo4/sb/8vygYVYH6tQ2SdEFQGzAUgzMBtegWaDy1vIZo0A7v9ijzrjTZNralEkcsp+LZRCEMZcJo0nCM7+qimOF84x3uIQCyZXRQ2mot9aRsKirOUHSlEcDo28IVwDXLHTbLJ1ZlNQitL+tZ48kbjlq2AXEQK4wWNnIy1XEstaV8Wb0xSfQ7c2eVkKyCF5rUBCThsLRzZYIJyhdRmU4UpsKFy1tqOBzxkYVSzesXSwu2U7iEbBY2DjTv2YBWGo9PIfIk+Y8glnFJXI5FYNZV7Un/2McOwYWpli1IYcIaz3MYxrSB5riCUDm32KWgbCPPxZyqYpWydCofXnKaIKzYnEnWOvdOlRSWKqSQtcmi0pnV1J95VaS55Gj+Tw341lKP1sq+8eSvyqRY4+A4SqGbW8z4F6GjKCY0n9zhCH0O4W282d5vo8iUP1CrDzBUaxksWrI2HPKA/3FFyL+Nc6DfyX9Lq0GaXhXfjv+Zbu8UzVWvz08loJj93EMXvkaAcfY+TK7mt7XFqnLEbQ7sYmWFvzc6Y2Jl3rM63tPRYCkb/3DL0wh7rR7Ngc0Nu1E0XUeCXV4s3xhT+5Ue+KiZlZR7dZ7nN5/YVZGn6oh/lN4LZdv+TUS/TwU
 xIfdZncp
 jIpaq/wTvLnVD/tIZX+yeq3f28j5Lk13Y0uneBi9iZEDI77w53d9/M0qlsWit2EngFRr6smY3ct7PePQ4GHkW1Qv2yg2f6cDtABYa/A/THAEcJktB1970nDxkvsCDiS+V/QatZXir6g2pJY1uuhTZ9IH1moFiQxqsMGyQFaMk50d/SYaDEYHM1VSq3qspVApZ5IC++SuYUeyV6qTzDuoJXeDVy6cf6EuNxa7FxDEftizW/VxQIZUMTUvS/pHS/qphVQBIrtsxa23uUqSGNZgmOkuBrdwXUaRWxMC8HjFrKhPtIizaS8O9LvP9IHxciww15ojtMkiujFACVvQvv0G4vxtPByjyU3+q1fm+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A large swapin can only read one folio when the whole range has compatible
backing. Mixed zswap/disk ranges must not reach large-folio IO, and zswap
range probes are only snapshots.

Filter the orders passed to swap_cache_alloc_folio() in swapin_sync().
Uniform zeromap ranges and all-disk ranges keep the existing large swapin
path. Fully zswap-backed ranges may be tried. Mixed zswap/disk ranges fall
back before allocation.

After a large swapcache folio is installed, recheck the zswap range and
drop the fresh folio if it became mixed. Also consume -EAGAIN from
swap_read_folio() the same way. Both cases retry order-0, where each slot
can resolve its current backend independently.

Signed-off-by: fujunjie <fujunjie1@qq.com>
---
 mm/memcontrol-v1.c |   8 ++-
 mm/memory.c        |  31 ++++++++-
 mm/swap_state.c    | 169 ++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 194 insertions(+), 14 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 765069211567..5b11b8055c66 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -682,8 +682,8 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
  * memcg1_swapin - uncharge swap slot on swapin
  * @folio: folio being swapped in
  *
- * Call this function after successfully adding the charged
- * folio to swapcache.
+ * Call this after the charged folio has been added to swapcache and the caller
+ * is no longer going to drop it back to swapped-out state.
  *
  * Context: The folio has to be in swap cache and locked.
  */
@@ -721,7 +721,9 @@ void memcg1_swapin(struct folio *folio)
 	id = __swap_cgroup_clear(ci, swp_cluster_offset(folio->swap),
 				 nr_pages);
 	swap_cluster_unlock(ci);
-	mem_cgroup_uncharge_swap(id, nr_pages);
+
+	if (id)
+		mem_cgroup_uncharge_swap(id, nr_pages);
 }
 #endif
 
diff --git a/mm/memory.c b/mm/memory.c
index 5a365492a9a2..d73a19692dea 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4538,6 +4538,24 @@ static inline bool should_try_to_free_swap(struct swap_info_struct *si,
 		folio_ref_count(folio) == (extra_refs + folio_nr_pages(folio));
 }
 
+static void memcg1_swapin_retry_folio(struct folio *folio,
+				      struct vm_fault *vmf)
+{
+	if (!folio_test_large(folio) || !folio_test_swapcache(folio))
+		return;
+
+	if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT) {
+		if (!folio_trylock(folio))
+			return;
+	} else {
+		folio_lock(folio);
+	}
+
+	if (folio_test_large(folio) && folio_test_swapcache(folio))
+		memcg1_swapin(folio);
+	folio_unlock(folio);
+}
+
 static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
 {
 	vmf->pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
@@ -4857,8 +4875,10 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 
 	swapcache = folio;
 	ret |= folio_lock_or_retry(folio, vmf);
-	if (ret & VM_FAULT_RETRY)
+	if (ret & VM_FAULT_RETRY) {
+		memcg1_swapin_retry_folio(folio, vmf);
 		goto out_release;
+	}
 
 	page = folio_file_page(folio, swp_offset(entry));
 	/*
@@ -5067,6 +5087,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (unlikely(folio != swapcache)) {
 		folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(folio, vma);
+		if (folio_test_large(swapcache))
+			memcg1_swapin(swapcache);
 		folio_put_swap(swapcache, NULL);
 	} else if (!folio_test_anon(folio)) {
 		/*
@@ -5076,6 +5098,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		VM_WARN_ON_ONCE_FOLIO(folio_nr_pages(folio) != nr_pages, folio);
 		VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
 		folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
+		if (folio_test_large(folio))
+			memcg1_swapin(folio);
 		folio_put_swap(folio, NULL);
 	} else {
 		VM_WARN_ON_ONCE(nr_pages != 1 && nr_pages != folio_nr_pages(folio));
@@ -5132,8 +5156,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 out_page:
-	if (folio_test_swapcache(folio))
+	if (folio_test_swapcache(folio)) {
+		if (folio_test_large(folio))
+			memcg1_swapin(folio);
 		folio_free_swap(folio);
+	}
 	folio_unlock(folio);
 out_release:
 	folio_put(folio);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index d37097913b30..f03ad4832f16 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -21,6 +21,7 @@
 #include <linux/migrate.h>
 #include <linux/vmalloc.h>
 #include <linux/huge_mm.h>
+#include <linux/zswap.h>
 #include <linux/shmem_fs.h>
 #include "internal.h"
 #include "swap_table.h"
@@ -403,7 +404,8 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 					swp_entry_t targ_entry, gfp_t gfp,
 					unsigned int order, struct vm_fault *vmf,
-					struct mempolicy *mpol, pgoff_t ilx)
+					struct mempolicy *mpol, pgoff_t ilx,
+					bool defer_memcg1_swapin)
 {
 	int err;
 	swp_entry_t entry;
@@ -466,7 +468,8 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 	}
 
 	/* memsw uncharges swap when folio is added to swap cache */
-	memcg1_swapin(folio);
+	if (!defer_memcg1_swapin || !order)
+		memcg1_swapin(folio);
 	if (shadow)
 		workingset_refault(folio, shadow);
 
@@ -495,9 +498,12 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
  * Return: Returns the folio if allocation succeeded and folio is in the swap
  * cache. Returns error code if failed due to race, OOM or invalid arguments.
  */
-struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
-				     unsigned long orders, struct vm_fault *vmf,
-				     struct mempolicy *mpol, pgoff_t ilx)
+static struct folio *__swap_cache_alloc_folio(swp_entry_t targ_entry,
+					      gfp_t gfp, unsigned long orders,
+					      struct vm_fault *vmf,
+					      struct mempolicy *mpol,
+					      pgoff_t ilx,
+					      bool defer_memcg1_swapin)
 {
 	int order, err;
 	struct folio *ret;
@@ -512,7 +518,8 @@ struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
 
 	do {
 		ret = __swap_cache_alloc(ci, targ_entry, gfp, order,
-					 vmf, mpol, ilx);
+					 vmf, mpol, ilx,
+					 defer_memcg1_swapin);
 		if (!IS_ERR(ret))
 			break;
 		err = PTR_ERR(ret);
@@ -525,6 +532,124 @@ struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
 	return ret;
 }
 
+struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
+				     unsigned long orders, struct vm_fault *vmf,
+				     struct mempolicy *mpol, pgoff_t ilx)
+{
+	return __swap_cache_alloc_folio(targ_entry, gfp, orders, vmf,
+					mpol, ilx, false);
+}
+
+static struct folio *swap_cache_alloc_speculative_folio(swp_entry_t targ_entry,
+							gfp_t gfp,
+							unsigned long orders,
+							struct vm_fault *vmf,
+							struct mempolicy *mpol,
+							pgoff_t ilx)
+{
+	/*
+	 * Speculative large swapin may drop this fresh swapcache folio and
+	 * retry order-0 after backend or page-table revalidation. Keep the
+	 * cgroup v1 memsw swap owner until the caller commits the folio.
+	 */
+	return __swap_cache_alloc_folio(targ_entry, gfp, orders, vmf,
+					mpol, ilx, true);
+}
+
+static bool swapin_zeromap_same(swp_entry_t entry, unsigned int nr_pages)
+{
+	unsigned int ci_start = swp_cluster_offset(entry);
+	struct swap_cluster_info *ci = __swap_entry_to_cluster(entry);
+	bool is_zero;
+	unsigned int i;
+
+	if (ci_start + nr_pages > SWAPFILE_CLUSTER) {
+		VM_WARN_ON_ONCE(1);
+		return false;
+	}
+
+	rcu_read_lock();
+	if (!rcu_dereference(ci->table)) {
+		rcu_read_unlock();
+		return true;
+	}
+
+	is_zero = __swap_table_test_zero(ci, ci_start);
+	for (i = 1; i < nr_pages; i++) {
+		if (is_zero != __swap_table_test_zero(ci, ci_start + i)) {
+			rcu_read_unlock();
+			return false;
+		}
+	}
+	rcu_read_unlock();
+
+	return true;
+}
+
+static unsigned long swapin_admit_orders(swp_entry_t entry,
+					 unsigned long orders)
+{
+	unsigned long candidates = orders & ~BIT(0);
+	unsigned long admitted = orders & BIT(0);
+	int order;
+
+	if (!candidates)
+		return orders;
+
+	while (candidates) {
+		enum zswap_range_state state;
+		unsigned int nr_pages;
+		swp_entry_t range_entry;
+		bool admit = false;
+
+		order = fls_long(candidates) - 1;
+		if (order > MAX_PAGE_ORDER) {
+			candidates &= ~BIT(order);
+			continue;
+		}
+
+		nr_pages = 1U << order;
+		range_entry = swp_entry(swp_type(entry),
+					round_down(swp_offset(entry), nr_pages));
+		if (!swapin_zeromap_same(range_entry, nr_pages))
+			goto next;
+
+		state = zswap_probe_range(range_entry, nr_pages);
+		switch (state) {
+		case ZSWAP_RANGE_MIXED:
+			break;
+		case ZSWAP_RANGE_ALL_ZSWAP:
+		case ZSWAP_RANGE_NEVER_ENABLED:
+		case ZSWAP_RANGE_NO_ZSWAP:
+			admit = true;
+			break;
+		}
+
+next:
+		if (admit)
+			admitted |= BIT(order);
+		else
+			count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK);
+		candidates &= ~BIT(order);
+	}
+
+	return admitted ? admitted : BIT(0);
+}
+
+static bool zswap_needs_order0_retry(struct folio *folio)
+{
+	if (!folio_test_large(folio))
+		return false;
+
+	/*
+	 * Admission sees only an advisory zswap snapshot. Recheck after the
+	 * large swapcache folio is installed; if the range became mixed, drop
+	 * the fresh folio before IO and let order-0 handle each slot.
+	 */
+	return zswap_probe_range(folio->swap, folio_nr_pages(folio)) ==
+	       ZSWAP_RANGE_MIXED;
+}
+
 /*
  * If we are the only user, then try to free up the swap cache.
  *
@@ -634,7 +759,8 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
-		folio = swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);
+		folio = swap_cache_alloc_folio(entry, gfp, BIT(0), NULL,
+					       mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR_OR_NULL(folio))
@@ -677,18 +803,43 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
 	struct folio *folio;
 	int ret;
 
+	orders = swapin_admit_orders(entry, orders);
+again:
 	do {
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
-		folio = swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
+		folio = swap_cache_alloc_speculative_folio(entry, gfp, orders,
+							   vmf, mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR(folio))
 		return folio;
 
+	if (zswap_needs_order0_retry(folio)) {
+		count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN_FALLBACK);
+		/*
+		 * The folio is newly allocated, locked, clean and not uptodate;
+		 * no data has been read into it. Removing it only restores the
+		 * swap table entries so order-0 swapin can resolve a backend
+		 * race without attempting speculative large-folio zswapin.
+		 */
+		swap_cache_del_folio(folio);
+		folio_unlock(folio);
+		folio_put(folio);
+		orders = BIT(0);
+		goto again;
+	}
+
 	ret = swap_read_folio(folio, NULL);
-	VM_WARN_ON_ONCE(ret == -EAGAIN);
+	if (ret == -EAGAIN) {
+		count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN_FALLBACK);
+		swap_cache_del_folio(folio);
+		folio_unlock(folio);
+		folio_put(folio);
+		orders = BIT(0);
+		goto again;
+	}
 	return folio;
 }
 
-- 
2.34.1


