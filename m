Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3DCDE63CAC
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 17:58:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13DB16B00A5; Sun, 25 Jan 2026 12:58:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F11D6B00A7; Sun, 25 Jan 2026 12:58:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F28B16B00A8; Sun, 25 Jan 2026 12:58:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC8DB6B00A5
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 12:58:56 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A164FD277A
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:58:56 +0000 (UTC)
X-FDA: 84371247072.03.91F8F7C
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id A542040005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:58:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SU9uMOMB;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769363934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OKXYNAqC58IBkWvtFGcy+ttT57KuezlLy+MzWN+rz2c=;
	b=CieRhB/eXYLozZnzOsqQKggmYkwb1oncOP+874yDaTs9GArYh1mK/DVFWM+Gbpnz8aumFH
	AsQUkiOlOfrI6wDTLlltysIOsVphG7f1frPgeoMsO2Cf/xTeLTeSw0N4yEzSRJ0Ic7SLVo
	gaJogCJvfIJW5OfmjQ9hjxpLd2lmYBE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SU9uMOMB;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769363934; a=rsa-sha256;
	cv=none;
	b=bUUsbylujPTRpEfq/jaJzfC/uMUzMnFeXz08EXbEAowlNLMDP3ZTco8rKn9UhpD/zktpYU
	xW4Gj5q2hYPi9LB2WS45PLku5W9+f1X4cCGrmsNow4VFvFG51qZUeIUZZm37VPDvWfP+2I
	q3jpy8iY8YqzXRAj9CLyTryO+G2GTZY=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8230c2d3128so1468666b3a.0
        for <linux-mm@kvack.org>; Sun, 25 Jan 2026 09:58:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769363933; x=1769968733; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OKXYNAqC58IBkWvtFGcy+ttT57KuezlLy+MzWN+rz2c=;
        b=SU9uMOMBAkPAmY92dVi5v8/HTI0VL1WzfJj0gQ6X30b6swFdWLfVOCSkBDkarPo1uL
         XwucklvR/ZU70wVR9zJMU6JO+0JbINvGcBt9FjxX1Es5K41csA8PZ78+j1xbY/VT74TN
         +oxDEjTjUk45F8T7E0L1AiBSEdIuBzkY9M0c28nZvaQnoMO92lq228UDEhmGggt6650e
         dulF9cajVOF5CgzyIRTdHqlwDsVR2X9GoM3nexxk5KGijI+v6CAmQ++M1DiWVM4kx4m2
         IGJx041wTKEbpwWz8yKnlRJniQzgp+8dGubUm8cwM0083rMVdeHx2uMe4krQBpnTdhVg
         1SsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769363933; x=1769968733;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OKXYNAqC58IBkWvtFGcy+ttT57KuezlLy+MzWN+rz2c=;
        b=VVGEtCAfpxWro2dvJIm+tRYI1PV7o67tUxHDSuLlvv2g1lSH15+iE2aMm8L49Sm3Nc
         e+LU7qbnIYIeyysOM3x5VFxpYH87vpw1Gk3cHZEpMZu5Sy0OmSKAY1o4hTRTBvWlVxmf
         oXbUM8XHkoWhFTA3Bk+nQ5JikDnaosQbPhxJmCqtSMm3GbUSExm0MmP/sRRKfRIumyCF
         VUWNOHEs/fmN1epDB+OEAO+LvhR9qrisz6kMb3h9mVdzQWGgRvzS0QN7GarpJ+QE43GS
         IH8NpeN/oQ+MaFSOLl3LWY4g/FB7qizVp5qF3263+r6SCNvhX2dME19CN2uiFEay9YTN
         nsHA==
X-Gm-Message-State: AOJu0YwIzz3McrzTuAzqKr9IL/X8W6nZVtx9wZA+vxj2s7t4Nctrh0HZ
	2mSMiQSZ/JShyugx/uBP1Pj4PAjjBtQWL/O8ZYt5yrHvFUG4QpFDoVUZ6oE2pBXWep4=
X-Gm-Gg: AZuq6aJnWE5gOtA5D9T5i2DNetLzMKuCSEUY1a8cvpXvaY+YAetXnJPh93mIF+POuzU
	W7QL/xWNKfGqqsCEayJkAVnpDIxnlixysXtFtXVclb02dadd4mabyH0lItQNHjDd2UPDjHQmrVl
	FHT66sLZs0tU5X7sF80GtABQ0fNQLfehkXx38TshrDl/rGUWFPt6afcldaJmtwbQghHl/l4hB7r
	p5mkJ27XyPniaZyQmJ6wSNzZ/bOLzhK6kzRnF5JEN7AWrYhpdpn1QxheZKj/y8aCfzM+vICaKwd
	P4Y2E5Ja6JPbCLY0aYrFh6NMLxdOTpdP2+3uWfXCRN1RZc8kU8no+MApDD//h9H38Zjb6eUGSto
	9AuC9Mki9OqM3ThGFEXV+F9UXuSXOgwfVpX4Ycne2k8lknz1uz3dHsIRKur8QvF1fG0lmvoTzSq
	HpX/8z3KDDKYYAqKFFw2hg+QBPfzyKuJoGjDHeYq6rt9+JEO4qLO81IAqPxMM=
X-Received: by 2002:a05:6a00:6c94:b0:81f:3d13:e081 with SMTP id d2e1a72fcca58-82341286034mr1728052b3a.41.1769363933483;
        Sun, 25 Jan 2026 09:58:53 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8231876e718sm7405963b3a.62.2026.01.25.09.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jan 2026 09:58:52 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 26 Jan 2026 01:57:34 +0800
Subject: [PATCH 11/12] mm, swap: simplify checking if a folio is swapped
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260126-swap-table-p3-v1-11-a74155fab9b0@tencent.com>
References: <20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com>
In-Reply-To: <20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769363877; l=7000;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=8TW7AOA0FyTSy07GVfKQSiXTCJR3nOx0B++VcBYD3xg=;
 b=pEzWHdtTTghSM7y2k/qDzilzweYWaIo/0d1n0BBKRJPn3omkQQM1w3UVRSo9dKwvUCoh3+lxv
 JgCcK0I0lDFDSs1Ho7U8htmHbBq0XbtuhWOrefmRcRNVD88lAd40L2R
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Stat-Signature: uidfgcws55h35iigx7geg76pbhqc9i5q
X-Rspamd-Queue-Id: A542040005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769363934-742426
X-HE-Meta: U2FsdGVkX1/POcSjrhzgbIvlhDVtKPJpHekpqASYQiqnjUIE5rSGg3LduIJnuYyMuoMPFcSiwtztvnO8tzuY7uSFkC3rsvfgJLYsy1TIl2TCZ7+eVUxpnyxx0RyH+r3sBHAsX2zJjyYJxUEpdc2A320ADoOpwLdlwmBTMVs9D7DAiU6sCLDMQ7NSMbRAw9gbddRuSmMxBkQJV45hSydI+mAZIuXb7DfuZla4FLhz/8J4RDC48Efyy2QOFQUdypiwNUfGSnWHzghbTdawfo23AvlJEJy5LKUaUv/LngMdY0wMOKgW4ih+tNth08fu1rY/T9yRbOh+oMLdpFkH6lTEVEjGVfAJgtN6dLrYM/txjRM27ddnOjxneczdMZ3N6mtBqzivHNYWMliCzcoHLQMdusf6ez6YgOEFU7b/AsApW2IYX+iY9DHPs5SICGMgXF0P2Iauk7vFkACRPEzhsVOEs4a37IpYXqlyPfDbPRVdUS4+mOsK6ndMRa2WgxWMGY1T/Tx7lmH3zlAHYo5uu4fMSKdnRrsNuovks0WIB6ASCebS04kkBh7MKUGNtz5pUK3pBq68/eu4j2VXYXxAtKoxnExh7nSZNNwUhRkRYEGMRivvaWXmS4nrRw4WY7eHIbuafTSJz101uSk4gbZ/wQuiGHq3MuiZevGYg3Ajy1RsR8krO6/bqDqc3R/F5wZJsxW5VWJJXAvmQ1YtT1Y6Xh5Y1r9xJZAPOjSfERebm1cXIdK2w2X3mYB4GrcjYvNYPFaUcgwd2zXdxjRXCe7ZN8FtFbncNG/uqWFMTvDyF3keD2bxOPxJuEy0m6bpCibQglyvA6hSGyQ4+NXp+x7N81kJGLDWpLLqiEUMEZ4haAWFvR+zoggxRmuHj7+d3jzgufCrbdmqpxVsWiT4hxAZswcABRpj3UZoK7KwQAjlVynocuLCLvvSe+NXgRRWnyFWWCBvyIF6wOkq2JBQlf4iLRg
 FgPHV9k8
 M0W2NhwkxqZbcdDR0e74hopM+erVduMSpdTr8490Njd2lhuCdymIC8FfIgo+OZKCvsavqz5zVMUNBJbAtTUHoz3+Abu6Ix0/iuNnMh9BeZoLx3ixkq8ETBcQxxl1MzcgEENTIgRSw3aO9SmFU+UcOELPp+Ukjz/ZVxGWNvSKbwtTV15ge4nTdRq5JOstLpO8prJI7aUW1XEUHwuSxxw5vIMoQzJzUeFPN2uuJKgKkY0KfGGlVyJVKlEtUGk/tn+n1pZUhoM2zBy6o1ktv9IOOTh4noCnVKtiBY8xYMh7LZQkxodIN+Zu2Hz/Oa9StzWVgmC78mmVLUT0DYXZezLejERAcSopc57BDryqw3Wi8Lg66PZtWItOLg2UKrO9bpgl7x22poQEHSS6jRv09PjdjGMo4WIrHtScZfwmD2wO46HtZ8TeiTIhvidVzwQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Clean up and simplify how we check if a folio is swapped. The helper
already requires the folio to be in swap cache and locked. That's enough
to pin the swap cluster from being freed, so there is no need to lock
anything else to avoid UAF.

And besides, we have cleaned up and defined the swap operation to be
mostly folio based, and now the only place a folio will have any of its
swap slots' count increased from 0 to 1 is folio_dup_swap, which also
requires the folio lock. So as we are holding the folio lock here, a
folio can't change its swap status from not swapped (all swap slots have
a count of 0) to swapped (any slot has a swap count larger than 0).

So there won't be any false negatives of this helper if we simply depend
on the folio lock to stabilize the cluster.

We are only using this helper to determine if we can and should release
the swap cache. So false positives are completely harmless, and also
already exist before. Depending on the timing, previously, it's also
possible that a racing thread releases the swap count right after
releasing the ci lock and before this helper returns. In any case, the
worst that could happen is we leave a clean swap cache. It will still be
reclaimed when under pressure just fine.

So, in conclusion, we can simplify and make the check much simpler and
lockless. Also, rename it to folio_maybe_swapped to reflect the design.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.h     |  5 ++--
 mm/swapfile.c | 82 ++++++++++++++++++++++++++++++++---------------------------
 2 files changed, 48 insertions(+), 39 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 751430e2d2a5..3395c2aa1956 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -195,12 +195,13 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
  *
  * folio_alloc_swap(): the entry point for a folio to be swapped
  * out. It allocates swap slots and pins the slots with swap cache.
- * The slots start with a swap count of zero.
+ * The slots start with a swap count of zero. The slots are pinned
+ * by swap cache reference which doesn't contribute to swap count.
  *
  * folio_dup_swap(): increases the swap count of a folio, usually
  * during it gets unmapped and a swap entry is installed to replace
  * it (e.g., swap entry in page table). A swap slot with swap
- * count == 0 should only be increasd by this helper.
+ * count == 0 can only be increased by this helper.
  *
  * folio_put_swap(): does the opposite thing of folio_dup_swap().
  */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 1cf18761c0fd..f2b5013c7692 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1740,7 +1740,11 @@ int folio_alloc_swap(struct folio *folio)
  * @subpage: if not NULL, only increase the swap count of this subpage.
  *
  * Typically called when the folio is unmapped and have its swap entry to
- * take its palce.
+ * take its place: Swap entries allocated to a folio has count == 0 and pinned
+ * by swap cache. The swap cache pin doesn't increase the swap count. This
+ * helper sets the initial count == 1 and increases the count as the folio is
+ * unmapped and swap entries referencing the slots are generated to replace
+ * the folio.
  *
  * Context: Caller must ensure the folio is locked and in the swap cache.
  * NOTE: The caller also has to ensure there is no raced call to
@@ -1941,49 +1945,44 @@ int swp_swapcount(swp_entry_t entry)
 	return count < 0 ? 0 : count;
 }
 
-static bool swap_page_trans_huge_swapped(struct swap_info_struct *si,
-					 swp_entry_t entry, int order)
+/*
+ * folio_maybe_swapped - Test if a folio covers any swap slot with count > 0.
+ *
+ * Check if a folio is swapped. Holding the folio lock ensures the folio won't
+ * go from not-swapped to swapped because the initial swap count increment can
+ * only be done by folio_dup_swap, which also locks the folio. But a concurrent
+ * decrease of swap count is possible through swap_put_entries_direct, so this
+ * may return a false positive.
+ *
+ * Context: Caller must ensure the folio is locked and in the swap cache.
+ */
+static bool folio_maybe_swapped(struct folio *folio)
 {
+	swp_entry_t entry = folio->swap;
 	struct swap_cluster_info *ci;
-	unsigned int nr_pages = 1 << order;
-	unsigned long roffset = swp_offset(entry);
-	unsigned long offset = round_down(roffset, nr_pages);
-	unsigned int ci_off;
-	int i;
+	unsigned int ci_off, ci_end;
 	bool ret = false;
 
-	ci = swap_cluster_lock(si, offset);
-	if (nr_pages == 1) {
-		ci_off = roffset % SWAPFILE_CLUSTER;
-		if (swp_tb_get_count(__swap_table_get(ci, ci_off)))
-			ret = true;
-		goto unlock_out;
-	}
-	for (i = 0; i < nr_pages; i++) {
-		ci_off = (offset + i) % SWAPFILE_CLUSTER;
-		if (swp_tb_get_count(__swap_table_get(ci, ci_off))) {
-			ret = true;
-			break;
-		}
-	}
-unlock_out:
-	swap_cluster_unlock(ci);
-	return ret;
-}
-
-static bool folio_swapped(struct folio *folio)
-{
-	swp_entry_t entry = folio->swap;
-	struct swap_info_struct *si;
-
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
 
-	si = __swap_entry_to_info(entry);
-	if (!IS_ENABLED(CONFIG_THP_SWAP) || likely(!folio_test_large(folio)))
-		return swap_entry_swapped(si, entry);
+	ci = __swap_entry_to_cluster(entry);
+	ci_off = swp_cluster_offset(entry);
+	ci_end = ci_off + folio_nr_pages(folio);
+	/*
+	 * Extra locking not needed, folio lock ensures its swap entries
+	 * won't be released, the backing data won't be gone either.
+	 */
+	rcu_read_lock();
+	do {
+		if (__swp_tb_get_count(__swap_table_get(ci, ci_off))) {
+			ret = true;
+			break;
+		}
+	} while (++ci_off < ci_end);
+	rcu_read_unlock();
 
-	return swap_page_trans_huge_swapped(si, entry, folio_order(folio));
+	return ret;
 }
 
 static bool folio_swapcache_freeable(struct folio *folio)
@@ -2029,7 +2028,7 @@ bool folio_free_swap(struct folio *folio)
 {
 	if (!folio_swapcache_freeable(folio))
 		return false;
-	if (folio_swapped(folio))
+	if (folio_maybe_swapped(folio))
 		return false;
 
 	swap_cache_del_folio(folio);
@@ -3713,6 +3712,8 @@ void si_swapinfo(struct sysinfo *val)
  *
  * Context: Caller must ensure there is no race condition on the reference
  * owner. e.g., locking the PTL of a PTE containing the entry being increased.
+ * Also the swap entry must have a count >= 1. Otherwise folio_dup_swap should
+ * be used.
  */
 int swap_dup_entry_direct(swp_entry_t entry)
 {
@@ -3724,6 +3725,13 @@ int swap_dup_entry_direct(swp_entry_t entry)
 		return -EINVAL;
 	}
 
+	/*
+	 * The caller must be increasing the swap count from a direct
+	 * reference of the swap slot (e.g. a swap entry in page table).
+	 * So the swap count must be >= 1.
+	 */
+	VM_WARN_ON_ONCE(!swap_entry_swapped(si, entry));
+
 	return swap_dup_entries_cluster(si, swp_offset(entry), 1);
 }
 

-- 
2.52.0


