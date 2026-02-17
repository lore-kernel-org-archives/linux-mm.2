Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E91AE9A03E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:07:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EF846B00A1; Tue, 17 Feb 2026 15:06:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 025656B0095; Tue, 17 Feb 2026 15:06:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA2C36B0099; Tue, 17 Feb 2026 15:06:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 732A56B009D
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:06:55 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1C5571B4529
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:06:55 +0000 (UTC)
X-FDA: 84455031990.30.8762E24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 088AA1C0013
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:06:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CS1J3qO0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771358813; a=rsa-sha256;
	cv=none;
	b=x9DcCk+GkIV5LmRcfXINOw8Tao8SMJO1APGVxh/omrgMLkkc9pGzA4JIZPuqqFleljktKV
	oH5lqvFxh9X3c84PWUld0LpoVMbn03trR1AefsU8gWDqfiIB3OXBYYekl4LGmHCpZGXsY/
	BjU40lYwjgggw+V/CsqJaiG1x7aKa5U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CS1J3qO0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771358813;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aA0m661VkCskBwUBoH6JQLcI4yRP8UW6rjgkuLSb/W0=;
	b=4vd+f5HkJpCM0CXN9WSo0GLSCGn1HLCsccuZ28KbCz9KEO3OxEw/1d8NT3xYdlbpYVu+1M
	gSFp3ADLt6BGp5+3K/oScNRF4gRW3fxIZHMgZqu7DBzk80R88BTi+Hi8U5EuPeVGmMs2YE
	UDdJGgSdA1Z5KhkXLVn6KGomXRkMl54=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BC08E44570;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 91414C19421;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771358809;
	bh=bRCmnJbeggUZ91UjveLB02es9HZ0T/a5dTIwJjGY6v8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=CS1J3qO0oP+QoHWETy+CXdOFfQK8ASdqXpu0z2U8t8QUw9iHL0BLf9j+BA621agEM
	 oPP5GEvSoBn9ukXjr8Vm7LcSj+KcBEjhwru3KTzp0dqeKgpffiQu1fJpWWKkdz9FwE
	 gCqyHZwUV/GlHNt1gJn1eOlB+beP65oCMeFHcfAo0oZVIbgfVsYoOpHvP/6b0NtXpj
	 nZOXt7IVUyb2M0shJML/x9Un67380KvOHVgxHvvvEGQxq44R4b/pqTPD6YQgIwmaj4
	 /qxKMNodCprIWI1e1LhkWF9zIC6yTz3SHCAE3LNOujoq4w0vRfZ7lVksHCpqsTX67u
	 S1MFY3NLmtiNA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A0EDE9A03F;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 18 Feb 2026 04:06:36 +0800
Subject: [PATCH v3 11/12] mm, swap: simplify checking if a folio is swapped
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260218-swap-table-p3-v3-11-f4e34be021a7@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771358806; l=7000;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=RmCYZA5fOPzN8Ok6mc+EihDY+qlYT4Nzp3aMmwNhDA8=;
 b=up3YTmSAV9fsExsL7mQJThV10LYZGkNQazOsqxJmgM05t1yZjP5R3KKgz/Mnn0sC0K+68bFMk
 EgllSQjSXwTCyY/g/F6d4V1i41f5KvPore41jSZwnrGbSgEKZti4JUl
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: i1arysb78ixktgtjo8aypoi5ockgt8gs
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 088AA1C0013
X-HE-Tag: 1771358812-644604
X-HE-Meta: U2FsdGVkX199caJTP3nI5+FaTis4utiakCLzgLWS1SblbsRYkbjFY+BHL1uSe9cb7YO2el+A+AckWFUXiEsjW6XeU3e3MvTt7JU+klerTLd3e5Lzc8/NrqtrawsXeum2nxXSaTo+XZbYoZODwAKfb1QdsE8WNPlkhW3gPuyOgTKkbyLYZs8cgYDGcrrIKHEbiA6i1EWTqdUZ6u8gV/gSU+7FKmJUDc+9kjcrVv9iPWinIFb0axeX4pOU9flVTI5GzMxYzOK09+ats1w8R/W73/96wodTYLvylwSXpWCoZ64vBJAq6IDmnvkZqJhgPl256Ml3mV3qi8KADdnezw/WbvKkz/whtQiBI6LZWOxCO97PBRtwal635kSL6VxMcQ99b3NsbwO+ms+eTljtfrtZExSlgo5ueOjNoMYAA1MCCka29k93Bhb48IoBdaseNAv6sY3NvgMHPmAS7SxNW9s/or+UJH51m+8bllp0/1tgc5/J4qZLDhn4nROKRsZ9xRqUtnpIjErhC2dnCV9KqZr2diOYpC7jrkG7oD/Etr/PY5P2+tslbaorTJj+lGHXONPHQmvv7TQHkOsBYnO0BridWLNeHtSL78nZFLWYWiA81BPhEsEeuiJxCfs9WrPwhIqzGuY3EsMA5fn8d9Zbh3UvbJN7XT8he7QSPBsbli82bN18ZmkOW0cthwEVX5k/OlyM5ZDqY9MomHmn2sSGMH9xZ74/j3BcGKhElNqHy+zX1GyTE/VRfX7jLkYuxovPqpEnepDA9revi7jYyuTh2CQ7AbCMyY2p1WSxZNc0RB0gJe8Ro9rpCZg2w2qBU2aWNmhXG0PkopTctc0zFANfxJWamPG2ENA/nTRhOl88guK03omIPz/rA7QPVzx3vctsP9HGTAQ3SKTR+DqjNZvL3uvZDQzyNCeXQ6NWuPiOY1W6g41GWSSsUSNiS4flSMn7vbQrbrSRG5qhaHmXNJb/kCE
 sztJv9bZ
 2Mdaxtvz7dbNOkbWXhwKqpEN4fSAg7+BKxmULuOSCz6IIYoumUtTIJDaOjB81dCQmBKL8zbzpIqRpQVGAf2YYRD8QTkMGa7t7V53FkIEG+8KrHRjwLnKb+teT588f9j24r0x37qlAsVlFjgQql9YZd51LJ1+zlYveOgoYYXT4pwA9q2hd77SuIl8uMoOZR8vVbLJIz6WoFNM+LCOybp9SofYhXsiIfi4Wswpesl3wEUQmbeDwRaxnQuoCg8me5YCi9Twidje+9oPNb3r1fE3G7lVwklvYb6MEMmZKuxgAmjDa5MbOYJpYhF2V4SiROv4khuGX6saw+sBWwefAQqETdgFufaNk7P0PRRP5w+KidqPHg0isN/gmGAEd2g==
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
index cc410b94e91a..9728e6a944b2 100644
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
index df2b88c6c67b..dab5e726855b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1743,7 +1743,11 @@ int folio_alloc_swap(struct folio *folio)
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
@@ -1942,49 +1946,44 @@ int swp_swapcount(swp_entry_t entry)
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
@@ -2030,7 +2029,7 @@ bool folio_free_swap(struct folio *folio)
 {
 	if (!folio_swapcache_freeable(folio))
 		return false;
-	if (folio_swapped(folio))
+	if (folio_maybe_swapped(folio))
 		return false;
 
 	swap_cache_del_folio(folio);
@@ -3719,6 +3718,8 @@ void si_swapinfo(struct sysinfo *val)
  *
  * Context: Caller must ensure there is no race condition on the reference
  * owner. e.g., locking the PTL of a PTE containing the entry being increased.
+ * Also the swap entry must have a count >= 1. Otherwise folio_dup_swap should
+ * be used.
  */
 int swap_dup_entry_direct(swp_entry_t entry)
 {
@@ -3730,6 +3731,13 @@ int swap_dup_entry_direct(swp_entry_t entry)
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



