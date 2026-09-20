Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03748C982D8
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 07:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D27596B009E; Sun, 20 Sep 2026 03:21:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0836B009F; Sun, 20 Sep 2026 03:21:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC6516B00A0; Sun, 20 Sep 2026 03:21:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C51B6B009E
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:21:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E1409A5C0D
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:21:35 +0000 (UTC)
X-FDA: 85233295350.01.C4C2B75
Received: from mta1.migadu.com (out-128.mta1.migadu.com [95.215.58.128])
	by imf19.hostedemail.com (Postfix) with ESMTP id 027C81A0003
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:21:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.128 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789888894;
	b=Iy84W85Ge77POzsxs0hxfBxnP4z+Oo8ziwlcntYPVvGCYhQMfKoLyeq74DanHrSF7fg4/w
	1pCZRgIGLqKte51/76hB9BU3+KdWUBSKL2BZXr1ZXXsU0Bz5Ko6UkiKnFFvzYlGW6K+d6J
	hPEP7yBrrmEF+xyyOYqWogsvyASvpbg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.128 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789888894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ggLKBDw7UHNFvKutgFGAbu1sg3DzBro04qv+5qChFPg=;
	b=0el1to5SiIP68M6xSbGGp2yGdcA6hce0HpwX030AUHgkOoyrvkVlInfRxXbduL3JMMX6KX
	tBwSTdY+nX3Z1raKbzGTnIzTQRon3hEYF/ZfcSlb8t8PCzcTBQWCs93iUUH3xVh2voexzY
	Klg5Nycp0bBcUknvgFbqGeIfX+ZycqY=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 5d14e7371db17aa6;
	Sun, 20 Sep 2026 07:21:32 +0000
X-Mizu-Trace-ID: 5d14e7371db17aa6
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
	david@kernel.org,
	kunwu.chan@gmail.com,
	baoquan.he@linux.dev,
	gourry@gourry.net,
	riel@surriel.com,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC PATCH 07/17] mm, swap: support swapoff of an xswap physical backend
Date: Sun, 20 Sep 2026 15:20:33 +0800
Message-ID: <20260920072043.430390-8-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260920072043.430390-1-hebaoquan@kylinos.cn>
References: <20260920072043.430390-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 027C81A0003
X-Stat-Signature: m7yh6nw6apuoon4mokg5sixn9mtjgxxz
X-HE-Tag: 1789888893-174961
X-HE-Meta: U2FsdGVkX19N9qViEEa7v2jf/24DSO8cjvEnnh2knO5l7ESlN8pLdMsEY49JLpIBr4p9PCWND6+Bmhad3z79hahr5734c2kwdRtDlWoKLcoZQGGCnrORWBHleVogbhjCfGt5cff5aau2zaOL59qWeTer+hy9JYuJ2dAIhiHF0xk5XkrgwAI/oCxMyuVhZnUO44hI51v8IEYSyOyZkkdpOULuG9pcH6AO41pJu7PsslixZWh9mYFL9hh4yjkuvKadDgQQKllmUhqTD5inX4/2H6KHfrjDllK8qD0EkMrWFRdVVBk4i4u9e+eCYUrwkyOqLrYqG9tbd6UMha9p3Q/u/IUIHLQ7Z7t5Kwdl9Hwf0qAr+V12aMm/OGJsAEmgEHAhawjUzmFBHOuB6i24LzGpKvUErxuu53SkLhsk7Nc1MOHTGuXlocRxy/UqL3lkHsGKpkVjUVYi2qzNKeuCcHc3vn4puLWT7fHQgTrDTiCt8Zqm/zUx/7fLO3CvxKPLoEJT6bB5mAT9t/a12brRpFvcr8yxbqDQWGuz065MTguNF/4X5jfyqtPeIVyzTk3PzTYKR7NVkCygH/9zoKG4v979d1KcWRl79tsBY4VV0ROtmENdLUxAgiXW9BxlymvJQ+aIx2I41BcZNE8AWFrfc9XpXWGvbGjDiMDsUevmX2bPRwv6vL303pLAFRFkhoHpgU4Bmp1gopXGFG0XUm+0bP7F5dfQQM5I6sj2EE/aLwi4OhZEEWWzXJR7tKlHoNDuHVI6QiFGsj8evpjSwCzCGDpC+SmQwWzuC/fjmxyjc7epG/RsMvJtKW22M22zL3v7ha+R2hhyui6K3936zdyT7Wj+3wM5Xz4HOO49C9amNqrB6pDOTG1EG/J0mq2ts7H+HjP1nL4D9SmAPI/WDQ1MxtlZqwnjBdVCjyS530wqY+7VDBWPub7zmJ9BYWXDT5SO9g7kVhSotq8Ngd5wUJr/gEs
 gWY/mlj5
 WEAbPe4AJt0LyAlRG5KcgXIiKqhaA32X6o+lUguRFIIX6qrWXdRoKv7l03Dbx9yFd5sCiWH7Ly3G+V5ZpnMc+MAwhuGayfUpdZTXOud7bU2sShD5TR48nVY2f4YffxVpMAbwmW0jZbSNB/OlUb6CJHW168slFy4b57qYqoOefx+H94Y6Z3LvnqMPJbN2PzJzi0B7vX7sJmT1Gr8r+J3em9hU+IKsKuHKlDx+e2DhlBfKq9Y5Kky+mOUmxtioFPAHXWjdMwZDRg5C+V0VqesmmgmJxW+uLLdqkjnfSd1vwjq7OALo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

swapoff of a real swap device iterates its slots through try_to_unuse()
and reads each one back into memory. A slot that was written back
from an xswap entry has no folio in the swap cache, so the loop
skips it and the slot is freed without ever reading the data. While
the xswap entry will keep pointing at a slot that no longer holds
anything.

Now change try_to_unuse() to analyze such a slot through its reverse
mapping: bring the folio back, mark it dirty so that reclaim stores it
into zswap again, and only then drop the backend.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 97 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 96 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 7b44458472a1..9afccdc03845 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -44,6 +44,7 @@
 #include <linux/suspend.h>
 #include <linux/zswap.h>
 #include <linux/plist.h>
+#include <linux/swap_ops.h>
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
@@ -3138,6 +3139,96 @@ static void xswap_release_slot_backend(struct swap_info_struct *si,
 		xswap_free_phys_slot(psi, entry, phys);
 }
 
+/*
+ * A written-back slot has no folio of its own here, so the unuse loop would
+ * skip it. Resolve it through the reverse mapping and free both sides.
+ */
+static int xswap_unuse_rmap(struct swap_info_struct *si, unsigned long offset)
+{
+	struct swap_cluster_info *pci, *xci;
+	struct swap_info_struct *xsi;
+	struct swap_io_ctx ctx = {};
+	struct mempolicy *mpol;
+	struct folio *folio;
+	unsigned long swp_tb, xoff;
+	swp_entry_t xentry, phys;
+
+	phys = swp_entry(si->type, offset);
+
+	pci = swap_cluster_lock(si, offset);
+	if (!pci)
+		return 0;
+	swp_tb = __swap_table_get(pci, offset % SWAPFILE_CLUSTER);
+	if (!swp_tb_is_pointer(swp_tb)) {
+		swap_cluster_unlock(pci);
+		return 0;
+	}
+	xentry = xswap_rmap_to_entry(swp_tb);
+	swap_cluster_unlock(pci);
+
+	xoff = swp_offset(xentry);
+
+	/*
+	 * Pin the owner before reading its cluster_info:
+	 * free_swap_cluster_info() only unmaps that after killing si->users.
+	 * No owner left means the slot is dropped below.
+	 */
+	xsi = swap_type_to_info(swp_type(xentry));
+	if (!xsi || !(xsi->flags & SWP_XSWAP) ||
+	    xoff >= READ_ONCE(xsi->nr_clusters_mapped) * SWAPFILE_CLUSTER ||
+	    !get_swap_device_info(xsi))
+		goto out_free;
+
+	/*
+	 * Bring the data back before the slot goes. A dirty folio is what
+	 * reclaim stores into zswap next time.
+	 */
+	folio = swap_cache_get_folio(xentry);
+	if (!folio) {
+		mpol = get_task_policy(current);
+		folio = swap_cache_alloc_folio(xentry, GFP_HIGHUSER_MOVABLE,
+					       BIT(0), NULL, mpol,
+					       NO_INTERLEAVE_INDEX);
+		if (IS_ERR(folio)) {
+			put_swap_device(xsi);
+			return PTR_ERR(folio) == -ENOMEM ? -ENOMEM : 0;
+		}
+		swap_read_folio(&ctx, folio);
+		swap_read_submit(&ctx);
+		folio_lock(folio);
+	} else {
+		folio_lock(folio);
+	}
+
+	if (folio_matches_swap_entry(folio, xentry)) {
+		folio_wait_writeback(folio);
+		if (unlikely(!folio_test_uptodate(folio)))
+			swap_cache_del_folio(folio);
+		else
+			folio_mark_dirty(folio);
+	}
+	folio_unlock(folio);
+	folio_put(folio);
+
+	/* The slot is going away, so our record of it is stale either way. */
+	xci = swap_cluster_lock(xsi, xoff);
+	if (xci) {
+		if (xswap_slot_backend(xci, xoff % SWAPFILE_CLUSTER).val == phys.val)
+			WRITE_ONCE(xci->xs_table[xoff % SWAPFILE_CLUSTER], 0);
+		swap_cluster_unlock(xci);
+	}
+	put_swap_device(xsi);
+out_free:
+	/* Leaving the mapping in place would make the unuse loop spin. */
+	xswap_free_phys_slot(si, xentry, phys);
+	return 0;
+}
+#else
+static inline int xswap_unuse_rmap(struct swap_info_struct *si,
+				   unsigned long offset)
+{
+	return 0;
+}
 #endif /* CONFIG_XSWAP */
 static int try_to_unuse(unsigned int type)
 {
@@ -3197,8 +3288,12 @@ static int try_to_unuse(unsigned int type)
 
 		entry = swp_entry(type, i);
 		folio = swap_cache_get_folio(entry);
-		if (!folio)
+		if (!folio) {
+			retval = xswap_unuse_rmap(si, i);
+			if (retval)
+				return retval;
 			continue;
+		}
 
 		/*
 		 * It is conceivable that a racing task removed this folio from
-- 
2.54.0


