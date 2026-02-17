Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41935E9A040
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1E356B009B; Tue, 17 Feb 2026 15:06:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8EF96B0099; Tue, 17 Feb 2026 15:06:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94BD26B009F; Tue, 17 Feb 2026 15:06:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 73A716B009E
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:06:55 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F542B7D86
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:06:55 +0000 (UTC)
X-FDA: 84455031990.04.82B874B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id DC4BF40014
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:06:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n0Ikbhms;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771358813;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HuAjbBkD8kSipQ4f8RnZbFFdejVpIBTnz7trVZn3q3k=;
	b=poJsx5zA2NjXmPfrAnC87v8AgQsja81KNeLmNAABLRJlL/0Uq+cH95XwwtpKPYHyBDpSlr
	wk9GfGPnx6xGtQ8ENbSiHFcg9fP76cc5vAF6h3g14vuQzhE1YRIBVmjEGt5/4bwxsITWt1
	Shrz38w5SoVp2HmI1DBZdZt9463tyMs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771358813; a=rsa-sha256;
	cv=none;
	b=5fIODFT7dBdmSH4ZEjl47FVQHAvZwm8tOAv5G8/6x1wykEOhQhvumdiT7JqL0GK2rAx/BK
	GqSM29vPFqad5ngIZg7r/5x2cbPZCNkTg8TvidK4KbrKPMj/45QmhfnT8lvzAfM2Lu4tMc
	Ic7R4BaWonl6xeIOr63MujpLsRcWFOQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n0Ikbhms;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6ACB74451F;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45982C2BC86;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771358809;
	bh=sWQzU7khQDNy4UQo93Y5S/9xblmavrsvmSlGL/edDFo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=n0Ikbhmsl6p8d/Vz34JTZeH9gtNaNmdxZUq3Dd4xIkJHlHohnUudggEuyvG9wpZ0h
	 dFVDA44xkv30oagcMR6lZiLSmPhWUo1v8SqU5/35yRekdxDNTLcg61D5RoKOj2MCtV
	 6WS0w6lmlvGlRi3DXlVf+4uXEc/B5EgXnsY3oGSVAINhyi8En0CA/NnlYB/zrS3KyU
	 LYt6pwTwsy8Erst4QXHuTbclvHhpOsGgZKjfo7XwcHJYM+HvkJfDkZa5X9lHfcls3l
	 IyIT6zghnMfA8Ei9Ws6LSL36gS8K3ze1xPS+s6ikF8olthh7IGE68RKyksf3IthnzN
	 6ZXIJDwjt/wpw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D4F7E9A044;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 18 Feb 2026 04:06:32 +0800
Subject: [PATCH v3 07/12] mm, swap: mark bad slots in swap table directly
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260218-swap-table-p3-v3-7-f4e34be021a7@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771358806; l=4470;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=/6a5WE0qU3CwNJencZWGo4oQ+mlwUxPDkxYGAlNshp0=;
 b=jq/N27cSt+ppJRZAEi0m4I/DLxjhvdPQdZsIhXJ8X0+Crkd5WUyH1h2LEs3soA0H/NCIqQZXl
 cxbyHJOcwGpDurXu0aPPvKAwRWVO8nYoOxIMUuoowIL88vB2NERu4ap
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: DC4BF40014
X-Stat-Signature: u94urkrbzf8gjfr7iwhwk8trsi1sn8ft
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771358812-133655
X-HE-Meta: U2FsdGVkX19NfvgFfWFgUPZs3IR3r/Nmy3CHNbVnoUs/3BXBczS1g8RHuC73YOkuatbmD4roCrrxpKL+iW35owH3bVrTMgmn15WNEZ2Z+xONNYQoTtgzHqoyjPmIkOYR7z2bpihUl/+0eoCMfI7rhsK4Ovf/9u8NxYXJuqn1BNeQl67bKylRTvYMHYVN7etYjiSxF8LNudiySer/AnedofPiUmUdzzixIUu5dtim9Mu0Z7/vMFZtyIlh5WwT+hE1IxxK2Ok11078PkYstxt8HAneSMf1znorsDORd/ag9Ig8Itdr5EkRr/R4mAzdkr1sdapAS4I8ZIIrm8lFop90lqdnz/3l/uJP+L3UMbFxcWmoGg8xyTRbwUOHUw6Fyw/Wl5VFRM4xIW13x4qoBXGxRKR0gohFg781qLNzYQqnaw1TjRRossKeqhk6TibbltO9l/gXogZ/4kDh825PZBS/RRva8cuP7D3ZjYl7Zv/faKgf8+FDbfbg+BveEIp3u6GWml9DnvgO5lz9Y5a8P3Mc//mKOUh6DKu1sJMgx046jyQhWVueEgY8LvumvKwPCgLA6BKx/JmWuMhNPip054dQL0Ua/d2M6a458ZRf5BRZDsJ/aohtDY7x01llRd8LnBX76mkZBgdJ3ONuKF9uJqjHMG/RgQN3zNghHRFNIFnTRY1HwE0VWRZFvz3xSGWZT3+GcIYn6rgEeFYT+6q1P47Zi33GZxDJy1C6COxNOqhMEF3x5s16fSo+jwYXo8pnSMm7ns1yplyeoe8hKT8WSxN37stgkJxMW7TGh21MjsqtXznQ7dAtVjkrWM4eCpsDPuUaVFUg22rc0DkkW1P9fIEk9PQXkCjypGprFPvkdUBahhKm/Rdt+NCr5e+p2PE5VFWOy7RMq7mhIwboJk9c1u1fxqk6Z3RCU2+iBv8rr6tauyyqIQu9K0Rc6oz6HjvO4HypUClJSrN5o2//a3KHx64
 Qklab74E
 rjNFCOEi/X7fAsU9xC/ukfR8f2LJrZiN9Bj1w51bl3MORTHNlQi/64XiGGhbgXo8UNGlcoWeuLUMZjXigCKrJwBV442RSr1VnAphRkEhdYrxVACHhmtpTuV8GPsdMdYUZ5B16f4aNNWlEiPkEzHHdZuyUWnzNi2+ZKn/JWtgFqTkPChKpU7ll9EcJe7jIkqOGEPzd0uaY2MsxnNxrP8uQq524JTlEo2O/SF+fKrJ4drbJx4Xx7PaCOHoIpd0wG24xknB2biQ4+UWEzy5VUCmHHpAEdbVO0kIvk3So79CYNZmxgTnpcSpokcI2GwsbYVhgXFVkME+norykKXoJk/8Be7gI+hTT++gP5l90yC2fNdtAo7ylzjFwmo1WSTUdq5gZK8xGMY/ZNJZ8OcnRtcUSLC0fpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

In preparing the deprecating swap_map, mark bad slots in the swap table
too when setting SWAP_MAP_BAD in swap_map. Also, refine the swap table
sanity check on freeing to adapt to the bad slots change. For swapoff,
the bad slots count must match the cluster usage count, as nothing
should touch them, and they contribute to the cluster usage count on
swapon. For ordinary swap table freeing, the swap table of clusters with
bad slots should never be freed since the cluster usage count never
reaches zero.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 56 +++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 41 insertions(+), 15 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 91c1fa804185..18bacf16cd26 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -454,16 +454,37 @@ static void swap_table_free(struct swap_table *table)
 		 swap_table_free_folio_rcu_cb);
 }
 
+/*
+ * Sanity check to ensure nothing leaked, and the specified range is empty.
+ * One special case is that bad slots can't be freed, so check the number of
+ * bad slots for swapoff, and non-swapoff path must never free bad slots.
+ */
+static void swap_cluster_assert_empty(struct swap_cluster_info *ci, bool swapoff)
+{
+	unsigned int ci_off = 0, ci_end = SWAPFILE_CLUSTER;
+	unsigned long swp_tb;
+	int bad_slots = 0;
+
+	if (!IS_ENABLED(CONFIG_DEBUG_VM) && !swapoff)
+		return;
+
+	do {
+		swp_tb = __swap_table_get(ci, ci_off);
+		if (swp_tb_is_bad(swp_tb))
+			bad_slots++;
+		else
+			WARN_ON_ONCE(!swp_tb_is_null(swp_tb));
+	} while (++ci_off < ci_end);
+
+	WARN_ON_ONCE(bad_slots != (swapoff ? ci->count : 0));
+}
+
 static void swap_cluster_free_table(struct swap_cluster_info *ci)
 {
-	unsigned int ci_off;
 	struct swap_table *table;
 
 	/* Only empty cluster's table is allow to be freed  */
 	lockdep_assert_held(&ci->lock);
-	VM_WARN_ON_ONCE(!cluster_is_empty(ci));
-	for (ci_off = 0; ci_off < SWAPFILE_CLUSTER; ci_off++)
-		VM_WARN_ON_ONCE(!swp_tb_is_null(__swap_table_get(ci, ci_off)));
 	table = (void *)rcu_dereference_protected(ci->table, true);
 	rcu_assign_pointer(ci->table, NULL);
 
@@ -567,6 +588,7 @@ static void swap_cluster_schedule_discard(struct swap_info_struct *si,
 
 static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info *ci)
 {
+	swap_cluster_assert_empty(ci, false);
 	swap_cluster_free_table(ci);
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
@@ -747,9 +769,11 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 				       struct swap_cluster_info *cluster_info,
 				       unsigned int offset, bool mask)
 {
+	unsigned int ci_off = offset % SWAPFILE_CLUSTER;
 	unsigned long idx = offset / SWAPFILE_CLUSTER;
-	struct swap_table *table;
 	struct swap_cluster_info *ci;
+	struct swap_table *table;
+	int ret = 0;
 
 	/* si->max may got shrunk by swap swap_activate() */
 	if (offset >= si->max && !mask) {
@@ -767,13 +791,7 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 		pr_warn("Empty swap-file\n");
 		return -EINVAL;
 	}
-	/* Check for duplicated bad swap slots. */
-	if (si->swap_map[offset]) {
-		pr_warn("Duplicated bad slot offset %d\n", offset);
-		return -EINVAL;
-	}
 
-	si->swap_map[offset] = SWAP_MAP_BAD;
 	ci = cluster_info + idx;
 	if (!ci->table) {
 		table = swap_table_alloc(GFP_KERNEL);
@@ -781,13 +799,21 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 			return -ENOMEM;
 		rcu_assign_pointer(ci->table, table);
 	}
-
-	ci->count++;
+	spin_lock(&ci->lock);
+	/* Check for duplicated bad swap slots. */
+	if (__swap_table_xchg(ci, ci_off, SWP_TB_BAD) != SWP_TB_NULL) {
+		pr_warn("Duplicated bad slot offset %d\n", offset);
+		ret = -EINVAL;
+	} else {
+		si->swap_map[offset] = SWAP_MAP_BAD;
+		ci->count++;
+	}
+	spin_unlock(&ci->lock);
 
 	WARN_ON(ci->count > SWAPFILE_CLUSTER);
 	WARN_ON(ci->flags);
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -2754,7 +2780,7 @@ static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
 		/* Cluster with bad marks count will have a remaining table */
 		spin_lock(&ci->lock);
 		if (rcu_dereference_protected(ci->table, true)) {
-			ci->count = 0;
+			swap_cluster_assert_empty(ci, true);
 			swap_cluster_free_table(ci);
 		}
 		spin_unlock(&ci->lock);

-- 
2.52.0



