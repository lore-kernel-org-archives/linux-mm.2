Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6056CD4F4A
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 15:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58DF76B0092; Sun, 17 May 2026 11:39:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 562A66B0096; Sun, 17 May 2026 11:39:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A3276B009B; Sun, 17 May 2026 11:39:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0D9966B0092
	for <linux-mm@kvack.org>; Sun, 17 May 2026 11:39:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4919C1EFB
	for <linux-mm@kvack.org>; Sun, 17 May 2026 15:39:54 +0000 (UTC)
X-FDA: 84777322308.21.D831A84
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id B2E9E20007
	for <linux-mm@kvack.org>; Sun, 17 May 2026 15:39:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hx4xeej5;
	spf=pass (imf03.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779032392;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kewyYUzOVU6PsIKBmQromG36Ix95eZVkJjR0tx3lnBc=;
	b=VDhlSQBoaWuoUcj4bDt9QLdX8SjEwnkZ8446o2VZO+jxbznt9jj+ZBBA2HGsVEO0sQ2S9p
	NNusdbenNUSZgpFEwDpvOyHudJONoXLwJuwYmSghpbil8nKnl7gyVgTmDVYM5qefDRRdCe
	TNnsZtympJj7Ka1vezZDNIMmtivuzKM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779032392; a=rsa-sha256;
	cv=none;
	b=7nT2Ynf6eDavh2REEzgnx72uyEGZmlfNwOqfCH6SKKIQ2vfWXSlheb2aIWUtWvZdH9uNUq
	z/jEtY4k/KRcUmk/rjdyYq70JrLXVnRi0J9+Ym53UYDbqiypeGmgUPzPoyse8P7XGv8oEu
	QL3pd1DyvKF7AXJxAyMhM4gfw3Ns3IU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hx4xeej5;
	spf=pass (imf03.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 43361445EC;
	Sun, 17 May 2026 15:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 221E8C2BCFB;
	Sun, 17 May 2026 15:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779032389;
	bh=IA+n1x4TGGrmvV2VnYh711ckQlZ8TYsnmX7nmSi5qbk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Hx4xeej5OriGbAD9fV3Nc/EvcAJEU39k/zjYtwDaXN2NIONHfSdw+g+czq5Zo0AyN
	 Om0cYSHb//cEVOP7A+tXQ20YPnj7KFHotcw0hfS/9vMrMClBZQOLHi3FlxPya/Yiqp
	 4Ab7XGCqRV/QwhxJyRbpkFhQA6HxEbOpurKl2YWZPp8Zo546tSPigec/aHxQt+xxbR
	 RsipPcGcmc02PYzo08dyL1LUfghXO/61tMf7KaoYdL3XFnjAiEHrPMcHzKC2zrKVEt
	 LXjTlpkkUXqHypvJuXk2Vvea2/5xxe2PxzqdSkplqmZaPIR2qbZqEwX1qgyo8Dc7ZX
	 CzyVTZq6ANLIQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16ADCCD4F4A;
	Sun, 17 May 2026 15:39:49 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 17 May 2026 23:39:46 +0800
Subject: [PATCH v5 07/12] mm, swap: support flexible batch freeing of slots
 in different memcgs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260517-swap-table-p4-v5-7-88ae43e064c7@tencent.com>
References: <20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com>
In-Reply-To: <20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779032386; l=2512;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ZD2081+ctfRfaBeb4mp+5wkRHhM7k1bXJ2YEQVy37aA=;
 b=/gV2rB59+sfFgcX/Dv/Tg5we0Z1EcHk9+EDjavgbQFtp9YpTqfm8oJ7yHIq0BedOQfVQ6HnSG
 GNhYM36cxJHBEEoKcNtjUh75tuEkjOcoLjMNFHzWMJEEtS6uiMtjPPG
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B2E9E20007
X-Rspam-User: 
X-Stat-Signature: z63je7nsskodrx8kg17ofza8ouri8hqz
X-HE-Tag: 1779032392-562762
X-HE-Meta: U2FsdGVkX18EZZajC4qsJStx+KEDYWFIoTXYkrw6rGSwkFh0mcNIjFD8Sn9VFBywXmsX97LGr5mJeruoL2GOCVGoMMzk1ay8gZR3FvYuRyxFnU0Si8ShxU3rHlHhbHq6u9WLvvP1d6SWUCT/7BjlaoX/RIrnwevp34FZZzW6clznWyswmMXsJRnbIlapYSi1eTwv5XOOwVH6JNKV3MjtTUiJGM/E/ofTr2ZMC3JdzZnJK5bLjZvTBahwXX2KR6lF+bs2FzEOJyEZXRtSKKXZyEso1Ml40bxQEAHh1Yp8xk2pZ9VtFRhCE+7LwY0eqmGY8iXNc7UOQf8FRupKpsv+aY98iQq7cGAGSi7rQAMg3E6auIavKEHqXAuu4XqtT3v8vincZQ81f7xE3UOGcEWPWYOvXUwDrOdphtBH3NhCnh5HsBALmocJ1Yb4twzN24pzAifxIfucBc5uw4FmFYIOhCGq1F1vppyaITp5NvpSx3UotgmhP5e3jXhgF9h7BVQEqxdCJzvOHWIqKPXE7K6Qy8m/2YEr9OCeZcWdL7MWkLUZ1uKjElTTDtFpuZ+Yncw7m8xso4CI23DO2g54RYm24FN7jtPdZ28Z4ocAJRD+JJvwVQDhyVZsqCw7PZy17xvhv7bbEVfUcFImB3lGU0XRSvGKmgARuACk94f/tgA2PptlKmB79fDGHA7vC0+z9KcknyGaBzrv/CUjhbuVVNd5B9AEkArdTA6LbC+f+/bTEjUbSd8W4Xbz2WNeAYQU51PnmsJ9CI+Iy79WQJzhgUKPzQVxlPq4hM3PpkebMsdaQgwTeWHUN3eh/w4MeS0nfRxvGe+3/ajKBUbB77KLYmbodNNn/urT5HVJ+VfEJPd0b+9t37Dckeyu3N5I/wUIYy+uEyv/nhS8oo50EZ/0MEdjBsPhfIuCIrMoufVu5dMptkKoKQquPU1+9ydgUhpi1EnUPYAyGX8EJerQzN6BzVY
 5Pj55wnF
 IUMKnePgoNVXu1roucub8xu1O652+KvhEktYHoZbYhZxeEaoxLoqMSBn2Jc+mKRCyj4AKyLM86cmnC6UCveb4ymIKnga1N4oKNdeZFrRlfzfJxBrx62I3y+L5E+y1+5LE58fyCsH0hBeHOGihrcvVonmE3K/Hvx6yspR10MJFC754n9jn3wyZ6dk++bLUXP/Sk81Y8tTvZzUBWkY3v9rGMFvm9dSlxi19Q1zPSvllYp8nBHC6OTsG5E6JKtW+u6rTiXLax8cizwAsU9UptXalyJX7NsHc/yHshZlmWnyfW6jVAqjkhcLqewhc03WFuHCx0/ZytRls752VwWK7K4yLU3iM3inP1NggapbK7vXWIiqN5QNTRbqsS1NtckE8K817Q9Vs+uvckgs1dbs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Instead of requiring the caller to ensure all slots are in the same
memcg, make the function handle different memcgs at once.

This is both a micro optimization and required for removing the memcg
lookup in the page table layer, so it can be unified at the swap layer.

We are not removing the memcg lookup in the page table in this commit.
It has to be done after the memcg lookup is deferred to the swap layer.

Acked-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5c8bb15719bf..c9c80ba9252b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1873,21 +1873,46 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 				 unsigned int ci_start, unsigned int nr_pages)
 {
 	unsigned long old_tb;
+	unsigned int type = si->type;
+	unsigned short batch_id = 0, id_cur;
 	unsigned int ci_off = ci_start, ci_end = ci_start + nr_pages;
-	unsigned long offset = cluster_offset(si, ci) + ci_start;
+	unsigned long ci_head = cluster_offset(si, ci);
+	unsigned int batch_off = ci_off;
+	swp_entry_t entry;
 
 	VM_WARN_ON(ci->count < nr_pages);
 
 	ci->count -= nr_pages;
 	do {
 		old_tb = __swap_table_get(ci, ci_off);
-		/* Release the last ref, or after swap cache is dropped */
+		/*
+		 * Freeing is done after release of the last swap count
+		 * ref, or after swap cache is dropped
+		 */
 		VM_WARN_ON(!swp_tb_is_shadow(old_tb) || __swp_tb_get_count(old_tb) > 1);
 		__swap_table_set(ci, ci_off, null_to_swp_tb());
+
+		/*
+		 * Uncharge swap slots by memcg in batches. Consecutive
+		 * slots with the same cgroup id are uncharged together.
+		 */
+		entry = swp_entry(type, ci_head + ci_off);
+		id_cur = lookup_swap_cgroup_id(entry);
+		if (batch_id != id_cur) {
+			if (batch_id)
+				mem_cgroup_uncharge_swap(swp_entry(type, ci_head + batch_off),
+							 ci_off - batch_off);
+			batch_id = id_cur;
+			batch_off = ci_off;
+		}
 	} while (++ci_off < ci_end);
 
-	mem_cgroup_uncharge_swap(swp_entry(si->type, offset), nr_pages);
-	swap_range_free(si, offset, nr_pages);
+	if (batch_id) {
+		mem_cgroup_uncharge_swap(swp_entry(type, ci_head + batch_off),
+					 ci_off - batch_off);
+	}
+
+	swap_range_free(si, ci_head + ci_start, nr_pages);
 	swap_cluster_assert_empty(ci, ci_start, nr_pages, false);
 
 	if (!ci->count)

-- 
2.54.0



