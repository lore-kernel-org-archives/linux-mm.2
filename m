Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DDC3C982CC
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 07:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 649356B009F; Sun, 20 Sep 2026 03:21:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 620DB6B00A0; Sun, 20 Sep 2026 03:21:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55DE66B00A1; Sun, 20 Sep 2026 03:21:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B30E6B009F
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:21:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7BD35803DF
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:21:45 +0000 (UTC)
X-FDA: 85233295770.03.E511532
Received: from mta0.migadu.com (out-5.mta0.migadu.com [91.218.175.5])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9C73440003
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:21:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.5 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789888903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fTkuUTiBnE8rFUy7exteKg0zxaiKC1vw0Juv0BLH7Hw=;
	b=uaGpm1wZAwD0XTNVVJ/C65r8jawHfQeChEbHXNH9idokalZvOi5C88EwphVuPLrUdqTDQf
	Gi6OZtEkfcoffQWaNirAkFcFdVKFpWvS5Mn1+A/ncDFvqTPnNx81mkZO17teq5Gh8T5L90
	2dFA4Dyh16nBOhP6w1sLa0V60w/IMkE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.5 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789888903;
	b=CZnYN8Onbci8wNSFoDYcGhWlfZ7DJA6KmaIpFruMbe7KjBe5KG4h1PZtqDcLpOdsEFLgcZ
	u/Lcv2/KaaUbus5LSW3QU9Bg0F+/D7RZchUU3E0MJsiGv6Zpi5qzMP0PaWGWFy9kSl8yk+
	DcDQyTkyPVgxmeZYiG3nMkoQFEWqFTs=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id f1be1098627f0bc7;
	Sun, 20 Sep 2026 07:21:42 +0000
X-Mizu-Trace-ID: f1be1098627f0bc7
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
Subject: [RFC PATCH 08/17] mm, swap: reclaim physical slots backing cache-only xswap entries
Date: Sun, 20 Sep 2026 15:20:34 +0800
Message-ID: <20260920072043.430390-9-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260920072043.430390-1-hebaoquan@kylinos.cn>
References: <20260920072043.430390-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9C73440003
X-Stat-Signature: q8crumq8wjbjq84dk5uz1kjooiqdcz3d
X-Rspam-User: 
X-HE-Tag: 1789888903-491900
X-HE-Meta: U2FsdGVkX1/cygQFlnBUk0NgdE2juzhvjt8otL1I743DbDZwPEVeX2/S4fxwuIT1/MRV4p8CHBBuayTZufgLj+7qTWht3OyX72+4bjN2Q4hqIvJfdZqiCzIZspuHCexau49ud1WsAKBDk/7tW9VYOXhjHV7DAJx7fheQTtua5w0c8vgtU1HeWMc+1uB+rq9K4ae/XKEEe91E2Q9xbdThLMqgXfjH5O6UehWwkYYjUGkKkLsUwUshMEUmtYoCoKm4CWrBB9E0TkCdqsVwXpa5V8gW3d0uzqUHltZUReGMDZqLlevdPYGmszRt4NiB9Ydh2ya5HgaDKAhp2OIa5WqOfaUsIASnZGVwPsQTOA7s7zM5dEilj+cB0X+O61PeudTZ3FLYN8HU0loJeYe1DkPX54KzKVcLKGWFckLgk1v3UoALdM0mTZ5setSWIX4LcxcKXr9Grir9SQJfl30fJMIRP59xbz/npTvYkARru+WGNOuFUZf+WOZML1LBsiIDXujoow0X2On0u+8KwIp7xWmBNqGNXJh+iEa8URhqXZj+gFai9vDAiq0+mpPggV1bFQoB8GvwJ/RN+oxZRBmju7aMF6Ar2I9OKt4BVSnfM+s890YQWKMB6q+HvKqy4k96/FwdOVrvkN29FjGuX0bo1jZ8NChB34C/hW4bnQ4HOISHsz7XlTpKHGJ5KOek3Vby+u16tN+0Qsnvio+5SBdiRfxgce8zkoHlwu1/2H5KmSxPwrp39nIgQ/vLOgL4VlM+MfuA8i8azom/DnjANGiH3XCL+l6U+U7YH7K9lqq3N2FQlYyVkhVd5IZuqMOpL2dIQD0R2bO4XkZBqiqsPuC/yAzyLr6hD4sHaytYRo3cVxxf4a+wbd4qeN95NvbEeCBez/+qis6K8F8wKymqgzDZI/mXwRTDZTaINgLmwta+y3mYEX9ORzSTlmUVLv6W0TLKKnsRz/VJHfUI5uAnVDb519S
 UTmkfsNP
 ZtLkdyFsjv8fRkx9cOUYUlb64avhzektlMHDdHUhHCzQpqbs7Liww4wR4nidW7h2XiQNlYb8EoqLb3rSxAdaWENuNd57RIleMNTRLmliarhppaWwOgE7JWB7xTfJY1COMSuqLLjhYeSHWmHRR7hUpwBweBidDtrsuy2Lvrw0eQ1llOU7zTdSCLoiQWcr3jfQwmAHKehuudu2w66GLbAzElSpMhNECYCwaPCRpmJfpiyszn0rh1mHIjC/17EbKML6aym/xO5eqU9en7VTfQtyEz827cZJdJ3jyvDqnW8yhSvOxsH4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An xswap entry's swap count can reach 0 while its folio is still in the
swap cache. Then the entry is cache-only, and its physical slot is
redundant. But the slot is only freed when the entry itself goes away.
A folio can stay in the swap cache for a long time, so the slot stays
pinned.

So reclaim these slots from the physical scanner. It already walks
full clusters when swap is more than half full. A slot with the
reverse mapping belongs to an xswap entry. The scanner can hand that
entry to __try_to_reclaim_swap(). That frees the folio from the swap
cache once no page table reference is left. The physical slot is
released with it.

So __try_to_reclaim_swap() now takes the entry, not a device and an
offset. The entry names its own device. For existing callers the two
are the same.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9afccdc03845..875b40f2e362 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -311,13 +311,17 @@ static bool swap_only_has_cache(struct swap_cluster_info *ci,
  * returns number of pages in the folio that backs the swap entry. If positive,
  * the folio was reclaimed. If negative, the folio was not reclaimed. If 0, no
  * folio was associated with the swap entry.
+ *
+ * @entry names its own device, which may differ from the device being scanned:
+ * a physical slot is backed by an xswap entry, and it is that entry's folio
+ * and cluster the reclaim works on.
  */
-static int __try_to_reclaim_swap(struct swap_info_struct *si,
-				 unsigned long offset, unsigned long flags)
+static int __try_to_reclaim_swap(swp_entry_t entry, unsigned long flags)
 {
-	const swp_entry_t entry = swp_entry(si->type, offset);
+	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct swap_cluster_info *ci;
 	struct folio *folio;
+	unsigned long offset;
 	int ret, nr_pages;
 	bool need_reclaim;
 
@@ -993,7 +997,8 @@ static bool cluster_reclaim_range(struct swap_info_struct *si,
 		if (swp_tb_get_count(swp_tb))
 			break;
 		if (swp_tb_is_folio(swp_tb))
-			if (__try_to_reclaim_swap(si, offset, TTRS_ANYWAY) < 0)
+			if (__try_to_reclaim_swap(swp_entry(si->type, offset),
+						  TTRS_ANYWAY) < 0)
 				break;
 	} while (++offset < end);
 	spin_lock(&ci->lock);
@@ -1213,13 +1218,31 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 			swp_tb = swap_table_get(ci, offset % SWAPFILE_CLUSTER);
 			if (swp_tb_is_folio(swp_tb) && !__swp_tb_get_count(swp_tb)) {
 				spin_unlock(&ci->lock);
-				nr_reclaim = __try_to_reclaim_swap(si, offset,
-								   TTRS_ANYWAY);
+				nr_reclaim = __try_to_reclaim_swap(
+						swp_entry(si->type, offset),
+						TTRS_ANYWAY);
 				spin_lock(&ci->lock);
 				if (nr_reclaim) {
 					offset += abs(nr_reclaim);
 					continue;
 				}
+#ifdef CONFIG_XSWAP
+			} else if (swp_tb_is_pointer(swp_tb)) {
+				/*
+				 * The slot is backed by an xswap entry, and
+				 * that entry's swap count decides whether the
+				 * slot can go.
+				 */
+				spin_unlock(&ci->lock);
+				nr_reclaim = __try_to_reclaim_swap(
+						xswap_rmap_to_entry(swp_tb),
+						TTRS_ANYWAY);
+				spin_lock(&ci->lock);
+				if (nr_reclaim) {
+					offset += abs(nr_reclaim);
+					continue;
+				}
+#endif
 			}
 			offset++;
 		}
@@ -1854,8 +1877,9 @@ static void swap_put_entries_cluster(struct swap_info_struct *si,
 		return;
 
 	do {
-		nr_reclaimed = __try_to_reclaim_swap(si, offset,
-						     TTRS_UNMAPPED | TTRS_FULL);
+		nr_reclaimed = __try_to_reclaim_swap(
+					swp_entry(si->type, offset),
+					TTRS_UNMAPPED | TTRS_FULL);
 		offset++;
 		if (nr_reclaimed)
 			offset = round_up(offset, abs(nr_reclaimed));
@@ -2459,7 +2483,7 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 	swap_cluster_unlock(ci);
 
 	/* In theory readahead might add it to the swap cache by accident */
-	__try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
+	__try_to_reclaim_swap(swp_entry(si->type, offset), TTRS_ANYWAY);
 }
 
 static int __find_hibernation_swap_type(dev_t device, sector_t offset)
-- 
2.54.0


