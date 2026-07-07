Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C64F5C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 08:27:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A33546B00A7; Tue,  7 Jul 2026 04:27:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BD7F6B00AA; Tue,  7 Jul 2026 04:27:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AE8F6B00AB; Tue,  7 Jul 2026 04:27:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 614956B00A7
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:27:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E7B3C8D165
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:27:05 +0000 (UTC)
X-FDA: 84961300410.28.D69C871
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf04.hostedemail.com (Postfix) with ESMTP id 244CC40007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:27:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nAaGzpYt;
	spf=pass (imf04.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783412824;
	b=FoFDtuE9I/jEL1KGpUovLB+Kian+pAmmAtw5Y/beMq1DOpvYbKCTyIrmmQInfS/mFpa3S+
	uKM1bDAme3ZpTWv3MY0nAq0gvvQ0+6UObggFAeDNY8+DawNJ5w0OIHL48JnTkGt5wvdnel
	avan6+cSTqazL8SgDe+mSdRWWmCqavY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nAaGzpYt;
	spf=pass (imf04.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783412824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uQRdyB2exQMY8PjLdMUY7qkNzm0fh5pDFz3uMFxFwug=;
	b=8X7XvV5Z8Sov3grFf9atRFwlVVJVxAYVihCmhymIMkrd2lWeT8I1WApxeFCBxw9ypKj92f
	TSnUKtrWnBwJHwDcvOBTCROKMKXqdxcWfrmA+9TBDhrfQU+aclTV1Eu5fSMRxZ1ZBjLs4l
	CqCud3MXauA6+ge9jlNeDUhRB9bQGY8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783412822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uQRdyB2exQMY8PjLdMUY7qkNzm0fh5pDFz3uMFxFwug=;
	b=nAaGzpYtXVbuVCg1xHEwqljL7JZSkxz5bpsy87hpaI4WHtkeVjevFYFzsP8SnOW2PEmE2V
	wsak8lJbptKJq15tIWoZ5QRS3T4LWoNgF2fPTRvmvs8mHe9pNAJHMbXcLvLkkQIm/Qx0t3
	3bN8ERwhbXsL3lrpddbkdfWBz38v8pg=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH 04/10] mm/swapfile: implement ghost redirect helpers and free-path cascade
Date: Tue,  7 Jul 2026 16:26:06 +0800
Message-ID: <20260707082614.95030-5-baoquan.he@linux.dev>
In-Reply-To: <20260707082614.95030-1-baoquan.he@linux.dev>
References: <20260707082614.95030-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 244CC40007
X-Stat-Signature: ecpib3hfbge3g5c1bpytk5u5kmjwmsj7
X-HE-Tag: 1783412823-232272
X-HE-Meta: U2FsdGVkX1+2Zg8neqRAJNBVCR04pMbMxcCjETi0uP7awQkgOTUHcnlzfjfpeC3MHZgYjo9U3O32b59UmLrp2Vd1uTKDik3F6qGYJ5wqgoFNcn10Hr08TjpSKYo3ZNPr3s0upMZrTF+NGQ6GkUZQlsqrXTpRTAPRJnj9Mlf3tZSrvjwh5HXXnQFdrc4o0yeb5LaCNC4wymWzCzC7K7What/qT4uGPaM1n9TFxGrjq+wtIVi/BKHoXSeDMc2La22UYjJwLII8xqBinmwMs8FV6j6XrrMf9u1A4ZzPjs4ql4pX3C9xP0m5F7tVJWcCdZELV19giH9REzgLMRKuTKf4V0gGR1ADbXsZoALSMv/rL/WMtNJCKgcd3iEcZuiSQtllw/Aj2gZdNlsqrVRNUCFYdTolE036nM+q/9eVY255yHXk3UO/pBh1S9o2Cy2RK6Dlk91yurwfTb+IgF7ke8fVsFqMFkRlj20yhVerJOjcICYmJPrOn3zS1z6vloEtqOR2nSQxc60AgYzMwU6n+wkCoFfoL7IBu0kaziTPGlVmpzLgWjXhT/o4qZcQytV0B+eDufyuu21XgzEnz+x/Vw8mNxTk77JcpMcEoYyCkCsulRW86leTnq6qHKG2FY3kAmvHYhDDoYP+XK4nn6wR8IC6PWGdSxHSR9UnUniHJX3Kfnfb/DTwVc3oQtfcvPhCHXOVqDkP0MhMqhliI/764W8F4yaGYf4YKF3hg4N9WdIZ0nJWNLXt5iMOMr/irtIpKW7kPb/tP6Fc32NGV/qayclJkemP2F7+bX2rGCRJX6qAg12pkjMWNidACu7KChKvA77tV9wFXJe1xibX/kAzv7xCOJgIuYED6aoH68JvWMzJjmpng9s3oR/vnehLBtDOMcYBKYhwM0j42DI7qDo8jnIJvRLZwhPH5RaLe2AklhRJ3EFRK1PA1c4fMExGMIdbHJd+BQiMwQj1qgdY40toc0Q
 ZX9vtb81
 iYCwu4i/orzwqAhFg64ugsxecT2WSRfBDk3a/pPaZCtcDMMREWJXYPIPBCpBiifGX8ULAF22mwFVmvWqCWY78JmuhPuwEcbwZMB5Rf0k1ophYqlZB6EOdTq8Sp0LMdCCXIV7JW+1A1a8eT1WYEn0M3CuRqE7b3r47fzHpulnFd24DxkFmOQFTGz9jO80pW9ZAzliGZVKzKbB3BOU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the core infrastructure for ghost swapfile backend switching:
- alloc_phys_swap_slot()
- free_phys_swap_slot()
- ghost_redirect_to_phys()

Initialize redirect_xa in read_swap_header() when a ghost swapfile
is detected (file size == PAGE_SIZE).

Handle Redirect entries in __swap_cluster_free_entries(): when a
ghost entry with a Redirect is freed (swap count reaches zero),
erase the xarray mapping and cascade the free to the physical
swap slot.  Also skip zero-flag clearing for Redirect entries
(they carry no zero flag).

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/swapfile.c | 107 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 105 insertions(+), 2 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 148ceb2d812b..c1686c2b2521 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/kernel_stat.h>
 #include <linux/swap.h>
+#include <linux/xarray.h>
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
 #include <linux/namei.h>
@@ -1975,7 +1976,14 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 		 * means zswap has a compressed copy; the xarray still
 		 * holds the entry and zswap_invalidate will free it.
 		 */
-		if (swp_tb_is_pointer(old_tb)) {
+		if (swp_tb_is_redirect(old_tb)) {
+			swp_entry_t phys_entry;
+
+			phys_entry = redirect_to_swp_entry(old_tb);
+			xa_erase(&si->redirect_xa,
+				 ci_off + cluster_offset(si, ci));
+			free_phys_swap_slot(phys_entry);
+		} else if (swp_tb_is_pointer(old_tb)) {
 			VM_WARN_ON(zswap_swp_tb_get_count(old_tb) > 1);
 			/*
 			 * Free the zswap entry now under ci->lock while
@@ -1990,7 +1998,8 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 
 		/* Resetting the slot to NULL also clears the inline flags. */
 		__swap_table_set(ci, ci_off, null_to_swp_tb());
-		if (!SWAP_TABLE_HAS_ZEROFLAG && !swp_tb_is_pointer(old_tb))
+		if (!SWAP_TABLE_HAS_ZEROFLAG && !swp_tb_is_pointer(old_tb) &&
+		    !swp_tb_is_redirect(old_tb))
 			__swap_table_clear_zero(ci, ci_off);
 
 		/*
@@ -3593,6 +3602,7 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 		/* Ghost swapfile */
 		si->bdev = NULL;
 		si->flags |= SWP_GHOST | SWP_SOLIDSTATE;
+		xa_init(&si->redirect_xa);
 		return maxpages;
 	}
 
@@ -4006,6 +4016,99 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 }
 #endif
 
+#ifdef CONFIG_ZSWAP
+/*
+ * Ghost swapfile redirect: physical swap slot allocation for writeback.
+ *
+ * Allocates a single order-0 swap slot from any real (non-ghost, writable)
+ * swap device.  Used by zswap writeback to obtain a physical destination
+ * for ghost-backed entries.
+ */
+swp_entry_t alloc_phys_swap_slot(void)
+{
+	struct swap_info_struct *si;
+	unsigned long offset;
+	swp_entry_t entry = {};
+
+	spin_lock(&swap_avail_lock);
+	plist_for_each_entry(si, &swap_avail_head, avail_list) {
+		/* Skip ghost or non-writable devices */
+		if (si->flags & SWP_GHOST)
+			continue;
+		if (!(si->flags & SWP_WRITEOK))
+			continue;
+		if (!get_swap_device_info(si))
+			continue;
+
+		/* Try to allocate one slot */
+		offset = cluster_alloc_swap_entry(si, NULL);
+		put_swap_device(si);
+		if (offset && offset != SWAP_ENTRY_INVALID) {
+			entry = swp_entry(si->type, offset);
+			break;
+		}
+	}
+	spin_unlock(&swap_avail_lock);
+
+	return entry;
+}
+
+void free_phys_swap_slot(swp_entry_t phys_entry)
+{
+	struct swap_info_struct *si;
+	unsigned long offset;
+	struct swap_cluster_info *ci;
+
+	si = get_swap_device(phys_entry);
+	if (!si)
+		return;
+	offset = swp_offset(phys_entry);
+	ci = swap_cluster_lock(si, offset);
+	if (ci) {
+		/*
+		 * Clear the physical slot.  The swap count should be 0 at
+		 * this point (the ghost entry's count has been transferred
+		 * or freed).
+		 */
+		__swap_table_set(ci, offset % SWAPFILE_CLUSTER,
+				null_to_swp_tb());
+		swap_cluster_unlock(ci);
+		swap_range_free(si, offset, 1);
+	}
+	put_swap_device(si);
+}
+
+/*
+ * Resolve a ghost swap offset to its physical backing entry.
+ * Checks the swap table first (for Redirect entries), then falls
+ * back to the xarray (for entries that have a swap-cache folio).
+ */
+swp_entry_t ghost_redirect_to_phys(struct swap_info_struct *si, pgoff_t offset)
+{
+	struct swap_cluster_info *ci;
+	unsigned long swp_tb;
+	void *val;
+
+	/* Fast path: check the swap table for a Redirect entry */
+	ci = __swap_offset_to_cluster(si, offset);
+	spin_lock(&ci->lock);
+	swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
+	if (swp_tb_is_redirect(swp_tb)) {
+		swp_entry_t phys = redirect_to_swp_entry(swp_tb);
+		spin_unlock(&ci->lock);
+		return phys;
+	}
+	spin_unlock(&ci->lock);
+
+	/* Slow path: look up the persistent xarray mapping */
+	val = xa_load(&si->redirect_xa, offset);
+	if (val && !xa_is_err(val))
+		return (swp_entry_t){ .val = xa_to_value(val) };
+
+	return (swp_entry_t){};
+}
+#endif /* CONFIG_ZSWAP */
+
 static int __init swapfile_init(void)
 {
 	swapfile_maximum_size = arch_max_swapfile_size();
-- 
2.54.0


