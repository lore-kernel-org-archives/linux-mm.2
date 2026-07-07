Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 977B1C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 08:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B1226B00AF; Tue,  7 Jul 2026 04:27:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63B776B00B1; Tue,  7 Jul 2026 04:27:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 503806B00B2; Tue,  7 Jul 2026 04:27:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 208436B00AF
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:27:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A4E501C3372
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:27:20 +0000 (UTC)
X-FDA: 84961301040.19.B01915A
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id D3F82C000D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:27:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DGZZjplH;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783412839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gozPqlohPzHMzky6X0UHxWSkHReQK7p56E2rZcCLooQ=;
	b=i8fzt+PAFJ5OtZEMKsmKJnUIHfhwPJi+cxNxGGh45h13vB0EdPua2ZkNhK6km7WsXzXE87
	FdhDZazaty3A6ki8Ps8jKiRFyI4hKGdFi5ff199tS/YuwBPkPGtU+B5YF6DEs36LxbjOGO
	dk0BM2uLOOA/HoCHsu2qk3y3TiWJd7g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DGZZjplH;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783412839;
	b=i7fOlUAI15AGlT/m3jK4m21Cd/nSw2tBsEF7Ac56zb4WzHGpJHGJs7XBGZu4QLkZJ4HIur
	N4Fn8ghB1q0z0JYnCo/OWdeodxmUPz0qx4sRbeJa1pcTOoGfqwXLA6Nlx0UixReHTAe+qI
	jTJJLkO+z2kFgdrNzMK9YxD9Sg6JZpI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783412837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gozPqlohPzHMzky6X0UHxWSkHReQK7p56E2rZcCLooQ=;
	b=DGZZjplHesAoUb55/bOlTDZ/QtYu+pGcmAWzLDkQPhEf/lSj/C+BXPdmak1XO5zajuXPnN
	gkI9GW8jStsZv9X6lE43GLrtjjuHwBXEGJiTgpiviNMCVz5b+gpCDPreXUCwXsfS3x3/9T
	ZwA1pHdsCocDYuKY+NgZls+pptEl4Iw=
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
Subject: [RFC PATCH 06/10] mm/zswap: implement ghost-to-physical writeback for backend switching
Date: Tue,  7 Jul 2026 16:26:08 +0800
Message-ID: <20260707082614.95030-7-baoquan.he@linux.dev>
In-Reply-To: <20260707082614.95030-1-baoquan.he@linux.dev>
References: <20260707082614.95030-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D3F82C000D
X-Stat-Signature: uixktqibhp84chf9ahehmxmg1w8ojq4h
X-HE-Tag: 1783412838-381442
X-HE-Meta: U2FsdGVkX1/ObqxjhIYuqJ8fQQ3hfa0v7fSo/5/dGKNf7Q5fLq4AoGbpMTHY2vIwIOgJNDqahkxC8KXtXKtGK7ZnNYwzPeCnfpH01AWL8YUwEZswJVtYaDye2LwQRff4l9tTZ0c5esyYjSjrYIqFHZUPyp3Q7BcC0JgHn1xUhXodRNeMueE/4mYj6Y9cjjYApvieDCZgFm8tCKN3L4G2DrW/98jipnOTXxZ13yZQm504T+biVMGa4h/R+XoQ6TKmR+QijB/7Z1/mBeZ9uPqADRFkgC9XZR5QQ50fLrjAvFFI4FjPe2DgxX24kPLr3+v2YtsnXeNvRCa49tgtXaCcXTuEA9gbeyr39j8yuCpZxE+xo3oAg/unQdcDPNpSBGOyLspUtBR1eIQl14hKrFVSltIN3CO0FK3lvbPVejnhYL8jS7Xa9LV3X4U5M7sYPIVgG7OkV09gQRSGaHPCOk95Sj8xjqhKV2YZoMlhVFnkPewqjG8mNVTUFNAmLdQyFly5k5IeglGUyhBDuau1neZ80soXEXqIe6UmsxXOrWMoOunOT0e4wWUEgw3g/NRLeg5BnHLNALQk69oRgs3UOiHjX+HXWjpwVf7AyX1KaMh4x8D6EyK2hdP+EJGMW2flLvrfZTUZlZffA7t2fy7Wj3LMvzOrit5N3RiMMfOWhKY98fWByhbhGKprqbTJd+ZqURriv281VmCo14rKpQlzw/aCUiJc/sO7x/yViINOSOLRxw8ksz3rK0t4uyVex+6ltL25cWzPtfIbSnfNQ/7e5W9rbYbNEeHtb0r47yiacUJJ1hTv+UCjw97tycHKOSN+ZbnJ2YlYQ/ls+olKSI/J5Jzmv040boaDm7CNeAZciCJc7qf/qZQfZSSdzigVo/s78dIv5dXKR6Pxh32fTwrypGTOartBAFkYXuGKLCO/Ra+m/HizmULXrYhlJo/Otks+u2lt+gelEBLFZYQQImjFOlX
 VbF8rwWM
 mvHH+Od7lwmIxSePvImoNTk63vtlWt3/TIzidNy53qX6wYqbhBRt1ZCypvaES3mTRI8kQxv/xoTND1UbITDz9a2TH0lrtschuPs+DqAiCHlDIBhOVqDNtOy4oPQiZcLJZ/UY4yADwVKcYTStbs9+PgUrY8sac/ZtdJsj2Ro957HfNjhOLbsU1atiACeGB2wQzqoZi1+PDb92naMSVuDEAd4DnEAbdebT8he94nffNco2heD54EbKUgRKoTRzm1Jmw2f6hE7SaWmPQl2vRWKSQU43SkOGDJ+ylIj7GzypLwKKJUDg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add zswap_writeback_ghost() to handle zswap writeback when the
backing swap device is a ghost swapfile (SWP_GHOST).  Previously,
writeback for ghost entries was rejected with -EINVAL.

The new writeback path:
1. Allocates a physical swap slot from any real swap device via
   alloc_phys_swap_slot().
2. Creates a swap-cache folio attached to the ghost swap entry.
3. Decompresses the zswap entry into the folio.
4. Stores the ghost->physical mapping in the ghost's redirect_xa.
5. Temporarily redirects folio->swap to the physical entry and
   calls __swap_writepage() to write to the physical device.
6. On success, the xarray mapping persists.  When the swap-cache
   folio is later removed, __swap_cache_do_del_folio() restores
   the Redirect entry from the xarray.

This enables the backend switch from zswap (compressed in memory)
to physical swap (on disk) without changing the PTE — the PTE
continues to point to the ghost swap entry, and the swapin path
forwards the I/O via the Redirect entry.

Modify zswap_writeback_entry() to call zswap_writeback_ghost()
for ghost-backed entries instead of returning -EINVAL.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/zswap.c | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 91 insertions(+), 5 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index bdf8283fd880..2137e8f14413 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -978,6 +978,90 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
  * the swap cache, the compressed version stored by zswap can be
  * freed.
  */
+/*
+ * Ghost swapfile writeback: allocate a physical swap slot, decompress
+ * the zswap entry into a swap-cache folio, write it to the physical
+ * device via __swap_writepage, and set up a Redirect entry on the
+ * ghost swap table so future swapins are forwarded to the physical
+ * device.
+ */
+static int zswap_writeback_ghost(struct zswap_entry *entry,
+				 swp_entry_t swpentry,
+				 struct swap_info_struct *ghost_si,
+				 pgoff_t offset)
+{
+	swp_entry_t phys_entry;
+	struct folio *folio;
+	struct mempolicy *mpol;
+	swp_entry_t saved_entry;
+	int ret = 0;
+
+	/* Allocate a physical swap slot from a real device */
+	phys_entry = alloc_phys_swap_slot();
+	if (!phys_entry.val)
+		return -ENOMEM;
+
+	/* Create a swap-cache folio attached to the ghost swap entry */
+	mpol = get_task_policy(current);
+	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
+				       NO_INTERLEAVE_INDEX, NULL);
+	if (IS_ERR(folio)) {
+		ret = PTR_ERR(folio);
+		goto free_phys;
+	}
+
+	/* Decompress zswap data into the folio */
+	if (!zswap_decompress(entry, folio)) {
+		ret = -EIO;
+		goto del_folio;
+	}
+
+	count_vm_event(ZSWPWB);
+	if (entry->objcg)
+		count_objcg_events(entry->objcg, ZSWPWB, 1);
+
+	zswap_entry_free(entry);
+
+	folio_mark_uptodate(folio);
+	folio_set_reclaim(folio);
+
+	/*
+	 * Store the redirect mapping in the xarray so it persists
+	 * across swap-cache PFN cycles.  The swap table currently
+	 * holds a PFN (the swap cache folio); when the folio is
+	 * eventually removed from swap cache, the Redirect entry
+	 * will be restored from the xarray.
+	 */
+	xa_store(&ghost_si->redirect_xa, offset,
+		 xa_mk_value(phys_entry.val), GFP_ATOMIC);
+
+	/*
+	 * Write the folio to the physical swap device.  Temporarily
+	 * redirect folio->swap to the physical entry so
+	 * __swap_writepage uses the correct bdev and sector.
+	 */
+	saved_entry = folio->swap;
+	folio->swap = phys_entry;
+	ret = __swap_writepage(folio, NULL);
+	folio->swap = saved_entry;
+
+	if (ret) {
+		xa_erase(&ghost_si->redirect_xa, offset);
+		goto del_folio;
+	}
+
+	folio_put(folio);
+	return 0;
+
+del_folio:
+	swap_cache_del_folio(folio);
+	folio_unlock(folio);
+	folio_put(folio);
+free_phys:
+	free_phys_swap_slot(phys_entry);
+	return ret;
+}
+
 static int zswap_writeback_entry(struct zswap_entry *entry,
 				 swp_entry_t swpentry)
 {
@@ -994,11 +1078,6 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	if (!si)
 		return -ENOENT;
 
-	if (si->flags & SWP_GHOST) {
-		put_swap_device(si);
-		return -EINVAL;
-	}
-
 	/*
 	 * Verify the swap table Pointer entry still references this
 	 * zswap_entry. If the entry was invalidated or replaced by a
@@ -1015,6 +1094,13 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	}
 	spin_unlock(&ci->lock);
 
+	/* Ghost swapfile: write back to a physical swap device */
+	if (si->flags & SWP_GHOST) {
+		ret = zswap_writeback_ghost(entry, swpentry, si, offset);
+		put_swap_device(si);
+		return ret;
+	}
+
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
 				       NO_INTERLEAVE_INDEX, NULL);
-- 
2.54.0


