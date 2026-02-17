Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12EF3E9A03F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8701B6B0093; Tue, 17 Feb 2026 15:06:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 662E86B0095; Tue, 17 Feb 2026 15:06:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AFE56B0098; Tue, 17 Feb 2026 15:06:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D8446B0095
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:06:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DFC7EC1893
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:06:54 +0000 (UTC)
X-FDA: 84455031948.23.6EAE1DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D96C3A000B
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:06:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QrJBFgyJ;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771358813;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=II5EEJitqai93D4ML9X7EbNqcXciITQ3RhkRPtgODQw=;
	b=2xZVYpGYt+VATqvQoKSEsPxByzHc6ntELNle0VMemrqN1JVENj2LaDudqvLRIrTTCY7Ch1
	fQof3PyEF491ZR1bt4CdIu+6PhZOap8mscihCNDpjrlf3XSPMf875X2kNhScnY5WUiw94+
	V0oxHqkZpaF3cAujHCpxS+t73l6AbO0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QrJBFgyJ;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771358813; a=rsa-sha256;
	cv=none;
	b=N2tyWXrgaU/lWI8044hnas/g0KfUN6yp1fk+5N8NuPA8kAPb9I3LhHLMT3ggPk7ZrSiyJw
	iSoCGokKTd68SOFmZxyjodYPfis90SMcHf9w3w2ZMx9SUOJKaWFeqAa7HbLdoYBum3wvS0
	ETArnrk39ThOlLzzPnAf3C0kkphYULM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 726FC4452B;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 536F1C4CEF7;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771358809;
	bh=2yeFedgdCFAimPY5RI1c2qVMLTt5kk1HGr79YRFFwtU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=QrJBFgyJRSoQWN8tcT2gCT0mUhrxFLY8aNOi2qK2FIVSZiRFHNs8ZaCvyHDcAQUPg
	 QA1Gaz/KbDQBBd54Z9crUJnr+stnwwUKRuGSzSUCKI1+hrQFNLfL1p+LQ3LdAdvLtu
	 vwnYpKR5uj4fXL9JY1yF022bIDfu10RMc6+/CR0qoLLxQwHCeFTNI+8kOykXN8YHQE
	 BkyIrlXcU/V5jLjsX7onMka4x8WPZSHLRPVWEV9yu0nyZ/cc3UUUmi9aST9g/4EnYa
	 Uxf9yPsUUjb4+eNrI0lwJiqiKb9oeFbpUAoGNqzkVFqUX0ugDfuapCoYsvC2CbHrmN
	 L+cl8KHVebk+w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C6E3E9A045;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 18 Feb 2026 04:06:33 +0800
Subject: [PATCH v3 08/12] mm, swap: simplify swap table sanity range check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260218-swap-table-p3-v3-8-f4e34be021a7@tencent.com>
References: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com>
In-Reply-To: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771358806; l=3805;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=qW7kb00sZvxT2nbJUP3ZxQKk6L3Y2uUbqLzNxOvxoKA=;
 b=thXuehseP5TvVLIZT7SlJc47FJQLJOHUXv+3J+61ZMtKTaqy6ubJEP0l/UB1/t0VDTvGZoAlJ
 i+qDWPRAg2sAyOjvyOYI4XjyZN7GQyz2evi1F7eu5m19Ps6HnF7Beb0
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D96C3A000B
X-Stat-Signature: j8s4iab33gk9wkcrhe45c4wjpaft5638
X-Rspam-User: 
X-HE-Tag: 1771358812-787166
X-HE-Meta: U2FsdGVkX1/72Z3Z9pk/t+JVW1v4jXSFFAhUq+3t8mZ7U8yf6ZrskIOTDU46toJplkrk0mVtxONAWN9Wnmvz0Tajh/ZPUshlcNydmuDBOzCo216dk0F2SWWjIyrE+tKokZGnzTLQR2bVV9gd/jICzm94mx+DLsP6k7MusqfFP3fLMdf64E8xA/aw5nTkbvD1hZY+w3RSMAqmybxw4eEvUPZEtS1Zv4UNZfJ8WlT0EDxarFWThR403DrJKlVNibUbWvUakE4L25BzrawEqwvkAIF4tuzgrtNtdxReNKLMTKu3lH1YStw/waVc0439bSV0eunLkMSTVSzn/9SnTjrLB+YnvQf7eOk6l+qNE2DwbJ0SEwWHxba+uzFnAEcc6Id3F5GrZ8wyxWxXC7ORnRI367jDU8x4NSSseKv5kd9EuibOrpI5uH6x+StsKu+Q+J2jFJcqgtl+N4CvpzcLnrBvnT8nSkHzDHYtW63Xoq7Tfz0biXeIoO+lSqNozG7SDzHI4PkmFwgyc+NMbN7H6F6dhMr/Ol8HpWYQFppZ8+dzcD8y8P96zMglsI32zRb7jhlo4xsrXbGdKG6af9V4A7xJrPN1CTEI3mEgWOjMz35I2FSn7SUwvLwVRCgPNWQHY1xjeV/LCGi97zRdRuOwVKy0QPjSHu9Ct8XCaqyhXPygmrkRGiWonixzPPH5VyDOeGqjH+uBkoYeQoAxD1GwGn2lhc2EOz3VzJ1NwLlZuWsOej0YDRXRFUVX1NQHkPAqATgFOzBnfk4Qe9IIQA8Oh7aUsSaKu4Q2tIHzwljM00+fQB5G0hbXgg8JvL2XT5ijQtARqENKWjKbxONd0BONuW/UNohecTGBXFS/y48bM/8eazAtW4LtBMHgg8AcffmSb17rYv8oFkJyzuITpuuADjsodoRTf6H4jsfD5zZEy05XUh0vwp+NOByEeTcR/L6yLpVsS0NkP0yyJJWzQFHdphF
 S8vR0iFk
 XYAXS3/h9XPKAGBjFNjx8kxhBQlqrwJYZN8JMRGQTQTr6e4Gy9kpgMRAsz6sXiB+SPErwZpvlud8VtXGp4GjXZGq8hTcV3EPvDqrm7Hip/xCQLwi1nm42J8MmrB5eb4iwW44DJLX/zunInaCTkUZvL2avyFJvnAVUet3O8vP1tp7VHfDrVK5BfKViwT5MBhlwHItQn3Qk4D72m53STrI0TEluR2xeFcLbziP9sE1JW4ALvxq9WVvlgAitEIKc2r60hTrpcPnOhnG5j0XNTpfpjR34hX+HsVIWrEx5tnsnTARz4ADtiNLKUYplHGx6XiX2rTxd7oMt/oA7VixSM7M20EBOB6VzXRmC9R3jT4ZfTEK1M2d8/aWp9LyqXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The newly introduced helper, which checks bad slots and emptiness of a
cluster, can cover the older sanity check just fine, with a more
rigorous condition check. So merge them.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 35 +++++++++--------------------------
 1 file changed, 9 insertions(+), 26 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 18bacf16cd26..9057fb3e4eed 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -459,9 +459,11 @@ static void swap_table_free(struct swap_table *table)
  * One special case is that bad slots can't be freed, so check the number of
  * bad slots for swapoff, and non-swapoff path must never free bad slots.
  */
-static void swap_cluster_assert_empty(struct swap_cluster_info *ci, bool swapoff)
+static void swap_cluster_assert_empty(struct swap_cluster_info *ci,
+				      unsigned int ci_off, unsigned int nr,
+				      bool swapoff)
 {
-	unsigned int ci_off = 0, ci_end = SWAPFILE_CLUSTER;
+	unsigned int ci_end = ci_off + nr;
 	unsigned long swp_tb;
 	int bad_slots = 0;
 
@@ -588,7 +590,7 @@ static void swap_cluster_schedule_discard(struct swap_info_struct *si,
 
 static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info *ci)
 {
-	swap_cluster_assert_empty(ci, false);
+	swap_cluster_assert_empty(ci, 0, SWAPFILE_CLUSTER, false);
 	swap_cluster_free_table(ci);
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
@@ -898,26 +900,6 @@ static bool cluster_scan_range(struct swap_info_struct *si,
 	return true;
 }
 
-/*
- * Currently, the swap table is not used for count tracking, just
- * do a sanity check here to ensure nothing leaked, so the swap
- * table should be empty upon freeing.
- */
-static void swap_cluster_assert_table_empty(struct swap_cluster_info *ci,
-				unsigned int start, unsigned int nr)
-{
-	unsigned int ci_off = start % SWAPFILE_CLUSTER;
-	unsigned int ci_end = ci_off + nr;
-	unsigned long swp_tb;
-
-	if (IS_ENABLED(CONFIG_DEBUG_VM)) {
-		do {
-			swp_tb = __swap_table_get(ci, ci_off);
-			VM_WARN_ON_ONCE(!swp_tb_is_null(swp_tb));
-		} while (++ci_off < ci_end);
-	}
-}
-
 static bool cluster_alloc_range(struct swap_info_struct *si,
 				struct swap_cluster_info *ci,
 				struct folio *folio,
@@ -943,13 +925,14 @@ static bool cluster_alloc_range(struct swap_info_struct *si,
 	if (likely(folio)) {
 		order = folio_order(folio);
 		nr_pages = 1 << order;
+		swap_cluster_assert_empty(ci, offset % SWAPFILE_CLUSTER, nr_pages, false);
 		__swap_cache_add_folio(ci, folio, swp_entry(si->type, offset));
 	} else if (IS_ENABLED(CONFIG_HIBERNATION)) {
 		order = 0;
 		nr_pages = 1;
 		WARN_ON_ONCE(si->swap_map[offset]);
 		si->swap_map[offset] = 1;
-		swap_cluster_assert_table_empty(ci, offset, 1);
+		swap_cluster_assert_empty(ci, offset % SWAPFILE_CLUSTER, 1, false);
 	} else {
 		/* Allocation without folio is only possible with hibernation */
 		WARN_ON_ONCE(1);
@@ -1768,7 +1751,7 @@ void swap_entries_free(struct swap_info_struct *si,
 
 	mem_cgroup_uncharge_swap(entry, nr_pages);
 	swap_range_free(si, offset, nr_pages);
-	swap_cluster_assert_table_empty(ci, offset, nr_pages);
+	swap_cluster_assert_empty(ci, offset % SWAPFILE_CLUSTER, nr_pages, false);
 
 	if (!ci->count)
 		free_cluster(si, ci);
@@ -2780,7 +2763,7 @@ static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
 		/* Cluster with bad marks count will have a remaining table */
 		spin_lock(&ci->lock);
 		if (rcu_dereference_protected(ci->table, true)) {
-			swap_cluster_assert_empty(ci, true);
+			swap_cluster_assert_empty(ci, 0, SWAPFILE_CLUSTER, true);
 			swap_cluster_free_table(ci);
 		}
 		spin_unlock(&ci->lock);

-- 
2.52.0



