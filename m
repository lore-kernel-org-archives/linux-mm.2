Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1178C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:27:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17AFC6B00EC; Mon, 13 Jul 2026 13:26:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00E716B0121; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA2DB6B0124; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8C59D6B00ED
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F70DC13F5
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:26:58 +0000 (UTC)
X-FDA: 84984433716.22.707A491
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2FB3620006
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:26:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ql3he0TL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783963616;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2PXF0UHurup8RVu5ycSwgz4vRRTInfHQ02pvcoOrc/0=;
	b=bmIiS6dJsPr75SsG+4LBShqoRzq77MekaVOuW2+oNrkKJo4+tkBa3UvVCVxWQa27NPhjay
	FTXocdaeAHaR2GOYx7PlkPo5n6Xta2CWwdXgsKrW2EgNovhhiiiInycCoAnT/1B2uRnniM
	3A/cmZ0kzdvxFUfUz4saTvCyD7OqaFg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ql3he0TL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783963616;
	b=xQkAqR4Uu/KQoRSt09yNgGRviSbVSL7ka2vN7SYTs/RTRtOOZDBlGCCpRvn2+EduQ/1T0F
	DvHlQOkElUWitfpi1jfQ7lHj20T4eMvzRQivPIks9xGBXkR5XxUOh2HXlzuv9kPqdJu+FF
	Tnn5nDQUJGV81K+lEDTqD6VUFlAwIEk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A988960254;
	Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5DEE3C2BCFB;
	Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783963615;
	bh=WqTYjdOGaZHRxMbAxfndXOIkYayJUYR6EirK7bK+HPE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Ql3he0TLF71rVGT72d5Bc6gLh5p5r7SmU8v51tPJFE5ZwUs+aegZAuCS0zr8sGqec
	 Y6viC8qAqlFQpEm8rDouYlwtL/wncOpkyZkN3jIcfI28XjXiwDzDYlYG4nkzVMcHKT
	 P88GfvuBTWlA16bqCNozTETWkR90qguTtO6NXpEZzEzRc4WqD62t4HHadR42RA4Ezl
	 TTJDr9gEd+pHyF+FzI2HZw7nZgxYzKh9uXBVlu6rMZbDcVkPRsDEuHV2jM9IOKkbYl
	 hIBaizNSKC3ysfMxtzmOVg0ngzzDCj66kYa8cSJOTZxPVunMN8LjjtmZDdqEg6DrNi
	 7fVzf/fackgMw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F2F7C44508;
	Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 14 Jul 2026 01:25:49 +0800
Subject: [PATCH RFC 11/13] mm/swap: perform sync discard on single device
 more proactively
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-swap-pcp-priq-v1-11-de9b164ed419@tencent.com>
References: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
In-Reply-To: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783963612; l=5605;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=nhsTnwGNr5mf8R77bamTTsWF0IFsUzZ/c3ikG+tnQoI=;
 b=O1S81EtMQVty3RnxX+OFve6HrrAWeJdN1IMW1ByIaQf6Zz+TtBVwOtMwyT0JlzbaXElvd8Y2I
 VSIabMtf9i8Dxzgy7IhHWGiaIlO1q7fT91QAevkyoEcZf0doxKAvfNC
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 2FB3620006
X-Stat-Signature: 3fd9oj4f6t4n6emkwdnkktc4widpw1bf
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783963615-773528
X-HE-Meta: U2FsdGVkX18U92o/AkjhAhdbb+33Bt2KJxt0nhhIT+DKXaP/IR51C3kSMf53eahbBTokol2tsefDebI7DGC1tZr+EqOoOpxU9ntqccy1kQCAOZbVqaWUfofF1zilGCM/W8TZ0Dn6GnFEDQsptdy9mklF0ROMgDWvvRSz+jDDb69wpSeYc3YVCJnX9KwaX/lA0agZWO9yCnzPeeYX/uyoE0za/Vbx+nSGDpkLaJ2rB0oteWqolS8IJa8+NYzvecAiZV7SZsi+SphyGomrJ4N1cql5Xr5iqQU6fnS/xZ52SGQCZsdOaUYxOBnq/44d2dAaIYsxKpOkO9PgQla0CYdoWS+sUFCJmOvoSk+O2XneoUtgi86X/w62h9n+C0gBCFjcZfhOygEKVbQkYwA4bRFBUigPDmeCoKoTXw9+ZtoDjbNqBHusGD+/V7YsNdkWFSdgFZxgAaiQ2Na2bugShzL4fCHLtxABt2bfP16KxIFZnPYZmQGLFl17+5yYeyQJZflT5imSIlzcqntFRQD/JLAtj5PnRTl4OXwuikNHodDcnSc+dbpwqmbN8U/9HsK5XhtzJTg59p4wICPEB0TaU221721pHHxdBQ2LM9t6AwstR435Fa7KJmCIioolUUjtDC2DoZOTx6v+BFZllt8iKgf2gtX6MLWHRmy7JBulIzJZgFVoYahDhRaI0m5HMuUWHrYyjcu+qWeuY4Bu0QfynIufNSEk9+wY2qeFdGVkSjg0P1w4k2VT61EvvlJISZ0+Ge8IhEC4A16koGpaQ8VwrIYvEcF9dpRT2KFwn+r5LI9j4iUXibFHqiYWI5d/E+WqVwi2/zj1TJ6ufTSbAD+vjduk2w3WmfkBxq7fMH16OzjV4frqROOpKH2ip51UF4vaTPJtpJg+DrEwNfTFqpnqZx0MvEYOUE7eBSz/iDLTJbRm/Z8EuZLsQZbOp1BjJo+mFz6tEr1eFHHF2JHOo9FUYX6
 aMgh9gcH
 tMbWMuMrlD0DvI4Nv5DjB8IT/a2CX/HV5LU/GeSOCqwxMitv16qMgO/TAV1glbZq+FPtPwJZrm9BA9Vmf15DEsoAwl/KtInCT4HNVLWGrIZDnY5JTkgBAR3HXgdrdg4+0GVZDTbdATeD4G2xMGxzE3iiEDOBJk2qm6Y4NB5WrwwXlRPISLhbS8G8Vncpf8KQly4x8zR8nWiOgHmnopft4TGzMUo73VCZyXM1fTcU2rxgAcRDgP4J24N8sGyxcP7UIlrx2Vpd2AhV5ExR8h0i16EKeC5W9bg+ip5tK8Mku4l/z1zF0fYTE7Ys8Bqwxa0PrBquGnTNRsqpquySPpZ+2GnvwXp6tuVFYib1jBKKUDzh2pJsezlZ8f2zkpVl8egNxHYUg2QVnmsAk+MN6sErJASIUXkhBc5jfejm/XNgnbaoViZxiK1KXDq8yZ1gD2e3+5qEZ3hpQCxl+Axs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Previous commit 9fb749cd15078 ("mm, swap: do not perform synchronous
discard during allocation") added a workaround-style global sync discard
when all devices are drained to prevent OOM. It wasn't an optimal
solution and in the discussion [1], it's preferred to discard more
proactively, and in the scope of a single device instead of globally.
That wasn't achievable due to the limitations of the previous swap
allocation design, or would have ended up too complex.

Now with the new workflow and swap cluster cache moved inside the device
scope, we can easily achieve that. So drop the old workaround and
implement a more proactive and simpler solution. Doing discard when the
free list is drained will prevent fragmentation better and avoid a
global discard scan.

Link: https://lore.kernel.org/all/CAMgjq7CsYhEjvtN85XGkrONYAJxve7gG593TFeOGV-oax++kWA@mail.gmail.com/ [1]
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 88 ++++++++++++++++++++++-------------------------------------
 1 file changed, 33 insertions(+), 55 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 01240c4c9db3..74a50c39da60 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -498,6 +498,26 @@ static long swap_usage_in_pages(struct swap_info_struct *si)
 	return atomic_long_read(&si->inuse_pages) & SWAP_USAGE_COUNTER_MASK;
 }
 
+/*
+ * Serialize the allocation on single CPU or globally to avoid
+ * fragmentation and make the workflow easier to follow.
+ */
+static void swap_alloc_lock_device(struct swap_info_struct *si)
+{
+	if (si->flags & SWP_SOLIDSTATE)
+		local_lock(&si->percpu_cluster->lock);
+	else
+		spin_lock(&si->global_cluster->lock);
+}
+
+static void swap_alloc_unlock_device(struct swap_info_struct *si)
+{
+	if (si->flags & SWP_SOLIDSTATE)
+		local_unlock(&si->percpu_cluster->lock);
+	else
+		spin_unlock(&si->global_cluster->lock);
+}
+
 /* Reclaim the swap entry anyway if possible */
 #define TTRS_ANYWAY		0x1
 /*
@@ -884,10 +904,7 @@ swap_cluster_populate(struct swap_info_struct *si,
 	 * the potential recursive allocation is limited.
 	 */
 	spin_unlock(&ci->lock);
-	if (si->flags & SWP_SOLIDSTATE)
-		local_unlock(&si->percpu_cluster->lock);
-	else
-		spin_unlock(&si->global_cluster->lock);
+	swap_alloc_unlock_device(si);
 
 	ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
 					   GFP_KERNEL);
@@ -900,10 +917,7 @@ swap_cluster_populate(struct swap_info_struct *si,
 	 * could happen with ignoring the percpu cluster is fragmentation,
 	 * which is acceptable since this fallback and race is rare.
 	 */
-	if (si->flags & SWP_SOLIDSTATE)
-		local_lock(&si->percpu_cluster->lock);
-	else
-		spin_lock(&si->global_cluster->lock);
+	swap_alloc_lock_device(si);
 	spin_lock(&ci->lock);
 
 	if (ret) {
@@ -1439,15 +1453,12 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	if (order && !(si->flags & SWP_BLKDEV))
 		return 0;
 
-	if (si->flags & SWP_SOLIDSTATE) {
-		/* Fast path using per CPU cluster */
-		local_lock(&si->percpu_cluster->lock);
+restart:
+	swap_alloc_lock_device(si);
+	if (si->flags & SWP_SOLIDSTATE)
 		offset = __this_cpu_read(si->percpu_cluster->next[order]);
-	} else {
-		/* Serialize HDD SWAP allocation for each device. */
-		spin_lock(&si->global_cluster->lock);
+	else
 		offset = si->global_cluster->next[order];
-	}
 
 	if (offset != SWAP_ENTRY_INVALID) {
 		ci = swap_cluster_lock(si, offset);
@@ -1471,6 +1482,12 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
 		if (found)
 			goto done;
+
+		if (!list_empty(&si->discard_clusters)) {
+			swap_alloc_unlock_device(si);
+			swap_do_scheduled_discard(si);
+			goto restart;
+		}
 	}
 
 	if (order < PMD_ORDER) {
@@ -1519,10 +1536,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 			goto done;
 	}
 done:
-	if (si->flags & SWP_SOLIDSTATE)
-		local_unlock(&si->percpu_cluster->lock);
-	else
-		spin_unlock(&si->global_cluster->lock);
+	swap_alloc_unlock_device(si);
 
 	return found;
 }
@@ -1711,36 +1725,6 @@ static int swap_alloc_entry(struct folio *folio)
 	return ret;
 }
 
-/*
- * Discard pending clusters in a synchronized way when under high pressure.
- * Return: true if any cluster is discarded.
- */
-static bool swap_sync_discard(void)
-{
-	bool ret = false;
-	struct swap_info_struct *si, *next;
-
-	percpu_down_read(&swapon_rwsem);
-start_over:
-	plist_for_each_entry_safe(si, next, &swap_active_head, list) {
-		percpu_up_read(&swapon_rwsem);
-		if (get_swap_device_info(si)) {
-			if (si->flags & SWP_PAGE_DISCARD)
-				ret = swap_do_scheduled_discard(si);
-			put_swap_device(si);
-		}
-		if (ret)
-			return true;
-
-		percpu_down_read(&swapon_rwsem);
-		if (plist_node_empty(&next->list))
-			goto start_over;
-	}
-	percpu_up_read(&swapon_rwsem);
-
-	return false;
-}
-
 static int swap_extend_table_alloc(struct swap_info_struct *si,
 				   struct swap_cluster_info *ci,
 				   unsigned int ci_off, gfp_t gfp)
@@ -2045,14 +2029,8 @@ int folio_alloc_swap(struct folio *folio)
 		}
 	}
 
-again:
 	ret = swap_alloc_entry(folio);
 
-	if (!order && unlikely(!folio_test_swapcache(folio))) {
-		if (swap_sync_discard())
-			goto again;
-	}
-
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
 	if (unlikely(mem_cgroup_try_charge_swap(folio)))
 		swap_cache_del_folio(folio);

-- 
2.55.0



